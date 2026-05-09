package com.ticket.train.controller;

import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.ticket.model.entity.Dictionary;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.train.service.DictionaryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 数据字典控制器。
 */
@RestController
@RequestMapping("/api/dictionary")
@Tag(name = "数据字典管理")
public class DictionaryController {

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（字典服务限流）";

    @Resource
    private DictionaryService dictionaryService;

    /**
     * 新增字典。
     */
    @PostMapping("/add")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "新增字典")
    public Result<Dictionary> addDictionary(@RequestBody Dictionary dictionary) {
        return dictionaryService.addDictionary(dictionary);
    }

    /**
     * 更新字典。
     */
    @PutMapping("/update")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "更新字典")
    public Result<Dictionary> updateDictionary(@RequestBody Dictionary dictionary) {
        return dictionaryService.updateDictionary(dictionary);
    }

    /**
     * 删除字典。
     */
    @DeleteMapping("/delete/{dictId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "删除字典")
    public Result<Boolean> deleteDictionary(@PathVariable Integer dictId) {
        return dictionaryService.deleteDictionary(dictId);
    }

    /**
     * 查询字典详情。
     */
    @GetMapping("/{dictId}")
    @SentinelResource(value = "dictionaryById", blockHandler = "getDictionaryByIdBlockHandler")
    @Operation(summary = "查询字典详情")
    public Result<Dictionary> getDictionaryById(@PathVariable Integer dictId) {
        return dictionaryService.getDictionaryById(dictId);
    }

    /**
     * 按类型查询字典列表。
     */
    @GetMapping("/type/{dictType}")
    @SentinelResource(value = "dictionaryByType", blockHandler = "getDictionaryByTypeBlockHandler")
    @Operation(summary = "根据类型获取字典列表")
    public Result<List<Dictionary>> getDictionaryByType(@PathVariable String dictType) {
        return dictionaryService.getDictionaryByType(dictType);
    }

    /**
     * 按类型和编码查询字典。
     */
    @GetMapping("/type/{dictType}/code/{dictCode}")
    @SentinelResource(value = "dictionaryByTypeAndCode", blockHandler = "getDictionaryByTypeAndCodeBlockHandler")
    @Operation(summary = "根据类型和代码获取字典")
    public Result<Dictionary> getDictionaryByTypeAndCode(@PathVariable String dictType,
                                                          @PathVariable String dictCode) {
        return dictionaryService.getDictionaryByTypeAndCode(dictType, dictCode);
    }

    /**
     * 分页查询字典。
     */
    @GetMapping("/page")
    @SentinelResource(value = "dictionaryPage", blockHandler = "getDictionaryPageBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "分页查询字典")
    public Result<Object> getDictionaryPage(PageRequest pageRequest,
                                            @RequestParam(required = false) String dictType,
                                            @RequestParam(required = false) String dictLabel) {
        return dictionaryService.getDictionaryPage(pageRequest, dictType, dictLabel);
    }

    /**
     * 查询全部字典类型。
     */
    @GetMapping("/types")
    @SentinelResource(value = "dictionaryTypes", blockHandler = "getAllDictTypesBlockHandler")
    @Operation(summary = "获取所有字典类型")
    public Result<List<String>> getAllDictTypes() {
        return dictionaryService.getAllDictTypes();
    }

    /**
     * 查询字典详情限流处理。
     */
    public static Result<Dictionary> getDictionaryByIdBlockHandler(Integer dictId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 按类型查询字典限流处理。
     */
    public static Result<List<Dictionary>> getDictionaryByTypeBlockHandler(String dictType, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 按类型和编码查询字典限流处理。
     */
    public static Result<Dictionary> getDictionaryByTypeAndCodeBlockHandler(String dictType, String dictCode, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 分页查询字典限流处理。
     */
    public static Result<Object> getDictionaryPageBlockHandler(PageRequest pageRequest, String dictType, String dictLabel, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 查询字典类型限流处理。
     */
    public static Result<List<String>> getAllDictTypesBlockHandler(BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
