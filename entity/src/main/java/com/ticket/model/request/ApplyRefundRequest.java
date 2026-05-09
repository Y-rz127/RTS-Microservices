package com.ticket.model.request;

import lombok.Data;

/**
 * 申请退票请求
 */
@Data
public class ApplyRefundRequest {
    
    /**
     * 车票ID
     */
    private Integer ticketId;
    
    /**
     * 申请原因
     */
    private String applyReason;
}
