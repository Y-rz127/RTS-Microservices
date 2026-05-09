package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * <p>
 * 车站表
 * </p>
 *
 * @author YourName
 * @since 2025-11-29
 */
@Data
@TableName("station")
@Schema(description = "车站实体")
public class Station implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "station_id", type = IdType.AUTO)
    @Schema(description = "车站ID")
    private Integer stationId;

    @TableField("station_name")
    @Schema(description = "车站名称")
    private String stationName;

    @TableField("city")
    @Schema(description = "所在城市")
    private String city;

    @TableField("province")
    @Schema(description = "所在省份")
    private String province;

    @TableField("station_level")
    @Schema(description = "车站等级")
    private String stationLevel;

    @TableField("address")
    @Schema(description = "详细地址")
    private String address;

    @TableField("contact_phone")
    @Schema(description = "联系电话")
    private String contactPhone;

    @TableField("status")
    @Schema(description = "状态：0-停用，1-启用")
    private Integer status;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}
