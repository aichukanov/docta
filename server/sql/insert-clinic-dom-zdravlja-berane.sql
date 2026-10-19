-- ═══════════════════════════════════════════════════════════════════════════
-- JZU Dom zdravlja "Dr Nika Labović" Berane — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-berane.sql
-- Затем: server/sql/insert-clinic-dom-zdravlja-berane-services.sql
--
-- Источники (собрано 2026-10-08, curl с браузерным UA — без него mod_security отдаёт 406):
--   * https://domzdravljaberane.me/ (Joomla): /o-nama/info, /o-nama/objekti,
--     /o-nama/menadzment, /kontaktirajte-nas (+ /9-jzu-dom-zdravlja-dr-nika-labovic-berane),
--     /brojevi-telefona-u-ordinacijama, /radno-vrijeme-izabranih-doktora (raspored
--     5.–11.10.2026), /radno-vrijeme-sluzbi, /ljekarska-uvjerenja, /sanitarne-knjizice.
--   * data/google-places/berane/jzu-dom-zdravlja-dr-nika-labovic.json — place_id,
--     координаты, телефон (Google не перезапрашивался).
--   * Сайт не взломан: скрытых блоков казино нет. Домен bolnicaberane.com (перекуплен
--     под казино) к ДЗ отношения не имеет и не использовался.
--
-- Сверка фактов:
--   * Адрес: /kontaktirajte-nas «Ulica Miljana Tomičića, br. 4, Berane 84300»; Google
--     «RVX9+RRM, Miljana Tomčića, Berane» (опечатка Google в фамилии) — записано по сайту.
--   * Координаты 42.84959590 / 19.86954690 — Google Places, единственный источник.
--   * Телефоны: +38251233324 (сайт: ДЗ, Google — тот же), +38251233325 (сайт: Info centar).
--   * Email: общего адреса на сайте нет (только форма). Единственный адрес —
--     epid.dz.berane@t-com.me на /sanitarne-knjizice, это ящик ХЭС для санитарных
--     осмотров; в clinics.email не записан, чтобы не слать туда общие вопросы.
--   * Facebook: ссылка в футере всех страниц.
--   * Логотип — файл шаблона сайта (PNG с прозрачным фоном), внешний URL.
--   * Часы: /radno-vrijeme-sluzbi — izabrani doktor za odrasle I smjena 07–15,
--     II smjena 13–21 в рабочие дни; в субботу, воскресенье и праздники — «jedan tim ID,
--     I smjena 07:00–15:00» (дети — так же). Записано пн–пт 07–21, сб–вс 07–15.
--     Остальные службы — 07–15 по будням, у них своих часов в карточке нет.
--   * Тип: POLYCLINIC (1) — как у всех ДЗ в БД. Языки клиники: только SR.
--   * Директор — Marica Janković, diplomirana pravnica (/o-nama/menadzment), не врач —
--     не заводится. Прайсы 2016 подписаны «DIREKTORKA dr Zuhra Hadrović» — сейчас она
--     в списке izabranih doktora za odrasle.
--
-- Врачи (35): список ordinacija (/brojevi-telefona-u-ordinacijama), недельный
-- график (/radno-vrijeme-izabranih-doktora, 5.–11.10.2026: замещающие врачи, ZS Petnjica,
-- гинекологи KBC Berane на замене) и tim za ljekarska uvjerenja (/ljekarska-uvjerenja).
-- Не заводятся: 2 психолога (Ana Golubović Popović, Snežana Vukajlović — dipl.
-- psihološkinje), директор, главная сестра, санитарные техники ХЭС.
-- Специальности по data/clinic-teams/decisions/domovi-zdravlja.md: za odrasle →
-- general_medicine, za djecu → pediatrics, za žene → gynecology_obstetrics.
-- Врачи — только по slug (шаблон «найти или создать»): так параллельные импорты
-- сходятся на одной записи. Существующие (4, все из OB Berane) — только привязка
-- doctor_clinics, их поля не трогаются. Фото на сайте нет — photo_url NULL.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей, описания
-- пишутся безусловным UPDATE, языки клиники синхронизируются, position привязки
-- к этой клинике обновляется. Правки из админки следующий прогон перезатрёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ6bOlY8KTUhMR1jGc6dKoOkM';
SET @clinic_slug = 'dom-zdravlja-berane';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	9, -- CityId.BERANE
	'Dom zdravlja "Dr Nika Labović" Berane',
	'Дом здравља "Др Ника Лабовић" Беране',
	'Дом здоровья «Др Ника Лабович» Беране',
	'Miljana Tomičića 4',
	'Миљана Томичића 4',
	'',
	'',
	'84300',
	42.84959590,
	19.86954690,
	'+38251233324;+38251233325',
	'', -- общего email на сайте нет (см. шапку)
	'https://domzdravljaberane.me/',
	'facebook.com/JZU-Dom-zdravlja-Dr-Nika-Labovi%C4%87-Berane-269038347034',
	'',
	'',
	'',
	'',
	'https://domzdravljaberane.me/templates/g5_hydrogen/custom/images/Dom-zdravlja-Berane-logo-transparent.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Дом здравља "Др Ника Лабовић" Беране', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Дом здоровья «Др Ника Лабович» Беране', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Miljana Tomičića 4', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Миљана Томичића 4', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '84300', postal_code),
	latitude        = COALESCE(latitude, 42.84959590),
	longitude       = COALESCE(longitude, 19.86954690),
	phone           = IF(phone IS NULL OR phone = '', '+38251233324;+38251233325', phone),
	website         = IF(website IS NULL OR website = '', 'https://domzdravljaberane.me/', website),
	facebook        = IF(facebook IS NULL OR facebook = '', 'facebook.com/JZU-Dom-zdravlja-Dr-Nika-Labovi%C4%87-Berane-269038347034', facebook),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://domzdravljaberane.me/templates/g5_hydrogen/custom/images/Dom-zdravlja-Berane-logo-transparent.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что ДЗ пишет о себе: /o-nama/info
-- (области работы, центры и единицы), /o-nama/objekti (Lamela A/B, Centar za
-- reproduktivno zdravlje, ZS Petnjica, seoske ambulante), /ljekarska-uvjerenja,
-- /sanitarne-knjizice. Численность персонала и статистика 2024 не переносятся — устаревают.
UPDATE clinics SET
	description_sr = 'Javna zdravstvena ustanova Dom zdravlja "Dr Nika Labović" Berane je centar primarne zdravstvene zaštite za opštine Berane i Petnjica. U Domu zdravlja rade timovi izabranih doktora za odrasle, za djecu i za žene, a pet centara, dvije specijalističke ambulante i tri jedinice za podršku pružaju usluge iz oblasti dijagnostike, plućnih bolesti i tuberkuloze, mentalnog zdravlja, zdravstvene zaštite djece i mladih sa poremećajima u razvoju, interne medicine, oftalmologije, medicine rada, fizikalne terapije i rehabilitacije, patronaže, preventivne medicine, higijene, epidemiologije, imunizacije i sanitetskog prevoza. Ordinacije izabranih doktora i većina centara nalaze se u glavnom objektu (Lamela „A“); u Lameli „B“ su Centar za mentalno zdravlje, Higijensko-epidemiološka služba, Mikrobiološka laboratorija regionalnog nivoa, Centar za djecu sa smetnjama i teškoćama u razvoju, fizikalna terapija i savjetovališta, a izabrani doktori za žene rade u Centru za reproduktivno zdravlje. U sastavu Doma zdravlja su i Zdravstvena stanica Petnjica i povremene seoske ambulante. Ambulanta medicine rada izdaje ljekarska uvjerenja (za zaposlenje, vozače, oružje, pomorce i dr.), a Higijensko-epidemiološka služba izdaje sanitarne knjižice.',
	description_sr_cyrl = 'Јавна здравствена установа Дом здравља "Др Ника Лабовић" Беране је центар примарне здравствене заштите за општине Беране и Петњица. У Дому здравља раде тимови изабраних доктора за одрасле, за дјецу и за жене, а пет центара, двије специјалистичке амбуланте и три јединице за подршку пружају услуге из области дијагностике, плућних болести и туберкулозе, менталног здравља, здравствене заштите дјеце и младих са поремећајима у развоју, интерне медицине, офталмологије, медицине рада, физикалне терапије и рехабилитације, патронаже, превентивне медицине, хигијене, епидемиологије, имунизације и санитетског превоза. Ординације изабраних доктора и већина центара налазе се у главном објекту (Ламела „А“); у Ламели „Б“ су Центар за ментално здравље, Хигијенско-епидемиолошка служба, Микробиолошка лабораторија регионалног нивоа, Центар за дјецу са сметњама и тешкоћама у развоју, физикална терапија и савјетовалишта, а изабрани доктори за жене раде у Центру за репродуктивно здравље. У саставу Дома здравља су и Здравствена станица Петњица и повремене сеоске амбуланте. Амбуланта медицине рада издаје љекарска увјерења (за запослење, возаче, оружје, поморце и др.), а Хигијенско-епидемиолошка служба издаје санитарне књижице.',
	description_ru = 'Государственное учреждение Дом здоровья «Др Ника Лабович» в Беране — центр первичной медицинской помощи для общин Беране и Петница. Здесь работают команды выбранных врачей для взрослых, детей и женщин, а пять центров, две специализированные амбулатории и три вспомогательных подразделения охватывают диагностику, болезни лёгких и туберкулёз, психическое здоровье, помощь детям и молодёжи с нарушениями развития, внутренние болезни, офтальмологию, медицину труда, физиотерапию и реабилитацию, патронаж, профилактическую медицину, гигиену, эпидемиологию, иммунизацию и санитарный транспорт. Кабинеты выбранных врачей и большинство центров находятся в главном корпусе (ламель «A»); в ламели «B» — Центр психического здоровья, гигиеническо-эпидемиологическая служба, микробиологическая лаборатория регионального уровня, центр для детей с нарушениями и трудностями развития, физиотерапия и консультации, а выбранные врачи для женщин принимают в Центре репродуктивного здоровья. В состав Дома здоровья входят также медицинский пункт в Петнице и выездные сельские амбулатории. Амбулатория медицины труда выдаёт медицинские справки (для трудоустройства, водителей, на оружие, для моряков и др.), а гигиеническо-эпидемиологическая служба оформляет санитарные книжки.',
	description_en = 'The public health centre Dom zdravlja "Dr Nika Labović" Berane is the primary health care centre for the municipalities of Berane and Petnjica. It houses the teams of chosen doctors for adults, children and women, while five centres, two specialist outpatient clinics and three support units cover diagnostics, lung diseases and tuberculosis, mental health, care for children and young people with developmental disorders, internal medicine, ophthalmology, occupational medicine, physical therapy and rehabilitation, community nursing (patronage), preventive medicine, hygiene, epidemiology, immunisation and patient transport. The chosen doctors'' offices and most centres are in the main building (Lamela "A"); Lamela "B" houses the Mental Health Centre, the Hygiene and Epidemiology Service, a regional-level microbiology laboratory, the centre for children with developmental disabilities, physical therapy and the counselling services, and the chosen doctors for women work in the Reproductive Health Centre. The health centre also runs the Petnjica health station and part-time rural outpatient clinics. The occupational medicine clinic issues medical certificates (for employment, drivers, firearms, seafarers and more), and the Hygiene and Epidemiology Service issues sanitary health booklets.',
	description_de = 'Das öffentliche Gesundheitszentrum Dom zdravlja "Dr Nika Labović" Berane ist das Zentrum der primären Gesundheitsversorgung für die Gemeinden Berane und Petnjica. Hier arbeiten die Teams der gewählten Ärzte für Erwachsene, Kinder und Frauen; fünf Zentren, zwei fachärztliche Ambulanzen und drei Unterstützungseinheiten decken Diagnostik, Lungenkrankheiten und Tuberkulose, psychische Gesundheit, die Versorgung von Kindern und Jugendlichen mit Entwicklungsstörungen, Innere Medizin, Augenheilkunde, Arbeitsmedizin, physikalische Therapie und Rehabilitation, Gemeindepflege (Patronage), Präventivmedizin, Hygiene, Epidemiologie, Impfungen und Krankentransport ab. Die Praxen der gewählten Ärzte und die meisten Zentren befinden sich im Hauptgebäude (Lamela „A“); in der Lamela „B“ sind das Zentrum für psychische Gesundheit, der hygienisch-epidemiologische Dienst, ein regionales mikrobiologisches Labor, das Zentrum für Kinder mit Entwicklungsstörungen, die physikalische Therapie und die Beratungsstellen untergebracht, und die gewählten Ärzte für Frauen arbeiten im Zentrum für reproduktive Gesundheit. Zum Gesundheitszentrum gehören außerdem die Gesundheitsstation Petnjica und zeitweise geöffnete Landambulanzen. Die arbeitsmedizinische Ambulanz stellt ärztliche Atteste aus (für die Arbeitsaufnahme, Fahrer, Waffenbesitz, Seeleute u. a.), der hygienisch-epidemiologische Dienst stellt Gesundheitsbücher (sanitarne knjižice) aus.',
	description_tr = 'Kamu sağlık kuruluşu Dom zdravlja "Dr Nika Labović" Berane, Berane ve Petnjica belediyeleri için birinci basamak sağlık hizmetleri merkezidir. Burada yetişkinler, çocuklar ve kadınlar için seçilmiş hekim ekipleri çalışır; beş merkez, iki uzman polikliniği ve üç destek birimi tanı, akciğer hastalıkları ve tüberküloz, ruh sağlığı, gelişim bozukluğu olan çocuk ve gençlerin sağlık hizmetleri, iç hastalıkları, göz hastalıkları, iş sağlığı, fizik tedavi ve rehabilitasyon, evde bakım hemşireliği (patronaj), koruyucu hekimlik, hijyen, epidemiyoloji, bağışıklama ve hasta nakli alanlarını kapsar. Seçilmiş hekimlerin muayenehaneleri ve merkezlerin çoğu ana binadadır (A lameli); B lamelinde Ruh Sağlığı Merkezi, hijyen-epidemiyoloji servisi, bölgesel düzeyde bir mikrobiyoloji laboratuvarı, gelişim güçlüğü olan çocuklar merkezi, fizik tedavi ve danışma birimleri bulunur; kadınlar için seçilmiş hekimler ise Üreme Sağlığı Merkezinde çalışır. Sağlık merkezine Petnjica sağlık istasyonu ve dönemsel olarak çalışan köy sağlık birimleri de bağlıdır. İş sağlığı polikliniği sağlık raporları (işe giriş, sürücüler, silah ruhsatı, denizciler vb. için) düzenler; hijyen-epidemiyoloji servisi ise sanitasyon sağlık karnesi (sanitarne knjižice) verir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 (как у всех ДЗ)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- /radno-vrijeme-sluzbi: izabrani doktor za odrasle — I smjena 07:00–15:00, II smjena
-- 13:00–21:00; subota, nedjelja i praznik — jedan tim ID, I smjena 07:00–15:00.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "15:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "15:00"}]}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Существующие — только привязка; новые — «найти или создать» по slug.
-- position привязки к ЭТОЙ клинике обновляется (ON DUPLICATE KEY UPDATE).
-- ═══════════════════════════════════════════════════════════════

-- ── 3.1 Уже в БД — только привязка (4) ──

-- Marijana Pešić — SCHED, замена из KBC Berane; в БД — OB Berane (#137), gynecology_obstetrics
SET @d = (SELECT id FROM doctors WHERE slug = 'marijana-pesic');
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene (zamjena), specijalista ginekologije KBC Berane' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sonja Joksimović — UVJ «dr Sonja Joksimović, spec. ORL»; в БД — OB Berane (#137), otorhinolaryngology
SET @d = (SELECT id FROM doctors WHERE slug = 'sonja-joksimovic');
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Tim za ljekarska uvjerenja, spec. ORL' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Saveta Kljajić Obradović — UVJ «dr Saveta Kljajić Obradović, spec. oftalmologije»; в БД как «Saveta Obradović Kljajić» — OB Berane (#137), ophthalmology
SET @d = (SELECT id FROM doctors WHERE slug = 'saveta-obradovic-kljajic');
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Tim za ljekarska uvjerenja, spec. oftalmologije' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jasmina Novalić — UVJ «dr Jasmina Novalić, spec. oftalmologije»; в БД — OB Berane (#137), ophthalmology
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmina-novalic');
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Tim za ljekarska uvjerenja, spec. oftalmologije' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ── 3.2 Новые (31) ──

-- Gordana Čantrić — PHONES «Izabrani doktori za djecu» ord. 1 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-cantric' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-cantric', 'Gordana Čantrić', 'Гордана Чантрић', 'Гордана Чантрич', 'Gordana Cantric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'gordana-cantric' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, ordinacija 1' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Vesna Đukić — PHONES ord. 2 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-djukic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-djukic', 'Vesna Đukić', 'Весна Ђукић', 'Весна Джукич', 'Vesna Djukic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-djukic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, ordinacija 2' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Marija Joksimović — PHONES ord. 2 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-joksimovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-joksimovic', 'Marija Joksimović', 'Марија Јоксимовић', 'Мария Йоксимович', 'Marija Joksimovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-joksimovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, ordinacija 2' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Suzana Savović — PHONES ord. 3 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'suzana-savovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'suzana-savovic', 'Suzana Savović', 'Сузана Савовић', 'Сузана Савович', 'Suzana Savovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'suzana-savovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, ordinacija 3' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Ana Popović — PHONES ord. 3 + SCHED; slug ana-popovic / popovic-ana / ana-popovic-2 заняты другими врачами
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-popovic-3' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-popovic-3', 'Ana Popović', 'Ана Поповић', 'Ана Попович', 'Ana Popovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ana-popovic-3' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, ordinacija 3' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Lenka Radunović — PHONES «Izabrani doktori za odrasle» ord. 1 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'lenka-radunovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'lenka-radunovic', 'Lenka Radunović', 'Ленка Радуновић', 'Ленка Радунович', 'Lenka Radunovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'lenka-radunovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 1' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Zuhra Hadrović — PHONES ord. 1 + SCHED; подписывала прайсы 2016 как DIREKTORKA, сейчас директор — Marica Janković (/o-nama/menadzment)
SET @d = (SELECT id FROM doctors WHERE slug = 'zuhra-hadrovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zuhra-hadrovic', 'Zuhra Hadrović', 'Зухра Хадровић', 'Зухра Хадрович', 'Zuhra Hadrovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zuhra-hadrovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 1' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Biljana Ralević — PHONES ord. 2 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-ralevic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-ralevic', 'Biljana Ralević', 'Биљана Ралевић', 'Биляна Ралевич', 'Biljana Ralevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'biljana-ralevic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 2' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Saša Stefanovski — PHONES ord. 2 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'sasa-stefanovski' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sasa-stefanovski', 'Saša Stefanovski', 'Саша Стефановски', 'Саша Стефановски', 'Sasa Stefanovski', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sasa-stefanovski' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 2' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Julijana Zečević — PHONES ord. 3 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'julijana-zecevic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'julijana-zecevic', 'Julijana Zečević', 'Јулијана Зечевић', 'Юлияна Зечевич', 'Julijana Zecevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'julijana-zecevic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 3' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Marija Rakonjac — PHONES ord. 3 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-rakonjac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-rakonjac', 'Marija Rakonjac', 'Марија Ракоњац', 'Мария Раконяц', 'Marija Rakonjac', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-rakonjac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 3' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sanja Kovačević — PHONES ord. 4 + SCHED (сейчас её замещает dr Jasna Đurašković Lutovac)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-kovacevic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-kovacevic', 'Sanja Kovačević', 'Сања Ковачевић', 'Саня Ковачевич', 'Sanja Kovacevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sanja-kovacevic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 4' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Milka Miladinović — PHONES ord. 4 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'milka-miladinovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milka-miladinovic', 'Milka Miladinović', 'Милка Миладиновић', 'Милка Миладинович', 'Milka Miladinovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milka-miladinovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 4' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Radoslav Brajović — PHONES ord. 5 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'radoslav-brajovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'radoslav-brajovic', 'Radoslav Brajović', 'Радослав Брајовић', 'Радослав Брайович', 'Radoslav Brajovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'radoslav-brajovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 5' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Vesna Pantović — PHONES ord. 5 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-pantovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-pantovic', 'Vesna Pantović', 'Весна Пантовић', 'Весна Пантович', 'Vesna Pantovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-pantovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 5' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Anđela Ćorović — PHONES ord. 6 + SCHED
SET @d = (SELECT id FROM doctors WHERE slug = 'andjela-corovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andjela-corovic', 'Anđela Ćorović', 'Анђела Ћоровић', 'Анджела Чорович', 'Andjela Corovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'andjela-corovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 6' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jelena Banjac — PHONES ord. 6 + SCHED (сейчас её замещает dr Marija Bojić)
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-banjac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-banjac', 'Jelena Banjac', 'Јелена Бањац', 'Елена Баняц', 'Jelena Banjac', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-banjac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ordinacija 6' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Marija Bojić — SCHED: «dr Jelenu Banjac mijenja dr Marija Bojić»
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-bojic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-bojic', 'Marija Bojić', 'Марија Бојић', 'Мария Бойич', 'Marija Bojic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-bojic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle (zamjena), ordinacija 6' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jasna Đurašković Lutovac — SCHED: «dr Sanju Kovačević mijenja dr Jasna Đurašković Lutovac»
SET @d = (SELECT id FROM doctors WHERE slug = 'jasna-djuraskovic-lutovac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasna-djuraskovic-lutovac', 'Jasna Đurašković Lutovac', 'Јасна Ђурашковић Лутовац', 'Ясна Джурашкович Лутовац', 'Jasna Djuraskovic Lutovac', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jasna-djuraskovic-lutovac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle (zamjena), ordinacija 4' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jasmina Garčević — SCHED «Izabrani doktori u Zdravstvenoj stanici Petnjica» ord. 1
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmina-garcevic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasmina-garcevic', 'Jasmina Garčević', 'Јасмина Гарчевић', 'Ясмина Гарчевич', 'Jasmina Garcevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jasmina-garcevic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ZS Petnjica' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Srđan Škrkić — SCHED «Izabrani doktori u Zdravstvenoj stanici Petnjica» ord. 2
SET @d = (SELECT id FROM doctors WHERE slug = 'srdjan-skrkic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-skrkic', 'Srđan Škrkić', 'Срђан Шкркић', 'Срджан Шкркич', 'Srdjan Skrkic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'srdjan-skrkic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ZS Petnjica' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jovana Mihailović — PHONES «Izabrani doktori za žene» ord. 1; в SCHED написано «Mihajlović»
SET @d = (SELECT id FROM doctors WHERE slug = 'jovana-mihailovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jovana-mihajlovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jovana-mihailovic', 'Jovana Mihailović', 'Јована Михаиловић', 'Йована Михайлович', 'Jovana Mihailovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jovana-mihailovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene, ordinacija 1' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Aleksandar Grdinić — PHONES ord. 2
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandar-grdinic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-grdinic', 'Aleksandar Grdinić', 'Александар Грдинић', 'Александар Грдинич', 'Aleksandar Grdinic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'aleksandar-grdinic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene, ordinacija 2' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Vlado Dragaš — SCHED: «Dr Jovanu Mihajlović … mijenjaju specijaliste ginekologije iz KBC Berane»
SET @d = (SELECT id FROM doctors WHERE slug = 'vlado-dragas' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vlado-dragas', 'Vlado Dragaš', 'Владо Драгаш', 'Владо Драгаш', 'Vlado Dragas', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vlado-dragas' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene (zamjena), specijalista ginekologije KBC Berane' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Denis Adrović — SCHED, замена из KBC Berane
SET @d = (SELECT id FROM doctors WHERE slug = 'denis-adrovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'denis-adrovic', 'Denis Adrović', 'Денис Адровић', 'Денис Адрович', 'Denis Adrovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'denis-adrovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene (zamjena), specijalista ginekologije KBC Berane' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Damir Šabotić — SCHED, замена из KBC Berane
SET @d = (SELECT id FROM doctors WHERE slug = 'damir-sabotic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'damir-sabotic', 'Damir Šabotić', 'Дамир Шаботић', 'Дамир Шаботич', 'Damir Sabotic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'damir-sabotic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene (zamjena), specijalista ginekologije KBC Berane' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Refka Lejla Latić — UVJ «tim čijim radom koordinira dr Refka Lejla Latić, specijalista medicine rada»
SET @d = (SELECT id FROM doctors WHERE slug = 'refka-lejla-latic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'refka-lejla-latic', 'Refka Lejla Latić', 'Рефка Лејла Латић', 'Рефка Лейла Латич', 'Refka Lejla Latic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'refka-lejla-latic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'occupational_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Specijalista medicine rada, koordinatorka tima za ljekarska uvjerenja' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Fadil Kalač — UVJ «dr Fadil Kalač, spec. radiologije»
SET @d = (SELECT id FROM doctors WHERE slug = 'fadil-kalac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'fadil-kalac', 'Fadil Kalač', 'Фадил Калач', 'Фадил Калач', 'Fadil Kalac', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'fadil-kalac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'radiology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Tim za ljekarska uvjerenja, spec. radiologije' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Irena Šćekić — UVJ «dr Irena Šćekić, spec. biohemije»
SET @d = (SELECT id FROM doctors WHERE slug = 'irena-scekic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'irena-scekic', 'Irena Šćekić', 'Ирена Шћекић', 'Ирена Щекич', 'Irena Scekic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'irena-scekic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'clinical_biochemistry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Tim za ljekarska uvjerenja, spec. biohemije' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jasmin Hasić — UVJ «dr Jasmin Hasić, spec. psihijatrije»
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmin-hasic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasmin-hasic', 'Jasmin Hasić', 'Јасмин Хасић', 'Ясмин Хасич', 'Jasmin Hasic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jasmin-hasic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Tim za ljekarska uvjerenja, spec. psihijatrije' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Damir Musić — UVJ «dr Damir Musić, spec. psihijatrije»
SET @d = (SELECT id FROM doctors WHERE slug = 'damir-music' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'damir-music', 'Damir Musić', 'Дамир Мусић', 'Дамир Мусич', 'Damir Music', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'damir-music' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Tim za ljekarska uvjerenja, spec. psihijatrije' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 9, status = published, languages = 1, types = 1, hours = 1.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 35 врачей; у каждого есть специальность и язык sr.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, dc.position,
	(SELECT GROUP_CONCAT(s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
	(SELECT GROUP_CONCAT(c2.slug) FROM doctor_clinics dc2 JOIN clinics c2 ON c2.id = dc2.clinic_id WHERE dc2.doctor_id = d.id) AS clinics
FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @clinic_id
ORDER BY dc.position, d.name_sr;

-- Страховка: slug из этого файла, которых нет у клиники. Ожидается ПУСТО.
SELECT s.slug AS missing_doctor FROM (
	SELECT 'marijana-pesic' AS slug
	UNION ALL SELECT 'sonja-joksimovic' AS slug
	UNION ALL SELECT 'saveta-obradovic-kljajic' AS slug
	UNION ALL SELECT 'jasmina-novalic' AS slug
	UNION ALL SELECT 'gordana-cantric' AS slug
	UNION ALL SELECT 'vesna-djukic' AS slug
	UNION ALL SELECT 'marija-joksimovic' AS slug
	UNION ALL SELECT 'suzana-savovic' AS slug
	UNION ALL SELECT 'ana-popovic-3' AS slug
	UNION ALL SELECT 'lenka-radunovic' AS slug
	UNION ALL SELECT 'zuhra-hadrovic' AS slug
	UNION ALL SELECT 'biljana-ralevic' AS slug
	UNION ALL SELECT 'sasa-stefanovski' AS slug
	UNION ALL SELECT 'julijana-zecevic' AS slug
	UNION ALL SELECT 'marija-rakonjac' AS slug
	UNION ALL SELECT 'sanja-kovacevic' AS slug
	UNION ALL SELECT 'milka-miladinovic' AS slug
	UNION ALL SELECT 'radoslav-brajovic' AS slug
	UNION ALL SELECT 'vesna-pantovic' AS slug
	UNION ALL SELECT 'andjela-corovic' AS slug
	UNION ALL SELECT 'jelena-banjac' AS slug
	UNION ALL SELECT 'marija-bojic' AS slug
	UNION ALL SELECT 'jasna-djuraskovic-lutovac' AS slug
	UNION ALL SELECT 'jasmina-garcevic' AS slug
	UNION ALL SELECT 'srdjan-skrkic' AS slug
	UNION ALL SELECT 'jovana-mihailovic' AS slug
	UNION ALL SELECT 'aleksandar-grdinic' AS slug
	UNION ALL SELECT 'vlado-dragas' AS slug
	UNION ALL SELECT 'denis-adrovic' AS slug
	UNION ALL SELECT 'damir-sabotic' AS slug
	UNION ALL SELECT 'refka-lejla-latic' AS slug
	UNION ALL SELECT 'fadil-kalac' AS slug
	UNION ALL SELECT 'irena-scekic' AS slug
	UNION ALL SELECT 'jasmin-hasic' AS slug
	UNION ALL SELECT 'damir-music' AS slug
) s
LEFT JOIN doctors d ON d.slug = s.slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;
