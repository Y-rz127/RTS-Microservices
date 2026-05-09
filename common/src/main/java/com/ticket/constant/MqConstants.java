package com.ticket.constant;

/**
 * RabbitMQ 消息队列常量类。
 */
public class MqConstants {
    public static final String APPROVAL_NOTIFICATION_EXCHANGE = "ticket.approval.notification.exchange";
    public static final String APPROVAL_NOTIFICATION_QUEUE = "ticket.approval.notification.queue";
    public static final String APPROVAL_NOTIFICATION_ROUTING_KEY = "ticket.approval.notification";

    public static final String BOOKING_RESULT_EXCHANGE = "ticket.booking.result.exchange";
    public static final String BOOKING_RESULT_QUEUE = "ticket.booking.result.queue";
    public static final String BOOKING_RESULT_ROUTING_KEY = "ticket.booking.result";

    public static final String PAYMENT_EXCHANGE = "ticket.payment.exchange";
    public static final String PAYMENT_DELAY_QUEUE = "ticket.payment.delay.queue";
    public static final String PAYMENT_TIMEOUT_QUEUE = "ticket.payment.timeout.queue";
    public static final String PAYMENT_DELAY_ROUTING_KEY = "ticket.payment.delay";
    public static final String PAYMENT_TIMEOUT_ROUTING_KEY = "ticket.payment.timeout";

    // 热点车次排行榜相关
    public static final String HOT_TRAIN_RANKING_EXCHANGE = "ticket.hot.ranking.exchange";
    public static final String HOT_TRAIN_RANKING_QUEUE = "ticket.hot.ranking.queue";
    public static final String HOT_TRAIN_RANKING_ROUTING_KEY = "ticket.hot.ranking";
}
