-- Fix medicine schema: remove unused tables, rename countries, add translations
-- Run AFTER create-med-tables.sql and alter-med-add-translations.sql
--
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/002-fix-med-schema.sql

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ---------------------------------------------------------------------------
-- 1. Drop unused tables
-- ---------------------------------------------------------------------------

DROP TABLE IF EXISTS `med_documents`;
DROP TABLE IF EXISTS `med_advertising_manners`;

-- ---------------------------------------------------------------------------
-- 2. Remove advertising_manner_id from med_medicines
-- ---------------------------------------------------------------------------

ALTER TABLE `med_medicines`
  DROP FOREIGN KEY `fk_med_medicines_advertising`;

ALTER TABLE `med_medicines`
  DROP COLUMN `advertising_manner_id`;

-- ---------------------------------------------------------------------------
-- 3. Rename med_countries → countries
-- ---------------------------------------------------------------------------

ALTER TABLE `med_manufacturers`
  DROP FOREIGN KEY `fk_med_manufacturers_country`;

RENAME TABLE `med_countries` TO `countries`;

ALTER TABLE `countries`
  ADD COLUMN `name_en`      VARCHAR(100) DEFAULT NULL AFTER `name`,
  ADD COLUMN `name_sr`      VARCHAR(100) DEFAULT NULL AFTER `name_en`,
  ADD COLUMN `name_sr_cyrl` VARCHAR(100) DEFAULT NULL AFTER `name_sr`,
  ADD COLUMN `name_ru`      VARCHAR(100) DEFAULT NULL AFTER `name_sr_cyrl`,
  ADD COLUMN `name_de`      VARCHAR(100) DEFAULT NULL AFTER `name_ru`,
  ADD COLUMN `name_tr`      VARCHAR(100) DEFAULT NULL AFTER `name_de`;

ALTER TABLE `med_manufacturers`
  ADD CONSTRAINT `fk_med_manufacturers_country` FOREIGN KEY (`country_id`)
    REFERENCES `countries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ---------------------------------------------------------------------------
-- 4. Add translation columns to med_dispensing_modes
-- ---------------------------------------------------------------------------

ALTER TABLE `med_dispensing_modes`
  ADD COLUMN `name_en`      VARCHAR(255) DEFAULT NULL AFTER `name`,
  ADD COLUMN `name_sr`      VARCHAR(255) DEFAULT NULL AFTER `name_en`,
  ADD COLUMN `name_sr_cyrl` VARCHAR(255) DEFAULT NULL AFTER `name_sr`,
  ADD COLUMN `name_ru`      VARCHAR(255) DEFAULT NULL AFTER `name_sr_cyrl`,
  ADD COLUMN `name_de`      VARCHAR(255) DEFAULT NULL AFTER `name_ru`,
  ADD COLUMN `name_tr`      VARCHAR(255) DEFAULT NULL AFTER `name_de`;

SET FOREIGN_KEY_CHECKS = 1;
