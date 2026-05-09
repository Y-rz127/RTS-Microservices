package com.ticket.sales.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 线程池配置类。
 */
@Configuration
@EnableScheduling
public class ThreadPoolConfig {

    /**
     * 创建抢票线程池。
     */
    @Bean
    public ThreadPoolExecutor ticketThreadPool() {
        return new ThreadPoolExecutor(
                10, 20, 60, TimeUnit.SECONDS,
                new LinkedBlockingQueue<>(1000)
        );
    }
}
