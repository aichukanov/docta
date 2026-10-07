SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- JZU Dom zdravlja Glavnog grada (Podgorica) — own self-pay prices: medicina rada + sports medicine
-- Mode: new pricelist. The clinic had 0 services locally and on prod (checked /api/services/list, 2026-10-02).
-- Sources:
--   1) https://www.dzpg.me/medicina-rada/ — HTML, «CJENOVNIK usluga i pregleda iz oblasti Medicine rada»,
--      adopted by Odbor direktora 08.07.2021; page dateModified 2026-04-30 (yoast schema), datePublished 2016-07-30.
--      30 numbered items, item 2 has sub-items a)–g): 36 prices «NN,00 eur-a».
--      Note under the list: «JZU Dom zdravlja Podgorica zadržava pravo da odobri popust do 30%».
--      snapshot: data/clinic-pricelists/sources/dom-zdravlja-podgorica/2026-10-02.medicina-rada.html
--   2) https://www.dzpg.me/wp-content/uploads/2025/09/cjenovnik.pdf — scan, «ODLUKA o usvajanju cijena za
--      utvrdjivanje zdravstvene sposobnosti sportista, sportskih sudija i trenera», Broj 05/16-253/2, 15.01.2025
--      (Last-Modified 2025-09-28). 3 prices: athletes under 18 — 10, over 18 — 15, referees and coaches — 30.
--      snapshot: data/clinic-pricelists/sources/dom-zdravlja-podgorica/2026-10-02.sportska-medicina-cjenovnik.pdf
-- Price date: 08.07.2021 (medicina rada, adoption date in the page text; page dateModified 2026-04-30)
--   and 15.01.2025 (sport, date of the Odluka). The medicina rada list is older than 2 years, but there is
--   no evidence its prices are stale: the live page still publishes it as the current list, and in 2025
--   the clinic revised only the sport prices (item 26 at the same 30.00) and left this list as is.
--   is_price_outdated = 0 on every row, by the user's decision (2026-10-02).
-- The 2025 Odluka supersedes medicina rada items 25 (athletes, 20.00) and 26 (referees/coaches, 30.00):
--   item 25 is not imported, both sport rows come from the Odluka.
-- Collected: 2026-10-02
--
-- Source prices: 39 (36 medicina rada + 3 sport); imported: 37 (items 25 and 26 replaced by the Odluka),
--   as 38 clinic rows (items 10 and 20 each name two certificates under one price → two rows, one code)
--   matched to existing catalog records: 22 rows (all by slug, all present on prod with the same name_en)
--   catalog records in PART 1: 16 — 14 new, plus medical-certificate-copy and
--   medical-certificate-for-social-care-institution-accommodation, created by the Nasa medicina import
--   (identical rows, already applied locally and on prod as of 2026-10-02)
-- Item 16 (ustanove socijalne zaštite) is NOT the elderly-home certificate (7852): social care institutions
--   are broader — same decision as for Nasa medicina. Item 24 (državljanstvo, stalni boravak) is NOT 4541
--   (temporary residence and work): the permanent residence / citizenship check is likely a longer list.
--   is_price_outdated = 1: 0 rows (see «Price date» above); price sum: 1640.00 (medicina rada 1600.00 + sport 40.00)
-- Codes: PG_MR_<nn> = item number on /medicina-rada/ (02a…02g — sub-items), PG_SP_<n> = item in the Odluka.
-- Record: data/clinic-imports/dom-zdravlja-podgorica.json
-- Idempotent: catalog ON DUPLICATE KEY (name_en / slug), everything else INSERT IGNORE.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-podgorica');

SET @cat_general_medicine = 9;
SET @spec_general_medicine = 45;
SET @spec_occupational_medicine = 50;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: NEW CATALOG RECORDS (no match in the catalog, checked locally and on prod)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Medical Certificate for Work at Height', 'medical-certificate-for-work-at-height',
	'Ljekarsko uvjerenje za rad na visini', 'Љекарско увјерење за рад на висини',
	'Медицинская справка для работы на высоте', 'Ärztliches Attest für Arbeiten in der Höhe', 'Yüksekte çalışma için sağlık raporu'),
('Medical Certificate for Work with Noise and Vibration Exposure', 'medical-certificate-for-work-with-noise-and-vibration-exposure',
	'Ljekarsko uvjerenje za rad u uslovima buke i vibracija', 'Љекарско увјерење за рад у условима буке и вибрација',
	'Медицинская справка для работы в условиях шума и вибрации', 'Ärztliches Attest für Arbeiten unter Lärm- und Vibrationsbelastung', 'Gürültü ve titreşimli ortamda çalışma için sağlık raporu'),
('Medical Certificate for Work with Chemical and Dust Exposure', 'medical-certificate-for-work-with-chemical-and-dust-exposure',
	'Ljekarsko uvjerenje za rad izložen hemijskim materijama, gasovima i prašini', 'Љекарско увјерење за рад изложен хемијским материјама, гасовима и прашини',
	'Медицинская справка для работы с химическими веществами, газами и пылью', 'Ärztliches Attest für Arbeiten mit Chemikalien-, Gas- und Staubbelastung', 'Kimyasal madde, gaz ve toza maruz çalışma için sağlık raporu'),
('Medical Certificate for Forklift and Construction Machinery Operators', 'medical-certificate-for-forklift-and-construction-machinery-operators',
	'Ljekarsko uvjerenje za rukovaoce građevinskih mašina, viljuškara i dizalica', 'Љекарско увјерење за руковаоце грађевинских машина, виљушкара и дизалица',
	'Медицинская справка для операторов погрузчиков, кранов и строительной техники', 'Ärztliches Attest für Bediener von Gabelstaplern, Kranen und Baumaschinen', 'Forklift, vinç ve iş makinesi operatörleri için sağlık raporu'),
('Medical Certificate for Work with Non-Ionizing Radiation Exposure', 'medical-certificate-for-work-with-non-ionizing-radiation-exposure',
	'Ljekarsko uvjerenje za rad izložen nejonizujućem zračenju', 'Љекарско увјерење за рад изложен нејонизујућем зрачењу',
	'Медицинская справка для работы с неионизирующим излучением', 'Ärztliches Attest für Arbeiten mit nichtionisierender Strahlung', 'İyonlaştırıcı olmayan radyasyona maruz çalışma için sağlık raporu'),
('Medical Certificate for Heavy Physical Work', 'medical-certificate-for-heavy-physical-work',
	'Ljekarsko uvjerenje za srednje težak i težak fizički rad', 'Љекарско увјерење за средње тежак и тежак физички рад',
	'Медицинская справка для среднетяжёлого и тяжёлого физического труда', 'Ärztliches Attest für mittelschwere und schwere körperliche Arbeit', 'Orta ağır ve ağır bedensel iş için sağlık raporu'),
('Medical Certificate for Work in Adverse Microclimate Conditions', 'medical-certificate-for-work-in-adverse-microclimate-conditions',
	'Ljekarsko uvjerenje za rad u nepovoljnim mikroklimatskim uslovima', 'Љекарско увјерење за рад у неповољним микроклиматским условима',
	'Медицинская справка для работы в неблагоприятных микроклиматических условиях', 'Ärztliches Attest für Arbeiten unter ungünstigen mikroklimatischen Bedingungen', 'Olumsuz mikroklima koşullarında çalışma için sağlık raporu'),
('Medical Certificate for Ionizing Radiation Workers with Chromosomal Aberration Test', 'medical-certificate-for-ionizing-radiation-workers-with-chromosomal-aberration-test',
	'Ljekarsko uvjerenje za rad u zoni jonizujućeg zračenja sa analizom hromozomskih aberacija', 'Љекарско увјерење за рад у зони јонизујућег зрачења са анализом хромозомских аберација',
	'Медицинская справка для работы с ионизирующим излучением с анализом хромосомных аберраций', 'Ärztliches Attest für strahlenexponierte Beschäftigte mit Chromosomenaberrationsanalyse', 'Kromozom aberasyonu analiziyle iyonlaştırıcı radyasyon çalışanları için sağlık raporu'),
('Medical Certificate for Unarmed Security Personnel', 'medical-certificate-for-unarmed-security-personnel',
	'Ljekarsko uvjerenje za rad u obezbjeđenju bez nošenja oružja', 'Љекарско увјерење за рад у обезбјеђењу без ношења оружја',
	'Медицинская справка для охранников без оружия', 'Ärztliches Attest für Sicherheitspersonal ohne Waffe', 'Silahsız güvenlik personeli için sağlık raporu'),
('Medical Certificate for Traffic School Enrollment', 'medical-certificate-for-traffic-school-enrollment',
	'Ljekarsko uvjerenje za upis u srednju školu saobraćajnog smjera', 'Љекарско увјерење за упис у средњу школу саобраћајног смјера',
	'Медицинская справка для поступления в транспортную среднюю школу', 'Ärztliches Attest für die Aufnahme an einer Verkehrsfachschule', 'Ulaştırma meslek lisesine kayıt için sağlık raporu'),
('Medical Certificate for Firefighters', 'medical-certificate-for-firefighters',
	'Ljekarsko uvjerenje za posao vatrogasca', 'Љекарско увјерење за посао ватрогасца',
	'Медицинская справка для пожарных', 'Ärztliches Attest für Feuerwehrleute', 'İtfaiyeciler için sağlık raporu'),
('Medical Certificate for Citizenship and Permanent Residence', 'medical-certificate-for-citizenship-and-permanent-residence',
	'Ljekarsko uvjerenje za dobijanje državljanstva i stalnog boravka', 'Љекарско увјерење за добијање држављанства и сталног боравка',
	'Медицинская справка для получения гражданства и ПМЖ', 'Ärztliches Attest für Einbürgerung und Daueraufenthalt', 'Vatandaşlık ve daimi oturma izni için sağlık raporu'),
-- the next two rows are identical to insert-clinic-prices-nasa-medicina-podgorica.sql
-- (already applied locally and on prod as of 2026-10-02): here they are a no-op
('Medical Certificate for Social Care Institution Accommodation', 'medical-certificate-for-social-care-institution-accommodation', 'Ljekarsko uvjerenje za smještaj u ustanove socijalne zaštite', 'Љекарско увјерење за смјештај у установе социјалне заштите', 'Медицинская справка для размещения в учреждении социальной защиты', 'Ärztliches Attest für die Unterbringung in einer Sozialeinrichtung', 'Sosyal hizmet kurumuna yerleşim için sağlık raporu'),
('Medical Certificate Copy','medical-certificate-copy', 'Prepis ljekarskog uvjerenja', 'Препис љекарског увјерења', 'Копия медицинской справки', 'Abschrift eines ärztlichen Attests', 'Sağlık raporu sureti'),
('Comprehensive Health Checkup for Women', 'comprehensive-health-checkup-for-women',
	'Sistematski pregled za žene', 'Систематски преглед за жене',
	'Комплексное медицинское обследование для женщин', 'Umfassende Gesundheitsuntersuchung für Frauen', 'Kadınlar için kapsamlı sağlık kontrolü'),
('Comprehensive Health Checkup for Men', 'comprehensive-health-checkup-for-men',
	'Sistematski pregled za muškarce', 'Систематски преглед за мушкарце',
	'Комплексное медицинское обследование для мужчин', 'Umfassende Gesundheitsuntersuchung für Männer', 'Erkekler için kapsamlı sağlık kontrolü')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- Category GENERAL_MEDICINE, as every other medical certificate in the catalog
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_general_medicine FROM medical_services WHERE slug IN (
	'medical-certificate-for-work-at-height',
	'medical-certificate-for-work-with-noise-and-vibration-exposure',
	'medical-certificate-for-work-with-chemical-and-dust-exposure',
	'medical-certificate-for-forklift-and-construction-machinery-operators',
	'medical-certificate-for-work-with-non-ionizing-radiation-exposure',
	'medical-certificate-for-heavy-physical-work',
	'medical-certificate-for-work-in-adverse-microclimate-conditions',
	'medical-certificate-for-ionizing-radiation-workers-with-chromosomal-aberration-test',
	'medical-certificate-for-unarmed-security-personnel',
	'medical-certificate-for-traffic-school-enrollment',
	'medical-certificate-for-firefighters',
	'medical-certificate-for-citizenship-and-permanent-residence',
	'medical-certificate-for-social-care-institution-accommodation',
	'medical-certificate-copy',
	'comprehensive-health-checkup-for-women',
	'comprehensive-health-checkup-for-men'
);

-- GENERAL_MEDICINE + OCCUPATIONAL_MEDICINE, as the 78xx certificates of DZ Bijelo Polje
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT ms.id, sp.specialty_id
FROM medical_services ms
CROSS JOIN (SELECT @spec_general_medicine AS specialty_id UNION ALL SELECT @spec_occupational_medicine) AS sp
WHERE ms.slug IN (
	'medical-certificate-for-work-at-height',
	'medical-certificate-for-work-with-noise-and-vibration-exposure',
	'medical-certificate-for-work-with-chemical-and-dust-exposure',
	'medical-certificate-for-forklift-and-construction-machinery-operators',
	'medical-certificate-for-work-with-non-ionizing-radiation-exposure',
	'medical-certificate-for-heavy-physical-work',
	'medical-certificate-for-work-in-adverse-microclimate-conditions',
	'medical-certificate-for-ionizing-radiation-workers-with-chromosomal-aberration-test',
	'medical-certificate-for-unarmed-security-personnel',
	'medical-certificate-for-traffic-school-enrollment',
	'medical-certificate-for-firefighters',
	'medical-certificate-for-citizenship-and-permanent-residence',
	'comprehensive-health-checkup-for-women',
	'comprehensive-health-checkup-for-men'
);

-- the two records shared with the Nasa medicina file: GENERAL_MEDICINE only, as there
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_general_medicine FROM medical_services
WHERE slug IN ('medical-certificate-copy', 'medical-certificate-for-social-care-institution-accommodation');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC PRICES
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, ms.id, p.price, NULL, p.price_max, p.code, p.outdated
FROM (
	-- Medicina rada, Odbor direktora 08.07.2021
	          SELECT 'medical-certificate-for-general-work' AS slug, 20.00 AS price, NULL AS price_max, 'PG_MR_01' AS code, 0 AS outdated -- 1. … za rad na radnim mjestima bez povećanog rizika - opšta zdravstvena sposobnost 20,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-work-at-height', 50.00, NULL, 'PG_MR_02a', 0                                     -- 2a) Radna mjesta sa radom na visini 50,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-work-with-noise-and-vibration-exposure', 50.00, NULL, 'PG_MR_02b', 0             -- 2b) … sa radom u uslovima buke, vibracija (opšte - lokalne) 50,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-work-with-chemical-and-dust-exposure', 45.00, NULL, 'PG_MR_02c', 0               -- 2c) … izložena uticaju hemijskih materija, gasova, prašine (fibrozogena i nefibrozogena) 45,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-forklift-and-construction-machinery-operators', 35.00, NULL, 'PG_MR_02d', 0      -- 2d) … unutrašnjeg transporta (rukovaoci građevinskih mašina, vozači viljuškara, dizalica) 35,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-work-with-non-ionizing-radiation-exposure', 50.00, NULL, 'PG_MR_02e', 0          -- 2e) … izložena uticaju nejonizujućeg zračenja 50,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-heavy-physical-work', 35.00, NULL, 'PG_MR_02f', 0                                -- 2f) … srednje težak i težak fizički rad 35,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-work-in-adverse-microclimate-conditions', 35.00, NULL, 'PG_MR_02g', 0            -- 2g) … nepovoljnim mikroklimatskim - nehigijenskim uslovima, prisustvu vlage i isparenja 35,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-ionizing-radiation-workers-with-chromosomal-aberration-test', 185.00, NULL, 'PG_MR_03', 0 -- 3. … u zoni jonizujućeg zračenja - sa hromozomskim aberacijama (prethodni i periodični svake 3. godine) 185,00
	UNION ALL SELECT 'medical-certificate-for-ionizing-radiation-workers', 85.00, NULL, 'PG_MR_04', 0                          -- 4. … u zoni jonizujućeg zračenja - bez hromozomskih aberacija (periodični pregled) 85,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-military-service', 50.00, NULL, 'PG_MR_05', 0                                    -- 5. … za obavljanje službe u Vojsci Crne Gore 50,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-security-personnel', 50.00, NULL, 'PG_MR_06', 0                                  -- 6. … za rad u obezbjeđenju uz nošenje oružja — zaštitari 50,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-unarmed-security-personnel', 35.00, NULL, 'PG_MR_07', 0                          -- 7. … za rad u obezbjeđenju bez nošenje oružja — portiri 35,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-class-a-and-b-drivers', 20.00, NULL, 'PG_MR_08', 0                               -- 8. … motornim vozilima A, B kategorije - amateri (polaganje vozačkog ispita i produženje vozačke dozvole) 20,00
	UNION ALL SELECT 'medical-certificate-for-professional-drivers', 40.00, NULL, 'PG_MR_09', 0                                -- 9. … motornim vozilima B, C, E, D kategorije profesionalci 40,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-driving-instructor-category-b-c-d-e', 30.00, NULL, 'PG_MR_10', 0                 -- 10. … za posao instruktora za obuku vozača i vozači taksi vozila 30,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-taxi-driver', 30.00, NULL, 'PG_MR_10', 0                                         -- 10. (same item, second certificate)
	UNION ALL SELECT 'medical-certificate-for-traffic-school-enrollment', 25.00, NULL, 'PG_MR_11', 0                           -- 11. … za upis u srednju školu - saobraćajnog smjera 25,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-university-enrollment', 15.00, NULL, 'PG_MR_12', 0                               -- 12. … za upis na fakultet 15,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-study-abroad-and-visa', 25.00, NULL, 'PG_MR_13', 0                               -- 13. … za odlazak na školovanje i boravak u inostranstvu, izdavanje vize 25,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-child-adoption', 25.00, NULL, 'PG_MR_14', 0                                      -- 14. … za usvajanje djeteta, starateljstvo 25,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-underage-marriage', 25.00, NULL, 'PG_MR_15', 0                                   -- 15. … za sklapanje braka maloljetnih lica 25,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-social-care-institution-accommodation', 20.00, NULL, 'PG_MR_16', 0                 -- 16. … za smještaj u ustanove socijalne zaštite 20,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-firearms-possession', 30.00, NULL, 'PG_MR_17', 0                                 -- 17. … o podobnosti fizičkog lica za posjedovanja vatrenog oružja 30,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-maritime-workers', 100.00, NULL, 'PG_MR_18', 0                                   -- 18. … za rad u vodenom saobraćaju — pomorci 100,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-boat-operation-up-to-12-meters', 35.00, NULL, 'PG_MR_19', 0                      -- 19. … za upravljanje čamcem 35,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-lifeguards', 30.00, NULL, 'PG_MR_20', 0                                          -- 20. … za posao spasioca i ronioca 30,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-divers', 30.00, NULL, 'PG_MR_20', 0                                              -- 20. (same item, second certificate)
	UNION ALL SELECT 'medical-certificate-for-firefighters', 50.00, NULL, 'PG_MR_21', 0                                        -- 21. … za posao vatrogasca 50,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-life-insurance', 20.00, NULL, 'PG_MR_22', 0                                      -- 22. … za životno osiguranje 20,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-court-expert', 35.00, NULL, 'PG_MR_23', 0                                        -- 23. … za posao sudskog vještaka 35,00 eur-a
	UNION ALL SELECT 'medical-certificate-for-citizenship-and-permanent-residence', 30.00, NULL, 'PG_MR_24', 0                 -- 24. … za dobijanje državljanstva, stalnog boravka u CG 30,00 eur-a
	-- 25. sportisti 20,00 and 26. sportske sudije, treneri 30,00 — superseded by the Odluka of 15.01.2025 below
	UNION ALL SELECT 'color-sensitivity-test-with-anomaloscope', 20.00, NULL, 'PG_MR_27', 0                                    -- 27. Pregled kolornog vida - anomaloskop (AQ koeficijent) 20,00 eur-a
	UNION ALL SELECT 'medical-certificate-copy', 10.00, NULL, 'PG_MR_28', 0                                               -- 28. Izdavanje duplikata uvjerenja 10,00 eur-a
	UNION ALL SELECT 'comprehensive-health-checkup-for-women', 120.00, NULL, 'PG_MR_29', 0                                     -- 29. Sistematski pregled za žene 120,00 eur-a
	UNION ALL SELECT 'comprehensive-health-checkup-for-men', 110.00, NULL, 'PG_MR_30', 0                                       -- 30. Sistematski pregled za muškarce 110,00 eur-a
	-- Sportska medicina, Odluka 05/16-253/2 od 15.01.2025
	UNION ALL SELECT 'medical-certificate-for-athletes', 10.00, 15.00, 'PG_SP_1-2', 0                                          -- ljekarsko uvjerenje … sportista do 18 godina 10,00 e. / preko 18 godina 15,00 e.
	UNION ALL SELECT 'medical-certificate-for-sports-referees', 30.00, NULL, 'PG_SP_3', 0                                      -- ljekarsko uvjerenje … sportskih sudija i trenera 30,00 e
) AS p
JOIN medical_services ms ON ms.slug = p.slug;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: SYNONYMS (clinic wording the catalog did not cover)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Ljekarsko uvjerenje o opštoj zdravstvenoj sposobnosti', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-general-work'
UNION ALL SELECT id, 'Љекарско увјерење о општој здравственој способности', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-general-work'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za vozače amatere', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-class-a-and-b-drivers'
UNION ALL SELECT id, 'Љекарско увјерење за возаче аматере', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-class-a-and-b-drivers'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za zaštitare', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-security-personnel'
UNION ALL SELECT id, 'Љекарско увјерење за заштитаре', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-security-personnel'
UNION ALL SELECT id, 'Медицинская справка для охранника с оружием', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-security-personnel'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za portire', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-unarmed-security-personnel'
UNION ALL SELECT id, 'Љекарско увјерење за портире', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-unarmed-security-personnel'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za vozače viljuškara', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-forklift-and-construction-machinery-operators'
UNION ALL SELECT id, 'Љекарско увјерење за возаче виљушкара', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-forklift-and-construction-machinery-operators'
UNION ALL SELECT id, 'Медицинская справка для водителя погрузчика', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-forklift-and-construction-machinery-operators'
UNION ALL SELECT id, 'Forklift Driver Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-forklift-and-construction-machinery-operators'
UNION ALL SELECT id, 'Справка для высотных работ', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-work-at-height'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za državljanstvo', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Љекарско увјерење за држављанство', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za stalni boravak', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Љекарско увјерење за стални боравак', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Медицинская справка для гражданства', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Справка для ПМЖ', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Citizenship Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Permanent Residence Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-citizenship-and-permanent-residence'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za trenere', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-sports-referees'
UNION ALL SELECT id, 'Љекарско увјерење за тренере', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-sports-referees'
UNION ALL SELECT id, 'Медицинская справка для тренеров', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-sports-referees'
UNION ALL SELECT id, 'Ljekarsko uvjerenje za starateljstvo', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-child-adoption'
UNION ALL SELECT id, 'Љекарско увјерење за старатељство', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-child-adoption'
UNION ALL SELECT id, 'Медицинская справка для опекунства', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-child-adoption'
UNION ALL SELECT id, 'Pregled kolornog vida anomaloskopom', 'sr' FROM medical_services WHERE slug = 'color-sensitivity-test-with-anomaloscope'
UNION ALL SELECT id, 'Преглед колорног вида аномалоскопом', 'sr-cyrl' FROM medical_services WHERE slug = 'color-sensitivity-test-with-anomaloscope'
UNION ALL SELECT id, 'Проверка цветового зрения на аномалоскопе', 'ru' FROM medical_services WHERE slug = 'color-sensitivity-test-with-anomaloscope'
UNION ALL SELECT id, 'Чекап для женщин', 'ru' FROM medical_services WHERE slug = 'comprehensive-health-checkup-for-women'
UNION ALL SELECT id, 'Чекап для мужчин', 'ru' FROM medical_services WHERE slug = 'comprehensive-health-checkup-for-men';

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: one row, the clinic id on this database (140 locally and on prod as of 2026-10-02)
SELECT @clinic_id AS clinic_id;

-- expected: 16 rows, cats = 9, specs = 45,50 (medical-certificate-copy and …-social-care-institution-accommodation: 45 only)
SELECT ms.id, ms.slug,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(s.specialty_id ORDER BY s.specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN (
	'medical-certificate-for-work-at-height', 'medical-certificate-for-work-with-noise-and-vibration-exposure',
	'medical-certificate-for-work-with-chemical-and-dust-exposure', 'medical-certificate-for-forklift-and-construction-machinery-operators',
	'medical-certificate-for-work-with-non-ionizing-radiation-exposure', 'medical-certificate-for-heavy-physical-work',
	'medical-certificate-for-work-in-adverse-microclimate-conditions', 'medical-certificate-for-ionizing-radiation-workers-with-chromosomal-aberration-test',
	'medical-certificate-for-unarmed-security-personnel', 'medical-certificate-for-traffic-school-enrollment',
	'medical-certificate-for-firefighters', 'medical-certificate-copy',
	'medical-certificate-for-citizenship-and-permanent-residence', 'medical-certificate-for-social-care-institution-accommodation',
	'comprehensive-health-checkup-for-women', 'comprehensive-health-checkup-for-men')
ORDER BY ms.slug;

-- expected: total = 38, outdated = 0, price_sum = 1640.00, with_price_max = 1
SELECT COUNT(*) AS total, SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum,
	SUM(price_max IS NOT NULL) AS with_price_max
FROM clinic_medical_services
WHERE clinic_id = @clinic_id AND (code LIKE 'PG\_MR\_%' OR code LIKE 'PG\_SP\_%');

SELECT cms.code, ms.slug, cms.price, cms.price_max, cms.is_price_outdated
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY cms.code, ms.slug;

-- expected: 33 rows (fewer only if a row already existed before this file)
SELECT ms.slug, s.language, s.another_name
FROM medical_service_synonyms s JOIN medical_services ms ON ms.id = s.medical_service_id
WHERE s.another_name IN (
	'Ljekarsko uvjerenje o opštoj zdravstvenoj sposobnosti', 'Љекарско увјерење о општој здравственој способности',
	'Ljekarsko uvjerenje za vozače amatere', 'Љекарско увјерење за возаче аматере',
	'Ljekarsko uvjerenje za zaštitare', 'Љекарско увјерење за заштитаре', 'Медицинская справка для охранника с оружием',
	'Ljekarsko uvjerenje za portire', 'Љекарско увјерење за портире',
	'Ljekarsko uvjerenje za vozače viljuškara', 'Љекарско увјерење за возаче виљушкара',
	'Медицинская справка для водителя погрузчика', 'Forklift Driver Medical Certificate', 'Справка для высотных работ',
	'Ljekarsko uvjerenje za državljanstvo', 'Љекарско увјерење за држављанство',
	'Ljekarsko uvjerenje za stalni boravak', 'Љекарско увјерење за стални боравак',
	'Медицинская справка для гражданства', 'Справка для ПМЖ', 'Citizenship Medical Certificate', 'Permanent Residence Medical Certificate',
	'Ljekarsko uvjerenje za trenere', 'Љекарско увјерење за тренере', 'Медицинская справка для тренеров',
	'Ljekarsko uvjerenje za starateljstvo', 'Љекарско увјерење за старатељство', 'Медицинская справка для опекунства',
	'Pregled kolornog vida anomaloskopom', 'Преглед колорног вида аномалоскопом', 'Проверка цветового зрения на аномалоскопе',
	'Чекап для женщин', 'Чекап для мужчин')
ORDER BY ms.slug, s.language;
