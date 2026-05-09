package com.ticket.model.response;

import com.ticket.model.entity.Ticket;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 抢票最终结果
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingResult {

    /**
     * 排队号
     */
    private String queueId;

    /**
     * 状态：SUCCESS-成功，FAILED-失败，TIMEOUT-超时
     */
    private String status;

    /**
     * 车票信息（成功时返回）
     */
    private Ticket ticket;

    /**
     * 团体票列表
     */
    private List<Ticket> tickets;

    /**
     * 失败原因
     */
    private String errorMessage;

    /**
     * 完成时间
     */
    private LocalDateTime completeTime;

    /**
     * 耗时（毫秒）
     */
    private Long elapsedTime;

    public static BookingResult success(String queueId, Ticket ticket) {
        return BookingResult.builder()
                .queueId(queueId)
                .status("SUCCESS")
                .ticket(ticket)
                .completeTime(LocalDateTime.now())
                .build();
    }

    public static BookingResult success(String queueId, List<Ticket> tickets) {
        return BookingResult.builder()
                .queueId(queueId)
                .status("SUCCESS")
                .tickets(tickets)
                .completeTime(LocalDateTime.now())
                .build();
    }

    public static BookingResult failed(String queueId, String errorMessage) {
        return BookingResult.builder()
                .queueId(queueId)
                .status("FAILED")
                .errorMessage(errorMessage)
                .completeTime(LocalDateTime.now())
                .build();
    }

    public static BookingResult timeout(String queueId) {
        return BookingResult.builder()
                .queueId(queueId)
                .status("TIMEOUT")
                .errorMessage("抢票超时，请稍后查询订单状态或重试")
                .completeTime(LocalDateTime.now())
                .build();
    }
}
