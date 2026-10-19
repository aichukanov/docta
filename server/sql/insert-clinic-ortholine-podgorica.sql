-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Ortholine (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ortholine-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/ortholine-podgorica.json):
--   * https://ortholine.me/ — WordPress (The7) + WPML (me/en/ru). Тот же сайт отдаётся и по https://stomatologpodgorica.me/
--     (одинаковый текст, отличается только <title>); основной — ortholine.me (на него ведёт место Google).
--     WP REST /wp-json/wp/v2/pages: 29 страниц, все услуги и «O nama» — modified 2020-04-13…15, Kontakt — 2023-02-09.
--     ⚠️ Состав и перечень — 2020, могли устареть. /oralna-hirurgija — «Stranica je u izradi» (перечень хирургии взят из /usluge).
--   * data/google-places/podgorica/stomatoloska-ordinacija-ortholine.json — place_id, координаты, телефон.
-- Адрес: сайт «Atinska 21, Podgorica» = Google «21 Atinska». Телефоны — /kontakt и футер; +382 69 021 203 = Google.
-- Instagram в футере — ссылка «#» (пустая), не заносим. Часы работы на сайте не указаны.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ4XH3VlLrTRMRIsNalxWsYSE';
SET @clinic_slug = 'ortholine-podgorica';

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
	1, -- CityId.PODGORICA
	'Stomatološka ordinacija Ortholine',
	'Стоматолошка ординација Ortholine',
	'Стоматологический кабинет Ortholine',
	'Atinska 21',
	'Атинска 21',
	'',
	'',
	'81000',
	42.44441330,
	19.27374540,
	'+38269819888;+38269021203;+38220655535',
	'ortholine@t-com.me',
	'https://ortholine.me/',
	'facebook.com/ortholine.podgorica',
	'',
	'',
	'',
	'',
	'https://ortholine.me/wp-content/uploads/2020/04/ortholine-newlogo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Ortholine', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Ortholine', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Atinska 21', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Атинска 21', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269819888;+38269021203;+38220655535', phone),
	email = IF(email IS NULL OR email = '', 'ortholine@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://ortholine.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/ortholine.podgorica', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://ortholine.me/wp-content/uploads/2020/04/ortholine-newlogo.png', logo_url),
	latitude = COALESCE(latitude, 42.44441330),
	longitude = COALESCE(longitude, 19.27374540)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Ortholine“ nalazi se u Podgorici, u Atinskoj ulici 21, i osnovana je 2004. godine. U timu su specijalista ortopedije vilica i dva opšta stomatologa, uz stručni tim konsultanata; članovi su Ljekarske komore Crne Gore. Ordinacija pruža usluge dječje i preventivne, konzervativne i estetske stomatologije (fasete, uključujući Componeer, keramički inleji, izbjeljivanje zuba Opalescence i Zoom), protetike, oralne hirurgije, implantologije, parodontologije i korekcije gummy smile, ortodoncije — mobilni aparati, uključujući Inman aparat, i fiksni aparati: metalni, estetski (keramika, safir), samoligirajući Damon i lingvalni Incognito — kao i hijaluronske filere. Opremljena je digitalnim ortopanom, RVG senzorom i intraoralnom kamerom. Ordinacija sarađuje sa Lovćen osiguranjem, Hipotekarnom bankom, NLB bankom i drugim institucijama i pruža usluge njihovim osiguranicima.',
	description_sr_cyrl = 'Стоматолошка ординација „Ortholine“ налази се у Подгорици, у Атинској улици 21, и основана је 2004. године. У тиму су специјалиста ортопедије вилица и два општа стоматолога, уз стручни тим консултаната; чланови су Љекарске коморе Црне Горе. Ординација пружа услуге дјечје и превентивне, конзервативне и естетске стоматологије (фасете, укључујући Componeer, керамички инлеји, избјељивање зуба Opalescence и Zoom), протетике, оралне хирургије, имплантологије, пародонтологије и корекције gummy smile, ортодонције — мобилни апарати, укључујући Inman апарат, и фиксни апарати: метални, естетски (керамика, сафир), самолигирајући Damon и лингвални Incognito — као и хијалуронске филере. Опремљена је дигиталним ортопаном, RVG сензором и интраоралном камером. Ординација сарађује са Ловћен осигурањем, Хипотекарном банком, NLB банком и другим институцијама и пружа услуге њиховим осигураницима.',
	description_ru = 'Стоматологический кабинет «Ortholine» находится в Подгорице, на улице Атинска, 21, и основан в 2004 году. В команде — специалист по ортодонтии и два стоматолога общей практики, а также консультанты; врачи — члены Врачебной палаты Черногории. Кабинет оказывает услуги детской и профилактической, терапевтической и эстетической стоматологии (виниры, в том числе Componeer, керамические вкладки, отбеливание Opalescence и Zoom), протезирования, хирургической стоматологии, имплантологии, пародонтологии и коррекции «десневой улыбки», ортодонтии — съёмные аппараты, включая аппарат Inman, и брекет-системы: металлические, эстетические (керамика, сапфир), самолигирующие Damon и лингвальные Incognito, — а также контурную пластику гиалуроновыми филлерами. Кабинет оснащён цифровым ортопантомографом, радиовизиографом (RVG) и интраоральной камерой. Сотрудничает с Lovćen osiguranje, Hipotekarna banka, NLB banka и другими организациями и обслуживает их застрахованных.',
	description_en = 'Ortholine is a dental practice in Podgorica, at Atinska 21, founded in 2004. The team includes an orthodontics specialist and two general dentists, supported by consultants; its members belong to the Medical Chamber of Montenegro. Services include paediatric and preventive, restorative and cosmetic dentistry (veneers including Componeer, ceramic inlays, Opalescence and Zoom whitening), prosthodontics, oral surgery, implantology, periodontology and gummy smile correction, orthodontics — removable appliances including the Inman Aligner, and fixed braces: metal, aesthetic (ceramic, sapphire), Damon self-ligating and Incognito lingual — as well as hyaluronic fillers. The practice is equipped with a digital panoramic X-ray unit, an RVG sensor and an intraoral camera. It works with Lovćen osiguranje, Hipotekarna banka, NLB banka and other institutions and treats their insured clients.',
	description_de = 'Ortholine ist eine Zahnarztpraxis in Podgorica, Atinska 21, gegründet 2004. Zum Team gehören eine Fachärztin für Kieferorthopädie und zwei Zahnärzte für allgemeine Zahnheilkunde sowie beratende Fachleute; die Ärzte sind Mitglieder der Ärztekammer Montenegros. Angeboten werden Kinder- und Präventivzahnheilkunde, konservierende und ästhetische Zahnheilkunde (Veneers einschließlich Componeer, Keramik-Inlays, Bleaching mit Opalescence und Zoom), Prothetik, Oralchirurgie, Implantologie, Parodontologie und Gummy-Smile-Korrektur, Kieferorthopädie – herausnehmbare Apparaturen einschließlich Inman Aligner sowie festsitzende Brackets: Metall, ästhetisch (Keramik, Saphir), selbstligierend Damon und lingual Incognito – sowie Hyaluronfiller. Die Praxis verfügt über ein digitales Panoramaröntgengerät, einen RVG-Sensor und eine Intraoralkamera. Sie arbeitet mit Lovćen osiguranje, Hipotekarna banka, NLB banka und weiteren Institutionen zusammen und behandelt deren Versicherte.',
	description_tr = 'Ortholine, Podgorica''da Atinska 21 adresinde bulunan ve 2004''te kurulan bir diş muayenehanesidir. Ekipte bir ortodonti uzmanı ile iki genel diş hekimi ve danışmanlar yer alır; hekimler Karadağ Tabipler Odası üyesidir. Çocuk ve koruyucu diş hekimliği, restoratif ve estetik diş hekimliği (Componeer dahil lamina, seramik inley, Opalescence ve Zoom ile beyazlatma), protez, ağız cerrahisi, implantoloji, periodontoloji ve diş eti gülüşü düzeltme, ortodonti — Inman apareyi dahil hareketli apareyler ile metal, estetik (seramik, safir), Damon kendinden bağlamalı ve Incognito lingual braketler — ve hiyalüronik dolgular sunulur. Muayenehanede dijital panoramik röntgen, RVG sensörü ve ağız içi kamera bulunur. Lovćen osiguranje, Hipotekarna banka, NLB banka ve diğer kurumlarla çalışır ve onların sigortalılarına hizmet verir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (en/ru версии сайта и отзыв турецкого посла на английском — не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: на сайте не указаны — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3)
-- Состав — /o-nama (2020-04-13), блок «Naš tim»: 3 доктора; Katarina Žunjić и Danijela Lalović — «Medicinska sestra», не заводятся.
-- В БД никого из троих нет (поиск 2026-10-09: есть другие Babić/Kovačević/Ivona, не они). Био на сайте нет.
-- Специальности: 78 = DENTISTRY, 93 = ORTHODONTIST. Язык 1 = SR. Фото — /wp-content/uploads/2020/04/<имя>.jpg.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Dubravka Babić — Specijalista ortopedije vilica
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dubravka Babić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Babić Dubravka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dubravka-babic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'dubravka-babic', 'Dubravka Babić', 'Дубравка Бабић', 'Дубравка Бабич', 'Dubravka Babic', 'dr',
	'https://ortholine.me/wp-content/uploads/2020/04/dubravka_babic.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Vladan Kovačević — Opšti stomatolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vladan Kovačević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kovačević Vladan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vladan-kovacevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'vladan-kovacevic', 'Vladan Kovačević', 'Владан Ковачевић', 'Владан Ковачевич', 'Vladan Kovacevic', 'dr',
	'https://ortholine.me/wp-content/uploads/2020/04/vladan_kovacevic.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Opšti stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Ivona Gnječ — Opšti stomatolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivona Gnječ' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Gnječ Ivona' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivona-gnjec' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'ivona-gnjec', 'Ivona Gnječ', 'Ивона Гњеч', 'Ивона Гнеч', 'Ivona Gnjec', 'dr',
	'https://ortholine.me/wp-content/uploads/2020/04/ivona_gnjec.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Opšti stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3 врач(а/ей): dubravka-babic, vladan-kovacevic, ivona-gnjec.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	IF(d.description_sr IS NULL OR d.description_sr = '', 'NO BIO', 'ok') AS bio,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;
