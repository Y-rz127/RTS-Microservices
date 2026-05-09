package com.ticket.approval.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ticket.approval.service.ApprovalNotificationPublisher;
import com.ticket.constant.MqConstants;
import com.ticket.model.dto.ApprovalNotificationEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * 审批通知发布实现类。
 */
@Slf4j
@Service
public class ApprovalNotificationPublisherImpl implements ApprovalNotificationPublisher {

    private final RabbitTemplate rabbitTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${app.rabbitmq.enabled:false}")
    private boolean rabbitEnabled;

    public ApprovalNotificationPublisherImpl(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    /**
     * 发布审批通知到消息队列。
     */
    @Override
    public boolean publish(ApprovalNotificationEvent event) {
        if (!rabbitEnabled) {
            log.info("RabbitMQ 未启用，跳过消息发布: userId={}, requestId={}", event.getUserId(), event.getRequestId());
            return false;
        }
        try {
            String payload = objectMapper.writeValueAsString(event);
            rabbitTemplate.convertAndSend(
                    MqConstants.APPROVAL_NOTIFICATION_EXCHANGE,
                    MqConstants.APPROVAL_NOTIFICATION_ROUTING_KEY,
                    payload
            );
            log.info("RabbitMQ 审批通知已发送: userId={}, requestId={}, success={}",
                    event.getUserId(), event.getRequestId(), event.isSuccess());
            return true;
        } catch (Exception e) {
            log.error("RabbitMQ 审批通知发送失败: userId={}, requestId={}",
                    event.getUserId(), event.getRequestId(), e);
            return false;
        }
    }
}
