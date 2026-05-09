package com.ticket.sales.config;

import com.ticket.constant.MqConstants;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.QueueBuilder;
import org.springframework.amqp.rabbit.annotation.EnableRabbit;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 售票服务 RabbitMQ 配置类。
 */
@Configuration
@EnableRabbit
public class RabbitMqConfig {

    /**
     * 配置 JSON 消息转换器，解决 HashMap 反序列化安全问题。
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
        return QueueBuilder.durable(MqConstants.BOOKING_RESULT_QUEUE).build();
    }

    /**
     * 绑定购票结果队列。
     */
    @Bean
    public Binding bookingResultBinding(Queue bookingResultQueue, DirectExchange bookingResultExchange) {
        return BindingBuilder.bind(bookingResultQueue).to(bookingResultExchange).with(MqConstants.BOOKING_RESULT_ROUTING_KEY);
    }

    /**
     * 声明支付交换机。
     */
    @Bean
    public DirectExchange paymentExchange() {
        return new DirectExchange(MqConstants.PAYMENT_EXCHANGE, true, false);
    }

    /**
     * 声明支付延迟队列。
     */
    @Bean
    public Queue paymentDelayQueue() {
        return QueueBuilder.durable(MqConstants.PAYMENT_DELAY_QUEUE)
                .withArgument("x-dead-letter-exchange", MqConstants.PAYMENT_EXCHANGE)
                .withArgument("x-dead-letter-routing-key", MqConstants.PAYMENT_TIMEOUT_ROUTING_KEY)
                .withArgument("x-message-ttl", 15 * 60 * 1000)
                .build();
    }

    /**
     * 声明支付超时队列。
     */
    @Bean
    public Queue paymentTimeoutQueue() {
        return QueueBuilder.durable(MqConstants.PAYMENT_TIMEOUT_QUEUE).build();
    }

    /**
     * 绑定支付延迟队列。
     */
    @Bean
    public Binding paymentDelayBinding(Queue paymentDelayQueue, DirectExchange paymentExchange) {
        return BindingBuilder.bind(paymentDelayQueue).to(paymentExchange).with(MqConstants.PAYMENT_DELAY_ROUTING_KEY);
    }

    /**
     * 绑定支付超时队列。
     */
    @Bean
    public Binding paymentTimeoutBinding(Queue paymentTimeoutQueue, DirectExchange paymentExchange) {
        return BindingBuilder.bind(paymentTimeoutQueue).to(paymentExchange).with(MqConstants.PAYMENT_TIMEOUT_ROUTING_KEY);
    }

    /**
     * 声明热点车次排行榜交换机。
     */
    @Bean
    public DirectExchange hotTrainRankingExchange() {
        return new DirectExchange(MqConstants.HOT_TRAIN_RANKING_EXCHANGE, true, false);
    }
}
