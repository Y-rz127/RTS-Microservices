package com.ticket.train.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.model.entity.Route;
import com.ticket.model.entity.Station;
import com.ticket.model.entity.Train;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.train.mapper.RouteMapper;
import com.ticket.train.mapper.StationMapper;
import com.ticket.train.mapper.TrainMapper;
import com.ticket.train.service.StationService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Time;
import java.util.List;

/**
 * 车站管理服务实现，提供车站信息的增删改查及删除后的路线自动修正。
 * @author 铁路票务系统
 */
@Service
public class StationServiceImpl extends ServiceImpl<StationMapper, Station> implements StationService {

    @Resource
    private StationMapper stationMapper;
    
    @Resource
    private RouteMapper routeMapper;
    
    @Resource
    private TrainMapper trainMapper;

    /**
     * 根据ID查询车站。
     */
    @Override
    public Result<Station> getStationById(Integer stationId) {
        Station station = stationMapper.selectById(stationId);
        return station != null ? Result.success(station) : Result.error(404, "车站不存在");
    }

    /**
     * 分页查询车站列表。
     */
    @Override
    public Result<Object> getStationPage(PageRequest pageRequest, String stationName, String city) {
        Page<Station> page = new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize());
        LambdaQueryWrapper<Station> wrapper = new LambdaQueryWrapper<>();
        if (stationName != null && !stationName.isBlank()) wrapper.like(Station::getStationName, stationName);
        if (city != null && !city.isBlank()) wrapper.eq(Station::getCity, city);
        
        wrapper.orderByDesc(Station::getCreatedAt);
        return Result.success(stationMapper.selectPage(page, wrapper));
    }

    /**
     * 获取所有车站列表。
     */
    @Override
    public Result<Object> getAllStations() {
        try {
            return Result.success(stationMapper.selectList(null));
        } catch (Exception e) {
            return Result.error("获取车站列表异常：" + e.getMessage());
        }
    }

    /**
     * 新增车站。
     */
    @Override
    @Transactional
    public Result<Station> addStation(Station station) {
        try {
            if (stationMapper.selectCount(new LambdaQueryWrapper<Station>().eq(Station::getStationName, station.getStationName())) > 0) {
                return Result.error("车站名称已存在");
            }
            if (station.getStatus() == null) station.setStatus(1);
            
            return stationMapper.insert(station) > 0 ? Result.success(station) : Result.error("新增车站失败");
        } catch (Exception e) {
            return Result.error("新增车站异常：" + e.getMessage());
        }
    }

    /**
     * 更新车站信息。
     */
    @Override
    @Transactional
    public Result<Station> updateStation(Station station) {
        try {
            if (stationMapper.selectById(station.getStationId()) == null) return Result.error("车站不存在");
            
            LambdaQueryWrapper<Station> wrapper = new LambdaQueryWrapper<Station>()
                    .eq(Station::getStationName, station.getStationName())
                    .ne(Station::getStationId, station.getStationId());
            if (stationMapper.selectCount(wrapper) > 0) return Result.error("车站名称已被使用");
            
            return stationMapper.updateById(station) > 0 ? 
                    Result.success(stationMapper.selectById(station.getStationId())) : Result.error("修改车站失败");
        } catch (Exception e) {
            return Result.error("修改车站异常：" + e.getMessage());
        }
    }

    /**
     * 删除车站。
     */
    @Override
    @Transactional
    public Result<Boolean> deleteStation(Integer stationId) {
        try {
            if (stationMapper.selectById(stationId) == null) return Result.error("车站不存在");
            
            List<Integer> affectedTrainIds = routeMapper.selectList(new LambdaQueryWrapper<Route>().eq(Route::getStationId, stationId))
                    .stream().map(Route::getTrainId).distinct().toList();
            
            affectedTrainIds.forEach(trainId -> updateTrainRouteAfterStationDelete(trainId, stationId));
            
            return stationMapper.deleteById(stationId) > 0 ? Result.success(true) : Result.error("删除车站失败");
        } catch (Exception e) {
            return Result.error("删除车站异常：" + e.getMessage());
        }
    }
    
    /**
     * 删除车站后更新车次路线。
     */
    private void updateTrainRouteAfterStationDelete(Integer trainId, Integer deletedStationId) {
        Train train = trainMapper.selectById(trainId);
        if (train == null) return;
        
        List<Route> routes = routeMapper.selectList(new LambdaQueryWrapper<Route>()
                .eq(Route::getTrainId, trainId).orderByAsc(Route::getStopOrder));
        if (routes.isEmpty()) return;
        
        routes.stream().filter(r -> r.getStationId().equals(deletedStationId)).findFirst()
                .ifPresent(r -> {
                    routeMapper.deleteById(r.getRouteId());
                    routes.remove(r);
                });
        
        if (routes.isEmpty()) return;
        
        long totalMin = (train.getArrivalTime().getTime() - train.getDepartureTime().getTime()) / (60 * 1000);
        if (totalMin <= 0) totalMin += 1440;
        
        BigDecimal totalDist = routes.get(routes.size() - 1).getDistanceFromStart();
        if (totalDist == null || totalDist.signum() == 0) totalDist = new BigDecimal("1000");
        
        for (int i = 0; i < routes.size(); i++) {
            Route r = routes.get(i);
            int order = i + 1;
            r.setStopOrder(order);
            
            if (order == 1) {
                r.setArrivalTime(null);
                r.setDepartureTime(train.getDepartureTime());
                r.setDistanceFromStart(BigDecimal.ZERO);
                r.setAdditionalPrice(BigDecimal.ZERO);
            } else if (order == routes.size()) {
                r.setArrivalTime(train.getArrivalTime());
                r.setDepartureTime(null);
            } else {
                double ratio = (double) order / routes.size();
                r.setArrivalTime(new Time(train.getDepartureTime().getTime() + (long)(totalMin * ratio) * 60 * 1000));
                r.setDepartureTime(new Time(r.getArrivalTime().getTime() + (r.getStopDuration() != null ? r.getStopDuration() : 2) * 60 * 1000));
                r.setDistanceFromStart(totalDist.multiply(BigDecimal.valueOf(ratio)).setScale(2, RoundingMode.HALF_UP));
                r.setAdditionalPrice((train.getBasePrice() != null ? train.getBasePrice() : BigDecimal.ZERO)
                        .multiply(BigDecimal.valueOf(ratio * 0.1)).setScale(2, RoundingMode.HALF_UP));
            }
            routeMapper.updateById(r);
        }
    }

    /**
     * 更新车站状态。
     */
    @Override
    @Transactional
    public Result<Boolean> updateStationStatus(Integer stationId, Integer status) {
        try {
            Station s = stationMapper.selectById(stationId);
            if (s == null) return Result.error("车站不存在");
            s.setStatus(status);
            return stationMapper.updateById(s) > 0 ? Result.success(true) : Result.error("更新状态失败");
        } catch (Exception e) {
            return Result.error("更新车站状态异常：" + e.getMessage());
        }
    }
}
