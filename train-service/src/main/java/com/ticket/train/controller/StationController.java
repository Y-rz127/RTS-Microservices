package com.ticket.train.controller;

import com.ticket.annotation.Log;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.model.entity.Station;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.train.service.StationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

/**
 * 车站管理控制器。
 */
@RestController
@RequestMapping("/api/station")
@Tag(name = "车站管理")
public class StationController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（车站服务限流）";

    @Resource
    private StationService stationService;

    /**
     * 新增车站。
     */
    @PostMapping("/add")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "新增车站")
    @Log(module = "车站管理", operation = "新增")
    public Result<Station> addStation(@RequestBody Station station) {
        return stationService.addStation(station);
    }

    /**
     * 更新车站。
     */
    @PutMapping("/update")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "更新车站")
    @Log(module = "车站管理", operation = "修改")
    public Result<Station> updateStation(@RequestBody Station station) {
        return stationService.updateStation(station);
    }

    /**
     * 删除车站。
     */
    @DeleteMapping("/delete/{stationId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "删除车站")
    @Log(module = "车站管理", operation = "删除")
    public Result<Boolean> deleteStation(@PathVariable Integer stationId) {
        return stationService.deleteStation(stationId);
    }

    /**
     * 更新车站状态。
     */
    @PutMapping("/status/{stationId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "更新车站状态")
    @Log(module = "车站管理", operation = "状态变更")
    public Result<Boolean> updateStationStatus(@PathVariable Integer stationId, @RequestParam Integer status) {
        return stationService.updateStationStatus(stationId, status);
    }

    /**
     * 查询车站详情。
     */
    @GetMapping("/{stationId}")
    @SentinelResource(value = "stationById", blockHandler = "getStationByIdBlockHandler")
    @Operation(summary = "查询车站详情")
    public Result<Station> getStationById(@PathVariable Integer stationId) {
        return stationService.getStationById(stationId);
    }

    /**
     * 分页查询车站。
     */
    @GetMapping("/page")
    @SentinelResource(value = "stationPage", blockHandler = "getStationPageBlockHandler")
    @Operation(summary = "分页查询车站")
    public Result<Object> getStationPage(PageRequest pageRequest,
                                        @RequestParam(required = false) String stationName,
                                        @RequestParam(required = false) String city) {
        return stationService.getStationPage(pageRequest, stationName, city);
    }

    /**
     * 查询全部车站。
     */
    @GetMapping("/all")
    @SentinelResource(value = "stationAll", blockHandler = "getAllStationsBlockHandler")
    @Operation(summary = "获取所有车站")
    public Result<Object> getAllStations() {
        return stationService.getAllStations();
    }

    /**
     * 查询车站详情限流处理。
     */
    public static Result<Station> getStationByIdBlockHandler(Integer stationId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 分页查询车站限流处理。
     */
    public static Result<Object> getStationPageBlockHandler(PageRequest pageRequest, String stationName, String city, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 查询全部车站限流处理。
     */
    public static Result<Object> getAllStationsBlockHandler(BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
