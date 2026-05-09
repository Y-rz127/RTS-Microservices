package com.ticket.train.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.Route;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;

import java.util.List;

/**
 * 车次线路服务接口。
 */
public interface RouteService extends IService<Route> {
    /**
     * 根据线路ID获取线路。
     */
    Result<Route> getRouteById(Integer routeId);

    /**
     * 分页查询线路列表。
     */
    Result<Object> getRoutePage(PageRequest pageRequest, Integer trainId, Integer stationId);

    /**
     * 根据车次ID获取线路列表。
     */
    Result<List<Route>> getRoutesByTrainId(Integer trainId);

    /**
     * 添加线路。
     */
    Result<Route> addRoute(Route route);

    /**
     * 批量添加线路。
     */
    Result<Boolean> addRoutes(List<Route> routes);

    /**
     * 更新线路。
     */
    Result<Route> updateRoute(Route route);

    /**
     * 删除线路。
     */
    Result<Boolean> deleteRoute(Integer routeId);

    /**
     * 根据车次ID删除线路。
     */
    Result<Boolean> deleteRoutesByTrainId(Integer trainId);
}
