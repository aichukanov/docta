-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dr Janković — Montenegro Dental Care (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-ordinacija-dr-jankovic-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-dr-jankovic-podgorica-services.sql
--
-- Источник: https://www.montenegrodentalcare.com/ (me), одностраничник, curl 2026-10-09. Прайса нет; все позиции price = NULL
-- («cijene naših usluga» в блоке дентального туризма — после ортопана/CBCT, не цена).
-- Заведены только процедуры, прямо названные в блоках сайта. Пояснения без процедуры — в excluded записи импорта.
--
-- Итого: 30 услуг (0 с ценой), новых записей каталога — 0, повторено из других импортов агента W — composite-inlay-onlay. Анализов нет.
-- Привязок врач↔услуга: 8.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJlytQ7C7rTRMRDPUgGS8McXQ' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ordinacija-dr-jankovic-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ordinacija-dr-jankovic-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- (запись заведена в insert-clinic-dental-smile-tivat-services.sql; повторена идемпотентно — файл не зависит от порядка применения)
-- dentalsmiletivat.com /inlay_overlay: «Izrađuju se od kompozitnog ili keramičkog materijala u zubotehničkom laboratoriju».
-- В каталоге вкладки только ceramic/gold/zirconia — композитной нет. Категория 20, специальность 78 (как ceramic-inlay-onlay).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'composite-inlay-onlay', 'Composite Inlay Onlay', 'Kompozitni inlay ili onlay', 'Композитни inlay или onlay',
	'Композитная вкладка инлей или онлей', 'Komposit-Inlay oder -Onlay', 'Kompozit inley veya onley', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'composite-inlay-onlay' OR name_en = 'Composite Inlay Onlay');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompozitni inlej', 'sr' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompozitni onlej', 'sr' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Композитни инлеј', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Composite inlay', 'en' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Indirect composite restoration', 'en' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Композитная вкладка', 'ru' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompositinlay', 'de' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompozit inley', 'tr' FROM medical_services WHERE slug = 'composite-inlay-onlay';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (30)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_w_jnk_services;
CREATE TEMPORARY TABLE tmp_w_jnk_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_w_jnk_services (slug, price, price_min, price_max) VALUES
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- «LIJEČENJE KANALA — Liječenje kanala korijena zuba - endodontska terapija … koristimo apex-locator» — число каналов не названо (как Mušura, dr-sevaljevic-tivat)
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('intraoral-x-ray', NULL, NULL, NULL), -- «koristimo apex-locator i najsavremeniji rendgen aparat američke proizvodnje Gendex imaging»; травмы: «neophodan je Rtg snimak»
	('composite-filling', NULL, NULL, NULL), -- «PLOMBIRANJE — Visokoestetski kompozitni i glasjonomerni ispuni»; «KOMPOZITNI ISPUNI … danas je kompozit sasvim sigurno favorit»
	('nano-composite-filling', NULL, NULL, NULL), -- «INLEJI … Tako dobijeni kaviteti se mogu nadoknaditi klasičnom plombom (nanohibridnim kompozitom)» — материал назван
	('glass-ionomer-filling', NULL, NULL, NULL), -- «Visokoestetski kompozitni i glasjonomerni ispuni»
	('ceramic-inlay-onlay', NULL, NULL, NULL), -- «Inlej izradjen od keramike i zlata je standard»; «INLEJI u narodu poznati kao keramičke i zlatne plombe … izradi inlej / onleja»
	('gold-inlay', NULL, NULL, NULL), -- «Inlej izradjen od keramike i zlata je standard»
	('composite-inlay-onlay', NULL, NULL, NULL), -- «… kompozit koji u svom puniocu ima 75% keramike takođe je našao svoje mjesto u izradi inleja» (НОВАЯ запись, заведена импортом dental-smile-tivat) (НОВАЯ запись каталога)
	('dental-fissure-sealant', NULL, NULL, NULL), -- «ZALIVANJE FISURA MLIJEČNIH I STALNIH ZUBA — Nanošenje zaštitnog materijala na griznu površinu zuba»
	('topical-fluoride-treatment', NULL, NULL, NULL), -- «FLUORIZACIJA ZUBA — tretman kojim se na zube nanosi pasta visoke koncentracije fluora»
	('dental-and-soft-tissue-trauma-treatment', NULL, NULL, NULL), -- «TRAUME MLIJEČNIH I STALNIH ZUBA KOD DJECE — Povrede mlečnih i stalnih zuba, kao i manje povrede mekog i koštanog tkiva orofacijalne regije»
	('custom-dental-guard', NULL, NULL, NULL), -- «Štitnici za zube … Izrađuju se za svakog pacijenta individualno»
	('tooth-extraction-complex', NULL, NULL, NULL), -- «KOMPLIKOVANO VAĐENJE ZUBA … uklanjanje zaostalih korijena»
	('surgical-tooth-extraction', NULL, NULL, NULL), -- «HIRURŠKO VAĐENJE ZUBA … Potrebno je napraviti rez u mekom tkivu oko zuba»
	('apicoectomy', NULL, NULL, NULL), -- «APIKOTOMIJA … uklanja patološki sadržaj iz kosti u regiji vrha korijena zuba, zajedno sa vrhom korijena»
	('cystectomy', NULL, NULL, NULL), -- «CISTEKTOMIJA … odstranjenje cističnog sadržaja i same ciste»
	('frenectomy', NULL, NULL, NULL), -- «FRENEKTOMIJA … uklanjanje zadebljalog frenuluma (resica), najčešče kod djece»
	('impacted-tooth-extraction', NULL, NULL, NULL), -- «VAĐENJE IMPAKTIRANIH ZUBA … najčešće su impaktirani umnjaci, poslije njih očnjaci»
	('pre-prosthetic-soft-and-hard-tissue-correction', NULL, NULL, NULL), -- «Predprotetski hirurški tretmani mekih tkiva. korekcija mekotkivnih I tvrdotkivnih deformiteta prije protetskog zbrinjavanja»
	('dental-implant-placement', NULL, NULL, NULL), -- «ZUBNI IMPLANTI — Implanti su titanijumska zamjena za izgubljeni zub» — бренд не назван
	('teeth-whitening', NULL, NULL, NULL), -- «IZBJELJIVANJE ZUBA … Peroksidi u preparatu za izbjeljivanje razlažu se na molekule aktivnog kiseonika» — метод/система не названы
	('direct-composite-veneer', NULL, NULL, NULL), -- «KOMPOZITNI VINIRI … nanohibridni kompozit koji posjeduje zadovoljavajuče osobine i za fasete»
	('ceramic-veneer', NULL, NULL, NULL), -- «KERAMIČKI VINIRI su kako estetski tako i funkcijonalno najprihvatljiviji»
	('lumineers', NULL, NULL, NULL), -- «nova podgrupa tankih keramičkih vinira nazvani LUMINIRI … nema brušenja zuba»; «POLUFABRIKOVANI I FABRIKOVANI LUMINIRI»
	('all-ceramic-crown', NULL, NULL, NULL), -- «VISOKOESTETSKE / BEZMETALNE NAVLAKE — Visokoestetske krune i mostovi izrađuju se isključivo od keramike …»
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- «… ili za osnovu imaju cirkonijum»
	('ceramic-dental-bridge', NULL, NULL, NULL), -- «Visokoestetske krune i mostovi izrađuju se isključivo od keramike ili za osnovu imaju cirkonijum»
	('complete-dental-cleaning', NULL, NULL, NULL), -- «PROFESIONALNO ČIŠĆENJE ZUBA … U SKLOPU TRETMANA UKLJUČENO JE: Uklanjanje zubnog kamenca (ultrazvučnim aparatom), Peskiranje zuba (Air-Flow), Poliranje i fluorisanje»
	('dental-jewelry-application', NULL, NULL, NULL); -- «U estetetsku stomatologiju spadaju: … nakit za zube»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_w_jnk_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_w_jnk_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_w_jnk_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 8
-- Хирургия и имплантация: единственный хирург — dr Marija Janković («Specijalista oralne hirurgije – implantolog») → 7 хирургических услуг
-- и имплантация на неё. dr Petar Janković — специализант протетики, услуги сайт по нему не распределяет → без привязок.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_jnk_ds;
CREATE TEMPORARY TABLE tmp_w_jnk_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_w_jnk_ds (doctor_slug, service_slug) VALUES
	('marija-jankovic', 'tooth-extraction-complex'),
	('marija-jankovic', 'surgical-tooth-extraction'),
	('marija-jankovic', 'apicoectomy'),
	('marija-jankovic', 'cystectomy'),
	('marija-jankovic', 'frenectomy'),
	('marija-jankovic', 'impacted-tooth-extraction'),
	('marija-jankovic', 'pre-prosthetic-soft-and-hard-tissue-correction'),
	('marija-jankovic', 'dental-implant-placement');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_w_jnk_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_jnk_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 30, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 8 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Новые записи каталога: категории, специальности, синонимы.
SELECT ms.id, ms.slug, ms.name_sr,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specs,
	(SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
FROM medical_services ms WHERE ms.slug IN ('composite-inlay-onlay');

DROP TEMPORARY TABLE IF EXISTS tmp_w_jnk_services;