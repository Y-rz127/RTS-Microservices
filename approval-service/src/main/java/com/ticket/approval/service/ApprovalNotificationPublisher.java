package com.ticket.approval.service;

import com.ticket.model.dto.ApprovalNotificationEvent;

/**
 * 审批通知发布接口。
 */
public interface ApprovalNotificationPublisher {
    /**
     * 发布审批通知。
     */
    boolean publish(ApprovalNotificationEvent event);
}
