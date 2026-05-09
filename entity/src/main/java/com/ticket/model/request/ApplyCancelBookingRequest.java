package com.ticket.model.request;

import lombok.Data;

/**
 * 申请取消预订请求
 */
@Data
public class ApplyCancelBookingRequest {
    
    /**
     * 车票ID
     */
    private Integer ticketId;
    
    /**
     * 申请原因
     */
    private String applyReason;
}
