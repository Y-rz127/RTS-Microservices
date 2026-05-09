package com.ticket.model.response;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 审批请求详情DTO（用于操作员页面显示）
 */
@Data
public class ApprovalRequestDetailDTO {
    
    /**
     * 请求ID
     */
    private Integer requestId;
    
    /**
     * 请求类型
     */
    private String requestType;
    
    /**
     * 车票ID
     */
    private Integer ticketId;
    
    /**
     * 订单ID
     */
    private Integer orderId;
    
    /**
     * 申请人ID
     */
    private Integer userId;
    
    /**
     * 申请人姓名
     */
    private String userName;
    
    /**
     * 审批状态
     */
    private String status;
    
    /**
     * 申请原因
     */
    private String applyReason;
    
    /**
     * 拒绝原因
     */
    private String rejectReason;
    
    /**
     * 车次号
     */
    private String trainNumber;
    
    /**
     * 出发站
     */
    private String startStation;
    
    /**
     * 到达站
     */
    private String endStation;
    
    /**
     * 出发时间
     */
    private String departureTime;
    
    /**
     * 乘车日期
     */
    private String travelDate;
    
    /**
     * 座位号
     */
    private String seatNumber;
    
    /**
     * 座位类型
     */
    private String seatType;
    
    /**
     * 票价
     */
    private BigDecimal price;
    
    /**
     * 车票状态（PAID-已支付, CHANGED-已改签, REFUNDED-已退票等）
     */
    private String ticketStatus;
    
    /**
     * 退票手续费
     */
    private BigDecimal refundFee;
    
    /**
     * 实际退款金额
     */
    private BigDecimal refundAmount;

    // ========== 改签新车票信息 ==========
    /**
     * 新车次号
     */
    private String newTrainNumber;

    /**
     * 新出发站
     */
    private String newStartStation;

    /**
     * 新到达站
     */
    private String newEndStation;

    /**
     * 新出发时间
     */
    private String newDepartureTime;

    /**
     * 新乘车日期
     */
    private String newTravelDate;

    /**
     * 新座位号
     */
    private String newSeatNumber;

    /**
     * 新座位类型
     */
    private String newSeatType;

    /**
     * 新票价
     */
    private BigDecimal newPrice;

    /**
     * 差价
     */
    private BigDecimal priceDiff;

    /**
     * 创建时间
     */
    private Date createdAt;

    /**
     * 处理时间
     */
    private Date processedAt;
}
