package com.ticket.userauth.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ticket.model.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper extends BaseMapper<User> {
}
