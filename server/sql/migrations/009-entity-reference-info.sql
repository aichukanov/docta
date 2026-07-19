-- Справочный контент услуг/анализов (что/как/когда/подготовка/о чём может
-- говорить отклонение) — пункт (4) плана SEO-аудита, PRD prd/service-reference-content/.
--
-- Данные сейчас черновиком лежат в
-- data/entity-reference/{lab-tests,medical-services}.json (связь по slug,
-- 110 карточек × 6 языков). Эта миграция создаёт только схему — импорт JSON →
-- SQL делается отдельным скриптом отдельным шагом.
--
-- Две отдельные 1:1-таблицы с настоящим FK (а не общая entity_type+entity_id,
-- как в review_ai_summaries/slug_redirects) — осознанный выбор: ссылочная
-- целостность важнее, чем экономия на дублировании структуры между таблицами.
--
-- Колонки по языку — та же конвенция суффиксов, что в name_en/name_sr/
-- name_sr_cyrl/name_ru/name_de/name_tr у lab_tests/medical_services.
-- "when" — зарезервированное слово в SQL, колонка называется indications.
-- Все текстовые колонки NULL: карточка может быть переведена не на все 6
-- языков сразу (перевод остальных локалей — отдельный проход).
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/009-entity-reference-info.sql

CREATE TABLE IF NOT EXISTS lab_test_reference_info (
	id INT PRIMARY KEY AUTO_INCREMENT,
	lab_test_id INT NOT NULL,

	what_en TEXT, what_sr TEXT, what_sr_cyrl TEXT, what_ru TEXT, what_de TEXT, what_tr TEXT,
	how_en TEXT, how_sr TEXT, how_sr_cyrl TEXT, how_ru TEXT, how_de TEXT, how_tr TEXT,
	indications_en TEXT, indications_sr TEXT, indications_sr_cyrl TEXT, indications_ru TEXT, indications_de TEXT, indications_tr TEXT,
	prep_en TEXT, prep_sr TEXT, prep_sr_cyrl TEXT, prep_ru TEXT, prep_de TEXT, prep_tr TEXT,
	abnormal_en TEXT, abnormal_sr TEXT, abnormal_sr_cyrl TEXT, abnormal_ru TEXT, abnormal_de TEXT, abnormal_tr TEXT,

	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	UNIQUE KEY unique_lab_test (lab_test_id),
	FOREIGN KEY (lab_test_id) REFERENCES lab_tests (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS medical_service_reference_info (
	id INT PRIMARY KEY AUTO_INCREMENT,
	medical_service_id INT NOT NULL,

	what_en TEXT, what_sr TEXT, what_sr_cyrl TEXT, what_ru TEXT, what_de TEXT, what_tr TEXT,
	how_en TEXT, how_sr TEXT, how_sr_cyrl TEXT, how_ru TEXT, how_de TEXT, how_tr TEXT,
	indications_en TEXT, indications_sr TEXT, indications_sr_cyrl TEXT, indications_ru TEXT, indications_de TEXT, indications_tr TEXT,
	prep_en TEXT, prep_sr TEXT, prep_sr_cyrl TEXT, prep_ru TEXT, prep_de TEXT, prep_tr TEXT,
	abnormal_en TEXT, abnormal_sr TEXT, abnormal_sr_cyrl TEXT, abnormal_ru TEXT, abnormal_de TEXT, abnormal_tr TEXT,

	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	UNIQUE KEY unique_medical_service (medical_service_id),
	FOREIGN KEY (medical_service_id) REFERENCES medical_services (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
