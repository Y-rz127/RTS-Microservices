<template>
  <div class="approval-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>审批管理</span>
          <el-radio-group v-model="activeTab" size="small">
            <el-radio-button value="pending">待审批</el-radio-button>
            <el-radio-button value="all">全部记录</el-radio-button>
          </el-radio-group>
        </div>
      </template>

      <!-- 待审批列表 -->
      <div v-if="activeTab === 'pending'">
        <el-table 
          :data="pendingRequests" 
          v-loading="loading"
          border
          stripe
        >
          <el-table-column type="expand">
            <template #default="{ row }">
              <div class="expand-content">
                <!-- 改签：新旧车票对比 -->
                <template v-if="row.requestType === 'CHANGE_TICKET'">
                  <div class="change-compare">
                    <el-row :gutter="20">
                      <el-col :span="12">
                        <el-card class="old-ticket-card" shadow="never">
                          <template #header>
                            <div class="card-header-title">
                              <el-tag type="info">原车票</el-tag>
                            </div>
                          </template>
                          <el-descriptions :column="1" border>
                            <el-descriptions-item label="车次号">{{ row.trainNumber }}</el-descriptions-item>
                            <el-descriptions-item label="座位">{{ row.seatType }} {{ row.seatNumber }}</el-descriptions-item>
                            <el-descriptions-item label="出发站">{{ row.startStation }}</el-descriptions-item>
                            <el-descriptions-item label="到达站">{{ row.endStation }}</el-descriptions-item>
                            <el-descriptions-item label="乘车日期">{{ row.travelDate }}</el-descriptions-item>
                            <el-descriptions-item label="发车时间">{{ row.departureTime }}</el-descriptions-item>
                            <el-descriptions-item label="票价">¥{{ row.price }}</el-descriptions-item>
                          </el-descriptions>
                        </el-card>
                      </el-col>
                      <el-col :span="12">
                        <el-card class="new-ticket-card" shadow="never">
                          <template #header>
                            <div class="card-header-title">
                              <el-tag type="success">新车票</el-tag>
                            </div>
                          </template>
                          <el-descriptions :column="1" border>
                            <el-descriptions-item label="车次号">{{ row.newTrainNumber }}</el-descriptions-item>
                            <el-descriptions-item label="座位">{{ row.newSeatType }} {{ row.newSeatNumber }}</el-descriptions-item>
                            <el-descriptions-item label="出发站">{{ row.newStartStation }}</el-descriptions-item>
                            <el-descriptions-item label="到达站">{{ row.newEndStation }}</el-descriptions-item>
                            <el-descriptions-item label="乘车日期">{{ row.newTravelDate }}</el-descriptions-item>
                            <el-descriptions-item label="发车时间">{{ row.newDepartureTime }}</el-descriptions-item>
                            <el-descriptions-item label="票价">¥{{ row.newPrice }}</el-descriptions-item>
                          </el-descriptions>
                        </el-card>
                      </el-col>
                    </el-row>
                    <div class="change-info-bar" style="margin-top: 12px;">
                      <el-alert :title="`申请原因：${row.applyReason || '无'}`" type="info" :closable="false" show-icon />
                    </div>
                  </div>
                </template>

                <!-- 退票/取消预订：单票详情 -->
                <template v-else>
                  <el-descriptions :column="2" border>
                    <el-descriptions-item label="申请原因">
                      {{ row.applyReason || '无' }}
                    </el-descriptions-item>
                    <el-descriptions-item label="申请时间">
                      {{ formatDateTime(row.createdAt) }}
                    </el-descriptions-item>
                    <el-descriptions-item label="车次号">
                      {{ row.trainNumber }}
                    </el-descriptions-item>
                    <el-descriptions-item label="座位">
                      {{ row.seatType }} {{ row.seatNumber }}
                    </el-descriptions-item>
                    <el-descriptions-item label="出发站">
                      {{ row.startStation }}
                    </el-descriptions-item>
                    <el-descriptions-item label="到达站">
                      {{ row.endStation }}
                    </el-descriptions-item>
                    <el-descriptions-item label="乘车日期">
                      {{ row.travelDate }}
                    </el-descriptions-item>
                    <el-descriptions-item label="发车时间">
                      {{ row.departureTime }}
                    </el-descriptions-item>
                    <el-descriptions-item label="票价">
                      ¥{{ row.price }}
                    </el-descriptions-item>
                    <el-descriptions-item label="退票手续费" v-if="row.refundFee !== undefined">
                      ¥{{ row.refundFee }}
                    </el-descriptions-item>
                    <el-descriptions-item label="实际退款" v-if="row.refundAmount !== undefined">
                      ¥{{ row.refundAmount }}
                    </el-descriptions-item>
                  </el-descriptions>
                </template>
              </div>
            </template>
          </el-table-column>
          
          <el-table-column prop="requestId" label="申请ID" width="80" />
          
          <el-table-column prop="requestType" label="申请类型" width="100">
            <template #default="{ row }">
              <el-tag :type="getRequestTypeTag(row.requestType)">
                {{ getRequestTypeName(row.requestType) }}
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column prop="userName" label="申请人" width="120" />
          
          <el-table-column label="车次信息" width="200">
            <template #default="{ row }">
              <div>{{ row.trainNumber }}</div>
              <div class="text-secondary">
                {{ row.startStation }} → {{ row.endStation }}
              </div>
            </template>
          </el-table-column>
          
          <el-table-column label="乘车信息" width="180">
            <template #default="{ row }">
              <div>{{ row.travelDate }} {{ row.departureTime }}</div>
              <div class="text-secondary">
                {{ row.seatType }} {{ row.seatNumber }}
              </div>
            </template>
          </el-table-column>
          
          <el-table-column prop="price" label="票价" width="100">
            <template #default="{ row }">
              ¥{{ row.price }}
            </template>
          </el-table-column>
          
          <el-table-column prop="createdAt" label="申请时间" width="180">
            <template #default="{ row }">
              {{ formatDateTime(row.createdAt) }}
            </template>
          </el-table-column>
          
          <el-table-column label="操作" width="180" fixed="right">
            <template #default="{ row }">
              <el-button 
                type="success" 
                size="small"
                @click="handleApprove(row)"
              >
                批准
              </el-button>
              <el-button 
                type="danger" 
                size="small"
                @click="handleReject(row)"
              >
                拒绝
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        
        <el-empty v-if="pendingRequests.length === 0 && !loading" description="暂无待审批申请" />
      </div>

      <!-- 全部记录 -->
      <div v-if="activeTab === 'all'">
        <el-table 
          :data="allRequests" 
          v-loading="loading"
          border
          stripe
        >
          <el-table-column prop="requestId" label="申请ID" width="80" />
          
          <el-table-column prop="requestType" label="类型" width="100">
            <template #default="{ row }">
              <el-tag :type="getRequestTypeTag(row.requestType)">
                {{ getRequestTypeName(row.requestType) }}
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column prop="userName" label="申请人" width="120" />
          
          <el-table-column label="车次" width="150">
            <template #default="{ row }">
              {{ row.trainNumber }}
              <div class="text-secondary">
                {{ row.startStation }} → {{ row.endStation }}
              </div>
            </template>
          </el-table-column>
          
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="getStatusTag(row.status)">
                {{ getStatusName(row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          
          <el-table-column prop="applyReason" label="申请原因" width="150" show-overflow-tooltip />
          
          <el-table-column prop="rejectReason" label="拒绝原因" width="150" show-overflow-tooltip />
          
          <el-table-column prop="createdAt" label="申请时间" width="180">
            <template #default="{ row }">
              {{ formatDateTime(row.createdAt) }}
            </template>
          </el-table-column>
          
          <el-table-column prop="processedAt" label="处理时间" width="180">
            <template #default="{ row }">
              {{ row.processedAt ? formatDateTime(row.processedAt) : '-' }}
            </template>
          </el-table-column>
        </el-table>
        
        <el-empty v-if="allRequests.length === 0 && !loading" description="暂无审批记录" />
      </div>
    </el-card>

    <!-- 拒绝对话框 -->
    <el-dialog v-model="rejectDialogVisible" title="拒绝申请" width="500px">
      <el-form :model="rejectForm" label-width="100px">
        <el-form-item label="拒绝原因">
          <el-input
            v-model="rejectForm.rejectReason"
            type="textarea"
            :rows="4"
            placeholder="请输入拒绝原因"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="rejectDialogVisible = false">取消</el-button>
        <el-button type="danger" @click="confirmReject">确认拒绝</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { approvalApi } from '@/api/approval'
import type { ApprovalRequestDetail } from '@/api/approval'

const activeTab = ref('pending')
const loading = ref(false)
const pendingRequests = ref<ApprovalRequestDetail[]>([])
const allRequests = ref<ApprovalRequestDetail[]>([])

const rejectDialogVisible = ref(false)
const rejectForm = ref({
  requestId: 0,
  rejectReason: ''
})

// 获取操作员ID（从用户信息中获取，这里暂时硬编码为25）
const operatorId = 25

// 加载待审批申请
const loadPendingRequests = async () => {
  loading.value = true
  try {
    const res = await approvalApi.getPendingRequests()
    if (res.code === 200) {
      pendingRequests.value = res.data || []
    } else {
      pendingRequests.value = []
      if (res.message) {
        ElMessage.error(res.message)
      }
    }
  } catch (error: any) {
    pendingRequests.value = []
    console.error('加载待审批申请失败', error)
    ElMessage.error('网络错误或系统异常，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 加载所有记录
const loadAllRequests = async () => {
  loading.value = true
  try {
    const res = await approvalApi.getAllRequests()
    if (res.code === 200) {
      allRequests.value = res.data || []
    } else {
      allRequests.value = []
      if (res.message) {
        ElMessage.error(res.message)
      }
    }
  } catch (error: any) {
    allRequests.value = []
    console.error('加载审批记录失败', error)
    ElMessage.error('网络错误或系统异常，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 批准申请
const handleApprove = async (row: ApprovalRequestDetail) => {
  try {
    await ElMessageBox.confirm(
      `确认批准【${getRequestTypeName(row.requestType)}】申请吗？`,
      '确认批准',
      {
        confirmButtonText: '确认批准',
        cancelButtonText: '取消',
        type: 'success'
      }
    )
    
    const res = await approvalApi.approveRequest(row.requestId, { operatorId })
    if (res.code === 200) {
      ElMessage.success('审批通过')
      void loadPendingRequests()
    } else {
      if (res.message) {
        ElMessage.error(res.message)
      }
    }
  } catch (error: any) {
    if (error !== 'cancel') {
      console.error('审批操作失败', error)
      ElMessage.error('网络错误或系统异常，请稍后重试')
    }
  }
}

// 拒绝申请
const handleReject = (row: ApprovalRequestDetail) => {
  rejectForm.value.requestId = row.requestId
  rejectForm.value.rejectReason = ''
  rejectDialogVisible.value = true
}

// 确认拒绝
const confirmReject = async () => {
  if (!rejectForm.value.rejectReason) {
    ElMessage.warning('请输入拒绝原因')
    return
  }
  
  try {
    const res = await approvalApi.rejectRequest(rejectForm.value.requestId, {
      operatorId,
      rejectReason: rejectForm.value.rejectReason
    })
    
    if (res.code === 200) {
      ElMessage.success('已拒绝该申请')
      rejectDialogVisible.value = false
      void loadPendingRequests()
    } else {
      if (res.message) {
        ElMessage.error(res.message)
      }
    }
  } catch (error: any) {
    console.error('拒绝申请失败', error)
    ElMessage.error('网络错误或系统异常，请稍后重试')
  }
}

// 格式化时间
const formatDateTime = (dateTime: string) => {
  if (!dateTime) return '-'
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hour = String(date.getHours()).padStart(2, '0')
  const minute = String(date.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day} ${hour}:${minute}`
}

// 获取请求类型名称
const getRequestTypeName = (type: string) => {
  const map: Record<string, string> = {
    'REFUND': '退票',
    'CANCEL_BOOKING': '取消预订',
    'CHANGE_TICKET': '改签'
  }
  return map[type] || type
}

// 获取请求类型标签
const getRequestTypeTag = (type: string) => {
  const map: Record<string, any> = {
    'REFUND': 'warning',
    'CANCEL_BOOKING': 'info',
    'CHANGE_TICKET': 'primary'
  }
  return map[type] || ''
}

// 获取状态名称
const getStatusName = (status: string) => {
  const map: Record<string, string> = {
    'PENDING': '待审批',
    'APPROVED': '已批准',
    'REJECTED': '已拒绝'
  }
  return map[status] || status
}

// 获取状态标签
const getStatusTag = (status: string) => {
  const map: Record<string, any> = {
    'PENDING': 'warning',
    'APPROVED': 'success',
    'REJECTED': 'danger'
  }
  return map[status] || ''
}

// 监听tab切换
watch(() => activeTab.value, (newVal) => {
  if (newVal === 'pending') {
    loadPendingRequests()
  } else {
    loadAllRequests()
  }
})

onMounted(() => {
  loadPendingRequests()
})
</script>

<script lang="ts">
import { watch } from 'vue'
export default {
  name: 'ApprovalManagement'
}
</script>

<style scoped>
.approval-management {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.text-secondary {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

.expand-content {
  padding: 20px;
}

.change-compare {
  .old-ticket-card {
    border: 1px solid #dcdfe6;
    :deep(.el-card__header) {
      background: #f5f7fa;
      padding: 10px 15px;
    }
  }
  .new-ticket-card {
    border: 1px solid #67c23a;
    :deep(.el-card__header) {
      background: #f0f9eb;
      padding: 10px 15px;
    }
  }
  .card-header-title {
    display: flex;
    justify-content: center;
  }
}
</style>
