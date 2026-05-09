package com.ticket.model.request;

import lombok.Data;

import java.util.Date;

/**
 * 改签请求模型
 */
@Data
public class TicketChangeRequest {
    
    /**
     * 原车票ID
     */
    private Integer originalTicketId;
    
    /**
     * 新车次ID
     */
    private Integer newTrainId;
    
    /**
     * 新座位ID
     */
    private Integer newSeatId;
    
    /**
     * 新乘车日期
     */
    private Date newTravelDate;

    /**
     * 售票员ID（操作人）
     */
    private Integer operatorId;
    
    /**
     * 是否允许补差价
     */
    private Boolean allowPriceDifference;


}