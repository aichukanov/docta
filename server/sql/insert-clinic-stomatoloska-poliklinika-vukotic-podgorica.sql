-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka poliklinika Vukotić (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-poliklinika-vukotic-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/stomatoloska-poliklinika-vukotic-podgorica.json):
--   * https://dentalclinicvukotic.com/ — WordPress + Polylang (me/ru/it/de/nb/en). Прочитаны ME-страницы: /, /usluge/,
--     /tim/, /sedacija/, /rendgen-kabinet/, /zubotehnicka-laboratorija/, /o-nama/, /ordinacije/, /prijem/, /higijena/,
--     /zdravstveni-turizam/, /zakazite-termin/ (modified 2022-01…2022-04).
--   * data/google-places/podgorica/stomatoloska-poliklinika-vukotic.json — place_id, координаты, телефон.
-- Филиал; Igalo (Herceg Novi) — server/sql/insert-clinic-stomatoloska-poliklinika-vukotic-herceg-novi.sql.
-- Адрес: сайт «Bulevar Ivana Crnojevića 54/3, Podgorica» = Google. Телефон: сайт «+382 020 673 030» = Google +382 20 673 030.
-- Не путать с другими «Vukotić» в Подгорице: «PZU Vukotić» (Nikole Tesle 2) и «Stomatoloska Ordinacija VUKOTIC»
-- (C7Q3+J63) — другие места без сайта, к этой клинике не относятся.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJD4HEq07rTRMRt07EFEmcmMw';
SET @clinic_slug = 'stomatoloska-poliklinika-vukotic-podgorica';

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
	'Stomatološka poliklinika Vukotić Podgorica',
	'Стоматолошка поликлиника Вукотић Подгорица',
	'Стоматологическая поликлиника Вукотич (Подгорица)',
	'Bulevar Ivana Crnojevića 54/3',
	'Булевар Ивана Црнојевића 54/3',
	'',
	'',
	'81000',
	42.44338150,
	19.26554020,
	'+38220673030',
	'info@dentalclinicvukotic.com',
	'https://dentalclinicvukotic.com/',
	'facebook.com/stomatoloska.poliklinika.vukotic',
	'@stomatologija_vukotic',
	'',
	'',
	'',
	'https://dentalclinicvukotic.com/wp-content/uploads/2021/12/logovukotic.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка поликлиника Вукотић Подгорица', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая поликлиника Вукотич (Подгорица)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Bulevar Ivana Crnojevića 54/3', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Булевар Ивана Црнојевића 54/3', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220673030', phone),
	email = IF(email IS NULL OR email = '', 'info@dentalclinicvukotic.com', email),
	website = IF(website IS NULL OR website = '', 'https://dentalclinicvukotic.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/stomatoloska.poliklinika.vukotic', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@stomatologija_vukotic', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://dentalclinicvukotic.com/wp-content/uploads/2021/12/logovukotic.png', logo_url),
	latitude = COALESCE(latitude, 42.44338150),
	longitude = COALESCE(longitude, 19.26554020)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka poliklinika Vukotić osnovana je 1960. godine i spaja porodičnu tradiciju sa savremenom stomatologijom. Poliklinika ima ordinacije u Podgorici (Bulevar Ivana Crnojevića 54/3) i u Igalu, Herceg Novi (Sarajevska 51). Pruža usluge estetsko-rekonstruktivne stomatologije, liječenja kanala korijena uz mašinsku obradu, protetike (mobilne nadoknade, metalo-keramičke i čisto keramičke krunice i mostovi), parodontologije, oralne hirurgije, implantologije (implantati Straumann i BioHorizons), ortopedije vilice te dječije i preventivne stomatologije, a radi i inhalacionu sedaciju. Poliklinika ima sopstvenu zubotehničku laboratoriju i rendgen kabinet sa digitalnom radioviziografijom (Kodak) i digitalnim ortopantomografom (Planmeca). Za hitne intervencije dostupna je 24 sata dnevno.',
	description_sr_cyrl = 'Стоматолошка поликлиника Вукотић основана је 1960. године и спаја породичну традицију са савременом стоматологијом. Поликлиника има ординације у Подгорици (Булевар Ивана Црнојевића 54/3) и у Игалу, Херцег Нови (Сарајевска 51). Пружа услуге естетско-реконструктивне стоматологије, лијечења канала коријена уз машинску обраду, протетике (мобилне надокнаде, метало-керамичке и чисто керамичке крунице и мостови), пародонтологије, оралне хирургије, имплантологије (имплантати Straumann и BioHorizons), ортопедије вилице те дјечије и превентивне стоматологије, а ради и инхалациону седацију. Поликлиника има сопствену зуботехничку лабораторију и рендген кабинет са дигиталном радиовизиографијом (Kodak) и дигиталним ортопантомографом (Planmeca). За хитне интервенције доступна је 24 сата дневно.',
	description_ru = 'Стоматологическая поликлиника Вукотич основана в 1960 году и сочетает семейные традиции с современной стоматологией. У поликлиники есть кабинеты в Подгорице (бульвар Ивана Црноевича, 54/3) и в Игало, Херцег-Нови (ул. Сараевска, 51). Здесь занимаются эстетико-реконструктивной стоматологией, лечением корневых каналов с машинной обработкой, протезированием (съёмные протезы, металлокерамические и цельнокерамические коронки и мосты), пародонтологией, хирургической стоматологией, имплантацией (имплантаты Straumann и BioHorizons), ортодонтией, детской и профилактической стоматологией, а также проводят ингаляционную седацию. В поликлинике есть собственная зуботехническая лаборатория и рентген-кабинет с цифровой радиовизиографией (Kodak) и цифровым ортопантомографом (Planmeca). Для неотложной помощи поликлиника доступна круглосуточно.',
	description_en = 'The Vukotić dental polyclinic was founded in 1960 and combines a family tradition with modern dentistry. It has practices in Podgorica (Bulevar Ivana Crnojevića 54/3) and in Igalo, Herceg Novi (Sarajevska 51). Services include aesthetic and restorative dentistry, root canal treatment with rotary instrumentation, prosthodontics (removable dentures, metal-ceramic and all-ceramic crowns and bridges), periodontology, oral surgery, implantology (Straumann and BioHorizons implants), orthodontics and paediatric and preventive dentistry, as well as inhalation sedation. The polyclinic has its own dental laboratory and an X-ray suite with digital radiovisiography (Kodak) and a digital panoramic unit (Planmeca). It is available 24 hours a day for emergencies.',
	description_de = 'Die Zahnpoliklinik Vukotić wurde 1960 gegründet und verbindet Familientradition mit moderner Zahnmedizin. Sie hat Praxen in Podgorica (Bulevar Ivana Crnojevića 54/3) und in Igalo, Herceg Novi (Sarajevska 51). Angeboten werden ästhetisch-rekonstruktive Zahnheilkunde, maschinelle Wurzelkanalbehandlung, Prothetik (herausnehmbarer Zahnersatz, Metallkeramik- und Vollkeramikkronen und -brücken), Parodontologie, Oralchirurgie, Implantologie (Straumann- und BioHorizons-Implantate), Kieferorthopädie sowie Kinder- und Präventivzahnheilkunde; außerdem wird Inhalationssedierung angeboten. Die Poliklinik verfügt über ein eigenes Dentallabor und einen Röntgenraum mit digitaler Radiovisiographie (Kodak) und digitalem Panoramaröntgengerät (Planmeca). Für Notfälle ist sie rund um die Uhr erreichbar.',
	description_tr = 'Vukotić diş polikliniği 1960''ta kurulmuştur ve aile geleneğini modern diş hekimliğiyle birleştirir. Podgorica''da (Bulevar Ivana Crnojevića 54/3) ve Herceg Novi''nin Igalo semtinde (Sarajevska 51) muayenehaneleri vardır. Estetik-rekonstrüktif diş hekimliği, döner aletlerle kanal tedavisi, protez (hareketli protezler, metal-seramik ve tam seramik kron ve köprüler), periodontoloji, ağız cerrahisi, implantoloji (Straumann ve BioHorizons implantları), ortodonti ile çocuk ve koruyucu diş hekimliği hizmetleri ve inhalasyon sedasyonu sunulur. Poliklinikte kendi diş laboratuvarı ile dijital radyovizyografi (Kodak) ve dijital panoramik cihazı (Planmeca) bulunan bir röntgen odası vardır. Acil müdahaleler için günün 24 saati ulaşılabilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Рабочее время (clinic_working_hours) НЕ заполняем: Сайт противоречит сам себе: главная «Ponedeljak–Petak 9-17, Subota 9-13», /zakazite-termin/ «Radnim danima: 9-21 h, Subotom: 9-14 h»; по поликлиникам не разделено. Не заполняем.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (4)
-- Состав — /tim/ (2022-02-25): 4 «Dr». Сайт не делит врачей по поликлиникам — вся команда привязана к обеим.
-- Зубной техник Vedrana Vukotić и сестра Nevena Glušac — не врачи, не заводятся. Все 4 — новые (локально и прод-API: 204).
-- Фото — портреты с /tim/ (wp-content/uploads/2022/01/1K2A46*.jpg).
-- Специальности: 74 = ORAL_SURGERY, 78 = DENTISTRY, 93 = ORTHODONTIST. Языки: 1 = SR, 3 = EN, 6 = DE.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Ivan Vukotić — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivan Vukotić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vukotić Ivan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivan-vukotic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-vukotic', 'Ivan Vukotić', 'Иван Вукотић', 'Иван Вукотич', 'Ivan Vukotic', 'Dr',
	'https://dentalclinicvukotic.com/wp-content/uploads/2022/01/1K2A4663-scaled-e1641145178368.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Mladen Vukotić — Specijalista oralne hirurgije i implantologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mladen Vukotić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vukotić Mladen' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mladen-vukotic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mladen-vukotic', 'Mladen Vukotić', 'Младен Вукотић', 'Младен Вукотич', 'Mladen Vukotic', 'Dr',
	'https://dentalclinicvukotic.com/wp-content/uploads/2022/01/1K2A4669-scaled-e1641145226770.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije i implantologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Tatjana Vukotić — Specijalista ortopedije vilice
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Tatjana Vukotić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vukotić Tatjana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'tatjana-vukotic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tatjana-vukotic', 'Tatjana Vukotić', 'Татјана Вукотић', 'Татьяна Вукотич', 'Tatjana Vukotic', 'Dr',
	'https://dentalclinicvukotic.com/wp-content/uploads/2022/01/1K2A4658-scaled-e1641145146384.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilice')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Sandra Brkić — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sandra Brkić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Brkić Sandra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sandra-brkic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sandra-brkic', 'Sandra Brkić', 'Сандра Бркић', 'Сандра Бркич', 'Sandra Brkic', 'Dr',
	'https://dentalclinicvukotic.com/wp-content/uploads/2022/01/1K2A4673-scaled-e1641145248739.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- В БД её нет (ни по slug, ни по имени). По заметке site-checks она же указана у Polident (Bijela) — Polident в
-- БД не заведён; при его импорте — привязка к sandra-brkic.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
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

-- Ожидается 4 врач(а/ей): ivan-vukotic, mladen-vukotic, tatjana-vukotic, sandra-brkic.
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
