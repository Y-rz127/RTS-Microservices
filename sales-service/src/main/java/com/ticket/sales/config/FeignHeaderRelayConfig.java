package com.ticket.sales.config;

import feign.RequestInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * Feign 请求头透传配置类。
 */
@Configuration
public class FeignHeaderRelayConfig {

    /**
     * 透传请求头到下游服务。
     */
    @Bean
    public RequestInterceptor relayRequestHeadersInterceptor() {
        return template -> {
            RequestAttributes attributes = RequestContextHolder.getRequestAttributes();
            if (!(attributes instanceof ServletRequestAttributes servletRequestAttributes)) {
                return;
            }
            String authorization = servletRequestAttributes.getRequest().getHeader("Authorization");
            String userId = servletRequestAttributes.getRequest().getHeader("X-User-Id");
            String userRole = servletRequestAttributes.getRequest().getHeader("X-User-Role");
            String authTimestamp = servletRequestAttributes.getRequest().getHeader("X-Auth-Timestamp");
            String authSignature = servletRequestAttributes.getRequest().getHeader("X-Auth-Signature");
            if (authorization != null && !authorization.isBlank()) {
                template.header("Authorization", authorization);
            }
            if (userId != null && !userId.isBlank()) {
                template.header("X-User-Id", userId);
            }
            if (userRole != null && !userRole.isBlank()) {
                template.header("X-User-Role", userRole);
            }
            if (authTimestamp != null && !authTimestamp.isBlank()) {
                template.header("X-Auth-Timestamp", authTimestamp);
            }
            if (authSignature != null && !authSignature.isBlank()) {
                template.header("X-Auth-Signature", authSignature);
            }
        };
    }
}
