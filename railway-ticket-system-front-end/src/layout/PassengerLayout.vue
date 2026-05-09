<template>
  <el-container class="passenger-layout">
    <!-- 顶部导航 -->
    <el-header class="header">
      <div class="header-left">
        <div class="logo">🚄 南宁站售票系统</div>
        <el-menu mode="horizontal" :default-active="activeMenu" :router="true">
          <el-menu-item index="/passenger/home">首页</el-menu-item>
          <el-menu-item index="/passenger/query">车票查询</el-menu-item>
          <el-menu-item index="/passenger/order">我的订单</el-menu-item>
        </el-menu>
      </div>
      <div class="header-right">
        <el-dropdown @command="handleCommand">
          <span class="user-info">
            <el-icon><User /></el-icon>
            {{ userStore.userInfo?.username }}
          </span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="profile">个人中心</el-dropdown-item>
              <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </el-header>

    <!-- 内容区域 -->
    <el-main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </el-main>
  </el-container>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import {User} from "@element-plus/icons-vue";

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)

const handleCommand = (command: string) => {
  if (command === 'logout') {
    userStore.logout()
  } else if (command === 'profile') {
    router.push('/profile')
  }
}
</script>

<style scoped lang="scss">
.passenger-layout {
  height: 100vh;
}

.header {
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 40px;

  .header-left {
    display: flex;
    align-items: center;
    gap: 40px;

    .logo {
      font-size: 20px;
      font-weight: bold;
      color: #409eff;
    }

    :deep(.el-menu) {
      border-bottom: none;
    }
  }

  .header-right {
    .user-info {
      display: flex;
      align-items: center;
      gap: 5px;
      cursor: pointer;
      &:hover {
        color: #409eff;
      }
    }
  }
}

.main-content {
  background: #f0f2f5;
  overflow-y: auto;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
