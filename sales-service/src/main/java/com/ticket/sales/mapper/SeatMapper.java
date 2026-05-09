package com.ticket.sales.mapper;

import com.ticket.model.entity.Seat;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;

@Mapper
public interface SeatMapper extends BaseMapper<Seat> {
    @Delete("DELETE FROM seat WHERE travel_date < #{today} AND seat_id NOT IN (SELECT seat_id FROM ticket)")
    int deleteExpiredSeatsNotReferenced(@Param("today") Date today);
}
