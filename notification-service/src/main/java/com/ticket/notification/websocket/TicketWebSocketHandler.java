package com.ticket.notification.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.ticket.model.response.BookingResult;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 票务 WebSocket 处理器。
 */
@Slf4j
@Component
public class TicketWebSocketHandler extends TextWebSocketHandler {

    private static final ConcurrentHashMap<String, WebSocketSession> SESSIONS = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, String> USER_SESSION_MAP = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, Object> SESSION_LOCKS = new ConcurrentHashMap<>();
    private static final String PENDING_NOTIFICATION_KEY = "pending_notifications:";

    @Resource(name = "stringRedisTemplate")
    private StringRedisTemplate redisTemplate;

    private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());

    /**
     * 处理连接建立事件。
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String userId = (String) session.getAttributes().get("userId");
        if (userId != null) {
            SESSIONS.put(userId, session);
            USER_SESSION_MAP.put(session.getId(), userId);
            log.info("WebSocket 连接建立: userId={}, sessionId={}", userId, session.getId());
            flushPendingNotifications(userId, session);
        } else {
            session.close(CloseStatus.BAD_DATA);
        }
    }

    /**
     * 处理连接关闭事件。
     */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        String userId = USER_SESSION_MAP.remove(session.getId());
        if (userId != null) {
            // 仅当映射的 session 仍是当前关闭的 session 时才移除，避免同用户新连接被误删
            SESSIONS.compute(userId, (k, existing) -> existing == null || existing.getId().equals(session.getId()) ? null : existing);
        }
        // 清理会话级锁，避免内存泄漏
        SESSION_LOCKS.remove(session.getId());
        log.info("WebSocket 连接关闭: sessionId={}, userId={}, status={}", session.getId(), userId, status);
    }

    /**
     * 推送购票结果。
     */
    public void pushBookingResultFlexible(String userIdOrUsername, BookingResult result) {
        try {
            String json = objectMapper.writeValueAsString(Map.of("type", "BOOKING_RESULT", "data", result));
            WebSocketSession session = SESSIONS.get(userIdOrUsername);
            if (session != null && session.isOpen()) {
                Object lock = SESSION_LOCKS.computeIfAbsent(session.getId(), k -> new Object());
                synchronized (lock) {
                    session.sendMessage(new TextMessage(json));
                    log.info("购票结果已推送: userId={}, status={}", userIdOrUsername, result.getStatus());
                }
            } else {
                redisTemplate.opsForList().rightPush(PENDING_NOTIFICATION_KEY + userIdOrUsername, json);
                log.info("购票结果已暂存Redis(用户未连接): userId={}", userIdOrUsername);
            }
        } catch (Exception e) {
            log.error("推送购票结果失败", e);
        }
    }

    /**
     * 推送退票通知。
     */
    public void pushRefundNotification(String userId, String message) {
        try {
            String json = objectMapper.writeValueAsString(Map.of(
                "type", "REFUND_NOTIFICATION",
                "message", message,
                "timestamp", System.currentTimeMillis()
            ));
            WebSocketSession session = SESSIONS.get(userId);
            if (session != null && session.isOpen()) {
                Object lock = SESSION_LOCKS.computeIfAbsent(session.getId(), k -> new Object());
                synchronized (lock) {
                    session.sendMessage(new TextMessage(json));
                }
            } else {
                redisTemplate.opsForList().rightPush(PENDING_NOTIFICATION_KEY + userId, json);
            }
        } catch (Exception e) {
            log.error("推送失败", e);
        }
    }

    /**
     * 推送离线通知。
     */
    private void flushPendingNotifications(String userId, WebSocketSession session) {
        String key = PENDING_NOTIFICATION_KEY + userId;
        try {
            // 逐条弹出，避免并发连接重复投递
            List<String> pending = new java.util.ArrayList<>();
            String msg;
            while ((msg = redisTemplate.opsForList().leftPop(key)) != null) {
                pending.add(msg);
            }
            if (pending.isEmpty()) return;
            Object lock = SESSION_LOCKS.computeIfAbsent(session.getId(), k -> new Object());
            synchronized (lock) {
                for (String json : pending) {
                    if (session.isOpen()) session.sendMessage(new TextMessage(json));
                }
            }
            log.info("已推送{}条离线消息给用户: userId={}", pending.size(), userId);
        } catch (Exception e) {
            log.error("投递离线消息失败", e);
        }
    }

    /**
     * 广播排行榜更新消息给所有连接的客户端。
     */
    public void broadcastRankingUpdate(String travelDate) {
        try {
            String json = objectMapper.writeValueAsString(Map.of(
                "type", "RANKING_UPDATE",
                "travelDate", travelDate,
                "timestamp", System.currentTimeMillis()
            ));
            for (WebSocketSession session : SESSIONS.values()) {
                if (session != null && session.isOpen()) {
                    Object lock = SESSION_LOCKS.computeIfAbsent(session.getId(), k -> new Object());
                    synchronized (lock) {
                        session.sendMessage(new TextMessage(json));
                    }
                }
            }
            log.info("排行榜更新已广播: travelDate={}, 连接数={}", travelDate, SESSIONS.size());
        } catch (Exception e) {
            log.error("广播排行榜更新失败", e);
        }
    }
}
