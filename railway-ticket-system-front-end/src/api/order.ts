import request from '@/utils/request'
import { type Order, type ApiResponse, type PageRequest, type PageResponse } from '@/types'

export const orderApi = {
  // 创建订单
  createOrder(data: Partial<Order>) {
    return request.post<any, ApiResponse<Order>>('/orders', data)
  },

  // 支付订单
  payOrder(orderId: number, paymentMethod: string) {
    return request.post<any, ApiResponse<boolean>>(`/orders/pay/${orderId}`, null, {
      params: { method: paymentMethod }
    })
  },

  // 取消订单
  cancelOrder(orderId: number) {
    return request.post<any, ApiResponse<boolean>>(`/orders/cancel/${orderId}`)
  },

  // 根据ID查询订单
  getOrderById(orderId: number) {
    return request.get<any, ApiResponse<Order>>(`/orders/${orderId}`)
  },

  // 分页查询订单
  getOrderPage(params: PageRequest & { userId?: number; status?: string }) {
    return request.get<any, ApiResponse<PageResponse<Order>>>('/orders/page', { params })
  },

  // 查询用户订单
  getUserOrders(userId: number) {
    return request.get<any, ApiResponse<Order[]>>(`/orders/user/${userId}`)
  },

  // 查询当前用户订单（前端兼容封装）
  getMyOrders(userId: number) {
    return request.get<any, ApiResponse<Order[]>>(`/orders/user/${userId}`)
  }
}
