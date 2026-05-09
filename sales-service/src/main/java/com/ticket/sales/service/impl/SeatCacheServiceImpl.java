package com.ticket.sales.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ticket.Enum.seatStatusEnum;
import com.ticket.sales.mapper.SeatMapper;
import com.ticket.model.entity.Seat;
import com.ticket.sales.service.SeatCacheService;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.sql.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * 座位缓存服务实现类。
 */
@Slf4j
@Service
public class SeatCacheServiceImpl implements SeatCacheService {

    @Resource(name = "stringRedisTemplate")
    private StringRedisTemplate redisTemplate;

    @Resource
    private SeatMapper seatMapper;

    private final ObjectMapper objectMapper = new ObjectMapper();

    private static final String SEAT_CACHE_PREFIX = "seat:availability:";
    private static final String SEAT_COUNT_PREFIX = "seat:count:";
    private static final String HOT_TRAIN_PREFIX = "train:hot:";
    private static final long CACHE_TTL = 10;

    /**
     * 获取车次座位可用性列表（优先 Redis 缓存）
     */
    @Override
    public List<Map<String, Serializable>> getSeatAvailability(Integer trainId, String travelDate) {
        String cacheKey = SEAT_CACHE_PREFIX + trainId + ":" + travelDate;
        try {
            String cachedData = redisTemplate.opsForValue().get(cacheKey);
            if (cachedData != null) {
                return objectMapper.readValue(cachedData, objectMapper.getTypeFactory()
                        .constructCollectionType(List.class, objectMapper.getTypeFactory()
                                .constructMapType(LinkedHashMap.class, String.class, Serializable.class)));
            }
        } catch (Exception e) {
            log.error("座位缓存反序列化失败", e);
        }

        List<Map<String, Serializable>> seatList = querySeatFromDB(trainId, travelDate);
        try {
            String json = objectMapper.writeValueAsString(seatList);
            redisTemplate.opsForValue().set(cacheKey, json, CACHE_TTL, TimeUnit.MINUTES);
        } catch (Exception e) {
            log.error("座位缓存序列化失败", e);
        }
        return seatList;
    }

    /**
     * 获取车次可用座位数量（优先 Redis 缓存）
     */
    @Override
    public Integer getAvailableSeatCount(Integer trainId, String travelDate, String seatType) {
        String typeKey = (seatType != null && !seatType.isBlank()) ? seatType : "ALL";
        String cacheKey = SEAT_COUNT_PREFIX + trainId + ":" + travelDate + ":" + typeKey;
        try {
            String cachedCount = redisTemplate.opsForValue().get(cacheKey);
            if (cachedCount != null) return Integer.parseInt(cachedCount);
        } catch (Exception e) {
            log.error("座位数量缓存读取失败", e);
        }

        LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Seat::getTrainId, trainId)
               .eq(Seat::getTravelDate, Date.valueOf(travelDate))
               .eq(Seat::getStatus, seatStatusEnum.AVAILABLE);
        if (seatType != null && !seatType.isBlank()) wrapper.eq(Seat::getSeatType, seatType);

        Long count = seatMapper.selectCount(wrapper);
        if (count != null) {
            redisTemplate.opsForValue().set(cacheKey, count.toString(), CACHE_TTL, TimeUnit.MINUTES);
        }
        return count != null ? count.intValue() : 0;
    }

    /**
     * 更新座位缓存（清理该车次缓存并递增热门车次计数）
     */
    @Override
    public void updateSeatCache(Integer trainId, String travelDate, Integer seatId, String seatType, boolean isAvailable) {
        clearSeatCache(trainId, travelDate);
        String hotKey = HOT_TRAIN_PREFIX + trainId + ":" + travelDate;
        redisTemplate.opsForValue().increment(hotKey, 1);
        redisTemplate.expire(hotKey, 1, TimeUnit.HOURS);
    }

    /**
     * 刷新座位缓存（先清理再重新加载）
     */
    @Override
    public void refreshSeatCache(Integer trainId, String travelDate) {
        clearSeatCache(trainId, travelDate);
        getSeatAvailability(trainId, travelDate);
    }

    /**
     * 清理指定车次的座位相关缓存
     */
    @Override
    public void clearSeatCache(Integer trainId, String travelDate) {
        String basePattern = trainId + ":" + travelDate;
        deleteKeysByPattern(SEAT_CACHE_PREFIX + basePattern + "*");
        deleteKeysByPattern(SEAT_COUNT_PREFIX + basePattern + "*");
        deleteKeysByPattern(HOT_TRAIN_PREFIX + basePattern + "*");
        log.info("已清理车次座位缓存: trainId={}, travelDate={}", trainId, travelDate);
    }

    /**
     * 按模式删除 Redis key
     */
    private void deleteKeysByPattern(String pattern) {
        Set<String> keys = redisTemplate.keys(pattern);
        if (keys != null && !keys.isEmpty()) redisTemplate.delete(keys);
    }

    /**
     * 判断车次是否为热门车次（计数 >100）
     */
    @Override
    public boolean isHotTrain(Integer trainId, String travelDate) {
        String hotKey = HOT_TRAIN_PREFIX + trainId + ":" + travelDate;
        String count = redisTemplate.opsForValue().get(hotKey);
        return count != null && Integer.parseInt(count) > 100;
    }

    /**
     * 按票 ID 清理全量座位缓存（订单取消时调用）
     */
    @Override
    public void clearSeatCacheByTicketId(Integer ticketId) {
        deleteKeysByPattern(SEAT_CACHE_PREFIX + "*");
        deleteKeysByPattern(SEAT_COUNT_PREFIX + "*");
    }

    /**
     * 从数据库查询座位列表
     */
    private List<Map<String, Serializable>> querySeatFromDB(Integer trainId, String travelDate) {
        LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Seat::getTrainId, trainId)
               .eq(Seat::getTravelDate, Date.valueOf(travelDate))
               .orderByAsc(Seat::getCarriageNumber, Seat::getSeatNumber);

        return seatMapper.selectList(wrapper).stream()
                .map(seat -> {
                    Map<String, Serializable> seatMap = new LinkedHashMap<>();
                    seatMap.put("seatId", seat.getSeatId());
                    seatMap.put("seatNumber", seat.getSeatNumber());
                    seatMap.put("carriageNumber", seat.getCarriageNumber());
                    seatMap.put("seatType", seat.getSeatType());
                    seatMap.put("status", seat.getStatus());
                    seatMap.put("priceCoefficient", seat.getPriceCoefficient());
                    return seatMap;
                })
                .collect(java.util.stream.Collectors.toList());
    }
}
