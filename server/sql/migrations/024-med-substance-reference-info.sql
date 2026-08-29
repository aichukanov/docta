-- Миграция 024: справка о действующем веществе (med_substance_reference_info)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/024-med-substance-reference-info.sql
--
-- Зачем: карточка лекарства и фасет вещества не отвечают на вопрос «что это
-- вообще такое и от чего оно». Класс из ATC (enums/atc-class.ts) даёт ярлык
-- («антигистаминное»), но не объясняет, когда вещество применяют и что важно
-- знать. См. prd/medicines-consumer-content/PLAN.md, трек C.
--
-- Схема — по образцу lab_test_reference_info / medical_service_reference_info
-- (миграция 009): отдельная 1:1-таблица с настоящим FK, а не общая
-- entity_type+entity_id. Поля другие, потому что вещество — не процедура:
--   what      — что это за вещество и к какому классу относится
--   used_for  — когда применяют (общие ситуации, не «у вас X»)
--   caution   — что важно знать: рецептурность, сонливость, алкоголь,
--               дети/беременность. БЕЗ дозировок и схем приёма (YMYL).
-- Дисклеймер не дублируется в данных — это общая i18n-строка на странице.
--
-- Все текстовые колонки NULL-able: перевод может появляться по локали
-- постепенно, как у справок услуг и анализов.
--
-- sr_cyrl не пишется руками — генерится транслитерацией из sr при сборке
-- insert-скрипта, иначе две сербские локали разъезжаются при правках.
--
-- collation указываем явно: utf8mb4 без COLLATE берёт дефолт сервера
-- (utf8mb4_0900_ai_ci) и ломает JOIN с существующими таблицами.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS med_substance_reference_info (
	id INT NOT NULL AUTO_INCREMENT,
	-- Тип как у med_substances.id (smallint unsigned) — иначе FK не создастся
	substance_id SMALLINT UNSIGNED NOT NULL,

	what_en TEXT NULL,
	what_sr TEXT NULL,
	what_sr_cyrl TEXT NULL,
	what_ru TEXT NULL,
	what_de TEXT NULL,
	what_tr TEXT NULL,

	used_for_en TEXT NULL,
	used_for_sr TEXT NULL,
	used_for_sr_cyrl TEXT NULL,
	used_for_ru TEXT NULL,
	used_for_de TEXT NULL,
	used_for_tr TEXT NULL,

	caution_en TEXT NULL,
	caution_sr TEXT NULL,
	caution_sr_cyrl TEXT NULL,
	caution_ru TEXT NULL,
	caution_de TEXT NULL,
	caution_tr TEXT NULL,

	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	PRIMARY KEY (id),
	UNIQUE KEY uq_med_substance_reference_substance (substance_id),
	CONSTRAINT fk_med_substance_reference_substance
		FOREIGN KEY (substance_id) REFERENCES med_substances (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT COUNT(*) AS substance_reference_rows FROM med_substance_reference_info;
