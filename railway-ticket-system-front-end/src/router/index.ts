import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue'),
    meta: { title: '注册' }
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('@/layout/AdminLayout.vue'),
    meta: { title: '管理系统', requiresAuth: true, roles: ['ADMIN', 'OPERATOR'] },
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: { title: '数据概览' }
      },
      {
        path: 'train',
        name: 'TrainManage',
        component: () => import('@/views/admin/TrainManage.vue'),
        meta: { title: '车次管理', roles: ['ADMIN'] }
      },
      {
        path: 'station',
        name: 'StationManage',
        component: () => import('@/views/admin/StationManage.vue'),
        meta: { title: '车站管理', roles: ['ADMIN'] }
      },
      {
        path: 'route',
        name: 'RouteManage',
        component: () => import('@/views/admin/RouteManage.vue'),
        meta: { title: '路线管理', roles: ['ADMIN'] }
      },
      {
        path: 'seat',
        name: 'SeatManage',
        component: () => import('@/views/admin/SeatManage.vue'),
        meta: { title: '座位管理', roles: ['ADMIN'] }
      },
      {
        path: 'employee',
        name: 'EmployeeManage',
        component: () => import('@/views/admin/EmployeeManage.vue'),
        meta: { title: '员工管理', roles: ['ADMIN'] }
      },
      {
        path: 'order',
        name: 'OrderManage',
        component: () => import('@/views/admin/OrderManage.vue'),
        meta: { title: '订单管理' }
      },
      {
        path: 'approval',
        name: 'ApprovalManagement',
        component: () => import('@/views/operator/ApprovalManagement.vue'),
        meta: { title: '审批管理', roles: ['OPERATOR'] }
      },
      {
        path: 'statistics',
        name: 'Statistics',
        component: () => import('@/views/admin/Statistics.vue'),
        meta: { title: '统计报表' }
      },
      {
        path: 'config',
        name: 'SystemConfig',
        component: () => import('@/views/admin/SystemConfig.vue'),
        meta: { title: '系统配置', roles: ['ADMIN'] }
      },
      {
        path: 'system-log',
        name: 'SystemLog',
        component: () => import('@/views/admin/SystemLog.vue'),
        meta: { title: '系统日志', roles: ['ADMIN'] }
      },
      {
        path: 'operation-log',
        name: 'OperationLog',
        component: () => import('@/views/admin/OperationLog.vue'),
        meta: { title: '操作日志', roles: ['ADMIN'] }
      }
    ]
  },
  {
    path: '/passenger',
    name: 'Passenger',
    component: () => import('@/layout/PassengerLayout.vue'),
    meta: { title: '乘客系统', requiresAuth: true, roles: ['PASSENGER'] },
    children: [
      {
        path: 'home',
        name: 'PassengerHome',
        component: () => import('@/views/passenger/Home.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'query',
        name: 'TicketQuery',
        component: () => import('@/views/passenger/TicketQuery.vue'),
        meta: { title: '车票查询' }
      },
      {
        path: 'order',
        name: 'MyOrders',
        component: () => import('@/views/passenger/MyOrders.vue'),
        meta: { title: '我的订单' }
      },
      {
        path: 'group-booking',
        name: 'GroupBooking',
        component: () => import('@/views/passenger/GroupBooking.vue'),
        meta: { title: '团体购票' }
      }
      ,{
        path: 'pay',
        name: 'Pay',
        component: () => import('@/views/passenger/Pay.vue'),
        meta: { title: '模拟支付' }
      },
      {
        path: 'profile',
        name: 'PassengerProfile',
        component: () => import('@/views/passenger/Profile.vue'),
        meta: { title: '个人中心', roles: ['PASSENGER', 'ADMIN', 'OPERATOR'] }
      }
    ]
  },
  {
    path: '/profile',
    name: 'Profile',
    redirect: '/passenger/profile'
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFound.vue'),
    meta: { title: '404' }
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  
  // 设置页面标题
  document.title = to.meta.title ? `${to.meta.title} - 南宁站售票管理系统` : '南宁站售票管理系统'
  
  // 需要登录的页面
  if (to.meta.requiresAuth) {
    if (!userStore.isLoggedIn) {
      ElMessage.warning('请先登录')
      next('/login')
      return
    }
    
    // 检查角色权限
    if (to.meta.roles && Array.isArray(to.meta.roles)) {
      if (!to.meta.roles.includes(userStore.userInfo?.role)) {
        ElMessage.error('权限不足')
        next(from.path)
        return
      }
    }
  }
  
  // 已登录用户访问登录页，跳转到对应的主页
  if (to.path === '/login' && userStore.isLoggedIn) {
    const role = userStore.userInfo?.role
    if (role === 'ADMIN' || role === 'OPERATOR') {
      next('/admin/dashboard')
    } else if (role === 'PASSENGER') {
      next('/passenger/home')
    } else {
      next()
    }
    return
  }
  
  next()
})

export default router
