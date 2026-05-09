package com.ticket.notification.config;

import com.ticket.constant.MqConstants;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 通知服务 RabbitMQ 配置类。
 */
@Configuration
public class RabbitMqConfig {

    /**
     * 配置 JSON 消息转换器，解决 HashMap 反序列化安全问题。
     * 同时支持 Java 序列化格式，以兼容队列中的旧消息。
     */
    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    /**
     * 配置 RabbitTemplate 使用 JSON 消息转换器。
     */
    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setMessageConverter(jsonMessageConverter());
        return rabbitTemplate;
    }

    /**
     * 声明审批通知交换机。
     */
    @Bean
    public DirectExchange approvalNotificationExchange() {
        return new DirectExchange(MqConstants.APPROVAL_NOTIFICATION_EXCHANGE, true, false);
    }

    /**
     * 声明审批通知队列。
     */
    @Bean
    public Queue approvalNotificationQueue() {
        return new Queue(MqConstants.APPROVAL_NOTIFICATION_QUEUE, true);
    }

    /**
     * 绑定审批通知队列。
     */
    @Bean
    public Binding approvalNotificationBinding(Queue approvalNotificationQueue,
                                              DirectExchange approvalNotificationExchange) {
        return BindingBuilder
                .bind(approvalNotificationQueue)
                .to(approvalNotificationExchange)
                .with(MqConstants.APPROVAL_NOTIFICATION_ROUTING_KEY);
    }

    /**
     * 声明购票结果交换机。
     */
    @Bean
    public DirectExchange bookingResultExchange() {
        return new DirectExchange(MqConstants.BOOKING_RESULT_EXCHANGE, true, false);
    }

    /**
     * 声明购票结果队列。
     */
    @Bean
    public Queue bookingResultQueue() {
        return new Queue(MqConstants.BOOKING_RESULT_QUEUE, true);
    }

    /**
     * 绑定购票结果队列。
     */
    @Bean
    public Binding bookingResultBinding(Queue bookingResultQueue,
                                       DirectExchange bookingResultExchange) {
        return BindingBuilder
                .bind(bookingResultQueue)
                .to(bookingResultExchange)
                .with(MqConstants.BOOKING_RESULT_ROUTING_KEY);
    }

    /**
     * 声明热点车次排行榜交换机。
     */
    @Bean
    public DirectExchange hotTrainRankingExchange() {
        return new DirectExchange(MqConstants.HOT_TRAIN_RANKING_EXCHANGE, true, false);
    }

    /**
     * 声明热点车次排行榜队列。
     */
    @Bean
    public Queue hotTrainRankingQueue() {
        return new Queue(MqConstants.HOT_TRAIN_RANKING_QUEUE, true);
    }

    /**
     * 绑定热点车次排行榜队列。
     */
    @Bean
    public Binding hotTrainRankingBinding(Queue hotTrainRankingQueue,
                                          DirectExchange hotTrainRankingExchange) {
        return BindingBuilder
                .bind(hotTrainRankingQueue)
                .to(hotTrainRankingExchange)
                .with(MqConstants.HOT_TRAIN_RANKING_ROUTING_KEY);
    }
}
