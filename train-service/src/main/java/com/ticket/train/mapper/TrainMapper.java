package com.ticket.train.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ticket.model.entity.Train;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TrainMapper extends BaseMapper<Train> {
}
