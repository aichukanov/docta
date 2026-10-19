-- ═══════════════════════════════════════════════════════════════════════════
-- V Dental Centar Podgorica — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-v-dental-centar-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-v-dental-centar-podgorica-services.sql
--
-- Источник: https://www.vdental.me/usluge (+ «O nama» на главной), curl 2026-10-08; lastmod страниц 2022-12-30.
-- Цен нет ни на одной странице → все позиции price = NULL. Раздел /usluge общий для обеих
-- ординаций (сайт не делит услуги по городам) → одинаковый список в Подгорице и Будве.
-- Заведены только процедуры, прямо названные в тексте; направления («Ortopedija vilica»,
-- «paradontalna i gingivalna hirurgija») — не услуги, см. excluded в записи импорта.
--
-- Итого: 36 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга нет: страница услуг не называет врачей.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJq0zUMS7rTRMRx6_IYy9YQZo';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'v-dental-centar-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-v-dental-centar-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (36)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_vdental_pg_services;
CREATE TEMPORARY TABLE tmp_vdental_pg_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_vdental_pg_services (slug, price, price_min, price_max) VALUES
	('dental-consultation-with-treatment-plan', NULL, NULL, NULL), -- / i /home: «Veliki akcenat stavljamo na prvi pregled … detaljno objašnjavamo plan terapije i dinamiku rada»
	('tooth-extraction', NULL, NULL, NULL), -- /usluge Oralna hirurgija: «rutinsko … vađenje zuba»
	('tooth-extraction-complex', NULL, NULL, NULL), -- «komplikovano … vađenje zuba»
	('surgical-tooth-extraction', NULL, NULL, NULL), -- «hirurško vađenje zuba»
	('surgical-extraction-of-residual-root', NULL, NULL, NULL), -- «… vađenje zuba i korjena zuba»
	('impacted-tooth-extraction', NULL, NULL, NULL), -- «hirurško vađenje impaktiranih umnjaka»
	('surgical-exposure-impacted-tooth', NULL, NULL, NULL), -- «hirurško ortodontska terapija impaktiranih očnjaka»
	('apicoectomy', NULL, NULL, NULL), -- «resekcije korjena zuba (apikotomija)»
	('cystectomy', NULL, NULL, NULL), -- «uklanjanje viličnih cisti»
	('bone-augmentation', NULL, NULL, NULL), -- «preimplantatna hirurgija … (nadoknada koštanog tkiva»
	('dental-sinus-lift', NULL, NULL, NULL), -- «podizanje poda sinusa - sinus lift»
	('mucosal-autograft', NULL, NULL, NULL), -- «transplantacije koštanog i mekog tkiva» — мягкие ткани; костная часть покрыта bone-augmentation
	('prp-dental-application', NULL, NULL, NULL), -- «primjena produkata krvne plazme pacijenta - PRP, PRF»
	('3d-dental-x-ray-cbct', NULL, NULL, NULL), -- «trodimenzionalni snimak vilica - CBCT»; Radiološka dijagnostika: «trodimenzionalnom CBCT … od 2011.»
	('dental-implant-placement', NULL, NULL, NULL), -- Implantologija: «Ugradnja implantata se obavlja u lokalnoj anesteziji» — бренд не назван («švajcarskih i njemačkih proizvođača»)
	('3d-implant-planning', NULL, NULL, NULL), -- Kompjuterom vođena implantologija: «virtuelno pozicioniranje implantata»
	('surgical-guide-per-implant', NULL, NULL, NULL), -- «izrađuje guide, tj. vodič» (с 2015 — 3D printing)
	('complete-denture', NULL, NULL, NULL), -- Protetika: «mobilne protetske nadoknade»
	('partial-denture', NULL, NULL, NULL), -- «mobilne protetske nadoknade»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- «kombinovane protetske nadoknade»
	('metal-ceramic-crown', NULL, NULL, NULL), -- «fiksne protetske nadoknade (metal keramičke … krunice»
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- «cirkonijumske … krunice»
	('all-ceramic-crown', NULL, NULL, NULL), -- «keramičke krunice»
	('ceramic-dental-bridge', NULL, NULL, NULL), -- «… krunice i mostove»
	('digital-smile-design', NULL, NULL, NULL), -- Digital Smile Design
	('teeth-whitening', NULL, NULL, NULL), -- Estetska stomatologija: «izbjeljivanja vitalnih … zuba … tretmanom u ordinaciji»
	('home-teeth-whitening', NULL, NULL, NULL), -- «… kućnim … tretmanom»
	('internal-bleaching-of-devitalized-tooth', NULL, NULL, NULL), -- «izbjeljivanja … avitalnih zuba»
	('direct-composite-veneer', NULL, NULL, NULL), -- «izradom kompozitnih … faseta»
	('ceramic-veneer', NULL, NULL, NULL), -- «… i keramičkih faseta»
	('prp-facial-treatment', NULL, NULL, NULL), -- «PRP … i PRF … koristimo ih i u Anti age tretmanima … ublažavanje bora, ožiljaka i pigmentacije na licu»
	('composite-filling-on-primary-tooth', NULL, NULL, NULL), -- Dječija i preventivna: «Sanacije karijesnih mliječnih zuba» — единственный кандидат каталога
	('fissure-sealant-with-fluoride', NULL, NULL, NULL), -- «Zalivanje fisura … nanošenjem površinskog premaza sa dodatkom fluora»
	('intraoral-x-ray', NULL, NULL, NULL), -- Radiološka dijagnostika: «pojedinačni (ciljani) snimci zuba»
	('panoramic-x-ray', NULL, NULL, NULL), -- «ortopantomografski … snimci»
	('cephalometric-x-ray', NULL, NULL, NULL); -- «telerentgen snimci»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_vdental_pg_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_vdental_pg_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_vdental_pg_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Только там, где сайт сам называет врача услуги/направления.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 36, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_vdental_pg_services;
