package com.ticket.train.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.model.entity.Route;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.train.mapper.RouteMapper;
import com.ticket.train.service.RouteService;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 车次线路服务实现类。
 */
@Service
public class RouteServiceImpl extends ServiceImpl<RouteMapper, Route> implements RouteService {

    @Resource
    private RouteMapper routeMapper;

    /**
     * 根据ID查询路线。
     */
    @Override
    public Result<Route> getRouteById(Integer routeId) {
        Route route = routeMapper.selectById(routeId);
        return route != null ? Result.success(route) : Result.error(404, "途经站点不存在");
    }

    /**
     * 分页查询路线列表。
     */
    @Override
    public Result<Object> getRoutePage(PageRequest pageRequest, Integer trainId, Integer stationId) {
        Page<Route> page = new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize());
        LambdaQueryWrapper<Route> wrapper = new LambdaQueryWrapper<>();
        if (trainId != null) wrapper.eq(Route::getTrainId, trainId);
        if (stationId != null) wrapper.eq(Route::getStationId, stationId);
        
        wrapper.orderByAsc(Route::getTrainId).orderByAsc(Route::getStopOrder);
        return Result.success(routeMapper.selectPage(page, wrapper));
    }

    /**
     * 根据车次ID查询路线列表。
     */
    @Override
    public Result<List<Route>> getRoutesByTrainId(Integer trainId) {
        LambdaQueryWrapper<Route> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Route::getTrainId, trainId).orderByAsc(Route::getStopOrder);
        return Result.success(routeMapper.selectList(wrapper));
    }

    /**
     * 新增路线。
     */
    @Override
    public Result<Route> addRoute(Route route) {
        if (route == null || route.getTrainId() == null || route.getStationId() == null) {
            return Result.error("参数不完整（车次ID和车站ID必填）");
        }
        return routeMapper.insert(route) > 0 ? Result.success(route) : Result.error("添加途经站点失败");
    }

    /**
     * 批量新增路线。
     */
    @Override
    public Result<Boolean> addRoutes(List<Route> routes) {
        if (routes == null || routes.isEmpty()) return Result.error("途经站点列表不能为空");
        return this.saveBatch(routes) ? Result.success(true) : Result.error("批量添加途经站点失败");
    }

    /**
     * 更新路线信息。
     */
    @Override
    public Result<Route> updateRoute(Route route) {
        if (route == null || route.getRouteId() == null) return Result.error("途经站点ID不能为空");
        return routeMapper.updateById(route) > 0 ? Result.success(route) : Result.error("更新途经站点失败");
    }

    /**
     * 删除路线。
     */
    @Override
    public Result<Boolean> deleteRoute(Integer routeId) {
        if (routeId == null) return Result.error("途经站点ID不能为空");
        return routeMapper.deleteById(routeId) > 0 ? Result.success(true) : Result.error("删除途经站点失败");
    }

    /**
     * 根据车次ID删除路线。
     */
    @Override
    public Result<Boolean> deleteRoutesByTrainId(Integer trainId) {
        if (trainId == null) return Result.error("车次ID不能为空");
        LambdaQueryWrapper<Route> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Route::getTrainId, trainId);
        int rows = routeMapper.delete(wrapper);
        return Result.success(true, "成功删除 " + rows + " 条途经站点记录");
    }
}
