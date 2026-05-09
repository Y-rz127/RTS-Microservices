package com.ticket.sales.controller;

import com.ticket.model.entity.Ticket;
import com.ticket.model.request.*;
import com.ticket.model.response.Result;
import com.ticket.sales.service.TicketService;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;

/**
 * 车票管理控制器。
 */
@RestController
@RequestMapping("/api/tickets")
public class TicketController {

    @Resource
    private TicketService ticketService;

    /**
     * 处理单人购票。
     */
    @PostMapping("/sell")
    public Result<Ticket> sellTicket(@RequestBody BookingRequest req) {
        return ticketService.sellTicket(req);
    }

    /**
     * 处理退票。
     */
    @PostMapping("/refund")
    public Result<BigDecimal> refundTicket(@RequestBody RefundRequest req) {
        return ticketService.refundTicket(req);
    }

    /**
     * 处理改签。
     */
    @PostMapping("/change")
    public Result<Object> changeTicket(@RequestBody TicketChangeRequest req) {
        return ticketService.changeTicket(req);
    }

    /**
     * 查询车票详情。
     */
    @GetMapping("/{id}")
    public Result<Ticket> getTicket(@PathVariable Integer id) {
        return ticketService.getTicketDetail(id);
    }

    /**
     * 取消预订。
     */
    @PostMapping("/cancel-booking/{id}")
    public Result<Boolean> cancelBooking(@PathVariable Integer id) {
        return ticketService.cancelBooking(id);
    }

    /**
     * 处理团体购票。
     */
    @PostMapping("/group/sell")
    public Result<List<Ticket>> groupSellTicket(@RequestBody GroupBookingRequest req) {
        return ticketService.groupSellTicket(req);
    }

    /**
     * 处理团体退票。
     */
    @PostMapping("/group/refund")
    public Result<BigDecimal> groupRefundTicket(@RequestBody GroupRefundRequest req) {
        return ticketService.groupRefundTicket(req);
    }

    /**
     * 查询用户车票。
     */
    @GetMapping("/user/{userId}")
    public Result<Object> getTicketsByUserId(@PathVariable Integer userId) {
        return ticketService.getTicketsByUserId(userId);
    }
}
