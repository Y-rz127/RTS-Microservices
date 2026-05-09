package com.ticket.train.controller;

import com.ticket.annotation.Log;
import com.ticket.model.entity.Train;
import com.ticket.model.request.PageRequest;
import com.ticket.model.request.FindTrainRequest;
import com.ticket.model.response.Result;
import com.ticket.train.service.TrainService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 车次管理控制器。
 */
@RestController
@RequestMapping("/api/train")
public class TrainController {

    @Resource
    private TrainService trainService;

    /**
     * 按编号查询车次。
     */
    @GetMapping("/{trainId}")
    public Result<Train> getTrainById(@PathVariable Integer trainId) {
        return trainService.getTrainById(trainId);
    }

    /**
     * 条件分页查询车次。
     */
    @GetMapping("/search")
    public Result<Object> searchTrains(
            PageRequest pageRequest,
            @ModelAttribute FindTrainRequest request
    ) {
        return trainService.searchTrains(pageRequest, request);
    }
    
    /**
     * 查询全部车次。
     */
    @GetMapping("/list")
    public Result<Object> getAllTrains() {
        return trainService.getAllTrains();
    }
    
    /**
     * 新增车次。
     */
    @PostMapping("/add")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "车次管理", operation = "新增")
    public Result<Train> addTrain(@RequestBody Train train) {
        return trainService.addTrain(train);
    }
    
    /**
     * 更新车次。
     */
    @PutMapping("/update")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "车次管理", operation = "修改")
    public Result<Train> updateTrain(@RequestBody Train train) {
        return trainService.updateTrain(train);
    }
    
    /**
     * 删除车次。
     */
    @DeleteMapping("/delete/{trainId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "车次管理", operation = "删除")
    public Result<Boolean> deleteTrain(@PathVariable Integer trainId) {
        return trainService.deleteTrain(trainId);
    }
    
    /**
     * 批量删除车次。
     */
    @DeleteMapping("/batch")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "车次管理", operation = "删除")
    public Result<Boolean> batchDeleteTrains(@RequestBody List<Integer> trainIds) {
        return trainService.batchDeleteTrains(trainIds);
    }
    
    /**
     * 更新车次状态。
     */
    @PutMapping("/status/{trainId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "车次管理", operation = "修改")
    public Result<Boolean> updateTrainStatus(@PathVariable Integer trainId, @RequestParam Integer status) {
        return trainService.updateTrainStatus(trainId, status);
    }
    
    /**
     * 查询车次途经站点。
     */
    @GetMapping("/{trainId}/routes")
    public Result<Object> getTrainRoutes(@PathVariable Integer trainId) {
        return trainService.getTrainRoutes(trainId);
    }
}
