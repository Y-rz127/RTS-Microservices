import request from '@/utils/request'

/**
 * 座位管理相关API
 */

interface ApiResponse<T = any> {
  code: number
  data: T
  message?: string
}

// 获取座位布局（用于座位选择界面）
export const getSeatLayout = (params: {
  trainId: number
  travelDate: string
}): Promise<ApiResponse<any[]>> => {
  return request({
    url: '/seats/layout',
    method: 'get',
    params
  })
}

// 查询可用座位数量
export const getAvailableSeatCount = (params: {
  trainId: number
  seatType: string
}): Promise<ApiResponse<number>> => {
  return request({
    url: '/seats/available-count',
    method: 'get',
    params
  })
}

// 获取指定车次、座位类型、日期的可用座位列表
export const getAvailableSeats = (
  trainId: number,
  seatType: string,
  travelDate: string
): Promise<ApiResponse<any[]>> => {
  return request({
    url: '/seats/available',
    method: 'get',
    params: {
      trainId,
      seatType,
      travelDate
    }
  })
}

// 分页查询座位列表（管理端）
export const getSeatPage = (params: {
  pageNum: number
  pageSize: number
  trainId?: number
  seatType?: string
  status?: string
}): Promise<ApiResponse<any>> => {
  return request({
    url: '/seats/page',
    method: 'get',
    params
  })
}

// 生成座位（管理端）
export const generateSeatsForTrain = (trainId: number, travelDate: string): Promise<ApiResponse<boolean>> => {
  return request({
    url: '/seats/generate',
    method: 'post',
    params: { trainId, travelDate }
  })
}

// 更新座位状态（管理端）
export const updateSeatStatus = (seatId: number, status: string): Promise<ApiResponse<boolean>> => {
  return request({
    url: '/seats/status',
    method: 'put',
    params: { seatId, status }
  })
}

// 清理过期座位（管理端）
export const cleanupExpiredSeats = (): Promise<ApiResponse<number>> => {
  return request({
    url: '/seats/cleanup-expired',
    method: 'post'
  })
}

// 导出 seatApi 对象
export const seatApi = {
  getSeatLayout,
  getAvailableSeatCount,
  getAvailableSeats,
  getSeatPage,
  generateSeatsForTrain,
  updateSeatStatus,
  cleanupExpiredSeats
}

export default seatApi
