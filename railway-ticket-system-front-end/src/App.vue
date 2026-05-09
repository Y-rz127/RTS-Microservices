<template>
  <router-view />
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElNotification } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const ws = ref<WebSocket | null>(null)
const reconnectTimer = ref<number | null>(null)
const manualDisconnect = ref(false)

// 排行榜更新事件
const rankingUpdatedEvent = new CustomEvent('ranking-updated')

// WebSocket 连接
const connectWebSocket = () => {
  const token = localStorage.getItem('token')
  if (!token) return

   if (ws.value && (ws.value.readyState === WebSocket.OPEN || ws.value.readyState === WebSocket.CONNECTING)) {
     return
   }

  // 如果已经连接或正在连接，先关闭
  if (ws.value) {
    ws.value.close()
  }

  const protocol = window.location.protocol === 'https:' ? 'wss' : 'ws'
  const host = window.location.hostname || 'localhost'
  const wsPort = window.location.port === '3000' ? '8081' : (window.location.port || '8081')
  const wsUrl = `${protocol}://${host}:${wsPort}/ws/ticket?token=${token}`
  
  try {
    ws.value = new WebSocket(wsUrl)
    
    ws.value.onopen = () => {
      console.log('Global WebSocket 连接成功')
      userStore.wsConnected = true
      manualDisconnect.value = false
      if (reconnectTimer.value) {
        window.clearTimeout(reconnectTimer.value)
        reconnectTimer.value = null
      }
    }
    
    ws.value.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data)
        console.log('全局收到 WebSocket 消息:', data)
        
        // 处理不同类型的消息
        switch (data.type) {
          case 'BOOKING_RESULT':
            handleBookingResult(data.data)
            break
          case 'REFUND_NOTIFICATION':
            handleRefundNotification(data)
            break
          case 'RANKING_UPDATE':
            handleRankingUpdate(data)
            break
          default:
            console.log('全局未知消息类型:', data.type)
        }
      } catch (error) {
        console.error('解析 WebSocket 消息失败:', error, event.data)
      }
    }
    
    ws.value.onerror = (error) => {
      console.error('WebSocket 错误:', error)
      userStore.wsConnected = false
    }
    
    ws.value.onclose = () => {
      console.log('WebSocket 连接关闭')
      userStore.wsConnected = false
      // 5秒后尝试重连（仅限已登录状态）
      if (reconnectTimer.value) {
        window.clearTimeout(reconnectTimer.value)
      }
      if (!manualDisconnect.value) {
        reconnectTimer.value = window.setTimeout(() => {
          if (!userStore.wsConnected && userStore.isLoggedIn && !manualDisconnect.value) {
            connectWebSocket()
          }
        }, 5000)
      }
    }
  } catch (e) {
    console.error('WebSocket 连接失败:', e)
  }
}

// 处理抢票结果推送
const handleBookingResult = (result: any) => {
  const isGroup = result.tickets && result.tickets.length > 0
  const isSuccess = result.status === 'SUCCESS'
  const title = isSuccess ? (isGroup ? `🎉 团体购票成功！共 ${result.tickets?.length || 0} 张票` : '🎉 抢票成功！') : '❌ 抢票失败'
  const type = isSuccess ? 'success' : 'error'
  
  let message = ''
  if (isSuccess) {
    if (isGroup) {
      message = `团体购票成功！共抢购 ${result.tickets?.length || 0} 张车票。请尽快支付。`
    } else {
      message = `您的车票${result.ticket?.ticketNumber || ''}已抢购成功！请尽快支付。`
    }
  } else {
    message = result.errorMessage || '抢票失败，请重试'
  }

  const orderId = isGroup ? result.tickets?.[0]?.orderId : result.ticket?.orderId

  ElNotification({
    title,
    message,
    type: type as any,
    duration: 8000,
    position: 'top-right',
    onClick: () => {
      if (isSuccess && orderId) {
        router.push({
          path: '/passenger/pay',
          query: { orderId }
        })
      }
    }
  })
  
  // 保存到全局通知列表
  userStore.saveNotification({
    type: 'BOOKING_RESULT',
    title,
    message: isSuccess ? (isGroup ? `团体购票成功，共 ${result.tickets?.length || 0} 张票` : '抢票成功') : '抢票失败',
    data: result
  })
}

// 处理退改通知推送
const handleRefundNotification = (data: any) => {
  ElNotification({
    title: '📢 退改通知',
    message: data.message,
    type: 'info',
    duration: 5000,
    position: 'top-right'
  })

  // 保存到全局通知列表
  userStore.saveNotification({
    type: 'REFUND_NOTIFICATION',
    title: '退改通知',
    message: data.message
  })

  // 触发订单页自动刷新
  userStore.refundNotifyCount++
}

// 处理排行榜更新推送
const handleRankingUpdate = (data: any) => {
  console.log('收到排行榜更新消息:', data)
  // 触发自定义事件通知页面刷新
  window.dispatchEvent(new CustomEvent('ranking-updated', { detail: data }))
}

// 断开 WebSocket
const disconnectWebSocket = () => {
  manualDisconnect.value = true
  if (reconnectTimer.value) {
    window.clearTimeout(reconnectTimer.value)
    reconnectTimer.value = null
  }
  if (ws.value) {
    ws.value.close()
    ws.value = null
  }
  userStore.wsConnected = false
}

// 监听登录状态变化，自动连/断
watch(() => userStore.isLoggedIn, (loggedIn) => {
  if (loggedIn) {
    manualDisconnect.value = false
    connectWebSocket()
  } else {
    disconnectWebSocket()
  }
})

onMounted(() => {
  // 尝试从localStorage恢复登录状态（会触发 watch，自动连接 WebSocket）
  userStore.checkLoginStatus()
})

onUnmounted(() => {
  disconnectWebSocket()
})
</script>

<style scoped>
</style>
