<template>
  <div class="ticket-query">
    <!-- 查询表单 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="query-form">
        <el-form-item label="出发站">
          <el-input 
            v-model="searchForm.startStation" 
            disabled
            prefix-icon="Location"
            style="width: 150px"
          />
        </el-form-item>
        
        <el-form-item label="到达站">
          <el-input 
            v-model="searchForm.endStation" 
            placeholder="请输入到达站"
            clearable
            prefix-icon="Location"
          />
        </el-form-item>
        
        <el-form-item label="出发日期">
          <el-date-picker
            v-model="searchForm.date"
            type="date"
            placeholder="选择日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            :disabled-date="disabledDate"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleSearch">查询车票</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 车次列表 -->
    <el-card v-if="trainList.length > 0" class="result-card">
      <div class="train-list">
        <div v-for="train in trainList" :key="train.trainId" class="train-item">
          <div class="train-info">
            <div class="train-number">
              <el-tag :type="getTrainTypeTag(train.trainType)" size="large">
                {{ train.trainNumber }}
              </el-tag>
            </div>
            
            <div class="station-info">
              <div class="departure">
                <div class="time">{{ train.departureTime }}</div>
                <div class="station">{{ train.startStation }}</div>
              </div>
              
              <div class="arrow">
                <el-icon size="24"><Right /></el-icon>
                <div class="duration">约{{ calculateDuration(train) }}</div>
              </div>
              
              <div class="arrival">
                <div class="time">{{ train.arrivalTime }}</div>
                <div class="station">{{ train.endStation }}</div>
              </div>
            </div>
          </div>
          
          <div class="ticket-info">
            <div class="seats">
              <el-tag type="success">余票：{{ train.availableSeats || train.totalSeats }}</el-tag>
            </div>
            <div class="price">
              <span class="amount">¥{{ train.basePrice }}</span>
              <span class="unit">起</span>
            </div>
            <div class="actions">
              <el-button type="info" @click="viewTrainDetail(train)">
                查看详情
              </el-button>
              <el-button type="primary" @click="handleBooking(train)">
                立即购票
              </el-button>
              <el-button type="success" @click="handleGroupBooking(train)">
                团体购票
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 空状态 -->
    <el-empty v-else description="暂无车次信息，请查询" />

    <!-- 购票对话框 -->
    <el-dialog
      v-model="bookingDialogVisible"
      title="购票信息"
      width="600px"
    >
      <el-form :model="bookingForm" label-width="100px">
        <el-form-item label="车次">
          <el-input v-model="selectedTrain.trainNumber" disabled />
        </el-form-item>
        
        <el-form-item label="出发站">
          <el-input v-model="selectedTrain.startStation" disabled />
        </el-form-item>
        
        <el-form-item label="到达站">
          <el-input v-model="selectedTrain.endStation" disabled />
        </el-form-item>
        
        <el-form-item label="乘车日期" required>
          <el-date-picker
            v-model="bookingForm.travelDate"
            type="date"
            placeholder="选择日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
            :disabled-date="disabledDate"
          />
        </el-form-item>
        
        <el-divider />
        
        <el-form-item label="乘客姓名" required>
          <el-input v-model="bookingForm.name" placeholder="请输入乘客姓名" />
        </el-form-item>
        
        <el-form-item label="性别" required>
          <el-select v-model="bookingForm.gender" placeholder="请选择" style="width: 100%">
            <el-option label="男" value="男" />
            <el-option label="女" value="女" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="证件类型" required>
          <el-select v-model="bookingForm.idType" placeholder="请选择" style="width: 100%">
            <el-option label="身份证" value="身份证" />
            <el-option label="护照" value="护照" />
            <el-option label="军官证" value="军官证" />
            <el-option label="学生证" value="学生证" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="证件号码" required>
          <el-input v-model="bookingForm.idNumber" placeholder="请输入证件号码" />
        </el-form-item>
        
        <el-form-item label="手机号码" required>
          <el-input v-model="bookingForm.phone" placeholder="请输入手机号码" />
        </el-form-item>
        
        <el-divider />
        
        <el-form-item label="选择座位" required>
          <el-button 
            type="primary" 
            size="large"
            @click="showSeatSelector" 
            :disabled="!bookingForm.travelDate"
            style="width: 100%;"
          >
            <el-icon><View /></el-icon> 
            点击选择座位 {{ selectedSeat ? `(已选${selectedSeat.seatNumber}号)` : '' }}
          </el-button>
          <div v-if="selectedSeat" style="margin-top: 10px;">
            <el-alert type="success" :closable="false" show-icon>
              <template #title>
                已选择座位：
                <el-tag size="large" type="warning">
                  {{ selectedSeat.seatNumber }}号 ({{ selectedSeat.seatType }})
                </el-tag>
              </template>
            </el-alert>
          </div>
        </el-form-item>
        
        <el-form-item label="购票方式">
          <el-radio-group v-model="bookingForm.isPreBooking">
            <el-radio :label="0" :disabled="mustPreBook">立即购票</el-radio>
            <el-radio :label="1" :disabled="cannotPreBook">预订座位</el-radio>
          </el-radio-group>
          <div v-if="mustPreBook" style="margin-top: 8px; color: #f56c6c; font-size: 12px;">
            <el-icon><Warning /></el-icon> 乘车日期距今>3天，必须使用预订方式
          </div>
          <div v-else-if="cannotPreBook" style="margin-top: 8px; color: #e6a23c; font-size: 12px;">
            <el-icon><Warning /></el-icon> 乘车日期距今≤3天，仅支持立即购票
          </div>
        </el-form-item>
        
        <el-form-item label="总价">
          <div class="total-price">
            ¥{{ calculateTotalPrice() }}
          </div>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="bookingDialogVisible = false">取消</el-button>
        <el-button type="success" @click="switchToGroupBooking">
          切换团体购票
        </el-button>
        <el-button type="primary" @click="confirmBooking" :loading="bookingLoading">
          确认购票
        </el-button>
      </template>
    </el-dialog>

    <!-- 车次详情对话框 -->
    <el-dialog
      v-model="trainDetailDialogVisible"
      :title="`车次详情 - ${selectedTrainDetail.trainNumber || ''}`"
      width="700px"
    >
      <div class="train-detail-content">
        <!-- 基本信息 -->
        <el-descriptions title="基本信息" :column="2" border>
          <el-descriptions-item label="车次号">{{ selectedTrainDetail.trainNumber }}</el-descriptions-item>
          <el-descriptions-item label="车次类型">{{ selectedTrainDetail.trainType }}</el-descriptions-item>
          <el-descriptions-item label="起始站">{{ selectedTrainDetail.startStation }}</el-descriptions-item>
          <el-descriptions-item label="终点站">{{ selectedTrainDetail.endStation }}</el-descriptions-item>
          <el-descriptions-item label="出发时间">{{ selectedTrainDetail.departureTime }}</el-descriptions-item>
          <el-descriptions-item label="到达时间">{{ selectedTrainDetail.arrivalTime }}</el-descriptions-item>
          <el-descriptions-item label="基础票价">¥{{ selectedTrainDetail.basePrice }}</el-descriptions-item>
          <el-descriptions-item label="总座位">{{ selectedTrainDetail.totalSeats }}</el-descriptions-item>
        </el-descriptions>

        <!-- 途径站信息 -->
        <div class="route-section" style="margin-top: 20px;">
          <h3>途径站信息</h3>
          <el-timeline v-if="trainRoutes.length > 0">
            <el-timeline-item
              v-for="route in trainRoutes"
              :key="route.routeId"
              :timestamp="route.stationName"
              placement="top"
            >
              <div class="route-item">
                <p>到达时间：{{ route.arrivalTime || '-' }}</p>
                <p>出发时间：{{ route.departureTime || '-' }}</p>
                <p v-if="route.stopDuration">停留时长：{{ route.stopDuration }} 分钟</p>
                <p v-if="route.distanceFromStart">距起点：{{ route.distanceFromStart }} 公里</p>
              </div>
            </el-timeline-item>
          </el-timeline>
          <el-empty v-else description="暂无途径站信息" />
        </div>
      </div>
      
      <template #footer>
        <el-button @click="trainDetailDialogVisible = false">返回</el-button>
        <el-button type="primary" @click="bookFromDetail">
          立即购票
        </el-button>
      </template>
    </el-dialog>

    <!-- 座位选择对话框 -->
    <SeatSelector
      v-if="selectedTrain.trainId && bookingForm.travelDate"
      v-model="seatSelectorVisible"
      :trainId="selectedTrain.trainId"
      :travelDate="bookingForm.travelDate"
      :maxSeats="1"
      @confirm="handleSeatSelected"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { trainApi } from '@/api/train'
import { ticketApi } from '@/api/ticket'
import { ElMessage } from 'element-plus'
import type { Train } from '@/types'
import { Right, Warning, View } from "@element-plus/icons-vue"
import SeatSelector from '@/components/SeatSelector.vue'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const searchForm = reactive({
  startStation: '南宁站',
  endStation: '',
  date: ''
})

const trainList = ref<Train[]>([])
const bookingDialogVisible = ref(false)
const bookingLoading = ref(false)
const selectedTrain = ref<any>({})
const trainDetailDialogVisible = ref(false)
const selectedTrainDetail = ref<any>({})
const trainRoutes = ref<any[]>([])
const seatSelectorVisible = ref(false)

// 异步购票相关
const queueDialogVisible = ref(false)
const currentQueueId = ref('')
const queueStatus = ref<any>(null)
const pollingTimer = ref<any>(null)
const queuePolling = ref(false)
const selectedSeat = ref<any>(null)
const pendingAutoBookTrainId = ref<string>('')

const bookingForm = reactive({
  travelDate: '',
  name: '',
  gender: '男',
  idType: '身份证',
  idNumber: '',
  phone: '',
  isPreBooking: 0
})

// 禁用过去的日期
const disabledDate = (time: Date) => {
  // 禁用今天之前的日期
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  return time.getTime() < today.getTime()
}

// 计算是否必须预订（距离>3天）
const mustPreBook = computed(() => {
  if (!bookingForm.travelDate) return false
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  // 显式解析日期字符串，避免时区问题
  const [year, month, day] = bookingForm.travelDate.split('-')
  const travelDate = new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0)
  const diffInDays = Math.ceil((travelDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
  return diffInDays > 3
})

// 计算是否不能预订（距离<=3天）
const cannotPreBook = computed(() => {
  if (!bookingForm.travelDate) return false
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  // 显式解析日期字符串，避免时区问题
  const [year, month, day] = bookingForm.travelDate.split('-')
  const travelDate = new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0)
  const diffInDays = Math.ceil((travelDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
  return diffInDays <= 3
})

// 监听日期变化，自动设置预订方式
watch(() => bookingForm.travelDate, (newDate) => {
  if (newDate) {
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    // 显式解析日期字符串，避免时区问题
    const [year, month, day] = newDate.split('-')
    const travelDate = new Date(Number(year), Number(month) - 1, Number(day), 0, 0, 0, 0)
    const diffInDays = Math.ceil((travelDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
    if (diffInDays > 3) {
      bookingForm.isPreBooking = 1
    } else {
      // 如果<=3天，允许用户选择（重置为0）
      bookingForm.isPreBooking = 0
    }
  }
})

// 查询车票
const handleSearch = async () => {
  if (!searchForm.startStation || !searchForm.endStation) {
    ElMessage.warning('请输入出发站和到达站')
    return
  }
  
  try {
    const res = await trainApi.searchTrains({
      startStation: searchForm.startStation,
      endStation: searchForm.endStation,
      pageNum: 1,
      pageSize: 50
    })
    
    if (res.code === 200) {
      trainList.value = res.data.records || []
      if (trainList.value.length === 0) {
        ElMessage.info('未找到符合条件的车次')
      } else if (pendingAutoBookTrainId.value) {
        const matchedTrain = trainList.value.find(train => String(train.trainId) === pendingAutoBookTrainId.value)
        if (matchedTrain) {
          handleBooking(matchedTrain)
        } else {
          ElMessage.warning('未找到对应热点车次，请手动选择购票方式')
        }
        pendingAutoBookTrainId.value = ''
      }
    }
  } catch (error) {
    ElMessage.error('查询失败')
  }
}

// 重置
const handleReset = () => {
  searchForm.startStation = '南宁站'  // 保持默认始发站
  searchForm.endStation = ''
  searchForm.date = ''
  trainList.value = []
}

// 获取车次类型标签
const getTrainTypeTag = (type: string) => {
  const typeMap: any = {
    '高铁': 'danger',
    '动车': 'warning',
    '快速': 'info',
    '直达': 'success'
  }
  return typeMap[type] || 'info'
}

// 计算行程时长
const calculateDuration = (train: Train) => {
  try {
    const departure = new Date(`2000-01-01 ${train.departureTime}`)
    const arrival = new Date(`2000-01-01 ${train.arrivalTime}`)
    const diff = arrival.getTime() - departure.getTime()
    const hours = Math.floor(diff / (1000 * 60 * 60))
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
    return `${hours}小时${minutes}分`
  } catch {
    return '未知'
  }
}

// 查看车次详情
const viewTrainDetail = async (train: Train) => {
  selectedTrainDetail.value = train
  trainDetailDialogVisible.value = true
  
  // 加载途径站信息
  try {
    const res = await trainApi.getTrainRoutes(train.trainId)
    if (res.code === 200) {
      trainRoutes.value = res.data || []
    } else {
      trainRoutes.value = []
    }
  } catch (error) {
    ElMessage.error('加载途径站信息失败')
    trainRoutes.value = []
  }
}

// 从详情页面购票
const bookFromDetail = () => {
  trainDetailDialogVisible.value = false
  selectedTrain.value = selectedTrainDetail.value
  bookingForm.travelDate = searchForm.date || new Date().toISOString().split('T')[0]
  bookingDialogVisible.value = true
}

// 购票
const handleBooking = (train: Train) => {
  const travelDate = searchForm.date || new Date().toISOString().split('T')[0]
  
  // 校验是否已发车
  const [hours, minutes, seconds] = train.departureTime.split(':').map(Number)
  const departureDate = new Date(travelDate)
  departureDate.setHours(hours, minutes, seconds || 0, 0)
  
  if (Date.now() > departureDate.getTime()) {
    ElMessage.warning('该车次已发车，无法购买')
    return
  }

  selectedTrain.value = train
  selectedSeat.value = null
  bookingForm.travelDate = travelDate
  bookingDialogVisible.value = true
}

// 切换团体购票
const switchToGroupBooking = () => {
  if (!selectedTrain.value || !selectedTrain.value.trainId) {
    ElMessage.warning('请先选择车次')
    return
  }
  
  const travelDate = bookingForm.travelDate || searchForm.date || new Date().toISOString().split('T')[0]
  
  // 校验是否已发车
  const [hours, minutes, seconds] = selectedTrain.value.departureTime.split(':').map(Number)
  const departureDate = new Date(travelDate)
  departureDate.setHours(hours, minutes, seconds || 0, 0)
  
  if (Date.now() > departureDate.getTime()) {
    ElMessage.warning('该车次已发车，无法购买')
    return
  }

  bookingDialogVisible.value = false
  router.push({
    path: '/passenger/group-booking',
    query: {
      train: JSON.stringify(selectedTrain.value),
      travelDate: travelDate
    }
  })
}

// 显示座位选择器
const showSeatSelector = () => {
  if (!bookingForm.travelDate) {
    ElMessage.warning('请先选择乘车日期')
    return
  }
  
  // 校验是否已发车
  const [hours, minutes, seconds] = selectedTrain.value.departureTime.split(':').map(Number)
  const departureDate = new Date(bookingForm.travelDate)
  departureDate.setHours(hours, minutes, seconds || 0, 0)
  
  if (Date.now() > departureDate.getTime()) {
    ElMessage.warning('该车次已发车，无法购买')
    bookingDialogVisible.value = false
    return
  }
  
  seatSelectorVisible.value = true
}

// 处理座位选择
const handleSeatSelected = (seats: any[]) => {
  if (seats && seats.length > 0) {
    selectedSeat.value = seats[0]
    ElMessage.success(`已选择${seats[0].seatNumber}号座位`)
  }
}

// 团体购票
const handleGroupBooking = (train: Train) => {
  const travelDate = searchForm.date || new Date().toISOString().split('T')[0]
  
  // 校验是否已发车
  const [hours, minutes, seconds] = train.departureTime.split(':').map(Number)
  const departureDate = new Date(travelDate)
  departureDate.setHours(hours, minutes, seconds || 0, 0)
  
  if (Date.now() > departureDate.getTime()) {
    ElMessage.warning('该车次已发车，无法购买')
    return
  }

  router.push({
    path: '/passenger/group-booking',
    query: {
      train: JSON.stringify(train),
      travelDate: travelDate // 传递乘车日期
    }
  })
}

// 计算总价
const calculateTotalPrice = () => {
  if (!selectedSeat.value) {
    return '请先选择座位'
  }
  const basePrice = selectedTrain.value.basePrice || 0
  const coefficient = selectedSeat.value.priceCoefficient || 1
  return (basePrice * coefficient).toFixed(2)
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
          // 抢票完成
          queueStatus.value = result
          queuePolling.value = false
          
          if (result.status === 'SUCCESS' && result.ticket && result.ticket.orderId) {
            ElMessage.success('购票成功，请在15分钟内完成支付');
            router.push({
              path: '/passenger/pay',
              query: { orderId: result.ticket.orderId }
            });
          } else if (result.status === 'FAILED') {
            ElMessage.error(result.errorMessage || '抢票失败');
          }
          
          // 关闭排队对话框
          queueDialogVisible.value = false
          
          // 清理表单
          bookingForm.name = ''
          bookingForm.idNumber = ''
          bookingForm.phone = ''
          bookingForm.isPreBooking = 0
          selectedSeat.value = null
          
          // 刷新车次列表
          handleSearch()
        } else {
          // 更新排队状态
          queueStatus.value = result
        }
      }
    } catch (error) {
      console.error('轮询失败:', error)
    }
    
    if (queuePolling.value) {
      // 每2秒轮询一次
      pollingTimer.value = setTimeout(poll, 2000)
    }
  }

  poll()
}

// 停止轮询
const stopPolling = () => {
  queuePolling.value = false
  if (pollingTimer.value) {
    clearTimeout(pollingTimer.value)
    pollingTimer.value = null
  }
}

// 查看排队详情
// const viewQueueDetail = () => {
//   ElMessageBox.alert(`排队号：${currentQueueId}\n状态：${queueStatus.value?.status || '处理中'}`, '排队详情', {
//     confirmButtonText: '确定'
//   })
// }

// 取消排队
// const cancelQueue = async () => {
//   try {
//     await ElMessageBox.confirm('确定要取消排队吗？', '取消排队', {
//       confirmButtonText: '确定',
//       cancelButtonText: '继续排队',
//       type: 'warning'
//     })
//
//     const res = await ticketApi.cancelAsyncTask(currentQueueId.value)
//
//     if (res.code === 200) {
//       ElMessage.success('已取消排队')
//       stopPolling()
//       queueDialogVisible.value = false
//     } else {
//       ElMessage.error('取消失败')
//     }
//   } catch (error) {
//     ElMessage.error('操作失败')
//   }
// }

// 确认购票
const confirmBooking = async () => {
  // 验证必填字段
  if (!bookingForm.travelDate) {
    ElMessage.warning('请选择乘车日期')
    return
  }
  if (!bookingForm.name) {
    ElMessage.warning('请输入乘客姓名')
    return
  }
  if (!bookingForm.idNumber) {
    ElMessage.warning('请输入证件号码')
    return
  }
  if (!bookingForm.phone) {
    ElMessage.warning('请输入手机号码')
    return
  }
  if (!selectedSeat.value) {
    ElMessage.warning('请先选择座位')
    return
  }
  
  // 计算乘车日期距离今天的天数
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const travelDate = new Date(bookingForm.travelDate)
  const diffInDays = Math.ceil((travelDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))
  
  // 根据天数自动判断购票类型
  let isPreBooking = bookingForm.isPreBooking
  if (diffInDays > 3) {
    // 大于3天必须预订
    isPreBooking = 1
    bookingForm.isPreBooking = 1  // 同步更新表单值
    ElMessage.info(`乘车日期距今${diffInDays}天，超过3天，将自动为您创建预订票`)
  } else {
    // 3天内（含3天）可以直接购买或预订
    if (bookingForm.isPreBooking === 1) {
      ElMessage.info('乘车日期在3天内，将为您创建预订票')
    }
  }
  
  bookingLoading.value = true
  try {
    // 构建后端需要的参数
    const bookingData: any = {
      trainId: selectedTrain.value.trainId,
      name: bookingForm.name,
      gender: bookingForm.gender,
      idType: bookingForm.idType,
      idNumber: bookingForm.idNumber,
      phone: bookingForm.phone,
      travelDate: bookingForm.travelDate,
      sellerId: userStore.userInfo?.userid,
      isPreBooking: isPreBooking // 使用计算后的购票方式
    }

    // 传递座位编号（用于虚拟座位选择）
    if (selectedSeat.value) {
      bookingData.seatId = selectedSeat.value.seatId
      bookingData.seatNumber = selectedSeat.value.seatNumber
    }
    
    // 使用异步购票接口
    const res = await ticketApi.asyncSellTicket(bookingData)
    
    if (res.code === 200) {
      const queueId = res.data.queueId
      currentQueueId.value = queueId
      
      // 显示排队对话框
      queueDialogVisible.value = true
      bookingDialogVisible.value = false
      
      // 开始轮询结果
      startPolling(queueId)
      
      ElMessage.success('已提交抢票请求，正在处理中...')
    } else {
      ElMessage.error(res.message || '提交失败')
    }
  } catch (error: any) {
    ElMessage.error(error.message || '购票失败')
  } finally {
    bookingLoading.value = false
  }
}

// 页面加载时，接收首页传递的查询参数并自动查询
onMounted(() => {
  const { startStation, endStation, date, trainId, autoBook } = route.query
  
  if (startStation && endStation) {
    searchForm.startStation = startStation as string
    searchForm.endStation = endStation as string
    searchForm.date = date as string || ''
    pendingAutoBookTrainId.value = autoBook === '1' && trainId ? String(trainId) : ''
    
    // 自动执行查询
    handleSearch()
  }
})

// 页面卸载时清理定时器
onUnmounted(() => {
  stopPolling()
})
</script>

<style scoped lang="scss">
.ticket-query {
  padding: 20px;
  background: #f0f2f5;
  min-height: calc(100vh - 60px);
}

.search-card {
  margin-bottom: 20px;
  
  .query-form {
    :deep(.el-form-item) {
      margin-bottom: 0;
    }
  }
}

.result-card {
  .train-list {
    .train-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px;
      margin-bottom: 16px;
      background: #fff;
      border: 1px solid #e4e7ed;
      border-radius: 8px;
      transition: all 0.3s;
      
      &:hover {
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
        border-color: #409eff;
      }
      
      .train-info {
        display: flex;
        align-items: center;
        flex: 1;
        gap: 40px;
        
        .train-number {
          min-width: 100px;
        }
        
        .station-info {
          display: flex;
          align-items: center;
          gap: 30px;
          flex: 1;
          
          .departure,
          .arrival {
            .time {
              font-size: 24px;
              font-weight: bold;
              color: #303133;
              margin-bottom: 8px;
            }
            
            .station {
              font-size: 14px;
              color: #909399;
            }
          }
          
          .arrow {
            text-align: center;
            color: #909399;
            
            .duration {
              font-size: 12px;
              margin-top: 4px;
            }
          }
        }
      }
      
      .ticket-info {
        display: flex;
        align-items: center;
        gap: 20px;
        
        .seats {
          text-align: center;
        }
        
        .price {
          text-align: right;
          
          .amount {
            font-size: 24px;
            font-weight: bold;
            color: #f56c6c;
          }
          
          .unit {
            font-size: 12px;
            color: #909399;
            margin-left: 4px;
          }
        }
        
        .actions {
          display: flex;
          flex-direction: column;
          gap: 8px;
        }
      }
    }
  }
}

.total-price {
  font-size: 20px;
  font-weight: bold;
  color: #f56c6c;
}

// 排队状态样式
.queue-status {
  text-align: center;
  padding: 20px;

  .queue-info {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 20px;
    margin-bottom: 30px;

    .queue-icon {
      color: #409eff;
      animation: rotate 2s linear infinite;
    }

    .queue-details {
      text-align: center;

      h3 {
        color: #303133;
        margin-bottom: 16px;
        font-size: 24px;
      }

      p {
        margin: 8px 0;
        color: #606266;
        font-size: 14px;
        line-height: 1.6;
      }
    }
  }

  .queue-actions {
    display: flex;
    gap: 12px;
    justify-content: center;
  }
}

@keyframes rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
