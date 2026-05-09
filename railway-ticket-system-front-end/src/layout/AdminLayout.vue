<template>
  <el-container class="admin-layout">
    <!-- 侧边栏 -->
    <el-aside :width="isCollapse ? '64px' : '200px'" class="sidebar">
      <div class="logo">
        <span v-if="!isCollapse">南宁站售票系统</span>
        <span v-else>南宁</span>
      </div>
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :router="true"
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409eff"
      >
        <!-- 数据概览 -->
        <el-menu-item index="/admin/dashboard">
          <el-icon><DataLine /></el-icon>
          <template #title>数据概览</template>
        </el-menu-item>

        <!-- 基础管理（仅管理员） -->
        <el-sub-menu index="basic" v-if="isAdmin">
          <template #title>
            <el-icon><Setting /></el-icon>
            <span>基础管理</span>
          </template>
          <el-menu-item index="/admin/train">车次管理</el-menu-item>
          <el-menu-item index="/admin/station">车站管理</el-menu-item>
          <el-menu-item index="/admin/route">路线管理</el-menu-item>
          <el-menu-item index="/admin/seat">座位管理</el-menu-item>
        </el-sub-menu>

        <!-- 业务管理（仅管理员） -->
        <el-sub-menu index="business" v-if="isAdmin">
          <template #title>
            <el-icon><Tickets /></el-icon>
            <span>业务管理</span>
          </template>
          <el-menu-item index="/admin/employee">员工管理</el-menu-item>
          <el-menu-item index="/admin/order">订单管理</el-menu-item>
        </el-sub-menu>

        <!-- 审批管理（仅操作员） -->
        <el-menu-item index="/admin/approval" v-if="isOperator">
          <el-icon><Tickets /></el-icon>
          <template #title>审批管理</template>
        </el-menu-item>

        <!-- 统计报表 -->
        <el-menu-item index="/admin/statistics">
          <el-icon><TrendCharts /></el-icon>
          <template #title>统计报表</template>
        </el-menu-item>

        <!-- 系统管理（仅管理员） -->
        <el-sub-menu index="system" v-if="isAdmin">
          <template #title>
            <el-icon><Tools /></el-icon>
            <span>系统管理</span>
          </template>
          <el-menu-item index="/admin/config">系统配置</el-menu-item>
          <el-menu-item index="/admin/system-log">系统日志</el-menu-item>
          <el-menu-item index="/admin/operation-log">操作日志</el-menu-item>
        </el-sub-menu>
      </el-menu>
    </el-aside>

    <!-- 主区域 -->
    <el-container>
      <!-- 顶部导航栏 -->
      <el-header class="header">
        <div class="header-left">
          <el-icon class="collapse-icon" @click="toggleCollapse">
            <Expand v-if="isCollapse" />
            <Fold v-else />
          </el-icon>
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
  </el-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const isCollapse = ref(false)

const activeMenu = computed(() => route.path)
const isAdmin = computed(() => userStore.userInfo?.role === 'ADMIN')
const isOperator = computed(() => userStore.userInfo?.role === 'OPERATOR')

const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}

const handleCommand = (command: string) => {
  if (command === 'logout') {
    userStore.logout()
  } else if (command === 'profile') {
    router.push('/profile')
  }
}
</script>

<style scoped lang="scss">
.admin-layout {
  height: 100vh;
}

.sidebar {
  background-color: #304156;
  transition: width 0.3s;

  .logo {
    height: 60px;
    line-height: 60px;
    text-align: center;
    font-size: 20px;
    font-weight: bold;
    color: #fff;
    background-color: #2b3a4b;
  }

  :deep(.el-menu) {
    border-right: none;
  }
}

.header {
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;

  .header-left {
    .collapse-icon {
      font-size: 20px;
      cursor: pointer;
      &:hover {
        color: #409eff;
      }
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
