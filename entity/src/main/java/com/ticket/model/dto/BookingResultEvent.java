package com.ticket.model.dto;

import com.ticket.model.response.BookingResult;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 抢票结果事件
 * 用于 RabbitMQ 中传递购票结果
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingResultEvent implements Serializable {

    private String userId;

    private BookingResult result;

    private long timestamp;

}
