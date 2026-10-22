-- 059: Репутация клиник (prd/clinic-reputation/)
-- 1) Закрепление отзывов: reviews.is_pinned / pinned_at — закреплённые всегда
--    первые в выдаче (ORDER BY-префикс в server/common/reviews.ts).
-- 2) Новые действия в журнале модерации: pin/unpin и редакционная верификация.
-- 3) clinic_complaints — стандартизированные жалобы на клинику; словарь типов
--    живёт на фронте (enums/clinic-complaint-type.ts), в БД только коды.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE reviews
	ADD COLUMN is_pinned TINYINT(1) NOT NULL DEFAULT 0 AFTER is_verified,
	ADD COLUMN pinned_at DATETIME NULL AFTER is_pinned;

-- Порядок существующих значений ENUM не меняется (хранение по индексу),
-- новые только дописываются в конец.
ALTER TABLE review_moderation_logs
	MODIFY action ENUM(
		'approved',
		'rejected',
		'verification_uploaded',
		'verification_approved',
		'verification_rejected',
		'pinned',
		'unpinned',
		'editorial_verified',
		'editorial_unverified'
	) NOT NULL;

CREATE TABLE IF NOT EXISTS clinic_complaints (
	id INT AUTO_INCREMENT PRIMARY KEY,
	clinic_id INT NOT NULL,
	-- Код из enums/clinic-complaint-type.ts; свободных текстов наружу нет
	complaint_type TINYINT UNSIGNED NOT NULL,
	-- confirmed — редакция видела документы; только confirmed даёт бейдж
	status ENUM('confirmed', 'unconfirmed') NOT NULL DEFAULT 'unconfirmed',
	is_active TINYINT(1) NOT NULL DEFAULT 1,
	-- Закреплённый отзыв-основание (якорь из раздела «Репутация»)
	review_id INT NULL,
	-- Статья-разбор (/articles/<slug>)
	article_slug VARCHAR(128) NULL,
	incident_date DATE NULL,
	-- ВНУТРЕННЕЕ: источник/документы. В публичные ответы API не отдаётся
	source_note TEXT NULL,
	-- Официальный ответ клиники — публичный
	clinic_response TEXT NULL,
	created_by INT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	-- Одна строка на пару (клиника, тип): повторные обращения того же типа
	-- повышают статус, а не плодят строки
	UNIQUE KEY uq_clinic_complaints_clinic_type (clinic_id, complaint_type),
	KEY idx_clinic_complaints_active (is_active, status, clinic_id),
	CONSTRAINT fk_clinic_complaints_clinic FOREIGN KEY (clinic_id)
		REFERENCES clinics (id) ON DELETE CASCADE,
	CONSTRAINT fk_clinic_complaints_review FOREIGN KEY (review_id)
		REFERENCES reviews (id) ON DELETE SET NULL
) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
