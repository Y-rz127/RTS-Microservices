import request from '@/utils/request'
import { type ApiResponse } from '@/types'

export const logApi = {
  // 获取操作日志列表（分页）
  getLogPage(params: {
    pageNum: number
    pageSize: number
    userId?: number
    operation?: string
    module?: string
    startTime?: string
    endTime?: string
  }) {
    return request.get<any, ApiResponse<any>>('/log/page', { params })
  },

  // 清除过期日志
  clearExpiredLogs(days: number) {
    return request.delete<any, ApiResponse<boolean>>('/log/clearExpired', { params: { days } })
  },

  // 获取今日操作统计
  getTodayStatistics() {
    return request.get<any, ApiResponse<any>>('/log/statistics/today')
  },

  // 根据模块查询日志
  getLogsByModule(module: string, params: { pageNum: number; pageSize: number }) {
    return request.get<any, ApiResponse<any>>(`/log/module/${module}`, { params })
  }
}
