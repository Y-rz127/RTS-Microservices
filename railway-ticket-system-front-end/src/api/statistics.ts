import request from '@/utils/request'
import { type ApiResponse } from '@/types'

export const statisticsApi = {
  // 数据概览
  getDashboard() {
    return request.get<any, ApiResponse<any>>('/statistics/dashboard')
  },

  // 售票趋势
  getSalesTrend(days: number = 7) {
    return request.get<any, ApiResponse<any>>('/statistics/sales-trend', {
      params: { days }
    })
  },

  // 收入趋势
  getRevenueTrend(days: number = 7) {
    return request.get<any, ApiResponse<any>>('/statistics/revenue-trend', {
      params: { days }
    })
  },

  // 热门车次（按售票量）
  getTopTrainsBySales(params: { topN: number; startDate: string; endDate: string }) {
    return request.get<any, ApiResponse<any>>('/statistics/top-trains/sales', { params })
  },

  // 热门车次（按收入）
  getTopTrainsByRevenue(params: { topN: number; startDate: string; endDate: string }) {
    return request.get<any, ApiResponse<any>>('/statistics/top-trains/revenue', { params })
  },

  // 退票统计
  getRefundStatistics(params: { startDate: string; endDate: string }) {
    return request.get<any, ApiResponse<any>>('/statistics/refund', { params })
  },

  // 乘客统计
  getPassengerStatistics(params: { startDate: string; endDate: string }) {
    return request.get<any, ApiResponse<any>>('/statistics/passenger', { params })
  }
}
