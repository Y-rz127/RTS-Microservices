package com.ticket.train.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ticket.api.feign.SalesFeignClient;
import com.ticket.model.entity.Train;
import com.ticket.model.response.Result;
import com.ticket.train.mapper.TrainMapper;
import com.ticket.train.service.StatisticsService;
import org.springframework.stereotype.Service;
import jakarta.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 统计服务实现类。
 */
@Service
public class StatisticsServiceImpl implements StatisticsService {

    @Resource
    private TrainMapper trainMapper;

    @Resource
    private SalesFeignClient salesFeignClient;

    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * 格式化日期。
     */
    private String fmt(Date date) {
        return date == null ? null : SDF.format(date);
    }

    /**
     * 获取车票销售统计。
     */
    @Override
    public Result<Object> getTicketSalesStatistics(Date startDate, Date endDate) {
        return salesFeignClient.getTicketCount(fmt(startDate), fmt(endDate), null, null);
    }

    /**
     * 获取车次车票销售统计。
     */
    @Override
    public Result<Object> getTrainTicketSalesStatistics(Integer trainId, Date startDate, Date endDate) {
        return salesFeignClient.getTicketCount(fmt(startDate), fmt(endDate), trainId, null);
    }

    /**
     * 获取收入统计。
     */
    @Override
    public Result<Object> getRevenueStatistics(Date startDate, Date endDate) {
        return salesFeignClient.getRevenue(fmt(startDate), fmt(endDate), null);
    }

    /**
     * 获取车次收入统计。
     */
    @Override
    public Result<Object> getTrainRevenueStatistics(Integer trainId, Date startDate, Date endDate) {
        return salesFeignClient.getRevenue(fmt(startDate), fmt(endDate), trainId);
    }

    /**
     * 获取仪表盘概览。
     */
    @Override
    public Result<Object> getDashboardOverview() {
        Result<Object> salesDashboard = salesFeignClient.getSalesDashboard();
        long trainCount = trainMapper.selectCount(null);
        long activeTrainCount = trainMapper.selectCount(
                new LambdaQueryWrapper<Train>().eq(Train::getStatus, 1));
        if (salesDashboard.getCode() == 200 && salesDashboard.getData() instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> data = (Map<String, Object>) salesDashboard.getData();
            data.put("trainCount", trainCount);
            data.put("activeTrainCount", activeTrainCount);
            return Result.success(data);
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("trainCount", trainCount);
        data.put("activeTrainCount", activeTrainCount);
        return Result.success(data);
    }

    /**
     * 获取销售趋势。
     */
    @Override
    public Result<Object> getSalesTrend(Integer days) {
        return salesFeignClient.getSalesTrend(days);
    }

    /**
     * 获取收入趋势。
     */
    @Override
    public Result<Object> getRevenueTrend(Integer days) {
        return salesFeignClient.getSalesTrend(days);
    }

    /**
     * 获取按销量排序的热门车次。
     */
    @Override
    public Result<Object> getTopTrainsBySales(Integer topN, Date startDate, Date endDate) {
        Result<Object> res = salesFeignClient.getTopTrains(topN, fmt(startDate), fmt(endDate), "count");
        if (res.getCode() == 200 && res.getData() instanceof List) {
            enrichTopTrains((List<?>) res.getData());
        }
        return res;
    }

    /**
     * 获取按收入排序的热门车次。
     */
    @Override
    public Result<Object> getTopTrainsByRevenue(Integer topN, Date startDate, Date endDate) {
        Result<Object> res = salesFeignClient.getTopTrains(topN, fmt(startDate), fmt(endDate), "revenue");
        if (res.getCode() == 200 && res.getData() instanceof List) {
            enrichTopTrains((List<?>) res.getData());
        }
        return res;
    }

    /**
     * 获取热门路线。
     */
    @Override
    public Result<Object> getTopRoutes(Integer topN, Date startDate, Date endDate) {
        Result<Object> res = salesFeignClient.getTopTrains(topN, fmt(startDate), fmt(endDate), "count");
        if (res.getCode() == 200 && res.getData() instanceof List) {
            enrichTopTrains((List<?>) res.getData());
        }
        return res;
    }

    /**
     * 获取座位类型统计。
     */
    @Override
    public Result<Object> getSeatTypeStatistics(Date startDate, Date endDate) {
        return salesFeignClient.getTicketCount(fmt(startDate), fmt(endDate), null, null);
    }

    /**
     * 获取退票统计。
     */
    @Override
    public Result<Object> getRefundStatistics(Date startDate, Date endDate) {
        return salesFeignClient.getRefundStats(fmt(startDate), fmt(endDate));
    }

    /**
     * 获取改签统计。
     */
    @Override
    public Result<Object> getChangeStatistics(Date startDate, Date endDate) {
        return salesFeignClient.getChangeStats(fmt(startDate), fmt(endDate));
    }

    /**
     * 获取乘客统计。
     */
    @Override
    public Result<Object> getPassengerStatistics(Date startDate, Date endDate) {
        return salesFeignClient.getPassengerStats(fmt(startDate), fmt(endDate));
    }

    /**
     * 丰富热门车次数据。
     */
    @SuppressWarnings("unchecked")
    private void enrichTopTrains(List<?> list) {
        for (Object item : list) {
            if (item instanceof Map) {
                Map<String, Object> map = (Map<String, Object>) item;
                Object trainIdObj = map.get("trainId");
                if (trainIdObj instanceof Number) {
                    Train train = trainMapper.selectById(((Number) trainIdObj).intValue());
                    if (train != null) {
                        map.put("trainNumber", train.getTrainNumber());
                        map.put("trainType", train.getTrainType());
                        map.put("startStation", train.getStartStation());
                        map.put("endStation", train.getEndStation());
                    }
                }
            }
        }
    }
}
