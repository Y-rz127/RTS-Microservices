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
@TableName("role_permission")
@Schema(description = "角色权限实体")
public class RolePermission implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "permission_id", type = IdType.AUTO)
    @Schema(description = "权限ID")
    private Integer permissionId;

    @TableField("role")
    @Schema(description = "角色：ADMIN-管理员，OPERATOR-售票员，PASSENGER-乘客")
    private String role;

    @TableField("module")
    @Schema(description = "功能模块")
    private String module;

    @TableField("permission")
    @Schema(description = "权限标识")
    private String permission;

    @TableField("permission_name")
    @Schema(description = "权限名称")
    private String permissionName;

    @TableField("description")
    @Schema(description = "描述")
    private String description;

    @TableField("status")
    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;


}