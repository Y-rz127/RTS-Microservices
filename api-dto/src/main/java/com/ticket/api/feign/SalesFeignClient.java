package com.ticket.api.feign;

import com.ticket.model.entity.Order;
import com.ticket.model.entity.Seat;
import com.ticket.model.entity.Ticket;
import com.ticket.model.request.TicketChangeRequest;
import com.ticket.model.response.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 销售服务 Feign 客户端接口。
 */
@FeignClient(name = "sales-service")
public interface SalesFeignClient {

    @GetMapping("/api/orders/{id}")
    Result<Order> getOrderById(@PathVariable("id") Integer id);

    @GetMapping("/api/seats/{seatId}")
    Result<Seat> getSeatById(@PathVariable("seatId") Integer seatId);

    @PostMapping("/api/orders/pay/{orderId}")
    Result<Boolean> payOrder(@PathVariable("orderId") Integer orderId, @RequestParam("method") String method);

    @GetMapping("/api/tickets/{id}")
    Result<Ticket> getTicket(@PathVariable("id") Integer id);

    @PostMapping("/api/tickets/change")
    Result<Object> changeTicket(@RequestBody TicketChangeRequest req);

    @PostMapping("/api/tickets/refund")
    Result<java.math.BigDecimal> refundTicket(@RequestBody com.ticket.model.request.RefundRequest req);

    @PostMapping("/api/tickets/cancel-booking/{id}")
    Result<Boolean> cancelBooking(@PathVariable("id") Integer id);

    @GetMapping("/api/sales/statistics/dashboard")
    Result<Object> getSalesDashboard();

    @GetMapping("/api/sales/statistics/ticket-count")
    Result<Object> getTicketCount(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) Integer trainId,
            @RequestParam(required = false) String status);

    @GetMapping("/api/sales/statistics/revenue")
    Result<Object> getRevenue(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(required = false) Integer trainId);

    @GetMapping("/api/sales/statistics/trend")
    Result<Object> getSalesTrend(@RequestParam(defaultValue = "7") Integer days);

    @GetMapping("/api/sales/statistics/top-trains")
    Result<Object> getTopTrains(
            @RequestParam(defaultValue = "5") Integer topN,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "count") String sortBy);

    @GetMapping("/api/sales/statistics/refund")
    Result<Object> getRefundStats(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate);

    @GetMapping("/api/sales/statistics/change")
    Result<Object> getChangeStats(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate);

    @GetMapping("/api/sales/statistics/passenger")
    Result<Object> getPassengerStats(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate);
}
