package com.ticket.train.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.Station;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;

/**
 * 车站服务接口。
 */
public interface StationService extends IService<Station> {
    /**
     * 根据车站ID获取车站。
     */
    Result<Station> getStationById(Integer stationId);

    /**
     * 分页查询车站列表。
     */
    Result<Object> getStationPage(PageRequest pageRequest, String stationName, String city);

    /**
     * 获取所有车站。
     */
    Result<Object> getAllStations();

    /**
     * 添加车站。
     */
    Result<Station> addStation(Station station);

    /**
     * 更新车站。
     */
    Result<Station> updateStation(Station station);

    /**
     * 删除车站。
     */
    Result<Boolean> deleteStation(Integer stationId);

    /**
     * 更新车站状态。
     */
    Result<Boolean> updateStationStatus(Integer stationId, Integer status);
}
