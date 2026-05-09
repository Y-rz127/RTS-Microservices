package com.ticket.model.request;

import lombok.Data;

/**
 * 退票请求模型
 */
@Data
public class RefundRequest {
    
    /**
     * 车票ID
     */
    private Integer ticketId;

    /**
     * 是否免手续费退票
     */
    private Boolean isFreeRefund;

}