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

@Data
@TableName("refund_record")
@Schema(description = "退票记录实体")
public class RefundRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "refund_id", type = IdType.AUTO)
    @Schema(description = "退票记录ID")
    private Integer refundId;

    @TableField("ticket_id")
    @Schema(description = "车票ID")
    private Integer ticketId;

    @TableField("order_id")
    @Schema(description = "订单ID")
    private Integer orderId;

    @TableField("passenger_id")
    @Schema(description = "乘客ID")
    private Integer passengerId;

    @TableField("refund_amount")
    @Schema(description = "退款金额")
    private BigDecimal refundAmount;

    @TableField("refund_fee")
    @Schema(description = "手续费")
    private BigDecimal refundFee;

    @TableField("refund_reason")
    @Schema(description = "退票原因")
    private String refundReason;

    @TableField("operator_id")
    @Schema(description = "操作人ID")
    private Integer operatorId;

    @TableField("refund_time")
    @Schema(description = "退票时间")
    private Date refundTime;

    @TableField("refund_status")
    @Schema(description = "退票状态：0-处理中，1-成功，2-失败")
    private Integer refundStatus;

    @TableField("payment_method")
    @Schema(description = "支付方式")
    private String paymentMethod;

    @TableField("transaction_id")
    @Schema(description = "交易流水号")
    private String transactionId;

    @TableField("remark")
    @Schema(description = "备注")
    private String remark;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}