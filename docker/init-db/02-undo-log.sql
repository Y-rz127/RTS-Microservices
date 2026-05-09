-- Seata AT mode undo_log table
-- Must exist in every schema that participates in distributed transactions

USE `railway_ticket_system`;

DELIMITER //

CREATE PROCEDURE create_undo_log(IN db_name VARCHAR(64))
BEGIN
    SET @sql = CONCAT('
        CREATE TABLE IF NOT EXISTS `', db_name, '`.`undo_log` (
            `branch_id`     BIGINT       NOT NULL COMMENT ''branch transaction id'',
            `xid`           VARCHAR(128) NOT NULL COMMENT ''global transaction id'',
            `context`       VARCHAR(128) NOT NULL COMMENT ''undo_log context, such as serialization'',
            `rollback_info` LONGBLOB     NOT NULL COMMENT ''rollback info'',
            `log_status`    INT          NOT NULL COMMENT ''0: normal, 1: defense'',
            `log_created`   DATETIME(6)  NOT NULL COMMENT ''create datetime'',
            `log_modified`  DATETIME(6)  NOT NULL COMMENT ''modify datetime'',
            UNIQUE KEY `ux_undo_log` (`xid`, `branch_id`)
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = ''AT transaction mode undo table'';
    ');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

CALL create_undo_log('rts_user');
CALL create_undo_log('rts_train');
CALL create_undo_log('rts_ticket');
CALL create_undo_log('rts_approval');

DROP PROCEDURE IF EXISTS create_undo_log;
