-- Reviews: moderation, verification, AI summaries (prd/reviews, iterations 3, 5, 6)
--
-- Moderation model: POST-moderation. Reviews are visible immediately after
-- submission ('pending'), admin can approve or reject them later. Rejected
-- reviews are hidden from public pages but stay visible to their author
-- together with the rejection reason. Existing and imported reviews are
-- treated as approved (column DEFAULT) — import scripts stay unchanged;
-- only /api/reviews/create explicitly inserts 'pending'.

-- 1. Moderation columns on reviews
ALTER TABLE reviews
	ADD COLUMN status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'approved' AFTER likes_count,
	ADD COLUMN is_verified BOOLEAN NOT NULL DEFAULT FALSE AFTER status,
	ADD COLUMN moderated_by INT NULL AFTER is_verified,
	ADD COLUMN moderated_at DATETIME NULL AFTER moderated_by,
	ADD COLUMN rejection_reason TEXT NULL AFTER moderated_at,
	ADD INDEX idx_reviews_status (status),
	ADD CONSTRAINT fk_reviews_moderated_by FOREIGN KEY (moderated_by) REFERENCES auth_users (id) ON DELETE SET NULL;

-- 2. Verification files (receipts / referrals confirming the visit).
-- Files are PERSONAL DATA: stored outside public/, served only to the review
-- author and admins via /api/reviews/verification-file. stored_name is the
-- on-disk file name inside VERIFICATIONS_DIR (default storage/verifications).
CREATE TABLE review_verification_files (
	id INT AUTO_INCREMENT PRIMARY KEY,
	review_id INT NOT NULL,
	stored_name VARCHAR(255) NOT NULL,
	file_name VARCHAR(255) NULL,
	file_type VARCHAR(100) NOT NULL,
	file_size INT UNSIGNED NOT NULL,
	status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
	rejection_reason TEXT NULL,
	uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	reviewed_at DATETIME NULL,
	reviewed_by INT NULL,
	UNIQUE KEY uq_verification_review (review_id),
	KEY idx_verification_status (status),
	CONSTRAINT fk_verification_review FOREIGN KEY (review_id) REFERENCES reviews (id) ON DELETE CASCADE,
	CONSTRAINT fk_verification_reviewer FOREIGN KEY (reviewed_by) REFERENCES auth_users (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 3. Moderation audit log (moderator_id NULL = action by review author)
CREATE TABLE review_moderation_logs (
	id INT AUTO_INCREMENT PRIMARY KEY,
	review_id INT NOT NULL,
	action ENUM(
		'approved',
		'rejected',
		'verification_uploaded',
		'verification_approved',
		'verification_rejected'
	) NOT NULL,
	moderator_id INT NULL,
	comment TEXT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	KEY idx_moderation_logs_review (review_id),
	CONSTRAINT fk_moderation_log_review FOREIGN KEY (review_id) REFERENCES reviews (id) ON DELETE CASCADE,
	CONSTRAINT fk_moderation_log_moderator FOREIGN KEY (moderator_id) REFERENCES auth_users (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 4. Cached AI summaries per entity per locale.
-- One Anthropic call generates all 6 locales at once; rows are upserted per
-- locale. positives/negatives are JSON arrays of short strings.
CREATE TABLE review_ai_summaries (
	id INT AUTO_INCREMENT PRIMARY KEY,
	entity_type ENUM('doctor', 'clinic') NOT NULL,
	entity_id INT NOT NULL,
	language VARCHAR(10) NOT NULL,
	sentiment ENUM('positive', 'neutral', 'negative') NOT NULL,
	positives JSON NOT NULL,
	negatives JSON NOT NULL,
	recommendations TEXT NULL,
	reviews_count INT NOT NULL,
	generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	regenerated_at DATETIME NULL,
	UNIQUE KEY uq_ai_summary_entity_lang (entity_type, entity_id, language)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Rollback:
-- DROP TABLE review_ai_summaries;
-- DROP TABLE review_moderation_logs;
-- DROP TABLE review_verification_files;
-- ALTER TABLE reviews
-- 	DROP FOREIGN KEY fk_reviews_moderated_by,
-- 	DROP INDEX idx_reviews_status,
-- 	DROP COLUMN rejection_reason,
-- 	DROP COLUMN moderated_at,
-- 	DROP COLUMN moderated_by,
-- 	DROP COLUMN is_verified,
-- 	DROP COLUMN status;
