# 南宁站售票管理系统 - 数据库设计文档

## 概述

- **数据库名称**: `railway_ticket_system`
- **字符集**: `utf8mb4`
- **排序规则**: `utf8mb4_unicode_ci`
- **数据库版本**: MySQL 8.0+

---

## 表结构设计

### 1. 用户表 (users)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| user_id | INT | PK, AUTO_INCREMENT | 用户ID |
| username | VARCHAR(50) | UNIQUE, NOT NULL | 用户名 |
| password | VARCHAR(255) | NOT NULL | 密码（BCrypt加密） |
| real_name | VARCHAR(50) | | 真实姓名 |
| id_card | VARCHAR(18) | UNIQUE | 身份证号 |
| phone | VARCHAR(20) | | 手机号 |
| email | VARCHAR(100) | | 邮箱 |
| role | ENUM | NOT NULL | 角色：ADMIN/OPERATOR/PASSENGER |
| status | TINYINT | DEFAULT 1 | 状态：1启用 0禁用 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |
| updated_at | DATETIME | ON UPDATE NOW() | 更新时间 |

### 2. 车次表 (train)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| train_id | INT | PK, AUTO_INCREMENT | 车次ID |
| train_number | VARCHAR(20) | UNIQUE, NOT NULL | 车次号（如G1001） |
| train_type | VARCHAR(20) | NOT NULL | 类型：高铁/动车/快速/直达 |
| total_seats | INT | DEFAULT 0 | 总座位数 |
| start_station | VARCHAR(50) | NOT NULL | 始发站（固定南宁站） |
| end_station | VARCHAR(50) | NOT NULL | 终点站 |
| departure_time | TIME | NOT NULL | 发车时间 |
| arrival_time | TIME | NOT NULL | 到达时间 |
| base_price | DECIMAL(10,2) | | 基础票价 |
| running_days | VARCHAR(20) | | 运行日（1234567=每天） |
| status | TINYINT | DEFAULT 1 | 状态：1运营 0停运 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |

### 3. 车站表 (station)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| station_id | INT | PK, AUTO_INCREMENT | 车站ID |
| station_name | VARCHAR(50) | UNIQUE, NOT NULL | 车站名称 |
| city | VARCHAR(50) | | 所在城市 |
| province | VARCHAR(50) | | 所在省份 |
| status | TINYINT | DEFAULT 1 | 状态：1启用 0禁用 |

### 4. 路线表 (route)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| route_id | INT | PK, AUTO_INCREMENT | 路线ID |
| train_id | INT | FK -> train | 车次ID |
| station_id | INT | FK -> station | 车站ID |
| station_name | VARCHAR(50) | | 站名（冗余） |
| stop_order | INT | NOT NULL | 停靠顺序 |
| arrival_time | TIME | | 到达时间 |
| departure_time | TIME | | 出发时间 |
| stop_duration | INT | DEFAULT 0 | 停留时长（分钟） |
| distance_from_start | INT | DEFAULT 0 | 距起点距离（公里） |
| additional_price | DECIMAL(10,2) | DEFAULT 0 | 区间加价 |

**唯一约束**: `(train_id, station_id)`

### 5. 座位表 (seat)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| seat_id | INT | PK, AUTO_INCREMENT | 座位ID |
| train_id | INT | FK -> train | 车次ID |
| travel_date | DATE | NOT NULL | 乘车日期 |
| seat_number | VARCHAR(10) | NOT NULL | 座位号（如01A） |
| seat_type | VARCHAR(20) | | 座位类型 |
| carriage_number | INT | | 车厢号 |
| status | ENUM | DEFAULT 'AVAILABLE' | 状态 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |

**座位状态**: `AVAILABLE`(可用) / `OCCUPIED`(已售) / `LOCKED`(锁定) / `MAINTENANCE`(维护)

**唯一约束**: `(train_id, travel_date, seat_number)`

### 6. 订单表 (orders)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| order_id | INT | PK, AUTO_INCREMENT | 订单ID |
| order_number | VARCHAR(32) | UNIQUE | 订单号（自动生成） |
| user_id | INT | FK -> users | 用户ID |
| total_amount | DECIMAL(10,2) | | 订单总额 |
| order_status | VARCHAR(20) | | 订单状态 |
| payment_method | VARCHAR(20) | | 支付方式 |
| payment_time | DATETIME | | 支付时间 |
| remark | VARCHAR(500) | | 备注 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |
| updated_at | DATETIME | ON UPDATE NOW() | 更新时间 |

**订单状态**: `PENDING`(待支付) / `PAID`(已支付) / `CANCELLED`(已取消) / `PENDING_REFUND`(退票审批中) / `REFUNDED`(已退票)

### 7. 车票表 (ticket)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| ticket_id | INT | PK, AUTO_INCREMENT | 车票ID |
| ticket_number | VARCHAR(32) | UNIQUE | 车票号（自动生成） |
| order_id | INT | FK -> orders | 订单ID |
| train_id | INT | FK -> train | 车次ID |
| seat_id | INT | FK -> seat | 座位ID |
| passenger_name | VARCHAR(50) | NOT NULL | 乘客姓名 |
| id_type | VARCHAR(20) | | 证件类型 |
| id_number | VARCHAR(30) | | 证件号码 |
| travel_date | DATE | NOT NULL | 乘车日期 |
| start_station | VARCHAR(50) | | 上车站 |
| end_station | VARCHAR(50) | | 下车站 |
| seat_type | VARCHAR(20) | | 座位类型 |
| seat_number | VARCHAR(10) | | 座位号 |
| price | DECIMAL(10,2) | | 票价 |
| status | VARCHAR(20) | DEFAULT 'VALID' | 状态 |
| created_at | DATETIME | DEFAULT NOW() | 创建时间 |

**车票状态**: `VALID`(有效) / `USED`(已使用) / `REFUNDED`(已退票) / `CHANGED`(已改签)

### 8. 乘客信息表 (passenger)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| passenger_id | INT | PK, AUTO_INCREMENT | 乘客ID |
| user_id | INT | FK -> users | 关联用户 |
| passenger_name | VARCHAR(50) | NOT NULL | 乘客姓名 |
| id_type | VARCHAR(20) | DEFAULT '身份证' | 证件类型 |
| id_number | VARCHAR(30) | NOT NULL | 证件号码 |
| phone | VARCHAR(20) | | 手机号 |
| is_default | TINYINT | DEFAULT 0 | 是否默认 |

### 9. 退票/审批记录表 (refund_record / approval_request)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| request_id | INT | 申请ID |
| ticket_id | INT | 关联车票 |
| user_id | INT | 申请用户 |
| request_type | VARCHAR(20) | 类型：REFUND/CHANGE/CANCEL |
| apply_reason | VARCHAR(500) | 申请原因 |
| status | VARCHAR(20) | 状态：PENDING/APPROVED/REJECTED |
| operator_id | INT | 审批操作员 |
| approve_reason | VARCHAR(500) | 审批意见 |
| refund_amount | DECIMAL(10,2) | 退款金额 |
| created_at | DATETIME | 申请时间 |
| updated_at | DATETIME | 处理时间 |

### 10. 改签记录表 (ticket_change)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| change_id | INT | 改签ID |
| original_ticket_id | INT | 原车票ID |
| new_ticket_id | INT | 新车票ID |
| change_fee | DECIMAL(10,2) | 改签费 |
| price_difference | DECIMAL(10,2) | 票价差额 |
| change_time | DATETIME | 改签时间 |

### 11. 系统配置表 (system_config)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| config_id | INT | 配置ID |
| config_key | VARCHAR(50) | 配置键 |
| config_value | VARCHAR(500) | 配置值 |
| description | VARCHAR(200) | 描述 |

### 12. 操作日志表 (operation_log)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| log_id | INT | 日志ID |
| user_id | INT | 操作用户 |
| module | VARCHAR(50) | 模块名 |
| operation | VARCHAR(50) | 操作类型 |
| content | TEXT | 操作内容 |
| ip | VARCHAR(50) | IP地址 |
| status | VARCHAR(20) | 状态 |
| created_at | DATETIME | 操作时间 |

### 13. 数据字典表 (dictionary)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| dict_id | INT | 字典ID |
| dict_type | VARCHAR(50) | 字典类型 |
| dict_code | VARCHAR(50) | 字典编码 |
| dict_label | VARCHAR(100) | 字典标签 |
| sort_order | INT | 排序 |
| status | TINYINT | 状态 |

### 14. 退票记录表 (refund_record)

| 字段名 | 类型 | 说明 |
|--------|------|------|
| refund_id | INT | 退票记录ID |
| ticket_id | INT | 车票ID |
| order_id | INT | 订单ID |
| passenger_id | INT | 乘客ID |
| refund_amount | DECIMAL(10,2) | 退款金额 |
| refund_fee | DECIMAL(10,2) | 手续费 |
| refund_reason | VARCHAR(500) | 退票原因 |
| operator_id | INT | 操作员ID |
| refund_time | DATETIME | 退票时间 |
| refund_status | INT | 状态：0-处理中，1-成功，2-失败 |
| payment_method | VARCHAR(20) | 支付方式 |
| transaction_id | VARCHAR(50) | 交易流水号 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

---

## 存储过程

| 存储过程名 | 参数 | 功能说明 |
|------------|------|----------|
| `sp_get_available_seats` | train_id, travel_date | 查询指定车次和日期的余票信息 |
| `sp_calculate_refund_fee` | ticket_id, OUT refund_fee, OUT refund_amount | 计算退票手续费和退款金额 |
| `sp_ticket_sales_statistics` | start_date, end_date | 按时间段统计售票数据 |
| `sp_train_occupancy_rate` | start_date, end_date | 统计车次上座率 |
| `sp_popular_routes_analysis` | start_date, end_date, limit | 分析热门路线 |
| `sp_seller_performance` | start_date, end_date | 统计售票员业绩 |
| `p_add_train_auto_route` | train_number, ... | 添加车次并自动创建路线 |
| `p_update_route_times` | train_id | 更新路线时间信息 |

---

## 函数

| 函数名 | 参数 | 返回值 | 功能说明 |
|--------|------|--------|----------|
| `fn_calculate_ticket_price` | train_id, start_station, end_station, seat_type | DECIMAL | 计算两站之间的票价 |
| `fn_check_seat_available` | seat_id, travel_date | BOOLEAN | 检查座位是否可用 |
| `fn_get_user_role` | user_id | VARCHAR | 获取用户角色权限 |

---

## 触发器

| 触发器名 | 触发表 | 触发时机 | 功能说明 |
|----------|--------|----------|----------|
| `trg_ticket_insert_update_seat` | ticket | AFTER INSERT | 售票后自动更新座位状态为已占用 |
| `trg_ticket_update_release_seat` | ticket | AFTER UPDATE | 退票后自动释放座位状态 |
| `trg_order_generate_number` | orders | BEFORE INSERT | 自动生成订单号 |
| `trg_ticket_generate_number` | ticket | BEFORE INSERT | 自动生成车票号 |
| `trg_user_update_log` | users | AFTER UPDATE | 记录用户信息变更日志 |

---

## 索引设计

| 表名 | 索引名 | 索引字段 | 类型 | 说明 |
|------|--------|----------|------|------|
| users | idx_username | username | UNIQUE | 用户名唯一索引 |
| users | idx_id_card | id_card | UNIQUE | 身份证唯一索引 |
| train | idx_train_number | train_number | UNIQUE | 车次号唯一索引 |
| seat | idx_train_date | train_id, travel_date | INDEX | 车次日期联合索引 |
| ticket | idx_order_id | order_id | INDEX | 订单外键索引 |
| ticket | idx_travel_date | travel_date | INDEX | 乘车日期索引 |
| route | idx_train_station | train_id, station_id | UNIQUE | 车次站点唯一索引 |
| orders | idx_user_id | user_id | INDEX | 用户外键索引 |
| orders | idx_order_status | order_status | INDEX | 订单状态索引 |

---

## ER关系图

```
users (1) ----< (n) orders ----< (n) ticket
   |                                  |
   |                                  |
   v                                  v
passenger (n)                      seat (1)
                                      |
                                      v
                                   train (1) ----< (n) route >---- (1) station
```

### 主要关系说明

1. **users -> orders**: 一个用户可以有多个订单
2. **orders -> ticket**: 一个订单可以包含多张车票
3. **ticket -> seat**: 一张车票对应一个座位
4. **train -> route**: 一个车次有多个途经站点
5. **route -> station**: 路线关联车站信息
6. **users -> passenger**: 一个用户可以保存多个乘客信息

---

## 初始化脚本

```bash
# 1. 创建数据库和表结构
mysql -u root -p < sql/railway_ticket_system.sql

# 2. 初始化50条车次数据
mysql -u root -p railway_ticket_system < sql/init_50_trains.sql

# 3. 生成路线数据
mysql -u root -p railway_ticket_system < sql/init_routes.sql
```

---

## 默认账号

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | 123456 | ADMIN | 管理员 |
| operator1 | 123456 | OPERATOR | 操作员 |
| passenger1 | 123456 | PASSENGER | 乘客 |

---

## 版本信息

- **文档版本**: 1.0
- **最后更新**: 2025-12-05
- **维护者**: 南宁站售票管理系统开发团队
