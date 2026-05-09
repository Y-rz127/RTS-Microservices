<template>
  <div class="dashboard">
    <!-- 数据卡片 -->
    <el-row :gutter="20" class="stats-cards">
      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: #409eff">
              <el-icon size="30"><Tickets /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ dashboardData.todaySales || 0 }}</div>
              <div class="stat-label">今日售票</div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: #67c23a">
              <el-icon size="30"><Money /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">¥{{ dashboardData.todayRevenue || 0 }}</div>
              <div class="stat-label">今日收入</div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background: #e6a23c">
              <el-icon size="30"><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ dashboardData.totalSales || 0 }}</div>
              <div class="stat-label">总售票数</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表区域 -->
    <el-row :gutter="20" class="charts-section">
      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>售票趋势</span>
              <el-radio-group v-model="salesDays" size="small" @change="loadSalesTrend">
                <el-radio-button :label="7">近7天</el-radio-button>
                <el-radio-button :label="30">近30天</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          <div ref="salesChartRef" style="height: 300px"></div>
        </el-card>
      </el-col>

      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>收入趋势</span>
              <el-radio-group v-model="revenueDays" size="small" @change="loadRevenueTrend">
                <el-radio-button :label="7">近7天</el-radio-button>
                <el-radio-button :label="30">近30天</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          <div ref="revenueChartRef" style="height: 300px"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 快捷操作 -->
    <el-row :gutter="20">
      <el-col :span="24">
        <el-card>
          <template #header>快捷操作</template>
          <div class="quick-actions">
            <el-button type="success" icon="Search" @click="handleQueryOrder">
              查询订单
            </el-button>
            <el-button type="warning" icon="TrendCharts" @click="goTo('/admin/statistics')">
              统计报表
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 查询订单对话框 -->
    <el-dialog v-model="queryDialogVisible" title="查询订单" width="500px">
      <el-form :model="queryForm" label-width="100px">
        <el-form-item label="查询类型">
          <el-radio-group v-model="queryForm.type">
            <el-radio label="passengerName">乘客姓名</el-radio>
            <el-radio label="username">用户名</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item :label="queryForm.type === 'passengerName' ? '乘客姓名' : '用户名'">
          <el-input
            v-model="queryForm.value"
            :placeholder="queryForm.type === 'passengerName' ? '请输入乘客姓名' : '请输入用户名'"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="queryDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmQuery">查询</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { statisticsApi } from '@/api/statistics'
import * as echarts from 'echarts'
import type { EChartsOption } from 'echarts'

const router = useRouter()

const dashboardData = ref<any>({})
const salesDays = ref(7)
const revenueDays = ref(7)

const salesChartRef = ref<HTMLElement>()
const revenueChartRef = ref<HTMLElement>()

let salesChart: echarts.ECharts | null = null
let revenueChart: echarts.ECharts | null = null

// 查询订单对话框
const queryDialogVisible = ref(false)
const queryForm = ref({
  type: 'passengerName',
  value: ''
})

// 加载数据概览
const loadDashboard = async () => {
  try {
    const res = await statisticsApi.getDashboard()
    if (res.code === 200) {
      dashboardData.value = res.data
    }
  } catch (error) {
    console.error('加载数据失败', error)
  }
}

// 加载售票趋势
const loadSalesTrend = async () => {
  try {
    const res = await statisticsApi.getSalesTrend(salesDays.value)
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
    const res = await statisticsApi.getRevenueTrend(revenueDays.value)
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
        itemStyle: { color: '#409eff' }
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

const goTo = (path: string) => {
  router.push(path)
}

// 打开查询订单对话框
const handleQueryOrder = () => {
  queryForm.value = {
    type: 'passengerName',
    value: ''
  }
  queryDialogVisible.value = true
}

// 确认查询
const confirmQuery = () => {
  if (!queryForm.value.value) {
    ElMessage.warning('请输入查询内容')
    return
  }
  
  // 跳转到订单管理页面并传递查询参数
  queryDialogVisible.value = false
  router.push({
    path: '/admin/order',
    query: {
      type: queryForm.value.type,
      value: queryForm.value.value
    }
  })
}

onMounted(async () => {
  await loadDashboard()
  await nextTick()
  await loadSalesTrend()
  await loadRevenueTrend()

  // 窗口大小改变时重新渲染图表
  window.addEventListener('resize', () => {
    salesChart?.resize()
    revenueChart?.resize()
  })
})
</script>

<style scoped lang="scss">
.dashboard {
  padding: 20px;

  .stats-cards {
    margin-bottom: 20px;

    .stat-card {
      .stat-content {
        display: flex;
        align-items: center;
        gap: 20px;

        .stat-icon {
          width: 60px;
          height: 60px;
          border-radius: 10px;
          display: flex;
          align-items: center;
          justify-content: center;
          color: #fff;
        }

        .stat-info {
          .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #303133;
            margin-bottom: 5px;
          }

          .stat-label {
            font-size: 14px;
            color: #909399;
          }
        }
      }
    }
  }

  .charts-section {
    margin-bottom: 20px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }

  .quick-actions {
    display: flex;
    gap: 10px;
  }
}
</style>
