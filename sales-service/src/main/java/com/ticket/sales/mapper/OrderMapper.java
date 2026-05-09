package com.ticket.sales.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ticket.model.entity.Order;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {
}
