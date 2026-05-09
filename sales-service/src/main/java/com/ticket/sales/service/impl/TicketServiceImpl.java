package com.ticket.sales.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.Enum.seatStatusEnum;
import com.ticket.Enum.ticketStatusEnum;
import com.ticket.api.feign.TrainFeignClient;
import com.ticket.api.feign.UserFeignClient;
import com.ticket.constant.MqConstants;
import com.ticket.model.entity.*;
import com.ticket.model.request.BookingRequest;
import com.ticket.model.request.GroupBookingRequest;
import com.ticket.model.request.GroupRefundRequest;
import com.ticket.model.request.RefundRequest;
import com.ticket.model.request.TicketChangeRequest;
import com.ticket.model.response.Result;
import com.ticket.exception.BusinessException;
import com.ticket.sales.mapper.*;
import com.ticket.sales.service.HotTrainRankingService;
import com.ticket.sales.service.SeatCacheService;
import com.ticket.sales.service.TicketService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import io.seata.spring.annotation.GlobalTransactional;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 票务核心服务实现，处理售票、退票、改签、查询等业务逻辑。
 * 包含座位锁定、订单创建、支付超时调度等关键流程。
 * @author 铁路票务系统
 */
@Slf4j
@Service
public class TicketServiceImpl extends ServiceImpl<TicketMapper, Ticket> implements TicketService {

    @Resource
    private SeatMapper seatMapper;

    @Resource
    private TicketMapper ticketMapper;

    @Resource
    private PassengerMapper passengerMapper;

    @Resource
    private OrderMapper orderMapper;

    @Resource
    private SeatCacheService seatCacheService;

    @Resource
    private HotTrainRankingService hotTrainRankingService;

    @Resource
    private RabbitTemplate rabbitTemplate;

    @Resource
    private TrainFeignClient trainFeignClient;

    @Resource
    private UserFeignClient userFeignClient;

    @Resource
    private TicketChangeMapper ticketChangeMapper;

    @Resource(name = "stringRedisTemplate")
    private StringRedisTemplate redisTemplate;

    private static final BigDecimal REFUND_FEE_RATIO = new BigDecimal("0.1");
    private static final BigDecimal MIN_REFUND_FEE = new BigDecimal("10.00");

    /**
     * 尝试获取 Redis 分布式锁。
     *
     * @param lockKey       锁 key
     * @param lockValue     锁唯一标识值（防止误删他人锁）
     * @param expireSeconds 过期时间（秒），防止死锁
     * @return true 获取成功，false 已被占用
     */
    private boolean tryLock(String lockKey, String lockValue, long expireSeconds) {
        Boolean result = redisTemplate.opsForValue().setIfAbsent(lockKey, lockValue, expireSeconds, TimeUnit.SECONDS);
        return Boolean.TRUE.equals(result);
    }

    /**
     * 释放 Redis 分布式锁（仅当持有者与当前值匹配时才删除）。
     */
    private void unlock(String lockKey, String lockValue) {
        String currentValue = redisTemplate.opsForValue().get(lockKey);
        if (lockValue.equals(currentValue)) {
            redisTemplate.delete(lockKey);
        }
    }

    /**
     * 解析日期字符串为 Date 对象。
     */
    private Date parseDate(String dateStr) {
        try {
            return new java.text.SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
        } catch (Exception e) {
            throw new RuntimeException("日期格式错误");
        }
    }

    /**
     * 个人售票。
     */
    @GlobalTransactional(rollbackFor = Exception.class, name = "sell-ticket-tx")
    @SentinelResource(value = "sellTicket", blockHandler = "sellTicketBlockHandler")
    @Transactional(rollbackFor = Exception.class)
    @Override
    public Result<Ticket> sellTicket(BookingRequest req) {
        try {
            // 1. 校验车次状态 (Feign)
            Result<Train> trainRes = trainFeignClient.getTrainById(req.getTrainId());
            if (trainRes.getCode() != 200 || trainRes.getData() == null) throw new BusinessException("车次不存在");
            Train train = trainRes.getData();
            if (Integer.valueOf(0).equals(train.getStatus())) throw new BusinessException("该车次已停运");

            // 1.1 校验发车时间（不能购买已发车车次）
            Date travelDate = parseDate(req.getTravelDate());
            if (train.getDepartureTime() != null) {
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(travelDate);
                java.util.Calendar timeCal = java.util.Calendar.getInstance();
                timeCal.setTime(train.getDepartureTime());
                cal.set(java.util.Calendar.HOUR_OF_DAY, timeCal.get(java.util.Calendar.HOUR_OF_DAY));
                cal.set(java.util.Calendar.MINUTE, timeCal.get(java.util.Calendar.MINUTE));
                cal.set(java.util.Calendar.SECOND, timeCal.get(java.util.Calendar.SECOND));
                if (new Date().after(cal.getTime())) {
                    throw new BusinessException("该车次已发车，无法购买");
                }
            }

            // 2. 校验权限
            Integer sellerId = req.getSellerId();
            if (sellerId == null) throw new BusinessException("卖家信息缺失");

            java.sql.Date sqlDate = new java.sql.Date(travelDate.getTime());

            autoGenerateSeats(req.getTrainId(), travelDate);

            Seat seat = findTargetSeat(req, sqlDate);
            if (seat == null) throw new BusinessException("座位不存在");

            String lockKey = String.format("lock:seat:%d:%d:%s", req.getTrainId(), seat.getSeatId(), req.getTravelDate());
            String lockValue = UUID.randomUUID().toString();
            boolean locked = false;
            try {
                locked = tryLock(lockKey, lockValue, 30);
                if (!locked) {
                    throw new BusinessException("座位正在处理中，请稍后重试");
                }

                int rows = seatMapper.update(null, new LambdaUpdateWrapper<Seat>()
                        .eq(Seat::getSeatId, seat.getSeatId())
                        .eq(Seat::getStatus, seatStatusEnum.AVAILABLE)
                        .set(Seat::getStatus, seatStatusEnum.OCCUPIED)
                        .set(Seat::getUpdatedAt, new Date()));
                if (rows == 0) {
                    throw new BusinessException("座位已被占用");
                }
                seat = seatMapper.selectById(seat.getSeatId());
            } finally {
                if (locked) {
                    unlock(lockKey, lockValue);
                }
            }

            // 清理座位缓存，确保热点车次数据及时更新
            seatCacheService.clearSeatCache(req.getTrainId(), req.getTravelDate());

            Passenger p = new Passenger();
            p.setUserId(sellerId); p.setName(req.getName()); p.setGender(req.getGender());
            p.setIdType(req.getIdType()); p.setIdNumber(req.getIdNumber()); p.setPhone(req.getPhone());
            p.setCreatedAt(new Date());
            passengerMapper.insert(p);

            boolean isPre = isPreBooking(travelDate);
            BigDecimal price = (train.getBasePrice() != null ? train.getBasePrice() : new BigDecimal("100"))
                    .multiply(seat.getPriceCoefficient()); 

            Order order = new Order();
            order.setOrderNumber("ORD" + System.currentTimeMillis());
            order.setUserId(sellerId); order.setTotalAmount(price); order.setPaymentAmount(price);
            order.setOrderType("INDIVIDUAL"); order.setIsPreBooking(isPre ? 1 : 0);
            order.setOrderStatus("UNPAID"); order.setCreatedAt(new Date()); order.setUpdatedAt(new Date());
            orderMapper.insert(order);

            Ticket t = new Ticket();
            t.setOrderId(order.getOrderId()); t.setTicketNumber("TKT" + System.currentTimeMillis());
            t.setTrainId(req.getTrainId()); t.setSeatId(seat.getSeatId()); t.setPassengerId(p.getPassengerId());
            t.setTravelDate(travelDate); t.setPrice(price); t.setSaleTime(new Date());
            t.setHadPay(0); t.setStatus(isPre ? ticketStatusEnum.BOOKED : ticketStatusEnum.UNPAID);
            t.setStartStation(train.getStartStation()); t.setEndStation(train.getEndStation());
            t.setDepartureTime(train.getDepartureTime()); t.setArrivalTime(train.getArrivalTime());
            t.setCreatedAt(new Date()); t.setUpdatedAt(new Date());
            ticketMapper.insert(t);

            // 更新车次热度并通知排行榜更新
            hotTrainRankingService.incrementTrainHotness(req.getTrainId(), req.getTravelDate());
            hotTrainRankingService.notifyRankingUpdate(req.getTravelDate());

            schedulePaymentTimeout(order.getOrderId());
            return Result.success(t);
        } catch (BusinessException e) {
            log.error("售票业务异常", e);
            throw e;
        } catch (Exception e) {
            log.error("售票异常", e);
            throw new RuntimeException(e.getMessage());
        }
    }

    /**
     * 团体售票。
     */
    @GlobalTransactional(rollbackFor = Exception.class, name = "group-sell-ticket-tx")
    @SentinelResource(value = "groupSellTicket", blockHandler = "groupSellTicketBlockHandler")
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<List<Ticket>> groupSellTicket(GroupBookingRequest req) {
        try {
            // 1. 基本校验
            if (req.getName() == null || req.getName().isEmpty()) throw new BusinessException("乘客列表不能为空");
            int count = req.getName().size();
            if (count > 50) throw new BusinessException("团体购票每次最多50人");
            if (req.getIdNumber() == null || req.getIdNumber().size() != count
                    || req.getIdType() == null || req.getIdType().size() != count
                    || req.getPhone() == null || req.getPhone().size() != count) {
                throw new BusinessException("乘客信息列表长度不一致");
            }
            if (req.getSellerId() == null) throw new BusinessException("售票员信息缺失");

            // 2. 校验车次
            Result<Train> trainRes = trainFeignClient.getTrainById(req.getTrainId());
            if (trainRes.getCode() != 200 || trainRes.getData() == null) throw new BusinessException("车次不存在");
            Train train = trainRes.getData();
            if (Integer.valueOf(0).equals(train.getStatus())) throw new BusinessException("该车次已停运");

            Date travelDate = req.getTravelDate();
            if (travelDate == null) throw new BusinessException("乘车日期不能为空");

            // 2.1 校验发车时间（不能购买已发车车次）
            if (train.getDepartureTime() != null) {
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(travelDate);
                java.util.Calendar timeCal = java.util.Calendar.getInstance();
                timeCal.setTime(train.getDepartureTime());
                cal.set(java.util.Calendar.HOUR_OF_DAY, timeCal.get(java.util.Calendar.HOUR_OF_DAY));
                cal.set(java.util.Calendar.MINUTE, timeCal.get(java.util.Calendar.MINUTE));
                cal.set(java.util.Calendar.SECOND, timeCal.get(java.util.Calendar.SECOND));
                if (new Date().after(cal.getTime())) {
                    throw new BusinessException("该车次已发车，无法购买");
                }
            }

            java.sql.Date sqlDate = new java.sql.Date(travelDate.getTime());

            // 3. 自动生成座位
            autoGenerateSeats(req.getTrainId(), travelDate);

            // 4. 分配座位
            List<Seat> seats = new ArrayList<>();
            if (req.getSeatIds() != null && req.getSeatIds().size() == count) {
                for (Integer seatId : req.getSeatIds()) {
                    Seat s = seatMapper.selectById(seatId);
                    if (s == null) throw new BusinessException("座位ID " + seatId + " 不存在");
                    seats.add(s);
                }
            } else if (req.getSeatNumbers() != null && req.getSeatNumbers().size() == count) {
                for (String seatNum : req.getSeatNumbers()) {
                    List<Seat> matchedSeats = seatMapper.selectList(new LambdaQueryWrapper<Seat>()
                            .eq(Seat::getTrainId, req.getTrainId())
                            .eq(Seat::getSeatNumber, seatNum)
                            .eq(Seat::getTravelDate, sqlDate)
                            .orderByAsc(Seat::getCarriageNumber, Seat::getSeatId));
                    Seat s = matchedSeats.stream()
                            .filter(item -> seatStatusEnum.AVAILABLE.equals(item.getStatus()))
                            .findFirst()
                            .orElse(matchedSeats.isEmpty() ? null : matchedSeats.get(0));
                    if (s == null) throw new BusinessException("座位 " + seatNum + " 不存在");
                    seats.add(s);
                }
            } else {
                // 自动分配可用座位
                List<Seat> available = seatMapper.selectList(new LambdaQueryWrapper<Seat>()
                        .eq(Seat::getTrainId, req.getTrainId())
                        .eq(Seat::getTravelDate, sqlDate)
                        .eq(Seat::getStatus, seatStatusEnum.AVAILABLE)
                        .last("LIMIT " + count));
                if (available.size() < count) throw new BusinessException("剩余座位不足，需要 " + count + " 个，仅剩 " + available.size() + " 个");
                seats = available;
            }

            // 5. 使用 Redis 分布式锁（车次维度）串行化座位占用，避免多实例并发冲突
            String groupLockKey = String.format("lock:train:%d:%s", req.getTrainId(), new java.text.SimpleDateFormat("yyyy-MM-dd").format(travelDate));
            String groupLockValue = UUID.randomUUID().toString();
            boolean groupLocked = false;
            try {
                groupLocked = tryLock(groupLockKey, groupLockValue, 60);
                if (!groupLocked) {
                    throw new BusinessException("该车次正在处理中，请稍后重试");
                }

                for (Seat seat : seats) {
                    int rows = seatMapper.update(null, new LambdaUpdateWrapper<Seat>()
                            .eq(Seat::getSeatId, seat.getSeatId())
                            .eq(Seat::getStatus, seatStatusEnum.AVAILABLE)
                            .set(Seat::getStatus, seatStatusEnum.OCCUPIED)
                            .set(Seat::getUpdatedAt, new Date()));
                    if (rows == 0) throw new BusinessException("座位 " + seat.getSeatNumber() + " 已被占用");
                }
            } finally {
                if (groupLocked) {
                    unlock(groupLockKey, groupLockValue);
                }
            }

            // 6. 计算总价并创建团体订单
            boolean isPre = isPreBooking(travelDate);
            BigDecimal totalAmount = BigDecimal.ZERO;
            List<BigDecimal> prices = new ArrayList<>();
            for (Seat seat : seats) {
                BigDecimal price = (train.getBasePrice() != null ? train.getBasePrice() : new BigDecimal("100"))
                        .multiply(seat.getPriceCoefficient());
                prices.add(price);
                totalAmount = totalAmount.add(price);
            }

            Order order = new Order();
            order.setOrderNumber("GRP" + System.currentTimeMillis());
            order.setUserId(req.getSellerId());
            order.setTotalAmount(totalAmount);
            order.setPaymentAmount(totalAmount);
            order.setOrderType("GROUP");
            order.setIsPreBooking(isPre ? 1 : 0);
            order.setOrderStatus("UNPAID");
            order.setCreatedAt(new Date());
            order.setUpdatedAt(new Date());
            orderMapper.insert(order);

            // 7. 为每位乘客创建乘客记录和车票
            List<Ticket> tickets = new ArrayList<>();
            for (int i = 0; i < count; i++) {
                Passenger p = new Passenger();
                p.setUserId(req.getSellerId());
                p.setName(req.getName().get(i));
                p.setIdType(req.getIdType().get(i));
                p.setIdNumber(req.getIdNumber().get(i));
                p.setPhone(req.getPhone().get(i));
                p.setGender(req.getGender() != null && i < req.getGender().size() ? req.getGender().get(i) : "未知");
                p.setCreatedAt(new Date());
                passengerMapper.insert(p);

                Seat seat = seats.get(i);
                Ticket t = new Ticket();
                t.setOrderId(order.getOrderId());
                t.setTicketNumber("TKT" + System.currentTimeMillis() + "-" + (i + 1));
                t.setTrainId(req.getTrainId());
                t.setSeatId(seat.getSeatId());
                t.setPassengerId(p.getPassengerId());
                t.setTravelDate(travelDate);
                t.setPrice(prices.get(i));
                t.setSaleTime(new Date());
                t.setHadPay(0);
                t.setStatus(isPre ? ticketStatusEnum.BOOKED : ticketStatusEnum.UNPAID);
                t.setStartStation(train.getStartStation());
                t.setEndStation(train.getEndStation());
                t.setDepartureTime(train.getDepartureTime());
                t.setArrivalTime(train.getArrivalTime());
                t.setCreatedAt(new Date());
                t.setUpdatedAt(new Date());
                ticketMapper.insert(t);
                tickets.add(t);
            }

            // 8. 清理座位缓存
            String travelDateStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(travelDate);
            seatCacheService.clearSeatCache(req.getTrainId(), travelDateStr);

            // 9. 调度支付超时
            schedulePaymentTimeout(order.getOrderId());
            log.info("团体售票成功: 订单={}, 人数={}, 总价={}", order.getOrderNumber(), count, totalAmount);
            return Result.success(tickets, "团体售票成功，共 " + count + " 张票，总价: " + totalAmount);
        } catch (BusinessException e) {
            log.error("团体售票业务异常", e);
            throw e;
        } catch (Exception e) {
            log.error("团体售票异常", e);
            throw new RuntimeException("团体售票失败: " + e.getMessage());
        }
    }

    /**
     * 查找目标座位。
     */
    private Seat findTargetSeat(BookingRequest req, java.sql.Date sqlDate) {
        if (req.getSeatId() != null) {
            return seatMapper.selectById(req.getSeatId());
        } else if (req.getSeatNumber() != null && !req.getSeatNumber().isBlank()) {
            List<Seat> matchedSeats = seatMapper.selectList(new LambdaQueryWrapper<Seat>()
                    .eq(Seat::getTrainId, req.getTrainId())
                    .eq(Seat::getSeatNumber, req.getSeatNumber())
                    .eq(Seat::getTravelDate, sqlDate)
                    .orderByAsc(Seat::getCarriageNumber, Seat::getSeatId));
            return matchedSeats.stream()
                    .filter(item -> seatStatusEnum.AVAILABLE.equals(item.getStatus()))
                    .findFirst()
                    .orElse(matchedSeats.isEmpty() ? null : matchedSeats.get(0));
        }
        return null;
    }

    /**
     * 个人退票。
     */
    @GlobalTransactional(rollbackFor = Exception.class, name = "refund-ticket-tx")
    @SentinelResource(value = "refundTicket", blockHandler = "refundTicketBlockHandler")
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<BigDecimal> refundTicket(RefundRequest req) {
        try {
            Ticket t = ticketMapper.selectById(req.getTicketId());
            if (t == null) return Result.error("票不存在");
            // 状态校验：已退票/已改签/已过期的票不能再退
            if (ticketStatusEnum.REFUNDED.equals(t.getStatus())
                    || ticketStatusEnum.CHANGED.equals(t.getStatus())
                    || ticketStatusEnum.EXPIRED.equals(t.getStatus())) {
                return Result.error("车票当前状态不允许退票: " + t.getStatus());
            }

            // 计算退款金额和手续费
            BigDecimal refundAmount;
            if (Boolean.TRUE.equals(req.getIsFreeRefund())) {
                // 免费退票（如车次取消），全额退款
                refundAmount = t.getPrice();
            } else {
                BigDecimal fee = t.getPrice().multiply(REFUND_FEE_RATIO).setScale(2, RoundingMode.HALF_UP);
                if (fee.compareTo(MIN_REFUND_FEE) < 0) fee = MIN_REFUND_FEE;
                refundAmount = t.getPrice().subtract(fee);
                if (refundAmount.compareTo(BigDecimal.ZERO) < 0) refundAmount = BigDecimal.ZERO;
                t.setRefundFee(fee);
            }

            t.setStatus(ticketStatusEnum.REFUNDED);
            t.setUpdatedAt(new Date());
            ticketMapper.updateById(t);

            // 更新订单状态为 REFUNDED
            if (t.getOrderId() != null) {
                orderMapper.update(null, new LambdaUpdateWrapper<Order>()
                        .eq(Order::getOrderId, t.getOrderId())
                        .set(Order::getOrderStatus, "REFUNDED")
                        .set(Order::getUpdatedAt, new Date()));
            }

            releaseSeat(t.getSeatId());
            seatCacheService.clearSeatCache(t.getTrainId(), new java.text.SimpleDateFormat("yyyy-MM-dd").format(t.getTravelDate()));

            // 减少车次热度并通知排行榜更新
            hotTrainRankingService.decrementTrainHotness(t.getTrainId(), new java.text.SimpleDateFormat("yyyy-MM-dd").format(t.getTravelDate()));
            hotTrainRankingService.notifyRankingUpdate(new java.text.SimpleDateFormat("yyyy-MM-dd").format(t.getTravelDate()));

            log.info("退票成功: 票ID={}, 退款金额={}", t.getTicketId(), refundAmount);
            return Result.success(refundAmount);
        } catch (Exception e) {
            log.error("退票异常", e);
            throw new RuntimeException("退票失败: " + e.getMessage());
        }
    }

    /**
     * 团体退票。
     */
    @GlobalTransactional(rollbackFor = Exception.class, name = "group-refund-ticket-tx")
    @SentinelResource(value = "groupRefundTicket", blockHandler = "groupRefundTicketBlockHandler")
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<BigDecimal> groupRefundTicket(GroupRefundRequest req) {
        try {
            if (req.getTicketIds() == null || req.getTicketIds().isEmpty()) return Result.error("退票列表不能为空");

            BigDecimal totalRefund = BigDecimal.ZERO;
            List<String> errors = new ArrayList<>();

            for (Integer ticketId : req.getTicketIds()) {
                Ticket t = ticketMapper.selectById(ticketId);
                if (t == null) {
                    errors.add("票ID " + ticketId + " 不存在");
                    continue;
                }
                if ("REFUNDED".equals(t.getStatus()) || "CHANGED".equals(t.getStatus())) {
                    errors.add("票ID " + ticketId + " 状态不允许退票: " + t.getStatus());
                    continue;
                }

                BigDecimal refundAmount;
                if (Boolean.TRUE.equals(req.getIsFreeRefund())) {
                    refundAmount = t.getPrice();
                } else {
                    BigDecimal fee = t.getPrice().multiply(REFUND_FEE_RATIO).setScale(2, RoundingMode.HALF_UP);
                    if (fee.compareTo(MIN_REFUND_FEE) < 0) fee = MIN_REFUND_FEE;
                    refundAmount = t.getPrice().subtract(fee);
                    if (refundAmount.compareTo(BigDecimal.ZERO) < 0) refundAmount = BigDecimal.ZERO;
                    t.setRefundFee(fee);
                }

                t.setStatus(ticketStatusEnum.REFUNDED);
                t.setUpdatedAt(new Date());
                ticketMapper.updateById(t);
                
                // 更新订单状态为 REFUNDED
                if (t.getOrderId() != null) {
                    orderMapper.update(null, new LambdaUpdateWrapper<Order>()
                            .eq(Order::getOrderId, t.getOrderId())
                            .set(Order::getOrderStatus, "REFUNDED")
                            .set(Order::getUpdatedAt, new Date()));
                }
                
                releaseSeat(t.getSeatId());
                seatCacheService.clearSeatCache(t.getTrainId(),
                        new java.text.SimpleDateFormat("yyyy-MM-dd").format(t.getTravelDate()));
                totalRefund = totalRefund.add(refundAmount);
            }

            if (!errors.isEmpty() && errors.size() == req.getTicketIds().size()) {
                return Result.error("全部退票失败: " + String.join("; ", errors));
            }

            String msg = "团体退票完成，退款总额: " + totalRefund;
            if (!errors.isEmpty()) msg += "（部分失败: " + String.join("; ", errors) + "）";
            log.info("团体退票: 请求{}张, 成功{}张, 退款={}", req.getTicketIds().size(), req.getTicketIds().size() - errors.size(), totalRefund);
            return Result.success(totalRefund, msg);
        } catch (Exception e) {
            log.error("团体退票异常", e);
            throw new RuntimeException("团体退票失败: " + e.getMessage());
        }
    }

    /**
     * 改签。
     */
    @GlobalTransactional(rollbackFor = Exception.class, name = "change-ticket-tx")
    @SentinelResource(value = "changeTicket", blockHandler = "changeTicketBlockHandler")
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Object> changeTicket(TicketChangeRequest req) {
        try {
            // 1. 查询原车票
            Ticket oldTicket = ticketMapper.selectById(req.getOriginalTicketId());
            if (oldTicket == null) return Result.error("原车票不存在");
            String status = oldTicket.getStatus();
            if (!"BOOKED".equals(status) && !"UNPAID".equals(status) && !"VALID".equals(status) && !"PAID".equals(status)) {
                return Result.error("当前车票状态不允许改签: " + status);
            }

            // 2. 查询新车次
            Result<Train> newTrainRes = trainFeignClient.getTrainById(req.getNewTrainId());
            if (newTrainRes.getCode() != 200 || newTrainRes.getData() == null) return Result.error("新车次不存在");
            Train newTrain = newTrainRes.getData();
            if (Integer.valueOf(0).equals(newTrain.getStatus())) return Result.error("新车次已停运");

            // 3. 查询原车次（用于记录）
            Result<Train> oldTrainRes = trainFeignClient.getTrainById(oldTicket.getTrainId());
            Train oldTrain = (oldTrainRes.getCode() == 200 && oldTrainRes.getData() != null) ? oldTrainRes.getData() : null;

            // 4. 锁定新座位
            Seat newSeat = seatMapper.selectById(req.getNewSeatId());
            if (newSeat == null) return Result.error("新座位不存在");
            if (!seatStatusEnum.AVAILABLE.equals(newSeat.getStatus())) return Result.error("新座位不可用");

            int rows = seatMapper.update(null, new LambdaUpdateWrapper<Seat>()
                    .eq(Seat::getSeatId, newSeat.getSeatId())
                    .eq(Seat::getStatus, seatStatusEnum.AVAILABLE)
                    .set(Seat::getStatus, seatStatusEnum.OCCUPIED)
                    .set(Seat::getUpdatedAt, new Date()));
            if (rows == 0) return Result.error("新座位已被占用");

            // 5. 释放原座位并清理缓存
            releaseSeat(oldTicket.getSeatId());
            String oldTravelDateStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(oldTicket.getTravelDate());
            seatCacheService.clearSeatCache(oldTicket.getTrainId(), oldTravelDateStr);

            // 5.1 清理新车次缓存（如果车次或日期不同）
            String newTravelDateStr = req.getNewTravelDate() != null
                    ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(req.getNewTravelDate())
                    : oldTravelDateStr;
            if (!oldTicket.getTrainId().equals(req.getNewTrainId()) || !oldTravelDateStr.equals(newTravelDateStr)) {
                seatCacheService.clearSeatCache(req.getNewTrainId(), newTravelDateStr);
            }

            // 6. 计算差价
            BigDecimal newPrice = (newTrain.getBasePrice() != null ? newTrain.getBasePrice() : new BigDecimal("100"))
                    .multiply(newSeat.getPriceCoefficient());
            BigDecimal priceDiff = newPrice.subtract(oldTicket.getPrice());

            // 7. 更新原票状态为已改签
            oldTicket.setStatus(ticketStatusEnum.CHANGED);
            oldTicket.setUpdatedAt(new Date());
            ticketMapper.updateById(oldTicket);

            // 8. 创建新票
            Date newTravelDate = req.getNewTravelDate() != null ? req.getNewTravelDate() : oldTicket.getTravelDate();
            Ticket newTicket = new Ticket();
            newTicket.setOrderId(oldTicket.getOrderId());
            newTicket.setTicketNumber("TKT" + System.currentTimeMillis());
            newTicket.setTrainId(req.getNewTrainId());
            newTicket.setSeatId(newSeat.getSeatId());
            newTicket.setPassengerId(oldTicket.getPassengerId());
            newTicket.setTravelDate(newTravelDate);
            newTicket.setPrice(newPrice);
            newTicket.setSaleTime(new Date());
            newTicket.setHadPay(oldTicket.getHadPay());
            newTicket.setStatus(ticketStatusEnum.BOOKED);
            newTicket.setStartStation(newTrain.getStartStation());
            newTicket.setEndStation(newTrain.getEndStation());
            newTicket.setDepartureTime(newTrain.getDepartureTime());
            newTicket.setArrivalTime(newTrain.getArrivalTime());
            newTicket.setCreatedAt(new Date());
            newTicket.setUpdatedAt(new Date());
            ticketMapper.insert(newTicket);

            // 9. 记录改签记录
            Seat oldSeat = seatMapper.selectById(oldTicket.getSeatId());
            String changeType = oldTicket.getTrainId().equals(req.getNewTrainId()) ? "SEAT" : "BOTH";

            TicketChange change = new TicketChange();
            change.setTicketId(oldTicket.getTicketId());
            change.setOldTrainNumber(oldTrain != null ? oldTrain.getTrainNumber() : null);
            change.setNewTrainNumber(newTrain.getTrainNumber());
            change.setOldSeatNumber(oldSeat != null ? oldSeat.getSeatNumber() : null);
            change.setNewSeatNumber(newSeat.getSeatNumber());
            change.setOldTravelDate(oldTicket.getTravelDate());
            change.setNewTravelDate(newTravelDate);
            change.setChangeType(changeType);
            change.setPriceDiff(priceDiff);
            change.setChangeFee(BigDecimal.ZERO);
            change.setOperatorId(req.getOperatorId());
            change.setChangeTime(new Date());
            ticketChangeMapper.insert(change);

            log.info("改签成功: 原票={}, 新票={}, 差价={}", oldTicket.getTicketId(), newTicket.getTicketId(), priceDiff);
            return Result.success(newTicket, "改签成功，差价: " + priceDiff);
        } catch (Exception e) {
            log.error("改签异常: " + e.getMessage(), e);
            throw new RuntimeException("改签失败: " + e.getMessage());
        }
    }

    /**
     * 根据订单ID查询车票列表。
     */
    @Override
    public Result<List<Ticket>> getTicketsByOrderId(Integer orderId) {
        return Result.success(ticketMapper.selectList(new LambdaQueryWrapper<Ticket>().eq(Ticket::getOrderId, orderId)));
    }

    /**
     * 获取车票详情。
     */
    @Override
    public Result<Ticket> getTicketDetail(Integer ticketId) {
        return Result.success(ticketMapper.selectById(ticketId));
    }

    /**
     * 更新车票状态。
     */
    @Override
    public Result<Boolean> updateTicketStatus(Integer ticketId, String status) {
        Ticket t = new Ticket(); t.setTicketId(ticketId); t.setStatus(status); t.setUpdatedAt(new Date());
        return ticketMapper.updateById(t) > 0 ? Result.success(true) : Result.error("更新失败");
    }

    /**
     * 根据用户ID查询车票列表。
     */
    @Override
    public Result<Object> getTicketsByUserId(Integer userId) {
        List<Passenger> passengers = passengerMapper.selectList(
                new LambdaQueryWrapper<Passenger>().eq(Passenger::getUserId, userId));
        if (passengers.isEmpty()) return Result.success(new ArrayList<>());
        List<Integer> passengerIds = passengers.stream().map(Passenger::getPassengerId).toList();
        List<Ticket> tickets = ticketMapper.selectList(
                new LambdaQueryWrapper<Ticket>().in(Ticket::getPassengerId, passengerIds)
                        .orderByDesc(Ticket::getCreatedAt));
        return Result.success(tickets);
    }

    /**
     * 取消预订。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> cancelBooking(Integer ticketId) {
        try {
            Ticket t = ticketMapper.selectById(ticketId);
            if (t == null) return Result.error("车票不存在");
            if (ticketStatusEnum.REFUNDED.equals(t.getStatus())
                    || ticketStatusEnum.CHANGED.equals(t.getStatus())) {
                return Result.error("车票当前状态不允许取消: " + t.getStatus());
            }
            t.setStatus(ticketStatusEnum.REFUNDED);
            t.setUpdatedAt(new Date());
            ticketMapper.updateById(t);
            releaseSeat(t.getSeatId());
            if (t.getTrainId() != null && t.getTravelDate() != null) {
                seatCacheService.clearSeatCache(t.getTrainId(),
                        new java.text.SimpleDateFormat("yyyy-MM-dd").format(t.getTravelDate()));
            }
            log.info("取消预订成功: 票ID={}", ticketId);
            return Result.success(true);
        } catch (Exception e) {
            log.error("取消预订异常", e);
            throw new RuntimeException("取消预订失败: " + e.getMessage());
        }
    }

    /**
     * 释放座位。
     */
    private void releaseSeat(Integer sid) {
        if (sid == null) {
            log.warn("释放座位失败: seatId 为空");
            return;
        }
        int rows = seatMapper.update(null, new LambdaUpdateWrapper<Seat>()
                .eq(Seat::getSeatId, sid).set(Seat::getStatus, seatStatusEnum.AVAILABLE));
        if (rows == 0) {
            log.error("释放座位失败: seatId={} 不存在或已是可用状态", sid);
        } else {
            log.info("座位已释放: seatId={}", sid);
        }
    }

    /**
     * 调度支付超时任务。
     */
    private void schedulePaymentTimeout(Integer orderId) {
        if (orderId == null) return;
        Runnable task = () -> rabbitTemplate.convertAndSend(MqConstants.PAYMENT_EXCHANGE, MqConstants.PAYMENT_DELAY_ROUTING_KEY, String.valueOf(orderId));
        if (TransactionSynchronizationManager.isSynchronizationActive()) {
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override public void afterCommit() { task.run(); }
            });
        } else { task.run(); }
    }

    /**
     * 自动生成座位（若该日期无座位数据）。
     */
    private void autoGenerateSeats(Integer tid, Date date) {
        java.sql.Date sqlDate = new java.sql.Date(date.getTime());
        // 只有该日期完全没有座位时才生成，避免重复/超卖
        if (seatMapper.selectCount(new LambdaQueryWrapper<Seat>().eq(Seat::getTrainId, tid).eq(Seat::getTravelDate, sqlDate)) == 0) {
            Date now = new Date();
            for (int i = 1; i <= 30; i++) buildAndInsertSeat(tid, sqlDate, i, "商务座", 1, "2.0", "1", now);
            for (int i = 31; i <= 80; i++) buildAndInsertSeat(tid, sqlDate, i, "一等座", 2, "1.5", "2", now);
            for (int i = 81; i <= 150; i++) buildAndInsertSeat(tid, sqlDate, i, "二等座", 3, "1.0", "3", now);
        }
    }

    /**
     * 构建并插入座位记录。
     */
    private void buildAndInsertSeat(Integer tid, java.sql.Date d, int n, String type, int lvl, String coeff, String c, Date now) {
        Seat s = new Seat(); s.setTrainId(tid); s.setTravelDate(d); s.setSeatNumber(String.format("%03d", n));
        s.setSeatType(type); s.setSeatLevel(lvl); s.setPriceCoefficient(new BigDecimal(coeff)); s.setCarriageNumber(c);
        s.setStatus(seatStatusEnum.AVAILABLE); s.setCreatedAt(now); s.setUpdatedAt(now);
        try { seatMapper.insert(s); } catch (Exception e) { /* 重复键异常静默处理，避免日志刷屏 */ }
    }

    /**
     * 判断是否为预订票（出发日期大于3天）。
     */
    private static boolean isPreBooking(Date travelDate) {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0); cal.set(Calendar.MINUTE, 0); cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0);
        return (travelDate.getTime() - cal.getTimeInMillis()) / (1000 * 60 * 60 * 24) > 3;
    }

    /**
     * 售票限流降级处理方法。
     * Sentinel限流发生在业务逻辑执行前，不涉及数据库操作，无需触发Seata回滚。
     */
    public static Result<Ticket> sellTicketBlockHandler(BookingRequest req, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        log.warn("售票接口触发限流/熔断: trainId={}, 异常类型={}", req.getTrainId(), ex.getClass().getSimpleName());
        return Result.error("购票高峰期，当前排队人数较多，请稍后重试或选择其他车次");
    }

    /**
     * 团体售票限流降级处理方法。
     * Sentinel限流发生在业务逻辑执行前，不涉及数据库操作，无需触发Seata回滚。
     */
    public static Result<List<Ticket>> groupSellTicketBlockHandler(GroupBookingRequest req, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        int ticketCount = req.getName() != null ? req.getName().size() : 0;
        log.warn("团体售票接口触发限流/熔断: trainId={}, 票数={}, 异常类型={}",
            req.getTrainId(), ticketCount, ex.getClass().getSimpleName());
        return Result.error("团体购票高峰期，请分批次购票或稍后重试");
    }

    /**
     * 退票限流降级处理方法。
     */
    public static Result<BigDecimal> refundTicketBlockHandler(RefundRequest req, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        log.warn("退票接口触发限流/熔断: ticketId={}, 异常类型={}", req.getTicketId(), ex.getClass().getSimpleName());
        return Result.error("退票处理繁忙，您的退票申请已记录，稍后处理");
    }

    /**
     * 团体退票限流降级处理方法。
     */
    public static Result<BigDecimal> groupRefundTicketBlockHandler(GroupRefundRequest req, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        log.warn("团体退票接口触发限流/熔断: 票数={}, 异常类型={}",
            req.getTicketIds() != null ? req.getTicketIds().size() : 0, ex.getClass().getSimpleName());
        return Result.error("团体退票处理繁忙，您的退票申请已记录，稍后处理");
    }

    /**
     * 改签限流降级处理方法。
     */
    public static Result<Object> changeTicketBlockHandler(TicketChangeRequest req, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        log.warn("改签接口触发限流/熔断: ticketId={}, 异常类型={}", req.getOriginalTicketId(), ex.getClass().getSimpleName());
        return Result.error("改签处理繁忙，请稍后重试或联系客服");
    }
}
