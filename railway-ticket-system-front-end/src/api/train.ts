import request from '@/utils/request'
import { type Train, type ApiResponse, type PageResponse } from '@/types'

export const trainApi = {
  // 获取所有车次
  getAllTrains() {
    return request.get<any, ApiResponse<Train[]>>('/train/list')
  },

  // 高级搜索车次（用于分页查询）
  searchTrains(params: any) {
    return request.get<any, ApiResponse<PageResponse<Train>>>('/train/search', { params })
  },

  // 根据ID查询车次
  getTrainById(id: number) {
    return request.get<any, ApiResponse<Train>>(`/train/${id}`)
  },

  // 新增车次
  addTrain(data: Partial<Train>) {
    return request.post<any, ApiResponse<Train>>('/train/add', data)
  },

  // 更新车次
  updateTrain(data: Train) {
    return request.put<any, ApiResponse<Train>>('/train/update', data)
  },

  // 删除车次
  deleteTrain(trainId: number) {
    return request.delete<any, ApiResponse<boolean>>(`/train/delete/${trainId}`)
  },

  // 批量删除车次
  batchDeleteTrains(ids: number[]) {
    return request.delete<any, ApiResponse<boolean>>('/train/batch', { data: ids })
  },

  // 更新车次状态
  updateTrainStatus(trainId: number, status: number) {
    return request.put<any, ApiResponse<boolean>>(`/train/status/${trainId}`, null, {
      params: { status }
    })
  },

  // 获取车次途径站信息
  getTrainRoutes(trainId: number) {
    return request.get<any, ApiResponse<any[]>>(`/train/${trainId}/routes`)
  }
}
