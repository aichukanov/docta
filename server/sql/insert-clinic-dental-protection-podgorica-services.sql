-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka poliklinika Dental Protection (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dental-protection-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-protection-podgorica-services.sql
--
-- Источник: https://dentalprotection.me/, curl 2026-10-08. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные на сайте; направления и оборудование — в excluded записи импорта.
--
-- Итого: 38 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 4.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJR1VVqhTrTRMR8AW3tk2L5Lo' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dental-protection-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dental-protection-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (38)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_q_dp_services;
CREATE TEMPORARY TABLE tmp_q_dp_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_q_dp_services (slug, price, price_min, price_max) VALUES
	('specialist-dental-examination', NULL, NULL, NULL), -- / (главная): «Brzo i lako zakažite redovan ili specijalistički pregled»
	('follow-up-dental-examination', NULL, NULL, NULL), -- /: «Redovni preventivni pregledi — Filozofija naše Poliklinike bazirana je na konceptu redovnih posjeta», Restaurativna: «Dobra higijena i redovne kontrole»
	('tooth-extraction', NULL, NULL, NULL), -- /departments/ Oralna hirurgija: «rutinska … vadjenja zuba»
	('tooth-extraction-complex', NULL, NULL, NULL), -- «… i komplikovana vadjenja zuba»
	('surgical-extraction-of-residual-root', NULL, NULL, NULL), -- «uklanjanje zaostalih korijenova zuba»
	('apicoectomy', NULL, NULL, NULL), -- «operacije vrha korijena zuba»
	('oral-fibroma-and-bone-exostosis-removal', NULL, NULL, NULL), -- «uklanjanje koštanih izraslina»
	('cystectomy', NULL, NULL, NULL), -- «operacije cista, kao i drugih promjena na viličnim kostima»
	('implantologist-consultation', NULL, NULL, NULL), -- «Preduslov ugradnje dentalnih implatata je specijalistički pregled koji obavljamo na našoj Poliklinici»
	('dental-implant-placement', NULL, NULL, NULL), -- «ugradnji posebnih korijenskih nadoknada (IMPLANTATA) izradjenih od titanijuma» — бренд не назван
	('orthodontic-consultation', NULL, NULL, NULL), -- Ortopedija vilica: «svoje dijete dovedu kod ortodonta na pregled … u uzrastu 7-9 godina»
	('comprehensive-orthodontic-diagnostics', NULL, NULL, NULL), -- «Ortodonska dijagnoza zahtijeva detaljnu analizu pacijenta, sa izradom plana terapije»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- «MOBILNI ORTODONSKI APARATI … sastoje se od akrilatne ploče, žičanih elemenata i raznih vrsta šrafova»
	('fixed-braces-metal-per-jaw', NULL, NULL, NULL), -- «vršimo terapiju kako klasičnim fiksnim protezama (metalnim)»
	('fixed-braces-ceramic-or-composite-per-jaw', NULL, NULL, NULL), -- «… tako i estetskim fiksnim protezama»
	('pediatric-dentist-consultation', NULL, NULL, NULL), -- Dječija i preventivna: «Već sa nicanjem mliječnih zuba kod djeteta treba ga dovesti … gdje će uz pregled roditelji dobiti savijete»
	('pediatric-dental-adaptation', NULL, NULL, NULL), -- «… da se upozna sa ambijentom i osobljem ordinacije»
	('pediatric-caries-treatment', NULL, NULL, NULL), -- «vrši se bezbolno zbrinjavanje svih oboljenja usta i zuba kod djece»
	('dental-and-soft-tissue-trauma-treatment', NULL, NULL, NULL), -- «… i zbrinjavanje fraktura zuba» (отделение детской стоматологии)
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- Parodontologija: «uklanjanje mekih i tvrdih naslaga … nakon čega se radi poliranje svih zubnih površina»
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- «kao i uklanjanje inficiranog tkiva sa površine zuba»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- «U odredjenim slučajevima je potrebno primjeniti hiruršku terapiju. Hirurškim tretmanom smanjuje se dubina parodontalnog dzepa»
	('periodontal-flap-surgery-with-bone-graft-per-tooth', NULL, NULL, NULL), -- «postavljaju se koštani zamjenici»
	('guided-tissue-regeneration', NULL, NULL, NULL), -- «kao i materijali koji omogućavaju brzu i bolju regeneraciju kako kosti tako i mekog tkiva»
	('aphthous-ulcer-treatment', NULL, NULL, NULL), -- Oralna medicina: «Alergijske reakcije u ustima, afte i razna virusna i gljivična oboljenja»
	('treatment-of-oral-manifestations-of-systemic-diseases', NULL, NULL, NULL), -- «Promjene u ustima kao posledica raznih kožnih i krvnih bolesti kao i endokrinih i vitaminskih poremećaja»
	('dental-caries-treatment', NULL, NULL, NULL), -- Restaurativna: «Restauracija zuba zubnim plombama ili ispunima … šupljine u zubu, nastale djelovanjem karijesa» — материал не назван
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- Endodoncija: «odstraniti pulpno tkivo (ručnim i mašinskim instrumentima), zatim … kanale … ispuniti»
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- «naročito kod višekorijenih zuba … i po četiri i više kanala»
	('teeth-whitening', NULL, NULL, NULL), -- Estetska: «da se izbjele prebojeni zubi» — способ не назван
	('aesthetic-tooth-restoration', NULL, NULL, NULL), -- «da se plombe koje ruže izgled zamijene novim visoko estetskim ispunima»
	('gingivoplasty', NULL, NULL, NULL), -- «kao i da se meko tkivo (desni) preoblikuje»
	('complete-denture', NULL, NULL, NULL), -- Protetika: «riješavanja problema parcijalne i totalne bezubosti», «Protetske nadoknade se dijele na fiksne, mobilne i kombinovane»
	('partial-denture', NULL, NULL, NULL), -- «… parcijalne … bezubosti»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- «… i kombinovane»
	('3d-dental-x-ray-cbct', NULL, NULL, NULL), -- Radiologija: «digitalnim aparatima najnovije generacije za snimanje zuba uključujući snimanja u tri dimenzije (3D)»
	('intraoral-x-ray', NULL, NULL, NULL), -- «… za snimanje zuba», /our-clinic/about/: «rentgen kabinet sa modernim digitalnim aparatima za sve vrste snimanja zuba i vilica»
	('panoramic-x-ray', NULL, NULL, NULL); -- /our-clinic/about/: «… za sve vrste snimanja zuba i vilica»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_q_dp_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_q_dp_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_q_dp_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 4
-- /departments/: «Stomatološka Poliklinika „Dental Protection“ je medju prvim djelatnostima razvila dječiju i
-- preventivnu stomatologiju koju vodi dr Novak Popović» — услуги отделения детской стоматологии привязаны к
-- нему. Остальные отделения сайт по врачам не называет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_q_dp_ds;
CREATE TEMPORARY TABLE tmp_q_dp_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_q_dp_ds (doctor_slug, service_slug) VALUES
	('novak-popovic', 'pediatric-dentist-consultation'),
	('novak-popovic', 'pediatric-dental-adaptation'),
	('novak-popovic', 'pediatric-caries-treatment'),
	('novak-popovic', 'dental-and-soft-tissue-trauma-treatment');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_q_dp_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_q_dp_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 38, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 4 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_q_dp_services;
