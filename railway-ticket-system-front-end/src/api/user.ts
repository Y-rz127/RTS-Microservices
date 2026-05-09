import request from '@/utils/request'
import { type LoginRequest, type RegisterRequest, type LoginResponse, type User, type ApiResponse } from '@/types'

export const userApi = {
  // 登录
  login(data: LoginRequest) {
    return request.post<any, ApiResponse<LoginResponse>>('/user/login', data)
  },

  // 登出
  logout() {
    return request.post('/user/logout')
  },

  // 注册
  register(data: RegisterRequest) {
    return request.post<any, ApiResponse<any>>('/user/register', data)
  },

  // 获取当前用户信息
  getCurrentUser() {
    return request.get<any, ApiResponse<User>>('/user/current')
  },

  // 更新当前用户信息
  updateCurrentUser(data: Partial<User>) {
    return request.put('/user/update', data)
  },

  // 修改密码
  changePassword(data: { oldPassword: string; newPassword: string }) {
    return request.put('/user/changePassword', data)
  },

  // 获取用户列表（分页）
  getUserPage(params: any) {
    return request.get<any, ApiResponse<any>>('/user/page', { params })
  },

  // 更新用户信息（管理员）
  updateUser(userId: number, data: any) {
    return request.put(`/user/${userId}`, data)
  },

  // 删除用户
  deleteUser(userId: number) {
    return request.delete(`/user/${userId}`)
  },

  // 更新用户状态（启用/禁用）
  updateUserStatus(userId: number, status: number) {
    return request.put(`/user/status/${userId}?status=${status}`)
  }
}
