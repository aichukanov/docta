-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Stojanović Medical (Berane) — клиника (врачей нет)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-stojanovic-medical-berane.sql
-- Затем: server/sql/insert-clinic-poliklinika-stojanovic-medical-berane-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://poliklinikastojanovic.me/ — WordPress/Elementor, читается через
--     wp-json /wp/v2/pages (19 страниц) и /wp/v2/posts (38 записей). Прайс
--     /cjenovnik-2/ (modified 2024-10-11) — в services-файле.
--   * data/google-places/berane/poliklinika-stojanovic-medical.json — place_id,
--     координаты, телефон (Google не перезапрашивался).
--
-- Сверка фактов:
--   * Адрес: /kontakt «43 Milorada Jovančevića, Berane 84300», Google
--     «43 Milorada Jovančevića, Беране 84300» — согласованы. ⚠️ Пост 2024-04-17
--     (гостевой гастроэнтеролог) пишет «Ul. Milorada Jovančevića 59» — не взято:
--     против него страница контактов и Google.
--   * Координаты 42.8505999 / 19.8663489 — Google Places, единственный источник.
--   * Телефоны: сайт «+382 67 103 043», «+382 51 233 222» (шапка всех страниц,
--     /kontakt); Google подтверждает первый.
--   * Email на сайте нет (ни mailto, ни адреса в тексте). Facebook-ссылки нет;
--     Instagram — футер: instagram.com/poliklinika.stojanovic.medical/.
--   * Часы: футер «RADNO VRIJEME 09:00-17:00» и пост 2024-04-17 «⏰ 09h – 17h» —
--     дни недели НЕ названы нигде. clinic_working_hours НЕ заполняется: какие дни
--     рабочие, источник не говорит (см. openQuestions в записи импорта).
--   * Языки клиники: только SR — сайт только на черногорском, о других языках
--     сопровождения ничего не пишет.
--   * Тип: POLYCLINIC (1) — клиника сама называет себя poliklinika; основное
--     направление — радиология, есть стоматология, гинекология, интернист.
--   * Врачей НЕТ: блок «Naše osoblje» — заглушки шаблона «Dr. Ime i Prezime /
--     Titule» ×4. Гостевые врачи из новостей (dr Predrag Štilet, dermatolog, разово
--     2023-02-25; dr sci. med. Velimir Milošević, gastroenterolog, разовые приёмы
--     2023–2024) составом не являются и не заводятся.
--   * Логотип — site icon WordPress 270×270 (круглый логотип клиники).
--
-- Маркетинговые превосходные степени («najsavremenije medicinske uređaje») в
-- описание не переносятся.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания
-- пишутся безусловным UPDATE (правки из админки следующий прогон перезатрёт —
-- вносить сюда), языки клиники синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJuSXfN7GTUhMRdCC_32memt0';
SET @clinic_slug = 'poliklinika-stojanovic-medical-berane';

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
	'Poliklinika Stojanović Medical',
	'Поликлиника Стојановић Medical', -- английское слово бренда не транслитерируем
	'Поликлиника Стоянович Medical',
	'Milorada Jovančevića 43',
	'Милорада Јованчевића 43',
	'',
	'',
	'84300',
	42.85059990,
	19.86634890,
	'+38267103043;+38251233222',
	'', -- на сайте нет
	'https://poliklinikastojanovic.me/',
	'', -- на сайте нет
	'@poliklinika.stojanovic.medical',
	'',
	'',
	'',
	'https://poliklinikastojanovic.me/wp-content/uploads/2022/11/cropped-Logo-Poliklinika-Stojanovia-Medical-270x270.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Стојановић Medical', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Стоянович Medical', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Milorada Jovančevića 43', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Милорада Јованчевића 43', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '84300', postal_code),
	latitude        = COALESCE(latitude, 42.85059990),
	longitude       = COALESCE(longitude, 19.86634890),
	phone           = IF(phone IS NULL OR phone = '', '+38267103043;+38251233222', phone),
	website         = IF(website IS NULL OR website = '', 'https://poliklinikastojanovic.me/', website),
	instagram       = IF(instagram IS NULL OR instagram = '', '@poliklinika.stojanovic.medical', instagram),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://poliklinikastojanovic.me/wp-content/uploads/2022/11/cropped-Logo-Poliklinika-Stojanovia-Medical-270x270.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что клиника пишет о себе:
-- naslovna («O nama», «Naše usluge»), страницы направлений, пост о стоматологии
-- (2024-08-06), пост про MR na teret Fonda (2022-03-31), saopštenje 2023-02-14.
UPDATE clinics SET
	description_sr = 'Poliklinika Stojanović Medical u Beranama počela je rad sa ultrazvučnom dijagnostikom, a danas je usmjerena prije svega na radiologiju: magnetnu rezonancu, MSCT skener, digitalni rendgen, ultrazvuk i kolor dopler krvnih sudova te mamografiju. Pregled magnetnom rezonancom može se obaviti i na teret Fonda za zdravstveno osiguranje Crne Gore, uz uput izabranog ljekara i odobren konzilijum za MR dijagnostiku. U okviru poliklinike radi i stomatološka ordinacija (restorativna stomatologija, endodoncija, oralna hirurgija, protetika na implantima, ortodoncija) sa 2D i 3D ortopanom i dentalnim snimcima, kao i ginekologija sa perinatologijom i internistička ambulanta.',
	description_sr_cyrl = 'Поликлиника Стојановић Medical у Беранама почела је рад са ултразвучном дијагностиком, а данас је усмјерена прије свега на радиологију: магнетну резонанцу, MSCT скенер, дигитални рендген, ултразвук и колор доплер крвних судова те мамографију. Преглед магнетном резонанцом може се обавити и на терет Фонда за здравствено осигурање Црне Горе, уз упут изабраног љекара и одобрен конзилијум за MR дијагностику. У оквиру поликлинике ради и стоматолошка ординација (рестауративна стоматологија, ендодонција, орална хирургија, протетика на имплантима, ортодонција) са 2D и 3D ортопаном и денталним снимцима, као и гинекологија са перинатологијом и интернистичка амбуланта.',
	description_ru = 'Поликлиника Stojanović Medical в Беране начинала с ультразвуковой диагностики, а сегодня работает прежде всего в области лучевой диагностики: МРТ, мультиспиральная КТ, цифровой рентген, УЗИ и цветное допплеровское исследование сосудов, маммография. МРТ можно пройти и за счёт Фонда медицинского страхования Черногории — по направлению выбранного врача и при одобрении консилиума для МР-диагностики. При поликлинике работает стоматологический кабинет (реставрационная стоматология, эндодонтия, хирургическая стоматология, протезирование на имплантах, ортодонтия) с 2D- и 3D-ортопантомографом и прицельными снимками зубов, а также гинекология с перинатологией и кабинет терапевта-интерниста.',
	description_en = 'Stojanović Medical Polyclinic in Berane started out with ultrasound diagnostics and today focuses mainly on radiology: MRI, multislice CT, digital X-ray, ultrasound and colour Doppler of blood vessels, and mammography. MRI scans can also be covered by the Health Insurance Fund of Montenegro with a referral from the chosen doctor and an approved MR diagnostics panel. The polyclinic also has a dental office (restorative dentistry, endodontics, oral surgery, implant prosthetics, orthodontics) with 2D and 3D panoramic and intraoral dental X-rays, as well as gynaecology with perinatology and an internal medicine practice.',
	description_de = 'Die Poliklinik Stojanović Medical in Berane begann mit der Ultraschalldiagnostik und konzentriert sich heute vor allem auf die Radiologie: MRT, Mehrschicht-CT, digitales Röntgen, Ultraschall und Farbdoppler der Blutgefäße sowie Mammographie. MRT-Untersuchungen können auch über den Krankenversicherungsfonds Montenegros abgerechnet werden, mit Überweisung des gewählten Arztes und genehmigtem Konsilium für die MR-Diagnostik. Zur Poliklinik gehören außerdem eine Zahnarztpraxis (restaurative Zahnheilkunde, Endodontie, Oralchirurgie, Implantatprothetik, Kieferorthopädie) mit 2D- und 3D-Panoramaröntgen und Zahnfilmen sowie Gynäkologie mit Perinatologie und eine internistische Ambulanz.',
	description_tr = 'Berane''deki Stojanović Medical Polikliniği ultrason tanısıyla çalışmaya başlamış olup bugün ağırlıklı olarak radyoloji alanında hizmet verir: MR, çok kesitli BT, dijital röntgen, ultrason ve kan damarlarının renkli Doppler incelemesi ile mamografi. MR incelemesi, seçilen hekimin sevki ve MR tanısı için onaylanmış konsültasyon kurulu kararıyla Karadağ Sağlık Sigortası Fonu kapsamında da yaptırılabilir. Poliklinikte ayrıca 2D ve 3D panoramik ile dental röntgen imkânına sahip bir diş hekimliği muayenehanesi (restoratif diş hekimliği, endodonti, ağız cerrahisi, implant üstü protez, ortodonti), perinatoloji ile birlikte jinekoloji ve dahiliye polikliniği bulunur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы НЕ заполняются: «RADNO VRIJEME 09:00-17:00» без дней недели.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 9, status = published, languages = 1, types = 1, hours = 0.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 0 врачей.
SELECT COUNT(*) AS doctors_linked FROM doctor_clinics WHERE clinic_id = @clinic_id;
