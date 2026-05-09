package com.ticket.userauth;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;

/**
 * 用户认证服务启动类。
 */
@SpringBootApplication
@ComponentScan(basePackages = {"com.ticket.userauth", "com.ticket.utils", "com.ticket.filter"})
@EnableFeignClients(basePackages = "com.ticket.api.feign")
@MapperScan(basePackages = {"com.ticket.userauth.mapper"})
public class UserAuthServiceApplication {

    /**
     * 启动用户认证服务。
     */
    public static void main(String[] args) {
        SpringApplication.run(UserAuthServiceApplication.class, args);
    }
}
