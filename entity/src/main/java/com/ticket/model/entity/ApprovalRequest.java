package com.ticket.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * 审批请求实体类
 */
@Data
@TableName("approval_request")
public class ApprovalRequest {
    
    @TableId(type = IdType.AUTO)
    private Integer requestId;
    
    /**
     * 请求类型：REFUND（退票）, CANCEL_BOOKING（取消预订）, CHANGE_TICKET（改签）
     */
    private String requestType;
    
    /**
     * 关联的车票ID
     */
    private Integer ticketId;
    
    /**
     * 关联的订单ID
     */
    private Integer orderId;
    
    /**
     * 申请人ID（乘客）
     */
    private Integer userId;
    
    /**
     * 处理人ID（操作员）
     */
    private Integer operatorId;
    
    /**
     * 审批状态：PENDING（待审批）, APPROVED（已批准）, REJECTED（已拒绝）
     */
    private String status;
    
    /**
     * 请求参数（JSON格式）
     * 退票：{"refundFee": 10.00, "refundAmount": 543.00, "isFreeRefund": false}
     * 改签：{"newTrainId": 2, "newSeatId": 120, "newTravelDate": "2025-12-10", "priceDifference": -20.00}
     * 取消预订：{"seatId": 100}
     */
    private String requestData;
    
    /**
     * 申请原因
     */
    private String applyReason;
    
    /**
     * 拒绝原因
     */
    private String rejectReason;
    
    /**
     * 创建时间
     */
    private Date createdAt;
    
    /**
     * 处理时间
     */
    private Date processedAt;
    
    /**
     * 更新时间
     */
    private Date updatedAt;
}
