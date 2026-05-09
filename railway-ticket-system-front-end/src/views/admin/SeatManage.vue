<template>
  <div class="seat-manage">
    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="选择车次">
          <el-select 
            v-model="searchForm.trainId" 
            placeholder="请选择车次" 
            clearable 
            filterable
            style="width: 200px"
          >
            <el-option
              v-for="train in trainList"
              :key="train.trainId"
              :label="`${train.trainNumber} (${train.startStation} → ${train.endStation})`"
              :value="train.trainId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="座位类型">
          <el-select v-model="searchForm.seatType" placeholder="全部类型" clearable style="width: 120px">
            <el-option label="商务座" value="商务座" />
            <el-option label="一等座" value="一等座" />
            <el-option label="二等座" value="二等座" />
          </el-select>
        </el-form-item>
        <el-form-item label="座位状态">
          <el-select v-model="searchForm.status" placeholder="全部状态" clearable style="width: 120px">
            <el-option label="可用" value="AVAILABLE" />
            <el-option label="已占用" value="OCCUPIED" />
            <el-option label="已锁定" value="LOCKED" />
            <el-option label="维修中" value="MAINTENANCE" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleSearch">搜索</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作按钮 -->
    <el-card class="table-card">
      <div class="toolbar">
        <el-button type="success" icon="Plus" @click="showGenerateDialog">为车次生成座位</el-button>
        <el-button type="danger" icon="Delete" @click="handleCleanupExpired" :loading="cleanupLoading">清理过期座位</el-button>
      </div>

      <!-- 数据表格 -->
      <el-table
        v-loading="loading"
        :data="tableData"
        stripe
        border
        max-height="500"
      >
        <el-table-column prop="seatId" label="ID" width="70" />
        <el-table-column prop="trainId" label="车次ID" width="80" />
        <el-table-column label="车次号" width="100">
          <template #default="{ row }">
            {{ getTrainNumber(row.trainId) }}
          </template>
        </el-table-column>
        <el-table-column prop="travelDate" label="乘车日期" width="110">
          <template #default="{ row }">
            {{ formatDate(row.travelDate) }}
          </template>
        </el-table-column>
        <el-table-column prop="carriageNumber" label="车厢" width="70" />
        <el-table-column prop="seatNumber" label="座位号" width="80" />
        <el-table-column prop="seatType" label="座位类型" width="100">
          <template #default="{ row }">
            <!-- @ts-ignore -->
            <el-tag :type="getSeatTypeTag(row.seatType)">{{ row.seatType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="priceCoefficient" label="价格系数" width="90" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <!-- @ts-ignore -->
            <el-tag :type="getStatusTag(row.status)">{{ getStatusLabel(row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button 
              v-if="row.status?.toUpperCase() === 'AVAILABLE'" 
              type="warning" 
              link 
              @click="handleDisable(row)"
            >
              禁用
            </el-button>
            <el-button 
              v-if="row.status?.toUpperCase() === 'MAINTENANCE'" 
              type="success" 
              link 
              @click="handleEnable(row)"
            >
              启用
            </el-button>
            <span v-if="row.status?.toUpperCase() === 'OCCUPIED' || row.status?.toUpperCase() === 'LOCKED'" class="disabled-text">
              {{ row.status?.toUpperCase() === 'OCCUPIED' ? '已售出' : '已锁定' }}
            </span>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <span class="page-info">共 {{ total }} 条 / {{ totalPages }} 页</span>
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[50, 100, 150]"
          :total="total"
          layout="sizes, prev, pager, next, jumper"
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </el-card>

    <!-- 生成座位对话框 -->
    <el-dialog
      v-model="generateDialogVisible"
      title="为车次生成座位"
      width="500px"
    >
      <el-form :model="generateForm" label-width="100px">
        <el-form-item label="选择车次" required>
          <el-select 
            v-model="generateForm.trainId" 
            placeholder="请选择车次" 
            filterable
            style="width: 100%"
          >
            <el-option
              v-for="train in trainList"
              :key="train.trainId"
              :label="`${train.trainNumber} (${train.startStation} → ${train.endStation})`"
              :value="train.trainId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="乘车日期" required>
          <el-date-picker
            v-model="generateForm.travelDate"
            type="date"
            placeholder="请选择日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-alert 
          title="座位生成说明" 
          type="info" 
          :closable="false"
          style="margin-top: 10px"
        >
          <template #default>
            将为该车次生成150个座位：<br/>
            • 商务座 30个（1-30号，系数2.0）<br/>
            • 一等座 50个（31-80号，系数1.5）<br/>
            • 二等座 70个（81-150号，系数1.0）
          </template>
        </el-alert>
      </el-form>
      <template #footer>
        <el-button @click="generateDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleGenerate" :loading="generateLoading">生成座位</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { seatApi } from '@/api/seat'
import { trainApi } from '@/api/train'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { Train } from '@/types'

const loading = ref(false)
const generateLoading = ref(false)
const cleanupLoading = ref(false)
const generateDialogVisible = ref(false)

const searchForm = reactive({
  trainId: undefined as number | undefined,
  seatType: '',
  status: ''
})

const generateForm = reactive({
  trainId: undefined as number | undefined,
  travelDate: ''
})

const pageNum = ref(1)
const pageSize = ref(50)
const total = ref(0)
const tableData = ref<any[]>([])
const trainList = ref<Train[]>([])

// 计算总页数
const totalPages = computed(() => {
  if (total.value === 0) return 1
  return Math.ceil(total.value / pageSize.value)
})

// 获取车次号
const getTrainNumber = (trainId: number) => {
  const train = trainList.value.find(t => t.trainId === trainId)
  return train?.trainNumber || '-'
}

// 格式化日期
const formatDate = (date: string) => {
  if (!date) return '-'
  return date.substring(0, 10)
}

type TagType = 'primary' | 'success' | 'warning' | 'info' | 'danger'

// 座位类型标签
const getSeatTypeTag = (type: string): TagType => {
  const map: Record<string, TagType> = {
    '商务座': 'danger',
    '一等座': 'warning',
    '二等座': 'success'
  }
  return map[type] || 'info'
}

// 状态标签
const getStatusTag = (status: string): TagType => {
  const map: Record<string, TagType> = {
    'AVAILABLE': 'success',
    'OCCUPIED': 'info',
    'LOCKED': 'warning',
    'MAINTENANCE': 'danger'
  }
  return map[status?.toUpperCase()] || 'info'
}

// 状态文本
const getStatusLabel = (status: string) => {
  const map: Record<string, string> = {
    'AVAILABLE': '可用',
    'OCCUPIED': '已占用',
    'LOCKED': '已锁定',
    'MAINTENANCE': '维修中'
  }
  return map[status?.toUpperCase()] || status
}

// 加载车次列表
const loadTrainList = async () => {
  try {
    const res = await trainApi.searchTrains({ pageNum: 1, pageSize: 1000, showAll: true })
    if (res.code === 200) {
      trainList.value = res.data.records
    }
  } catch (error) {
    console.error('加载车次列表失败', error)
  }
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const res = await seatApi.getSeatPage({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      trainId: searchForm.trainId,
      seatType: searchForm.seatType || undefined,
      status: searchForm.status || undefined
    })
    if (res.code === 200 && res.data) {
      tableData.value = res.data.records || []
      total.value = res.data.total || 0
    }
  } catch (error) {
    console.error('加载数据失败', error)
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  pageNum.value = 1
  loadData()
}

// 重置
const handleReset = () => {
  searchForm.trainId = undefined
  searchForm.seatType = ''
  searchForm.status = ''
  pageNum.value = 1
  loadData()
}

// 显示生成对话框
const showGenerateDialog = () => {
  generateForm.trainId = undefined
  generateForm.travelDate = ''
  generateDialogVisible.value = true
}

// 生成座位
const handleGenerate = async () => {
  if (!generateForm.trainId) {
    ElMessage.warning('请选择车次')
    return
  }
  if (!generateForm.travelDate) {
    ElMessage.warning('请选择乘车日期')
    return
  }
  
  generateLoading.value = true
  try {
    const res = await seatApi.generateSeatsForTrain(generateForm.trainId, generateForm.travelDate)
    if (res.code === 200) {
      ElMessage.success(res.message || '座位生成成功')
      generateDialogVisible.value = false
      loadData()
    } else {
      ElMessage.error(res.message || '生成失败')
    }
  } finally {
    generateLoading.value = false
  }
}

// 禁用座位
const handleDisable = (row: any) => {
  ElMessageBox.confirm('确定要将该座位设为维修中吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    const res = await seatApi.updateSeatStatus(row.seatId, 'MAINTENANCE')
    if (res.code === 200) {
      ElMessage.success('座位已禁用')
      loadData()
    }
  }).catch(() => {})
}

// 启用座位
const handleEnable = (row: any) => {
  ElMessageBox.confirm('确定要启用该座位吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    const res = await seatApi.updateSeatStatus(row.seatId, 'AVAILABLE')
    if (res.code === 200) {
      ElMessage.success('座位已启用')
      loadData()
    }
  }).catch(() => {})
}

// 清理过期座位
const handleCleanupExpired = () => {
  ElMessageBox.confirm(
    '确定要清理已发车车次的过期座位数据吗？\n此操作将删除今天之前已发车车次的所有座位记录，且不可恢复。',
    '警告',
    {
      type: 'warning',
      confirmButtonText: '确认清理',
      cancelButtonText: '取消'
    }
  ).then(async () => {
    cleanupLoading.value = true
    try {
      const res = await seatApi.cleanupExpiredSeats()
      if (res.code === 200) {
        ElMessage.success(res.message || '清理成功')
        loadData()
      } else {
        ElMessage.error(res.message || '清理失败')
      }
    } catch (error: any) {
      ElMessage.error(error.message || '清理异常')
    } finally {
      cleanupLoading.value = false
    }
  }).catch(() => {})
}

onMounted(() => {
  loadTrainList()
  loadData()
})
</script>

<style scoped lang="scss">
.seat-manage {
  padding: 20px;

  .search-card {
    margin-bottom: 20px;
  }

  .toolbar {
    margin-bottom: 15px;
  }

  .pagination {
    margin-top: 20px;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    
    .page-info {
      margin-right: 15px;
      color: #606266;
      font-size: 14px;
    }
  }

  .disabled-text {
    color: #909399;
    font-size: 12px;
  }
}
</style>
