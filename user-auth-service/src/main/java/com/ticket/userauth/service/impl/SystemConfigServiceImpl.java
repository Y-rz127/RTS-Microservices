package com.ticket.userauth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.model.entity.SystemConfig;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.userauth.mapper.SystemConfigMapper;
import com.ticket.userauth.service.SystemConfigService;
import org.springframework.stereotype.Service;

/**
 * 系统配置服务实现类。
 */
@Service
public class SystemConfigServiceImpl extends ServiceImpl<SystemConfigMapper, SystemConfig> implements SystemConfigService {

    /**
     * 分页查询系统配置。
     */
    @Override
    public Result<Object> getConfigPage(PageRequest pageRequest, String configKey, String configType) {
        LambdaQueryWrapper<SystemConfig> wrapper = new LambdaQueryWrapper<>();
        if (configKey != null && !configKey.isBlank()) {
            wrapper.like(SystemConfig::getConfigKey, configKey);
        }
        if (configType != null && !configType.isBlank()) {
            wrapper.eq(SystemConfig::getConfigType, configType);
        }
        wrapper.orderByDesc(SystemConfig::getCreatedAt);
        Page<SystemConfig> page = page(new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize()), wrapper);
        return Result.success(page);
    }

    /**
     * 获取所有系统配置。
     */
    @Override
    public Result<Object> getAllConfigs() {
        return Result.success(list());
    }

    /**
     * 根据配置键获取配置值。
     */
    @Override
    public Result<String> getConfigValue(String configKey) {
        SystemConfig config = getOne(new LambdaQueryWrapper<SystemConfig>()
                .eq(SystemConfig::getConfigKey, configKey)
                .eq(SystemConfig::getStatus, 1)
                .last("LIMIT 1"));
        if (config == null) {
            return Result.error("配置不存在");
        }
        return Result.success(config.getConfigValue());
    }

    /**
     * 根据配置类型获取配置列表。
     */
    @Override
    public Result<Object> getConfigsByType(String configType) {
        return Result.success(list(new LambdaQueryWrapper<SystemConfig>()
                .eq(SystemConfig::getConfigType, configType)
                .orderByAsc(SystemConfig::getConfigKey)));
    }

    /**
     * 新增系统配置。
     */
    @Override
    public Result<SystemConfig> addConfig(SystemConfig config) {
        long count = count(new LambdaQueryWrapper<SystemConfig>()
                .eq(SystemConfig::getConfigKey, config.getConfigKey()));
        if (count > 0) {
            return Result.error("配置键已存在");
        }
        if (config.getStatus() == null) {
            config.setStatus(1);
        }
        if (config.getIsSystem() == null) {
            config.setIsSystem(0);
        }
        save(config);
        return Result.success(config, "新增成功");
    }

    /**
     * 更新系统配置。
     */
    @Override
    public Result<SystemConfig> updateConfig(SystemConfig config) {
        if (config.getConfigId() == null) {
            return Result.error("配置ID不能为空");
        }
        SystemConfig existing = getById(config.getConfigId());
        if (existing == null) {
            return Result.error("配置不存在");
        }
        if (existing.getIsSystem() != null && existing.getIsSystem() == 1) {
            return Result.error("系统内置配置不允许修改");
        }
        updateById(config);
        return Result.success(config, "更新成功");
    }

    /**
     * 删除系统配置。
     */
    @Override
    public Result<Boolean> deleteConfig(Integer configId) {
        SystemConfig config = getById(configId);
        if (config == null) {
            return Result.error("配置不存在");
        }
        if (config.getIsSystem() != null && config.getIsSystem() == 1) {
            return Result.error("系统内置配置不允许删除");
        }
        return Result.success(removeById(configId));
    }

    /**
     * 批量更新系统配置。
     */
    @Override
    public Result<Boolean> batchUpdateConfigs(SystemConfig[] configs) {
        if (configs == null || configs.length == 0) {
            return Result.success(true);
        }
        for (SystemConfig config : configs) {
            if (config.getConfigId() == null || config.getConfigValue() == null) {
                continue;
            }
            update(new LambdaUpdateWrapper<SystemConfig>()
                    .eq(SystemConfig::getConfigId, config.getConfigId())
                    .set(SystemConfig::getConfigValue, config.getConfigValue())
                    .set(SystemConfig::getUpdatedAt, new java.util.Date()));
        }
        return Result.success(true, "批量更新成功");
    }
}
