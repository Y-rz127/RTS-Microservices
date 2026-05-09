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
 * 乘客实体，对应 passenger 表。
 * 记录购票乘客的基础信息，关联用户账号，支持身份证、护照等多种证件类型。
 *
 * @author 铁路票务系统
 */
@Data
@TableName("passenger")
@Schema(description = "乘客实体")
public class Passenger implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    @TableId(value = "passenger_id", type = IdType.AUTO)
    @Schema(description = "乘客ID")
    private Integer passengerId;

    @TableField("user_id")
    @Schema(description = "用户ID")
    private Integer userId;

    @TableField("name")
    @Schema(description = "姓名")
    private String name;

    @TableField("id_type")
    @Schema(description = "证件类型")
    private String idType;

    @TableField("id_number")
    @Schema(description = "证件号码")
    private String idNumber;

    @TableField("phone")
    @Schema(description = "手机号")
    private String phone;

    @TableField("gender")
    @Schema(description = "性别：男，女，未知")
    private String gender;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private Date createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private Date updatedAt;
}