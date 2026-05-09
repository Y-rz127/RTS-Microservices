package com.ticket.sales.controller;

import com.ticket.annotation.Log;
import com.ticket.model.request.BookingRequest;
import com.ticket.model.request.GroupBookingRequest;
import com.ticket.model.response.AsyncBookingResponse;
import com.ticket.model.response.BookingResult;
import com.ticket.model.response.Result;
import com.ticket.sales.service.AsyncTicketService;
import com.ticket.utils.RequestUserContext;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;

/**
 * 异步抢票控制器。
 */
@Slf4j
@RestController
@RequestMapping("/api/async/ticket")
@Tag(name = "异步抢票管理")
public class AsyncTicketController {

    @Resource
    private AsyncTicketService asyncTicketService;

    @Resource
    private RequestUserContext requestUserContext;

    /**
     * 提交单人异步抢票。
     */
    @PostMapping("/sell")
    @Log(module = "异步抢票", operation = "单人抢票")
    public Result<AsyncBookingResponse> asyncSellTicket(@RequestBody BookingRequest request) {
        Integer userId = getCurrentUserId();
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        return asyncTicketService.asyncSellTicket(request, userId);
    }

    /**
     * 提交团体异步抢票。
     */
    @PostMapping("/group/sell")
    @Log(module = "异步抢票", operation = "团体抢票")
    public Result<AsyncBookingResponse> asyncGroupSellTicket(@RequestBody GroupBookingRequest request) {
        Integer userId = getCurrentUserId();
        if (userId == null) {
            return Result.error(401, "未登录");
        }
        return asyncTicketService.asyncGroupSellTicket(request, userId);
    }

    /**
     * 查询抢票结果。
     */
    @GetMapping("/result/{queueId}")
    public Result<Object> getBookingResult(@PathVariable String queueId) {
        BookingResult result = asyncTicketService.getBookingResult(queueId);

        if (result == null) {
            // 还在处理中，返回排队信息
            Integer position = asyncTicketService.getQueuePosition(queueId);
            Map<String, Object> data = new HashMap<>();
            data.put("queueId", queueId);
            data.put("status", "PROCESSING");
            data.put("queuePosition", position);
            data.put("message", position > 0 ? "排队中，当前位置: " + position : "正在处理中...");
            return Result.success(data, "处理中"); // 202 Accepted
        }

        return Result.success(result);
    }

    /**
     * 查询排队位置。
     */
    @GetMapping("/position/{queueId}")
    public Result<Map<String, Object>> getQueuePosition(@PathVariable String queueId) {
        Integer position = asyncTicketService.getQueuePosition(queueId);

        Map<String, Object> data = new HashMap<>();
        data.put("queueId", queueId);
        data.put("position", position);

        if (position == -1) {
            // 可能已完成，尝试查结果
            BookingResult result = asyncTicketService.getBookingResult(queueId);
            if (result != null && !"FAILED".equals(result.getStatus())) {
                data.put("status", "COMPLETED");
                data.put("result", result);
            } else {
                data.put("status", "NOT_FOUND");
            }
        } else if (position == 0) {
            data.put("status", "PROCESSING");
        } else {
            data.put("status", "PENDING");
            data.put("estimatedWaitSeconds", position * 2); // 预估每个任务2秒
        }

        return Result.success(data);
    }

    /**
     * 取消排队任务。
     */
    @DeleteMapping("/task/{queueId}")
    @Log(module = "异步抢票", operation = "取消排队")
    public Result<Boolean> cancelTask(@PathVariable String queueId) {
        return asyncTicketService.cancelTask(queueId);
    }

    /**
     * 获取当前用户编号。
     */
    private Integer getCurrentUserId() {
        return requestUserContext.getCurrentUserId();
    }
}
