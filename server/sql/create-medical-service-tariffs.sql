-- Migration: medical_service_tariffs
-- Reference tariff table for state insurance pricelists (FZOCG and similar).
-- Distinct from `clinic_medical_services` because FZOCG is NOT a clinic — it's
-- a national tariff that multiple state clinics bill against.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < e:/pet/docta.me/nuxt/server/sql/create-medical-service-tariffs.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS `medical_service_tariffs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tariff_source` ENUM(
    'fzocg-pzz',
    'fzocg-sekundarna',
    'fzocg-drg',
    'fzocg-transfuziologija',
    'fzocg-apotekarska',
    'fzocg-medicinsko-pomagala',
    'fzocg-van-mreze'
  ) NOT NULL COMMENT 'Pricelist this row belongs to.',
  `code` VARCHAR(50) NOT NULL COMMENT 'Source-document service code (e.g. J09001, A05Z, 50, AA1101).',
  `medical_service_id` INT NULL DEFAULT NULL COMMENT 'Optional link to medical_services catalog. Auto-populated via clinic_medical_services.code matching.',

  `scheme` ENUM('single','dual','operacija','coefficient') NOT NULL COMMENT 'Which price columns are populated.',
  `price_eur` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'scheme=single: the only price. scheme=coefficient: final coefficient * base.',
  `price_odjeljenje_eur` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'scheme=dual: department/inpatient price.',
  `price_ambulanta_eur` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'scheme=dual: outpatient price.',
  `price_operacija_eur` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'scheme=operacija: operation portion.',
  `price_anestezija_eur` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'scheme=operacija: anesthesia portion.',
  `price_ukupno_eur` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'scheme=operacija: operacija + anestezija total.',
  `coefficient` DECIMAL(8,4) NULL DEFAULT NULL COMMENT 'scheme=coefficient: DRG koeficijent (× base_coefficient_eur = price_eur).',
  `base_coefficient_eur` DECIMAL(10,2) NULL DEFAULT NULL COMMENT 'scheme=coefficient: DRG base rate (e.g. 760.18).',

  `name_sr_latin` VARCHAR(500) NULL DEFAULT NULL COMMENT 'Service name as printed in the source PDF (Serbian Latin, with diacritics where merged from LLM).',
  `section` VARCHAR(500) NULL DEFAULT NULL,
  `subsection` VARCHAR(255) NULL DEFAULT NULL,
  `amended_from` DATE NULL DEFAULT NULL COMMENT 'Effective date of the latest amendment that touched this row.',
  `effective_from` DATE NULL DEFAULT NULL COMMENT 'Effective date of the base document.',
  `source_signed_number` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Document broj, e.g. 01-4396.',
  `source_pdf` VARCHAR(500) NULL DEFAULT NULL,
  `notes` TEXT NULL DEFAULT NULL,

  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_source_code` (`tariff_source`, `code`),
  KEY `idx_medical_service_id` (`medical_service_id`),
  KEY `idx_code` (`code`),
  CONSTRAINT `fk_medical_service_tariffs_service`
    FOREIGN KEY (`medical_service_id`) REFERENCES `medical_services` (`id`)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
