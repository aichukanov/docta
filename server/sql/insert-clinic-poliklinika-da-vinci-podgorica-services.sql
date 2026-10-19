-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Da Vinci (Podgorica) — перечень услуг (без цен) + привязка врач↔услуга
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-da-vinci-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-poliklinika-da-vinci-podgorica.sql.
-- Клиника — по google_place_id/slug, услуги и врачи — по slug, литеральных id нет.
--
-- Источник: https://davincipoliklinika.me/ (собрано 2026-10-08) — главная и 8 страниц направлений
-- из меню (urologija, hirurgija, ginekologija, endokrinologija, kardiologija, hematologija,
-- onkologija, nefrologija; правки wp-json 2024-08-27…2024-09-11), /neven-vavic/.
--
-- ЦЕН НЕТ: /cjenovnik/ — заглушка темы («Ultrazvuk 35eur, Specijalistički pregled 45eur,
-- Operacija 1 2589eur…», Lorem ipsum ×3). Все услуги — NULL по дизайну.
--
-- Что взято: приём специалиста по каждому направлению меню (страница направления кончается
-- «zakažite pregled») и процедуры, названные от первого лица («U Poliklinici Da Vinci,
-- obavljamo / koristimo …»). Новых записей каталога нет — всё сопоставлено с существующими.
--
-- ЧЕГО ЗДЕСЬ НЕТ (подробно — excluded в data/clinic-imports/poliklinika-da-vinci-podgorica.json):
--   * Списки «Dijagnostika … obuhvata / Liječenje … uključuje» на страницах onkologija,
--     hematologija, ginekologija, urologija — шаблонный SEO-текст: в одном ряду с биопсиями стоят
--     радиотерапия, трансплантация костного мозга, КТ и МРТ, которых в поликлинике нет.
--   * /radiologija/ и /interna-medicina/ — страницы-сироты: в меню и на главной ссылок нет,
--     у интерны вместо команды Lorem ipsum, у радиологии интро про «hematolozi».
--   * Vaskularni hirurg (Sekulić) — отдельного направления нет, приём вазохирурга не заводим.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишнее от прошлых прогонов
-- удаляется. ⚠️ Услуги и привязки врачей, добавленные клинике вручную (админка, кабинет),
-- следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJkc08ut3rTRMRWn6Gc02KfjM' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-da-vinci-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-da-vinci-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- Синонимы: формулировки клиники, отличные от названий каталога.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Laparoskopska hernioplastika', 'sr' FROM medical_services WHERE slug = 'laparoscopic-hernia-operation'
UNION ALL SELECT id, 'Лапароскопска херниопластика', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-hernia-operation'
UNION ALL SELECT id, 'Лапароскопическая герниопластика', 'ru' FROM medical_services WHERE slug = 'laparoscopic-hernia-operation'
UNION ALL SELECT id, 'Laparoskopska resekcija crijeva', 'sr' FROM medical_services WHERE slug = 'laparoscopic-colectomy'
UNION ALL SELECT id, 'Лапароскопска ресекција цријева', 'sr-cyrl' FROM medical_services WHERE slug = 'laparoscopic-colectomy'
UNION ALL SELECT id, 'Лапароскопическая резекция кишечника', 'ru' FROM medical_services WHERE slug = 'laparoscopic-colectomy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (все без цены — NULL по дизайну)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_davinci_services;
CREATE TEMPORARY TABLE tmp_davinci_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_davinci_services (slug, price, price_min, price_max) VALUES
-- ── ПРИЁМЫ — направления из меню и блока «Usluge poliklinike DaVinci» (главная); каждая страница кончается «zakažite pregled» ───
('urologist-examination', NULL, NULL, NULL), -- Urologija — «Imate urološki problem? Pozovite odmah i zakažite pregled!»
('first-nephrologist-examination', NULL, NULL, NULL), -- Nefrologija — «Treba vam nefrolog? … zakažite pregled!»; /neven-vavic/ «Potreban Vam je pregled kod dr Nevena?»
('hematologist-examination', NULL, NULL, NULL), -- Hematologija — «Imate problem za hematologa? … zakažite pregled!»
('surgical-examination', NULL, NULL, NULL), -- Hirurgija — «Potrebna Vam je operacija? Pozovite odmah i zakažite pregled!»
('gynecological-specialist-examination', NULL, NULL, NULL), -- Ginekologija — «Dijagnostika … obuhvata: Ginekološke preglede»; «Imate ginekološki problem? … zakažite pregled!»
('oncologist-examination', NULL, NULL, NULL), -- Onkologija — «Imate onkološki problem? … zakažite pregled!» (onkolog — internista-onkolog, «Pregled interniste onkologa»)
('cardiologist-examination', NULL, NULL, NULL), -- Kardiologija — «… zakažite pregled!»
('endocrinologist-examination', NULL, NULL, NULL), -- Endokrinologija — «Imate problem sa žlijezdama? … zakažite pregled!»
-- ── DIJAGNOSTIKA — /kardiologija/ «U Poliklinici Da Vinci, koristimo sledeće metode» ───
('echocardiography-heart-ultrasound', NULL, NULL, NULL), -- Ultrazvuk srca (Ehokardiogram); «Dopler ultrazvuk» там же — допплер в составе ЭхоКГ
-- ── LAPAROSKOPSKA HIRURGIJA — /hirurgija/ «U Poliklinici Da Vinci, obavljamo različite laparoskopske postupke» ───
('laparoscopic-cholecystectomy', NULL, NULL, NULL), -- Laparoskopska kolecistektomija: Uklanjanje žučne kese
('laparoscopic-appendectomy', NULL, NULL, NULL), -- Laparoskopska apendektomija: Uklanjanje slijepog crijeva
('laparoscopic-hernia-operation', NULL, NULL, NULL), -- Laparoskopska hernioplastika: Popravka trbušnih kila
('laparoscopic-colectomy', NULL, NULL, NULL), -- Laparoskopska resekcija crijeva (divertikulitis, rak crijeva)
('total-laparoscopic-abdominal-hysterectomy', NULL, NULL, NULL), -- Laparoskopska operacija materice: Uklanjanje materice (histerektomija)
('laparoscopic-myomectomy', NULL, NULL, NULL); -- Laparoskopska operacija materice: … ili mioma materice

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_davinci_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_davinci_services t
JOIN medical_services ms ON ms.slug = t.slug
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_davinci_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ПРИВЯЗКИ ВРАЧ ↔ УСЛУГА (только где сайт называет врача у услуги)
-- Полная пересборка привязок этой клиники.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- /neven-vavic/: «Potreban Vam je pregled kod dr Nevena? Pozovite odmah i zakažite pregled!»
INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
JOIN medical_services ms ON ms.slug = 'first-nephrologist-examination'
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id
WHERE d.slug IN ('neven-vavic');

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 15 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается привязок: 1.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id ORDER BY d.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_davinci_services;
