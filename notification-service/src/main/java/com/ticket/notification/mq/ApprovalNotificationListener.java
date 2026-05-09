package com.ticket.notification.mq;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ticket.constant.MqConstants;
import com.ticket.model.dto.ApprovalNotificationEvent;
import com.ticket.notification.websocket.TicketWebSocketHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * 审批通知监听器。
 */
@Slf4j
@Component
public class ApprovalNotificationListener {

    private static final String BUSY_MESSAGE = "系统繁忙，审批通知稍后重试";

    private final TicketWebSocketHandler webSocketHandler;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public ApprovalNotificationListener(TicketWebSocketHandler webSocketHandler) {
        this.webSocketHandler = webSocketHandler;
    }

    /**
     * 处理审批通知消息。
     */
    @RabbitListener(queues = MqConstants.APPROVAL_NOTIFICATION_QUEUE)
    @SentinelResource(value = "approvalNotificationListener", blockHandler = "handleApprovalNotificationBlockHandler")
    public void handleApprovalNotification(String payload) {
        try {
            ApprovalNotificationEvent event = objectMapper.readValue(payload, ApprovalNotificationEvent.class);
            webSocketHandler.pushRefundNotification(event.getUserId().toString(), event.getMessage());
        } catch (Exception e) {
            log.error("消费失败", e);
        }
    }

    /**
     * 处理审批通知限流。
     */
    public void handleApprovalNotificationBlockHandler(String payload, BlockException ex) {
        log.warn(BUSY_MESSAGE);
    }
}
