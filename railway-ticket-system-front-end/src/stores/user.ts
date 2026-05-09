import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { type User } from '@/types'
import { userApi } from '@/api/user'
import { ElMessage } from 'element-plus'
import router from '@/router'

export const useUserStore = defineStore('user', () => {
  const token = ref<string>('')
  const userInfo = ref<User | null>(null)
  const notifications = ref<any[]>(JSON.parse(localStorage.getItem('ws_notifications') || '[]'))
  const wsConnected = ref(false)
  const refundNotifyCount = ref(0)

  // 保存消息
  const saveNotification = (notification: any) => {
    notifications.value.unshift({
      id: Date.now(),
      ...notification,
      time: new Date().toLocaleString()
    })
    localStorage.setItem('ws_notifications', JSON.stringify(notifications.value))
  }

  // 清空消息
  const clearNotifications = () => {
    notifications.value = []
    localStorage.removeItem('ws_notifications')
  }

  const isLoggedIn = computed(() => !!token.value)

  // 登录
  const login = async (username: string, password: string) => {
    try {
      const res = await userApi.login({ username, password })
      if (res.code === 200) {
        token.value = res.data.token
        userInfo.value = res.data.user
        
        // 保存到localStorage
        localStorage.setItem('token', token.value)
        localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
        
        ElMessage.success('登录成功')
        
        // 根据角色跳转
        if (userInfo.value.role === 'ADMIN' || userInfo.value.role === 'OPERATOR') {
          router.push('/admin/dashboard')
        } else if (userInfo.value.role === 'PASSENGER') {
          router.push('/passenger/home')
        }
        
        return true
      } else {
        ElMessage.error(res.message || '登录失败')
        return false
      }
    } catch (error: any) {
      ElMessage.error(error.message || '登录失败')
      return false
    }
  }

  // 登出
  const logout = async () => {
    try {
      await userApi.logout()
    } catch (error) {
      console.error('登出请求失败', error)
    } finally {
      token.value = ''
      userInfo.value = null
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
      ElMessage.success('已退出登录')
      router.push('/login')
    }
  }

  // 检查登录状态
  const checkLoginStatus = () => {
    const savedToken = localStorage.getItem('token')
    const savedUserInfo = localStorage.getItem('userInfo')
    
    if (savedToken && savedUserInfo) {
      token.value = savedToken
      userInfo.value = JSON.parse(savedUserInfo)
    }
  }

  // 更新用户信息
  const updateUserInfo = (newUserInfo: Partial<User>) => {
    if (userInfo.value) {
      userInfo.value = { ...userInfo.value, ...newUserInfo }
      localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
    }
  }

  return {
    token,
    userInfo,
    notifications,
    wsConnected,
    refundNotifyCount,
    isLoggedIn,
    login,
    logout,
    saveNotification,
    clearNotifications,
    checkLoginStatus,
    updateUserInfo
  }
})
