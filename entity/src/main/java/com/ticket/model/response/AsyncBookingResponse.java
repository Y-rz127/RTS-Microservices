package com.ticket.model.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 异步抢票响应
 * 立即返回排队号，客户端通过轮询或WebSocket获取最终結果
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AsyncBookingResponse {

    /**
     * 排队号（UUID）
     */
    private String queueId;

    /**
     * 状态：PENDING-排队中，PROCESSING-处理中，SUCCESS-成功，FAILED-失败
     */
    private String status;

    /**
     * 预计等待时间（秒）
     */
    private Integer estimatedWaitTime;

    /**
     * 当前排队位置
     */
    private Integer queuePosition;

    /**
     * 提交时间
     */
    private LocalDateTime submitTime;

    /**
     * 提示信息
     */
    private String message;

    /**
     * 创建排队中响应
     */
    public static AsyncBookingResponse pending(String queueId, int position) {
        return AsyncBookingResponse.builder()
                .queueId(queueId)
                .status("PENDING")
                .queuePosition(position)
                .estimatedWaitTime(position * 2) // 预估每个任务2秒
                .submitTime(LocalDateTime.now())
                .message("已进入抢票队列，当前排队位置: " + position)
                .build();
    }

    /**
     * 创建处理中响应
     */
    public static AsyncBookingResponse processing(String queueId) {
        return AsyncBookingResponse.builder()
                .queueId(queueId)
                .status("PROCESSING")
                .estimatedWaitTime(3)
                .submitTime(LocalDateTime.now())
                .message("正在处理抢票请求...")
                .build();
    }
}
