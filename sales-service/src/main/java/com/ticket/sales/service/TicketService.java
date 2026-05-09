package com.ticket.sales.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.Ticket;
import com.ticket.model.request.BookingRequest;
import com.ticket.model.request.GroupBookingRequest;
import com.ticket.model.request.GroupRefundRequest;
import com.ticket.model.request.RefundRequest;
import com.ticket.model.request.TicketChangeRequest;
import com.ticket.model.response.Result;
import java.math.BigDecimal;
import java.util.List;

/**
 * 车票服务接口。
 */
public interface TicketService extends IService<Ticket> {
    /**
     * 处理单人购票。
     */
    Result<Ticket> sellTicket(BookingRequest req);
    /**
     * 处理团体购票。
     */
    Result<List<Ticket>> groupSellTicket(GroupBookingRequest req);
    /**
     * 处理退票。
     */
    Result<BigDecimal> refundTicket(RefundRequest req);
    /**
     * 处理团体退票。
     */
    Result<BigDecimal> groupRefundTicket(GroupRefundRequest req);
    /**
     * 处理改签。
     */
    Result<Object> changeTicket(TicketChangeRequest req);
    /**
     * 查询订单车票。
     */
    Result<List<Ticket>> getTicketsByOrderId(Integer orderId);
    /**
     * 查询车票详情。
     */
    Result<Ticket> getTicketDetail(Integer ticketId);
    /**
     * 更新车票状态。
     */
    Result<Boolean> updateTicketStatus(Integer ticketId, String status);
    /**
     * 查询用户车票。
     */
    Result<Object> getTicketsByUserId(Integer userId);
    /**
     * 取消预订。
     */
    Result<Boolean> cancelBooking(Integer ticketId);
}
