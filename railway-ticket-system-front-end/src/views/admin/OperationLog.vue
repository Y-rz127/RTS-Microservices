<template>
  <div class="operation-log">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="操作类型">
          <el-select v-model="searchForm.operation" placeholder="全部类型" clearable style="width: 120px">
            <el-option label="登录" value="登录" />
            <el-option label="登出" value="登出" />
            <el-option label="新增" value="新增" />
            <el-option label="修改" value="修改" />
            <el-option label="删除" value="删除" />
            <el-option label="查询" value="查询" />
          </el-select>
        </el-form-item>
        <el-form-item label="模块">
          <el-select v-model="searchForm.module" placeholder="全部模块" clearable style="width: 120px">
            <el-option label="用户管理" value="用户管理" />
            <el-option label="车次管理" value="车次管理" />
            <el-option label="车站管理" value="车站管理" />
            <el-option label="订单管理" value="订单管理" />
            <el-option label="售票管理" value="售票管理" />
          </el-select>
        </el-form-item>
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            style="width: 240px"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleSearch">查询</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table v-loading="loading" :data="logList" stripe border>
        <el-table-column prop="logId" label="ID" width="70" />
        <el-table-column prop="username" label="操作用户" width="100" />
        <el-table-column prop="operation" label="操作类型" width="90">
          <template #default="{ row }">
            <!-- @ts-ignore -->
            <el-tag :type="getOperationTag(row.operation)">{{ row.operation }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="module" label="模块" width="100" />
        <el-table-column prop="method" label="方法" width="180" show-overflow-tooltip />
        <el-table-column prop="params" label="请求参数" min-width="200" show-overflow-tooltip />
        <el-table-column prop="ipAddress" label="IP地址" width="130" />
        <el-table-column prop="executionTime" label="耗时(ms)" width="90" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 'SUCCESS' ? 'success' : 'danger'">
              {{ row.status === 'SUCCESS' ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="操作时间" width="170">
          <template #default="{ row }">{{ formatDate(row.createdAt) }}</template>
        </el-table-column>
        <el-table-column label="操作" width="80" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleView(row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

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

    <!-- 详情对话框 -->
    <el-dialog v-model="detailVisible" title="操作日志详情" width="700px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="日志ID">{{ currentLog.logId }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ currentLog.userId }}</el-descriptions-item>
        <el-descriptions-item label="用户名">{{ currentLog.username }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">
          <!-- @ts-ignore -->
          <el-tag :type="getOperationTag(currentLog.operation)">{{ currentLog.operation }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="模块">{{ currentLog.module }}</el-descriptions-item>
        <el-descriptions-item label="方法">{{ currentLog.method }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ currentLog.ipAddress }}</el-descriptions-item>
        <el-descriptions-item label="执行耗时">{{ currentLog.executionTime }} ms</el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="currentLog.status === 'SUCCESS' ? 'success' : 'danger'">
            {{ currentLog.status === 'SUCCESS' ? '成功' : '失败' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作时间">{{ formatDate(currentLog.createdAt) }}</el-descriptions-item>
        <el-descriptions-item label="请求参数" :span="2">
          <pre style="margin: 0; white-space: pre-wrap; max-height: 150px; overflow: auto">{{ currentLog.params || '-' }}</pre>
        </el-descriptions-item>
        <el-descriptions-item label="返回结果" :span="2" v-if="currentLog.result">
          <pre style="margin: 0; white-space: pre-wrap; max-height: 150px; overflow: auto">{{ currentLog.result }}</pre>
        </el-descriptions-item>
        <el-descriptions-item label="错误信息" :span="2" v-if="currentLog.errorMsg">
          <pre style="margin: 0; white-space: pre-wrap; color: #f56c6c">{{ currentLog.errorMsg }}</pre>
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { logApi } from '@/api/log'

const loading = ref(false)
const detailVisible = ref(false)

const searchForm = reactive({
  operation: '',
  module: '',
  dateRange: null as any
})

const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const logList = ref<any[]>([])
const currentLog = ref<any>({})

const formatDate = (date: string) => {
  if (!date) return '-'
  return date.replace('T', ' ').substring(0, 19)
}

type TagType = 'primary' | 'success' | 'warning' | 'info' | 'danger'

const getOperationTag = (operation: string): TagType => {
  const map: Record<string, TagType> = {
    '登录': 'success',
    '登出': 'info',
    '新增': 'primary',
    '修改': 'warning',
    '删除': 'danger',
    '查询': 'info'
  }
  return map[operation] || 'info'
}

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    const params: any = {
      pageNum: pageNum.value,
      pageSize: pageSize.value
    }
    if (searchForm.operation) params.operation = searchForm.operation
    if (searchForm.module) params.module = searchForm.module
    if (searchForm.dateRange?.length === 2) {
      params.startTime = searchForm.dateRange[0]
      params.endTime = searchForm.dateRange[1]
    }
    
    const res = await logApi.getLogPage(params)
    if (res.code === 200) {
      logList.value = res.data.records || []
      total.value = res.data.total || 0
    }
  } catch (e) {
    console.error('加载日志失败', e)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => { pageNum.value = 1; loadData() }
const handleReset = () => { 
  searchForm.operation = ''
  searchForm.module = ''
  searchForm.dateRange = null
  pageNum.value = 1
  loadData()
}
const handleView = (row: any) => { currentLog.value = { ...row }; detailVisible.value = true }

onMounted(() => loadData())
</script>

<style scoped lang="scss">
.operation-log {
  padding: 20px;
  .search-card { margin-bottom: 20px; }
  .pagination { margin-top: 20px; display: flex; justify-content: flex-end; }
}
</style>
