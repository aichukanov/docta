-- ═══════════════════════════════════════════════════════════════════════════
-- Llolla Dent (Ульцинь) — новая клиника: частная стоматология, 2 врача.
--
-- Источники (сверено curl'ом 2026-10-08, запись импорта —
-- data/clinic-imports/llolla-dent-ulcinj.json):
--   * data/google-places/ulcinj/llolla-dent.json — place_id, координаты,
--     телефон +382 69 522 029, адрес «bb Кодра, Улцињ 85360»;
--   * карточка клиники на stomatologija.me — адрес Kodre bb, оба телефона,
--     email, часы «Ponedeljak – Četvrtak: 08-16h; Petak, Subota, Nedelja:
--     Neradni», услуги, «Ordiniraju: dr Rešid Lolović, dr Miradin Lolović»;
--   * интервью stomatologija.me с dr Miradin Lolović (2016-06-20 — «moj otac
--     započeo taj biznis još 1981»; 2025-11-17 — UCAM Murcia, Brazil,
--     immediate loading, intraoralni/3D skener) — био врача и описание;
--   * registarfirmi.me — те же адрес/телефоны, Viber и WhatsApp на 069.
--   ⚠️ stomatologija.me / ordinacije.me — агрегаторы-конкуренты: данные с них
--   берём, ССЫЛКИ на них никуда не пишем (website пуст, своего сайта нет).
--
-- ЧЕГО ЗДЕСЬ НЕТ И ПОЧЕМУ:
--   * website — у клиники нет сайта; Google Places даёт ссылку на агрегатор.
--   * facebook — facebook.com/llolla.dental назвал поиск агента, но ни curl
--     (400), ни поиск это не подтвердили.
--   * Договор с ФЗО («privatno javno partnerstvo sa Fondom») — только в
--     старом тексте ordinacije.me рядом с устаревшими часами; не заявляем.
--   * Фото врачей — на портале снимки с подписью «Foto: stomatologija.me».
--   * Отзывы Google — в JSON 5 из 11, полный сбор отдельно.
--   * Специальность «протетика» — такой в enum нет, у Miradin только
--     DENTISTRY, протетика и имплантология — в описании.
--
-- Идемпотентно: клиника ищется по google_place_id → slug, врачи по
-- name_sr / перевёрнутому имени / slug; непустые поля существующих записей
-- не перезатираются, описания пишутся безусловным UPDATE (правки — сюда).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJSXExDCITThMRP9seBhnncR8';
SET @clinic_slug = 'llolla-dent-ulcinj';

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
	5, -- CityId.ULCINJ
	'Stomatološka ordinacija Llolla Dent',
	'Стоматолошка ординација Llolla Dent',
	'Стоматологическая клиника Llolla Dent',
	'Kodre bb',
	'Кодре бб',
	'',
	'',
	'85360',
	41.93043320,
	19.23632610,
	'+38230407050;+38269522029',
	'llolladent@t-com.me',
	'',
	'',
	'',
	'',
	'+38269522029',
	'+38269522029',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Llolla Dent', name_sr_cyrl),
	name_ru      = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая клиника Llolla Dent', name_ru),
	address_sr   = IF(address_sr IS NULL OR address_sr = '', 'Kodre bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Кодре бб', address_sr_cyrl),
	postal_code  = IF(postal_code IS NULL OR postal_code = '', '85360', postal_code),
	latitude     = COALESCE(latitude, 41.93043320),
	longitude    = COALESCE(longitude, 19.23632610),
	phone        = IF(phone IS NULL OR phone = '', '+38230407050;+38269522029', phone),
	email        = IF(email IS NULL OR email = '', 'llolladent@t-com.me', email),
	whatsapp     = IF(whatsapp IS NULL OR whatsapp = '', '+38269522029', whatsapp),
	viber        = IF(viber IS NULL OR viber = '', '+38269522029', viber)
WHERE id = @clinic_id;

UPDATE clinics SET
	description_sr = 'Privatna stomatološka ordinacija u Ulcinju, u naselju Kodre. Ordinaciju je 1981. godine osnovao otac dr Miradina Lolovića, koji je danas vodi kao specijalista stomatološke protetike i implantologije. Ordinacija obavlja preventivnu i dječju stomatologiju, liječenje karijesa i kanala korijena, izbjeljivanje zuba i uklanjanje kamenca, mobilnu i fiksnu protetiku (bezmetalne krunice, mostovi i proteze), oralnu hirurgiju, ugradnju implantata, parodontologiju i ortodonciju. Otisci i nadoknade rade se digitalno, intraoralnim skenerom i CAD/CAM sistemom.',
	description_sr_cyrl = 'Приватна стоматолошка ординација у Улцињу, у насељу Кодре. Ординацију је 1981. године основао отац др Мирадина Лоловића, који је данас води као специјалиста стоматолошке протетике и имплантологије. Ординација обавља превентивну и дјечју стоматологију, лијечење каријеса и канала коријена, избјељивање зуба и уклањање каменца, мобилну и фиксну протетику (безметалне крунице, мостови и протезе), оралну хирургију, уградњу имплантата, пародонтологију и ортодонцију. Отисци и надокнаде раде се дигитално, интраоралним скенером и CAD/CAM системом.',
	description_ru = 'Частная стоматологическая клиника в Ульцине, в районе Кодре. Клинику в 1981 году открыл отец доктора Мирадина Лоловича, который сегодня руководит ею как специалист по стоматологической ортопедии и имплантологии. Клиника занимается профилактической и детской стоматологией, лечением кариеса и корневых каналов, отбеливанием зубов и удалением зубного камня, съёмным и несъёмным протезированием (безметалловые коронки, мосты и протезы), хирургической стоматологией, имплантацией, пародонтологией и ортодонтией. Слепки и конструкции выполняются в цифровом виде — с помощью интраорального сканера и системы CAD/CAM.',
	description_en = 'A private dental practice in Ulcinj, in the Kodre neighbourhood. The practice was founded in 1981 by the father of Dr Miradin Lolović, who now runs it as a specialist in prosthodontics and implantology. It provides preventive and paediatric dentistry, caries and root canal treatment, teeth whitening and scaling, removable and fixed prosthodontics (metal-free crowns, bridges and dentures), oral surgery, dental implants, periodontology and orthodontics. Impressions and restorations are made digitally, using an intraoral scanner and a CAD/CAM system.',
	description_de = 'Eine private Zahnarztpraxis in Ulcinj im Stadtteil Kodre. Die Praxis wurde 1981 vom Vater von Dr. Miradin Lolović gegründet, der sie heute als Fachzahnarzt für Prothetik und Implantologie leitet. Das Leistungsspektrum umfasst Prophylaxe und Kinderzahnheilkunde, Karies- und Wurzelkanalbehandlung, Zahnaufhellung und Zahnsteinentfernung, herausnehmbaren und festsitzenden Zahnersatz (metallfreie Kronen, Brücken und Prothesen), Oralchirurgie, Implantologie, Parodontologie und Kieferorthopädie. Abformungen und Zahnersatz werden digital mit einem Intraoralscanner und einem CAD/CAM-System erstellt.',
	description_tr = 'Ulcinj''in Kodre semtinde bulunan özel bir diş kliniği. Klinik 1981 yılında Dr. Miradin Lolović''in babası tarafından kurulmuş olup bugün protetik diş tedavisi ve implantoloji uzmanı olan Dr. Miradin Lolović tarafından yönetilmektedir. Klinikte koruyucu ve çocuk diş hekimliği, çürük ve kanal tedavisi, diş beyazlatma ve diş taşı temizliği, hareketli ve sabit protezler (metal desteksiz kronlar, köprüler ve protezler), ağız cerrahisi, implant tedavisi, periodontoloji ve ortodonti hizmetleri sunulmaktadır. Ölçüler ve restorasyonlar ağız içi tarayıcı ve CAD/CAM sistemi ile dijital olarak hazırlanmaktadır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE — INSERT IGNORE не дедуплицирует, поэтому
-- вставка только при отсутствии. Сопровождения на других языках клиника не
-- заявляет → только SR (LanguageId.SR = 1).
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (
	SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

-- Часы — по актуальной карточке stomatologija.me (пн–чт 08–16). Старые
-- варианты (9–13 и 17–21; «только понедельник» на ordinacije.me) не берём.
-- INSERT IGNORE: правки часов из админки повторный прогон не трогает.
INSERT IGNORE INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}',
	'{"type": "closed"}'
);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Специальности: 78 = DENTISTRY. Языки: 1 = SR.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Miradin Lolović — specijalista protetike i implantologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Miradin Lolović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lolović Miradin' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'miradin-lolovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'miradin-lolovic', 'Miradin Lolović', 'Мирадин Лоловић', 'Мирадин Лолович', 'Miradin Lolovic', 'dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista stomatološke protetike i implantologije, vodi ordinaciju Llolla Dent u Ulcinju, koju je 1981. godine osnovao njegov otac. Postdiplomske studije iz implantologije, a zatim i parodontologije, pohađao je na Katoličkom univerzitetu San Antonio (UCAM) u Mursiji, u Španiji; prvo iskustvo u implantologiji stekao je u Brazilu. Posebno se bavi imedijatnim opterećenjem implantata i digitalnom protetikom.',
	description_sr_cyrl = 'Специјалиста стоматолошке протетике и имплантологије, води ординацију Llolla Dent у Улцињу, коју је 1981. године основао његов отац. Постдипломске студије из имплантологије, а затим и пародонтологије, похађао је на Католичком универзитету San Antonio (UCAM) у Мурсији, у Шпанији; прво искуство у имплантологији стекао је у Бразилу. Посебно се бави имедијатним оптерећењем имплантата и дигиталном протетиком.',
	description_ru = 'Специалист по стоматологической ортопедии и имплантологии, руководит клиникой Llolla Dent в Ульцине, которую в 1981 году открыл его отец. Прошёл постдипломное обучение по имплантологии, а затем по пародонтологии в Католическом университете Сан-Антонио (UCAM) в Мурсии, Испания; первый опыт в имплантологии получил в Бразилии. Особое внимание уделяет немедленной нагрузке имплантатов и цифровому протезированию.',
	description_en = 'A specialist in prosthodontics and implantology who runs the Llolla Dent practice in Ulcinj, founded by his father in 1981. He pursued postgraduate studies in implantology, and later in periodontology, at the Catholic University of San Antonio (UCAM) in Murcia, Spain; his first experience in implantology was gained in Brazil. His particular focus is immediate implant loading and digital prosthodontics.',
	description_de = 'Fachzahnarzt für Prothetik und Implantologie, leitet die Praxis Llolla Dent in Ulcinj, die sein Vater 1981 gegründet hat. Postgradual studierte er Implantologie und später Parodontologie an der Katholischen Universität San Antonio (UCAM) in Murcia, Spanien; erste Erfahrungen in der Implantologie sammelte er in Brasilien. Schwerpunkte sind die Sofortbelastung von Implantaten und die digitale Prothetik.',
	description_tr = 'Protetik diş tedavisi ve implantoloji uzmanı; babasının 1981 yılında kurduğu Ulcinj''deki Llolla Dent kliniğini yönetmektedir. San Antonio Katolik Üniversitesi''nde (UCAM, Murcia, İspanya) implantoloji ve ardından periodontoloji alanlarında lisansüstü eğitim aldı; implantolojideki ilk deneyimini Brezilya''da edindi. Özellikle implantlara anında yükleme ve dijital protetik üzerine çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- dr Rešid Lolović — био нет; ordinacije.me пишет «Rašid Lalović»
-- (искажение), родство с Miradin нигде не заявлено.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Rešid Lolović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lolović Rešid' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'resid-lolovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'resid-lolovic', 'Rešid Lolović', 'Решид Лоловић', 'Решид Лолович', 'Resid Lolovic', 'dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 5, status = published, clinic_languages = '1', clinic_types = '2', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2 врача; created_at сильно раньше запуска = переиспользован
-- существующий врач, убедиться, что это тот же человек.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, d.professional_title,
	GROUP_CONCAT(DISTINCT s.name ORDER BY s.name) AS specialties,
	GROUP_CONCAT(DISTINCT l.code ORDER BY l.code) AS languages,
	IF(d.description_sr IS NULL, 'NO BIO', 'ok') AS bio,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN specialties s ON s.id = ds.specialty_id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
LEFT JOIN languages l ON l.id = dl.language_id
GROUP BY d.id
ORDER BY d.name_sr;
