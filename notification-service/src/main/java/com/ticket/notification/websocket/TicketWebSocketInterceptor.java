package com.ticket.notification.websocket;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.utils.JwtUtils;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.Map;

/**
 * 票务 WebSocket 握手拦截器。
 */
@Slf4j
@Component
public class TicketWebSocketInterceptor implements HandshakeInterceptor {

    private static final String BUSY_MESSAGE = "WebSocket 握手已限流，请稍后重试";

    @Resource
    private JwtUtils jwtUtils;

    /**
     * 处理握手前校验。
     */
    @Override
    @SentinelResource(value = "ticketWebSocketHandshake", blockHandler = "beforeHandshakeBlockHandler")
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) {
        if (request instanceof ServletServerHttpRequest servletRequest) {
            String token = servletRequest.getServletRequest().getParameter("token");
            log.info("WebSocket 握手 token: {}", token != null ? token.substring(0, Math.min(20, token.length())) + "..." : "null");
            if (token != null && !token.isEmpty()) {
                try {
                    String userId = jwtUtils.extractUserId(token);
                    if (userId == null) userId = jwtUtils.extractUsername(token);
                    if (userId != null) {
                        attributes.put("userId", userId);
                        log.info("WebSocket 握手成功: userId={}", userId);
                        return true;
                    }
                    log.warn("WebSocket 握手失败: token有效但无法提取userId");
                } catch (ExpiredJwtException e) {
                    String userId = e.getClaims().get("userId", String.class);
                    if (userId == null) userId = e.getClaims().getSubject();
                    if (userId != null) {
                        attributes.put("userId", userId);
                        log.info("WebSocket 握手成功(token已过期但userId有效): userId={}", userId);
                        return true;
                    }
                    log.warn("WebSocket 握手失败: token已过期且无法提取userId");
                } catch (Exception e) {
                    log.error("WebSocket 握手验证失败: {}", e.getMessage(), e);
                }
            } else {
                log.warn("WebSocket 握手失败: token为空");
            }
        } else {
            log.warn("WebSocket 握手失败: 非Servlet请求, 类型={}", request.getClass().getName());
        }
        return false;
    }

    /**
     * 处理握手限流。
     */
    public boolean beforeHandshakeBlockHandler(ServerHttpRequest request, ServerHttpResponse response,
                                               WebSocketHandler wsHandler, Map<String, Object> attributes,
                                               BlockException ex) {
        log.warn(BUSY_MESSAGE);
        return false;
    }

    /**
     * 处理握手后事件。
     */
    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                               WebSocketHandler wsHandler, Exception exception) {}
}
