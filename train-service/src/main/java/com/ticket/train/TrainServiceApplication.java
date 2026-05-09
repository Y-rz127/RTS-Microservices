package com.ticket.train;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;

/**
 * 车次服务启动类。
 */
@SpringBootApplication
@ComponentScan(basePackages = "com.ticket")
@EnableFeignClients(basePackages = "com.ticket.api.feign")
@MapperScan(basePackages = {"com.ticket.train.mapper"})
public class TrainServiceApplication {

    /**
     * 启动车次服务。
     */
    public static void main(String[] args) {
        SpringApplication.run(TrainServiceApplication.class, args);
    }
}
