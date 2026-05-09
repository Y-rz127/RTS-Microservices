<template>
  <div class="route-manage">
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
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleSearch">搜索</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作按钮 -->
    <el-card class="table-card">
      <div class="toolbar">
        <el-button type="primary" icon="Plus" @click="handleAdd">新增途经站</el-button>
        <el-button type="danger" icon="Delete" :disabled="selectedIds.length === 0" @click="handleBatchDelete">
          批量删除
        </el-button>
      </div>

      <!-- 数据表格 -->
      <el-table
        v-loading="loading"
        :data="tableData"
        @selection-change="handleSelectionChange"
        stripe
        border
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="routeId" label="ID" width="70" />
        <el-table-column prop="trainId" label="车次ID" width="80" />
        <el-table-column label="车次号" width="100">
          <template #default="{ row }">
            {{ getTrainNumber(row.trainId) }}
          </template>
        </el-table-column>
        <el-table-column prop="stopOrder" label="站序" width="70">
          <template #default="{ row }">
            <el-tag type="info">{{ row.stopOrder }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="stationName" label="站点名称" width="120" />
        <el-table-column prop="arrivalTime" label="到达时间" width="100">
          <template #default="{ row }">
            {{ row.arrivalTime || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="departureTime" label="发车时间" width="100">
          <template #default="{ row }">
            {{ row.departureTime || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="stopDuration" label="停留(分)" width="90">
          <template #default="{ row }">
            {{ row.stopDuration || 0 }}
          </template>
        </el-table-column>
        <el-table-column prop="distanceFromStart" label="距起点(km)" width="110">
          <template #default="{ row }">
            {{ row.distanceFromStart || 0 }}
          </template>
        </el-table-column>
        <el-table-column prop="additionalPrice" label="附加票价" width="100">
          <template #default="{ row }">
            <span class="price">¥{{ row.additionalPrice || 0 }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @close="resetForm"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="选择车次" prop="trainId">
          <el-select 
            v-model="form.trainId" 
            placeholder="请选择车次" 
            filterable
            style="width: 100%"
            :disabled="!!form.routeId"
          >
            <el-option
              v-for="train in trainList"
              :key="train.trainId"
              :label="`${train.trainNumber} (${train.startStation} → ${train.endStation})`"
              :value="train.trainId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="选择站点" prop="stationId">
          <el-select 
            v-model="form.stationId" 
            placeholder="请选择站点" 
            filterable
            style="width: 100%"
            @change="handleStationChange"
          >
            <el-option
              v-for="station in stationList"
              :key="station.stationId"
              :label="`${station.stationName} (${station.city})`"
              :value="station.stationId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="站点名称" prop="stationName">
          <el-input v-model="form.stationName" placeholder="选择站点后自动填充" />
        </el-form-item>
        <el-form-item label="站序" prop="stopOrder">
          <el-input-number v-model="form.stopOrder" :min="1" :max="99" style="width: 100%" />
        </el-form-item>
        <el-form-item label="到达时间" prop="arrivalTime">
          <el-time-picker v-model="form.arrivalTime" format="HH:mm:ss" value-format="HH:mm:ss" style="width: 100%" placeholder="起点站无需填写" />
        </el-form-item>
        <el-form-item label="发车时间" prop="departureTime">
          <el-time-picker v-model="form.departureTime" format="HH:mm:ss" value-format="HH:mm:ss" style="width: 100%" placeholder="终点站无需填写" />
        </el-form-item>
        <el-form-item label="停留时长" prop="stopDuration">
          <el-input-number v-model="form.stopDuration" :min="0" :max="999" style="width: 100%" />
          <span class="unit">分钟</span>
        </el-form-item>
        <el-form-item label="距起点距离" prop="distanceFromStart">
          <el-input-number v-model="form.distanceFromStart" :min="0" :precision="2" style="width: 100%" />
          <span class="unit">公里</span>
        </el-form-item>
        <el-form-item label="附加票价" prop="additionalPrice">
          <el-input-number v-model="form.additionalPrice" :min="0" :precision="2" style="width: 100%" />
          <span class="unit">元</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { routeApi } from '@/api/route'
import { trainApi } from '@/api/train'
import { stationApi } from '@/api/station'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import type { Route, Train, Station } from '@/types'

const loading = ref(false)
const submitLoading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('新增途经站')
const formRef = ref<FormInstance>()

const searchForm = reactive({
  trainId: undefined as number | undefined
})

const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const tableData = ref<Route[]>([])
const selectedIds = ref<number[]>([])
const trainList = ref<Train[]>([])
const stationList = ref<Station[]>([])

const form = reactive<Partial<Route>>({
  routeId: undefined,
  trainId: undefined,
  stationId: undefined,
  stationName: '',
  arrivalTime: '',
  departureTime: '',
  stopOrder: 1,
  stopDuration: 0,
  distanceFromStart: 0,
  additionalPrice: 0
})

const formRules: FormRules = {
  trainId: [{ required: true, message: '请选择车次', trigger: 'change' }],
  stationId: [{ required: true, message: '请选择站点', trigger: 'change' }],
  stationName: [{ required: true, message: '请输入站点名称', trigger: 'blur' }],
  stopOrder: [{ required: true, message: '请输入站序', trigger: 'blur' }]
}

// 获取车次号
const getTrainNumber = (trainId: number) => {
  const train = trainList.value.find(t => t.trainId === trainId)
  return train?.trainNumber || '-'
}

// 站点选择变化
const handleStationChange = (stationId: number) => {
  const station = stationList.value.find(s => s.stationId === stationId)
  if (station) {
    form.stationName = station.stationName
  }
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

// 加载车站列表
const loadStationList = async () => {
  try {
    const res = await stationApi.getAllStations()
    if (res.code === 200) {
      stationList.value = res.data
    }
  } catch (error) {
    console.error('加载车站列表失败', error)
  }
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const res = await routeApi.getRoutePage({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      ...searchForm
    })
    if (res.code === 200) {
      tableData.value = res.data.records
      total.value = res.data.total
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
  pageNum.value = 1
  loadData()
}

// 选择变化
const handleSelectionChange = (selection: Route[]) => {
  selectedIds.value = selection.map(item => item.routeId)
}

// 新增
const handleAdd = () => {
  dialogTitle.value = '新增途经站'
  resetForm()
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row: Route) => {
  dialogTitle.value = '编辑途经站'
  Object.assign(form, row)
  dialogVisible.value = true
}

// 重置表单
const resetForm = () => {
  form.routeId = undefined
  form.trainId = undefined
  form.stationId = undefined
  form.stationName = ''
  form.arrivalTime = ''
  form.departureTime = ''
  form.stopOrder = 1
  form.stopDuration = 0
  form.distanceFromStart = 0
  form.additionalPrice = 0
  formRef.value?.resetFields()
}

// 提交
const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        const res = form.routeId 
          ? await routeApi.updateRoute(form as Route)
          : await routeApi.addRoute(form)
        
        if (res.code === 200) {
          ElMessage.success('操作成功')
          dialogVisible.value = false
          loadData()
        }
      } finally {
        submitLoading.value = false
      }
    }
  })
}

// 删除
const handleDelete = (row: Route) => {
  ElMessageBox.confirm('确定要删除该途经站吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    const res = await routeApi.deleteRoute(row.routeId)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  }).catch(() => {})
}

// 批量删除
const handleBatchDelete = () => {
  ElMessageBox.confirm(`确定要删除选中的 ${selectedIds.value.length} 个途经站吗？`, '提示', {
    type: 'warning'
  }).then(async () => {
    let successCount = 0
    for (const id of selectedIds.value) {
      try {
        const res = await routeApi.deleteRoute(id)
        if (res.code === 200) successCount++
      } catch (e) {
        console.error('删除失败', e)
      }
    }
    ElMessage.success(`成功删除 ${successCount} 个途经站`)
    loadData()
  }).catch(() => {})
}

onMounted(() => {
  loadTrainList()
  loadStationList()
  loadData()
})
</script>

<style scoped lang="scss">
.route-manage {
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
    justify-content: flex-end;
  }

  .price {
    color: #f56c6c;
    font-weight: bold;
  }

  .unit {
    margin-left: 8px;
    color: #909399;
  }
}
</style>
