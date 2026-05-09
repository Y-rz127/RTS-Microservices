package com.ticket.sales.service.impl;

import com.ticket.model.entity.Order;
import com.ticket.sales.service.OrderService;
import com.ticket.sales.service.PaymentService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * 支付服务实现类。
 */
@Slf4j
@Service
public class PaymentServiceImpl implements PaymentService {

    @Resource
    private OrderService orderService;

    private static final long PAYMENT_TIMEOUT_MILLIS = 15 * 60 * 1000L;

    /**
     * 创建支付会话
     */
    @Override
    public Map<String, Object> createPayment(Integer orderId) {
        Order order = orderService.getById(orderId);
        if (order == null) throw new RuntimeException("订单不存在");
        if ("CANCELLED".equals(order.getOrderStatus())) {
            throw new RuntimeException("订单已超时取消");
        }
        if ("PAID".equals(order.getOrderStatus())) {
            throw new RuntimeException("订单已支付，请勿重复支付");
        }
        if (!"UNPAID".equals(order.getOrderStatus()) && !"PENDING".equals(order.getOrderStatus())) {
            throw new RuntimeException("当前订单状态不允许支付");
        }
        String paymentId = UUID.randomUUID().toString().replace("-", "");
        Date createdAt = order.getCreatedAt();
        long expireAt = (createdAt != null ? createdAt.getTime() : System.currentTimeMillis()) + PAYMENT_TIMEOUT_MILLIS;
        Map<String, Object> resp = new HashMap<>();
        resp.put("paymentId", paymentId);
        resp.put("orderId", orderId);
        resp.put("expireAt", expireAt);
        log.info("已创建模拟支付会话: orderId={}, paymentId={}, expireAt={}", orderId, paymentId, expireAt);
        return resp;
    }

    /**
     * 模拟支付成功
     */
    @Override
    public boolean mockSuccess(String paymentId) {
        return true;
    }
}
