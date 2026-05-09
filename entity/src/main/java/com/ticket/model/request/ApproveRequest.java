package com.ticket.model.request;

import lombok.Data;

/**
 * 批准申请请求
 */
@Data
public class ApproveRequest {
    
    /**
     * 操作员ID
     */
    private Integer operatorId;
}
