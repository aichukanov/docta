-- Данные страховых компаний и их филиалов (схема — migrations/010-insurance-companies.sql,
-- контакты компании — 011, working_hours филиала — 012).
--
-- Собрано из официальных сайтов страховых (2026-07-18), координаты и часы
-- работы перепроверены и исправлены 2026-07-19 (см. 013-insurance-company-branches-geo-hours-fix.sql
-- для деталей по источникам и что именно изменилось). Телефоны/email —
-- чистые цифры с +382 без пробелов, несколько значений в одном поле через
-- ";" (как у клиник) — см. update-insurance-companies-phone-format.sql.
--
-- Sava: подтверждена официальным сайтом/новостями только часть городов —
-- Kotor/Cetinje/Danilovgrad/Ulcinj/Rožaje/Kolašin присутствие страховой не
-- вызывает сомнений, но точный адрес офиса найти не удалось, поэтому эти
-- города не включены (лучше меньше, чем неточный адрес).
--
-- Известные неподтверждённые координаты (оставлены как есть, нужна ручная
-- проверка в браузере): Generali/Berane (Teramska 5a), Grawe/Podgorica
-- (Bulevar Ivana Crnojevića 62/I, životno osiguranje).
--
-- ON DUPLICATE KEY UPDATE — повторный запуск скрипта безопасен.
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/insert-insurance-companies.sql

SET NAMES utf8mb4;

INSERT INTO insurance_companies (slug, name_sr, name_sr_cyrl, name_ru, website, phone, email, logo_url) VALUES
('sava', 'Sava osiguranje', 'Сава осигурање', 'Сава — страховая компания', 'https://www.sava.co.me', '+38220234008;+38220403020', 'info@sava.co.me', NULL),
('lovcen', 'Lovćen osiguranje', 'Ловћен осигурање', 'Ловчен — страховая компания', 'https://www.lovcen-osiguranje.me', '+38220404404', 'info@lo.co.me', NULL),
('uniqa', 'Uniqa osiguranje', 'Уника осигурање', 'Uniqa — страховая компания', 'https://www.uniqa.me', '+38220444700', 'info@uniqa.me', NULL),
('generali', 'Generali osiguranje', 'Генерали осигурање', 'Generali — страховая компания', 'https://www.generali.me', '+38220444800', 'kontakt@generali.me', NULL),
('grawe', 'Grawe osiguranje', 'Граве осигурање', 'Grawe — страховая компания', 'https://www.grawe.me', '+38220210960;+38220657300', 'info.zivot@grawe.me;info.nezivot@grawe.me', NULL)
ON DUPLICATE KEY UPDATE
	name_sr = VALUES(name_sr), name_sr_cyrl = VALUES(name_sr_cyrl), name_ru = VALUES(name_ru),
	website = VALUES(website), phone = VALUES(phone), email = VALUES(email);

-- ===================== Sava osiguranje =====================
-- Источники адресов: sava.co.me/kontakt, официальные новости об открытии
-- филиалов (Bar 2016, Pljevlja 2021, Podgorica retail 2020). Координаты и
-- часы работы — sava.co.me/me-me/mapa/radno-vrijeme/ (внутренний loc-list
-- API), Bar дополнительно подтверждён Google Maps, Budva — OSM.

INSERT INTO insurance_company_branches (insurance_company_id, city_id, address_sr, postal_code, latitude, longitude, phone, email, working_hours) VALUES
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 1, 'Ulica Svetlane Kane Radević br. 1', '81000', 42.439204, 19.257187, '+38220234008', 'info@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 1, 'Bulevar Save Kovačevića br. 4', '81000', 42.437043, 19.276244, '+38220640473', 'podgorica@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 7, 'Maršala Tita br. 42', '85000', 42.0960755, 19.0941132, '+38230319091', 'bar@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 3, 'Mediteranska ulica br. 59', '85310', 42.284655, 18.838467, NULL, 'budva@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 4, 'Ulica Dumidran br. 3, lokal 1', '85320', 42.429558, 18.699661, NULL, 'tivat@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 8, 'Njegoševa br. 30', '85340', 42.4518363, 18.5346917, NULL, 'hercegnovi@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 2, 'Njegoševa ulica br. 12', '81400', 42.773264, 18.948651, NULL, 'niksic@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 12, 'Tršova bb', '84000', 43.0332294, 19.7477837, NULL, 'bijelopolje@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 9, 'Miljana Vukova bb', '84300', 42.8432954, 19.8731086, NULL, 'berane@sava.co.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'sava'), 16, 'Skerlićeva ulica br. 10', '84210', 43.355405, 19.357194, NULL, 'pljevlja@sava.co.me', 'Pon-pet 08:00-16:00, sub 08:00-13:00');

-- ===================== Lovćen osiguranje =====================
-- Источники: lovcen-osiguranje.me, PlanPlus.rs (адреса), RTV Budva (адрес
-- филиала Budva). 8 официальных филиал по всей стране. Координаты Bijelo
-- Polje/Kotor/Budva перепроверены и исправлены (PlanPlus.rs + OSM, для
-- Budva — OSM POI c check_date=2026-04-04). Email — только общий info@lo.co.me
-- на уровне компании, отдельного per-branch email не найдено ни у одного
-- филиала.

INSERT INTO insurance_company_branches (insurance_company_id, city_id, address_sr, postal_code, latitude, longitude, phone, working_hours) VALUES
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 1, 'Ulica Slobode 13a', '81000', 42.4397993, 19.2625436, '+38220404404', 'Pon-pet 08:00-18:00, sub 08:00-14:00'),
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 2, 'Ivana Milutinovića 4', '81400', 42.7717503, 18.9493482, '+38240213404', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 9, 'Polimska 9', '84300', 42.8374530, 19.8705189, '+38251231888', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 16, 'Prijepoljska 16', '84210', 43.3530268, 19.3602947, '+38252321359', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 12, 'III Sandžačke 114', '84000', 43.033120, 19.739941, '+38250487105', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 6, 'Šuranj bb', '85330', 42.422130, 18.770575, '+38232301999', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 7, 'Beogradska 3', '85000', 42.0931842, 19.0990198, '+38230312755', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'lovcen'), 3, 'Jadranski put bb', '85310', 42.285371, 18.836171, '+38233403596', 'Pon-pet 08:00-16:00');

UPDATE insurance_company_branches SET email = 'infobd@lo.co.me'
WHERE insurance_company_id = (SELECT id FROM insurance_companies WHERE slug = 'lovcen') AND address_sr = 'Jadranski put bb';

-- ===================== Uniqa osiguranje =====================
-- Источник: uniqa.me/prodajna-mjesta (данные из data-locations виджета на
-- официальном сайте — первичный источник, координаты и email собственные
-- страховой). Часы работы — та же страница.

INSERT INTO insurance_company_branches (insurance_company_id, city_id, address_sr, postal_code, latitude, longitude, phone, email, working_hours) VALUES
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 1, 'Bulevar Džordža Vašingtona 98/4, The Capital Plaza', '81000', 42.4427864, 19.2453488, '+38220444700', 'info@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 1, 'Cetinjska 11/1', '81000', 42.440758, 19.242863, '+38267201449', 'poslovnica_pg@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 7, 'Jovana Tomaševića 15', '85000', 42.096872, 19.095508, '+38267201224', 'poslovnica_br@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 9, 'Njegošev trg, Nemanjina br. 1', '84300', 42.844742, 19.873573, '+38251232541', 'poslovnica_ba@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 12, 'Tršova L/D', '84000', 43.032940, 19.747871, '+38267201311', 'poslovnica_bp@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 3, 'Jadranski put bb', '85310', 42.288092, 18.840673, '+38233453300', 'poslovnica_bd@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 8, 'Braće Grbića 4', '85340', 42.459173, 18.525972, '+38267201243', 'poslovnica_hn@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 6, 'Jadranska 18, Dobrota', '85330', 42.432722, 18.770117, '+38267608542', 'poslovnica_ko@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 2, 'Bulevar 13. jula bb', '81400', 42.770073, 18.948291, '+38267201296', 'poslovnica_nk@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 16, 'Tršova bb', '84210', 43.355983, 19.359159, '+38267201484', 'poslovnica_pv@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 17, 'Maršala Tita 5', '84310', 42.843244, 20.168880, '+38267311992', 'poslovnica_ro@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 4, 'Trg Magnolija bb', '85320', 42.430087, 18.699410, '+38267608550', 'poslovnica_tv@uniqa.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'uniqa'), 5, 'Bulevar Skenderbega bb', '85360', 41.930386, 19.213623, '+38267219105', 'poslovnica_ul@uniqa.me', 'Pon-pet 08:00-16:00');

-- ===================== Generali osiguranje =====================
-- Источник: generali.me/kontakt/lokacije. Единый телефон/email для всех
-- офисов (страховая не публикует отдельные номера филиалов) — оставлены NULL,
-- в карточке используется общий контакт компании. Исключение — офис
-- урегулирования убытков (Serdara Jola Piletića), у него отдельный email.
-- Координаты Berane (Teramska 5a) не удалось независимо подтвердить —
-- свободные геокодеры не знают эту улицу, оставлена как есть до ручной
-- проверки в браузере.

INSERT INTO insurance_company_branches (insurance_company_id, city_id, address_sr, postal_code, latitude, longitude, email, working_hours) VALUES
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 1, 'Kralja Nikole 27a/VI', '81000', 42.4275430, 19.2559670, NULL, 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 1, 'Moskovska 77', '81000', 42.4441574, 19.2485810, NULL, 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 1, 'Serdara Jola Piletića br. 22', '81000', 42.4481620, 19.2586497, 'stete@generali.me', 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 7, 'Makedonska 3b', '85000', 42.0990436, 19.1046061, NULL, 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 9, 'Teramska 5a', '84300', 42.8428, 19.8733, NULL, 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 12, '3. januara bb', '84000', 43.0337398, 19.7473414, NULL, 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 8, 'Mića Vavića bb', '85340', 42.4578066, 18.5253870, NULL, 'Pon-pet 08:00-16:00'),
((SELECT id FROM insurance_companies WHERE slug = 'generali'), 16, 'Mila Peruničića bb', '84210', 43.3578118, 19.3575147, NULL, 'Pon-pet 08:00-16:00');

-- ===================== Grawe osiguranje =====================
-- Источник: grawe.me/kontakt. Единственный город присутствия — Podgorica,
-- два офиса (životno и neživotno osiguranje — разные юрлица группы). Часы
-- работы не найдены (сайт компании не отдаётся автоматическому фетчу).
-- Координаты životno-офиса (Bulevar Ivana Crnojevića 62/I) близки к нашей
-- константе центра города и не подтверждены однозначно — нужна ручная
-- проверка в браузере.

INSERT INTO insurance_company_branches (insurance_company_id, city_id, address_sr, postal_code, latitude, longitude, phone, email) VALUES
((SELECT id FROM insurance_companies WHERE slug = 'grawe'), 1, 'Bulevar Ivana Crnojevića 62/I', '81000', 42.4422497, 19.2682110, '+38220210960', 'info.zivot@grawe.me'),
((SELECT id FROM insurance_companies WHERE slug = 'grawe'), 1, 'Josipa Broza Tita 23a', '81000', 42.4334490, 19.2742116, '+38220657300', 'info.nezivot@grawe.me');
