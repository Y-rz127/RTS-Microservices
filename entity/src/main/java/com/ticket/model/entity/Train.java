package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Time;
import java.util.Date;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * 车次实体，对应 train 表。
 * 记录列车基础信息，包括车次编号、始发/终到站、发车/到达时间及票价基准。
 *
 * @author 铁路票务系统
 */
@Data
@TableName("train")
@Schema(description = "车次实体")
public class Train implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "train_id", type = IdType.AUTO)
    @Schema(description = "车次ID")
    private Integer trainId;

    @TableField("train_number")
    @Schema(description = "车次号")
    private String trainNumber;

    @TableField("train_type")
    @Schema(description = "列车类型")
    private String trainType;

    @TableField("total_seats")
    @Schema(description = "总座位数")
    private Integer totalSeats;

    @TableField("start_station")
    @Schema(description = "始发站")
    private String startStation;

    @TableField("end_station")
    @Schema(description = "终点站")
    private String endStation;

    @TableField("departure_time")
    @Schema(description = "发车时间")
    @JsonFormat(pattern = "HH:mm:ss")
    private Time departureTime;

    @TableField("arrival_time")
    @Schema(description = "到达时间")
    @JsonFormat(pattern = "HH:mm:ss")
    private Time arrivalTime;

    @TableField("base_price")
    @Schema(description = "基础票价")
    private BigDecimal basePrice;

    @TableField("running_days")
    @Schema(description = "运行日期（1-7表示周一到周日）")
    private String runningDays;

    @TableField("status")
    @Schema(description = "状态：0-停运，1-正常")
    private Integer status;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}
