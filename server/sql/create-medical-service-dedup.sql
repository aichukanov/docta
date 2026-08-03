-- Review queue for suspected duplicate medical services.
--
-- Filled by scripts/services/find-duplicate-services.mjs, consumed by the
-- "Дубликаты" tab in the admin panel. The detector never merges anything on
-- its own — every row is a proposal awaiting a human decision.
--
-- `status` is the whole point of persisting this: once a pair is dismissed it
-- must never resurface, otherwise every rerun re-proposes the same hundreds of
-- near-duplicates that were already judged to be distinct services.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/create-medical-service-dedup.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

CREATE TABLE IF NOT EXISTS `medical_service_duplicate_candidates` (
	`id` int NOT NULL AUTO_INCREMENT,
	`service_id_a` int NOT NULL COMMENT 'Always the smaller of the two ids',
	`service_id_b` int NOT NULL COMMENT 'Always the larger of the two ids',
	`tier` enum('A', 'B', 'C') NOT NULL COMMENT 'A: >=2 languages agree; B: 1 language agrees; C: fuzzy English only',
	`score` decimal(6, 2) NOT NULL DEFAULT '0.00' COMMENT 'Ranking score, higher = more confident',
	`signals` varchar(500) NOT NULL DEFAULT '' COMMENT 'Comma-separated evidence codes, e.g. "lang:name_sr,lang:name_ru,same-clinic:3"',
	`status` enum('pending', 'merged', 'dismissed') NOT NULL DEFAULT 'pending',
	`detected_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`decided_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uq_msdc_pair` (`service_id_a`, `service_id_b`),
	KEY `idx_msdc_status_score` (`status`, `score` DESC),
	CONSTRAINT `fk_msdc_a` FOREIGN KEY (`service_id_a`) REFERENCES `medical_services` (`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_msdc_b` FOREIGN KEY (`service_id_b`) REFERENCES `medical_services` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Suspected duplicate service pairs awaiting review';
