-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dentalux (Tivat) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dentalux-tivat.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/dentalux-tivat.json):
--   * https://www.dentalux.me/ — самописная CMS (Web Center), версии me/en/ru. Прочитаны /me/, /me/O-nama/, /me/naš-tim/ и
--     3 страницы врачей, /me/usluge/ (5 статей /me/service/…), 7 разделов /me/обслуживание/<Раздел>/, акция
--     /me/IZBJELJIVANJE-ZUBA-ZOOM-LAMPOM/, /me/MENTORSTVO-U-ORTODONCIJI/. ⚠️ CMS отдаёт 200 и на несуществующий slug
--     (пустой шаблон 14 228 байт) — все использованные страницы непустые, с текстом раздела.
--   * ⚠️ Футер © 2019, фото врачей загружены в январе 2020 (timestamp в имени файла), страница менторства — 2024-05.
--     Состав мог устареть (dr Ivana Anđelić описана как «budući specijalista», специализация с 2017).
--   * data/google-places/tivat/stomatoloska-ordinacija-dentalux.json — place_id, координаты, телефон.
-- Адрес: сайт «Pod kuk bb, 85320 Tivat» = Google «Podkuk 85320». Телефоны — футер сайта; +382 69 086 740 совпадает с Google.
-- Viber/WhatsApp: строка футера «+382 69 086 740, +382 67 646 558 (Vib./WhatsApp)» — оба номера.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJe7RkFpYxTBMRHTr3t1ahdTY';
SET @clinic_slug = 'dentalux-tivat';

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
	4, -- CityId.TIVAT
	'Stomatološka ordinacija Dentalux',
	'Стоматолошка ординација Dentalux',
	'Стоматологический кабинет Dentalux',
	'Pod kuk bb',
	'Под кук бб',
	'',
	'',
	'85320',
	42.43790340,
	18.69970590,
	'+38232672262;+38269086740;+38267646558',
	'jasminka@dentalux.me',
	'https://www.dentalux.me/',
	'facebook.com/dentaluxtivat',
	'@dentalux_tivat',
	'',
	'+38269086740;+38267646558',
	'+38269086740;+38267646558',
	'https://www.dentalux.me/images/dentalux.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Dentalux', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Dentalux', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Pod kuk bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Под кук бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85320', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38232672262;+38269086740;+38267646558', phone),
	email = IF(email IS NULL OR email = '', 'jasminka@dentalux.me', email),
	website = IF(website IS NULL OR website = '', 'https://www.dentalux.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/dentaluxtivat', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@dentalux_tivat', instagram),
	whatsapp = IF(whatsapp IS NULL OR whatsapp = '', '+38269086740;+38267646558', whatsapp),
	viber = IF(viber IS NULL OR viber = '', '+38269086740;+38267646558', viber),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.dentalux.me/images/dentalux.png', logo_url),
	latitude = COALESCE(latitude, 42.43790340),
	longitude = COALESCE(longitude, 18.69970590)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Dentalux“ nalazi se u Tivtu, na adresi Pod kuk bb. Stomatološka zdravstvena ustanova „Dentalux“ osnovana je 1987. godine. U njoj ordiniraju prof. dr Jasminka Anđelić, specijalista ortopedije vilica, i prof. dr Snežana Matijević, specijalista dječje i preventivne stomatologije — obje su profesorke na Studijskom programu stomatologije Medicinskog fakulteta u Podgorici; ustanova angažuje i stručne konsultante iz drugih oblasti stomatologije. Ordinacija pruža usluge restaurativne stomatologije, protetike, ortodoncije (mobilni i fiksni aparati sa metalnim, keramičkim i lingvalnim bravicama, Invisalign folije), dječje i preventivne stomatologije, oralne hirurgije i implantologije, izbjeljivanje zuba Zoom lampom i u kućnim uslovima, nakit za zube i aplikaciju hijaluronske kiseline. Ordinacija ima dvije stomatološke stolice, a ispred nje je obezbijeđen prostor za parkiranje. Za hitne situacije i konsultacije pacijentima je dostupan kontakt 24 sata.',
	description_sr_cyrl = 'Стоматолошка ординација „Dentalux“ налази се у Тивту, на адреси Под кук бб. Стоматолошка здравствена установа „Dentalux“ основана је 1987. године. У њој ординирају проф. др Јасминка Анђелић, специјалиста ортопедије вилица, и проф. др Снежана Матијевић, специјалиста дјечје и превентивне стоматологије — обје су професорке на Студијском програму стоматологије Медицинског факултета у Подгорици; установа ангажује и стручне консултанте из других области стоматологије. Ординација пружа услуге рестауративне стоматологије, протетике, ортодонције (мобилни и фиксни апарати са металним, керамичким и лингвалним бравицама, Invisalign фолије), дјечје и превентивне стоматологије, оралне хирургије и имплантологије, избјељивање зуба Zoom лампом и у кућним условима, накит за зубе и апликацију хијалуронске киселине. Ординација има двије стоматолошке столице, а испред ње је обезбијеђен простор за паркирање. За хитне ситуације и консултације пацијентима је доступан контакт 24 сата.',
	description_ru = 'Стоматологический кабинет «Dentalux» находится в Тивате, в районе Под-Кук (Pod kuk bb). Стоматологическое учреждение «Dentalux» основано в 1987 году. Здесь принимают профессор Ясминка Анджелич, специалист по ортодонтии, и профессор Снежана Матиевич, специалист по детской и профилактической стоматологии, — обе преподают на программе «Стоматология» медицинского факультета в Подгорице; учреждение также привлекает консультантов из других областей стоматологии. Кабинет оказывает услуги терапевтической стоматологии, протезирования, ортодонтии (съёмные и несъёмные аппараты с металлическими, керамическими и лингвальными брекетами, элайнеры Invisalign), детской и профилактической стоматологии, хирургической стоматологии и имплантологии, отбеливание зубов лампой Zoom и в домашних условиях, украшения для зубов и введение гиалуроновой кислоты. В кабинете две стоматологические установки, перед входом есть парковка. Для экстренных случаев и консультаций пациентам круглосуточно доступен контактный телефон.',
	description_en = 'Dentalux is a dental practice in Tivat, at Pod kuk bb. The Dentalux dental healthcare institution was founded in 1987. Its practitioners are Prof. Dr Jasminka Anđelić, an orthodontics specialist, and Prof. Dr Snežana Matijević, a specialist in paediatric and preventive dentistry, both professors in the Dentistry programme at the Faculty of Medicine in Podgorica; the practice also engages consultants from other fields of dentistry. Services include restorative dentistry, prosthodontics, orthodontics (removable and fixed appliances with metal, ceramic and lingual brackets, Invisalign aligners), paediatric and preventive dentistry, oral surgery and implantology, Zoom lamp and at-home teeth whitening, tooth jewellery and hyaluronic acid injections. The practice has two dental chairs and parking in front of the building. A 24-hour contact is available for emergencies and consultations.',
	description_de = 'Dentalux ist eine Zahnarztpraxis in Tivat, Pod kuk bb. Die zahnmedizinische Einrichtung Dentalux wurde 1987 gegründet. Hier praktizieren Prof. Dr. Jasminka Anđelić, Fachärztin für Kieferorthopädie, und Prof. Dr. Snežana Matijević, Fachärztin für Kinder- und Präventivzahnheilkunde; beide lehren im Studiengang Zahnmedizin der Medizinischen Fakultät in Podgorica. Die Praxis zieht zudem Fachberater aus anderen Bereichen der Zahnmedizin hinzu. Angeboten werden restaurative Zahnheilkunde, Prothetik, Kieferorthopädie (herausnehmbare und festsitzende Apparaturen mit Metall-, Keramik- und Lingualbrackets, Invisalign-Aligner), Kinder- und Präventivzahnheilkunde, Oralchirurgie und Implantologie, Zahnaufhellung mit der Zoom-Lampe und für zu Hause, Zahnschmuck sowie Hyaluronsäure-Injektionen. Die Praxis verfügt über zwei Behandlungsstühle, vor dem Gebäude gibt es Parkplätze. Für Notfälle und Beratungen ist rund um die Uhr ein Kontakt erreichbar.',
	description_tr = 'Dentalux, Tivat''ta Pod kuk bb adresinde bulunan bir diş muayenehanesidir. Dentalux diş sağlığı kurumu 1987''de kuruldu. Burada ortodonti uzmanı Prof. Dr. Jasminka Anđelić ile çocuk ve koruyucu diş hekimliği uzmanı Prof. Dr. Snežana Matijević hasta kabul eder; ikisi de Podgorica Tıp Fakültesi Diş Hekimliği programında öğretim üyesidir. Kurum, diş hekimliğinin diğer alanlarından danışmanlarla da çalışır. Restoratif diş hekimliği, protez, ortodonti (metal, seramik ve lingual braketli hareketli ve sabit apareyler, Invisalign şeffaf plaklar), çocuk ve koruyucu diş hekimliği, ağız cerrahisi ve implantoloji, Zoom lambasıyla ve evde diş beyazlatma, diş takısı ve hiyalüronik asit uygulaması sunulur. Muayenehanede iki diş ünitesi bulunur, binanın önünde otopark vardır. Acil durumlar ve danışma için 24 saat ulaşılabilen bir iletişim hattı mevcuttur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (ru/en версии сайта — не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: на сайте не указаны («Pacijentima smo na usluzi 24h» — контакт для экстренных случаев, не график) — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3)
-- Состав — /me/naš-tim/ («Stomatolozi i konsultanti ordinacije»): 3 карточки. В БД никого из них нет (поиск по name_sr,
-- перевёрнутому имени и slug, 2026-10-09; Matijević есть только petar-matijevic — другой человек).
-- Специальности: 78 = DENTISTRY, 87 = PEDIATRIC_DENTISTRY, 93 = ORTHODONTIST. Языки: 1 = SR, 3 = EN.
-- Фото — внешние URL сайта, пробелы в имени файла закодированы %20 (проверено: 200 image/jpeg).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- prof. dr Jasminka Anđelić — Specijalista ortopedije vilica
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jasminka Anđelić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Anđelić Jasminka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jasminka-andjelic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'jasminka-andjelic', 'Jasminka Anđelić', 'Јасминка Анђелић', 'Ясминка Анджелич', 'Jasminka Andjelic', 'prof. dr',
	'https://www.dentalux.me/files/images/1580738315-FDSM8336-8%20(1).jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista ortopedije vilica, redovni profesor i rukovodilac Studijskog programa stomatologije na Medicinskom fakultetu u Podgorici; 2019. godine izabrana je i za vanrednog profesora na studiju dentalne medicine Medicinskog fakulteta Sveučilišta u Mostaru. Stomatološki fakultet u Beogradu završila je 1987. godine kao najbolji student generacije, a specijalistički ispit iz ortopedije vilica položila je 1998. godine na Stomatološkom fakultetu u Beogradu. Magistarski rad odbranila je 1999, a doktorsku disertaciju 2006. godine; zvanje primarijusa stekla je 2010, a zvanje profesora 2013. godine. Autorka je i koautorka više od 80 stručnih radova i monografije „Rasprostranjenost ortodontskih anomalija primorskog dijela Crne Gore“, a sprovela je više od 4000 stomatoloških tretmana. U ordinaciji „Dentalux“ vodi i program mentorstva za mlade specijaliste ortodoncije.',
	description_sr_cyrl = 'Специјалиста ортопедије вилица, редовни професор и руководилац Студијског програма стоматологије на Медицинском факултету у Подгорици; 2019. године изабрана је и за ванредног професора на студију денталне медицине Медицинског факултета Свеучилишта у Мостару. Стоматолошки факултет у Београду завршила је 1987. године као најбољи студент генерације, а специјалистички испит из ортопедије вилица положила је 1998. године на Стоматолошком факултету у Београду. Магистарски рад одбранила је 1999, а докторску дисертацију 2006. године; звање примаријуса стекла је 2010, а звање професора 2013. године. Ауторка је и коауторка више од 80 стручних радова и монографије „Распрострањеност ортодонтских аномалија приморског дијела Црне Горе“, а спровела је више од 4000 стоматолошких третмана. У ординацији „Dentalux“ води и програм менторства за младе специјалисте ортодонције.',
	description_ru = 'Специалист по ортодонтии, профессор и руководитель программы «Стоматология» медицинского факультета в Подгорице; в 2019 году также избрана ассоциированным профессором по дентальной медицине медицинского факультета Мостарского университета. В 1987 году окончила стоматологический факультет в Белграде лучшей на курсе, в 1998 году сдала там же специализационный экзамен по ортодонтии. Магистерскую диссертацию защитила в 1999 году, докторскую — в 2006 году; звание примариуса получила в 2010 году, звание профессора — в 2013 году. Автор и соавтор более 80 научных работ и монографии о распространённости ортодонтических аномалий в приморской части Черногории; провела более 4000 стоматологических курсов лечения. В кабинете «Dentalux» также ведёт программу наставничества для молодых ортодонтов.',
	description_en = 'Orthodontics specialist, full professor and head of the Dentistry programme at the Faculty of Medicine in Podgorica; in 2019 she was also elected associate professor in dental medicine at the Faculty of Medicine, University of Mostar. She graduated from the School of Dentistry in Belgrade in 1987 as the top student of her year and passed her specialist examination in orthodontics there in 1998. She defended her master''s thesis in 1999 and her doctoral dissertation in 2006, became a primarius in 2010 and a professor in 2013. She has authored or co-authored more than 80 professional papers and a monograph on the prevalence of orthodontic anomalies in coastal Montenegro, and has carried out more than 4,000 dental treatments. At Dentalux she also runs a mentoring programme for young orthodontists.',
	description_de = 'Fachärztin für Kieferorthopädie, ordentliche Professorin und Leiterin des Studiengangs Zahnmedizin an der Medizinischen Fakultät in Podgorica; 2019 wurde sie zudem zur außerordentlichen Professorin für Zahnmedizin an der Medizinischen Fakultät der Universität Mostar gewählt. Sie schloss 1987 das Zahnmedizinstudium in Belgrad als Jahrgangsbeste ab und legte dort 1998 die Facharztprüfung in Kieferorthopädie ab. 1999 verteidigte sie ihre Magisterarbeit, 2006 ihre Dissertation; 2010 erhielt sie den Titel Primarius, 2013 den Professorentitel. Sie ist Autorin oder Mitautorin von mehr als 80 Fachbeiträgen und einer Monografie über die Verbreitung kieferorthopädischer Anomalien an der montenegrinischen Küste und hat mehr als 4.000 zahnmedizinische Behandlungen durchgeführt. Bei Dentalux leitet sie außerdem ein Mentoring-Programm für junge Kieferorthopäden.',
	description_tr = 'Ortodonti uzmanı; Podgorica Tıp Fakültesi Diş Hekimliği programında profesör ve program yöneticisi. 2019''da Mostar Üniversitesi Tıp Fakültesi diş hekimliği bölümünde doçent olarak da seçildi. 1987''de Belgrad Diş Hekimliği Fakültesinden dönem birincisi olarak mezun oldu, 1998''de aynı fakültede ortodonti uzmanlık sınavını geçti. 1999''da yüksek lisans, 2006''da doktora tezini savundu; 2010''da primarius, 2013''te profesör unvanını aldı. 80''den fazla bilimsel çalışmanın ve Karadağ kıyı bölgesinde ortodontik anomalilerin yaygınlığına dair bir monografinin yazarı veya ortak yazarıdır; 4.000''den fazla diş tedavisi gerçekleştirmiştir. Dentalux''ta genç ortodontistler için bir mentorluk programı da yürütmektedir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
-- Только SR: английский на /me/MENTORSTVO-U-ORTODONCIJI/ заявлен для программы менторства, не для приёма пациентов (решение координатора 2026-10-09)
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Ivana Anđelić — Doktor dentalne medicine
-- ───────────────────────────────────────────────────────────────
-- «doktor dentalne medicine, budući specijalista ortopedije vilica» (специализацию начала в 2017) — ортодонтом не заводим, только 78.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivana Anđelić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Anđelić Ivana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivana-andjelic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'ivana-andjelic', 'Ivana Anđelić', 'Ивана Анђелић', 'Ивана Анджелич', 'Ivana Andjelic', 'dr',
	'https://www.dentalux.me/files/images/1580118562-dr%20Ivana%20Andjelic.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Doktor dentalne medicine. Stomatološki fakultet u Podgorici završila je 2014. godine, a 2017. upisala je specijalizaciju iz ortopedije vilica na Stomatološkom fakultetu Univerziteta u Beogradu. Magistrant je sa temom „Ponašanje djece kao determinanta oralnog zdravlja“. Pored rada u ordinaciji „Dentalux“ radi i u Savjetovalištu za djecu Doma zdravlja Tivat.',
	description_sr_cyrl = 'Доктор денталне медицине. Стоматолошки факултет у Подгорици завршила је 2014. године, а 2017. уписала је специјализацију из ортопедије вилица на Стоматолошком факултету Универзитета у Београду. Магистрант је са темом „Понашање дјеце као детерминанта оралног здравља“. Поред рада у ординацији „Dentalux“ ради и у Савјетовалишту за дјецу Дома здравља Тиват.',
	description_ru = 'Врач-стоматолог. В 2014 году окончила стоматологический факультет в Подгорице, в 2017 году поступила на специализацию по ортодонтии на стоматологический факультет Белградского университета. Пишет магистерскую работу о поведении детей как факторе здоровья полости рта. Помимо кабинета «Dentalux», работает в детской консультации Дома здоровья Тивата.',
	description_en = 'Doctor of dental medicine. She graduated from the School of Dentistry in Podgorica in 2014 and in 2017 began her specialisation in orthodontics at the School of Dentistry, University of Belgrade. Her master''s thesis is on children''s behaviour as a determinant of oral health. Besides Dentalux, she works at the children''s counselling unit of the Tivat health centre.',
	description_de = 'Zahnärztin. Sie schloss 2014 das Zahnmedizinstudium in Podgorica ab und begann 2017 die Fachausbildung in Kieferorthopädie an der Zahnmedizinischen Fakultät der Universität Belgrad. Ihre Magisterarbeit befasst sich mit dem Verhalten von Kindern als Determinante der Mundgesundheit. Neben Dentalux arbeitet sie in der Kinderberatungsstelle des Gesundheitszentrums Tivat.',
	description_tr = 'Diş hekimi. 2014''te Podgorica Diş Hekimliği Fakültesinden mezun oldu, 2017''de Belgrad Üniversitesi Diş Hekimliği Fakültesinde ortodonti uzmanlığına başladı. Yüksek lisans tezi, çocuk davranışının ağız sağlığının belirleyicisi olarak rolü üzerinedir. Dentalux''un yanı sıra Tivat Sağlık Merkezi çocuk danışma biriminde çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor dentalne medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- prof. dr Snežana Matijević — Specijalista dječje i preventivne stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Snežana Matijević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Matijević Snežana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'snezana-matijevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'snezana-matijevic', 'Snežana Matijević', 'Снежана Матијевић', 'Снежана Матиевич', 'Snezana Matijevic', 'prof. dr',
	'https://www.dentalux.me/files/images/1579874688-FDSM8383%20(1)-min.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista dječje i preventivne stomatologije i redovni profesor na Studijskom programu stomatologije Medicinskog fakulteta u Podgorici, gdje predaje preventivnu i dječju stomatologiju, povrede usta i zuba kod djece i menadžment u stomatologiji. Od 2006. do 2016. godine bila je direktor Doma zdravlja Tivat, a 2019. izabrana je za vanrednog profesora na studiju dentalne medicine Medicinskog fakulteta Sveučilišta u Mostaru. Stomatološki fakultet u Beogradu završila je 1987. godine, a specijalistički ispit iz dječje i preventivne stomatologije položila je 1998. godine. Magistarski rad odbranila je 1999, a doktorsku disertaciju „Definisanje modela za preventivnu stomatološku zaštitu odojčadi“ 2003. godine; zvanje primarijusa stekla je 2010. godine.',
	description_sr_cyrl = 'Специјалиста дјечје и превентивне стоматологије и редовни професор на Студијском програму стоматологије Медицинског факултета у Подгорици, гдје предаје превентивну и дјечју стоматологију, повреде уста и зуба код дјеце и менаџмент у стоматологији. Од 2006. до 2016. године била је директор Дома здравља Тиват, а 2019. изабрана је за ванредног професора на студију денталне медицине Медицинског факултета Свеучилишта у Мостару. Стоматолошки факултет у Београду завршила је 1987. године, а специјалистички испит из дјечје и превентивне стоматологије положила је 1998. године. Магистарски рад одбранила је 1999, а докторску дисертацију „Дефинисање модела за превентивну стоматолошку заштиту одојчади“ 2003. године; звање примаријуса стекла је 2010. године.',
	description_ru = 'Специалист по детской и профилактической стоматологии, профессор программы «Стоматология» медицинского факультета в Подгорице, где преподаёт профилактическую и детскую стоматологию, травмы полости рта и зубов у детей и менеджмент в стоматологии. В 2006–2016 годах была директором Дома здоровья Тивата, в 2019 году избрана ассоциированным профессором по дентальной медицине медицинского факультета Мостарского университета. В 1987 году окончила стоматологический факультет в Белграде, в 1998 году сдала специализационный экзамен по детской и профилактической стоматологии. Магистерскую диссертацию защитила в 1999 году, докторскую — о модели профилактической стоматологической помощи грудным детям — в 2003 году; звание примариуса получила в 2010 году.',
	description_en = 'Specialist in paediatric and preventive dentistry and full professor in the Dentistry programme at the Faculty of Medicine in Podgorica, where she teaches preventive and paediatric dentistry, oral and dental injuries in children and dental practice management. From 2006 to 2016 she was director of the Tivat health centre, and in 2019 she was elected associate professor in dental medicine at the Faculty of Medicine, University of Mostar. She graduated from the School of Dentistry in Belgrade in 1987 and passed her specialist examination in paediatric and preventive dentistry in 1998. She defended her master''s thesis in 1999 and her doctoral dissertation on a model of preventive dental care for infants in 2003, and became a primarius in 2010.',
	description_de = 'Fachärztin für Kinder- und Präventivzahnheilkunde und ordentliche Professorin im Studiengang Zahnmedizin der Medizinischen Fakultät in Podgorica, wo sie Präventiv- und Kinderzahnheilkunde, Mund- und Zahnverletzungen bei Kindern sowie Praxismanagement lehrt. Von 2006 bis 2016 leitete sie das Gesundheitszentrum Tivat; 2019 wurde sie zur außerordentlichen Professorin für Zahnmedizin an der Medizinischen Fakultät der Universität Mostar gewählt. Sie schloss 1987 das Zahnmedizinstudium in Belgrad ab und legte 1998 die Facharztprüfung in Kinder- und Präventivzahnheilkunde ab. 1999 verteidigte sie ihre Magisterarbeit, 2003 ihre Dissertation über ein Modell der zahnmedizinischen Prävention für Säuglinge; 2010 erhielt sie den Titel Primarius.',
	description_tr = 'Çocuk ve koruyucu diş hekimliği uzmanı; Podgorica Tıp Fakültesi Diş Hekimliği programında profesör olarak koruyucu ve çocuk diş hekimliği, çocuklarda ağız ve diş yaralanmaları ile diş hekimliğinde yönetim dersleri veriyor. 2006–2016 yılları arasında Tivat Sağlık Merkezi müdürlüğünü yürüttü, 2019''da Mostar Üniversitesi Tıp Fakültesi diş hekimliği bölümünde doçent olarak seçildi. 1987''de Belgrad Diş Hekimliği Fakültesinden mezun oldu, 1998''de çocuk ve koruyucu diş hekimliği uzmanlık sınavını geçti. 1999''da yüksek lisans tezini, 2003''te bebekler için koruyucu diş sağlığı modeli üzerine doktora tezini savundu; 2010''da primarius unvanını aldı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 87);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dječje i preventivne stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 4, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3 врач(а/ей): jasminka-andjelic, ivana-andjelic, snezana-matijevic.
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
