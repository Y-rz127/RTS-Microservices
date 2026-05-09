<template>
  <div class="system-log">
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stat-row">
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: #409eff"><el-icon><Document /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.totalCount || 0 }}</div>
              <div class="stat-label">今日操作总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: #67c23a"><el-icon><SuccessFilled /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.successCount || 0 }}</div>
              <div class="stat-label">成功操作</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: #f56c6c"><el-icon><CircleCloseFilled /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.failCount || 0 }}</div>
              <div class="stat-label">失败操作</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: #e6a23c"><el-icon><User /></el-icon></div>
            <div class="stat-info">
              <div class="stat-value">{{ statistics.successRate || '0%' }}</div>
              <div class="stat-label">成功率</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 搜索和清理 -->
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="模块">
          <el-select v-model="searchForm.module" placeholder="全部模块" clearable style="width: 150px">
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
        <el-form-item style="float: right">
          <el-button type="danger" icon="Delete" @click="handleClearExpired">清理过期日志</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 日志表格 -->
    <el-card class="table-card">
      <el-table v-loading="loading" :data="logList" stripe border>
        <el-table-column prop="logId" label="ID" width="70" />
        <el-table-column prop="username" label="操作用户" width="100" />
        <el-table-column prop="module" label="模块" width="100" />
        <el-table-column prop="operation" label="操作类型" width="100" />
        <el-table-column prop="method" label="方法" width="150" show-overflow-tooltip />
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
    <el-dialog v-model="detailVisible" title="日志详情" width="700px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="日志ID">{{ currentLog.logId }}</el-descriptions-item>
        <el-descriptions-item label="操作用户">{{ currentLog.username }}</el-descriptions-item>
        <el-descriptions-item label="模块">{{ currentLog.module }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">{{ currentLog.operation }}</el-descriptions-item>
        <el-descriptions-item label="方法" :span="2">{{ currentLog.method }}</el-descriptions-item>
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
import { ElMessage, ElMessageBox } from 'element-plus'
import { Document, SuccessFilled, CircleCloseFilled, User } from '@element-plus/icons-vue'
import { logApi } from '@/api/log'

const loading = ref(false)
const detailVisible = ref(false)

const searchForm = reactive({
  module: '',
  dateRange: null as any
})

const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const logList = ref<any[]>([])
const currentLog = ref<any>({})
const statistics = ref<any>({})

const formatDate = (date: string) => {
  if (!date) return '-'
  return date.replace('T', ' ').substring(0, 19)
}

// 加载统计数据
const loadStatistics = async () => {
  try {
    const res = await logApi.getTodayStatistics()
    if (res.code === 200) {
      statistics.value = res.data || {}
    }
  } catch (e) {
    console.error('加载统计失败', e)
  }
}

// 加载日志列表
const loadData = async () => {
  loading.value = true
  try {
    const params: any = {
      pageNum: pageNum.value,
      pageSize: pageSize.value
    }
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
const handleReset = () => { searchForm.module = ''; searchForm.dateRange = null; pageNum.value = 1; loadData() }
const handleView = (row: any) => { currentLog.value = { ...row }; detailVisible.value = true }

const handleClearExpired = () => {
  ElMessageBox.prompt('请输入要清理的天数（将删除N天前的日志）', '清理过期日志', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputPattern: /^[1-9]\d*$/,
    inputErrorMessage: '请输入正整数'
  }).then(async ({ value }) => {
    const res = await logApi.clearExpiredLogs(parseInt(value))
    if (res.code === 200) {
      ElMessage.success('清理成功')
      loadData()
      loadStatistics()
    } else {
      ElMessage.error(res.message || '清理失败')
    }
  }).catch(() => {})
}

onMounted(() => {
  loadStatistics()
  loadData()
})
</script>

<style scoped lang="scss">
.system-log {
  padding: 20px;

  .stat-row { margin-bottom: 20px; }
  .stat-card {
    .stat-content {
      display: flex;
      align-items: center;
    }
    .stat-icon {
      width: 60px;
      height: 60px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
      font-size: 28px;
    }
    .stat-info {
      margin-left: 15px;
      .stat-value { font-size: 28px; font-weight: bold; color: #303133; }
      .stat-label { font-size: 14px; color: #909399; margin-top: 5px; }
    }
  }

  .search-card { margin-bottom: 20px; }
  .pagination { margin-top: 20px; display: flex; justify-content: flex-end; }
}
</style>
