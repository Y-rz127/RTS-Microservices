<template>
  <div class="my-orders">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>我的订单</span>
          <el-button type="primary" icon="Refresh" @click="loadOrders">刷新</el-button>
        </div>
      </template>

      <!-- 订单列表 -->
      <el-row v-if="orderList.length > 0" :gutter="20" class="order-list">
        <el-col v-for="order in orderList" :key="order.order?.orderId || order.orderId" :xs="24" :sm="12" class="order-col">
          <div class="order-item">
            <div class="order-header">
              <div class="order-number">
                订单号：{{ order.order?.orderNumber || order.orderNumber }}
              </div>
              <div class="order-status">
                <el-tag 
                  v-if="(order.order?.isPreBooking === 1) || (order.isPreBooking === 1)" 
                  type="warning" 
                  size="small" 
                  style="margin-right: 8px"
                >
                  预订票
                </el-tag>
                <el-tag 
                  v-if="order.ticketStatus === 'CHANGED' || order.status === 'CHANGED'" 
                  type="info" 
                  size="small" 
                  style="margin-right: 8px"
                >
                  已改签
                </el-tag>
                <el-tag :type="getStatusType(order.order?.orderStatus || order.orderStatus)">
                  {{ getStatusText(order.order?.orderStatus || order.orderStatus) }}
                </el-tag>
              </div>
            </div>

            <div class="order-content">
              <div class="order-info">
                <div class="info-item">
                  <span class="label">车次：</span>
                  <span class="value">{{ order.trainNumber || 'N/A' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">出发站：</span>
                  <span class="value">{{ order.startStation || 'N/A' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">到达站：</span>
                  <span class="value">{{ order.endStation || 'N/A' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">出发时间：</span>
                  <span class="value">{{ order.departureTime || 'N/A' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">座位类型：</span>
                  <span class="value">{{ order.seatType || '未知' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">乘车日期：</span>
                  <span class="value">{{ order.travelDate || 'N/A' }}</span>
                </div>
              </div>

              <div class="order-price">
                <div class="amount">¥{{ order.order?.totalAmount || order.totalAmount }}</div>
                <div class="label">订单金额</div>
              </div>

              <div class="order-actions">
                <!-- 未支付订单：立即支付、取消订单 -->
                <el-button
                  v-if="(order.order?.orderStatus || order.orderStatus) === 'UNPAID' || (order.order?.orderStatus || order.orderStatus) === 'PENDING'"
                  type="primary"
                  size="small"
                  @click="handlePay(order)"
                >
                  立即支付
                </el-button>
                <el-button
                  v-if="(order.order?.orderStatus || order.orderStatus) === 'UNPAID' || (order.order?.orderStatus || order.orderStatus) === 'PENDING'"
                  type="danger"
                  size="small"
                  @click="handleCancel(order)"
                >
                  取消订单
                </el-button>

                <!-- 已支付的车票 -->
                <el-button
                  v-if="(order.order?.orderStatus || order.orderStatus) === 'PAID'"
                  type="warning"
                  size="small"
                  @click="handleApplyRefund(order)"
                >
                  申请退票
                </el-button>
                <el-button
                  v-if="(order.order?.orderStatus || order.orderStatus) === 'PAID'"
                  type="primary"
                  size="small"
                  @click="handleChangeTicket(order)"
                >
                  申请改签
                </el-button>
                
                <!-- 待审批状态 -->
                <el-button
                  v-if="order.approvalStatus === 'PENDING'"
                  type="info"
                  size="small"
                  disabled
                >
                  审批中
                </el-button>
                
                <!-- 申请被拒绝 -->
                <el-button
                  v-if="order.approvalStatus === 'REJECTED'"
                  type="danger"
                  size="small"
                  @click="showRejectReason(order)"
                >
                  申请被拒绝
                </el-button>
                
                <!-- 查看详情 -->
                <el-button
                  size="small"
                  @click="viewDetail(order)"
                >
                  查看详情
                </el-button>
              </div>
            </div>

            <div class="order-footer">
              <span>创建时间：{{ formatDateTime(order.order?.createdAt) }}</span>
              <span
                v-if="['UNPAID', 'PENDING'].includes(order.order?.orderStatus || order.orderStatus)"
                style="margin-left: 16px; color: #e6a23c"
              >
                剩余支付时间：{{ getRemainingPayTime(order.order?.createdAt) }}
              </span>
            </div>
          </div>
        </el-col>
      </el-row>

      <!-- 空状态 -->
      <el-empty v-else description="暂无订单" />
    </el-card>

    <!-- 订单详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="订单详情"
      width="600px"
    >
      <el-descriptions :column="2" border>
        <el-descriptions-item label="订单号" :span="2">
          <el-tag>{{ orderDetail.orderNumber }}</el-tag>
        </el-descriptions-item>
        
        <el-descriptions-item label="订单类型">
          <div>
            <el-tag :type="orderDetail.orderType === 'GROUP' ? 'success' : 'primary'">
              {{ orderDetail.orderType === 'GROUP' ? '团体购票' : '单人购票' }}
            </el-tag>
            <span v-if="orderDetail.orderType === 'GROUP' && orderDetail.passengerCount" style="margin-left: 10px; color: #409eff;">
              ({{ orderDetail.passengerCount }}人)
            </span>
          </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="是否预订票">
          <el-tag :type="orderDetail.isPreBooking === 1 ? 'warning' : 'info'">
            {{ orderDetail.isPreBooking === 1 ? '是（预订票）' : '否（直接购票）' }}
          </el-tag>
        </el-descriptions-item>
        
        <el-descriptions-item label="车次">
          {{ orderDetail.trainNumber || 'N/A' }}
        </el-descriptions-item>
        
        <el-descriptions-item label="座位类型">
          {{ orderDetail.seatType || 'N/A' }}
        </el-descriptions-item>
        
        <el-descriptions-item label="出发站">
          {{ orderDetail.startStation || 'N/A' }}
        </el-descriptions-item>
        
        <el-descriptions-item label="到达站">
          {{ orderDetail.endStation || 'N/A' }}
        </el-descriptions-item>
        
        <el-descriptions-item label="出发时间">
          {{ orderDetail.departureTime || 'N/A' }}
        </el-descriptions-item>
        
        <el-descriptions-item label="到达时间">
          {{ orderDetail.arrivalTime || 'N/A' }}
        </el-descriptions-item>
        
        <el-descriptions-item label="乘车日期" :span="2">
          {{ orderDetail.travelDate || 'N/A' }}
        </el-descriptions-item>
        
        <el-descriptions-item label="订单金额">
          <span style="color: #f56c6c; font-size: 18px; font-weight: bold;">¥{{ orderDetail.totalAmount }}</span>
        </el-descriptions-item>
        
        <el-descriptions-item label="订单状态">
          <el-tag :type="getStatusType(orderDetail.orderStatus)">
            {{ getStatusText(orderDetail.orderStatus) }}
          </el-tag>
        </el-descriptions-item>
      </el-descriptions>
      
      <template #footer>
        <el-button type="primary" @click="detailDialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 改签对话框 -->
    <ChangeTicketDialog
      v-model="changeDialogVisible"
      :order="changeOrder"
      @success="handleChangeSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { orderApi } from '@/api/order'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'
import ChangeTicketDialog from '@/components/ChangeTicketDialog.vue'

const router = useRouter()
const userStore = useUserStore()

const orderList = ref<any[]>([])
// const selectedOrder = ref<any>({})
const detailDialogVisible = ref(false)
const orderDetail = ref<any>({})
const changeDialogVisible = ref(false)
const changeOrder = ref<any>({})
const nowTick = ref(Date.now())
let payCountdownTimer: number | null = null

// const payForm = reactive({
//   paymentMethod: '支付宝'
// })

// 加载订单列表
const loadOrders = async () => {
  try {
    const userId = userStore.userInfo?.userid
    if (!userId) {
      ElMessage.error('未获取到当前用户信息')
      return
    }
    console.log('当前用户ID:', userId)
    const res = await orderApi.getMyOrders(userId)
    console.log('订单查询结果:', res)
    if (res.code === 200) {
      orderList.value = res.data || []
      // 加载每个订单的审批记录
      await loadApprovalRecords()
    } else {
      console.error('订单查询失败:', res.message)
    }
  } catch (error) {
    console.error('加载订单异常:', error)
    ElMessage.error('加载订单失败')
  }
}

// 加载审批记录
const loadApprovalRecords = async () => {
  try {
    const { approvalApi } = await import('@/api/approval')
    const res = await approvalApi.getMyRequests()
    if (res.code === 200 && res.data) {
      // 将审批记录映射到订单上
      const approvalMap = new Map()
      res.data.forEach((approval: any) => {
        const orderId = approval.orderId
        if (orderId) {
          // 如果同一订单有多条记录，取最新的
          if (!approvalMap.has(orderId) || 
              new Date(approval.createdAt) > new Date(approvalMap.get(orderId).createdAt)) {
            approvalMap.set(orderId, approval)
          }
        }
      })
      
      // 将审批信息添加到订单中
      orderList.value = orderList.value.map((order: any) => {
        const orderId = order.order?.orderId || order.orderId
        const approval = approvalMap.get(orderId)
        if (approval) {
          return {
            ...order,
            approvalStatus: approval.status,
            approvalType: approval.requestType,
            rejectReason: approval.rejectReason,
            approvalRequestId: approval.requestId
          }
        }
        return order
      })
    }
  } catch (error) {
    console.error('加载审批记录失败', error)
  }
}

// 获取订单状态类型
const getStatusType = (status: string) => {
  const typeMap: any = {
    'UNPAID': 'warning',
    'PENDING': 'warning',
    'PAID': 'success',
    'CANCELLED': 'info',
    'COMPLETED': 'success',
    'REFUNDED': 'danger',
    'PENDING_REFUND': 'warning'
  }
  return typeMap[status] || 'info'
}

// 获取订单状态文本
const getStatusText = (status: string) => {
  const textMap: any = {
    'UNPAID': '待支付',
    'PENDING': '待支付',
    'PAID': '已支付',
    'CANCELLED': '已取消',
    'COMPLETED': '已完成',
    'REFUNDED': '已退款',
    'PENDING_REFUND': '待审批'
  }
  return textMap[status] || status
}

// 格式化日期
// @ts-ignore - 保留以备后用
const formatDate = (dateStr: string) => {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

// 格式化日期时间
const formatDateTime = (dateStr: string) => {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleString('zh-CN')
}

const getRemainingPayTime = (createdAt?: string) => {
  nowTick.value
  if (!createdAt) return '00:00'
  const expireAt = new Date(createdAt).getTime() + 15 * 60 * 1000
  const left = Math.max(0, expireAt - Date.now())
  const mm = String(Math.floor(left / 60000)).padStart(2, '0')
  const ss = String(Math.floor((left % 60000) / 1000)).padStart(2, '0')
  return `${mm}:${ss}`
}

// 支付订单
const handlePay = (order: any) => {
  const o = order.order || order
  router.push({
    path: '/passenger/pay',
    query: { orderId: o.orderId }
  })
}

// 取消订单
const handleCancel = (order: any) => {
  ElMessageBox.confirm('确定要取消该订单吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      const res = await orderApi.cancelOrder(order.order?.orderId || order.orderId)
      if (res.code === 200) {
        ElMessage.success('订单已取消')
        void loadOrders()
      } else {
        ElMessage.error(res.message || '取消失败')
      }
    } catch (error: any) {
      ElMessage.error(error.message || '取消失败')
    }
  }).catch(() => {})
}

// 判断车次是否已发车
const isTrainDeparted = (order: any) => {
  if (!order.travelDate || !order.departureTime) return false
  
  const [hours, minutes, seconds] = order.departureTime.split(':').map(Number)
  const departureDate = new Date(order.travelDate)
  departureDate.setHours(hours, minutes, seconds || 0, 0)
  
  return Date.now() > departureDate.getTime()
}

// 申请退票（支持单人和团体购票）
const handleApplyRefund = async (order: any) => {
  try {
    // 校验发车时间
    if (isTrainDeparted(order)) {
      ElMessage.warning('该车次已发车，无法申请退票')
      return
    }

    // 获取所有车票ID（支持多种数据结构）
    let ticketIds: number[] = []
    
    // 方式1：从tickets数组获取（后端返回的字段名）
    if (order.tickets && order.tickets.length > 0) {
      ticketIds = order.tickets.map((t: any) => t.ticketId).filter((id: any) => id)
    }
    // 方式2：从ticketDetails数组获取（备用）
    else if (order.ticketDetails && order.ticketDetails.length > 0) {
      ticketIds = order.ticketDetails.map((t: any) => t.ticketId).filter((id: any) => id)
    }
    // 方式3：直接从order对象获取（单票）
    else if (order.ticketId) {
      ticketIds = [order.ticketId]
    }
    
    console.log('提取的车票IDs:', ticketIds, '数量:', ticketIds.length)
    
    if (ticketIds.length === 0) {
      ElMessage.error('车票信息错误，无法获取票据ID。请查看浏览器控制台获取详细信息。')
      return
    }
    
    // 根据票数显示不同的提示信息
    const ticketCount = ticketIds.length
    const confirmMessage = ticketCount > 1 
      ? `此订单包含 ${ticketCount} 张车票（团体购票），将全部申请退票。确认继续吗？`
      : '确认申请退票吗？'
    
    // 先确认是否继续
    await ElMessageBox.confirm(
      confirmMessage,
      '退票确认',
      {
        confirmButtonText: '继续',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    // 弹出对话框让用户输入申请原因
    const { value: applyReason } = await ElMessageBox.prompt(
      ticketCount > 1 ? `请输入退票原因（将应用于全部${ticketCount}张车票）` : '请输入退票原因',
      '申请退票',
      {
        confirmButtonText: '提交申请',
        cancelButtonText: '取消',
        inputPattern: /.+/,
        inputErrorMessage: '请输入退票原因',
        inputPlaceholder: '例如：行程变更、临时有事等'
      }
    )
    
    // 批量提交退票申请
    const approvalApi = await import('@/api/approval').then(m => m.approvalApi)
    const promises = ticketIds.map(ticketId => 
      approvalApi.applyRefund({ ticketId, applyReason })
    )
    
    const results = await Promise.all(promises)
    const successCount = results.filter(r => r.code === 200).length
    const failCount = ticketCount - successCount
    
    // 收集失败原因
    const failedMessages = results
      .filter(r => r.code !== 200)
      .map(r => r.message || '未知错误')
      .filter((msg, index, self) => self.indexOf(msg) === index) // 去重
    
    console.log('退票申请结果:', results)
    console.log('失败原因:', failedMessages)
    
    if (successCount === ticketCount) {
      ElMessage.success(
        ticketCount > 1 
          ? `已成功提交 ${successCount} 张车票的退票申请，请等待操作员审批` 
          : '退票申请已提交，请等待操作员审批'
      )
    } else if (successCount > 0) {
      ElMessage.warning(`成功提交 ${successCount} 张车票的退票申请，${failCount} 张提交失败：${failedMessages.join('; ')}`)
    } else {
      ElMessage.error(`全部退票申请提交失败：${failedMessages.join('; ')}`)
    }
    
    void loadOrders()
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '提交申请失败')
    }
  }
}

// 申请改签（支持单人和团体购票）
const handleChangeTicket = async (order: any) => {
  try {
    // 校验发车时间
    if (isTrainDeparted(order)) {
      ElMessage.warning('该车次已发车，无法申请改签')
      return
    }

    // 获取所有车票
    let tickets: any[] = []
    
    if (order.tickets && order.tickets.length > 0) {
      tickets = order.tickets
    } else if (order.ticketDetails && order.ticketDetails.length > 0) {
      tickets = order.ticketDetails
    } else if (order.ticketId) {
      // 单张票，构造tickets数组
      tickets = [order]
    }
    
    const ticketCount = tickets.length
    console.log('申请改签 - 车票数量:', ticketCount, '车票数据:', tickets)
    
    if (ticketCount === 0) {
      ElMessage.error('车票信息错误，无法获取票据')
      return
    }
    
    // 团体购票改签说明
    if (ticketCount > 1) {
      const confirmHTML = `
        <div style="text-align: left; line-height: 1.8;">
          <p style="font-size: 16px; color: #409EFF; font-weight: bold; margin-bottom: 12px;">
            📋 此订单包含 ${ticketCount} 张车票（团体购票）
          </p>
          <div style="background: #f0f9ff; padding: 12px; border-radius: 6px; margin-bottom: 12px;">
            <p style="font-weight: bold; color: #333; margin-bottom: 8px;">改签方式：</p>
            <p>✓ 为所有 ${ticketCount} 张车票批量改签到同一车次</p>
            <p>✓ 每张车票将分别提交改签申请</p>
            <p>✓ 每张车票需要单独选择新座位</p>
          </div>
          <div style="background: #fff7e6; padding: 12px; border-radius: 6px;">
            <p style="font-weight: bold; color: #ff9800; margin-bottom: 6px;">⚠️ 注意事项：</p>
            <p style="color: #666;">• 改签后的车票价格可能不同，系统会自动计算差价</p>
            <p style="color: #666;">• 所有改签申请需等待操作员审批</p>
            <p style="color: #666;">• 审批通过后同步执行改签，保留座位锁机制</p>
          </div>
        </div>
      `
      
      await ElMessageBox.confirm(
        confirmHTML,
        '团体改签确认',
        {
          confirmButtonText: '开始批量改签',
          cancelButtonText: '取消',
          type: 'info',
          dangerouslyUseHTMLString: true,
          customClass: 'group-change-confirm'
        }
      )
    }
    
    // 传递完整的订单信息和票据列表给改签对话框
    changeOrder.value = {
      ...order,
      tickets: tickets,
      ticketCount: ticketCount,
      isGroupBooking: ticketCount > 1
    }
    
    changeDialogVisible.value = true
  } catch (error: any) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '操作失败')
    }
  }
}

// 改签成功回调
const handleChangeSuccess = () => {
  loadOrders()
}

// 显示拒绝原因
const showRejectReason = (order: any) => {
  const approvalTypeMap: Record<string, string> = {
    'REFUND': '退票',
    'CANCEL_BOOKING': '取消预订',
    'CHANGE_TICKET': '改签'
  }
  const approvalTypeText = approvalTypeMap[order.approvalType as string] || '审批'
  
  ElMessageBox.alert(
    order.rejectReason || '无拒绝原因说明',
    `${approvalTypeText}申请被拒绝`,
    {
      confirmButtonText: '我知道了',
      type: 'error',
      dangerouslyUseHTMLString: false
    }
  )
}

// 查看详情
const viewDetail = (order: any) => {
  console.log('原始订单数据：', order)
  
  // 获取订单基本信息
  const orderData = order.order || order
  console.log('订单基本信息：', orderData)
  console.log('isPreBooking值：', orderData.isPreBooking, '类型：', typeof orderData.isPreBooking)
  
  // 合并订单数据和行程数据
  orderDetail.value = {
    orderNumber: orderData.orderNumber,
    orderType: orderData.orderType || 'INDIVIDUAL',
    isPreBooking: orderData.isPreBooking,
    passengerCount: order.passengerCount,
    trainNumber: order.trainNumber,
    seatType: order.seatType,
    startStation: order.startStation,
    endStation: order.endStation,
    departureTime: order.departureTime,
    arrivalTime: order.arrivalTime,
    travelDate: order.travelDate,
    totalAmount: orderData.totalAmount,
    orderStatus: orderData.orderStatus
  }
  
  console.log('合并后的订单详情：', orderDetail.value)
  detailDialogVisible.value = true
}

watch(() => userStore.refundNotifyCount, (count) => {
  if (count > 0) loadOrders()
})

onMounted(() => {
  payCountdownTimer = window.setInterval(() => {
    nowTick.value = Date.now()
  }, 1000)
  loadOrders()
})

onUnmounted(() => {
  if (payCountdownTimer) {
    window.clearInterval(payCountdownTimer)
    payCountdownTimer = null
  }
})
</script>

<style scoped lang="scss">
.my-orders {
  padding: 20px;
  background: #f0f2f5;
  min-height: calc(100vh - 60px);

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .order-list {
    .order-col {
      margin-bottom: 20px;
    }

    .order-item {
      background: #fff;
      border: 1px solid #e4e7ed;
      border-radius: 8px;
      padding: 15px; // 缩小padding以适应两列
      height: 100%; // 确保高度一致
      display: flex;
      flex-direction: column;
      box-shadow: 0 2px 12px 0 rgba(0,0,0,0.05);
      transition: all 0.3s;

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 16px 0 rgba(0,0,0,0.1);
      }

      .order-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding-bottom: 10px;
        border-bottom: 1px solid #e4e7ed;
        margin-bottom: 12px;

        .order-number {
          font-weight: bold;
          color: #303133;
          font-size: 14px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
          flex: 1;
          margin-right: 10px;
        }
      }

      .order-content {
        display: flex;
        flex: 1;
        gap: 15px;

        .order-info {
          flex: 1;
          display: grid;
          grid-template-columns: 1fr; // 在窄屏下改为单列，或者保持双列
          gap: 8px;

          @media (min-width: 1400px) {
            grid-template-columns: repeat(2, 1fr);
          }

          .info-item {
            font-size: 13px;
            .label {
              color: #909399;
              margin-right: 4px;
            }

            .value {
              color: #303133;
              font-weight: 500;
            }
          }
        }

        .order-price {
          text-align: center;
          padding: 0 10px;
          border-left: 1px solid #e4e7ed;
          border-right: 1px solid #e4e7ed;
          display: flex;
          flex-direction: column;
          justify-content: center;
          min-width: 80px;

          .amount {
            font-size: 20px;
            font-weight: bold;
            color: #f56c6c;
            margin-bottom: 4px;
          }

          .label {
            font-size: 11px;
            color: #909399;
          }
        }

        .order-actions {
          display: flex;
          flex-direction: column;
          gap: 6px;
          justify-content: center;
          min-width: 90px;

          :deep(.el-button) {
            margin-left: 0 !important; // 覆盖element-plus默认边距
            width: 100%;
          }
        }
      }

      .order-footer {
        margin-top: 12px;
        padding-top: 10px;
        border-top: 1px solid #e4e7ed;
        font-size: 11px;
        color: #909399;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
    }
  }

  .pay-info {
    .pay-amount {
      margin-bottom: 20px;
      padding: 20px;
      background: #f5f7fa;
      border-radius: 4px;
      text-align: center;

      .amount {
        font-size: 28px;
        font-weight: bold;
        color: #f56c6c;
        margin-left: 10px;
      }
    }
  }
}

// 订单详情对话框样式
:deep(.el-descriptions) {
  .el-descriptions__label {
    background-color: #f5f7fa;
    font-weight: 500;
    width: 120px;
  }
  
  .el-descriptions__content {
    font-weight: 400;
  }
}

:deep(.el-dialog__body) {
  padding: 20px 30px;
}
</style>
