package com.ticket.userauth.controller;

import com.ticket.model.entity.OperationLog;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.userauth.service.OperationLogService;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

/**
 * 操作日志控制器
 */
@RestController
@RequestMapping("/api/log")
@Tag(name = "操作日志管理", description = "系统操作日志的查询和管理")
public class OperationLogController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（操作日志限流）";

    @Resource
    private OperationLogService operationLogService;

    /**
     * 保存操作日志
     */
    @PostMapping("/save")
    @SentinelResource(value = "logSave", blockHandler = "saveLogBlockHandler")
    @Operation(summary = "保存操作日志")
    public Result<Boolean> saveLog(@RequestBody OperationLog log) {
        operationLogService.saveLog(log);
        return Result.success(true);
    }

    /**
     * 分页查询操作日志（管理员权限）
     */
    @GetMapping("/page")
    @SentinelResource(value = "logPage", blockHandler = "getLogPageBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "分页查询操作日志")
    public Result<Object> getLogPage(PageRequest pageRequest,
                                     @RequestParam(required = false) Integer userId,
                                     @RequestParam(required = false) String operation,
                                     @RequestParam(required = false) String module,
                                     @RequestParam(required = false) String startTime,
                                     @RequestParam(required = false) String endTime) {
        return operationLogService.getLogPage(pageRequest, userId, operation, module, startTime, endTime);
    }

    /**
     * 清除过期日志（管理员权限）
     */
    @DeleteMapping("/clearExpired")
    @SentinelResource(value = "logClearExpired", blockHandler = "clearExpiredLogsBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "清除过期日志")
    public Result<Boolean> clearExpiredLogs(@RequestParam Integer days) {
        return operationLogService.clearExpiredLogs(days);
    }

    /**
     * 根据用户ID查询操作日志
     */
    @GetMapping("/user/{userId}")
    @SentinelResource(value = "logUser", blockHandler = "getLogsByUserIdBlockHandler")
    @Operation(summary = "查询用户操作日志")
    public Result<Object> getLogsByUserId(@PathVariable Integer userId, PageRequest pageRequest) {
        return operationLogService.getLogPage(pageRequest, userId, null, null, null, null);
    }

    /**
     * 根据模块查询操作日志（管理员权限）
     */
    @GetMapping("/module/{module}")
    @SentinelResource(value = "logModule", blockHandler = "getLogsByModuleBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "查询模块操作日志")
    public Result<Object> getLogsByModule(@PathVariable String module, PageRequest pageRequest) {
        return operationLogService.getLogPage(pageRequest, null, null, module, null, null);
    }

    /**
     * 查询今日操作统计（管理员权限）
     */
    @GetMapping("/statistics/today")
    @SentinelResource(value = "logTodayStatistics", blockHandler = "getTodayStatisticsBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "今日操作统计")
    public Result<Object> getTodayStatistics() {
        return operationLogService.getTodayStatistics();
    }

    /**
     * 保存日志限流处理。
     */
    public static Result<Boolean> saveLogBlockHandler(OperationLog log, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 分页查询日志限流处理。
     */
    public static Result<Object> getLogPageBlockHandler(PageRequest pageRequest, Integer userId, String operation, String module, String startTime, String endTime, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 清理过期日志限流处理。
     */
    public static Result<Boolean> clearExpiredLogsBlockHandler(Integer days, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 按用户查询日志限流处理。
     */
    public static Result<Object> getLogsByUserIdBlockHandler(Integer userId, PageRequest pageRequest, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 按模块查询日志限流处理。
     */
    public static Result<Object> getLogsByModuleBlockHandler(String module, PageRequest pageRequest, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 今日统计限流处理。
     */
    public static Result<Object> getTodayStatisticsBlockHandler(BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
