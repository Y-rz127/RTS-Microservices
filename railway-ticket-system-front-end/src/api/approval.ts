import request from '@/utils/request'
import type { ApiResponse } from '@/types'

// 申请退票请求
export interface ApplyRefundRequest {
  ticketId: number
  applyReason?: string
}

// 申请取消预订请求
export interface ApplyCancelBookingRequest {
  ticketId: number
  applyReason?: string
}

// 申请改签请求
export interface ApplyChangeTicketRequest {
  ticketId: number
  newTrainId: number
  newSeatId: number
  newTravelDate: Date
  newDepartureTime: Date
  newArrivalTime: Date
  newPrice: number
  applyReason?: string
}

// 批准申请请求
export interface ApproveRequest {
  operatorId: number
}

// 拒绝申请请求
export interface RejectRequest {
  operatorId: number
  rejectReason: string
}

// 审批请求详情
export interface ApprovalRequestDetail {
  requestId: number
  requestType: string
  ticketId: number
  orderId: number
  userId: number
  userName: string
  status: string
  applyReason: string
  rejectReason: string
  trainNumber: string
  startStation: string
  endStation: string
  departureTime: string
  travelDate: string
  seatNumber: string
  seatType: string
  price: number
  refundFee: number
  refundAmount: number
  createdAt: string
  processedAt: string
}

export const approvalApi = {
  // ========== 乘客端接口 ==========
  
  // 申请退票
  applyRefund(data: ApplyRefundRequest) {
    return request.post<any, ApiResponse<any>>('/approval/apply/refund', data)
  },

  // 申请取消预订
  applyCancelBooking(data: ApplyCancelBookingRequest) {
    return request.post<any, ApiResponse<any>>('/approval/apply/cancel-booking', data)
  },

  // 申请改签
  applyChangeTicket(data: ApplyChangeTicketRequest) {
    return request.post<any, ApiResponse<any>>('/approval/apply/change-ticket', data)
  },

  // 查询我的申请
  getMyRequests() {
    return request.get<any, ApiResponse<ApprovalRequestDetail[]>>('/approval/my-requests')
  },

  // ========== 操作员端接口 ==========
  
  // 查询待审批申请
  getPendingRequests() {
    return request.get<any, ApiResponse<ApprovalRequestDetail[]>>('/operator/approval/pending')
  },

  // 查询所有审批记录
  getAllRequests() {
    return request.get<any, ApiResponse<ApprovalRequestDetail[]>>('/operator/approval/all')
  },

  // 批准申请
  approveRequest(requestId: number, data: ApproveRequest) {
    return request.post<any, ApiResponse<any>>(`/operator/approval/approve/${requestId}`, data)
  },

  // 拒绝申请
  rejectRequest(requestId: number, data: RejectRequest) {
    return request.post<any, ApiResponse<any>>(`/operator/approval/reject/${requestId}`, data)
  }
}
