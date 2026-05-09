package com.ticket.train.controller;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.model.response.Result;
import com.ticket.train.service.StatisticsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Date;

/**
 * 统计报表控制器。
 */
@RestController
@RequestMapping("/api/statistics")
@Tag(name = "数据统计与报表")
public class StatisticsController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（统计服务限流）";

    @Resource
    private StatisticsService statisticsService;

    /**
     * 查询售票统计。
     */
    @GetMapping("/ticket-sales")
    @SentinelResource(value = "statisticsTicketSales", blockHandler = "statisticsDateRangeBlockHandler")
    public Result<Object> getTicketSalesStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getTicketSalesStatistics(startDate, endDate);
    }

    /**
     * 查询指定车次售票统计。
     */
    @GetMapping("/ticket-sales/train/{trainId}")
    @SentinelResource(value = "statisticsTrainTicketSales", blockHandler = "statisticsTrainDateRangeBlockHandler")
    public Result<Object> getTrainTicketSalesStatistics(
            @PathVariable Integer trainId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getTrainTicketSalesStatistics(trainId, startDate, endDate);
    }

    /**
     * 查询收入统计。
     */
    @GetMapping("/revenue")
    @SentinelResource(value = "statisticsRevenue", blockHandler = "statisticsDateRangeBlockHandler")
    public Result<Object> getRevenueStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getRevenueStatistics(startDate, endDate);
    }

    /**
     * 查询指定车次收入统计。
     */
    @GetMapping("/revenue/train/{trainId}")
    @SentinelResource(value = "statisticsTrainRevenue", blockHandler = "statisticsTrainDateRangeBlockHandler")
    public Result<Object> getTrainRevenueStatistics(
            @PathVariable Integer trainId,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getTrainRevenueStatistics(trainId, startDate, endDate);
    }

    /**
     * 查询概览统计。
     */
    @GetMapping("/dashboard")
    @SentinelResource(value = "statisticsDashboard", blockHandler = "statisticsNoArgBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取数据概览")
    public Result<Object> getDashboardOverview() {
        return statisticsService.getDashboardOverview();
    }

    /**
     * 查询售票趋势。
     */
    @GetMapping("/sales-trend")
    @SentinelResource(value = "statisticsSalesTrend", blockHandler = "statisticsDaysBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取售票趋势")
    public Result<Object> getSalesTrend(@RequestParam(defaultValue = "7") Integer days) {
        return statisticsService.getSalesTrend(days);
    }

    /**
     * 查询收入趋势。
     */
    @GetMapping("/revenue-trend")
    @SentinelResource(value = "statisticsRevenueTrend", blockHandler = "statisticsDaysBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取收入趋势")
    public Result<Object> getRevenueTrend(@RequestParam(defaultValue = "7") Integer days) {
        return statisticsService.getRevenueTrend(days);
    }

    /**
     * 查询热门车次售票排行。
     */
    @GetMapping("/top-trains/sales")
    @SentinelResource(value = "statisticsTopSales", blockHandler = "statisticsTopBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取热门车次排行-售票量")
    public Result<Object> getTopTrainsBySales(
            @RequestParam(defaultValue = "10") Integer topN,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getTopTrainsBySales(topN, startDate, endDate);
    }

    /**
     * 查询热门车次收入排行。
     */
    @GetMapping("/top-trains/revenue")
    @SentinelResource(value = "statisticsTopRevenue", blockHandler = "statisticsTopBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取热门车次排行-收入")
    public Result<Object> getTopTrainsByRevenue(
            @RequestParam(defaultValue = "10") Integer topN,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getTopTrainsByRevenue(topN, startDate, endDate);
    }

    /**
     * 查询热门路线排行。
     */
    @GetMapping("/top-routes")
    @SentinelResource(value = "statisticsTopRoutes", blockHandler = "statisticsTopBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取热门路线排行")
    public Result<Object> getTopRoutes(
            @RequestParam(defaultValue = "10") Integer topN,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getTopRoutes(topN, startDate, endDate);
    }

    /**
     * 查询座位类型统计。
     */
    @GetMapping("/seat-type")
    @SentinelResource(value = "statisticsSeatType", blockHandler = "statisticsDateRangeBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取座位类型销售统计")
    public Result<Object> getSeatTypeStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getSeatTypeStatistics(startDate, endDate);
    }

    /**
     * 查询退票统计。
     */
    @GetMapping("/refund")
    @SentinelResource(value = "statisticsRefund", blockHandler = "statisticsDateRangeBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取退票统计")
    public Result<Object> getRefundStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getRefundStatistics(startDate, endDate);
    }

    /**
     * 查询改签统计。
     */
    @GetMapping("/change")
    @SentinelResource(value = "statisticsChange", blockHandler = "statisticsDateRangeBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取改签统计")
    public Result<Object> getChangeStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getChangeStatistics(startDate, endDate);
    }

    /**
     * 查询乘客统计。
     */
    @GetMapping("/passenger")
    @SentinelResource(value = "statisticsPassenger", blockHandler = "statisticsDateRangeBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR')")
    @Operation(summary = "获取乘客统计分析")
    public Result<Object> getPassengerStatistics(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {
        return statisticsService.getPassengerStatistics(startDate, endDate);
    }

    /**
     * 日期范围统计限流处理。
     */
    public static Result<Object> statisticsDateRangeBlockHandler(Date startDate, Date endDate, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 车次日期范围统计限流处理。
     */
    public static Result<Object> statisticsTrainDateRangeBlockHandler(Integer trainId, Date startDate, Date endDate, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 无参数统计限流处理。
     */
    public static Result<Object> statisticsNoArgBlockHandler(BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 趋势统计限流处理。
     */
    public static Result<Object> statisticsDaysBlockHandler(Integer days, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 排行统计限流处理。
     */
    public static Result<Object> statisticsTopBlockHandler(Integer topN, Date startDate, Date endDate, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
