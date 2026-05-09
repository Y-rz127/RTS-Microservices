package com.ticket.api.feign;

import com.ticket.model.entity.Train;
import com.ticket.model.entity.Station;
import com.ticket.model.response.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

/**
 * 车次服务 Feign 客户端接口。
 */
@FeignClient(name = "train-service")
public interface TrainFeignClient {

    @GetMapping("/api/train/{trainId}")
    Result<Train> getTrainById(@PathVariable("trainId") Integer trainId);

    @GetMapping("/api/station/{stationId}")
    Result<Station> getStationById(@PathVariable("stationId") Integer stationId);
}
