package com.ticket.userauth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.model.entity.OperationLog;
import com.ticket.model.entity.User;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.userauth.mapper.OperationLogMapper;
import com.ticket.userauth.service.OperationLogService;
import com.ticket.userauth.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import jakarta.annotation.Resource;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.Map;

/**
 * 操作日志服务实现类。
 */
@Service
@Slf4j
public class OperationLogServiceImpl extends ServiceImpl<OperationLogMapper, OperationLog> implements OperationLogService {

    @Resource
    private OperationLogMapper operationLogMapper;

    @Resource
    private UserService userService;

    /**
     * 保存操作日志。
     */
    @Override
    public void saveLog(OperationLog operationLog) {
        try {
            if (operationLog == null) return;
            if (operationLog.getCreatedAt() == null) operationLog.setCreatedAt(new Date());
            if (operationLog.getStatus() == null || operationLog.getStatus().isBlank()) operationLog.setStatus("SUCCESS");
            operationLogMapper.insert(operationLog);
        } catch (Exception e) {
            log.error("保存操作日志失败", e);
        }
    }

    /**
     * 分页查询操作日志。
     */
    @Override
    public Result<Object> getLogPage(PageRequest pageRequest, Integer userId, String operation,
                                     String module, String startTime, String endTime) {
        try {
            Page<OperationLog> page = new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize());
            LambdaQueryWrapper<OperationLog> wrapper = new LambdaQueryWrapper<>();
            if (userId != null) wrapper.eq(OperationLog::getUserId, userId);
            if (operation != null && !operation.isBlank()) wrapper.like(OperationLog::getOperation, operation);
            if (module != null && !module.isBlank()) wrapper.eq(OperationLog::getModule, module);
            if (startTime != null && !startTime.isBlank()) wrapper.ge(OperationLog::getCreatedAt, startTime);
            if (endTime != null && !endTime.isBlank()) wrapper.le(OperationLog::getCreatedAt, endTime);
            wrapper.orderByDesc(OperationLog::getCreatedAt);
            return Result.success(operationLogMapper.selectPage(page, wrapper));
        } catch (Exception e) {
            return Result.error("查询日志失败：" + e.getMessage());
        }
    }

    /**
     * 清除过期日志。
     */
    @Override
    @Transactional
    public Result<Boolean> clearExpiredLogs(Integer days) {
        try {
            LocalDateTime expireTime = LocalDateTime.now().minusDays(days);
            LambdaQueryWrapper<OperationLog> wrapper = new LambdaQueryWrapper<>();
            wrapper.lt(OperationLog::getCreatedAt, expireTime);
            int count = operationLogMapper.delete(wrapper);
            return count > 0 ? Result.success(true, "成功清除 " + count + " 条过期日志") :
                               Result.success(false, "暂无过期日志可清除");
        } catch (Exception e) {
            return Result.error("清除日志失败：" + e.getMessage());
        }
    }

    /**
     * 获取今日统计。
     */
    @Override
    public Result<Object> getTodayStatistics() {
        try {
            LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
            long total = operationLogMapper.selectCount(new LambdaQueryWrapper<OperationLog>()
                    .ge(OperationLog::getCreatedAt, startOfDay));
            long success = operationLogMapper.selectCount(new LambdaQueryWrapper<OperationLog>()
                    .ge(OperationLog::getCreatedAt, startOfDay).eq(OperationLog::getStatus, "SUCCESS"));
            long failure = total - success;
            String rate = total > 0 ? String.format("%.2f%%", (double) success / total * 100) : "0%";
            return Result.success(Map.of(
                    "totalCount", total,
                    "successCount", success,
                    "failCount", failure,
                    "successRate", rate
            ));
        } catch (Exception e) {
            return Result.error("获取统计数据失败：" + e.getMessage());
        }
    }

    /**
     * 根据用户ID获取用户信息。
     */
    @Override
    public User getUserById(Integer userId) {
        try {
            return userService.getById(userId);
        } catch (Exception e) {
            log.error("根据用户ID获取用户信息失败: userId={}", userId, e);
            return null;
        }
    }
}
