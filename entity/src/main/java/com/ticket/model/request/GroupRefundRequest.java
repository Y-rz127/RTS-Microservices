package com.ticket.model.request;

import lombok.Data;
import java.util.List;

/**
 * 团体退票请求模型
 */
@Data
public class GroupRefundRequest {
    /**
     * 车票ID
     */
    private List<Integer> ticketIds;

    /**
     * 是否免手续费退票
     */
    private Boolean isFreeRefund;

}
