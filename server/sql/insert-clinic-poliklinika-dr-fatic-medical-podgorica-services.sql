-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Dr Fatić Medical (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-poliklinika-dr-fatic-medical-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-dr-fatic-medical-podgorica-services.sql
--
-- Источники (curl 2026-10-08): 21 страница направлений drfaticmedical.com, RU-пост 2023-02 со сводным перечнем
-- услуг, посты 2026-05 (EVLA, склеротерапия), vaskularnahirurgija.me/online-konsultacije (2024-07).
-- Цен нет → все price = NULL. Заведены только названные процедуры; направления и описательные тексты
-- специальностей — в excluded. КТ/МРТ/ангиография/ИВП/бронхоскопия, литотрипсия, химиотерапия — НЕ заведены
-- (собственная радиология клиники — только УЗИ; см. openQuestions записи импорта).
--
-- 2e (агент Z, 2026-10-09, решение координатора): меню «Tretman» и «Dijagnostički testovi» vaskularnahirurgija.me
-- (персональный сайт dr Nikola Fatić) перепроверено — процедуры поликлинике НЕ заводятся. Сайт сам описывает их как
-- стационарные: ампутации и каротидная эндартерэктомия — «Procedura se sprovodi u operacionoj sali» / «u sterilnim
-- uslovima i standardnoj operacionoj sali»; ангиография — «Prije izvođenja angiografije pacijent se mora hospitalizovati»;
-- катетерный тромболизис — «Procedura se izvodi u angio sali u radiološkom odjelu»; TEVAR/EVAR — стент-графт «pod
-- kontrolom x zraka», шунтирования и открытая операция на аорте — разрез живота; MR/MSCT-ангиография требуют аппаратов,
-- которых у поликлиники нет. Страницы 2017-08, когда dr Fatić работал в КЦЦГ (Hirurška klinika, Centar za vaskularnu
-- hirurgiju). Классическая операция вен (ligiranje, striping) — в общей/регионарной анестезии, тоже не заведена;
-- «Diabetsko stopalo» — памятка по домашнему уходу, не услуга поликлиники. Из 2e осталось только 6 привязок
-- nikola-fatic к уже заведённой диагностике (color duplex ×4, ABI, онлайн-консультация) — это его сайт.
--
-- Итого: 42 услуг (0 с ценой), из них новых в каталоге: 2. Анализов нет
-- (патология — партнёрская IGA lab). Привязки врач↔услуга — где сайт называет ответственного врача:
-- Anđela Fatić (antiaging, laser), Nikola Fatić (vaskularna/EVLA), Rade Stanisavljević (urologija).
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJR3tem2HrTRMRa4Lw8UHmfL0';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-dr-fatic-medical-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-dr-fatic-medical-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (2, идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- «LASERSKO USKLANJANJE TRAJNE ŠMINKE, TETOVAŽA I PIGMENTACIJA SA KOŽE» (/laserski-tretmani/).
-- Удаления татуировок/перманентного макияжа в каталоге нет совсем (поиск tattoo/tetov/šmink/татуир).
-- Пигментации — отдельно, существующая melasma-hyperpigmentation-laser. Схема категорий/специальностей —
-- как у лазерных эстетических записей (co2-laser-*, ultraformer): 18 + 24 / 7 + 18.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'laser-tattoo-removal', 'Laser Tattoo Removal', 'Lasersko uklanjanje tetovaža', 'Ласерско уклањање тетоважа',
	'Лазерное удаление татуировок', 'Laser-Tattooentfernung', 'Lazerle dövme silme', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'laser-tattoo-removal' OR name_en = 'Laser Tattoo Removal');

-- «NEINVAZIVNO LASERSKO PODMLAĐIVANJE, ZATEZANJE I OSVJEŽAVANJE KOŽE» (/laserski-tretmani/).
-- Generic-записи лазерного омоложения нет: только брендовые non-surgical-rejuvenation-fractora-laser,
-- ultraformer-laser-facial-rejuvenation и абляционные co2-laser-face* — сайт ни бренд, ни CO2 не называет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'laser-skin-rejuvenation', 'Laser Skin Rejuvenation', 'Lasersko podmlađivanje kože', 'Ласерско подмлађивање коже',
	'Лазерное омоложение кожи', 'Laser-Hautverjüngung', 'Lazerle cilt gençleştirme', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'laser-skin-rejuvenation' OR name_en = 'Laser Skin Rejuvenation');

-- Категория 18
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('laser-tattoo-removal', 'laser-skin-rejuvenation');

-- Категория 24
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 24 FROM medical_services WHERE slug IN ('laser-tattoo-removal', 'laser-skin-rejuvenation');

-- Специальность 7
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('laser-tattoo-removal', 'laser-skin-rejuvenation');

-- Специальность 18
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('laser-tattoo-removal', 'laser-skin-rejuvenation');

-- Синонимы новых записей
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Uklanjanje tetovaže laserom', 'sr' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Lasersko uklanjanje trajne šminke', 'sr' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Ласерско уклањање трајне шминке', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Лазерное удаление перманентного макияжа', 'ru' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Удаление тату лазером', 'ru' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Laser permanent makeup removal', 'en' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Permanent-Make-up-Entfernung mit Laser', 'de' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Kalıcı makyajın lazerle silinmesi', 'tr' FROM medical_services WHERE slug = 'laser-tattoo-removal'
UNION ALL SELECT id, 'Lasersko zatezanje kože', 'sr' FROM medical_services WHERE slug = 'laser-skin-rejuvenation'
UNION ALL SELECT id, 'Ласерско затезање коже', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-skin-rejuvenation'
UNION ALL SELECT id, 'Лазерная подтяжка кожи', 'ru' FROM medical_services WHERE slug = 'laser-skin-rejuvenation'
UNION ALL SELECT id, 'Laser skin tightening', 'en' FROM medical_services WHERE slug = 'laser-skin-rejuvenation'
UNION ALL SELECT id, 'Laser-Hautstraffung', 'de' FROM medical_services WHERE slug = 'laser-skin-rejuvenation'
UNION ALL SELECT id, 'Lazerle cilt sıkılaştırma', 'tr' FROM medical_services WHERE slug = 'laser-skin-rejuvenation';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (42)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_fatic_services;
CREATE TEMPORARY TABLE tmp_fatic_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_fatic_services (slug, price, price_min, price_max) VALUES
	('vascular-surgeon-examination', NULL, NULL, NULL), -- «Zakažite pregled» (главная, блок Dr Nikola Fatić) + /vaskularna-hirurgija/ — vaskularni hirurg
	('laser-varicose-vein-surgery', NULL, NULL, NULL), -- /laserska-operacija-vena/: «Endovenska laserska ablacija proširenih vena (EVLA)»; laser Biolitec Leonardo 1470 nm, ELVeS Radial — бренд аппарата, не процедуры
	('sclerotherapy-veins', NULL, NULL, NULL), -- пост 2026-05: «sklerozaciju koristimo isključivo kao finalni, estetski touch nakon što laserom odradimo glavni dio»
	('doppler-lower-extremity-blood-vessels', NULL, NULL, NULL), -- /vaskularna-hirurgija/ Dijagnostički testovi: «Color duplex scan arterija i vena nogu i ruku»
	('doppler-upper-extremity-blood-vessels', NULL, NULL, NULL), -- «Color duplex scan arterija i vena nogu i ruku»
	('doppler-neck-blood-vessels', NULL, NULL, NULL), -- «Color duplex scan karotidnih arterija»
	('doppler-abdominal-arteries-and-veins', NULL, NULL, NULL), -- «Color Duplex scan krvnih sudova trbuha»
	('ankle-brachial-index-by-doppler-ultrasound', NULL, NULL, NULL), -- «Pedo-brahijani ili ABI indeksi»
	('e-consultation-with-specialist', NULL, NULL, NULL), -- vaskularnahirurgija.me/online-konsultacije (2024-07): «poliklinika … nudi uslugu online medicinskih konsultacija» — у записи синонимы Online consultation
	('botox-injection', NULL, NULL, NULL), -- /antiaging/: «BOTOX tretmani»
	('hyaluronic-acid-filler', NULL, NULL, NULL), -- «HIJALURONSKI fileri»
	('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- «MEZOTERAPIJA» (раздел anti-aging лица)
	('dermapen-microneedling', NULL, NULL, NULL), -- «DERMAPEN tretmani»
	('biorevitalization', NULL, NULL, NULL), -- «BIOREVITALIZACIJA»
	('laser-hair-removal', NULL, NULL, NULL), -- /laserski-tretmani/: «LASERSKA MEDICINSKA TRAJNA EPILACIJA»
	('laser-tattoo-removal', NULL, NULL, NULL), -- «LASERSKO USKLANJANJE TRAJNE ŠMINKE, TETOVAŽA …» (НОВАЯ)
	('melasma-hyperpigmentation-laser', NULL, NULL, NULL), -- «… I PIGMENTACIJA SA KOŽE»
	('laser-skin-rejuvenation', NULL, NULL, NULL), -- «NEINVAZIVNO LASERSKO PODMLAĐIVANJE, ZATEZANJE I OSVJEŽAVANJE KOŽE» (НОВАЯ)
	('scar-correction', NULL, NULL, NULL), -- «NEINVAZIVNO LASERSKO UKLANJANJE OŽILJAKA …» — generic-запись, синоним «Uklanjanje ožiljaka»
	('stretch-mark-treatment', NULL, NULL, NULL), -- «… I STRIJA»
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- /protetika/: «Bezmetalne krunice … cirkonijom»
	('pressed-ceramic-crown', NULL, NULL, NULL), -- «Bezmetalne krunice … empresom» (press-keramika)
	('metal-ceramic-crown', NULL, NULL, NULL), -- «Metal-keramičke krunice»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- «Skeletirane proteze sa atačmentima»
	('partial-denture', NULL, NULL, NULL), -- «Parcijalne proteze»
	('complete-acrylic-denture', NULL, NULL, NULL), -- «Totalne ili akrilatne proteze»
	('radiowave-skin-lesion-removal', NULL, NULL, NULL), -- RU-пост 2023: «Безболезненное удаление кожных и подкожных образований радиочастотными волнами»
	('intra-articular-injection', NULL, NULL, NULL), -- RU-пост: «Ортопедия – минимально инвазивная терапия уколами для болезней суставов, связок и сухожилий»
	('urologist-examination', NULL, NULL, NULL), -- /urologija/: «Pregled urologa»
	('transrectal-prostate-echosonography', NULL, NULL, NULL), -- «Transrektalni ultrazvuk prostate»
	('trus-guided-prostate-biopsy', NULL, NULL, NULL), -- «Biospija prostate (TRUS biopsija prostate)»
	('abdomen-ultrasound', NULL, NULL, NULL), -- /radiologija/: «CDS / Ultrazvuk abdomena»; /urologija/: «Ultrazvuk abdomena»
	('thyroid-ultrasound', NULL, NULL, NULL), -- /radiologija/: «CDS / Ultrazvuk štitne žlijezde»; /endokrinologija/
	('cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound', NULL, NULL, NULL), -- /kardiologija/: «Redovan kardiološki pregled obuhvata snimanje … na višekanalnom EKG aparatu, ehokardiografiju …, pregled kardiologa»
	('professor-endocrinologist-examination', NULL, NULL, NULL), -- /endokrinologija/: «Pored kliničkog pregleda profesora endokrinologije …»
	('spirometry', NULL, NULL, NULL), -- /pulmologija/: «koristimo … spirometrije»
	('bronchodilator-test', NULL, NULL, NULL), -- «… bronhodilatatornih testova»
	('tuberculin-skin-test', NULL, NULL, NULL), -- «… PPD testova»
	('oncologist-examination', NULL, NULL, NULL), -- /onkologija-hematologija/: «U poliklinici … možete obaviti … Klinički pregled»
	('nutritionist-specialist-examination', NULL, NULL, NULL), -- /nutricionizam/: «Analiza kvaliteta ishrane, Savjetovanje»
	('personalized-nutrition-plan', NULL, NULL, NULL), -- «Program ishrane (jelovnik)»
	('body-composition-analysis', NULL, NULL, NULL); -- RU-пост: «оценка состава тела/процента жиров»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_fatic_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_fatic_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_fatic_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 23 = 17 + 6 (2e, nikola-fatic)
-- Только там, где сайт сам называет врача услуги/направления.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_fatic_doctor_services;
CREATE TEMPORARY TABLE tmp_fatic_doctor_services (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
);

INSERT INTO tmp_fatic_doctor_services (doctor_slug, service_slug) VALUES
	('nikola-fatic', 'vascular-surgeon-examination'),
	('nikola-fatic', 'laser-varicose-vein-surgery'),
	('nikola-fatic', 'sclerotherapy-veins'),
	('andjela-fatic', 'botox-injection'),
	('andjela-fatic', 'hyaluronic-acid-filler'),
	('andjela-fatic', 'facial-mesotherapy-single-treatment'),
	('andjela-fatic', 'dermapen-microneedling'),
	('andjela-fatic', 'biorevitalization'),
	('andjela-fatic', 'laser-hair-removal'),
	('andjela-fatic', 'laser-tattoo-removal'),
	('andjela-fatic', 'melasma-hyperpigmentation-laser'),
	('andjela-fatic', 'laser-skin-rejuvenation'),
	('andjela-fatic', 'scar-correction'),
	('andjela-fatic', 'stretch-mark-treatment'),
	('rade-stanisavljevic', 'urologist-examination'),
	('rade-stanisavljevic', 'transrectal-prostate-echosonography'),
	('rade-stanisavljevic', 'trus-guided-prostate-biopsy'),
	-- 2e, vaskularnahirurgija.me, 2026-10-09: диагностика и онлайн-консультации с персонального сайта dr Nikola Fatić
	('nikola-fatic', 'doppler-lower-extremity-blood-vessels'), -- 2e, vaskularnahirurgija.me, 2026-10-09: «Color duplex scan arterija i vena nogu i ruku»
	('nikola-fatic', 'doppler-upper-extremity-blood-vessels'), -- 2e, vaskularnahirurgija.me, 2026-10-09: то же
	('nikola-fatic', 'doppler-neck-blood-vessels'), -- 2e, vaskularnahirurgija.me, 2026-10-09: «Color duplex scan karotidnih arterija»
	('nikola-fatic', 'doppler-abdominal-arteries-and-veins'), -- 2e, vaskularnahirurgija.me, 2026-10-09: «Color Duplex scan krvnih sudova trbuha»
	('nikola-fatic', 'ankle-brachial-index-by-doppler-ultrasound'), -- 2e, vaskularnahirurgija.me, 2026-10-09: «Pedo-brahijani ili ABI indeksi»
	('nikola-fatic', 'e-consultation-with-specialist'); -- 2e, vaskularnahirurgija.me, 2026-10-09: «Online konsultacije»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО.
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_fatic_doctor_services t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_fatic_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 42, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 23 привязки врач↔услуга (nikola-fatic — 9). (2e: было 17)
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Новые записи каталога: ожидается 2 строк, у услуг — категория и специальность.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	GROUP_CONCAT(DISTINCT r.medical_service_category_id) AS categories,
	GROUP_CONCAT(DISTINCT s.specialty_id) AS specialties
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_services_specialties s ON s.medical_service_id = ms.id
WHERE ms.slug IN ('laser-tattoo-removal', 'laser-skin-rejuvenation')
GROUP BY ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_fatic_services;
DROP TEMPORARY TABLE IF EXISTS tmp_fatic_doctor_services;
