package com.ticket.sales.metrics;

import com.ticket.model.entity.ThreadPoolStatus;
import com.ticket.sales.service.AsyncTicketService;
import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tags;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.concurrent.ThreadPoolExecutor;

/**
 * 线程池监控组件。
 */
@Slf4j
@Component
public class ThreadPoolMetrics {

    @Resource
    private ThreadPoolExecutor ticketThreadPool;

    private final AsyncTicketService asyncTicketService;

    @Resource
    private MeterRegistry meterRegistry;

    public ThreadPoolMetrics(AsyncTicketService asyncTicketService) {
        this.asyncTicketService = asyncTicketService;
    }

    /**
     * 注册线程池指标。
     */
    @PostConstruct
    public void registerMetrics() {
        Tags tags = Tags.of("pool.name", "ticketThreadPool");
        Gauge.builder("threadpool.core.size", ticketThreadPool, ThreadPoolExecutor::getCorePoolSize)
                .tags(tags).register(meterRegistry);
        Gauge.builder("threadpool.max.size", ticketThreadPool, ThreadPoolExecutor::getMaximumPoolSize)
                .tags(tags).register(meterRegistry);
        Gauge.builder("threadpool.active.count", ticketThreadPool, ThreadPoolExecutor::getActiveCount)
                .tags(tags).register(meterRegistry);
        Gauge.builder("threadpool.queue.size", ticketThreadPool, e -> e.getQueue().size())
                .tags(tags).register(meterRegistry);
        log.info("线程池监控指标注册完成");
    }

    /**
     * 获取线程池状态
     */
    @Scheduled(fixedRate = 1000)
    public void logThreadPoolStatus() {
    ThreadPoolStatus status = asyncTicketService.getThreadPoolStatus();
    // 只在有活跃任务时输出
    if (status.getActiveCount() > 0 || status.getQueueSize() > 0) {
        log.info("[线程池监控] {}", status);
    }
    }
}
