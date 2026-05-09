-- ============================================================
-- rts_train 数据库初始化脚本 (train-service)
-- 包含：train, station, route, dictionary, system_config
-- ============================================================

USE `rts_train`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table: dictionary
-- ----------------------------
DROP TABLE IF EXISTS `dictionary`;
CREATE TABLE `dictionary` (
  `dict_id` int NOT NULL AUTO_INCREMENT COMMENT '字典ID',
  `dict_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典类型',
  `dict_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典编码',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '字典值',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `uk_type_code`(`dict_type` ASC, `dict_code` ASC) USING BTREE,
  INDEX `idx_dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '数据字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `config_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置类型',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `is_system` tinyint NOT NULL DEFAULT 0 COMMENT '是否系统内置：0-否，1-是',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_id`) USING BTREE,
  UNIQUE INDEX `config_key`(`config_key` ASC) USING BTREE,
  INDEX `idx_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: station
-- ----------------------------
DROP TABLE IF EXISTS `station`;
CREATE TABLE `station` (
  `station_id` int NOT NULL AUTO_INCREMENT COMMENT '车站ID',
  `station_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '车站名称',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所在城市',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所在省份',
  `station_level` enum('特等站','一等站','二等站','三等站','四等站') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '三等站' COMMENT '车站等级',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-停用，1-启用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`station_id`) USING BTREE,
  UNIQUE INDEX `station_name`(`station_name` ASC) USING BTREE,
  INDEX `idx_city`(`city` ASC) USING BTREE,
  INDEX `idx_name`(`station_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '车站表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: train
-- ----------------------------
DROP TABLE IF EXISTS `train`;
CREATE TABLE `train` (
  `train_id` int NOT NULL AUTO_INCREMENT COMMENT '车次ID',
  `train_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '车次号（如G1234）',
  `train_type` enum('高铁','动车','特快','快速','普快','直达') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '列车类型',
  `total_seats` int NOT NULL DEFAULT 0 COMMENT '总座位数',
  `start_station` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '始发站',
  `end_station` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '终点站',
  `departure_time` time NOT NULL COMMENT '发车时间',
  `arrival_time` time NOT NULL COMMENT '到达时间',
  `base_price` decimal(10, 2) NOT NULL COMMENT '基础票价',
  `running_days` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1234567' COMMENT '运行日期（1-7表示周一到周日）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-停运，1-正常',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`train_id`) USING BTREE,
  UNIQUE INDEX `train_number`(`train_number` ASC) USING BTREE,
  INDEX `idx_train_number`(`train_number` ASC) USING BTREE,
  INDEX `idx_train_type`(`train_type` ASC) USING BTREE,
  INDEX `idx_stations`(`start_station` ASC, `end_station` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '车次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table: route
-- ----------------------------
DROP TABLE IF EXISTS `route`;
CREATE TABLE `route` (
  `route_id` int NOT NULL AUTO_INCREMENT COMMENT '路线ID',
  `train_id` int NOT NULL COMMENT '车次ID',
  `station_id` int NOT NULL COMMENT '车站ID',
  `station_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '站点名称',
  `stop_order` int NOT NULL COMMENT '停靠顺序',
  `arrival_time` time NULL DEFAULT NULL COMMENT '到达时间',
  `departure_time` time NULL DEFAULT NULL COMMENT '出发时间',
  `stop_duration` int NULL DEFAULT 0 COMMENT '停留时长（分钟）',
  `distance_from_start` decimal(8, 2) NULL DEFAULT 0.00 COMMENT '距起点公里数',
  `additional_price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '区间附加价格',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`route_id`) USING BTREE,
  UNIQUE INDEX `uk_train_station`(`train_id` ASC, `station_id` ASC) USING BTREE,
  INDEX `idx_train_id`(`train_id` ASC) USING BTREE,
  INDEX `idx_station_id`(`station_id` ASC) USING BTREE,
  INDEX `idx_stop_order`(`stop_order` ASC) USING BTREE,
  CONSTRAINT `route_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `route_ibfk_2` FOREIGN KEY (`station_id`) REFERENCES `station` (`station_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 216 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '途经站点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Procedure: generate_routes (simplified: auto route generation)
-- ----------------------------
DROP PROCEDURE IF EXISTS `generate_routes`;
delimiter ;;
CREATE PROCEDURE `generate_routes`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_train_id INT;
    DECLARE v_train_number VARCHAR(20);
    DECLARE v_start_station VARCHAR(50);
    DECLARE v_end_station VARCHAR(50);
    DECLARE v_departure_time TIME;
    DECLARE v_arrival_time TIME;
    DECLARE v_base_price DECIMAL(10,2);
    DECLARE v_start_station_id INT;
    DECLARE v_end_station_id INT;
    
    DECLARE train_cursor CURSOR FOR 
        SELECT train_id, train_number, start_station, end_station, departure_time, arrival_time, base_price 
        FROM train;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN train_cursor;
    
    read_loop: LOOP
        FETCH train_cursor INTO v_train_id, v_train_number, v_start_station, v_end_station, v_departure_time, v_arrival_time, v_base_price;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 获取始发站ID
        SELECT station_id INTO v_start_station_id FROM station WHERE station_name = v_start_station LIMIT 1;
        -- 获取终点站ID
        SELECT station_id INTO v_end_station_id FROM station WHERE station_name = v_end_station LIMIT 1;
        
        -- 插入始发站路线
        IF v_start_station_id IS NOT NULL THEN
            INSERT INTO route (train_id, station_id, station_name, stop_order, arrival_time, departure_time, stop_duration, distance_from_start, additional_price)
            VALUES (v_train_id, v_start_station_id, v_start_station, 1, NULL, v_departure_time, 0, 0, 0.00);
        END IF;
        
        -- 插入终点站路线
        IF v_end_station_id IS NOT NULL THEN
            INSERT INTO route (train_id, station_id, station_name, stop_order, arrival_time, departure_time, stop_duration, distance_from_start, additional_price)
            VALUES (v_train_id, v_end_station_id, v_end_station, 2, v_arrival_time, NULL, 0, 500, v_base_price);
        END IF;
    END LOOP;
    
    CLOSE train_cursor;
END ;;
delimiter ;

-- ============================================================
-- 初始化数据
-- ============================================================

-- ----------------------------
-- Records of dictionary
-- ----------------------------
INSERT INTO `dictionary` VALUES (1, 'ID_TYPE', 'ID_CARD', '居民身份证', '1', 1, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (2, 'ID_TYPE', 'PASSPORT', '护照', '2', 2, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (3, 'ID_TYPE', 'HK_MACAU_PASS', '港澳通行证', '3', 3, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (4, 'ID_TYPE', 'TAIWAN_PASS', '台湾通行证', '4', 4, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (5, 'ID_TYPE', 'MILITARY_ID', '军官证', '5', 5, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (6, 'TRAIN_TYPE', 'G', '高铁', 'G', 1, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (7, 'TRAIN_TYPE', 'D', '动车', 'D', 2, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (8, 'TRAIN_TYPE', 'Z', '直达', 'Z', 3, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (9, 'TRAIN_TYPE', 'T', '特快', 'T', 4, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (10, 'TRAIN_TYPE', 'K', '快速', 'K', 5, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (11, 'SEAT_TYPE', 'BUSINESS', '商务座', '1', 1, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (12, 'SEAT_TYPE', 'FIRST', '一等座', '2', 2, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (13, 'SEAT_TYPE', 'SECOND', '二等座', '3', 3, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (14, 'SEAT_TYPE', 'HARD_SLEEPER', '硬卧', '4', 4, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (15, 'SEAT_TYPE', 'SOFT_SLEEPER', '软卧', '5', 5, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (16, 'SEAT_TYPE', 'HARD_SEAT', '硬座', '6', 6, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (17, 'PAYMENT_METHOD', 'WECHAT', '微信支付', '1', 1, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (18, 'PAYMENT_METHOD', 'ALIPAY', '支付宝', '2', 2, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (19, 'PAYMENT_METHOD', 'CARD', '银行卡', '3', 3, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `dictionary` VALUES (20, 'PAYMENT_METHOD', 'CASH', '现金', '4', 4, 1, NULL, '2025-12-02 10:49:54', '2025-12-02 10:49:54');

-- ----------------------------
-- Records of system_config
-- ----------------------------
INSERT INTO `system_config` VALUES (1, 'system.name', '铁路售票管理系统', 'SYSTEM', '系统名称', 1, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (2, 'system.version', '1.0.0', 'SYSTEM', '系统版本', 1, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (3, 'booking.advance_days', '15', 'BUSINESS', '预订提前天数', 0, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (4, 'refund.fee_rate', '0.05', 'BUSINESS', '退票手续费率（5%）', 0, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (5, 'refund.deadline_hours', '2', 'BUSINESS', '退票截止时间（发车前2小时）', 0, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (6, 'change.fee', '10', 'BUSINESS', '改签手续费（元）', 0, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (7, 'change.deadline_hours', '2', 'BUSINESS', '改签截止时间（发车前2小时）', 0, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (8, 'ticket.lock_minutes', '15', 'BUSINESS', '车票锁定时长（分钟）', 0, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (9, 'payment.timeout_minutes', '30', 'BUSINESS', '支付超时时间（分钟）', 0, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');
INSERT INTO `system_config` VALUES (10, 'log.retention_days', '90', 'SYSTEM', '日志保留天数', 1, 1, '2025-12-02 10:49:54', '2025-12-02 10:49:54');

-- ----------------------------
-- Records of station
-- ----------------------------
INSERT INTO `station` VALUES (1, '北京站', '北京', '北京市', '特等站', '北京市东城区毛家湾胡同甲13号', '010-12306001', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (2, '上海站', '上海', '上海市', '特等站', '上海市静安区秣陵路303号', '021-12306002', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (3, '广州南站', '广州', '广东省', '特等站', '广州市番禺区石壁街道南站北路', '020-12306003', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (4, '深圳北站', '深圳', '广东省', '一等站', '深圳市龙华区民治街道', '0755-12306004', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (5, '杭州东站', '杭州', '浙江省', '一等站', '杭州市江干区天城路', '0571-12306005', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (6, '南京南站', '南京', '江苏省', '一等站', '南京市雨花台区玉兰路98号', '025-12306006', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (7, '武汉站', '武汉', '湖北省', '一等站', '武汉市洪山区杨春湖', '027-12306007', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (8, '成都东站', '成都', '四川省', '一等站', '成都市成华区保和街道', '028-12306008', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (9, '西安北站', '西安', '陕西省', '一等站', '西安市未央区元朔路', '029-12306009', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (10, '郑州东站', '郑州', '河南省', '一等站', '郑州市郑东新区', '0371-12306010', 1, '2025-12-02 10:35:37', '2025-12-02 10:35:37');
INSERT INTO `station` VALUES (12, '天津南站', '天津', '天津市', '特等站', '天津市西青区张家窝镇', '022-12306001', 1, '2025-12-04 23:23:07', '2025-12-04 23:23:07');
INSERT INTO `station` VALUES (13, '济南西站', '济南', '山东省', '特等站', '济南市槐荫区齐鲁大道6号', '0531-12306002', 1, '2025-12-04 23:23:07', '2025-12-04 23:23:07');
INSERT INTO `station` VALUES (14, '石家庄站', '石家庄', '河北省', '特等站', '石家庄市桥西区中华南大街', '0311-12306003', 1, '2025-12-04 23:23:07', '2025-12-04 23:23:07');
INSERT INTO `station` VALUES (15, '长沙南站', '长沙', '湖南省', '特等站', '长沙市雨花台区花侯路', '0731-12306004', 1, '2025-12-04 23:23:07', '2025-12-04 23:23:07');
INSERT INTO `station` VALUES (16, '嘉兴南站', '嘉兴', '浙江省', '一等站', '嘉兴市南湖区余新镇', '0573-12306005', 1, '2025-12-04 23:23:07', '2025-12-04 23:23:07');
INSERT INTO `station` VALUES (17, '南宁东站', '南宁', '广西', '特等站', '南宁市青秀区凤岭南路', '0771-12306001', 1, '2025-12-04 23:33:21', '2025-12-04 23:33:21');
INSERT INTO `station` VALUES (18, '桂林北站', '桂林', '广西', '一等站', '桂林市叠彩区站前路', '0773-12306002', 1, '2025-12-04 23:33:21', '2025-12-04 23:33:21');
INSERT INTO `station` VALUES (19, '长沙站', '长沙', '湖南', '特等站', '长沙北路', '07723-12306001', 1, '2025-12-04 23:33:21', '2025-12-04 23:33:21');
INSERT INTO `station` VALUES (21, '南宁站', '南宁', '广西', '三等站', '南宁路', '07724-12306001', 1, '2025-12-05 20:19:13', '2026-03-10 19:01:49');
INSERT INTO `station` VALUES (22, '北京西站', '北京', '北京', '三等站', '北京西路', '07725-12306001', 1, '2025-12-05 20:19:13', '2026-03-10 19:01:55');
INSERT INTO `station` VALUES (23, '上海虹桥站', '上海', '上海', '三等站', '上海虹桥', '07726-12306001', 1, '2025-12-05 20:19:13', '2026-03-10 19:02:02');
INSERT INTO `station` VALUES (24, '昆明南站', '昆明', '云南', '三等站', '昆明南路', '07727-12306001', 1, '2025-12-05 20:19:13', '2026-03-10 19:02:08');
INSERT INTO `station` VALUES (25, '贵阳北站', '贵阳', '贵州', '三等站', '贵阳北路', '07728-12306001', 1, '2025-12-05 20:19:13', '2026-03-10 19:02:18');
INSERT INTO `station` VALUES (26, '柳州站', '柳州', '广西', '三等站', '柳州路', '07729-12306001', 1, '2025-12-05 20:19:13', '2026-03-10 19:02:27');
INSERT INTO `station` VALUES (27, '广州站', '广州', '广东', '三等站', '广州路', '1111444', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:25');
INSERT INTO `station` VALUES (28, '梧州南站', '梧州', '广西', '三等站', '梧州南路', '1984154', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:28');
INSERT INTO `station` VALUES (29, '百色站', '百色', '广西', '三等站', '百色路', '5484511', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:31');
INSERT INTO `station` VALUES (30, '重庆站', '重庆', '重庆', '三等站', '重庆路', '821645511', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:34');
INSERT INTO `station` VALUES (31, '昆明站', '昆明', '云南', '三等站', '昆明路', '116568451', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:37');
INSERT INTO `station` VALUES (32, '成都站', '成都', '四川', '三等站', '成都路', '144511', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:39');
INSERT INTO `station` VALUES (33, '贵阳站', '贵阳', '贵州', '三等站', '贵阳路', '54411484', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:42');
INSERT INTO `station` VALUES (34, '武昌站', '武汉', '湖北', '三等站', '武昌路', '16658448', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:45');
INSERT INTO `station` VALUES (35, '上海南站', '上海', '上海', '三等站', '上海南路', '4848954', 1, '2025-12-05 20:31:02', '2026-03-10 19:03:47');
INSERT INTO `station` VALUES (36, '北海站', '北海市', '广西壮族自治区', '三等站', '北海市', '8808-1113132', 1, '2025-12-11 11:00:19', '2025-12-11 11:00:19');
INSERT INTO `station` VALUES (37, '崇左站', '崇左市', '广西壮族自治区', '三等站', '崇左市北区', '02307110111', 1, '2025-12-11 11:00:19', '2025-12-11 11:00:19');
INSERT INTO `station` VALUES (38, '西大站', '南宁', '广西', '三等站', '广西大学', '15498415411', 1, '2025-12-14 10:36:31', '2026-03-10 19:04:23');

-- ----------------------------
-- Records of train
-- ----------------------------
INSERT INTO `train` VALUES (13, 'G1001', '高铁', 150, '南宁站', '广州南站', '06:30:00', '10:30:00', 219.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (14, 'G1002', '高铁', 150, '南宁站', '广州南站', '08:00:00', '11:00:00', 219.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (15, 'G1003', '高铁', 150, '南宁站', '广州南站', '10:30:00', '13:30:00', 219.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (16, 'G1004', '高铁', 150, '南宁站', '广州南站', '14:00:00', '17:00:00', 219.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (17, 'G1005', '高铁', 150, '南宁站', '深圳北站', '07:00:00', '10:30:00', 289.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (18, 'G1006', '高铁', 150, '南宁站', '深圳北站', '09:30:00', '13:00:00', 289.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (19, 'G1007', '高铁', 150, '南宁站', '深圳北站', '15:00:00', '18:30:00', 289.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (20, 'G1008', '高铁', 150, '南宁站', '北京西站', '08:00:00', '18:00:00', 862.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (21, 'G1009', '高铁', 150, '南宁站', '北京西站', '10:00:00', '20:00:00', 862.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (22, 'G1010', '高铁', 150, '南宁站', '上海虹桥站', '07:30:00', '16:30:00', 793.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (23, 'G1011', '高铁', 150, '南宁站', '上海虹桥站', '09:00:00', '18:00:00', 793.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (24, 'G1012', '高铁', 150, '南宁站', '长沙南站', '08:30:00', '12:30:00', 368.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (25, 'G1013', '高铁', 150, '南宁站', '长沙南站', '13:00:00', '17:00:00', 368.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (26, 'G1014', '高铁', 150, '南宁站', '武汉站', '07:00:00', '12:30:00', 458.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (27, 'G1015', '高铁', 150, '南宁站', '武汉站', '11:00:00', '16:30:00', 458.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (28, 'G1016', '高铁', 150, '南宁站', '贵阳北站', '06:00:00', '09:00:00', 198.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (29, 'G1017', '高铁', 150, '南宁站', '贵阳北站', '12:00:00', '15:00:00', 198.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (30, 'G1018', '高铁', 150, '南宁站', '昆明南站', '08:00:00', '12:00:00', 328.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (31, 'G1019', '高铁', 150, '南宁站', '昆明南站', '14:00:00', '18:00:00', 328.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (32, 'G1020', '高铁', 150, '南宁站', '成都东站', '07:00:00', '14:00:00', 528.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (33, 'D2001', '动车', 120, '南宁站', '桂林北站', '07:00:00', '09:30:00', 108.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (34, 'D2002', '动车', 120, '南宁站', '桂林北站', '09:00:00', '11:30:00', 108.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (35, 'D2003', '动车', 120, '南宁站', '桂林北站', '14:00:00', '16:30:00', 108.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (36, 'D2004', '动车', 120, '南宁站', '桂林北站', '18:00:00', '20:30:00', 108.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (37, 'D2005', '动车', 120, '南宁站', '柳州站', '06:30:00', '08:00:00', 68.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (38, 'D2006', '动车', 120, '南宁站', '柳州站', '10:00:00', '11:30:00', 68.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (39, 'D2007', '动车', 120, '南宁站', '柳州站', '15:00:00', '16:30:00', 68.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (40, 'D2008', '动车', 120, '南宁站', '柳州站', '19:00:00', '20:30:00', 68.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (41, 'D2009', '动车', 120, '南宁站', '广州南站', '07:30:00', '11:30:00', 178.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (42, 'D2010', '动车', 120, '南宁站', '广州南站', '12:00:00', '16:00:00', 178.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (43, 'D2011', '动车', 120, '南宁站', '贵阳北站', '08:00:00', '12:00:00', 158.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (44, 'D2012', '动车', 120, '南宁站', '贵阳北站', '16:00:00', '20:00:00', 158.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (45, 'D2013', '动车', 120, '南宁站', '昆明南站', '09:00:00', '14:00:00', 268.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (46, 'D2014', '动车', 120, '南宁站', '长沙南站', '07:00:00', '13:00:00', 298.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (47, 'D2015', '动车', 120, '南宁站', '深圳北站', '08:30:00', '13:30:00', 238.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (48, 'K501', '快速', 200, '南宁站', '广州站', '18:00:00', '06:00:00', 128.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (49, 'K502', '快速', 200, '南宁站', '广州站', '20:00:00', '08:00:00', 128.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (50, 'K503', '快速', 200, '南宁站', '昆明站', '17:00:00', '07:00:00', 168.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (51, 'K504', '快速', 200, '南宁站', '昆明站', '19:00:00', '09:00:00', 168.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (52, 'K505', '快速', 200, '南宁站', '成都站', '16:00:00', '10:00:00', 258.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (53, 'K506', '快速', 200, '南宁站', '重庆站', '15:00:00', '06:00:00', 218.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (54, 'K507', '快速', 200, '南宁站', '贵阳站', '21:00:00', '06:00:00', 98.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (55, 'K508', '快速', 200, '南宁站', '长沙站', '19:00:00', '08:00:00', 178.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (56, 'K509', '快速', 200, '南宁站', '武昌站', '17:00:00', '09:00:00', 228.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (57, 'K510', '快速', 200, '南宁站', '北京西站', '12:00:00', '18:00:00', 398.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (58, 'Z101', '直达', 180, '南宁站', '北京西站', '16:00:00', '14:00:00', 458.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (59, 'Z102', '直达', 180, '南宁站', '上海南站', '15:00:00', '12:00:00', 428.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (60, 'Z103', '直达', 180, '南宁站', '广州站', '22:00:00', '07:00:00', 138.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (61, 'Z104', '直达', 180, '南宁站', '成都站', '14:00:00', '08:00:00', 318.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (62, 'Z105', '直达', 180, '南宁站', '昆明站', '20:00:00', '08:00:00', 188.00, '1234567', 1, '2025-12-05 20:31:02', '2025-12-05 20:31:02');
INSERT INTO `train` VALUES (66, 'Z106', '直达', 150, '南宁站', '北海站', '10:00:00', '12:30:00', 25.00, '1234567', 1, '2025-12-11 11:28:31', '2025-12-11 11:28:31');
INSERT INTO `train` VALUES (67, 'Z107', '直达', 150, '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, '1234567', 1, '2025-12-14 10:36:31', '2025-12-14 10:36:31');

-- ----------------------------
-- Records of route
-- ----------------------------
INSERT INTO `route` VALUES (39, 13, 21, '南宁站', 1, NULL, '06:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (40, 14, 21, '南宁站', 1, NULL, '08:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (41, 15, 21, '南宁站', 1, NULL, '10:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (42, 16, 21, '南宁站', 1, NULL, '14:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (46, 13, 3, '广州南站', 2, '10:30:00', NULL, 0, 450.00, 220.00, '2025-12-05 20:36:38', '2025-12-10 16:15:23');
INSERT INTO `route` VALUES (47, 14, 3, '广州南站', 2, '11:00:00', NULL, 0, 450.00, 219.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (48, 15, 3, '广州南站', 2, '13:30:00', NULL, 0, 450.00, 219.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (49, 16, 3, '广州南站', 2, '17:00:00', NULL, 0, 450.00, 219.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (53, 17, 21, '南宁站', 1, NULL, '07:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (54, 18, 21, '南宁站', 1, NULL, '09:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (55, 19, 21, '南宁站', 1, NULL, '15:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (56, 17, 3, '广州南站', 2, '09:30:00', '09:35:00', 5, 450.00, 219.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (57, 18, 3, '广州南站', 2, '12:00:00', '12:05:00', 5, 450.00, 219.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (58, 19, 3, '广州南站', 2, '17:30:00', '17:35:00', 5, 450.00, 219.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (59, 17, 4, '深圳北站', 3, '10:30:00', NULL, 0, 560.00, 289.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (60, 18, 4, '深圳北站', 3, '13:00:00', NULL, 0, 560.00, 289.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (61, 19, 4, '深圳北站', 3, '18:30:00', NULL, 0, 560.00, 289.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (62, 20, 21, '南宁站', 1, NULL, '08:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (63, 21, 21, '南宁站', 1, NULL, '10:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (65, 20, 15, '长沙南站', 2, '12:00:00', '12:05:00', 5, 650.00, 368.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (66, 21, 15, '长沙南站', 2, '14:00:00', '14:05:00', 5, 650.00, 368.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (68, 20, 7, '武汉站', 3, '14:00:00', '14:05:00', 5, 1000.00, 458.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (69, 21, 7, '武汉站', 3, '16:00:00', '16:05:00', 5, 1000.00, 458.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (71, 20, 22, '北京西站', 4, '18:00:00', NULL, 0, 1800.00, 862.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (72, 21, 22, '北京西站', 4, '20:00:00', NULL, 0, 1800.00, 862.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (74, 22, 21, '南宁站', 1, NULL, '07:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (75, 23, 21, '南宁站', 1, NULL, '09:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (77, 22, 15, '长沙南站', 2, '11:30:00', '11:35:00', 5, 650.00, 368.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (78, 23, 15, '长沙南站', 2, '13:00:00', '13:05:00', 5, 650.00, 368.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (80, 22, 23, '上海虹桥站', 3, '16:30:00', NULL, 0, 1650.00, 793.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (81, 23, 23, '上海虹桥站', 3, '18:00:00', NULL, 0, 1650.00, 793.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (83, 24, 21, '南宁站', 1, NULL, '08:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (84, 25, 21, '南宁站', 1, NULL, '13:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (85, 26, 21, '南宁站', 1, NULL, '07:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (86, 27, 21, '南宁站', 1, NULL, '11:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (87, 28, 21, '南宁站', 1, NULL, '06:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (88, 29, 21, '南宁站', 1, NULL, '12:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (89, 30, 21, '南宁站', 1, NULL, '08:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (90, 31, 21, '南宁站', 1, NULL, '14:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (91, 32, 21, '南宁站', 1, NULL, '07:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (98, 24, 15, '长沙南站', 2, '12:30:00', NULL, 0, 500.00, 368.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (99, 25, 15, '长沙南站', 2, '17:00:00', NULL, 0, 500.00, 368.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (100, 26, 7, '武汉站', 2, '12:30:00', NULL, 0, 500.00, 458.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (101, 27, 7, '武汉站', 2, '16:30:00', NULL, 0, 500.00, 458.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (102, 28, 25, '贵阳北站', 2, '09:00:00', NULL, 0, 500.00, 198.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (103, 29, 25, '贵阳北站', 2, '15:00:00', NULL, 0, 500.00, 198.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (104, 30, 24, '昆明南站', 2, '12:00:00', NULL, 0, 500.00, 328.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (105, 31, 24, '昆明南站', 2, '18:00:00', NULL, 0, 500.00, 328.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (106, 32, 8, '成都东站', 2, '14:00:00', NULL, 0, 500.00, 528.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (113, 33, 21, '南宁站', 1, NULL, '07:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (114, 34, 21, '南宁站', 1, NULL, '09:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (115, 35, 21, '南宁站', 1, NULL, '14:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (116, 36, 21, '南宁站', 1, NULL, '18:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (120, 33, 26, '柳州站', 2, '08:15:00', '08:18:00', 3, 200.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (121, 34, 26, '柳州站', 2, '10:15:00', '10:18:00', 3, 200.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (122, 35, 26, '柳州站', 2, '15:15:00', '15:18:00', 3, 200.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (123, 36, 26, '柳州站', 2, '19:15:00', '19:18:00', 3, 200.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (127, 33, 18, '桂林北站', 3, '09:30:00', NULL, 0, 350.00, 108.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (128, 34, 18, '桂林北站', 3, '11:30:00', NULL, 0, 350.00, 108.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (129, 35, 18, '桂林北站', 3, '16:30:00', NULL, 0, 350.00, 108.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (130, 36, 18, '桂林北站', 3, '20:30:00', NULL, 0, 350.00, 108.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (134, 37, 21, '南宁站', 1, NULL, '06:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (135, 38, 21, '南宁站', 1, NULL, '10:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (136, 39, 21, '南宁站', 1, NULL, '15:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (137, 40, 21, '南宁站', 1, NULL, '19:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (138, 41, 21, '南宁站', 1, NULL, '07:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (139, 42, 21, '南宁站', 1, NULL, '12:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (140, 43, 21, '南宁站', 1, NULL, '08:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (141, 44, 21, '南宁站', 1, NULL, '16:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (142, 45, 21, '南宁站', 1, NULL, '09:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (143, 46, 21, '南宁站', 1, NULL, '07:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (144, 47, 21, '南宁站', 1, NULL, '08:30:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (149, 37, 26, '柳州站', 2, '08:00:00', NULL, 0, 400.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (150, 38, 26, '柳州站', 2, '11:30:00', NULL, 0, 400.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (151, 39, 26, '柳州站', 2, '16:30:00', NULL, 0, 400.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (152, 40, 26, '柳州站', 2, '20:30:00', NULL, 0, 400.00, 68.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (153, 41, 3, '广州南站', 2, '11:30:00', NULL, 0, 400.00, 178.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (154, 42, 3, '广州南站', 2, '16:00:00', NULL, 0, 400.00, 178.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (155, 43, 25, '贵阳北站', 2, '12:00:00', NULL, 0, 400.00, 158.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (156, 44, 25, '贵阳北站', 2, '20:00:00', NULL, 0, 400.00, 158.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (157, 45, 24, '昆明南站', 2, '14:00:00', NULL, 0, 400.00, 268.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (158, 46, 15, '长沙南站', 2, '13:00:00', NULL, 0, 400.00, 298.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (159, 47, 4, '深圳北站', 2, '13:30:00', NULL, 0, 400.00, 238.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (164, 48, 21, '南宁站', 1, NULL, '18:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (165, 49, 21, '南宁站', 1, NULL, '20:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (166, 50, 21, '南宁站', 1, NULL, '17:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (167, 51, 21, '南宁站', 1, NULL, '19:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (168, 52, 21, '南宁站', 1, NULL, '16:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (169, 53, 21, '南宁站', 1, NULL, '15:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (170, 54, 21, '南宁站', 1, NULL, '21:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (171, 55, 21, '南宁站', 1, NULL, '19:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (172, 56, 21, '南宁站', 1, NULL, '17:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (173, 57, 21, '南宁站', 1, NULL, '12:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (179, 48, 27, '广州站', 2, '06:00:00', NULL, 0, 600.00, 128.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (180, 49, 27, '广州站', 2, '08:00:00', NULL, 0, 600.00, 128.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (181, 50, 31, '昆明站', 2, '07:00:00', NULL, 0, 600.00, 168.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (182, 51, 31, '昆明站', 2, '09:00:00', NULL, 0, 600.00, 168.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (183, 52, 32, '成都站', 2, '10:00:00', NULL, 0, 600.00, 258.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (184, 53, 30, '重庆站', 2, '06:00:00', NULL, 0, 600.00, 218.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (185, 54, 33, '贵阳站', 2, '06:00:00', NULL, 0, 600.00, 98.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (186, 55, 19, '长沙站', 2, '08:00:00', NULL, 0, 600.00, 178.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (187, 56, 34, '武昌站', 2, '09:00:00', NULL, 0, 600.00, 228.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (188, 57, 22, '北京西站', 2, '18:00:00', NULL, 0, 600.00, 398.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (194, 58, 21, '南宁站', 1, NULL, '16:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (195, 59, 21, '南宁站', 1, NULL, '15:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (196, 60, 21, '南宁站', 1, NULL, '22:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (197, 61, 21, '南宁站', 1, NULL, '14:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (198, 62, 21, '南宁站', 1, NULL, '20:00:00', 0, 0.00, 0.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (201, 58, 22, '北京西站', 2, '14:00:00', NULL, 0, 800.00, 458.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (202, 59, 35, '上海南站', 2, '12:00:00', NULL, 0, 800.00, 428.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (203, 60, 27, '广州站', 2, '07:00:00', NULL, 0, 800.00, 138.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (204, 61, 32, '成都站', 2, '08:00:00', NULL, 0, 800.00, 318.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (205, 62, 31, '昆明站', 2, '08:00:00', NULL, 0, 800.00, 188.00, '2025-12-05 20:36:38', '2025-12-05 20:36:38');
INSERT INTO `route` VALUES (212, 66, 21, '南宁站', 1, NULL, '10:00:00', 0, 0.00, 0.00, '2025-12-11 11:28:31', '2025-12-11 11:28:31');
INSERT INTO `route` VALUES (213, 66, 36, '北海站', 2, '12:30:00', NULL, 0, 55.00, 25.00, '2025-12-11 11:28:31', '2025-12-11 17:25:46');
INSERT INTO `route` VALUES (214, 67, 21, '南宁站', 1, NULL, '10:35:59', 0, 0.00, 0.00, '2025-12-14 10:36:31', '2025-12-14 10:36:31');
INSERT INTO `route` VALUES (215, 67, 38, '西大站', 2, '12:35:59', NULL, 0, 1000.00, 15.00, '2025-12-14 10:36:31', '2025-12-14 10:36:31');

SET FOREIGN_KEY_CHECKS = 1;
