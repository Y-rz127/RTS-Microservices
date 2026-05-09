package com.ticket.Enum;

/**
 * 车票状态枚举（与数据库ENUM类型完全匹配）
 */
public class ticketStatusEnum {
    /** 已预订（未支付） */
    public static final String BOOKED = "BOOKED";
    
    /** 已支付（购票成功，直接设为此状态） */
    public static final String PAID = "PAID";
    
    /** 待支付 */
    public static final String UNPAID = "UNPAID";
    
    /** 已使用（乘客已乘车） */
    public static final String USED = "USED";
    
    /** 已退票 */
    public static final String REFUNDED = "REFUNDED";
    
    /** 已改签 */
    public static final String CHANGED = "CHANGED";
    
    /** 已过期 */
    public static final String EXPIRED = "EXPIRED";
}
