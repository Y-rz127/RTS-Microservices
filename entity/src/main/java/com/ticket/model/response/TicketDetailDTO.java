package com.ticket.model.response;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 车票详情DTO（包含车票和关联的乘客、车次信息）
 */
@Data
public class TicketDetailDTO {
    /**
     * 车票ID
     */
    private Integer ticketId;
    
    /**
     * 车票号
     */
    private String ticketNumber;
    
    /**
     * 乘客姓名
     */
    private String passengerName;
    
    /**
     * 证件类型
     */
    private String idType;
    
    /**
     * 证件号码
     */
    private String idNumber;
    
    /**
     * 手机号
     */
    private String phone;
    
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
     * 到达时间
     */
    private String arrivalTime;
    
    /**
     * 乘车日期
     */
    private Date travelDate;
    
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
     * 状态
     */
    private String status;
}
