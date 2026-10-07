SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Naša medicina (Подгорица) — синхронизация цен с сайтом.
--
-- Источник — https://nasa-medicina.me/usluge/ (одна страница-прайс), снят
-- 2026-10-02: data/clinic-pricelists/sources/nasa-medicina-podgorica/2026-10-02.html.
-- Дата прайса — lastmod страницы /usluge/ в wp-sitemap-posts-page-1.xml:
-- 2026-06-15. Прайс свежий, is_price_outdated = 0.
-- Сравнение построчно — data/clinic-imports/nasa-medicina-podgorica-prices-2026-10.md.
--
-- На сайте 30 позиций, 33 цены (у спортсменов 4 цены в одной строке).
-- В БД было 19 строк, цены у 6; прод = локальная (сверено через API).
--   меняется цена         3  (40→45, 35→45, 40→45)
--   совпадает             3
--   цена появилась       13  (строка была с NULL)
--   новые строки          12 (5 на существующие записи каталога, 7 на новые)
--   is_obsolete           0  (все 19 строк БД есть на сайте)
--
-- «za smještaj u ustanove socijalne zaštite» — новая запись, а не дом
-- престарелых (medical-certificate-for-elderly-home-accommodation): учреждения
-- соцзащиты шире. Решение юзера 2026-10-02.
--
-- Спортсмены: «do 14 god. 15 €, do 18 god. 20 €, do 25 god. 25 €» — в каталоге
-- справки по возрасту не делятся, поэтому диапазон 15–25 на
-- medical-certificate-for-athletes. «Sportske sudije 40 €» — отдельная запись
-- medical-certificate-for-sports-referees.
--
-- Новые записи каталога (7): medical-certificate-copy,
-- medical-certificate-for-social-care-institution-accommodation,
-- psychological-counseling, psychological-mental-status-assessment, iq-test,
-- cognitive-function-assessment-for-school-or-work,
-- psychological-testing-for-suspected-dementia.
--
-- Попутно: clinics.google_place_id из data/google-places/podgorica/nasa-medicina.json
-- (телефон, сайт и 58 отзывов совпадают). Ставится, только если поле пустое и
-- этот place_id не занят другой клиникой (колонка UNIQUE).
--
-- Клиника и записи каталога — по slug (id локально и на проде расходятся).
-- Правки цен — с условием на старую цену: строку, поправленную руками, файл
-- не перезапишет. INSERT IGNORE / ON DUPLICATE KEY: повторный прогон безопасен.

-- ═══ 0. Google place_id клиники ═══

UPDATE clinics c
   SET c.google_place_id = 'ChIJn8uW797rTRMRrS2RaFjJif0'
 WHERE c.slug = 'nasa-medicina-podgorica'
   AND c.google_place_id IS NULL
   AND NOT EXISTS (SELECT 1 FROM (SELECT id FROM clinics WHERE google_place_id = 'ChIJn8uW797rTRMRrS2RaFjJif0') AS taken);

-- ═══ 1. Новые записи каталога ═══

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Medical Certificate for Social Care Institution Accommodation', 'medical-certificate-for-social-care-institution-accommodation', 'Ljekarsko uvjerenje za smještaj u ustanove socijalne zaštite', 'Љекарско увјерење за смјештај у установе социјалне заштите', 'Медицинская справка для размещения в учреждении социальной защиты', 'Ärztliches Attest für die Unterbringung in einer Sozialeinrichtung', 'Sosyal hizmet kurumuna yerleşim için sağlık raporu')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 9 FROM medical_services WHERE slug = 'medical-certificate-for-social-care-institution-accommodation';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 45 FROM medical_services WHERE slug = 'medical-certificate-for-social-care-institution-accommodation';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Ljekarsko uvjerenje za dom socijalne zaštite', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-social-care-institution-accommodation'
UNION ALL SELECT id, 'Љекарско увјерење за дом социјалне заштите', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-social-care-institution-accommodation'
UNION ALL SELECT id, 'Справка в учреждение социальной защиты', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-social-care-institution-accommodation';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Medical Certificate Copy', 'medical-certificate-copy', 'Prepis ljekarskog uvjerenja', 'Препис љекарског увјерења', 'Копия медицинской справки', 'Abschrift eines ärztlichen Attests', 'Sağlık raporu sureti')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 9 FROM medical_services WHERE slug = 'medical-certificate-copy';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 45 FROM medical_services WHERE slug = 'medical-certificate-copy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Duplikat ljekarskog uvjerenja', 'sr' FROM medical_services WHERE slug = 'medical-certificate-copy'
UNION ALL SELECT id, 'Дупликат љекарског увјерења', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-copy'
UNION ALL SELECT id, 'Duplicate Medical Certificate', 'en' FROM medical_services WHERE slug = 'medical-certificate-copy'
UNION ALL SELECT id, 'Дубликат медицинской справки', 'ru' FROM medical_services WHERE slug = 'medical-certificate-copy'
UNION ALL SELECT id, 'Duplikat des ärztlichen Attests', 'de' FROM medical_services WHERE slug = 'medical-certificate-copy'
UNION ALL SELECT id, 'Sağlık raporu kopyası', 'tr' FROM medical_services WHERE slug = 'medical-certificate-copy';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Psychological Counseling', 'psychological-counseling', 'Psihološko savjetovanje', 'Психолошко савјетовање', 'Психологическое консультирование', 'Psychologische Beratung', 'Psikolojik danışmanlık')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 22 FROM medical_services WHERE slug = 'psychological-counseling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Partnersko savjetovanje', 'sr' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Партнерско савјетовање', 'sr-cyrl' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Porodično psihološko savjetovanje', 'sr' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Породично психолошко савјетовање', 'sr-cyrl' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Couples Counseling', 'en' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Psychologist Consultation', 'en' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Консультация психолога', 'ru' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Консультирование пар', 'ru' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Paarberatung', 'de' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Çift danışmanlığı', 'tr' FROM medical_services WHERE slug = 'psychological-counseling';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Psychological Mental Status Assessment', 'psychological-mental-status-assessment', 'Psihološka procjena mentalnog stanja', 'Психолошка процјена менталног стања', 'Психологическая оценка психического состояния', 'Psychologische Beurteilung des psychischen Zustands', 'Psikolojik ruhsal durum değerlendirmesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 22 FROM medical_services WHERE slug = 'psychological-mental-status-assessment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Procjena psihičkog statusa', 'sr' FROM medical_services WHERE slug = 'psychological-mental-status-assessment'
UNION ALL SELECT id, 'Процјена психичког статуса', 'sr-cyrl' FROM medical_services WHERE slug = 'psychological-mental-status-assessment'
UNION ALL SELECT id, 'Mental Status Assessment', 'en' FROM medical_services WHERE slug = 'psychological-mental-status-assessment'
UNION ALL SELECT id, 'Оценка психического статуса', 'ru' FROM medical_services WHERE slug = 'psychological-mental-status-assessment';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('IQ Test', 'iq-test', 'Test inteligencije (IQ)', 'Тест интелигенције (IQ)', 'Тест на интеллект (IQ)', 'Intelligenztest (IQ)', 'Zeka testi (IQ)')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 22 FROM medical_services WHERE slug = 'iq-test';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Procjena inteligencije', 'sr' FROM medical_services WHERE slug = 'iq-test'
UNION ALL SELECT id, 'Процјена интелигенције', 'sr-cyrl' FROM medical_services WHERE slug = 'iq-test'
UNION ALL SELECT id, 'Intelligence Test', 'en' FROM medical_services WHERE slug = 'iq-test'
UNION ALL SELECT id, 'Тест IQ', 'ru' FROM medical_services WHERE slug = 'iq-test'
UNION ALL SELECT id, 'Оценка интеллекта', 'ru' FROM medical_services WHERE slug = 'iq-test'
UNION ALL SELECT id, 'IQ-Test', 'de' FROM medical_services WHERE slug = 'iq-test'
UNION ALL SELECT id, 'IQ testi', 'tr' FROM medical_services WHERE slug = 'iq-test';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Cognitive Function Assessment for School or Work', 'cognitive-function-assessment-for-school-or-work', 'Procjena kognitivnih funkcija za školovanje ili rad', 'Процјена когнитивних функција за школовање или рад', 'Оценка когнитивных функций для учёбы или работы', 'Beurteilung kognitiver Funktionen für Schule oder Beruf', 'Eğitim veya iş için bilişsel fonksiyon değerlendirmesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 22 FROM medical_services WHERE slug = 'cognitive-function-assessment-for-school-or-work';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Psychological Testing for Suspected Dementia', 'psychological-testing-for-suspected-dementia', 'Psihološko testiranje kod sumnje na demenciju', 'Психолошко тестирање код сумње на деменцију', 'Психологическое тестирование при подозрении на деменцию', 'Psychologische Testung bei Verdacht auf Demenz', 'Demans şüphesinde psikolojik test')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 22 FROM medical_services WHERE slug = 'psychological-testing-for-suspected-dementia';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Test na demenciju', 'sr' FROM medical_services WHERE slug = 'psychological-testing-for-suspected-dementia'
UNION ALL SELECT id, 'Тест на деменцију', 'sr-cyrl' FROM medical_services WHERE slug = 'psychological-testing-for-suspected-dementia'
UNION ALL SELECT id, 'Dementia Screening', 'en' FROM medical_services WHERE slug = 'psychological-testing-for-suspected-dementia'
UNION ALL SELECT id, 'Тест на деменцию', 'ru' FROM medical_services WHERE slug = 'psychological-testing-for-suspected-dementia'
UNION ALL SELECT id, 'Demenztest', 'de' FROM medical_services WHERE slug = 'psychological-testing-for-suspected-dementia'
UNION ALL SELECT id, 'Demans testi', 'tr' FROM medical_services WHERE slug = 'psychological-testing-for-suspected-dementia';

-- ═══ 2. Меняется цена ═══

-- «sposobnosti za rad na radnim mjestima sa povećanim rizikom i otežanim uslovima rada – prethodni/periodični/vanredni/sistematski – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 40→45

-- «sposobnosti za rad na radnim mjestima bez povećanih rizika i otežanim uslovima rada – prethodni/periodični/vanredni – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-difficult-working-conditions-without-high-risk'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 35→45

-- «za upravljanje vozilom, C,D i E kategorije, specijalnim vozilima i taxi – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-professional-drivers'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 40→45

-- ═══ 3. Цена появилась (строка была с NULL) ═══

-- «za posao instruktora B,C,D i E kategorije – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-driving-instructor-category-b-c-d-e'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za upravljanje čamcom do 12 metara – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-boat-operation-up-to-12-meters'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za posjedovanje vatrenog oružja – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-firearms-possession'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za obavljanje službe u Vojsci Crne Gore – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-military-service'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za sklapanje braka za maloljetne osobe – 25 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-underage-marriage'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 25.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za podobnost za usvajanje djeteta – 25 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-child-adoption'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 25.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za posao sudskog vještaka – 25 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-court-expert'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 25.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za dalji nastavak školovanja i boravak u inostranstvu/viza – 25 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-study-abroad-and-visa'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 25.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za životno osiguranje – 45 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-life-insurance'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 45.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za kolektivni smještaj – 10 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-collective-accommodation'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 10.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za sportiste (do 14 god.-15€, do 18 god.-20 €, do 25 god. – 25 €, …)» → диапазон 15–25
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-athletes'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 15.00, r.price_min = NULL, r.price_max = 25.00, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za boravak i rad u Crnoj Gori – 25 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-residence-and-work-in-montenegro'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 25.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- «za rad u vodenom saobraćaju (pomorci) – 120 €»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-certificate-for-maritime-workers'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nasa-medicina-podgorica'
   SET r.price = 120.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price IS NULL AND r.price_min IS NULL AND r.price_max IS NULL;

-- ═══ 4. Новые строки клиники ═══

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-sports-referees' WHERE c.slug = 'nasa-medicina-podgorica'; -- «za sportiste (… sportske sudije- 40 €)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 5.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-copy' WHERE c.slug = 'nasa-medicina-podgorica'; -- «prepis ljekarskog uvjerenja – 5 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 25.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-social-care-institution-accommodation' WHERE c.slug = 'nasa-medicina-podgorica'; -- «za smještaj u ustanove socijalne zaštite – 25 €»

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'first-psychiatrist-examination' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Prvi pregled specijaliste psihijatra 40 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 35.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'follow-up-psychiatrist-examination' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Kontrolni pregled specijaliste psihijatra 35 €»

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'first-psychological-examination' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Psihološki pregled – 40 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'psychological-counseling' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Psihološko savjetovanje (individualno/partnersko/porodično) – 40 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 150.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'neuropsychological-examination-with-cognitive-assessment-for-adults' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Psihološko testiranje 1 (baterija testova – kognitivno funkcionisanje komb. 4/6 testova za svrhe psihijatra/neurologa; za odrasle) – 150 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 130.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'psychological-mental-status-assessment' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Psihološko testiranje 2 (baterija testova – procjena mentalnog stanja/psihičkog statusa komb. 3/6 testa …; za djecu i odrasle) – 130 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 100.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'iq-test' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Psihološko testiranje 3 (procjena inteligencije 1 test različite svrhe; za djecu i odrasle) – 100 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 100.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'cognitive-function-assessment-for-school-or-work' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Psihološko testiranje 4 (procjena kognitivnih funkcija u svrhu školovanja, rada i td komb. 2/3 testa; za djecu i odrasle) – 100 €»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 60.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'psychological-testing-for-suspected-dementia' WHERE c.slug = 'nasa-medicina-podgorica'; -- «Psihološko testiranje 5 (sumnja na demenciju – komb.4 testa bez testa inteligencije) – 60 €»

-- ═══ VERIFICATION ═══

-- Ожидается place_id ChIJn8uW797rTRMRrS2RaFjJif0. NULL — значит, id уже занят другой клиникой: проверить, какой.
SELECT id, slug, google_place_id FROM clinics WHERE slug = 'nasa-medicina-podgorica' OR google_place_id = 'ChIJn8uW797rTRMRrS2RaFjJif0';

-- Ожидается 31 строка: все с ценой, is_obsolete = 0, is_price_outdated = 0.
SELECT ms.slug, cms.price, cms.price_min, cms.price_max, cms.is_price_outdated, cms.is_obsolete
  FROM clinic_medical_services cms
  JOIN medical_services ms ON ms.id = cms.medical_service_id
  JOIN clinics c ON c.id = cms.clinic_id
 WHERE c.slug = 'nasa-medicina-podgorica'
 ORDER BY ms.slug;

-- Ожидается: total = 31, priced = 31.
SELECT COUNT(*) AS total,
       SUM(cms.price IS NOT NULL OR cms.price_min IS NOT NULL) AS priced
  FROM clinic_medical_services cms
  JOIN clinics c ON c.id = cms.clinic_id
 WHERE c.slug = 'nasa-medicina-podgorica';

-- Новые записи каталога: 7 строк, у каждой специальность, синонимы у всех, кроме cognitive-function-assessment-for-school-or-work.
SELECT ms.id, ms.slug,
       (SELECT GROUP_CONCAT(s.specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specialties,
       (SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS categories,
       (SELECT COUNT(*) FROM medical_service_synonyms y WHERE y.medical_service_id = ms.id) AS synonyms
  FROM medical_services ms
 WHERE ms.slug IN ('medical-certificate-copy', 'medical-certificate-for-social-care-institution-accommodation', 'psychological-counseling', 'psychological-mental-status-assessment',
                   'iq-test', 'cognitive-function-assessment-for-school-or-work', 'psychological-testing-for-suspected-dementia');
