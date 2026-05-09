package com.ticket.train.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.Train;
import com.ticket.model.request.PageRequest;
import com.ticket.model.request.FindTrainRequest;
import com.ticket.model.response.Result;

import java.util.List;

/**
 * 车次服务接口。
 */
public interface TrainService extends IService<Train> {
    /**
     * 根据车次ID获取车次。
     */
    Result<Train> getTrainById(Integer trainId);

    /**
     * 搜索车次。
     */
    Result<Object> searchTrains(PageRequest pageRequest, FindTrainRequest request);

    /**
     * 添加车次。
     */
    Result<Train> addTrain(Train train);

    /**
     * 更新车次。
     */
    Result<Train> updateTrain(Train train);

    /**
     * 删除车次。
     */
    Result<Boolean> deleteTrain(Integer trainId);

    /**
     * 批量删除车次。
     */
    Result<Boolean> batchDeleteTrains(List<Integer> trainIds);

    /**
     * 更新车次状态。
     */
    Result<Boolean> updateTrainStatus(Integer trainId, Integer status);

    /**
     * 获取所有车次。
     */
    Result<Object> getAllTrains();

    /**
     * 获取车次线路。
     */
    Result<Object> getTrainRoutes(Integer trainId);
}
