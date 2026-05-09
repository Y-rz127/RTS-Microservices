package com.ticket.sales.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ticket.api.feign.TrainFeignClient;
import com.ticket.model.entity.Ticket;
import com.ticket.model.entity.Train;
import com.ticket.model.response.Result;
import com.ticket.sales.mapper.TicketMapper;
import com.ticket.sales.service.HotTrainRankingService;
import com.ticket.sales.service.SeatCacheService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 热点车次控制器。
 */
@Slf4j
@RestController
@RequestMapping("/api/hot")
@Tag(name = "热点车次管理")
public class HotTrainController {

    @Resource
    private SeatCacheService seatCacheService;

    @Resource
    private TicketMapper ticketMapper;

    @Resource
    private TrainFeignClient trainFeignClient;

    @Resource
    private HotTrainRankingService hotTrainRankingService;

    /**
     * 查询热点车次排行。
     */
    @GetMapping("/ranking")
    @Operation(summary = "热点车次排行榜（按售票次数）")
    public Result<List<Map<String, Object>>> getHotTrainRanking(
            @RequestParam(defaultValue = "10") int topN,
            @RequestParam(required = false) String travelDate,
            @RequestParam(defaultValue = "false") boolean forceRefresh) {

        long startTime = System.currentTimeMillis();

        try {
            // 默认使用今天日期
            String queryDate = travelDate;
            if (queryDate == null || queryDate.isEmpty()) {
                queryDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
            }

            // 从 Redis ZSET 获取排行榜数据
            List<Map<String, Object>> rankingList = hotTrainRankingService.getHotTrainRanking(queryDate, topN);

            if (rankingList.isEmpty()) {
                return Result.success(new ArrayList<>(), "暂无热点车次数据");
            }

            // 构建返回数据，关联车次信息和余票
            List<Map<String, Object>> hotTrains = new ArrayList<>();

            for (Map<String, Object> ranking : rankingList) {
                Object trainIdObj = ranking.get("trainId");
                Integer trainId = trainIdObj instanceof String ? Integer.parseInt((String) trainIdObj) : (Integer) trainIdObj;
                Object salesCountObj = ranking.get("salesCount");
                Long salesCount = salesCountObj instanceof Number ? ((Number) salesCountObj).longValue() : Long.parseLong(salesCountObj.toString());

                Result<Train> trainRes = trainFeignClient.getTrainById(trainId);
                Train train = trainRes.getData();

                Map<String, Object> trainInfo = new HashMap<>();
                trainInfo.put("trainId", trainId);
                trainInfo.put("travelDate", queryDate);
                trainInfo.put("salesCount", salesCount);

                if (train != null) {
                    trainInfo.put("trainNumber", train.getTrainNumber());
                    trainInfo.put("trainType", train.getTrainType());
                    trainInfo.put("startStation", train.getStartStation());
                    trainInfo.put("endStation", train.getEndStation());
                    trainInfo.put("departureTime", train.getDepartureTime() != null ?
                            train.getDepartureTime().toString() : null);
                    trainInfo.put("arrivalTime", train.getArrivalTime() != null ?
                            train.getArrivalTime().toString() : null);
                    trainInfo.put("basePrice", train.getBasePrice());
                } else {
                    trainInfo.put("trainNumber", "未知");
                    trainInfo.put("startStation", "");
                    trainInfo.put("endStation", "");
                }

                // 强制刷新时先清理余票缓存，确保数据最新
                if (forceRefresh) {
                    seatCacheService.clearSeatCache(trainId, queryDate);
                }

                // 获取余票数量（优先从缓存读取，未命中则查库并写入缓存）
                int availableSeats = seatCacheService.getAvailableSeatCount(trainId, queryDate, null);
                trainInfo.put("availableSeats", availableSeats);
                trainInfo.put("isHot", salesCount >= 5);

                // 主动预热座位详情缓存（乘客点击时直接从Redis读取）
                seatCacheService.getSeatAvailability(trainId, queryDate);

                hotTrains.add(trainInfo);
            }

            long responseTime = System.currentTimeMillis() - startTime;
            log.info("热点车次排行榜(从Redis)查询完成: 共{}条, 耗时{}ms", hotTrains.size(), responseTime);

            return Result.success(hotTrains, "查询成功");

        } catch (Exception e) {
            log.error("获取热点车次排行榜失败", e);
            return Result.error("获取热点车次排行榜失败：" + e.getMessage());
        }
    }

    /**
     * 按日期查询热点车次。
     */
    @GetMapping("/by-date")
    @Operation(summary = "按日期查询热点车次")
    public Result<List<Map<String, Object>>> getHotTrainsByDate(
            @RequestParam String travelDate) {
        return getHotTrainRanking(10, travelDate, false);
    }

    /**
     * 查询热点车次座位详情。
     */
    @GetMapping("/seats")
    @Operation(summary = "查询热点车次座位详情（优先Redis缓存）")
    public Result<List<Map<String, java.io.Serializable>>> getHotTrainSeatDetails(
            @RequestParam Integer trainId,
            @RequestParam String travelDate) {
        try {
            return Result.success(seatCacheService.getSeatAvailability(trainId, travelDate));
        } catch (Exception e) {
            log.error("查询热点车次座位详情失败, trainId={}, travelDate={}", trainId, travelDate, e);
            return Result.error("查询热点车次座位详情失败：" + e.getMessage());
        }
    }
}
