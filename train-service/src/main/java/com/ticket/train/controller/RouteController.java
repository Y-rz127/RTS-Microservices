package com.ticket.train.controller;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.model.entity.Route;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.train.service.RouteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 路线管理控制器。
 */
@RestController
@RequestMapping("/api/route")
@Tag(name = "路线管理")
public class RouteController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（路线服务限流）";

    @Resource
    private RouteService routeService;

    /**
     * 新增途经站点。
     */
    @PostMapping("/add")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "新增途经站点")
    public Result<Route> addRoute(@RequestBody Route route) {
        return routeService.addRoute(route);
    }

    /**
     * 批量新增途经站点。
     */
    @PostMapping("/addBatch")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "批量新增途经站点")
    public Result<Boolean> addRoutes(@RequestBody List<Route> routes) {
        return routeService.addRoutes(routes);
    }

    /**
     * 更新途经站点。
     */
    @PutMapping("/update")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "更新途经站点")
    public Result<Route> updateRoute(@RequestBody Route route) {
        return routeService.updateRoute(route);
    }

    /**
     * 删除途经站点。
     */
    @DeleteMapping("/delete/{routeId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "删除途经站点")
    public Result<Boolean> deleteRoute(@PathVariable Integer routeId) {
        return routeService.deleteRoute(routeId);
    }

    /**
     * 删除车次的全部途经站点。
     */
    @DeleteMapping("/deleteByTrainId/{trainId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "删除车次的所有途经站点")
    public Result<Boolean> deleteRoutesByTrainId(@PathVariable Integer trainId) {
        return routeService.deleteRoutesByTrainId(trainId);
    }

    /**
     * 查询途经站点详情。
     */
    @GetMapping("/getById/{routeId}")
    @SentinelResource(value = "routeById", blockHandler = "getRouteByIdBlockHandler")
    @Operation(summary = "查询途经站点详情")
    public Result<Route> getRouteById(@PathVariable Integer routeId) {
        return routeService.getRouteById(routeId);
    }

    /**
     * 分页查询途经站点。
     */
    @GetMapping("/page")
    @SentinelResource(value = "routePage", blockHandler = "getRoutePageBlockHandler")
    @Operation(summary = "分页查询途经站点")
    public Result<Object> getRoutePage(PageRequest pageRequest,
                                       @RequestParam(required = false) Integer trainId,
                                       @RequestParam(required = false) Integer stationId) {
        return routeService.getRoutePage(pageRequest, trainId, stationId);
    }

    /**
     * 查询车次途经站点。
     */
    @GetMapping("/getByTrainId/{trainId}")
    @SentinelResource(value = "routeByTrainId", blockHandler = "getRoutesByTrainIdBlockHandler")
    @Operation(summary = "查询车次途经站点")
    public Result<List<Route>> getRoutesByTrainId(@PathVariable Integer trainId) {
        return routeService.getRoutesByTrainId(trainId);
    }

    /**
     * 查询途经站点详情限流处理。
     */
    public static Result<Route> getRouteByIdBlockHandler(Integer routeId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 分页查询途经站点限流处理。
     */
    public static Result<Object> getRoutePageBlockHandler(PageRequest pageRequest, Integer trainId, Integer stationId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 查询车次途经站点限流处理。
     */
    public static Result<List<Route>> getRoutesByTrainIdBlockHandler(Integer trainId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
