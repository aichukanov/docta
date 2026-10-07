SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Vaše zdravlje (Podgorica) — full pricelist, new import (clinic had 0 services and 0 lab tests
--   locally and on prod: /api/services/list and /api/labtests/list for prod id 39 → totalCount 0, 2026-10-02)
-- Source: https://vasezdravlje.me/cjenovnik/ — HTML (WordPress page 684, Elementor)
--   snapshots: data/clinic-pricelists/sources/vase-zdravlje-podgorica/2026-10-02.html (rendered page)
--              data/clinic-pricelists/sources/vase-zdravlje-podgorica/2026-10-02.json (wp-json pages/684 with content)
-- Price date: page modified 2026-04-22T08:44:10 (wp-json /wp/v2/pages/684?_fields=modified — the single page
--   answers even though /wp-json/ and sitemap are 403; created 2018-11-15) → current, is_price_outdated = 0
-- Collected: 2026-10-02
--
-- Source: 255 priced lines (107 services, 148 lab tests, incl. 7 excluded;
--   3 of them carry no € sign: «pregled kardiologa – 40», «Kontrolni pregled kardiologa – 30», «Anti spermatozoidna antitijela – 35»)
--   services: 101 lines → 88 clinic rows (72 existing catalog records, 16 new)
--     8 records take several lines → price range min–max:
--       Home Therapy Administration: 2 lines → 10.00
--       Intramuscular Injection: 2 lines → 5.00–10.00
--       Infusion Therapy: 6 lines → 10.00–25.00
--       Residual Work Capacity Assessment: 2 lines → 35.00–50.00
--       Medical Certificate for Athletes: 3 lines → 10.00–20.00
--       Musculoskeletal Ultrasound: 2 lines → 40.00
--       Psychological Counseling: 2 lines → 20.00–30.00
--       Chiropractic Treatment: 2 lines → 35.00
--   lab tests: 147 lines → 147 clinic rows, all existing catalog records, 0 new
--   excluded: 7 lines (2 disputed: hs Troponin T/I, «radna mjesta sa posebnim uslovima») — see the import record
--   new catalog records: 16, of them 5 shared with sibling imports, copied verbatim
--     (dom-zdravlja-podgorica: medical-certificate-for-firefighters, medical-certificate-for-unarmed-security-personnel, medical-certificate-for-traffic-school-enrollment; nasa-medicina-podgorica: medical-certificate-copy, psychological-counseling)
--   free: Venous Blood Draw 0.00 («Uzorkovanje u ordinaciji – BESPLATNO»)
-- Source quirk: «produženje vozačke dozvole … – 25€   20€» — 25 is wrapped in <s> (struck through) in the HTML,
--   the current price is 20.
-- Price sums: services 3070.00 (price column), lab tests 1816.00
-- Record: data/clinic-imports/vase-zdravlje-podgorica.json
-- Idempotent: catalog ON DUPLICATE KEY (name_en / slug), everything else INSERT IGNORE / guarded UPDATE.
-- Revised 2026-10-05, after the first version was applied (local + prod): «Dobutaminski test» moved from
--   Stress Echocardiography to its own record Pharmacological Stress Echo Test Dobutamine, together with
--   its 4 synonyms. Databases that ran the first version: update-clinic-prices-vase-zdravlje-podgorica-dobutamine.sql

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'vase-zdravlje-podgorica');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: NEW CATALOG RECORDS
-- ═══════════════════════════════════════════════════════════════

-- 1a. Shared with sibling imports of 2026-10-02 — definitions copied verbatim, so ON DUPLICATE KEY
--     merges them whichever file runs first; categories / specialties as in the sibling file
--     dom-zdravlja-podgorica: medical-certificate-for-firefighters, medical-certificate-for-unarmed-security-personnel, medical-certificate-for-traffic-school-enrollment
--     nasa-medicina-podgorica: medical-certificate-copy, psychological-counseling
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Medical Certificate for Firefighters', 'medical-certificate-for-firefighters',
	'Ljekarsko uvjerenje za posao vatrogasca', 'Љекарско увјерење за посао ватрогасца',
	'Медицинская справка для пожарных', 'Ärztliches Attest für Feuerwehrleute', 'İtfaiyeciler için sağlık raporu'),
('Medical Certificate for Unarmed Security Personnel', 'medical-certificate-for-unarmed-security-personnel',
	'Ljekarsko uvjerenje za rad u obezbjeđenju bez nošenja oružja', 'Љекарско увјерење за рад у обезбјеђењу без ношења оружја',
	'Медицинская справка для охранников без оружия', 'Ärztliches Attest für Sicherheitspersonal ohne Waffe', 'Silahsız güvenlik personeli için sağlık raporu'),
('Medical Certificate for Traffic School Enrollment', 'medical-certificate-for-traffic-school-enrollment',
	'Ljekarsko uvjerenje za upis u srednju školu saobraćajnog smjera', 'Љекарско увјерење за упис у средњу школу саобраћајног смјера',
	'Медицинская справка для поступления в транспортную среднюю школу', 'Ärztliches Attest für die Aufnahme an einer Verkehrsfachschule', 'Ulaştırma meslek lisesine kayıt için sağlık raporu'),
('Medical Certificate Copy', 'medical-certificate-copy',
	'Prepis ljekarskog uvjerenja', 'Препис љекарског увјерења',
	'Копия медицинской справки', 'Abschrift eines ärztlichen Attests', 'Sağlık raporu sureti'),
('Psychological Counseling', 'psychological-counseling',
	'Psihološko savjetovanje', 'Психолошко савјетовање',
	'Психологическое консультирование', 'Psychologische Beratung', 'Psikolojik danışmanlık')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- 1b. Own new records (no match locally or among sibling imports of 2026-10-02)
--   Home Therapy Administration: общей записи нет: есть только патронажные IM/IV на дому «город / периферия» (4135–4138) с зонами, которых в прайсе нет
--   Occupational Medicine Specialist Examination: осмотра специалиста медицины труда в каталоге нет (есть только справки)
--   Follow-up Occupational Medicine Specialist Examination: пара к первичному осмотру
--   Residual Work Capacity Assessment: записи нет; обычный (35) и консилиумный (50) осмотр слиты в диапазон 35–50
--   Gynecological Examination with Swab Collection: есть только осмотр (Gynecological Specialist Examination) и отдельно взятие мазков (Gynecological Swab Collection); у клиники это одна позиция со своей ценой
--   Follow-up Hematologist Examination: у Hematologist Examination (sort_order 1) нет пары-контроля
--   Psychiatrist Home Visit: домашние визиты в каталоге только общие или по зонам; у клиники отдельная цена по специальности
--   Neurologist Home Visit: как у психиатра
--   X-Ray per Segment: в каталоге рентген только по конкретным областям; клиника даёт единую цену «за сегмент + описание», раскладывать её по 20 областям значило бы угадывать, какие снимают
--   Home X-Ray: выездного рентгена в каталоге нет
--   Home Blood Draw: есть только Venous Blood Draw в кабинете
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Home Therapy Administration', 'home-therapy-administration',
	'Aplikacija terapije u kućnim uslovima', 'Апликација терапије у кућним условима',
	'Введение лекарств на дому', 'Medikamentengabe zu Hause', 'Evde tedavi uygulaması'),
('Occupational Medicine Specialist Examination', 'occupational-medicine-specialist-examination',
	'Pregled specijaliste medicine rada', 'Преглед специјалисте медицине рада',
	'Осмотр специалиста по медицине труда', 'Untersuchung durch Facharzt für Arbeitsmedizin', 'İş sağlığı uzmanı muayenesi'),
('Follow-up Occupational Medicine Specialist Examination', 'follow-up-occupational-medicine-specialist-examination',
	'Kontrolni pregled specijaliste medicine rada', 'Контролни преглед специјалисте медицине рада',
	'Повторный осмотр специалиста по медицине труда', 'Kontrolluntersuchung durch Facharzt für Arbeitsmedizin', 'İş sağlığı uzmanı kontrol muayenesi'),
('Residual Work Capacity Assessment', 'residual-work-capacity-assessment',
	'Pregled za ocjenu preostale radne sposobnosti', 'Преглед за оцјену преостале радне способности',
	'Осмотр для оценки остаточной трудоспособности', 'Untersuchung zur Beurteilung der Restarbeitsfähigkeit', 'Kalan çalışma kapasitesi değerlendirme muayenesi'),
('Gynecological Examination with Swab Collection', 'gynecological-examination-with-swab-collection',
	'Ginekološki pregled sa uzimanjem briseva', 'Гинеколошки преглед са узимањем брисева',
	'Гинекологический осмотр со взятием мазков', 'Gynäkologische Untersuchung mit Abstrichentnahme', 'Sürüntü alımı ile jinekolojik muayene'),
('Follow-up Hematologist Examination', 'follow-up-hematologist-examination',
	'Kontrolni pregled hematologa', 'Контролни преглед хематолога',
	'Повторный осмотр гематолога', 'Hämatologische Kontrolluntersuchung', 'Hematoloji kontrol muayenesi'),
('Psychiatrist Home Visit', 'psychiatrist-home-visit',
	'Kućna posjeta psihijatra', 'Кућна посјета психијатра',
	'Визит психиатра на дом', 'Hausbesuch durch Psychiater', 'Psikiyatrist ev ziyareti'),
('Neurologist Home Visit', 'neurologist-home-visit',
	'Kućna posjeta neurologa', 'Кућна посјета неуролога',
	'Визит невролога на дом', 'Hausbesuch durch Neurologen', 'Nörolog ev ziyareti'),
('X-Ray per Segment', 'x-ray-per-segment',
	'Rendgenski snimak po segmentu', 'Рендгенски снимак по сегменту',
	'Рентген одного сегмента', 'Röntgenaufnahme pro Segment', 'Segment başına röntgen'),
('Home X-Ray', 'home-x-ray',
	'Rendgenski snimak u kućnim uslovima', 'Рендгенски снимак у кућним условима',
	'Рентген на дому', 'Röntgenaufnahme zu Hause', 'Evde röntgen'),
('Home Blood Draw', 'home-blood-draw',
	'Uzimanje krvi u kućnim uslovima', 'Узимање крви у кућним условима',
	'Забор крови на дому', 'Blutabnahme zu Hause', 'Evde kan alma')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- sort_order for examinations (1 = first, 2 = follow-up); only where nobody has set it yet
UPDATE medical_services SET sort_order = 1 WHERE slug = 'occupational-medicine-specialist-examination' AND sort_order IS NULL;
UPDATE medical_services SET sort_order = 2 WHERE slug = 'follow-up-occupational-medicine-specialist-examination' AND sort_order IS NULL;
UPDATE medical_services SET sort_order = 2 WHERE slug = 'follow-up-hematologist-examination' AND sort_order IS NULL;

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT ms.id, r.category_id
FROM (
	          SELECT 'home-therapy-administration' AS slug, 29 AS category_id
	UNION ALL SELECT 'home-therapy-administration', 30
	UNION ALL SELECT 'occupational-medicine-specialist-examination', 9
	UNION ALL SELECT 'follow-up-occupational-medicine-specialist-examination', 9
	UNION ALL SELECT 'residual-work-capacity-assessment', 9
	UNION ALL SELECT 'medical-certificate-for-firefighters', 9
	UNION ALL SELECT 'medical-certificate-for-unarmed-security-personnel', 9
	UNION ALL SELECT 'medical-certificate-for-traffic-school-enrollment', 9
	UNION ALL SELECT 'medical-certificate-copy', 9
	UNION ALL SELECT 'gynecological-examination-with-swab-collection', 7
	UNION ALL SELECT 'follow-up-hematologist-examination', 9
	UNION ALL SELECT 'psychiatrist-home-visit', 30
	UNION ALL SELECT 'neurologist-home-visit', 30
	UNION ALL SELECT 'neurologist-home-visit', 21
	UNION ALL SELECT 'x-ray-per-segment', 3
	UNION ALL SELECT 'home-x-ray', 3
	UNION ALL SELECT 'home-x-ray', 30
	UNION ALL SELECT 'home-blood-draw', 28
	UNION ALL SELECT 'home-blood-draw', 29
	UNION ALL SELECT 'home-blood-draw', 30
) AS r
JOIN medical_services ms ON ms.slug = r.slug;

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT ms.id, r.specialty_id
FROM (
	          SELECT 'home-therapy-administration' AS slug, 45 AS specialty_id
	UNION ALL SELECT 'occupational-medicine-specialist-examination', 50
	UNION ALL SELECT 'follow-up-occupational-medicine-specialist-examination', 50
	UNION ALL SELECT 'residual-work-capacity-assessment', 50
	UNION ALL SELECT 'medical-certificate-for-firefighters', 45
	UNION ALL SELECT 'medical-certificate-for-firefighters', 50
	UNION ALL SELECT 'medical-certificate-for-unarmed-security-personnel', 45
	UNION ALL SELECT 'medical-certificate-for-unarmed-security-personnel', 50
	UNION ALL SELECT 'medical-certificate-for-traffic-school-enrollment', 45
	UNION ALL SELECT 'medical-certificate-for-traffic-school-enrollment', 50
	UNION ALL SELECT 'medical-certificate-copy', 45
	UNION ALL SELECT 'psychological-counseling', 22
	UNION ALL SELECT 'gynecological-examination-with-swab-collection', 5
	UNION ALL SELECT 'follow-up-hematologist-examination', 15
	UNION ALL SELECT 'psychiatrist-home-visit', 21
	UNION ALL SELECT 'neurologist-home-visit', 8
	UNION ALL SELECT 'x-ray-per-segment', 10
	UNION ALL SELECT 'home-x-ray', 10
	UNION ALL SELECT 'home-blood-draw', 2
) AS r
JOIN medical_services ms ON ms.slug = r.slug;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC PRICES — SERVICES (88 rows)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, ms.id, p.price, NULL, p.price_max, NULL, 0
FROM (
	          SELECT 'family-medicine-examination' AS slug, 20.00 AS price, NULL AS price_max                 -- Pregled specijaliste porodične medicine – 20€
	UNION ALL SELECT 'follow-up-family-medicine-examination', 15.00, NULL                           -- Kontrolni pregled specijaliste porodične medicine – 15€
	UNION ALL SELECT 'home-visit-examination', 50.00, NULL                                          -- Prva kućna posjeta specijaliste – 50€
	UNION ALL SELECT 'home-therapy-administration', 10.00, NULL                                     -- Davanje terapije u kući -10€/dan (nije uključena cijena medikamenata) / Aplikacija terapije u kućnim uslovima – 10 € (nije uključena cijena medikamenata)
	UNION ALL SELECT 'intramuscular-injection', 5.00, 10.00                                         -- Intramuskularna injekcija (uključuje 1 lijek) – 5€ / Intramuskularna injekcija (uključuje 2+ lijeka) – 10€
	UNION ALL SELECT 'infusion-therapy', 10.00, 25.00                                               -- Infuzija – 10 € / Infuzija manitol – 10 € / Infuzija (uključuje 1-2 lijeka) – 15€ / Infuzija (uključuje 3 lijeka ) – 20 € / Infuzija (uključuje antibiotik) – 20€ / Infuzija (uključuje 2+ lijeka i antibiotik ) – 25€
	UNION ALL SELECT 'occupational-medicine-specialist-examination', 30.00, NULL                    -- prvi pregled specijaliste medicine rada – 30€
	UNION ALL SELECT 'follow-up-occupational-medicine-specialist-examination', 25.00, NULL          -- kontrolni pregled specijaliste medicine rada – 25€
	UNION ALL SELECT 'residual-work-capacity-assessment', 35.00, 50.00                              -- pregled za ocjenu preostale radne sposobnosti – 35€ / konzilijarni pregld za ocjenu preostale radne sposobnosti -50€
	UNION ALL SELECT 'medical-certificate-for-athletes', 10.00, 20.00                               -- do 10 godina – 10€ / 11-17 godina – 15€ / 18+ godina – 20€
	UNION ALL SELECT 'medical-certificate-for-class-a-and-b-drivers', 20.00, NULL                   -- ljekarsko uvjerenje za polaganje A,B kategorije – 20€
	UNION ALL SELECT 'medical-certificate-for-professional-drivers', 25.00, NULL                    -- ljekarsko uvjerenje za polaganje C,D,E kategorije – 25€
	UNION ALL SELECT 'medical-certificate-for-driving-license-renewal-category-a-b-c-d-e', 20.00, NULL -- ljekarsko uvjerenje za produženje vozačke dozvole A,B,C,D,E kategorije – 25€ 20€
	UNION ALL SELECT 'medical-certificate-for-general-work', 20.00, NULL                            -- radna mjesta bez povećanog rizika (opšta zdravstvene sposobnost: službenici, konobari, kuvari, administrativni poslovi …) – 20€
	UNION ALL SELECT 'medical-certificate-for-high-risk-and-difficult-working-conditions', 35.00, NULL -- radna mjesta sa povećanim rizikom (prethodni pregled) – 35€
	UNION ALL SELECT 'medical-certificate-for-military-service', 35.00, NULL                        -- obavljanje službe u Vojsci Crne Gore -35€
	UNION ALL SELECT 'medical-certificate-for-firefighters', 35.00, NULL                            -- vatrogasca-35€
	UNION ALL SELECT 'medical-certificate-for-security-personnel', 35.00, NULL                      -- zaštitara (obezbjeđenje uz nošenje oružja)-35€
	UNION ALL SELECT 'medical-certificate-for-unarmed-security-personnel', 20.00, NULL              -- portira (obezbjeđenje bez nošenje oružja)-20€
	UNION ALL SELECT 'medical-certificate-for-maritime-workers', 85.00, NULL                        -- pomorca – 85€
	UNION ALL SELECT 'medical-certificate-for-court-expert', 35.00, NULL                            -- sudskog vještaka – 35€
	UNION ALL SELECT 'medical-certificate-for-firearms-possession', 35.00, NULL                     -- posjedovanje vatrenog oružja – 35€
	UNION ALL SELECT 'medical-certificate-for-driving-instructor-category-b-c-d-e', 30.00, NULL     -- upravljanje motornim vozilom za instruktore vožnje – 30€
	UNION ALL SELECT 'medical-certificate-for-lifeguards', 30.00, NULL                              -- dobijanje licence za spasioca na vodi -30€
	UNION ALL SELECT 'medical-certificate-for-divers', 30.00, NULL                                  -- ronioca-profesionalca, rukovodioca i instruktora ronjenja-30€
	UNION ALL SELECT 'medical-certificate-for-boat-operation-up-to-12-meters', 30.00, NULL          -- upravitelja čamca-30€
	UNION ALL SELECT 'medical-certificate-for-traffic-school-enrollment', 25.00, NULL               -- upis u srednju školu-saobraćajnog smjera -25€
	UNION ALL SELECT 'medical-certificate-for-sports-referees', 35.00, NULL                         -- sportske sudije-35€
	UNION ALL SELECT 'medical-certificate-for-residence-and-work-in-montenegro', 20.00, NULL        -- boravak i rad u Crnoj Gori-20€
	UNION ALL SELECT 'medical-certificate-for-elderly-home-accommodation', 20.00, NULL              -- kolektivni smještaj za za ustanove socijalnog staranja-20€
	UNION ALL SELECT 'medical-certificate-for-child-adoption', 20.00, NULL                          -- podobnost za usvajanje djeteta, starateljstvo-20€
	UNION ALL SELECT 'medical-certificate-for-underage-marriage', 20.00, NULL                       -- sklapanje braka za maloljetne osobe-20€
	UNION ALL SELECT 'medical-certificate-for-life-insurance', 20.00, NULL                          -- radi životnog osiguranja-20€
	UNION ALL SELECT 'medical-certificate-for-university-enrollment', 15.00, NULL                   -- upis na fakultet – 15€
	UNION ALL SELECT 'medical-certificate-for-study-abroad-and-visa', 15.00, NULL                   -- dalji nastavak školovanja i boravak u inostranstvu, izdavanje viza -15€
	UNION ALL SELECT 'medical-certificate-for-collective-accommodation', 15.00, NULL                -- kolektivni smještaj za đake i studente – 15€
	UNION ALL SELECT 'medical-certificate-copy', 10.00, NULL                                        -- izdavanje duplikata uvjerenja-10€
	UNION ALL SELECT 'gynecological-specialist-examination', 30.00, NULL                            -- Ginekološko-akušerski pregled — 30,00 €
	UNION ALL SELECT 'gynecological-ultrasound', 30.00, NULL                                        -- Ultrazvučni pregled –30,00 €
	UNION ALL SELECT 'gynecological-specialist-examination-with-ultrasound', 50.00, NULL            -- Ginekološko-akušerski pregled sa ultrazvukom—50 €
	UNION ALL SELECT 'gynecological-examination-with-swab-collection', 35.00, NULL                  -- Ginekološki pregled sa uzivamnje briseva—35 €
	UNION ALL SELECT 'pap-test-with-smear-collection', 15.00, NULL                                  -- PAPA test I -15€
	UNION ALL SELECT 'internist-examination', 40.00, NULL                                           -- Pregled interniste – 40€
	UNION ALL SELECT 'follow-up-internist-examination', 30.00, NULL                                 -- Kontrolni pregled interniste – 30€
	UNION ALL SELECT 'cardiologist-examination', 40.00, NULL                                        -- pregled kardiologa – 40
	UNION ALL SELECT 'follow-up-cardiologist-examination', 30.00, NULL                              -- Kontrolni pregled kardiologa – 30
	UNION ALL SELECT 'ecg', 5.00, NULL                                                              -- Elektrokardiografija (EKG)- 5€
	UNION ALL SELECT 'holter-blood-pressure-24h', 40.00, NULL                                       -- Holter krvnog pritiska 24 sata (holter TA) – 40€
	UNION ALL SELECT 'holter-ecg-24h', 40.00, NULL                                                  -- Holter rada srca 24 sata (holter EKG) – 40€
	UNION ALL SELECT 'echocardiography-heart-ultrasound', 40.00, NULL                               -- Ultrazvuk srca (UZV srca) – 40€
	UNION ALL SELECT 'cardiologist-examination-with-ultrasound', 60.00, NULL                        -- Pregled kardiologa i UZ srca – 60€
	UNION ALL SELECT 'ergometry-stress-test', 60.00, NULL                                           -- Test fizičkog opterećenja (TFO)-ergometrija – 60€
	UNION ALL SELECT 'pharmacological-stress-echo-test-dobutamine', 80.00, NULL                     -- Dobutaminski test – 80€
	UNION ALL SELECT 'stress-echocardiography', 80.00, NULL                                         -- Stres ehokardiografski test (stres EHO) – 80€
	UNION ALL SELECT 'first-endocrinologist-examination', 40.00, NULL                               -- Prvi pregled endokrinologa – 40€
	UNION ALL SELECT 'follow-up-endocrinologist-examination', 30.00, NULL                           -- Kontrolni pregled endokrinologa – 30€
	UNION ALL SELECT 'musculoskeletal-ultrasound', 40.00, NULL                                      -- Ultratvučni pregled koštano-zglobnog sistem (rame, lakat, koljeno,skočni zglob) – 40€ / Ultrazvučni pregled koštano-zglobnog sistem (rame, lakat, koljeno,skočni zglob) – 40€
	UNION ALL SELECT 'first-rheumatologist-examination', 40.00, NULL                                -- Prvi pregled reumatologa (uključuje aplikaciju lijeka u zglob) – 40€
	UNION ALL SELECT 'follow-up-rheumatologist-examination', 30.00, NULL                            -- Kontrolni pregled reumatologa (uključuje aplikaciju lijeka u zglob) – 30€
	UNION ALL SELECT 'hematologist-examination', 50.00, NULL                                        -- Prvi pregled hematologa – 50€
	UNION ALL SELECT 'follow-up-hematologist-examination', 40.00, NULL                              -- Kontrolni pregled hematologa – 40€
	UNION ALL SELECT 'psychotherapy', 40.00, NULL                                                   -- Tretman psihoterapeuta – 40€
	UNION ALL SELECT 'first-psychiatrist-examination', 50.00, NULL                                  -- Prvi pregled psihijatra – 50€
	UNION ALL SELECT 'follow-up-psychiatrist-examination', 50.00, NULL                              -- Kontrolni pregled psihijatra – 50€
	UNION ALL SELECT 'first-neurologist-examination', 40.00, NULL                                   -- Prvi pregled neurologa – 40€
	UNION ALL SELECT 'follow-up-neurologist-examination', 30.00, NULL                               -- Kontrolni pregled neurologa – 30€
	UNION ALL SELECT 'psychiatrist-home-visit', 70.00, NULL                                         -- Kućna posjeta psihijatra – 70€
	UNION ALL SELECT 'neurologist-home-visit', 70.00, NULL                                          -- Kućna posjeta neurologa – 70€
	UNION ALL SELECT 'psychological-counseling', 20.00, 30.00                                       -- Tretman psihologa – 30€ / Savjetovanje psihologa-20€
	UNION ALL SELECT 'psychological-testing', 45.00, NULL                                           -- Psihološka dijagnostika-45€
	UNION ALL SELECT 'career-counseling-and-vocational-guidance', 45.00, NULL                       -- Profesionalna orijetacija-45€
	UNION ALL SELECT 'ultrasound-thyroid-and-parathyroid-glands', 40.00, NULL                       -- Ultrazvučni pregled štitne i paraštitne žlijezde – 40€
	UNION ALL SELECT 'abdomen-ultrasound', 40.00, NULL                                              -- Ultrazvučni pregled abdomena (jetre, žučne kese, žučnih puteva, gušterače, slezene, bubrega, nadbubrega, mokraćne bešike i limfnih žlijezda abdomena) – 40€
	UNION ALL SELECT 'urinary-tract-ultrasound', 40.00, NULL                                        -- Ultrazvučni pregled bubrega, nadbubrega, mokraćne bešike i prostate – 40€
	UNION ALL SELECT 'breast-ultrasound', 50.00, NULL                                               -- Ultrazvučni pregled dojki – 50€
	UNION ALL SELECT 'testicular-ultrasound', 40.00, NULL                                           -- Ultrazvučni pregled testisa – 40€
	UNION ALL SELECT 'soft-tissue-ultrasound', 40.00, NULL                                          -- Ultrazvučni pregled mekih tkiva – 40€
	UNION ALL SELECT 'ultrasound-lymph-nodes', 50.00, NULL                                          -- Ultrazvučni pregled limfnih žlijezda (prepone, pazuha, potključne i natkljčne regije) – 50€
	UNION ALL SELECT 'doppler-neck-blood-vessels', 50.00, NULL                                      -- dopler krvnih sudova vrata – 50 €
	UNION ALL SELECT 'doppler-upper-extremity-blood-vessels', 50.00, NULL                           -- dopler krvnih sudova gornjih ekstremiteta – 50 €
	UNION ALL SELECT 'doppler-lower-extremity-blood-vessels', 50.00, NULL                           -- dopler krvnih sudova donjih esktremiteta – 50 €
	UNION ALL SELECT 'x-ray-per-segment', 25.00, NULL                                               -- Rendgenski snimak (po segmentu) + opis – 25€
	UNION ALL SELECT 'x-ray-full-spine', 60.00, NULL                                                -- Rendgenski snimak cijele kičme + opis – 60€
	UNION ALL SELECT 'home-x-ray', 80.00, NULL                                                      -- Rendgenski snimak u kućnim uslovima + opis – 80€
	UNION ALL SELECT 'chiropractic-treatment', 35.00, NULL                                          -- Prvi pregled kiropraktičara (uključuje i tretman) – 35€ / Kontrolni pregled kiropraktičara (uključuje i tretman) – 35€
	UNION ALL SELECT 'cupping-therapy', 30.00, NULL                                                 -- Tretman hidžamom – 30€
	UNION ALL SELECT 'venous-blood-draw', 0.00, NULL                                                -- Uzorkovanje u ordinaciji – BESPLATNO
	UNION ALL SELECT 'home-blood-draw', 10.00, NULL                                                 -- Uzorkovanje u kući – 10€
) AS p
JOIN medical_services ms ON ms.slug = p.slug;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: CLINIC PRICES — LAB TESTS (147 rows)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code, is_price_outdated)
SELECT @clinic_id, lt.id, p.price, p.price_max, NULL, 0
FROM (
	          SELECT 'complete-blood-count' AS slug, 5.00 AS price, NULL AS price_max                         -- KKS (kompletna krvna slika) – 5€
	UNION ALL SELECT 'erythrocyte-sedimentation-rate', 2.00, NULL                                   -- SE (sedimentacija eritrocita) – 2€
	UNION ALL SELECT 'c-reactive-protein', 5.00, NULL                                               -- CRP – 5€
	UNION ALL SELECT 'glucose', 2.00, NULL                                                          -- Glukoza – 2€
	UNION ALL SELECT 'urea', 2.00, NULL                                                             -- Urea – 2€
	UNION ALL SELECT 'creatinine', 2.00, NULL                                                       -- Kreatinin – 2€
	UNION ALL SELECT 'cholesterol', 2.00, NULL                                                      -- Holesterol – 2€
	UNION ALL SELECT 'hdl-cholesterol', 3.00, NULL                                                  -- HDL-holesterol – 3€
	UNION ALL SELECT 'ldl-cholesterol', 2.00, NULL                                                  -- LDL-holesterol – 2€
	UNION ALL SELECT 'triglycerides', 3.00, NULL                                                    -- Trigliceridi- 3€
	UNION ALL SELECT 'ast', 2.00, NULL                                                              -- AST – 2€
	UNION ALL SELECT 'alt', 2.00, NULL                                                              -- ALT – 2€
	UNION ALL SELECT 'gamma-gt', 3.00, NULL                                                         -- GGT – 3€
	UNION ALL SELECT 'ldh', 3.00, NULL                                                              -- LDH – 3€
	UNION ALL SELECT 'total-bilirubin', 3.00, NULL                                                  -- Ukupni bilirubin – 3€
	UNION ALL SELECT 'direct-bilirubin', 3.00, NULL                                                 -- Direktni bilirubin – 3€
	UNION ALL SELECT 'amylase', 2.00, NULL                                                          -- Amilaza – 2€
	UNION ALL SELECT 'alkaline-phosphatase', 2.00, NULL                                             -- ALP -2€
	UNION ALL SELECT 'total-protein', 2.00, NULL                                                    -- Proteini – 2€
	UNION ALL SELECT 'albumin', 2.00, NULL                                                          -- Albumin – 2€
	UNION ALL SELECT 'uric-acid', 2.00, NULL                                                        -- Mokraćna kiselina – 2€
	UNION ALL SELECT 'iron', 3.00, NULL                                                             -- Gvožđe – 3€
	UNION ALL SELECT 'tibc', 5.00, NULL                                                             -- TIBC – 5€
	UNION ALL SELECT 'uibc', 5.00, NULL                                                             -- UIBC – 5€
	UNION ALL SELECT 'ck', 3.00, NULL                                                               -- CK – 3€
	UNION ALL SELECT 'ck-mb', 3.00, NULL                                                            -- CK-MB – 3€
	UNION ALL SELECT 'magnesium', 3.00, NULL                                                        -- Magnezijum – 3€
	UNION ALL SELECT 'phosphorus', 2.00, NULL                                                       -- Fosfor – 2€
	UNION ALL SELECT 'calcium', 2.00, NULL                                                          -- Ukupni kalcijum – 2€
	UNION ALL SELECT 'ionized-calcium', 2.00, NULL                                                  -- Jonizovani kalcijum – 2€
	UNION ALL SELECT 'sodium', 3.00, NULL                                                           -- Natrijum – 3€
	UNION ALL SELECT 'potassium', 3.00, NULL                                                        -- Kalijum – 3€
	UNION ALL SELECT 'chloride', 3.00, NULL                                                         -- Hloridi – 3€
	UNION ALL SELECT 'procalcitonin', 25.00, NULL                                                   -- Prokalcitonin – 25€
	UNION ALL SELECT 'interleukin-6', 40.00, NULL                                                   -- Interleukin-6 (IL-6) – 40€
	UNION ALL SELECT 'transferrin', 12.00, NULL                                                     -- Transferin – 12€
	UNION ALL SELECT 'ferritin', 12.00, NULL                                                        -- Feritin – 12€
	UNION ALL SELECT 'hba1c', 14.00, NULL                                                           -- HbA1C – 14€
	UNION ALL SELECT 'fructosamine', 6.00, NULL                                                     -- Fruktozamin – 6€
	UNION ALL SELECT 'ace', 20.00, NULL                                                             -- ACE – 20€
	UNION ALL SELECT 'beta-crosslaps', 15.00, NULL                                                  -- Beta Cross Laps – 15€
	UNION ALL SELECT 'osteocalcin', 15.00, NULL                                                     -- Osteokalcin – 15€
	UNION ALL SELECT 'urea-clearance', 7.00, NULL                                                   -- Klirens uree – 7€
	UNION ALL SELECT 'creatinine-clearance', 7.00, NULL                                             -- Klirens kreatinina – 7€
	UNION ALL SELECT 'fibrinogen', 4.00, NULL                                                       -- Fibrinogen – 4€
	UNION ALL SELECT 'activated-partial-thromboplastin-time', 12.00, NULL                           -- APTT – 12€
	UNION ALL SELECT 'prothrombin-time-pt-inr', 4.00, NULL                                          -- Protrombinsko vrijeme/INR – 4€
	UNION ALL SELECT 'd-dimer', 15.00, NULL                                                         -- D-dimer – 15€
	UNION ALL SELECT 'bleeding-time', 3.00, NULL                                                    -- Vrijeme krvarenja – 3€
	UNION ALL SELECT 'coagulation-time', 3.00, NULL                                                 -- Vrijeme koagulacije – 3€
	UNION ALL SELECT 'protein-c', 15.00, NULL                                                       -- Protein C – 15€
	UNION ALL SELECT 'protein-s', 15.00, NULL                                                       -- Protein S – 15€
	UNION ALL SELECT 'lupus-anticoagulant', 15.00, NULL                                             -- LA 1 – 15€
	UNION ALL SELECT 'antithrombin-iii', 15.00, NULL                                                -- Antitrombin III – 15€
	UNION ALL SELECT 'rheumatoid-factor', 4.00, NULL                                                -- Reuma faktor – 4€
	UNION ALL SELECT 'anti-ccp-antibodies', 15.00, NULL                                             -- Anti CCP – 15€
	UNION ALL SELECT 'asto', 4.00, NULL                                                             -- ASTO – 4€
	UNION ALL SELECT 'waaler-rose-test', 5.00, NULL                                                 -- WALLER ROSE – 5€
	UNION ALL SELECT 'ana-antinuclear-antibodies', 20.00, NULL                                      -- ANA – 20€
	UNION ALL SELECT 'dsdna-igm-antibodies', 15.00, NULL                                            -- ds DNA-M – 15€
	UNION ALL SELECT 'dsdna-igg-antibodies', 15.00, NULL                                            -- ds DNA-G – 15€
	UNION ALL SELECT 'transglutaminase-iga-antibodies', 15.00, NULL                                 -- At na tkivnu transglutaminazu IgA – 15€
	UNION ALL SELECT 'transglutaminase-igg-antibodies', 15.00, NULL                                 -- At na tkivnu transglutaminazu IgG – 15€
	UNION ALL SELECT 'anticardiolipin-igm', 15.00, NULL                                             -- Kardiolipinska antitijela IgM – 15€
	UNION ALL SELECT 'anticardiolipin-igg', 15.00, NULL                                             -- Kardiolipinska antitijela IgG – 15€
	UNION ALL SELECT 'gliadin-iga-antibodies', 15.00, NULL                                          -- Gliadin-A – 15€
	UNION ALL SELECT 'gliadin-igg-antibodies', 15.00, NULL                                          -- Gliadin-G – 15€
	UNION ALL SELECT 'beta-2-glycoprotein-i-igm', 15.00, NULL                                       -- Beta 2 glikoprotein-M – 15€
	UNION ALL SELECT 'beta-2-glycoprotein-i-igg', 15.00, NULL                                       -- Beta 2 glikoprotein-G – 15€
	UNION ALL SELECT 'anti-gad-antibodies', 20.00, NULL                                             -- At na glutamat dekarboksilazu (GAD) IgG – 20€
	UNION ALL SELECT 'ia-2-antibodies', 20.00, NULL                                                 -- At na tirozin fosfatazu (IA2) IgG – 20€
	UNION ALL SELECT 'ovarian-antibodies', 20.00, NULL                                              -- Anti ovarijalna antitijela – 20€
	UNION ALL SELECT 'spermatozoa-antibodies-asa', 35.00, NULL                                      -- Anti spermatozoidna antitijela – 35
	UNION ALL SELECT 'helicobacter-pylori-iga', 13.00, NULL                                         -- Helicobacter pylori IgA – 13€
	UNION ALL SELECT 'helicobacter-pylori-igg', 13.00, NULL                                         -- Helicobakter pylori IgG – 13€
	UNION ALL SELECT 'iga', 5.00, NULL                                                              -- Imunoglobulin A – 5€
	UNION ALL SELECT 'igm', 5.00, NULL                                                              -- Imunoglobulin M – 5€
	UNION ALL SELECT 'igg', 11.00, NULL                                                             -- Imunoglobulin G – 11€
	UNION ALL SELECT 'ige', 11.00, NULL                                                             -- Imunoglobulin E – 11€
	UNION ALL SELECT 'c3-complement', 5.00, NULL                                                    -- C – 3 – 5€
	UNION ALL SELECT 'c4-complement', 5.00, NULL                                                    -- C – 4 – 5€
	UNION ALL SELECT 'tsh', 6.00, NULL                                                              -- TSH – 6€
	UNION ALL SELECT 't3', 6.00, NULL                                                               -- T3 – 6€
	UNION ALL SELECT 't4', 6.00, NULL                                                               -- T4 – 6€
	UNION ALL SELECT 'free-t3', 11.00, NULL                                                         -- FT3 – 11€
	UNION ALL SELECT 'free-t4', 11.00, NULL                                                         -- FT4 – 11€
	UNION ALL SELECT 'anti-thyroglobulin-antibodies', 15.00, NULL                                   -- TgAt – 15€
	UNION ALL SELECT 'anti-tpo', 15.00, NULL                                                        -- Anti TPO – 15€
	UNION ALL SELECT 'anti-tshr', 25.00, NULL                                                       -- Anti TSHR – 25€
	UNION ALL SELECT 'thyroglobulin', 12.00, NULL                                                   -- Tireoglobulin – 12€
	UNION ALL SELECT 'calcitonin', 15.00, NULL                                                      -- Kalcitonin – 15€
	UNION ALL SELECT 'cortisol', 10.00, NULL                                                        -- Kortizol – 10€
	UNION ALL SELECT 'pth', 15.00, NULL                                                             -- PTH – 15€
	UNION ALL SELECT 'insulin', 12.00, NULL                                                         -- Insulin – 12€
	UNION ALL SELECT 'c-peptide', 12.00, NULL                                                       -- C – peptid – 12€
	UNION ALL SELECT 'beta-hcg', 15.00, NULL                                                        -- Beta HCG – 15€
	UNION ALL SELECT 'triple-test-second-trimester-screening', 45.00, NULL                          -- Tripl test (14 – 19 nedelja) – 45€
	UNION ALL SELECT 'double-test-first-trimester-screening', 38.00, NULL                           -- Dabl test (8 – 13 nedelja) – 38€
	UNION ALL SELECT 'papp-a', 16.00, NULL                                                          -- PAPP – A – 16€
	UNION ALL SELECT 'free-beta-hcg', 17.00, NULL                                                   -- Free beta HCG – 17€
	UNION ALL SELECT 'free-estriol', 15.00, NULL                                                    -- Free estriol – 15€
	UNION ALL SELECT 'afp', 12.00, NULL                                                             -- AFP – 12€
	UNION ALL SELECT 'fsh', 7.00, NULL                                                              -- FSH – 7€
	UNION ALL SELECT 'lh', 7.00, NULL                                                               -- LH – 7€
	UNION ALL SELECT 'prolactin', 7.00, NULL                                                        -- Prolaktin – 7€
	UNION ALL SELECT 'estradiol', 8.00, NULL                                                        -- Estradiol – 8€
	UNION ALL SELECT 'progesterone', 8.00, NULL                                                     -- Progesteron – 8€
	UNION ALL SELECT 'testosterone', 10.00, NULL                                                    -- Testosteron – 10€
	UNION ALL SELECT 'free-testosterone', 25.00, NULL                                               -- Free testosteron – 25€
	UNION ALL SELECT 'dhea-s', 12.00, NULL                                                          -- DHEAS – 12€
	UNION ALL SELECT 'shbg', 15.00, NULL                                                            -- SHBG – 15€
	UNION ALL SELECT 'androstenedione', 16.00, NULL                                                 -- Androstendion – 16€
	UNION ALL SELECT 'anti-mullerian-hormone', 30.00, NULL                                          -- Antimilerov Hormon – 30€
	UNION ALL SELECT 'inhibin-b', 20.00, NULL                                                       -- Inhibin B – 20€
	UNION ALL SELECT '17-hydroxyprogesterone', 15.00, NULL                                          -- 17-OHP – 15€
	UNION ALL SELECT 'acth', 18.00, NULL                                                            -- ACTH – 18€
	UNION ALL SELECT 'renin', 30.00, NULL                                                           -- Renin – 30€
	UNION ALL SELECT 'nt-probnp', 40.00, NULL                                                       -- NT pro-BNP – 40€
	UNION ALL SELECT 'psa', 14.00, NULL                                                             -- PSA – 14€
	UNION ALL SELECT 'free-psa', 14.00, NULL                                                        -- Free PSA – 14€
	UNION ALL SELECT 'cea', 14.00, NULL                                                             -- CEA – 14€
	UNION ALL SELECT 'ca-15-3', 14.00, NULL                                                         -- CA-15-3 – 14€
	UNION ALL SELECT 'ca-125', 14.00, NULL                                                          -- CA-125 – 14€
	UNION ALL SELECT 'ca-19-9', 14.00, NULL                                                         -- CA-19.9 – 14€
	UNION ALL SELECT 'cyfra-21-1', 15.00, NULL                                                      -- CYFRA 21-1 – 15€
	UNION ALL SELECT 'nse', 15.00, NULL                                                             -- NSE – 15€
	UNION ALL SELECT 'protein-s-100', 25.00, NULL                                                   -- S 100 – 25€
	UNION ALL SELECT 'ca-72-4', 20.00, NULL                                                         -- CA-72-4 – 20€
	UNION ALL SELECT 'he4', 25.00, NULL                                                             -- HE-4 – 25€
	UNION ALL SELECT 'chromogranin-a', 40.00, NULL                                                  -- Hromogranin A – 40€
	UNION ALL SELECT '5-hiaa', 25.00, NULL                                                          -- 5-HIAA – 25€
	UNION ALL SELECT 'roma-index', 38.00, NULL                                                      -- Roma Index (CA-125+ HE-4) – 38€
	UNION ALL SELECT 'vitamin-d-25-oh', 25.00, NULL                                                 -- Vitamin D – 25€
	UNION ALL SELECT 'vitamin-b12', 15.00, NULL                                                     -- Vitamin B12 – 15€
	UNION ALL SELECT 'vma', 15.00, NULL                                                             -- VMA – 15€
	UNION ALL SELECT 'valproic-acid', 20.00, NULL                                                   -- Valproati – 20€
	UNION ALL SELECT 'fecal-occult-blood', 15.00, NULL                                              -- Test na okultno krvarenje (bakterijska serologija) -15€
	UNION ALL SELECT 'helicobacter-pylori-antigen-in-feces', 15.00, NULL                            -- Test na Helicobacter pylori Ag (imunohromatografija) -15€
	UNION ALL SELECT 'complete-urinalysis', 5.00, NULL                                              -- Citohemijska analiza urina – 5€
	UNION ALL SELECT 'uric-acid-in-urine', 3.00, NULL                                               -- Mokraćna kiselina u urinu – 3€
	UNION ALL SELECT 'protein-in-urine', 10.00, NULL                                                -- Proteini u urinu – 10€
	UNION ALL SELECT 'microalbumin-in-urine', 10.00, NULL                                           -- Albumin u urinu – 10€
	UNION ALL SELECT 'amylase-in-urine', 2.00, NULL                                                 -- Amilaza u urinu – 2€
	UNION ALL SELECT 'calcium-in-urine', 3.00, NULL                                                 -- Kalcijum u urinu – 3€
	UNION ALL SELECT 'phosphorus-in-urine', 3.00, NULL                                              -- Fosfor u urinu – 3€
	UNION ALL SELECT 'drug-panel-10-ii', 40.00, NULL                                                -- Test na psihoaktivne supstance (panel od 10 testova) – 40€
	UNION ALL SELECT 'drug-panel-5-new', 25.00, NULL                                                -- Test na psihoaktivne supstance (panel od 5 testova) – 25€
) AS p
JOIN lab_tests lt ON lt.slug = p.slug;

-- ═══════════════════════════════════════════════════════════════
-- PART 4: SYNONYMS (clinic wording the catalog did not cover)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT ms.id, s.another_name, s.language
FROM (
	          SELECT 'cupping-therapy' AS slug, 'Hidžama' AS another_name, 'sr' AS language
	UNION ALL SELECT 'cupping-therapy', 'Хиџама', 'sr-cyrl'
	UNION ALL SELECT 'cupping-therapy', 'Хиджама', 'ru'
	UNION ALL SELECT 'cupping-therapy', 'Hijama', 'en'
	UNION ALL SELECT 'pharmacological-stress-echo-test-dobutamine', 'Dobutaminski test', 'sr'
	UNION ALL SELECT 'pharmacological-stress-echo-test-dobutamine', 'Добутамински тест', 'sr-cyrl'
	UNION ALL SELECT 'pharmacological-stress-echo-test-dobutamine', 'Dobutamine Stress Echo', 'en'
	UNION ALL SELECT 'pharmacological-stress-echo-test-dobutamine', 'Добутаминовая стресс-эхокардиография', 'ru'
	UNION ALL SELECT 'holter-blood-pressure-24h', 'Holter TA', 'sr'
	UNION ALL SELECT 'holter-blood-pressure-24h', 'Холтер ТА', 'sr-cyrl'
	UNION ALL SELECT 'ergometry-stress-test', 'TFO', 'sr'
	UNION ALL SELECT 'ergometry-stress-test', 'ТФО', 'sr-cyrl'
	UNION ALL SELECT 'home-blood-draw', 'Uzorkovanje u kući', 'sr'
	UNION ALL SELECT 'home-blood-draw', 'Узорковање у кући', 'sr-cyrl'
	UNION ALL SELECT 'home-blood-draw', 'Вађење крви у кући', 'sr-cyrl'
	UNION ALL SELECT 'home-blood-draw', 'Vađenje krvi u kući', 'sr'
	UNION ALL SELECT 'occupational-medicine-specialist-examination', 'Pregled medicine rada', 'sr'
	UNION ALL SELECT 'occupational-medicine-specialist-examination', 'Преглед медицине рада', 'sr-cyrl'
	UNION ALL SELECT 'occupational-medicine-specialist-examination', 'Профпатолог', 'ru'
) AS s
JOIN medical_services ms ON ms.slug = s.slug;

-- lab_test_synonyms: UNIQUE (another_name, language) across all tests — INSERT IGNORE skips taken names
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT lt.id, s.another_name, s.language
FROM (
	          SELECT 'lupus-anticoagulant' AS slug, 'LA1' AS another_name, 'en' AS language
	UNION ALL SELECT 'lupus-anticoagulant', 'LA 1', 'sr'
	UNION ALL SELECT 'complete-urinalysis', 'Citohemijska analiza urina', 'sr'
	UNION ALL SELECT 'complete-urinalysis', 'Цитохемијска анализа урина', 'sr-cyrl'
	UNION ALL SELECT 'beta-crosslaps', 'Beta Cross Laps', 'en'
	UNION ALL SELECT 'triple-test-second-trimester-screening', 'Tripl test', 'sr'
	UNION ALL SELECT 'triple-test-second-trimester-screening', 'Трипл тест', 'sr-cyrl'
	UNION ALL SELECT 'double-test-first-trimester-screening', 'Dabl test', 'sr'
	UNION ALL SELECT 'double-test-first-trimester-screening', 'Дабл тест', 'sr-cyrl'
	UNION ALL SELECT 'ovarian-antibodies', 'Anti ovarijalna antitijela', 'sr'
	UNION ALL SELECT 'ovarian-antibodies', 'Анти оваријална антитијела', 'sr-cyrl'
	UNION ALL SELECT 'spermatozoa-antibodies-asa', 'Anti spermatozoidna antitijela', 'sr'
	UNION ALL SELECT 'spermatozoa-antibodies-asa', 'Анти сперматозоидна антитијела', 'sr-cyrl'
) AS s
JOIN lab_tests lt ON lt.slug = s.slug;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: one row, the clinic id on this database (prod: 39)
SELECT id, slug FROM clinics WHERE slug = 'vase-zdravlje-podgorica';

-- expected: services = 88, price sum = 3070.00, with range = 5, outdated = 0
SELECT COUNT(*) AS services, SUM(price) AS price_sum, SUM(price_max IS NOT NULL) AS with_range, SUM(is_price_outdated) AS outdated
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- expected: lab_tests = 147, price sum = 1816.00, outdated = 0
SELECT COUNT(*) AS lab_tests, SUM(price) AS price_sum, SUM(is_price_outdated) AS outdated
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

-- expected: 16 rows, each with at least one specialty; categories everywhere except psychological-counseling
SELECT ms.id, ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS categories,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specialties
FROM medical_services ms WHERE ms.slug IN (
	'home-therapy-administration',
	'occupational-medicine-specialist-examination',
	'follow-up-occupational-medicine-specialist-examination',
	'residual-work-capacity-assessment',
	'medical-certificate-for-firefighters',
	'medical-certificate-for-unarmed-security-personnel',
	'medical-certificate-for-traffic-school-enrollment',
	'medical-certificate-copy',
	'psychological-counseling',
	'gynecological-examination-with-swab-collection',
	'follow-up-hematologist-examination',
	'psychiatrist-home-visit',
	'neurologist-home-visit',
	'x-ray-per-segment',
	'home-x-ray',
	'home-blood-draw'
);
