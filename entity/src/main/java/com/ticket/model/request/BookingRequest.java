package com.ticket.model.request;

import io.swagger.v3.oas.models.security.SecurityScheme;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * 个人购票请求模型
 */
@Data
public class BookingRequest {

    /**
     * 车次ID
     */
    private Integer trainId;

    /**
     * 座位ID
     */
    private Integer seatId;

    /**
     * 座位编号（用于虚拟座位选择）
     */
    private String seatNumber;

    /**
     * 姓名
     */
    private String name;

    /**
     * 性别
     */
    private String gender;

    /**
     * 证件类型
     */
    private String idType;

    /**
     * 证件号码
     */
    private String idNumber;

    /**
     * 电话
     */
    private String phone;

    /**
     * 售票员ID
     */
    private Integer sellerId;

    /**
     * 是否是预订票
     */
    private Integer isPreBooking;

    /**
     * 乘车日期（格式：yyyy-MM-dd）
     */
    private String travelDate;

    /**
     * 创建时间
     */
    private LocalDateTime createdAt;


}