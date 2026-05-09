package com.ticket.train.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.model.entity.Route;
import com.ticket.model.entity.Train;
import com.ticket.model.request.FindTrainRequest;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.train.mapper.RouteMapper;
import com.ticket.train.mapper.TrainMapper;
import com.ticket.train.service.TrainService;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.List;
import java.util.Objects;

/**
 * 车次核心服务实现，管理车次信息、路线查询、车次状态等业务。
 * @author 铁路票务系统
 */
@Slf4j
@Service
public class TrainServiceImpl extends ServiceImpl<TrainMapper, Train> implements TrainService {

    @Resource
    private TrainMapper trainMapper;
    
    @Resource
    private RouteMapper routeMapper;

    /**
     * 根据ID查询车次。
     */
    @SentinelResource(value = "getTrainById", blockHandler = "trainBlockHandler")
    @Override
    public Result<Train> getTrainById(Integer trainId) {
        try {
            Train train = trainMapper.selectById(trainId);
            return train != null ? Result.success(train) : Result.error("车次不存在");
        } catch (Exception e) {
            return Result.error("查询车次异常：" + e.getMessage());
        }
    }
    
    private static final String DEFAULT_START_STATION = "南宁站";
    
    /**
     * 新增车次。
     */
    @Override
    @Transactional
    public Result<Train> addTrain(Train train) {
        try {
            train.setStartStation(DEFAULT_START_STATION);
            if (trainMapper.selectCount(new LambdaQueryWrapper<Train>().eq(Train::getTrainNumber, train.getTrainNumber())) > 0) {
                return Result.error("车次号已存在");
            }
            if (train.getStatus() == null) train.setStatus(1);
            if (train.getTotalSeats() == null) train.setTotalSeats(0);
            
            // 注意：由于数据库拆分，存储过程需要在 rts_train 库中存在
            trainMapper.insert(train);
            
            Train newTrain = trainMapper.selectOne(new LambdaQueryWrapper<Train>().eq(Train::getTrainNumber, train.getTrainNumber()));
            return newTrain != null ? Result.success(newTrain) : Result.error("新增车次失败");
        } catch (Exception e) {
            log.error("新增车次异常", e);
            return Result.error("新增车次异常：" + e.getMessage());
        }
    }
    
    /**
     * 更新车次信息。
     */
    @Override
    @Transactional
    public Result<Train> updateTrain(Train train) {
        try {
            train.setStartStation(DEFAULT_START_STATION);
            Train old = trainMapper.selectById(train.getTrainId());
            if (old == null) return Result.error("车次不存在");
            
            if (trainMapper.selectCount(new LambdaQueryWrapper<Train>()
                    .eq(Train::getTrainNumber, train.getTrainNumber()).ne(Train::getTrainId, train.getTrainId())) > 0) {
                return Result.error("车次号已被使用");
            }
            
            if (trainMapper.updateById(train) > 0) {
                return Result.success(trainMapper.selectById(train.getTrainId()));
            }
            return Result.error("修改车次失败");
        } catch (Exception e) {
            return Result.error("修改车次异常：" + e.getMessage());
        }
    }
    
    /**
     * 删除车次。
     */
    @Override
    @Transactional
    public Result<Boolean> deleteTrain(Integer trainId) {
        try {
            if (trainMapper.selectById(trainId) == null) return Result.error("车次不存在");
            // 注意：在分布式环境下，跨服务的校验（如是否有活跃票）需要通过 Feign 调用 ticketing-service
            // 这里暂时保留简单删除，实际迁移时需加 Feign 校验
            return trainMapper.deleteById(trainId) > 0 ? Result.success(true) : Result.error("删除车次失败");
        } catch (Exception e) {
            return Result.error("删除车次异常：" + e.getMessage());
        }
    }
    
    /**
     * 批量删除车次。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> batchDeleteTrains(List<Integer> trainIds) {
        if (trainIds == null || trainIds.isEmpty()) return Result.error("车次ID列表不能为空");
        try {
            for (Integer id : trainIds) {
                Result<Boolean> res = deleteTrain(id);
                if (!res.isSuccess()) {
                    // 抛出异常触发事务回滚，否则部分删除成功会造成数据不一致
                    throw new RuntimeException("批量删除失败（ID:" + id + "）：" + res.getMessage());
                }
            }
            return Result.success(true);
        } catch (RuntimeException e) {
            log.error("批量删除车次异常", e);
            throw e;
        }
    }
    
    /**
     * 更新车次状态。
     */
    @Override
    @Transactional
    public Result<Boolean> updateTrainStatus(Integer trainId, Integer status) {
        try {
            Train t = trainMapper.selectById(trainId);
            if (t == null) return Result.error("车次不存在");
            t.setStatus(status);
            return trainMapper.updateById(t) > 0 ? Result.success(true) : Result.error("更新状态失败");
        } catch (Exception e) {
            return Result.error("更新车次状态异常：" + e.getMessage());
        }
    }
    
    /**
     * 获取所有车次列表。
     */
    @SentinelResource(value = "getAllTrains", blockHandler = "trainBlockHandler")
    @Override
    public Result<Object> getAllTrains() {
        try {
            return Result.success(trainMapper.selectList(null));
        } catch (Exception e) {
            return Result.error("获取车次列表异常：" + e.getMessage());
        }
    }

    /**
     * 搜索车次。
     */
    @SentinelResource(value = "searchTrains", blockHandler = "trainBlockHandler")
    @Override
    public Result<Object> searchTrains(PageRequest pageRequest, FindTrainRequest req) {
        Page<Train> page = new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize());
        LambdaQueryWrapper<Train> wrapper = new LambdaQueryWrapper<>();
        
        if (req.getTrainNumber() != null && !req.getTrainNumber().isBlank()) wrapper.like(Train::getTrainNumber, req.getTrainNumber());
        if (req.getTrainId() != null) wrapper.eq(Train::getTrainId, req.getTrainId());
        if (req.getTrainType() != null && !req.getTrainType().isBlank()) wrapper.eq(Train::getTrainType, req.getTrainType());
        if (req.getStartStation() != null && !req.getStartStation().isBlank()) wrapper.like(Train::getStartStation, req.getStartStation());
        if (req.getEndStation() != null && !req.getEndStation().isBlank()) wrapper.like(Train::getEndStation, req.getEndStation());
        
        if (req.getMinDepartureTime() != null) wrapper.ge(Train::getDepartureTime, req.getMinDepartureTime());
        if (req.getMaxDepartureTime() != null) wrapper.le(Train::getDepartureTime, req.getMaxDepartureTime());
        if (req.getMinArrivalTime() != null) wrapper.ge(Train::getArrivalTime, req.getMinArrivalTime());
        if (req.getMaxArrivalTime() != null) wrapper.le(Train::getArrivalTime, req.getMaxArrivalTime());
        if (req.getBasePrice() != null) wrapper.eq(Train::getBasePrice, req.getBasePrice());
        
        if (req.getStatus() != null) wrapper.eq(Train::getStatus, req.getStatus());
        else if (req.getShowAll() == null || !req.getShowAll()) wrapper.eq(Train::getStatus, 1);

        wrapper.orderByDesc(Train::getCreatedAt);
        return Result.success(trainMapper.selectPage(page, wrapper));
    }

    /**
     * 获取车次路线。
     */
    @SentinelResource(value = "getTrainRoutes", blockHandler = "trainBlockHandler")
    @Override
    public Result<Object> getTrainRoutes(Integer trainId) {
        try {
            if (trainMapper.selectById(trainId) == null) return Result.error("车次不存在");
            return Result.success(routeMapper.selectList(new LambdaQueryWrapper<Route>()
                    .eq(Route::getTrainId, trainId).orderByAsc(Route::getStopOrder)));
        } catch (Exception e) {
            return Result.error("查询途径站失败：" + e.getMessage());
        }
    }

    /**
     * 车次服务限流降级处理方法（Object类型）。
     */
    public static Result<Object> trainBlockHandler(Object req, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        return Result.error("系统繁忙，请稍后重试（车次服务限流）");
    }

    /**
     * 车次服务限流降级处理方法（Train类型）。
     */
    public static Result<Train> trainBlockHandler(Integer trainId, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        return Result.error("系统繁忙，请稍后重试（车次服务限流）");
    }
}
