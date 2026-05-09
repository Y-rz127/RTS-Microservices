package com.ticket.sales.controller;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.model.entity.Seat;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.sales.service.SeatService;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;

/**
 * 座位管理控制器。
 */
@RestController
@RequestMapping("/api/seats")
public class SeatController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（座位服务限流）";

    @Resource
    private SeatService seatService;

    /**
     * 查询座位布局。
     */
    @GetMapping("/layout")
    @SentinelResource(value = "seatLayout", blockHandler = "getLayoutBlockHandler")
    public Result<List<Seat>> getLayout(@RequestParam Integer trainId, @RequestParam String travelDate) {
        return seatService.getSeatLayout(trainId, travelDate);
    }

    /**
     * 查询可用座位。
     */
    @GetMapping("/available")
    @SentinelResource(value = "seatAvailable", blockHandler = "getAvailableBlockHandler")
    public Result<List<Seat>> getAvailable(@RequestParam Integer trainId, @RequestParam String seatType, @RequestParam String travelDate) {
        return seatService.getAvailableSeats(trainId, seatType, travelDate);
    }

    /**
     * 查询可用座位数量。
     */
    @GetMapping("/available-count")
    public Result<Integer> getAvailableCount(@RequestParam Integer trainId, @RequestParam String seatType) {
        return seatService.getAvailableSeatCount(trainId, seatType);
    }

    /**
     * 查询座位详情。
     */
    @GetMapping("/{seatId}")
    public Result<Seat> getSeatById(@PathVariable Integer seatId) {
        return seatService.getSeatById(seatId);
    }

    /**
     * 分页查询座位。
     */
    @GetMapping("/page")
    @SentinelResource(value = "seatPage", blockHandler = "getSeatPageBlockHandler")
    public Result<Object> getSeatPage(PageRequest pageRequest, @RequestParam(required = false) Integer trainId,
                                       @RequestParam(required = false) String seatType, @RequestParam(required = false) String status) {
        return seatService.getSeatPage(pageRequest, trainId, seatType, status);
    }

    /**
     * 查询座位布局限流处理。
     */
    public static Result<List<Seat>> getLayoutBlockHandler(Integer trainId, String travelDate, BlockException ex) {
        return Result.error("座位查询繁忙，请稍后刷新页面重试");
    }

    /**
     * 查询可用座位限流处理。
     */
    public static Result<List<Seat>> getAvailableBlockHandler(Integer trainId, String seatType, String travelDate, BlockException ex) {
        return Result.error("可用座位查询高峰期，建议稍后重试或选择其他车次");
    }

    /**
     * 分页查询座位限流处理。
     */
    public static Result<Object> getSeatPageBlockHandler(PageRequest pageRequest, Integer trainId, String seatType, String status, BlockException ex) {
        return Result.error("座位数据加载繁忙，请稍后重试");
    }

    /**
     * 生成车次座位。
     */
    @PostMapping("/generate")
    public Result<Boolean> generateSeatsForTrain(@RequestParam Integer trainId, @RequestParam String travelDate) {
        return seatService.generateSeatsForTrain(trainId, travelDate);
    }

    /**
     * 更新座位状态。
     */
    @PutMapping("/status")
    public Result<Boolean> updateSeatStatus(@RequestParam Integer seatId, @RequestParam String status) {
        return seatService.updateSeatStatus(seatId, status);
    }

    /**
     * 清理过期座位。
     */
    @PostMapping("/cleanup-expired")
    public Result<Integer> cleanupExpiredSeats() {
        return seatService.cleanupExpiredSeats();
    }
}
