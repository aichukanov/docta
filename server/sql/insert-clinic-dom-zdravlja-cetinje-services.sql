-- ═══════════════════════════════════════════════════════════════════════════
-- JZU Dom zdravlja Cetinje — услуги и цены
-- Run (после insert-clinic-dom-zdravlja-cetinje.sql):
--   mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-cetinje-services.sql
--
-- Цены — два скана CamScanner без текстового слоя, прочитаны с рендера страниц:
--   * Cjenovnik_i_saglasnost.pdf — «CJENOVNIK ZA PRUŽANJE USLUGA IZDAVANJA
--     LJEKARSKIH UVJERENJA», akt br. 2346 od 08.06.2021, stupio na snagu
--     09.06.2021, saglasnost MZ br. 1-501/21-1867/4 od 07.06.2021. 20 строк:
--     19 цен 5–70 € + 1 «besplatno» (1b — то же uvjerenje 1a за счёт ОМС).
--   * Cjenovnik_zdravstvenih_usluga_za_Hemodijalizu_za_strance_m.pdf — br. 2905
--     od 26.07.2021, stupio na snagu 29.07.2021; 3 позиции по 160 € (V01007,
--     V01001, V01008). Цена включает диализатор, санитарный материал и
--     санитарный транспорт; только для иностранцев (čl. 1, 5, 7).
-- is_price_outdated не ставится (решение юзера 2026-10-08), дата прайса — в записи импорта.
-- Записи каталога только существующие; клиника резолвится по google_place_id/slug.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ49c5O17OTRMRuU4JnVePgbc' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-cetinje' LIMIT 1));

-- Новых записей каталога нет (правило подволны 2b для ДЗ): только существующие slug.
DROP TEMPORARY TABLE IF EXISTS tmp_dzf_cetinje_services;
CREATE TEMPORARY TABLE tmp_dzf_cetinje_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dzf_cetinje_services (slug, price, code) VALUES
-- ── Cjenovnik ljekarskih uvjerenja 2021 ──
('pre-employment-medical-certificate', 20.00, NULL), -- 1a) sposobnosti za rad prilikom zasnivanja radnog odnosa (radna mjesta bez povećanih rizika) — 20,00 (1b: isto uvjerenje na teret obaveznog zdravstvenog osiguranja — besplatno)
('medical-certificate-for-general-work', 20.00, NULL), -- 2a) sposobnosti za rad pri zapošljavanju i radu na radnim mjestima bez povećanih rizika i otežanim uslovima rada — prethodni/periodični vanredni — 20,00
('medical-certificate-for-high-risk-and-difficult-working-conditions', 50.00, NULL), -- 2b) … na radnim mjestima sa povećanim rizikom i otežanim uslovima rada — prethodni/periodični/vanredni/sistematski — 50,00
('medical-certificate-for-difficult-working-conditions-without-high-risk', 35.00, NULL), -- 2c) … na radnim mjestima sa otežanim uslovima rada — prethodni/periodični/vanredni — 35,00
('medical-certificate-for-driving-license-category-a-b-c-d-e', 20.00, NULL), -- 3a) sposobnosti/kontrolni zdravstveni pregled, za upravljanje motornim vozilima u drumskom saobraćaju, A, B, C, D i E kategorije /vozači amateri/ — 20,00
('medical-certificate-for-driving-license-renewal-category-a-b-c-d-e', 20.00, NULL), -- 3a) … /kontrolni zdravstveni pregled … A, B, C, D i E kategorije — 20,00 (ista stavka kao gore)
('medical-certificate-for-professional-drivers', 40.00, NULL), -- 3b) sposobnosti/kontrolni zdravstveni pregled, za upravljanje motornim vozilom u drumskom saobraćaju, C, D i E kategorije, specijalnim vozilima — 40,00
('medical-certificate-for-driving-instructor-category-b-c-d-e', 40.00, NULL), -- 3b) … i za posao instruktora B, C, D i E kategorije — 40,00 (ista stavka)
('medical-certificate-for-taxi-driver', 30.00, NULL), -- 3c) sposobnosti/kontrolni zdravstveni pregled, za upravljanje taxi vozilima — 30,00
('medical-certificate-for-firearms-possession', 35.00, NULL), -- 4. Ljekarsko uvjerenje o podobnosti za posjedovanje vatrenog oružja — 35,00
('medical-certificate-for-military-service', 40.00, NULL), -- 5. Ljekarsko uvjerenje o sposobnosti za obavljanje službe u Vojsci Crne Gore — 40,00
('medical-certificate-for-underage-marriage', 25.00, NULL), -- 6. Ljekarsko uvjerenje za sklapanje braka za maloljetne osobe — 25,00
('medical-certificate-for-child-adoption', 25.00, NULL), -- 7. Ljekarsko uvjerenje za podobnost za usvajanje djeteta — 25,00
('medical-certificate-for-study-abroad-and-visa', 25.00, NULL), -- 8. Ljekarsko uvjerenje za dalji nastavak školovanja i boravak u inostranstvu/viza — 25,00
('medical-certificate-for-maritime-workers', 70.00, NULL), -- 9a) Ljekarsko uvjerenje za rad u vodenom saobraćaju/(pomorci) — 70,00
('medical-certificate-for-lifeguards-divers-and-boat-operators', 35.00, NULL), -- 9b) Ljekarsko uvjerenje za spasioce/ronioce/upravljanje čamcem — 35,00
('medical-certificate-for-court-expert', 35.00, NULL), -- 10. Ljekarsko uvjerenja za posao sudskog vještaka — 35,00
('medical-certificate-for-life-insurance', 40.00, NULL), -- 11. Ljekarsko uvjerenje radi životnog osiguranja — 40,00
('medical-certificate-for-collective-accommodation', 5.00, NULL), -- 12. Ljekarsko uvjerenje za kolektivni smještaj — 5,00
('medical-certificate-for-athletes', 50.00, NULL), -- 13. Ljekarsko uvjerenje za utvrđivanje zdravstvene sposobnosti sprotiste — 50,00
('medical-certificate-for-sports-referees-and-other-purposes', 60.00, NULL), -- 14. Ljekarsko uvjerenje za druge potrebe (sposrtske sudije i dr.) — 60,00
-- ── Cjenovnik hemodijalize za strance 2021 ──
('urgent-hemodialysis', 160.00, 'V01007'), -- V01007 Intermitentna zamjena bubrežne funkcije – Urgentna hemodijaliza — 160,00
('chronic-hemodialysis-session', 160.00, 'V01001'), -- V01001 Intermitentna zamjena bubrežne funkcije – Hronična hemodijaliza — 160,00
('peritoneal-dialysis', 160.00, 'V01008'), -- V01008 Intermitentna zamjena bubrežne funkcije – Peritineumska dijaliza — 160,00
-- ── timovi-izabranih-doktora ──
('general-practitioner-examination', NULL, NULL), -- Timovi izabranih doktora — Odrasli
('pediatric-examination', NULL, NULL), -- Timovi izabranih doktora — Djeca
('gynecological-specialist-examination', NULL, NULL), -- Timovi izabranih doktora — Žene: dr Aleksandra Perišić, spec. ginekologije i akušerstva
('subcutaneous-or-intramuscular-injection', NULL, NULL); -- Injekciona ambulanta — Radojka Gardašević, med. sestra

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service FROM tmp_dzf_cetinje_services t LEFT JOIN medical_services ms ON ms.slug = t.slug WHERE ms.id IS NULL;

-- is_price_outdated не ставится (решение юзера 2026-10-08).
INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, NULL, NULL, t.code
FROM tmp_dzf_cetinje_services t JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max), code = VALUES(code);

-- Самоисправление: услуги клиники, которых больше нет в списке.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dzf_cetinje_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════
-- Ожидается 28 услуг, с ценой 24, сумма цен 1200.00, лабораторных анализов 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL) AS with_price, SUM(price) AS price_sum,
	(SELECT COUNT(*) FROM clinic_lab_tests WHERE clinic_id = @clinic_id) AS lab_tests
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_dzf_cetinje_services;
