-- ═══════════════════════════════════════════════════════════════════════════
-- Diagnost — ordinacija za ultrazvučnu dijagnostiku (Budva) — клиника + врач
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-diagnost-budva.sql
-- Затем: server/sql/insert-clinic-diagnost-budva-services.sql
-- Запись импорта: data/clinic-imports/diagnost-budva.json. Подволна 2e, агент Z.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://www.ultrazvuk.me/ — Drupal 7, 18 URL в sitemap.xml (lastmod 2019-09 … 2021-12): главная, /o-nama, /kontakt,
--     /ultrazvu-na-dijagnostika и 11 страниц исследований. ⚠️ Страницы 2019–2021 — состав/часы могли устареть. Цен нет
--     (/cenovnik, /cjenovnik — 404; /shop — пустой шаблон).
--   * data/google-places/budva/diagnost-ultrasound-diagnostic-clinic-montenegro.json — place_id, координаты 42.2891426 / 18.8491471,
--     +382 68 555 595, «BB Veljka Vlahovića, Budva 85310», 15 отзывов (rating 5) — не импортировались.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJKQtwIC_VTRMRbjpsrWfQwiI';
SET @clinic_slug = 'diagnost-budva';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Diagnost', 'Diagnost — ordinacija za ultrazvučnu dijagnostiku', 'Diagnost - ordinacija za ultrazvučnu dijagnostiku', 'Diagnost - ultrasound diagnostic clinic Montenegro') AND city_id = 3 LIMIT 1));

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
	3, -- CityId.BUDVA
	'Diagnost — ordinacija za ultrazvučnu dijagnostiku',
	'Diagnost — ординација за ултразвучну дијагностику',
	'Diagnost — кабинет ультразвуковой диагностики',
	'Veljka Vlahovića bb',
	'Вељка Влаховића бб',
	'',
	'',
	'85310',
	42.28914260,
	18.84914710,
	'+38268555595',
	'diagnost@ultrazvuk.me',
	'https://www.ultrazvuk.me/',
	'facebook.com/Diagnost-ordinacija-za-ultrazvučnu-dijagnostiku-102206687861985',
	'@diagnost.ordinacija',
	'',
	'',
	'',
	'https://www.ultrazvuk.me/sites/default/files/diagnost-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.28914260, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.84914710, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Diagnost — ординација за ултразвучну дијагностику', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Diagnost — кабинет ультразвуковой диагностики', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Veljka Vlahovića bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Вељка Влаховића бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85310', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38268555595', phone),
	email = IF(email IS NULL OR email = '', 'diagnost@ultrazvuk.me', email),
	website = IF(website IS NULL OR website = '', 'https://www.ultrazvuk.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/Diagnost-ordinacija-za-ultrazvučnu-dijagnostiku-102206687861985', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@diagnost.ordinacija', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.ultrazvuk.me/sites/default/files/diagnost-logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Diagnost je ordinacija za ultrazvučnu dijagnostiku u Budvi, u ulici Veljka Vlahovića bb (kod parkinga hotela Podostrog), za djecu i odrasle, uključujući novorođenčad i odojčad. U ordinaciji radi dr Marija Mandić, specijalista radiologije i subspecijalista digestivne radiologije, s dugogodišnjim iskustvom u pedijatrijskoj radiologiji u Univerzitetskoj dječjoj klinici Tiršova u Beogradu. Pregledi se rade na ultrazvučnom aparatu Siemens najnovije generacije. Usluge: ultrazvuk abdomena, urinarnog trakta kod djece i male karlice; ultrazvuk kukova kod beba, mozga (CNS) novorođenčadi i odojčadi i kičme kod novorođenčadi i mlađe odojčadi; ultrazvuk testisa, štitaste žlijezde i mekih tkiva vrata i dojki; ultrazvučna mikciona cistografija, za koju ordinacija navodi da je jedina ustanova u Crnoj Gori koja radi ovaj pregled; kolor dopler krvnih sudova bubrega, jetre (portnog sistema) i vrata. Zakazivanje telefonom ili preko kontakt forme na sajtu.',
	description_sr_cyrl = 'Diagnost је ординација за ултразвучну дијагностику у Будви, у улици Вељка Влаховића бб (код паркинга хотела Подострог), за дјецу и одрасле, укључујући новорођенчад и одојчад. У ординацији ради др Марија Мандић, специјалиста радиологије и субспецијалиста дигестивне радиологије, с дугогодишњим искуством у педијатријској радиологији у Универзитетској дјечјој клиници Тиршова у Београду. Прегледи се раде на ултразвучном апарату Siemens најновије генерације. Услуге: ултразвук абдомена, уринарног тракта код дјеце и мале карлице; ултразвук кукова код беба, мозга (CNS) новорођенчади и одојчади и кичме код новорођенчади и млађе одојчади; ултразвук тестиса, штитасте жлијезде и меких ткива врата и дојки; ултразвучна микциона цистографија, за коју ординација наводи да је једина установа у Црној Гори која ради овај преглед; колор доплер крвних судова бубрега, јетре (портног система) и врата. Заказивање телефоном или преко контакт форме на сајту.',
	description_ru = 'Diagnost — кабинет ультразвуковой диагностики в Будве, улица Veljka Vlahovića bb (у парковки отеля Podostrog), для детей и взрослых, включая новорождённых и грудных детей. Приём ведёт д-р Мария Мандич, специалист по радиологии и субспециалист по радиологии пищеварительной системы, много лет проработавшая в детской радиологии Университетской детской клиники Тиршова в Белграде. Исследования проводятся на ультразвуковом аппарате Siemens последнего поколения. Услуги: УЗИ брюшной полости, мочевыводящих путей у детей и малого таза; УЗИ тазобедренных суставов у младенцев, головного мозга (ЦНС) новорождённых и грудных детей и позвоночника у новорождённых и детей первых месяцев; УЗИ яичек, щитовидной железы и мягких тканей шеи, молочных желёз; ультразвуковая микционная цистография — по словам кабинета, единственное учреждение в Черногории, где её делают; цветовой допплер сосудов почек, печени (портальной системы) и шеи. Запись по телефону или через форму на сайте.',
	description_en = 'Diagnost is an ultrasound diagnostics practice in Budva at Veljka Vlahovića bb (by the Hotel Podostrog car park) for children and adults, including newborns and infants. It is run by Dr Marija Mandić, a specialist radiologist and subspecialist in digestive radiology with many years of experience in paediatric radiology at the Tiršova University Children''s Clinic in Belgrade. Examinations are performed on a latest-generation Siemens ultrasound machine. Services: abdominal, paediatric urinary tract and pelvic ultrasound; infant hip ultrasound, brain (CNS) ultrasound in newborns and infants and spinal ultrasound in newborns and young infants; testicular, thyroid and neck soft tissue, and breast ultrasound; voiding urosonography, which the practice says is offered nowhere else in Montenegro; colour Doppler of the renal, hepatic (portal system) and neck vessels. Appointments by phone or via the contact form on the website.',
	description_de = 'Diagnost ist eine Praxis für Ultraschalldiagnostik in Budva, Veljka Vlahovića bb (am Parkplatz des Hotels Podostrog), für Kinder und Erwachsene einschließlich Neugeborener und Säuglinge. Die Praxis leitet Dr. Marija Mandić, Fachärztin für Radiologie und Subspezialistin für Radiologie des Verdauungstrakts, mit langjähriger Erfahrung in der Kinderradiologie an der Universitätskinderklinik Tiršova in Belgrad. Untersucht wird mit einem Siemens-Ultraschallgerät der neuesten Generation. Leistungen: Ultraschall des Abdomens, der Harnwege bei Kindern und des kleinen Beckens; Hüftultraschall bei Säuglingen, Ultraschall des Gehirns (ZNS) bei Neugeborenen und Säuglingen sowie der Wirbelsäule bei Neugeborenen und jungen Säuglingen; Ultraschall der Hoden, der Schilddrüse und der Weichteile des Halses sowie der Brust; Miktionsurosonographie, die nach Angaben der Praxis sonst nirgends in Montenegro angeboten wird; Farbdoppler der Nieren-, Leber- (Pfortadersystem) und Halsgefäße. Termine telefonisch oder über das Kontaktformular der Website.',
	description_tr = 'Diagnost, Budva''da Veljka Vlahovića bb adresinde (Podostrog otelinin otoparkı yanında) yenidoğanlar ve bebekler dahil çocuklara ve yetişkinlere hizmet veren bir ultrason tanı muayenehanesidir. Muayenehanede, Belgrad''daki Tiršova Üniversite Çocuk Kliniği''nde çocuk radyolojisinde uzun yıllar çalışmış radyoloji uzmanı ve sindirim sistemi radyolojisi yan dal uzmanı Dr. Marija Mandić hasta kabul eder. Muayeneler son nesil Siemens ultrason cihazıyla yapılır. Hizmetler: karın, çocuklarda idrar yolları ve küçük pelvis ultrasonu; bebeklerde kalça ultrasonu, yenidoğan ve bebeklerde beyin (MSS) ultrasonu ile yenidoğan ve küçük bebeklerde omurga ultrasonu; testis, tiroid ve boyun yumuşak dokuları ile meme ultrasonu; muayenehanenin Karadağ''da başka hiçbir yerde yapılmadığını belirttiği işeme ürosonografisi; böbrek, karaciğer (portal sistem) ve boyun damarlarının renkli Doppler incelemesi. Randevu telefonla veya web sitesindeki iletişim formuyla alınır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- POLYCLINIC = 1 (кабинет лучевой диагностики — решение владельца каталога для radio-medic: отдельного типа радиологии нет, DIAGNOSTIC_LAB вводит в заблуждение) + PEDIATRIC_CLINIC = 12 (детская радиология: «ULTRAZVUČNA DIJAGNOSTIKA ZA: DECU I ODRASLE, NOVOROĐENČAD I ODOJČAD», 5 из 12 пунктов — детские; как medikid-podgorica).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1), (@clinic_id, 12);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском (экавица), другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — /kontakt: «Radno vreme: Pon - Pet 10 - 12 i 17 - 19, Subotom 10 - 12, Nedeljom ne radimo». ⚠️ Страница kontakt — lastmod 2020-11.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "12:00"}, {"start": "17:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "12:00"}, {"start": "17:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "12:00"}, {"start": "17:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "12:00"}, {"start": "17:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "12:00"}, {"start": "17:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "12:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday),
	tuesday = VALUES(tuesday),
	wednesday = VALUES(wednesday),
	thursday = VALUES(thursday),
	friday = VALUES(friday),
	saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- ═══════════════════════════════════════════════════════════════
-- Источник: главная и /o-nama — единственный врач сайта. (В отзыве Google упомянут ещё «dr Igor», радиолог — на сайте его нет, не заводим.)
-- Привязки врач↔услуга — все услуги к единственному врачу, см. services-SQL.

-- ───────────────────────────────────────────────────────────────
-- «dr Marija Mandić, specijalista radiologije i subspecijalista digestivne radiologije, sa dugogodišnjim iskustvom rada u dečijoj klinici Tiršova …» (главная), биография — /o-nama.
-- В БД не найдена (локаль: Mandić — Dejan/Vojislav/Igor/Goran/Borislav/Nina Pejović/Svjetlana, Marija нет; прод-API marija-mandic → 204) — новая.
-- 10 = RADIOLOGY. Детской радиологии отдельной специальностью в enums нет; субспециализация — в описании.
-- Языки: сайт других языков не заявляет → только SR. (Отзыв в Google про русский язык врача — не заявление сайта.)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marija Mandić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mandić Marija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marija-mandic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-mandic', 'Marija Mandić', 'Марија Мандић', 'Мария Мандич', 'Marija Mandic', 'Dr',
	'https://www.ultrazvuk.me/sites/default/files/dr_Marija_Mandic_0.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.ultrazvuk.me/sites/default/files/dr_Marija_Mandic_0.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Specijalizaciju iz radiologije završila je u Beogradu, na Institutu za onkologiju i radiologiju. Radila je u Institutu za bolesti djece i omladine u Podgorici kao prvi dječji radiolog u Crnoj Gori, a potom 17 godina u Univerzitetskoj dječjoj klinici Tiršova u Beogradu. Subspecijalista je digestivne radiologije. Šesnaest godina je stručni konsultant u poliklinici Profmedika Simeunović u Beogradu i dugogodišnji edukator u školi pedijatrijskog ultrazvuka u dječjoj klinici Tiršova. Učesnik je brojnih naučnih skupova u regionu i inostranstvu i autor brojnih naučnih radova.',
	description_sr_cyrl = 'Специјализацију из радиологије завршила је у Београду, на Институту за онкологију и радиологију. Радила је у Институту за болести дјеце и омладине у Подгорици као први дјечји радиолог у Црној Гори, а потом 17 година у Универзитетској дјечјој клиници Тиршова у Београду. Субспецијалиста је дигестивне радиологије. Шеснаест година је стручни консултант у поликлиници Profmedika Simeunović у Београду и дугогодишњи едукатор у школи педијатријског ултразвука у дјечјој клиници Тиршова. Учесник је бројних научних скупова у региону и иностранству и аутор бројних научних радова.',
	description_ru = 'Специализацию по радиологии окончила в Белграде, в Институте онкологии и радиологии. Работала в Институте болезней детей и молодёжи в Подгорице как первый детский радиолог Черногории, затем 17 лет — в Университетской детской клинике Тиршова в Белграде. Субспециалист по радиологии пищеварительной системы. Шестнадцать лет — консультант поликлиники Profmedika Simeunović в Белграде, многолетний преподаватель школы педиатрического УЗИ в детской клинике Тиршова. Участник многочисленных научных конференций в регионе и за рубежом, автор многих научных работ.',
	description_en = 'She completed her radiology residency in Belgrade at the Institute of Oncology and Radiology. She worked at the Institute for Children''s and Youth Diseases in Podgorica as the first paediatric radiologist in Montenegro, and then for 17 years at the Tiršova University Children''s Clinic in Belgrade. She is a subspecialist in digestive radiology. For sixteen years she has been a consultant at the Profmedika Simeunović polyclinic in Belgrade and a long-standing lecturer at the paediatric ultrasound school of the Tiršova Children''s Clinic. She has taken part in numerous scientific meetings in the region and abroad and authored many scientific papers.',
	description_de = 'Ihre Facharztausbildung in Radiologie absolvierte sie in Belgrad am Institut für Onkologie und Radiologie. Sie arbeitete am Institut für Kinder- und Jugendkrankheiten in Podgorica als erste Kinderradiologin Montenegros und danach 17 Jahre an der Universitätskinderklinik Tiršova in Belgrad. Sie ist Subspezialistin für Radiologie des Verdauungstrakts. Seit sechzehn Jahren ist sie Fachberaterin der Poliklinik Profmedika Simeunović in Belgrad und langjährige Dozentin der Schule für pädiatrischen Ultraschall an der Kinderklinik Tiršova. Sie nahm an zahlreichen wissenschaftlichen Tagungen im In- und Ausland teil und ist Autorin zahlreicher Fachpublikationen.',
	description_tr = 'Radyoloji uzmanlığını Belgrad''da Onkoloji ve Radyoloji Enstitüsü''nde tamamladı. Podgorica''daki Çocuk ve Gençlik Hastalıkları Enstitüsü''nde Karadağ''ın ilk çocuk radyoloğu olarak çalıştı, ardından 17 yıl Belgrad''daki Tiršova Üniversite Çocuk Kliniği''nde görev yaptı. Sindirim sistemi radyolojisi yan dal uzmanıdır. On altı yıldır Belgrad''daki Profmedika Simeunović polikliniğinin danışmanıdır ve Tiršova Çocuk Kliniği''ndeki pediatrik ultrason okulunda uzun yıllardır eğitmenlik yapmaktadır. Bölgede ve yurt dışında çok sayıda bilimsel toplantıya katılmış, birçok bilimsel çalışmanın yazarıdır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije, subspecijalista digestivne radiologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 3, status = published, clinic_languages = '1', clinic_types = '1,12', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: marija-mandic (10).
-- Если created_at нового врача старше даты прогона — запись уже была: проверить, тот ли человек.
SELECT d.id, d.slug, d.name_sr, d.professional_title,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id
ORDER BY d.name_sr;
