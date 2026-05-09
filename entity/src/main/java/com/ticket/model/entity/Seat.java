package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 座位实体，对应 seat 表。
 * 记录每个车次在特定日期下的座位信息，包含车厢号、座位号、类型、状态及价格系数。
 *
 * @author 铁路票务系统
 */
@Data
@TableName("seat")
@Schema(description = "座位实体")
public class Seat implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "seat_id", type = IdType.AUTO)
    @Schema(description = "座位ID")
    private Integer seatId;

    @TableField("train_id")
    @Schema(description = "车次ID")
    private Integer trainId;

    @TableField("travel_date")
    @Schema(description = "发车日期")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Shanghai")
    private Date travelDate;

    @TableField("seat_number")
    @Schema(description = "座位号")
    private String seatNumber;

    @TableField("seat_type")
    @Schema(description = "座位类型")
    private String seatType;

    @TableField("seat_level")
    @Schema(description = "座位等级（1-5）")
    private Integer seatLevel;

    @TableField("price_coefficient")
    @Schema(description = "价格系数")
    private BigDecimal priceCoefficient;

    @TableField("carriage_number")
    @Schema(description = "车厢号")
    private String carriageNumber;

    @TableField("status")
    @Schema(description = "状态：available-可用，occupied-已占用，locked-已锁定，maintenance-维护中")
    private String status;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}
