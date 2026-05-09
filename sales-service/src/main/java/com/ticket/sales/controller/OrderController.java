package com.ticket.sales.controller;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.model.entity.Order;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.sales.service.OrderService;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;

/**
 * 订单管理控制器。
 */
@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（订单服务限流）";

    @Resource
    private OrderService orderService;

    /**
     * 创建订单。
     */
    @PostMapping
    public Result<Order> createOrder(@RequestBody Order order) {
        return orderService.createOrder(order);
    }

    /**
     * 支付订单。
     */
    @PostMapping("/pay/{orderId}")
    public Result<Boolean> payOrder(@PathVariable Integer orderId, @RequestParam String method) {
        return orderService.payOrder(orderId, method);
    }

    /**
     * 取消订单。
     */
    @PostMapping("/cancel/{orderId}")
    public Result<Boolean> cancelOrder(@PathVariable Integer orderId) {
        return orderService.cancelOrder(orderId);
    }

    /**
     * 查询订单详情。
     */
    @GetMapping("/{id}")
    public Result<Order> getOrderById(@PathVariable Integer id) {
        return Result.success(orderService.getById(id));
    }

    /**
     * 分页查询订单。
     */
    @GetMapping("/page")
    @SentinelResource(value = "orderPage", blockHandler = "getOrderPageBlockHandler")
    public Result<Object> getOrderPage(PageRequest pr, @RequestParam(required = false) Integer userId, @RequestParam(required = false) String status) {
        return orderService.getOrderPage(pr, userId, status);
    }

    /**
     * 查询用户订单。
     */
    @GetMapping("/user/{userId}")
    @SentinelResource(value = "userOrders", blockHandler = "getUserOrdersBlockHandler")
    public Result<Object> getUserOrders(@PathVariable Integer userId) {
        return orderService.getOrdersByUserId(userId);
    }

    /**
     * 分页查询订单限流处理。
     */
    public static Result<Object> getOrderPageBlockHandler(PageRequest pr, Integer userId, String status, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 查询用户订单限流处理。
     */
    public static Result<Object> getUserOrdersBlockHandler(Integer userId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
