-- ═══════════════════════════════════════════════════════════════════════════
-- Cirkon Dental Lab (Podgorica) — клиника (врачей нет)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-cirkon-dental-lab-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/cirkon-dental-lab-podgorica.json):
--   * https://www.cirkondentallab.com/ (Next.js, SSR-HTML) — главная (JSON-LD Dentist:
--     телефон, адрес, часы, Instagram/Facebook/TikTok, логотип), /o-nama, /kontakt,
--     /usluge + 5 страниц /usluge/*, /cjenovnik (есть в sitemap, в меню нет; даты нет),
--     /dentalni-turizam, /en/dental-tourism, /nasi-radovi (галерея пустая).
--   * Места Google в нашей выгрузке НЕТ → google_place_id = NULL. Places API не
--     запрашивался.
--
-- КООРДИНАТЫ: 42.429896, 19.250732 — точка из ссылки Google Maps, которую прислал юзер
-- 2026-10-08 (https://maps.app.goo.gl/1UJdXnVQ31ipunTEA → maps/search/42.429896,+19.250732).
-- Сайт координат не даёт (карта на /kontakt — по текстовому адресу, в JSON-LD нет geo).
--
-- Врачей сайт не перечисляет — врачи не заводятся (подволна 2a). В /o-nama назван
-- только «Elvir Šuntić — Direktor» без специальности; «Dr Alen Šuntić» — из отзыва Google.
--
-- Email на сайте нет (только форма обратной связи). WhatsApp: ссылки wa.me/38267604664
-- на всех страницах («WhatsApp Business»). Viber не заявлен. TikTok @cirkondentallab —
-- колонки нет. Почтовый индекс на сайте не указан — не заполнялся.
--
-- Идемпотентно и самоисправляюще: клиника ищется по slug; пустые поля существующей
-- записи дозаполняются, непустые не трогаются (status тоже). description_* пишутся
-- БЕЗУСЛОВНЫМ UPDATE — правки описаний вносить сюда, иначе следующий прогон их
-- перезапишет. Языки клиники и часы синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @clinic_slug = 'cirkon-dental-lab-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1);

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
	NULL,
	'published',
	1, -- CityId.PODGORICA
	'Cirkon Dental Lab',
	'Cirkon Dental Lab',
	'Cirkon Dental Lab',
	'Ilije Plamenca bb, zgrada „Ist Sajd“ (East Side Ljubović), Zabjelo',
	'Илије Пламенца бб, зграда „Ист Сајд“ (East Side Ljubović), Забјело',
	'',
	'',
	'',
	42.429896,
	19.250732,
	'+38267604664',
	'',
	'https://www.cirkondentallab.com/',
	'facebook.com/p/Cirkon-Dental-Lab-100091784692022/',
	'@cirkondentallab',
	'',
	'+38267604664',
	'',
	'https://www.cirkondentallab.com/ikona%20cirkon.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не трогаем, координаты —
-- только если пусты или 0 (админка пишет 0 вместо NULL).
UPDATE clinics SET
	latitude = IF(latitude IS NULL OR latitude = 0, 42.429896, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.250732, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Cirkon Dental Lab', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Cirkon Dental Lab', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Ilije Plamenca bb, zgrada „Ist Sajd“ (East Side Ljubović), Zabjelo', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Илије Пламенца бб, зграда „Ист Сајд“ (East Side Ljubović), Забјело', address_sr_cyrl),
	phone = IF(phone IS NULL OR phone = '', '+38267604664', phone),
	website = IF(website IS NULL OR website = '', 'https://www.cirkondentallab.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/p/Cirkon-Dental-Lab-100091784692022/', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@cirkondentallab', instagram),
	whatsapp = IF(whatsapp IS NULL OR whatsapp = '', '+38267604664', whatsapp),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.cirkondentallab.com/ikona%20cirkon.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (см. шапку). Только то, что клиника пишет о себе
-- (/o-nama, /usluge, /usluge/*, /dentalni-turizam, футер). «Besplatne konsultacije»
-- в описание НЕ вынесено: прайс берёт за осмотр 10 € (см. запись импорта).
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija sa vlastitom zubotehničkom laboratorijom u Podgorici, u ulici Ilije Plamenca (zgrada „Ist Sajd“, East Side Ljubović) na Zabjelu. Posluje od 10. novembra 2005. godine. Ordinacija i laboratorija rade pod jednim krovom — od digitalnog skeniranja i dizajna osmijeha do izrade krunice, a odabrani radovi izrađuju se u sopstvenoj laboratoriji za 24–48 sati. Rad se oslanja na digitalni protokol: 3D intraoralni skener, digitalni 2D ortopan, Digital Smile Design i CAD/CAM izradu keramičkih krunica. Ordinacija se bavi estetskom stomatologijom (Hollywood Smile, bezmetalne cirkonijum krunice, keramičke i kompozitne fasete, izbjeljivanje zuba u ordinaciji i kod kuće), protetikom (metalokeramičke krunice, totalne i parcijalne akrilatne, skeletirane i fleksibilne proteze), liječenjem kanala korijena, bijelim plombama, oralnom hirurgijom (vađenje zuba i manji hirurški zahvati) i profesionalnim čišćenjem zuba. Na sve protetske radove daje pisanu garanciju. Za pacijente iz inostranstva organizuje dentalni turizam: smještaj, prevoz od aerodroma u Podgorici ili Tivtu i podršku tokom boravka. Radno vrijeme: ponedjeljak–petak 09:00–17:00, subota 09:00–13:00.',
	description_sr_cyrl = 'Стоматолошка ординација са властитом зуботехничком лабораторијом у Подгорици, у улици Илије Пламенца (зграда „Ист Сајд“, East Side Ljubović) на Забјелу. Послује од 10. новембра 2005. године. Ординација и лабораторија раде под једним кровом — од дигиталног скенирања и дизајна осмијеха до израде крунице, а одабрани радови израђују се у сопственој лабораторији за 24–48 сати. Рад се ослања на дигитални протокол: 3D интраорални скенер, дигитални 2D ортопан, Digital Smile Design и CAD/CAM израду керамичких круница. Ординација се бави естетском стоматологијом (Hollywood Smile, безметалне цирконијум крунице, керамичке и композитне фасете, избјељивање зуба у ординацији и код куће), протетиком (металокерамичке крунице, тоталне и парцијалне акрилатне, скелетиране и флексибилне протезе), лијечењем канала коријена, бијелим пломбама, оралном хирургијом (вађење зуба и мањи хируршки захвати) и професионалним чишћењем зуба. На све протетске радове даје писану гаранцију. За пацијенте из иностранства организује дентални туризам: смјештај, превоз од аеродрома у Подгорици или Тивту и подршку током боравка. Радно вријеме: понедјељак–петак 09:00–17:00, субота 09:00–13:00.',
	description_ru = 'Стоматологическая клиника с собственной зуботехнической лабораторией в Подгорице, на улице Илие Пламенца (здание «Ист Сайд», East Side Ljubović) в районе Забьело. Работает с 10 ноября 2005 года. Клиника и лаборатория находятся под одной крышей — от цифрового сканирования и дизайна улыбки до изготовления коронки; отдельные работы изготавливаются в собственной лаборатории за 24–48 часов. Работа строится на цифровом протоколе: 3D-интраоральный сканер, цифровая 2D-ортопантомограмма, Digital Smile Design и изготовление керамических коронок по технологии CAD/CAM. Клиника занимается эстетической стоматологией (Hollywood Smile, безметалловые циркониевые коронки, керамические и композитные виниры, отбеливание зубов в кабинете и на дому), протезированием (металлокерамические коронки, полные и частичные акриловые, бюгельные и гибкие протезы), лечением корневых каналов, композитными пломбами, хирургической стоматологией (удаление зубов и небольшие хирургические вмешательства) и профессиональной чисткой зубов. На все ортопедические работы даётся письменная гарантия. Для пациентов из-за рубежа клиника организует стоматологический туризм: проживание, трансфер из аэропорта Подгорицы или Тивата и поддержку во время пребывания. Часы работы: понедельник–пятница 09:00–17:00, суббота 09:00–13:00.',
	description_en = 'A dental practice with its own dental laboratory in Podgorica, on Ilije Plamenca street (the “Ist Sajd” building, East Side Ljubović) in Zabjelo. It has been operating since 10 November 2005. The practice and the laboratory work under one roof — from digital scanning and smile design to making the crown — and selected restorations are made in the in-house laboratory within 24–48 hours. The work follows a digital protocol: a 3D intraoral scanner, a digital 2D panoramic X-ray (OPG), Digital Smile Design and CAD/CAM fabrication of ceramic crowns. The practice provides cosmetic dentistry (Hollywood Smile, metal-free zirconia crowns, ceramic and composite veneers, in-office and at-home teeth whitening), prosthodontics (metal-ceramic crowns, complete and partial acrylic, cast-metal and flexible dentures), root canal treatment, tooth-coloured fillings, oral surgery (tooth extractions and minor surgical procedures) and professional teeth cleaning. All prosthetic work comes with a written warranty. For patients from abroad it organises dental tourism: accommodation, transfers from Podgorica or Tivat airport and support throughout the stay. Opening hours: Monday–Friday 09:00–17:00, Saturday 09:00–13:00.',
	description_de = 'Zahnarztpraxis mit eigenem Dentallabor in Podgorica, in der Straße Ilije Plamenca (Gebäude „Ist Sajd“, East Side Ljubović) im Stadtteil Zabjelo. Die Praxis besteht seit dem 10. November 2005. Praxis und Labor arbeiten unter einem Dach — vom digitalen Scan und Smile Design bis zur Anfertigung der Krone; ausgewählte Arbeiten entstehen im eigenen Labor innerhalb von 24–48 Stunden. Gearbeitet wird nach einem digitalen Protokoll: 3D-Intraoralscanner, digitales 2D-Panoramaröntgen (OPG), Digital Smile Design und CAD/CAM-Fertigung von Keramikkronen. Angeboten werden ästhetische Zahnmedizin (Hollywood Smile, metallfreie Zirkonkronen, Keramik- und Kompositveneers, Zahnaufhellung in der Praxis und zu Hause), Prothetik (Metallkeramikkronen, Voll- und Teilprothesen aus Kunststoff, Modellguss- und flexible Prothesen), Wurzelkanalbehandlung, zahnfarbene Füllungen, Oralchirurgie (Zahnextraktionen und kleinere chirurgische Eingriffe) sowie professionelle Zahnreinigung. Auf alle prothetischen Arbeiten gibt es eine schriftliche Garantie. Für Patienten aus dem Ausland organisiert die Praxis Dentaltourismus: Unterkunft, Transfer vom Flughafen Podgorica oder Tivat und Betreuung während des Aufenthalts. Öffnungszeiten: Montag–Freitag 09:00–17:00, Samstag 09:00–13:00.',
	description_tr = 'Podgorica''da, Zabjelo semtinde Ilije Plamenca caddesinde (“Ist Sajd” binası, East Side Ljubović) bulunan, kendi diş laboratuvarına sahip diş kliniği. 10 Kasım 2005''ten beri hizmet vermektedir. Klinik ve laboratuvar aynı çatı altında çalışır — dijital taramadan ve gülüş tasarımından kronun üretimine kadar; seçili çalışmalar kendi laboratuvarında 24–48 saatte üretilir. Çalışmalar dijital protokole dayanır: 3D ağız içi tarayıcı, dijital 2D panoramik röntgen (OPG), Digital Smile Design ve seramik kronların CAD/CAM ile üretimi. Klinikte estetik diş hekimliği (Hollywood Smile, metalsiz zirkonyum kronlar, seramik ve kompozit veneerler, muayenehanede ve evde diş beyazlatma), protez (metal seramik kronlar, tam ve kısmi akrilik, iskelet ve esnek protezler), kanal tedavisi, diş renginde dolgular, ağız cerrahisi (diş çekimi ve küçük cerrahi müdahaleler) ve profesyonel diş temizliği hizmetleri sunulmaktadır. Tüm protez çalışmalarına yazılı garanti verilir. Yurt dışından gelen hastalar için diş turizmi düzenler: konaklama, Podgorica veya Tivat havalimanından transfer ve kalış süresince destek. Çalışma saatleri: pazartesi–cuma 09:00–17:00, cumartesi 09:00–13:00.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Приём на других
-- языках сайт прямо не заявляет (есть английская версия сайта и страница
-- dental tourism, но без слов о языке приёма) → только SR (LanguageId.SR = 1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: футер всех страниц «Ponedjeljak – petak 09:00–17:00 / Subota 09:00–13:00»,
-- /kontakt «Pon–Pet 09:00–17:00 • Sub 09:00–13:00», JSON-LD openingHoursSpecification
-- (Mo–Fr 09–17, Sa 09–13, воскресенья нет) — совпадают. Воскресенье = закрыто.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS — нет (сайт не перечисляет врачей; подволна 2a)
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, google_place_id = NULL, latitude = 42.429896,
-- clinic_languages = '1', clinic_types = '2', hours = 1, doctors = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.whatsapp,
	c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours,
	(SELECT COUNT(*) FROM doctor_clinics WHERE clinic_id = c.id) AS doctors
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;
