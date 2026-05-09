package com.ticket.approval.controller;

import com.ticket.approval.service.ApprovalService;
import com.ticket.model.request.ApplyCancelBookingRequest;
import com.ticket.model.request.ApplyChangeTicketRequest;
import com.ticket.model.request.ApplyRefundRequest;
import com.ticket.model.response.Result;
import com.ticket.utils.RequestUserContext;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 乘客审批申请控制器。
 */
@RestController
@RequestMapping("/api/approval")
@Tag(name = "审批管理（乘客端）")
public class ApprovalController {

    @Resource
    private ApprovalService approvalService;

    @Resource
    private RequestUserContext requestUserContext;

    /**
     * 提交退票申请。
     */
    @PostMapping("/apply/refund")
    @PreAuthorize("hasRole('PASSENGER')")
    public Result<Object> applyRefund(@RequestBody ApplyRefundRequest request) {
        return approvalService.applyRefund(request);
    }

    /**
     * 提交取消预订申请。
     */
    @PostMapping("/apply/cancel-booking")
    @PreAuthorize("hasRole('PASSENGER')")
    public Result<Object> applyCancelBooking(@RequestBody ApplyCancelBookingRequest request) {
        return approvalService.applyCancelBooking(request);
    }

    /**
     * 提交改签申请。
     */
    @PostMapping("/apply/change-ticket")
    @PreAuthorize("hasRole('PASSENGER')")
    public Result<Object> applyChangeTicket(@RequestBody ApplyChangeTicketRequest request) {
        return approvalService.applyChangeTicket(request);
    }

    /**
     * 查询当前用户的申请记录。
     */
    @GetMapping("/my-requests")
    @PreAuthorize("hasRole('PASSENGER')")
    public Result<Object> getMyRequests() {
        Integer currentUserId = requestUserContext.getCurrentUserId();
        if (currentUserId == null) {
            return Result.error("未登录");
        }
        return approvalService.getMyRequests(currentUserId);
    }
}
