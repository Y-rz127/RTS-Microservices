<template>
  <el-dialog
    v-model="visible"
    title="座位选择"
    width="900px"
    :before-close="handleClose"
  >
    <div class="seat-selector">
      <!-- 座位类型标签 -->
      <div class="seat-type-tabs">
        <el-radio-group v-model="currentType" @change="handleTypeChange">
          <el-radio-button label="商务座">商务座 (1-30)</el-radio-button>
          <el-radio-button label="一等座">一等座 (31-80)</el-radio-button>
          <el-radio-button label="二等座">二等座 (81-150)</el-radio-button>
        </el-radio-group>
      </div>

      <!-- 座位状态说明 -->
      <div class="seat-legend">
        <div class="legend-item">
          <div class="legend-box available"></div>
          <span>可选</span>
        </div>
        <div class="legend-item">
          <div class="legend-box selected"></div>
          <span>已选</span>
        </div>
        <div class="legend-item">
          <div class="legend-box occupied"></div>
          <span>已占用</span>
        </div>
        <div class="legend-item">
          <div class="legend-box maintenance"></div>
          <span>维修中</span>
        </div>
      </div>

      <!-- 座位布局（5列） -->
      <div class="seat-layout" v-loading="loading">
        <div 
          v-for="seat in filteredSeats" 
          :key="seat.seatId"
          class="seat-item"
          :class="getSeatClass(seat)"
          @click="handleSeatClick(seat)"
        >
          <div class="seat-number">{{ seat.seatNumber }}</div>
        </div>
      </div>

      <!-- 已选座位信息 -->
      <div class="selected-info" v-if="selectedSeats.length > 0">
        <div class="info-title">已选座位 ({{ selectedSeats.length }}/{{ maxSeats }})</div>
        <div class="selected-list">
          <el-tag
            v-for="seat in selectedSeats"
            :key="seat.seatId"
            closable
            @close="removeSeat(seat)"
            size="large"
            type="warning"
          >
            {{ seat.seatNumber }}号 ({{ seat.seatType }})
          </el-tag>
        </div>
      </div>
    </div>

    <template #footer>
      <el-button @click="handleClose">取消</el-button>
      <el-button 
        type="primary" 
        @click="confirmSelection"
        :disabled="selectedSeats.length === 0"
      >
        确认选座 ({{ selectedSeats.length }})
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import seatApi from '@/api/seat'

interface Seat {
  seatId: number
  trainId: number
  travelDate: Date
  seatNumber: string
  seatType: string
  seatLevel: number
  priceCoefficient: number
  carriageNumber: string
  status: string
  createdAt: Date
  updatedAt: Date
}

interface Props {
  modelValue: boolean
  trainId: number
  travelDate: string
  maxSeats?: number // 最多可选座位数
}

const props = withDefaults(defineProps<Props>(), {
  maxSeats: 1
})

const emit = defineEmits(['update:modelValue', 'confirm'])

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const loading = ref(false)
const allSeats = ref<Seat[]>([])
const selectedSeats = ref<Seat[]>([])
const currentType = ref('商务座')
const maxSeats = computed(() => props.maxSeats || 1)

// 根据当前座位类型过滤座位
const filteredSeats = computed(() => {
  return allSeats.value.filter(seat => seat.seatType === currentType.value)
})

// 获取座位样式类
const getSeatClass = (seat: Seat) => {
  const isSelected = selectedSeats.value.some(s => s.seatId === seat.seatId)
  
  if (isSelected) return 'selected'
  if (seat.status === 'occupied' || seat.status === 'OCCUPIED') return 'occupied'
  if (seat.status === 'maintenance' || seat.status === 'MAINTENANCE') return 'maintenance'
  if (seat.status === 'available' || seat.status === 'AVAILABLE') return 'available'
  return ''
}

// 生成虚拟座位（当数据库没有记录时）
const generateVirtualSeats = () => {
  const seats: Seat[] = []
  
  // 商务座：1-30
  for (let i = 1; i <= 30; i++) {
    seats.push({
      seatId: i,
      trainId: props.trainId,
      travelDate: new Date(props.travelDate),
      seatNumber: String(i).padStart(3, '0'),
      seatType: '商务座',
      seatLevel: 1,
      priceCoefficient: 2.0,
      carriageNumber: '1',
      status: 'available',
      createdAt: new Date(),
      updatedAt: new Date()
    })
  }
  
  // 一等座：31-80
  for (let i = 31; i <= 80; i++) {
    seats.push({
      seatId: i,
      trainId: props.trainId,
      travelDate: new Date(props.travelDate),
      seatNumber: String(i).padStart(3, '0'),
      seatType: '一等座',
      seatLevel: 2,
      priceCoefficient: 1.5,
      carriageNumber: '2',
      status: 'available',
      createdAt: new Date(),
      updatedAt: new Date()
    })
  }
  
  // 二等座：81-150
  for (let i = 81; i <= 150; i++) {
    seats.push({
      seatId: i,
      trainId: props.trainId,
      travelDate: new Date(props.travelDate),
      seatNumber: String(i).padStart(3, '0'),
      seatType: '二等座',
      seatLevel: 3,
      priceCoefficient: 1.0,
      carriageNumber: '3',
      status: 'available',
      createdAt: new Date(),
      updatedAt: new Date()
    })
  }
  
  return seats
}

// 加载座位布局
const loadSeats = async () => {
  try {
    loading.value = true
    console.log('正在加载座位布局:', {
      trainId: props.trainId,
      travelDate: props.travelDate
    })
    
    const res = await seatApi.getSeatLayout({
      trainId: props.trainId,
      travelDate: props.travelDate
    })
    
    if (res.code === 200) {
      const seats = res.data || []
      
      // 如果数据库没有记录，生成虚拟座位（全部可选）
      if (seats.length === 0) {
        allSeats.value = generateVirtualSeats()
        // 静默生成座位，无需提示用户
      } else {
        allSeats.value = seats
      }
    } else {
      ElMessage.error(res.message || '加载座位失败')
    }
  } catch (error: any) {
    console.error('加载座位失败:', error)
    if (error.response?.status === 403) {
      ElMessage.error('权限不足，请重新登录')
    } else if (error.response?.status === 401) {
      ElMessage.error('未登录，请先登录')
    } else {
      ElMessage.error(error.message || '加载座位失败')
    }
  } finally {
    loading.value = false
  }
}

// 处理座位点击
const handleSeatClick = (seat: Seat) => {
  // 已占用或维修中的座位不能选
  const status = seat.status.toLowerCase()
  if (status === 'occupied' || status === 'maintenance' || status === 'locked') {
    ElMessage.warning('该座位不可选择')
    return
  }

  const index = selectedSeats.value.findIndex(s => s.seatId === seat.seatId)
  
  if (index > -1) {
    // 已选中，取消选择
    selectedSeats.value.splice(index, 1)
  } else {
    // 未选中，添加选择
    if (selectedSeats.value.length >= maxSeats.value) {
      ElMessage.warning(`最多只能选择${maxSeats.value}个座位`)
      return
    }
    selectedSeats.value.push(seat)
  }
}

// 移除已选座位
const removeSeat = (seat: Seat) => {
  const index = selectedSeats.value.findIndex(s => s.seatId === seat.seatId)
  if (index > -1) {
    selectedSeats.value.splice(index, 1)
  }
}

// 切换座位类型
const handleTypeChange = () => {
  // 类型切换时不清空已选座位，允许跨类型选择
}

// 确认选座
const confirmSelection = () => {
  if (selectedSeats.value.length === 0) {
    ElMessage.warning('请至少选择一个座位')
    return
  }
  
  emit('confirm', selectedSeats.value)
  handleClose()
}

// 关闭对话框
const handleClose = () => {
  visible.value = false
  selectedSeats.value = []
  currentType.value = '商务座'
}

// 监听对话框打开
watch(visible, (newVal) => {
  if (newVal) {
    // 验证必要参数
    if (!props.trainId || !props.travelDate) {
      ElMessage.error('缺少必要参数：车次ID或乘车日期')
      visible.value = false
      return
    }
    loadSeats()
  }
})
</script>

<style scoped lang="scss">
.seat-selector {
  .seat-type-tabs {
    margin-bottom: 20px;
    text-align: center;
  }

  .seat-legend {
    display: flex;
    justify-content: center;
    gap: 30px;
    margin-bottom: 20px;
    padding: 10px;
    background: #f5f7fa;
    border-radius: 4px;

    .legend-item {
      display: flex;
      align-items: center;
      gap: 8px;

      .legend-box {
        width: 30px;
        height: 30px;
        border-radius: 4px;
        border: 1px solid #dcdfe6;

        &.available {
          background: #67c23a;
        }

        &.selected {
          background: #e6a23c;
        }

        &.occupied {
          background: #909399;
        }

        &.maintenance {
          background: #f56c6c;
        }
      }
    }
  }

  .seat-layout {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 10px;
    padding: 20px;
    background: #f5f7fa;
    border-radius: 8px;
    min-height: 400px;
    max-height: 500px;
    overflow-y: auto;

    .seat-item {
      width: 100%;
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.3s;
      border: 2px solid transparent;
      font-weight: bold;
      font-size: 14px;

      &.available {
        background: #67c23a;
        color: white;

        &:hover {
          transform: scale(1.05);
          box-shadow: 0 2px 8px rgba(103, 194, 58, 0.5);
        }
      }

      &.selected {
        background: #e6a23c;
        color: white;
        border-color: #d48806;

        &:hover {
          transform: scale(1.05);
        }
      }

      &.occupied {
        background: #909399;
        color: white;
        cursor: not-allowed;
        opacity: 0.7;
      }

      &.maintenance {
        background: #f56c6c;
        color: white;
        cursor: not-allowed;
        opacity: 0.7;
      }

      .seat-number {
        user-select: none;
      }
    }
  }

  .selected-info {
    margin-top: 20px;
    padding: 15px;
    background: #fef0e6;
    border-radius: 4px;

    .info-title {
      font-weight: bold;
      margin-bottom: 10px;
      color: #e6a23c;
    }

    .selected-list {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }
  }
}
</style>
