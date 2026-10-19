-- ═══════════════════════════════════════════════════════════════════════════
-- Medicinski centar dr Zobin (Dobrota, Kotor) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-medicinski-centar-dr-zobin-kotor-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-medicinski-centar-dr-zobin-kotor.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/medicinski-centar-dr-zobin-kotor.json.
-- 
-- Услуг: 9, с ценой: 0 — настоящего прайса нет (/tseny/ — шаблон в рублях, игнорируется). Новых записей каталога: 9
-- (drug-addiction-treatment, alcohol-addiction-treatment, opioid-addiction-treatment, smoking-cessation-treatment, gambling-addiction-treatment, depression-treatment, anxiety-disorder-treatment, insomnia-treatment, medical-detoxification) — общие с MonteRehab (monterehab-budva), создаются идемпотентно в обоих services-SQL.
-- Амбулаторного лечения зависимостей и расстройств в каталоге не было — только стационарные DRG-тарифы. Записи без категории (как вся психиатрия каталога).
-- «Лечение прочих психических и поведенческих расстройств» — не заведено (собирательная страница без конкретной услуги, см. excluded в записи импорта).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJF5cdFWYzTBMReM2jCGw4OrM' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'medicinski-centar-dr-zobin-kotor' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-medicinski-centar-dr-zobin-kotor.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Зобин: «Лечение всех видов наркотической зависимости», «Лечение зависимости от психостимуляторов и каннабиса»; MonteRehab: «Drug addiction». В каталоге только стационарные DRG (hospitalization-for-drug-intoxication-and-withdrawal, …-other-drug-use-disorders) и methadone-administration — амбулаторного/реабилитационного лечения наркозависимости нет. Спец. 21 + 51. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'drug-addiction-treatment', 'Drug Addiction Treatment', 'Liječenje zavisnosti od droga', 'Лијечење зависности од дрога',
	'Лечение наркотической зависимости', 'Behandlung der Drogenabhängigkeit', 'Uyuşturucu bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'drug-addiction-treatment' OR name_en = 'Drug Addiction Treatment');

-- Зобин: «Лечение алкогольной зависимости»; MonteRehab: «Alcohol addiction». В каталоге только DRG-госпитализации (hospitalization-for-alcohol-…). Спец. 21 + 51. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alcohol-addiction-treatment', 'Alcohol Addiction Treatment', 'Liječenje zavisnosti od alkohola', 'Лијечење зависности од алкохола',
	'Лечение алкогольной зависимости', 'Behandlung der Alkoholabhängigkeit', 'Alkol bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alcohol-addiction-treatment' OR name_en = 'Alcohol Addiction Treatment');

-- Зобин: отдельная услуга «Лечение опиоидной зависимости» (свой протокол: воздержание 3 недели, 2 дня); MonteRehab: «Treatment of heroin / methadone / codeine addiction», «Treatment for tramadol», «Treatment for opiates». Опиоидная зависимость — устойчивое отдельное направление (ср. methadone-administration, hospitalization-for-opioid-use-disorders-and-dependence); амбулаторной записи нет. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'opioid-addiction-treatment', 'Opioid Addiction Treatment', 'Liječenje zavisnosti od opioida', 'Лијечење зависности од опиоида',
	'Лечение опиоидной зависимости', 'Behandlung der Opioidabhängigkeit', 'Opioid bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'opioid-addiction-treatment' OR name_en = 'Opioid Addiction Treatment');

-- Зобин: «Лечение табакокурения» (препараты ≥7 дней + однодневная процедура), «Отказ от курения — табакокурение, курение е-сигарет и вейпов». В каталоге нет ни под одним названием (smok|nicotin|pušen — пусто). Спец. 21. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'smoking-cessation-treatment', 'Smoking Cessation Treatment', 'Liječenje zavisnosti od pušenja', 'Лијечење зависности од пушења',
	'Лечение табачной зависимости', 'Raucherentwöhnung', 'Sigara bırakma tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'smoking-cessation-treatment' OR name_en = 'Smoking Cessation Treatment');

-- Зобин: «Лечение пристрастия к азартным играм» (три сеанса за пять дней); MonteRehab: «Treatment of gambling addiction». В каталоге нет. Отдельно от behavioral-addiction-treatment: у Зобина — только азартные игры, а «поведенческие зависимости» MonteRehab шире (интернет, шопинг, секс, еда). Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'gambling-addiction-treatment', 'Gambling Addiction Treatment', 'Liječenje zavisnosti od kockanja', 'Лијечење зависности од коцкања',
	'Лечение игровой зависимости', 'Behandlung der Spielsucht', 'Kumar bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'gambling-addiction-treatment' OR name_en = 'Gambling Addiction Treatment');

-- Зобин: «Лечение депрессий» (протокол 5–12 дней); MonteRehab: «Depression treatment». В каталоге только DRG (hospitalization-for-major-affective-disorders). Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'depression-treatment', 'Depression Treatment', 'Liječenje depresije', 'Лијечење депресије',
	'Лечение депрессии', 'Depressionsbehandlung', 'Depresyon tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'depression-treatment' OR name_en = 'Depression Treatment');

-- Зобин: «Лечение тревожных расстройств»; MonteRehab: «Anxiety treatment». В каталоге только DRG (hospitalization-for-anxiety-disorders). Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'anxiety-disorder-treatment', 'Anxiety Disorder Treatment', 'Liječenje anksioznih poremećaja', 'Лијечење анксиозних поремећаја',
	'Лечение тревожных расстройств', 'Behandlung von Angststörungen', 'Anksiyete bozukluğu tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'anxiety-disorder-treatment' OR name_en = 'Anxiety Disorder Treatment');

-- MonteRehab: «Insomnia treatment»; Зобин (главная): «предоставляет услуги по лечению: … нарушений сна». В каталоге только ЭЭГ во сне и апноэ. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'insomnia-treatment', 'Insomnia Treatment', 'Liječenje nesanice', 'Лијечење несанице',
	'Лечение бессонницы', 'Behandlung von Schlaflosigkeit', 'Uykusuzluk tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'insomnia-treatment' OR name_en = 'Insomnia Treatment');

-- MonteRehab: «Medical detox … under the supervision of experienced narcologists»; Зобин: «В некоторых случаях возможно проведение подготовительного детоксикационного периода в нашем центре». В каталоге нет (detox|detoks — пусто; есть только DRG «intoksikacija … i apstinencija»). Спец. 21. Способ (инфузии и т.п.) не назван — категорию 29 не ставим.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'medical-detoxification', 'Medical Detoxification', 'Medicinska detoksikacija', 'Медицинска детоксикација',
	'Медицинская детоксикация', 'Medizinische Entgiftung', 'Tıbbi detoksifikasyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'medical-detoxification' OR name_en = 'Medical Detoxification');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 21 FROM medical_services WHERE slug IN ('drug-addiction-treatment', 'alcohol-addiction-treatment', 'opioid-addiction-treatment', 'smoking-cessation-treatment', 'gambling-addiction-treatment', 'depression-treatment', 'anxiety-disorder-treatment', 'insomnia-treatment', 'medical-detoxification');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 51 FROM medical_services WHERE slug IN ('drug-addiction-treatment', 'alcohol-addiction-treatment', 'opioid-addiction-treatment', 'gambling-addiction-treatment', 'depression-treatment', 'anxiety-disorder-treatment', 'insomnia-treatment');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Liječenje narkomanije', 'sr' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Лијечење наркоманије', 'sr-cyrl' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Zavisnost od droga', 'sr' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Зависност од дрога', 'sr-cyrl' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Liječenje zavisnosti od psihostimulansa i kanabisa', 'sr' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Лијечење зависности од психостимуланса и канабиса', 'sr-cyrl' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Лечение наркомании', 'ru' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Лечение зависимости от психостимуляторов и каннабиса', 'ru' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Drug Rehab', 'en' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Substance Abuse Treatment', 'en' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Drogentherapie', 'de' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Madde bağımlılığı tedavisi', 'tr' FROM medical_services WHERE slug = 'drug-addiction-treatment'
UNION ALL SELECT id, 'Liječenje alkoholizma', 'sr' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Лијечење алкохолизма', 'sr-cyrl' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Лечение алкоголизма', 'ru' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alcohol Rehab', 'en' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alcoholism Treatment', 'en' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alkoholentzug', 'de' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alkolizm tedavisi', 'tr' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Liječenje zavisnosti od opijata', 'sr' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Лијечење зависности од опијата', 'sr-cyrl' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Liječenje zavisnosti od heroina', 'sr' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Лијечење зависности од хероина', 'sr-cyrl' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Лечение героиновой зависимости', 'ru' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Heroin Addiction Treatment', 'en' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Opiate Addiction Treatment', 'en' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Heroinsucht', 'de' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Eroin bağımlılığı tedavisi', 'tr' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Odvikavanje od pušenja', 'sr' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Одвикавање од пушења', 'sr-cyrl' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Liječenje pušenja', 'sr' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Лијечење пушења', 'sr-cyrl' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Лечение табакокурения', 'ru' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Отказ от курения', 'ru' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Quit Smoking Treatment', 'en' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Nicotine Addiction Treatment', 'en' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Nikotinsucht', 'de' FROM medical_services WHERE slug = 'smoking-cessation-treatment'
UNION ALL SELECT id, 'Lečenje zavisnosti od kockanja', 'sr' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лечење зависности од коцкања', 'sr-cyrl' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Ludomanija', 'sr' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лудоманија', 'sr-cyrl' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лечение игромании', 'ru' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лечение пристрастия к азартным играм', 'ru' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лудомания', 'ru' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Problem Gambling Treatment', 'en' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Glücksspielsucht', 'de' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Lečenje depresije', 'sr' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Лечење депресије', 'sr-cyrl' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Лечение депрессий', 'ru' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Depressionstherapie', 'de' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Liječenje anksioznosti', 'sr' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Лијечење анксиозности', 'sr-cyrl' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Лечение тревожности', 'ru' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Anxiety Treatment', 'en' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Angsttherapie', 'de' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Kaygı bozukluğu tedavisi', 'tr' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Poremećaji spavanja', 'sr' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Поремећаји спавања', 'sr-cyrl' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Лечение нарушений сна', 'ru' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Sleep Disorder Treatment', 'en' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Schlafstörungen', 'de' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Uyku bozukluğu tedavisi', 'tr' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Medical Detox', 'en' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Detox', 'en' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Detoksikacija', 'sr' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Детоксикација', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Детокс', 'ru' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Вывод из запоя', 'ru' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Entzug', 'de' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Detoks', 'tr' FROM medical_services WHERE slug = 'medical-detoxification';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_medicinski_centar_dr_zobin_kotor;
CREATE TEMPORARY TABLE tmp_medicinski_centar_dr_zobin_kotor (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_medicinski_centar_dr_zobin_kotor (slug, price, price_min, price_max) VALUES
('drug-addiction-treatment', NULL, NULL, NULL), -- /uslugi/lechenie_vsekh_vidov_narkoticheskoy_zavisimosti/: «Лечение всех видов наркотической зависимости» + /uslugi/lechenie_zavisimosti_ot_psikhostimulyatorov_i_kannabisa/: «Лечение зависимости от психостимуляторов и каннабиса» (одна запись: отдельной для стимуляторов/каннабиса не заводим — синонимом)
('alcohol-addiction-treatment', NULL, NULL, NULL), -- /uslugi/lechenie_alkogolnoy_zavisimosti/: «Лечение алкогольной зависимости … проводится в течение одного дня»
('opioid-addiction-treatment', NULL, NULL, NULL), -- /uslugi/lechenie_opioidnoy_zavisimosti/: «Лечение опиоидной зависимости … Типовой терапевтический протокол занимает два дня»
('smoking-cessation-treatment', NULL, NULL, NULL), -- /uslugi/lechenie_tabakokureniya/: «Лечение табакокурения», главная: «Отказ от курения — табакокурение, курение е-сигарет и вейпов»
('gambling-addiction-treatment', NULL, NULL, NULL), -- /uslugi/lechenie_pristrastiya_k_azartnym_igram/: «Лечение пристрастия к азартным играм … три лечебных сеанса в течение пяти дней»
('depression-treatment', NULL, NULL, NULL), -- /uslugi/lechenie_depressiy/: «Лечение депрессий … от 5 до 12 дней»
('anxiety-disorder-treatment', NULL, NULL, NULL), -- /uslugi/lechenie_trevozhnykh_rasstroystv/: «Лечение тревожных расстройств»
('insomnia-treatment', NULL, NULL, NULL), -- Главная: «Медицинский центр доктора Зобина предоставляет услуги по лечению: … нарушений сна», /treatment/: «различные нарушения сна»
('medical-detoxification', NULL, NULL, NULL); -- /uslugi/lechenie_vsekh_vidov…/ и /treatment/: «В некоторых случаях возможно проведение подготовительного детоксикационного периода в нашем центре»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_medicinski_centar_dr_zobin_kotor t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_medicinski_centar_dr_zobin_kotor t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_medicinski_centar_dr_zobin_kotor t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 9
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_medicinski_centar_dr_zobin_kotor_ds;
CREATE TEMPORARY TABLE tmp_medicinski_centar_dr_zobin_kotor_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_medicinski_centar_dr_zobin_kotor_ds (doctor_slug, service_slug) VALUES
('mihail-zobin', 'drug-addiction-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'alcohol-addiction-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'opioid-addiction-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'smoking-cessation-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'gambling-addiction-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'depression-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'anxiety-disorder-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'insomnia-treatment'), -- единственный врач центра, «Руководитель клинических программ»
('mihail-zobin', 'medical-detoxification'); -- единственный врач центра, «Руководитель клинических программ»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_medicinski_centar_dr_zobin_kotor_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_medicinski_centar_dr_zobin_kotor_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 9 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 9 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 9: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('drug-addiction-treatment', 'alcohol-addiction-treatment', 'opioid-addiction-treatment', 'smoking-cessation-treatment', 'gambling-addiction-treatment', 'depression-treatment', 'anxiety-disorder-treatment', 'insomnia-treatment', 'medical-detoxification');

DROP TEMPORARY TABLE IF EXISTS tmp_medicinski_centar_dr_zobin_kotor;
DROP TEMPORARY TABLE IF EXISTS tmp_medicinski_centar_dr_zobin_kotor_ds;
