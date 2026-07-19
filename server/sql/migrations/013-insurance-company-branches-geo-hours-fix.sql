-- Исправляет координаты филиалов, которые при исходном импорте (см.
-- insert-insurance-companies.sql) откатились на центр города вместо
-- реального адреса — обнаружено пользователем на примере Sava в Баре
-- (пин был в ~500м от настоящего офиса). Заодно:
--   - у Sava пять адресов оказались устаревшими относительно официального
--     сайта компании (переезд/переименование улицы) — обновлены вместе
--     с координатами, чтобы текст адреса не расходился с пином на карте;
--   - добавлены рабочие часы (working_hours, миграция 012) и email там,
--     где найден настоящий адрес-специфичный контакт, а не просто дубль
--     общего телефона/email компании;
--   - координаты, которые при перепроверке не подтвердились уверенно
--     (Generali/Berane, Grawe/Podgorica-62), оставлены как есть — см.
--     комментарии на месте.
--
-- Источники — сайты компаний (sava.co.me, lo.co.me), OpenStreetMap/Nominatim,
-- PlanPlus.rs, независимая проверка через Google Maps (см. историю чата).
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/013-insurance-company-branches-geo-hours-fix.sql

SET NAMES utf8mb4;

-- ===================== Sava osiguranje =====================
-- Координаты — sava.co.me/me-me/mapa/radno-vrijeme/ (внутренний loc-list API),
-- перекрёстно подтверждены Google Maps (Bar) и OSM (Budva).

UPDATE insurance_company_branches SET
	latitude = 42.439204, longitude = 19.257187,
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 1; -- Podgorica, Ulica Svetlane Kane Radević br. 1

UPDATE insurance_company_branches SET
	address_sr = 'Bulevar Save Kovačevića br. 4',
	latitude = 42.437043, longitude = 19.276244,
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 2; -- Podgorica — адрес на сайте компании сейчас другой (переезд)

UPDATE insurance_company_branches SET
	latitude = 42.0960755, longitude = 19.0941132,
	email = 'bar@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 3; -- Bar — подтверждено пользователем через Google Maps

UPDATE insurance_company_branches SET
	address_sr = 'Mediteranska ulica br. 59',
	latitude = 42.284655, longitude = 18.838467,
	email = 'budva@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 4; -- Budva — адрес на сайте компании сейчас другой

UPDATE insurance_company_branches SET
	address_sr = 'Ulica Dumidran br. 3, lokal 1',
	latitude = 42.429558, longitude = 18.699661,
	email = 'tivat@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 5; -- Tivat — адрес на сайте компании сейчас другой

UPDATE insurance_company_branches SET
	latitude = 42.4518363, longitude = 18.5346917,
	email = 'hercegnovi@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 6; -- Herceg Novi

UPDATE insurance_company_branches SET
	address_sr = 'Njegoševa ulica br. 12',
	latitude = 42.773264, longitude = 18.948651,
	email = 'niksic@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 7; -- Nikšić — адрес на сайте компании сейчас другой

UPDATE insurance_company_branches SET
	latitude = 43.0332294, longitude = 19.7477837,
	email = 'bijelopolje@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 8; -- Bijelo Polje

UPDATE insurance_company_branches SET
	address_sr = 'Miljana Vukova bb',
	latitude = 42.8432954, longitude = 19.8731086,
	email = 'berane@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 9; -- Berane — адрес на сайте компании сейчас другой

UPDATE insurance_company_branches SET
	latitude = 43.355405, longitude = 19.357194,
	email = 'pljevlja@sava.co.me',
	working_hours = 'Pon-pet 08:00-16:00, sub 08:00-13:00'
WHERE id = 10; -- Pljevlja — единственный филиал с рабочей субботой

-- ===================== Lovćen osiguranje =====================
-- Bijelo Polje/Kotor были на константе центра города — исправлено (PlanPlus.rs
-- + OSM сходятся с точностью до ~15м). Budva не была помечена подозрительной,
-- но при проверке оказалась в ~1.7км от реального адреса (OSM POI с
-- check_date=2026-04-04) — тоже исправлена. Email не найден отдельно на
-- филиал — общий info@lo.co.me уже задан на уровне компании и используется
-- как fallback в интерфейсе.

UPDATE insurance_company_branches SET working_hours = 'Pon-pet 08:00-18:00, sub 08:00-14:00' WHERE id = 11; -- Podgorica (glavna filijala)
UPDATE insurance_company_branches SET working_hours = 'Pon-pet 08:00-16:00' WHERE id = 12; -- Nikšić
UPDATE insurance_company_branches SET working_hours = 'Pon-pet 08:00-16:00' WHERE id = 13; -- Berane
UPDATE insurance_company_branches SET working_hours = 'Pon-pet 08:00-16:00' WHERE id = 14; -- Pljevlja

UPDATE insurance_company_branches SET
	latitude = 43.033120, longitude = 19.739941,
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 15; -- Bijelo Polje — была на константе центра города

UPDATE insurance_company_branches SET
	latitude = 42.422130, longitude = 18.770575,
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 16; -- Kotor — была на константе центра города

UPDATE insurance_company_branches SET working_hours = 'Pon-pet 08:00-16:00' WHERE id = 17; -- Bar

UPDATE insurance_company_branches SET
	latitude = 42.285371, longitude = 18.836171,
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 18; -- Budva — не была помечена подозрительной, но оказалась в ~1.7км от реального адреса

-- ===================== Generali osiguranje =====================
-- Единственная подозрительная точка (Berane, id 36) не подтвердилась и не
-- опроверглась — свободные геокодеры не знают улицу "Teramska" в Berane,
-- страница компании не отдаётся автоматическому фетчу. Оставлена как есть,
-- нужна ручная проверка в браузере. У claims-офиса (id 34) есть отдельный,
-- более специфичный email — сохранён, у остальных email не трогаем (есть
-- общий kontakt@generali.me на уровне компании).

UPDATE insurance_company_branches SET working_hours = 'Pon-pet 08:00-16:00' WHERE id IN (32, 33, 35, 36, 37, 38, 39);
UPDATE insurance_company_branches SET
	email = 'stete@generali.me',
	working_hours = 'Pon-pet 08:00-16:00'
WHERE id = 34; -- Serdara Jola Piletića — likvidacija šteta, отдельный email

-- ===================== Uniqa osiguranje =====================
-- Координаты и email уже были из первичного источника (виджет на uniqa.me) —
-- при выборочной проверке 4 из 13 подтвердились точно, остальные не трогаем.
-- Добавлены только рабочие часы (со страницы uniqa.me/prodajna-mjesta).

UPDATE insurance_company_branches
SET working_hours = 'Pon-pet 08:00-16:00'
WHERE id BETWEEN 19 AND 31;

-- ===================== Grawe osiguranje =====================
-- Единственная подозрительная точка (Bulevar Ivana Crnojevića 62, id 40) не
-- подтвердилась и не опроверглась однозначно — сайт компании отдаёт 403
-- автоматическому фетчу, у OSM нет данных по этому номеру дома. Оставлена
-- как есть, нужна ручная проверка в браузере. Рабочие часы не найдены ни
-- для одного из двух офисов.
