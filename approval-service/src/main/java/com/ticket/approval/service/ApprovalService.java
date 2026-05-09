package com.ticket.approval.service;

import com.ticket.model.request.ApplyCancelBookingRequest;
import com.ticket.model.request.ApplyChangeTicketRequest;
import com.ticket.model.request.ApplyRefundRequest;
import com.ticket.model.request.ApproveRequest;
import com.ticket.model.request.RejectRequest;
import com.ticket.model.response.Result;

/**
 * 审批服务接口。
 */
public interface ApprovalService {
    /**
     * 申请退票。
     */
    Result<Object> applyRefund(ApplyRefundRequest request);

    /**
     * 申请取消预订。
     */
    Result<Object> applyCancelBooking(ApplyCancelBookingRequest request);

    /**
     * 申请改签。
     */
    Result<Object> applyChangeTicket(ApplyChangeTicketRequest request);

    /**
     * 审批通过申请。
     */
    Result<Object> approveRequest(Integer requestId, ApproveRequest approveRequest);

    /**
     * 审批拒绝申请。
     */
    Result<Object> rejectRequest(Integer requestId, RejectRequest rejectRequest);

    /**
     * 获取我的申请列表。
     */
    Result<Object> getMyRequests(Integer userId);

    /**
     * 获取待审批申请列表。
     */
    Result<Object> getPendingRequests();

    /**
     * 获取所有申请列表。
     */
    Result<Object> getAllRequests();
}
