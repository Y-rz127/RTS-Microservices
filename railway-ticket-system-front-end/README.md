# 南宁站售票系统前端 - 微服务联调版

本项目是南宁站售票系统的前端工程，基于 Vue 3、TypeScript、Vite 与 Element Plus 构建，当前默认通过 **Gateway** 访问后端微服务。

## 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 3.x | 前端框架 |
| TypeScript | 5.x | 类型系统 |
| Vite | 5.x | 开发服务器与构建工具 |
| Vue Router | 4.x | 路由管理 |
| Pinia | 2.x | 状态管理 |
| Axios | 1.x | HTTP 请求 |
| Element Plus | 2.x | UI 组件库 |
| ECharts | 5.x | 图表可视化 |
| Sass | 1.x | 样式预处理 |

## 当前架构说明

前端不直接请求各微服务，而是统一走：

- 浏览器 -> Vite 开发服务器 -> `/api` 代理 -> `gateway:8081` -> 各微服务

当前本地开发代理配置位于 `vite.config.ts`：

```ts
server: {
  port: 3000,
  proxy: {
    '/api': {
      target: 'http://localhost:8081',
      changeOrigin: true
    }
  }
}
```

这意味着：

- 前端只需要请求 `/api/...`
- Gateway 负责 JWT 解析、统一鉴权与路由转发

## 项目结构

```text
src/
├── api/                 # API 封装
├── assets/              # 静态资源
├── layout/              # 管理端 / 乘客端布局
├── router/              # 路由定义与权限守卫
├── stores/              # Pinia 状态
├── types/               # 类型定义
├── utils/               # 请求封装、工具函数
├── views/               # 页面视图
├── App.vue
└── main.ts
```

## 页面分区

### 管理端

主要页面包括：

- `/admin/dashboard`
- `/admin/train`
- `/admin/station`
- `/admin/route`
- `/admin/seat`
- `/admin/order`
- `/admin/statistics`
- `/admin/config`
- `/admin/system-log`
- `/admin/operation-log`

### 操作员端

主要页面包括：

- `/admin/dashboard`
- `/admin/order`
- `/admin/approval`
- `/admin/statistics`

### 乘客端

主要页面包括：

- `/passenger/home`
- `/passenger/query`
- `/passenger/group-booking`
- `/passenger/order`
- `/passenger/profile`
- `/passenger/pay`

## API 模块与实际后端前缀

当前前端 API 模块已经对接微服务后的真实接口前缀。

| 前端模块 | 实际请求前缀 | 对应后端服务 |
|------|------|------|
| `user.ts` | `/user` | user-auth-service |
| `config.ts` | `/config` | user-auth-service |
| `log.ts` | `/log` | user-auth-service |
| `train.ts` | `/train` | train-service |
| `station.ts` | `/station` | train-service |
| `route.ts` | `/route` | train-service |
| `statistics.ts` | `/statistics` | train-service |
| `order.ts` | `/orders` | sales-service |
| `ticket.ts` | `/tickets` / `/async/ticket` | sales-service |
| `pay.ts` | `/pay` | sales-service |
| `approval.ts` | `/approval` / `/operator/approval` | approval-service |

### 特别注意

当前真实前缀不是旧单体时期的：

- 不是 `/order`，而是 `/orders`
- 不是 `/ticket`，而是 `/tickets`
- 不是 `/seat`，而是 `/seats`
- 统计分页还包含 `/sales/statistics`

如果你发现接口文档、旧笔记或旧截图里仍使用单体前缀，请以 `src/api/*.ts` 和后端 Controller 为准。

## 快速开始

### 1. 环境要求

- Node.js 18+（建议）
- npm / pnpm / yarn
- 后端 Gateway 与相关微服务已启动

### 2. 安装依赖

```bash
npm install
```

或：

```bash
pnpm install
```

### 3. 启动开发服务器

```bash
npm run dev
```

默认访问：

- `http://localhost:3000`

### 4. 生产构建

```bash
npm run build
```

### 5. 本地预览构建结果

```bash
npm run preview
```

## 联调前准备

建议按以下顺序检查：

### 基础服务

- MySQL
- Redis
- RabbitMQ
- Nacos
- Sentinel Dashboard
- Seata Server

### 后端服务

- gateway
- user-auth-service
- train-service
- sales-service
- approval-service
- notification-service

### 前端联调注意事项

- 登录前请清理旧 token
- 确认 Vite 代理目标是 `http://localhost:8081`
- 确认 Gateway 路由已覆盖 `/api/config/**`、`/api/log/**`、`/api/sales/**`、`/ws/**` 等路径

## 登录与权限

系统主要角色如下：

| 角色 | 权限范围 |
|------|----------|
| `ADMIN` | 全量后台管理功能 |
| `OPERATOR` | 订单、审批、统计等运营功能 |
| `PASSENGER` | 购票、订单、个人中心 |

路由守卫基于登录状态与角色元信息控制页面访问。

## 请求封装说明

统一请求封装位于：

- `src/utils/request.ts`

当前行为：

- 自动从 `localStorage` 注入 `Authorization: Bearer <token>`
- 对 `401` 做统一登录失效处理
- 其他业务错误交由页面自行处理

## 支付页说明

当前乘客支付页位于：

- `/passenger/pay?orderId=xxx`

相关 API：

- `POST /api/pay/create`
- `POST /api/pay/mock/success`

当前行为：

- 打开支付页时会创建支付会话并同步剩余支付时间
- 如果订单已超时，页面会直接退出到订单页
- 点击“稍后再说”只离开支付页，不会终止后端超时取消逻辑

## WebSocket / 通知联调

通知链路涉及：

- `notification-service`
- Gateway `/ws/**` 转发
- JWT 握手鉴权

如果 WebSocket 失败，优先检查：

- token 是否是当前环境重新登录后生成的
- Gateway 是否放通并转发 `/ws/**`
- notification-service 的 JWT 配置是否与其他服务一致

## 常见问题

### 1. 返回 401 / 403

优先检查：

- 是否使用了旧 token
- 当前角色是否满足页面权限要求
- Gateway 是否正常注入 Header 认证信息

### 2. 返回 404 / 资源不存在

优先检查：

- 前端 `src/api/*.ts` 使用的前缀是否正确
- Gateway 是否已配置对应路由

### 3. 管理端页面打开但数据为空或异常

优先检查：

- 当前账号是否为 `ADMIN` 或 `OPERATOR`
- Sentinel 是否触发限流
- 对应服务是否已在 Nacos 中注册成功

### 4. 支付页一打开就异常

优先检查：

- 订单是否已超时
- `/api/pay/create` 返回的 `expireAt`
- 后端订单状态是否已被取消

## 开发建议

- 优先修改 `src/api/*.ts` 与后端真实前缀保持一致
- 页面联调时先看浏览器 Network 中第一个失败请求
- 如出现 401 / 403 / 404 / 500，优先区分是鉴权、路由还是业务异常

## 当前状态说明

本 README 已按当前 **微服务 + Gateway 联调模式** 重写，不再按单体后端 `8080` 直连方式描述。
