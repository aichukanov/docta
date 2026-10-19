-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija VIVAdent (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-stomatoloska-ordinacija-vivadent-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-vivadent-podgorica-services.sql
--
-- Источник: https://vivadent.me/ (me), 7 страниц-направлений + /o-nama/, wp-json 2026-10-09 (страницы 2024-08). Прайса нет; все позиции price = NULL.
-- Направления раскрыты до процедур, прямо названных в тексте страниц. «Dental plan za firme» (рассрочка) и «Dentalni turizam» — не услуги,
-- упомянуты в описании. Пояснения без процедуры — в excluded записи импорта.
--
-- Итого: 24 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 10.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJW6ohrkDrTRMRp0sMhQl0oFc' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'stomatoloska-ordinacija-vivadent-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-stomatoloska-ordinacija-vivadent-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (24)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_w_viv_services;
CREATE TEMPORARY TABLE tmp_w_viv_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_w_viv_services (slug, price, price_min, price_max) VALUES
	('panoramic-x-ray', NULL, NULL, NULL), -- /savremena-dijagnostika/: «Ortopan – tomografija», «snimanje pomoću digitalniog senzorskog ortopan aparata»
	('cephalometric-x-ray', NULL, NULL, NULL), -- /savremena-dijagnostika/: «Telerendgen»
	('intraoral-x-ray', NULL, NULL, NULL), -- /savremena-dijagnostika/: «Retroalveolarni snimci»; /o-nama/: «usluge digitalnog intraoralnog radiografskog snimanja zuba»
	('x-ray-paranasal-sinuses', NULL, NULL, NULL), -- /savremena-dijagnostika/: «Rtg paranazalnih sinusa»
	('x-ray-temporomandibular-joint', NULL, NULL, NULL), -- /savremena-dijagnostika/: «Rtg temporomandibularnog zgloba»
	('x-ray-hand', NULL, NULL, NULL), -- /savremena-dijagnostika/: «Rtg šake»
	('ceramic-veneer', NULL, NULL, NULL), -- /estetska-stomatologija/: «Viniri (keramičke fasete)»
	('all-ceramic-crown', NULL, NULL, NULL), -- /estetska-stomatologija/: «Bezmetalne krunice»; /protetika-2/: «Krunice i mostovi izrađeni od bezmetalne keramike» — материал (цирконий/пресс) не назван → общая безметалловая
	('direct-composite-veneer', NULL, NULL, NULL), -- /estetska-stomatologija/: «Kompozitne fasete» — техника не названа, прямая (в кресле) — основной вид
	('home-teeth-whitening', NULL, NULL, NULL), -- /estetska-stomatologija/: «Izbjeljivanje zuba … dobiti foliju izrađenu po modelu Vaših zuba i sredstvo za bjeljenje … bjeliti zube kod kuće»
	('dental-implant-placement', NULL, NULL, NULL), -- /implantologija/: «Zubni implant je imitacija korijena zuba, obično napravljen od titanijuma»; /oralna-hirurgija/: «ugradnja dentalnih implantata» — бренд не назван
	('wisdom-tooth-extraction', NULL, NULL, NULL), -- /oralna-hirurgija/: «ekstrakcija (vađenje) umnjaka»
	('apicoectomy', NULL, NULL, NULL), -- /oralna-hirurgija/: «apikotomija»
	('dental-and-soft-tissue-trauma-treatment', NULL, NULL, NULL), -- /oralna-hirurgija/: «zbrinjavanje facijalne traume»
	('pre-prosthetic-soft-and-hard-tissue-correction', NULL, NULL, NULL), -- /oralna-hirurgija/: «preprotetska hirurgija», «korektivni i preventivni zahvati na koštanim i mekim tkivima»
	('bone-augmentation', NULL, NULL, NULL), -- /oralna-hirurgija/: «koštani graftovi»
	('self-ligating-braces-metal-per-jaw', NULL, NULL, NULL), -- /ortodoncija/: «Među njima su fiksni aparati Damon system» — Damon уже синоним этой записи (ortholine-podgorica, dental-smile-tivat)
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- /lijecenje-parodontopatije/: «profesionalno ukljanjanje čvrstih i mekih naslaga», «Uklanjanje mikrobiološkog plaka i kalkulusa (kamenca)»
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- /lijecenje-parodontopatije/: «nehirurški (konzervativni) tretman prostora ispod nivoa desni … čišćenje zubnog kamenca i mekih naslaga ultrazvukom i specijalnim kiretama»
	('therapeutic-tooth-grinding', NULL, NULL, NULL), -- /lijecenje-parodontopatije/: «U ovoj fazi ponekad radimo i tzv. okluzalno uravnoteženje»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- /lijecenje-parodontopatije/: «Hirurška terapija … modifikovana Vidmanova režanj operacija»
	('guided-tissue-regeneration', NULL, NULL, NULL), -- /lijecenje-parodontopatije/: «vođena regeneracija tkiva»
	('periodontal-flap-surgery-with-bone-graft-per-tooth', NULL, NULL, NULL), -- /lijecenje-parodontopatije/: «koštani graftovi (transplantati)» в хирургическом лечении пародонтита
	('ceramic-dental-bridge', NULL, NULL, NULL); -- /protetika-2/: «Krunice i mostovi izrađeni od bezmetalne keramike»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_w_viv_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_w_viv_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_w_viv_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 10
-- Ортодонтия: единственный ортодонт — dr Jovanka Lekić («specijalista ortodoncije»; «posebno fiksne ortodoncije») → Damon.
-- Хирургия: единственный хирург — dr Stefan Lekić («specijalista oralne hirurgije»); /lijecenje-parodontopatije/: «Vaš oralni hirurg će Vam …
-- predložiti najadekvatniju terapiju» → хирургия полости рта, имплантация и хирургическое лечение пародонтита на него.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_viv_ds;
CREATE TEMPORARY TABLE tmp_w_viv_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_w_viv_ds (doctor_slug, service_slug) VALUES
	('jovanka-lekic', 'self-ligating-braces-metal-per-jaw'),
	('stefan-lekic', 'dental-implant-placement'),
	('stefan-lekic', 'wisdom-tooth-extraction'),
	('stefan-lekic', 'apicoectomy'),
	('stefan-lekic', 'dental-and-soft-tissue-trauma-treatment'),
	('stefan-lekic', 'pre-prosthetic-soft-and-hard-tissue-correction'),
	('stefan-lekic', 'bone-augmentation'),
	('stefan-lekic', 'flap-surgery-periodontal'),
	('stefan-lekic', 'guided-tissue-regeneration'),
	('stefan-lekic', 'periodontal-flap-surgery-with-bone-graft-per-tooth');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_w_viv_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_viv_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 24, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 10 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_w_viv_services;