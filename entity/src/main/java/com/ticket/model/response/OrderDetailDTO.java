package com.ticket.model.response;

import com.ticket.model.entity.Order;
import com.ticket.model.entity.Ticket;
import lombok.Data;

import java.util.List;

/**
 * 订单详情DTO（包含订单基本信息和关联的车票信息）
 */
@Data
public class OrderDetailDTO {
    /**
     * 订单基本信息
     */
    private Order order;
    
    /**
     * 订单关联的车票列表
     */
    private List<TicketDetailDTO> tickets;
    
    /**
     * 车次号（从第一张票获取）
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
     * 到达时间
     */
    private String arrivalTime;
    
    /**
     * 乘车日期
     */
    private String travelDate;
    
    /**
     * 座位类型
     */
    private String seatType;
    
    /**
     * 票据状态（PAID-已支付, CHANGED-已改签, REFUNDED-已退票等）
     */
    private String ticketStatus;
    
    /**
     * 购票人数（团体购票时显示）
     */
    private Integer passengerCount;
}
