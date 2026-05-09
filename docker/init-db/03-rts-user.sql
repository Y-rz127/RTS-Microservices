-- ============================================================
-- rts_user 数据库初始化脚本 (user-auth-service)
-- 包含：users, role_permission, operation_log
-- ============================================================

USE `rts_user`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table: users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('ADMIN','OPERATOR','PASSENGER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PASSENGER' COMMENT '角色',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `user_name`(`user_name` ASC) USING BTREE,
  INDEX `idx_username`(`user_name` ASC) USING BTREE,
  INDEX `idx_role`(`role` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission` (
  `permission_id` int NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `role` enum('ADMIN','OPERATOR','PASSENGER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '功能模块',
  `permission` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限标识',
  `permission_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`permission_id`) USING BTREE,
  UNIQUE INDEX `uk_role_permission`(`role` ASC, `module` ASC, `permission` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `operation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作模块',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '方法名',
  `params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求参数',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '返回结果',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `execution_time` int NULL DEFAULT NULL COMMENT '执行时长（毫秒）',
  `status` enum('SUCCESS','FAILURE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SUCCESS' COMMENT '操作状态',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_operation`(`operation` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_log_user_time`(`user_id` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40263 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Trigger: trg_user_update_log
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_user_update_log`;
delimiter ;;
CREATE TRIGGER `trg_user_update_log` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO operation_log (user_id, username, operation, module, params, status)
        VALUES (NEW.user_id, NEW.user_name, 'UPDATE_STATUS', 'USER',
                CONCAT('status changed from ', OLD.status, ' to ', NEW.status), 'SUCCESS');
    END IF;
END ;;
delimiter ;

-- ============================================================
-- 初始化数据
-- ============================================================

-- ----------------------------
-- Records of users (核心账号，密码均为 bcrypt 加密)
-- admin/operator1 密码相同，passenger1/test 各有独立密码
-- ----------------------------
INSERT INTO `users` VALUES (20, 'passenger1', '$2a$10$leCbZXoMjG2A/QPC.iGBGOLFBWh56Zyi3sRkIJ.soom2zl2d5WGvu', 'PASSENGER', '15900139022', 1, '2025-12-04 10:40:58', '2025-12-12 20:50:44');
INSERT INTO `users` VALUES (21, 'test', '$2a$10$G4N2iXI6ktjzPNfLfGVvSOzeYZ149ddWQ1DavyqpKBMjaGTCTm8QW', 'PASSENGER', '15177933537', 1, '2025-12-04 10:40:58', '2025-12-04 10:40:58');
INSERT INTO `users` VALUES (24, 'admin', '$2a$10$X0f02QtfSVfE0kKaFVRuT.hi13X2RhaMcG3JAjiN2Spdrg63ESMlq', 'ADMIN', '13800138000', 1, '2025-12-04 11:06:33', '2025-12-04 22:11:48');
INSERT INTO `users` VALUES (25, 'operator1', '$2a$10$X0f02QtfSVfE0kKaFVRuT.hi13X2RhaMcG3JAjiN2Spdrg63ESMlq', 'OPERATOR', '13800138003', 1, '2025-12-04 11:06:33', '2025-12-10 16:26:02');

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES (1, 'ADMIN', 'USER', 'user:create', '创建用户', '创建新用户账号', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (2, 'ADMIN', 'USER', 'user:update', '更新用户', '更新用户信息', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (3, 'ADMIN', 'USER', 'user:delete', '删除用户', '删除用户账号', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (4, 'ADMIN', 'USER', 'user:query', '查询用户', '查询用户信息', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (5, 'ADMIN', 'TRAIN', 'train:create', '创建车次', '创建新车次', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (6, 'ADMIN', 'TRAIN', 'train:update', '更新车次', '更新车次信息', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (7, 'ADMIN', 'TRAIN', 'train:delete', '删除车次', '删除车次', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (8, 'ADMIN', 'TRAIN', 'train:query', '查询车次', '查询车次信息', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (9, 'OPERATOR', 'TICKET', 'ticket:sell', '售票', '出售车票', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (10, 'OPERATOR', 'TICKET', 'ticket:refund', '退票', '处理退票', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (11, 'OPERATOR', 'TICKET', 'ticket:change', '改签', '处理改签', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (12, 'OPERATOR', 'TICKET', 'ticket:query', '查询车票', '查询车票信息', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (13, 'PASSENGER', 'TICKET', 'ticket:book', '预订车票', '在线预订车票', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (14, 'PASSENGER', 'TICKET', 'ticket:query:own', '查询自己的车票', '查询自己购买的车票', '2025-12-01 23:14:08');
INSERT INTO `role_permission` VALUES (15, 'PASSENGER', 'ORDER', 'order:query:own', '查询自己的订单', '查询自己的订单', '2025-12-01 23:14:08');

SET FOREIGN_KEY_CHECKS = 1;
