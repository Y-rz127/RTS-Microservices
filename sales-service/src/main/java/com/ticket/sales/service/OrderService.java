package com.ticket.sales.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.Order;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;

/**
 * 订单服务接口。
 */
public interface OrderService extends IService<Order> {
    /**
     * 创建订单。
     */
    Result<Order> createOrder(Order order);
    /**
     * 支付订单。
     */
    Result<Boolean> payOrder(Integer orderId, String paymentMethod);
    /**
     * 取消订单。
     */
    Result<Boolean> cancelOrder(Integer orderId);
    /**
     * 按订单号查询订单。
     */
    Result<Order> getOrderByNumber(String orderNumber);
    /**
     * 分页查询订单。
     */
    Result<Object> getOrderPage(PageRequest pageRequest, Integer userId, String orderStatus);
    /**
     * 查询用户订单。
     */
    Result<Object> getOrdersByUserId(Integer userId);
    /**
     * 查询退票申请。
     */
    Result<Object> getRefundApplications(String status);
    /**
     * 按用户名查询订单。
     */
    Result<Object> getOrdersByUsername(String username);
    /**
     * 按乘客名查询订单。
     */
    Result<Object> getOrdersByPassengerName(String passengerName);
}
