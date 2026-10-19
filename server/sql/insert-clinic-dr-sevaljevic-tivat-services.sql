-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dr Ševaljević (Tivat) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dr-sevaljevic-tivat.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dr-sevaljevic-tivat-services.sql
--
-- Источник: https://www.drsevaljevic.me/ (блок «Naše usluge», вкладки), curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- Заведены только подпункты перечня; заголовки направлений без процедуры — в excluded записи импорта.
--
-- Итого: 37 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ0yC6VJwxTBMRLu4wgJzWJCU' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dr-sevaljevic-tivat' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dr-sevaljevic-tivat.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (37)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_s_sev_services;
CREATE TEMPORARY TABLE tmp_s_sev_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_s_sev_services (slug, price, price_min, price_max) VALUES
	('dental-consultation', NULL, NULL, NULL), -- Pregled i dijagnostika: «Radi spriječavanja svih bolesti zuba i usne šupljine preporučuje se pregled i cišćenje kamenca najmanje dva puta godišnje»
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- Endodoncija: «liječenje korjenskih kanala zuba … dijeli na dvije oblasti liječenja zubnih kanala (pulpi)» — число каналов не названо, как у Mušura
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('root-canal-retreatment', NULL, NULL, NULL), -- «… i revizije punjenja kanala»
	('dental-fissure-sealant', NULL, NULL, NULL), -- Dječja stomatologija: «Zalivanje fisura»
	('pediatric-caries-treatment', NULL, NULL, NULL), -- «Plombe na mliječnim i trajnim zubima kod djece»
	('primary-tooth-pulp-treatment', NULL, NULL, NULL), -- «Endodontsko liječenje mliječnih zubi»
	('primary-tooth-extraction', NULL, NULL, NULL), -- «Vađenje mliječnih zubi»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- Ortopedija vilica: «Ploče sa šrafom i pokretnim aparatima»
	('orthodontic-functional-monoblock-appliance', NULL, NULL, NULL), -- «Bimaksilarni blok- monoblok»
	('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL), -- «Samoligirajući fiksni aparat» — материал брекетов не назван, а self-ligating в каталоге только с материалом (metal/ceramic) → generic fixed, см. openQuestions
	('retention-aligner-fabrication', NULL, NULL, NULL), -- «Retenciona folija» (дословный синоним записи)
	('heavy-dental-scaling-and-polishing', NULL, NULL, NULL), -- Parodontologija: «Ultrazvučno čišćenje zubnog kamenca i poliranje zuba»
	('soft-dental-deposit-removal', NULL, NULL, NULL), -- «Čišćenje zubnih naslaga»
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- «Liječenje parodonta (kiretaža zuba)» (у записи синоним «Zatvorena kiretaža parodontalnih džepova»)
	('metal-ceramic-crown', NULL, NULL, NULL), -- Zubna protetika: «Krunice i mostovi: Metal- Keramika»
	('metal-ceramic-bridge-pontic', NULL, NULL, NULL), -- там же (мосты металлокерамика → член моста, как в прежних импортах)
	('cadcam-e-max-layered-crown', NULL, NULL, NULL), -- «Bezmetalna keramika (e.max, cirkon)» — e.max в каталоге только эта запись (синоним «Emax krunica»); CAD/CAM и облицовка сайтом не названы
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- «Bezmetalna keramika (e.max, cirkon)»
	('ceramic-dental-bridge', NULL, NULL, NULL), -- «Krunice i mostovi: … Bezmetalna keramika»
	('skeletal-partial-denture', NULL, NULL, NULL), -- «Zubne proteze: Skeletirane (parcijalne)»
	('complete-denture', NULL, NULL, NULL), -- «Zubne proteze: … Totalne» — материал не назван
	('ceramic-veneer', NULL, NULL, NULL), -- «Keramičke (porcelanske) fasete»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- «Kombinovani protetski radovi (fiksno-mobilni+ atečmeni)»
	('dental-implant-placement', NULL, NULL, NULL), -- Implanti: «Ugradnjom implanta u kost zamjenjuje se korijen zuba» — бренд не назван
	('implant-crown-metal-ceramic', NULL, NULL, NULL), -- «… stavlja se nosač krunice (abatment) koja može biti metalno-keramička …»
	('metal-free-implant-crown-with-original-abutment', NULL, NULL, NULL), -- «… ili bezmetalna keramička krunica (cirkon)» (как у Mušura)
	('teeth-whitening', NULL, NULL, NULL), -- Kozmetički radovi: «Bijeljenje zuba» — способ не назван
	('dental-jewelry-application', NULL, NULL, NULL), -- Kozmetički radovi: «Cirkoni» — в косметическом разделе рядом с отбеливанием, циркониевые коронки уже есть в протетике («Bezmetalna keramika (e.max, cirkon)») → стразы на зубы, как «svjetlucavi cirkoni» у Dentalux (координатор 2026-10-09)
	('tooth-extraction', NULL, NULL, NULL), -- Oralna hirurgija: «Vađenje zuba»
	('surgical-tooth-extraction', NULL, NULL, NULL), -- «Alveotomija ili hirurško uklanjanje … zuba … iz kosti (najčešće umnjaka)»
	('impacted-tooth-extraction', NULL, NULL, NULL), -- «… hirurško uklanjanje impaktiranih ili retiniranih zuba»
	('surgical-extraction-of-residual-root', NULL, NULL, NULL), -- «… dijelova zuba ili korijena iz kosti»
	('apicoectomy', NULL, NULL, NULL), -- «Apikotomija – hirurški zahvat kojim se odstranjuje vrh korijena zuba uz hronični upalni proces»
	('frenectomy', NULL, NULL, NULL), -- «Frenulektomija – hirurško odstranjivanje abnormalno razvijenog frenuluma»
	('bone-augmentation', NULL, NULL, NULL), -- «Augmentacija – hirurški postupak dodavanja vjestacke kosti … radi ugradnje implanta»
	('dental-sinus-lift', NULL, NULL, NULL); -- «Sinus lifting – hirurški zahvat kojim se podiže dno sinusa … za ugradnju implanta»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_s_sev_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_s_sev_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_s_sev_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Сайт не называет врачей у услуг — привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 37, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_s_sev_services;