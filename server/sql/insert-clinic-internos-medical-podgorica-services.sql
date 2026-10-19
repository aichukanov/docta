-- ═══════════════════════════════════════════════════════════════════════════
-- Internos Medical & Laboratorija (Podgorica) — перечень услуг (без цен) + привязки врач ↔ услуга
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-internos-medical-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-internos-medical-podgorica.sql.
-- Клиника — по google_place_id/slug, услуги и врачи — по slug, литеральных id нет.
--
-- Источник: https://internosmedical.me/ (главная — тексты направлений и карточки услуг;
-- modified 2026-03-12), собрано 2026-10-08. Страницы /service/* пустые (только заголовок).
-- ЦЕН НА САЙТЕ НЕТ (0 вхождений «€»/«EUR»): все услуги NULL по дизайну.
-- Новых записей каталога НЕТ — всё сопоставлено с существующими.
-- Анализы: перечня на сайте нет («LABORATORIJA» — только заголовок) — clinic_lab_tests
-- не заполняется.
--
-- Правила сопоставления (подробно — data/clinic-imports/internos-medical-podgorica.json):
--   * направление с текстом «konsultativne/specijalističke preglede … obavlja dr …» →
--     осмотр специалиста, врач привязан (clinic_medical_service_doctors, цены NULL);
--   * карточки «GINEKOLOGIJA», «INTERNISTIČKI PREGLEDI» → осмотры без привязки к врачу
--     (сайт не называет, кто принимает);
--   * «Psihološko savjetovalište» (individualni rad, program za porodicu, bračno
--     savjetovanje) → Psychological Counseling: у записи каталога уже есть синонимы
--     «Partnersko savjetovanje» / «Porodično psihološko savjetovanje»; психолог — не врач,
--     к услуге не привязан;
--   * «Radiologija» (виды обследований не названы), «Laboratorija», «Kućna njega i
--     patronaža» (пустая страница), «Kozmetika i estetika» (демо-текст шаблона) —
--     в excluded записи импорта.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишнее от прошлых прогонов
-- удаляется. ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJeTqm7EjrTRMRwOE9-ehR6jo' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'internos-medical-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-internos-medical-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: УСЛУГИ КЛИНИКИ (9, все без цены)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_internos_services;
CREATE TEMPORARY TABLE tmp_internos_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_internos_services (slug) VALUES
('cardiologist-examination'),              -- «Kardiologija … iz oblasti kardiologije ordinira dr Dijana Drekalović – spec.internista-kardiolog»
('surgical-examination'),                  -- «Hirurgija … Konsultativne preglede iz hirurgije … obavljaju … Dr Perica Maraš»
('first-psychiatrist-examination'),        -- «Psihijatrija … Psihijatrijsko savjetovalište … obavlja … dr Lidija Injac Stevović» (общей записи «осмотр психиатра» в каталоге нет)
('endocrinologist-examination'),           -- «Endokrinologija … Konsultativne preglede iz endokrinologije … Dr Đorđe Krnjević»
('urologist-examination'),                 -- «Urologija … Konsultativne-specijalističke preglede iz urologije obavlja … dr Vladimir Brajović»
('psychological-counseling'),              -- «Psihološko savjetovalište za adolescente i odrasle … individualni rad sa klijentom, program za porodicu, bračno savjetovanje»
('4d-pregnancy-ultrasound'),               -- «4D ultrazvuk+slika» (name_sr записи — «4D ultrazvuk»)
('gynecological-specialist-examination'),  -- карточка «GINEKOLOGIJA»
('internist-examination');                 -- карточка «INTERNISTIČKI PREGLEDI»; «djelatnost proširili i na internističku ambulantu»

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service FROM tmp_internos_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, NULL, NULL, NULL, NULL
FROM tmp_internos_services t
JOIN medical_services ms ON ms.slug = t.slug
ON DUPLICATE KEY UPDATE price = NULL, price_min = NULL, price_max = NULL;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_internos_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL)
-- Только там, где сайт сам называет врача направления.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_internos_doctor_services;
CREATE TEMPORARY TABLE tmp_internos_doctor_services (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Slug — как в БД (maras-perica, djordjije-krnjevic, brajovic-vladimir).
INSERT INTO tmp_internos_doctor_services (doctor_slug, service_slug) VALUES
('dijana-drekalovic', 'cardiologist-examination'),
('maras-perica', 'surgical-examination'),
('lidija-injac-stevovic', 'first-psychiatrist-examination'),
('djordjije-krnjevic', 'endocrinologist-examination'),
('brajovic-vladimir', 'urologist-examination');

-- Страховка: врачи из списка, которых нет в БД или нет в составе клиники. Ожидается ПУСТО.
SELECT DISTINCT t.doctor_slug AS unmatched_doctor FROM tmp_internos_doctor_services t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_internos_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 9 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 5 привязок у 5 врачей.
SELECT d.slug, COUNT(*) AS linked_services
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id
GROUP BY d.slug
ORDER BY d.slug;

-- Ожидается 0: анализов у клиники нет.
SELECT COUNT(*) AS lab_tests_total FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_internos_services;
DROP TEMPORARY TABLE IF EXISTS tmp_internos_doctor_services;
