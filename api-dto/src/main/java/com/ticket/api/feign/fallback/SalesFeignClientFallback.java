package com.ticket.api.feign.fallback;

import com.ticket.api.feign.SalesFeignClient;
import com.ticket.model.entity.Order;
import com.ticket.model.entity.Seat;
import com.ticket.model.entity.Ticket;
import com.ticket.model.request.RefundRequest;
import com.ticket.model.request.TicketChangeRequest;
import com.ticket.model.response.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;

import java.math.BigDecimal;
import java.util.List;

/**
 * 销售服务 Feign 客户端降级处理类。
 */
@Slf4j
public class SalesFeignClientFallback implements FallbackFactory<SalesFeignClient> {
    @Override
    public SalesFeignClient create(Throwable cause) {
        log.error("sales-service 调用失败，触发熔断降级", cause);
        return new SalesFeignClient() {
            @Override
            public Result<Order> getOrderById(Integer id) {
                return Result.error("订单服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Seat> getSeatById(Integer seatId) {
                return Result.error("座位服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Boolean> payOrder(Integer orderId, String method) {
                return Result.error("支付服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Ticket> getTicket(Integer id) {
                return Result.error("票务服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> changeTicket(TicketChangeRequest req) {
                return Result.error("改签服务暂不可用，请稍后重试");
            }

            @Override
            public Result<BigDecimal> refundTicket(RefundRequest req) {
                return Result.error("退票服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Boolean> cancelBooking(Integer id) {
                return Result.error("取消预订服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getSalesDashboard() {
                return Result.error("统计服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getTicketCount(String startDate, String endDate, Integer trainId, String status) {
                return Result.error("统计服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getRevenue(String startDate, String endDate, Integer trainId) {
                return Result.error("统计服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getSalesTrend(Integer days) {
                return Result.error("统计服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getTopTrains(Integer topN, String startDate, String endDate, String sortBy) {
                return Result.error("统计服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getRefundStats(String startDate, String endDate) {
                return Result.error("统计服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getChangeStats(String startDate, String endDate) {
                return Result.error("统计服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Object> getPassengerStats(String startDate, String endDate) {
                return Result.error("统计服务暂不可用，请稍后重试");
            }
        };
    }
}
