package com.ticket.approval.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ticket.api.feign.SalesFeignClient;
import com.ticket.api.feign.TrainFeignClient;
import com.ticket.approval.mapper.ApprovalRequestMapper;
import com.ticket.approval.service.ApprovalNotificationPublisher;
import com.ticket.approval.service.ApprovalService;
import com.ticket.model.dto.ApprovalNotificationEvent;
import com.ticket.model.entity.*;
import com.ticket.model.request.*;
import com.ticket.model.response.ApprovalRequestDetailDTO;
import com.ticket.model.response.Result;
import com.ticket.utils.RequestUserContext;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import io.seata.spring.annotation.GlobalTransactional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

/**
 * 审批服务实现类，处理退票、改签、取消预订等审批业务。
 * @author 铁路票务系统
 */
@Slf4j
@Service
public class ApprovalServiceImpl implements ApprovalService {

    @Resource
    private ApprovalRequestMapper approvalRequestMapper;

    @Resource
    private ApprovalNotificationPublisher approvalNotificationPublisher;

    @Resource
    private SalesFeignClient salesFeignClient;

    @Resource
    private TrainFeignClient trainFeignClient;

    @Resource
    private RequestUserContext requestUserContext;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 申请退票。
     */
    @Override
    @Transactional
    public Result<Object> applyRefund(ApplyRefundRequest request) {
        try {
            Integer currentUserId = requestUserContext.getCurrentUserId();
            if (currentUserId == null) return Result.error("未登录");
            Result<Ticket> ticketRes = salesFeignClient.getTicket(request.getTicketId());
            if (ticketRes.getCode() != 200 || ticketRes.getData() == null) return Result.error("车票不存在");
            Ticket ticket = ticketRes.getData();

            // 校验发车时间
            if (isTrainDeparted(ticket.getTravelDate(), ticket.getDepartureTime())) {
                return Result.error("该车次已发车，无法办理退票");
            }

            ApprovalRequest approval = new ApprovalRequest();
            approval.setRequestType("REFUND");
            approval.setTicketId(request.getTicketId());
            approval.setOrderId(ticket.getOrderId());
            approval.setUserId(currentUserId);
            approval.setStatus("PENDING");
            approval.setApplyReason(request.getApplyReason());
            approval.setCreatedAt(new Date());
            approval.setUpdatedAt(new Date());
            
            // 校验重复提交
            long pendingCount = approvalRequestMapper.selectCount(new LambdaQueryWrapper<ApprovalRequest>()
                    .eq(ApprovalRequest::getTicketId, request.getTicketId())
                    .eq(ApprovalRequest::getRequestType, "REFUND")
                    .eq(ApprovalRequest::getStatus, "PENDING"));
            if (pendingCount > 0) return Result.error("该车票已有待处理的退票申请，请勿重复提交");

            approvalRequestMapper.insert(approval);
            return Result.success(approval, "申请已提交");
        } catch (Exception e) {
            log.error("退票申请提交异常", e);
            throw new RuntimeException("提交失败: " + e.getMessage());
        }
    }

    /**
     * 申请取消预订。
     */
    @Override
    @Transactional
    public Result<Object> applyCancelBooking(ApplyCancelBookingRequest request) {
        try {
            Integer currentUserId = requestUserContext.getCurrentUserId();
            if (currentUserId == null) return Result.error("未登录");
            ApprovalRequest approval = new ApprovalRequest();
            approval.setRequestType("CANCEL_BOOKING");
            approval.setTicketId(request.getTicketId());
            approval.setUserId(currentUserId);
            approval.setStatus("PENDING");
            approval.setApplyReason(request.getApplyReason());
            approval.setCreatedAt(new Date());
            approval.setUpdatedAt(new Date());
            
            approvalRequestMapper.insert(approval);
            return Result.success(approval, "申请已提交");
        } catch (Exception e) {
            log.error("取消预订申请异常", e);
            throw new RuntimeException("提交失败: " + e.getMessage());
        }
    }

    /**
     * 申请改签。
     */
    @Override
    @Transactional
    public Result<Object> applyChangeTicket(ApplyChangeTicketRequest request) {
        try {
            Integer currentUserId = requestUserContext.getCurrentUserId();
            if (currentUserId == null) return Result.error("未登录");
            
            // 查询车票信息获取 orderId
            Result<Ticket> ticketRes = salesFeignClient.getTicket(request.getTicketId());
            Integer orderId = null;
            if (ticketRes != null && ticketRes.getCode() == 200 && ticketRes.getData() != null) {
                Ticket ticket = ticketRes.getData();
                orderId = ticket.getOrderId();
                
                // 校验发车时间
                if (isTrainDeparted(ticket.getTravelDate(), ticket.getDepartureTime())) {
                    return Result.error("该车次已发车，无法办理改签");
                }
            }
            
            // 构建改签参数JSON（日期格式化为字符串避免时间戳）
            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm:ss");
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            java.util.Map<String, Object> changeData = new java.util.HashMap<>();
            changeData.put("newTrainId", request.getNewTrainId());
            changeData.put("newSeatId", request.getNewSeatId());
            changeData.put("newTravelDate", request.getNewTravelDate() != null ? dateFormat.format(request.getNewTravelDate()) : null);
            changeData.put("newDepartureTime", request.getNewDepartureTime() != null ? timeFormat.format(request.getNewDepartureTime()) : null);
            changeData.put("newArrivalTime", request.getNewArrivalTime() != null ? timeFormat.format(request.getNewArrivalTime()) : null);
            changeData.put("newPrice", request.getNewPrice());
            String requestData = mapper.writeValueAsString(changeData);
            
            ApprovalRequest approval = new ApprovalRequest();
            approval.setRequestType("CHANGE_TICKET");
            approval.setTicketId(request.getTicketId());
            approval.setOrderId(orderId);
            approval.setUserId(currentUserId);
            approval.setStatus("PENDING");
            approval.setApplyReason(request.getApplyReason());
            approval.setRequestData(requestData);
            approval.setCreatedAt(new Date());
            approval.setUpdatedAt(new Date());
            
            // 校验重复提交
            long pendingCount = approvalRequestMapper.selectCount(new LambdaQueryWrapper<ApprovalRequest>()
                    .eq(ApprovalRequest::getTicketId, request.getTicketId())
                    .eq(ApprovalRequest::getRequestType, "CHANGE_TICKET")
                    .eq(ApprovalRequest::getStatus, "PENDING"));
            if (pendingCount > 0) return Result.error("该车票已有待处理的改签申请，请勿重复提交");

            approvalRequestMapper.insert(approval);
            return Result.success(approval, "申请已提交");
        } catch (Exception e) {
            log.error("改签申请异常", e);
            throw new RuntimeException("提交失败: " + e.getMessage());
        }
    }

    /**
     * 审批通过申请。
     */
    @GlobalTransactional(rollbackFor = Exception.class, name = "approve-request-tx")
    @SentinelResource(value = "approveRequest", blockHandler = "approveRequestBlockHandler")
    @Override
    @Transactional
    public Result<Object> approveRequest(Integer requestId, ApproveRequest approveRequest) {
        ApprovalRequest request = approvalRequestMapper.selectById(requestId);
        if (request == null) return Result.error("不存在");
        if (!"PENDING".equals(request.getStatus())) return Result.error("已处理");

        Result<Object> execRes;
        if ("REFUND".equals(request.getRequestType())) {
            RefundRequest rr = new RefundRequest();
            rr.setTicketId(request.getTicketId());
            rr.setIsFreeRefund(false);
            Result<BigDecimal> refundRes = salesFeignClient.refundTicket(rr);
            if (refundRes == null) {
                execRes = Result.error("退票服务无响应");
            } else if (refundRes.getCode() != 200) {
                execRes = Result.error(refundRes.getMessage());
            } else {
                execRes = Result.success(refundRes.getData());
            }
        } else if ("CANCEL_BOOKING".equals(request.getRequestType())) {
            Result<Boolean> cancelRes = salesFeignClient.cancelBooking(request.getTicketId());
            if (cancelRes == null) {
                execRes = Result.error("取消预订服务无响应");
            } else if (cancelRes.getCode() != 200) {
                execRes = Result.error(cancelRes.getMessage());
            } else {
                execRes = Result.success(cancelRes.getData());
            }
        } else if ("CHANGE_TICKET".equals(request.getRequestType())) {
            // 改签审批：解析 requestData 并调用改签接口
            if (request.getRequestData() != null && !request.getRequestData().isBlank()) {
                try {
                    com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                    @SuppressWarnings("unchecked")
                    java.util.Map<String, Object> changeData = mapper.readValue(request.getRequestData(), java.util.Map.class);
                    
                    TicketChangeRequest changeReq = new TicketChangeRequest();
                    changeReq.setOriginalTicketId(request.getTicketId());
                    changeReq.setNewTrainId(changeData.get("newTrainId") != null ? ((Number) changeData.get("newTrainId")).intValue() : null);
                    changeReq.setNewSeatId(changeData.get("newSeatId") != null ? ((Number) changeData.get("newSeatId")).intValue() : null);
                    changeReq.setNewTravelDate(changeData.get("newTravelDate") != null ? 
                        new java.text.SimpleDateFormat("yyyy-MM-dd").parse(changeData.get("newTravelDate").toString()) : null);
                    changeReq.setOperatorId(approveRequest.getOperatorId());
                    
                    Result<Object> changeRes = salesFeignClient.changeTicket(changeReq);
                    if (changeRes == null) {
                        execRes = Result.error("改签服务无响应");
                    } else if (changeRes.getCode() != 200) {
                        execRes = Result.error(changeRes.getMessage());
                    } else {
                        execRes = Result.success(changeRes.getData());
                    }
                } catch (Exception e) {
                    log.error("改签参数解析失败", e);
                    execRes = Result.error("改签参数解析失败: " + e.getMessage());
                }
            } else {
                execRes = Result.error("改签参数缺失");
            }
        } else {
            execRes = Result.success(null);
        }

        if (execRes.getCode() != 200) return execRes;

        request.setStatus("APPROVED");
        request.setOperatorId(approveRequest.getOperatorId());
        request.setProcessedAt(new Date());
        approvalRequestMapper.updateById(request);

        notifyResult(request, "审批通过");
        return Result.success(null, "已通过");
    }

    /**
     * 审批拒绝申请。
     */
    @GlobalTransactional(rollbackFor = Exception.class, name = "reject-request-tx")
    @SentinelResource(value = "rejectRequest", blockHandler = "rejectRequestBlockHandler")
    @Override
    @Transactional
    public Result<Object> rejectRequest(Integer requestId, RejectRequest rejectRequest) {
        ApprovalRequest request = approvalRequestMapper.selectById(requestId);
        if (request == null) return Result.error("审批单不存在");
        if (!"PENDING".equals(request.getStatus())) return Result.error("审批单已处理，当前状态: " + request.getStatus());
        request.setStatus("REJECTED");
        request.setOperatorId(rejectRequest.getOperatorId());
        request.setRejectReason(rejectRequest.getRejectReason());
        request.setProcessedAt(new Date());
        approvalRequestMapper.updateById(request);
        
        notifyResult(request, "审批拒绝");
        return Result.success(null, "已拒绝");
    }

    /**
     * 发送审批结果通知。
     */
    private void notifyResult(ApprovalRequest request, String msg) {
        ApprovalNotificationEvent event = new ApprovalNotificationEvent(
                request.getUserId(), request.getRequestId(), request.getRequestType(),
                msg, "APPROVED".equals(request.getStatus()), System.currentTimeMillis()
        );
        approvalNotificationPublisher.publish(event);
    }

    /**
     * 判断车次是否已发车。
     */
    private boolean isTrainDeparted(Date travelDate, Date departureTime) {
        if (travelDate == null || departureTime == null) return false;
        
        Calendar cal = Calendar.getInstance();
        cal.setTime(travelDate);
        
        Calendar timeCal = Calendar.getInstance();
        timeCal.setTime(departureTime);
        
        cal.set(Calendar.HOUR_OF_DAY, timeCal.get(Calendar.HOUR_OF_DAY));
        cal.set(Calendar.MINUTE, timeCal.get(Calendar.MINUTE));
        cal.set(Calendar.SECOND, timeCal.get(Calendar.SECOND));
        cal.set(Calendar.MILLISECOND, 0);
        
        return new Date().after(cal.getTime());
    }

    /**
     * 获取我的申请列表。
     */
    @Override
    public Result<Object> getMyRequests(Integer userId) {
        List<ApprovalRequest> requests = approvalRequestMapper.selectList(
                new LambdaQueryWrapper<ApprovalRequest>().eq(ApprovalRequest::getUserId, userId));
        return Result.success(convertToDetailDTOs(requests));
    }

    /**
     * 获取待审批申请列表。
     */
    @Override
    public Result<Object> getPendingRequests() {
        List<ApprovalRequest> requests = approvalRequestMapper.selectList(
                new LambdaQueryWrapper<ApprovalRequest>().eq(ApprovalRequest::getStatus, "PENDING"));
        return Result.success(convertToDetailDTOs(requests));
    }

    /**
     * 获取所有申请列表。
     */
    @Override
    public Result<Object> getAllRequests() {
        List<ApprovalRequest> requests = approvalRequestMapper.selectList(null);
        return Result.success(convertToDetailDTOs(requests));
    }

    /**
     * 转换为详情 DTO 列表。
     */
    private List<ApprovalRequestDetailDTO> convertToDetailDTOs(List<ApprovalRequest> requests)
    {
        List<ApprovalRequestDetailDTO> dtos = new ArrayList<>();
        for (ApprovalRequest req : requests) {
            ApprovalRequestDetailDTO dto = new ApprovalRequestDetailDTO();
            dto.setRequestId(req.getRequestId());
            dto.setRequestType(req.getRequestType());
            dto.setTicketId(req.getTicketId());
            dto.setOrderId(req.getOrderId());
            dto.setUserId(req.getUserId());
            dto.setStatus(req.getStatus());
            dto.setApplyReason(req.getApplyReason());
            dto.setRejectReason(req.getRejectReason());
            dto.setCreatedAt(req.getCreatedAt());
            dto.setProcessedAt(req.getProcessedAt());

            // 查询车票详情
            if (req.getTicketId() != null) {
                try {
                    Result<Ticket> ticketRes = salesFeignClient.getTicket(req.getTicketId());
                    if (ticketRes != null && ticketRes.getCode() == 200 && ticketRes.getData() != null) {
                        Ticket ticket = ticketRes.getData();
                        dto.setTicketStatus(ticket.getStatus());
                        dto.setPrice(ticket.getPrice());

                                    // 从车票填充信息
                        dto.setStartStation(ticket.getStartStation());
                        dto.setEndStation(ticket.getEndStation());
                        dto.setPrice(ticket.getPrice());
                        if (ticket.getDepartureTime() != null) {
                            dto.setDepartureTime(ticket.getDepartureTime().toString());
                        }
                        if (ticket.getTravelDate() != null) {
                            dto.setTravelDate(new java.text.SimpleDateFormat("yyyy-MM-dd").format(ticket.getTravelDate()));
                        }

                        // 查询车次号
                        Result<Train> trainRes = trainFeignClient.getTrainById(ticket.getTrainId());
                        if (trainRes != null && trainRes.getCode() == 200 && trainRes.getData() != null) {
                            dto.setTrainNumber(trainRes.getData().getTrainNumber());
                        }

                        // 查询座位号
                        if (ticket.getSeatId() != null) {
                            Result<Seat> seatRes = salesFeignClient.getSeatById(ticket.getSeatId());
                            if (seatRes != null && seatRes.getCode() == 200 && seatRes.getData() != null) {
                                dto.setSeatNumber(seatRes.getData().getSeatNumber());
                                dto.setSeatType(seatRes.getData().getSeatType());
                            }
                        }
                    }
                } catch (Exception e) {
                    log.error("查询审批单详情失败, requestId={}", req.getRequestId(), e);
                }
            }

            // 改签：解析 requestData 获取新车票信息
            if ("CHANGE_TICKET".equals(req.getRequestType()) && req.getRequestData() != null && !req.getRequestData().isBlank()) {
                try {
                    @SuppressWarnings("unchecked")
                    java.util.Map<String, Object> changeData = objectMapper.readValue(req.getRequestData(), java.util.Map.class);

                    // 新车次号
                    Integer newTrainId = changeData.get("newTrainId") != null ? ((Number) changeData.get("newTrainId")).intValue() : null;
                    if (newTrainId != null) {
                        Result<Train> newTrainRes = trainFeignClient.getTrainById(newTrainId);
                        if (newTrainRes != null && newTrainRes.getCode() == 200 && newTrainRes.getData() != null) {
                            Train newTrain = newTrainRes.getData();
                            dto.setNewTrainNumber(newTrain.getTrainNumber());
                            dto.setNewStartStation(newTrain.getStartStation());
                            dto.setNewEndStation(newTrain.getEndStation());
                            if (newTrain.getDepartureTime() != null) {
                                dto.setNewDepartureTime(newTrain.getDepartureTime().toString());
                            }
                        }
                    }

                    // 新座位号
                    Integer newSeatId = changeData.get("newSeatId") != null ? ((Number) changeData.get("newSeatId")).intValue() : null;
                    if (newSeatId != null) {
                        Result<Seat> newSeatRes = salesFeignClient.getSeatById(newSeatId);
                        if (newSeatRes != null && newSeatRes.getCode() == 200 && newSeatRes.getData() != null) {
                            dto.setNewSeatNumber(newSeatRes.getData().getSeatNumber());
                            dto.setNewSeatType(newSeatRes.getData().getSeatType());
                        }
                    }

                    // 新日期
                    Object newTravelDate = changeData.get("newTravelDate");
                    if (newTravelDate != null) {
                        dto.setNewTravelDate(newTravelDate.toString().substring(0, 10));
                    }

                    // 新票价/差价
                    if (changeData.get("newPrice") != null) {
                        dto.setNewPrice(new BigDecimal(changeData.get("newPrice").toString()));
                    }

                } catch (Exception e) {
                    log.error("解析改签参数失败, requestId={}", req.getRequestId(), e);
                }
            }

            dtos.add(dto);
        }
        return dtos;
    }

    /**
     * 审批通过限流降级处理方法。
     */
    public static Result<Object> approveRequestBlockHandler(Integer requestId, ApproveRequest approveRequest, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        return Result.error("系统繁忙，请稍后重试");
    }

    /**
     * 审批拒绝限流降级处理方法。
     */
    public static Result<Object> rejectRequestBlockHandler(Integer requestId, RejectRequest rejectRequest, com.alibaba.csp.sentinel.slots.block.BlockException ex) {
        return Result.error("系统繁忙，请稍后重试");
    }
}
