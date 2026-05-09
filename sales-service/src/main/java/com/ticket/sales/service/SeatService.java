package com.ticket.sales.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.Seat;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import java.util.List;

/**
 * 座位服务接口。
 */
public interface SeatService extends IService<Seat> {
    /**
     * 查询座位详情。
     */
    Result<Seat> getSeatById(Integer seatId);
    /**
     * 分页查询座位。
     */
    Result<Object> getSeatPage(PageRequest pageRequest, Integer trainId, String seatType, String status);
    /**
     * 查询车次座位。
     */
    Result<List<Seat>> getSeatsByTrainId(Integer trainId);
    /**
     * 更新座位状态。
     */
    Result<Boolean> updateSeatStatus(Integer seatId, String status);
    /**
     * 查询可用座位数量。
     */
    Result<Integer> getAvailableSeatCount(Integer trainId, String seatType);
    /**
     * 新增座位。
     */
    Result<Seat> addSeat(Seat seat);
    /**
     * 批量新增座位。
     */
    Result<Boolean> addSeats(List<Seat> seats);
    /**
     * 更新座位。
     */
    Result<Seat> updateSeat(Seat seat);
    /**
     * 删除座位。
     */
    Result<Boolean> deleteSeat(Integer seatId);
    /**
     * 查询座位布局。
     */
    Result<List<Seat>> getSeatLayout(Integer trainId, String travelDate);
    /**
     * 查询可用座位。
     */
    Result<List<Seat>> getAvailableSeats(Integer trainId, String seatType, String travelDate);
    /**
     * 生成车次座位。
     */
    Result<Boolean> generateSeatsForTrain(Integer trainId, String travelDate);
    /**
     * 清理过期座位。
     */
    Result<Integer> cleanupExpiredSeats();
}
