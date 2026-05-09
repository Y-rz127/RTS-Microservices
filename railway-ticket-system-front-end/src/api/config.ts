import request from '@/utils/request'
import { type ApiResponse } from '@/types'

export interface SystemConfig {
  configId?: number
  configKey: string
  configValue: string
  configType?: string
  description?: string
  isSystem?: number
  status?: number
  createdAt?: string
  updatedAt?: string
}

export const configApi = {
  // 分页查询系统配置
  getConfigPage(params: {
    pageNum: number
    pageSize: number
    configKey?: string
    configType?: string
  }) {
    return request.get<any, ApiResponse<any>>('/config/page', { params })
  },

  // 获取所有配置
  getAllConfigs() {
    return request.get<any, ApiResponse<SystemConfig[]>>('/config/all')
  },

  // 根据配置键获取值
  getConfigValue(configKey: string) {
    return request.get<any, ApiResponse<string>>(`/config/get/${configKey}`)
  },

  // 根据类型获取配置
  getConfigsByType(configType: string) {
    return request.get<any, ApiResponse<SystemConfig[]>>(`/config/type/${configType}`)
  },

  // 新增配置
  addConfig(data: SystemConfig) {
    return request.post<any, ApiResponse<SystemConfig>>('/config/add', data)
  },

  // 更新配置
  updateConfig(data: SystemConfig) {
    return request.put<any, ApiResponse<SystemConfig>>('/config/update', data)
  },

  // 删除配置
  deleteConfig(configId: number) {
    return request.delete<any, ApiResponse<boolean>>(`/config/delete/${configId}`)
  },

  // 批量更新配置
  batchUpdateConfigs(configs: SystemConfig[]) {
    return request.put<any, ApiResponse<boolean>>('/config/batchUpdate', configs)
  }
}
