package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 订单实体，对应 orders 表。
 * 承载购票/退票/改签产生的订单信息，关联用户、车票及支付状态。
 *
 * @author 铁路票务系统
 */
@Data
@TableName("orders")
@Schema(description = "订单实体")
public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "order_id", type = IdType.AUTO)
    @Schema(description = "订单ID")
    private Integer orderId;

    @TableField("order_number")
    @Schema(description = "订单号")
    private String orderNumber;

    @TableField("user_id")
    @Schema(description = "用户ID")
    private Integer userId;

    @TableField("total_amount")
    @Schema(description = "订单总金额")
    private BigDecimal totalAmount;

    @TableField("payment_amount")
    @Schema(description = "实付金额")
    private BigDecimal paymentAmount;

    @TableField("order_type")
    @Schema(description = "订单类型：INDIVIDUAL-个人，GROUP-团体")
    private String orderType;

    @TableField("order_status")
    @Schema(description = "订单状态：UNPAID-未支付，PAID-已支付，CANCELLED-已取消，REFUNDED-已退款")
    private String orderStatus;

    @TableField("payment_method")
    @Schema(description = "支付方式")
    private String paymentMethod;

    @TableField("payment_time")
    @Schema(description = "支付时间")
    private Date paymentTime;

    @TableField("operator_id")
    @Schema(description = "操作员ID")
    private Integer operatorId;

    @TableField("is_pre_booking")
    @Schema(description = "是否预订票：0-直接购票（立即出票），1-预订票（未发售）")
    private Integer isPreBooking;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}