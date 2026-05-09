<template>
  <div class="profile">
    <!-- 用户信息卡片 -->
    <el-card class="user-card">
      <template #header>
        <div class="card-header">
          <span>👤 个人信息</span>
          <el-button type="primary" size="small" @click="editDialogVisible = true">
            编辑资料
          </el-button>
        </div>
      </template>
      
      <div class="user-info">
        <el-avatar :size="80" class="avatar">
          {{ userStore.userInfo?.username?.charAt(0).toUpperCase() }}
        </el-avatar>
        
        <div class="info-list">
          <div class="info-item">
            <span class="label">用户名：</span>
            <span class="value">{{ userStore.userInfo?.username }}</span>
          </div>
          <div class="info-item">
            <span class="label">角色：</span>
            <el-tag :type="getRoleType(userStore.userInfo?.role)">
              {{ getRoleText(userStore.userInfo?.role) }}
            </el-tag>
          </div>
          <div class="info-item">
            <span class="label">手机号：</span>
            <span class="value">{{ userStore.userInfo?.phone || '未设置' }}</span>
          </div>
          <div class="info-item">
            <span class="label">状态：</span>
            <el-tag :type="userStore.userInfo?.status === 1 ? 'success' : 'danger'">
              {{ userStore.userInfo?.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 统计信息 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-content">
            <el-icon size="40" color="#409eff"><Document /></el-icon>
            <div class="stat-info">
              <div class="stat-value">{{ stats.orderCount }}</div>
              <div class="stat-label">订单总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-content">
            <el-icon size="40" color="#67c23a"><Money /></el-icon>
            <div class="stat-info">
              <div class="stat-value">¥{{ stats.totalAmount }}</div>
              <div class="stat-label">累计消费</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="8">
        <el-card class="stat-card">
          <div class="stat-content">
            <el-icon size="40" color="#e6a23c"><Tickets /></el-icon>
            <div class="stat-info">
              <div class="stat-value">{{ stats.ticketCount }}</div>
              <div class="stat-label">购票数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 快捷操作 -->
    <el-card class="action-card">
      <template #header>
        <span>⚡ 快捷操作</span>
      </template>
      
      <div class="action-list">
        <el-button type="primary" icon="Edit" @click="passwordDialogVisible = true">
          修改密码
        </el-button>
        <el-button type="success" icon="Tickets" @click="router.push('/passenger/query')">
          购买车票
        </el-button>
        <el-button type="warning" icon="Document" @click="router.push('/passenger/order')">
          我的订单
        </el-button>
      </div>
    </el-card>

    <!-- 编辑资料对话框 -->
    <el-dialog v-model="editDialogVisible" title="编辑资料" width="500px">
      <el-form :model="editForm" label-width="80px">
        <el-form-item label="用户名">
          <el-input v-model="editForm.username" disabled />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="editForm.phone" placeholder="请输入手机号" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleUpdateProfile" :loading="loading">
          保存
        </el-button>
      </template>
    </el-dialog>

    <!-- 修改密码对话框 -->
    <el-dialog v-model="passwordDialogVisible" title="修改密码" width="500px">
      <el-form :model="passwordForm" label-width="100px">
        <el-form-item label="原密码">
          <el-input v-model="passwordForm.oldPassword" type="password" placeholder="请输入原密码" />
        </el-form-item>
        <el-form-item label="新密码">
          <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码" />
        </el-form-item>
        <el-form-item label="确认密码">
          <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="passwordDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleChangePassword" :loading="loading">
          确认修改
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { orderApi } from '@/api/order'
import { ElMessage } from 'element-plus'
import { Document, Money, Tickets } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()

const editDialogVisible = ref(false)
const passwordDialogVisible = ref(false)
const loading = ref(false)

const stats = reactive({
  orderCount: 0,
  totalAmount: 0,
  ticketCount: 0
})

const editForm = reactive({
  username: '',
  phone: ''
})

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 获取角色类型
const getRoleType = (role?: string) => {
  if (!role) return 'info'
  const typeMap: any = {
    'ADMIN': 'danger',
    'OPERATOR': 'warning',
    'PASSENGER': 'success'
  }
  return typeMap[role] || 'info'
}

// 获取角色文本
const getRoleText = (role?: string) => {
  if (!role) return '未知'
  const textMap: any = {
    'ADMIN': '管理员',
    'OPERATOR': '售票员',
    'PASSENGER': '乘客'
  }
  return textMap[role] || role
}

// 加载统计数据
const loadStats = async () => {
  try {
    const res = await orderApi.getUserOrders(userStore.userInfo?.userid!)
    if (res.code === 200) {
      const orders = res.data || []
      stats.orderCount = orders.length
      stats.totalAmount = orders.reduce((sum: number, order: any) => {
        return sum + (order.order?.totalAmount || 0)
      }, 0)
      stats.ticketCount = orders.reduce((sum: number, order: any) => {
        return sum + (order.tickets?.length || 0)
      }, 0)
    }
  } catch (error) {
    console.error('加载统计数据失败', error)
  }
}

// 更新资料
const handleUpdateProfile = async () => {
  if (!editForm.phone) {
    ElMessage.warning('请输入手机号')
    return
  }
  
  loading.value = true
  try {
    // 这里应该调用更新用户信息的API
    ElMessage.success('资料更新成功！')
    editDialogVisible.value = false
  } catch (error: any) {
    ElMessage.error(error.message || '更新失败')
  } finally {
    loading.value = false
  }
}

// 修改密码
const handleChangePassword = async () => {
  if (!passwordForm.oldPassword || !passwordForm.newPassword || !passwordForm.confirmPassword) {
    ElMessage.warning('请填写完整信息')
    return
  }
  
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }
  
  if (passwordForm.newPassword.length < 6) {
    ElMessage.warning('新密码长度不能少于6位')
    return
  }
  
  loading.value = true
  try {
    // 这里应该调用修改密码的API
    ElMessage.success('密码修改成功！')
    passwordDialogVisible.value = false
    passwordForm.oldPassword = ''
    passwordForm.newPassword = ''
    passwordForm.confirmPassword = ''
  } catch (error: any) {
    ElMessage.error(error.message || '修改失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  editForm.username = userStore.userInfo?.username || ''
  editForm.phone = userStore.userInfo?.phone || ''
  loadStats()
})
</script>

<style scoped lang="scss">
.profile {
  padding: 20px;
  background: #f0f2f5;
  min-height: calc(100vh - 60px);

  .user-card {
    margin-bottom: 20px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .user-info {
      display: flex;
      gap: 30px;
      align-items: center;

      .avatar {
        font-size: 32px;
        font-weight: bold;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }

      .info-list {
        flex: 1;
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 16px;

        .info-item {
          .label {
            color: #909399;
            margin-right: 8px;
          }

          .value {
            color: #303133;
            font-weight: 500;
          }
        }
      }
    }
  }

  .stats-row {
    margin-bottom: 20px;

    .stat-card {
      .stat-content {
        display: flex;
        align-items: center;
        gap: 20px;

        .stat-info {
          .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #303133;
            margin-bottom: 4px;
          }

          .stat-label {
            font-size: 14px;
            color: #909399;
          }
        }
      }
    }
  }

  .action-card {
    .action-list {
      display: flex;
      gap: 16px;
      flex-wrap: wrap;
    }
  }
}
</style>
