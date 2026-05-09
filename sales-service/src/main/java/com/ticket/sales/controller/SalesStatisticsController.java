package com.ticket.sales.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.model.entity.Ticket;
import com.ticket.model.response.Result;
import com.ticket.sales.mapper.OrderMapper;
import com.ticket.sales.mapper.TicketMapper;
import jakarta.annotation.Resource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/sales/statistics")
public class SalesStatisticsController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（销售统计限流）";

    @Resource
    private TicketMapper ticketMapper;

    @Resource
    private OrderMapper orderMapper;

    @GetMapping("/ticket-count")
    @SentinelResource(value = "salesTicketCount", blockHandler = "ticketCountBlockHandler")
    public Result<Object> getTicketCount(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            @RequestParam(required = false) Integer trainId,
            @RequestParam(required = false) String status) {

        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<>();
        if (startDate != null) wrapper.ge(Ticket::getCreatedAt, startDate);
        if (endDate != null) wrapper.le(Ticket::getCreatedAt, endEnd(endDate));
        if (trainId != null) wrapper.eq(Ticket::getTrainId, trainId);
        if (status != null) wrapper.eq(Ticket::getStatus, status);

        long total = ticketMapper.selectCount(wrapper);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("totalCount", total);
        if (trainId != null) data.put("trainId", trainId);
        if (status != null) data.put("status", status);
        return Result.success(data);
    }

    @GetMapping("/revenue")
    @SentinelResource(value = "salesRevenue", blockHandler = "revenueBlockHandler")
    public Result<Object> getRevenue(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            @RequestParam(required = false) Integer trainId) {

        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<Ticket>()
                .notIn(Ticket::getStatus, "REFUNDED", "CHANGED");
        if (startDate != null) wrapper.ge(Ticket::getCreatedAt, startDate);
        if (endDate != null) wrapper.le(Ticket::getCreatedAt, endEnd(endDate));
        if (trainId != null) wrapper.eq(Ticket::getTrainId, trainId);

        List<Ticket> tickets = ticketMapper.selectList(wrapper);
        BigDecimal totalRevenue = tickets.stream()
                .map(Ticket::getPrice)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalRefundFee = tickets.stream()
                .map(t -> t.getRefundFee() != null ? t.getRefundFee() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("totalRevenue", totalRevenue);
        data.put("totalRefundFee", totalRefundFee);
        data.put("ticketCount", tickets.size());
        if (trainId != null) data.put("trainId", trainId);
        return Result.success(data);
    }

    @GetMapping("/trend")
    @SentinelResource(value = "salesTrend", blockHandler = "daysBlockHandler")
    public Result<Object> getSalesTrend(@RequestParam(defaultValue = "7") Integer days) {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0); cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0);
        Date endDate = cal.getTime();
        cal.add(Calendar.DAY_OF_MONTH, -days);
        Date startDate = cal.getTime();

        List<Ticket> tickets = ticketMapper.selectList(new LambdaQueryWrapper<Ticket>()
                .ge(Ticket::getCreatedAt, startDate)
                .le(Ticket::getCreatedAt, endDate));

        Map<String, Map<String, Object>> dailyMap = new LinkedHashMap<>();
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

        Calendar iter = Calendar.getInstance();
        iter.setTime(startDate);
        while (!iter.getTime().after(endDate)) {
            String dateKey = sdf.format(iter.getTime());
            Map<String, Object> dayData = new LinkedHashMap<>();
            dayData.put("date", dateKey);
            dayData.put("count", 0L);
            dayData.put("revenue", BigDecimal.ZERO);
            dailyMap.put(dateKey, dayData);
            iter.add(Calendar.DAY_OF_MONTH, 1);
        }

        for (Ticket t : tickets) {
            if (t.getCreatedAt() == null) continue;
            String dateKey = sdf.format(t.getCreatedAt());
            if (dailyMap.containsKey(dateKey)) {
                Map<String, Object> dayData = dailyMap.get(dateKey);
                dayData.put("count", (Long) dayData.get("count") + 1L);
                if (t.getPrice() != null && !"REFUNDED".equals(t.getStatus()) && !"CHANGED".equals(t.getStatus())) {
                    dayData.put("revenue", ((BigDecimal) dayData.get("revenue")).add(t.getPrice()));
                }
            }
        }

        return Result.success(new ArrayList<>(dailyMap.values()));
    }

    @GetMapping("/top-trains")
    @SentinelResource(value = "salesTopTrains", blockHandler = "topTrainsBlockHandler")
    public Result<Object> getTopTrains(
            @RequestParam(defaultValue = "5") Integer topN,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            @RequestParam(defaultValue = "count") String sortBy) {

        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<Ticket>()
                .notIn(Ticket::getStatus, "REFUNDED", "CHANGED");
        if (startDate != null) wrapper.ge(Ticket::getCreatedAt, startDate);
        if (endDate != null) wrapper.le(Ticket::getCreatedAt, endEnd(endDate));

        List<Ticket> tickets = ticketMapper.selectList(wrapper);

        Map<Integer, List<Ticket>> grouped = tickets.stream()
                .collect(Collectors.groupingBy(Ticket::getTrainId));

        List<Map<String, Object>> result = grouped.entrySet().stream()
                .map(e -> {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("trainId", e.getKey());
                    long count = e.getValue().size();
                    BigDecimal revenue = e.getValue().stream()
                            .map(Ticket::getPrice).filter(Objects::nonNull)
                            .reduce(BigDecimal.ZERO, BigDecimal::add);
                    item.put("salesCount", count);
                    item.put("revenue", revenue);
                    return item;
                })
                .sorted((a, b) -> "revenue".equals(sortBy)
                        ? ((BigDecimal) b.get("revenue")).compareTo((BigDecimal) a.get("revenue"))
                        : Long.compare((Long) b.get("salesCount"), (Long) a.get("salesCount")))
                .limit(topN)
                .collect(Collectors.toList());

        return Result.success(result);
    }

    @GetMapping("/seat-type")
    @SentinelResource(value = "salesSeatType", blockHandler = "dateRangeBlockHandler")
    public Result<Object> getSeatTypeStats(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {

        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<Ticket>()
                .notIn(Ticket::getStatus, "REFUNDED", "CHANGED");
        if (startDate != null) wrapper.ge(Ticket::getCreatedAt, startDate);
        if (endDate != null) wrapper.le(Ticket::getCreatedAt, endEnd(endDate));

        List<Ticket> tickets = ticketMapper.selectList(wrapper);
        long total = tickets.size();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("total", total);
        return Result.success(data);
    }

    @GetMapping("/refund")
    @SentinelResource(value = "salesRefund", blockHandler = "dateRangeBlockHandler")
    public Result<Object> getRefundStats(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {

        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<Ticket>()
                .eq(Ticket::getStatus, "REFUNDED");
        if (startDate != null) wrapper.ge(Ticket::getUpdatedAt, startDate);
        if (endDate != null) wrapper.le(Ticket::getUpdatedAt, endEnd(endDate));

        List<Ticket> refunded = ticketMapper.selectList(wrapper);
        BigDecimal totalRefundFee = refunded.stream()
                .map(t -> t.getRefundFee() != null ? t.getRefundFee() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal refundAmount = refunded.stream()
                .map(t -> t.getPrice() != null ? t.getPrice() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("refundCount", (long) refunded.size());
        data.put("refundAmount", refundAmount);
        data.put("refundFee", totalRefundFee);
        data.put("actualRefund", refundAmount.subtract(totalRefundFee));
        return Result.success(data);
    }

    @GetMapping("/change")
    @SentinelResource(value = "salesChange", blockHandler = "dateRangeBlockHandler")
    public Result<Object> getChangeStats(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {

        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<Ticket>()
                .eq(Ticket::getStatus, "CHANGED");
        if (startDate != null) wrapper.ge(Ticket::getUpdatedAt, startDate);
        if (endDate != null) wrapper.le(Ticket::getUpdatedAt, endEnd(endDate));

        long changeCount = ticketMapper.selectCount(wrapper);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("changeCount", changeCount);
        return Result.success(data);
    }

    @GetMapping("/passenger")
    @SentinelResource(value = "salesPassenger", blockHandler = "dateRangeBlockHandler")
    public Result<Object> getPassengerStats(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate) {

        LambdaQueryWrapper<Ticket> wrapper = new LambdaQueryWrapper<>();
        if (startDate != null) wrapper.ge(Ticket::getCreatedAt, startDate);
        if (endDate != null) wrapper.le(Ticket::getCreatedAt, endEnd(endDate));

        List<Ticket> tickets = ticketMapper.selectList(wrapper);
        long uniquePassengers = tickets.stream().map(Ticket::getPassengerId)
                .filter(Objects::nonNull).distinct().count();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("totalTickets", (long) tickets.size());
        data.put("uniquePassengers", uniquePassengers);
        data.put("avgTicketsPerPassenger", uniquePassengers == 0 ? 0 : (double) tickets.size() / uniquePassengers);
        return Result.success(data);
    }

    @GetMapping("/dashboard")
    @SentinelResource(value = "salesDashboard", blockHandler = "dashboardBlockHandler")
    public Result<Object> getDashboard() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0); cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0);
        Date today = cal.getTime();

        long totalTickets = ticketMapper.selectCount(null);
        long totalOrders = orderMapper.selectCount(null);

        // 今日售票
        long todaySales = ticketMapper.selectCount(new LambdaQueryWrapper<Ticket>()
                .ge(Ticket::getCreatedAt, today));

        // 今日收入 (排除已退票和已改签)
        List<Ticket> todayTickets = ticketMapper.selectList(new LambdaQueryWrapper<Ticket>()
                .ge(Ticket::getCreatedAt, today)
                .notIn(Ticket::getStatus, "REFUNDED", "CHANGED"));
        BigDecimal todayRevenue = todayTickets.stream()
                .map(Ticket::getPrice).filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<Ticket> allActiveTickets = ticketMapper.selectList(
                new LambdaQueryWrapper<Ticket>().notIn(Ticket::getStatus, "REFUNDED", "CHANGED"));
        BigDecimal totalRevenue = allActiveTickets.stream()
                .map(Ticket::getPrice).filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        long refundCount = ticketMapper.selectCount(
                new LambdaQueryWrapper<Ticket>().eq(Ticket::getStatus, "REFUNDED"));
        long changeCount = ticketMapper.selectCount(
                new LambdaQueryWrapper<Ticket>().eq(Ticket::getStatus, "CHANGED"));

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("todaySales", todaySales);
        data.put("todayRevenue", todayRevenue);
        data.put("totalSales", totalTickets);
        data.put("totalOrders", totalOrders);
        data.put("totalRevenue", totalRevenue);
        data.put("refundCount", refundCount);
        data.put("changeCount", changeCount);
        return Result.success(data);
    }

    public static Result<Object> ticketCountBlockHandler(Date startDate, Date endDate, Integer trainId, String status, BlockException ex) {
        return Result.error("售票数据统计繁忙，请稍后刷新页面");
    }

    public static Result<Object> revenueBlockHandler(Date startDate, Date endDate, Integer trainId, BlockException ex) {
        return Result.error("收入统计计算繁忙，请稍后重试");
    }

    public static Result<Object> daysBlockHandler(Integer days, BlockException ex) {
        return Result.error("趋势数据加载繁忙，请减少查询天数或稍后重试");
    }

    public static Result<Object> topTrainsBlockHandler(Integer topN, Date startDate, Date endDate, String sortBy, BlockException ex) {
        return Result.error("热门车次排行榜更新中，请稍后刷新");
    }

    public static Result<Object> dateRangeBlockHandler(Date startDate, Date endDate, BlockException ex) {
        return Result.error("统计数据查询繁忙，请缩小查询时间范围或稍后重试");
    }

    public static Result<Object> dashboardBlockHandler(BlockException ex) {
        return Result.error("仪表板数据加载繁忙，请稍后刷新页面");
    }

    private Date endEnd(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        return cal.getTime();
    }
}
