-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija dr Kaluđerović (Podgorica) — клиника + врач
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-dr-kaludjerovic-podgorica.sql
-- Затем: server/sql/insert-clinic-ordinacija-dr-kaludjerovic-podgorica-services.sql
-- Запись импорта: data/clinic-imports/ordinacija-dr-kaludjerovic-podgorica.json. Подволна 2e, агент Z.
-- 
-- Источники (собрано 2026-10-09):
--   * http://www.dermatolog-kaludjer.org/ — статический FrontPage/Word-HTML сайт. Хостинг отдаёт JS-челлендж: cookie __test = AES-128-CBC-
--     расшифровка (slowAES.decrypt(c, 2, a, b)) трёх hex-констант со страницы; посчитано node crypto, затем curl с cookie. Прочитаны
--     главная (?i=1), onama.html, SADRZAJ.html, kako.html, 1.php?br=220 (теледерматология — тело грузится скриптом, пусто).
--     «Cjenovnik usluga je u prilogu» — вложения/ссылки на прайс нет. Сестринский alergolog-kaludjer.org (тот же челлендж) —
--     та же главная с блоком COVID-19 и теми же услугами/часами.
--   * data/google-places/podgorica/ordinacija-dr-kaludjerovic.json — place_id, координаты 42.4404738 / 19.253997, +382 69 020 772,
--     «19/9 Ivana Milutinovića, Podgorica», 41 отзыв (rating 3.1) — не импортировались.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJuQhy-znrTRMRvowiO4-vZg0';
SET @clinic_slug = 'ordinacija-dr-kaludjerovic-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Ordinacija dr Kaluđerović', 'ORDINACIJA DR KALUDJEROVIC', 'Ordinacija Dr Kaluđerović', 'Ordinacija dr Kaludjerović') AND city_id = 1 LIMIT 1));

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
	'Ordinacija dr Kaluđerović',
	'Ординација др Калуђеровић',
	'Кабинет доктора Калуджеровича',
	'Ivana Milutinovića 19/9, prizemlje',
	'Ивана Милутиновића 19/9, приземље',
	'',
	'',
	'81000',
	42.44047380,
	19.25399700,
	'+38269020772;+38220245751',
	'kalve@t-com.me',
	'http://www.dermatolog-kaludjer.org/',
	'',
	'',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.44047380, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.25399700, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Ординација др Калуђеровић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Кабинет доктора Калуджеровича', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Ivana Milutinovića 19/9, prizemlje', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Ивана Милутиновића 19/9, приземље', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269020772;+38220245751', phone),
	email = IF(email IS NULL OR email = '', 'kalve@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'http://www.dermatolog-kaludjer.org/', website)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Ordinacija dr Kaluđerović u Podgorici, u ulici Ivana Milutinovića 19/9 (prizemlje; ranije Đura Salaja 17), u centru grada preko puta Sportskog centra Morača, ima specijalističku ambulantu za kožne i polne bolesti i subspecijalističku ambulantu za alergologiju s kompletnim alergološkim testiranjem. Preglede i procedure obavlja dr Velimir Kaluđerović, specijalista dermatovenerolog i subspecijalista alergolog — klinički imunolog, sa saradnicima. Ordinacija radi radnim danima od 14 do 19 časova i subotom od 14 do 18 časova; pregledi se obavezno zakazuju telefonom, a za hitne slučajeve moguća je konsultacija telefonom i van radnog vremena. Ordinacija nudi i besplatnu teledermatologiju: pripremljeni upiti šalju se na mejl kalve@t-com.me, a odgovori se daju radnim danima od 16 do 18 časova. Može se pregledati i pacijent koji ne može da plati pregled.',
	description_sr_cyrl = 'Ординација др Калуђеровић у Подгорици, у улици Ивана Милутиновића 19/9 (приземље; раније Ђура Салаја 17), у центру града преко пута Спортског центра Морача, има специјалистичку амбуланту за кожне и полне болести и субспецијалистичку амбуланту за алергологију с комплетним алерголошким тестирањем. Прегледе и процедуре обавља др Велимир Калуђеровић, специјалиста дерматовенеролог и субспецијалиста алерголог — клинички имунолог, са сарадницима. Ординација ради радним данима од 14 до 19 часова и суботом од 14 до 18 часова; прегледи се обавезно заказују телефоном, а за хитне случајеве могућа је консултација телефоном и ван радног времена. Ординација нуди и бесплатну теледерматологију: припремљени упити шаљу се на мејл kalve@t-com.me, а одговори се дају радним данима од 16 до 18 часова. Може се прегледати и пацијент који не може да плати преглед.',
	description_ru = 'Кабинет доктора Калуджеровича в Подгорице, улица Ivana Milutinovića 19/9 (первый этаж; прежний адрес — Đura Salaja 17), в центре города напротив спортивного центра «Морача», включает специализированную амбулаторию кожных и венерических болезней и аллергологическую амбулаторию с полным аллергологическим тестированием. Осмотры и процедуры проводит д-р Велимир Калуджерович, дерматовенеролог и субспециалист аллерголог — клинический иммунолог, вместе с сотрудниками. Часы работы: в будни с 14 до 19, в субботу с 14 до 18; запись на приём обязательна по телефону, в экстренных случаях возможна консультация по телефону и вне рабочего времени. Кабинет также бесплатно консультирует дистанционно (теледерматология): подготовленные запросы отправляют на почту kalve@t-com.me, ответы даются в будни с 16 до 18. Принимают и пациентов, которые не могут оплатить осмотр.',
	description_en = 'Dr Kaluđerović''s practice in Podgorica, at Ivana Milutinovića 19/9 (ground floor; formerly Đura Salaja 17) in the city centre opposite the Morača Sports Centre, comprises a specialist clinic for skin and sexually transmitted diseases and an allergology clinic offering complete allergy testing. Examinations and procedures are performed by Dr Velimir Kaluđerović, a specialist in dermatovenereology and subspecialist in allergology and clinical immunology, together with his associates. The practice is open on weekdays from 14:00 to 19:00 and on Saturdays from 14:00 to 18:00; appointments must be booked by phone, and in urgent cases a phone consultation is possible outside working hours. The practice also offers free teledermatology: prepared enquiries are sent by email to kalve@t-com.me and answered on weekdays from 16:00 to 18:00. Patients who cannot pay for an examination are also seen.',
	description_de = 'Die Praxis von Dr. Kaluđerović in Podgorica, Ivana Milutinovića 19/9 (Erdgeschoss; früher Đura Salaja 17), im Stadtzentrum gegenüber dem Sportzentrum Morača, umfasst eine Fachambulanz für Haut- und Geschlechtskrankheiten und eine Ambulanz für Allergologie mit kompletter Allergietestung. Untersuchungen und Eingriffe führt Dr. Velimir Kaluđerović durch, Facharzt für Dermatovenerologie und Subspezialist für Allergologie und klinische Immunologie, gemeinsam mit seinen Mitarbeitenden. Geöffnet ist werktags von 14 bis 19 Uhr und samstags von 14 bis 18 Uhr; Termine sind telefonisch zu vereinbaren, in dringenden Fällen ist eine telefonische Beratung auch außerhalb der Öffnungszeiten möglich. Die Praxis bietet außerdem kostenlose Teledermatologie an: vorbereitete Anfragen werden per E-Mail an kalve@t-com.me gesendet und werktags von 16 bis 18 Uhr beantwortet. Auch Patienten, die die Untersuchung nicht bezahlen können, werden behandelt.',
	description_tr = 'Dr. Kaluđerović muayenehanesi Podgorica''da, şehir merkezinde Morača Spor Merkezi''nin karşısında, Ivana Milutinovića 19/9 (zemin kat; eski adres Đura Salaja 17) adresindedir; deri ve cinsel yolla bulaşan hastalıklar uzman polikliniği ile kapsamlı alerji testlerinin yapıldığı alerji polikliniğinden oluşur. Muayene ve işlemleri dermatovenereoloji uzmanı ve alerji–klinik immünoloji yan dal uzmanı Dr. Velimir Kaluđerović ekibiyle birlikte yapar. Muayenehane hafta içi 14:00–19:00, cumartesi 14:00–18:00 arası açıktır; randevu mutlaka telefonla alınır, acil durumlarda mesai dışında da telefonla danışılabilir. Ücretsiz teledermatoloji hizmeti de sunulur: hazırlanan sorular kalve@t-com.me adresine e-postayla gönderilir ve hafta içi 16:00–18:00 arasında yanıtlanır. Muayene ücretini ödeyemeyen hastalar da muayene edilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- DERMATOLOGY_CLINIC = 10 — «Specijalistička ambulanta za kožne i polne bolesti» + «Subspecijalistička ambulanta za alergologiju» (отдельного типа аллергологии нет).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 10);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском, другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — главная и onama.html: «radno vrijeme: 14 H – 19 H radnim danima, subotom: 14 H – 18 H», «obavezno zakazivanje pregleda telefonom». Вс не назван → closed. Теледерматология (email) — будни 16–18, в описании.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "18:00"}]}',
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
-- Источник: главная («Ordinira: Kaludjerović dr Velimir») и onama.html. «Saradnici» без имён — не заводятся.
-- Привязки врач↔услуга — все услуги к единственному врачу, см. services-SQL.

-- ───────────────────────────────────────────────────────────────
-- «Ordinira: Kaludjerović dr Velimir — Specijalista dermatolog - venerolog, Subspecijalista alergolog - klinički imunolog» (главная); биография — onama.html.
-- В БД не найден (локаль: Kaluđerović — Rade (детская пульмонология), Olga, Đorđije, Branka, Željko, Marija, Ljubinko — другие люди; velimir-kaludjerovic нет; прод-API 204) — новый.
-- 7 = DERMATOVENEROLOGY + 79 = ALLERGOLOGY + 80 = IMMUNOLOGY («alergolog – klinički imunolog»). Фото на сайте нет. Языки не заявлены → SR.
-- «Preglede i procedure obavlja Dr Kaluđerović Velimir … sa svojim saradnicima» — сотрудники без имён, не заводятся.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Velimir Kaluđerović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kaluđerović Velimir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'velimir-kaludjerovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'velimir-kaludjerovic', 'Velimir Kaluđerović', 'Велимир Калуђеровић', 'Велимир Калуджерович', 'Velimir Kaludjerovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Specijalista dermatovenerolog i subspecijalista alergolog — klinički imunolog, s blizu četiri decenije ljekarskog rada, od toga preko 30 godina u dermatovenerologiji i preko 20 godina u alergologiji i kliničkoj imunologiji. Medicinski fakultet u Beogradu završio je 1976. godine; radio je u terenskim ambulantama u Nikšiću, Kolašinu i Golubovcima i u Urgentnom centru Kliničkog centra u Podgorici. Specijalistički ispit iz dermatologije i venerologije položio je 1987, a subspecijalistički iz alergologije i kliničke imunologije 1990. godine na Medicinskom fakultetu u Beogradu, gdje je 1993. odbranio i rad uže specijalizacije. U Klinici za dermatovenerologiju Kliničkog centra Crne Gore uveo je laboratorijsku dijagnostiku u dermatovenerologiji i fizikalne procedure na koži (termokauterizacija i krioprocedure), a zatim osnovao i više od 20 godina vodio Ambulantu za alergologiju i kliničku imunologiju. Blizu dvije decenije bio je šef stručnog konzilijuma za dermatovenerologiju i alergologiju Crne Gore, a od 1994. godine mentor je na poslediplomskim i specijalističkim studijama iz dermatovenerologije Medicinskog fakulteta u Beogradu. Od 2002. godine ima sertifikat European Academy of Allergology and Clinical Immunology. Osnivač je i dvostruki predsjednik Udruženja dermatovenerologa Crne Gore. Od 1. jula 2013. godine radi u svojoj ordinaciji.',
	description_sr_cyrl = 'Специјалиста дерматовенеролог и субспецијалиста алерголог — клинички имунолог, с близу четири деценије љекарског рада, од тога преко 30 година у дерматовенерологији и преко 20 година у алергологији и клиничкој имунологији. Медицински факултет у Београду завршио је 1976. године; радио је у теренским амбулантама у Никшићу, Колашину и Голубовцима и у Ургентном центру Клиничког центра у Подгорици. Специјалистички испит из дерматологије и венерологије положио је 1987, а субспецијалистички из алергологије и клиничке имунологије 1990. године на Медицинском факултету у Београду, гдје је 1993. одбранио и рад уже специјализације. У Клиници за дерматовенерологију Клиничког центра Црне Горе увео је лабораторијску дијагностику у дерматовенерологији и физикалне процедуре на кожи (термокаутеризација и криопроцедуре), а затим основао и више од 20 година водио Амбуланту за алергологију и клиничку имунологију. Близу двије деценије био је шеф стручног конзилијума за дерматовенерологију и алергологију Црне Горе, а од 1994. године ментор је на последипломским и специјалистичким студијама из дерматовенерологије Медицинског факултета у Београду. Од 2002. године има сертификат European Academy of Allergology and Clinical Immunology. Оснивач је и двоструки предсједник Удружења дерматовенеролога Црне Горе. Од 1. јула 2013. године ради у својој ординацији.',
	description_ru = 'Дерматовенеролог и субспециалист аллерголог — клинический иммунолог, почти четыре десятилетия врачебной практики, из них более 30 лет в дерматовенерологии и более 20 лет в аллергологии и клинической иммунологии. В 1976 году окончил медицинский факультет в Белграде; работал в сельских амбулаториях Никшича, Колашина и Голубовцев и в Центре неотложной помощи Клинического центра в Подгорице. Специализацию по дерматологии и венерологии завершил в 1987 году, субспециализацию по аллергологии и клинической иммунологии — в 1990 году на медицинском факультете в Белграде, где в 1993 году защитил работу по узкой специализации. В Клинике дерматовенерологии Клинического центра Черногории внедрил лабораторную диагностику в дерматовенерологии и физические процедуры на коже (термокаутеризацию и криопроцедуры), затем основал и более 20 лет возглавлял Амбулаторию аллергологии и клинической иммунологии. Почти два десятилетия руководил экспертным консилиумом по дерматовенерологии и аллергологии Черногории, с 1994 года — наставник на последипломных и специализационных программах по дерматовенерологии медицинского факультета в Белграде. С 2002 года имеет сертификат European Academy of Allergology and Clinical Immunology. Основатель и дважды президент Ассоциации дерматовенерологов Черногории. С 1 июля 2013 года ведёт приём в своём кабинете.',
	description_en = 'A specialist in dermatovenereology and subspecialist in allergology and clinical immunology with nearly four decades of medical practice, more than 30 years of it in dermatovenereology and more than 20 in allergology and clinical immunology. He graduated from the Faculty of Medicine in Belgrade in 1976 and worked at rural outpatient clinics in Nikšić, Kolašin and Golubovci and at the Emergency Centre of the Clinical Centre in Podgorica. He passed his specialist exam in dermatology and venereology in 1987 and his subspecialist exam in allergology and clinical immunology in 1990 at the Faculty of Medicine in Belgrade, where he defended his subspecialisation thesis in 1993. At the Dermatovenereology Clinic of the Clinical Centre of Montenegro he introduced laboratory diagnostics in dermatovenereology and physical skin procedures (thermocautery and cryotherapy), and then founded and for more than 20 years headed the Outpatient Clinic for Allergology and Clinical Immunology. For almost two decades he chaired Montenegro''s expert council for dermatovenereology and allergology, and since 1994 he has been a mentor in postgraduate and specialist dermatovenereology training at the Faculty of Medicine in Belgrade. Since 2002 he has held a certificate of the European Academy of Allergology and Clinical Immunology. He founded the Association of Dermatovenereologists of Montenegro and served two terms as its president. Since 1 July 2013 he has worked in his own practice.',
	description_de = 'Facharzt für Dermatovenerologie und Subspezialist für Allergologie und klinische Immunologie mit fast vier Jahrzehnten ärztlicher Tätigkeit, davon über 30 Jahre in der Dermatovenerologie und über 20 Jahre in Allergologie und klinischer Immunologie. Er schloss 1976 das Medizinstudium in Belgrad ab und arbeitete in Landambulanzen in Nikšić, Kolašin und Golubovci sowie im Notfallzentrum des Klinischen Zentrums in Podgorica. Die Facharztprüfung in Dermatologie und Venerologie legte er 1987 ab, die Subspezialisierungsprüfung in Allergologie und klinischer Immunologie 1990 an der Medizinischen Fakultät Belgrad, wo er 1993 auch seine Subspezialisierungsarbeit verteidigte. An der Klinik für Dermatovenerologie des Klinischen Zentrums Montenegros führte er die Labordiagnostik in der Dermatovenerologie und physikalische Hautverfahren (Thermokauterisation und Kryotherapie) ein und gründete danach die Ambulanz für Allergologie und klinische Immunologie, die er über 20 Jahre leitete. Fast zwei Jahrzehnte war er Leiter des Fachkonsiliums für Dermatovenerologie und Allergologie Montenegros; seit 1994 ist er Mentor in der postgradualen und fachärztlichen Ausbildung in Dermatovenerologie der Medizinischen Fakultät Belgrad. Seit 2002 besitzt er ein Zertifikat der European Academy of Allergology and Clinical Immunology. Er ist Gründer und zweifacher Präsident des Verbands der Dermatovenerologen Montenegros. Seit dem 1. Juli 2013 arbeitet er in seiner eigenen Praxis.',
	description_tr = 'Yaklaşık kırk yıllık hekimlik deneyimine sahip, bunun 30 yıldan fazlasını dermatovenerolojide ve 20 yıldan fazlasını alerji ve klinik immünolojide geçirmiş dermatovenereoloji uzmanı ve alerji–klinik immünoloji yan dal uzmanıdır. 1976''da Belgrad Tıp Fakültesi''ni bitirdi; Nikšić, Kolašin ve Golubovci''deki kırsal sağlık ocaklarında ve Podgorica Klinik Merkezi Acil Merkezi''nde çalıştı. Dermatoloji ve veneroloji uzmanlık sınavını 1987''de, alerji ve klinik immünoloji yan dal sınavını 1990''da Belgrad Tıp Fakültesi''nde verdi ve 1993''te yan dal tezini aynı fakültede savundu. Karadağ Klinik Merkezi Dermatoveneroloji Kliniği''nde dermatovenerolojide laboratuvar tanısını ve fiziksel cilt işlemlerini (termokoter ve kriyoterapi) başlattı, ardından Alerji ve Klinik İmmünoloji Polikliniği''ni kurarak 20 yılı aşkın süre yönetti. Yaklaşık yirmi yıl Karadağ dermatoveneroloji ve alerji uzman konseyine başkanlık etti; 1994''ten bu yana Belgrad Tıp Fakültesi dermatoveneroloji lisansüstü ve uzmanlık eğitiminde mentördür. 2002''den beri European Academy of Allergology and Clinical Immunology sertifikasına sahiptir. Karadağ Dermatovenerologlar Derneği''nin kurucusu ve iki dönem başkanıdır. 1 Temmuz 2013''ten beri kendi muayenehanesinde çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7), (@doctor_id, 79), (@doctor_id, 80);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatovenerolog, subspecijalista alergolog — klinički imunolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '10', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: velimir-kaludjerovic (7,79,80).
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
