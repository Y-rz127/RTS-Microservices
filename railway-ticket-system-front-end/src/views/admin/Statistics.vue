<template>
  <div class="statistics">
    <!-- 日期范围选择 -->
    <el-card class="date-card">
      <el-form :inline="true">
        <el-form-item label="统计时间">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            :shortcuts="dateShortcuts"
            :clearable="false"
            unlink-panels
            :key="datePickerKey"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="loadAllStatistics">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 退票统计 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="8">
        <el-card>
          <template #header>
            <span>退票统计</span>
          </template>
          <div v-loading="loading.refund">
            <div class="stat-item">
              <span class="stat-label">退票数量：</span>
              <span class="stat-value">{{ refundStats.refundCount || 0 }} 张</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">退票金额：</span>
              <span class="stat-value">¥{{ refundStats.refundAmount || 0 }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">手续费：</span>
              <span class="stat-value">¥{{ refundStats.refundFee || 0 }}</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">实际退款：</span>
              <span class="stat-value text-success">¥{{ refundStats.actualRefund || 0 }}</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card>
          <template #header>
            <span>乘客统计</span>
          </template>
          <div v-loading="loading.passenger">
            <div class="stat-item">
              <span class="stat-label">独立乘客数：</span>
              <span class="stat-value">{{ passengerStats.uniquePassengers || 0 }} 人</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">购票总数：</span>
              <span class="stat-value">{{ passengerStats.totalTickets || 0 }} 张</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">人均购票：</span>
              <span class="stat-value">{{ (passengerStats.avgTicketsPerPassenger || 0).toFixed(2) }} 张</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card>
          <template #header>
            <span>数据说明</span>
          </template>
          <div class="quick-stats">
            <div class="stat-item">
              <span class="stat-label">统计周期：</span>
              <span class="stat-value">最近30天</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">数据更新：</span>
              <span class="stat-value">实时</span>
            </div>
            <div class="stat-item">
              <span class="stat-label">热门车次：</span>
              <span class="stat-value">Top 10</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 热门车次排行 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>热门车次（按售票量）</span>
          </template>
          <el-table 
            :data="topTrainsBySales" 
            v-loading="loading.topSales"
            border
            stripe
            style="width: 100%"
          >
            <el-table-column type="index" label="排名" width="60" align="center" />
            <el-table-column prop="trainNumber" label="车次号" width="100" align="center">
              <template #default="{ row }">
                <el-tag type="primary">{{ row.trainNumber || '-' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="路线">
              <template #default="{ row }">
                <span>{{ row.startStation }} - {{ row.endStation }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="salesCount" label="售票数量" width="100" align="center">
              <template #default="{ row }">
                <el-tag type="success">{{ row.salesCount }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-if="topTrainsBySales.length === 0 && !loading.topSales" description="当前时间段内暂无售票数据" />
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card>
          <template #header>
            <span>热门车次（按收入）</span>
          </template>
          <el-table 
            :data="topTrainsByRevenue" 
            v-loading="loading.topRevenue"
            border
            stripe
            style="width: 100%"
          >
            <el-table-column type="index" label="排名" width="60" align="center" />
            <el-table-column prop="trainNumber" label="车次号" width="100" align="center">
              <template #default="{ row }">
                <el-tag type="primary">{{ row.trainNumber || '-' }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column label="路线">
              <template #default="{ row }">
                <span>{{ row.startStation }} - {{ row.endStation }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="revenue" label="收入金额" width="120" align="center">
              <template #default="{ row }">
                <el-tag type="warning">¥{{ (row.revenue || 0).toFixed(2) }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-if="topTrainsByRevenue.length === 0 && !loading.topRevenue" description="当前时间段内暂无收入数据" />
        </el-card>
      </el-col>
    </el-row>

    <!-- 趋势图表 -->
    <el-row :gutter="20" style="margin-top: 20px">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>售票趋势</span>
          </template>
          <div ref="salesChartRef" style="height: 400px"></div>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card>
          <template #header>
            <span>收入趋势</span>
          </template>
          <div ref="revenueChartRef" style="height: 400px"></div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import { statisticsApi } from '@/api/statistics'
import * as echarts from 'echarts'
import type { EChartsOption } from 'echarts'

const dateRange = ref<string[]>([])
const datePickerKey = ref(0) // 用于强制刷新日期选择器

// 日期快捷选项
const dateShortcuts = [
  {
    text: '最近7天',
    value: () => {
      const end = new Date()
      const start = new Date(end.getTime()) // 创建新的Date对象
      start.setDate(start.getDate() - 6)
      return [start, end]
    }
  },
  {
    text: '最近15天',
    value: () => {
      const end = new Date()
      const start = new Date(end.getTime()) // 创建新的Date对象
      start.setDate(start.getDate() - 14)
      return [start, end]
    }
  },
  {
    text: '最近30天',
    value: () => {
      const end = new Date()
      const start = new Date(end.getTime()) // 创建新的Date对象
      start.setDate(start.getDate() - 29)
      return [start, end]
    }
  },
  {
    text: '最近90天',
    value: () => {
      const end = new Date()
      const start = new Date(end.getTime()) // 创建新的Date对象
      start.setDate(start.getDate() - 89)
      return [start, end]
    }
  }
]

const loading = ref({
  refund: false,
  passenger: false,
  topSales: false,
  topRevenue: false
})

const refundStats = ref<any>({})
const passengerStats = ref<any>({})
const topTrainsBySales = ref<any[]>([])
const topTrainsByRevenue = ref<any[]>([])

const salesChartRef = ref<HTMLElement>()
const revenueChartRef = ref<HTMLElement>()

let salesChart: echarts.ECharts | null = null
let revenueChart: echarts.ECharts | null = null

// 初始化日期范围（默认最近30天到今天）
const initDateRange = () => {
  const today = new Date()
  const startDate = new Date(today.getTime()) // 创建新的Date对象，避免引用问题
  startDate.setDate(startDate.getDate() - 29) // 往前推29天，加上今天正好30天
  
  const formatDate = (date: Date) => {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }
  
  const startStr = formatDate(startDate)
  const endStr = formatDate(today)
  
  // 先清空，再设置新值，确保触发响应式更新
  dateRange.value = []
  nextTick(() => {
    dateRange.value = [startStr, endStr]
    datePickerKey.value++ // 强制刷新日期选择器
    console.log('初始化日期范围:', startStr, '至', endStr)
  })
}

// 加载退票统计
const loadRefundStats = async () => {
  if (!dateRange.value || !dateRange.value[0] || !dateRange.value[1]) return
  
  loading.value.refund = true
  try {
    const res = await statisticsApi.getRefundStatistics({
      startDate: dateRange.value[0],
      endDate: dateRange.value[1]
    })
    
    if (res.code === 200) {
      refundStats.value = res.data || {}
    }
  } catch (error: any) {
    console.error('加载退票统计失败', error)
  } finally {
    loading.value.refund = false
  }
}

// 加载乘客统计
const loadPassengerStats = async () => {
  if (!dateRange.value || !dateRange.value[0] || !dateRange.value[1]) return
  
  loading.value.passenger = true
  try {
    const res = await statisticsApi.getPassengerStatistics({
      startDate: dateRange.value[0],
      endDate: dateRange.value[1]
    })
    
    if (res.code === 200) {
      passengerStats.value = res.data || {}
    }
  } catch (error: any) {
    console.error('加载乘客统计失败', error)
  } finally {
    loading.value.passenger = false
  }
}

// 加载热门车次（按销量）
const loadTopTrainsBySales = async () => {
  if (!dateRange.value || !dateRange.value[0] || !dateRange.value[1]) {
    ElMessage.warning('请先选择日期范围')
    return
  }
  
  loading.value.topSales = true
  try {
    const res = await statisticsApi.getTopTrainsBySales({
      topN: 10,
      startDate: dateRange.value[0],
      endDate: dateRange.value[1]
    })
    
    if (res.code === 200) {
      topTrainsBySales.value = res.data || []
    } else {
      topTrainsBySales.value = []
      if (res.message) {
        ElMessage.warning(res.message)
      }
    }
  } catch (error: any) {
    topTrainsBySales.value = []
    console.error('加载热门车次失败', error)
    ElMessage.error('网络错误或系统异常，请稍后重试')
  } finally {
    loading.value.topSales = false
  }
}

// 加载热门车次（按收入）
const loadTopTrainsByRevenue = async () => {
  if (!dateRange.value || !dateRange.value[0] || !dateRange.value[1]) {
    ElMessage.warning('请先选择日期范围')
    return
  }
  
  loading.value.topRevenue = true
  try {
    const res = await statisticsApi.getTopTrainsByRevenue({
      topN: 10,
      startDate: dateRange.value[0],
      endDate: dateRange.value[1]
    })
    
    if (res.code === 200) {
      topTrainsByRevenue.value = res.data || []
    } else {
      topTrainsByRevenue.value = []
      if (res.message) {
        ElMessage.warning(res.message)
      }
    }
  } catch (error: any) {
    topTrainsByRevenue.value = []
    console.error('加载热门车次失败', error)
    ElMessage.error('网络错误或系统异常，请稍后重试')
  } finally {
    loading.value.topRevenue = false
  }
}

// 加载售票趋势
const loadSalesTrend = async () => {
  try {
    const res = await statisticsApi.getSalesTrend(30)
    if (res.code === 200) {
      renderSalesChart(res.data)
    }
  } catch (error) {
    console.error('加载售票趋势失败', error)
  }
}

// 加载收入趋势
const loadRevenueTrend = async () => {
  try {
    const res = await statisticsApi.getRevenueTrend(30)
    if (res.code === 200) {
      renderRevenueChart(res.data)
    }
  } catch (error) {
    console.error('加载收入趋势失败', error)
  }
}

// 渲染售票图表
const renderSalesChart = (data: any[]) => {
  if (!salesChartRef.value) return
  
  if (!salesChart) {
    salesChart = echarts.init(salesChartRef.value)
  }

  const option: EChartsOption = {
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: data.map(item => new Date(item.date).toLocaleDateString())
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        data: data.map(item => item.count),
        type: 'line',
        smooth: true,
        itemStyle: { color: '#409eff' },
        areaStyle: { color: 'rgba(64, 158, 255, 0.2)' }
      }
    ]
  }

  salesChart.setOption(option)
}

// 渲染收入图表
const renderRevenueChart = (data: any[]) => {
  if (!revenueChartRef.value) return
  
  if (!revenueChart) {
    revenueChart = echarts.init(revenueChartRef.value)
  }

  const option: EChartsOption = {
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: data.map(item => new Date(item.date).toLocaleDateString())
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        data: data.map(item => item.revenue),
        type: 'bar',
        itemStyle: { color: '#67c23a' }
      }
    ]
  }

  revenueChart.setOption(option)
}

// 加载所有统计数据
const loadAllStatistics = async () => {
  if (!dateRange.value || !dateRange.value[0] || !dateRange.value[1]) {
    ElMessage.warning('请选择日期范围')
    return
  }
  
  // 验证日期范围
  if (dateRange.value[0] > dateRange.value[1]) {
    ElMessage.warning('开始日期不能大于结束日期')
    return
  }
  
  console.log('开始加载统计数据，日期范围:', dateRange.value[0], '至', dateRange.value[1])
  
  await Promise.all([
    loadRefundStats(),
    loadPassengerStats(),
    loadSalesTrend(),
    loadRevenueTrend(),
    loadTopTrainsBySales(),
    loadTopTrainsByRevenue()
  ])
}

// 重置
const handleReset = () => {
  initDateRange()
  // 等待日期范围初始化完成后再加载数据
  nextTick(() => {
    loadAllStatistics()
  })
}

onMounted(async () => {
  initDateRange()
  // 等待日期范围初始化和DOM更新完成
  await nextTick()
  await nextTick() // 双重nextTick确保日期选择器完全渲染
  await loadAllStatistics()
  
  // 窗口大小改变时重新渲染图表
  window.addEventListener('resize', () => {
    salesChart?.resize()
    revenueChart?.resize()
  })
})
</script>

<style scoped lang="scss">
.statistics {
  padding: 20px;

  .date-card {
    margin-bottom: 20px;
  }

  .stat-item {
    padding: 10px 0;
    display: flex;
    justify-content: space-between;
    border-bottom: 1px solid #eee;

    &:last-child {
      border-bottom: none;
    }

    .stat-label {
      color: #606266;
      font-size: 14px;
    }

    .stat-value {
      font-weight: bold;
      font-size: 16px;
      color: #303133;

      &.text-success {
        color: #67c23a;
      }
    }
  }

  .quick-stats {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: 10px 0;
  }
}
</style>
