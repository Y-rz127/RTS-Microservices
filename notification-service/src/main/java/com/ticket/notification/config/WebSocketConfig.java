package com.ticket.notification.config;

import com.ticket.notification.websocket.TicketWebSocketHandler;
import com.ticket.notification.websocket.TicketWebSocketInterceptor;
import jakarta.annotation.Resource;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * WebSocket 配置类。
 */
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    @Resource
    private TicketWebSocketHandler ticketWebSocketHandler;

    @Resource
    private TicketWebSocketInterceptor ticketWebSocketInterceptor;

    /**
     * 注册 WebSocket 处理器。
     */
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(ticketWebSocketHandler, "/ws/ticket")
                .addInterceptors(ticketWebSocketInterceptor)
                .setAllowedOrigins("*");
    }
}
