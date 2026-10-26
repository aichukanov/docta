-- 060: Репутация врачей (prd/clinic-reputation/)
-- Зеркало clinic_complaints из миграции 059 для врачей: правила раздела,
-- словарь типов (enums/complaint-type.ts) и статусы общие, отличаются только
-- FK и колонка публичного ответа (doctor_response вместо clinic_response).
-- Отдельная таблица, а не entity_type/entity_id в одной: сохраняются
-- настоящие внешние ключи с ON DELETE CASCADE на обе сущности.
-- Требует применённой миграции 059 (таблица reviews.is_pinned для якоря).

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS doctor_complaints (
	id INT AUTO_INCREMENT PRIMARY KEY,
	doctor_id INT NOT NULL,
	-- Код из enums/complaint-type.ts; свободных текстов наружу нет
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
	-- Официальный ответ врача — публичный
	doctor_response TEXT NULL,
	created_by INT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	-- Одна строка на пару (врач, тип): повторные обращения того же типа
	-- повышают статус, а не плодят строки
	UNIQUE KEY uq_doctor_complaints_doctor_type (doctor_id, complaint_type),
	KEY idx_doctor_complaints_active (is_active, status, doctor_id),
	CONSTRAINT fk_doctor_complaints_doctor FOREIGN KEY (doctor_id)
		REFERENCES doctors (id) ON DELETE CASCADE,
	CONSTRAINT fk_doctor_complaints_review FOREIGN KEY (review_id)
		REFERENCES reviews (id) ON DELETE SET NULL
) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
