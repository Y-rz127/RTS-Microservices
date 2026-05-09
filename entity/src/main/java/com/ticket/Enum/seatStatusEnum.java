package com.ticket.Enum;

/**
 * 座位状态枚举（与数据库ENUM保持一致）
 */
public class seatStatusEnum {
    public static final String AVAILABLE = "available";  // 可用
    public static final String OCCUPIED = "occupied";    // 已占用（已售出）
    public static final String LOCKED = "locked";        // 锁定中
    public static final String MAINTENANCE = "maintenance"; // 维修中

    public static final String BOOKED = LOCKED;  // 已预订（等同于锁定）
    public static final String NOTUSE = MAINTENANCE;  // 维修中
}
