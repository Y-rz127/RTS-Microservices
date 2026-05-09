package com.ticket.api.feign;

import com.ticket.model.entity.User;
import com.ticket.model.response.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

/**
 * 用户认证服务 Feign 客户端接口。
 */
@FeignClient(name = "user-auth-service", path = "/api/user")
public interface UserFeignClient {

    @GetMapping("/{userId}")
    Result<User> getUserById(@PathVariable("userId") Integer userId);

    @GetMapping("/internal/byUsername/{username}")
    Result<User> getUserByUsername(@PathVariable("username") String username);
}
