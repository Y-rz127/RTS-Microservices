package com.ticket.train.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.model.entity.Dictionary;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;
import com.ticket.train.mapper.DictionaryMapper;
import com.ticket.train.service.DictionaryService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 数据字典服务实现类。
 */
@Service
public class DictionaryServiceImpl extends ServiceImpl<DictionaryMapper, Dictionary> implements DictionaryService {

    @Resource
    private DictionaryMapper dictionaryMapper;

    /**
     * 根据ID查询字典。
     */
    @Override
    public Result<Dictionary> getDictionaryById(Integer dictId) {
        try {
            Dictionary dict = dictionaryMapper.selectById(dictId);
            return dict != null ? Result.success(dict) : Result.error("字典不存在");
        } catch (Exception e) {
            return Result.error("查询字典异常：" + e.getMessage());
        }
    }

    /**
     * 根据类型查询字典列表。
     */
    @Override
    public Result<List<Dictionary>> getDictionaryByType(String dictType) {
        try {
            LambdaQueryWrapper<Dictionary> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Dictionary::getDictType, dictType)
                   .eq(Dictionary::getStatus, 1)
                   .orderByAsc(Dictionary::getSortOrder, Dictionary::getDictCode);
            return Result.success(dictionaryMapper.selectList(wrapper));
        } catch (Exception e) {
            return Result.error("查询字典列表异常：" + e.getMessage());
        }
    }

    /**
     * 根据类型和代码查询字典。
     */
    @Override
    public Result<Dictionary> getDictionaryByTypeAndCode(String dictType, String dictCode) {
        try {
            LambdaQueryWrapper<Dictionary> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Dictionary::getDictType, dictType)
                   .eq(Dictionary::getDictCode, dictCode)
                   .eq(Dictionary::getStatus, 1);
            Dictionary dict = dictionaryMapper.selectOne(wrapper);
            return dict != null ? Result.success(dict) : Result.error("字典不存在");
        } catch (Exception e) {
            return Result.error("查询字典异常：" + e.getMessage());
        }
    }

    /**
     * 新增字典。
     */
    @Override
    @Transactional
    public Result<Dictionary> addDictionary(Dictionary dictionary) {
        try {
            LambdaQueryWrapper<Dictionary> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Dictionary::getDictType, dictionary.getDictType())
                   .eq(Dictionary::getDictCode, dictionary.getDictCode());
            if (dictionaryMapper.selectCount(wrapper) > 0) return Result.error("该类型下的字典代码已存在");
            
            if (dictionary.getStatus() == null) dictionary.setStatus(1);
            if (dictionary.getSortOrder() == null) dictionary.setSortOrder(0);
            
            return dictionaryMapper.insert(dictionary) > 0 ? Result.success(dictionary) : Result.error("新增字典失败");
        } catch (Exception e) {
            return Result.error("新增字典异常：" + e.getMessage());
        }
    }

    /**
     * 更新字典信息。
     */
    @Override
    @Transactional
    public Result<Dictionary> updateDictionary(Dictionary dictionary) {
        try {
            if (dictionaryMapper.selectById(dictionary.getDictId()) == null) return Result.error("字典不存在");
            
            LambdaQueryWrapper<Dictionary> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Dictionary::getDictType, dictionary.getDictType())
                   .eq(Dictionary::getDictCode, dictionary.getDictCode())
                   .ne(Dictionary::getDictId, dictionary.getDictId());
            if (dictionaryMapper.selectCount(wrapper) > 0) return Result.error("该类型下的字典代码已被使用");
            
            return dictionaryMapper.updateById(dictionary) > 0 ? 
                    Result.success(dictionaryMapper.selectById(dictionary.getDictId())) : Result.error("更新字典失败");
        } catch (Exception e) {
            return Result.error("更新字典异常：" + e.getMessage());
        }
    }

    /**
     * 删除字典。
     */
    @Override
    @Transactional
    public Result<Boolean> deleteDictionary(Integer dictId) {
        try {
            if (dictionaryMapper.selectById(dictId) == null) return Result.error("字典不存在");
            return dictionaryMapper.deleteById(dictId) > 0 ? Result.success(true) : Result.error("删除字典失败");
        } catch (Exception e) {
            return Result.error("删除字典异常：" + e.getMessage());
        }
    }

    /**
     * 分页查询字典列表。
     */
    @Override
    public Result<Object> getDictionaryPage(PageRequest pageRequest, String dictType, String dictLabel) {
        try {
            Page<Dictionary> page = new Page<>(pageRequest.getPageNum(), pageRequest.getPageSize());
            LambdaQueryWrapper<Dictionary> wrapper = new LambdaQueryWrapper<>();
            if (dictType != null && !dictType.isBlank()) wrapper.eq(Dictionary::getDictType, dictType);
            if (dictLabel != null && !dictLabel.isBlank()) wrapper.like(Dictionary::getDictLabel, dictLabel);
            wrapper.orderByAsc(Dictionary::getDictType, Dictionary::getSortOrder, Dictionary::getDictCode);
            return Result.success(dictionaryMapper.selectPage(page, wrapper));
        } catch (Exception e) {
            return Result.error("分页查询字典异常：" + e.getMessage());
        }
    }

    /**
     * 获取所有字典类型列表。
     */
    @Override
    public Result<List<String>> getAllDictTypes() {
        try {
            List<String> dictTypes = dictionaryMapper.selectList(null).stream()
                    .map(Dictionary::getDictType)
                    .distinct()
                    .collect(Collectors.toList());
            return Result.success(dictTypes);
        } catch (Exception e) {
            return Result.error("获取字典类型列表异常：" + e.getMessage());
        }
    }
}
