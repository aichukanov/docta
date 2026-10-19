-- ═══════════════════════════════════════════════════════════════════════════
-- Institut za javno zdravlje Crne Gore (Podgorica) — услуги и анализы
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-institut-za-javno-zdravlje-crne-gore-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-institut-za-javno-zdravlje-crne-gore-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/institut-za-javno-zdravlje-crne-gore-podgorica.json.
-- 
-- Услуг: 8, анализов: 26, с ценой: 0 — цен на сайте нет (Pravilnik и плакат санитарных осмотров — без сумм, только счета для оплаты; поиск cjenovnik/cijena по API — пусто).
-- Новых записей каталога: услуг 1 (voluntary-hiv-hepatitis-and-sti-counseling-and-testing), анализов 2 (epstein-barr-virus-pcr-quantitative, bk-virus-pcr-quantitative).
-- Санитарные осмотры — три существующие записи по категориям Pravilnik-а (вода/пища; здравоохранение/образование; косметические услуги) —
-- ИЗЗ проводит осмотры всех категорий; mixed-запись sanitary-examination-for-food-service-and-healthcare-workers (тариф ДЗ Херцег-Нови) не ставим — дублирует первые две.
-- Анализы — только то, что названо на страницах «Uputstva za pripremu pacijenata» (бактериологические посевы/мазки, ПЦР урина); грибковые варианты мазков не ставим — сайт их не называет.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги/анализы прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJZXrorSTrTRMRS0H_vRxwHdc' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'institut-za-javno-zdravlje-crne-gore-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-institut-za-javno-zdravlje-crne-gore-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- ИЗЗ: «Dobrovoljno, povjerljivo savjetovanje i testiranje na HIV, virusne hepatitise i polno prenosive infekcije» (страница DPST, контакты). Это услуга-процесс (пре-тест консультирование → тест → пост-тест консультирование), а не отдельный анализ; конкретный тест не назван, поэтому hiv-ag-ab не ставим. В каталоге нет. Категория 9 GENERAL_MEDICINE → спец. 45 (авто) + 52 INFECTIOUS_DISEASES.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing', 'Voluntary HIV, Hepatitis and STI Counseling and Testing', 'Dobrovoljno savjetovanje i testiranje na HIV, hepatitise i polno prenosive infekcije', 'Добровољно савјетовање и тестирање на HIV, хепатитисе и полно преносиве инфекције',
	'Добровольное консультирование и тестирование на ВИЧ, гепатиты и ИППП', 'Freiwillige Beratung und Testung auf HIV, Hepatitis und STI', 'HIV, hepatit ve cinsel yolla bulaşan enfeksiyonlar için gönüllü danışmanlık ve test', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing' OR name_en = 'Voluntary HIV, Hepatitis and STI Counseling and Testing');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 9 FROM medical_services WHERE slug IN ('voluntary-hiv-hepatitis-and-sti-counseling-and-testing');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 45 FROM medical_services WHERE slug IN ('voluntary-hiv-hepatitis-and-sti-counseling-and-testing');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 52 FROM medical_services WHERE slug IN ('voluntary-hiv-hepatitis-and-sti-counseling-and-testing');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'DPST', 'sr' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'ДПСТ', 'sr-cyrl' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'Dobrovoljno povjerljivo savjetovanje i testiranje', 'sr' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'Добровољно повјерљиво савјетовање и тестирање', 'sr-cyrl' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'Savjetovalište za HIV', 'sr' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'Савјетовалиште за HIV', 'sr-cyrl' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'VCT', 'en' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'HIV Counseling', 'en' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'Анонимное тестирование на ВИЧ', 'ru' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'HIV-Beratung', 'de' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'HIV danışmanlığı', 'tr' FROM medical_services WHERE slug = 'voluntary-hiv-hepatitis-and-sti-counseling-and-testing'
UNION ALL SELECT id, 'Sanitarna knjižica', 'sr' FROM medical_services WHERE slug = 'sanitary-examination-for-food-industry-and-water-supply-workers'
UNION ALL SELECT id, 'Санитарна књижица', 'sr-cyrl' FROM medical_services WHERE slug = 'sanitary-examination-for-food-industry-and-water-supply-workers'
UNION ALL SELECT id, 'Санитарная книжка', 'ru' FROM medical_services WHERE slug = 'sanitary-examination-for-food-industry-and-water-supply-workers'
UNION ALL SELECT id, 'Savjetovanje putnika u međunarodnom saobraćaju', 'sr' FROM medical_services WHERE slug = 'travel-medicine-examination'
UNION ALL SELECT id, 'Савјетовање путника у међународном саобраћају', 'sr-cyrl' FROM medical_services WHERE slug = 'travel-medicine-examination'
UNION ALL SELECT id, 'Консультация перед поездкой', 'ru' FROM medical_services WHERE slug = 'travel-medicine-examination'
UNION ALL SELECT id, 'Pre-Travel Consultation', 'en' FROM medical_services WHERE slug = 'travel-medicine-examination';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_institut_za_javno_zdravlje_crne_gore_podgorica;
CREATE TEMPORARY TABLE tmp_institut_za_javno_zdravlje_crne_gore_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_institut_za_javno_zdravlje_crne_gore_podgorica (slug, price, price_min, price_max) VALUES
('sanitary-examination-for-food-industry-and-water-supply-workers', NULL, NULL, NULL), -- /sanitarni-pregledi: «obavezni zdravstveni pregledi (sanitarni pregledi) za određene kategorije stanovništva» + Pravilnik čl. 5 t. 1, čl. 6: «zaposleni na poslovima javnog vodosnabdijevanja … i rukovanja hranom»
('sanitary-examination-for-healthcare-and-educational-workers', NULL, NULL, NULL), -- Pravilnik čl. 5 t. 2–3, čl. 7–8: «zaposleni na poslovima njege i održavanja higijene u predškolskim ustanovama, obrazovnim ustanovama …», «zaposleni u zdravstvenim ustanovama …»
('sanitary-examination-for-hairdressers-and-service-personnel', NULL, NULL, NULL), -- Pravilnik čl. 5 t. 5: «zaposleni na poslovima pružanja usluge higijenske njege i uljepšavanja lica i tijela …»
('travel-medicine-examination', NULL, NULL, NULL), -- /czb-imunoprofilaksa: «Priprema putnika u međunarodnom saobraćaju», /savjeti-putovanja: «zakazivanja posjete, konsultacije ili savjetovanja prije putovanja» (запись «Specijalistički pregled lica u međunarodnom transportu»)
('post-travel-medical-examination', NULL, NULL, NULL), -- /czb-imunoprofilaksa: «… i njihova kontrola prilikom povratka iz država u kojima postoje endemske infektivne bolesti» (запись «… prilikom povratka u zemlju»)
('voluntary-hiv-hepatitis-and-sti-counseling-and-testing', NULL, NULL, NULL), -- /details: «Dobrovoljno, povjerljivo savjetovanje i testiranje na HIV, virusne hepatitise i polno prenosive infekcije: Tel: +382 67 103 378», /dpst: «Radno vrijeme: radni dan od 08:00 do 15:00h»
('first-nutritionist-examination', NULL, NULL, NULL), -- /departments/centar-za-zdravstvenu-ekologiju: «Specijalističke ambulante za poremećaj ishrane», /details: «Ambulanta za ishranu Tel: +382 67 167 636» (запись «Prvi pregled - specijalista higijene - nutricionista» — врач-гигиенист, как в ИЗЗ)
('personalized-nutrition-plan', NULL, NULL, NULL); -- /departments/centar-za-zdravstvenu-ekologiju: «… uz kreiranje individualnih i kolektivnih jelovnika i planova ishrane»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_institut_za_javno_zdravlje_crne_gore_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_institut_za_javno_zdravlje_crne_gore_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_institut_za_javno_zdravlje_crne_gore_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 1b: АНАЛИЗЫ КЛИНИКИ (clinic_lab_tests, цены NULL): 26
-- ═══════════════════════════════════════════════════════════════

-- Новые записи каталога анализов (идемпотентно по slug / name_en).
-- ИЗЗ /priprema-pcr: «ODREĐIVANJE KONCENTRACIJE NUKLEINSKE KISELINE EPSTEIN BARR VIRUSA (EBV)» — количественный ПЦР. В каталоге есть только epstein-barr-virus-pcr (без количества), а для CMV количественный тест заведён отдельно (cytomegalovirus-pcr-quantitative) — по той же схеме. Категории 10 + 22, как у CMV quant.
INSERT INTO lab_tests (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
SELECT 'epstein-barr-virus-pcr-quantitative', 'Epstein-Barr Virus PCR Quantitative', 'Epstein-Barr virus PCR kvantitativni', 'Epstein-Barr вирус PCR квантитативни', 'Вирус Эпштейна-Барр ПЦР количественный', 'Epstein-Barr-Virus PCR quantitativ', 'Epstein-Barr virüsü kantitatif PCR'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM lab_tests WHERE slug = 'epstein-barr-virus-pcr-quantitative' OR name_en = 'Epstein-Barr Virus PCR Quantitative');

-- ИЗЗ /priprema-pcr: «ODREĐIVANJE KONCENTRACIJE NUKLEINSKE KISELINE BK VIRUSA (BKV)» (рядом отдельно «ISPITIVANJE PRISUSTVA BK VIRUSA» → bk-virus-pcr-urine). Количественного в каталоге нет — по схеме cytomegalovirus-pcr-quantitative. Категории 10 + 22.
INSERT INTO lab_tests (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
SELECT 'bk-virus-pcr-quantitative', 'BK Virus PCR Quantitative', 'BK virus PCR kvantitativni', 'BK вирус PCR квантитативни', 'BK вирус ПЦР количественный', 'BK-Virus PCR quantitativ', 'BK Virüs kantitatif PCR'
FROM dual WHERE NOT EXISTS (SELECT 1 FROM lab_tests WHERE slug = 'bk-virus-pcr-quantitative' OR name_en = 'BK Virus PCR Quantitative');

INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT id, 10 FROM lab_tests WHERE slug IN ('epstein-barr-virus-pcr-quantitative', 'bk-virus-pcr-quantitative');

INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT id, 22 FROM lab_tests WHERE slug IN ('epstein-barr-virus-pcr-quantitative', 'bk-virus-pcr-quantitative');

-- Синонимы анализов: формулировки сайта к существующим записям (язык sr — и для латиницы, и для кириллицы).
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT id, 'Genitalne mikoplazme', 'sr' FROM lab_tests WHERE slug = 'mycoplasma-hominis-ureaplasma'
UNION ALL SELECT id, 'Bris iscjedka dojke', 'sr' FROM lab_tests WHERE slug = 'nipple-discharge-bacteria'
UNION ALL SELECT id, 'Bris nepca', 'sr' FROM lab_tests WHERE slug = 'oral-cavity-swab-bacteria'
UNION ALL SELECT id, 'Брис непца', 'sr' FROM lab_tests WHERE slug = 'oral-cavity-swab-bacteria'
UNION ALL SELECT id, 'EBV PCR kvantitativni', 'sr' FROM lab_tests WHERE slug = 'epstein-barr-virus-pcr-quantitative'
UNION ALL SELECT id, 'EBV viral load', 'en' FROM lab_tests WHERE slug = 'epstein-barr-virus-pcr-quantitative'
UNION ALL SELECT id, 'ВЭБ ПЦР количественный', 'ru' FROM lab_tests WHERE slug = 'epstein-barr-virus-pcr-quantitative'
UNION ALL SELECT id, 'BKV PCR kvantitativni', 'sr' FROM lab_tests WHERE slug = 'bk-virus-pcr-quantitative'
UNION ALL SELECT id, 'BK viral load', 'en' FROM lab_tests WHERE slug = 'bk-virus-pcr-quantitative';

DROP TEMPORARY TABLE IF EXISTS tmp_institut_za_javno_zdravlje_crne_gore_podgorica_lab;
CREATE TEMPORARY TABLE tmp_institut_za_javno_zdravlje_crne_gore_podgorica_lab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_institut_za_javno_zdravlje_crne_gore_podgorica_lab (slug, price) VALUES
('urine-culture', NULL), -- /priprema-urinokultura: «Priprema pacijenta za davanje urina za bakteriološku analizu (urinokultura)»
('cytomegalovirus-pcr', NULL), -- /priprema-pcr: «ISPITIVANJE PRISUSTVA CYTOMEGALOVIRUSA» (urin, PCR)
('cytomegalovirus-pcr-quantitative', NULL), -- /priprema-pcr: «ODREĐIVANJE KONCENTRACIJE NUKLEINSKE KISELINE CYTOMEGALOVIRUSA (CMV)»
('epstein-barr-virus-pcr-quantitative', NULL), -- /priprema-pcr: «ODREĐIVANJE KONCENTRACIJE NUKLEINSKE KISELINE EPSTEIN BARR VIRUSA (EBV)» (новая запись)
('bk-virus-pcr-urine', NULL), -- /priprema-pcr: «ISPITIVANJE PRISUSTVA BK VIRUSA (BKV)» — из урина (запись «BK virus PCR urin»)
('bk-virus-pcr-quantitative', NULL), -- /priprema-pcr: «ODREĐIVANJE KONCENTRACIJE NUKLEINSKE KISELINE BK VIRUSA (BKV)» (новая запись)
('legionella-pneumophila-pcr', NULL), -- /priprema-pcr: «ISPITIVANJE PRISUSTVA LEGIONELLA PNEUMOPHILA» — в списке ПЦР-анализов урина (PCR, а не антиген: страница — «Priprema pacijenta za davanje urina za PCR analize»)
('mycoplasma-hominis-ureaplasma', NULL), -- /departments/…mikrobiologiju: «osim za genitalne mikoplazme (uzorkovanje i prijem uzoraka se ne vrše petkom)», /priprema-urinokultura: «… dokaz infekcije uretre mikoplazmama, ureaplazmama» — метод не назван, запись «Kultura na Mycoplasma hominis i Ureaplasma» — стандартная для генитальных микоплазм (19 клиник)
('chlamydia-trachomatis-pcr-urine', NULL), -- /priprema-urinokultura: «Postupak uzimanja uzorka urina za dokaz infekcije uretre mikoplazmama, ureaplazmama i hlamidijama … potrebno je uzeti prvi mlaz prvog jutarnjeg urina» — метод на сайте НЕ назван, из мочи хламидии стандартно определяют ПЦР (решение координатора 2026-10-09)
('urethral-swab-bacteria', NULL), -- /priprema-uretra: «Priprema pacijenta za uzorkovanje brisa uretre»
('neisseria-gonorrhoeae-culture', NULL), -- /priprema-uretra, /priprema-cerviks: «Bris uretre / cerviksa za ispitivanje gonokoka treba da bude na temperaturi od 36 do 37ºC» — посев (общая запись, без привязки к месту взятия)
('vaginal-swab-bacteria', NULL), -- /priprema-cerviks: «Priprema pacijenta za uzorkovanje brisa vagine i cerviksa»
('cervical-swab-bacteria', NULL), -- /priprema-cerviks: «… brisa vagine i cerviksa»
('throat-swab-bacteria', NULL), -- /priprema-grlo: «Priprema pacijenta za ispitivanje brisa grla, nepca i jezika»
('tongue-swab-bacteria', NULL), -- /priprema-grlo: «… brisa grla, nepca i jezika»
('oral-cavity-swab-bacteria', NULL), -- /priprema-grlo: «… brisa grla, nepca i jezika» — нёбо: бактериологического мазка с нёба в каталоге нет, нёбо — часть полости рта (решение координатора 2026-10-09), формулировка — синонимом
('sputum-bacteria', NULL), -- /priprema-sputum: «Priprema pacijenta za ispitivanje ispljuvka/sputuma»
('stool-culture', NULL), -- /priprema-feces: «Priprema pacijenta za ispitivanje stolice/fecesa», Pravilnik: «laboratorijski pregled stolice na Salmonellae i Shigellae» (Koprokultura)
('stool-parasites', NULL), -- /priprema-feces, центр: «Odjeljenje za parazitologiju i mikologiju», Pravilnik: «laboratorijski pregled stolice na crijevne protozoe i parazite»
('nose-swab-bacteria', NULL), -- /priprema-pacijenta-ostalo: «Za ispitivanje brisa nosa»
('eye-swab-bacteria', NULL), -- /priprema-pacijenta-ostalo: «Za ispitivanje brisa oka»
('ear-swab-bacteria', NULL), -- /priprema-pacijenta-ostalo: «Za ispitivanje brisa uva» (запись «Bris uha na bakterije» — серия briseva, bacteriological-examination-ear-swab — тарифная формулировка, менее распространена)
('wound-swab-bacteria', NULL), -- /priprema-pacijenta-ostalo: «Za ispitivanje brisa rane»
('skin-swab-bacteria', NULL), -- /priprema-pacijenta-ostalo: «Za ispitivanje brisa kože»
('nipple-discharge-bacteria', NULL), -- /priprema-pacijenta-ostalo: «Za ispitivanje brisa iscjedka dojke» (запись «Iscedak bradavice bakterije» — именно выделения, breast-swab-bacteria — мазок с кожи груди)
('umbilicus-swab-bacteria', NULL); -- /priprema-pacijenta-ostalo: «Za ispitivanje brisa pupka»

-- Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_test
FROM tmp_institut_za_javno_zdravlje_crne_gore_podgorica_lab t
LEFT JOIN lab_tests l ON l.slug = t.slug
WHERE l.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, l.id, t.price, NULL, NULL
FROM lab_tests l
JOIN tmp_institut_za_javno_zdravlje_crne_gore_podgorica_lab t ON t.slug = l.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_max = NULL;

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
LEFT JOIN tmp_institut_za_javno_zdravlje_crne_gore_podgorica_lab t ON t.slug = l.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 8 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 1: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('voluntary-hiv-hepatitis-and-sti-counseling-and-testing');

-- Ожидается 26 анализов, с ценой 0. Новые записи каталога анализов: epstein-barr-virus-pcr-quantitative, bk-virus-pcr-quantitative.
SELECT COUNT(*) AS lab_tests_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

SELECT l.slug, l.name_en, clt.price
FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
WHERE clt.clinic_id = @clinic_id
ORDER BY l.name_en;

DROP TEMPORARY TABLE IF EXISTS tmp_institut_za_javno_zdravlje_crne_gore_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_institut_za_javno_zdravlje_crne_gore_podgorica_lab;
