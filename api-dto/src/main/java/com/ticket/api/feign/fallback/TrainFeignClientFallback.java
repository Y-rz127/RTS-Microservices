package com.ticket.api.feign.fallback;

import com.ticket.api.feign.TrainFeignClient;
import com.ticket.model.entity.Station;
import com.ticket.model.entity.Train;
import com.ticket.model.response.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.openfeign.FallbackFactory;

/**
 * 车次服务 Feign 客户端降级处理类。
 */
@Slf4j
public class TrainFeignClientFallback implements FallbackFactory<TrainFeignClient> {
    @Override
    public TrainFeignClient create(Throwable cause) {
        log.error("train-service 调用失败，触发熔断降级", cause);
        return new TrainFeignClient() {
            @Override
            public Result<Train> getTrainById(Integer trainId) {
                return Result.error("车次服务暂不可用，请稍后重试");
            }

            @Override
            public Result<Station> getStationById(Integer stationId) {
                return Result.error("车站服务暂不可用，请稍后重试");
            }
        };
    }
}
