-- Review queue for suspected duplicate lab tests.
--
-- Filled by scripts/labtests/find-duplicate-labtests.mjs, consumed by the
-- "Дубликаты" tab in the admin panel. Same shape as
-- medical_service_duplicate_candidates — the detector never merges anything on
-- its own, every row is a proposal awaiting a human decision.
--
-- `status` is the whole point of persisting this: once a pair is dismissed it
-- must never resurface, otherwise every rerun re-proposes the same pairs that
-- were already judged to be distinct tests.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/create-lab-test-dedup.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

CREATE TABLE IF NOT EXISTS `lab_test_duplicate_candidates` (
	`id` int NOT NULL AUTO_INCREMENT,
	`lab_test_id_a` int NOT NULL COMMENT 'Always the smaller of the two ids',
	`lab_test_id_b` int NOT NULL COMMENT 'Always the larger of the two ids',
	`tier` enum('A', 'B', 'C') NOT NULL COMMENT 'A: >=2 languages agree, or synonym + 1 language; B: 1 language, or synonym alone; C: fuzzy English only',
	`score` decimal(6, 2) NOT NULL DEFAULT '0.00' COMMENT 'Ranking score, higher = more confident',
	`signals` varchar(500) NOT NULL DEFAULT '' COMMENT 'Comma-separated evidence codes, e.g. "lang:name_sr,synonym-match,same-clinic:2"',
	`status` enum('pending', 'merged', 'dismissed') NOT NULL DEFAULT 'pending',
	`detected_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`decided_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `uq_ltdc_pair` (`lab_test_id_a`, `lab_test_id_b`),
	KEY `idx_ltdc_status_score` (`status`, `score` DESC),
	CONSTRAINT `fk_ltdc_a` FOREIGN KEY (`lab_test_id_a`) REFERENCES `lab_tests` (`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_ltdc_b` FOREIGN KEY (`lab_test_id_b`) REFERENCES `lab_tests` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Suspected duplicate lab test pairs awaiting review';
