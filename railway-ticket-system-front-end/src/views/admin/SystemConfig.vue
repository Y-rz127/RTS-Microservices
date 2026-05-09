<template>
  <div class="system-config">
    <!-- 搜索区域 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="配置键">
          <el-input v-model="searchForm.configKey" placeholder="请输入配置键" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="配置类型">
          <el-select v-model="searchForm.configType" placeholder="全部类型" clearable style="width: 150px">
            <el-option label="系统参数" value="SYSTEM" />
            <el-option label="业务参数" value="BUSINESS" />
            <el-option label="安全配置" value="SECURITY" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleSearch">搜索</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作按钮和表格 -->
    <el-card class="table-card">
      <div class="toolbar">
        <el-button type="primary" icon="Plus" @click="handleAdd">新增配置</el-button>
      </div>

      <el-table v-loading="loading" :data="tableData" stripe border>
        <el-table-column prop="configId" label="ID" width="70" />
        <el-table-column prop="configKey" label="配置键" width="180" show-overflow-tooltip />
        <el-table-column prop="configValue" label="配置值" min-width="200" show-overflow-tooltip />
        <el-table-column prop="configType" label="类型" width="100">
          <template #default="{ row }">
            <!-- @ts-ignore -->
            <el-tag :type="getTypeTag(row.configType)">{{ row.configType || '-' }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="150" show-overflow-tooltip />
        <el-table-column prop="isSystem" label="系统内置" width="90">
          <template #default="{ row }">
            <el-tag :type="row.isSystem === 1 ? 'warning' : 'info'">
              {{ row.isSystem === 1 ? '是' : '否' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" link @click="handleDelete(row)" :disabled="row.isSystem === 1">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadData"
          @current-change="loadData"
        />
      </div>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="550px" @close="resetForm">
      <el-form ref="formRef" :model="form" :rules="formRules" label-width="100px">
        <el-form-item label="配置键" prop="configKey">
          <el-input v-model="form.configKey" placeholder="如：max_ticket_per_order" :disabled="!!form.configId" />
        </el-form-item>
        <el-form-item label="配置值" prop="configValue">
          <el-input v-model="form.configValue" placeholder="请输入配置值" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="配置类型" prop="configType">
          <el-select v-model="form.configType" placeholder="请选择类型" style="width: 100%">
            <el-option label="系统参数" value="SYSTEM" />
            <el-option label="业务参数" value="BUSINESS" />
            <el-option label="安全配置" value="SECURITY" />
          </el-select>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" active-text="启用" inactive-text="禁用" />
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
import { configApi, type SystemConfig } from '@/api/config'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'

const loading = ref(false)
const submitLoading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('新增配置')
const formRef = ref<FormInstance>()

const searchForm = reactive({ configKey: '', configType: '' })
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const tableData = ref<SystemConfig[]>([])

const form = reactive<SystemConfig>({
  configId: undefined,
  configKey: '',
  configValue: '',
  configType: 'SYSTEM',
  description: '',
  status: 1
})

const formRules: FormRules = {
  configKey: [{ required: true, message: '请输入配置键', trigger: 'blur' }],
  configValue: [{ required: true, message: '请输入配置值', trigger: 'blur' }]
}

type TagType = 'primary' | 'success' | 'warning' | 'info' | 'danger'

const getTypeTag = (type: string): TagType => {
  const map: Record<string, TagType> = { SYSTEM: 'primary', BUSINESS: 'success', SECURITY: 'warning' }
  return map[type] || 'info'
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await configApi.getConfigPage({
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      configKey: searchForm.configKey || undefined,
      configType: searchForm.configType || undefined
    })
    if (res.code === 200) {
      tableData.value = res.data.records
      total.value = res.data.total
    }
  } finally {
    loading.value = false
  }
}

const handleSearch = () => { pageNum.value = 1; loadData() }
const handleReset = () => { searchForm.configKey = ''; searchForm.configType = ''; pageNum.value = 1; loadData() }

const handleAdd = () => {
  dialogTitle.value = '新增配置'
  resetForm()
  dialogVisible.value = true
}

const handleEdit = (row: SystemConfig) => {
  dialogTitle.value = '编辑配置'
  Object.assign(form, row)
  dialogVisible.value = true
}

const resetForm = () => {
  form.configId = undefined
  form.configKey = ''
  form.configValue = ''
  form.configType = 'SYSTEM'
  form.description = ''
  form.status = 1
  formRef.value?.resetFields()
}

const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        const res = form.configId
          ? await configApi.updateConfig(form)
          : await configApi.addConfig(form)
        if (res.code === 200) {
          ElMessage.success('操作成功')
          dialogVisible.value = false
          loadData()
        } else {
          ElMessage.error(res.message || '操作失败')
        }
      } finally {
        submitLoading.value = false
      }
    }
  })
}

const handleDelete = (row: SystemConfig) => {
  ElMessageBox.confirm('确定要删除该配置吗？', '提示', { type: 'warning' })
    .then(async () => {
      const res = await configApi.deleteConfig(row.configId!)
      if (res.code === 200) {
        ElMessage.success('删除成功')
        loadData()
      } else {
        ElMessage.error(res.message || '删除失败')
      }
    }).catch(() => {})
}

onMounted(() => loadData())
</script>

<style scoped lang="scss">
.system-config {
  padding: 20px;
  .search-card { margin-bottom: 20px; }
  .toolbar { margin-bottom: 15px; }
  .pagination { margin-top: 20px; display: flex; justify-content: flex-end; }
}
</style>
