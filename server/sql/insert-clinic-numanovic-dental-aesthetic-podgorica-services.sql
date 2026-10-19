-- ═══════════════════════════════════════════════════════════════════════════
-- Numanović Dental & Aesthetic (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-numanovic-dental-aesthetic-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-numanovic-dental-aesthetic-podgorica-services.sql
--
-- Источник: https://drnumanovic.me/ — /usluge/, /o-nama/ и 10 страниц /services/<направление>/ (по одной фразе), curl 2026-10-09.
-- Прайса нет; все позиции price = NULL. Заведены только процедуры, прямо названные во фразах направлений.
--
-- Итого: 11 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ73Ry4dXrTRMRm2ShmpTyQfc' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'numanovic-dental-aesthetic-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-numanovic-dental-aesthetic-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (11)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_nmd_services;
CREATE TEMPORARY TABLE tmp_x_nmd_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_nmd_services (slug, price, price_min, price_max) VALUES
	('dental-consultation', NULL, NULL, NULL), -- /o-nama/ «Opšta stomatologija — Pregledi, dijagnostika i opšta stomatološka terapija»; /services/opsta-stomatologija/: «Preventivni pregledi, dijagnostika»; /tim/: «Zakažite konsultaciju»
	('dental-caries-treatment', NULL, NULL, NULL), -- /services/lijecenje-karijesa/: «Savremeno liječenje karijesa …»
	('composite-filling', NULL, NULL, NULL), -- /services/lijecenje-karijesa/: «… i estetske kompozitne restauracije»
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- /services/endodoncija/: «Dijagnostika i liječenje kanala korijena zuba» — число каналов не названо
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- /services/parodontologija/: «Prevencija i terapija oboljenja desni i potpornog aparata zuba»
	('complete-dental-cleaning', NULL, NULL, NULL), -- /services/profesionalno-ciscenje-zuba/: «Profesionalno uklanjanje zubnog kamenca, naslaga i pigmentacija» — kamenac + naslage + pigmentacije = полная чистка
	('teeth-whitening', NULL, NULL, NULL), -- /services/izbjeljivanje-zuba/: «Profesionalno izbjeljivanje zuba uz prethodnu procjenu stanja zuba i desni» — метод не назван
	('aesthetic-tooth-restoration', NULL, NULL, NULL), -- /services/estetska-stomatologija/: «Individualno planiranje osmijeha, estetske restauracije i protetska rješenja»
	('dental-implant-placement', NULL, NULL, NULL), -- /services/implantologija/: «Planiranje implantološke terapije i protetske nadoknade zuba»; /usluge/: «Implantologija»
	('pediatric-dentist-consultation', NULL, NULL, NULL); -- /o-nama/ «Dječja stomatologija — Preventivna i terapijska stomatološka njega za djecu»; /services/djecja-stomatologija/: «preventivni pregledi i terapija prilagođena uzrastu djeteta»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_nmd_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_nmd_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_nmd_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Врач заведён по косвенным признакам; кто какие услуги выполняет — неизвестно → привязок нет (решение координатора).
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 11, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_x_nmd_services;