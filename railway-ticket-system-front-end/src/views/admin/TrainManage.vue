<template>
  <div class="train-manage">
    <!-- 搜索表单 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="车次号">
          <el-input v-model="searchForm.trainNumber" placeholder="请输入车次号" clearable />
        </el-form-item>
        <el-form-item label="车次类型">
          <el-select v-model="searchForm.trainType" placeholder="请选择" clearable>
            <el-option label="高铁" value="高铁" />
            <el-option label="动车" value="动车" />
            <el-option label="快速" value="快速" />
            <el-option label="直达" value="直达" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleSearch">搜索</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作按钮 -->
    <el-card>
      <div class="action-buttons">
        <el-button type="primary" icon="Plus" @click="handleAdd">新增车次</el-button>
        <el-button type="danger" icon="Delete" :disabled="selectedIds.length === 0" @click="handleBatchDelete">
          批量删除
        </el-button>
      </div>

      <!-- 表格 -->
      <el-table
        :data="tableData"
        @selection-change="handleSelectionChange"
        v-loading="loading"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="trainNumber" label="车次号" width="120" />
        <el-table-column prop="trainType" label="类型" width="100" />
        <el-table-column prop="startStation" label="始发站" />
        <el-table-column prop="endStation" label="终点站" />
        <el-table-column prop="departureTime" label="发车时间" width="120" />
        <el-table-column prop="arrivalTime" label="到达时间" width="120" />
        <el-table-column prop="basePrice" label="基础票价" width="100">
          <template #default="{ row }">
            ¥{{ row.basePrice }}
          </template>
        </el-table-column>
        <el-table-column prop="totalSeats" label="总座位" width="100" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '正常' : '停运' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
            <el-button link @click="handleToggleStatus(row)">
              {{ row.status === 1 ? '停运' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="loadData"
        @current-change="loadData"
        class="pagination"
      />
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="车次号" prop="trainNumber">
          <el-input v-model="form.trainNumber" placeholder="如：G1" />
        </el-form-item>
        <el-form-item label="车次类型" prop="trainType">
          <el-select v-model="form.trainType" placeholder="请选择" style="width: 100%">
            <el-option label="高铁" value="高铁" />
            <el-option label="动车" value="动车" />
            <el-option label="快速" value="快速" />
            <el-option label="直达" value="直达" />
          </el-select>
        </el-form-item>
        <el-form-item label="始发站" prop="startStation">
          <el-input v-model="form.startStation" disabled />
          <span style="color: #909399; font-size: 12px; margin-left: 10px;">（固定为南宁站）</span>
        </el-form-item>
        <el-form-item label="终点站" prop="endStation">
          <el-input v-model="form.endStation" placeholder="请输入终点站" />
        </el-form-item>
        <el-form-item label="发车时间" prop="departureTime">
          <el-time-picker v-model="form.departureTime" format="HH:mm:ss" value-format="HH:mm:ss" style="width: 100%" />
        </el-form-item>
        <el-form-item label="到达时间" prop="arrivalTime">
          <el-time-picker v-model="form.arrivalTime" format="HH:mm:ss" value-format="HH:mm:ss" style="width: 100%" />
        </el-form-item>
        <el-form-item label="基础票价" prop="basePrice">
          <el-input-number v-model="form.basePrice" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="总座位数" prop="totalSeats">
          <el-input-number v-model="form.totalSeats" :min="0" />
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
import { trainApi } from '@/api/train'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import type { Train } from '@/types'

const loading = ref(false)
const submitLoading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('新增车次')
const formRef = ref<FormInstance>()

const searchForm = reactive({
  trainNumber: '',
  trainType: ''
})

const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const tableData = ref<Train[]>([])
const selectedIds = ref<number[]>([])

const form = reactive<Partial<Train>>({
  trainNumber: '',
  trainType: '',
  startStation: '南宁站',
  endStation: '',
  departureTime: '',
  arrivalTime: '',
  basePrice: 0,
  totalSeats: 0
})

const formRules: FormRules = {
  trainNumber: [{ required: true, message: '请输入车次号', trigger: 'blur' }],
  trainType: [{ required: true, message: '请选择车次类型', trigger: 'change' }],
  startStation: [{ required: true, message: '请输入始发站', trigger: 'blur' }],
  endStation: [{ required: true, message: '请输入终点站', trigger: 'blur' }],
  departureTime: [{ required: true, message: '请选择发车时间', trigger: 'change' }],
  arrivalTime: [{ required: true, message: '请选择到达时间', trigger: 'change' }],
  basePrice: [{ required: true, message: '请输入基础票价', trigger: 'blur' }]
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const res = await trainApi.searchTrains({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      showAll: true,  // 管理端显示所有车次（包括停运的）
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
  searchForm.trainNumber = ''
  searchForm.trainType = ''
  handleSearch()
}

// 新增
const handleAdd = () => {
  dialogTitle.value = '新增车次'
  Object.assign(form, {
    trainId: undefined,
    trainNumber: '',
    trainType: '',
    startStation: '南宁站',
    endStation: '',
    departureTime: '',
    arrivalTime: '',
    basePrice: 0,
    totalSeats: 0
  })
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row: Train) => {
  dialogTitle.value = '编辑车次'
  Object.assign(form, row)
  form.startStation = '南宁站'  // 确保始发站为南宁站
  dialogVisible.value = true
}

// 提交
const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        const res = form.trainId 
          ? await trainApi.updateTrain(form as Train)
          : await trainApi.addTrain(form)
        
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
const handleDelete = (row: Train) => {
  ElMessageBox.confirm('确定要删除该车次吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    const res = await trainApi.deleteTrain(row.trainId)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  }).catch(() => {})
}

// 批量删除
const handleBatchDelete = () => {
  ElMessageBox.confirm(`确定要删除选中的 ${selectedIds.value.length} 条记录吗？`, '提示', {
    type: 'warning'
  }).then(async () => {
    const res = await trainApi.batchDeleteTrains(selectedIds.value)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  }).catch(() => {})
}

// 切换状态
const handleToggleStatus = async (row: Train) => {
  const newStatus = row.status === 1 ? 0 : 1
  const res = await trainApi.updateTrainStatus(row.trainId, newStatus)
  if (res.code === 200) {
    ElMessage.success('操作成功')
    loadData()
  }
}

// 选择变化
const handleSelectionChange = (selection: Train[]) => {
  selectedIds.value = selection.map(item => item.trainId)
}

onMounted(() => {
  loadData()
})
</script>

<style scoped lang="scss">
.train-manage {
  padding: 20px;

  .search-card {
    margin-bottom: 20px;
  }

  .action-buttons {
    margin-bottom: 20px;
  }

  .pagination {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
  }
}
</style>
