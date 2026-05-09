package com.ticket.sales.service;

import com.ticket.model.entity.ThreadPoolStatus;
import com.ticket.model.request.BookingRequest;
import com.ticket.model.request.GroupBookingRequest;
import com.ticket.model.response.AsyncBookingResponse;
import com.ticket.model.response.BookingResult;
import com.ticket.model.response.Result;

/**
 * 异步抢票服务接口。
 */
public interface AsyncTicketService {
    /**
     * 提交单人异步抢票。
     */
    Result<AsyncBookingResponse> asyncSellTicket(BookingRequest request, Integer userId);
    /**
     * 提交团体异步抢票。
     */
    Result<AsyncBookingResponse> asyncGroupSellTicket(GroupBookingRequest request, Integer userId);
    /**
     * 查询抢票结果。
     */
    BookingResult getBookingResult(String queueId);
    /**
     * 查询排队位置。
     */
    Integer getQueuePosition(String queueId);
    /**
     * 取消排队任务。
     */
    Result<Boolean> cancelTask(String queueId);
    
    /**
     * 获取线程池状态。
     */
    ThreadPoolStatus getThreadPoolStatus();
}
