package com.ticket.model.request;

import lombok.Data;

/**
 * 拒绝申请请求
 */
@Data
public class RejectRequest {
    
    /**
     * 操作员ID
     */
    private Integer operatorId;
    
    /**
     * 拒绝原因
     */
    private String rejectReason;
}
