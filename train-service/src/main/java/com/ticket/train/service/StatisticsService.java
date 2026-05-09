package com.ticket.train.service;

import com.ticket.model.response.Result;

import java.util.Date;

/**
 * 统计服务接口。
 */
public interface StatisticsService {
    /**
     * 获取票务销售统计。
     */
    Result<Object> getTicketSalesStatistics(Date startDate, Date endDate);

    /**
     * 获取车次票务销售统计。
     */
    Result<Object> getTrainTicketSalesStatistics(Integer trainId, Date startDate, Date endDate);

    /**
     * 获取收入统计。
     */
    Result<Object> getRevenueStatistics(Date startDate, Date endDate);

    /**
     * 获取车次收入统计。
     */
    Result<Object> getTrainRevenueStatistics(Integer trainId, Date startDate, Date endDate);

    /**
     * 获取仪表盘概览。
     */
    Result<Object> getDashboardOverview();

    /**
     * 获取销售趋势。
     */
    Result<Object> getSalesTrend(Integer days);

    /**
     * 获取收入趋势。
     */
    Result<Object> getRevenueTrend(Integer days);

    /**
     * 获取销售量前N的车次。
     */
    Result<Object> getTopTrainsBySales(Integer topN, Date startDate, Date endDate);

    /**
     * 获取收入前N的车次。
     */
    Result<Object> getTopTrainsByRevenue(Integer topN, Date startDate, Date endDate);

    /**
     * 获取热门线路。
     */
    Result<Object> getTopRoutes(Integer topN, Date startDate, Date endDate);

    /**
     * 获取座位类型统计。
     */
    Result<Object> getSeatTypeStatistics(Date startDate, Date endDate);

    /**
     * 获取退票统计。
     */
    Result<Object> getRefundStatistics(Date startDate, Date endDate);

    /**
     * 获取改签统计。
     */
    Result<Object> getChangeStatistics(Date startDate, Date endDate);

    /**
     * 获取乘客统计。
     */
    Result<Object> getPassengerStatistics(Date startDate, Date endDate);
}
