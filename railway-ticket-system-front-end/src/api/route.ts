import request from '@/utils/request'
import { type Route, type ApiResponse, type PageRequest, type PageResponse } from '@/types'

export const routeApi = {
  // 分页查询路线
  getRoutePage(params: PageRequest & { trainId?: number; stationId?: number }) {
    return request.get<any, ApiResponse<PageResponse<Route>>>('/route/page', { params })
  },

  // 根据车次ID查询路线
  getRoutesByTrainId(trainId: number) {
    return request.get<any, ApiResponse<Route[]>>(`/route/getByTrainId/${trainId}`)
  },

  // 根据ID查询路线
  getRouteById(id: number) {
    return request.get<any, ApiResponse<Route>>(`/route/getById/${id}`)
  },

  // 新增路线
  addRoute(data: Partial<Route>) {
    return request.post<any, ApiResponse<Route>>('/route/add', data)
  },

  // 批量新增路线
  addRoutes(data: Partial<Route>[]) {
    return request.post<any, ApiResponse<boolean>>('/route/addBatch', data)
  },

  // 更新路线
  updateRoute(data: Route) {
    return request.put<any, ApiResponse<Route>>('/route/update', data)
  },

  // 删除路线
  deleteRoute(id: number) {
    return request.delete<any, ApiResponse<boolean>>(`/route/delete/${id}`)
  },

  // 删除车次的所有路线
  deleteRoutesByTrainId(trainId: number) {
    return request.delete<any, ApiResponse<boolean>>(`/route/deleteByTrainId/${trainId}`)
  }
}
