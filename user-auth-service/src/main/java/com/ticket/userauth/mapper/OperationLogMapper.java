package com.ticket.userauth.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ticket.model.entity.OperationLog;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OperationLogMapper extends BaseMapper<OperationLog> {
}
