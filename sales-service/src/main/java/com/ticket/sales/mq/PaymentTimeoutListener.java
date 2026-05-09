package com.ticket.sales.mq;

import com.ticket.constant.MqConstants;
import com.ticket.model.entity.Order;
import com.ticket.sales.service.OrderService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

/**
 * 支付超时监听器。
 */
@Slf4j
@Component
public class PaymentTimeoutListener {

    @Resource
    private OrderService orderService;

    /**
     * 处理支付超时消息。
     */
    @RabbitListener(queues = MqConstants.PAYMENT_TIMEOUT_QUEUE)
    public void handlePaymentTimeout(String payload) {
        try {
            Integer orderId = Integer.valueOf(payload);
            Order order = orderService.getById(orderId);
            if (order == null) {
                log.warn("支付超时订单不存在, orderId={}", orderId);
                return;
            }
            if (!"UNPAID".equals(order.getOrderStatus()) && !"PENDING".equals(order.getOrderStatus())) {
                log.info("支付超时忽略非未支付订单, orderId={}, status={}", orderId, order.getOrderStatus());
                return;
            }
            orderService.cancelOrder(orderId);
            log.info("支付超时自动取消订单成功, orderId={}", orderId);
        } catch (Exception e) {
            log.error("支付超时自动取消订单失败, payload={}", payload, e);
        }
    }
}
