package com.ticket.sales.service.impl;

import com.ticket.constant.MqConstants;
import com.ticket.sales.service.HotTrainRankingService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * 热点车次排行榜服务实现类。
 */
@Slf4j
@Service
public class HotTrainRankingServiceImpl implements HotTrainRankingService {

    private static final String HOT_RANKING_KEY_PREFIX = "train:hot:ranking:";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Resource
    private RedisTemplate<String, Object> redisTemplate;

    @Resource
    private RabbitTemplate rabbitTemplate;

    @Override
    public void incrementTrainHotness(Integer trainId, String travelDate) {
        String key = HOT_RANKING_KEY_PREFIX + travelDate;
        String member = trainId.toString();
        redisTemplate.opsForZSet().incrementScore(key, member, 1);
        redisTemplate.expire(key, 24, TimeUnit.HOURS);
        log.info("车次热度增加: trainId={}, travelDate={}", trainId, travelDate);
    }

    @Override
    public void decrementTrainHotness(Integer trainId, String travelDate) {
        String key = HOT_RANKING_KEY_PREFIX + travelDate;
        String member = trainId.toString();
        redisTemplate.opsForZSet().incrementScore(key, member, -1);
        // 如果分数 <= 0，从排行榜中移除
        Double score = redisTemplate.opsForZSet().score(key, member);
        if (score != null && score <= 0) {
            redisTemplate.opsForZSet().remove(key, member);
        }
        log.info("车次热度减少: trainId={}, travelDate={}", trainId, travelDate);
    }

    @Override
    public List<Map<String, Object>> getHotTrainRanking(String travelDate, int topN) {
        String key = HOT_RANKING_KEY_PREFIX + travelDate;
        Set<Object> topTrains = redisTemplate.opsForZSet().reverseRange(key, 0, topN - 1);
        List<Map<String, Object>> result = new ArrayList<>();
        if (topTrains != null) {
            for (Object trainId : topTrains) {
                Double score = redisTemplate.opsForZSet().score(key, trainId);
                Map<String, Object> trainInfo = new HashMap<>();
                trainInfo.put("trainId", trainId);
                trainInfo.put("salesCount", score != null ? score.longValue() : 0);
                result.add(trainInfo);
            }
        }
        return result;
    }

    @Override
    public void notifyRankingUpdate(String travelDate) {
        try {
            Map<String, Object> message = new HashMap<>();
            message.put("type", "RANKING_UPDATE");
            message.put("travelDate", travelDate);
            message.put("timestamp", System.currentTimeMillis());
            rabbitTemplate.convertAndSend(
                MqConstants.HOT_TRAIN_RANKING_EXCHANGE,
                MqConstants.HOT_TRAIN_RANKING_ROUTING_KEY,
                message
            );
            log.info("排行榜更新通知已发送: travelDate={}", travelDate);
        } catch (Exception e) {
            log.error("排行榜更新通知发送失败", e);
        }
    }
}
