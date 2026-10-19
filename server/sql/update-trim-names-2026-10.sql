-- ═══════════════════════════════════════════════════════════════════════════
-- Пробелы и табуляция по краям имён врачей и названий клиник
--
-- Найдено 2026-10-08 при импорте подволны 2c: у врача vukovic-marko в name_sr
-- хвостовой TAB («Vuković Marko\t»), поэтому поиск по имени его не находил (агенту
-- пришлось искать по slug). Тот же TAB отдаёт API прода. В локальной БД ещё три
-- клиники с пробелом по краю названия: ginekoloska-ordinacija-dr-soc-podgorica,
-- barovic-aesthetic-dental-centar, dr-jovovic-oftalmoloska-ordinacija.
--
-- Обрезаются пробельные символы (пробел, TAB, перевод строки) только по краям,
-- во всех языковых колонках имени. Идемпотентно: повторный прогон ничего не меняет.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @edge = '^[[:space:]]+|[[:space:]]+$';

SELECT 'doctors before' AS what, COUNT(*) AS n FROM doctors
WHERE name_sr REGEXP @edge OR name_sr_cyrl REGEXP @edge OR name_en REGEXP @edge OR name_ru REGEXP @edge;
SELECT 'clinics before' AS what, COUNT(*) AS n FROM clinics
WHERE name_sr REGEXP @edge OR name_sr_cyrl REGEXP @edge OR name_ru REGEXP @edge;

UPDATE doctors SET
	name_sr = REGEXP_REPLACE(name_sr, @edge, ''),
	name_sr_cyrl = REGEXP_REPLACE(name_sr_cyrl, @edge, ''),
	name_en = REGEXP_REPLACE(name_en, @edge, ''),
	name_ru = REGEXP_REPLACE(name_ru, @edge, '')
WHERE name_sr REGEXP @edge OR name_sr_cyrl REGEXP @edge OR name_en REGEXP @edge OR name_ru REGEXP @edge;

UPDATE clinics SET
	name_sr = REGEXP_REPLACE(name_sr, @edge, ''),
	name_sr_cyrl = REGEXP_REPLACE(name_sr_cyrl, @edge, ''),
	name_ru = REGEXP_REPLACE(name_ru, @edge, '')
WHERE name_sr REGEXP @edge OR name_sr_cyrl REGEXP @edge OR name_ru REGEXP @edge;

-- Ожидается 0 и 0.
SELECT 'doctors after' AS what, COUNT(*) AS n FROM doctors
WHERE name_sr REGEXP @edge OR name_sr_cyrl REGEXP @edge OR name_en REGEXP @edge OR name_ru REGEXP @edge;
SELECT 'clinics after' AS what, COUNT(*) AS n FROM clinics
WHERE name_sr REGEXP @edge OR name_sr_cyrl REGEXP @edge OR name_ru REGEXP @edge;
