-- ═══════════════════════════════════════════════════════════════════════════
-- MonteRehab (Blizikuće, Sveti Stefan — Budva) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-monterehab-budva-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-monterehab-budva.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/monterehab-budva.json.
-- 
-- Услуг: 18, с ценой: 3 — месячные программы /pricing (дата прайса — sitemap lastmod 2026-07-04). Новых записей каталога: 18
-- (все — новые; общие с Зобиным и Integra создаются идемпотентно в каждом services-SQL). Без категории — как вся психиатрия каталога.
-- Eurostandard single/double — одна запись с диапазоном price 6000 / price_max 9000 (программа одна, различается размещение). Скидка 10% от 3 месяцев — в описании клиники.
-- Лендинги футера (≈60 SEO-страниц по веществам) сведены к общим записям: опиоиды → opioid-addiction-treatment, азартные игры → gambling-addiction-treatment,
-- прочие вещества → drug-addiction-treatment, нехимические → behavioral-addiction-treatment, анорексия/булимия → eating-disorder-treatment.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJH5qWtknXTRMRvbZK1sxa4XQ' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'monterehab-budva' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-monterehab-budva.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- MonteRehab /pricing: «Eurostandard (double occupancy) €6,000 / month», «Eurostandard (single occupancy) €9,000 / month». Записей «в месяц» и вариантов размещения в каталоге нет (ближайшие — bed-day DRG); одна запись с диапазоном цены 6000–9000 (двухместное–одноместное размещение), а не две записи по типу номера: программа одна, различается только размещение. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'residential-addiction-treatment-per-month', 'Residential Addiction Treatment (per month)', 'Stacionarno liječenje zavisnosti (mjesečno)', 'Стационарно лијечење зависности (мјесечно)',
	'Стационарное лечение зависимостей (за месяц)', 'Stationäre Suchtbehandlung (pro Monat)', 'Yatılı bağımlılık tedavisi (aylık)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month' OR name_en = 'Residential Addiction Treatment (per month)');

-- MonteRehab /pricing: «Online program "Motivation and Recovery" €3,000 / month» (me: «Onlajn program „Motivacija i oporavak“ … Program se održava onlajn»). В каталоге нет. Название программы — синонимом. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'online-rehabilitation-program-per-month', 'Online Rehabilitation Program (per month)', 'Online program rehabilitacije (mjesečno)', 'Онлајн програм рехабилитације (мјесечно)',
	'Онлайн-программа реабилитации (за месяц)', 'Online-Rehabilitationsprogramm (pro Monat)', 'Online rehabilitasyon programı (aylık)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'online-rehabilitation-program-per-month' OR name_en = 'Online Rehabilitation Program (per month)');

-- MonteRehab /pricing: «Resocialization and education €3,500 / month» (me: «Resocijalizacija i obrazovanje … Smeštaj na teritoriji centra ili samostalno u najbližem gradu; Dnevno prisustvovanje obaveznim aktivnostima i sastancima sa mentorom; Podrška tokom obrazovanja i zapošljavanja»). В каталоге нет. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'resocialization-program-per-month', 'Resocialization Program (per month)', 'Program resocijalizacije (mjesečno)', 'Програм ресоцијализације (мјесечно)',
	'Программа ресоциализации (за месяц)', 'Resozialisierungsprogramm (pro Monat)', 'Yeniden sosyalleşme programı (aylık)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'resocialization-program-per-month' OR name_en = 'Resocialization Program (per month)');

-- Integra: «Grupna psihoterapija … iskustveno-terapijske grupe, 6-10 učesnika»; MonteRehab: «Group therapy online». В каталоге групповая психотерапия есть только как тарифные позиции FZOCG с конкретным профилем (…for-addictions, …anxiety-depression-or-psychotic-disorders, group-psychodynamic-and-sociodynamic-therapy) — общей записи нет. Спец. 21 + 22 + 51. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'group-psychotherapy', 'Group Psychotherapy', 'Grupna psihoterapija', 'Групна психотерапија',
	'Групповая психотерапия', 'Gruppenpsychotherapie', 'Grup psikoterapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'group-psychotherapy' OR name_en = 'Group Psychotherapy');

-- Зобин: «Лечение алкогольной зависимости»; MonteRehab: «Alcohol addiction». В каталоге только DRG-госпитализации (hospitalization-for-alcohol-…). Спец. 21 + 51. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'alcohol-addiction-treatment', 'Alcohol Addiction Treatment', 'Liječenje zavisnosti od alkohola', 'Лијечење зависности од алкохола',
	'Лечение алкогольной зависимости', 'Behandlung der Alkoholabhängigkeit', 'Alkol bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'alcohol-addiction-treatment' OR name_en = 'Alcohol Addiction Treatment');

-- Зобин: «Лечение всех видов наркотической зависимости», «Лечение зависимости от психостимуляторов и каннабиса»; MonteRehab: «Drug addiction». В каталоге только стационарные DRG (hospitalization-for-drug-intoxication-and-withdrawal, …-other-drug-use-disorders) и methadone-administration — амбулаторного/реабилитационного лечения наркозависимости нет. Спец. 21 + 51. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'drug-addiction-treatment', 'Drug Addiction Treatment', 'Liječenje zavisnosti od droga', 'Лијечење зависности од дрога',
	'Лечение наркотической зависимости', 'Behandlung der Drogenabhängigkeit', 'Uyuşturucu bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'drug-addiction-treatment' OR name_en = 'Drug Addiction Treatment');

-- Зобин: отдельная услуга «Лечение опиоидной зависимости» (свой протокол: воздержание 3 недели, 2 дня); MonteRehab: «Treatment of heroin / methadone / codeine addiction», «Treatment for tramadol», «Treatment for opiates». Опиоидная зависимость — устойчивое отдельное направление (ср. methadone-administration, hospitalization-for-opioid-use-disorders-and-dependence); амбулаторной записи нет. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'opioid-addiction-treatment', 'Opioid Addiction Treatment', 'Liječenje zavisnosti od opioida', 'Лијечење зависности од опиоида',
	'Лечение опиоидной зависимости', 'Behandlung der Opioidabhängigkeit', 'Opioid bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'opioid-addiction-treatment' OR name_en = 'Opioid Addiction Treatment');

-- MonteRehab: «Medical detox … under the supervision of experienced narcologists»; Зобин: «В некоторых случаях возможно проведение подготовительного детоксикационного периода в нашем центре». В каталоге нет (detox|detoks — пусто; есть только DRG «intoksikacija … i apstinencija»). Спец. 21. Способ (инфузии и т.п.) не назван — категорию 29 не ставим.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'medical-detoxification', 'Medical Detoxification', 'Medicinska detoksikacija', 'Медицинска детоксикација',
	'Медицинская детоксикация', 'Medizinische Entgiftung', 'Tıbbi detoksifikasyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'medical-detoxification' OR name_en = 'Medical Detoxification');

-- MonteRehab: «Behavioural addiction treatment» — «Eating disorders, Gambling addiction / ludomania, Internet addiction, Sexual addiction»; футер «Rehabilitation program of non-chemical addictions» (Internet, gaming, gambling, sex/love, shopaholism). В каталоге нет. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'behavioral-addiction-treatment', 'Behavioral Addiction Treatment', 'Liječenje bihejvioralnih zavisnosti', 'Лијечење бихејвиоралних зависности',
	'Лечение нехимических (поведенческих) зависимостей', 'Behandlung von Verhaltenssüchten', 'Davranışsal bağımlılık tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'behavioral-addiction-treatment' OR name_en = 'Behavioral Addiction Treatment');

-- Зобин: «Лечение пристрастия к азартным играм» (три сеанса за пять дней); MonteRehab: «Treatment of gambling addiction». В каталоге нет. Отдельно от behavioral-addiction-treatment: у Зобина — только азартные игры, а «поведенческие зависимости» MonteRehab шире (интернет, шопинг, секс, еда). Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'gambling-addiction-treatment', 'Gambling Addiction Treatment', 'Liječenje zavisnosti od kockanja', 'Лијечење зависности од коцкања',
	'Лечение игровой зависимости', 'Behandlung der Spielsucht', 'Kumar bağımlılığı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'gambling-addiction-treatment' OR name_en = 'Gambling Addiction Treatment');

-- MonteRehab: «Dual diagnosis» (зависимость + психическое расстройство). В каталоге нет. Спец. 21.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dual-diagnosis-treatment', 'Dual Diagnosis Treatment', 'Liječenje dvojne dijagnoze', 'Лијечење двојне дијагнозе',
	'Лечение двойного диагноза', 'Behandlung von Doppeldiagnosen', 'İkili tanı tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dual-diagnosis-treatment' OR name_en = 'Dual Diagnosis Treatment');

-- Зобин: «Лечение тревожных расстройств»; MonteRehab: «Anxiety treatment». В каталоге только DRG (hospitalization-for-anxiety-disorders). Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'anxiety-disorder-treatment', 'Anxiety Disorder Treatment', 'Liječenje anksioznih poremećaja', 'Лијечење анксиозних поремећаја',
	'Лечение тревожных расстройств', 'Behandlung von Angststörungen', 'Anksiyete bozukluğu tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'anxiety-disorder-treatment' OR name_en = 'Anxiety Disorder Treatment');

-- Зобин: «Лечение депрессий» (протокол 5–12 дней); MonteRehab: «Depression treatment». В каталоге только DRG (hospitalization-for-major-affective-disorders). Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'depression-treatment', 'Depression Treatment', 'Liječenje depresije', 'Лијечење депресије',
	'Лечение депрессии', 'Depressionsbehandlung', 'Depresyon tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'depression-treatment' OR name_en = 'Depression Treatment');

-- MonteRehab: «Executive burnout» (me: «Izgaranje na poslu kod rukovodilaca»). Запись общая — «executive» в синоним, не в название (выгорание лечат не только у руководителей). В каталоге нет. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'burnout-treatment', 'Burnout Treatment', 'Liječenje sindroma izgaranja', 'Лијечење синдрома изгарања',
	'Лечение эмоционального выгорания', 'Burnout-Behandlung', 'Tükenmişlik sendromu tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'burnout-treatment' OR name_en = 'Burnout Treatment');

-- MonteRehab: «Insomnia treatment»; Зобин (главная): «предоставляет услуги по лечению: … нарушений сна». В каталоге только ЭЭГ во сне и апноэ. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'insomnia-treatment', 'Insomnia Treatment', 'Liječenje nesanice', 'Лијечење несанице',
	'Лечение бессонницы', 'Behandlung von Schlaflosigkeit', 'Uykusuzluk tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'insomnia-treatment' OR name_en = 'Insomnia Treatment');

-- MonteRehab: «Mood disorder treatment» — отдельный пункт меню рядом с «Depression treatment». В каталоге нет. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'mood-disorder-treatment', 'Mood Disorder Treatment', 'Liječenje poremećaja raspoloženja', 'Лијечење поремећаја расположења',
	'Лечение расстройств настроения', 'Behandlung affektiver Störungen', 'Duygudurum bozukluğu tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'mood-disorder-treatment' OR name_en = 'Mood Disorder Treatment');

-- MonteRehab: «PTSD and trauma treatment» (me: «Liječenje PTSP»). В каталоге нет. Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'ptsd-and-trauma-treatment', 'PTSD and Trauma Treatment', 'Liječenje PTSP-a i traume', 'Лијечење ПТСП-а и трауме',
	'Лечение ПТСР и психологической травмы', 'Behandlung von PTBS und Traumata', 'TSSB ve travma tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment' OR name_en = 'PTSD and Trauma Treatment');

-- MonteRehab: раздел «Eating disorders» (ru: «Наши специалисты, включая диетологов, психологов и психиатров…»), «Treatment of anorexia», «Treatment of bulimia». В каталоге только DRG (hospitalization-for-eating-and-obsessive-compulsive-disorders). Спец. 21 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'eating-disorder-treatment', 'Eating Disorder Treatment', 'Liječenje poremećaja ishrane', 'Лијечење поремећаја исхране',
	'Лечение расстройств пищевого поведения', 'Behandlung von Essstörungen', 'Yeme bozukluğu tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'eating-disorder-treatment' OR name_en = 'Eating Disorder Treatment');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 21 FROM medical_services WHERE slug IN ('residential-addiction-treatment-per-month', 'online-rehabilitation-program-per-month', 'resocialization-program-per-month', 'group-psychotherapy', 'alcohol-addiction-treatment', 'drug-addiction-treatment', 'opioid-addiction-treatment', 'medical-detoxification', 'behavioral-addiction-treatment', 'gambling-addiction-treatment', 'dual-diagnosis-treatment', 'anxiety-disorder-treatment', 'depression-treatment', 'burnout-treatment', 'insomnia-treatment', 'mood-disorder-treatment', 'ptsd-and-trauma-treatment', 'eating-disorder-treatment');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 22 FROM medical_services WHERE slug IN ('group-psychotherapy');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 51 FROM medical_services WHERE slug IN ('residential-addiction-treatment-per-month', 'online-rehabilitation-program-per-month', 'resocialization-program-per-month', 'group-psychotherapy', 'alcohol-addiction-treatment', 'drug-addiction-treatment', 'opioid-addiction-treatment', 'behavioral-addiction-treatment', 'gambling-addiction-treatment', 'anxiety-disorder-treatment', 'depression-treatment', 'burnout-treatment', 'insomnia-treatment', 'mood-disorder-treatment', 'ptsd-and-trauma-treatment', 'eating-disorder-treatment');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Rehabilitacioni centar za zavisnike', 'sr' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Рехабилитациони центар за зависнике', 'sr-cyrl' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Stacionarno lečenje', 'sr' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Стационарно лечење', 'sr-cyrl' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Реабилитационный центр', 'ru' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Рехаб', 'ru' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Rehab', 'en' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Residential Treatment', 'en' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Inpatient Rehabilitation', 'en' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Entzugsklinik', 'de' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Rehabilitasyon merkezi', 'tr' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Motivation and Recovery', 'en' FROM medical_services WHERE slug = 'online-rehabilitation-program-per-month'
UNION ALL SELECT id, 'Motivacija i oporavak', 'sr' FROM medical_services WHERE slug = 'online-rehabilitation-program-per-month'
UNION ALL SELECT id, 'Мотивација и опоравак', 'sr-cyrl' FROM medical_services WHERE slug = 'online-rehabilitation-program-per-month'
UNION ALL SELECT id, 'Мотивация и восстановление', 'ru' FROM medical_services WHERE slug = 'online-rehabilitation-program-per-month'
UNION ALL SELECT id, 'Resocijalizacija i obrazovanje', 'sr' FROM medical_services WHERE slug = 'resocialization-program-per-month'
UNION ALL SELECT id, 'Ресоцијализација и образовање', 'sr-cyrl' FROM medical_services WHERE slug = 'resocialization-program-per-month'
UNION ALL SELECT id, 'Resocialization and Education', 'en' FROM medical_services WHERE slug = 'resocialization-program-per-month'
UNION ALL SELECT id, 'Ресоциализация', 'ru' FROM medical_services WHERE slug = 'resocialization-program-per-month'
UNION ALL SELECT id, 'Grupna terapija', 'sr' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Групна терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Group Therapy', 'en' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Групповая терапия', 'ru' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Gruppentherapie', 'de' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Grup terapisi', 'tr' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Liječenje alkoholizma', 'sr' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Лијечење алкохолизма', 'sr-cyrl' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Лечение алкоголизма', 'ru' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alcohol Rehab', 'en' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alcoholism Treatment', 'en' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alkoholentzug', 'de' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Alkolizm tedavisi', 'tr' FROM medical_services WHERE slug = 'alcohol-addiction-treatment'
UNION ALL SELECT id, 'Liječenje narkomanije', 'sr' FROM medical_services WHERE slug = 'drug-addiction-treatment'
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
UNION ALL SELECT id, 'Liječenje zavisnosti od opijata', 'sr' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Лијечење зависности од опијата', 'sr-cyrl' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Liječenje zavisnosti od heroina', 'sr' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Лијечење зависности од хероина', 'sr-cyrl' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Лечение героиновой зависимости', 'ru' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Heroin Addiction Treatment', 'en' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Opiate Addiction Treatment', 'en' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Heroinsucht', 'de' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Eroin bağımlılığı tedavisi', 'tr' FROM medical_services WHERE slug = 'opioid-addiction-treatment'
UNION ALL SELECT id, 'Medical Detox', 'en' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Detox', 'en' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Detoksikacija', 'sr' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Детоксикација', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Детокс', 'ru' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Вывод из запоя', 'ru' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Entzug', 'de' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Detoks', 'tr' FROM medical_services WHERE slug = 'medical-detoxification'
UNION ALL SELECT id, 'Bezhemijske zavisnosti', 'sr' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Безхемијске зависности', 'sr-cyrl' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Zavisnost od interneta', 'sr' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Зависност од интернета', 'sr-cyrl' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Zavisnost od video igara', 'sr' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Зависност од видео игара', 'sr-cyrl' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Šopoholizam', 'sr' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Шопохолизам', 'sr-cyrl' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Интернет-зависимость', 'ru' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Шопоголизм', 'ru' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Non-Chemical Addiction Treatment', 'en' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Internet Addiction', 'en' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Gaming Addiction', 'en' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Lečenje zavisnosti od kockanja', 'sr' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лечење зависности од коцкања', 'sr-cyrl' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Ludomanija', 'sr' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лудоманија', 'sr-cyrl' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лечение игромании', 'ru' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лечение пристрастия к азартным играм', 'ru' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Лудомания', 'ru' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Problem Gambling Treatment', 'en' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Glücksspielsucht', 'de' FROM medical_services WHERE slug = 'gambling-addiction-treatment'
UNION ALL SELECT id, 'Dvojna dijagnoza', 'sr' FROM medical_services WHERE slug = 'dual-diagnosis-treatment'
UNION ALL SELECT id, 'Двојна дијагноза', 'sr-cyrl' FROM medical_services WHERE slug = 'dual-diagnosis-treatment'
UNION ALL SELECT id, 'Двойной диагноз', 'ru' FROM medical_services WHERE slug = 'dual-diagnosis-treatment'
UNION ALL SELECT id, 'Co-occurring Disorders Treatment', 'en' FROM medical_services WHERE slug = 'dual-diagnosis-treatment'
UNION ALL SELECT id, 'Doppeldiagnose', 'de' FROM medical_services WHERE slug = 'dual-diagnosis-treatment'
UNION ALL SELECT id, 'Liječenje anksioznosti', 'sr' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Лијечење анксиозности', 'sr-cyrl' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Лечение тревожности', 'ru' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Anxiety Treatment', 'en' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Angsttherapie', 'de' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Kaygı bozukluğu tedavisi', 'tr' FROM medical_services WHERE slug = 'anxiety-disorder-treatment'
UNION ALL SELECT id, 'Lečenje depresije', 'sr' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Лечење депресије', 'sr-cyrl' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Лечение депрессий', 'ru' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Depressionstherapie', 'de' FROM medical_services WHERE slug = 'depression-treatment'
UNION ALL SELECT id, 'Izgaranje na poslu', 'sr' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Изгарање на послу', 'sr-cyrl' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Sindrom sagorijevanja', 'sr' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Синдром сагоријевања', 'sr-cyrl' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Executive Burnout', 'en' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Профессиональное выгорание', 'ru' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Выгорание', 'ru' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Burnout-Syndrom', 'de' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Tükenmişlik', 'tr' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Poremećaji spavanja', 'sr' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Поремећаји спавања', 'sr-cyrl' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Лечение нарушений сна', 'ru' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Sleep Disorder Treatment', 'en' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Schlafstörungen', 'de' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Uyku bozukluğu tedavisi', 'tr' FROM medical_services WHERE slug = 'insomnia-treatment'
UNION ALL SELECT id, 'Afektivni poremećaji', 'sr' FROM medical_services WHERE slug = 'mood-disorder-treatment'
UNION ALL SELECT id, 'Афективни поремећаји', 'sr-cyrl' FROM medical_services WHERE slug = 'mood-disorder-treatment'
UNION ALL SELECT id, 'Аффективные расстройства', 'ru' FROM medical_services WHERE slug = 'mood-disorder-treatment'
UNION ALL SELECT id, 'Affective Disorder Treatment', 'en' FROM medical_services WHERE slug = 'mood-disorder-treatment'
UNION ALL SELECT id, 'Posttraumatski stresni poremećaj', 'sr' FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment'
UNION ALL SELECT id, 'Посттрауматски стресни поремећај', 'sr-cyrl' FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment'
UNION ALL SELECT id, 'Посттравматическое стрессовое расстройство', 'ru' FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment'
UNION ALL SELECT id, 'Post-Traumatic Stress Disorder Treatment', 'en' FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment'
UNION ALL SELECT id, 'PTSD Treatment', 'en' FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment'
UNION ALL SELECT id, 'Posttraumatische Belastungsstörung', 'de' FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment'
UNION ALL SELECT id, 'Travma sonrası stres bozukluğu', 'tr' FROM medical_services WHERE slug = 'ptsd-and-trauma-treatment'
UNION ALL SELECT id, 'Liječenje anoreksije', 'sr' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Лијечење анорексије', 'sr-cyrl' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Liječenje bulimije', 'sr' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Лијечење булимије', 'sr-cyrl' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Poremećaji u ishrani', 'sr' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Поремећаји у исхрани', 'sr-cyrl' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Лечение анорексии', 'ru' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Лечение булимии', 'ru' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'РПП', 'ru' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Anorexia Treatment', 'en' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Bulimia Treatment', 'en' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Magersucht', 'de' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Anoreksiya tedavisi', 'tr' FROM medical_services WHERE slug = 'eating-disorder-treatment'
UNION ALL SELECT id, 'Eurostandard', 'en' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Program rehabilitacije', 'sr' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Програм рехабилитације', 'sr-cyrl' FROM medical_services WHERE slug = 'residential-addiction-treatment-per-month'
UNION ALL SELECT id, 'Dvostruka dijagnoza', 'sr' FROM medical_services WHERE slug = 'dual-diagnosis-treatment'
UNION ALL SELECT id, 'Двострука дијагноза', 'sr-cyrl' FROM medical_services WHERE slug = 'dual-diagnosis-treatment'
UNION ALL SELECT id, 'Liječenje ponašajnih zavisnosti', 'sr' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Лијечење понашајних зависности', 'sr-cyrl' FROM medical_services WHERE slug = 'behavioral-addiction-treatment'
UNION ALL SELECT id, 'Sindrom sagorijevanja na poslu', 'sr' FROM medical_services WHERE slug = 'burnout-treatment'
UNION ALL SELECT id, 'Синдром сагоријевања на послу', 'sr-cyrl' FROM medical_services WHERE slug = 'burnout-treatment';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_monterehab_budva;
CREATE TEMPORARY TABLE tmp_monterehab_budva (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_monterehab_budva (slug, price, price_min, price_max) VALUES
('residential-addiction-treatment-per-month', 6000.00, NULL, 9000.00), -- /pricing: «Eurostandard (double occupancy) €6,000 / month», «Eurostandard (single occupancy) €9,000 / month», «10% discount when paying for three months or more» → 6000–9000 € в месяц (двух-/одноместное размещение), скидка — в описании, меню: «Residential treatment»
('online-rehabilitation-program-per-month', 3000.00, NULL, NULL), -- /pricing: «Online program "Motivation and Recovery" €3,000 / month» (/cijene_me: «Program se održava onlajn … Cijena programa — €3,000 mjesečno»)
('resocialization-program-per-month', 3500.00, NULL, NULL), -- /pricing: «Resocialization and education €3,500 / month» (/cijene_me: «Popust 10% pri uplati za tri ili više mjeseci»)
('group-psychotherapy', NULL, NULL, NULL), -- Меню: «Group therapy online» (/group_therapy, me: «Grupna terapija»), главная: «We offer safe and intimate group classes online and offline»
('alcohol-addiction-treatment', NULL, NULL, NULL), -- Меню: «Alcohol addiction» (/alcohol_addiction), футер «Rehabilitation program for alcoholics»
('drug-addiction-treatment', NULL, NULL, NULL), -- Меню: «Drug addiction» (/drug_addiction), футер «Rehabilitation program for drug addicts» (cocaine, amphetamine, marijuana, hashish, Spice, ecstasy, LSD, salt …)
('opioid-addiction-treatment', NULL, NULL, NULL), -- Футер (лендинги): «Treatment of heroin addiction», «Treatment of methadone addiction», «Treatment of codeine addiction», «Treatment for tramadol», «Treatment for opiates» (/opiate_addiction)
('medical-detoxification', NULL, NULL, NULL), -- Меню: «Medical detox … qualified assistance to overcome the abstinence stage under the supervision of experienced narcologists and therapists»
('behavioral-addiction-treatment', NULL, NULL, NULL), -- Меню: «Behavioural addiction treatment» («Eating disorders, Gambling addiction / ludomania, Internet addiction, Sexual addiction»), футер «Rehabilitation program of non-chemical addictions»
('gambling-addiction-treatment', NULL, NULL, NULL), -- Футер (лендинг /gambling_addiction): «Treatment of gambling addiction»
('dual-diagnosis-treatment', NULL, NULL, NULL), -- Меню: «Dual diagnosis» (me: «Dvostruka dijagnoza»)
('anxiety-disorder-treatment', NULL, NULL, NULL), -- Меню: «Anxiety treatment»
('depression-treatment', NULL, NULL, NULL), -- Меню: «Depression treatment»
('burnout-treatment', NULL, NULL, NULL), -- Меню: «Executive burnout» (me: «Sindrom sagorijevanja na poslu»)
('insomnia-treatment', NULL, NULL, NULL), -- Меню: «Insomnia treatment»
('mood-disorder-treatment', NULL, NULL, NULL), -- Меню: «Mood disorder treatment»
('ptsd-and-trauma-treatment', NULL, NULL, NULL), -- Меню: «PTSD and trauma treatment»
('eating-disorder-treatment', NULL, NULL, NULL); -- Раздел «Eating disorders» (/ru/eating-disorders), футер «Rehabilitation for eating disorders: Treatment of anorexia, Treatment of bulimia …»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_monterehab_budva t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_monterehab_budva t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_monterehab_budva t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 18 услуг, с ценой 3.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 18: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('residential-addiction-treatment-per-month', 'online-rehabilitation-program-per-month', 'resocialization-program-per-month', 'group-psychotherapy', 'alcohol-addiction-treatment', 'drug-addiction-treatment', 'opioid-addiction-treatment', 'medical-detoxification', 'behavioral-addiction-treatment', 'gambling-addiction-treatment', 'dual-diagnosis-treatment', 'anxiety-disorder-treatment', 'depression-treatment', 'burnout-treatment', 'insomnia-treatment', 'mood-disorder-treatment', 'ptsd-and-trauma-treatment', 'eating-disorder-treatment');

DROP TEMPORARY TABLE IF EXISTS tmp_monterehab_budva;
