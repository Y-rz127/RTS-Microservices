package com.ticket.approval;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;

/**
 * 审批服务启动类。
 */
@SpringBootApplication
@ComponentScan(basePackages = "com.ticket")
@EnableFeignClients(basePackages = "com.ticket.api.feign")
@MapperScan(basePackages = {"com.ticket.approval.mapper"})
public class ApprovalServiceApplication {

    /**
     * 启动审批服务。
     */
    public static void main(String[] args) {
        SpringApplication.run(ApprovalServiceApplication.class, args);
    }
}
