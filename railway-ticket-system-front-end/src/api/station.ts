import request from '@/utils/request'
import { type Station, type ApiResponse, type PageRequest, type PageResponse } from '@/types'

export const stationApi = {
  // 获取所有车站
  getAllStations() {
    return request.get<any, ApiResponse<Station[]>>('/station/all')
  },

  // 分页查询车站
  getStationPage(params: PageRequest & { stationName?: string; city?: string }) {
    return request.get<any, ApiResponse<PageResponse<Station>>>('/station/page', { params })
  },

  // 根据ID查询车站
  getStationById(id: number) {
    return request.get<any, ApiResponse<Station>>(`/station/${id}`)
  },

  // 新增车站
  addStation(data: Partial<Station>) {
    return request.post<any, ApiResponse<Station>>('/station/add', data)
  },

  // 更新车站
  updateStation(data: Station) {
    return request.put<any, ApiResponse<Station>>('/station/update', data)
  },

  // 删除车站
  deleteStation(id: number) {
    return request.delete<any, ApiResponse<boolean>>(`/station/delete/${id}`)
  },

  // 更新车站状态
  updateStationStatus(id: number, status: number) {
    return request.put<any, ApiResponse<boolean>>(`/station/status/${id}`, null, {
      params: { status }
    })
  }
}
