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

    /**
     * 基于 CPU 动态调整线程池参数
     */
    @Scheduled(fixedRate = 5000)
    public void adjustThreadPoolByCpu() {
        double cpuUsage = getCpuUsage();
        int currentCoreSize = ticketThreadPool.getCorePoolSize();
        int currentMaxSize = ticketThreadPool.getMaximumPoolSize();

        if (cpuUsage > 0.8) {
            // CPU 高负载，减少线程数
            if (currentCoreSize > 5) {
                ticketThreadPool.setCorePoolSize(5);
                log.info("[动态线程池] CPU 高负载({}%), 核心线程数调整为 5", String.format("%.1f", cpuUsage));
            }
            if (currentMaxSize > 10) {
                ticketThreadPool.setMaximumPoolSize(10);
                log.info("[动态线程池] CPU 高负载({}%), 最大线程数调整为 10", String.format("%.1f", cpuUsage));
            }
        } else if (cpuUsage < 0.5) {
            // CPU 低负载，增加线程数
            if (currentCoreSize < 15) {
                ticketThreadPool.setCorePoolSize(15);
                log.info("[动态线程池] CPU 低负载({}%), 核心线程数调整为 15", String.format("%.1f", cpuUsage));
            }
            if (currentMaxSize < 30) {
                ticketThreadPool.setMaximumPoolSize(30);
                log.info("[动态线程池] CPU 低负载({}%), 最大线程数调整为 30", String.format("%.1f", cpuUsage));
            }
        }
    }

    /**
     * 获取当前 CPU 使用率
     */
    private double getCpuUsage() {
        try {
            com.sun.management.OperatingSystemMXBean osBean =
                (com.sun.management.OperatingSystemMXBean) java.lang.management.ManagementFactory.getOperatingSystemMXBean();
            return osBean.getCpuLoad() * 100;
        } catch (Exception e) {
            log.error("获取 CPU 使用率失败", e);
            return 0.5; // 默认返回中等负载
        }
    }
}
