-- Create separate schemas for each microservice
-- Single MySQL instance, multiple schemas, no sharding

CREATE DATABASE IF NOT EXISTS `railway_ticket_system`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `rts_user`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `rts_train`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `rts_ticket`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `rts_approval`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
