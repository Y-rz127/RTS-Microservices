package com.ticket.userauth.controller;

import com.ticket.model.entity.SystemConfig;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.userauth.service.SystemConfigService;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

/**
 * 系统配置控制器
 */
@RestController
@RequestMapping("/api/config")
@Tag(name = "系统配置管理")
public class SystemConfigController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（系统配置限流）";

    @Resource
    private SystemConfigService systemConfigService;

    /**
     * 分页查询系统配置。
     */
    @GetMapping("/page")
    @SentinelResource(value = "configPage", blockHandler = "configPageBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "分页查询系统配置")
    public Result<Object> getConfigPage(PageRequest pageRequest,
                                        @RequestParam(required = false) String configKey,
                                        @RequestParam(required = false) String configType) {
        return systemConfigService.getConfigPage(pageRequest, configKey, configType);
    }

    /**
     * 查询全部系统配置。
     */
    @GetMapping("/all")
    @SentinelResource(value = "configAll", blockHandler = "configAllBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "获取所有配置")
    public Result<Object> getAllConfigs() {
        return systemConfigService.getAllConfigs();
    }

    /**
     * 按配置键查询配置值。
     */
    @GetMapping("/get/{configKey}")
    @SentinelResource(value = "configGet", blockHandler = "configGetBlockHandler")
    @Operation(summary = "根据配置键获取值")
    public Result<String> getConfigValue(@PathVariable String configKey) {
        return systemConfigService.getConfigValue(configKey);
    }

    /**
     * 按配置类型查询配置。
     */
    @GetMapping("/type/{configType}")
    @SentinelResource(value = "configType", blockHandler = "configTypeBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "根据类型获取配置")
    public Result<Object> getConfigsByType(@PathVariable String configType) {
        return systemConfigService.getConfigsByType(configType);
    }

    /**
     * 新增系统配置。
     */
    @PostMapping("/add")
    @SentinelResource(value = "configAdd", blockHandler = "configAddBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "新增配置")
    public Result<SystemConfig> addConfig(@RequestBody SystemConfig config) {
        return systemConfigService.addConfig(config);
    }

    /**
     * 更新系统配置。
     */
    @PutMapping("/update")
    @SentinelResource(value = "configUpdate", blockHandler = "configUpdateBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "更新配置")
    public Result<SystemConfig> updateConfig(@RequestBody SystemConfig config) {
        return systemConfigService.updateConfig(config);
    }

    /**
     * 删除系统配置。
     */
    @DeleteMapping("/delete/{configId}")
    @SentinelResource(value = "configDelete", blockHandler = "configDeleteBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "删除配置")
    public Result<Boolean> deleteConfig(@PathVariable Integer configId) {
        return systemConfigService.deleteConfig(configId);
    }

    /**
     * 批量更新系统配置。
     */
    @PutMapping("/batchUpdate")
    @SentinelResource(value = "configBatchUpdate", blockHandler = "configBatchUpdateBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "批量更新配置")
    public Result<Boolean> batchUpdateConfigs(@RequestBody SystemConfig[] configs) {
        return systemConfigService.batchUpdateConfigs(configs);
    }

    /**
     * 分页查询配置限流处理。
     */
    public static Result<Object> configPageBlockHandler(PageRequest pageRequest, String configKey, String configType, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 查询全部配置限流处理。
     */
    public static Result<Object> configAllBlockHandler(BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 查询配置值限流处理。
     */
    public static Result<String> configGetBlockHandler(String configKey, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 按类型查询配置限流处理。
     */
    public static Result<Object> configTypeBlockHandler(String configType, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 新增配置限流处理。
     */
    public static Result<SystemConfig> configAddBlockHandler(SystemConfig config, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 更新配置限流处理。
     */
    public static Result<SystemConfig> configUpdateBlockHandler(SystemConfig config, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 删除配置限流处理。
     */
    public static Result<Boolean> configDeleteBlockHandler(Integer configId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 批量更新配置限流处理。
     */
    public static Result<Boolean> configBatchUpdateBlockHandler(SystemConfig[] configs, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
