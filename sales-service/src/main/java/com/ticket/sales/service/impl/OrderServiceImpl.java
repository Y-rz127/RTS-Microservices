package com.ticket.sales.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.Enum.seatStatusEnum;
import com.ticket.api.feign.TrainFeignClient;
import com.ticket.constant.MqConstants;
import com.ticket.model.entity.*;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.OrderDetailDTO;
import com.ticket.model.response.Result;
import com.ticket.model.response.TicketDetailDTO;
import com.ticket.sales.mapper.*;
import com.ticket.sales.service.OrderService;
import com.ticket.sales.service.SeatCacheService;
import jakarta.annotation.Resource;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 订单核心服务实现，处理订单创建、支付、取消、查询等业务逻辑。
 * 与票务系统联动，支持支付超时自动取消机制。
 * @author 铁路票务系统
 */
@Service
public class OrderServiceImpl extends ServiceImpl<OrderMapper, Order> implements OrderService {

    @Resource
    private TicketMapper ticketMapper;
    
    @Resource
    private PassengerMapper passengerMapper;
    
    @Resource
    private SeatMapper seatMapper;

    @Resource
    private TrainFeignClient trainFeignClient;

    @Resource
    private RabbitTemplate rabbitTemplate;

    @Resource
    private SeatCacheService seatCacheService;

    /**
     * 创建订单。
     */
    @Override
    @Transactional
    public Result<Order> createOrder(Order order) {
        try {
            Date now = new Date();
            order.setOrderStatus("UNPAID");
            order.setCreatedAt(now);
            order.setUpdatedAt(now);

            if (!this.save(order)) return Result.error("创建订单失败");

            schedulePaymentTimeout(order.getOrderId());
            return Result.success(order);
        } catch (Exception e) {
            return Result.error("创建订单异常：" + e.getMessage());
        }
    }

    /**
     * 支付订单。
     */
    @Override
    @Transactional
    public Result<Boolean> payOrder(Integer orderId, String paymentMethod) {
        try {
            Order order = this.getById(orderId);
            if (order == null) return Result.error("订单不存在");
            if ("CANCELLED".equals(order.getOrderStatus())) return Result.error("订单已超时取消");
            if ("PAID".equals(order.getOrderStatus())) return Result.error("订单已支付，请勿重复支付");
            if (!"UNPAID".equals(order.getOrderStatus())) return Result.error("当前订单状态不允许支付");

            Date now = new Date();
            order.setOrderStatus("PAID");
            order.setPaymentMethod(paymentMethod);
            order.setPaymentTime(now);
            order.setUpdatedAt(now);

            if (!this.updateById(order)) return Result.error("支付失败");
            
            ticketMapper.update(null, new LambdaUpdateWrapper<Ticket>()
                    .eq(Ticket::getOrderId, orderId)
                    .set(Ticket::getHadPay, 1)
                    .set(Ticket::getStatus, "PAID")
                    .set(Ticket::getUpdatedAt, now));
            
            return Result.success(true);
        } catch (Exception e) {
            return Result.error("支付异常：" + e.getMessage());
        }
    }

    /**
     * 取消订单。
     */
    @Override
    @Transactional
    public Result<Boolean> cancelOrder(Integer orderId) {
        try {
            Order order = this.getById(orderId);
            if (order == null) return Result.error("订单不存在");
            if (!"UNPAID".equals(order.getOrderStatus()) && !"PENDING".equals(order.getOrderStatus())) {
                return Result.error("只有未支付订单才能取消");
            }

            List<Ticket> tickets = ticketMapper.selectList(new LambdaQueryWrapper<Ticket>()
                    .eq(Ticket::getOrderId, orderId));
            for (Ticket ticket : tickets) {
                ticket.setStatus("REFUNDED");
                ticket.setHadPay(0);
                ticket.setUpdatedAt(new Date());
                if (ticketMapper.updateById(ticket) != 1) {
                    throw new RuntimeException("车票状态更新失败");
                }
                releaseSeat(ticket.getSeatId());
                if (ticket.getTrainId() != null && ticket.getTravelDate() != null) {
                    seatCacheService.clearSeatCache(ticket.getTrainId(), new SimpleDateFormat("yyyy-MM-dd").format(ticket.getTravelDate()));
                }
            }

            order.setOrderStatus("CANCELLED");
            order.setUpdatedAt(new Date());

            return this.updateById(order) ? Result.success(true) : Result.error("取消订单失败");
        } catch (Exception e) {
            return Result.error("取消订单异常：" + e.getMessage());
        }
    }

    /**
     * 调度支付超时任务。
     */
    private void schedulePaymentTimeout(Integer orderId) {
        if (orderId == null) return;
        Runnable sendTask = () -> rabbitTemplate.convertAndSend(
                MqConstants.PAYMENT_EXCHANGE,
                MqConstants.PAYMENT_DELAY_ROUTING_KEY,
                String.valueOf(orderId)
        );
        if (TransactionSynchronizationManager.isSynchronizationActive()) {
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override
                public void afterCommit() {
                    sendTask.run();
                }
            });
        } else {
            sendTask.run();
        }
    }

    /**
     * 释放座位。
     */
    private void releaseSeat(Integer seatId) {
        if (seatId == null) return;
        seatMapper.update(null, new LambdaUpdateWrapper<Seat>()
                .eq(Seat::getSeatId, seatId)
                .set(Seat::getStatus, seatStatusEnum.AVAILABLE)
                .set(Seat::getUpdatedAt, new Date()));
    }

    /**
     * 根据订单号查询订单。
     */
    @Override
    public Result<Order> getOrderByNumber(String orderNumber) {
        try {
            Order order = this.getOne(new LambdaQueryWrapper<Order>().eq(Order::getOrderNumber, orderNumber));
            return order != null ? Result.success(order) : Result.error("订单不存在");
        } catch (Exception e) {
            return Result.error("查询订单异常：" + e.getMessage());
        }
    }

    /**
     * 分页查询订单列表。
     */
    @Override
    public Result<Object> getOrderPage(PageRequest pageRequest, Integer userId, String orderStatus) {
        try {
            Page<Order> page = new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize());
            LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
            if (userId != null) wrapper.eq(Order::getUserId, userId);
            if (orderStatus != null && !orderStatus.isBlank()) wrapper.eq(Order::getOrderStatus, orderStatus);
            wrapper.orderByDesc(Order::getCreatedAt);
            return Result.success(this.page(page, wrapper));
        } catch (Exception e) {
            return Result.error("查询订单列表异常：" + e.getMessage());
        }
    }

    /**
     * 根据用户ID查询订单列表。
     */
    @Override
    public Result<Object> getOrdersByUserId(Integer userId) {
        try {
            List<Order> orders = this.list(new LambdaQueryWrapper<Order>()
                    .eq(Order::getUserId, userId).orderByDesc(Order::getCreatedAt));
            List<OrderDetailDTO> orderDetails = orders.stream()
                    .map(this::buildOrderDetail)
                    .collect(Collectors.toList());
            return Result.success(orderDetails);
        } catch (Exception e) {
            return Result.error("查询用户订单异常：" + e.getMessage());
        }
    }

    /**
     * 查询退票申请列表。
     */
    @Override
    public Result<Object> getRefundApplications(String status) {
        try {
            LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Order::getOrderStatus, (status != null && !status.isBlank()) ? status : "PENDING_REFUND")
                   .orderByDesc(Order::getUpdatedAt);
            return Result.success(this.list(wrapper));
        } catch (Exception e) {
            return Result.error("查询退票申请失败：" + e.getMessage());
        }
    }

    /**
     * 构建订单详情 DTO。
     */
    private OrderDetailDTO buildOrderDetail(Order order) {
        OrderDetailDTO dto = new OrderDetailDTO();
        dto.setOrder(order);

        List<Ticket> tickets = ticketMapper.selectList(new LambdaQueryWrapper<Ticket>()
                .eq(Ticket::getOrderId, order.getOrderId())
                .orderByAsc(Ticket::getTicketId));

        List<TicketDetailDTO> ticketDetails = tickets.stream().map(ticket -> {
            TicketDetailDTO ticketDto = new TicketDetailDTO();
            ticketDto.setTicketId(ticket.getTicketId());
            ticketDto.setTicketNumber(ticket.getTicketNumber());
            ticketDto.setTrainNumber(resolveTrainNumber(ticket.getTrainId()));
            ticketDto.setStartStation(ticket.getStartStation());
            ticketDto.setEndStation(ticket.getEndStation());
            ticketDto.setDepartureTime(ticket.getDepartureTime() != null ? ticket.getDepartureTime().toString() : null);
            ticketDto.setArrivalTime(ticket.getArrivalTime() != null ? ticket.getArrivalTime().toString() : null);
            ticketDto.setTravelDate(ticket.getTravelDate());
            ticketDto.setPrice(ticket.getPrice());
            ticketDto.setStatus(ticket.getStatus());

            Passenger passenger = ticket.getPassengerId() != null ? passengerMapper.selectById(ticket.getPassengerId()) : null;
            if (passenger != null) {
                ticketDto.setPassengerName(passenger.getName());
                ticketDto.setIdType(passenger.getIdType());
                ticketDto.setIdNumber(passenger.getIdNumber());
                ticketDto.setPhone(passenger.getPhone());
            }

            Seat seat = ticket.getSeatId() != null ? seatMapper.selectById(ticket.getSeatId()) : null;
            if (seat != null) {
                ticketDto.setSeatNumber(buildSeatDisplay(seat));
                ticketDto.setSeatType(seat.getSeatType());
            }
            return ticketDto;
        }).collect(Collectors.toList());

        dto.setTickets(ticketDetails);
        dto.setPassengerCount(ticketDetails.size());

        if (!ticketDetails.isEmpty()) {
            // 优先显示有效车票（BOOKED/PAID），而不是 CHANGED/REFUNDED 的票
            TicketDetailDTO displayTicket = ticketDetails.stream()
                    .filter(t -> "BOOKED".equals(t.getStatus()) || "PAID".equals(t.getStatus()))
                    .findFirst()
                    .orElse(ticketDetails.get(0));
            dto.setTrainNumber(displayTicket.getTrainNumber());
            dto.setStartStation(displayTicket.getStartStation());
            dto.setEndStation(displayTicket.getEndStation());
            dto.setDepartureTime(displayTicket.getDepartureTime());
            dto.setArrivalTime(displayTicket.getArrivalTime());
            dto.setTravelDate(displayTicket.getTravelDate() != null ? new SimpleDateFormat("yyyy-MM-dd").format(displayTicket.getTravelDate()) : null);
            dto.setSeatType(displayTicket.getSeatType());
            dto.setTicketStatus(displayTicket.getStatus());
        }

        return dto;
    }

    /**
     * 解析车次编号。
     */
    private String resolveTrainNumber(Integer trainId) {
        if (trainId == null) {
            return null;
        }
        try {
            Result<Train> trainRes = trainFeignClient.getTrainById(trainId);
            return trainRes != null && trainRes.getCode() == 200 && trainRes.getData() != null
                    ? trainRes.getData().getTrainNumber()
                    : null;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 构建座位显示字符串。
     */
    private String buildSeatDisplay(Seat seat) {
        if (seat == null) {
            return null;
        }
        if (seat.getCarriageNumber() == null || seat.getCarriageNumber().isBlank()) {
            return seat.getSeatNumber();
        }
        return seat.getCarriageNumber() + "车-" + seat.getSeatNumber() + "号";
    }

    /**
     * 根据用户名查询订单（已废弃）
     */
    @Override
    public Result<Object> getOrdersByUsername(String username) {
        // 该方法已废弃：分布式环境下按用户名查询应走 user-auth-service 获取 userId 后再查订单，
        // 目前订单列表通过 getOrdersByUserId 查询，保留此方法仅为兼容旧接口定义。
        return Result.error("该查询方式已废弃，请使用 getOrdersByUserId");
    }

    /**
     * 根据乘客姓名查询订单。
     */
    @Override
    public Result<Object> getOrdersByPassengerName(String passengerName) {
        try {
            List<Passenger> passengers = passengerMapper.selectList(new LambdaQueryWrapper<Passenger>().eq(Passenger::getName, passengerName));
            if (passengers.isEmpty()) return Result.error("未找到该乘客");
            List<Integer> passengerIds = passengers.stream().map(Passenger::getPassengerId).collect(Collectors.toList());
            List<Ticket> tickets = ticketMapper.selectList(new LambdaQueryWrapper<Ticket>().in(Ticket::getPassengerId, passengerIds));
            if (tickets.isEmpty()) return Result.success(List.of());
            List<Integer> orderIds = tickets.stream().map(Ticket::getOrderId).distinct().collect(Collectors.toList());
            return Result.success(this.listByIds(orderIds));
        } catch (Exception e) {
            return Result.error("查询异常：" + e.getMessage());
        }
    }
}
