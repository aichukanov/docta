-- Clinic cabinet (PRD clinic-profile, iterations 2-6):
-- user-created clinics with draft/published lifecycle.
--
-- Adds to `clinics`:
--   created_by — owner user (NULL for clinics imported/created via admin panel)
--   status     — lifecycle: draft / pending_verification / published / rejected
--                existing rows default to 'published' (they are already public)
--
-- NOTE: logo_url already exists in `clinics` (added earlier), not part of this migration.
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/006-clinic-cabinet.sql

ALTER TABLE clinics
	ADD COLUMN created_by INT NULL DEFAULT NULL AFTER google_place_id,
	ADD COLUMN status ENUM('draft', 'pending_verification', 'published', 'rejected')
		NOT NULL DEFAULT 'published' AFTER created_by;

ALTER TABLE clinics
	ADD INDEX idx_clinics_status (status),
	ADD INDEX idx_clinics_created_by (created_by),
	ADD CONSTRAINT fk_clinics_created_by
		FOREIGN KEY (created_by) REFERENCES auth_users (id) ON DELETE SET NULL;
