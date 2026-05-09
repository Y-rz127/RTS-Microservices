package com.ticket.userauth.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.OperationLog;
import com.ticket.model.entity.User;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;

/**
 * 操作日志服务接口。
 */
public interface OperationLogService extends IService<OperationLog> {
    /**
     * 保存操作日志。
     */
    void saveLog(OperationLog log);

    /**
     * 分页查询操作日志。
     */
    Result<Object> getLogPage(PageRequest pageRequest, Integer userId, String operation,
                             String module, String startTime, String endTime);

    /**
     * 清理过期日志。
     */
    Result<Boolean> clearExpiredLogs(Integer days);

    /**
     * 获取今日统计。
     */
    Result<Object> getTodayStatistics();

    /**
     * 根据用户ID获取用户信息。
     */
    User getUserById(Integer userId);
}
