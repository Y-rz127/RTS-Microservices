<template>
  <div class="passenger-home">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <div class="banner-content">
        <div class="header-actions">
          <!-- WebSocket 连接状态 -->
          <el-tooltip :content="wsConnected ? '实时消息已连接' : '实时消息未连接'">
            <el-badge :value="notifications.length" :hidden="notifications.length === 0" class="notification-badge">
              <el-button 
                circle 
                :type="wsConnected ? 'success' : 'info'"
                @click="showNotificationPanel = true"
              >
                <el-icon><Bell /></el-icon>
              </el-button>
            </el-badge>
          </el-tooltip>
        </div>
        <h1>🚄 欢迎使用南宁站售票系统</h1>
        <p>南宁出发，便捷出行</p>
        <div class="user-info">
          <el-avatar :size="50">{{ userStore.userInfo?.username?.charAt(0) }}</el-avatar>
          <span class="username">{{ userStore.userInfo?.username }}</span>
        </div>
      </div>
    </div>

    <!-- 消息通知面板 -->
    <el-drawer
      v-model="showNotificationPanel"
      direction="rtl"
      size="350px"
      :with-header="true"
    >
      <template #header>
        <div class="notification-drawer-header">
          <span class="notification-drawer-title">📢 消息通知</span>
          <el-button class="clear-btn" type="danger" size="small" plain @click="clearNotifications">一键清空</el-button>
        </div>
      </template>
      <div class="notification-list">
        <div v-if="notifications.length === 0" class="empty-notifications">
          <el-empty description="暂无消息" />
        </div>
        <div
          v-for="item in notifications"
          :key="item.id"
          class="notification-item"
          :class="item.type.toLowerCase()"
        >
          <div class="notification-header">
            <span class="notification-title">{{ item.title }}</span>
            <span class="notification-time">{{ item.time }}</span>
          </div>
          <div class="notification-message">{{ item.message }}</div>
        </div>
      </div>
    </el-drawer>

    <!-- 快速查询 -->
    <el-card class="quick-query">
      <template #header>
        <span>🔍 快速查询车票</span>
      </template>
      <el-form :inline="true" :model="quickQueryForm" class="query-form">
        <el-form-item>
          <el-input
            v-model="quickQueryForm.startStation"
            disabled
            prefix-icon="LocationFilled"
            style="width: 120px"
          />
        </el-form-item>
        <el-form-item>
          <el-input
            v-model="quickQueryForm.endStation"
            placeholder="到达站"
            prefix-icon="LocationFilled"
            clearable
          />
        </el-form-item>
        <el-form-item>
          <el-date-picker
            v-model="quickQueryForm.date"
            type="date"
            placeholder="出发日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            :disabled-date="disabledDate"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="goToQuery">查询</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 功能卡片 -->
    <div class="feature-cards">
      <el-row :gutter="20">
        <el-col :span="8">
          <el-card class="feature-card" shadow="hover" @click="router.push('/passenger/query')">
            <div class="card-content">
              <el-icon size="48" color="#409eff"><Tickets /></el-icon>
              <h3>车票查询</h3>
              <p>查询全国车次信息</p>
            </div>
          </el-card>
        </el-col>

        <el-col :span="8">
          <el-card class="feature-card" shadow="hover" @click="router.push('/passenger/order')">
            <div class="card-content">
              <el-icon size="48" color="#67c23a"><Document /></el-icon>
              <h3>我的订单</h3>
              <p>查看订单记录</p>
            </div>
          </el-card>
        </el-col>

        <el-col :span="8">
          <el-card class="feature-card" shadow="hover" @click="router.push('/passenger/profile')">
            <div class="card-content">
              <el-icon size="48" color="#e6a23c"><User /></el-icon>
              <h3>个人中心</h3>
              <p>管理个人信息</p>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 热点车次排行榜 -->
    <el-card class="hot-trains-card">
      <template #header>
        <div class="card-header">
          <span>🔥 热点车次排行榜</span>
          <div class="header-actions">
            <el-date-picker
              v-model="hotTrainDate"
              type="date"
              placeholder="选择日期"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
              :disabled-date="disabledDate"
              style="width: 150px; margin-right: 10px;"
              size="small"
            />
            <el-button type="primary" size="small" @click="loadHotTrains(true)" :loading="loading">
              <el-icon><Refresh /></el-icon>刷新
            </el-button>
          </div>
        </div>
      </template>
      
      <div v-if="hotTrains.length === 0 && !loading" class="empty-tip">
        <el-empty description="暂无热点车次数据" />
      </div>
      
      <div v-else class="hot-trains-list">
        <div 
          v-for="(train, index) in hotTrains" 
          :key="train.trainId + '-' + train.travelDate"
          class="hot-train-item"
          :class="{ 'hot': train.isHot }"
          @click="showTrainDetail(train)"
        >
          <div class="train-rank">
            <el-tag :type="index < 3 ? 'danger' : 'info'" effect="dark" size="small">
              {{ index + 1 }}
            </el-tag>
          </div>
          <div class="train-info">
            <div class="train-header">
              <span class="train-id">{{ train.trainNumber || ('车次 ' + train.trainId) }}</span>
              <el-tag v-if="train.trainType" size="small" type="info" style="margin-left: 6px;">{{ train.trainType }}</el-tag>
              <span v-if="train.isHot" class="hot-tag">HOT</span>
            </div>
            <div class="train-route">
              {{ train.startStation }} → {{ train.endStation }}
            </div>
          </div>
          <div class="train-stats">
            <div class="stat-item">
              <el-icon><Ticket /></el-icon>
              <span>售出 {{ train.salesCount }} 张</span>
            </div>
            <div class="stat-item" :class="getSeatClass(train.availableSeats)">
              <el-icon><View /></el-icon>
              <span>余票 {{ train.availableSeats }} 张</span>
            </div>
          </div>
          <div class="train-action">
            <el-button type="primary" size="small" @click.stop="goToBooking(train)">
              抢票
            </el-button>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 车次详情弹窗 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="车次座位详情"
      width="700px"
    >
      <div v-if="currentTrain" class="train-detail">
        <div class="detail-header">
          <h3>{{ currentTrain.trainNumber || ('车次 ' + currentTrain.trainId) }}</h3>
          <p>{{ currentTrain.startStation }} → {{ currentTrain.endStation }} | {{ currentTrain.travelDate }}</p>
        </div>
        <div class="detail-stats">
          <el-statistic title="今日售出" :value="currentTrain.salesCount" />
          <el-statistic title="剩余座位" :value="currentTrain.availableSeats" :value-style="getSeatStyle(currentTrain.availableSeats)" />
          <el-statistic v-if="currentTrain.basePrice" title="基础票价" :value="currentTrain.basePrice" prefix="¥" />
        </div>
        <el-divider />
        <div class="detail-seats">
          <h4>座位分布</h4>
          <el-table :data="seatDetails" v-loading="seatsLoading" style="width: 100%" max-height="350">
            <el-table-column prop="seatNumber" label="座位号" width="120" />
            <el-table-column prop="carriageNumber" label="车厢" width="100" />
            <el-table-column prop="seatType" label="座位类型" width="120" />
            <el-table-column prop="status" label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="row.status === 'available' ? 'success' : 'danger'" size="small">
                  {{ row.status === 'available' ? '可售' : '已售' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="priceCoefficient" label="价格系数" width="100" />
          </el-table>
        </div>
      </div>
      <template #footer>
        <el-button @click="detailDialogVisible = false">关闭</el-button>
        <el-button type="primary" @click="goToBooking(currentTrain)">立即购票</el-button>
      </template>
    </el-dialog>

    <!-- 公告信息 -->
    <el-card class="notice-card">
      <template #header>
        <span>📢 系统公告</span>
      </template>
      <el-timeline>
        <el-timeline-item timestamp="2025/12/02" placement="top">
          <el-card>
            <h4>欢迎使用铁路售票系统</h4>
            <p>本系统提供便捷的在线购票服务，支持查询、预订、支付、退改等功能。</p>
          </el-card>
        </el-timeline-item>
        <el-timeline-item timestamp="2025/12/01" placement="top">
          <el-card>
            <h4>系统更新通知</h4>
            <p>系统已升级至最新版本，优化了用户体验，提升了系统稳定性。</p>
          </el-card>
        </el-timeline-item>
        <el-timeline-item timestamp="2025/11/30" placement="top">
          <el-card>
            <h4>购票小贴士</h4>
            <p>建议提前规划行程，节假日高峰期请尽早订票。支持多种支付方式，祝您出行愉快！</p>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </el-card>

    <!-- 常见问题 -->
    <el-card class="faq-card">
      <template #header>
        <span>❓ 常见问题</span>
      </template>
      <el-collapse>
        <el-collapse-item title="如何购票？" name="1">
          <p>在"车票查询"页面输入到达站和日期，点击查询后选择合适的车次，点击"立即购票"按钮即可。所有车次均从南宁站出发。</p>
        </el-collapse-item>
        <el-collapse-item title="如何支付订单？" name="2">
          <p>在"我的订单"页面找到待支付订单，点击"立即支付"按钮，选择支付方式完成支付。</p>
        </el-collapse-item>
        <el-collapse-item title="如何取消订单？" name="3">
          <p>在"我的订单"页面找到需要取消的订单，点击"取消订单"按钮，确认后即可取消。</p>
        </el-collapse-item>
        <el-collapse-item title="支持哪些支付方式？" name="4">
          <p>目前支持支付宝、微信和银行卡三种支付方式。</p>
        </el-collapse-item>
      </el-collapse>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { storeToRefs } from 'pinia'
import { ElMessage } from 'element-plus'
import { Document, Tickets, User, Refresh, View, Ticket, Bell } from "@element-plus/icons-vue"
import { getHotTrainRanking, getSeatAvailability } from '@/api/hotTrain'

const router = useRouter()
const userStore = useUserStore()
const { notifications, wsConnected } = storeToRefs(userStore)

const quickQueryForm = reactive({
  startStation: '南宁站',
  endStation: '',
  date: ''
})

const hotTrains = ref<any[]>([])
const hotTrainDate = ref('')
const loading = ref(false)
const detailDialogVisible = ref(false)
const currentTrain = ref<any>(null)
const seatDetails = ref<any[]>([])
const seatsLoading = ref(false)

// 消息通知相关面板控制
const showNotificationPanel = ref(false)

// 获取默认日期（今天）
const getDefaultDate = () => {
  const today = new Date()
  return today.toISOString().split('T')[0]
}

// 加载热点车次
const loadHotTrains = async (forceRefresh: boolean = false) => {
  loading.value = true
  try {
    const date = hotTrainDate.value || getDefaultDate()
    const res = await getHotTrainRanking(10, date, forceRefresh) as any
    if (res.code === 200) {
      hotTrains.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载热点车次失败')
    console.error(error)
  } finally {
    loading.value = false
  }
}

// 显示车次详情
const showTrainDetail = async (train: any) => {
  currentTrain.value = train
  detailDialogVisible.value = true
  seatsLoading.value = true
  try {
    const res = await getSeatAvailability(train.trainId, train.travelDate) as any
    if (res.code === 200) {
      seatDetails.value = res.data || []
    }
  } catch (error) {
    ElMessage.error('加载座位详情失败')
    console.error(error)
  } finally {
    seatsLoading.value = false
  }
}

// 跳转到购票页面
const goToBooking = (train: any) => {
  router.push({
    path: '/passenger/query',
    query: {
      startStation: train.startStation || '南宁站',
      endStation: train.endStation || '',
      date: train.travelDate || hotTrainDate.value || getDefaultDate(),
      trainId: String(train.trainId),
      autoBook: '1'
    }
  })
}

// 获取座位数量样式
const getSeatClass = (count: number) => {
  if (count === 0) return 'empty'
  if (count < 10) return 'low'
  return ''
}

const getSeatStyle = (count: number) => {
  return {
    color: count === 0 ? '#999' : count < 10 ? '#f56c6c' : '#67c23a'
  }
}

// 禁用今天之前的日期
const disabledDate = (time: Date) => {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  return time.getTime() < today.getTime()
}

// 快速查询
const goToQuery = () => {
  router.push({
    path: '/passenger/query',
    query: {
      startStation: quickQueryForm.startStation,
      endStation: quickQueryForm.endStation,
      date: quickQueryForm.date
    }
  })
}

// 一键清理所有消息
const clearNotifications = () => {
  userStore.clearNotifications()
  ElMessage.success('消息已清空')
}

// 页面加载时获取热点车次
onMounted(() => {
  hotTrainDate.value = getDefaultDate()
  loadHotTrains()

  // 监听排行榜更新事件
  window.addEventListener('ranking-updated', handleRankingUpdated)
})

// 组件卸载时移除事件监听
onUnmounted(() => {
  window.removeEventListener('ranking-updated', handleRankingUpdated)
})

// 处理排行榜更新事件
const handleRankingUpdated = (event: any) => {
  console.log('收到排行榜更新事件:', event.detail)
  const travelDate = event.detail?.travelDate
  if (travelDate && travelDate === hotTrainDate.value) {
    loadHotTrains()
  } else {
    loadHotTrains()
  }
}
</script>

<style scoped lang="scss">
.passenger-home {
  padding: 20px;
  background: #f0f2f5;
  min-height: calc(100vh - 60px);

  .welcome-banner {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 12px;
    padding: 40px;
    margin-bottom: 20px;
    color: #fff;

    .banner-content {
      text-align: center;

      h1 {
        font-size: 32px;
        margin-bottom: 10px;
      }

      p {
        font-size: 16px;
        opacity: 0.9;
        margin-bottom: 20px;
      }

      .user-info {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        margin-top: 20px;

        .username {
          font-size: 18px;
          font-weight: bold;
        }
      }
    }
  }

  .quick-query {
    margin-bottom: 20px;

    .query-form {
      display: flex;
      justify-content: center;

      :deep(.el-form-item) {
        margin-bottom: 0;
      }
    }
  }

  .feature-cards {
    margin-bottom: 20px;

    .feature-card {
      cursor: pointer;
      transition: all 0.3s;

      &:hover {
        transform: translateY(-5px);
      }

      .card-content {
        text-align: center;
        padding: 20px;

        h3 {
          margin: 16px 0 8px;
          color: #303133;
        }

        p {
          color: #909399;
          font-size: 14px;
        }
      }
    }
  }

  .notice-card {
    margin-bottom: 20px;

    :deep(.el-timeline-item__content) {
      h4 {
        margin: 0 0 8px 0;
        color: #303133;
      }

      p {
        margin: 0;
        color: #606266;
        line-height: 1.6;
      }
    }
  }

  .faq-card {
    :deep(.el-collapse-item__content) {
      padding: 16px 20px;
      color: #606266;
      line-height: 1.8;
    }
  }

  // 热点车次样式
  .hot-trains-card {
    margin-bottom: 20px;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .header-actions {
        display: flex;
        align-items: center;
      }
    }

    .empty-tip {
      padding: 40px 0;
    }

    .hot-trains-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .hot-train-item {
      display: flex;
      align-items: center;
      padding: 16px;
      background: #f8f9fa;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.3s;
      border: 2px solid transparent;

      &:hover {
        background: #e3f2fd;
        border-color: #409eff;
        transform: translateX(5px);
      }

      &.hot {
        background: linear-gradient(135deg, #fff5f5 0%, #ffe0e0 100%);
        border-color: #f56c6c;
      }

      .train-rank {
        margin-right: 16px;
      }

      .train-info {
        flex: 1;

        .train-header {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 4px;

          .train-id {
            font-size: 18px;
            font-weight: 700;
            color: #303133;
          }

          .hot-tag {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
          }
        }

        .train-route {
          color: #606266;
          font-size: 13px;
          margin-top: 2px;
        }
      }

      .train-stats {
        display: flex;
        flex-direction: column;
        gap: 4px;
        margin-right: 20px;

        .stat-item {
          display: flex;
          align-items: center;
          gap: 4px;
          color: #606266;
          font-size: 13px;

          &.low {
            color: #f56c6c;
          }

          &.empty {
            color: #999;
          }
        }
      }

      .train-action {
        display: flex;
        align-items: center;
      }
    }
  }

  // 车次详情弹窗样式
  .train-detail {
    .detail-header {
      text-align: center;
      margin-bottom: 20px;

      h3 {
        font-size: 24px;
        margin-bottom: 8px;
      }

      p {
        color: #909399;
      }
    }

    .detail-stats {
      display: flex;
      justify-content: space-around;
      margin-bottom: 20px;
    }

    .detail-seats {
      h4 {
        margin-bottom: 16px;
        color: #303133;
      }
    }
  }

  // 消息通知样式（仅限欢迎横幅内的通知铃铛）
  .welcome-banner .header-actions {
    position: absolute;
    top: 15px;
    right: 150px;

    .notification-badge {
      :deep(.el-badge__content) {
        background-color: #f56c6c;
      }
    }
  }

  .notification-list {
    .notification-drawer-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;

      .notification-drawer-title {
        font-size: 16px;
        font-weight: 600;
      }

      .clear-btn {
        padding: 4px 10px;
        font-size: 12px;
        height: 28px;
      }
    }

    .empty-notifications {
      padding: 40px 0;
    }

    .notification-item {
      padding: 16px;
      margin-bottom: 12px;
      border-radius: 8px;
      background: #f8f9fa;
      border-left: 4px solid #909399;

      &.booking_result {
        border-left-color: #409eff;
        background: #e3f2fd;
      }

      &.refund_notification {
        border-left-color: #e6a23c;
        background: #fff3e0;
      }

      .notification-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;

        .notification-title {
          font-weight: 600;
          color: #303133;
        }

        .notification-time {
          font-size: 12px;
          color: #909399;
        }
      }

      .notification-message {
        color: #606266;
        font-size: 14px;
        line-height: 1.5;
      }
    }
  }
}
</style>
