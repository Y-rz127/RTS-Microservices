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

/**
 * 用户表
 */
@Data
@TableName("users")
public class User implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 用户ID
     */
    @TableId(value = "user_id", type = IdType.AUTO)
    @Schema(description = "用户ID")
    private Integer userid;

    /**
     * 用户名
     */
    @TableField("user_name")
    @Schema(description = "用户名")
    private String username;

    /**
     * 密码
     */
    @TableField("password")
    @Schema(description = "密码")
    private String password;

    /**
     * 用户角色：ADMIN（系统管理员）、OPERATOR（售票员）、PASSENGER (乘客)
     */
    @TableField("role")
    @Schema(description = "用户角色")
    private String role;

    /**
     * 联系电话
     */
    @TableField("phone")
    @Schema(description = "联系电话")
    private String phone;

    /**
     * 状态：0-禁用，1-启用
     */
    @TableField("status")
    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;

    /**
     * 创建时间
     */
    @TableField("create_time")
    @Schema(description = "创建时间")
    private Date createTime;

    /**
     * 更新时间
     */
    @TableField("update_time")
    @Schema(description = "更新时间")
    private Date updateTime;
}