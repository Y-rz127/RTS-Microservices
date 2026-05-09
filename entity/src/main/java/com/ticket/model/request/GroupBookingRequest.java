package com.ticket.model.request;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 团体购票请求模型
 */
@Data
public class GroupBookingRequest {
    /** 车次ID（必填） */
    private Integer trainId;

    /** 售票员ID（必填） */
    private Integer sellerId;

    /** 乘车日期（必填） */
    private Date travelDate;

    /** 乘客姓名列表（必填，与其他List长度一致） */
    private List<String> name;

    /** 乘客证件类型列表（必填，与姓名列表一一对应） */
    private List<String> idType;

    /** 乘客证件号码列表（必填，唯一标识乘客） */
    private List<String> idNumber;

    /** 乘客电话列表（必填，与姓名列表一一对应） */
    private List<String> phone;

    /** 乘客性别列表（可选，与姓名列表一一对应） */
    private List<String> gender;

    /** 座位编号列表（用于虚拟座位选择） */
    private List<String> seatNumbers;

    /** 座位ID列表（用于真实座位选择） */
    private List<Integer> seatIds;

    /** 是否是预订票 */
    private Integer isPreBooking;

    /** 创建日期（后端自动填充，前端可不传） */
    private Date createdAt;

}