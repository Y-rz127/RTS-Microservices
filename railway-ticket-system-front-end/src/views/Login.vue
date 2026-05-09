<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-title">
        <h2>🚄 南宁站售票管理系统</h2>
        <p>Nanning Station Ticket Management System</p>
      </div>

      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        class="login-form"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名"
            size="large"
            prefix-icon="User"
          />
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            size="large"
            prefix-icon="Lock"
            show-password
            @keyup.enter="handleLogin"
          />
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            size="large"
            :loading="loading"
            @click="handleLogin"
            class="login-button"
          >
            登 录
          </el-button>
        </el-form-item>

        <div class="login-footer">
          <el-link type="primary" @click="goToRegister">没有账号？立即注册</el-link>
        </div>
      </el-form>

      <div class="demo-accounts">
        <el-divider>测试账号</el-divider>
        <div class="demo-list">
          <el-tag @click="useDemo('admin')">管理员: admin / 123456</el-tag>
          <el-tag @click="useDemo('operator')">操作员: operator1 / 123456</el-tag>
          <el-tag @click="useDemo('passenger')">乘客: passenger1 / 123456</el-tag>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import type { FormInstance, FormRules } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()

const loginFormRef = ref<FormInstance>()
const loading = ref(false)

const loginForm = reactive({
  username: '',
  password: ''
})

const loginRules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return

  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        await userStore.login(loginForm.username, loginForm.password)
      } finally {
        loading.value = false
      }
    }
  })
}

const goToRegister = () => {
  router.push('/register')
}

const useDemo = (type: string) => {
  if (type === 'admin') {
    loginForm.username = 'admin'
    loginForm.password = '123456'
  } else if (type === 'operator') {
    loginForm.username = 'operator1'
    loginForm.password = '123456'
  } else if (type === 'passenger') {
    loginForm.username = 'passenger1'
    loginForm.password = '123456'
  }
}
</script>

<style scoped lang="scss">
.login-container {
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-box {
  width: 400px;
  padding: 40px;
  background: #fff;
  border-radius: 10px;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

.login-title {
  text-align: center;
  margin-bottom: 30px;

  h2 {
    font-size: 24px;
    color: #303133;
    margin-bottom: 10px;
  }

  p {
    font-size: 14px;
    color: #909399;
  }
}

.login-form {
  .login-button {
    width: 100%;
  }
}

.login-footer {
  text-align: center;
  margin-top: 10px;
}

.demo-accounts {
  margin-top: 30px;

  .demo-list {
    display: flex;
    flex-direction: column;
    gap: 10px;

    .el-tag {
      cursor: pointer;
      &:hover {
        opacity: 0.8;
      }
    }
  }
}
</style>
