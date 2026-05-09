package com.ticket.sales;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;

/**
 * 售票服务启动类。
 */
@SpringBootApplication
@ComponentScan(basePackages = "com.ticket")
@EnableFeignClients(basePackages = "com.ticket.api.feign")
@MapperScan(basePackages = {"com.ticket.sales.mapper"})
public class SalesServiceApplication {

    /**
     * 启动售票服务。
     */
    public static void main(String[] args) {
        SpringApplication.run(SalesServiceApplication.class, args);
    }
}
