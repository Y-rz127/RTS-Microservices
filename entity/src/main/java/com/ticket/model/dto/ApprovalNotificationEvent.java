package com.ticket.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 审批通知事件
 * 用于 RabbitMQ 中传递审批结果通知
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ApprovalNotificationEvent {

    private Integer userId;

    private Integer requestId;

    private String requestType;

    private String message;

    private boolean success;

    private long createdAt;

}
