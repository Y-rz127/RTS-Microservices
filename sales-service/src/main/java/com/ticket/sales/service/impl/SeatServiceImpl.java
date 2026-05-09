package com.ticket.sales.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.Enum.seatStatusEnum;
import com.ticket.model.entity.Seat;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.sales.mapper.SeatMapper;
import com.ticket.sales.service.SeatService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * 座位服务实现类。
 */
@Service
public class SeatServiceImpl extends ServiceImpl<SeatMapper, Seat> implements SeatService {

    @Resource
    private SeatMapper seatMapper;

    /**
     * 查询座位详情。
     */
    @Override
    public Result<Seat> getSeatById(Integer seatId) {
        Seat seat = seatMapper.selectById(seatId);
        return seat != null ? Result.success(seat) : Result.error(404, "座位不存在");
    }

    /**
     * 分页查询座位。
     */
    @Override
    public Result<Object> getSeatPage(PageRequest pageRequest, Integer trainId, String seatType, String status) {
        Page<Seat> page = new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize());
        LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
        if (trainId != null) wrapper.eq(Seat::getTrainId, trainId);
        if (seatType != null && !seatType.isBlank()) wrapper.eq(Seat::getSeatType, seatType);
        if (status != null && !status.isBlank()) wrapper.eq(Seat::getStatus, status);
        wrapper.orderByAsc(Seat::getTrainId).orderByAsc(Seat::getCarriageNumber).orderByAsc(Seat::getSeatNumber);
        return Result.success(seatMapper.selectPage(page, wrapper));
    }

    /**
     * 查询车次座位。
     */
    @Override
    public Result<List<Seat>> getSeatsByTrainId(Integer trainId) {
        LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Seat::getTrainId, trainId).orderByAsc(Seat::getCarriageNumber).orderByAsc(Seat::getSeatNumber);
        return Result.success(seatMapper.selectList(wrapper));
    }

    /**
     * 更新座位状态。
     */
    @Override
    @Transactional
    public Result<Boolean> updateSeatStatus(Integer seatId, String status) {
        Seat seat = seatMapper.selectById(seatId);
        if (seat == null) return Result.error(404, "座位不存在");
        if (status == null || status.isBlank()) return Result.error("状态参数不能为空");

        // 统一小写后与枚举比较（枚举值均为小写）
        String targetStatus = status.toLowerCase();
        String currentStatus = seat.getStatus() == null ? "" : seat.getStatus().toLowerCase();

        boolean enable = seatStatusEnum.AVAILABLE.equals(targetStatus) && seatStatusEnum.MAINTENANCE.equals(currentStatus);
        boolean disable = seatStatusEnum.MAINTENANCE.equals(targetStatus) && seatStatusEnum.AVAILABLE.equals(currentStatus);

        if (!enable && !disable) {
            return Result.error("当前状态不支持该修改（已售出/锁定中的座位不可变更）");
        }

        seat.setStatus(targetStatus);
        seat.setUpdatedAt(new java.util.Date());
        return seatMapper.updateById(seat) > 0 ? Result.success(true) : Result.error(500, "更新失败");
    }

    /**
     * 查询可用座位数量。
     */
    @Override
    public Result<Integer> getAvailableSeatCount(Integer trainId, String seatType) {
        try {
            LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Seat::getTrainId, trainId).eq(Seat::getSeatType, seatType).eq(Seat::getStatus, "available");
            return Result.success(Math.toIntExact(seatMapper.selectCount(wrapper)));
        } catch (Exception e) {
            return Result.error("查询失败：" + e.getMessage());
        }
    }

    /**
     * 新增座位。
     */
    @Override
    @Transactional
    public Result<Seat> addSeat(Seat seat) {
        try {
            LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Seat::getTrainId, seat.getTrainId())
                   .eq(Seat::getCarriageNumber, seat.getCarriageNumber())
                   .eq(Seat::getSeatNumber, seat.getSeatNumber());
            if (seatMapper.selectCount(wrapper) > 0) return Result.error("座位已存在");
            if (seat.getStatus() == null || seat.getStatus().isBlank()) seat.setStatus("available");
            return seatMapper.insert(seat) > 0 ? Result.success(seat) : Result.error("新增失败");
        } catch (Exception e) {
            return Result.error("异常：" + e.getMessage());
        }
    }

    /**
     * 批量新增座位。
     */
    @Override
    @Transactional
    public Result<Boolean> addSeats(List<Seat> seats) {
        return this.saveBatch(seats) ? Result.success(true) : Result.error("批量新增失败");
    }

    /**
     * 更新座位。
     */
    @Override
    @Transactional
    public Result<Seat> updateSeat(Seat seat) {
        if (seatMapper.selectById(seat.getSeatId()) == null) return Result.error("不存在");
        return seatMapper.updateById(seat) > 0 ? Result.success(seatMapper.selectById(seat.getSeatId())) : Result.error("修改失败");
    }

    /**
     * 删除座位。
     */
    @Override
    @Transactional
    public Result<Boolean> deleteSeat(Integer seatId) {
        Seat seat = seatMapper.selectById(seatId);
        if (seat == null) return Result.error("不存在");
        if (!"available".equals(seat.getStatus())) return Result.error("非空闲状态，无法删除");
        return seatMapper.deleteById(seatId) > 0 ? Result.success(true) : Result.error("删除失败");
    }

    /**
     * 查询座位布局。
     */
    @Override
    public Result<List<Seat>> getSeatLayout(Integer trainId, String travelDate) {
        try {
            Date date = Date.valueOf(travelDate);
            LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Seat::getTrainId, trainId).eq(Seat::getTravelDate, date).orderByAsc(Seat::getSeatNumber);
            List<Seat> seats = seatMapper.selectList(wrapper);
            if (seats.isEmpty()) {
                if (generateSeatsForTrain(trainId, travelDate).isSuccess()) seats = seatMapper.selectList(wrapper);
            }
            return Result.success(seats);
        } catch (Exception e) {
            return Result.error("查询失败：" + e.getMessage());
        }
    }

    /**
     * 查询可用座位列表。
     */
    @Override
    public Result<List<Seat>> getAvailableSeats(Integer trainId, String seatType, String travelDate) {
        try {
            Date date = Date.valueOf(travelDate);
            LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Seat::getTrainId, trainId).eq(Seat::getTravelDate, date).eq(Seat::getSeatType, seatType).eq(Seat::getStatus, "available").orderByAsc(Seat::getSeatNumber);
            return Result.success(seatMapper.selectList(wrapper));
        } catch (Exception e) {
            return Result.error("查询失败：" + e.getMessage());
        }
    }

    /**
     * 生成车次座位。
     */
    @Override
    @Transactional
    public Result<Boolean> generateSeatsForTrain(Integer trainId, String travelDate) {
        try {
            Date date = Date.valueOf(travelDate);
            if (seatMapper.selectCount(new LambdaQueryWrapper<Seat>().eq(Seat::getTrainId, trainId).eq(Seat::getTravelDate, date)) > 0) return Result.error("已存在");
            List<Seat> seats = new ArrayList<>();
            java.util.Date now = new java.util.Date();
            seats.addAll(buildBatchSeats(trainId, date, 1, 30, "商务座", 1, "2.0", "1", now));
            seats.addAll(buildBatchSeats(trainId, date, 31, 50, "一等座", 2, "1.5", "2", now));
            seats.addAll(buildBatchSeats(trainId, date, 81, 70, "二等座", 3, "1.0", "3", now));
            return this.saveBatch(seats) ? Result.success(true) : Result.error("生成失败");
        } catch (Exception e) {
            return Result.error("生成失败：" + e.getMessage());
        }
    }

    /**
     * 批量构建座位记录。
     */
    private List<Seat> buildBatchSeats(Integer trainId, Date date, int startNum, int count, String type, int level, String coeff, String carriage, java.util.Date now) {
        List<Seat> list = new ArrayList<>();
        BigDecimal priceCoeff = new BigDecimal(coeff);
        for (int i = 0; i < count; i++) {
            Seat s = new Seat();
            s.setTrainId(trainId); s.setTravelDate(date); s.setSeatNumber(String.format("%03d", startNum + i));
            s.setSeatType(type); s.setSeatLevel(level); s.setPriceCoefficient(priceCoeff); s.setCarriageNumber(carriage);
            s.setStatus(seatStatusEnum.AVAILABLE); s.setCreatedAt(now); s.setUpdatedAt(now);
            list.add(s);
        }
        return list;
    }

    /**
     * 清理过期座位。
     */
    @Override
    @Transactional
    public Result<Integer> cleanupExpiredSeats() {
        try {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
            int count = seatMapper.deleteExpiredSeatsNotReferenced(cal.getTime());
            return Result.success(count, "清理成功，共清理 " + count + " 条过期数据");
        } catch (Exception e) {
            return Result.error("清理失败：" + e.getMessage());
        }
    }
}
