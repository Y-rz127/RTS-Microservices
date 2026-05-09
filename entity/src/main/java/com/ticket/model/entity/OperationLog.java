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
@TableName("operation_log")
@Schema(description = "操作日志实体")
public class OperationLog implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "log_id", type = IdType.AUTO)
    @Schema(description = "日志ID")
    private Integer logId;

    @TableField("user_id")
    @Schema(description = "用户ID")
    private Integer userId;

    @TableField("username")
    @Schema(description = "用户名")
    private String username;

    @TableField("operation")
    @Schema(description = "操作类型")
    private String operation;

    @TableField("module")
    @Schema(description = "操作模块")
    private String module;

    @TableField("method")
    @Schema(description = "方法名")
    private String method;

    @TableField("params")
    @Schema(description = "请求参数")
    private String params;

    @TableField("result")
    @Schema(description = "返回结果")
    private String result;

    @TableField("ip_address")
    @Schema(description = "IP地址")
    private String ipAddress;

    @TableField("execution_time")
    @Schema(description = "执行时长（毫秒）")
    private Integer executionTime;

    @TableField("status")
    @Schema(description = "操作状态：SUCCESS-成功，FAILURE-失败")
    private String status;

    @TableField("error_msg")
    @Schema(description = "错误信息")
    private String errorMsg;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;
}