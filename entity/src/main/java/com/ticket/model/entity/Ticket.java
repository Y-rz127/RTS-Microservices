package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Time;
import java.util.Date;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 车票实体，对应 ticket 表。
 * 记录每张已售/已退/已改签车票的完整信息，关联订单、座位、乘客及车次。
 *
 * @author 铁路票务系统
 */
@Data
@TableName("ticket")
@Schema(description = "车票实体")
public class Ticket implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "ticket_id", type = IdType.AUTO)
    @Schema(description = "车票ID")
    private Integer ticketId;

    @TableField("ticket_number")
    @Schema(description = "车票号")
    private String ticketNumber;

    @TableField("order_id")
    @Schema(description = "订单ID")
    private Integer orderId;

    @TableField("train_id")
    @Schema(description = "车次ID")
    private Integer trainId;

    @TableField("passenger_id")
    @Schema(description = "乘客ID")
    private Integer passengerId;

    @TableField("seat_id")
    @Schema(description = "座位ID")
    private Integer seatId;

    @TableField("start_station")
    @Schema(description = "出发站")
    private String startStation;

    @TableField("end_station")
    @Schema(description = "到达站")
    private String endStation;

    @TableField("travel_date")
    @Schema(description = "乘车日期")
    private Date travelDate;

    @TableField("departure_time")
    @Schema(description = "发车时间")
    private Time departureTime;

    @TableField("arrival_time")
    @Schema(description = "到达时间")
    private Time arrivalTime;

    @TableField("price")
    @Schema(description = "票价")
    private BigDecimal price;

    @TableField("seller_id")
    @Schema(description = "售票员ID")
    private Integer sellerId;

    @TableField("status")
    @Schema(description = "状态：BOOKED-已预订，PAID-已支付，UNPAID-未支付，USED-已使用，REFUNDED-已退票，CHANGED-已改签，EXPIRED-已过期")
    private String status;

    @TableField("had_pay")
    @Schema(description = "是否已支付：0-未支付，1-已支付")
    private Integer hadPay;

    @TableField("is_PreBook")
    @Schema(description = "是否预订：0-非预订，1-预订")
    private Integer isPreBook;

    @TableField("refund_fee")
    @Schema(description = "退票手续费")
    private BigDecimal refundFee;

    @TableField("sale_time")
    @Schema(description = "售票时间")
    private Date saleTime;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}
