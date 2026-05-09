package com.ticket.approval.controller;

import com.ticket.approval.service.ApprovalService;
import com.ticket.model.request.ApproveRequest;
import com.ticket.model.request.RejectRequest;
import com.ticket.model.response.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 操作员审批控制器。
 */
@RestController
@RequestMapping("/api/operator/approval")
@Tag(name = "审批管理（操作员端）")
public class OperatorApprovalController {

    @Resource
    private ApprovalService approvalService;

    /**
     * 查询待审批申请。
     */
    @GetMapping("/pending")
    @PreAuthorize("hasRole('OPERATOR')")
    public Result<Object> getPendingRequests() {
        return approvalService.getPendingRequests();
    }

    /**
     * 查询全部审批记录。
     */
    @GetMapping("/all")
    @PreAuthorize("hasRole('OPERATOR')")
    public Result<Object> getAllRequests() {
        return approvalService.getAllRequests();
    }

    /**
     * 批准审批申请。
     */
    @PostMapping("/approve/{requestId}")
    @PreAuthorize("hasRole('OPERATOR')")
    public Result<Object> approveRequest(@PathVariable Integer requestId, @RequestBody ApproveRequest request) {
        return approvalService.approveRequest(requestId, request);
    }

    /**
     * 驳回审批申请。
     */
    @PostMapping("/reject/{requestId}")
    @PreAuthorize("hasRole('OPERATOR')")
    public Result<Object> rejectRequest(@PathVariable Integer requestId, @RequestBody RejectRequest request) {
        return approvalService.rejectRequest(requestId, request);
    }
}
