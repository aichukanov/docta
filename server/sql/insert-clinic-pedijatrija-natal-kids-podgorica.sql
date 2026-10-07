SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- Pedijatrija Natal Kids (Подгорица) — новая клиника: педиатрическое отделение
-- Poliklinika Natal по отдельному адресу. Клиника, 25 услуг, 15 врачей.
--
-- Источники (все — poliklinikanatal.me, снимки в
-- data/clinic-pricelists/sources/poliklinika-natal-podgorica/):
--   * /cjenovnik/ + wp-json cjenovnik — 18 позиций раздела «pedijatrija» с ценами,
--     созданы 2026-04-21, перепроверены 2026-10-06 (modified не менялся);
--   * подвал сайта — название, адрес, телефоны, email, часы работы;
--   * /pod-usluge/<…>/ (CPT pod-usluge, usluge = 18) — перечень услуг по
--     отделениям, в т. ч. без цен;
--   * wp-json nas-tim (usluge = 18) — 15 педиатров, страницы /nas-tim/<slug>/;
--   * координаты — ссылка Google Maps от юзера (2026-10-06):
--     «2g II Crnogorskog Bataljona», 42.4521563, 19.2627952.
-- Сверка с прайсом поликлиники — data/clinic-imports/poliklinika-natal-podgorica-prices-2026-10.md,
-- запись импорта — data/clinic-imports/pedijatrija-natal-kids-podgorica.json.
--
-- ЧЕГО ЗДЕСЬ НЕТ И ПОЧЕМУ:
--   * google_place_id — ссылка ведёт на АДРЕС (ChIJ82tzSbSUTRMRjKZRS5OEFtc —
--     place здания), а не на карточку заведения: отзывов и рейтинга у него нет.
--   * facebook / instagram — на сайте только аккаунты поликлиники; своих у
--     Natal Kids не заявлено. Сайт — общий poliklinikanatal.me, домен из email
--     (pedijatrijanatal.me) не открывается.
--   * «Alergo testovi» (страница дјечије пулмологије) — без цены и без перечня,
--     каких именно тестов; не заводим.
--   * Фото у Aida Ećo и Dragan Nešović — на сайте общая заглушка 75.png.
--
-- РЕШЕНИЯ:
--   * «Pregled dječijeg radiologa (jedna regija)» 50 € — УЗИ одной области;
--     страница /pod-usluge/djecija-radiologija/ перечисляет области: kukovi,
--     abdomen, meka tkiva vrata, urotrakt, štitasta žlijezda, testisi. Как с
--     рентгеном поликлиники (решение 2026-10-05), цену получают записи
--     названных областей, общую запись «детский радиолог» не заводим.
--     Тазобедренные суставы есть ещё и отдельной позицией «Ultrazvuk kukova»
--     40 € (общая педиатрия) — у них диапазон 40–50.
--   * Услуги со страниц отделений без цены — NULL (на сайте перечислены,
--     прайса нет): pregled dječijeg hirurga, obrada rane, skidanje konaca.
--   * 11 педиатров, которые у нас висели на клинике 54, переводятся сюда
--     (решение юзера 2026-10-06): на Studentska 16 педиатрии больше нет.
--     Sonja Milašinović остаётся в остальных своих клиниках, снимается только 54.
--   * Milorada Nešović уже есть в БД (Doktorica Mica, 113) — добавляется
--     второй клиникой. Новых врачей 3: Predrag Ilić, Aida Ećo, Dragan Nešović.
--
-- Новые записи каталога (3): pediatrician-home-visit,
-- pediatric-orthopedist-examination, pediatric-urologist-examination.
--
-- Клиника, врачи и записи каталога — по slug (id локально и на проде расходятся).
-- Идемпотентно: find-or-create, INSERT IGNORE, NOT EXISTS. description_*
-- клиники и врача пишутся безусловным UPDATE — правки описаний вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET @clinic_slug = 'pedijatrija-natal-kids-podgorica';
SET @parent_slug = 'poliklinika-natal-podgorica';

-- ═══ 1. Клиника ═══

SET @clinic_id = (SELECT id FROM clinics WHERE slug = @clinic_slug);

INSERT INTO clinics (
	slug, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
SELECT
	@clinic_slug, 'published', 1,
	'Pedijatrija Natal Kids', 'Педијатрија Natal Kids', 'Педиатрия Natal Kids',
	'Drugog crnogorskog bataljona 2H, kod Vezirovog mosta', 'Другог црногорског батаљона 2Х, код Везировог моста', '', '', '81000',
	42.45215630, 19.26279520,
	'+38220273274;+38266273274', 'info@pedijatrijanatal.me', 'https://poliklinikanatal.me/', '', '', '', '', '',
	(SELECT logo_url FROM clinics WHERE slug = @parent_slug), NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

UPDATE clinics SET
	description_sr = 'Pedijatrijsko odjeljenje Poliklinike Natal na posebnoj adresi — u ulici Drugog crnogorskog bataljona, kod Vezirovog mosta u Podgorici. Opšta pedijatrija: pregled, kontrolni pregled i konsultacija pedijatra, ultrazvuk kukova i kućne posjete. Preventivni pregledi: sistematski pregled novorođenčeta i sistematski pregled za školu. Neonatologija: pregled neonatologa i ultrazvuk mozga kod beba. Dječji subspecijalisti: pulmolog, kardiolog (pregled sa ultrazvukom srca i EKG-om), gastroenterolog, neurolog, fizijatar, ortoped, urolog, hirurg i ORL specijalista. Dječji radiolog radi ultrazvuk kukova, abdomena, mekih tkiva vrata, urotrakta, štitaste žlijezde i testisa.',
	description_sr_cyrl = 'Педијатријско одјељење Поликлинике Natal на посебној адреси — у улици Другог црногорског батаљона, код Везировог моста у Подгорици. Општа педијатрија: преглед, контролни преглед и консултација педијатра, ултразвук кукова и кућне посјете. Превентивни прегледи: систематски преглед новорођенчета и систематски преглед за школу. Неонатологија: преглед неонатолога и ултразвук мозга код беба. Дјечји субспецијалисти: пулмолог, кардиолог (преглед са ултразвуком срца и ЕКГ-ом), гастроентеролог, неуролог, физијатар, ортопед, уролог, хирург и ОРЛ специјалиста. Дјечји радиолог ради ултразвук кукова, абдомена, меких ткива врата, уротракта, штитасте жлијезде и тестиса.',
	description_ru = 'Педиатрическое отделение поликлиники Natal по отдельному адресу — улица Другог црногорского батальона, у Визирова моста в Подгорице. Общая педиатрия: осмотр, повторный осмотр и консультация педиатра, УЗИ тазобедренных суставов и вызов педиатра на дом. Профилактические осмотры: систематический осмотр новорождённого и медосмотр для школы. Неонатология: осмотр неонатолога и УЗИ головного мозга младенца. Детские узкие специалисты: пульмонолог, кардиолог (осмотр с УЗИ сердца и ЭКГ), гастроэнтеролог, невролог, физиотерапевт, ортопед, уролог, хирург и ЛОР. Детский радиолог делает УЗИ тазобедренных суставов, брюшной полости, мягких тканей шеи, мочевыводящих путей, щитовидной железы и яичек.',
	description_en = 'The paediatric department of Poliklinika Natal, at its own address on Drugog crnogorskog bataljona street near the Vizier''s Bridge in Podgorica. General paediatrics: paediatrician examinations, follow-ups and consultations, hip ultrasound and home visits. Preventive check-ups: newborn screening examination and school check-up. Neonatology: neonatologist examination and infant brain ultrasound. Paediatric specialists: pulmonologist, cardiologist (examination with echocardiography and ECG), gastroenterologist, neurologist, physiatrist, orthopaedist, urologist, surgeon and ENT specialist. A paediatric radiologist performs ultrasound of the hips, abdomen, neck soft tissues, urinary tract, thyroid and testes.',
	description_de = 'Die Kinderabteilung der Poliklinik Natal an eigener Adresse — Straße Drugog crnogorskog bataljona, an der Wesirbrücke in Podgorica. Allgemeine Kinderheilkunde: Untersuchung, Kontrolluntersuchung und Beratung beim Kinderarzt, Hüftultraschall und Hausbesuche. Vorsorge: Vorsorgeuntersuchung des Neugeborenen und Schuluntersuchung. Neonatologie: Untersuchung beim Neonatologen und Schädelultraschall beim Säugling. Kinderfachärzte: Pneumologe, Kardiologe (Untersuchung mit Herzultraschall und EKG), Gastroenterologe, Neurologe, Physiater, Orthopäde, Urologe, Chirurg und HNO-Arzt. Ein Kinderradiologe führt Ultraschall von Hüften, Abdomen, Halsweichteilen, Harnwegen, Schilddrüse und Hoden durch.',
	description_tr = 'Poliklinika Natal''ın ayrı adresteki çocuk bölümü — Podgorica''da Vezir Köprüsü yakınında, Drugog crnogorskog bataljona caddesinde. Genel pediatri: çocuk doktoru muayenesi, kontrol muayenesi ve danışma, kalça ultrasonu ve ev ziyaretleri. Koruyucu muayeneler: yenidoğan tarama muayenesi ve okul muayenesi. Neonatoloji: neonatolog muayenesi ve bebek beyin ultrasonu. Çocuk uzmanları: göğüs hastalıkları, kardiyoloji (kalp ultrasonu ve EKG ile muayene), gastroenteroloji, nöroloji, fizik tedavi, ortopedi, üroloji, cerrahi ve KBB. Çocuk radyoloğu kalça, karın, boyun yumuşak dokuları, idrar yolları, tiroid ve testis ultrasonu yapar.'
WHERE id = @clinic_id;

-- 12 = PEDIATRIC_CLINIC
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 12);

-- Только SR: сопровождения на других языках сайт не заявляет.
-- clinic_languages без UNIQUE — вставка через NOT EXISTS.
INSERT INTO clinic_languages (clinic_id, language_id, create_time)
SELECT @clinic_id, 1, NOW() FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- «Ponedjeljak – petak | 08:00 – 20:00h, Subota | 08:00 – 16:00h, Nedjeljom | ne radimo»
INSERT IGNORE INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
	'{"type": "closed"}');

-- ═══ 2. Новые записи каталога ═══
-- Категории: 10 Orthopedics, 22 Urology, 25 Pediatrics, 30 Home Visits.
-- Специальности: 4 Pediatrics, 32 Pediatric Orthopedics, 33 Pediatric Urology.

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Pediatrician Home Visit', 'pediatrician-home-visit', 'Kućna posjeta pedijatra', 'Кућна посјета педијатра', 'Вызов педиатра на дом', 'Hausbesuch des Kinderarztes', 'Çocuk doktoru ev ziyareti')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 25 FROM medical_services WHERE slug = 'pediatrician-home-visit'
UNION ALL SELECT id, 30 FROM medical_services WHERE slug = 'pediatrician-home-visit';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 4 FROM medical_services WHERE slug = 'pediatrician-home-visit';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Pediatric Home Visit', 'en' FROM medical_services WHERE slug = 'pediatrician-home-visit'
UNION ALL SELECT id, 'Педиатр на дом', 'ru' FROM medical_services WHERE slug = 'pediatrician-home-visit'
UNION ALL SELECT id, 'Вызов детского врача на дом', 'ru' FROM medical_services WHERE slug = 'pediatrician-home-visit'
UNION ALL SELECT id, 'Kinderarzt-Hausbesuch', 'de' FROM medical_services WHERE slug = 'pediatrician-home-visit'
UNION ALL SELECT id, 'Evde çocuk doktoru muayenesi', 'tr' FROM medical_services WHERE slug = 'pediatrician-home-visit';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Pediatric Orthopedist Examination', 'pediatric-orthopedist-examination', 'Pregled dječjeg ortopeda', 'Преглед дјечјег ортопеда', 'Осмотр детского ортопеда', 'Untersuchung beim Kinderorthopäden', 'Çocuk ortopedisti muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 25 FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 10 FROM medical_services WHERE slug = 'pediatric-orthopedist-examination';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 4 FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 32 FROM medical_services WHERE slug = 'pediatric-orthopedist-examination';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Pregled dječijeg ortopeda', 'sr' FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 'Преглед дјечијег ортопеда', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 'Pediatric Orthopedic Consultation', 'en' FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 'Детский ортопед', 'ru' FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 'Приём детского ортопеда', 'ru' FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 'Kinderorthopädie Sprechstunde', 'de' FROM medical_services WHERE slug = 'pediatric-orthopedist-examination'
UNION ALL SELECT id, 'Çocuk ortopedi muayenesi', 'tr' FROM medical_services WHERE slug = 'pediatric-orthopedist-examination';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Pediatric Urologist Examination', 'pediatric-urologist-examination', 'Pregled dječjeg urologa', 'Преглед дјечјег уролога', 'Осмотр детского уролога', 'Untersuchung beim Kinderurologen', 'Çocuk ürolog muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 25 FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 22 FROM medical_services WHERE slug = 'pediatric-urologist-examination';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 4 FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 33 FROM medical_services WHERE slug = 'pediatric-urologist-examination';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Pregled dječijeg urologa', 'sr' FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 'Преглед дјечијег уролога', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 'Pediatric Urology Consultation', 'en' FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 'Детский уролог', 'ru' FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 'Приём детского уролога', 'ru' FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 'Kinderurologie Sprechstunde', 'de' FROM medical_services WHERE slug = 'pediatric-urologist-examination'
UNION ALL SELECT id, 'Çocuk üroloji muayenesi', 'tr' FROM medical_services WHERE slug = 'pediatric-urologist-examination';

-- Формулировки Natal на существующих записях
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Sistematski pregled novorođenčeta', 'sr' FROM medical_services WHERE slug = 'systematic-infant-examination'
UNION ALL SELECT id, 'Систематски преглед новорођенчета', 'sr-cyrl' FROM medical_services WHERE slug = 'systematic-infant-examination'
UNION ALL SELECT id, 'Систематический осмотр новорождённого', 'ru' FROM medical_services WHERE slug = 'systematic-infant-examination'
UNION ALL SELECT id, 'Newborn Systematic Examination', 'en' FROM medical_services WHERE slug = 'systematic-infant-examination'
UNION ALL SELECT id, 'Sistematski pregled za školu', 'sr' FROM medical_services WHERE slug = 'preventive-examination-for-kindergarten-and-school-enrollment'
UNION ALL SELECT id, 'Систематски преглед за школу', 'sr-cyrl' FROM medical_services WHERE slug = 'preventive-examination-for-kindergarten-and-school-enrollment'
UNION ALL SELECT id, 'Медосмотр для школы', 'ru' FROM medical_services WHERE slug = 'preventive-examination-for-kindergarten-and-school-enrollment'
UNION ALL SELECT id, 'Konsultacija pedijatra', 'sr' FROM medical_services WHERE slug = 'pediatric-counseling'
UNION ALL SELECT id, 'Консултација педијатра', 'sr-cyrl' FROM medical_services WHERE slug = 'pediatric-counseling'
UNION ALL SELECT id, 'Консультация педиатра', 'ru' FROM medical_services WHERE slug = 'pediatric-counseling'
UNION ALL SELECT id, 'Pediatrician Consultation', 'en' FROM medical_services WHERE slug = 'pediatric-counseling';

-- ═══ 3. Услуги клиники ═══

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT @clinic_id, e.id, v.price, NULL, v.price_max
  FROM (
	          SELECT 'pediatric-examination' AS slug, 50.00 AS price, NULL AS price_max                -- «Pregled pedijatra» 50 €
	UNION ALL SELECT 'follow-up-pediatric-examination', 40.00, NULL                                   -- «Kontrolni pregled pedijatra» 40 €
	UNION ALL SELECT 'pediatric-counseling', 30.00, NULL                                              -- «Konsultacija pedijatra» 30 €
	UNION ALL SELECT 'pediatric-hip-ultrasound', 40.00, 50.00                                         -- «Ultrazvuk kukova» 40 € + у радиолога 50 €
	UNION ALL SELECT 'pediatrician-home-visit', 150.00, NULL                                          -- «Kućna posjeta pedijatra» 150 €
	UNION ALL SELECT 'systematic-infant-examination', 60.00, NULL                                     -- «Sistematski pregled novorođenčeta» 60 €
	UNION ALL SELECT 'preventive-examination-for-kindergarten-and-school-enrollment', 60.00, NULL     -- «Sistematski pregled za školu» 60 €
	UNION ALL SELECT 'neonatologist-examination', 60.00, NULL                                         -- «Pregled neonatologa» 60 €
	UNION ALL SELECT 'infant-brain-ultrasound-neurosonography', 50.00, NULL                           -- «Ultrazvuk mozga kod beba (CNS)» 50 €
	UNION ALL SELECT 'pediatric-pulmonologist-examination', 120.00, NULL                              -- «Pregled dječijeg pulmologa» 120 €
	UNION ALL SELECT 'pediatric-cardiologist-examination-with-echocardiography', 120.00, NULL         -- «Pregled dječijeg kardiologa sa ultrazvukom i EKG-om» 120 €
	UNION ALL SELECT 'pediatric-gastroenterologist-examination', 120.00, NULL                         -- «Pregled dječijeg gastroenterologa» 120 €
	UNION ALL SELECT 'pediatric-neurologist-examination', 100.00, NULL                                -- «Pregled dječijeg neurologa» 100 €
	UNION ALL SELECT 'subspecialist-pediatric-physiatrist-examination', 100.00, NULL                  -- «Pregled dječijeg fizijatara» 100 €
	UNION ALL SELECT 'pediatric-orthopedist-examination', 60.00, NULL                                 -- «Pregled dječijeg ortopeda» 60 €
	UNION ALL SELECT 'pediatric-urologist-examination', 50.00, NULL                                   -- «Pregled dječijeg urologa» 50 €
	UNION ALL SELECT 'pediatric-ent-examination', 50.00, NULL                                         -- «ORL pregled djece» 50 €
	-- «Pregled dječijeg radiologa (jedna regija)» 50 € — по областям из /pod-usluge/djecija-radiologija/
	UNION ALL SELECT 'abdomen-ultrasound', 50.00, NULL                                                -- «Ultrazvuk abdomena» (и «Ultrazvuk stomaka» у гастроэнтеролога)
	UNION ALL SELECT 'ultrasound-neck-glands-and-soft-tissue', 50.00, NULL                            -- «Ultrazvuk mekih tkiva vrata»
	UNION ALL SELECT 'urinary-tract-ultrasound', 50.00, NULL                                          -- «Ultrazvuk urotrakta» (и «Ultrazvuk dječijeg urologa»)
	UNION ALL SELECT 'thyroid-ultrasound', 50.00, NULL                                                -- «Ultrazvuk štitaste žlijezde»
	UNION ALL SELECT 'testicular-ultrasound', 50.00, NULL                                             -- «Ultrazvuk testisa»
	-- без цены: перечислены на страницах отделений, в прайсе их нет
	UNION ALL SELECT 'pediatric-surgeon-examination', NULL, NULL                                      -- «Pregled dječijeg hirurga»
	UNION ALL SELECT 'wound-care', NULL, NULL                                                         -- «Obrada rane» (дјечија хирургија)
	UNION ALL SELECT 'suture-removal', NULL, NULL                                                     -- «Skidanje konaca» (дјечија хирургија)
  ) v
  JOIN medical_services e ON e.slug = v.slug COLLATE utf8mb4_unicode_ci;

-- ═══ 4. Врачи ═══
-- Специальности: 4 Pediatrics, 10 Radiology, 24 Pediatric Surgery,
-- 33 Pediatric Urology, 68 Neonatology. Язык: 1 = SR.

-- 4.1 Переезд с клиники 54: 11 педиатров (раздел «Pedijatrija» на сайте).
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT d.id, @clinic_id, dc.position
  FROM doctors d
  JOIN doctor_clinics dc ON dc.doctor_id = d.id
  JOIN clinics p ON p.id = dc.clinic_id AND p.slug = @parent_slug
 WHERE d.slug IN ('slavica-ostojic', 'snezana-sebek', 'snezana-bugaric', 'dragan-prokic', 'olga-prentic',
                  'vesna-bardak', 'snezana-perazic', 'aleksandar-sovtic', 'vladislav-vukomanovic',
                  'sonja-milasinovic', 'marija-kolinovic');

-- Снимаем с 54 только тех, кто уже стоит на новой клинике (self-join, а не
-- EXISTS: подзапрос к удаляемой таблице MySQL не пускает, ERROR 1093).
DELETE dc FROM doctor_clinics dc
  JOIN doctors d ON d.id = dc.doctor_id
  JOIN clinics p ON p.id = dc.clinic_id AND p.slug = @parent_slug
  JOIN doctor_clinics k ON k.doctor_id = dc.doctor_id AND k.clinic_id = @clinic_id
 WHERE d.slug IN ('slavica-ostojic', 'snezana-sebek', 'snezana-bugaric', 'dragan-prokic', 'olga-prentic',
                  'vesna-bardak', 'snezana-perazic', 'aleksandar-sovtic', 'vladislav-vukomanovic',
                  'sonja-milasinovic', 'marija-kolinovic');

-- 4.2 Milorada Nešović — уже в БД (Doktorica Mica), добавляем вторую клинику.
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT id, @clinic_id, 'Specijalista pedijatrije, subspecijalista neonatologije' FROM doctors WHERE slug = 'milorada-nesovic';

-- 4.3 Prim. asist. dr sc. med. Predrag Ilić — /nas-tim/prim-asist-dr-sc-med-predrag-ilic/
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'predrag-ilic');
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Predrag Ilić' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-ilic', 'Predrag Ilić', 'Предраг Илић', 'Предраг Илич', 'Predrag Ilic', 'prim. asist. dr sc. med.',
       'https://poliklinikanatal.me/wp-content/uploads/2026/08/Predrag-Ilic-1.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 24), (@doctor_id, 33);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
VALUES (@doctor_id, @clinic_id, 'Specijalista dječje hirurgije, supspecijalista dječje urologije (gostujući ljekar)');
UPDATE doctors SET
	description_sr = 'Specijalista dječje hirurgije i supspecijalista dječje urologije, primarijus, doktor medicinskih nauka. Od 2011. godine je načelnik Odjeljenja urologije Instituta za zdravstvenu zaštitu majke i djeteta Srbije „Dr Vukan Čupić“ i klinički asistent na Katedri za hirurgiju sa anesteziologijom Medicinskog fakulteta Univerziteta u Beogradu. Medicinski fakultet u Beogradu završio je 1997. godine, specijalizaciju iz dječje hirurgije 2003, a užu specijalizaciju iz dječje urologije 2011. godine. Od 2015. do 2019. godine bio je predsjednik Sekcije za dječju hirurgiju Srpskog ljekarskog društva. Bavi se opštom dječjom hirurgijom i dječjom urologijom: urođene anomalije bubrega, uretera i mokraćne bešike, anomalije spoljašnjih genitalija, nespušteni testisi, fimoza, hipospadija, preponske kile, tumori urogenitalnog sistema i kamen u bubregu. U Natalu obavlja kliničke i ultrazvučne preglede urinarnog trakta, procjenu i planiranje hirurškog liječenja, kontrole nakon operacija i manje intervencije u lokalnoj anesteziji.',
	description_sr_cyrl = 'Специјалиста дјечје хирургије и супспецијалиста дјечје урологије, примаријус, доктор медицинских наука. Од 2011. године је начелник Одјељења урологије Института за здравствену заштиту мајке и дјетета Србије „Др Вукан Чупић“ и клинички асистент на Катедри за хирургију са анестезиологијом Медицинског факултета Универзитета у Београду. Медицински факултет у Београду завршио је 1997. године, специјализацију из дјечје хирургије 2003, а ужу специјализацију из дјечје урологије 2011. године. Од 2015. до 2019. године био је предсједник Секције за дјечју хирургију Српског љекарског друштва. Бави се општом дјечјом хирургијом и дјечјом урологијом: урођене аномалије бубрега, уретера и мокраћне бешике, аномалије спољашњих гениталија, неспуштени тестиси, фимоза, хипоспадија, препонске киле, тумори урогениталног система и камен у бубрегу. У Наталу обавља клиничке и ултразвучне прегледе уринарног тракта, процјену и планирање хируршког лијечења, контроле након операција и мање интервенције у локалној анестезији.',
	description_ru = 'Детский хирург и детский уролог, примариус, доктор медицинских наук. С 2011 года заведует отделением урологии Института охраны здоровья матери и ребёнка Сербии «Др Вукан Чупич» и работает клиническим ассистентом кафедры хирургии с анестезиологией медицинского факультета Белградского университета. Окончил медицинский факультет в Белграде в 1997 году, специализацию по детской хирургии — в 2003-м, по детской урологии — в 2011-м. В 2015–2019 годах возглавлял секцию детской хирургии Сербского врачебного общества. Занимается общей детской хирургией и детской урологией: врождённые аномалии почек, мочеточников и мочевого пузыря, аномалии наружных половых органов, неопущение яичек, фимоз, гипоспадия, паховые грыжи, опухоли мочеполовой системы и камни в почках. В Natal проводит клинические осмотры и УЗИ мочевыводящих путей, оценку и планирование хирургического лечения, контроль после операций и небольшие вмешательства под местной анестезией.',
	description_en = 'Paediatric surgeon and paediatric urologist, primarius, PhD in medical sciences. Since 2011 he has headed the Urology Department of the Institute for Mother and Child Health Care of Serbia "Dr Vukan Čupić" and is a clinical assistant at the Department of Surgery and Anaesthesiology, Faculty of Medicine, University of Belgrade. He graduated from the Belgrade Faculty of Medicine in 1997, completed his specialisation in paediatric surgery in 2003 and his subspecialisation in paediatric urology in 2011. From 2015 to 2019 he chaired the Paediatric Surgery Section of the Serbian Medical Society. His work covers general paediatric surgery and paediatric urology: congenital anomalies of the kidneys, ureters and bladder, anomalies of the external genitalia, undescended testes, phimosis, hypospadias, inguinal hernias, urogenital tumours and kidney stones. At Natal he performs clinical examinations and urinary tract ultrasound, assessment and planning of surgical treatment, post-operative follow-ups and minor procedures under local anaesthesia.',
	description_de = 'Kinderchirurg und Kinderurologe, Primarius, Doktor der medizinischen Wissenschaften. Seit 2011 leitet er die urologische Abteilung des Instituts für Mutter-Kind-Gesundheit Serbiens „Dr. Vukan Čupić“ und ist klinischer Assistent am Lehrstuhl für Chirurgie und Anästhesiologie der Medizinischen Fakultät der Universität Belgrad. Das Medizinstudium in Belgrad schloss er 1997 ab, die Facharztausbildung in Kinderchirurgie 2003 und die Subspezialisierung in Kinderurologie 2011. Von 2015 bis 2019 war er Vorsitzender der Sektion Kinderchirurgie der Serbischen Ärztegesellschaft. Schwerpunkte sind die allgemeine Kinderchirurgie und die Kinderurologie: angeborene Fehlbildungen von Nieren, Harnleitern und Harnblase, Fehlbildungen des äußeren Genitales, Hodenhochstand, Phimose, Hypospadie, Leistenbrüche, Tumoren des Urogenitalsystems und Nierensteine. Bei Natal führt er klinische Untersuchungen und Ultraschall der Harnwege durch, beurteilt und plant operative Behandlungen, übernimmt Nachkontrollen nach Operationen und kleinere Eingriffe in Lokalanästhesie.',
	description_tr = 'Çocuk cerrahı ve çocuk ürolog, primarius, tıp bilimleri doktoru. 2011''den beri Sırbistan Anne ve Çocuk Sağlığı Enstitüsü "Dr Vukan Čupić" üroloji bölümünün başkanıdır ve Belgrad Üniversitesi Tıp Fakültesi Cerrahi ve Anesteziyoloji Anabilim Dalı''nda klinik asistandır. Belgrad Tıp Fakültesi''nden 1997''de mezun oldu, çocuk cerrahisi uzmanlığını 2003''te, çocuk ürolojisi yan dal uzmanlığını 2011''de tamamladı. 2015–2019 yıllarında Sırp Tabipler Derneği Çocuk Cerrahisi Bölümü''nün başkanlığını yaptı. Genel çocuk cerrahisi ve çocuk ürolojisiyle ilgilenir: böbrek, üreter ve mesanenin doğuştan anomalileri, dış genital anomalileri, inmemiş testis, fimozis, hipospadias, kasık fıtıkları, ürogenital sistem tümörleri ve böbrek taşları. Natal''da klinik muayene ve idrar yolu ultrasonu, cerrahi tedavinin değerlendirilmesi ve planlanması, ameliyat sonrası kontroller ve lokal anestezi altında küçük girişimler yapar.'
WHERE id = @doctor_id;

-- 4.4 Dr Aida Ećo — «Specijalista pedijatrije, subspecijalista neonatologije»; биографии на сайте нет.
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'aida-eco');
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Aida Ećo' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aida-eco', 'Aida Ećo', 'Аида Ећо', 'Аида Эчо', 'Aida Eco', 'dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4), (@doctor_id, 68);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatrije, subspecijalista neonatologije');

-- 4.5 Dr Dragan Nešović — «Specijalista radiologije, dječiji radiolog»; биографии на сайте нет.
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'dragan-nesovic');
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Dragan Nešović' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragan-nesovic', 'Dragan Nešović', 'Драган Нешовић', 'Драган Нешович', 'Dragan Nesovic', 'dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position)
VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije, dječji radiolog');

-- ═══ VERIFICATION ═══

-- Клиника: 1 строка, published, координаты 42.4521563 / 19.2627952, тип 12, язык 1, часы есть.
SELECT c.id, c.slug, c.status, c.latitude, c.longitude, c.phone, c.email,
       (SELECT GROUP_CONCAT(clinic_type_id) FROM clinic_clinic_types WHERE clinic_id = c.id) AS types,
       (SELECT GROUP_CONCAT(language_id) FROM clinic_languages WHERE clinic_id = c.id) AS languages,
       (SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
  FROM clinics c WHERE c.slug = 'pedijatrija-natal-kids-podgorica';

-- Услуги: ожидается 25 строк, 22 с ценой (у pediatric-hip-ultrasound 40–50), 3 NULL.
SELECT ms.slug, cms.price, cms.price_max
  FROM clinic_medical_services cms
  JOIN medical_services ms ON ms.id = cms.medical_service_id
  JOIN clinics c ON c.id = cms.clinic_id AND c.slug = 'pedijatrija-natal-kids-podgorica'
 ORDER BY ms.slug;

-- Новые записи каталога: 3 строки, у каждой 2 категории, специальности и синонимы.
SELECT ms.slug,
       (SELECT GROUP_CONCAT(medical_service_category_id ORDER BY medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS categories,
       (SELECT GROUP_CONCAT(specialty_id ORDER BY specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specialties,
       (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
  FROM medical_services ms
 WHERE ms.slug IN ('pediatrician-home-visit', 'pediatric-orthopedist-examination', 'pediatric-urologist-examination');

-- Врачи новой клиники: ожидается 15.
SELECT d.slug, d.professional_title, dc.position,
       (SELECT GROUP_CONCAT(clinic_id) FROM doctor_clinics WHERE doctor_id = d.id) AS all_clinics
  FROM doctor_clinics dc
  JOIN doctors d ON d.id = dc.doctor_id
  JOIN clinics c ON c.id = dc.clinic_id AND c.slug = 'pedijatrija-natal-kids-podgorica'
 ORDER BY d.slug;

-- На клинике 54 педиатров не осталось: ожидается 0.
SELECT COUNT(*) AS pediatricians_left_on_54
  FROM doctor_clinics dc
  JOIN doctors d ON d.id = dc.doctor_id
  JOIN clinics p ON p.id = dc.clinic_id AND p.slug = 'poliklinika-natal-podgorica'
 WHERE d.slug IN ('slavica-ostojic', 'snezana-sebek', 'snezana-bugaric', 'dragan-prokic', 'olga-prentic',
                  'vesna-bardak', 'snezana-perazic', 'aleksandar-sovtic', 'vladislav-vukomanovic',
                  'sonja-milasinovic', 'marija-kolinovic', 'milorada-nesovic', 'predrag-ilic', 'aida-eco', 'dragan-nesovic');
