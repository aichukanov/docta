-- ═══════════════════════════════════════════════════════════════════════════
-- Dom zdravlja Rožaje — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-rozaje-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-dom-zdravlja-rozaje.sql.
-- Клиника — по google_place_id/slug, услуги — по slug, литеральных id нет.
-- Новых записей каталога НЕТ (правило подволны 2b для домов здоровья).
--
-- Цен на сайте нет: ни страницы прайса, ни PDF (в «Dokumenta» только планы интегритета, путевые
-- листы, аналитические карты, планы донаций и договоры о дополнительной работе). Тарифы ФЗОЦГ
-- ценами клиники не ставятся.
-- Без цены (8) — только то, что сайт называет конкретно: ординации избранных врачей для взрослых
-- и детей, гинеколого-акушерская, офтальмологическая, психиатрическая, ORL и интернистская
-- амбулатории, центр гемодиализа. Записи — те же, что у ДЗ Беране (подволна 2b).
-- Не услуги (организационные единицы): radiološka dijagnostika (что именно делают — не сказано),
-- higijensko-epidemiološka služba, medicina rada (справки не перечислены), laboratorijska
-- dijagnostika, Centar za plućne bolesti i TBC, Centar za mentalno zdravlje, patronaža, fizikalna
-- terapija, sanitetski prevoz, savjetovališta, bolnički odjeli, dopunski rad врачей ОБ Беране
-- (специальности названы, амбулатории — нет).
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишнее от прошлых прогонов
-- удаляется. ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJUxlYZUfmUhMRPsI6M2SUK6U' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-rozaje' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dom-zdravlja-rozaje.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

DROP TEMPORARY TABLE IF EXISTS tmp_dzrozaje_services;
CREATE TEMPORARY TABLE tmp_dzrozaje_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dzrozaje_services (slug, price, code) VALUES
('general-practitioner-examination', NULL, NULL), -- /radno-vrijeme/ «Izabrani doktor za odrasle — Pon – Pet I smjena: 07:00 – 14:00, II smjena: 14:00 – 21:00, Sub – Ned / Praznici I smjena: 08:00 – 14:00»
('pediatric-examination', NULL, NULL), -- /organizacione-jedinice/ «Pedijatrija — Timovi — Izabrani doktor za djecu» (тимы 1–4, spec. pedijatri), /radno-vrijeme/ «Izabrani doktor za djecu»
('gynecological-specialist-examination', NULL, NULL), -- /organizacione-jedinice/ «Ginekologija — Tim — Ginekološko akušerska ambulanta», /specijalisticke-ambulante/ «Ginekološko akušerska ambulanta»
('ophthalmological-examination', NULL, NULL), -- /specijalisticke-ambulante/ «Oftalmološka ambulanta — dr mr. spec. oftalmolog Saimir Markišić»
('first-psychiatrist-examination', NULL, NULL), -- /specijalisticke-ambulante/ «Psihijatrijska ambulanta — spec. psihijatar dr Sead Nurković»
('first-ent-examination', NULL, NULL), -- /specijalisticke-ambulante/ «ORL ambulanta — prim. dr spec. otorinolaringolog» (имени врача на странице нет)
('internist-examination', NULL, NULL), -- /specijalisticke-ambulante/ «Internistička ambulanta — spec. interne medicine Asad Kalač»
('hemodialysis-services', NULL, NULL); -- /specijalisticke-ambulante/ «Centar za hemodijalizu — spec. interne medicine Semir Murić», /radno-vrijeme/ «Hemodijaliza … Radi vikendom»

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_dzrozaje_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, NULL, NULL, t.code
FROM tmp_dzrozaje_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max), code = VALUES(code);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dzrozaje_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 8 услуг, все без цены, outdated 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL) AS with_price, SUM(price IS NULL) AS without_price,
	SUM(is_price_outdated) AS outdated
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_sr, cms.price
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_dzrozaje_services;
