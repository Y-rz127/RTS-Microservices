package com.ticket.api.feign.fallback;

import com.ticket.api.feign.UserFeignClient;
import com.ticket.model.entity.User;
import com.ticket.model.response.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;

/**
 * 用户认证服务 Feign 客户端降级处理类。
 */
@Slf4j
public class UserFeignClientFallback implements FallbackFactory<UserFeignClient> {
    @Override
    public UserFeignClient create(Throwable cause) {
        log.error("user-auth-service 调用失败，触发熔断降级", cause);
        return new UserFeignClient() {
            @Override
            public Result<User> getUserById(Integer userId) {
                return Result.error("用户服务暂不可用，请稍后重试");
            }

            @Override
            public Result<User> getUserByUsername(String username) {
                return Result.error("用户服务暂不可用，请稍后重试");
            }
        };
    }
}
