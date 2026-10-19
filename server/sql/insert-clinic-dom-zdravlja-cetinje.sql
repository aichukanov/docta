-- ═══════════════════════════════════════════════════════════════════════════
-- JZU Dom zdravlja Cetinje — клиника + врачи
-- Подволна 2b (дома здоровья), агент F. Сгенерировано 2026-10-08.
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-cetinje.sql
-- Затем: server/sql/insert-clinic-dom-zdravlja-cetinje-services.sql
--
-- Источники (curl, сырой HTML, 2026-10-08):
--   * https://www.dzcetinje.me/index.php/srp/ — Joomla: o-nama, timovi-izabranih-
--     doktora (+ страницы команд), ostale-jedinice (+ страницы служб), menadzment,
--     aktuelnosti (расписания ID на октябрь 2026, изображения);
--   * /images/dokumenta/Spisak_zaposlenih.pdf — «Pregled zaposlenih po
--     organizacionim jedinicama», напечатан 16.07.2025, 94 сотрудника;
--   * data/google-places/cetinje/dom-zdravlja-cetinje.json — place_id,
--     координаты, телефон.
--
-- Решения:
--   * Тип POLYCLINIC (1), язык только SR — как у всех ДЗ в БД.
--   * Адрес «Vuka Mićunovića 5» — /o-nama («na adresi Vuka Mićunovića broj 5»);
--     Google без номера дома. Почтовый индекс в источниках не указан — пусто.
--   * clinic_working_hours НЕ заполняется: график ID на октябрь 2026 даёт смены
--     07–14 и 14–21 в выходные, а страница «Raspored rada vikendom» — 08–12 и
--     15–19; для будних дней часы не названы (см. openQuestions).
--   * Службы ОБ «Danilo I» (клиника 88), которые работают в том же здании
--     (офтальмология, интернист, РТГ, лаборатория, ОРЛ, дерматология), — НЕ
--     услуги ДЗ и сюда не заведены.
--   * Физиотерапевты (3) заведены со специальностью Physiotherapy без титула —
--     так уже записаны физиотерапевты ДЗ Бар и ДЗ Котор.
--   * Boško Janković — sports_medicine (специальность 96 в справочнике есть).
--   * Не заведены: директор dr Marko Radović (doktor stomatologije, администрация),
--     психологи Marija Perišić и Sandra Ivanović, соцработник, специализанты
--     (5 по Spisku), медсёстры и техники.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания
-- пишутся безусловным UPDATE, языки клиники синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ49c5O17OTRMRuU4JnVePgbc';
SET @clinic_slug = 'dom-zdravlja-cetinje';

-- Поиск существующей клиники: google_place_id → slug → name_sr.
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr = 'Dom zdravlja Cetinje' LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
SELECT
	@clinic_slug, @google_place_id, 'published', 10, -- CityId.CETINJE
	'Dom zdravlja Cetinje', 'Дом здравља Цетиње', 'Дом здоровья Цетине',
	'Vuka Mićunovića 5', 'Вука Мићуновића 5', '', '', '',
	42.38960490, 18.92738180,
	'+38241231379', '', 'https://www.dzcetinje.me/', '', '', '', '', '',
	'https://www.dzcetinje.me/images/modules/logoDZv.png', NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));

-- Дозаполнение только пустых полей уже существующей записи; status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = COALESCE(latitude, 42.38960490),
	longitude = COALESCE(longitude, 18.92738180),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Дом здравља Цетиње', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Дом здоровья Цетине', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vuka Mićunovića 5', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Вука Мићуновића 5', address_sr_cyrl),
	phone = IF(phone IS NULL OR phone = '', '+38241231379', phone),
	website = IF(website IS NULL OR website = '', 'https://www.dzcetinje.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.dzcetinje.me/images/modules/logoDZv.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись (самоисправляемость). Правки из админки
-- следующий прогон файла перезатрёт — вносить их сюда.
UPDATE clinics SET
	description_sr = 'Dom zdravlja Cetinje je ustanova primarne zdravstvene zaštite. Kao poseban funkcionalni oblik osnovan je 1991. godine i od tada radi na istoj lokaciji, u blizini istorijskog jezgra Cetinja, u Ulici Vuka Mićunovića 5. Pored glavnog objekta ima ambulante na Rijeci Crnojevića, Čevu i Trešnjevu, a usluge pruža i na Njegušima. Organizacione jedinice su izabrani doktor za odrasle, djecu i žene, Centar za plućne bolesti i TBC, mikrobiološka dijagnostika, Centar za mentalno zdravlje, savjetovališta (populaciono, za mlade i za reproduktivno zdravlje), patronaža, fizikalna terapija, sanitetski prevoz, medicina rada, sportska medicina i hemodijaliza. Dom zdravlja izdaje ljekarska uvjerenja, a hemodijalizu pruža i strancima po posebnom cjenovniku. U istom objektu nalaze se Jedinica za hitnu medicinsku pomoć i službe Opšte bolnice Danilo I.',
	description_sr_cyrl = 'Дом здравља Цетиње је установа примарне здравствене заштите. Као посебан функционални облик основан је 1991. године и од тада ради на истој локацији, у близини историјског језгра Цетиња, у Улици Вука Мићуновића 5. Поред главног објекта има амбуланте на Ријеци Црнојевића, Чеву и Трешњеву, а услуге пружа и на Његушима. Организационе јединице су изабрани доктор за одрасле, дјецу и жене, Центар за плућне болести и ТБЦ, микробиолошка дијагностика, Центар за ментално здравље, савјетовалишта (популационо, за младе и за репродуктивно здравље), патронажа, физикална терапија, санитетски превоз, медицина рада, спортска медицина и хемодијализа. Дом здравља издаје љекарска увјерења, а хемодијализу пружа и странцима по посебном цјеновнику. У истом објекту налазе се Јединица за хитну медицинску помоћ и службе Опште болнице Данило I.',
	description_ru = 'Дом здоровья Цетине — государственное учреждение первичной медицинской помощи. Как самостоятельное учреждение основан в 1991 году и с тех пор работает на том же месте, рядом с историческим центром Цетине, на улице Вука Мичуновича, 5. Помимо главного здания, у него есть амбулатории в Риеке-Црноевича, Чеве и Трешневе, приём ведётся также в Негушах. В структуру входят избранные врачи для взрослых, детей и женщин, Центр лёгочных болезней и туберкулёза, микробиологическая диагностика, Центр психического здоровья, консультации (общая, для молодёжи и по репродуктивному здоровью), патронажная служба, физиотерапия, санитарный транспорт, медицина труда, спортивная медицина и гемодиализ. Дом здоровья выдаёт медицинские справки, а гемодиализ проводит и иностранцам по отдельному прейскуранту. В том же здании находятся отделение скорой помощи и службы Общей больницы «Данило I».',
	description_en = 'The Cetinje Health Centre (JZU Dom zdravlja Cetinje) is a public primary healthcare institution. It was established as a separate institution in 1991 and has worked at the same location ever since, near the historic core of Cetinje, at Vuka Mićunovića 5. Besides the main building, it has outpatient clinics in Rijeka Crnojevića, Čevo and Trešnjevo and also provides services in Njeguši. Its units are chosen doctors for adults, children and women, a Centre for Lung Diseases and TB, microbiology diagnostics, a Mental Health Centre, counselling services (general population, youth and reproductive health), home-visiting nursing, physical therapy, patient transport, occupational medicine, sports medicine and haemodialysis. The centre issues medical certificates and also provides haemodialysis to foreign nationals under a separate price list. The same building houses the emergency medical unit and services of the Danilo I General Hospital.',
	description_de = 'Das Gesundheitszentrum Cetinje (JZU Dom zdravlja Cetinje) ist eine öffentliche Einrichtung der primären Gesundheitsversorgung. Als eigenständige Einrichtung wurde es 1991 gegründet und arbeitet seitdem am selben Standort, nahe dem historischen Stadtkern von Cetinje, in der Straße Vuka Mićunovića 5. Neben dem Hauptgebäude unterhält es Ambulanzen in Rijeka Crnojevića, Čevo und Trešnjevo und bietet Leistungen auch in Njeguši an. Zu den Abteilungen gehören gewählte Ärzte für Erwachsene, Kinder und Frauen, ein Zentrum für Lungenkrankheiten und Tuberkulose, mikrobiologische Diagnostik, ein Zentrum für psychische Gesundheit, Beratungsstellen (allgemein, für Jugendliche und für reproduktive Gesundheit), Hauspflege, Physiotherapie, Krankentransport, Arbeitsmedizin, Sportmedizin und Hämodialyse. Das Zentrum stellt ärztliche Bescheinigungen aus und bietet Hämodialyse auch für Ausländer nach einer gesonderten Preisliste an. Im selben Gebäude befinden sich die Notfallambulanz und Abteilungen des Allgemeinkrankenhauses Danilo I.',
	description_tr = 'Cetinje Sağlık Merkezi (JZU Dom zdravlja Cetinje), birinci basamak sağlık hizmeti veren bir kamu kurumudur. 1991 yılında ayrı bir kurum olarak kurulmuş ve o zamandan beri Cetinje''nin tarihi merkezinin yakınında, Vuka Mićunovića 5 adresinde aynı yerde hizmet vermektedir. Ana binanın yanı sıra Rijeka Crnojevića, Čevo ve Trešnjevo''da poliklinikleri bulunur, Njeguši''de de hizmet verilir. Birimleri arasında yetişkinler, çocuklar ve kadınlar için seçilmiş doktorlar, Akciğer Hastalıkları ve Tüberküloz Merkezi, mikrobiyolojik tanı, Ruh Sağlığı Merkezi, danışma birimleri (genel nüfus, gençler ve üreme sağlığı), evde bakım hemşireliği, fizik tedavi, hasta nakli, iş hekimliği, spor hekimliği ve hemodiyaliz yer alır. Merkez sağlık raporları düzenler ve yabancı uyruklulara ayrı bir fiyat listesiyle hemodiyaliz hizmeti de sunar. Aynı binada acil tıp birimi ve Danilo I Genel Hastanesi''nin servisleri bulunur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPE, LANGUAGES, HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 — как у всех 11 ДЗ в БД.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) SELECT @clinic_id, 1 FROM dual WHERE @clinic_id IS NOT NULL;

-- clinic_languages без UNIQUE → синхронизация: оставить ровно одну строку SR.
-- Сайт о сопровождении на других языках не пишет.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE @clinic_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Рабочее время (clinic_working_hours) НЕ заполняется: часы будних дней не
-- названы, для выходных два противоречащих источника (08–12/15–19 и 07–14/14–21).
-- См. openQuestions.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Существующие — только привязка по slug. Новые — find-or-create:
-- slug → name_sr → перевёрнутое имя; специальности по specialties.name.
-- Фото на сайте нет → photo_url NULL.
-- ═══════════════════════════════════════════════════════════════

-- Страховка: slug существующих врачей, которых нет в этой БД. Ожидается ПУСТО.
SELECT x.s AS missing_existing_doctor FROM (SELECT 'tatjana-borilovic-stamenkovic' AS s UNION ALL SELECT 'aleksandra-perisic' UNION ALL SELECT 'lopicic-kascelan-ana' UNION ALL SELECT 'latkovic-djuro' UNION ALL SELECT 'ivan-ivanovic') x LEFT JOIN doctors d ON d.slug = x.s WHERE d.id IS NULL;

-- Branislava Marković — family_medicine. timovi-izabranih-doktora: «Dr Branislava Marković, spec. porodične medicine» (Spisak zaposlenih 07/2025: spec. opšte medicine); raspored ID oktobar 2026
SET @d = (SELECT id FROM doctors WHERE slug = 'branislava-markovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Branislava Marković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marković Branislava' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'branislava-markovic', 'Branislava Marković', 'Бранислава Марковић', 'Бранислава Маркович', 'Branislava Markovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'branislava-markovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('family_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Slavko Popović — general_medicine. timovi: «dr Slavko Popović, doktor medicine»; raspored ID oktobar 2026
SET @d = (SELECT id FROM doctors WHERE slug = 'slavko-popovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Slavko Popović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Popović Slavko' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slavko-popovic', 'Slavko Popović', 'Славко Поповић', 'Славко Попович', 'Slavko Popovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'slavko-popovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Vesna Peranović — general_medicine, family_medicine. timovi: «spec. opšte i porodične medicine»; raspored ID oktobar 2026 (i II smjena ID za djecu 08–09.10)
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-peranovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vesna Peranović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Peranović Vesna' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-peranovic', 'Vesna Peranović', 'Весна Перановић', 'Весна Перанович', 'Vesna Peranovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-peranovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine', 'family_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Tatjana Borilović Stamenković — существует в БД (tatjana-borilovic-stamenkovic), только привязка. timovi: «spec. opšte medicine»; raspored ID oktobar 2026
SET @d = (SELECT id FROM doctors WHERE slug = 'tatjana-borilovic-stamenkovic' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Marija Vuletić — general_medicine. timovi: «spec. opšte medicine»; raspored ID oktobar 2026
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-vuletic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marija Vuletić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vuletić Marija' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-vuletic', 'Marija Vuletić', 'Марија Вулетић', 'Мария Вулетич', 'Marija Vuletic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-vuletic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Boško Janković — sports_medicine. timovi: «spec. sportske medicine»; raspored ID oktobar 2026
SET @d = (SELECT id FROM doctors WHERE slug = 'bosko-jankovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Boško Janković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Janković Boško' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bosko-jankovic', 'Boško Janković', 'Бошко Јанковић', 'Бошко Янкович', 'Bosko Jankovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'bosko-jankovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('sports_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle (spec. sportske medicine)' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ivana Katnić — occupational_medicine. timovi: «spec. medicine rada»; raspored ID oktobar 2026
SET @d = (SELECT id FROM doctors WHERE slug = 'ivana-katnic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivana Katnić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Katnić Ivana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-katnic', 'Ivana Katnić', 'Ивана Катнић', 'Ивана Катнич', 'Ivana Katnic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ivana-katnic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('occupational_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle (spec. medicine rada)' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Aleksandra Perišić — существует в БД (aleksandra-perisic), только привязка. timovi: «spec. ginekologije i akušerstva»
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandra-perisic' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Biljana Ivelja — pediatrics. timovi: «spec. pedijatrije»; Spisak zaposlenih 07/2025
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-ivelja' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Biljana Ivelja' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivelja Biljana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-ivelja', 'Biljana Ivelja', 'Биљана Ивеља', 'Биляна Ивеля', 'Biljana Ivelja', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'biljana-ivelja' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Mirjana Iličković — pediatrics. timovi: «spec. pedijatar»; raspored ID djeca 05–11.10.2026
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-ilickovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mirjana Iličković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Iličković Mirjana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirjana-ilickovic', 'Mirjana Iličković', 'Мирјана Иличковић', 'Мирьяна Иличкович', 'Mirjana Ilickovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mirjana-ilickovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Danica Otašević — pediatrics. timovi: «spec. pedijatar»; raspored ID djeca 05–11.10.2026
SET @d = (SELECT id FROM doctors WHERE slug = 'danica-otasevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Danica Otašević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Otašević Danica' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'danica-otasevic', 'Danica Otašević', 'Даница Оташевић', 'Даница Оташевич', 'Danica Otasevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'danica-otasevic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ana Lopičić Kašćelan — существует в БД (lopicic-kascelan-ana), только привязка. Spisak zaposlenih 07/2025: «LOPIČIĆ KAŠĆELAN ANA, specijalista pedijatrije, izabrani doktor za djecu»; raspored ID djeca 05–11.10.2026
SET @d = (SELECT id FROM doctors WHERE slug = 'lopicic-kascelan-ana' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Mitar Popović — family_medicine. timovi (Djeca): «dr Mitar Popović, spec. porodične medicine» (Spisak 07/2025: spec. opšte medicine, IDO)
SET @d = (SELECT id FROM doctors WHERE slug = 'mitar-popovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mitar Popović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Popović Mitar' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mitar-popovic', 'Mitar Popović', 'Митар Поповић', 'Митар Попович', 'Mitar Popovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mitar-popovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('family_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Đuro Latković — существует в БД (latkovic-djuro), только привязка. raspored ID djeca 05–11.10.2026: II smjena 05.–06.10, I smjena 10.10
SET @d = (SELECT id FROM doctors WHERE slug = 'latkovic-djuro' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ivan Ivanović — существует в БД (ivan-ivanovic), только привязка. raspored ID djeca 05–11.10.2026: 11.10 (nedjelja)
SET @d = (SELECT id FROM doctors WHERE slug = 'ivan-ivanovic' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu (vikend)' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Žarko Nikčević — microbiology. ostale-jedinice: «dr Žarko Nikčević, spec. mikrobiolog»
SET @d = (SELECT id FROM doctors WHERE slug = 'zarko-nikcevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Žarko Nikčević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nikčević Žarko' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zarko-nikcevic', 'Žarko Nikčević', 'Жарко Никчевић', 'Жарко Никчевич', 'Zarko Nikcevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zarko-nikcevic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('microbiology') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Mikrobiološka dijagnostika' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ljiljana Ivanović Radoman — pulmonology. ostale-jedinice: «dr Ljiljana Ivanović Radoman, spec. pneumoftiziolog»
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-ivanovic-radoman' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ljiljana Ivanović Radoman' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivanović Radoman Ljiljana' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ljiljana-radoman' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'radoman-ljiljana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-ivanovic-radoman', 'Ljiljana Ivanović Radoman', 'Љиљана Ивановић Радоман', 'Лиляна Иванович Радоман', 'Ljiljana Ivanovic Radoman', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ljiljana-ivanovic-radoman' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pulmonology') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ana Đuranović — psychiatry. ostale-jedinice: «dr Ana Đuranović, spec. psihijatar»
SET @d = (SELECT id FROM doctors WHERE slug = 'ana-djuranovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ana Đuranović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Đuranović Ana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-djuranovic', 'Ana Đuranović', 'Ана Ђурановић', 'Ана Джуранович', 'Ana Djuranovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ana-djuranovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Milena Ivanović — internal_medicine. Spisak zaposlenih 07/2025: «IVANOVIĆ MILENA, specijalista interne medicine, doktor u odsjeku za hemodijalizu»
SET @d = (SELECT id FROM doctors WHERE slug = 'milena-ivanovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milena Ivanović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivanović Milena' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-ivanovic', 'Milena Ivanović', 'Милена Ивановић', 'Милена Иванович', 'Milena Ivanovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milena-ivanovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Odsjek za hemodijalizu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Mirjana Pravilović — Physiotherapy. ostale-jedinice: «Fizioterapeuti: Mirjana Pravilović, Snežana Radović, Slavica Joković»
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-pravilovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mirjana Pravilović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Pravilović Mirjana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirjana-pravilovic', 'Mirjana Pravilović', 'Мирјана Правиловић', 'Мирьяна Правилович', 'Mirjana Pravilovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mirjana-pravilovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Jedinica za fizikalnu terapiju (fizioterapeut)' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Snežana Radović — Physiotherapy. ostale-jedinice
SET @d = (SELECT id FROM doctors WHERE slug = 'snezana-radovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Snežana Radović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Radović Snežana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-radovic', 'Snežana Radović', 'Снежана Радовић', 'Снежана Радович', 'Snezana Radovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'snezana-radovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Jedinica za fizikalnu terapiju (fizioterapeut)' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Slavica Joković — Physiotherapy. ostale-jedinice
SET @d = (SELECT id FROM doctors WHERE slug = 'slavica-jokovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Slavica Joković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Joković Slavica' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slavica-jokovic', 'Slavica Joković', 'Славица Јоковић', 'Славица Йокович', 'Slavica Jokovic', '', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'slavica-jokovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('Physiotherapy') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Jedinica za fizikalnu terapiju (fizioterapeut)' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT c.id, c.slug, c.city_id, c.google_place_id, c.status,
	(SELECT GROUP_CONCAT(clinic_type_id) FROM clinic_clinic_types WHERE clinic_id = c.id) AS types,
	(SELECT GROUP_CONCAT(language_id) FROM clinic_languages WHERE clinic_id = c.id) AS langs,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c WHERE c.id = @clinic_id;

-- Ожидается 22 врачей (5 существующих + 17 новых).
SELECT COUNT(*) AS doctors_linked FROM doctor_clinics WHERE clinic_id = @clinic_id;

-- У каждого врача должна быть хотя бы одна специальность.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, dc.position,
	(SELECT GROUP_CONCAT(s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specs
FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @clinic_id ORDER BY dc.position, d.name_sr;
