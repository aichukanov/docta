SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Dom zdravlja "Boško Dedeić" Mojkovac — medical certificates and sanitary examinations
-- Mode: addition. The main pricelist (274 services + 36 lab tests, PDF 02.10.2025) is already
--   in the DB and is NOT touched here; none of its 274 rows is a certificate or a sanitary exam
--   (checked locally and on prod via /api/services/list, 2026-10-02).
-- Sources (scans, no text layer, read from page renders):
--   1) https://dzmojkovac.me/wp-content/uploads/2019/03/cjenovnik_ljekarskih_uvjerenja.pdf
--      «ЦЈЕНОВНИК здравствених услуга које се пружају трећим лицима», број 1674, 24.05.2021, 2 pages
--      snapshot: data/clinic-pricelists/sources/dom-zdravlja-bosko-dedeic-mojkovac/2026-10-02.uvjerenja.pdf
--   2) https://dzmojkovac.me/wp-content/uploads/2019/03/Cjenovnik_za_sanitarne_preglede.pdf
--      «CJENOVNIK … (SANITARNI PREGLEDI)», broj 1115, 29.06.2016, 1 page
--      snapshot: data/clinic-pricelists/sources/dom-zdravlja-bosko-dedeic-mojkovac/2026-10-02.sanitarni.pdf
--   Both: HTTP Last-Modified 2022-04-28 (date of transfer to the site, not of the pricelist).
-- Price date: 24.05.2021 and 29.06.2016 (dates inside the documents)
--   → older than 2 years, every row gets is_price_outdated = 1
-- Collected: 2026-10-02
--
-- Source rows: 23 (20 certificates + 3 sanitary exams)
--   matched to existing catalog records: 23 (all by slug, all present on prod)
--   new catalog records: 0
--   price sum: 892.00 (certificates 825.00 + sanitary 67.00)
-- Codes: MO_UVJ_<nn> / MO_SAN_<n> = item number in the source document.
-- Item 1 (pre-employment, 20.00): the source adds «бесплатно*» — free with a certificate of
--   registration at the Employment Agency of Montenegro (Zavod za zapošljavanje). Stored as 20.00.
-- Record: data/clinic-imports/dom-zdravlja-bosko-dedeic-mojkovac.json
-- Idempotent: INSERT IGNORE on (clinic_id, medical_service_id); synonyms INSERT IGNORE.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-bosko-dedeic-mojkovac');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: MEDICAL SERVICES (prices)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, ms.id, p.price, NULL, NULL, p.code, 1
FROM (
	-- Љекарска увјерења (број 1674, 24.05.2021)
	          SELECT 'pre-employment-medical-certificate' AS slug, 20.00 AS price, 'MO_UVJ_01' AS code      -- 1. … о способности за рад, приликом заснивања радног односа (радна мјеста без повећаног ризика) 20,00€ (бесплатно*)
	UNION ALL SELECT 'medical-certificate-for-general-work', 35.00, 'MO_UVJ_02'                                -- 2. … при запошљавању и раду на радним мјестима без повећаног ризика и отежаним условима рада/предходни, периодични, ванредни
	UNION ALL SELECT 'medical-certificate-for-high-risk-and-difficult-working-conditions', 50.00, 'MO_UVJ_03'  -- 3. … са повећаним ризиком и отежаним условима рада предходни, периодични, ванредни/систематски
	UNION ALL SELECT 'medical-certificate-for-difficult-working-conditions-without-high-risk', 40.00, 'MO_UVJ_04' -- 4. … на радним мјестима са отежаним условима рада-предходни, периодични, ванредни
	UNION ALL SELECT 'medical-certificate-for-class-a-and-b-drivers', 30.00, 'MO_UVJ_05'                       -- 5. … /контролни здравствени преглед, за управљање моторним возилом у друмском саобраћају, А и Б категорија
	UNION ALL SELECT 'driver-class-c-d-e-health-examination', 40.00, 'MO_UVJ_06'                               -- 6. … /контролни здравствени преглед, за управљање моторним возилом у друмском саобраћају, Ц, Д и Е категорије спец.возила и такси возилом
	UNION ALL SELECT 'medical-certificate-for-driving-instructor-category-b-c-d-e', 60.00, 'MO_UVJ_07'         -- 7. … /контролни здравствени преглед за посао инструктора Б, Ц, Д и Е категорије
	UNION ALL SELECT 'medical-certificate-for-firearms-possession', 50.00, 'MO_UVJ_08'                         -- 8. … о подобности за посједовање ватреног оружја
	UNION ALL SELECT 'medical-certificate-for-military-service', 50.00, 'MO_UVJ_09'                            -- 9. … о способноси за обављање службе у Војсци Црне Горе
	UNION ALL SELECT 'medical-certificate-for-underage-marriage', 25.00, 'MO_UVJ_10'                           -- 10. … за склапање брака малољетне особе
	UNION ALL SELECT 'medical-certificate-for-child-adoption', 25.00, 'MO_UVJ_11'                              -- 11. … о подобности за усвајање дјетета
	UNION ALL SELECT 'medical-certificate-for-study-abroad-and-visa', 25.00, 'MO_UVJ_12'                       -- 12. … за даље школовање и боравак у иностранству
	UNION ALL SELECT 'medical-certificate-for-lifeguards-divers-and-boat-operators', 35.00, 'MO_UVJ_13'        -- 13. … за спасиоце, рониоце и управљање чамцем
	UNION ALL SELECT 'medical-certificate-for-maritime-workers', 110.00, 'MO_UVJ_14'                           -- 14. … за рад у воденом саобраћају (поморци)
	UNION ALL SELECT 'medical-certificate-for-ionizing-radiation-workers', 85.00, 'MO_UVJ_15'                  -- 15. … предходни и периодични преглед радника професионално изложених јонизирајућим зрачењима
	UNION ALL SELECT 'medical-certificate-for-court-expert', 35.00, 'MO_UVJ_16'                                -- 16. … за посао судског вјештака
	UNION ALL SELECT 'medical-certificate-for-life-insurance', 40.00, 'MO_UVJ_17'                              -- 17. … ради животног осигурања
	UNION ALL SELECT 'medical-certificate-for-collective-accommodation', 5.00, 'MO_UVJ_18'                     -- 18. … за колективни смјештај
	UNION ALL SELECT 'medical-certificate-for-athletes', 25.00, 'MO_UVJ_19'                                    -- 19. … за утврђивање здравствене способности спортисте
	UNION ALL SELECT 'medical-certificate-for-sports-referees', 40.00, 'MO_UVJ_20'                             -- 20. … за тренере, спортске судије и друге раднике у спорту
	-- Sanitarni pregledi (broj 1115, 29.06.2016)
	UNION ALL SELECT 'sanitary-examination-for-food-industry-and-water-supply-workers', 32.00, 'MO_SAN_1'      -- 1. Za zaposlene koji rade u proizvodnji i prometu hrane (ugostitelji, trgovci …), i na poslovima snadbijevanja građana vodom za piće
	UNION ALL SELECT 'sanitary-examination-for-healthcare-and-educational-workers', 20.00, 'MO_SAN_2'          -- 2. Za zaposlene koji rade u zdravstvenim ustanovama …, u preškolskim, školskim i drugim ustanovama, ustanovama za stara lica, u proizvodnji i prometu ljekova i prevozu hrane
	UNION ALL SELECT 'sanitary-examination-for-hairdressers-and-service-personnel', 15.00, 'MO_SAN_3'          -- 3. Za zaposlene koji rade na zdravstvenim pregledima u ambulantama i laboratorijama, … higijenske njege građana (frizerski i kozmetički saloni i dr.)
) AS p
JOIN medical_services ms ON ms.slug = p.slug;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: SYNONYMS (clinic wording the catalog did not cover)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ljekarsko uvjerenje za vozače C, D i E kategorije', 'sr' FROM medical_services WHERE slug = 'driver-class-c-d-e-health-examination'
UNION ALL SELECT id, 'Љекарско увјерење за возаче Ц, Д и Е категорије', 'sr-cyrl' FROM medical_services WHERE slug = 'driver-class-c-d-e-health-examination'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za trenere', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-sports-referees'
UNION ALL SELECT id, 'Љекарско увјерење за тренере', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-sports-referees'
UNION ALL SELECT id, 'Медицинская справка для тренеров', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-sports-referees'
UNION ALL SELECT id, 'Sanitarni pregled za frizerske i kozmetičke salone', 'sr' FROM medical_services WHERE slug = 'sanitary-examination-for-hairdressers-and-service-personnel'
UNION ALL SELECT id, 'Санитарни преглед за фризерске и козметичке салоне', 'sr-cyrl' FROM medical_services WHERE slug = 'sanitary-examination-for-hairdressers-and-service-personnel'
UNION ALL SELECT id, 'Санитарный осмотр для косметологов', 'ru' FROM medical_services WHERE slug = 'sanitary-examination-for-hairdressers-and-service-personnel'
UNION ALL SELECT id, 'Sanitarni pregled za zaposlene u vrtićima i školama', 'sr' FROM medical_services WHERE slug = 'sanitary-examination-for-healthcare-and-educational-workers'
UNION ALL SELECT id, 'Санитарни преглед за запослене у вртићима и школама', 'sr-cyrl' FROM medical_services WHERE slug = 'sanitary-examination-for-healthcare-and-educational-workers';

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: one row, the clinic id on this database (127 locally and on prod as of 2026-10-02)
SELECT @clinic_id AS clinic_id;

-- expected: added = 23, outdated = 23, sum = 892.00
SELECT COUNT(*) AS added, SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum
FROM clinic_medical_services
WHERE clinic_id = @clinic_id AND (code LIKE 'MO\_UVJ\_%' OR code LIKE 'MO\_SAN\_%');

-- expected: total = 297 (274 from the main pricelist + 23), main pricelist untouched (outdated = 0 among the rest)
SELECT COUNT(*) AS total,
	SUM(is_price_outdated AND code NOT LIKE 'MO\_UVJ\_%' AND code NOT LIKE 'MO\_SAN\_%') AS main_outdated
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT cms.code, ms.slug, cms.price, cms.is_price_outdated
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id AND (cms.code LIKE 'MO\_UVJ\_%' OR cms.code LIKE 'MO\_SAN\_%')
ORDER BY cms.code;

-- expected: 10 rows
SELECT ms.slug, s.language, s.another_name
FROM medical_service_synonyms s JOIN medical_services ms ON ms.id = s.medical_service_id
WHERE ms.slug IN ('driver-class-c-d-e-health-examination', 'medical-certificate-for-sports-referees',
	'sanitary-examination-for-hairdressers-and-service-personnel', 'sanitary-examination-for-healthcare-and-educational-workers')
	AND s.another_name IN ('Ljekarsko uvjerenje za vozače C, D i E kategorije', 'Љекарско увјерење за возаче Ц, Д и Е категорије',
		'Ljekarsko uvjerenje za trenere', 'Љекарско увјерење за тренере', 'Медицинская справка для тренеров',
		'Sanitarni pregled za frizerske i kozmetičke salone', 'Санитарни преглед за фризерске и козметичке салоне',
		'Санитарный осмотр для косметологов', 'Sanitarni pregled za zaposlene u vrtićima i školama',
		'Санитарни преглед за запослене у вртићима и школама');
