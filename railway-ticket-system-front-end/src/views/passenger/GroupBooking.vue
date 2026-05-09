<template>
  <div class="group-booking">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>👥 团体购票</span>
          <el-button @click="router.back()">返回</el-button>
        </div>
      </template>

      <!-- 车次信息 -->
      <el-alert
        v-if="train"
        type="info"
        :closable="false"
        class="train-info"
      >
        <template #title>
          <div>车次：{{ train.trainNumber }} | {{ train.startStation }} → {{ train.endStation }}</div>
          <div>出发时间：{{ train.departureTime }} | 票价：¥{{ train.basePrice }}</div>
        </template>
      </el-alert>

      <!-- 购票设置 -->
      <el-form :model="form" label-width="120px" class="booking-form">
        <el-form-item label="乘车日期" required>
          <el-date-picker
            v-model="form.travelDate"
            type="date"
            placeholder="选择日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
            :disabled-date="disabledDate"
          />
        </el-form-item>

        <el-form-item label="选择座位" required>
          <el-button
            type="primary"
            size="large"
            @click="showSeatSelector"
            :disabled="!form.travelDate || passengers.length === 0"
            style="width: 100%;"
          >
            <el-icon><View /></el-icon>
            点击选择座位 {{ selectedSeats.length > 0 ? `(已选${selectedSeats.length}个)` : '' }}
          </el-button>
          <div v-if="selectedSeats.length > 0" style="margin-top: 10px;">
            <el-alert type="success" :closable="false" show-icon>
              <template #title>
                已选择 {{ selectedSeats.length }} 个座位：
                <el-tag v-for="seat in selectedSeats" :key="seat.seatId" size="small" style="margin-left: 5px;">
                  {{ seat.seatNumber }}号
                </el-tag>
              </template>
            </el-alert>
          </div>
        </el-form-item>

        <el-form-item label="购票方式">
          <el-radio-group v-model="form.isPreBooking">
            <el-radio :value="false" :disabled="mustPreBook">立即购票</el-radio>
            <el-radio :value="true" :disabled="cannotPreBook">预订座位</el-radio>
          </el-radio-group>
          <div v-if="mustPreBook" style="margin-top: 8px; color: #f56c6c; font-size: 12px;">
            <el-icon><Warning /></el-icon> 乘车日期距今>3天，必须使用预订方式
          </div>
          <div v-else-if="cannotPreBook" style="margin-top: 8px; color: #e6a23c; font-size: 12px;">
            <el-icon><Warning /></el-icon> 乘车日期距今≤3天，仅支持立即购票
          </div>
        </el-form-item>
      </el-form>

      <el-divider />

      <!-- 乘客列表 -->
      <div class="passengers-section">
        <div class="section-header">
          <span>乘客信息（{{ passengers.length }}人）</span>
          <el-button type="primary" size="small" @click="addPassenger">
            <el-icon><Plus /></el-icon> 添加乘客
          </el-button>
        </div>

        <div v-if="passengers.length === 0" class="empty-tip">
          <el-empty description="暂无乘客，请添加" />
        </div>

        <div v-for="(passenger, index) in passengers" :key="index" class="passenger-item">
          <div class="passenger-number">乘客 {{ index + 1 }}</div>

          <el-row :gutter="16">
            <el-col :xs="24" :sm="12" :md="5">
              <el-input v-model="passenger.name" placeholder="姓名" />
            </el-col>
            <el-col :xs="24" :sm="12" :md="4">
              <el-select v-model="passenger.gender" placeholder="性别">
                <el-option label="男" value="男" />
                <el-option label="女" value="女" />
              </el-select>
            </el-col>
            <el-col :xs="24" :sm="12" :md="4">
              <el-select v-model="passenger.idType" placeholder="证件类型">
                <el-option label="身份证" value="身份证" />
                <el-option label="护照" value="护照" />
                <el-option label="军官证" value="军官证" />
                <el-option label="学生证" value="学生证" />
              </el-select>
            </el-col>
            <el-col :xs="24" :sm="12" :md="5">
              <el-input v-model="passenger.idNumber" placeholder="证件号码" />
            </el-col>
            <el-col :xs="24" :sm="12" :md="4">
              <el-input v-model="passenger.phone" placeholder="手机号" />
            </el-col>
            <el-col :xs="24" :sm="12" :md="2">
              <el-button type="danger" plain @click="removePassenger(index)" style="width: 100%;">
                <el-icon><Delete /></el-icon>
              </el-button>
            </el-col>
          </el-row>
        </div>
      </div>

      <el-divider />

      <!-- 总价 -->
      <div class="total-section">
        <div class="total-label">总金额：</div>
        <div class="total-amount">¥{{ totalAmount }}</div>
      </div>

      <!-- 提交按钮 -->
      <div class="submit-section">
        <el-button size="large" @click="router.back()">取消</el-button>
        <el-button
          type="primary"
          size="large"
          @click="handleSubmit"
          :loading="loading"
        >
          确认购票
        </el-button>
      </div>
    </el-card>

    <!-- 座位选择对话框 -->
    <SeatSelector
      v-if="train?.trainId && form.travelDate"
      v-model="seatSelectorVisible"
      :trainId="train.trainId"
      :travelDate="form.travelDate"
      :maxSeats="passengers.length || 1"
      @confirm="handleSeatSelected"
    />

    <!-- 排队处理对话框 -->
    <el-dialog
      v-model="queueDialogVisible"
      title="团体购票处理中"
      width="400px"
      :close-on-click-modal="false"
      :show-close="!queuePolling"
      :before-close="() => { stopPolling(); queueDialogVisible = false; }"
    >
      <div class="queue-status" style="text-align: center; padding: 20px;">
        <el-icon v-if="queuePolling" class="is-loading" style="font-size: 40px; color: #409EFF;">
          <Loading />
        </el-icon>
        <el-icon v-else-if="queueStatus?.status === 'SUCCESS'" style="font-size: 40px; color: #67C23A;">
          <CircleCheck />
        </el-icon>
        <el-icon v-else-if="queueStatus?.status === 'FAILED'" style="font-size: 40px; color: #F56C6C;">
          <CircleClose />
        </el-icon>

        <p style="margin-top: 16px; font-size: 16px;">
          {{ queueStatus?.message || (queuePolling ? '正在为您处理团体购票请求，请稍候...' : '') }}
        </p>
        <p v-if="queuePolling" style="margin-top: 8px; color: #909399; font-size: 14px;">
          排队号：{{ currentQueueId }}
        </p>
      </div>

      <template #footer>
        <el-button v-if="queuePolling" type="danger" @click="stopPolling(); queueDialogVisible = false;">
          取消等待
        </el-button>
        <el-button v-else @click="queueDialogVisible = false;">
          关闭
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import {Delete, Plus, View, Warning, Loading, CircleCheck, CircleClose} from '@element-plus/icons-vue'
import { ticketApi } from '@/api/ticket'
import { useUserStore } from '@/stores/user'
import SeatSelector from '@/components/SeatSelector.vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const loading = ref(false)
const train = ref<any>(null)
const seatSelectorVisible = ref(false)
const selectedSeats = ref<any[]>([])

// 排队/轮询相关
const queueDialogVisible = ref(false)
const queueStatus = ref<any>(null)
const currentQueueId = ref('')
const queuePolling = ref(false)
let pollingTimer: number | null = null

const form = reactive({
  travelDate: '',
  isPreBooking: false
})

interface Passenger {
  name: string
  gender: string
  idType: string
  idNumber: string
  phone: string
}

const passengers = ref<Passenger[]>([])

// 禁用过去的日期
const disabledDate = (time: Date) => {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  return time.getTime() < today.getTime()
}

// 计算是否必须预订（距离>3天）
const mustPreBook = computed(() => {
  if (!form.travelDate) return false
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  // 显式解析日期字符串，避免时区问题
  const [year, month, day] = form.travelDate.split('-')
  const travelDate = new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0)
  const diffInDays = Math.ceil((travelDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
  return diffInDays > 3
})

// 计算是否不能预订（距离<=3天）
const cannotPreBook = computed(() => {
  if (!form.travelDate) return false
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  // 显式解析日期字符串，避免时区问题
  const [year, month, day] = form.travelDate.split('-')
  const travelDate = new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0)
  const diffInDays = Math.ceil((travelDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
  return diffInDays <= 3
})

// 监听日期变化，自动设置预订方式
watch(() => form.travelDate, (newDate) => {
  if (newDate) {
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    // 显式解析日期字符串，避免时区问题
    const [year, month, day] = newDate.split('-')
    const travelDate = new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0)
    const diffInDays = Math.ceil((travelDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
    form.isPreBooking = diffInDays > 3;
  }
})

// 计算总金额
const totalAmount = computed(() => {
  if (!train.value) return 0
  return (train.value.basePrice * passengers.value.length).toFixed(2)
})

// 添加乘客
const addPassenger = () => {
  passengers.value.push({
    name: '',
    gender: '男',
    idType: '身份证',
    idNumber: '',
    phone: ''
  })
}

// 删除乘客
const removePassenger = (index: number) => {
  passengers.value.splice(index, 1)
}

// 验证乘客信息
const validatePassengers = () => {
  if (passengers.value.length === 0) {
    ElMessage.warning('请至少添加一名乘客')
    return false
  }

  for (let i = 0; i < passengers.value.length; i++) {
    const p = passengers.value[i]
    if (!p.name) {
      ElMessage.warning(`乘客${i + 1}：请输入姓名`)
      return false
    }
    if (!p.idType) {
      ElMessage.warning(`乘客${i + 1}：请选择证件类型`)
      return false
    }
    if (!p.idNumber) {
      ElMessage.warning(`乘客${i + 1}：请输入证件号码`)
      return false
    }
    if (!p.phone) {
      ElMessage.warning(`乘客${i + 1}：请输入手机号`)
      return false
    }
  }

  return true
}

// 显示座位选择器
const showSeatSelector = () => {
  if (!form.travelDate) {
    ElMessage.warning('请先选择乘车日期')
    return
  }

  if (!train.value || !train.value.trainId) {
    ElMessage.warning('车次信息缺失，请返回重新选择')
    return
  }

  // 校验是否已发车
  const [hours, minutes, seconds] = train.value.departureTime.split(':').map(Number)
  const departureDate = new Date(form.travelDate)
  departureDate.setHours(hours, minutes, seconds || 0, 0)
  
  if (Date.now() > departureDate.getTime()) {
    ElMessage.warning('该车次已发车，无法购买')
    return
  }

  if (passengers.value.length === 0) {
    ElMessage.warning('请先添加乘客信息')
    return
  }

  // 清空之前的选择
  selectedSeats.value = []
  seatSelectorVisible.value = true
}

// 处理座位选择
const handleSeatSelected = (seats: any[]) => {
  selectedSeats.value = seats
  ElMessage.success(`已选择${seats.length}个座位`)
}

// 提交购票
const handleSubmit = async () => {
  if (!form.travelDate) {
    ElMessage.warning('请选择乘车日期')
    return
  }

  // 校验是否已发车
  const [hours, minutes, seconds] = train.value.departureTime.split(':').map(Number)
  const departureDate = new Date(form.travelDate)
  departureDate.setHours(hours, minutes, seconds || 0, 0)
  
  if (Date.now() > departureDate.getTime()) {
    ElMessage.warning('该车次已发车，无法购买')
    return
  }

  if (!validatePassengers()) {
    return
  }

  // 强制要求必须选座
  if (selectedSeats.value.length === 0) {
    ElMessage.warning('请先选择座位')
    return
  }

  // 检查座位选择数量
  if (selectedSeats.value.length !== passengers.value.length) {
    ElMessage.warning(`已选择${selectedSeats.value.length}个座位，但有${passengers.value.length}名乘客，数量不匹配`)
    return
  }

  loading.value = true
  try {
    const data: any = {
      trainId: train.value.trainId,
      sellerId: userStore.userInfo?.userid,
      travelDate: form.travelDate,
      isPreBooking: form.isPreBooking ? 1 : 0,
      name: passengers.value.map(p => p.name),
      gender: passengers.value.map(p => p.gender),
      idType: passengers.value.map(p => p.idType),
      idNumber: passengers.value.map(p => p.idNumber),
      phone: passengers.value.map(p => p.phone),
      seatNumbers: selectedSeats.value.map(s => s.seatNumber)
    }

    const res = await ticketApi.asyncGroupSellTicket(data)

    if (res.code === 200) {
      const queueId = res.data?.queueId
      if (queueId) {
        currentQueueId.value = queueId
        queueDialogVisible.value = true
        queueStatus.value = { status: 'PENDING', message: '正在处理团体购票请求...' }
        startPolling(queueId)
        ElMessage.success('团体购票请求已提交，正在处理中...')
      } else {
        // 同步成功，直接跳转支付
        const orderId = res.data?.orderId || res.data?.orders?.[0]?.orderId
        if (orderId) {
          router.push({ path: '/passenger/pay', query: { orderId } })
        } else {
          router.push('/passenger/order')
        }
      }
    } else {
      ElMessage.error(res.message || '购票失败')
    }
  } catch (error: any) {
    ElMessage.error(error.message || '购票失败')
  } finally {
    loading.value = false
  }
}

// 开始轮询抢票结果
const startPolling = (queueId: string) => {
  queuePolling.value = true

  const poll = async () => {
    try {
      const res = await ticketApi.getAsyncBookingResult(queueId)

      if (res.code === 200) {
        const result = res.data

        if (result.status === 'SUCCESS' || result.status === 'FAILED') {
          queueStatus.value = result
          queuePolling.value = false

          if (result.status === 'SUCCESS') {
            const orderId = result.orderId || result.tickets?.[0]?.orderId || result.ticket?.orderId
            if (orderId) {
              ElMessage.success('团体购票成功，请在15分钟内完成支付')
              queueDialogVisible.value = false
              router.push({
                path: '/passenger/pay',
                query: { orderId }
              })
            } else {
              ElMessage.success('团体购票成功')
              queueDialogVisible.value = false
              router.push('/passenger/order')
            }
          } else if (result.status === 'FAILED') {
            ElMessage.error(result.errorMessage || '团体购票失败')
            queueDialogVisible.value = false
          }

          // 清理表单
          selectedSeats.value = []
          passengers.value = passengers.value.map(() => ({
            name: '', gender: '男', idType: '身份证', idNumber: '', phone: ''
          }))
        } else {
          queueStatus.value = result
        }
      }
    } catch (error) {
      console.error('轮询失败:', error)
    }

    if (queuePolling.value) {
      pollingTimer = window.setTimeout(poll, 2000)
    }
  }

  poll()
}

// 停止轮询
const stopPolling = () => {
  queuePolling.value = false
  if (pollingTimer) {
    clearTimeout(pollingTimer)
    pollingTimer = null
  }
}

onMounted(() => {
  // 从路由参数获取车次信息
  const trainData = route.query.train
  if (trainData) {
    try {
      train.value = JSON.parse(trainData as string)
    } catch (e) {
      ElMessage.error('车次信息无效')
      router.back()
    }
  } else {
    ElMessage.error('缺少车次信息')
    router.back()
  }

  // 从路由参数获取乘车日期
  const travelDate = route.query.travelDate
  if (travelDate) {
    form.travelDate = travelDate as string
  }

  // 默认添加一名乘客
  addPassenger()
})

// 页面卸载时清理定时器，避免内存泄漏
onUnmounted(() => {
  stopPolling()
})
</script>

<style scoped lang="scss">
.group-booking {
  padding: 20px;
  background: #f0f2f5;
  min-height: calc(100vh - 60px);

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .train-info {
    margin-bottom: 20px;
  }

  .booking-form {
    margin: 20px 0;
  }

  .passengers-section {
    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 16px;
      font-weight: bold;
      font-size: 16px;
    }

    .empty-tip {
      padding: 20px 0;
    }

    .passenger-item {
      position: relative;
      background: #f5f7fa;
      padding: 20px 16px 16px 16px;
      border-radius: 8px;
      margin-bottom: 12px;

      .passenger-number {
        position: absolute;
        top: -10px;
        left: 16px;
        background: #409eff;
        color: #fff;
        padding: 2px 12px;
        border-radius: 10px;
        font-size: 12px;
        z-index: 1;
      }

      .el-input,
      .el-select {
        width: 100%;
      }

      .el-col {
        margin-bottom: 8px;
      }
    }
  }

  .total-section {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 10px;
    margin: 20px 0;

    .total-label {
      font-size: 18px;
      color: #606266;
    }

    .total-amount {
      font-size: 28px;
      font-weight: bold;
      color: #f56c6c;
    }
  }

  .submit-section {
    display: flex;
    justify-content: center;
    gap: 16px;
    margin-top: 24px;
  }

  // 响应式适配
  @media screen and (max-width: 768px) {
    padding: 10px;

    .passengers-section {
      .passenger-item {
        padding: 24px 12px 12px 12px;

        .el-col {
          margin-bottom: 12px;
        }
      }
    }

    .total-section {
      flex-direction: column;
      align-items: flex-end;
      gap: 5px;
    }

    .submit-section {
      flex-direction: column;

      .el-button {
        width: 100%;
      }
    }
  }
}
</style>
