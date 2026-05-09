package com.ticket.sales.controller;

import com.ticket.model.response.Result;
import com.ticket.sales.service.OrderService;
import com.ticket.sales.service.PaymentService;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.Map;

/**
 * 支付控制器。
 */
@RestController
@RequestMapping("/api/pay")
public class PaymentController {

    @Resource
    private PaymentService paymentService;

    @Resource
    private OrderService orderService;

    /**
     * 创建支付会话。
     */
    @PostMapping("/create")
    public Result<Map<String, Object>> createPayment(@RequestBody Map<String, Integer> req) {
        try {
            return Result.success(paymentService.createPayment(req.get("orderId")));
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 模拟支付成功。
     */
    @PostMapping("/mock/success")
    public Result<Boolean> mockSuccess(@RequestBody Map<String, Integer> req) {
        Integer orderId = req.get("orderId");
        return orderService.payOrder(orderId, "MOCK");
    }
}
