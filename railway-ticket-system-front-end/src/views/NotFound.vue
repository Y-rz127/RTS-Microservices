<template>
  <div class="not-found">
    <div class="content">
      <h1>404</h1>
      <p>抱歉，您访问的页面不存在</p>
      <el-button type="primary" @click="goHome">返回首页</el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

const goHome = () => {
  const role = userStore.userInfo?.role
  if (role === 'ADMIN' || role === 'OPERATOR') {
    router.push('/admin/dashboard')
  } else if (role === 'PASSENGER') {
    router.push('/passenger/home')
  } else {
    router.push('/login')
  }
}
</script>

<style scoped lang="scss">
.not-found {
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #f0f2f5;

  .content {
    text-align: center;

    h1 {
      font-size: 120px;
      color: #409eff;
      margin-bottom: 20px;
    }

    p {
      font-size: 20px;
      color: #606266;
      margin-bottom: 30px;
    }
  }
}
</style>
