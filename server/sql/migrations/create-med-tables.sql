-- Medicine register tables for docta.me
-- Source: CInMED (cinmed.me) — Montenegro Ministry of Health
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/create-med-tables.sql

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- Справочники (lookup tables)
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `countries` (
  `id`   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_countries_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `med_dispensing_modes` (
  `id`   TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_med_dispensing_modes_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `med_pharma_forms` (
  `id`   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_med_pharma_forms_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `med_auth_holders` (
  `id`   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_med_auth_holders_name` (`name`(400))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `med_manufacturers` (
  `id`           SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`         VARCHAR(500) NOT NULL,
  `full_address` VARCHAR(1000) DEFAULT NULL,
  `country_id`   SMALLINT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_med_manufacturers_name` (`name`(400)),
  KEY `idx_med_manufacturers_country` (`country_id`),
  CONSTRAINT `fk_med_manufacturers_country` FOREIGN KEY (`country_id`)
    REFERENCES `countries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Действующие вещества (INN)
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `med_substances` (
  `id`   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_med_substances_name` (`name`(400))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- Основная таблица лекарств
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `med_medicines` (
  `id`                     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cinmed_id`              INT UNSIGNED NOT NULL COMMENT 'CInMED internal ID',
  `name`                   VARCHAR(500) NOT NULL COMMENT 'Brand name',
  `pharmaceutical_form_id` SMALLINT UNSIGNED DEFAULT NULL,
  `strength`               VARCHAR(255) DEFAULT NULL,
  `packaging`              VARCHAR(500) DEFAULT NULL,
  `detail_packaging`       VARCHAR(1000) DEFAULT NULL,
  `manufacturer_id`        SMALLINT UNSIGNED DEFAULT NULL,
  `authorization_holder_id` SMALLINT UNSIGNED DEFAULT NULL,
  `authorization_number`   VARCHAR(100) DEFAULT NULL,
  `authorization_date`     DATE DEFAULT NULL,
  `dispensing_mode_id`     TINYINT UNSIGNED DEFAULT NULL,
  `atc_code`               VARCHAR(10) DEFAULT NULL COMMENT 'ATC classification code',
  `is_active`              TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=active license, 0=expired',
  `detail_url`             VARCHAR(500) DEFAULT NULL,
  `scraped_at`             DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at`             DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_med_medicines_cinmed` (`cinmed_id`),
  KEY `idx_med_medicines_atc` (`atc_code`),
  KEY `idx_med_medicines_name` (`name`(200)),
  KEY `idx_med_medicines_active` (`is_active`),
  KEY `idx_med_medicines_pharma_form` (`pharmaceutical_form_id`),
  KEY `idx_med_medicines_manufacturer` (`manufacturer_id`),
  KEY `idx_med_medicines_dispensing` (`dispensing_mode_id`),
  CONSTRAINT `fk_med_medicines_pharma_form` FOREIGN KEY (`pharmaceutical_form_id`)
    REFERENCES `med_pharma_forms` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_med_medicines_manufacturer` FOREIGN KEY (`manufacturer_id`)
    REFERENCES `med_manufacturers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_med_medicines_auth_holder` FOREIGN KEY (`authorization_holder_id`)
    REFERENCES `med_auth_holders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_med_medicines_dispensing` FOREIGN KEY (`dispensing_mode_id`)
    REFERENCES `med_dispensing_modes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- M:N связь лекарство ↔ действующее вещество
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `med_medicine_substances` (
  `medicine_id`  INT UNSIGNED NOT NULL,
  `substance_id` SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (`medicine_id`, `substance_id`),
  KEY `idx_med_ms_substance` (`substance_id`),
  CONSTRAINT `fk_med_ms_medicine` FOREIGN KEY (`medicine_id`)
    REFERENCES `med_medicines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_med_ms_substance` FOREIGN KEY (`substance_id`)
    REFERENCES `med_substances` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

