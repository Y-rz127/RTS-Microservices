package com.ticket.sales.service;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 座位缓存服务接口。
 */
public interface SeatCacheService {
    /**
     * 获取座位可用性详情。
     */
    List<Map<String, Serializable>> getSeatAvailability(Integer trainId, String travelDate);
    /**
     * 获取可用座位数量。
     */
    Integer getAvailableSeatCount(Integer trainId, String travelDate, String seatType);
    /**
     * 更新座位缓存。
     */
    void updateSeatCache(Integer trainId, String travelDate, Integer seatId, String seatType, boolean isAvailable);
    /**
     * 刷新座位缓存。
     */
    void refreshSeatCache(Integer trainId, String travelDate);
    /**
     * 清除座位缓存。
     */
    void clearSeatCache(Integer trainId, String travelDate);
    /**
     * 判断是否为热点车次。
     */
    boolean isHotTrain(Integer trainId, String travelDate);
    /**
     * 根据车票清除缓存。
     */
    void clearSeatCacheByTicketId(Integer ticketId);
}
