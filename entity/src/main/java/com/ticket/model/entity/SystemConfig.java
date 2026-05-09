package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
@TableName("system_config")
@Schema(description = "系统配置实体")
public class SystemConfig implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "config_id", type = IdType.AUTO)
    @Schema(description = "配置ID")
    private Integer configId;

    @TableField("config_key")
    @Schema(description = "配置键")
    private String configKey;

    @TableField("config_value")
    @Schema(description = "配置值")
    private String configValue;

    @TableField("config_type")
    @Schema(description = "配置类型")
    private String configType;

    @TableField("description")
    @Schema(description = "描述")
    private String description;

    @TableField("is_system")
    @Schema(description = "是否系统内置：0-否，1-是")
    private Integer isSystem;

    @TableField("status")
    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}