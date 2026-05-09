package com.ticket.notification.mq;

import com.ticket.constant.MqConstants;
import com.ticket.notification.websocket.TicketWebSocketHandler;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 热点车次排行榜更新监听器。
 */
@Slf4j
@Component
public class HotTrainRankingListener {

    @Resource
    private TicketWebSocketHandler ticketWebSocketHandler;

    /**
     * 监听排行榜更新消息并推送给所有连接的客户端。
     */
    @RabbitListener(queues = MqConstants.HOT_TRAIN_RANKING_QUEUE)
    public void handleRankingUpdate(Map<String, Object> message) {
        try {
            String travelDate = (String) message.get("travelDate");
            log.info("收到排行榜更新消息: travelDate={}", travelDate);
            ticketWebSocketHandler.broadcastRankingUpdate(travelDate);
        } catch (Exception e) {
            log.error("处理排行榜更新消息失败", e);
        }
    }
}
