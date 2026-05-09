/*
 Navicat Premium Data Transfer

 Source Server         : local-mysql
 Source Server Type    : MySQL
 Source Server Version : 90400
 Source Host           : localhost:3306
 Source Schema         : railway_ticket_system

 Target Server Type    : MySQL
 Target Server Version : 90400
 File Encoding         : 65001

 Date: 23/04/2026 14:59:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for approval_request
-- ----------------------------
DROP TABLE IF EXISTS `approval_request`;
CREATE TABLE `approval_request`  (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `request_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ticket_id` int NOT NULL,
  `order_id` int NOT NULL,
  `user_id` int NOT NULL,
  `operator_id` int NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PENDING',
  `request_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `apply_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `reject_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `processed_at` datetime NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`) USING BTREE,
  INDEX `idx_ticket`(`ticket_id` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 153 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approval_request
-- ----------------------------
INSERT INTO `approval_request` VALUES (33, 'REFUND', 59, 39, 20, 25, 'APPROVED', '{\"refundFee\":87.60,\"isFreeRefund\":false,\"refundAmount\":350.40}', '行程变更', NULL, '2025-12-05 20:44:38', '2025-12-05 20:44:49', '2025-12-05 20:44:49');
INSERT INTO `approval_request` VALUES (34, 'CHANGE_TICKET', 60, 40, 20, 25, 'APPROVED', '{\"newSeatId\":1583,\"priceDifference\":199.00,\"oldPrice\":398.00,\"oldTravelDate\":1765209600000,\"newTravelDate\":1765238400000,\"newSeatNumber\":\"031\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765274400000,\"newPrice\":597,\"oldTrainId\":57,\"newTrainId\":57,\"newDepartureTime\":1765252800000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":60,\"newCarriageNumber\":\"2\",\"oldSeatId\":1702,\"isVirtualSeat\":false}', '换座位', NULL, '2025-12-05 20:51:23', '2025-12-05 20:51:38', '2025-12-05 20:51:38');
INSERT INTO `approval_request` VALUES (35, 'REFUND', 60, 40, 20, 25, 'APPROVED', '{\"refundFee\":0.00,\"isFreeRefund\":false,\"refundAmount\":597.00}', '有事', NULL, '2025-12-05 20:52:07', '2025-12-05 20:57:30', '2025-12-05 20:57:30');
INSERT INTO `approval_request` VALUES (36, 'REFUND', 61, 41, 20, 25, 'APPROVED', '{\"refundFee\":87.60,\"isFreeRefund\":false,\"refundAmount\":350.40}', '有事', NULL, '2025-12-05 21:02:03', '2025-12-05 21:02:11', '2025-12-05 21:02:11');
INSERT INTO `approval_request` VALUES (37, 'CHANGE_TICKET', 62, 42, 20, 25, 'APPROVED', '{\"newSeatId\":2003,\"priceDifference\":1146.00,\"oldPrice\":438.00,\"oldTravelDate\":1764864000000,\"newTravelDate\":1764892800000,\"newSeatNumber\":\"001\",\"newSeatType\":\"商务座\",\"newArrivalTime\":1764914400000,\"newPrice\":1584,\"oldTrainId\":14,\"newTrainId\":32,\"newDepartureTime\":1764889200000,\"newSeatLevel\":1,\"newPriceCoefficient\":2.00,\"oldTicketId\":62,\"newCarriageNumber\":\"1\",\"oldSeatId\":1703,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-05 21:47:36', '2025-12-05 21:47:59', '2025-12-05 21:47:59');
INSERT INTO `approval_request` VALUES (38, 'CHANGE_TICKET', 63, 42, 20, 25, 'APPROVED', '{\"newSeatId\":2004,\"priceDifference\":1255.50,\"oldPrice\":328.50,\"oldTravelDate\":1764864000000,\"newTravelDate\":1764892800000,\"newSeatNumber\":\"002\",\"newSeatType\":\"商务座\",\"newArrivalTime\":1764914400000,\"newPrice\":1584,\"oldTrainId\":14,\"newTrainId\":32,\"newDepartureTime\":1764889200000,\"newSeatLevel\":1,\"newPriceCoefficient\":2.00,\"oldTicketId\":63,\"newCarriageNumber\":\"1\",\"oldSeatId\":1733,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-05 21:47:36', '2025-12-05 21:48:00', '2025-12-05 21:48:00');
INSERT INTO `approval_request` VALUES (39, 'REFUND', 62, 42, 20, 25, 'APPROVED', '{\"refundFee\":316.80,\"isFreeRefund\":false,\"refundAmount\":1267.20}', '有事啊啊', NULL, '2025-12-05 21:48:57', '2025-12-05 21:49:06', '2025-12-05 21:49:06');
INSERT INTO `approval_request` VALUES (40, 'REFUND', 63, 42, 20, 25, 'APPROVED', '{\"refundFee\":316.80,\"isFreeRefund\":false,\"refundAmount\":1267.20}', '有事啊啊', NULL, '2025-12-05 21:48:57', '2025-12-05 21:49:07', '2025-12-05 21:49:07');
INSERT INTO `approval_request` VALUES (41, 'REFUND', 65, 44, 20, 25, 'APPROVED', '{\"refundFee\":0.00,\"isFreeRefund\":false,\"refundAmount\":862.00}', '不想要了', NULL, '2025-12-10 14:30:13', '2025-12-10 14:30:25', '2025-12-10 14:30:25');
INSERT INTO `approval_request` VALUES (42, 'REFUND', 66, 44, 20, 25, 'APPROVED', '{\"refundFee\":0.00,\"isFreeRefund\":false,\"refundAmount\":862.00}', '不想要了', NULL, '2025-12-10 14:30:13', '2025-12-10 14:30:27', '2025-12-10 14:30:27');
INSERT INTO `approval_request` VALUES (43, 'CHANGE_TICKET', 64, 43, 20, 25, 'APPROVED', '{\"newSeatId\":2183,\"priceDifference\":-431.00,\"oldPrice\":1724.00,\"oldTravelDate\":1765296000000,\"newTravelDate\":1765324800000,\"newSeatNumber\":\"031\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765360800000,\"newPrice\":1293,\"oldTrainId\":20,\"newTrainId\":20,\"newDepartureTime\":1765324800000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":64,\"newCarriageNumber\":\"2\",\"oldSeatId\":2153,\"isVirtualSeat\":false}', '临时有事', NULL, '2025-12-10 14:41:14', '2025-12-10 14:41:25', '2025-12-10 14:41:25');
INSERT INTO `approval_request` VALUES (44, 'CHANGE_TICKET', 64, 43, 20, 25, 'APPROVED', '{\"newSeatId\":2233,\"priceDifference\":-431.00,\"oldPrice\":1293.00,\"oldTravelDate\":1765296000000,\"newTravelDate\":1765324800000,\"newSeatNumber\":\"081\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765360800000,\"newPrice\":862,\"oldTrainId\":20,\"newTrainId\":20,\"newDepartureTime\":1765324800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":64,\"newCarriageNumber\":\"3\",\"oldSeatId\":2183,\"isVirtualSeat\":false}', '哈哈', NULL, '2025-12-10 14:42:43', '2025-12-10 14:42:52', '2025-12-10 14:42:52');
INSERT INTO `approval_request` VALUES (45, 'CHANGE_TICKET', 64, 43, 20, 25, 'APPROVED', '{\"newSeatId\":2153,\"priceDifference\":1724.00,\"oldPrice\":862.00,\"oldTravelDate\":1765296000000,\"newTravelDate\":1765324800000,\"newSeatNumber\":\"001\",\"newSeatType\":\"商务座\",\"newArrivalTime\":1765360800000,\"newPrice\":2586,\"oldTrainId\":20,\"newTrainId\":20,\"newDepartureTime\":1765324800000,\"newSeatLevel\":1,\"newPriceCoefficient\":2.00,\"oldTicketId\":64,\"newCarriageNumber\":\"1\",\"oldSeatId\":2233,\"isVirtualSeat\":false}', '你好', NULL, '2025-12-10 14:43:48', '2025-12-10 14:44:00', '2025-12-10 14:44:00');
INSERT INTO `approval_request` VALUES (46, 'REFUND', 70, 48, 20, 25, 'APPROVED', '{\"refundFee\":344.80,\"isFreeRefund\":false,\"refundAmount\":1379.20}', '你好', NULL, '2025-12-10 16:09:08', '2025-12-10 16:09:19', '2025-12-10 16:09:19');
INSERT INTO `approval_request` VALUES (47, 'REFUND', 72, 50, 20, 25, 'APPROVED', '{\"refundFee\":7.50,\"isFreeRefund\":false,\"refundAmount\":30.00}', '临时有事', NULL, '2025-12-11 11:38:23', '2025-12-11 11:38:52', '2025-12-11 11:38:52');
INSERT INTO `approval_request` VALUES (48, 'CHANGE_TICKET', 71, 49, 20, 25, 'REJECTED', '{\"newSeatId\":3353,\"priceDifference\":-350.00,\"oldPrice\":1724.00,\"oldTravelDate\":1765296000000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"001\",\"newSeatType\":\"商务座\",\"newArrivalTime\":1765519200000,\"newPrice\":1374,\"oldTrainId\":20,\"newTrainId\":58,\"newDepartureTime\":1765526400000,\"newSeatLevel\":1,\"newPriceCoefficient\":2.00,\"oldTicketId\":71,\"newCarriageNumber\":\"1\",\"oldSeatId\":2154,\"isVirtualSeat\":false}', '有事', '已经发车，拒绝改签', '2025-12-11 11:39:50', '2025-12-11 11:40:13', '2025-12-11 11:40:13');
INSERT INTO `approval_request` VALUES (49, 'CHANGE_TICKET', 115, 96, 21, 25, 'APPROVED', '{\"newSeatId\":3536,\"priceDifference\":-12.50,\"oldPrice\":50.00,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"034\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765512000000,\"newPrice\":37.5,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":115,\"newCarriageNumber\":\"2\",\"oldSeatId\":3506,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:14:58', '2025-12-11 17:15:10', '2025-12-11 17:15:10');
INSERT INTO `approval_request` VALUES (50, 'CHANGE_TICKET', 116, 96, 21, 25, 'APPROVED', '{\"newSeatId\":3537,\"priceDifference\":-12.50,\"oldPrice\":50.00,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"035\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765512000000,\"newPrice\":37.5,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":116,\"newCarriageNumber\":\"2\",\"oldSeatId\":3507,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:14:58', '2025-12-11 17:15:11', '2025-12-11 17:15:11');
INSERT INTO `approval_request` VALUES (51, 'CHANGE_TICKET', 113, 96, 21, 25, 'APPROVED', '{\"newSeatId\":3534,\"priceDifference\":-12.50,\"oldPrice\":50.00,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"032\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765512000000,\"newPrice\":37.5,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":113,\"newCarriageNumber\":\"2\",\"oldSeatId\":3504,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:14:58', '2025-12-11 17:15:13', '2025-12-11 17:15:13');
INSERT INTO `approval_request` VALUES (52, 'CHANGE_TICKET', 114, 96, 21, 25, 'APPROVED', '{\"newSeatId\":3535,\"priceDifference\":-12.50,\"oldPrice\":50.00,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"033\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765512000000,\"newPrice\":37.5,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":114,\"newCarriageNumber\":\"2\",\"oldSeatId\":3505,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:14:58', '2025-12-11 17:15:14', '2025-12-11 17:15:14');
INSERT INTO `approval_request` VALUES (53, 'CHANGE_TICKET', 112, 96, 21, 25, 'APPROVED', '{\"newSeatId\":3533,\"priceDifference\":-12.50,\"oldPrice\":50.00,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"031\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765512000000,\"newPrice\":37.5,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":112,\"newCarriageNumber\":\"2\",\"oldSeatId\":3503,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:14:58', '2025-12-11 17:15:15', '2025-12-11 17:15:15');
INSERT INTO `approval_request` VALUES (54, 'REFUND', 116, 96, 21, 25, 'APPROVED', '{\"refundFee\":3.75,\"isFreeRefund\":false,\"refundAmount\":33.75}', '有事', NULL, '2025-12-11 17:15:53', '2025-12-11 17:16:00', '2025-12-11 17:16:00');
INSERT INTO `approval_request` VALUES (55, 'REFUND', 112, 96, 21, 25, 'APPROVED', '{\"refundFee\":3.75,\"isFreeRefund\":false,\"refundAmount\":33.75}', '有事', NULL, '2025-12-11 17:15:53', '2025-12-11 17:16:01', '2025-12-11 17:16:01');
INSERT INTO `approval_request` VALUES (56, 'REFUND', 115, 96, 21, 25, 'APPROVED', '{\"refundFee\":3.75,\"isFreeRefund\":false,\"refundAmount\":33.75}', '有事', NULL, '2025-12-11 17:15:53', '2025-12-11 17:16:02', '2025-12-11 17:16:02');
INSERT INTO `approval_request` VALUES (57, 'REFUND', 114, 96, 21, 25, 'APPROVED', '{\"refundFee\":3.75,\"isFreeRefund\":false,\"refundAmount\":33.75}', '有事', NULL, '2025-12-11 17:15:53', '2025-12-11 17:16:04', '2025-12-11 17:16:04');
INSERT INTO `approval_request` VALUES (58, 'REFUND', 113, 96, 21, 25, 'APPROVED', '{\"refundFee\":3.75,\"isFreeRefund\":false,\"refundAmount\":33.75}', '有事', NULL, '2025-12-11 17:15:53', '2025-12-11 17:18:11', '2025-12-11 17:18:11');
INSERT INTO `approval_request` VALUES (59, 'CHANGE_TICKET', 117, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3583,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"081\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":117,\"newCarriageNumber\":\"3\",\"oldSeatId\":3533,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (60, 'CHANGE_TICKET', 118, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3584,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"082\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":118,\"newCarriageNumber\":\"3\",\"oldSeatId\":3534,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (61, 'CHANGE_TICKET', 119, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3585,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"083\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":119,\"newCarriageNumber\":\"3\",\"oldSeatId\":3535,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (62, 'CHANGE_TICKET', 121, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3587,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"085\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":121,\"newCarriageNumber\":\"3\",\"oldSeatId\":3537,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (63, 'CHANGE_TICKET', 120, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3586,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"084\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":120,\"newCarriageNumber\":\"3\",\"oldSeatId\":3536,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (64, 'CHANGE_TICKET', 122, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3588,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"086\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":122,\"newCarriageNumber\":\"3\",\"oldSeatId\":3538,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (65, 'CHANGE_TICKET', 124, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3590,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"088\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":124,\"newCarriageNumber\":\"3\",\"oldSeatId\":3540,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (66, 'CHANGE_TICKET', 123, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3589,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"087\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":123,\"newCarriageNumber\":\"3\",\"oldSeatId\":3539,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:44', '2025-12-11 17:22:44');
INSERT INTO `approval_request` VALUES (67, 'CHANGE_TICKET', 125, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3591,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"089\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":125,\"newCarriageNumber\":\"3\",\"oldSeatId\":3541,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (68, 'CHANGE_TICKET', 126, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3592,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"090\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":126,\"newCarriageNumber\":\"3\",\"oldSeatId\":3542,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (69, 'CHANGE_TICKET', 127, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3593,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"091\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":127,\"newCarriageNumber\":\"3\",\"oldSeatId\":3543,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (70, 'CHANGE_TICKET', 128, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3594,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"092\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":128,\"newCarriageNumber\":\"3\",\"oldSeatId\":3544,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (71, 'CHANGE_TICKET', 130, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3596,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"094\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":130,\"newCarriageNumber\":\"3\",\"oldSeatId\":3546,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (72, 'CHANGE_TICKET', 129, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3595,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"093\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":129,\"newCarriageNumber\":\"3\",\"oldSeatId\":3545,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (73, 'CHANGE_TICKET', 131, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3597,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"095\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":131,\"newCarriageNumber\":\"3\",\"oldSeatId\":3547,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (74, 'CHANGE_TICKET', 132, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3598,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"096\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":132,\"newCarriageNumber\":\"3\",\"oldSeatId\":3548,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (75, 'CHANGE_TICKET', 133, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3599,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"097\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":133,\"newCarriageNumber\":\"3\",\"oldSeatId\":3549,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (76, 'CHANGE_TICKET', 134, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3600,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"098\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":134,\"newCarriageNumber\":\"3\",\"oldSeatId\":3550,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (77, 'CHANGE_TICKET', 135, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3601,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"099\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":135,\"newCarriageNumber\":\"3\",\"oldSeatId\":3551,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (78, 'CHANGE_TICKET', 136, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3602,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"100\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":136,\"newCarriageNumber\":\"3\",\"oldSeatId\":3552,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (79, 'CHANGE_TICKET', 137, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3603,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"101\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":137,\"newCarriageNumber\":\"3\",\"oldSeatId\":3553,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (80, 'CHANGE_TICKET', 138, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3604,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"102\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":138,\"newCarriageNumber\":\"3\",\"oldSeatId\":3554,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (81, 'CHANGE_TICKET', 139, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3605,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"103\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":139,\"newCarriageNumber\":\"3\",\"oldSeatId\":3556,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (82, 'CHANGE_TICKET', 140, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3606,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"104\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":140,\"newCarriageNumber\":\"3\",\"oldSeatId\":3557,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (83, 'CHANGE_TICKET', 141, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3607,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"105\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":141,\"newCarriageNumber\":\"3\",\"oldSeatId\":3555,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:45', '2025-12-11 17:22:45');
INSERT INTO `approval_request` VALUES (84, 'CHANGE_TICKET', 142, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3608,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"106\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":142,\"newCarriageNumber\":\"3\",\"oldSeatId\":3558,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (85, 'CHANGE_TICKET', 143, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3609,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"107\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":143,\"newCarriageNumber\":\"3\",\"oldSeatId\":3560,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (86, 'CHANGE_TICKET', 144, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3610,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"108\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":144,\"newCarriageNumber\":\"3\",\"oldSeatId\":3559,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (87, 'CHANGE_TICKET', 145, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3611,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"109\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":145,\"newCarriageNumber\":\"3\",\"oldSeatId\":3561,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (88, 'CHANGE_TICKET', 147, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3613,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"111\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":147,\"newCarriageNumber\":\"3\",\"oldSeatId\":3563,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (89, 'CHANGE_TICKET', 146, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3612,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"110\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":146,\"newCarriageNumber\":\"3\",\"oldSeatId\":3562,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (90, 'CHANGE_TICKET', 148, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3614,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"112\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":148,\"newCarriageNumber\":\"3\",\"oldSeatId\":3564,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (91, 'CHANGE_TICKET', 149, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3615,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"113\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":149,\"newCarriageNumber\":\"3\",\"oldSeatId\":3565,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (92, 'CHANGE_TICKET', 150, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3616,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"114\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":150,\"newCarriageNumber\":\"3\",\"oldSeatId\":3566,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (93, 'CHANGE_TICKET', 151, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3617,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"115\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":151,\"newCarriageNumber\":\"3\",\"oldSeatId\":3567,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (94, 'CHANGE_TICKET', 153, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3619,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"117\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":153,\"newCarriageNumber\":\"3\",\"oldSeatId\":3569,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (95, 'CHANGE_TICKET', 152, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3618,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"116\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":152,\"newCarriageNumber\":\"3\",\"oldSeatId\":3568,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (96, 'CHANGE_TICKET', 154, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3620,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"118\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":154,\"newCarriageNumber\":\"3\",\"oldSeatId\":3570,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (97, 'CHANGE_TICKET', 156, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3622,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"120\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":156,\"newCarriageNumber\":\"3\",\"oldSeatId\":3572,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (98, 'CHANGE_TICKET', 155, 97, 21, 25, 'APPROVED', '{\"newSeatId\":3621,\"priceDifference\":-12.50,\"oldPrice\":37.50,\"oldTravelDate\":1765468800000,\"newTravelDate\":1765497600000,\"newSeatNumber\":\"119\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1765512000000,\"newPrice\":25,\"oldTrainId\":66,\"newTrainId\":66,\"newDepartureTime\":1765504800000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":155,\"newCarriageNumber\":\"3\",\"oldSeatId\":3571,\"isVirtualSeat\":false}', '有事', NULL, '2025-12-11 17:22:34', '2025-12-11 17:22:46', '2025-12-11 17:22:46');
INSERT INTO `approval_request` VALUES (99, 'REFUND', 121, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `approval_request` VALUES (100, 'REFUND', 119, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `approval_request` VALUES (101, 'REFUND', 118, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `approval_request` VALUES (102, 'REFUND', 120, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `approval_request` VALUES (103, 'REFUND', 122, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (104, 'REFUND', 117, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (105, 'REFUND', 123, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (106, 'REFUND', 124, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (107, 'REFUND', 125, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (108, 'REFUND', 126, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (109, 'REFUND', 128, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (110, 'REFUND', 127, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (111, 'REFUND', 129, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (112, 'REFUND', 130, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (113, 'REFUND', 131, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (114, 'REFUND', 134, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (115, 'REFUND', 132, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (116, 'REFUND', 133, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (117, 'REFUND', 136, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (118, 'REFUND', 135, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (119, 'REFUND', 139, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (120, 'REFUND', 138, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (121, 'REFUND', 137, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (122, 'REFUND', 140, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (123, 'REFUND', 141, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (124, 'REFUND', 142, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (125, 'REFUND', 143, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (126, 'REFUND', 144, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (127, 'REFUND', 145, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (128, 'REFUND', 146, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (129, 'REFUND', 148, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (130, 'REFUND', 147, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (131, 'REFUND', 149, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (132, 'REFUND', 150, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (133, 'REFUND', 151, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (134, 'REFUND', 152, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (135, 'REFUND', 153, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (136, 'REFUND', 154, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (137, 'REFUND', 155, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (138, 'REFUND', 156, 97, 21, 25, 'APPROVED', '{\"refundFee\":2.50,\"isFreeRefund\":false,\"refundAmount\":22.50}', '有事', NULL, '2025-12-11 17:23:19', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `approval_request` VALUES (139, 'CHANGE_TICKET', 158, 99, 20, 25, 'APPROVED', '{\"newSeatId\":4883,\"priceDifference\":1243.00,\"oldPrice\":50.00,\"oldTravelDate\":1765641600000,\"newTravelDate\":1765670400000,\"newSeatNumber\":\"031\",\"newSeatType\":\"一等座\",\"newArrivalTime\":1765706400000,\"newPrice\":1293,\"oldTrainId\":66,\"newTrainId\":20,\"newDepartureTime\":1765670400000,\"newSeatLevel\":2,\"newPriceCoefficient\":1.50,\"oldTicketId\":158,\"newCarriageNumber\":\"2\",\"oldSeatId\":4703,\"isVirtualSeat\":false}', '临时有事', NULL, '2025-12-14 10:32:16', '2025-12-14 10:33:34', '2025-12-14 10:33:34');
INSERT INTO `approval_request` VALUES (140, 'REFUND', 158, 99, 20, 25, 'REJECTED', '{\"refundFee\":258.60,\"isFreeRefund\":false,\"refundAmount\":1034.40}', '11', '不行', '2025-12-14 10:33:48', '2025-12-14 10:34:01', '2025-12-14 10:34:01');
INSERT INTO `approval_request` VALUES (141, 'REFUND', 159, 100, 20, 25, 'APPROVED', '{\"refundFee\":6.00,\"isFreeRefund\":false,\"refundAmount\":24.00}', '行程变更', NULL, '2026-03-10 19:37:58', '2026-03-10 19:43:23', '2026-03-10 19:43:23');
INSERT INTO `approval_request` VALUES (142, 'CHANGE_TICKET', 160, 101, 20, 25, 'APPROVED', '{\"newSeatId\":6052,\"priceDifference\":-15.00,\"oldPrice\":30.00,\"oldTravelDate\":1775836800000,\"newTravelDate\":1775952000000,\"newSeatNumber\":\"150\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1775968559000,\"newPrice\":15,\"oldTrainId\":67,\"newTrainId\":67,\"newDepartureTime\":1775961359000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":160,\"newCarriageNumber\":\"3\",\"oldSeatId\":5753,\"isVirtualSeat\":false}', '今天有急事', NULL, '2026-04-11 11:01:00', '2026-04-11 11:01:41', '2026-04-11 11:01:41');
INSERT INTO `approval_request` VALUES (143, 'CHANGE_TICKET', 160, 101, 20, 25, 'REJECTED', '{\"newSeatId\":6052,\"priceDifference\":-15.00,\"oldPrice\":30.00,\"oldTravelDate\":1775836800000,\"newTravelDate\":1775952000000,\"newSeatNumber\":\"150\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1775968559000,\"newPrice\":15,\"oldTrainId\":67,\"newTrainId\":67,\"newDepartureTime\":1775961359000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":160,\"newCarriageNumber\":\"3\",\"oldSeatId\":5753,\"isVirtualSeat\":false}', '哈哈哈哈', '你哈', '2026-04-11 11:04:31', '2026-04-11 11:18:45', '2026-04-11 11:18:45');
INSERT INTO `approval_request` VALUES (144, 'CHANGE_TICKET', 160, 101, 20, 25, 'REJECTED', '{\"newSeatId\":6053,\"priceDifference\":744.00,\"oldPrice\":30.00,\"oldTravelDate\":1775836800000,\"newTravelDate\":1775865600000,\"newSeatNumber\":\"001\",\"newSeatType\":\"商务座\",\"newArrivalTime\":1775872800000,\"newPrice\":774,\"oldTrainId\":67,\"newTrainId\":52,\"newDepartureTime\":1775894400000,\"newSeatLevel\":1,\"newPriceCoefficient\":2.00,\"oldTicketId\":160,\"newCarriageNumber\":\"1\",\"oldSeatId\":5753,\"isVirtualSeat\":false}', '有事', '原车次已发车', '2026-04-11 11:21:04', '2026-04-11 11:25:30', '2026-04-11 11:25:30');
INSERT INTO `approval_request` VALUES (145, 'REFUND', 164, 103, 20, 25, 'APPROVED', '{\"refundFee\":1.50,\"isFreeRefund\":false,\"refundAmount\":13.50}', '临时有事', NULL, '2026-04-11 11:59:53', '2026-04-11 12:00:01', '2026-04-11 12:00:01');
INSERT INTO `approval_request` VALUES (146, 'REFUND', 165, 104, 20, 25, 'REJECTED', '{\"refundFee\":3.00,\"isFreeRefund\":false,\"refundAmount\":27.00}', '有事', '模式', '2026-04-11 12:07:15', '2026-04-11 12:07:52', '2026-04-11 12:07:52');
INSERT INTO `approval_request` VALUES (147, 'REFUND', 165, 104, 20, 25, 'APPROVED', '{\"refundFee\":3.00,\"isFreeRefund\":false,\"refundAmount\":27.00}', '有事', NULL, '2026-04-11 12:18:27', '2026-04-11 12:18:54', '2026-04-11 12:18:54');
INSERT INTO `approval_request` VALUES (148, 'REFUND', 200, 121, 20, 25, 'APPROVED', '{\"refundAmount\":27.00,\"isFreeRefund\":false,\"refundFee\":3.00}', '有事1', NULL, '2026-04-11 19:42:10', '2026-04-11 19:43:21', '2026-04-11 19:43:21');
INSERT INTO `approval_request` VALUES (149, 'CHANGE_TICKET', 203, 124, 20, 25, 'APPROVED', '{\"newSeatId\":6883,\"priceDifference\":-15.00,\"oldPrice\":30.00,\"oldTravelDate\":1775923200000,\"newTravelDate\":1776038400000,\"newSeatNumber\":\"081\",\"newSeatType\":\"二等座\",\"newArrivalTime\":1776054959000,\"newPrice\":15,\"oldTrainId\":67,\"newTrainId\":67,\"newDepartureTime\":1776047759000,\"newSeatLevel\":3,\"newPriceCoefficient\":1.00,\"oldTicketId\":203,\"newCarriageNumber\":\"3\",\"oldSeatId\":5924,\"isVirtualSeat\":false}', '有事', NULL, '2026-04-11 19:42:38', '2026-04-11 19:48:29', '2026-04-11 19:48:29');
INSERT INTO `approval_request` VALUES (150, 'REFUND', 203, 124, 20, 25, 'REJECTED', '{\"refundAmount\":27.00,\"isFreeRefund\":false,\"refundFee\":3.00}', '有事', '不行', '2026-04-11 19:54:39', '2026-04-11 19:55:07', '2026-04-11 19:55:07');
INSERT INTO `approval_request` VALUES (151, 'REFUND', 204, 124, 20, 25, 'APPROVED', '{\"refundAmount\":14.25,\"isFreeRefund\":false,\"refundFee\":0.75}', '有事', NULL, '2026-04-11 19:54:39', '2026-04-11 19:55:10', '2026-04-11 19:55:10');
INSERT INTO `approval_request` VALUES (152, 'REFUND', 205, 125, 20, 25, 'APPROVED', '{\"isFreeRefund\":false,\"refundFee\":3.00,\"refundAmount\":27.00}', '有事', NULL, '2026-04-11 20:00:23', '2026-04-11 20:00:31', '2026-04-11 20:00:31');
INSERT INTO `approval_request` VALUES (153, 'REFUND', 206, 126, 20, 25, 'APPROVED', '{\"refundFee\":1.50,\"refundAmount\":13.50,\"isFreeRefund\":false}', '有事', NULL, '2026-04-11 20:11:05', '2026-04-11 20:11:13', '2026-04-11 20:11:13');

-- ----------------------------
-- Table structure for dictionary
-- ----------------------------
DROP TABLE IF EXISTS `dictionary`;
CREATE TABLE `dictionary`  (
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
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 40278 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (40257, NULL, 'anonymousUser', '登录', '用户认证', 'com.ticket.controller.UserController.login', NULL, NULL, '0:0:0:0:0:0:0:1', 305, 'SUCCESS', NULL, '2026-04-20 16:42:04');
INSERT INTO `operation_log` VALUES (40258, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"001\",\"name\":\"杨日航\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"12嗯\",\"phone\":\"1额额\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-20\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 12, 'SUCCESS', NULL, '2026-04-20 16:43:12');
INSERT INTO `operation_log` VALUES (40259, NULL, 'anonymousUser', '登录', '用户认证', 'com.ticket.controller.UserController.login', NULL, NULL, '0:0:0:0:0:0:0:1', 263, 'SUCCESS', NULL, '2026-04-21 20:49:56');
INSERT INTO `operation_log` VALUES (40260, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"001\",\"name\":\"分熟\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"12321\",\"phone\":\"213131\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-22\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 13, 'SUCCESS', NULL, '2026-04-21 20:51:23');
INSERT INTO `operation_log` VALUES (40261, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"002\",\"name\":\"你好\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"8551\",\"phone\":\"1566115\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-22\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 0, 'SUCCESS', NULL, '2026-04-21 20:54:11');
INSERT INTO `operation_log` VALUES (40262, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"003\",\"name\":\" i哈苏\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"154845\",\"phone\":\"484521\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-22\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 10, 'SUCCESS', NULL, '2026-04-21 21:00:35');
INSERT INTO `operation_log` VALUES (40263, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"004\",\"name\":\"比成都\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"11465\",\"phone\":\"84951\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-22\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 14, 'SUCCESS', NULL, '2026-04-21 21:23:17');
INSERT INTO `operation_log` VALUES (40264, NULL, 'passenger1', '取消订单', '订单管理', 'com.ticket.controller.OrderController.cancelOrder', '[131]', NULL, '0:0:0:0:0:0:0:1', 28, 'SUCCESS', NULL, '2026-04-21 21:26:48');
INSERT INTO `operation_log` VALUES (40265, NULL, 'passenger1', '取消订单', '订单管理', 'com.ticket.controller.OrderController.cancelOrder', '[130]', NULL, '0:0:0:0:0:0:0:1', 3, 'SUCCESS', NULL, '2026-04-21 21:26:51');
INSERT INTO `operation_log` VALUES (40266, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"005\",\"name\":\"杨挨打的\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"11323\",\"phone\":\"44234\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-22\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 6, 'SUCCESS', NULL, '2026-04-21 21:27:16');
INSERT INTO `operation_log` VALUES (40267, NULL, 'passenger1', '登出', '用户认证', 'com.ticket.controller.UserController.logout', NULL, NULL, '0:0:0:0:0:0:0:1', 0, 'SUCCESS', NULL, '2026-04-21 21:32:33');
INSERT INTO `operation_log` VALUES (40268, NULL, 'anonymousUser', '登录', '用户认证', 'com.ticket.controller.UserController.login', NULL, NULL, '0:0:0:0:0:0:0:1', 107, 'SUCCESS', NULL, '2026-04-21 21:32:34');
INSERT INTO `operation_log` VALUES (40269, NULL, 'passenger1', '取消订单', '订单管理', 'com.ticket.controller.OrderController.cancelOrder', '[132]', NULL, '0:0:0:0:0:0:0:1', 35, 'SUCCESS', NULL, '2026-04-21 21:42:39');
INSERT INTO `operation_log` VALUES (40270, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"006\",\"name\":\"哈哈哈哈\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"1254465\",\"phone\":\"1244214\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-22\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 4, 'SUCCESS', NULL, '2026-04-21 21:43:24');
INSERT INTO `operation_log` VALUES (40271, NULL, 'passenger1', '登出', '用户认证', 'com.ticket.controller.UserController.logout', NULL, NULL, '0:0:0:0:0:0:0:1', 4, 'SUCCESS', NULL, '2026-04-21 22:13:07');
INSERT INTO `operation_log` VALUES (40272, NULL, 'anonymousUser', '登录', '用户认证', 'com.ticket.controller.UserController.login', NULL, NULL, '0:0:0:0:0:0:0:1', 218, 'SUCCESS', NULL, '2026-04-21 22:13:09');
INSERT INTO `operation_log` VALUES (40273, NULL, 'passenger1', '单人抢票', '异步抢票', 'com.ticket.controller.AsyncTicketController.asyncSellTicket', '[{\"trainId\":67,\"seatId\":null,\"seatNumber\":\"003\",\"name\":\"比富\",\"gender\":\"男\",\"idType\":\"身份证\",\"idNumber\":\"65\",\"phone\":\"161\",\"sellerId\":20,\"isPreBooking\":0,\"travelDate\":\"2026-04-22\",\"createdAt\":null}]', NULL, '0:0:0:0:0:0:0:1', 13, 'SUCCESS', NULL, '2026-04-21 22:39:10');
INSERT INTO `operation_log` VALUES (40274, NULL, 'passenger1', '取消订单', '订单管理', 'com.ticket.controller.OrderController.cancelOrder', '[134]', NULL, '0:0:0:0:0:0:0:1', 24, 'SUCCESS', NULL, '2026-04-21 22:41:15');
INSERT INTO `operation_log` VALUES (40275, NULL, 'passenger1', '登出', '用户认证', 'com.ticket.controller.UserController.logout', NULL, NULL, '0:0:0:0:0:0:0:1', 0, 'SUCCESS', NULL, '2026-04-21 22:43:53');
INSERT INTO `operation_log` VALUES (40276, NULL, 'anonymousUser', '登录', '用户认证', 'com.ticket.controller.UserController.login', NULL, NULL, '0:0:0:0:0:0:0:1', 100, 'SUCCESS', NULL, '2026-04-21 22:43:54');
INSERT INTO `operation_log` VALUES (40277, NULL, 'operator1', '登出', '用户认证', 'com.ticket.controller.UserController.logout', NULL, NULL, '0:0:0:0:0:0:0:1', 0, 'SUCCESS', NULL, '2026-04-21 22:44:09');
INSERT INTO `operation_log` VALUES (40278, NULL, 'anonymousUser', '登录', '用户认证', 'com.ticket.controller.UserController.login', NULL, NULL, '0:0:0:0:0:0:0:1', 84, 'SUCCESS', NULL, '2026-04-21 22:44:11');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
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
  INDEX `operator_id`(`operator_id` ASC) USING BTREE,
  INDEX `idx_order_number`(`order_number` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_order_user_status`(`user_id` ASC, `order_status` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`operator_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 134 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (39, 'ORD1764938634431', 20, 219.00, 219.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2025-12-05 20:43:54', 25, 0, '2025-12-05 20:43:54', '2025-12-05 20:44:49');
INSERT INTO `orders` VALUES (40, 'ORD1764938961813', 20, 597.00, 597.00, 'INDIVIDUAL', 'REFUNDED', '微信', '2025-12-05 20:50:05', 25, 1, '2025-12-05 20:49:22', '2025-12-05 20:57:30');
INSERT INTO `orders` VALUES (41, 'ORD1764939693520', 20, 219.00, 219.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2025-12-05 21:01:34', 25, 0, '2025-12-05 21:01:34', '2025-12-05 21:02:11');
INSERT INTO `orders` VALUES (42, 'ORD1764941984678', 20, 3168.00, 3168.00, 'GROUP', 'REFUNDED', '现金', '2025-12-05 21:39:45', 25, 0, '2025-12-05 21:39:45', '2025-12-05 21:49:07');
INSERT INTO `orders` VALUES (43, 'ORD1765347440532', 20, 2586.00, 2586.00, 'INDIVIDUAL', 'PAID', '现金', '2025-12-10 14:17:21', 25, 0, '2025-12-10 14:17:21', '2025-12-10 14:44:00');
INSERT INTO `orders` VALUES (44, 'ORD1765347491009', 20, 1724.00, 1724.00, 'GROUP', 'REFUNDED', '支付宝', '2025-12-10 14:29:49', 25, 1, '2025-12-10 14:18:11', '2025-12-10 14:30:27');
INSERT INTO `orders` VALUES (45, 'ORD1765349217931', 20, 793.00, 793.00, 'INDIVIDUAL', 'PAID', '现金', '2025-12-10 14:46:58', 25, 0, '2025-12-10 14:46:58', '2025-12-10 14:46:58');
INSERT INTO `orders` VALUES (46, 'ORD1765353141401', 20, 862.00, 862.00, 'INDIVIDUAL', 'PAID', '现金', '2025-12-10 15:52:21', 25, 0, '2025-12-10 15:52:21', '2025-12-10 15:52:21');
INSERT INTO `orders` VALUES (47, 'ORD1765353534196', 20, 1189.50, 1189.50, 'INDIVIDUAL', 'PAID', '现金', '2025-12-10 15:58:54', 25, 0, '2025-12-10 15:58:54', '2025-12-10 15:58:54');
INSERT INTO `orders` VALUES (48, 'ORD1765353936300', 20, 1724.00, 1724.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2025-12-10 16:05:36', 25, 0, '2025-12-10 16:05:36', '2025-12-10 16:09:19');
INSERT INTO `orders` VALUES (49, 'ORD1765355834279', 20, 1724.00, 1724.00, 'INDIVIDUAL', 'PAID', '现金', '2025-12-10 16:37:14', 25, 0, '2025-12-10 16:37:14', '2025-12-10 16:37:14');
INSERT INTO `orders` VALUES (50, 'ORD1765424239910', 20, 37.50, 37.50, 'INDIVIDUAL', 'REFUNDED', '现金', '2025-12-11 11:37:20', 25, 0, '2025-12-11 11:37:20', '2025-12-11 11:38:52');
INSERT INTO `orders` VALUES (51, 'OD202412110001', 20, 65.00, 65.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 08:30:00', 25, 0, '2024-12-11 08:30:00', '2024-12-11 08:30:00');
INSERT INTO `orders` VALUES (52, 'OD202412110002', 20, 130.00, 130.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-11 09:00:00', 25, 0, '2024-12-11 09:00:00', '2024-12-11 09:00:00');
INSERT INTO `orders` VALUES (53, 'OD202412110003', 20, 120.00, 120.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 09:30:00', 25, 0, '2024-12-11 09:30:00', '2024-12-11 09:30:00');
INSERT INTO `orders` VALUES (54, 'OD202412110004', 20, 200.00, 200.00, 'INDIVIDUAL', 'PAID', '银行卡', '2024-12-11 10:00:00', 25, 0, '2024-12-11 10:00:00', '2024-12-11 10:00:00');
INSERT INTO `orders` VALUES (55, 'OD202412110005', 20, 250.00, 250.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 10:30:00', 25, 0, '2024-12-11 10:30:00', '2024-12-11 10:30:00');
INSERT INTO `orders` VALUES (56, 'OD202412110006', 20, 80.00, 80.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-11 11:00:00', 25, 0, '2024-12-11 11:00:00', '2024-12-11 11:00:00');
INSERT INTO `orders` VALUES (57, 'OD202412110007', 20, 45.00, 45.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 11:30:00', 25, 0, '2024-12-11 11:30:00', '2024-12-11 11:30:00');
INSERT INTO `orders` VALUES (58, 'OD202412110008', 20, 70.00, 70.00, 'INDIVIDUAL', 'PAID', '现金', '2024-12-11 12:00:00', 25, 0, '2024-12-11 12:00:00', '2024-12-11 12:00:00');
INSERT INTO `orders` VALUES (59, 'OD202412110009', 20, 350.00, 350.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 12:30:00', 25, 0, '2024-12-11 12:30:00', '2024-12-11 12:30:00');
INSERT INTO `orders` VALUES (60, 'OD202412110010', 20, 320.00, 320.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-11 13:00:00', 25, 0, '2024-12-11 13:00:00', '2024-12-11 13:00:00');
INSERT INTO `orders` VALUES (61, 'OD202412110011', 20, 280.00, 280.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 13:30:00', 25, 0, '2024-12-11 13:30:00', '2024-12-11 13:30:00');
INSERT INTO `orders` VALUES (62, 'OD202412110012', 20, 260.00, 260.00, 'INDIVIDUAL', 'PAID', '银行卡', '2024-12-11 14:00:00', 25, 0, '2024-12-11 14:00:00', '2024-12-11 14:00:00');
INSERT INTO `orders` VALUES (63, 'OD202412110013', 20, 150.00, 150.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 14:30:00', 25, 0, '2024-12-11 14:30:00', '2024-12-11 14:30:00');
INSERT INTO `orders` VALUES (64, 'OD202412110014', 20, 400.00, 400.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-11 15:00:00', 25, 0, '2024-12-11 15:00:00', '2024-12-11 15:00:00');
INSERT INTO `orders` VALUES (65, 'OD202412110015', 20, 65.00, 65.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 15:30:00', 25, 0, '2024-12-11 15:30:00', '2024-12-11 15:30:00');
INSERT INTO `orders` VALUES (66, 'OD202412110016', 20, 97.50, 97.50, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-11 16:00:00', 25, 0, '2024-12-11 16:00:00', '2024-12-11 16:00:00');
INSERT INTO `orders` VALUES (67, 'OD202412110017', 20, 120.00, 120.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 16:30:00', 25, 0, '2024-12-11 16:30:00', '2024-12-11 16:30:00');
INSERT INTO `orders` VALUES (68, 'OD202412110018', 20, 200.00, 200.00, 'INDIVIDUAL', 'PAID', '现金', '2024-12-11 17:00:00', 25, 0, '2024-12-11 17:00:00', '2024-12-11 17:00:00');
INSERT INTO `orders` VALUES (69, 'OD202412110019', 20, 250.00, 250.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-11 17:30:00', 25, 0, '2024-12-11 17:30:00', '2024-12-11 17:30:00');
INSERT INTO `orders` VALUES (70, 'OD202412110020', 20, 80.00, 80.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-11 18:00:00', 25, 0, '2024-12-11 18:00:00', '2024-12-11 18:00:00');
INSERT INTO `orders` VALUES (71, 'OD202412110021', 20, 45.00, 45.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-10 08:00:00', 25, 0, '2024-12-10 08:00:00', '2024-12-10 08:00:00');
INSERT INTO `orders` VALUES (72, 'OD202412110022', 20, 70.00, 70.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-10 09:00:00', 25, 0, '2024-12-10 09:00:00', '2024-12-10 09:00:00');
INSERT INTO `orders` VALUES (73, 'OD202412110023', 20, 350.00, 350.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-10 10:00:00', 25, 0, '2024-12-10 10:00:00', '2024-12-10 10:00:00');
INSERT INTO `orders` VALUES (74, 'OD202412110024', 20, 320.00, 320.00, 'INDIVIDUAL', 'PAID', '银行卡', '2024-12-10 11:00:00', 25, 0, '2024-12-10 11:00:00', '2024-12-10 11:00:00');
INSERT INTO `orders` VALUES (75, 'OD202412110025', 20, 280.00, 280.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-10 12:00:00', 25, 0, '2024-12-10 12:00:00', '2024-12-10 12:00:00');
INSERT INTO `orders` VALUES (76, 'OD202412110026', 20, 260.00, 260.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-10 13:00:00', 25, 0, '2024-12-10 13:00:00', '2024-12-10 13:00:00');
INSERT INTO `orders` VALUES (77, 'OD202412110027', 20, 150.00, 150.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-10 14:00:00', 25, 0, '2024-12-10 14:00:00', '2024-12-10 14:00:00');
INSERT INTO `orders` VALUES (78, 'OD202412110028', 20, 400.00, 400.00, 'INDIVIDUAL', 'PAID', '现金', '2024-12-10 15:00:00', 25, 0, '2024-12-10 15:00:00', '2024-12-10 15:00:00');
INSERT INTO `orders` VALUES (79, 'OD202412110029', 20, 65.00, 65.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-10 16:00:00', 25, 0, '2024-12-10 16:00:00', '2024-12-10 16:00:00');
INSERT INTO `orders` VALUES (80, 'OD202412110030', 20, 97.50, 97.50, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-10 17:00:00', 25, 0, '2024-12-10 17:00:00', '2024-12-10 17:00:00');
INSERT INTO `orders` VALUES (81, 'OD202412110036', 20, 70.00, 0.00, 'INDIVIDUAL', 'REFUNDED', '微信支付', '2024-12-09 10:00:00', 25, 0, '2024-12-09 10:00:00', '2024-12-09 10:00:00');
INSERT INTO `orders` VALUES (82, 'OD202412110037', 20, 350.00, 0.00, 'INDIVIDUAL', 'REFUNDED', '支付宝', '2024-12-09 11:00:00', 25, 0, '2024-12-09 11:00:00', '2024-12-09 11:00:00');
INSERT INTO `orders` VALUES (83, 'OD202412110038', 20, 320.00, 320.00, 'GROUP', 'PAID', '银行卡', '2024-12-09 12:00:00', 25, 0, '2024-12-09 12:00:00', '2024-12-09 12:00:00');
INSERT INTO `orders` VALUES (84, 'OD202412110039', 20, 280.00, 280.00, 'GROUP', 'PAID', '银行卡', '2024-12-09 13:00:00', 25, 0, '2024-12-09 13:00:00', '2024-12-09 13:00:00');
INSERT INTO `orders` VALUES (85, 'OD202412110040', 20, 260.00, 260.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-09 14:00:00', 25, 1, '2024-12-09 14:00:00', '2024-12-09 14:00:00');
INSERT INTO `orders` VALUES (86, 'OD202412110041', 20, 150.00, 150.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-09 15:00:00', 25, 1, '2024-12-09 15:00:00', '2024-12-09 15:00:00');
INSERT INTO `orders` VALUES (87, 'OD202412110042', 20, 400.00, 400.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-09 16:00:00', 25, 1, '2024-12-09 16:00:00', '2024-12-09 16:00:00');
INSERT INTO `orders` VALUES (88, 'OD202412110043', 20, 65.00, 65.00, 'INDIVIDUAL', 'PAID', '现金', '2024-12-09 17:00:00', 25, 0, '2024-12-09 17:00:00', '2024-12-09 17:00:00');
INSERT INTO `orders` VALUES (89, 'OD202412110044', 20, 97.50, 97.50, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-08 08:00:00', 25, 0, '2024-12-08 08:00:00', '2024-12-08 08:00:00');
INSERT INTO `orders` VALUES (90, 'OD202412110045', 20, 120.00, 120.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-08 09:00:00', 25, 0, '2024-12-08 09:00:00', '2024-12-08 09:00:00');
INSERT INTO `orders` VALUES (91, 'OD202412110046', 20, 200.00, 200.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-08 10:00:00', 25, 0, '2024-12-08 10:00:00', '2024-12-08 10:00:00');
INSERT INTO `orders` VALUES (92, 'OD202412110047', 20, 250.00, 250.00, 'INDIVIDUAL', 'PAID', '银行卡', '2024-12-08 11:00:00', 25, 0, '2024-12-08 11:00:00', '2024-12-08 11:00:00');
INSERT INTO `orders` VALUES (93, 'OD202412110048', 20, 80.00, 80.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-08 12:00:00', 25, 0, '2024-12-08 12:00:00', '2024-12-08 12:00:00');
INSERT INTO `orders` VALUES (94, 'OD202412110049', 20, 45.00, 45.00, 'INDIVIDUAL', 'PAID', '支付宝', '2024-12-08 13:00:00', 25, 0, '2024-12-08 13:00:00', '2024-12-08 13:00:00');
INSERT INTO `orders` VALUES (95, 'OD202412110050', 20, 70.00, 70.00, 'INDIVIDUAL', 'PAID', '微信支付', '2024-12-08 14:00:00', 25, 0, '2024-12-08 14:00:00', '2024-12-08 14:00:00');
INSERT INTO `orders` VALUES (96, 'ORD1765444460566', 21, 187.50, 187.50, 'GROUP', 'REFUNDED', '现金', '2025-12-11 17:14:21', 25, 0, '2025-12-11 17:14:21', '2025-12-11 17:18:11');
INSERT INTO `orders` VALUES (97, 'ORD1765444898936', 21, 1000.00, 1000.00, 'GROUP', 'REFUNDED', '现金', '2025-12-11 17:21:39', 25, 0, '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `orders` VALUES (98, 'ORD1765445069428', 20, 25.00, 25.00, 'INDIVIDUAL', 'PAID', '现金', '2025-12-11 17:24:29', 25, 0, '2025-12-11 17:24:29', '2025-12-11 17:24:29');
INSERT INTO `orders` VALUES (99, 'ORD1765679467671', 20, 1293.00, 1293.00, 'INDIVIDUAL', 'PAID', '现金', '2025-12-14 10:31:08', 25, 0, '2025-12-14 10:31:08', '2025-12-14 10:33:34');
INSERT INTO `orders` VALUES (100, 'ORD1773142121792', 20, 30.00, 30.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2026-03-10 19:28:42', 25, 0, '2026-03-10 19:28:42', '2026-03-10 19:43:23');
INSERT INTO `orders` VALUES (101, 'ORD1775876329949', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 10:58:50', 25, 0, '2026-04-11 10:58:50', '2026-04-11 10:58:50');
INSERT INTO `orders` VALUES (102, 'ORD1775879242264', 20, 954.00, 954.00, 'GROUP', 'PAID', '现金', '2026-04-11 11:47:22', 25, 0, '2026-04-11 11:47:22', '2026-04-11 11:47:22');
INSERT INTO `orders` VALUES (103, 'ORD1775879680088', 20, 15.00, 15.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2026-04-11 11:54:40', 25, 0, '2026-04-11 11:54:40', '2026-04-11 12:00:01');
INSERT INTO `orders` VALUES (104, 'ORD1775880352690', 20, 30.00, 30.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2026-04-11 12:05:53', 25, 0, '2026-04-11 12:05:53', '2026-04-11 12:18:54');
INSERT INTO `orders` VALUES (105, 'ORD1775881768707', 20, 477.00, 477.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 12:29:29', 25, 0, '2026-04-11 12:29:29', '2026-04-11 12:29:29');
INSERT INTO `orders` VALUES (106, 'ORD1775886627700', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 13:50:28', 25, 0, '2026-04-11 13:50:28', '2026-04-11 13:50:28');
INSERT INTO `orders` VALUES (107, 'ORD1775886742413', 20, 22.50, 22.50, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 13:52:22', 25, 0, '2026-04-11 13:52:22', '2026-04-11 13:52:22');
INSERT INTO `orders` VALUES (108, 'ORD1775890157451', 20, 516.00, 516.00, 'GROUP', 'PAID', '现金', '2026-04-11 14:49:17', 25, 0, '2026-04-11 14:49:17', '2026-04-11 14:49:17');
INSERT INTO `orders` VALUES (109, 'ORD1775890543984', 20, 30.00, 30.00, 'GROUP', 'PAID', '现金', '2026-04-11 14:55:44', 25, 0, '2026-04-11 14:55:44', '2026-04-11 14:55:44');
INSERT INTO `orders` VALUES (110, 'ORD1775890770988', 20, 45.00, 45.00, 'GROUP', 'PAID', '现金', '2026-04-11 14:59:31', 25, 0, '2026-04-11 14:59:31', '2026-04-11 14:59:31');
INSERT INTO `orders` VALUES (111, 'ORD1775891676397', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 15:14:36', 25, 0, '2026-04-11 15:14:36', '2026-04-11 15:14:36');
INSERT INTO `orders` VALUES (112, 'ORD1775891721857', 20, 30.00, 30.00, 'GROUP', 'PAID', '现金', '2026-04-11 15:15:22', 25, 0, '2026-04-11 15:15:22', '2026-04-11 15:15:22');
INSERT INTO `orders` VALUES (113, 'ORD1775892089998', 20, 30.00, 30.00, 'GROUP', 'PAID', '现金', '2026-04-11 15:21:30', 25, 0, '2026-04-11 15:21:30', '2026-04-11 15:21:30');
INSERT INTO `orders` VALUES (114, 'ORD1775892238494', 20, 30.00, 30.00, 'GROUP', 'PAID', '现金', '2026-04-11 15:23:58', 25, 0, '2026-04-11 15:23:58', '2026-04-11 15:23:58');
INSERT INTO `orders` VALUES (115, 'ORD1775892350043', 20, 30.00, 30.00, 'GROUP', 'PAID', '现金', '2026-04-11 15:25:50', 25, 0, '2026-04-11 15:25:50', '2026-04-11 15:25:50');
INSERT INTO `orders` VALUES (116, 'ORD1775892567830', 20, 30.00, 30.00, 'GROUP', 'PAID', '现金', '2026-04-11 15:29:28', 25, 0, '2026-04-11 15:29:28', '2026-04-11 15:29:28');
INSERT INTO `orders` VALUES (117, 'ORD1775892835908', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 15:33:56', 25, 0, '2026-04-11 15:33:56', '2026-04-11 15:33:56');
INSERT INTO `orders` VALUES (118, 'ORD1775892995681', 20, 22.50, 22.50, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 15:36:36', 25, 0, '2026-04-11 15:36:36', '2026-04-11 15:36:36');
INSERT INTO `orders` VALUES (119, 'ORD1775893595244', 20, 150.00, 150.00, 'GROUP', 'PAID', '现金', '2026-04-11 15:46:35', 25, 0, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `orders` VALUES (120, 'ORD1775894831641', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 16:07:12', 25, 0, '2026-04-11 16:07:12', '2026-04-11 16:07:12');
INSERT INTO `orders` VALUES (121, 'ORD1775896178740', 20, 30.00, 30.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2026-04-11 16:29:39', 25, 0, '2026-04-11 16:29:39', '2026-04-11 19:43:21');
INSERT INTO `orders` VALUES (122, 'ORD1775896178770', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 16:29:39', 25, 0, '2026-04-11 16:29:39', '2026-04-11 16:29:39');
INSERT INTO `orders` VALUES (123, 'ORD1775896178790', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-11 16:29:39', 25, 0, '2026-04-11 16:29:39', '2026-04-11 16:29:39');
INSERT INTO `orders` VALUES (124, 'ORD1775896816828', 20, 30.00, 30.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2026-04-11 16:40:17', 25, 0, '2026-04-11 16:40:17', '2026-04-11 19:55:10');
INSERT INTO `orders` VALUES (125, 'ORD1775908786383', 20, 30.00, 30.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2026-04-11 19:59:46', 25, 0, '2026-04-11 19:59:46', '2026-04-11 20:00:31');
INSERT INTO `orders` VALUES (126, 'ORD1775909444921', 20, 15.00, 15.00, 'INDIVIDUAL', 'REFUNDED', '现金', '2026-04-11 20:10:45', 25, 0, '2026-04-11 20:10:45', '2026-04-11 20:11:13');
INSERT INTO `orders` VALUES (127, 'ORD1776674591830', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-20 16:43:12', 25, 0, '2026-04-20 16:43:12', '2026-04-20 16:43:12');
INSERT INTO `orders` VALUES (128, 'ORD1776775882598', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-21 20:51:23', 25, 0, '2026-04-21 20:51:23', '2026-04-21 20:51:23');
INSERT INTO `orders` VALUES (129, 'ORD1776776050966', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', '现金', '2026-04-21 20:54:11', 25, 0, '2026-04-21 20:54:11', '2026-04-21 20:54:11');
INSERT INTO `orders` VALUES (130, 'ORD1776776434594', 20, 30.00, 30.00, 'INDIVIDUAL', 'CANCELLED', NULL, NULL, 25, 0, '2026-04-21 21:00:35', '2026-04-21 21:26:51');
INSERT INTO `orders` VALUES (131, 'ORD1776777797411', 20, 30.00, 30.00, 'INDIVIDUAL', 'CANCELLED', NULL, NULL, 25, 0, '2026-04-21 21:23:17', '2026-04-21 21:26:48');
INSERT INTO `orders` VALUES (132, 'ORD1776778036273', 20, 30.00, 30.00, 'INDIVIDUAL', 'CANCELLED', NULL, NULL, 25, 0, '2026-04-21 21:27:16', '2026-04-21 21:42:39');
INSERT INTO `orders` VALUES (133, 'ORD1776779003580', 20, 30.00, 30.00, 'INDIVIDUAL', 'PAID', 'MOCK', '2026-04-21 22:16:13', 25, 0, '2026-04-21 21:43:24', '2026-04-21 22:16:13');
INSERT INTO `orders` VALUES (134, 'ORD1776782349594', 20, 30.00, 30.00, 'INDIVIDUAL', 'CANCELLED', NULL, NULL, 25, 0, '2026-04-21 22:39:10', '2026-04-21 22:41:15');

-- ----------------------------
-- Table structure for passenger
-- ----------------------------
DROP TABLE IF EXISTS `passenger`;
CREATE TABLE `passenger`  (
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
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `passenger_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 214 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '乘客表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of passenger
-- ----------------------------
INSERT INTO `passenger` VALUES (30, '杨', '身份证', '12', '12', '男', 20, '2025-12-04 11:08:51', '2025-12-04 11:08:51');
INSERT INTO `passenger` VALUES (31, '1', '身份证', '1', '1', '男', 20, '2025-12-04 11:14:04', '2025-12-04 11:14:04');
INSERT INTO `passenger` VALUES (32, '12', '身份证', '12', '12', '男', 20, '2025-12-04 11:26:40', '2025-12-04 11:26:39');
INSERT INTO `passenger` VALUES (33, '11', '身份证', '22', '33', '男', 20, '2025-12-04 11:27:38', '2025-12-04 11:27:37');
INSERT INTO `passenger` VALUES (34, '的', '护照', '4', '3', '男', 20, '2025-12-04 11:48:18', '2025-12-04 11:48:18');
INSERT INTO `passenger` VALUES (35, '发1', '身份证', '2', '1', '男', 20, '2025-12-04 11:49:11', '2025-12-04 11:49:10');
INSERT INTO `passenger` VALUES (36, '12', '身份证', '12', '1', '男', 20, '2025-12-04 11:58:39', '2025-12-04 11:58:39');
INSERT INTO `passenger` VALUES (37, '1', '身份证', '22', '33', '男', 20, '2025-12-04 12:05:42', '2025-12-04 12:05:42');
INSERT INTO `passenger` VALUES (38, '11', '护照', '2', '1', '男', 20, '2025-12-04 12:59:00', '2025-12-04 12:59:00');
INSERT INTO `passenger` VALUES (39, '啊哈哈', '身份证', '1', '1', '男', 20, '2025-12-04 13:14:25', '2025-12-04 13:14:25');
INSERT INTO `passenger` VALUES (40, '哈哈1', '身份证', '222', '111', '男', 20, '2025-12-04 18:00:56', '2025-12-04 18:00:55');
INSERT INTO `passenger` VALUES (41, '哈哈2', '身份证', '222', '111', '男', 20, '2025-12-04 18:00:56', '2025-12-04 18:00:55');
INSERT INTO `passenger` VALUES (42, '12', '军官证', '21', '12', '男', 20, '2025-12-04 18:03:33', '2025-12-04 18:03:33');
INSERT INTO `passenger` VALUES (43, '21', '身份证', '21', '11', '女', 20, '2025-12-04 18:03:33', '2025-12-04 18:03:33');
INSERT INTO `passenger` VALUES (44, '111', '身份证', '111', '111', '男', 20, '2025-12-04 19:02:11', '2025-12-04 19:02:11');
INSERT INTO `passenger` VALUES (45, '222', '身份证', '222', '222', '女', 20, '2025-12-04 19:02:11', '2025-12-04 19:02:11');
INSERT INTO `passenger` VALUES (46, '羊羊羊', '身份证', '1111', '2222', '男', 20, '2025-12-05 17:27:47', '2025-12-05 17:27:47');
INSERT INTO `passenger` VALUES (47, '你好', '身份证', '111', '111', '男', 20, '2025-12-05 17:37:02', '2025-12-05 17:37:01');
INSERT INTO `passenger` VALUES (48, '杨日樟', '身份证', '111', '222', '男', 20, '2025-12-05 20:43:54', '2025-12-05 20:43:54');
INSERT INTO `passenger` VALUES (49, '顾慧沁', '身份证', '11', '22', '女', 20, '2025-12-05 20:49:22', '2025-12-05 20:49:21');
INSERT INTO `passenger` VALUES (50, '12', '身份证', '12', '12', '男', 20, '2025-12-05 21:01:34', '2025-12-05 21:01:33');
INSERT INTO `passenger` VALUES (51, '11', '身份证', '1212', '1212', '男', 20, '2025-12-05 21:39:45', '2025-12-05 21:39:44');
INSERT INTO `passenger` VALUES (52, '12', '军官证', '121', '1212', '女', 20, '2025-12-05 21:39:45', '2025-12-05 21:39:44');
INSERT INTO `passenger` VALUES (53, '哇哈哈', '身份证', '1352366', '124423435', '男', 20, '2025-12-10 14:17:21', '2025-12-10 14:17:20');
INSERT INTO `passenger` VALUES (54, '11', '军官证', '12414', '123412', '男', 20, '2025-12-10 14:18:11', '2025-12-10 14:18:11');
INSERT INTO `passenger` VALUES (55, '22', '学生证', '12314', '124442', '女', 20, '2025-12-10 14:18:11', '2025-12-10 14:18:11');
INSERT INTO `passenger` VALUES (56, '二维', '身份证', '11', '11', '男', 20, '2025-12-10 14:46:58', '2025-12-10 14:46:57');
INSERT INTO `passenger` VALUES (57, '12', '身份证', '13', '14', '男', 20, '2025-12-10 15:52:21', '2025-12-10 15:52:21');
INSERT INTO `passenger` VALUES (58, '方法', '身份证', '2', '3', '男', 20, '2025-12-10 15:58:54', '2025-12-10 15:58:54');
INSERT INTO `passenger` VALUES (59, '好好干', '身份证', '56', '57', '男', 20, '2025-12-10 16:05:36', '2025-12-10 16:05:36');
INSERT INTO `passenger` VALUES (60, '高数', '身份证', '1545', '1545', '男', 20, '2025-12-10 16:37:14', '2025-12-10 16:37:14');
INSERT INTO `passenger` VALUES (61, '杨啊哈哈', '身份证', '123', '22424', '男', 20, '2025-12-11 11:37:20', '2025-12-11 11:37:19');
INSERT INTO `passenger` VALUES (62, '哈哈', '护照', '111', '123456', '男', 24, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (63, '哈哈', '身份证', '111', '123456', '男', 25, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (64, '哈哈', '军官证', '111', '123456', '女', 27, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (65, '哈哈', '其他', '111', '123456', '未知', 24, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (66, '哈哈', '其他', '111', '123456', '未知', 20, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (67, '哈哈', '军官证', '111', '123456', '男', 27, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (68, '哈哈', '军官证', '111', '123456', '未知', 24, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (69, '哈哈', '身份证', '111', '123456', '女', 24, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (70, '哈哈', '护照', '111', '123456', '女', 25, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (71, '哈哈', '军官证', '111', '123456', '未知', 24, '2025-12-11 14:01:46', '2025-12-11 14:01:46');
INSERT INTO `passenger` VALUES (95, '唐玲', '身份证', '450125199125255678', '13900000025', '女', 31, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `passenger` VALUES (96, '韩超', '身份证', '450126199026266789', '13900000026', '男', 32, '2025-01-01 10:01:00', '2025-01-01 10:01:00');
INSERT INTO `passenger` VALUES (97, '曹红', '身份证', '450127198927277890', '13900000027', '女', NULL, '2025-01-01 10:02:00', '2025-01-01 10:02:00');
INSERT INTO `passenger` VALUES (98, '许志', '身份证', '450128198828288901', '13900000028', '男', 34, '2025-01-01 10:03:00', '2025-01-01 10:03:00');
INSERT INTO `passenger` VALUES (99, '邓莉', '身份证', '450129198729299012', '13900000029', '女', 35, '2025-01-01 10:04:00', '2025-01-01 10:04:00');
INSERT INTO `passenger` VALUES (100, '萧峰', '身份证', '450130198630300123', '13900000030', '男', 36, '2025-01-01 10:05:00', '2025-01-01 10:05:00');
INSERT INTO `passenger` VALUES (101, '冯艳', '身份证', '450131199631311234', '13900000031', '女', 37, '2025-01-01 10:06:00', '2025-01-01 10:06:00');
INSERT INTO `passenger` VALUES (102, '程伟', '身份证', '450132199732322345', '13900000032', '男', 38, '2025-01-01 10:07:00', '2025-01-01 10:07:00');
INSERT INTO `passenger` VALUES (103, '蔡芳', '身份证', '450133199833333456', '13900000033', '女', 39, '2025-01-01 10:08:00', '2025-01-01 10:08:00');
INSERT INTO `passenger` VALUES (104, '彭辉', '身份证', '450134199934344567', '13900000034', '男', 40, '2025-01-01 10:09:00', '2025-01-01 10:09:00');
INSERT INTO `passenger` VALUES (105, '潘婷', '身份证', '450135200035355678', '13900000035', '女', 41, '2025-01-01 10:10:00', '2025-01-01 10:10:00');
INSERT INTO `passenger` VALUES (106, '袁刚', '身份证', '450136200136366789', '13900000036', '男', 42, '2025-01-01 10:11:00', '2025-01-01 10:11:00');
INSERT INTO `passenger` VALUES (107, '蒋丽', '身份证', '450137200237377890', '13900000037', '女', 43, '2025-01-01 10:12:00', '2025-01-01 10:12:00');
INSERT INTO `passenger` VALUES (108, '田明', '身份证', '450138200338388901', '13900000038', '男', 44, '2025-01-01 10:13:00', '2025-01-01 10:13:00');
INSERT INTO `passenger` VALUES (109, '杜娟', '身份证', '450139199539399012', '13900000039', '女', 45, '2025-01-01 10:14:00', '2025-01-01 10:14:00');
INSERT INTO `passenger` VALUES (110, '丁强', '身份证', '450140199440400123', '13900000040', '男', 47, '2025-01-01 10:15:00', '2025-01-01 10:15:00');
INSERT INTO `passenger` VALUES (111, '沈燕', '身份证', '450141199341411234', '13900000041', '女', 48, '2025-01-01 10:16:00', '2025-01-01 10:16:00');
INSERT INTO `passenger` VALUES (112, '姜涛', '身份证', '450142199242422345', '13900000042', '男', 61, '2025-01-01 10:17:00', '2025-01-01 10:17:00');
INSERT INTO `passenger` VALUES (113, '12', '身份证', '13', '132', '男', 21, '2025-12-11 17:14:21', '2025-12-11 17:14:20');
INSERT INTO `passenger` VALUES (114, '12', '身份证', '313', '3123', '男', 21, '2025-12-11 17:14:21', '2025-12-11 17:14:20');
INSERT INTO `passenger` VALUES (115, '123', '身份证', '133', '123', '男', 21, '2025-12-11 17:14:21', '2025-12-11 17:14:20');
INSERT INTO `passenger` VALUES (116, '13', '身份证', '13', '3231', '男', 21, '2025-12-11 17:14:21', '2025-12-11 17:14:20');
INSERT INTO `passenger` VALUES (117, '313', '身份证', '413', '224', '男', 21, '2025-12-11 17:14:21', '2025-12-11 17:14:20');
INSERT INTO `passenger` VALUES (118, '12', '身份证', '124', '1421', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (119, '12', '身份证', '241', '241', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (120, '13', '身份证', '41', '1241', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (121, '13', '身份证', '412', '421', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (122, '31', '身份证', '535', '3', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (123, '123', '身份证', '43', '646', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (124, '231', '身份证', '63', '363', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (125, '123', '身份证', '43', '4', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (126, '214', '身份证', '6', '4', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (127, '2', '身份证', '34', '434', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (128, '241', '身份证', '644', '463', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (129, '124', '身份证', '463', '3', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (130, '124', '身份证', '364', '4643', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (131, '244', '身份证', '634', '634', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (132, '1412', '身份证', '36', '46', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (133, '42124', '身份证', '647', '7', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (134, '142', '身份证', '6', '86', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (135, '14', '身份证', '865', '567', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (136, '2414', '身份证', '57', '57', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (137, '14', '身份证', '337', '35', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (138, '24141', '身份证', '375', '564', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (139, '24141', '身份证', '735', '765586', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (140, '24124', '身份证', '375', '856', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (141, '12425', '身份证', '375', '856', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (142, '347', '身份证', '77', '86', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (143, '4', '身份证', '765', '87', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (144, '7', '身份证', '576', '987', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (145, '077', '身份证', '57', '080', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (146, '4574', '身份证', '35', '9-89', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (147, '364', '身份证', '63', '576', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (148, '36', '身份证', '36', '87352', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (149, '46', '身份证', '364', '253357', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (150, '57', '身份证', '757', '776556', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (151, '85', '身份证', '565', '86586', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (152, '65', '身份证', '423', '856', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (153, '586', '身份证', '6456', '57', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (154, '685', '身份证', '765', '46', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (155, '56', '身份证', '687', '63466', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (156, '56', '身份证', '769', '463', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (157, '2423', '身份证', '658', '364643', '男', 21, '2025-12-11 17:21:39', '2025-12-11 17:21:38');
INSERT INTO `passenger` VALUES (158, '哈哈哈', '身份证', '123', '123', '男', 20, '2025-12-11 17:24:29', '2025-12-11 17:24:29');
INSERT INTO `passenger` VALUES (159, '11', '身份证', '13', '31', '男', 20, '2025-12-14 10:31:08', '2025-12-14 10:31:07');
INSERT INTO `passenger` VALUES (160, '杨日章', '身份证', '450722200405052535', '15177933867', '男', 20, '2026-03-10 19:28:42', '2026-03-10 19:28:41');
INSERT INTO `passenger` VALUES (161, '你哈还会', '身份证', '111', '111', '男', 20, '2026-04-11 10:58:50', '2026-04-11 10:58:49');
INSERT INTO `passenger` VALUES (162, '11', '身份证', '11', '112', '男', 20, '2026-04-11 11:47:22', '2026-04-11 11:47:22');
INSERT INTO `passenger` VALUES (163, '22', '身份证', '22', '222', '男', 20, '2026-04-11 11:47:22', '2026-04-11 11:47:22');
INSERT INTO `passenger` VALUES (164, '33', '身份证', '33', '333', '男', 20, '2026-04-11 11:47:22', '2026-04-11 11:47:22');
INSERT INTO `passenger` VALUES (165, '11', '身份证', '12', '212', '男', 20, '2026-04-11 11:54:40', '2026-04-11 11:54:40');
INSERT INTO `passenger` VALUES (166, '几乎', '身份证', '1212', '3133', '男', 20, '2026-04-11 12:05:53', '2026-04-11 12:05:52');
INSERT INTO `passenger` VALUES (167, '和搜噶', '身份证', '1616', '2645', '男', 20, '2026-04-11 12:29:29', '2026-04-11 12:29:28');
INSERT INTO `passenger` VALUES (168, '反倒是', '身份证', '122', '112', '男', 20, '2026-04-11 13:50:28', '2026-04-11 13:50:27');
INSERT INTO `passenger` VALUES (169, '二位刚刚', '身份证', '223232', '·1··2323', '男', 20, '2026-04-11 13:52:22', '2026-04-11 13:52:22');
INSERT INTO `passenger` VALUES (170, '发顺丰', '身份证', '·23', '2343', '男', 20, '2026-04-11 14:49:17', '2026-04-11 14:49:17');
INSERT INTO `passenger` VALUES (171, '大V', '身份证', '2132', '123', '男', 20, '2026-04-11 14:49:17', '2026-04-11 14:49:17');
INSERT INTO `passenger` VALUES (172, '撒', '身份证', '12', '2', '男', 20, '2026-04-11 14:55:44', '2026-04-11 14:55:43');
INSERT INTO `passenger` VALUES (173, '官方', '身份证', '121', '1221', '男', 20, '2026-04-11 14:55:44', '2026-04-11 14:55:43');
INSERT INTO `passenger` VALUES (174, '大城市', '身份证', '·2·', '·12', '男', 20, '2026-04-11 14:59:31', '2026-04-11 14:59:30');
INSERT INTO `passenger` VALUES (175, 'VV', '身份证', '224', '345', '男', 20, '2026-04-11 14:59:31', '2026-04-11 14:59:30');
INSERT INTO `passenger` VALUES (176, '122额', '身份证', '46', '775', '男', 20, '2026-04-11 14:59:31', '2026-04-11 14:59:30');
INSERT INTO `passenger` VALUES (177, '水滴筹', '身份证', '·313', '423443', '男', 20, '2026-04-11 15:14:36', '2026-04-11 15:14:36');
INSERT INTO `passenger` VALUES (178, '深V的程序', '身份证', '·123', '7667', '男', 20, '2026-04-11 15:15:22', '2026-04-11 15:15:21');
INSERT INTO `passenger` VALUES (179, 'V雕是的', '身份证', '23454', '767', '男', 20, '2026-04-11 15:15:22', '2026-04-11 15:15:21');
INSERT INTO `passenger` VALUES (180, '研究研究·', '身份证', '45354', '44554', '男', 20, '2026-04-11 15:21:30', '2026-04-11 15:21:30');
INSERT INTO `passenger` VALUES (181, '但是VV是的·', '身份证', '4544', '35445', '男', 20, '2026-04-11 15:21:30', '2026-04-11 15:21:30');
INSERT INTO `passenger` VALUES (182, 'CV', '身份证', '22124', '4565', '男', 20, '2026-04-11 15:23:59', '2026-04-11 15:23:58');
INSERT INTO `passenger` VALUES (183, '菲菲', '身份证', '23345', '6577', '男', 20, '2026-04-11 15:23:59', '2026-04-11 15:23:58');
INSERT INTO `passenger` VALUES (184, '321', '身份证', '2132', '23213', '男', 20, '2026-04-11 15:25:50', '2026-04-11 15:25:50');
INSERT INTO `passenger` VALUES (185, '方法大概', '身份证', '123', '1321', '男', 20, '2026-04-11 15:25:50', '2026-04-11 15:25:50');
INSERT INTO `passenger` VALUES (186, '刚刚', '身份证', '·11321', '3423', '男', 20, '2026-04-11 15:29:28', '2026-04-11 15:29:27');
INSERT INTO `passenger` VALUES (187, 'bff', '身份证', '4535', '345', '男', 20, '2026-04-11 15:29:28', '2026-04-11 15:29:27');
INSERT INTO `passenger` VALUES (188, '不过不', '身份证', '324434', '35435', '男', 20, '2026-04-11 15:33:56', '2026-04-11 15:33:55');
INSERT INTO `passenger` VALUES (189, '就', '身份证', '556', '564654', '男', 20, '2026-04-11 15:36:36', '2026-04-11 15:36:35');
INSERT INTO `passenger` VALUES (190, '1', '身份证', '42142', '1422', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (191, '2', '身份证', '142', '124', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (192, '12', '身份证', '2', '24', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (193, '121', '身份证', '2212', '4124', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (194, '121', '身份证', '24', '41', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (195, '22', '身份证', '242', '412', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (196, '33', '身份证', '2442', '22', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (197, '3444', '身份证', '244', '122', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (198, '342432', '身份证', '2', '321', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (199, '32', '身份证', '123', '3232', '男', 20, '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `passenger` VALUES (200, '张三', '身份证', '110101199001011234', '13800138000', '男', 20, '2026-04-11 16:07:12', '2026-04-11 16:07:11');
INSERT INTO `passenger` VALUES (201, '张三', '身份证', '110101199001011234', '13800138000', '男', 20, '2026-04-11 16:29:39', '2026-04-11 16:29:38');
INSERT INTO `passenger` VALUES (202, '张三', '身份证', '110101199001011234', '13800138000', '男', 20, '2026-04-11 16:29:39', '2026-04-11 16:29:38');
INSERT INTO `passenger` VALUES (203, '张三', '身份证', '110101199001011234', '13800138000', '男', 20, '2026-04-11 16:29:39', '2026-04-11 16:29:38');
INSERT INTO `passenger` VALUES (204, '张三', '身份证', '110101199001011234', '13800138000', '男', 20, '2026-04-11 16:40:17', '2026-04-11 16:40:16');
INSERT INTO `passenger` VALUES (205, '全都是', '身份证', '2312', '443', '男', 20, '2026-04-11 19:59:46', '2026-04-11 19:59:46');
INSERT INTO `passenger` VALUES (206, '步步高', '身份证', '454534', '4656', '男', 20, '2026-04-11 20:10:45', '2026-04-11 20:10:44');
INSERT INTO `passenger` VALUES (207, '杨日航', '身份证', '12嗯', '1额额', '男', 20, '2026-04-20 16:43:12', '2026-04-20 16:43:11');
INSERT INTO `passenger` VALUES (208, '分熟', '身份证', '12321', '213131', '男', 20, '2026-04-21 20:51:23', '2026-04-21 20:51:22');
INSERT INTO `passenger` VALUES (209, '你好', '身份证', '8551', '1566115', '男', 20, '2026-04-21 20:54:11', '2026-04-21 20:54:10');
INSERT INTO `passenger` VALUES (210, ' i哈苏', '身份证', '154845', '484521', '男', 20, '2026-04-21 21:00:35', '2026-04-21 21:00:34');
INSERT INTO `passenger` VALUES (211, '比成都', '身份证', '11465', '84951', '男', 20, '2026-04-21 21:23:17', '2026-04-21 21:23:17');
INSERT INTO `passenger` VALUES (212, '杨挨打的', '身份证', '11323', '44234', '男', 20, '2026-04-21 21:27:16', '2026-04-21 21:27:16');
INSERT INTO `passenger` VALUES (213, '哈哈哈哈', '身份证', '1254465', '1244214', '男', 20, '2026-04-21 21:43:24', '2026-04-21 21:43:23');
INSERT INTO `passenger` VALUES (214, '比富', '身份证', '65', '161', '男', 20, '2026-04-21 22:39:10', '2026-04-21 22:39:09');

-- ----------------------------
-- Table structure for refund_record
-- ----------------------------
DROP TABLE IF EXISTS `refund_record`;
CREATE TABLE `refund_record`  (
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
  CONSTRAINT `refund_record_ibfk_3` FOREIGN KEY (`passenger_id`) REFERENCES `passenger` (`passenger_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `refund_record_ibfk_4` FOREIGN KEY (`operator_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退票记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_record
-- ----------------------------
INSERT INTO `refund_record` VALUES (1, 60, 40, NULL, 597.00, 0.00, 'FULL', '有事', 25, '2025-12-05 20:57:30', 'PENDING', 1, '微信', 'RF1764939450068', '2025-12-05 20:57:30', '2025-12-05 20:57:30');
INSERT INTO `refund_record` VALUES (2, 61, 41, 50, 350.40, 87.60, 'FULL', '有事', 25, '2025-12-05 21:02:11', 'PENDING', 1, '现金', 'RF1764939731021', '2025-12-05 21:02:11', '2025-12-05 21:02:11');
INSERT INTO `refund_record` VALUES (3, 62, 42, 51, 1267.20, 316.80, 'FULL', '有事啊啊', 25, '2025-12-05 21:49:06', 'PENDING', 1, '现金', 'RF1764942545541', '2025-12-05 21:49:05', '2025-12-05 21:49:05');
INSERT INTO `refund_record` VALUES (4, 63, 42, 52, 1267.20, 316.80, 'FULL', '有事啊啊', 25, '2025-12-05 21:49:07', 'PENDING', 1, '现金', 'RF1764942547095', '2025-12-05 21:49:07', '2025-12-05 21:49:07');
INSERT INTO `refund_record` VALUES (5, 65, 44, 54, 862.00, 0.00, 'FULL', '不想要了', 25, '2025-12-10 14:30:25', 'PENDING', 1, '支付宝', 'RF1765348225442', '2025-12-10 14:30:25', '2025-12-10 14:30:25');
INSERT INTO `refund_record` VALUES (6, 66, 44, 55, 862.00, 0.00, 'FULL', '不想要了', 25, '2025-12-10 14:30:27', 'PENDING', 1, '支付宝', 'RF1765348227002', '2025-12-10 14:30:27', '2025-12-10 14:30:27');
INSERT INTO `refund_record` VALUES (7, 70, 48, 59, 1379.20, 344.80, 'FULL', '你好', 25, '2025-12-10 16:09:19', 'PENDING', 1, '现金', 'RF1765354158697', '2025-12-10 16:09:18', '2025-12-10 16:09:18');
INSERT INTO `refund_record` VALUES (8, 72, 50, 61, 30.00, 7.50, 'FULL', '临时有事', 25, '2025-12-11 11:38:52', 'PENDING', 1, '现金', 'RF1765424331675', '2025-12-11 11:38:51', '2025-12-11 11:38:51');
INSERT INTO `refund_record` VALUES (9, 116, 96, 117, 33.75, 3.75, 'FULL', '有事', 25, '2025-12-11 17:16:00', 'PENDING', 1, '现金', 'RF1765444559773', '2025-12-11 17:15:59', '2025-12-11 17:15:59');
INSERT INTO `refund_record` VALUES (10, 112, 96, 113, 33.75, 3.75, 'FULL', '有事', 25, '2025-12-11 17:16:01', 'PENDING', 1, '现金', 'RF1765444561108', '2025-12-11 17:16:01', '2025-12-11 17:16:01');
INSERT INTO `refund_record` VALUES (11, 115, 96, 116, 33.75, 3.75, 'FULL', '有事', 25, '2025-12-11 17:16:02', 'PENDING', 1, '现金', 'RF1765444562310', '2025-12-11 17:16:02', '2025-12-11 17:16:02');
INSERT INTO `refund_record` VALUES (12, 114, 96, 115, 33.75, 3.75, 'FULL', '有事', 25, '2025-12-11 17:16:04', 'PENDING', 1, '现金', 'RF1765444563503', '2025-12-11 17:16:03', '2025-12-11 17:16:03');
INSERT INTO `refund_record` VALUES (13, 113, 96, 114, 33.75, 3.75, 'FULL', '有事', 25, '2025-12-11 17:18:11', 'PENDING', 1, '现金', 'RF1765444691377', '2025-12-11 17:18:11', '2025-12-11 17:18:11');
INSERT INTO `refund_record` VALUES (14, 121, 97, 122, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:28', 'PENDING', 1, '现金', 'RF1765445008406', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (15, 119, 97, 120, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:28', 'PENDING', 1, '现金', 'RF1765445008435', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (16, 118, 97, 119, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:28', 'PENDING', 1, '现金', 'RF1765445008456', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (17, 120, 97, 121, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:28', 'PENDING', 1, '现金', 'RF1765445008481', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (18, 122, 97, 123, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008506', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (19, 117, 97, 118, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008529', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (20, 123, 97, 124, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008557', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (21, 124, 97, 125, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008587', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (22, 125, 97, 126, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008623', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (23, 126, 97, 127, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008651', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (24, 128, 97, 129, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008681', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (25, 127, 97, 128, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008706', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (26, 129, 97, 130, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008733', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (27, 130, 97, 131, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008754', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (28, 131, 97, 132, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008771', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (29, 134, 97, 135, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008789', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (30, 132, 97, 133, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008806', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (31, 133, 97, 134, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008841', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (32, 136, 97, 137, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008912', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (33, 135, 97, 136, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445008972', '2025-12-11 17:23:28', '2025-12-11 17:23:28');
INSERT INTO `refund_record` VALUES (34, 139, 97, 140, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009032', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (35, 138, 97, 139, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009072', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (36, 137, 97, 138, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009098', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (37, 140, 97, 141, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009123', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (38, 141, 97, 142, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009144', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (39, 142, 97, 143, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009167', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (40, 143, 97, 144, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009187', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (41, 144, 97, 145, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009206', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (42, 145, 97, 146, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009230', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (43, 146, 97, 147, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009255', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (44, 148, 97, 149, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009279', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (45, 147, 97, 148, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009300', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (46, 149, 97, 150, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009322', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (47, 150, 97, 151, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009344', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (48, 151, 97, 152, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009366', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (49, 152, 97, 153, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009390', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (50, 153, 97, 154, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009410', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (51, 154, 97, 155, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009430', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (52, 155, 97, 156, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009450', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (53, 156, 97, 157, 22.50, 2.50, 'FULL', '有事', 25, '2025-12-11 17:23:29', 'PENDING', 1, '现金', 'RF1765445009473', '2025-12-11 17:23:29', '2025-12-11 17:23:29');
INSERT INTO `refund_record` VALUES (54, 159, 100, 160, 24.00, 6.00, 'FULL', '行程变更', 25, '2026-03-10 19:43:23', 'PENDING', 1, '现金', 'RF1773143003432', '2026-03-10 19:43:23', '2026-03-10 19:43:23');
INSERT INTO `refund_record` VALUES (55, 164, 103, 165, 13.50, 1.50, 'FULL', '临时有事', 25, '2026-04-11 12:00:01', 'PENDING', 1, '现金', 'RF1775880001184', '2026-04-11 12:00:01', '2026-04-11 12:00:01');
INSERT INTO `refund_record` VALUES (56, 165, 104, 166, 27.00, 3.00, 'FULL', '有事', 25, '2026-04-11 12:18:54', 'PENDING', 1, '现金', 'RF1775881133752', '2026-04-11 12:18:53', '2026-04-11 12:18:53');
INSERT INTO `refund_record` VALUES (57, 200, 121, 201, 27.00, 3.00, 'FULL', '有事1', 25, '2026-04-11 19:43:21', 'PENDING', 1, '现金', 'RF1775907801056', '2026-04-11 19:43:21', '2026-04-11 19:43:21');
INSERT INTO `refund_record` VALUES (58, 204, 124, 204, 14.25, 0.75, 'FULL', '有事', 25, '2026-04-11 19:55:10', 'PENDING', 1, '现金', 'RF1775908509839', '2026-04-11 19:55:09', '2026-04-11 19:55:09');
INSERT INTO `refund_record` VALUES (59, 205, 125, 205, 27.00, 3.00, 'FULL', '有事', 25, '2026-04-11 20:00:31', 'PENDING', 1, '现金', 'RF1775908831238', '2026-04-11 20:00:31', '2026-04-11 20:00:31');
INSERT INTO `refund_record` VALUES (60, 206, 126, 206, 13.50, 1.50, 'FULL', '有事', 25, '2026-04-11 20:11:13', 'PENDING', 1, '现金', 'RF1775909472895', '2026-04-11 20:11:12', '2026-04-11 20:11:12');

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
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

-- ----------------------------
-- Table structure for route
-- ----------------------------
DROP TABLE IF EXISTS `route`;
CREATE TABLE `route`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 215 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '途经站点表' ROW_FORMAT = Dynamic;

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

-- ----------------------------
-- Table structure for seat
-- ----------------------------
DROP TABLE IF EXISTS `seat`;
CREATE TABLE `seat`  (
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
  INDEX `idx_train_date_status`(`train_id` ASC, `travel_date` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `seat_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7252 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '座位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of seat
-- ----------------------------
INSERT INTO `seat` VALUES (1403, 13, '2025-12-05', '1', '001', '商务座', 1, 2.00, 'available', '2025-12-05 20:42:04', '2025-12-05 21:02:11');
INSERT INTO `seat` VALUES (1583, 57, '2025-12-09', '2', '031', '一等座', 2, 1.50, 'available', '2025-12-05 20:49:22', '2025-12-05 20:52:14');
INSERT INTO `seat` VALUES (2003, 32, '2025-12-05', '1', '001', '商务座', 1, 2.00, 'available', '2025-12-05 21:47:21', '2025-12-05 21:49:05');
INSERT INTO `seat` VALUES (2004, 32, '2025-12-05', '1', '002', '商务座', 1, 2.00, 'available', '2025-12-05 21:47:21', '2025-12-05 21:49:07');
INSERT INTO `seat` VALUES (2153, 20, '2025-12-10', '1', '001', '商务座', 1, 2.00, 'occupied', '2025-12-10 14:17:16', '2025-12-10 14:44:00');
INSERT INTO `seat` VALUES (2154, 20, '2025-12-10', '1', '002', '商务座', 1, 2.00, 'occupied', '2025-12-10 14:17:16', '2025-12-10 16:37:14');
INSERT INTO `seat` VALUES (2232, 20, '2025-12-10', '2', '080', '一等座', 2, 1.50, 'occupied', '2025-12-10 14:17:16', '2025-12-10 15:52:21');
INSERT INTO `seat` VALUES (2601, 21, '2025-12-14', '3', '149', '二等座', 3, 1.00, 'available', '2025-12-10 14:17:56', '2025-12-10 14:30:26');
INSERT INTO `seat` VALUES (2602, 21, '2025-12-14', '3', '150', '二等座', 3, 1.00, 'available', '2025-12-10 14:17:56', '2025-12-10 14:30:25');
INSERT INTO `seat` VALUES (2603, 22, '2025-12-10', '1', '001', '商务座', 1, 2.00, 'occupied', '2025-12-10 14:44:32', '2025-12-10 14:46:58');
INSERT INTO `seat` VALUES (2682, 22, '2025-12-10', '2', '080', '一等座', 2, 1.50, 'occupied', '2025-12-10 14:44:32', '2025-12-10 15:58:54');
INSERT INTO `seat` VALUES (3233, 66, '2025-12-11', '2', '031', '一等座', 2, 1.50, 'available', '2025-12-11 11:35:05', '2025-12-11 11:38:51');
INSERT INTO `seat` VALUES (3533, 66, '2025-12-12', '2', '031', '一等座', 2, 1.50, 'available', '2025-12-11 16:59:16', '2025-12-11 17:22:44');
INSERT INTO `seat` VALUES (3534, 66, '2025-12-12', '2', '032', '一等座', 2, 1.50, 'available', '2025-12-11 16:59:16', '2025-12-11 17:22:44');
INSERT INTO `seat` VALUES (3535, 66, '2025-12-12', '2', '033', '一等座', 2, 1.50, 'available', '2025-12-11 16:59:16', '2025-12-11 17:22:44');
INSERT INTO `seat` VALUES (3536, 66, '2025-12-12', '2', '034', '一等座', 2, 1.50, 'available', '2025-12-11 16:59:16', '2025-12-11 17:22:44');
INSERT INTO `seat` VALUES (3537, 66, '2025-12-12', '2', '035', '一等座', 2, 1.50, 'available', '2025-12-11 16:59:16', '2025-12-11 17:22:44');
INSERT INTO `seat` VALUES (3583, 66, '2025-12-12', '3', '081', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3584, 66, '2025-12-12', '3', '082', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3585, 66, '2025-12-12', '3', '083', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3586, 66, '2025-12-12', '3', '084', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3587, 66, '2025-12-12', '3', '085', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3588, 66, '2025-12-12', '3', '086', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3589, 66, '2025-12-12', '3', '087', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3590, 66, '2025-12-12', '3', '088', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3591, 66, '2025-12-12', '3', '089', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3592, 66, '2025-12-12', '3', '090', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3593, 66, '2025-12-12', '3', '091', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3594, 66, '2025-12-12', '3', '092', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3595, 66, '2025-12-12', '3', '093', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3596, 66, '2025-12-12', '3', '094', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3597, 66, '2025-12-12', '3', '095', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3598, 66, '2025-12-12', '3', '096', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3599, 66, '2025-12-12', '3', '097', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3600, 66, '2025-12-12', '3', '098', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3601, 66, '2025-12-12', '3', '099', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3602, 66, '2025-12-12', '3', '100', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:28');
INSERT INTO `seat` VALUES (3603, 66, '2025-12-12', '3', '101', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3604, 66, '2025-12-12', '3', '102', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3605, 66, '2025-12-12', '3', '103', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3606, 66, '2025-12-12', '3', '104', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3607, 66, '2025-12-12', '3', '105', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3608, 66, '2025-12-12', '3', '106', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3609, 66, '2025-12-12', '3', '107', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3610, 66, '2025-12-12', '3', '108', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3611, 66, '2025-12-12', '3', '109', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3612, 66, '2025-12-12', '3', '110', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3613, 66, '2025-12-12', '3', '111', '二等座', 3, 1.00, 'occupied', '2025-12-11 16:59:16', '2025-12-11 17:24:29');
INSERT INTO `seat` VALUES (3614, 66, '2025-12-12', '3', '112', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3615, 66, '2025-12-12', '3', '113', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3616, 66, '2025-12-12', '3', '114', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3617, 66, '2025-12-12', '3', '115', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3618, 66, '2025-12-12', '3', '116', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3619, 66, '2025-12-12', '3', '117', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3620, 66, '2025-12-12', '3', '118', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3621, 66, '2025-12-12', '3', '119', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (3622, 66, '2025-12-12', '3', '120', '二等座', 3, 1.00, 'available', '2025-12-11 16:59:16', '2025-12-11 17:23:29');
INSERT INTO `seat` VALUES (4883, 20, '2025-12-14', '2', '031', '一等座', 2, 1.50, 'occupied', '2025-12-14 10:31:55', '2025-12-14 10:33:34');
INSERT INTO `seat` VALUES (5003, 67, '2026-03-10', '1', '001', '商务座', 1, 2.00, 'available', '2026-03-10 19:28:25', '2026-03-10 19:43:23');
INSERT INTO `seat` VALUES (5753, 67, '2026-04-11', '1', '001', '商务座', 1, 2.00, 'occupied', '2026-04-11 10:58:38', '2026-04-11 10:58:50');
INSERT INTO `seat` VALUES (5903, 67, '2026-04-12', '1', '001', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 13:50:28');
INSERT INTO `seat` VALUES (5904, 67, '2026-04-12', '1', '002', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 14:59:31');
INSERT INTO `seat` VALUES (5905, 67, '2026-04-12', '1', '003', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 14:59:31');
INSERT INTO `seat` VALUES (5906, 67, '2026-04-12', '1', '004', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 14:59:31');
INSERT INTO `seat` VALUES (5907, 67, '2026-04-12', '1', '005', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:14:36');
INSERT INTO `seat` VALUES (5908, 67, '2026-04-12', '1', '006', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:15:22');
INSERT INTO `seat` VALUES (5909, 67, '2026-04-12', '1', '007', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:15:22');
INSERT INTO `seat` VALUES (5910, 67, '2026-04-12', '1', '008', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:25:50');
INSERT INTO `seat` VALUES (5911, 67, '2026-04-12', '1', '009', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:25:50');
INSERT INTO `seat` VALUES (5912, 67, '2026-04-12', '1', '010', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:33:56');
INSERT INTO `seat` VALUES (5913, 67, '2026-04-12', '1', '011', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5914, 67, '2026-04-12', '1', '012', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5915, 67, '2026-04-12', '1', '013', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5916, 67, '2026-04-12', '1', '014', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5917, 67, '2026-04-12', '1', '015', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5918, 67, '2026-04-12', '1', '016', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5919, 67, '2026-04-12', '1', '017', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5920, 67, '2026-04-12', '1', '018', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5921, 67, '2026-04-12', '1', '019', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5922, 67, '2026-04-12', '1', '020', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:46:35');
INSERT INTO `seat` VALUES (5923, 67, '2026-04-12', '1', '021', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 16:07:12');
INSERT INTO `seat` VALUES (5924, 67, '2026-04-12', '1', '022', '商务座', 1, 2.00, 'available', '2026-04-11 11:00:42', '2026-04-11 20:00:31');
INSERT INTO `seat` VALUES (5927, 67, '2026-04-12', '1', '025', '商务座', 1, 2.00, 'available', '2026-04-11 11:00:42', '2026-04-11 19:43:21');
INSERT INTO `seat` VALUES (5933, 67, '2026-04-12', '2', '031', '一等座', 2, 1.50, 'occupied', '2026-04-11 11:00:42', '2026-04-11 13:52:22');
INSERT INTO `seat` VALUES (5934, 67, '2026-04-12', '2', '032', '一等座', 2, 1.50, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:21:30');
INSERT INTO `seat` VALUES (5935, 67, '2026-04-12', '2', '033', '一等座', 2, 1.50, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:21:30');
INSERT INTO `seat` VALUES (5936, 67, '2026-04-12', '2', '034', '一等座', 2, 1.50, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:36:36');
INSERT INTO `seat` VALUES (5983, 67, '2026-04-12', '3', '081', '二等座', 3, 1.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:23:59');
INSERT INTO `seat` VALUES (5984, 67, '2026-04-12', '3', '082', '二等座', 3, 1.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:23:59');
INSERT INTO `seat` VALUES (5985, 67, '2026-04-12', '3', '083', '二等座', 3, 1.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:29:28');
INSERT INTO `seat` VALUES (5986, 67, '2026-04-12', '3', '084', '二等座', 3, 1.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 15:29:28');
INSERT INTO `seat` VALUES (5987, 67, '2026-04-12', '3', '085', '二等座', 3, 1.00, 'available', '2026-04-11 11:00:42', '2026-04-11 20:11:12');
INSERT INTO `seat` VALUES (6051, 67, '2026-04-12', '3', '149', '二等座', 3, 1.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 14:55:44');
INSERT INTO `seat` VALUES (6052, 67, '2026-04-12', '3', '150', '二等座', 3, 1.00, 'occupied', '2026-04-11 11:00:42', '2026-04-11 14:55:44');
INSERT INTO `seat` VALUES (6353, 61, '2026-04-11', '1', '001', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:47:18', '2026-04-11 11:47:22');
INSERT INTO `seat` VALUES (6354, 61, '2026-04-11', '1', '002', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:47:18', '2026-04-11 11:47:22');
INSERT INTO `seat` VALUES (6355, 61, '2026-04-11', '1', '003', '商务座', 1, 2.00, 'occupied', '2026-04-11 11:47:18', '2026-04-11 11:47:22');
INSERT INTO `seat` VALUES (6383, 61, '2026-04-11', '2', '031', '一等座', 2, 1.50, 'occupied', '2026-04-11 11:47:18', '2026-04-11 12:29:29');
INSERT INTO `seat` VALUES (6653, 52, '2026-04-11', '1', '001', '商务座', 1, 2.00, 'occupied', '2026-04-11 14:49:13', '2026-04-11 14:49:17');
INSERT INTO `seat` VALUES (6654, 52, '2026-04-11', '1', '002', '商务座', 1, 2.00, 'occupied', '2026-04-11 14:49:13', '2026-04-11 14:49:17');
INSERT INTO `seat` VALUES (6883, 67, '2026-04-13', '3', '081', '二等座', 3, 1.00, 'available', '2026-04-11 19:42:30', '2026-04-11 19:55:09');
INSERT INTO `seat` VALUES (6953, 67, '2026-04-20', '1', '001', '商务座', 1, 2.00, 'occupied', '2026-04-20 16:43:06', '2026-04-20 16:43:12');
INSERT INTO `seat` VALUES (7103, 67, '2026-04-22', '1', '001', '商务座', 1, 2.00, 'occupied', '2026-04-21 20:51:16', '2026-04-21 20:51:23');
INSERT INTO `seat` VALUES (7104, 67, '2026-04-22', '1', '002', '商务座', 1, 2.00, 'occupied', '2026-04-21 20:51:16', '2026-04-21 20:54:11');
INSERT INTO `seat` VALUES (7105, 67, '2026-04-22', '1', '003', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 22:41:15');
INSERT INTO `seat` VALUES (7106, 67, '2026-04-22', '1', '004', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 22:23:39');
INSERT INTO `seat` VALUES (7107, 67, '2026-04-22', '1', '005', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 22:23:37');
INSERT INTO `seat` VALUES (7108, 67, '2026-04-22', '1', '006', '商务座', 1, 2.00, 'locked', '2026-04-21 20:51:16', '2026-04-21 21:43:23');
INSERT INTO `seat` VALUES (7109, 67, '2026-04-22', '1', '007', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7110, 67, '2026-04-22', '1', '008', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7111, 67, '2026-04-22', '1', '009', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7112, 67, '2026-04-22', '1', '010', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7113, 67, '2026-04-22', '1', '011', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7114, 67, '2026-04-22', '1', '012', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7115, 67, '2026-04-22', '1', '013', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7116, 67, '2026-04-22', '1', '014', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7117, 67, '2026-04-22', '1', '015', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7118, 67, '2026-04-22', '1', '016', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7119, 67, '2026-04-22', '1', '017', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7120, 67, '2026-04-22', '1', '018', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7121, 67, '2026-04-22', '1', '019', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7122, 67, '2026-04-22', '1', '020', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7123, 67, '2026-04-22', '1', '021', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7124, 67, '2026-04-22', '1', '022', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7125, 67, '2026-04-22', '1', '023', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7126, 67, '2026-04-22', '1', '024', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7127, 67, '2026-04-22', '1', '025', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7128, 67, '2026-04-22', '1', '026', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7129, 67, '2026-04-22', '1', '027', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7130, 67, '2026-04-22', '1', '028', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7131, 67, '2026-04-22', '1', '029', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7132, 67, '2026-04-22', '1', '030', '商务座', 1, 2.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7133, 67, '2026-04-22', '2', '031', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7134, 67, '2026-04-22', '2', '032', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7135, 67, '2026-04-22', '2', '033', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7136, 67, '2026-04-22', '2', '034', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7137, 67, '2026-04-22', '2', '035', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7138, 67, '2026-04-22', '2', '036', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7139, 67, '2026-04-22', '2', '037', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7140, 67, '2026-04-22', '2', '038', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7141, 67, '2026-04-22', '2', '039', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7142, 67, '2026-04-22', '2', '040', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7143, 67, '2026-04-22', '2', '041', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7144, 67, '2026-04-22', '2', '042', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7145, 67, '2026-04-22', '2', '043', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7146, 67, '2026-04-22', '2', '044', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7147, 67, '2026-04-22', '2', '045', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7148, 67, '2026-04-22', '2', '046', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7149, 67, '2026-04-22', '2', '047', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7150, 67, '2026-04-22', '2', '048', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7151, 67, '2026-04-22', '2', '049', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7152, 67, '2026-04-22', '2', '050', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7153, 67, '2026-04-22', '2', '051', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7154, 67, '2026-04-22', '2', '052', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7155, 67, '2026-04-22', '2', '053', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7156, 67, '2026-04-22', '2', '054', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7157, 67, '2026-04-22', '2', '055', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7158, 67, '2026-04-22', '2', '056', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7159, 67, '2026-04-22', '2', '057', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7160, 67, '2026-04-22', '2', '058', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7161, 67, '2026-04-22', '2', '059', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7162, 67, '2026-04-22', '2', '060', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7163, 67, '2026-04-22', '2', '061', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7164, 67, '2026-04-22', '2', '062', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7165, 67, '2026-04-22', '2', '063', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7166, 67, '2026-04-22', '2', '064', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7167, 67, '2026-04-22', '2', '065', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7168, 67, '2026-04-22', '2', '066', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7169, 67, '2026-04-22', '2', '067', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7170, 67, '2026-04-22', '2', '068', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7171, 67, '2026-04-22', '2', '069', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7172, 67, '2026-04-22', '2', '070', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7173, 67, '2026-04-22', '2', '071', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7174, 67, '2026-04-22', '2', '072', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7175, 67, '2026-04-22', '2', '073', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7176, 67, '2026-04-22', '2', '074', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7177, 67, '2026-04-22', '2', '075', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7178, 67, '2026-04-22', '2', '076', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7179, 67, '2026-04-22', '2', '077', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7180, 67, '2026-04-22', '2', '078', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7181, 67, '2026-04-22', '2', '079', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7182, 67, '2026-04-22', '2', '080', '一等座', 2, 1.50, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7183, 67, '2026-04-22', '3', '081', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7184, 67, '2026-04-22', '3', '082', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7185, 67, '2026-04-22', '3', '083', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7186, 67, '2026-04-22', '3', '084', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7187, 67, '2026-04-22', '3', '085', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7188, 67, '2026-04-22', '3', '086', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7189, 67, '2026-04-22', '3', '087', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7190, 67, '2026-04-22', '3', '088', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7191, 67, '2026-04-22', '3', '089', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7192, 67, '2026-04-22', '3', '090', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7193, 67, '2026-04-22', '3', '091', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7194, 67, '2026-04-22', '3', '092', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7195, 67, '2026-04-22', '3', '093', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7196, 67, '2026-04-22', '3', '094', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7197, 67, '2026-04-22', '3', '095', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7198, 67, '2026-04-22', '3', '096', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7199, 67, '2026-04-22', '3', '097', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7200, 67, '2026-04-22', '3', '098', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7201, 67, '2026-04-22', '3', '099', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7202, 67, '2026-04-22', '3', '100', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7203, 67, '2026-04-22', '3', '101', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7204, 67, '2026-04-22', '3', '102', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7205, 67, '2026-04-22', '3', '103', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7206, 67, '2026-04-22', '3', '104', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7207, 67, '2026-04-22', '3', '105', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7208, 67, '2026-04-22', '3', '106', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7209, 67, '2026-04-22', '3', '107', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7210, 67, '2026-04-22', '3', '108', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7211, 67, '2026-04-22', '3', '109', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7212, 67, '2026-04-22', '3', '110', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7213, 67, '2026-04-22', '3', '111', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7214, 67, '2026-04-22', '3', '112', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7215, 67, '2026-04-22', '3', '113', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7216, 67, '2026-04-22', '3', '114', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7217, 67, '2026-04-22', '3', '115', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7218, 67, '2026-04-22', '3', '116', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7219, 67, '2026-04-22', '3', '117', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7220, 67, '2026-04-22', '3', '118', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7221, 67, '2026-04-22', '3', '119', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7222, 67, '2026-04-22', '3', '120', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7223, 67, '2026-04-22', '3', '121', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7224, 67, '2026-04-22', '3', '122', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7225, 67, '2026-04-22', '3', '123', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7226, 67, '2026-04-22', '3', '124', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7227, 67, '2026-04-22', '3', '125', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7228, 67, '2026-04-22', '3', '126', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7229, 67, '2026-04-22', '3', '127', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7230, 67, '2026-04-22', '3', '128', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7231, 67, '2026-04-22', '3', '129', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7232, 67, '2026-04-22', '3', '130', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7233, 67, '2026-04-22', '3', '131', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7234, 67, '2026-04-22', '3', '132', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7235, 67, '2026-04-22', '3', '133', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7236, 67, '2026-04-22', '3', '134', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7237, 67, '2026-04-22', '3', '135', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7238, 67, '2026-04-22', '3', '136', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7239, 67, '2026-04-22', '3', '137', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7240, 67, '2026-04-22', '3', '138', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7241, 67, '2026-04-22', '3', '139', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7242, 67, '2026-04-22', '3', '140', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7243, 67, '2026-04-22', '3', '141', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7244, 67, '2026-04-22', '3', '142', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7245, 67, '2026-04-22', '3', '143', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7246, 67, '2026-04-22', '3', '144', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7247, 67, '2026-04-22', '3', '145', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7248, 67, '2026-04-22', '3', '146', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7249, 67, '2026-04-22', '3', '147', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7250, 67, '2026-04-22', '3', '148', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7251, 67, '2026-04-22', '3', '149', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');
INSERT INTO `seat` VALUES (7252, 67, '2026-04-22', '3', '150', '二等座', 3, 1.00, 'available', '2026-04-21 20:51:16', '2026-04-21 20:51:16');

-- ----------------------------
-- Table structure for station
-- ----------------------------
DROP TABLE IF EXISTS `station`;
CREATE TABLE `station`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '车站表' ROW_FORMAT = Dynamic;

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
INSERT INTO `station` VALUES (15, '长沙南站', '长沙', '湖南省', '特等站', '长沙市雨花区花侯路', '0731-12306004', 1, '2025-12-04 23:23:07', '2025-12-04 23:23:07');
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
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
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
-- Table structure for ticket
-- ----------------------------
DROP TABLE IF EXISTS `ticket`;
CREATE TABLE `ticket`  (
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
  INDEX `seat_id`(`seat_id` ASC) USING BTREE,
  INDEX `seller_id`(`seller_id` ASC) USING BTREE,
  INDEX `idx_ticket_number`(`ticket_number` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_train_id`(`train_id` ASC) USING BTREE,
  INDEX `idx_passenger_id`(`passenger_id` ASC) USING BTREE,
  INDEX `idx_travel_date`(`travel_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_ticket_train_date_status`(`train_id` ASC, `travel_date` ASC, `status` ASC) USING BTREE,
  INDEX `idx_ticket_passenger_status`(`passenger_id` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ticket_ibfk_3` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ticket_ibfk_4` FOREIGN KEY (`passenger_id`) REFERENCES `passenger` (`passenger_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ticket_ibfk_5` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '车票表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ticket
-- ----------------------------
INSERT INTO `ticket` VALUES (59, 39, 'TKT1764938634435', 13, 1403, 48, 25, '2025-12-05', '南宁站', '广州南站', '06:30:00', '09:30:00', 438.00, 'REFUNDED', 1, 0, 87.60, '2025-12-05 20:43:54', '2025-12-05 20:43:54', '2025-12-05 20:44:49');
INSERT INTO `ticket` VALUES (60, 40, 'TKT1764938961821', 57, 1583, 49, 25, '2025-12-09', '南宁站', '北京西站', '12:00:00', '18:00:00', 597.00, 'REFUNDED', 1, 1, 0.00, '2025-12-05 20:49:22', '2025-12-05 20:49:22', '2025-12-05 20:57:30');
INSERT INTO `ticket` VALUES (61, 41, 'TKT1764939693527', 13, 1403, 50, 25, '2025-12-05', '南宁站', '广州南站', '06:30:00', '09:30:00', 438.00, 'REFUNDED', 1, 0, 87.60, '2025-12-05 21:01:34', '2025-12-05 21:01:34', '2025-12-05 21:02:11');
INSERT INTO `ticket` VALUES (62, 42, 'TKT1764941984682_0', 32, 2003, 51, 25, '2025-12-05', '南宁站', '成都东站', '07:00:00', '14:00:00', 1584.00, 'REFUNDED', 1, 0, 316.80, '2025-12-05 21:39:45', '2025-12-05 21:39:45', '2025-12-05 21:49:06');
INSERT INTO `ticket` VALUES (63, 42, 'TKT1764941984684_1', 32, 2004, 52, 25, '2025-12-05', '南宁站', '成都东站', '07:00:00', '14:00:00', 1584.00, 'REFUNDED', 1, 0, 316.80, '2025-12-05 21:39:45', '2025-12-05 21:39:45', '2025-12-05 21:49:07');
INSERT INTO `ticket` VALUES (64, 43, 'TKT1765347440540', 20, 2153, 53, 25, '2025-12-10', '南宁站', '北京西站', '08:00:00', '18:00:00', 2586.00, 'CHANGED', 1, 0, 10.00, '2025-12-10 14:17:21', '2025-12-10 14:17:21', '2025-12-10 14:44:00');
INSERT INTO `ticket` VALUES (65, 44, 'TKT1765347491014_0', 21, 2602, 54, 25, '2025-12-14', '南宁站', '北京西站', '10:00:00', '20:00:00', 862.00, 'REFUNDED', 1, 1, 0.00, '2025-12-10 14:18:11', '2025-12-10 14:18:11', '2025-12-10 14:30:25');
INSERT INTO `ticket` VALUES (66, 44, 'TKT1765347491015_1', 21, 2601, 55, 25, '2025-12-14', '南宁站', '北京西站', '10:00:00', '20:00:00', 862.00, 'REFUNDED', 1, 1, 0.00, '2025-12-10 14:18:11', '2025-12-10 14:18:11', '2025-12-10 14:30:27');
INSERT INTO `ticket` VALUES (67, 45, 'TKT1765349217934', 22, 2603, 56, 25, '2025-12-10', '南宁站', '上海虹桥站', '07:30:00', '16:30:00', 1586.00, 'PAID', 1, 0, 10.00, '2025-12-10 14:46:58', '2025-12-10 14:46:58', '2025-12-10 14:46:58');
INSERT INTO `ticket` VALUES (68, 46, 'TKT1765353141413', 20, 2232, 57, 25, '2025-12-10', '南宁站', '北京西站', '08:00:00', '18:00:00', 1293.00, 'PAID', 1, 0, 10.00, '2025-12-10 15:52:21', '2025-12-10 15:52:21', '2025-12-10 15:52:21');
INSERT INTO `ticket` VALUES (69, 47, 'TKT1765353534203', 22, 2682, 58, 25, '2025-12-10', '南宁站', '上海虹桥站', '07:30:00', '16:30:00', 1189.50, 'PAID', 1, 0, 10.00, '2025-12-10 15:58:54', '2025-12-10 15:58:54', '2025-12-10 15:58:54');
INSERT INTO `ticket` VALUES (70, 48, 'TKT1765353936306', 20, 2154, 59, 25, '2025-12-10', '南宁站', '北京西站', '08:00:00', '18:00:00', 1724.00, 'REFUNDED', 1, 0, 344.80, '2025-12-10 16:05:36', '2025-12-10 16:05:36', '2025-12-10 16:09:19');
INSERT INTO `ticket` VALUES (71, 49, 'TKT1765355834282', 20, 2154, 60, 25, '2025-12-10', '南宁站', '北京西站', '08:00:00', '18:00:00', 1724.00, 'PAID', 1, 0, 10.00, '2025-12-10 16:37:14', '2025-12-10 16:37:14', '2025-12-10 16:37:14');
INSERT INTO `ticket` VALUES (72, 50, 'TKT1765424239923', 66, 3233, 61, 25, '2025-12-11', '南宁站', '北海站', '10:00:00', '12:00:00', 37.50, 'REFUNDED', 1, 0, 7.50, '2025-12-11 11:37:20', '2025-12-11 11:37:20', '2025-12-11 11:38:52');
INSERT INTO `ticket` VALUES (112, 96, 'TKT1765444460591_0', 66, 3533, 113, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 37.50, 'REFUNDED', 1, 0, 3.75, '2025-12-11 17:14:21', '2025-12-11 17:14:21', '2025-12-11 17:16:01');
INSERT INTO `ticket` VALUES (113, 96, 'TKT1765444460592_1', 66, 3534, 114, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 37.50, 'REFUNDED', 1, 0, 3.75, '2025-12-11 17:14:21', '2025-12-11 17:14:21', '2025-12-11 17:18:11');
INSERT INTO `ticket` VALUES (114, 96, 'TKT1765444460592_2', 66, 3535, 115, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 37.50, 'REFUNDED', 1, 0, 3.75, '2025-12-11 17:14:21', '2025-12-11 17:14:21', '2025-12-11 17:16:03');
INSERT INTO `ticket` VALUES (115, 96, 'TKT1765444460592_3', 66, 3536, 116, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 37.50, 'REFUNDED', 1, 0, 3.75, '2025-12-11 17:14:21', '2025-12-11 17:14:21', '2025-12-11 17:16:02');
INSERT INTO `ticket` VALUES (116, 96, 'TKT1765444460592_4', 66, 3537, 117, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 37.50, 'REFUNDED', 1, 0, 3.75, '2025-12-11 17:14:21', '2025-12-11 17:14:21', '2025-12-11 17:16:00');
INSERT INTO `ticket` VALUES (117, 97, 'TKT1765444898968_0', 66, 3583, 118, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (118, 97, 'TKT1765444898968_1', 66, 3584, 119, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:28');
INSERT INTO `ticket` VALUES (119, 97, 'TKT1765444898968_2', 66, 3585, 120, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:28');
INSERT INTO `ticket` VALUES (120, 97, 'TKT1765444898968_3', 66, 3586, 121, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:28');
INSERT INTO `ticket` VALUES (121, 97, 'TKT1765444898968_4', 66, 3587, 122, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:28');
INSERT INTO `ticket` VALUES (122, 97, 'TKT1765444898968_5', 66, 3588, 123, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (123, 97, 'TKT1765444898968_6', 66, 3589, 124, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (124, 97, 'TKT1765444898968_7', 66, 3590, 125, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (125, 97, 'TKT1765444898968_8', 66, 3591, 126, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (126, 97, 'TKT1765444898968_9', 66, 3592, 127, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (127, 97, 'TKT1765444898968_10', 66, 3593, 128, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (128, 97, 'TKT1765444898968_11', 66, 3594, 129, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (129, 97, 'TKT1765444898968_12', 66, 3595, 130, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (130, 97, 'TKT1765444898968_13', 66, 3596, 131, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (131, 97, 'TKT1765444898968_14', 66, 3597, 132, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (132, 97, 'TKT1765444898968_15', 66, 3598, 133, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (133, 97, 'TKT1765444898968_16', 66, 3599, 134, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (134, 97, 'TKT1765444898968_17', 66, 3600, 135, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (135, 97, 'TKT1765444898968_18', 66, 3601, 136, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (136, 97, 'TKT1765444898968_19', 66, 3602, 137, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (137, 97, 'TKT1765444898968_20', 66, 3603, 138, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (138, 97, 'TKT1765444898968_21', 66, 3604, 139, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (139, 97, 'TKT1765444898968_22', 66, 3605, 140, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (140, 97, 'TKT1765444898968_23', 66, 3606, 141, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (141, 97, 'TKT1765444898968_24', 66, 3607, 142, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (142, 97, 'TKT1765444898968_25', 66, 3608, 143, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (143, 97, 'TKT1765444898968_26', 66, 3609, 144, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (144, 97, 'TKT1765444898968_27', 66, 3610, 145, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (145, 97, 'TKT1765444898968_28', 66, 3611, 146, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (146, 97, 'TKT1765444898968_29', 66, 3612, 147, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (147, 97, 'TKT1765444898968_30', 66, 3613, 148, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (148, 97, 'TKT1765444898968_31', 66, 3614, 149, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (149, 97, 'TKT1765444898968_32', 66, 3615, 150, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (150, 97, 'TKT1765444898968_33', 66, 3616, 151, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (151, 97, 'TKT1765444898968_34', 66, 3617, 152, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (152, 97, 'TKT1765444898968_35', 66, 3618, 153, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (153, 97, 'TKT1765444898968_36', 66, 3619, 154, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (154, 97, 'TKT1765444898968_37', 66, 3620, 155, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (155, 97, 'TKT1765444898968_38', 66, 3621, 156, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (156, 97, 'TKT1765444898968_39', 66, 3622, 157, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'REFUNDED', 1, 0, 2.50, '2025-12-11 17:21:39', '2025-12-11 17:21:39', '2025-12-11 17:23:29');
INSERT INTO `ticket` VALUES (157, 98, 'TKT1765445069429', 66, 3613, 158, 25, '2025-12-12', '南宁站', '北海站', '10:00:00', '12:00:00', 25.00, 'PAID', 1, 0, 10.00, '2025-12-11 17:24:29', '2025-12-11 17:24:29', '2025-12-11 17:24:29');
INSERT INTO `ticket` VALUES (158, 99, 'TKT1765679467684', 20, 4883, 159, 25, '2025-12-14', '南宁站', '北京西站', '08:00:00', '18:00:00', 1293.00, 'CHANGED', 1, 0, 10.00, '2025-12-14 10:31:08', '2025-12-14 10:31:08', '2025-12-14 10:33:34');
INSERT INTO `ticket` VALUES (159, 100, 'TKT1773142121808', 67, 5003, 160, 25, '2026-03-10', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'REFUNDED', 1, 0, 6.00, '2026-03-10 19:28:42', '2026-03-10 19:28:42', '2026-03-10 19:43:23');
INSERT INTO `ticket` VALUES (160, 101, 'TKT1775876329968', 67, 5753, 161, 25, '2026-04-11', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 10:58:50', '2026-04-11 10:58:50', '2026-04-11 10:58:50');
INSERT INTO `ticket` VALUES (161, 102, 'TKT1775879242288_0', 61, 6353, 162, 25, '2026-04-11', '南宁站', '成都站', '14:00:00', '08:00:00', 636.00, 'PAID', 1, 0, 10.00, '2026-04-11 11:47:22', '2026-04-11 11:47:22', '2026-04-11 11:47:22');
INSERT INTO `ticket` VALUES (162, 102, 'TKT1775879242291_1', 61, 6354, 163, 25, '2026-04-11', '南宁站', '成都站', '14:00:00', '08:00:00', 636.00, 'PAID', 1, 0, 10.00, '2026-04-11 11:47:22', '2026-04-11 11:47:22', '2026-04-11 11:47:22');
INSERT INTO `ticket` VALUES (163, 102, 'TKT1775879242291_2', 61, 6355, 164, 25, '2026-04-11', '南宁站', '成都站', '14:00:00', '08:00:00', 636.00, 'PAID', 1, 0, 10.00, '2026-04-11 11:47:22', '2026-04-11 11:47:22', '2026-04-11 11:47:22');
INSERT INTO `ticket` VALUES (164, 103, 'TKT1775879680091', 67, 6052, 165, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'REFUNDED', 1, 0, 1.50, '2026-04-11 11:54:40', '2026-04-11 11:54:40', '2026-04-11 12:00:01');
INSERT INTO `ticket` VALUES (165, 104, 'TKT1775880352692', 67, 5903, 166, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'REFUNDED', 1, 0, 3.00, '2026-04-11 12:05:53', '2026-04-11 12:05:53', '2026-04-11 12:18:54');
INSERT INTO `ticket` VALUES (166, 105, 'TKT1775881768713', 61, 6383, 167, 25, '2026-04-11', '南宁站', '成都站', '14:00:00', '08:00:00', 477.00, 'PAID', 1, 0, 10.00, '2026-04-11 12:29:29', '2026-04-11 12:29:29', '2026-04-11 12:29:29');
INSERT INTO `ticket` VALUES (167, 106, 'TKT1775886627716', 67, 5903, 168, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 13:50:28', '2026-04-11 13:50:28', '2026-04-11 13:50:28');
INSERT INTO `ticket` VALUES (168, 107, 'TKT1775886742418', 67, 5933, 169, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 22.50, 'PAID', 1, 0, 10.00, '2026-04-11 13:52:22', '2026-04-11 13:52:22', '2026-04-11 13:52:22');
INSERT INTO `ticket` VALUES (169, 108, 'TKT1775890157460_0', 52, 6653, 170, 25, '2026-04-11', '南宁站', '成都站', '16:00:00', '10:00:00', 516.00, 'PAID', 1, 0, 10.00, '2026-04-11 14:49:17', '2026-04-11 14:49:17', '2026-04-11 14:49:17');
INSERT INTO `ticket` VALUES (170, 108, 'TKT1775890157462_1', 52, 6654, 171, 25, '2026-04-11', '南宁站', '成都站', '16:00:00', '10:00:00', 516.00, 'PAID', 1, 0, 10.00, '2026-04-11 14:49:17', '2026-04-11 14:49:17', '2026-04-11 14:49:17');
INSERT INTO `ticket` VALUES (171, 109, 'TKT1775890543991_0', 67, 6051, 172, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'PAID', 1, 0, 10.00, '2026-04-11 14:55:44', '2026-04-11 14:55:44', '2026-04-11 14:55:44');
INSERT INTO `ticket` VALUES (172, 109, 'TKT1775890543991_1', 67, 6052, 173, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'PAID', 1, 0, 10.00, '2026-04-11 14:55:44', '2026-04-11 14:55:44', '2026-04-11 14:55:44');
INSERT INTO `ticket` VALUES (173, 110, 'TKT1775890770996_0', 67, 5904, 174, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 14:59:31', '2026-04-11 14:59:31', '2026-04-11 14:59:31');
INSERT INTO `ticket` VALUES (174, 110, 'TKT1775890770996_1', 67, 5905, 175, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 14:59:31', '2026-04-11 14:59:31', '2026-04-11 14:59:31');
INSERT INTO `ticket` VALUES (175, 110, 'TKT1775890770996_2', 67, 5906, 176, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 14:59:31', '2026-04-11 14:59:31', '2026-04-11 14:59:31');
INSERT INTO `ticket` VALUES (176, 111, 'TKT1775891676412', 67, 5907, 177, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:14:36', '2026-04-11 15:14:36', '2026-04-11 15:14:36');
INSERT INTO `ticket` VALUES (177, 112, 'TKT1775891721880_0', 67, 5908, 178, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:15:22', '2026-04-11 15:15:22', '2026-04-11 15:15:22');
INSERT INTO `ticket` VALUES (178, 112, 'TKT1775891721882_1', 67, 5909, 179, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:15:22', '2026-04-11 15:15:22', '2026-04-11 15:15:22');
INSERT INTO `ticket` VALUES (179, 113, 'TKT1775892090016_0', 67, 5935, 180, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 22.50, 'PAID', 1, 0, 10.00, '2026-04-11 15:21:30', '2026-04-11 15:21:30', '2026-04-11 15:21:30');
INSERT INTO `ticket` VALUES (180, 113, 'TKT1775892090018_1', 67, 5934, 181, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 22.50, 'PAID', 1, 0, 10.00, '2026-04-11 15:21:30', '2026-04-11 15:21:30', '2026-04-11 15:21:30');
INSERT INTO `ticket` VALUES (181, 114, 'TKT1775892238511_0', 67, 5983, 182, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:23:59', '2026-04-11 15:23:59', '2026-04-11 15:23:59');
INSERT INTO `ticket` VALUES (182, 114, 'TKT1775892238513_1', 67, 5984, 183, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:23:59', '2026-04-11 15:23:59', '2026-04-11 15:23:59');
INSERT INTO `ticket` VALUES (183, 115, 'TKT1775892350055_0', 67, 5910, 184, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:25:50', '2026-04-11 15:25:50', '2026-04-11 15:25:50');
INSERT INTO `ticket` VALUES (184, 115, 'TKT1775892350055_1', 67, 5911, 185, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:25:50', '2026-04-11 15:25:50', '2026-04-11 15:25:50');
INSERT INTO `ticket` VALUES (185, 116, 'TKT1775892567850_0', 67, 5985, 186, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:29:28', '2026-04-11 15:29:28', '2026-04-11 15:29:28');
INSERT INTO `ticket` VALUES (186, 116, 'TKT1775892567851_1', 67, 5986, 187, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:29:28', '2026-04-11 15:29:28', '2026-04-11 15:29:28');
INSERT INTO `ticket` VALUES (187, 117, 'TKT1775892835924', 67, 5912, 188, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:33:56', '2026-04-11 15:33:56', '2026-04-11 15:33:56');
INSERT INTO `ticket` VALUES (188, 118, 'TKT1775892995684', 67, 5936, 189, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 22.50, 'PAID', 1, 0, 10.00, '2026-04-11 15:36:36', '2026-04-11 15:36:36', '2026-04-11 15:36:36');
INSERT INTO `ticket` VALUES (189, 119, 'TKT1775893595279_0', 67, 5913, 190, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (190, 119, 'TKT1775893595281_1', 67, 5914, 191, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (191, 119, 'TKT1775893595281_2', 67, 5915, 192, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (192, 119, 'TKT1775893595281_3', 67, 5916, 193, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (193, 119, 'TKT1775893595281_4', 67, 5917, 194, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (194, 119, 'TKT1775893595281_5', 67, 5918, 195, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (195, 119, 'TKT1775893595281_6', 67, 5919, 196, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (196, 119, 'TKT1775893595281_7', 67, 5920, 197, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (197, 119, 'TKT1775893595281_8', 67, 5921, 198, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (198, 119, 'TKT1775893595281_9', 67, 5922, 199, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 15:46:35', '2026-04-11 15:46:35', '2026-04-11 15:46:35');
INSERT INTO `ticket` VALUES (199, 120, 'TKT1775894831658', 67, 5923, 200, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-11 16:07:12', '2026-04-11 16:07:12', '2026-04-11 16:07:12');
INSERT INTO `ticket` VALUES (200, 121, 'TKT1775896178753', 67, 5927, 201, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'REFUNDED', 1, 0, 3.00, '2026-04-11 16:29:39', '2026-04-11 16:29:39', '2026-04-11 19:43:21');
INSERT INTO `ticket` VALUES (203, 124, 'TKT1775896816834', 67, 5924, 204, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'CHANGED', 1, 0, 10.00, '2026-04-11 16:40:17', '2026-04-11 16:40:17', '2026-04-11 16:40:17');
INSERT INTO `ticket` VALUES (204, 124, 'TKT1775908108271', 67, 6883, 204, 20, '2026-04-13', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'REFUNDED', 1, 0, 0.75, '2026-04-11 19:48:28', '2026-04-11 19:48:28', '2026-04-11 19:55:10');
INSERT INTO `ticket` VALUES (205, 125, 'TKT1775908786388', 67, 5924, 205, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'REFUNDED', 1, 0, 3.00, '2026-04-11 19:59:46', '2026-04-11 19:59:46', '2026-04-11 20:00:31');
INSERT INTO `ticket` VALUES (206, 126, 'TKT1775909444929', 67, 5987, 206, 25, '2026-04-12', '南宁站', '西大站', '10:35:59', '12:35:59', 15.00, 'REFUNDED', 1, 0, 1.50, '2026-04-11 20:10:45', '2026-04-11 20:10:45', '2026-04-11 20:11:13');
INSERT INTO `ticket` VALUES (207, 127, 'TKT1776674591856', 67, 6953, 207, 25, '2026-04-20', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-20 16:43:12', '2026-04-20 16:43:12', '2026-04-20 16:43:12');
INSERT INTO `ticket` VALUES (208, 128, 'TKT1776775882610', 67, 7103, 208, 25, '2026-04-22', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-21 20:51:23', '2026-04-21 20:51:23', '2026-04-21 20:51:23');
INSERT INTO `ticket` VALUES (209, 129, 'TKT1776776050981', 67, 7104, 209, 25, '2026-04-22', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-21 20:54:11', '2026-04-21 20:54:11', '2026-04-21 20:54:11');
INSERT INTO `ticket` VALUES (210, 133, 'TKT1776779003586', 67, 7108, 213, 25, '2026-04-22', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'PAID', 1, 0, 10.00, '2026-04-21 21:43:24', '2026-04-21 21:43:24', '2026-04-21 22:16:13');
INSERT INTO `ticket` VALUES (211, 134, 'TKT1776782349607', 67, 7105, 214, 25, '2026-04-22', '南宁站', '西大站', '10:35:59', '12:35:59', 30.00, 'REFUNDED', 0, 0, 10.00, '2026-04-21 22:39:10', '2026-04-21 22:39:10', '2026-04-21 22:41:15');

-- ----------------------------
-- Table structure for ticket_change
-- ----------------------------
DROP TABLE IF EXISTS `ticket_change`;
CREATE TABLE `ticket_change`  (
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
  CONSTRAINT `fk_ticket_change_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ticket_change_ibfk_3` FOREIGN KEY (`operator_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '改签记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ticket_change
-- ----------------------------
INSERT INTO `ticket_change` VALUES (14, 60, 'K510', 'K510', '150', '031', '2025-12-09', '2025-12-09', 'SEAT', 199.00, 0.00, 25, '2025-12-05 20:51:38', '换座位');
INSERT INTO `ticket_change` VALUES (15, 62, 'G1002', 'G1020', '001', '001', '2025-12-05', '2025-12-05', 'BOTH', 1146.00, 0.00, 25, '2025-12-05 21:47:59', '有事');
INSERT INTO `ticket_change` VALUES (16, 63, 'G1002', 'G1020', '031', '002', '2025-12-05', '2025-12-05', 'BOTH', 1255.50, 0.00, 25, '2025-12-05 21:48:00', '有事');
INSERT INTO `ticket_change` VALUES (17, 64, 'G1008', 'G1008', '001', '031', '2025-12-10', '2025-12-10', 'SEAT', -431.00, 0.00, 25, '2025-12-10 14:41:25', '临时有事');
INSERT INTO `ticket_change` VALUES (18, 64, 'G1008', 'G1008', '031', '081', '2025-12-10', '2025-12-10', 'SEAT', -431.00, 0.00, 25, '2025-12-10 14:42:52', '哈哈');
INSERT INTO `ticket_change` VALUES (19, 64, 'G1008', 'G1008', '081', '001', '2025-12-10', '2025-12-10', 'SEAT', 1724.00, 0.00, 25, '2025-12-10 14:44:00', '你好');
INSERT INTO `ticket_change` VALUES (30, 115, 'Z106', 'Z106', '004', '034', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:15:10', '有事');
INSERT INTO `ticket_change` VALUES (31, 116, 'Z106', 'Z106', '005', '035', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:15:11', '有事');
INSERT INTO `ticket_change` VALUES (32, 113, 'Z106', 'Z106', '002', '032', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:15:13', '有事');
INSERT INTO `ticket_change` VALUES (33, 114, 'Z106', 'Z106', '003', '033', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:15:14', '有事');
INSERT INTO `ticket_change` VALUES (34, 112, 'Z106', 'Z106', '001', '031', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:15:15', '有事');
INSERT INTO `ticket_change` VALUES (35, 117, 'Z106', 'Z106', '031', '081', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (36, 118, 'Z106', 'Z106', '032', '082', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (37, 119, 'Z106', 'Z106', '033', '083', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (38, 121, 'Z106', 'Z106', '035', '085', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (39, 120, 'Z106', 'Z106', '034', '084', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (40, 122, 'Z106', 'Z106', '036', '086', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (41, 124, 'Z106', 'Z106', '038', '088', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (42, 123, 'Z106', 'Z106', '037', '087', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:44', '有事');
INSERT INTO `ticket_change` VALUES (43, 125, 'Z106', 'Z106', '039', '089', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (44, 126, 'Z106', 'Z106', '040', '090', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (45, 127, 'Z106', 'Z106', '041', '091', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (46, 128, 'Z106', 'Z106', '042', '092', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (47, 130, 'Z106', 'Z106', '044', '094', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (48, 129, 'Z106', 'Z106', '043', '093', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (49, 131, 'Z106', 'Z106', '045', '095', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (50, 132, 'Z106', 'Z106', '046', '096', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (51, 133, 'Z106', 'Z106', '047', '097', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (52, 134, 'Z106', 'Z106', '048', '098', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (53, 135, 'Z106', 'Z106', '049', '099', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (54, 136, 'Z106', 'Z106', '050', '100', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (55, 137, 'Z106', 'Z106', '051', '101', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (56, 138, 'Z106', 'Z106', '052', '102', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (57, 139, 'Z106', 'Z106', '054', '103', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (58, 140, 'Z106', 'Z106', '055', '104', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (59, 141, 'Z106', 'Z106', '053', '105', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:45', '有事');
INSERT INTO `ticket_change` VALUES (60, 142, 'Z106', 'Z106', '056', '106', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (61, 143, 'Z106', 'Z106', '058', '107', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (62, 144, 'Z106', 'Z106', '057', '108', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (63, 145, 'Z106', 'Z106', '059', '109', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (64, 147, 'Z106', 'Z106', '061', '111', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (65, 146, 'Z106', 'Z106', '060', '110', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (66, 148, 'Z106', 'Z106', '062', '112', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (67, 149, 'Z106', 'Z106', '063', '113', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (68, 150, 'Z106', 'Z106', '064', '114', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (69, 151, 'Z106', 'Z106', '065', '115', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (70, 153, 'Z106', 'Z106', '067', '117', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (71, 152, 'Z106', 'Z106', '066', '116', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (72, 154, 'Z106', 'Z106', '068', '118', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (73, 156, 'Z106', 'Z106', '070', '120', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (74, 155, 'Z106', 'Z106', '069', '119', '2025-12-12', '2025-12-12', 'SEAT', -12.50, 0.00, 25, '2025-12-11 17:22:46', '有事');
INSERT INTO `ticket_change` VALUES (75, 158, 'Z106', 'G1008', '001', '031', '2025-12-14', '2025-12-14', 'BOTH', 1243.00, 0.00, 25, '2025-12-14 10:33:34', '临时有事');
INSERT INTO `ticket_change` VALUES (76, 160, NULL, NULL, NULL, NULL, NULL, NULL, 'TRAIN', -15.00, 0.00, 25, '2026-04-11 11:01:41', '今天有急事');
INSERT INTO `ticket_change` VALUES (77, 204, 'Z107', 'Z107', '022', '081', '2026-04-12', '2026-04-13', 'SEAT', -15.00, 0.00, 20, '2026-04-11 19:48:28', NULL);

-- ----------------------------
-- Table structure for train
-- ----------------------------
DROP TABLE IF EXISTS `train`;
CREATE TABLE `train`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '车次表' ROW_FORMAT = Dynamic;

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
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 94 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (20, 'passenger1', '$2a$10$leCbZXoMjG2A/QPC.iGBGOLFBWh56Zyi3sRkIJ.soom2zl2d5WGvu', 'PASSENGER', '15900139022', 1, '2025-12-04 10:40:58', '2025-12-12 20:50:44');
INSERT INTO `users` VALUES (21, 'test', '$2a$10$G4N2iXI6ktjzPNfLfGVvSOzeYZ149ddWQ1DavyqpKBMjaGTCTm8QW', 'PASSENGER', '15177933537', 1, '2025-12-04 10:40:58', '2025-12-04 10:40:58');
INSERT INTO `users` VALUES (24, 'admin', '$2a$10$X0f02QtfSVfE0kKaFVRuT.hi13X2RhaMcG3JAjiN2Spdrg63ESMlq', 'ADMIN', '13800138000', 1, '2025-12-04 11:06:33', '2025-12-04 22:11:48');
INSERT INTO `users` VALUES (25, 'operator1', '$2a$10$X0f02QtfSVfE0kKaFVRuT.hi13X2RhaMcG3JAjiN2Spdrg63ESMlq', 'OPERATOR', '13800138003', 1, '2025-12-04 11:06:33', '2025-12-10 16:26:02');
INSERT INTO `users` VALUES (27, '哇哈哈哈', '$2a$10$pEwEfPaCeLH.ijMObPQjMeZFcDnnRkpb1xaXYcbkyJe.tlmEClV/2', 'PASSENGER', '15177963538', 1, '2025-12-10 22:27:19', '2025-12-10 22:27:19');
INSERT INTO `users` VALUES (28, '娃哈哈哈', '$2a$10$uj3EEle0iEp9FDVonItY1eCW5o28frrA4ZDIeR8Ddf9X3X5e8bywW', 'PASSENGER', NULL, 1, '2025-12-10 22:27:46', '2025-12-10 22:27:46');
INSERT INTO `users` VALUES (29, '哈哈你', '$2a$10$BZ9Zmim0ieSILMhvsNd7OuHqUst9la1ipmhRESZ.8gw2uuRLLoR22', 'OPERATOR', '16994602024', 1, '2025-12-11 10:57:44', '2026-04-11 14:26:46');
INSERT INTO `users` VALUES (30, 'passenger242', '$2a$10b006658a70296c09999c$', 'OPERATOR', '15104366790', 1, '2025-12-10 14:05:56', '2025-12-07 14:05:56');
INSERT INTO `users` VALUES (31, 'operator551', '$2a$10d6fa842b84a86030bdf4$', 'PASSENGER', '15137298199', 1, '2025-12-11 14:05:56', '2025-11-12 14:05:56');
INSERT INTO `users` VALUES (32, 'operator450', '$2a$1056ae2019b3752e3dff60$', 'OPERATOR', '15103378680', 1, '2025-11-20 14:05:56', '2025-11-28 14:05:56');
INSERT INTO `users` VALUES (34, 'operator541', '$2a$10167f8c28ad4b21622013$', 'PASSENGER', '13086323088', 1, '2025-12-10 14:05:56', '2025-11-24 14:05:56');
INSERT INTO `users` VALUES (35, 'operator393', '$2a$104571a4504d8b079cf45c$', 'PASSENGER', '15167671932', 1, '2025-11-18 14:05:56', '2025-11-16 14:05:56');
INSERT INTO `users` VALUES (36, 'operator458', '$2a$1024e685ded44d13265e0d$', 'PASSENGER', '15106882866', 1, '2025-11-27 14:05:56', '2025-12-06 14:05:56');
INSERT INTO `users` VALUES (37, 'passenger689', '$2a$10791ba7a6e61b5e24bdc3$', 'OPERATOR', '13052180857', 1, '2025-11-21 14:05:56', '2025-11-16 14:05:56');
INSERT INTO `users` VALUES (38, 'passenger354', '$2a$10767e352d89f84f6c0f43$', 'PASSENGER', '13014282501', 1, '2025-11-20 14:05:56', '2025-12-07 14:05:56');
INSERT INTO `users` VALUES (39, 'operator447', '$2a$104184732f62fd98976256$', 'PASSENGER', '15149998309', 1, '2025-11-12 14:05:56', '2025-12-01 14:05:56');
INSERT INTO `users` VALUES (40, 'operator475', '$2a$10ac26161519929694447e$', 'OPERATOR', '18944182617', 1, '2025-11-19 14:05:56', '2025-11-29 14:05:56');
INSERT INTO `users` VALUES (41, 'operator196', '$2a$100fffc5c15c8688e8f32d$', 'PASSENGER', '15144643826', 1, '2025-11-19 14:05:56', '2025-12-02 14:05:56');
INSERT INTO `users` VALUES (42, 'passenger379', '$2a$10347c5bbbeadacaf7e5b5$', 'PASSENGER', '15187479071', 1, '2025-11-22 14:05:56', '2025-11-24 14:05:56');
INSERT INTO `users` VALUES (43, 'passenger474', '$2a$10989edb77673c009cd6c2$', 'OPERATOR', '15145832263', 1, '2025-11-23 14:05:56', '2025-11-21 14:05:56');
INSERT INTO `users` VALUES (44, 'operator1002', '$2a$1057aadd2dfc05650c8ba1$', 'OPERATOR', '18945289639', 1, '2025-12-05 14:05:56', '2025-11-17 14:05:56');
INSERT INTO `users` VALUES (45, 'passenger336', '$2a$10b8bf765530c050c5caf2$', 'PASSENGER', '15138694858', 1, '2025-12-09 14:05:56', '2025-12-05 14:05:56');
INSERT INTO `users` VALUES (46, 'operator678', '$2a$104bf29bf02aae84993c3b$', 'PASSENGER', '13097836466', 1, '2025-12-06 14:05:56', '2025-12-11 14:05:56');
INSERT INTO `users` VALUES (47, 'operator845', '$2a$103621599f75e48016c0e8$', 'OPERATOR', '15136326666', 1, '2025-11-24 14:05:56', '2025-11-17 14:05:56');
INSERT INTO `users` VALUES (48, 'passenger337', '$2a$10bd9c5400d2c0d9db5586$', 'PASSENGER', '13006338484', 1, '2025-11-30 14:05:56', '2025-11-21 14:05:56');
INSERT INTO `users` VALUES (49, 'passenger597', '$2a$1042cc39f537361f84d9e7$', 'PASSENGER', '15150567141', 1, '2025-11-25 14:05:56', '2025-12-04 14:05:56');
INSERT INTO `users` VALUES (61, 'passenger7844', '$2a$10f7ab9e33c03401deebe9$', 'OPERATOR', '18920247562', 1, '2025-11-13 14:07:01', '2025-12-06 14:07:01');
INSERT INTO `users` VALUES (62, 'passenger8613', '$2a$10789b6fbd2c22918e2370$', 'PASSENGER', '18976714359', 1, '2025-11-24 14:07:01', '2025-11-25 14:07:01');
INSERT INTO `users` VALUES (63, 'passenger6460', '$2a$10682ab7417b32f019f79f$', 'OPERATOR', '13095989976', 1, '2025-11-28 14:07:01', '2025-12-02 14:07:01');
INSERT INTO `users` VALUES (64, 'passenger1925', '$2a$105318d02c8b7338972303$', 'PASSENGER', '15151771751', 1, '2025-12-04 14:07:01', '2025-11-20 14:07:01');
INSERT INTO `users` VALUES (65, 'operator3233', '$2a$107cbc489a97b6ed4cd2c5$', 'PASSENGER', '18917871260', 1, '2025-12-07 14:07:01', '2025-12-04 14:07:01');
INSERT INTO `users` VALUES (66, 'operator2787', '$2a$10f662468c4b510d7b9050$', 'PASSENGER', '15166669716', 1, '2025-11-28 14:07:01', '2025-12-06 14:07:01');
INSERT INTO `users` VALUES (67, 'operator6266', '$2a$1098a4a3916bacffc93a68$', 'PASSENGER', '18972022862', 1, '2025-11-23 14:07:01', '2025-11-14 14:07:01');
INSERT INTO `users` VALUES (68, 'operator6736', '$2a$10d52204b9e2bf781f5c10$', 'PASSENGER', '15130322906', 1, '2025-12-08 14:07:01', '2025-11-19 14:07:01');
INSERT INTO `users` VALUES (69, 'passenger4374', '$2a$108c192cd9078be842197f$', 'PASSENGER', '15105636621', 1, '2025-11-16 14:07:01', '2025-12-09 14:07:01');
INSERT INTO `users` VALUES (70, 'operator9642', '$2a$103c8bf0750b3f907d6ac5$', 'OPERATOR', '18981497862', 1, '2025-11-30 14:07:01', '2025-11-26 14:07:01');
INSERT INTO `users` VALUES (71, 'passenger7785', '$2a$1054637ff5adf8c0e858dc$', 'OPERATOR', '15157855328', 1, '2025-11-13 14:07:01', '2025-12-09 14:07:01');
INSERT INTO `users` VALUES (72, 'operator4392', '$2a$10a3372ff392445fe5a7a2$', 'PASSENGER', '13041833352', 1, '2025-11-20 14:07:01', '2025-12-04 14:07:01');
INSERT INTO `users` VALUES (73, 'passenger9626', '$2a$105fa913c8714eabf35e14$', 'OPERATOR', '18986597156', 1, '2025-12-10 14:07:01', '2025-11-21 14:07:01');
INSERT INTO `users` VALUES (74, 'passenger4538', '$2a$109a52cfb369ce7263f984$', 'PASSENGER', '18971887146', 1, '2025-11-13 14:07:01', '2025-11-22 14:07:01');
INSERT INTO `users` VALUES (75, 'passenger7524', '$2a$101c1da5d7352665bab75f$', 'OPERATOR', '13041571807', 1, '2025-11-16 14:07:01', '2025-11-14 14:07:01');
INSERT INTO `users` VALUES (76, 'passenger8862', '$2a$10affe89fedbaa566cf903$', 'PASSENGER', '15195734856', 1, '2025-11-19 14:07:01', '2025-11-14 14:07:01');
INSERT INTO `users` VALUES (77, 'passenger6511', '$2a$10920a925727a5401246d7$', 'PASSENGER', '15148770145', 1, '2025-11-21 14:07:01', '2025-12-11 14:07:01');
INSERT INTO `users` VALUES (78, 'operator7137', '$2a$10156b99f6440f6ca8872c$', 'OPERATOR', '18942072962', 1, '2025-11-24 14:07:01', '2025-11-21 14:07:01');
INSERT INTO `users` VALUES (79, 'operator1617', '$2a$107dea46ca0982b59d93d0$', 'PASSENGER', '15145553425', 1, '2025-11-29 14:07:01', '2025-11-20 14:07:01');
INSERT INTO `users` VALUES (80, 'passenger7214', '$2a$1075ac07914115f216d1d4$', 'OPERATOR', '18994920649', 1, '2025-11-14 14:07:01', '2025-11-19 14:07:01');
INSERT INTO `users` VALUES (81, 'operator6813', '$2a$109aae4f293ce63da96ac8$', 'OPERATOR', '18966715808', 1, '2025-11-19 14:07:01', '2025-11-20 14:07:01');
INSERT INTO `users` VALUES (92, '叶文洁', '$2a$10$8Uk1M6fvuugQQKUEXeynuOPjK0OE9SorPAZaX9.oS0moHVtiYQaJW', 'PASSENGER', '15177963857', 1, '2025-12-12 18:00:16', '2025-12-12 18:00:16');
INSERT INTO `users` VALUES (93, '云天命', '$2a$10$qZ1F0Pe29O5C1IH5VvjSNugAfw3DFmGvlvHPAhiM.tMk5pmFiEoNy', 'PASSENGER', '15177933537', 1, '2025-12-12 18:08:46', '2025-12-12 18:08:46');
INSERT INTO `users` VALUES (94, '个人助手', '$2a$10$bjY9jsXm4FnJFT5sZUYkQ.Rbp8YXnOVHlcMzgq0OG919EtVbGsp.u', 'OPERATOR', '15733578642', 1, '2026-04-11 14:26:40', '2026-04-11 14:26:40');

-- ----------------------------
-- View structure for v_available_seats
-- ----------------------------
DROP VIEW IF EXISTS `v_available_seats`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_available_seats` AS select `s`.`seat_id` AS `seat_id`,`s`.`train_id` AS `train_id`,`t`.`train_number` AS `train_number`,`s`.`travel_date` AS `travel_date`,`s`.`seat_number` AS `seat_number`,`s`.`seat_type` AS `seat_type`,`s`.`carriage_number` AS `carriage_number`,(`t`.`base_price` * `s`.`price_coefficient`) AS `price` from (`seat` `s` join `train` `t` on((`s`.`train_id` = `t`.`train_id`))) where (`s`.`status` = 'available');

-- ----------------------------
-- View structure for v_order_detail
-- ----------------------------
DROP VIEW IF EXISTS `v_order_detail`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_order_detail` AS select `o`.`order_id` AS `order_id`,`o`.`order_number` AS `order_number`,`o`.`user_id` AS `user_id`,`u`.`user_name` AS `user_name`,`o`.`total_amount` AS `total_amount`,`o`.`order_status` AS `order_status`,count(`t`.`ticket_id`) AS `ticket_count`,`o`.`created_at` AS `created_at` from ((`orders` `o` join `users` `u` on((`o`.`user_id` = `u`.`user_id`))) left join `ticket` `t` on((`o`.`order_id` = `t`.`order_id`))) group by `o`.`order_id`;

-- ----------------------------
-- View structure for v_today_sales
-- ----------------------------
DROP VIEW IF EXISTS `v_today_sales`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_today_sales` AS select count(distinct `o`.`order_id`) AS `total_orders`,count(`t`.`ticket_id`) AS `total_tickets`,coalesce(sum(`o`.`total_amount`),0) AS `total_amount`,count(distinct (case when (`o`.`order_status` = 'PAID') then `o`.`order_id` end)) AS `paid_orders` from (`orders` `o` left join `ticket` `t` on((`o`.`order_id` = `t`.`order_id`))) where (cast(`o`.`created_at` as date) = curdate());

-- ----------------------------
-- Function structure for fn_calculate_ticket_price
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_calculate_ticket_price`;
delimiter ;;
CREATE FUNCTION `fn_calculate_ticket_price`(p_train_id INT,
    p_start_station VARCHAR(100),
    p_end_station VARCHAR(100),
    p_seat_type VARCHAR(20))
 RETURNS decimal(10,2)
  READS SQL DATA 
  DETERMINISTIC
BEGIN
    DECLARE v_base_price DECIMAL(10,2);
    DECLARE v_price_coefficient DECIMAL(3,2);
    DECLARE v_start_order INT;
    DECLARE v_end_order INT;
    DECLARE v_additional_price DECIMAL(10,2);
    DECLARE v_final_price DECIMAL(10,2);

    -- 获取基础票价
SELECT base_price INTO v_base_price FROM train WHERE train_id = p_train_id;

-- 获取座位类型系数
SELECT price_coefficient INTO v_price_coefficient
FROM seat
WHERE train_id = p_train_id AND seat_type = p_seat_type
    LIMIT 1;

-- 获取起止站的顺序
SELECT stop_order INTO v_start_order
FROM route
WHERE train_id = p_train_id AND station_name = p_start_station;

SELECT stop_order INTO v_end_order
FROM route
WHERE train_id = p_train_id AND station_name = p_end_station;

-- 计算区间附加价格
SELECT SUM(additional_price) INTO v_additional_price
FROM route
WHERE train_id = p_train_id
  AND stop_order > v_start_order
  AND stop_order <= v_end_order;

-- 计算最终价格
SET v_final_price = (v_base_price + IFNULL(v_additional_price, 0)) * IFNULL(v_price_coefficient, 1.0);

RETURN ROUND(v_final_price, 2);
END
;;
delimiter ;

-- ----------------------------
-- Function structure for fn_check_seat_available
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_check_seat_available`;
delimiter ;;
CREATE FUNCTION `fn_check_seat_available`(p_seat_id INT,
    p_travel_date DATE)
 RETURNS tinyint(1)
  READS SQL DATA 
  DETERMINISTIC
BEGIN
    DECLARE v_count INT;

SELECT COUNT(*) INTO v_count
FROM ticket
WHERE seat_id = p_seat_id
  AND travel_date = p_travel_date
  AND status NOT IN ('REFUNDED', 'EXPIRED');

RETURN v_count = 0;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for fn_get_user_role
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_get_user_role`;
delimiter ;;
CREATE FUNCTION `fn_get_user_role`(p_user_id INT)
 RETURNS varchar(20) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
  READS SQL DATA 
  DETERMINISTIC
BEGIN
    DECLARE v_role VARCHAR(20);
SELECT role INTO v_role FROM users WHERE userid = p_user_id;
RETURN v_role;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for generate_routes
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
            INSERT INTO route (train_id, station_id, stop_order, arrival_time, departure_time, stop_duration, distance_from_start, additional_price)
            VALUES (v_train_id, v_start_station_id, 1, NULL, v_departure_time, 0, 0, 0.00);
        END IF;
        
        -- 插入终点站路线
        IF v_end_station_id IS NOT NULL THEN
            INSERT INTO route (train_id, station_id, stop_order, arrival_time, departure_time, stop_duration, distance_from_start, additional_price)
            VALUES (v_train_id, v_end_station_id, 2, v_arrival_time, NULL, 0, 500, v_base_price);
        END IF;
    END LOOP;
    
    CLOSE train_cursor;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for p_add_train_auto_routes
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_add_train_auto_routes`;
delimiter ;;
CREATE PROCEDURE `p_add_train_auto_routes`(IN p_train_number VARCHAR(20),
    IN p_train_type VARCHAR(20),
    IN p_total_seats INT,
    IN p_start_station VARCHAR(100),
    IN p_end_station VARCHAR(100),
    IN p_departure_time TIME,
    IN p_arrival_time TIME,
    IN p_base_price DECIMAL(10,2))
BEGIN
    DECLARE v_train_id INT;
    DECLARE v_station_id INT;
    DECLARE v_total_duration INT;
    DECLARE v_stop_order INT DEFAULT 1;
    
    -- 1. 插入车次
    INSERT INTO train (
        train_number, train_type, total_seats, 
        start_station, end_station, 
        departure_time, arrival_time, base_price, status
    ) VALUES (
        p_train_number, p_train_type, p_total_seats,
        p_start_station, p_end_station,
        p_departure_time, p_arrival_time, p_base_price, 1
    );
    
    SET v_train_id = LAST_INSERT_ID();
    
    -- 计算总时长（分钟）
    SET v_total_duration = TIMESTAMPDIFF(MINUTE, p_departure_time, p_arrival_time);
    IF v_total_duration < 0 THEN
        SET v_total_duration = v_total_duration + 1440;
    END IF;
    
    -- =============================================
    -- 京沪高铁：北京站 → 上海站
    -- =============================================
    IF p_start_station = '北京站' AND p_end_station = '上海站' THEN
        -- 1. 北京站（起点）
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        -- 2. 天津南站
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '天津南站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('天津南站', '天津', '天津市', '特等站', '天津市西青区张家窝镇', '022-12306001', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '天津南站', 2, ADDTIME(p_departure_time, '00:33:00'), ADDTIME(p_departure_time, '00:35:00'), 2, 122, ROUND(p_base_price * 0.09, 2), NOW(), NOW());
        
        -- 3. 济南西站
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '济南西站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('济南西站', '济南', '山东省', '特等站', '济南市槐荫区齐鲁大道6号', '0531-12306002', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '济南西站', 3, ADDTIME(p_departure_time, '01:37:00'), ADDTIME(p_departure_time, '01:40:00'), 3, 406, ROUND(p_base_price * 0.31, 2), NOW(), NOW());
        
        -- 4. 南京南站
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '南京南站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('南京南站', '南京', '江苏省', '特等站', '南京市雨花台区玉兰路98号', '025-12306006', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '南京南站', 4, ADDTIME(p_departure_time, '03:30:00'), ADDTIME(p_departure_time, '03:33:00'), 3, 1023, ROUND(p_base_price * 0.78, 2), NOW(), NOW());
        
        -- 5. 上海站（终点）
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '上海站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '上海站', 5, p_arrival_time, NULL, 0, 1318, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 京沪高铁：上海站 → 北京站
    -- =============================================
    ELSEIF p_start_station = '上海站' AND p_end_station = '北京站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '上海站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '上海站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '南京南站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '南京南站', 2, ADDTIME(p_departure_time, '00:59:00'), ADDTIME(p_departure_time, '01:02:00'), 3, 295, ROUND(p_base_price * 0.22, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '济南西站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '济南西站', 3, ADDTIME(p_departure_time, '02:52:00'), ADDTIME(p_departure_time, '02:55:00'), 3, 912, ROUND(p_base_price * 0.69, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '天津南站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '天津南站', 4, ADDTIME(p_departure_time, '03:56:00'), ADDTIME(p_departure_time, '03:58:00'), 2, 1196, ROUND(p_base_price * 0.91, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 5, p_arrival_time, NULL, 0, 1318, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 京广高铁：北京站 → 广州南站
    -- =============================================
    ELSEIF p_start_station = '北京站' AND p_end_station = '广州南站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '石家庄站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('石家庄站', '石家庄', '河北省', '特等站', '石家庄市桥西区', '0311-12306003', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '石家庄站', 2, ADDTIME(p_departure_time, '01:08:00'), ADDTIME(p_departure_time, '01:11:00'), 3, 281, ROUND(p_base_price * 0.12, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '郑州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '郑州东站', 3, ADDTIME(p_departure_time, '02:34:00'), ADDTIME(p_departure_time, '02:38:00'), 4, 693, ROUND(p_base_price * 0.30, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '武汉站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '武汉站', 4, ADDTIME(p_departure_time, '04:24:00'), ADDTIME(p_departure_time, '04:28:00'), 4, 1229, ROUND(p_base_price * 0.53, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '长沙南站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('长沙南站', '长沙', '湖南省', '特等站', '长沙市雨花区', '0731-12306004', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '长沙南站', 5, ADDTIME(p_departure_time, '05:54:00'), ADDTIME(p_departure_time, '05:58:00'), 4, 1591, ROUND(p_base_price * 0.69, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '广州南站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '广州南站', 6, p_arrival_time, NULL, 0, 2298, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 京广高铁：广州南站 → 北京站
    -- =============================================
    ELSEIF p_start_station = '广州南站' AND p_end_station = '北京站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '广州南站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '广州南站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '长沙南站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('长沙南站', '长沙', '湖南省', '特等站', '长沙市雨花区', '0731-12306004', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '长沙南站', 2, ADDTIME(p_departure_time, '02:06:00'), ADDTIME(p_departure_time, '02:10:00'), 4, 707, ROUND(p_base_price * 0.31, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '武汉站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '武汉站', 3, ADDTIME(p_departure_time, '03:36:00'), ADDTIME(p_departure_time, '03:40:00'), 4, 1069, ROUND(p_base_price * 0.47, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '郑州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '郑州东站', 4, ADDTIME(p_departure_time, '05:26:00'), ADDTIME(p_departure_time, '05:30:00'), 4, 1605, ROUND(p_base_price * 0.70, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '石家庄站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('石家庄站', '石家庄', '河北省', '特等站', '石家庄市桥西区', '0311-12306003', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '石家庄站', 5, ADDTIME(p_departure_time, '06:52:00'), ADDTIME(p_departure_time, '06:55:00'), 3, 2017, ROUND(p_base_price * 0.88, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 6, p_arrival_time, NULL, 0, 2298, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 沪杭高铁：上海站 → 杭州东站
    -- =============================================
    ELSEIF p_start_station = '上海站' AND p_end_station = '杭州东站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '上海站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '上海站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '嘉兴南站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('嘉兴南站', '嘉兴', '浙江省', '一等站', '嘉兴市南湖区', '0573-12306005', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '嘉兴南站', 2, ADDTIME(p_departure_time, '00:25:00'), ADDTIME(p_departure_time, '00:27:00'), 2, 78, ROUND(p_base_price * 0.49, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '杭州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '杭州东站', 3, p_arrival_time, NULL, 0, 159, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 沪杭高铁：杭州东站 → 上海站
    -- =============================================
    ELSEIF p_start_station = '杭州东站' AND p_end_station = '上海站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '杭州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '杭州东站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '嘉兴南站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('嘉兴南站', '嘉兴', '浙江省', '一等站', '嘉兴市南湖区', '0573-12306005', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '嘉兴南站', 2, ADDTIME(p_departure_time, '00:20:00'), ADDTIME(p_departure_time, '00:22:00'), 2, 81, ROUND(p_base_price * 0.51, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '上海站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '上海站', 3, p_arrival_time, NULL, 0, 159, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 京西线：北京站 → 西安北站
    -- =============================================
    ELSEIF p_start_station = '北京站' AND p_end_station = '西安北站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '石家庄站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('石家庄站', '石家庄', '河北省', '特等站', '石家庄市桥西区', '0311-12306003', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '石家庄站', 2, ADDTIME(p_departure_time, '01:08:00'), ADDTIME(p_departure_time, '01:11:00'), 3, 281, ROUND(p_base_price * 0.23, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '郑州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '郑州东站', 3, ADDTIME(p_departure_time, '02:34:00'), ADDTIME(p_departure_time, '02:38:00'), 4, 693, ROUND(p_base_price * 0.57, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '西安北站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '西安北站', 4, p_arrival_time, NULL, 0, 1216, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 京西线：西安北站 → 北京站
    -- =============================================
    ELSEIF p_start_station = '西安北站' AND p_end_station = '北京站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '西安北站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '西安北站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '郑州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '郑州东站', 2, ADDTIME(p_departure_time, '01:56:00'), ADDTIME(p_departure_time, '02:00:00'), 4, 523, ROUND(p_base_price * 0.43, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '石家庄站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('石家庄站', '石家庄', '河北省', '特等站', '石家庄市桥西区', '0311-12306003', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '石家庄站', 3, ADDTIME(p_departure_time, '03:22:00'), ADDTIME(p_departure_time, '03:25:00'), 3, 935, ROUND(p_base_price * 0.77, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 4, p_arrival_time, NULL, 0, 1216, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 京蓉线：北京站 → 成都东站
    -- =============================================
    ELSEIF p_start_station = '北京站' AND p_end_station = '成都东站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '石家庄站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('石家庄站', '石家庄', '河北省', '特等站', '石家庄市桥西区', '0311-12306003', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '石家庄站', 2, ADDTIME(p_departure_time, '01:08:00'), ADDTIME(p_departure_time, '01:11:00'), 3, 281, ROUND(p_base_price * 0.15, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '郑州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '郑州东站', 3, ADDTIME(p_departure_time, '02:34:00'), ADDTIME(p_departure_time, '02:38:00'), 4, 693, ROUND(p_base_price * 0.37, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '西安北站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '西安北站', 4, ADDTIME(p_departure_time, '04:30:00'), ADDTIME(p_departure_time, '04:35:00'), 5, 1216, ROUND(p_base_price * 0.65, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '成都东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '成都东站', 5, p_arrival_time, NULL, 0, 1874, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 京蓉线：成都东站 → 北京站
    -- =============================================
    ELSEIF p_start_station = '成都东站' AND p_end_station = '北京站' THEN
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '成都东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '成都东站', 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '西安北站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '西安北站', 2, ADDTIME(p_departure_time, '03:00:00'), ADDTIME(p_departure_time, '03:05:00'), 5, 658, ROUND(p_base_price * 0.35, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '郑州东站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '郑州东站', 3, ADDTIME(p_departure_time, '04:56:00'), ADDTIME(p_departure_time, '05:00:00'), 4, 1181, ROUND(p_base_price * 0.63, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '石家庄站' LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) VALUES ('石家庄站', '石家庄', '河北省', '特等站', '石家庄市桥西区', '0311-12306003', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '石家庄站', 4, ADDTIME(p_departure_time, '06:22:00'), ADDTIME(p_departure_time, '06:25:00'), 3, 1593, ROUND(p_base_price * 0.85, 2), NOW(), NOW());
        
        SELECT station_id INTO v_station_id FROM station WHERE station_name = '北京站' LIMIT 1;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, '北京站', 5, p_arrival_time, NULL, 0, 1874, p_base_price, NOW(), NOW());
    
    -- =============================================
    -- 无匹配线路：只生成起点和终点
    -- =============================================
    ELSE
        -- 确保起点站存在
        SELECT station_id INTO v_station_id FROM station WHERE station_name = p_start_station LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) 
            VALUES (p_start_station, '未知', '未知', '三等站', '待完善', '待完善', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, p_start_station, 1, NULL, p_departure_time, 0, 0, 0, NOW(), NOW());
        
        -- 确保终点站存在
        SET v_station_id = NULL;
        SELECT station_id INTO v_station_id FROM station WHERE station_name = p_end_station LIMIT 1;
        IF v_station_id IS NULL THEN
            INSERT INTO station (station_name, city, province, station_level, address, contact_phone, status) 
            VALUES (p_end_station, '未知', '未知', '三等站', '待完善', '待完善', 1);
            SET v_station_id = LAST_INSERT_ID();
        END IF;
        INSERT INTO route VALUES (NULL, v_train_id, v_station_id, p_end_station, 2, p_arrival_time, NULL, 0, 1000, p_base_price, NOW(), NOW());
    END IF;
    
    SELECT v_train_id as new_train_id;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for p_update_route_times
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_update_route_times`;
delimiter ;;
CREATE PROCEDURE `p_update_route_times`(IN p_train_id INT,
    IN p_new_departure TIME,
    IN p_new_arrival TIME)
BEGIN
    DECLARE v_old_departure TIME;
    DECLARE v_old_arrival TIME;
    DECLARE v_old_total_minutes INT;
    DECLARE v_new_total_minutes INT;
    DECLARE v_time_ratio DECIMAL(10, 6);
    DECLARE v_max_stop_order INT;
    DECLARE v_departure_diff_minutes INT;
    
    -- 获取原来的发车和到达时间
    SELECT departure_time, arrival_time INTO v_old_departure, v_old_arrival
    FROM train WHERE train_id = p_train_id;
    
    -- 计算原始总行程时间（分钟）
    SET v_old_total_minutes = TIMESTAMPDIFF(MINUTE, v_old_departure, v_old_arrival);
    IF v_old_total_minutes <= 0 THEN
        SET v_old_total_minutes = v_old_total_minutes + 1440; -- 跨天处理
    END IF;
    
    -- 计算新的总行程时间（分钟）
    SET v_new_total_minutes = TIMESTAMPDIFF(MINUTE, p_new_departure, p_new_arrival);
    IF v_new_total_minutes <= 0 THEN
        SET v_new_total_minutes = v_new_total_minutes + 1440; -- 跨天处理
    END IF;
    
    -- 计算时间比例
    SET v_time_ratio = v_new_total_minutes / v_old_total_minutes;
    
    -- 计算发车时间偏移（分钟）
    SET v_departure_diff_minutes = TIMESTAMPDIFF(MINUTE, v_old_departure, p_new_departure);
    
    -- 获取最大停靠顺序（终点站）
    SELECT MAX(stop_order) INTO v_max_stop_order FROM route WHERE train_id = p_train_id;
    
    -- 更新所有途经站的时间
    UPDATE route r
    SET 
        -- 到达时间：起点站保持NULL，其他站按比例计算
        arrival_time = CASE 
            WHEN r.stop_order = 1 THEN NULL
            WHEN r.stop_order = v_max_stop_order THEN p_new_arrival
            ELSE ADDTIME(
                p_new_departure,
                SEC_TO_TIME(
                    ROUND(
                        TIMESTAMPDIFF(SECOND, v_old_departure, r.arrival_time) * v_time_ratio
                    )
                )
            )
        END,
        -- 出发时间：终点站保持NULL，其他站按比例计算
        departure_time = CASE 
            WHEN r.stop_order = v_max_stop_order THEN NULL
            WHEN r.stop_order = 1 THEN p_new_departure
            ELSE ADDTIME(
                p_new_departure,
                SEC_TO_TIME(
                    ROUND(
                        TIMESTAMPDIFF(SECOND, v_old_departure, r.departure_time) * v_time_ratio
                    )
                )
            )
        END
    WHERE r.train_id = p_train_id;
    
    -- 返回更新后的路线
    SELECT stop_order, station_name, arrival_time, departure_time 
    FROM route WHERE train_id = p_train_id ORDER BY stop_order;
    
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_calculate_refund_fee
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_calculate_refund_fee`;
delimiter ;;
CREATE PROCEDURE `sp_calculate_refund_fee`(IN p_ticket_id INT,
    OUT p_refund_fee DECIMAL(10,2),
    OUT p_refund_amount DECIMAL(10,2))
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_travel_date DATE;
    DECLARE v_departure_time TIME;
    DECLARE hours_before INT;

    -- 获取车票信息
SELECT price, travel_date, departure_time
INTO v_price, v_travel_date, v_departure_time
FROM ticket
WHERE ticket_id = p_ticket_id;

-- 计算距离发车时间
SET hours_before = TIMESTAMPDIFF(HOUR, NOW(), CONCAT(v_travel_date, ' ', v_departure_time));

    -- 根据时间计算手续费
    IF hours_before > 48 THEN
        SET p_refund_fee = 0;  -- 48小时以上免手续费
    ELSEIF hours_before >= 24 THEN
        SET p_refund_fee = v_price * 0.05;  -- 24-48小时收5%
    ELSEIF hours_before >= 2 THEN
        SET p_refund_fee = v_price * 0.10;  -- 2-24小时收10%
ELSE
        SET p_refund_fee = v_price * 0.20;  -- 2小时内收20%
END IF;

    SET p_refund_amount = v_price - p_refund_fee;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_available_seats
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_available_seats`;
delimiter ;;
CREATE PROCEDURE `sp_get_available_seats`(IN p_train_id INT,
    IN p_travel_date DATE)
BEGIN
SELECT
    s.seat_id,
    s.carriage_number,
    s.seat_number,
    s.seat_type,
    s.status,
    ROUND(t.base_price * s.price_coefficient, 2) AS price
FROM seat s
         INNER JOIN train t ON s.train_id = t.train_id
WHERE s.train_id = p_train_id
  AND s.status = 'available'
  AND s.seat_id NOT IN (
    SELECT seat_id FROM ticket
    WHERE train_id = p_train_id
      AND travel_date = p_travel_date
      AND status NOT IN ('REFUNDED', 'EXPIRED')
)
ORDER BY s.carriage_number, s.seat_number;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_popular_routes_analysis
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_popular_routes_analysis`;
delimiter ;;
CREATE PROCEDURE `sp_popular_routes_analysis`(IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_limit INT)
BEGIN
SELECT
    t.start_station,
    t.end_station,
    COUNT(t.ticket_id) AS ticket_count,
    SUM(t.price) AS total_revenue,
    AVG(t.price) AS avg_price,
    COUNT(DISTINCT t.passenger_id) AS unique_passengers
FROM ticket t
WHERE t.travel_date BETWEEN p_start_date AND p_end_date
  AND t.had_pay = 1
  AND t.status NOT IN ('REFUNDED', 'EXPIRED')
GROUP BY t.start_station, t.end_station
ORDER BY ticket_count DESC
    LIMIT p_limit;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_seller_performance
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_seller_performance`;
delimiter ;;
CREATE PROCEDURE `sp_seller_performance`(IN p_start_date DATE,
    IN p_end_date DATE)
BEGIN
SELECT
    u.userid,
    u.user_name AS seller_name,
    COUNT(t.ticket_id) AS tickets_sold,
    SUM(t.price) AS total_revenue,
    AVG(t.price) AS avg_ticket_price,
    COUNT(CASE WHEN t.is_PreBook = 1 THEN 1 END) AS prebook_count,
    COUNT(DISTINCT t.passenger_id) AS unique_customers,
    COUNT(DISTINCT DATE(t.sale_time)) AS working_days
FROM users u
         LEFT JOIN ticket t ON u.userid = t.seller_id
    AND DATE(t.sale_time) BETWEEN p_start_date AND p_end_date
    AND t.had_pay = 1
WHERE u.role = 'OPERATOR'
GROUP BY u.userid, u.user_name
ORDER BY total_revenue DESC;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_ticket_sales_statistics
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_ticket_sales_statistics`;
delimiter ;;
CREATE PROCEDURE `sp_ticket_sales_statistics`(IN p_start_date DATE,
    IN p_end_date DATE)
BEGIN
SELECT
    DATE(sale_time) AS sale_date,
    COUNT(ticket_id) AS total_tickets,
    SUM(CASE WHEN had_pay = 1 THEN 1 ELSE 0 END) AS paid_tickets,
    SUM(CASE WHEN is_PreBook = 1 THEN 1 ELSE 0 END) AS prebook_tickets,
    SUM(price) AS total_revenue,
    AVG(price) AS avg_price,
    COUNT(DISTINCT passenger_id) AS unique_passengers
FROM ticket
WHERE DATE(sale_time) BETWEEN p_start_date AND p_end_date
GROUP BY DATE(sale_time)
ORDER BY sale_date;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_train_occupancy_rate
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_train_occupancy_rate`;
delimiter ;;
CREATE PROCEDURE `sp_train_occupancy_rate`(IN p_start_date DATE,
    IN p_end_date DATE)
BEGIN
SELECT
    tr.train_number,
    tr.train_type,
    tr.total_seats,
    DATE(t.travel_date) AS travel_date,
    COUNT(t.ticket_id) AS sold_seats,
    ROUND(COUNT(t.ticket_id) * 100.0 / tr.total_seats, 2) AS occupancy_rate
FROM train tr
    LEFT JOIN ticket t ON tr.train_id = t.train_id
    AND t.travel_date BETWEEN p_start_date AND p_end_date
    AND t.had_pay = 1
    AND t.status NOT IN ('REFUNDED', 'EXPIRED')
WHERE tr.status = 1
GROUP BY tr.train_id, tr.train_number, tr.train_type, tr.total_seats, DATE(t.travel_date)
ORDER BY travel_date, tr.train_number;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table orders
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_order_generate_number`;
delimiter ;;
CREATE TRIGGER `trg_order_generate_number` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
    IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        SET NEW.order_number = CONCAT('OD', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table ticket
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_ticket_generate_number`;
delimiter ;;
CREATE TRIGGER `trg_ticket_generate_number` BEFORE INSERT ON `ticket` FOR EACH ROW BEGIN
    DECLARE train_num VARCHAR(20);
    IF NEW.ticket_number IS NULL OR NEW.ticket_number = '' THEN
    SELECT train_number INTO train_num FROM train WHERE train_id = NEW.train_id;
    SET NEW.ticket_number = CONCAT('T', train_num, DATE_FORMAT(NEW.travel_date, '%Y%m%d'), LPAD(FLOOR(RAND() * 100000), 5, '0'));
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table ticket
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_ticket_insert_update_seat`;
delimiter ;;
CREATE TRIGGER `trg_ticket_insert_update_seat` AFTER INSERT ON `ticket` FOR EACH ROW BEGIN
    IF NEW.had_pay = 1 THEN
    UPDATE seat SET status = 'occupied' WHERE seat_id = NEW.seat_id;
    ELSE
    UPDATE seat SET status = 'locked' WHERE seat_id = NEW.seat_id;
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table ticket
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_ticket_update_release_seat`;
delimiter ;;
CREATE TRIGGER `trg_ticket_update_release_seat` AFTER UPDATE ON `ticket` FOR EACH ROW BEGIN
    IF NEW.status = 'REFUNDED' AND OLD.status != 'REFUNDED' THEN
    UPDATE seat SET status = 'available' WHERE seat_id = NEW.seat_id;
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table users
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_user_update_log`;
delimiter ;;
CREATE TRIGGER `trg_user_update_log` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO operation_log (user_id, username, operation, module, params, status)
        VALUES (NEW.user_id, NEW.user_name, 'UPDATE_STATUS', 'USER',
                CONCAT('status changed from ', OLD.status, ' to ', NEW.status), 'SUCCESS');
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
