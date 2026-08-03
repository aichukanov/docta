-- Alternative names for medical services.
-- Mirrors lab_test_synonyms, which already backs lab test search.
--
-- Two jobs:
--   1. Search — a service found by a wording that is not one of its name_* columns.
--   2. Merge history — when two services are merged, the losing name is kept
--      here, so the wording a clinic actually used still resolves.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/create-medical-service-synonyms.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

CREATE TABLE IF NOT EXISTS `medical_service_synonyms` (
	`id` int NOT NULL AUTO_INCREMENT,
	`medical_service_id` int NOT NULL COMMENT 'Medical Service ID',
	`another_name` varchar(255) NOT NULL COMMENT 'Alternative name',
	`language` varchar(10) NOT NULL COMMENT 'en | sr | sr_cyrl | ru | de | tr',
	`created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uq_mss_service_name_lang` (
		`medical_service_id`,
		`another_name`,
		`language`
	),
	KEY `idx_mss_name` (`another_name`),
	KEY `idx_mss_service_language_name` (
		`medical_service_id`,
		`language`,
		`another_name`
	),
	CONSTRAINT `fk_mss_service` FOREIGN KEY (`medical_service_id`) REFERENCES `medical_services` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Medical Service Synonyms';
