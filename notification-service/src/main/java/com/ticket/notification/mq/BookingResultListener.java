package com.ticket.notification.mq;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ticket.constant.MqConstants;
import com.ticket.model.dto.BookingResultEvent;
import com.ticket.notification.websocket.TicketWebSocketHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * 购票结果监听器。
 */
@Slf4j
@Component
public class BookingResultListener {

    private static final String BUSY_MESSAGE = "系统繁忙，购票结果通知稍后重试";

    private final TicketWebSocketHandler webSocketHandler;
    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());

    public BookingResultListener(TicketWebSocketHandler webSocketHandler) {
        this.webSocketHandler = webSocketHandler;
    }

    /**
     * 处理购票结果消息。
     */
    @RabbitListener(queues = MqConstants.BOOKING_RESULT_QUEUE)
    @SentinelResource(value = "bookingResultListener", blockHandler = "handleBookingResultBlockHandler")
    public void handleBookingResult(String payload) {
        try {
            BookingResultEvent event = objectMapper.readValue(payload, BookingResultEvent.class);
            webSocketHandler.pushBookingResultFlexible(event.getUserId(), event.getResult());
        } catch (Exception e) {
            log.error("消费失败", e);
        }
    }

    /**
     * 处理购票结果限流。
     */
    public void handleBookingResultBlockHandler(String payload, BlockException ex) {
        log.warn(BUSY_MESSAGE);
    }
}
