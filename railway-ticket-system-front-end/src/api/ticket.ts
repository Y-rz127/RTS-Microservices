import request from '@/utils/request'
import { type Ticket, type ApiResponse } from '@/types'

export const ticketApi = {
  // ========== 同步接口 ==========
  // 单人售票
  sellTicket(data: any) {
    return request.post<any, ApiResponse<Ticket>>('/tickets/sell', data)
  },

  // 团体售票
  groupSellTicket(data: any) {
    return request.post<any, ApiResponse<Ticket[]>>('/tickets/group/sell', data)
  },

  // 改签
  changeTicket(data: any) {
    return request.post<any, ApiResponse<any>>('/tickets/change', data)
  },

  // 退票
  refundTicket(data: { ticketId: number; isFreeRefund?: boolean }) {
    return request.post<any, ApiResponse<number>>('/tickets/refund', data)
  },

  // 团体退票
  refundGroupTickets(data: { ticketIds: number[]; isFreeRefund?: boolean }) {
    return request.post<any, ApiResponse<number>>('/tickets/group/refund', data)
  },

  // 取消预订
  cancelBooking(ticketId: number) {
    return request.post<any, ApiResponse<boolean>>(`/tickets/cancel-booking/${ticketId}`)
  },

  // 查询车票详情
  getTicketById(ticketId: number) {
    return request.get<any, ApiResponse<Ticket>>(`/tickets/${ticketId}`)
  },

  // 查询用户的车票
  getTicketsByUserId(userId: number) {
    return request.get<any, ApiResponse<Ticket[]>>(`/tickets/user/${userId}`)
  },

  // ========== 异步购票（高并发场景）==========
  // 异步单人抢票
  asyncSellTicket(data: any) {
    return request.post<any, ApiResponse<any>>('/async/ticket/sell', data)
  },

  // 异步团体抢票
  asyncGroupSellTicket(data: any) {
    return request.post<any, ApiResponse<any>>('/async/ticket/group/sell', data)
  },

  // 查询抢票结果
  getAsyncBookingResult(queueId: string) {
    return request.get<any, ApiResponse<any>>(`/async/ticket/result/${queueId}`)
  },

  // 查询排队位置
  getQueuePosition(queueId: string) {
    return request.get<any, ApiResponse<any>>(`/async/ticket/position/${queueId}`)
  },

  // 取消排队
  cancelAsyncTask(queueId: string) {
    return request.delete<any, ApiResponse<boolean>>(`/async/ticket/task/${queueId}`)
  }
}
