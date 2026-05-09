<template>
  <el-dialog
    v-model="visible"
    title="申请改签"
    width="900px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <el-steps :active="currentStep" finish-status="success" align-center style="margin-bottom: 30px">
      <el-step title="选择新车次" />
      <el-step title="选择座位" />
      <el-step title="确认信息" />
    </el-steps>

    <!-- 步骤1: 选择新车次 -->
    <div v-if="currentStep === 0" class="step-content">
      <div class="search-section">
        <el-form :inline="true" @submit.prevent="searchTrains">
          <el-form-item label="出发站">
            <el-autocomplete
              v-model="searchForm.startStation"
              :fetch-suggestions="queryStations"
              placeholder="请输入出发站"
              clearable
              :trigger-on-focus="true"
              @select="handleSelectStation"
              style="width: 200px"
            >
              <template #default="{ item }">
                <div class="station-item">{{ item.value }}</div>
              </template>
            </el-autocomplete>
          </el-form-item>
          <el-form-item label="到达站">
            <el-autocomplete
              v-model="searchForm.endStation"
              :fetch-suggestions="queryStations"
              placeholder="请输入到达站"
              clearable
              :trigger-on-focus="true"
              @select="handleSelectStation"
              style="width: 200px"
            >
              <template #default="{ item }">
                <div class="station-item">{{ item.value }}</div>
              </template>
            </el-autocomplete>
          </el-form-item>
          <el-form-item label="出行日期">
            <el-date-picker
              v-model="searchForm.date"
              type="date"
              placeholder="选择日期"
              :disabled-date="disabledDate"
              value-format="YYYY-MM-DD"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="searchTrains" :loading="searchLoading">
              <el-icon><Search /></el-icon>
              <span>搜索</span>
            </el-button>
          </el-form-item>
        </el-form>
      </div>

      <el-table
        :data="trainList"
        style="width: 100%"
        height="350"
        v-loading="searchLoading"
        highlight-current-row
      >
        <el-table-column prop="trainNumber" label="车次" width="100" />
        <el-table-column prop="startStation" label="出发站" width="100" />
        <el-table-column prop="endStation" label="到达站" width="100" />
        <el-table-column prop="departureTime" label="发车时间" width="100" />
        <el-table-column prop="arrivalTime" label="到达时间" width="100" />
        <el-table-column label="余票" width="120">
          <template #default="scope">
            <div class="seat-info">
              <el-tag size="small" type="success">
                余票: {{ scope.row.availableSeats || scope.row.totalSeats || '-' }}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="票价" width="100">
          <template #default="scope">
            <span style="color: #f56c6c; font-weight: bold">¥{{ scope.row.basePrice || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="scope">
            <el-button type="primary" size="small" @click="selectTrain(scope.row)">
              选择
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 步骤2: 选择座位 -->
    <div v-if="currentStep === 1" class="step-content">
      <div class="train-info-card">
        <h3>{{ selectedTrain?.trainNumber }}</h3>
        <p>{{ selectedTrain?.startStation }} → {{ selectedTrain?.endStation }}</p>
        <p>{{ searchForm.date }} {{ selectedTrain?.departureTime }}</p>
      </div>

      <!-- 座位状态说明 -->
      <div class="seat-legend">
        <span class="legend-item">
          <span class="legend-dot available"></span>
          <span>可选</span>
        </span>
        <span class="legend-item">
          <span class="legend-dot occupied"></span>
          <span>已占用</span>
        </span>
        <span class="legend-item">
          <span class="legend-dot selected"></span>
          <span>已选择</span>
        </span>
      </div>

      <!-- 团体购票提示 -->
      <el-alert
        v-if="originalOrder.isGroupBooking && originalOrder.ticketCount > 1"
        :title="`团体购票提示（共${originalOrder.ticketCount}张车票）`"
        type="info"
        :closable="false"
        style="margin: 15px 0;"
      >
        <template #default>
          <div style="line-height: 1.6;">
            <p style="margin: 5px 0;">✓ 请为第一张车票选择座位</p>
            <p style="margin: 5px 0;">✓ 其他 {{ originalOrder.ticketCount - 1 }} 张车票将自动分配连续座位</p>
            <p style="margin: 5px 0; color: #909399;">• 系统会尽量为您分配相邻座位，便于团体出行</p>
          </div>
        </template>
      </el-alert>

      <el-tabs v-model="selectedSeatType" @tab-change="loadSeats">
        <el-tab-pane label="二等座" name="二等座">
          <div v-loading="seatsLoading" class="seat-container">
            <div v-if="!seatsLoading && availableSeats.length > 0" class="seat-grid">
              <div
                v-for="seat in availableSeats"
                :key="seat.seatId"
                :class="[
                  'seat-item',
                  {
                    selected: selectedSeat?.seatId === seat.seatId,
                    available: seat.status === 'available',
                    occupied: seat.status !== 'available'
                  }
                ]"
                @click="seat.status === 'available' ? selectSeat(seat) : null"
              >
                <div class="seat-number">{{ seat.seatNumber }}</div>
                <div class="seat-price">¥{{ getSeatPrice(seat) }}</div>
                <div class="seat-status">
                  <el-tag v-if="seat.status === 'available'" type="success" size="small">可选</el-tag>
                  <el-tag v-else type="info" size="small">已占</el-tag>
                </div>
              </div>
            </div>
            <el-empty v-if="!seatsLoading && availableSeats.length === 0" description="暂无可用座位" />
          </div>
        </el-tab-pane>
        <el-tab-pane label="一等座" name="一等座">
          <div v-loading="seatsLoading" class="seat-container">
            <div v-if="!seatsLoading && availableSeats.length > 0" class="seat-grid">
              <div
                v-for="seat in availableSeats"
                :key="seat.seatId"
                :class="[
                  'seat-item',
                  {
                    selected: selectedSeat?.seatId === seat.seatId,
                    available: seat.status === 'available',
                    occupied: seat.status !== 'available'
                  }
                ]"
                @click="seat.status === 'available' ? selectSeat(seat) : null"
              >
                <div class="seat-number">{{ seat.seatNumber }}</div>
                <div class="seat-price">¥{{ getSeatPrice(seat) }}</div>
                <div class="seat-status">
                  <el-tag v-if="seat.status === 'available'" type="success" size="small">可选</el-tag>
                  <el-tag v-else type="info" size="small">已占</el-tag>
                </div>
              </div>
            </div>
            <el-empty v-if="!seatsLoading && availableSeats.length === 0" description="暂无可用座位" />
          </div>
        </el-tab-pane>
        <el-tab-pane label="商务座" name="商务座">
          <div v-loading="seatsLoading" class="seat-container">
            <div v-if="!seatsLoading && availableSeats.length > 0" class="seat-grid">
              <div
                v-for="seat in availableSeats"
                :key="seat.seatId"
                :class="[
                  'seat-item',
                  {
                    selected: selectedSeat?.seatId === seat.seatId,
                    available: seat.status === 'available',
                    occupied: seat.status !== 'available'
                  }
                ]"
                @click="seat.status === 'available' ? selectSeat(seat) : null"
              >
                <div class="seat-number">{{ seat.seatNumber }}</div>
                <div class="seat-price">¥{{ getSeatPrice(seat) }}</div>
                <div class="seat-status">
                  <el-tag v-if="seat.status === 'available'" type="success" size="small">可选</el-tag>
                  <el-tag v-else type="info" size="small">已占</el-tag>
                </div>
              </div>
            </div>
            <el-empty v-if="!seatsLoading && availableSeats.length === 0" description="暂无可用座位" />
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 步骤3: 确认信息 -->
    <div v-if="currentStep === 2" class="step-content">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="原车次">
          {{ originalOrder?.trainNumber }}
        </el-descriptions-item>
        <el-descriptions-item label="原出行日期">
          {{ originalOrder?.travelDate }}
        </el-descriptions-item>
        <el-descriptions-item label="原座位">
          {{ originalOrder?.seatType || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="原票价">
          ¥{{ getOriginalPrice() }}
        </el-descriptions-item>

        <el-descriptions-item label="新车次" label-class-name="new-info">
          {{ selectedTrain?.trainNumber || '-' }}
        </el-descriptions-item>
        <el-descriptions-item label="新出行日期" label-class-name="new-info">
          {{ searchForm.date }} {{ selectedTrain?.departureTime || '' }}
        </el-descriptions-item>
        <el-descriptions-item label="新座位" label-class-name="new-info">
          {{ selectedSeat?.seatNumber || '-' }} ({{ selectedSeatType }})
        </el-descriptions-item>
        <el-descriptions-item label="新票价" label-class-name="new-info">
          ¥{{ getNewPrice() }}
        </el-descriptions-item>
      </el-descriptions>

      <el-alert
        v-if="priceDifference !== 0"
        :title="priceDifferenceText"
        :type="priceDifference > 0 ? 'warning' : 'success'"
        style="margin-top: 20px"
        show-icon
      />

      <!-- 团体购票座位分配说明 -->
      <el-alert
        v-if="originalOrder.isGroupBooking && originalOrder.ticketCount > 1"
        type="success"
        :closable="false"
        style="margin-top: 15px;"
      >
        <template #title>
          <div style="display: flex; align-items: center;">
            <span style="font-size: 16px; font-weight: bold;">✓ 团体改签：将为 {{ originalOrder.ticketCount }} 张车票提交改签申请</span>
          </div>
        </template>
        <template #default>
          <div style="line-height: 1.8; margin-top: 8px;">
            <p style="margin: 5px 0;">• 第一张车票座位：<strong>{{ selectedSeat?.seatNumber }}</strong></p>
            <p style="margin: 5px 0;">• 其他车票座位：系统将自动分配从 {{ selectedSeat?.seatNumber }} 开始的连续座位</p>
            <p style="margin: 5px 0; color: #67C23A;">• 所有座位均为 <strong>{{ selectedSeatType }}</strong>，确保团体一起出行</p>
          </div>
        </template>
      </el-alert>

      <el-form :model="changeForm" style="margin-top: 20px">
        <el-form-item label="改签原因">
          <el-input
            v-model="changeForm.reason"
            type="textarea"
            :rows="3"
            placeholder="请输入改签原因（例如：行程变更、时间调整等）"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
      </el-form>
    </div>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button v-if="currentStep > 0" @click="previousStep">上一步</el-button>
        <el-button
          v-if="currentStep < 2"
          type="primary"
          @click="nextStep"
          :disabled="!canNextStep"
        >
          下一步
        </el-button>
        <el-button
          v-if="currentStep === 2"
          type="primary"
          @click="submitChange"
          :loading="submitting"
        >
          提交改签申请
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { trainApi } from '@/api/train'
import { seatApi } from '@/api/seat'
import { approvalApi } from '@/api/approval'
import { Search } from '@element-plus/icons-vue'

const props = defineProps<{
  modelValue: boolean
  order: any
}>()

const emit = defineEmits(['update:modelValue', 'success'])

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

// 步骤
const currentStep = ref(0)

// 原订单信息
const originalOrder = computed(() => props.order)

// 搜索表单
// 常用站点列表
const commonStations = [
  { value: '北京站' },
  { value: '北京南站' },
  { value: '北京西站' },
  { value: '上海站' },
  { value: '上海虹桥站' },
  { value: '广州站' },
  { value: '广州南站' },
  { value: '深圳站' },
  { value: '深圳北站' },
  { value: '杭州站' },
  { value: '杭州东站' },
  { value: '南京站' },
  { value: '南京南站' },
  { value: '武汉站' },
  { value: '成都站' },
  { value: '成都东站' },
  { value: '重庆站' },
  { value: '重庆北站' },
  { value: '西安站' },
  { value: '西安北站' },
  { value: '郑州站' },
  { value: '郑州东站' },
  { value: '长沙站' },
  { value: '长沙南站' },
  { value: '天津站' },
  { value: '天津西站' },
  { value: '济南站' },
  { value: '青岛站' },
  { value: '沈阳站' },
  { value: '哈尔滨站' }
]

const searchForm = ref({
  startStation: '',
  endStation: '',
  date: ''
})

const searchLoading = ref(false)
const trainList = ref<any[]>([])
const selectedTrain = ref<any>(null)
const selectedSeatType = ref('二等座')
const availableSeats = ref<any[]>([])
const selectedSeat = ref<any>(null)
const changeForm = ref({
  reason: ''
})
const submitting = ref(false)
const seatsLoading = ref(false)

// 站点自动完成查询（支持部分匹配：输入"北京"可匹配"北京站"）
const queryStations = (queryString: string, cb: any) => {
  if (!queryString) {
    cb(commonStations)
    return
  }

  const query = queryString.toLowerCase().trim()
  const results = commonStations.filter((station) => {
    const stationLower = station.value.toLowerCase()
    // 支持多种匹配方式
    return stationLower.includes(query) ||           // 包含匹配："北京" 匹配 "北京站"
           stationLower.startsWith(query) ||         // 前缀匹配："北" 匹配 "北京站"
           stationLower.replace('站', '') === query  // 去掉"站"后精确匹配："北京" 匹配 "北京站"
  })

  cb(results)
}

// 处理站点选择
const handleSelectStation = (item: any) => {
  // 可以在这里添加额外的逻辑，例如自动触发搜索等
  console.log('选择了站点:', item.value)
}

// 禁用过去的日期
const disabledDate = (time: Date) => {
  return time.getTime() < Date.now() - 24 * 60 * 60 * 1000
}

// 搜索车次（参考车票查询逻辑，允许部分条件为空）
const searchTrains = async () => {
  // 至少填写一个条件
  if (!searchForm.value.startStation && !searchForm.value.endStation && !searchForm.value.date) {
    ElMessage.warning('请至少填写一个查询条件')
    return
  }

  searchLoading.value = true
  try {
    // 构建查询参数（只传递非空值）
    const params: any = {}
    if (searchForm.value.startStation) params.startStation = searchForm.value.startStation
    if (searchForm.value.endStation) params.endStation = searchForm.value.endStation
    if (searchForm.value.date) params.date = searchForm.value.date

    const res = await trainApi.searchTrains(params)
    if (res.code === 200) {
      // 从分页对象中提取records数组
      trainList.value = res.data?.records || []
      if (trainList.value.length === 0) {
        ElMessage.info('未找到符合条件的车次')
      }
    } else {
      ElMessage.error(res.message || '搜索失败')
    }
  } catch (error: any) {
    ElMessage.error(error.message || '搜索失败')
  } finally {
    searchLoading.value = false
  }
}

// 选择车次
const selectTrain = (row: any) => {
  if (!row) {
    ElMessage.warning('请选择车次')
    return
  }

  // 验证必要的数据
  if (!row.trainId) {
    ElMessage.error('车次信息不完整')
    return
  }

  selectedTrain.value = row
  ElMessage.success(`已选择车次: ${row.trainNumber}`)

  // 自动进入下一步（选择座位）
  nextStep()
}

// 加载座位（加载所有座位，包括已占用的，方便用户查看）
const loadSeats = async () => {
  if (!selectedTrain.value) {
    ElMessage.warning('请先选择车次')
    return
  }

  seatsLoading.value = true

  // 先清空座位列表，避免切换时数据累积
  availableSeats.value = []
  selectedSeat.value = null

  try {
    // 查询该车次该日期的所有座位
    const res = await seatApi.getSeatLayout({
      trainId: selectedTrain.value.trainId,
      travelDate: searchForm.value.date
    })

    if (res.code === 200) {
      const allSeats = res.data || []
      console.log(`从后端获取的座位总数: ${allSeats.length}`)

      // 调试：显示前3个座位的原始数据
      if (allSeats.length > 0) {
        console.log('前3个座位的原始数据:')
        allSeats.slice(0, 3).forEach((seat: any, index: number) => {
          console.log(`  座位${index + 1}:`, {
            seatId: seat.seatId,
            seatNumber: seat.seatNumber,
            seatType: seat.seatType,
            travelDate: seat.travelDate,
            trainId: seat.trainId,
            status: seat.status
          })
        })
      }

      // ⚠️ 关键修复：按日期和座位类型筛选座位
      // 因为同一个train_id在不同日期有不同的座位记录
      const selectedDate = searchForm.value.date
      console.log(`选择的出行日期: ${selectedDate}`)
      console.log(`选择的座位类型: ${selectedSeatType.value}`)

      let filterDebugCount = 0  // 用于限制调试输出数量
      const filteredSeats = allSeats.filter((seat: any) => {
        // 筛选条件1：座位类型匹配
        const seatTypeMatch = seat.seatType === selectedSeatType.value

        // 筛选条件2：日期匹配（关键！）
        let dateMatch: boolean  // 默认不匹配

        if (selectedDate && seat.travelDate) {
          // 后端返回的travelDate可能是字符串"yyyy-MM-dd"或Date对象
          let seatDate: string
          if (typeof seat.travelDate === 'string') {
            // 如果是字符串，直接使用（后端已格式化）
            seatDate = seat.travelDate
          } else {
            // 如果是Date对象，转换为YYYY-MM-DD格式
            seatDate = new Date(seat.travelDate).toISOString().split('T')[0]
          }

          dateMatch = seatDate === selectedDate

          // 调试：显示不匹配的原因（只显示前3个）
          if ((!seatTypeMatch || !dateMatch) && filterDebugCount < 3) {
            console.log(`  座位${seat.seatNumber}被过滤:`, {
              seatType: seat.seatType,
              "需要类型": selectedSeatType.value,
              "类型匹配": seatTypeMatch,
              "座位日期": seatDate,
              "需要日期": selectedDate,
              "日期匹配": dateMatch
            })
            filterDebugCount++
          }
        } else {
          // 日期信息缺失
          if (filterDebugCount < 3) {
            if (!selectedDate) {
              console.warn(`  未选择出行日期`)
            } else if (!seat.travelDate) {
              console.warn(`  座位${seat.seatNumber}的travelDate为null或undefined`)
            }
            filterDebugCount++
          }
          dateMatch = false  // 日期信息不完整时不匹配
        }

        return seatTypeMatch && dateMatch
      })

      console.log(`筛选后的${selectedSeatType.value}座位数（日期${selectedDate}）: ${filteredSeats.length}`)

      // 去重：根据座位号(seatNumber)去重，避免显示重复座位
      // 注意：使用 Map 来去重，key 是 seatNumber，保留最后一个
      const seatMap = new Map()
      filteredSeats.forEach((seat: any) => {
        // 如果座位号已存在，保留状态为available的，或者保留最新的
        const existing = seatMap.get(seat.seatNumber)
        if (!existing || seat.status === 'available') {
          seatMap.set(seat.seatNumber, seat)
        }
      })

      // 转换回数组
      const uniqueSeats = Array.from(seatMap.values())
      console.log(`去重后的座位数: ${uniqueSeats.length}`)

      // 检查是否还有重复
      const seatNumbers = uniqueSeats.map(s => s.seatNumber)
      const duplicates = seatNumbers.filter((num, index) => seatNumbers.indexOf(num) !== index)
      if (duplicates.length > 0) {
        console.warn('警告：仍有重复的座位号:', duplicates)
      }

      // 按座位号排序，让座位显示更有序
      uniqueSeats.sort((a: any, b: any) => {
        return a.seatNumber.localeCompare(b.seatNumber, 'zh-CN', { numeric: true })
      })

      availableSeats.value = uniqueSeats
      console.log('座位列表已更新，共', uniqueSeats.length, '个座位')

      // 显示前5个座位的详细信息（用于验证日期是否正确）
      if (uniqueSeats.length > 0) {
        console.log('前5个座位详情:')
        uniqueSeats.slice(0, 5).forEach((seat: any) => {
          let seatDate: string
          if (typeof seat.travelDate === 'string') {
            seatDate = seat.travelDate
          } else if (seat.travelDate) {
            seatDate = new Date(seat.travelDate).toISOString().split('T')[0]
          } else {
            seatDate = 'null'
          }
          console.log(`  - ${seat.seatNumber}: seatId=${seat.seatId}, trainId=${seat.trainId}, date=${seatDate}, status=${seat.status}`)
        })
      }

      // 统计可用座位数量
      const availableCount = availableSeats.value.filter((seat: any) =>
        seat.status === 'available'
      ).length

      if (availableSeats.value.length === 0) {
        ElMessage.info(`${selectedSeatType.value}暂无座位`)
      } else if (availableCount === 0) {
        ElMessage.warning(`${selectedSeatType.value}暂无可选座位，全部已被占用`)
      } else {
        console.log(`${selectedSeatType.value}共${availableSeats.value.length}个座位，${availableCount}个可选`)
      }
    } else {
      ElMessage.error(res.message || '加载座位失败')
    }
  } catch (error: any) {
    ElMessage.error(error.message || '加载座位失败')
    availableSeats.value = []
  } finally {
    seatsLoading.value = false
  }
}

// 选择座位
const selectSeat = (seat: any) => {
  if (!seat) {
    ElMessage.warning('请选择座位')
    return
  }

  selectedSeat.value = seat
  const price = getSeatPrice(seat)
  ElMessage.success(`已选择座位: ${seat.seatNumber}，票价: ¥${price}`)
}

// 获取原票价数值（用于计算）
const getOriginalPriceValue = () => {
  if (!originalOrder.value) return 0

  const price = originalOrder.value.totalAmount ||
                originalOrder.value.price ||
                originalOrder.value.amount ||
                (originalOrder.value.tickets && originalOrder.value.tickets[0]?.price)

  return price ? Number(price) : 0
}

// 获取原票价（用于显示）
const getOriginalPrice = () => {
  if (!originalOrder.value) return '-'

  // 调试：查看原订单数据结构
  console.log('原订单数据:', originalOrder.value)

  // 尝试多种可能的字段名
  const price = originalOrder.value.totalAmount ||
                originalOrder.value.price ||
                originalOrder.value.amount ||
                (originalOrder.value.tickets && originalOrder.value.tickets[0]?.price)

  console.log('提取到的原票价:', price)
  return price ? Number(price).toFixed(2) : '-'
}

// 获取新票价
const getNewPrice = () => {
  if (!selectedSeat.value) return '-'

  // 调试：查看完整数据
  console.log('选中座位数据:', selectedSeat.value)
  console.log('选中车次数据:', selectedTrain.value)

  // 尝试从多个来源获取价格
  let price = selectedSeat.value.price ||
              selectedSeat.value.amount ||
              selectedSeat.value.ticketPrice

  // 如果座位没有价格，从车次的基础价格计算
  if (!price && selectedTrain.value) {
    const basePrice = selectedTrain.value.basePrice || selectedTrain.value.price
    const seatType = selectedSeatType.value

    // 根据座位类型计算价格
    if (basePrice) {
      if (seatType === '商务座') {
        price = Number(basePrice) * 3  // 商务座是基础价的3倍
      } else if (seatType === '一等座') {
        price = Number(basePrice) * 1.5  // 一等座是基础价的1.5倍
      } else {
        price = Number(basePrice)  // 二等座就是基础价
      }
    }
  }

  console.log('提取到的新票价:', price)
  return price ? Number(price).toFixed(2) : '-'
}

// 计算座位价格（用于显示）
const getSeatPrice = (seat: any) => {
  if (!seat) return '-'

  // 尝试从座位数据获取价格
  let price = seat.price || seat.amount || seat.ticketPrice

  // 如果座位没有价格，从车次的基础价格计算
  if (!price && selectedTrain.value) {
    const basePrice = selectedTrain.value.basePrice || selectedTrain.value.price
    const seatType = seat.seatType || selectedSeatType.value

    // 根据座位类型计算价格
    if (basePrice) {
      if (seatType === '商务座') {
        price = Number(basePrice) * 3
      } else if (seatType === '一等座') {
        price = Number(basePrice) * 1.5
      } else {
        price = Number(basePrice)
      }
    }
  }

  return price ? Number(price).toFixed(2) : '-'
}

// 获取新票价数值（用于计算）
const getNewPriceValue = () => {
  if (!selectedSeat.value) return 0

  // 尝试从多个来源获取价格
  let price = selectedSeat.value.price ||
              selectedSeat.value.amount ||
              selectedSeat.value.ticketPrice

  // 如果座位没有价格，从车次的基础价格计算
  if (!price && selectedTrain.value) {
    const basePrice = selectedTrain.value.basePrice || selectedTrain.value.price
    const seatType = selectedSeatType.value

    // 根据座位类型计算价格
    if (basePrice) {
      if (seatType === '商务座') {
        price = Number(basePrice) * 3
      } else if (seatType === '一等座') {
        price = Number(basePrice) * 1.5
      } else {
        price = Number(basePrice)
      }
    }
  }

  return price ? Number(price) : 0
}

// 价差计算
const priceDifference = computed(() => {
  const newPrice = getNewPriceValue()
  const oldPrice = getOriginalPriceValue()

  return newPrice - oldPrice
})

const priceDifferenceText = computed(() => {
  const diff = priceDifference.value
  if (diff > 0) {
    return `需补票价：¥${diff.toFixed(2)}`
  } else if (diff < 0) {
    return `将退还差价：¥${Math.abs(diff).toFixed(2)}`
  }
  return '票价相同'
})

// 是否可以下一步
const canNextStep = computed(() => {
  if (currentStep.value === 0) return selectedTrain.value !== null
  if (currentStep.value === 1) return selectedSeat.value !== null
  return true
})

// 下一步
const nextStep = () => {
  if (currentStep.value === 0 && selectedTrain.value) {
    currentStep.value++
    loadSeats()
  } else if (currentStep.value === 1 && selectedSeat.value) {
    currentStep.value++
  }
}

// 上一步
const previousStep = () => {
  if (currentStep.value > 0) {
    currentStep.value--
  }
}

// 提交改签申请（支持单人和团体购票）
const submitChange = async () => {
  if (!changeForm.value.reason) {
    ElMessage.warning('请填写改签原因')
    return
  }

  submitting.value = true
  try {
    // 获取所有车票ID
    const tickets = originalOrder.value.tickets || []
    const ticketIds = tickets.map((t: any) => t.ticketId).filter((id: any) => id)

    if (ticketIds.length === 0) {
      ElMessage.error('无法获取车票信息')
      return
    }

    const ticketCount = ticketIds.length
    console.log(`准备为${ticketCount}张车票提交改签申请`)

    // 构建日期和时间
    const newTravelDate = new Date(searchForm.value.date)
    const departureDateTime = new Date(`${searchForm.value.date} ${selectedTrain.value.departureTime}`)
    const arrivalDateTime = new Date(`${searchForm.value.date} ${selectedTrain.value.arrivalTime}`)

    // 获取可用座位列表（用于为多张票分配座位）
    const availableSeatsForBooking = availableSeats.value.filter((seat: any) =>
      seat.status === 'available'
    )

    // 检查可用座位是否足够
    if (availableSeatsForBooking.length < ticketCount) {
      ElMessage.error(`可用座位不足！需要${ticketCount}个座位，但只有${availableSeatsForBooking.length}个可用座位`)
      return
    }

    // 为每张票分配座位
    const seatAssignments: any[] = []
    const selectedSeatIndex = availableSeatsForBooking.findIndex(
      (seat: any) => seat.seatId === selectedSeat.value.seatId
    )

    if (selectedSeatIndex === -1) {
      for (let i = 0; i < ticketCount; i++) {
        seatAssignments.push(availableSeatsForBooking[i])
      }
    } else {
      for (let i = 0; i < ticketCount; i++) {
        const seatIndex = selectedSeatIndex + i
        if (seatIndex < availableSeatsForBooking.length) {
          seatAssignments.push(availableSeatsForBooking[seatIndex])
        } else {
          seatAssignments.push(availableSeatsForBooking[i])
        }
      }
    }

    console.log('座位分配方案:', seatAssignments.map((s: any) => s.seatNumber))
    console.log('车票ID列表:', ticketIds)
    console.log('选择的新车次:', selectedTrain.value.trainNumber, 'ID:', selectedTrain.value.trainId)

    // 批量提交改签申请
    const promises = ticketIds.map((ticketId: number, index: number) => {
      const assignedSeat = seatAssignments[index]

      // 计算该座位的票价
      let seatPrice = assignedSeat.price || assignedSeat.amount || assignedSeat.ticketPrice

      if (!seatPrice && selectedTrain.value) {
        const basePrice = selectedTrain.value.basePrice || selectedTrain.value.price
        const seatType = selectedSeatType.value

        if (basePrice) {
          if (seatType === '商务座') {
            seatPrice = Number(basePrice) * 3
          } else if (seatType === '一等座') {
            seatPrice = Number(basePrice) * 1.5
          } else {
            seatPrice = Number(basePrice)
          }
        }
      }

      const requestData = {
        ticketId,
        newTrainId: selectedTrain.value.trainId,
        newSeatId: assignedSeat.seatId,
        newTravelDate,
        newDepartureTime: departureDateTime,
        newArrivalTime: arrivalDateTime,
        newPrice: seatPrice ? Number(seatPrice) : 0,
        applyReason: changeForm.value.reason
      }

      console.log(`第 ${index + 1} 张票改签申请:`, requestData)

      return approvalApi.applyChangeTicket(requestData)
    })

    const results = await Promise.all(promises)

    const successCount = results.filter((r: any) => r.code === 200).length
    const failCount = ticketCount - successCount

    console.log(`改签申请结果 - 成功: ${successCount}/${ticketCount}, 失败: ${failCount}/${ticketCount}`)

    if (successCount === ticketCount) {
      ElMessage.success(
        ticketCount > 1
          ? `已成功为 ${successCount} 张车票提交改签申请，请等待操作员审批`
          : '改签申请已提交，请等待操作员审批'
      )
      emit('success')
      handleClose()
    } else if (successCount > 0) {
      ElMessage.warning(`成功提交 ${successCount} 张车票的改签申请，${failCount} 张提交失败`)
      emit('success')
      handleClose()
    } else {
      const errMsg = results[0]?.message || '改签申请提交失败'
      ElMessage.error(errMsg)
    }
  } catch (error: any) {
    ElMessage.error(error.message || '提交失败')
  } finally {
    submitting.value = false
  }
}

// 关闭对话框
const handleClose = () => {
  visible.value = false
  // 重置状态
  currentStep.value = 0
  selectedTrain.value = null
  selectedSeat.value = null
  selectedSeatType.value = '二等座'
  trainList.value = []
  availableSeats.value = []
  changeForm.value.reason = ''
  searchForm.value = {
    startStation: '',
    endStation: '',
    date: ''
  }
}

// 监听对话框打开，初始化搜索条件
watch(visible, (newVal) => {
  if (newVal && originalOrder.value) {
    console.log('\n========== 改签对话框已打开 ==========')
    console.log('原始订单信息:', originalOrder.value)
    console.log('是否团体购票:', originalOrder.value.isGroupBooking)
    console.log('票据数量:', originalOrder.value.ticketCount)

    if (originalOrder.value.tickets) {
      console.log('票据列表:')
      originalOrder.value.tickets.forEach((ticket: any, index: number) => {
        console.log(`  票${index + 1}:`, {
          ticketId: ticket.ticketId,
          trainId: ticket.trainId,
          trainNumber: ticket.trainNumber,
          seatNumber: ticket.seatNumber,
          startStation: ticket.startStation,
          endStation: ticket.endStation
        })
      })
    }
    console.log('======================================\n')

    searchForm.value.startStation = originalOrder.value.startStation || ''
    searchForm.value.endStation = originalOrder.value.endStation || ''
  }
})
</script>

<style scoped lang="scss">
.step-content {
  min-height: 400px;
}

.search-section {
  margin-bottom: 20px;
}

.station-item {
  padding: 8px 12px;
  font-size: 14px;

  &:hover {
    background-color: #f5f7fa;
  }
}

.seat-info {
  display: flex;
  gap: 5px;
  flex-wrap: wrap;
}

.seat-container {
  min-height: 300px;
  position: relative;
}

.seat-legend {
  display: flex;
  gap: 20px;
  padding: 15px 20px;
  background: #f5f7fa;
  border-radius: 8px;
  margin-bottom: 15px;

  .legend-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    color: #606266;

    .legend-dot {
      width: 20px;
      height: 20px;
      border-radius: 4px;
      border: 2px solid;

      &.available {
        background: #f0f9ff;
        border-color: #67c23a;
      }

      &.occupied {
        background: #f5f7fa;
        border-color: #dcdfe6;
        opacity: 0.6;
      }

      &.selected {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-color: #409eff;
      }
    }
  }
}

.train-info-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;

  h3 {
    margin: 0 0 10px 0;
    font-size: 24px;
  }

  p {
    margin: 5px 0;
    opacity: 0.9;
  }
}

.seat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 15px;
  padding: 20px;
  max-height: 400px;
  overflow-y: auto;
}

.seat-item {
  border: 2px solid #e4e7ed;
  border-radius: 8px;
  padding: 15px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
  background: white;
  position: relative;

  &.available {
    border-color: #67c23a;
    background: #f0f9ff;

    &:hover {
      border-color: #409eff;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
    }
  }

  &.occupied {
    border-color: #dcdfe6;
    background: #f5f7fa;
    cursor: not-allowed;
    opacity: 0.6;

    &:hover {
      transform: none;
      box-shadow: none;
    }

    .seat-number,
    .seat-price {
      color: #909399;
    }
  }

  &.selected {
    border-color: #409eff;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;

    .seat-price,
    .seat-number {
      color: white;
    }
  }

  .seat-number {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 8px;
  }

  .seat-price {
    font-size: 14px;
    color: #f56c6c;
    margin-bottom: 8px;
  }

  .seat-status {
    margin-top: 5px;
  }
}

:deep(.new-info) {
  background-color: #f0f9ff !important;
  color: #409eff;
  font-weight: bold;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
