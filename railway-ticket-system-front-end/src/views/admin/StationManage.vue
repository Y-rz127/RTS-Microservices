<template>
  <div class="station-manage">
    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="车站名称">
          <el-input v-model="searchForm.stationName" placeholder="请输入车站名称" clearable />
        </el-form-item>
        <el-form-item label="所在城市">
          <el-input v-model="searchForm.city" placeholder="请输入城市" clearable />
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
        <el-button type="primary" icon="Plus" @click="handleAdd">新增车站</el-button>
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
        <el-table-column prop="stationId" label="ID" width="80" />
        <el-table-column prop="stationName" label="车站名称" width="150" />
        <el-table-column prop="city" label="城市" width="100" />
        <el-table-column prop="province" label="省份" width="120" />
        <el-table-column prop="stationLevel" label="车站等级" width="100">
          <template #default="{ row }">
            <!-- @ts-ignore -->
            <el-tag :type="getLevelTagType(row.stationLevel)">{{ row.stationLevel || '未设置' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="address" label="详细地址" min-width="180" show-overflow-tooltip />
        <el-table-column prop="contactPhone" label="联系电话" width="140" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '启用' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
            <el-button 
              :type="row.status === 1 ? 'warning' : 'success'" 
              link 
              @click="handleToggleStatus(row)"
            >
              {{ row.status === 1 ? '停用' : '启用' }}
            </el-button>
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
        <el-form-item label="车站名称" prop="stationName">
          <el-input v-model="form.stationName" placeholder="请输入车站名称" />
        </el-form-item>
        <el-form-item label="所在城市" prop="city">
          <el-input v-model="form.city" placeholder="请输入所在城市" />
        </el-form-item>
        <el-form-item label="所在省份" prop="province">
          <el-input v-model="form.province" placeholder="请输入所在省份" />
        </el-form-item>
        <el-form-item label="车站等级" prop="stationLevel">
          <el-select v-model="form.stationLevel" placeholder="请选择车站等级" style="width: 100%">
            <el-option label="特等站" value="特等站" />
            <el-option label="一等站" value="一等站" />
            <el-option label="二等站" value="二等站" />
            <el-option label="三等站" value="三等站" />
          </el-select>
        </el-form-item>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址" />
        </el-form-item>
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input v-model="form.contactPhone" placeholder="请输入联系电话" />
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
import { stationApi } from '@/api/station'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import type { Station } from '@/types'

const loading = ref(false)
const submitLoading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('新增车站')
const formRef = ref<FormInstance>()

const searchForm = reactive({
  stationName: '',
  city: ''
})

const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const tableData = ref<Station[]>([])
const selectedIds = ref<number[]>([])

const form = reactive<Partial<Station>>({
  stationId: undefined,
  stationName: '',
  city: '',
  province: '',
  stationLevel: '',
  address: '',
  contactPhone: ''
})

const formRules: FormRules = {
  stationName: [{ required: true, message: '请输入车站名称', trigger: 'blur' }],
  city: [{ required: true, message: '请输入所在城市', trigger: 'blur' }],
  province: [{ required: true, message: '请输入所在省份', trigger: 'blur' }]
}

type TagType = 'primary' | 'success' | 'warning' | 'info' | 'danger'

// 获取车站等级标签类型
const getLevelTagType = (level: string): TagType => {
  const typeMap: Record<string, TagType> = {
    '特等站': 'danger',
    '一等站': 'warning',
    '二等站': 'success',
    '三等站': 'info'
  }
  return typeMap[level] || 'info'
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const res = await stationApi.getStationPage({
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
  searchForm.stationName = ''
  searchForm.city = ''
  pageNum.value = 1
  loadData()
}

// 选择变化
const handleSelectionChange = (selection: Station[]) => {
  selectedIds.value = selection.map(item => item.stationId)
}

// 新增
const handleAdd = () => {
  dialogTitle.value = '新增车站'
  resetForm()
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row: Station) => {
  dialogTitle.value = '编辑车站'
  Object.assign(form, row)
  dialogVisible.value = true
}

// 重置表单
const resetForm = () => {
  form.stationId = undefined
  form.stationName = ''
  form.city = ''
  form.province = ''
  form.stationLevel = ''
  form.address = ''
  form.contactPhone = ''
  formRef.value?.resetFields()
}

// 提交
const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        const res = form.stationId 
          ? await stationApi.updateStation(form as Station)
          : await stationApi.addStation(form)
        
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
const handleDelete = (row: Station) => {
  ElMessageBox.confirm('确定要删除该车站吗？删除后可能影响相关路线数据', '提示', {
    type: 'warning'
  }).then(async () => {
    const res = await stationApi.deleteStation(row.stationId)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadData()
    }
  }).catch(() => {})
}

// 批量删除
const handleBatchDelete = () => {
  ElMessageBox.confirm(`确定要删除选中的 ${selectedIds.value.length} 个车站吗？`, '提示', {
    type: 'warning'
  }).then(async () => {
    // 逐个删除
    let successCount = 0
    for (const id of selectedIds.value) {
      try {
        const res = await stationApi.deleteStation(id)
        if (res.code === 200) successCount++
      } catch (e) {
        console.error('删除失败', e)
      }
    }
    ElMessage.success(`成功删除 ${successCount} 个车站`)
    loadData()
  }).catch(() => {})
}

// 切换状态
const handleToggleStatus = async (row: Station) => {
  const newStatus = row.status === 1 ? 0 : 1
  const action = newStatus === 1 ? '启用' : '停用'
  
  ElMessageBox.confirm(`确定要${action}该车站吗？`, '提示', {
    type: 'warning'
  }).then(async () => {
    const res = await stationApi.updateStationStatus(row.stationId, newStatus)
    if (res.code === 200) {
      ElMessage.success(`${action}成功`)
      loadData()
    }
  }).catch(() => {})
}

onMounted(() => {
  loadData()
})
</script>

<style scoped lang="scss">
.station-manage {
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
}
</style>
