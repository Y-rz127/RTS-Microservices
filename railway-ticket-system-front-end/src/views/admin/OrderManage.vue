<template>
  <div class="order-manage">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>订单管理</span>
        </div>
      </template>

      <!-- 搜索栏 -->
      <el-form :model="searchForm" :inline="true" class="search-form">
        <el-form-item label="查询类型">
          <el-select v-model="searchForm.searchType" placeholder="请选择" style="width: 120px">
            <el-option label="乘客姓名" value="passengerName" />
            <el-option label="用户名" value="username" />
            <el-option label="订单号" value="orderNumber" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="关键词">
          <el-input
            v-model="searchForm.keyword"
            placeholder="请输入关键词"
            clearable
            style="width: 200px"
          />
        </el-form-item>

        <el-form-item label="订单状态">
          <el-select v-model="searchForm.status" placeholder="全部" clearable style="width: 120px">
            <el-option label="待支付" value="PENDING" />
            <el-option label="已支付" value="PAID" />
            <el-option label="已取消" value="CANCELLED" />
            <el-option label="已退款" value="REFUNDED" />
          </el-select>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" icon="Search" @click="() => handleSearch()">查询</el-button>
          <el-button icon="Refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 订单列表 -->
      <el-table 
        :data="orderList" 
        v-loading="loading"
        border
        stripe
        style="margin-top: 20px"
      >
        <el-table-column prop="orderId" label="订单ID" width="80" />
        
        <el-table-column prop="orderNumber" label="订单号" width="180" />
        
        <el-table-column label="用户信息" width="150">
          <template #default="{ row }">
            <div>用户ID: {{ row.userId }}</div>
          </template>
        </el-table-column>
        
        <el-table-column prop="orderType" label="订单类型" width="100">
          <template #default="{ row }">
            <el-tag :type="row.orderType === 'GROUP' ? 'warning' : 'info'" size="small">
              {{ row.orderType === 'GROUP' ? '团体' : '个人' }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="totalAmount" label="订单金额" width="100">
          <template #default="{ row }">
            ¥{{ row.totalAmount || 0 }}
          </template>
        </el-table-column>
        
        <el-table-column prop="paymentAmount" label="实付金额" width="100">
          <template #default="{ row }">
            ¥{{ row.paymentAmount || 0 }}
          </template>
        </el-table-column>
        
        <el-table-column prop="orderStatus" label="订单状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.orderStatus)" size="small">
              {{ getStatusText(row.orderStatus) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="paymentMethod" label="支付方式" width="100">
          <template #default="{ row }">
            {{ row.paymentMethod || '-' }}
          </template>
        </el-table-column>
        
        <el-table-column prop="paymentTime" label="支付时间" width="180">
          <template #default="{ row }">
            {{ formatDateTime(row.paymentTime) }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleViewDetail(row)">
              查看详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <el-pagination
        v-model:current-page="pagination.current"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        style="margin-top: 20px; justify-content: flex-end"
        @size-change="loadOrders"
        @current-change="loadOrders"
      />

      <el-empty v-if="orderList.length === 0 && !loading" description="暂无订单数据" />
    </el-card>

    <!-- 订单详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="订单详情" width="800px">
      <el-descriptions :column="2" border v-if="currentOrder">
        <el-descriptions-item label="订单ID">{{ currentOrder.orderId }}</el-descriptions-item>
        <el-descriptions-item label="订单号">{{ currentOrder.orderNumber }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ currentOrder.userId }}</el-descriptions-item>
        <el-descriptions-item label="订单类型">
          <el-tag :type="currentOrder.orderType === 'GROUP' ? 'warning' : 'info'">
            {{ currentOrder.orderType === 'GROUP' ? '团体订单' : '个人订单' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="订单金额">¥{{ currentOrder.totalAmount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="实付金额">¥{{ currentOrder.paymentAmount || 0 }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag :type="getStatusType(currentOrder.orderStatus)">
            {{ getStatusText(currentOrder.orderStatus) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="支付方式">{{ currentOrder.paymentMethod || '-' }}</el-descriptions-item>
        <el-descriptions-item label="支付时间">{{ formatDateTime(currentOrder.paymentTime) }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ formatDateTime(currentOrder.createdAt) }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ formatDateTime(currentOrder.updatedAt) }}</el-descriptions-item>
        <el-descriptions-item label="操作员ID">{{ currentOrder.operatorId || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { orderApi } from '@/api/order'
import type { Order } from '@/types'

const route = useRoute()

const loading = ref(false)
const orderList = ref<Order[]>([])
const searchForm = ref({
  searchType: 'passengerName',
  keyword: '',
  status: ''
})

const pagination = ref({
  current: 1,
  size: 10,
  total: 0
})

const detailDialogVisible = ref(false)
const currentOrder = ref<Order | null>(null)

// 加载订单列表
const loadOrders = async () => {
  loading.value = true
  try {
    const params: any = {
      current: pagination.value.current,
      size: pagination.value.size
    }
    if (searchForm.value.status) {
      params.orderStatus = searchForm.value.status
    }
    const res = await orderApi.getOrderPage(params)
    
    if (res.code === 200 && res.data) {
      orderList.value = res.data.records || []
      pagination.value.total = res.data.total || 0
    } else {
      orderList.value = []
      pagination.value.total = 0
      if (res.message) {
        ElMessage.error(res.message)
      }
    }
  } catch (error: any) {
    // 只处理真正的网络错误或异常
    orderList.value = []
    pagination.value.total = 0
    console.error('加载订单失败', error)
    ElMessage.error('网络错误或系统异常，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 搜索订单
const handleSearch = async (showEmptyTip: boolean = true) => {
  if (searchForm.value.keyword) {
    loading.value = true
    try {
      let res: any
      
      // 根据查询类型调用不同的API
      if (searchForm.value.searchType === 'orderNumber') {
        // 按订单号查询 - API not implemented yet
        ElMessage.warning('按订单号查询功能暂未实现')
        return
        // res = await orderApi.getOrderByNumber(searchForm.value.keyword)
      } else if (searchForm.value.searchType === 'username') {
        // 按用户名查询 - API not implemented yet
        ElMessage.warning('按用户名查询功能暂未实现')
        return
        // res = await orderApi.getOrdersByUsername(searchForm.value.keyword)
      } else if (searchForm.value.searchType === 'passengerName') {
        // 按乘客姓名查询 - API not implemented yet
        ElMessage.warning('按乘客姓名查询功能暂未实现')
        return
        // res = await orderApi.getOrdersByPassengerName(searchForm.value.keyword)
      } else {
        // 默认分页查询
        res = await orderApi.getOrderPage({
          pageNum: pagination.value.current,
          pageSize: pagination.value.size
        })
        if (res.code === 200 && res.data) {
          orderList.value = res.data.records || []
          pagination.value.total = res.data.total || 0
        } else {
          orderList.value = []
          pagination.value.total = 0
          if (res.message && showEmptyTip) {
            ElMessage.warning(res.message)
          }
        }
      }
    } catch (error: any) {
      // 只处理真正的网络错误或异常
      orderList.value = []
      pagination.value.total = 0
      console.error('查询订单异常:', error)
      ElMessage.error('网络错误或系统异常，请稍后重试')
    } finally {
      loading.value = false
    }
  } else {
    // 没有关键词，正常分页查询
    pagination.value.current = 1
    loadOrders()
  }
}

// 重置搜索
const handleReset = () => {
  searchForm.value = {
    searchType: 'passengerName',
    keyword: '',
    status: ''
  }
  pagination.value.current = 1
  loadOrders()
}

// 查看订单详情
const handleViewDetail = (order: Order) => {
  currentOrder.value = order
  detailDialogVisible.value = true
}

// 获取状态类型
const getStatusType = (status: string) => {
  const map: Record<string, any> = {
    'PAID': 'success',
    'PENDING': 'warning',
    'CANCELLED': 'info',
    'REFUNDED': 'warning',
    'COMPLETED': 'success',
    'PROCESSING': 'primary'
  }
  return map[status] || 'info'
}

// 获取状态文本
const getStatusText = (status: string) => {
  const map: Record<string, string> = {
    'PAID': '已支付',
    'PENDING': '待支付',
    'CANCELLED': '已取消',
    'REFUNDED': '已退款',
    'COMPLETED': '已完成',
    'PROCESSING': '处理中'
  }
  return map[status] || status
}

// 格式化时间
const formatDateTime = (dateTime?: string | Date | null) => {
  if (!dateTime) return '-'
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hour = String(date.getHours()).padStart(2, '0')
  const minute = String(date.getMinutes()).padStart(2, '0')
  return `${year}-${month}-${day} ${hour}:${minute}`
}

// 监听路由参数变化（从Dashboard跳转过来的查询）
watch(() => route.query, (newQuery) => {
  if (newQuery.type && newQuery.value) {
    searchForm.value.searchType = newQuery.type as string
    searchForm.value.keyword = newQuery.value as string
    // 从路由跳转过来时，不显示空结果提示
    handleSearch(false)
  }
}, { immediate: true })

onMounted(() => {
  // 如果没有查询参数，正常加载
  if (!route.query.type) {
    loadOrders()
  }
})
</script>

<style scoped lang="scss">
.order-manage {
  padding: 20px;

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .search-form {
    margin-top: 10px;
  }
}
</style>
