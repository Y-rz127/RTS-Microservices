package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 改签记录实体类
 */
@Data
@TableName("ticket_change")
@Schema(description = "改签记录实体")
public class TicketChange implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value="change_id", type = IdType.AUTO)
    @Schema(description = "改签ID")
    private Integer changeId;
    
    @TableField("ticket_id")
    @Schema(description = "车票ID（关联ticket表）")
    private Integer ticketId;
    
    @TableField("old_train_number")
    @Schema(description = "原车次号")
    private String oldTrainNumber;
    
    @TableField("new_train_number")
    @Schema(description = "新车次号")
    private String newTrainNumber;
    
    @TableField("old_seat_number")
    @Schema(description = "原座位号")
    private String oldSeatNumber;
    
    @TableField("new_seat_number")
    @Schema(description = "新座位号")
    private String newSeatNumber;
    
    @TableField("old_travel_date")
    @Schema(description = "原出行日期")
    private Date oldTravelDate;
    
    @TableField("new_travel_date")
    @Schema(description = "新出行日期")
    private Date newTravelDate;
    
    @TableField("change_type")
    @Schema(description = "改签类型：TRAIN-换车，SEAT-换座，BOTH-两者都换")
    private String changeType;
    
    @TableField("price_diff")
    @Schema(description = "票价差额")
    private BigDecimal priceDiff;
    
    @TableField("change_fee")
    @Schema(description = "改签手续费")
    private BigDecimal changeFee;
    
    @TableField("operator_id")
    @Schema(description = "操作员ID")
    private Integer operatorId;
    
    @TableField("change_time")
    @Schema(description = "改签时间")
    private Date changeTime;
    
    @TableField("reason")
    @Schema(description = "改签原因")
    private String reason;
}
