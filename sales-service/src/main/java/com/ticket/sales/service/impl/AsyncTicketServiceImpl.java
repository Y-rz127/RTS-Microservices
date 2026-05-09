package com.ticket.sales.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ticket.constant.MqConstants;
import com.ticket.model.dto.BookingResultEvent;
import com.ticket.model.entity.ThreadPoolStatus;
import com.ticket.model.entity.Ticket;
import com.ticket.model.request.BookingRequest;
import com.ticket.model.request.GroupBookingRequest;
import com.ticket.model.response.AsyncBookingResponse;
import com.ticket.model.response.BookingResult;
import com.ticket.model.response.Result;
import com.ticket.sales.service.AsyncTicketService;
import com.ticket.sales.service.TicketService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * 异步抢票服务实现类。
 */
@Slf4j
@Service
public class AsyncTicketServiceImpl implements AsyncTicketService {

    private static final ConcurrentHashMap<String, BookingResult> RESULT_STORE = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, String> USER_STORE = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, Boolean> CANCELED_STORE = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, Long> CREATED_TIME_STORE = new ConcurrentHashMap<>();
    private static final ConcurrentLinkedQueue<String> QUEUE_ORDER = new ConcurrentLinkedQueue<>();

    /** 异步任务结果保留时长：30 分钟 */
    private static final long RESULT_TTL_MILLIS = 30 * 60 * 1000L;

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());

    @Resource
    private ThreadPoolExecutor ticketThreadPool;

    @Resource
    private TicketService ticketService;

    @Resource
    private RabbitTemplate rabbitTemplate;

    /**
     * 提交单人异步抢票。
     */
    @Override
    public Result<AsyncBookingResponse> asyncSellTicket(BookingRequest request, Integer userId) {
        String queueId = UUID.randomUUID().toString();
        USER_STORE.put(queueId, String.valueOf(userId));
        CREATED_TIME_STORE.put(queueId, System.currentTimeMillis());
        QUEUE_ORDER.add(queueId);
        ticketThreadPool.execute(() -> {
            log.info("开始异步处理购票请求: queueId={}", queueId);
            try {
                if (Boolean.TRUE.equals(CANCELED_STORE.get(queueId))) {
                    RESULT_STORE.put(queueId, BookingResult.failed(queueId, "排队已取消"));
                    return;
                }
                request.setSellerId(userId);
                Result<Ticket> result = ticketService.sellTicket(request);
                BookingResult bookingResult = buildSingleBookingResult(queueId, result);
                RESULT_STORE.put(queueId, bookingResult);
                publishBookingResult(String.valueOf(userId), bookingResult);
            } catch (Exception e) {
                log.error("异步购票失败", e);
                BookingResult failed = BookingResult.failed(queueId, e.getMessage() == null ? "异步购票失败" : e.getMessage());
                RESULT_STORE.put(queueId, failed);
                publishBookingResult(String.valueOf(userId), failed);
            } finally {
                QUEUE_ORDER.remove(queueId);
            }
        });
        
        AsyncBookingResponse resp = new AsyncBookingResponse();
        resp.setQueueId(queueId);
        resp.setEstimatedWaitTime(5);
        return Result.success(resp);
    }

    /**
     * 提交团体异步抢票。
     */
    @Override
    public Result<AsyncBookingResponse> asyncGroupSellTicket(GroupBookingRequest request, Integer userId) {
        String queueId = UUID.randomUUID().toString();
        USER_STORE.put(queueId, String.valueOf(userId));
        CREATED_TIME_STORE.put(queueId, System.currentTimeMillis());
        QUEUE_ORDER.add(queueId);
        ticketThreadPool.execute(() -> {
            log.info("开始异步处理团体购票请求: queueId={}, 人数={}", queueId,
                    request.getName() != null ? request.getName().size() : 0);
            try {
                if (Boolean.TRUE.equals(CANCELED_STORE.get(queueId))) {
                    RESULT_STORE.put(queueId, BookingResult.failed(queueId, "排队已取消"));
                    return;
                }
                request.setSellerId(userId);
                Result<List<Ticket>> result = ticketService.groupSellTicket(request);
                BookingResult bookingResult = buildGroupBookingResult(queueId, result);
                RESULT_STORE.put(queueId, bookingResult);
                publishBookingResult(String.valueOf(userId), bookingResult);
            } catch (Exception e) {
                log.error("异步团体购票失败", e);
                BookingResult failed = BookingResult.failed(queueId, e.getMessage() == null ? "异步团体购票失败" : e.getMessage());
                RESULT_STORE.put(queueId, failed);
                publishBookingResult(String.valueOf(userId), failed);
            } finally {
                QUEUE_ORDER.remove(queueId);
            }
        });

        AsyncBookingResponse resp = new AsyncBookingResponse();
        resp.setQueueId(queueId);
        resp.setEstimatedWaitTime(10);
        return Result.success(resp);
    }

    /**
     * 查询抢票结果。
     */
    @Override
    public BookingResult getBookingResult(String queueId) {
        return RESULT_STORE.get(queueId);
    }

    /**
     * 查询排队位置。
     */
    @Override
    public Integer getQueuePosition(String queueId) {
        if (RESULT_STORE.containsKey(queueId)) {
            return -1;
        }
        int position = 1;
        for (String id : QUEUE_ORDER) {
            if (queueId.equals(id)) {
                return position;
            }
            position++;
        }
        return 0;
    }

    /**
     * 取消排队任务。
     */
    @Override
    public Result<Boolean> cancelTask(String queueId) {
        CANCELED_STORE.put(queueId, true);
        QUEUE_ORDER.remove(queueId);
        RESULT_STORE.put(queueId, BookingResult.failed(queueId, "排队已取消"));
        return Result.success(true);
    }

    /**
     * 定时清理过期任务结果。
     */
    @Scheduled(fixedDelay = 5 * 60 * 1000L)
    public void cleanupExpiredResults() {
        long now = System.currentTimeMillis();
        int removed = 0;
        for (java.util.Map.Entry<String, Long> entry : CREATED_TIME_STORE.entrySet()) {
            if (now - entry.getValue() > RESULT_TTL_MILLIS) {
                String queueId = entry.getKey();
                RESULT_STORE.remove(queueId);
                USER_STORE.remove(queueId);
                CANCELED_STORE.remove(queueId);
                CREATED_TIME_STORE.remove(queueId);
                QUEUE_ORDER.remove(queueId);
                removed++;
            }
        }
        if (removed > 0) {
            log.info("异步任务结果清理: 移除 {} 条过期数据，当前总量 {}", removed, RESULT_STORE.size());
        }
    }

    /**
     * 获取线程池状态。
     */
    @Override
    public ThreadPoolStatus getThreadPoolStatus() {
        ThreadPoolStatus status = new ThreadPoolStatus();
        status.setCorePoolSize(ticketThreadPool.getCorePoolSize());
        status.setMaximumPoolSize(ticketThreadPool.getMaximumPoolSize());
        status.setActiveCount(ticketThreadPool.getActiveCount());
        status.setQueueSize(ticketThreadPool.getQueue().size());
        status.setCompletedTaskCount(ticketThreadPool.getCompletedTaskCount());
        status.setPoolSize(ticketThreadPool.getPoolSize());
        status.setLargestPoolSize(ticketThreadPool.getLargestPoolSize());
        status.setRemainingQueueCapacity(ticketThreadPool.getQueue().remainingCapacity());
        return status;
    }

    /**
     * 构建单人购票结果。
     */
    private BookingResult buildSingleBookingResult(String queueId, Result<Ticket> result) {
        if (result != null && result.getCode() == 200 && result.getData() != null) {
            return BookingResult.success(queueId, result.getData());
        }
        return BookingResult.failed(queueId, result == null ? "购票失败" : result.getMessage());
    }

    /**
     * 构建团体购票结果。
     */
    private BookingResult buildGroupBookingResult(String queueId, Result<List<Ticket>> result) {
        if (result != null && result.getCode() == 200 && result.getData() != null) {
            return BookingResult.success(queueId, result.getData());
        }
        return BookingResult.failed(queueId, result == null ? "团体购票失败" : result.getMessage());
    }

    /**
     * 发布购票结果到消息队列。
     */
    private void publishBookingResult(String userId, BookingResult result) {
        try {
            BookingResultEvent event = BookingResultEvent.builder()
                    .userId(userId)
                    .result(result)
                    .timestamp(System.currentTimeMillis())
                    .build();
            String payload = objectMapper.writeValueAsString(event);
            rabbitTemplate.convertAndSend(
                    MqConstants.BOOKING_RESULT_EXCHANGE,
                    MqConstants.BOOKING_RESULT_ROUTING_KEY,
                    payload
            );
        } catch (Exception e) {
            log.error("发送购票结果通知失败, userId={}, queueId={}", userId, result != null ? result.getQueueId() : null, e);
        }
    }
}
