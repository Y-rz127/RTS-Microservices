package com.ticket.train.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.Dictionary;
import com.ticket.model.request.PageRequest;
import com.ticket.model.response.Result;

import java.util.List;

/**
 * 数据字典服务接口。
 */
public interface DictionaryService extends IService<Dictionary> {
    /**
     * 根据字典ID获取字典。
     */
    Result<Dictionary> getDictionaryById(Integer dictId);

    /**
     * 根据字典类型获取字典列表。
     */
    Result<List<Dictionary>> getDictionaryByType(String dictType);

    /**
     * 根据字典类型和字典编码获取字典。
     */
    Result<Dictionary> getDictionaryByTypeAndCode(String dictType, String dictCode);

    /**
     * 添加字典。
     */
    Result<Dictionary> addDictionary(Dictionary dictionary);

    /**
     * 更新字典。
     */
    Result<Dictionary> updateDictionary(Dictionary dictionary);

    /**
     * 删除字典。
     */
    Result<Boolean> deleteDictionary(Integer dictId);

    /**
     * 分页查询字典列表。
     */
    Result<Object> getDictionaryPage(PageRequest pageRequest, String dictType, String dictLabel);

    /**
     * 获取所有字典类型。
     */
    Result<List<String>> getAllDictTypes();
}
