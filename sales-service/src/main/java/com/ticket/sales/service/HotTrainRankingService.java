package com.ticket.sales.service;

import java.util.List;
import java.util.Map;

/**
 * 热点车次排行榜服务接口。
 */
public interface HotTrainRankingService {

    /**
     * 更新车次热度（购票时调用）。
     */
    void incrementTrainHotness(Integer trainId, String travelDate);

    /**
     * 减少车次热度（退票时调用）。
     */
    void decrementTrainHotness(Integer trainId, String travelDate);

    /**
     * 获取热点车次排行榜。
     */
    List<Map<String, Object>> getHotTrainRanking(String travelDate, int topN);

    /**
     * 发送排行榜更新通知到 MQ。
     */
    void notifyRankingUpdate(String travelDate);
}
