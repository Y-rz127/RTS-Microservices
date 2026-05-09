package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Time;
import java.time.LocalDateTime;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * <p>
 * 
 * </p>
 *
 * @author YourName
 * @since 2025-11-29
 */
@Data
@TableName("route")
@Schema(description = "途径站点实体")
public class Route implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "route_id", type = IdType.AUTO)
    private Integer routeId;

    @TableField("train_id")
    private Integer trainId;

    @TableField("station_id")
    private Integer stationId;

    @TableField("station_name")
    private String stationName;

    @TableField("arrival_time")
    private Time arrivalTime;

    @TableField("departure_time")
    private Time departureTime;

    @TableField("stop_order")
    private Integer stopOrder;

    @TableField("stop_duration")
    @Schema(description = "停留时长（分钟）")
    private Integer stopDuration;

    @TableField("distance_from_start")
    @Schema(description = "距起点公里数")
    private BigDecimal distanceFromStart;

    @TableField("additional_price")
    @Schema(description = "区间附加价格")
    private BigDecimal additionalPrice;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;

}
