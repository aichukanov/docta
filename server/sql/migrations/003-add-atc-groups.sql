-- ATC therapeutic groups table + FK in med_medicines
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/003-add-atc-groups.sql

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `med_atc_groups` (
  `id`         TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`       CHAR(1) NOT NULL COMMENT 'ATC level 1 code (A-V)',
  `name`       VARCHAR(100) NOT NULL,
  `name_en`    VARCHAR(100) DEFAULT NULL,
  `name_sr`    VARCHAR(100) DEFAULT NULL,
  `name_sr_cyrl` VARCHAR(100) DEFAULT NULL,
  `name_ru`    VARCHAR(100) DEFAULT NULL,
  `name_de`    VARCHAR(100) DEFAULT NULL,
  `name_tr`    VARCHAR(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_med_atc_groups_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `med_medicines`
  ADD COLUMN `atc_group_id` TINYINT UNSIGNED DEFAULT NULL AFTER `atc_code`,
  ADD KEY `idx_med_medicines_atc_group` (`atc_group_id`),
  ADD CONSTRAINT `fk_med_medicines_atc_group` FOREIGN KEY (`atc_group_id`)
    REFERENCES `med_atc_groups` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
