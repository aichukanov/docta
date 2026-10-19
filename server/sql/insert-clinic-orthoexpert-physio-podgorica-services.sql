-- ═══════════════════════════════════════════════════════════════════════════
-- OrthoExpert Physio Podgorica — услуги и цены
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-orthoexpert-physio-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-orthoexpert-physio-podgorica.sql. Клиника резолвится по google_place_id.
--
-- Источник: https://www.orthoexpert.me/cenovnik, блок «Ordinacija OrthoExpert Physio
-- Podgorica» (колонка «Cijena (EUR)»), собрано 2026-10-08. Блоки Beograd/Niš (RSD) не брались.
-- Дата прайса: явной нет. JSON-LD страницы — datePublished/dateModified 2022-06-07,
-- футер «© 2022-2026». is_price_outdated НЕ ставится — решает юзер.
--
-- В блоке Подгорицы 68 строк с ценой. Заведено 51 позиций каталога (49 с ценой),
-- покрывают 63 строки. 5 строк — в «Спорные» (запись импорта, раздел disputed):
--   * отдельные «Pregled inostranog konsultanta» 120 и «Kontrolni pregled inostranog
--     konsultanta» 80: в каталоге нет ранга «иностранный консультант» (решение юзера —
--     оставить спорными);
--   * Mezoterapija 50 (дважды: в «Pojedinačne usluge» и в «Kineziterapija») — в каталоге
--     нет общей «Mesotherapy», а цель (эстетика или обезболивание) прайс не называет;
--   * Terapija Guna kolagenom 30 — кандидата нет, бренд.
--
-- Решения по сопоставлению:
--   * Пакеты 1–4 (решение юзера 2026-10-08): каждая строка пакета — своя запись каталога
--     по схеме «<осмотр> with Ultrasound [and Blockade]», как существующие Specialist /
--     Subspecialist / Professor Examination with Ultrasound. 13 из них новые (PART 0).
--   * Осмотры заведены как в прайсе — по рангу врача (Specialist / Subspecialist /
--     Professor Examination), без привязки к ортопеду или физиатру: прайс её не делает.
--   * «Ultrazvučni pregled» → Musculoskeletal Ultrasound: ортопедическая ординация,
--     главная страница называет «ultrazvučni ortopedski pregledi».
--   * «Aplikacija botoxa» → Botox Injection (единственная общая запись; её категории
--     эстетические, а цель в прайсе не названа).
--   * Восемь вариантов «Fizikalna terapija po terapijskom danu» (#1–#8) и восемь пакетов
--     FT#1–FT#8 сведены в две новые записи с диапазоном цены (min–max); состав каждого
--     варианта — в комментарии строки и в записи импорта.
--   * Tecar Therapy и Super Inductive System Therapy — без цены: в прайсе это составная
--     часть пакетов («SIS/TECAR + klasični fizikalni agensi…»), отдельной цены нет.
--   * «Kineziotejping» → Taping Application, «Aparaturna limfna drenaža» → Pressotherapy
--     (без длительности), «Parcijalna masaža» → Partial Therapeutic Massage.
--
-- Новые записи каталога (PART 0) — 27 шт., список дублируется в
-- data/clinic-imports/_wave1-new-catalog-C.json для сверки координатором.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены обновляются
-- ON DUPLICATE KEY UPDATE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- Врач↔услуга не привязываются: прайс не называет врачей.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @google_place_id = 'ChIJhfDvLo_rTRMRosr6ahUrUwI';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-orthoexpert-physio-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- Категории: 5 = PHYSIOTHERAPY, 9 = GENERAL_MEDICINE (пакеты осмотров, как у Specialist
--            Examination with Ultrasound), 10 = ORTHOPEDICS, 19 = PAIN_THERAPY,
--            29 = INJECTIONS_INFUSIONS.
-- Специальности: 42 = PHYSICAL_MEDICINE_REHABILITATION (к кат. 5), 17 = ORTHOPEDICS (к кат. 10
--            и к пакетам с блокадой), 2 и 10 — как у Specialist Examination with Ultrasound.
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'ultrasound-guided-blockade', 'Ultrasound-Guided Blockade', 'Blokada pod kontrolom ultrazvuka', 'Блокада под контролом ултразвука',
	'Блокада под контролем УЗИ', 'Ultraschallgesteuerte Blockade', 'Ultrason eşliğinde blokaj', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'ultrasound-guided-blockade' OR name_en = 'Ultrasound-Guided Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'intra-articular-hyaluronic-acid-injection', 'Intra-articular Hyaluronic Acid Injection', 'Intraartikularna infiltracija hijalurona', 'Интраартикуларна инфилтрација хијалурона',
	'Внутрисуставное введение гиалуроновой кислоты', 'Intraartikuläre Hyaluronsäure-Injektion', 'Eklem içi hyaluronik asit enjeksiyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection' OR name_en = 'Intra-articular Hyaluronic Acid Injection');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'preoperative-rehabilitation', 'Preoperative Rehabilitation', 'Preoperativna rehabilitacija', 'Преоперативна рехабилитација',
	'Предоперационная реабилитация', 'Präoperative Rehabilitation', 'Ameliyat öncesi rehabilitasyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'preoperative-rehabilitation' OR name_en = 'Preoperative Rehabilitation');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'physical-therapy-per-therapy-day', 'Physical Therapy per Therapy Day', 'Fizikalna terapija po terapijskom danu', 'Физикална терапија по терапијском дану',
	'Физиотерапия за один терапевтический день', 'Physikalische Therapie pro Therapietag', 'Terapi günü başına fizik tedavi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'physical-therapy-per-therapy-day' OR name_en = 'Physical Therapy per Therapy Day');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'physical-therapy-package-10-sessions-with-follow-up-examination', 'Physical Therapy Package 10 Sessions with Follow-up Examination', 'Paket fizikalne terapije – 10 terapija + kontrolni pregled', 'Пакет физикалне терапије – 10 терапија + контролни преглед',
	'Пакет физиотерапии: 10 процедур + контрольный осмотр', 'Physiotherapie-Paket: 10 Behandlungen + Kontrolluntersuchung', 'Fizik tedavi paketi: 10 seans + kontrol muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'physical-therapy-package-10-sessions-with-follow-up-examination' OR name_en = 'Physical Therapy Package 10 Sessions with Follow-up Examination');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'kinesiotherapy-60-min', 'Kinesiotherapy 60 min', 'Kineziterapija – 60 min.', 'Кинезитерапија – 60 мин.',
	'Кинезитерапия 60 мин', 'Kinesiotherapie 60 Min.', 'Kineziterapi 60 dk', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'kinesiotherapy-60-min' OR name_en = 'Kinesiotherapy 60 min');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'kinesiotherapy-60-min-package-10-treatments', 'Kinesiotherapy 60 min Package 10 Treatments', 'Kineziterapija 60 min. – paket 10 tretmana', 'Кинезитерапија 60 мин. – пакет 10 третмана',
	'Кинезитерапия 60 мин пакет 10 процедур', 'Kinesiotherapie 60 Min. Paket 10 Behandlungen', 'Kineziterapi 60 dk 10 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'kinesiotherapy-60-min-package-10-treatments' OR name_en = 'Kinesiotherapy 60 min Package 10 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'kinesiotherapy-60-min-package-20-treatments', 'Kinesiotherapy 60 min Package 20 Treatments', 'Kineziterapija 60 min. – paket 20 tretmana', 'Кинезитерапија 60 мин. – пакет 20 третмана',
	'Кинезитерапия 60 мин пакет 20 процедур', 'Kinesiotherapie 60 Min. Paket 20 Behandlungen', 'Kineziterapi 60 dk 20 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'kinesiotherapy-60-min-package-20-treatments' OR name_en = 'Kinesiotherapy 60 min Package 20 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'anti-cellulite-shockwave-therapy-with-lymphatic-drainage', 'Anti-Cellulite Shockwave Therapy with Lymphatic Drainage', 'Shockwave anticelulit + limfna drenaža', 'Схоцкwаве антицелулит + лимфна дренажа',
	'Антицеллюлитная ударно-волновая терапия + лимфодренаж', 'Anti-Cellulite-Stoßwellentherapie mit Lymphdrainage', 'Selülit için şok dalga tedavisi ve lenf drenajı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'anti-cellulite-shockwave-therapy-with-lymphatic-drainage' OR name_en = 'Anti-Cellulite Shockwave Therapy with Lymphatic Drainage');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'relaxing-massage-60-min', 'Relaxing Massage 60 min', 'Relaks masaža 60 min', 'Релакс масажа 60 мин',
	'Расслабляющий массаж 60 мин', 'Entspannungsmassage 60 Min', 'Rahatlatıcı masaj 60 dk', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'relaxing-massage-60-min' OR name_en = 'Relaxing Massage 60 min');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'tecar-beauty-face-and-neck', 'TECAR Beauty Face and Neck', 'TECAR Beauty lice i vrat', 'TECAR Beauty лице и врат',
	'TECAR Beauty: лицо и шея', 'TECAR Beauty Gesicht und Hals', 'TECAR Beauty yüz ve boyun', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'tecar-beauty-face-and-neck' OR name_en = 'TECAR Beauty Face and Neck');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'tecar-beauty-face-and-neck-package-6-treatments', 'TECAR Beauty Face and Neck Package 6 Treatments', 'TECAR Beauty lice i vrat – paket 6 tretmana', 'TECAR Beauty лице и врат – пакет 6 третмана',
	'TECAR Beauty: лицо и шея, пакет 6 процедур', 'TECAR Beauty Gesicht und Hals Paket 6 Behandlungen', 'TECAR Beauty yüz ve boyun 6 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'tecar-beauty-face-and-neck-package-6-treatments' OR name_en = 'TECAR Beauty Face and Neck Package 6 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'tecar-beauty-face-neck-and-decollete', 'TECAR Beauty Face, Neck and Decollete', 'TECAR Beauty lice, vrat i dekolte', 'TECAR Beauty лице, врат и деколте',
	'TECAR Beauty: лицо, шея и декольте', 'TECAR Beauty Gesicht, Hals und Dekolleté', 'TECAR Beauty yüz, boyun ve dekolte', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'tecar-beauty-face-neck-and-decollete' OR name_en = 'TECAR Beauty Face, Neck and Decollete');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'tecar-beauty-face-neck-and-decollete-package-6-treatments', 'TECAR Beauty Face, Neck and Decollete Package 6 Treatments', 'TECAR Beauty lice, vrat i dekolte – paket 6 tretmana', 'TECAR Beauty лице, врат и деколте – пакет 6 третмана',
	'TECAR Beauty: лицо, шея и декольте, пакет 6 процедур', 'TECAR Beauty Gesicht, Hals und Dekolleté Paket 6 Behandlungen', 'TECAR Beauty yüz, boyun ve dekolte 6 seans paketi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'tecar-beauty-face-neck-and-decollete-package-6-treatments' OR name_en = 'TECAR Beauty Face, Neck and Decollete Package 6 Treatments');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'foreign-consultant-examination-with-ultrasound', 'Foreign Consultant Examination with Ultrasound', 'Pregled inostranog konsultanta sa ultrazvukom', 'Преглед иностраног консултанта са ултразвуком',
	'Осмотр иностранного консультанта с УЗИ', 'Untersuchung durch ausländischen Konsiliararzt mit Ultraschall', 'Ultrasonlu Yabancı Konsültan Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'foreign-consultant-examination-with-ultrasound' OR name_en = 'Foreign Consultant Examination with Ultrasound');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'foreign-consultant-examination-with-ultrasound-and-blockade', 'Foreign Consultant Examination with Ultrasound and Blockade', 'Pregled inostranog konsultanta sa ultrazvukom i blokadom', 'Преглед иностраног консултанта са ултразвуком и блокадом',
	'Осмотр иностранного консультанта с УЗИ и блокадой', 'Untersuchung durch ausländischen Konsiliararzt mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Yabancı Konsültan Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'foreign-consultant-examination-with-ultrasound-and-blockade' OR name_en = 'Foreign Consultant Examination with Ultrasound and Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'professor-examination-with-ultrasound-and-blockade', 'Professor Examination with Ultrasound and Blockade', 'Profesorski pregled sa ultrazvukom i blokadom', 'Професорски преглед са ултразвуком и блокадом',
	'Профессорский осмотр с УЗИ и блокадой', 'Professorale Untersuchung mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Profesör Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'professor-examination-with-ultrasound-and-blockade' OR name_en = 'Professor Examination with Ultrasound and Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'subspecialist-examination-with-ultrasound-and-blockade', 'Subspecialist Examination with Ultrasound and Blockade', 'Subspecijalistički pregled sa ultrazvukom i blokadom', 'Субспецијалистички преглед са ултразвуком и блокадом',
	'Субспециализированный осмотр с УЗИ и блокадой', 'Subspezialistische Untersuchung mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Alt Uzmanlık Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'subspecialist-examination-with-ultrasound-and-blockade' OR name_en = 'Subspecialist Examination with Ultrasound and Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'specialist-examination-with-ultrasound-and-blockade', 'Specialist Examination with Ultrasound and Blockade', 'Specijalistički pregled sa ultrazvukom i blokadom', 'Специјалистички преглед са ултразвуком и блокадом',
	'Специализированный осмотр с УЗИ и блокадой', 'Facharztuntersuchung mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Uzman Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'specialist-examination-with-ultrasound-and-blockade' OR name_en = 'Specialist Examination with Ultrasound and Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-foreign-consultant-examination-with-ultrasound', 'Follow-up Foreign Consultant Examination with Ultrasound', 'Kontrolni pregled inostranog konsultanta sa ultrazvukom', 'Контролни преглед иностраног консултанта са ултразвуком',
	'Контрольный осмотр иностранного консультанта с УЗИ', 'Kontrolluntersuchung durch ausländischen Konsiliararzt mit Ultraschall', 'Ultrasonlu Yabancı Konsültan Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-foreign-consultant-examination-with-ultrasound' OR name_en = 'Follow-up Foreign Consultant Examination with Ultrasound');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-professor-examination-with-ultrasound', 'Follow-up Professor Examination with Ultrasound', 'Kontrolni profesorski pregled sa ultrazvukom', 'Контролни професорски преглед са ултразвуком',
	'Контрольный профессорский осмотр с УЗИ', 'Kontrolluntersuchung durch einen Professor mit Ultraschall', 'Ultrasonlu Profesör Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-professor-examination-with-ultrasound' OR name_en = 'Follow-up Professor Examination with Ultrasound');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-subspecialist-examination-with-ultrasound', 'Follow-up Subspecialist Examination with Ultrasound', 'Kontrolni subspecijalistički pregled sa ultrazvukom', 'Контролни субспецијалистички преглед са ултразвуком',
	'Контрольный субспециализированный осмотр с УЗИ', 'Subspezialistische Kontrolluntersuchung mit Ultraschall', 'Ultrasonlu Alt Uzmanlık Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-subspecialist-examination-with-ultrasound' OR name_en = 'Follow-up Subspecialist Examination with Ultrasound');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-specialist-examination-with-ultrasound', 'Follow-up Specialist Examination with Ultrasound', 'Kontrolni specijalistički pregled sa ultrazvukom', 'Контролни специјалистички преглед са ултразвуком',
	'Контрольный специализированный осмотр с УЗИ', 'Facharzt-Kontrolluntersuchung mit Ultraschall', 'Ultrasonlu Uzman Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-specialist-examination-with-ultrasound' OR name_en = 'Follow-up Specialist Examination with Ultrasound');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade', 'Follow-up Foreign Consultant Examination with Ultrasound and Blockade', 'Kontrolni pregled inostranog konsultanta sa ultrazvukom i blokadom', 'Контролни преглед иностраног консултанта са ултразвуком и блокадом',
	'Контрольный осмотр иностранного консультанта с УЗИ и блокадой', 'Kontrolluntersuchung durch ausländischen Konsiliararzt mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Yabancı Konsültan Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade' OR name_en = 'Follow-up Foreign Consultant Examination with Ultrasound and Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-professor-examination-with-ultrasound-and-blockade', 'Follow-up Professor Examination with Ultrasound and Blockade', 'Kontrolni profesorski pregled sa ultrazvukom i blokadom', 'Контролни професорски преглед са ултразвуком и блокадом',
	'Контрольный профессорский осмотр с УЗИ и блокадой', 'Kontrolluntersuchung durch einen Professor mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Profesör Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-professor-examination-with-ultrasound-and-blockade' OR name_en = 'Follow-up Professor Examination with Ultrasound and Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-subspecialist-examination-with-ultrasound-and-blockade', 'Follow-up Subspecialist Examination with Ultrasound and Blockade', 'Kontrolni subspecijalistički pregled sa ultrazvukom i blokadom', 'Контролни субспецијалистички преглед са ултразвуком и блокадом',
	'Контрольный субспециализированный осмотр с УЗИ и блокадой', 'Subspezialistische Kontrolluntersuchung mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Alt Uzmanlık Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-subspecialist-examination-with-ultrasound-and-blockade' OR name_en = 'Follow-up Subspecialist Examination with Ultrasound and Blockade');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'follow-up-specialist-examination-with-ultrasound-and-blockade', 'Follow-up Specialist Examination with Ultrasound and Blockade', 'Kontrolni specijalistički pregled sa ultrazvukom i blokadom', 'Контролни специјалистички преглед са ултразвуком и блокадом',
	'Контрольный специализированный осмотр с УЗИ и блокадой', 'Facharzt-Kontrolluntersuchung mit Ultraschall und Blockade', 'Ultrason ve Blokajlı Uzman Kontrol Muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'follow-up-specialist-examination-with-ultrasound-and-blockade' OR name_en = 'Follow-up Specialist Examination with Ultrasound and Blockade');



INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN (
	'preoperative-rehabilitation',
	'physical-therapy-per-therapy-day',
	'physical-therapy-package-10-sessions-with-follow-up-examination',
	'kinesiotherapy-60-min',
	'kinesiotherapy-60-min-package-10-treatments',
	'kinesiotherapy-60-min-package-20-treatments',
	'anti-cellulite-shockwave-therapy-with-lymphatic-drainage',
	'relaxing-massage-60-min',
	'tecar-beauty-face-and-neck',
	'tecar-beauty-face-and-neck-package-6-treatments',
	'tecar-beauty-face-neck-and-decollete',
	'tecar-beauty-face-neck-and-decollete-package-6-treatments'
);

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 9 FROM medical_services WHERE slug IN (
	'foreign-consultant-examination-with-ultrasound',
	'foreign-consultant-examination-with-ultrasound-and-blockade',
	'professor-examination-with-ultrasound-and-blockade',
	'subspecialist-examination-with-ultrasound-and-blockade',
	'specialist-examination-with-ultrasound-and-blockade',
	'follow-up-foreign-consultant-examination-with-ultrasound',
	'follow-up-professor-examination-with-ultrasound',
	'follow-up-subspecialist-examination-with-ultrasound',
	'follow-up-specialist-examination-with-ultrasound',
	'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade',
	'follow-up-professor-examination-with-ultrasound-and-blockade',
	'follow-up-subspecialist-examination-with-ultrasound-and-blockade',
	'follow-up-specialist-examination-with-ultrasound-and-blockade'
);

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 10 FROM medical_services WHERE slug IN (
	'ultrasound-guided-blockade',
	'intra-articular-hyaluronic-acid-injection'
);

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 19 FROM medical_services WHERE slug IN (
	'ultrasound-guided-blockade',
	'foreign-consultant-examination-with-ultrasound-and-blockade',
	'professor-examination-with-ultrasound-and-blockade',
	'subspecialist-examination-with-ultrasound-and-blockade',
	'specialist-examination-with-ultrasound-and-blockade',
	'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade',
	'follow-up-professor-examination-with-ultrasound-and-blockade',
	'follow-up-subspecialist-examination-with-ultrasound-and-blockade',
	'follow-up-specialist-examination-with-ultrasound-and-blockade'
);

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 29 FROM medical_services WHERE slug IN (
	'intra-articular-hyaluronic-acid-injection'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 2 FROM medical_services WHERE slug IN (
	'foreign-consultant-examination-with-ultrasound',
	'foreign-consultant-examination-with-ultrasound-and-blockade',
	'professor-examination-with-ultrasound-and-blockade',
	'subspecialist-examination-with-ultrasound-and-blockade',
	'specialist-examination-with-ultrasound-and-blockade',
	'follow-up-foreign-consultant-examination-with-ultrasound',
	'follow-up-professor-examination-with-ultrasound',
	'follow-up-subspecialist-examination-with-ultrasound',
	'follow-up-specialist-examination-with-ultrasound',
	'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade',
	'follow-up-professor-examination-with-ultrasound-and-blockade',
	'follow-up-subspecialist-examination-with-ultrasound-and-blockade',
	'follow-up-specialist-examination-with-ultrasound-and-blockade'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug IN (
	'foreign-consultant-examination-with-ultrasound',
	'foreign-consultant-examination-with-ultrasound-and-blockade',
	'professor-examination-with-ultrasound-and-blockade',
	'subspecialist-examination-with-ultrasound-and-blockade',
	'specialist-examination-with-ultrasound-and-blockade',
	'follow-up-foreign-consultant-examination-with-ultrasound',
	'follow-up-professor-examination-with-ultrasound',
	'follow-up-subspecialist-examination-with-ultrasound',
	'follow-up-specialist-examination-with-ultrasound',
	'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade',
	'follow-up-professor-examination-with-ultrasound-and-blockade',
	'follow-up-subspecialist-examination-with-ultrasound-and-blockade',
	'follow-up-specialist-examination-with-ultrasound-and-blockade'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 17 FROM medical_services WHERE slug IN (
	'ultrasound-guided-blockade',
	'intra-articular-hyaluronic-acid-injection',
	'foreign-consultant-examination-with-ultrasound-and-blockade',
	'professor-examination-with-ultrasound-and-blockade',
	'subspecialist-examination-with-ultrasound-and-blockade',
	'specialist-examination-with-ultrasound-and-blockade',
	'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade',
	'follow-up-professor-examination-with-ultrasound-and-blockade',
	'follow-up-subspecialist-examination-with-ultrasound-and-blockade',
	'follow-up-specialist-examination-with-ultrasound-and-blockade'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN (
	'preoperative-rehabilitation',
	'physical-therapy-per-therapy-day',
	'physical-therapy-package-10-sessions-with-follow-up-examination',
	'kinesiotherapy-60-min',
	'kinesiotherapy-60-min-package-10-treatments',
	'kinesiotherapy-60-min-package-20-treatments',
	'anti-cellulite-shockwave-therapy-with-lymphatic-drainage',
	'relaxing-massage-60-min',
	'tecar-beauty-face-and-neck',
	'tecar-beauty-face-and-neck-package-6-treatments',
	'tecar-beauty-face-neck-and-decollete',
	'tecar-beauty-face-neck-and-decollete-package-6-treatments'
);

-- Синонимы (новые записи + формулировки прайса к существующим)
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Hijaluron u zglob', 'sr' FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection'
UNION ALL SELECT id, 'Хијалурон у зглоб', 'sr-cyrl' FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection'
UNION ALL SELECT id, 'Viscosupplementation', 'en' FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection'
UNION ALL SELECT id, 'Вискосапплементация', 'ru' FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection'
UNION ALL SELECT id, 'Гиалуроновая кислота в сустав', 'ru' FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection'
UNION ALL SELECT id, 'Viskosupplementation', 'de' FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection'
UNION ALL SELECT id, 'Viskosuplementasyon', 'tr' FROM medical_services WHERE slug = 'intra-articular-hyaluronic-acid-injection'
UNION ALL SELECT id, 'Prehabilitation', 'en' FROM medical_services WHERE slug = 'preoperative-rehabilitation'
UNION ALL SELECT id, 'Преабилитация', 'ru' FROM medical_services WHERE slug = 'preoperative-rehabilitation'
UNION ALL SELECT id, 'Prähabilitation', 'de' FROM medical_services WHERE slug = 'preoperative-rehabilitation'
UNION ALL SELECT id, 'Relax masaža', 'sr' FROM medical_services WHERE slug = 'relaxing-massage-60-min'
UNION ALL SELECT id, 'Релакс масажа', 'sr-cyrl' FROM medical_services WHERE slug = 'relaxing-massage-60-min'
UNION ALL SELECT id, 'Релакс-массаж', 'ru' FROM medical_services WHERE slug = 'relaxing-massage-60-min'
UNION ALL SELECT id, 'Kineziotejping', 'sr' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'Кинезиотејпинг', 'sr-cyrl' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'Kinesio taping', 'en' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'Кинезиотейпирование', 'ru' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'Kinesio-Taping', 'de' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'Kinezyo bantlama', 'tr' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'Aparaturna limfna drenaža', 'sr' FROM medical_services WHERE slug = 'pressotherapy'
UNION ALL SELECT id, 'Апаратурна лимфна дренажа', 'sr-cyrl' FROM medical_services WHERE slug = 'pressotherapy'
UNION ALL SELECT id, 'Аппаратный лимфодренаж', 'ru' FROM medical_services WHERE slug = 'pressotherapy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ С ЦЕНАМИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_orthoexpert_services;
CREATE TEMPORARY TABLE tmp_orthoexpert_services (
	name_en VARCHAR(255) NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_orthoexpert_services (name_en, price, price_min, price_max) VALUES
('Specialist Examination', 60, NULL, NULL), -- Specijalistički pregled — 60,00
('Subspecialist Examination', 70, NULL, NULL), -- Subspecijalistički pregled — 70,00
('Professor Examination', 80, NULL, NULL), -- Pregled profesora — 80,00
('Follow-up Specialist Examination', 30, NULL, NULL), -- Kontrolni specijalistički pregled (do 30 dana) — 30,00
('Follow-up Subspecialist Examination', 30, NULL, NULL), -- Kontrolni subspecijalistički pregled — 30,00
('Follow-up Professor Examination', 40, NULL, NULL), -- Kontrolni pregled profesora — 40,00
('Musculoskeletal Ultrasound', 50, NULL, NULL), -- Ultrazvučni pregled — 50,00 (ortopedska ordinacija; naslovna: «Specijalistički i subspecijalistički ultrazvučni ortopedski pregledi»)
('Ultrasound-Guided Blockade', 50, NULL, NULL), -- Blokada — 50,00 (blok «Pojedinačne usluge: pregledi, blokade pod kontrolom ultrazvuka»)
('Intramuscular Injection', 20, NULL, NULL), -- Intramuskularne injekcije — 20,00
('Intra-articular Hyaluronic Acid Injection', 270, NULL, NULL), -- Intraartikularna infiltracija hijalurona — 270,00
('Botox Injection', 220, NULL, NULL), -- Aplikacija botoxa — 220,00
('Specialist Examination with Ultrasound', 90, NULL, NULL), -- Paket 1 (pregled + ultrazvuk): Specijalistički pregled + ultrazvučni pregled — 90,00
('Subspecialist Examination with Ultrasound', 100, NULL, NULL), -- Paket 1: Subspecijalistički pregled + ultrazvučni pregled — 100,00
('Professor Examination with Ultrasound', 110, NULL, NULL), -- Paket 1: Pregled profesora + ultrazvučni pregled — 110,00
('Foreign Consultant Examination with Ultrasound', 150, NULL, NULL), -- Paket 1: Pregled inostranog konsultanta + ultrazvučni pregled — 150,00
('Foreign Consultant Examination with Ultrasound and Blockade', 180, NULL, NULL), -- Paket 2 (pregled + ultrazvuk + blokada): Pregled inostranog konsultanta + ultrazvučni pregled + blokada — 180,00
('Professor Examination with Ultrasound and Blockade', 140, NULL, NULL), -- Paket 2: Pregled profesora + ultrazvučni pregled + blokada — 140,00
('Subspecialist Examination with Ultrasound and Blockade', 120, NULL, NULL), -- Paket 2: Subspecijalistički pregled + ultrazvučni pregled + blokada — 120,00
('Specialist Examination with Ultrasound and Blockade', 110, NULL, NULL), -- Paket 2: Specijalistički pregled + ultrazvučni pregled + blokada — 110,00
('Follow-up Foreign Consultant Examination with Ultrasound', 110, NULL, NULL), -- Paket 3 (kontrolni pregled + ultrazvuk): Kontrolni pregled inostranog konsultanta + ultrazvučni pregled — 110,00
('Follow-up Professor Examination with Ultrasound', 80, NULL, NULL), -- Paket 3: Kontrolni pregled profesora + ultrazvučni pregled — 80,00
('Follow-up Subspecialist Examination with Ultrasound', 70, NULL, NULL), -- Paket 3: Kontrolni subspecijalistički pregled + ultrazvučni pregled — 70,00
('Follow-up Specialist Examination with Ultrasound', 70, NULL, NULL), -- Paket 3: Kontrolni specijalistički pregled + ultrazvučni pregled — 70,00
('Follow-up Foreign Consultant Examination with Ultrasound and Blockade', 140, NULL, NULL), -- Paket 4 (kontrolni pregled + ultrazvuk + blokada): Kontrolni pregled inostranog konsultanta + ultrazvučni pregled + blokada — 140,00
('Follow-up Professor Examination with Ultrasound and Blockade', 100, NULL, NULL), -- Paket 4: Kontrolni pregled profesora + ultrazvučni pregled + blokada — 100,00
('Follow-up Subspecialist Examination with Ultrasound and Blockade', 90, NULL, NULL), -- Paket 4: Kontrolni subspecijalistički pregled + ultrazvučni pregled + blokada — 90,00
('Follow-up Specialist Examination with Ultrasound and Blockade', 90, NULL, NULL), -- Paket 4: Kontrolni specijalistički pregled + ultrazvučni pregled + blokada — 90,00
('Preoperative Rehabilitation', 600, NULL, NULL), -- Preoperativna rehabilitacija: SIS/TECAR + klasični fizikalni agensi + KTH x 20 — 600,00
('Postoperative Locomotor System Rehabilitation', 700, NULL, NULL), -- Postoperativna rehabilitacija: SIS/TECAR + klasični fizikalni agensi + KTH x 20 — 700,00
('Physical Therapy per Therapy Day', 20, NULL, 45), -- Fizikalna terapija po terapijskom danu, #1–#8: #1 ≤ 2 klasična fizikalna agensa bez kineziterapije 20,00; #2 > 2 agensa bez KT 25,00; #3 ≤ 2 sa KT 30,00; #4 > 2 sa KT 35,00; #5 SIS/TECAR + ≤ 2 bez KT 35,00; #6 SIS/TECAR + > 2 bez KT 40,00; #7 SIS/TECAR + ≤ 2 sa KT 40,00; #8 SIS/TECAR + > 2 sa KT 45,00
('Physical Therapy Package 10 Sessions with Follow-up Examination', 200, NULL, 450), -- Terapijski paketi FT#1–FT#8 «10 terapija + kontrolni pregled»: FT#1 200,00; FT#2 250,00; FT#3 300,00; FT#4 350,00; FT#5 350,00; FT#6 400,00; FT#7 400,00; FT#8 450,00
('Tecar Therapy', NULL, NULL, NULL), -- «SIS/TECAR» — sastavni dio pre-/postoperativne rehabilitacije i dana fizikalne terapije #5–#8; zasebne cijene nema
('Super Inductive System Therapy', NULL, NULL, NULL), -- «SIS/TECAR» — sastavni dio pre-/postoperativne rehabilitacije i dana fizikalne terapije #5–#8; zasebne cijene nema
('Kinesiotherapy 30 min', 25, NULL, NULL), -- Kineziterapija individualne vježbe 30 min — 25,00
('Kinesiotherapy 60 min', 40, NULL, NULL), -- Kineziterapija individualne vježbe 60 min — 40,00
('Kinesiotherapy 60 min Package 10 Treatments', 360, NULL, NULL), -- Kineziterapija individualne vježbe 60 min - 10 terapija — 360,00
('Kinesiotherapy 60 min Package 20 Treatments', 700, NULL, NULL), -- Kineziterapija individualne vježbe 60 min - 20 terapija — 700,00
('Schroth Method', 60, NULL, NULL), -- Kineziterapija individualne vježbe po Šrotu — 60,00
('Shock Wave Therapy', 30, NULL, NULL), -- Shockwave terapija — 30,00
('Anti-Cellulite Shockwave Therapy with Lymphatic Drainage', 60, NULL, NULL), -- Shockwave anticelulit + limfna drenaža — 60,00
('Taping Application', 20, NULL, NULL), -- Kineziotejping — 20,00
('Acupuncture', 25, NULL, NULL), -- Akupunktura — 25,00
('Manual Lymphatic Drainage 60 min', 35, NULL, NULL), -- Manuelna limfna drenaža cijelo tijelo 60 min — 35,00
('Pressotherapy', 30, NULL, NULL), -- Aparaturna limfna drenaža — 30,00
('Relaxing Massage 60 min', 35, NULL, NULL), -- Terapeutska relax masaža 60 min — 35,00
('Sports Massage 60 min', 50, NULL, NULL), -- Terapeutska sportska masaža 60 min — 50,00
('Partial Therapeutic Massage', 25, NULL, NULL), -- Parcijalna masaža — 25,00
('TECAR Beauty Face and Neck', 30, NULL, NULL), -- Fizioestetika: TECAR Beauty lice i vrat — 30,00
('TECAR Beauty Face and Neck Package 6 Treatments', 150, NULL, NULL), -- Fizioestetika: TECAR Beauty lice i vrat x6 — 150,00
('TECAR Beauty Face, Neck and Decollete', 50, NULL, NULL), -- Fizioestetika: TECAR Beauty lice, vrat i dekolte — 50,00
('TECAR Beauty Face, Neck and Decollete Package 6 Treatments', 250, NULL, NULL); -- Fizioestetika: TECAR Beauty lice, vrat i dekolte x6 — 250,00

-- Ожидается ПУСТО: имена, не найденные в каталоге.
SELECT t.name_en AS unmatched_service
FROM tmp_orthoexpert_services t
LEFT JOIN medical_services ms ON ms.name_en = t.name_en
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_orthoexpert_services t ON t.name_en = ms.name_en
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_orthoexpert_services t ON t.name_en = ms.name_en
WHERE cms.clinic_id = @clinic_id AND t.name_en IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 51 услуг, с ценой 49.
SELECT COUNT(*) AS services_total,
	SUM(cms.price IS NOT NULL OR cms.price_min IS NOT NULL) AS with_price
FROM clinic_medical_services cms WHERE cms.clinic_id = @clinic_id;

SELECT ms.name_en, ms.slug, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 27: новые записи каталога с категорией.
SELECT ms.slug, GROUP_CONCAT(r.medical_service_category_id) AS cats
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
WHERE ms.slug IN ('ultrasound-guided-blockade', 'intra-articular-hyaluronic-acid-injection', 'preoperative-rehabilitation', 'physical-therapy-per-therapy-day', 'physical-therapy-package-10-sessions-with-follow-up-examination', 'kinesiotherapy-60-min', 'kinesiotherapy-60-min-package-10-treatments', 'kinesiotherapy-60-min-package-20-treatments', 'anti-cellulite-shockwave-therapy-with-lymphatic-drainage', 'relaxing-massage-60-min', 'tecar-beauty-face-and-neck', 'tecar-beauty-face-and-neck-package-6-treatments', 'tecar-beauty-face-neck-and-decollete', 'tecar-beauty-face-neck-and-decollete-package-6-treatments', 'foreign-consultant-examination-with-ultrasound', 'foreign-consultant-examination-with-ultrasound-and-blockade', 'professor-examination-with-ultrasound-and-blockade', 'subspecialist-examination-with-ultrasound-and-blockade', 'specialist-examination-with-ultrasound-and-blockade', 'follow-up-foreign-consultant-examination-with-ultrasound', 'follow-up-professor-examination-with-ultrasound', 'follow-up-subspecialist-examination-with-ultrasound', 'follow-up-specialist-examination-with-ultrasound', 'follow-up-foreign-consultant-examination-with-ultrasound-and-blockade', 'follow-up-professor-examination-with-ultrasound-and-blockade', 'follow-up-subspecialist-examination-with-ultrasound-and-blockade', 'follow-up-specialist-examination-with-ultrasound-and-blockade')
GROUP BY ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_orthoexpert_services;
