# 南宁站售票系统后端 - 微服务版

本仓库是南宁站售票系统的 **微服务后端工程**，基于 Spring Boot 3、Spring Cloud、Spring Cloud Alibaba 构建，当前以 **Gateway + 多业务服务** 为核心。

## 架构概览

当前系统主要由以下部分组成：

- `gateway`
  - API 网关
  - 统一 JWT 解析
  - 路由转发
  - 基础 Sentinel 入口限流

- `user-auth-service`
  - 登录 / 注册 / 当前用户
  - 用户管理
  - 系统配置
  - 操作日志

- `train-service`
  - 车次管理
  - 车站管理
  - 路线管理
  - 字典管理
  - 统计报表

- `sales-service`
  - 个人购票
  - 团体购票
  - 订单管理
  - 座位管理
  - 销售统计
  - 支付模拟
  - 异步抢票 / 支付超时处理

- `approval-service`
  - 退票审批
  - 改签审批
  - 取消预订审批

- `notification-service`
  - WebSocket 通知
  - MQ 结果通知
  - 审批 / 购票结果推送

- `common`
  - 公共配置
  - JWT / Header 认证工具
  - 公共常量 / 通用逻辑

- `entity`
  - 实体模型

- `api-dto`
  - 服务间 DTO / 请求响应对象

- `railway-ticket-system-front-end`
  - 前端工程（独立目录）

## 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Spring Boot | 3.4.1 | 核心框架 |
| Spring Cloud | 2024.0.0 | 微服务基础设施 |
| Spring Cloud Alibaba | 2023.0.1.0 | Nacos / Sentinel / Seata |
| MyBatis-Plus | 3.5.7 | ORM |
| MySQL | 8.0 | 业务数据库 |
| Redis | 7 | 缓存 / 分布式锁 |
| RabbitMQ | 3 | 异步消息 / 延迟支付超时 |
| Nacos | 2.3.0 | 服务注册发现 |
| Sentinel | Alibaba Cloud Starter | 限流 / 熔断入口保护 |
| Seata | 1.8.0 | 分布式事务 |
| JWT | 0.12.5 | 统一身份认证 |
| Spring Security | 6.x | 权限控制 |
| Springdoc OpenAPI | 2.3.0 | API 文档 |

## 仓库结构

```text
railway-ticket-system-back-end/
├── common/
├── entity/
├── api-dto/
├── gateway/
├── user-auth-service/
├── train-service/
├── sales-service/
├── approval-service/
├── notification-service/
├── railway-ticket-system-front-end/
├── docker/
├── sql/
├── seata-config/
├── DATABASE.md
├── docker-compose-sentinel-seata.yml
└── pom.xml
```

## Maven 模块

根 `pom.xml` 采用聚合工程方式管理以下模块：

- `common`
- `entity`
- `api-dto`
- `gateway`
- `user-auth-service`
- `train-service`
- `sales-service`
- `approval-service`
- `notification-service`

## 服务端口（默认）

| 服务 | 端口 |
|------|------|
| gateway | 8081 |
| user-auth-service | 8082 |
| train-service | 8083 |
| sales-service | 8084 |
| approval-service | 8085 |
| notification-service | 8086 |

## 基础中间件

系统依赖以下基础设施：

- MySQL
- Redis
- RabbitMQ
- Nacos
- Sentinel Dashboard
- Seata Server

### 相关编排文件

- `docker/docker-compose.yml`
  - 基础中间件 + 微服务容器编排
- `docker-compose-sentinel-seata.yml`
  - Sentinel / Seata 相关环境编排

## 数据库划分

当前微服务数据库按业务拆分：

- `rts_user`
- `rts_train`
- `rts_ticket`
- `rts_approval`

### Docker 初始化脚本

初始化脚本位于：

- `docker/init-db/01-create-schemas.sql`
- `docker/init-db/02-undo-log.sql`

当前已经修正为仅初始化以下 Seata AT 参与库：

- `rts_user`
- `rts_train`
- `rts_ticket`
- `rts_approval`

已移除历史遗留的：

- `rts_order`

## JWT 与鉴权

系统当前采用 **Gateway 统一解析 JWT** 的方式：

- Gateway 负责解析 Bearer Token
- 解析后的 `userId` / `role` 写入请求头
- 下游服务通过 Header 恢复认证上下文

## 实际接口前缀

当前项目的前端请求统一经过 Gateway 的 `/api/**` 路由，以下是与当前 Controller 映射一致的主要接口前缀：

| 服务 | 接口前缀 | 说明 |
|------|----------|------|
| user-auth-service | `/api/user` | 登录、注册、当前用户、用户管理 |
| user-auth-service | `/api/config` | 系统配置 |
| user-auth-service | `/api/log` | 操作日志 |
| train-service | `/api/train` | 车次管理 |
| train-service | `/api/station` | 车站管理 |
| train-service | `/api/route` | 路线管理 |
| train-service | `/api/dictionary` | 字典管理 |
| train-service | `/api/statistics` | 统计报表 |
| sales-service | `/api/orders` | 订单管理 |
| sales-service | `/api/tickets` | 售票、退票、改签 |
| sales-service | `/api/seats` | 座位管理 |
| sales-service | `/api/pay` | 模拟支付 |
| sales-service | `/api/async/ticket` | 异步抢票 |
| sales-service | `/api/sales/statistics` | 销售统计 |
| sales-service | `/api/hot` | 热门车次 |
| approval-service | `/api/approval` | 乘客审批申请 |
| approval-service | `/api/operator/approval` | 操作员审批 |

文档中若仍出现旧式单体命名（如 `/api/order`、`/api/ticket`、`/api/seat`），请以当前 Controller 映射与 Gateway 路由为准。

相关公共能力位于：

- `common/src/main/java/com/ticket/filter/HeaderAuthenticationFilter.java`
- `common/src/main/java/com/ticket/utils/RequestUserContext.java`
- `common/src/main/java/com/ticket/utils/JwtUtils.java`

### 当前约定

各服务 JWT 配置应保持一致：

```yaml
jwt:
  secret: railway-ticket-system-secret-key-2024
  expire: 86400000
```

## Sentinel 说明

当前项目已经完成一轮入口级 Sentinel 覆盖补齐。

### 已覆盖范围

- Gateway
  - 路径级资源限流
  - 默认基础规则初始化

- user-auth-service
  - 登录
  - 用户管理
  - 系统配置
  - 操作日志

- train-service
  - station
  - route
  - dictionary
  - statistics

- sales-service
  - 销售统计接口
  - 订单分页 / 用户订单
  - 座位分页 / 可用座位 / 布局查询
  - 核心售票 / 退票 / 改签已有业务级 Sentinel 保护

- notification-service
  - WebSocket 握手入口
  - MQ 通知消费入口

### 当前策略

本次补齐优先采用 **入口级 `@SentinelResource` + blockHandler**，目标是：

- 最小侵入
- 快速补全覆盖
- 降低对现有业务逻辑的破坏风险

## Seata 说明

当前项目已经接入 Seata，用于跨服务核心事务。

### 已确认点

- `sales-service` 核心售票、退票、改签已使用 `@GlobalTransactional`
- `approval-service` 核心审批方法已接入分布式事务
- 业务库 `undo_log` 已覆盖主要事务参与库

### 审计结论

- 用户管理未发现明显跨服务写操作
- 审批链关键事务方法未发现遗漏的核心全局事务入口
- `undo_log` 初始化脚本已与现有微服务数据库划分对齐

## MQ / 异步链路

系统使用 RabbitMQ 处理以下场景：

- 购票结果异步通知
- 支付超时自动取消
- 审批结果通知

### 典型链路

- 团体购票 / 异步抢票 -> MQ -> 结果通知 -> WebSocket 推送
- 创建订单 -> 延迟队列 -> 超时监听 -> 自动取消订单

相关常量位于：

- `common/src/main/java/com/ticket/constant/MqConstants.java`

## 支付与超时说明

当前支付页与后端超时逻辑已经统一为：

- 真实超时基于 **订单创建时间** 计算
- 点击“稍后再说”只关闭支付页，不会终止后端超时计时
- 订单页仍应按真实订单状态展示未支付 / 已取消结果
- 如果支付页打开时订单已超时，会直接跳转订单页，不再停留在 `0:00`

### 当前行为

- `createPayment` 返回基于订单创建时间的真实剩余支付时间
- `payOrder` 对以下状态返回更明确错误：
  - `CANCELLED` -> `订单已超时取消`
  - `PAID` -> `订单已支付，请勿重复支付`
  - 其他非法状态 -> `当前订单状态不允许支付`

## 本地开发启动

### 1. 环境要求

- JDK 17+
- Maven 3.8+
- MySQL 8+
- Redis 7+
- RabbitMQ 3+
- Nacos
- Sentinel Dashboard
- Seata Server

### 2. 构建项目

```bash
mvn clean install -DskipTests
```

### 3. 推荐启动顺序

先启动基础设施：

1. MySQL
2. Redis
3. RabbitMQ
4. Nacos
5. Sentinel Dashboard
6. Seata Server

再启动业务服务：

1. `user-auth-service`
2. `train-service`
3. `sales-service`
4. `approval-service`
5. `notification-service`
6. `gateway`

### 4. 前端联调前注意事项

- 重新登录，避免使用旧 JWT
- 确认 Nacos 中所有微服务均已注册
- 确认 Gateway 已包含所有本地调试所需路由

## Docker 启动

### 基础命令

在 `docker/` 目录下使用：

```bash
docker compose up -d
```

或根据你的环境使用根目录补充编排：

```bash
docker compose -f docker/docker-compose.yml up -d
```

### 说明

- MySQL 初始化脚本位于 `docker/init-db/`
- Docker profile 使用各服务的 `application-docker.yml`
- 通知服务、网关、审批服务等已对齐 JWT 配置

## 常见问题

### 1. 后台接口返回 401 / 403

优先检查：

- token 是否为新登录生成
- Gateway 是否正确转发
- 当前账号角色是否为 `ADMIN` / `OPERATOR`

### 2. 页面返回“请求资源不存在”

优先检查：

- Gateway 路由是否已包含对应接口前缀
- 前端请求路径与后端 controller 映射是否一致

### 3. WebSocket 握手失败

优先检查：

- `notification-service` JWT 配置是否与其他服务一致
- `/ws/**` 是否已由 Gateway 正确转发

### 4. 团体购票支付页刚打开就异常

当前已修复：

- 支付页会读取真实订单剩余支付时间
- 已超时订单会直接退出支付页
- “稍后再说”不会中断后端超时取消链路

## 文档补充

- 数据库设计文档：`DATABASE.md`
- Seata 相关 SQL：`sql/seata-sql/`
- Docker 初始化 SQL：`docker/init-db/`
- Seata 配置：`seata-config/`

## 当前状态说明

本仓库当前已经以 **微服务架构** 为主线维护。根 README 以微服务运行方式、基础设施依赖和联调说明为准。
