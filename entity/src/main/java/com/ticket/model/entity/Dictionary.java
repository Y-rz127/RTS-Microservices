package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("dictionary")
@Schema(description = "数据字典实体")
public class Dictionary implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "dict_id", type = IdType.AUTO)
    @Schema(description = "字典ID")
    private Integer dictId;

    @TableField("dict_type")
    @Schema(description = "字典类型")
    private String dictType;

    @TableField("dict_code")
    @Schema(description = "字典编码")
    private String dictCode;

    @TableField("dict_label")
    @Schema(description = "字典标签")
    private String dictLabel;

    @TableField("dict_value")
    @Schema(description = "字典值")
    private String dictValue;

    @TableField("sort_order")
    @Schema(description = "排序")
    private Integer sortOrder;

    @TableField("status")
    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;

    @TableField("remark")
    @Schema(description = "备注")
    private String remark;

    @TableField("created_at")
    @Schema(description = "创建时间")
    private LocalDateTime createdAt;

    @TableField("updated_at")
    @Schema(description = "更新时间")
    private LocalDateTime updatedAt;
}