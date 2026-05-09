package com.ticket.model.dto;

import com.ticket.model.request.BookingRequest;
import com.ticket.model.request.GroupBookingRequest;
import com.ticket.model.request.TicketChangeRequest;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.concurrent.CompletableFuture;

/**
 * 异步抢票任务封装
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AsyncBookingTask {

    /**
     * 任务ID（UUID）
     */
    private String taskId;

    /**
     * 任务类型：SINGLE-单人，GROUP-团体
     */
    private String taskType;

    /**
     * 单人购票请求
     */
    private BookingRequest singleRequest;

    /**
     * 团体购票请求
     */
    private GroupBookingRequest groupRequest;

    /**
     * 改签请求
     */
    private TicketChangeRequest changeRequest;

    /**
     * 提交时间（用于计算等待时长）
     */
    private LocalDateTime submitTime;

    /**
     * 用户ID（用于结果推送）
     */
    private Integer userId;

    /**
     * 未来结果（用于异步回调）
     */
    private transient CompletableFuture<Object> future;

    /**
     * 任务超时时间（秒）
     */
    private Integer timeoutSeconds;

    /**
     * 重试次数
     */
    private Integer retryCount;

    public static AsyncBookingTask single(String taskId, BookingRequest request, Integer userId) {
        return AsyncBookingTask.builder()
                .taskId(taskId)
                .taskType("SINGLE")
                .singleRequest(request)
                .userId(userId)
                .submitTime(LocalDateTime.now())
                .timeoutSeconds(30) // 默认30秒超时
                .retryCount(0)
                .build();
    }

    public static AsyncBookingTask group(String taskId, GroupBookingRequest request, Integer userId) {
        return AsyncBookingTask.builder()
                .taskId(taskId)
                .taskType("GROUP")
                .groupRequest(request)
                .userId(userId)
                .submitTime(LocalDateTime.now())
                .timeoutSeconds(60) // 团体票60秒超时
                .retryCount(0)
                .build();
    }

    public static AsyncBookingTask change(String taskId, TicketChangeRequest request, Integer userId) {
        return AsyncBookingTask.builder()
                .taskId(taskId)
                .taskType("CHANGE")
                .changeRequest(request)
                .userId(userId)
                .submitTime(LocalDateTime.now())
                .timeoutSeconds(45) // 改签45秒超时
                .retryCount(0)
                .build();
    }

    /**
     * 计算等待时长（秒）
     */
    public long getWaitSeconds() {
        return java.time.Duration.between(submitTime, LocalDateTime.now()).getSeconds();
    }

    /**
     * 是否超时
     */
    public boolean isTimeout() {
        return getWaitSeconds() > timeoutSeconds;
    }
}
