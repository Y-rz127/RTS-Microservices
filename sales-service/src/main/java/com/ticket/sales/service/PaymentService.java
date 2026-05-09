package com.ticket.sales.service;

import com.ticket.model.response.Result;
import java.util.Map;

/**
 * 支付服务接口。
 */
public interface PaymentService {
    /**
     * 创建支付会话。
     */
    Map<String, Object> createPayment(Integer orderId);
    /**
     * 模拟支付成功。
     */
    boolean mockSuccess(String paymentId);
}
