-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Mušura (Budva) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-musura.sql
--
-- Источники данных:
--   * https://www.musura.me/ (naslovna, o-nama, istorijat, nas-tim, kontakt) — 2026-07-26
--   * data/google-places/budva/dental-musura.json (Google Places, place_id,
--     координаты, нормализованный адрес, телефон)
--
-- Сверка фактов:
--   * Адрес: сайт «Trg Slobode 2» + Google «Trg Slobode broj 2, Budva 85310» —
--     совпадают. Записан в сербской орфографии: «Trg slobode 2».
--   * Координаты 42.2873538 / 18.8407689 — Google Places (единственный источник,
--     попадает в центр Будвы, рядом с Trg slobode).
--   * Телефоны: три номера с сайта; Google подтверждает +382 69 025 296.
--   * Год основания: 1951 (dr Nikola Mušura, первая постоянная стоматологическая
--     ординация в Будве) — /istorijat; частная ординация «Mušura» — 1995
--     (dr Dejan Mušura) — /nas-tim + /istorijat, источники согласованы.
--
-- Требует ручной проверки (см. отчёт):
--   * logo_url не заполнен — на сайте не найден отдельный файл логотипа.
--   * photo_url для Davorka Uskoković оставлен NULL: на /nas-tim её карточка
--     ссылается на /images/portreti/Dr-Jelena.jpg (файл существует и отличается
--     от портрета Jelene, но имя файла делает атрибуцию ненадёжной).
--   * Возможные однофамильцы: скрипт переиспользует уже существующих врачей,
--     найденных по name_sr / перевёрнутому имени / slug. Проверить VERIFICATION.
--
-- Идемпотентно: повторный запуск не создаёт дублей и не перезатирает
-- непустые поля уже существующей клиники (status тоже не трогается).
-- Также самоисправляющийся — отдельный fix-скрипт не нужен ни на чистой БД, ни
-- там, где применена старая версия файла:
--   * PART 2 сносит языки RU/EN/FR, ошибочно прописанные клинике первой версией;
--   * description_* клиники и врачей пишутся БЕЗУСЛОВНЫМ UPDATE, а не внутри
--     INSERT, поэтому правки текстов доезжают до уже созданных записей.
-- Цена этого: правки описаний из админки следующий прогон файла перезатрёт —
-- вносить их сюда, а не только в БД.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ5_aQDJvUTRMREZMDTbIvs3k';
SET @clinic_slug = 'stomatoloska-ordinacija-musura';

-- Поиск существующей клиники: по google_place_id → по slug → по name_sr
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr = 'Stomatološka ordinacija Mušura' LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
-- description_* сознательно НЕ здесь: их пишет безусловный UPDATE ниже, чтобы
-- правки текстов подхватывались и на уже импортированной клинике.
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	3, -- CityId.BUDVA
	'Stomatološka ordinacija Mušura',
	'Стоматолошка ординација Мушура',
	'Стоматологическая клиника Мушура',
	'Trg slobode 2',
	'Трг слободе 2',
	'',
	'',
	'85310',
	42.28735380,
	18.84076890,
	'+38233452805;+38269025296;+38269331711',
	'info@musura.me',
	'https://www.musura.me/',
	'facebook.com/ordinacija.musura',
	'@dental_musura',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение: только пустые/NULL поля уже существующей записи.
-- Непустые значения (в т.ч. правки из админки) не трогаем. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Мушура', name_sr_cyrl),
	name_ru      = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая клиника Мушура', name_ru),
	address_sr   = IF(address_sr IS NULL OR address_sr = '', 'Trg slobode 2', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Трг слободе 2', address_sr_cyrl),
	postal_code  = IF(postal_code IS NULL OR postal_code = '', '85310', postal_code),
	latitude     = COALESCE(latitude, 42.28735380),
	longitude    = COALESCE(longitude, 18.84076890),
	phone        = IF(phone IS NULL OR phone = '', '+38233452805;+38269025296;+38269331711', phone),
	email        = IF(email IS NULL OR email = '', 'info@musura.me', email),
	website      = IF(website IS NULL OR website = '', 'https://www.musura.me/', website),
	facebook     = IF(facebook IS NULL OR facebook = '', 'facebook.com/ordinacija.musura', facebook),
	instagram    = IF(instagram IS NULL OR instagram = '', '@dental_musura', instagram)
WHERE id = @clinic_id;

-- Описания — БЕЗУСЛОВНАЯ перезапись: контент собран этим импортом, и правки
-- текста должны доезжать до уже импортированной клиники (иначе исправление
-- фактической ошибки требовало бы отдельного скрипта).
-- ⚠️ Если описание будут править в админке — сначала перенести правку сюда,
-- иначе следующий прогон файла её потеряет.
UPDATE clinics SET
	description_sr = 'Porodična stomatološka ordinacija u centru Budve, na Trgu slobode. Tradicija porodice Mušura počinje 1951. godine, kada je zubar Nikola Mušura osnovao stomatološku ambulantu u Budvi; privatnu ordinaciju osnovao je 1995. godine dr stom. Dejan Mušura, a danas u njoj radi treća generacija. Ordinacija obavlja oralnu hirurgiju, implantologiju, protetiku (bezmetalne cirkonske i metalo-keramičke krunice, mostove, fasete i proteze), liječenje karijesa i kanala korijena, uklanjanje kamenca, izbjeljivanje zuba, ortodonciju (mobilni i fiksni aparati, samoligirajuće bravice i providne folije) i dječju stomatologiju. Digitalna dijagnostika radi se ortopan aparatom Owandy i RVG senzorom.',
	description_sr_cyrl = 'Породична стоматолошка ординација у центру Будве, на Тргу слободе. Традиција породице Мушура почиње 1951. године, када је зубар Никола Мушура основао стоматолошку амбуланту у Будви; приватну ординацију основао је 1995. године др стом. Дејан Мушура, а данас у њој ради трећа генерација. Ординација обавља оралну хирургију, имплантологију, протетику (безметалне цирконске и метало-керамичке крунице, мостове, фасете и протезе), лијечење каријеса и канала коријена, уклањање каменца, избјељивање зуба, ортодонцију (мобилни и фиксни апарати, самолигирајуће бравице и провидне фолије) и дјечју стоматологију. Дигитална дијагностика ради се ортопан апаратом Owandy и RVG сензором.',
	description_ru = 'Семейная стоматологическая клиника в центре Будвы, на площади Трг слободе. Традиция семьи Мушура началась в 1951 году, когда зубной врач Никола Мушура открыл первый стоматологический кабинет в Будве; частную клинику в 1995 году основал доктор Деян Мушура, сегодня в ней работает третье поколение. Клиника занимается оральной хирургией, имплантологией, протезированием (безметалловые циркониевые и металлокерамические коронки, мосты, виниры и протезы), лечением кариеса и корневых каналов, удалением зубного камня, отбеливанием зубов, ортодонтией (съёмные и несъёмные аппараты, самолигирующие брекеты и прозрачные элайнеры) и детской стоматологией. Цифровая диагностика выполняется ортопантомографом Owandy и RVG-сенсором.',
	description_en = 'A family dental practice in the centre of Budva, on Trg slobode square. The Mušura family tradition began in 1951, when the dentist Nikola Mušura opened the first dental surgery in Budva; the private practice was founded in 1995 by Dr Dejan Mušura and is now run by the third generation. The practice covers oral surgery, implantology, prosthodontics (metal-free zirconia and metal-ceramic crowns, bridges, veneers and dentures), caries and root canal treatment, scaling, teeth whitening, orthodontics (removable and fixed appliances, self-ligating brackets and clear aligners) and paediatric dentistry. Digital imaging is performed with an Owandy panoramic unit and an RVG sensor.',
	description_de = 'Eine familiengeführte Zahnarztpraxis im Zentrum von Budva am Platz Trg slobode. Die Tradition der Familie Mušura beginnt 1951, als der Zahnarzt Nikola Mušura die erste Zahnarztpraxis in Budva eröffnete; die Privatpraxis wurde 1995 von Dr. Dejan Mušura gegründet und wird heute in dritter Generation geführt. Das Leistungsspektrum umfasst Oralchirurgie, Implantologie, Prothetik (vollkeramische Zirkon- und Metallkeramikkronen, Brücken, Veneers und Prothesen), Karies- und Wurzelkanalbehandlung, Zahnsteinentfernung, Zahnaufhellung, Kieferorthopädie (herausnehmbare und feste Apparaturen, selbstligierende Brackets und transparente Schienen) sowie Kinderzahnheilkunde. Die digitale Diagnostik erfolgt mit einem Owandy-Panoramagerät und einem RVG-Sensor.',
	description_tr = 'Budva''nın merkezinde, Trg slobode meydanında bulunan bir aile diş kliniği. Mušura ailesinin geleneği, diş hekimi Nikola Mušura''nın Budva''daki ilk diş muayenehanesini açtığı 1951 yılında başlar; özel muayenehane 1995 yılında Dr. Dejan Mušura tarafından kurulmuş olup bugün üçüncü kuşak tarafından yürütülmektedir. Klinikte ağız cerrahisi, implantoloji, protez (metal desteksiz zirkonyum ve metal seramik kronlar, köprüler, lamina ve protezler), çürük ve kanal tedavisi, diş taşı temizliği, diş beyazlatma, ortodonti (hareketli ve sabit apareyler, kendinden bağlamalı braketler ve şeffaf plaklar) ve çocuk diş hekimliği hizmetleri sunulmaktadır. Dijital görüntüleme Owandy panoramik cihaz ve RVG sensörü ile yapılmaktadır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES & LANGUAGES
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages — это языки СОПРОВОЖДЕНИЯ клиники, а не сумма языков её
-- врачей. Клиники заявляют их отдельно и явно; musura.me об этом не пишет
-- ничего → только сербский (LanguageId.SR = 1).
-- Языки Jelene (ru/en) и Davorke (en/fr) живут в doctor_languages, см. PART 3.
--
-- ⚠️ `clinic_languages` — ЕДИНСТВЕННАЯ junction-таблица схемы без составного
-- UNIQUE (проверено по information_schema: только PRIMARY(id); у
-- clinic_clinic_types, doctor_specialties, doctor_languages, doctor_clinics,
-- clinic_medical_services составные уникальные ключи есть). Поэтому
-- `INSERT IGNORE` здесь НЕ дедуплицирует и каждый прогон файла добавлял новую
-- строку — на локальной БД накопилось три (142, 1).
-- Отсюда полная синхронизация вместо INSERT IGNORE: снести всё лишнее,
-- оставить один экземпляр SR, вставить только если его нет вообще.
--
-- Заодно это исправляет ПЕРВУЮ версию файла, которая ошибочно прописывала
-- клинике RU=2 / EN=3 / FR=9, сложив языки из био врачей.
-- Побочный эффект: если клиника РЕАЛЬНО заявит сопровождение на других языках
-- и его добавят в админке — повторный прогон снесёт. Тогда правки вносить сюда.
SET @keep_lang_id = (
	SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND (language_id <> 1 OR id <> @keep_lang_id);

INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (
	SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

-- Рабочее время (clinic_working_hours) НЕ заполняем: ни сайт, ни Google Places
-- не публикуют radno vrijeme. Добавить вручную после уточнения у клиники.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Специальности: 78 = DENTISTRY, 87 = PEDIATRIC_DENTISTRY,
--                74 = ORAL_SURGERY, 93 = ORTHODONTIST
-- Языки: 1 = SR, 2 = RU, 3 = EN, 9 = FR
--
-- Схема на каждого врача: find-or-create (без description_*) → безусловный
-- UPDATE описаний. Так правка био доезжает и до уже импортированного врача:
-- `INSERT ... WHERE @doctor_id IS NULL` для существующей записи не срабатывает.
-- ⚠️ Те же оговорки, что и для описания клиники: правки из админки следующий
-- прогон файла перезатрёт, вносить их сюда.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr stom. Dejan Mušura — spec. dječje i preventivne stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dejan Mušura' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mušura Dejan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dejan-musura' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-musura', 'Dejan Mušura', 'Дејан Мушура', 'Деян Мушура', 'Dejan Musura', 'Dr stom.',
	'https://www.musura.me/images/portreti/1-1/Dr-Dejan.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
SET @doc_dejan = @doctor_id;

UPDATE doctors SET
	description_sr = 'Rođen 1958. u Budvi. Diplomirao je na Stomatološkom fakultetu Univerziteta u Beogradu, a specijalizaciju iz dječje i preventivne stomatologije stekao je 1991. godine. Nakon diplomiranja, od 1983. godine, radi u Budvi, gdje je bio načelnik stomatološke službe Doma zdravlja. Privatnu ordinaciju osnovao je 1995. godine i učestvovao je na osnivačkoj skupštini Stomatološke komore Crne Gore.',
	description_sr_cyrl = 'Рођен 1958. у Будви. Дипломирао је на Стоматолошком факултету Универзитета у Београду, а специјализацију из дјечје и превентивне стоматологије стекао је 1991. године. Након дипломирања, од 1983. године, ради у Будви, гдје је био начелник стоматолошке службе Дома здравља. Приватну ординацију основао је 1995. године и учествовао је на оснивачкој скупштини Стоматолошке коморе Црне Горе.',
	description_ru = 'Родился в 1958 году в Будве. Окончил стоматологический факультет Белградского университета, в 1991 году получил специализацию по детской и профилактической стоматологии. После окончания учёбы, с 1983 года, работает в Будве, где возглавлял стоматологическую службу Дома здоровья. В 1995 году основал частную клинику и участвовал в учредительном собрании Стоматологической палаты Черногории.',
	description_en = 'Born in 1958 in Budva. He graduated from the School of Dental Medicine of the University of Belgrade and obtained his specialisation in paediatric and preventive dentistry in 1991. He has practised in Budva since 1983, where he headed the dental service of the local health centre. He founded the private practice in 1995 and took part in the founding assembly of the Dental Chamber of Montenegro.',
	description_de = '1958 in Budva geboren. Er studierte Zahnmedizin an der Universität Belgrad und erwarb 1991 seine Fachanerkennung in Kinder- und Präventivzahnheilkunde. Seit 1983 praktiziert er in Budva, wo er den zahnärztlichen Dienst des Gesundheitszentrums leitete. 1995 gründete er die Privatpraxis und nahm an der Gründungsversammlung der Zahnärztekammer Montenegros teil.',
	description_tr = '1958 yılında Budva doğumlu. Belgrad Üniversitesi Diş Hekimliği Fakültesinden mezun oldu ve 1991 yılında çocuk ve koruyucu diş hekimliği uzmanlığını aldı. 1983 yılından bu yana Budva''da çalışmakta olup burada Sağlık Merkezinin diş hekimliği biriminin başhekimliğini yaptı. Özel muayenehanesini 1995 yılında kurdu ve Karadağ Diş Hekimleri Odasının kuruluş kurultayına katıldı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 87);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Osnivač ordinacije');

-- ───────────────────────────────────────────────────────────────
-- Dr stom. Nikoleta Mušura Vujović — spec. oralne hirurgije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nikoleta Mušura Vujović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mušura Vujović Nikoleta' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nikoleta-musura-vujovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikoleta-musura-vujovic', 'Nikoleta Mušura Vujović', 'Николета Мушура Вујовић', 'Николета Мушура Вуйович', 'Nikoleta Musura Vujovic', 'Dr stom.',
	'https://www.musura.me/images/portreti/1-1/Dr-Nikoleta.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
SET @doc_nikoleta = @doctor_id;

UPDATE doctors SET
	description_sr = 'Rođena 1988. u Budvi. Diplomirala je 2011. godine, u prvoj generaciji studenata Medicinskog fakulteta Univerziteta Crne Gore. Specijalizaciju iz oralne hirurgije završila je 2017. godine na Stomatološkom fakultetu Univerziteta u Beogradu. Posjeduje i diplomu za aplikaciju hijaluronskih filera.',
	description_sr_cyrl = 'Рођена 1988. у Будви. Дипломирала је 2011. године, у првој генерацији студената Медицинског факултета Универзитета Црне Горе. Специјализацију из оралне хирургије завршила је 2017. године на Стоматолошком факултету Универзитета у Београду. Посједује и диплому за апликацију хијалуронских филера.',
	description_ru = 'Родилась в 1988 году в Будве. Окончила обучение в 2011 году в первом выпуске Медицинского факультета Университета Черногории. В 2017 году завершила специализацию по оральной хирургии на стоматологическом факультете Белградского университета. Имеет диплом по применению гиалуроновых филлеров.',
	description_en = 'Born in 1988 in Budva. She graduated in 2011 as part of the first cohort of the Faculty of Medicine of the University of Montenegro. In 2017 she completed her specialisation in oral surgery at the School of Dental Medicine of the University of Belgrade. She also holds a diploma in the application of hyaluronic acid fillers.',
	description_de = '1988 in Budva geboren. Sie schloss ihr Studium 2011 im ersten Jahrgang der Medizinischen Fakultät der Universität Montenegro ab. 2017 absolvierte sie ihre Fachausbildung in Oralchirurgie an der Zahnmedizinischen Fakultät der Universität Belgrad. Zudem verfügt sie über ein Diplom für die Anwendung von Hyaluronsäure-Fillern.',
	description_tr = '1988 yılında Budva doğumlu. Karadağ Üniversitesi Tıp Fakültesinin ilk mezun kuşağı içinde 2011 yılında mezun oldu. 2017 yılında Belgrad Üniversitesi Diş Hekimliği Fakültesinde ağız cerrahisi uzmanlığını tamamladı. Ayrıca hyaluronik dolgu uygulaması diplomasına sahiptir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Dr stom. Dragana Bjelica
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dragana Bjelica' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bjelica Dragana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dragana-bjelica' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-bjelica', 'Dragana Bjelica', 'Драгана Бјелица', 'Драгана Бьелица', 'Dragana Bjelica', 'Dr stom.',
	'https://www.musura.me/images/portreti/1-1/Dr-Dragana.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
SET @doc_dragana = @doctor_id;

UPDATE doctors SET
	description_sr = 'Rođena 1961. u Kruševcu. Diplomirala je na Stomatološkom fakultetu u Beogradu. Radno iskustvo sticala je u Srbiji i Južnoj Africi, a od 1999. godine živi i radi u Budvi.',
	description_sr_cyrl = 'Рођена 1961. у Крушевцу. Дипломирала је на Стоматолошком факултету у Београду. Радно искуство стицала је у Србији и Јужној Африци, а од 1999. године живи и ради у Будви.',
	description_ru = 'Родилась в 1961 году в Крушевце. Окончила стоматологический факультет в Белграде. Профессиональный опыт получила в Сербии и Южной Африке, с 1999 года живёт и работает в Будве.',
	description_en = 'Born in 1961 in Kruševac. She graduated from the School of Dental Medicine in Belgrade. She gained professional experience in Serbia and South Africa and has lived and worked in Budva since 1999.',
	description_de = '1961 in Kruševac geboren. Sie studierte Zahnmedizin in Belgrad. Berufserfahrung sammelte sie in Serbien und Südafrika; seit 1999 lebt und arbeitet sie in Budva.',
	description_tr = '1961 yılında Kruševac doğumlu. Belgrad Diş Hekimliği Fakültesinden mezun oldu. Mesleki deneyimini Sırbistan ve Güney Afrika''da kazandı ve 1999 yılından bu yana Budva''da yaşayıp çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Dr stom. Jelena Potpara (endodoncija; engleski, ruski)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jelena Potpara' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Potpara Jelena' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jelena-potpara' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-potpara', 'Jelena Potpara', 'Јелена Потпара', 'Елена Потпара', 'Jelena Potpara', 'Dr stom.',
	'https://www.musura.me/images/portreti/1-1/Dr-Jelena.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
SET @doc_jelena = @doctor_id;

UPDATE doctors SET
	description_sr = 'Rođena 1983. u Pljevljima. Diplomirala je 2010. godine na Stomatološkom fakultetu u Beogradu s prosječnom ocjenom 9,2. Završila je jednogodišnje specijalističke akademske studije iz endodoncije. Aktivno govori engleski i ruski jezik.',
	description_sr_cyrl = 'Рођена 1983. у Пљевљима. Дипломирала је 2010. године на Стоматолошком факултету у Београду с просјечном оцјеном 9,2. Завршила је једногодишње специјалистичке академске студије из ендодонције. Активно говори енглески и руски језик.',
	description_ru = 'Родилась в 1983 году в Плевле. В 2010 году окончила стоматологический факультет в Белграде со средним баллом 9,2. Прошла годичные специализированные академические курсы по эндодонтии. Свободно говорит на английском и русском языках.',
	description_en = 'Born in 1983 in Pljevlja. She graduated from the School of Dental Medicine in Belgrade in 2010 with a grade point average of 9.2. She completed a one-year specialist academic programme in endodontics. She speaks English and Russian fluently.',
	description_de = '1983 in Pljevlja geboren. Sie schloss ihr Studium 2010 an der Zahnmedizinischen Fakultät in Belgrad mit einem Notendurchschnitt von 9,2 ab. Sie absolvierte ein einjähriges Aufbaustudium in Endodontie. Sie spricht Englisch und Russisch.',
	description_tr = '1983 yılında Pljevlja doğumlu. 2010 yılında Belgrad Diş Hekimliği Fakültesini 9,2 not ortalaması ile bitirdi. Endodonti alanında bir yıllık uzmanlık akademik programını tamamladı. İngilizce ve Rusça bilmektedir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 2), (@doctor_id, 3);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Dr stom. Davorka Uskoković — spec. ortodoncije (engleski, francuski)
-- photo_url NULL: см. шапку файла (ссылка на сайте ведёт на Dr-Jelena.jpg)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Davorka Uskoković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Uskoković Davorka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'davorka-uskokovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'davorka-uskokovic', 'Davorka Uskoković', 'Даворка Ускоковић', 'Даворка Ускокович', 'Davorka Uskokovic', 'Dr stom.',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
SET @doc_davorka = @doctor_id;

UPDATE doctors SET
	description_sr = 'Rođena 1966. u Kotoru. Stomatološki fakultet u Beogradu završila je s prosječnom ocjenom 9, a specijalizaciju je s odličnom ocjenom završila na Klinici za ortopediju vilica. Osmogodišnje iskustvo u radu s pacijentima sticala je uz prim. dr Milorada Todorovića, jednog od prvih ortodonata na ovim prostorima. Pohađala je brojne inostrane kurseve iz oblasti ortodoncije. Aktivno govori engleski i francuski jezik.',
	description_sr_cyrl = 'Рођена 1966. у Котору. Стоматолошки факултет у Београду завршила је с просјечном оцјеном 9, а специјализацију је с одличном оцјеном завршила на Клиници за ортопедију вилица. Осмогодишње искуство у раду с пацијентима стицала је уз прим. др Милорада Тодоровића, једног од првих ортодоната на овим просторима. Похађала је бројне иностране курсеве из области ортодонције. Активно говори енглески и француски језик.',
	description_ru = 'Родилась в 1966 году в Которе. Окончила стоматологический факультет в Белграде со средним баллом 9, специализацию с отличием прошла в Клинике ортопедии челюстей (ортодонтии). Восьмилетний опыт работы с пациентами получила рядом с прим. др Милорадом Тодоровичем, одним из первых ортодонтов в этих краях. Прошла множество зарубежных курсов по ортодонтии. Свободно говорит на английском и французском языках.',
	description_en = 'Born in 1966 in Kotor. She graduated from the School of Dental Medicine in Belgrade with a grade point average of 9 and completed her specialisation with excellent marks at the Clinic for Orthodontics (Klinika za ortopediju vilica). She gained eight years of clinical experience working alongside prim. dr Milorad Todorović, one of the region''s first orthodontists. She has attended numerous international courses in orthodontics. She speaks English and French fluently.',
	description_de = '1966 in Kotor geboren. Sie schloss ihr Zahnmedizinstudium in Belgrad mit einem Notendurchschnitt von 9 ab und absolvierte ihre Fachausbildung mit Auszeichnung an der Klinik für Kieferorthopädie. Achtjährige klinische Erfahrung sammelte sie an der Seite von prim. dr Milorad Todorović, einem der ersten Kieferorthopäden dieser Region. Sie hat zahlreiche internationale Kurse im Bereich der Kieferorthopädie besucht. Sie spricht Englisch und Französisch.',
	description_tr = '1966 yılında Kotor doğumlu. Belgrad Diş Hekimliği Fakültesini 9 not ortalaması ile bitirdi ve uzmanlığını Çene Ortopedisi (Ortodonti) Kliniğinde pekiyi derece ile tamamladı. Sekiz yıllık klinik deneyimini, bu bölgenin ilk ortodontistlerinden prim. dr Milorad Todorović ile birlikte çalışarak kazandı. Ortodonti alanında çok sayıda uluslararası kursa katıldı. İngilizce ve Fransızca bilmektedir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 3), (@doctor_id, 9);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Dr stom. Nikola Mušura — четвёртая генерация
--
-- ⚠️ Этого врача НЕТ на /nas-tim: страница отстала от жизни. На /istorijat он
-- ещё «Sin doktora Dejana, Nikola, student je Stomatološkog fakulteta u
-- Podgorici», а отзывы 2025-2026 уже называют его практикующим врачом:
--   «Veliko hvala doktoru Nikoli koji je resio svojom predanoscu i znanjem
--    ono sto niz stomatoloskih ordinacija nije uspelo»
--   «Posebne pohvale za mladog dr Nikolu»
-- Мужской род подтверждён согласованием (koji/resio/mladog) и отзывами
-- «Ljubazni doktori, sin i otac» / «his son, grandson and granddaughter work
-- here» — это НЕ сокращение имени Nikoleta (падежи Nikoli/Nikolu от Nikola,
-- у Nikoleta были бы Nikoleti/Nikoletu).
--
-- Запись минимальная, заведена чтобы к ней можно было привязать отзывы:
--   * professional_title 'Dr stom.' — из отзывов пациентов, сайт его так не
--     называет; специализация нигде не заявлена → только DENTISTRY (78).
--   * фото нет; в био только то, что подтверждено /istorijat дословно —
--     факт получения диплома сайтом НЕ подтверждён, поэтому не утверждается.
-- Обновить, когда клиника обновит /nas-tim.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nikola Mušura' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mušura Nikola' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nikola-musura' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-musura', 'Nikola Mušura', 'Никола Мушура', 'Никола Мушура', 'Nikola Musura', 'Dr stom.',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
SET @doc_nikola = @doctor_id;

UPDATE doctors SET
	description_sr = 'Četvrta generacija stomatološke tradicije porodice Mušura — sin dr stom. Dejana Mušure, a imenom nasljednik dr Nikole Mušure koji je 1951. godine osnovao prvu stomatološku ambulantu u Budvi. Stomatologiju je studirao na Stomatološkom fakultetu u Podgorici.',
	description_sr_cyrl = 'Четврта генерација стоматолошке традиције породице Мушура — син др стом. Дејана Мушуре, а именом насљедник др Николе Мушуре који је 1951. године основао прву стоматолошку амбуланту у Будви. Стоматологију је студирао на Стоматолошком факултету у Подгорици.',
	description_ru = 'Четвёртое поколение стоматологической традиции семьи Мушура — сын др стом. Деяна Мушуры, названный в честь Николы Мушуры, который в 1951 году открыл первый стоматологический кабинет в Будве. Изучал стоматологию на стоматологическом факультете в Подгорице.',
	description_en = 'The fourth generation of the Mušura family''s dental tradition — son of dr stom. Dejan Mušura, and named after Nikola Mušura, who opened the first dental surgery in Budva in 1951. He studied dentistry at the School of Dental Medicine in Podgorica.',
	description_de = 'Die vierte Generation der zahnmedizinischen Tradition der Familie Mušura — Sohn von dr stom. Dejan Mušura und Namensträger von Nikola Mušura, der 1951 die erste Zahnarztpraxis in Budva eröffnete. Er studierte Zahnmedizin an der Zahnmedizinischen Fakultät in Podgorica.',
	description_tr = 'Mušura ailesinin diş hekimliği geleneğinin dördüncü kuşağı — dr stom. Dejan Mušura''nın oğlu ve 1951 yılında Budva''daki ilk diş muayenehanesini açan Nikola Mušura''nın adaşı. Diş hekimliğini Podgorica Diş Hekimliği Fakültesinde okudu.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- Стоматологические ассистенты (Andrijana Mrdović, Nada Pavićević,
-- Mirjana Vidojević) НЕ добавляются — таблица doctors только для врачей.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 3, status = published, clinic_languages = '1' (только SR)
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, d.professional_title,
	GROUP_CONCAT(DISTINCT s.name ORDER BY s.name) AS specialties,
	GROUP_CONCAT(DISTINCT l.code ORDER BY l.code) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN specialties s ON s.id = ds.specialty_id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
LEFT JOIN languages l ON l.id = dl.language_id
GROUP BY d.id
ORDER BY d.name_sr;

-- Проверка на переиспользование чужих однофамильцев: если created_at сильно
-- старше даты запуска — врач уже существовал в БД, убедиться, что это тот же человек.
