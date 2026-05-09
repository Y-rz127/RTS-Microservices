package com.ticket.model.request;

import lombok.Data;
import java.util.Date;

/**
 * 申请改签请求
 */
@Data
public class ApplyChangeTicketRequest {
    
    /**
     * 原车票ID
     */
    private Integer ticketId;
    
    /**
     * 新车次ID
     */
    private Integer newTrainId;
    
    /**
     * 新座位ID
     */
    private Integer newSeatId;
    
    /**
     * 新出行日期
     */
    private Date newTravelDate;
    
    /**
     * 新出发时间
     */
    private Date newDepartureTime;
    
    /**
     * 新到达时间
     */
    private Date newArrivalTime;
    
    /**
     * 新票价
     */
    private java.math.BigDecimal newPrice;
    
    /**
     * 申请原因
     */
    private String applyReason;
}
