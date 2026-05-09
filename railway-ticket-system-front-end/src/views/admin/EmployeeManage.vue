<template>
  <div class="employee-manage">
    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="员工姓名">
          <el-input v-model="searchForm.username" placeholder="请输入员工姓名" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="启用" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
          <el-button type="success" @click="handleAdd">新增员工</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="employeeList" border v-loading="loading">
        <template #empty>
          <el-empty description="暂无数据" />
        </template>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="userid" label="员工ID" width="80" align="center" />
        <el-table-column prop="username" label="用户名" width="150" align="center" />
        <el-table-column prop="phone" label="电话" width="130" align="center" />
        <el-table-column prop="role" label="角色" width="100" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.role === 'ADMIN'" type="danger">管理员</el-tag>
            <el-tag v-else-if="row.role === 'OPERATOR'" type="warning">操作员</el-tag>
            <el-tag v-else type="info">{{ row.role }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              :active-value="1"
              :inactive-value="0"
              :disabled="row.role === 'ADMIN'"
              @change="handleStatusChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" align="center" />
        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="pagination.current"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="loadEmployees"
        @current-change="loadEmployees"
        style="margin-top: 20px; justify-content: center"
      />
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @close="handleDialogClose"
    >
      <el-form
        ref="employeeFormRef"
        :model="employeeForm"
        :rules="employeeRules"
        label-width="100px"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="employeeForm.username" placeholder="请输入用户名" :disabled="isEdit" />
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="!isEdit">
          <el-input v-model="employeeForm.password" type="password" placeholder="请输入密码" show-password />
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="employeeForm.role" placeholder="请选择角色" style="width: 100%">
            <el-option label="管理员" value="ADMIN" />
            <el-option label="操作员" value="OPERATOR" />
          </el-select>
        </el-form-item>
        <el-form-item label="电话" prop="phone">
          <el-input v-model="employeeForm.phone" placeholder="请输入电话" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="employeeForm.status" :disabled="employeeForm.role === 'ADMIN'">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
          <div v-if="employeeForm.role === 'ADMIN'" style="color: #909399; font-size: 12px; margin-top: 5px;">
            管理员账号状态不可修改，始终保持启用
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { userApi } from '@/api/user'
import { useUserStore } from '@/stores/user'

const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const dialogTitle = ref('新增员工')
const employeeFormRef = ref<FormInstance>()

const searchForm = reactive({
  username: '',
  status: null as number | null
})

const employeeList = ref<any[]>([])

const pagination = reactive({
  current: 1,
  size: 10,
  total: 0
})

const employeeForm = reactive({
  userid: null as number | null,
  username: '',
  password: '',
  role: 'OPERATOR' as string,
  phone: '',
  status: 1
})

const employeeRules: FormRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6个字符', trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
}

// 加载员工列表
const loadEmployees = async () => {
  loading.value = true
  try {
    const params: any = {
      pageNum: pagination.current,
      pageSize: pagination.size
    }
    
    if (searchForm.username) params.username = searchForm.username
    if (searchForm.status !== null) params.status = searchForm.status
    
    const res = await userApi.getUserPage(params) as any
    
    if (res.code === 200 && res.data) {
      // 过滤掉乘客角色，只显示管理员和操作员
      const allRecords = res.data.records || []
      const filteredRecords = allRecords.filter((user: any) => 
        user.role === 'ADMIN' || user.role === 'OPERATOR'
      )
      employeeList.value = filteredRecords
      pagination.total = filteredRecords.length
      
      console.log('员工列表数据:', {
        total: allRecords.length,
        filtered: filteredRecords.length,
        employees: filteredRecords
      })
    } else {
      employeeList.value = []
      pagination.total = 0
      console.log('获取员工列表失败:', res)
      if (res.message) {
        ElMessage.warning(res.message)
      }
    }
  } catch (error: any) {
    console.error('加载员工列表失败', error)
    ElMessage.error('加载员工列表失败')
    employeeList.value = []
    pagination.total = 0
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  pagination.current = 1
  loadEmployees()
}

// 重置
const handleReset = () => {
  searchForm.username = ''
  searchForm.status = null
  pagination.current = 1
  loadEmployees()
}

// 新增
const handleAdd = () => {
  isEdit.value = false
  dialogTitle.value = '新增员工'
  resetForm()
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row: any) => {
  isEdit.value = true
  dialogTitle.value = '编辑员工'
  Object.assign(employeeForm, {
    userid: row.userid,
    username: row.username,
    role: row.role,
    phone: row.phone || '',
    status: row.role === 'ADMIN' ? 1 : row.status  // 管理员始终启用
  })
  dialogVisible.value = true
}

// 删除
const handleDelete = async (row: any) => {
  try {
    // 检查是否是当前登录的管理员
    const userStore = useUserStore()
    if (row.userid === userStore.userInfo?.userid) {
      ElMessage.warning('不能删除自己的账号')
      return
    }
    
    await ElMessageBox.confirm(
      `确定要删除员工"${row.username}"吗？`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    const res = await userApi.deleteUser(row.userid) as any
    if (res.code === 200) {
      ElMessage.success('删除成功')
      loadEmployees()
    } else {
      ElMessage.error(res.message || '删除失败')
    }
  } catch (error: any) {
    if (error !== 'cancel') {
      console.error('删除员工失败', error)
      ElMessage.error('删除失败')
    }
  }
}

// 状态切换
const handleStatusChange = async (row: any) => {
  try {
    const res = await userApi.updateUserStatus(row.userid, row.status) as any
    if (res.code === 200) {
      ElMessage.success(row.status === 1 ? '启用成功' : '禁用成功')
    } else {
      // 恢复原状态
      row.status = row.status === 1 ? 0 : 1
      ElMessage.error(res.message || '操作失败')
    }
  } catch (error: any) {
    // 恢复原状态
    row.status = row.status === 1 ? 0 : 1
    console.error('修改状态失败', error)
    ElMessage.error('操作失败')
  }
}

// 提交表单
const handleSubmit = async () => {
  if (!employeeFormRef.value) return
  
  await employeeFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    try {
      let res: any
      // 确保管理员账号状态始终为启用
      const finalStatus = employeeForm.role === 'ADMIN' ? 1 : employeeForm.status
      
      if (isEdit.value) {
        // 编辑
        res = await userApi.updateUser(employeeForm.userid!, {
          role: employeeForm.role as any,
          phone: employeeForm.phone,
          status: finalStatus
        })
      } else {
        // 新增
        res = await userApi.register({
          username: employeeForm.username,
          password: employeeForm.password,
          role: employeeForm.role as any,
          phone: employeeForm.phone,
          status: finalStatus
        })
      }
      
      if (res.code === 200) {
        ElMessage.success(isEdit.value ? '修改成功' : '添加成功')
        dialogVisible.value = false
        loadEmployees()
      } else {
        ElMessage.error(res.message || '操作失败')
      }
    } catch (error: any) {
      console.error('提交失败', error)
      ElMessage.error(error.message || '操作失败')
    }
  })
}

// 重置表单
const resetForm = () => {
  if (employeeFormRef.value) {
    employeeFormRef.value.resetFields()
  }
  Object.assign(employeeForm, {
    userid: null,
    username: '',
    password: '',
    role: 'OPERATOR',
    phone: '',
    status: 1
  })
}

// 对话框关闭
const handleDialogClose = () => {
  resetForm()
}

onMounted(() => {
  loadEmployees()
})
</script>

<style scoped lang="scss">
.employee-manage {
  .search-card {
    margin-bottom: 20px;
  }

  .table-card {
    :deep(.el-table) {
      font-size: 14px;
    }
  }
}
</style>
