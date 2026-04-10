-- Add translation columns to med_substances and med_pharma_forms
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/alter-med-add-translations.sql

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- med_substances: add translation columns
-- Original `name` becomes the Montenegrin/Serbian source name from CInMED
-- ---------------------------------------------------------------------------

ALTER TABLE `med_substances`
  ADD COLUMN `name_en`      VARCHAR(500) DEFAULT NULL AFTER `name`,
  ADD COLUMN `name_sr`      VARCHAR(500) DEFAULT NULL AFTER `name_en`,
  ADD COLUMN `name_sr_cyrl` VARCHAR(500) DEFAULT NULL AFTER `name_sr`,
  ADD COLUMN `name_ru`      VARCHAR(500) DEFAULT NULL AFTER `name_sr_cyrl`,
  ADD COLUMN `name_de`      VARCHAR(500) DEFAULT NULL AFTER `name_ru`,
  ADD COLUMN `name_tr`      VARCHAR(500) DEFAULT NULL AFTER `name_de`;

-- ---------------------------------------------------------------------------
-- med_pharma_forms: add translation columns
-- ---------------------------------------------------------------------------

ALTER TABLE `med_pharma_forms`
  ADD COLUMN `name_en`      VARCHAR(255) DEFAULT NULL AFTER `name`,
  ADD COLUMN `name_sr`      VARCHAR(255) DEFAULT NULL AFTER `name_en`,
  ADD COLUMN `name_sr_cyrl` VARCHAR(255) DEFAULT NULL AFTER `name_sr`,
  ADD COLUMN `name_ru`      VARCHAR(255) DEFAULT NULL AFTER `name_sr_cyrl`,
  ADD COLUMN `name_de`      VARCHAR(255) DEFAULT NULL AFTER `name_ru`,
  ADD COLUMN `name_tr`      VARCHAR(255) DEFAULT NULL AFTER `name_de`;

-- ---------------------------------------------------------------------------
-- med_countries: add translation columns
-- ---------------------------------------------------------------------------

ALTER TABLE `countries`
  ADD COLUMN `name_en`      VARCHAR(100) DEFAULT NULL AFTER `name`,
  ADD COLUMN `name_sr`      VARCHAR(100) DEFAULT NULL AFTER `name_en`,
  ADD COLUMN `name_sr_cyrl` VARCHAR(100) DEFAULT NULL AFTER `name_sr`,
  ADD COLUMN `name_ru`      VARCHAR(100) DEFAULT NULL AFTER `name_sr_cyrl`,
  ADD COLUMN `name_de`      VARCHAR(100) DEFAULT NULL AFTER `name_ru`,
  ADD COLUMN `name_tr`      VARCHAR(100) DEFAULT NULL AFTER `name_de`;

-- ---------------------------------------------------------------------------
-- med_dispensing_modes: add translation columns
-- ---------------------------------------------------------------------------

ALTER TABLE `med_dispensing_modes`
  ADD COLUMN `name_en`      VARCHAR(255) DEFAULT NULL AFTER `name`,
  ADD COLUMN `name_sr`      VARCHAR(255) DEFAULT NULL AFTER `name_en`,
  ADD COLUMN `name_sr_cyrl` VARCHAR(255) DEFAULT NULL AFTER `name_sr`,
  ADD COLUMN `name_ru`      VARCHAR(255) DEFAULT NULL AFTER `name_sr_cyrl`,
  ADD COLUMN `name_de`      VARCHAR(255) DEFAULT NULL AFTER `name_ru`,
  ADD COLUMN `name_tr`      VARCHAR(255) DEFAULT NULL AFTER `name_de`;

