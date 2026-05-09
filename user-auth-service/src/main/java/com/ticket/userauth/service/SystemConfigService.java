package com.ticket.userauth.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.SystemConfig;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;

/**
 * 系统配置服务接口。
 */
public interface SystemConfigService extends IService<SystemConfig> {
    /**
     * 分页查询系统配置。
     */
    Result<Object> getConfigPage(PageRequest pageRequest, String configKey, String configType);

    /**
     * 获取所有系统配置。
     */
    Result<Object> getAllConfigs();

    /**
     * 根据配置键获取配置值。
     */
    Result<String> getConfigValue(String configKey);

    /**
     * 根据配置类型获取配置列表。
     */
    Result<Object> getConfigsByType(String configType);

    /**
     * 添加系统配置。
     */
    Result<SystemConfig> addConfig(SystemConfig config);

    /**
     * 更新系统配置。
     */
    Result<SystemConfig> updateConfig(SystemConfig config);

    /**
     * 删除系统配置。
     */
    Result<Boolean> deleteConfig(Integer configId);

    /**
     * 批量更新系统配置。
     */
    Result<Boolean> batchUpdateConfigs(SystemConfig[] configs);
}
