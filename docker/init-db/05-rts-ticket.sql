-- ============================================================
-- rts_ticket 数据库初始化脚本 (sales-service)
-- 包含：orders, passenger, seat, ticket, ticket_change, refund_record
-- 注意：已移除跨库外键（users/train 等在外部服务）
-- ============================================================

USE `rts_ticket`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table: passenger
-- ----------------------------
DROP TABLE IF EXISTS `passenger`;
CREATE TABLE `passenger` (
  `passenger_id` int NOT NULL AUTO_INCREMENT COMMENT '乘客ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '姓名',
  `id_type` enum('身份证','护照','军官证','学生证','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '身份证' COMMENT '证件类型',
  `id_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '证件号码',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系电话',
  `gender` enum('男','女','未知') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '未知' COMMENT '性别',
  `user_id` int NULL DEFAULT NULL COMMENT '关联用户ID（如果注册为会员）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`passenger_id`) USING BTREE,
  INDEX `idx_id_number`(`id_number` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '乘客表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID（会员购票）',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '订单总金额',
  `payment_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实付金额',
  `order_type` enum('INDIVIDUAL','GROUP') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INDIVIDUAL' COMMENT '订单类型',
  `order_status` enum('UNPAID','PAID','CANCELLED','REFUNDED','PARTIAL_REFUNDED','PENDING_REFUND') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UNPAID' COMMENT '订单状态',
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付方式',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作员ID（柜台购票）',
  `is_pre_booking` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否预订票：0-直接购票，1-预订票',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_number`(`order_number` ASC) USING BTREE,
  INDEX `idx_order_number`(`order_number` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_order_user_status`(`user_id` ASC, `order_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: seat
-- ----------------------------
DROP TABLE IF EXISTS `seat`;
CREATE TABLE `seat` (
  `seat_id` int NOT NULL AUTO_INCREMENT COMMENT '座位ID',
  `train_id` int NOT NULL COMMENT '车次ID',
  `travel_date` date NULL DEFAULT NULL COMMENT '发车日期',
  `carriage_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '车厢号',
  `seat_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '座位号',
  `seat_type` enum('商务座','一等座','二等座','硬座','软座','硬卧','软卧') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '座位类型',
  `seat_level` tinyint NULL DEFAULT 1 COMMENT '座位等级（1-5）',
  `price_coefficient` decimal(3, 2) NULL DEFAULT 1.00 COMMENT '价格系数',
  `status` enum('available','occupied','locked','maintenance') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'available' COMMENT '状态',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`seat_id`) USING BTREE,
  UNIQUE INDEX `idx_train_seat_date`(`train_id` ASC, `seat_number` ASC, `travel_date` ASC) USING BTREE,
  UNIQUE INDEX `uk_train_carriage_seat_date`(`train_id` ASC, `carriage_number` ASC, `seat_number` ASC, `travel_date` ASC) USING BTREE,
  INDEX `idx_train_id`(`train_id` ASC) USING BTREE,
  INDEX `idx_seat_type`(`seat_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_train_date_seat`(`train_id` ASC, `travel_date` ASC, `seat_number` ASC) USING BTREE,
  INDEX `idx_train_date_status`(`train_id` ASC, `travel_date` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7253 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '座位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: ticket
-- ----------------------------
DROP TABLE IF EXISTS `ticket`;
CREATE TABLE `ticket` (
  `ticket_id` int NOT NULL AUTO_INCREMENT COMMENT '车票ID',
  `order_id` int NOT NULL COMMENT '订单ID',
  `ticket_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '车票号',
  `train_id` int NOT NULL COMMENT '车次ID',
  `seat_id` int NOT NULL COMMENT '座位ID',
  `passenger_id` int NOT NULL COMMENT '乘客ID',
  `seller_id` int NULL DEFAULT NULL COMMENT '售票员ID',
  `travel_date` date NOT NULL COMMENT '乘车日期',
  `start_station` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '出发站',
  `end_station` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '到达站',
  `departure_time` time NOT NULL COMMENT '发车时间',
  `arrival_time` time NOT NULL COMMENT '到达时间',
  `price` decimal(10, 2) NOT NULL COMMENT '票价',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `had_pay` tinyint NOT NULL DEFAULT 0 COMMENT '是否已支付：0-未支付，1-已支付',
  `is_PreBook` tinyint NOT NULL DEFAULT 0 COMMENT '是否预订：0-非预订，1-预订',
  `refund_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '退票手续费',
  `sale_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '售票时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`ticket_id`) USING BTREE,
  UNIQUE INDEX `ticket_number`(`ticket_number` ASC) USING BTREE,
  INDEX `idx_ticket_number`(`ticket_number` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_train_id`(`train_id` ASC) USING BTREE,
  INDEX `idx_passenger_id`(`passenger_id` ASC) USING BTREE,
  INDEX `idx_travel_date`(`travel_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_ticket_train_date_status`(`train_id` ASC, `travel_date` ASC, `status` ASC) USING BTREE,
  INDEX `idx_ticket_passenger_status`(`passenger_id` ASC, `status` ASC) USING BTREE,
  INDEX `seat_id`(`seat_id` ASC) USING BTREE,
  INDEX `seller_id`(`seller_id` ASC) USING BTREE,
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `ticket_ibfk_3` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ticket_ibfk_4` FOREIGN KEY (`passenger_id`) REFERENCES `passenger` (`passenger_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 210 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '车票表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: ticket_change
-- ----------------------------
DROP TABLE IF EXISTS `ticket_change`;
CREATE TABLE `ticket_change` (
  `change_id` int NOT NULL AUTO_INCREMENT COMMENT '改签ID',
  `ticket_id` int NOT NULL COMMENT '车票ID（关联ticket表）',
  `old_train_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原车次号',
  `new_train_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新车次号',
  `old_seat_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '原座位号',
  `new_seat_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '新座位号',
  `old_travel_date` date NULL DEFAULT NULL COMMENT '原出行日期',
  `new_travel_date` date NULL DEFAULT NULL COMMENT '新出行日期',
  `change_type` enum('TRAIN','SEAT','BOTH') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '改签类型',
  `price_diff` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '票价差额',
  `change_fee` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '改签手续费',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作员ID',
  `change_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '改签时间',
  `reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '改签原因',
  PRIMARY KEY (`change_id`) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE,
  INDEX `idx_change_time`(`change_time` ASC) USING BTREE,
  INDEX `idx_ticket_id`(`ticket_id` ASC) USING BTREE,
  CONSTRAINT `fk_ticket_change_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: refund_record
-- ----------------------------
DROP TABLE IF EXISTS `refund_record`;
CREATE TABLE `refund_record` (
  `refund_id` int NOT NULL AUTO_INCREMENT COMMENT '退票ID',
  `ticket_id` int NOT NULL COMMENT '车票ID',
  `order_id` int NULL DEFAULT NULL COMMENT '订单ID',
  `passenger_id` int NULL DEFAULT NULL,
  `refund_amount` decimal(10, 2) NOT NULL COMMENT '退款金额',
  `refund_fee` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '退票手续费',
  `refund_type` enum('FULL','PARTIAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'FULL' COMMENT '退票类型',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退票原因',
  `operator_id` int NULL DEFAULT NULL COMMENT '操作员ID',
  `refund_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '退票时间',
  `status` enum('PENDING','APPROVED','REJECTED','COMPLETED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING' COMMENT '状态',
  `refund_status` int NULL DEFAULT 0 COMMENT '退票状态：0-处理中，1-成功，2-失败',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付方式',
  `transaction_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '交易流水号',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`refund_id`) USING BTREE,
  INDEX `passenger_id`(`passenger_id` ASC) USING BTREE,
  INDEX `operator_id`(`operator_id` ASC) USING BTREE,
  INDEX `idx_ticket_id`(`ticket_id` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_refund_time`(`refund_time` ASC) USING BTREE,
  CONSTRAINT `refund_record_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `refund_record_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `refund_record_ibfk_3` FOREIGN KEY (`passenger_id`) REFERENCES `passenger` (`passenger_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退票记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Triggers for orders
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_order_generate_number`;
delimiter ;;
CREATE TRIGGER `trg_order_generate_number` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
    IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        SET NEW.order_number = CONCAT('OD', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
    END IF;
END ;;
delimiter ;

-- ----------------------------
-- Triggers for ticket
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_ticket_insert_update_seat`;
delimiter ;;
CREATE TRIGGER `trg_ticket_insert_update_seat` AFTER INSERT ON `ticket` FOR EACH ROW BEGIN
    IF NEW.had_pay = 1 THEN
        UPDATE seat SET status = 'occupied' WHERE seat_id = NEW.seat_id;
    ELSE
        UPDATE seat SET status = 'locked' WHERE seat_id = NEW.seat_id;
    END IF;
END ;;
delimiter ;

DROP TRIGGER IF EXISTS `trg_ticket_update_release_seat`;
delimiter ;;
CREATE TRIGGER `trg_ticket_update_release_seat` AFTER UPDATE ON `ticket` FOR EACH ROW BEGIN
    IF NEW.status = 'REFUNDED' AND OLD.status != 'REFUNDED' THEN
        UPDATE seat SET status = 'available' WHERE seat_id = NEW.seat_id;
    END IF;
END ;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
