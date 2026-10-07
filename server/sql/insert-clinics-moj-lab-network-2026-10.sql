-- ═══════════════════════════════════════════════════════════════════════════
-- Moj Lab: остальная сеть + Ulcinj раздельно + переименование педиатрии (2026-10-02)
-- Применять ПОСЛЕ update-clinics-moj-lab-2026-10.sql.
--
-- Источник — https://mojlab.me/lokacije/* (17 локаций в sitemap.xml, проверка
-- 2026-10-02). У нас было 5, этот файл добавляет 12:
--   Bolnica (Donja Gorica), лаборатории Podgorica-Moskovska, City kvart, Budva,
--   Ulcinj, Cetinje, Herceg Novi, Kotor, Nikšić, Tivat; педиатрия Budva и Ulcinj.
-- Совпадающий адрес с уже существующими клиниками сети — норма: на сайте это
-- отдельные локации со своими часами и email (решение юзера).
--
-- Поля — по аналогии с пятью существующими клиниками сети: phone = call-центр
-- 19989, email и часы со страницы локации, website = страница локации, логотип
-- общий (у всех пяти один и тот же файл, копируется с moj-lab-podgorica-1),
-- clinic_languages только SR, description_* пустые, google_place_id NULL.
-- Типы: лаборатория — 4; педиатрия — 12+1 (как mansa-medica-tivat); больница —
-- 1+3 (как codra-hospital-podgorica: поликлиника при больнице заявлена отдельно).
--
-- Координаты:
--   * точки по адресу существующей клиники сети берут её координаты подзапросом
--     (City kvart ← педиатрия Podgorica; Budva ← moj-lab-budva; Ulcinj ← moj-lab-ulcinj);
--   * Moskovska, Herceg Novi — точка места из embed Google Maps (формат !1m14 даёт
--     координаты места, сверено с data/google-places на Budva и Donja Gorica);
--   * Cetinje, Kotor — embed формата !1m18, у которого центр сдвинут по долготе;
--     сдвиг (+0.0026°) откалиброван по Budva и Ulcinj из той же сессии embed'ов
--     (18.03.2024), проверка на Tivat: 13 м до OSM;
--   * Tivat — OSM «Trg od kulture»;
--   * Bolnica — embed !1m18 с крупным масштабом (1d=711), поправка +0.0006°;
--   * Nikšić — середина улицы Nikole Tesle по OSM (улица ~250 м). Embed на сайте
--     показывает всю область, точку из него взять нельзя. ПРИБЛИЗИТЕЛЬНО, ±150 м.
--
-- Ulcinj: наша moj-lab-ulcinj ссылается на поликлинику, а часы у неё стояли
-- лабораторные (пн–пт 07–14, сб 08–13). Часы лаборатории уходят в новую запись
-- moj-lab-laboratorija-ulcinj, поликлинике — её часы с сайта (пн–сб 08–20;
-- воскресенье на сайте не указано → закрыто).
--
-- Педиатрия: опечатка «Pedijatria» в name_sr и slug. Старый слаг → slug_redirects
-- (как saveSlugRedirect в server/common/slug-db.ts), новый удаляется из
-- редиректов, если вдруг там был.
--
-- Идемпотентно: клиники вставляются только по отсутствующему slug, связи — по
-- отсутствию пары, UPDATE часов и переименование — с условием на старое значение.
-- Клиники только по slug (id локально и на проде расходятся).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

START TRANSACTION;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: 12 новых клиник
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_mojlab;
CREATE TEMPORARY TABLE tmp_mojlab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	city_id INT NOT NULL,
	name_sr VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	name_sr_cyrl VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	address_sr VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	address_sr_cyrl VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	town_sr VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	town_sr_cyrl VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	postal_code VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	latitude DECIMAL(10,8) NULL,
	longitude DECIMAL(11,8) NULL,
	coord_src_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	email VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	website VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	types VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	h_mon VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	h_tue VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	h_wed VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	h_thu VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	h_fri VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	h_sat VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	h_sun VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);

SET @closed = '{"type": "closed"}';
SET @h24 = '{"type": "24/7"}';
SET @h0720 = '{"type": "regular", "intervals": [{"start": "07:00", "end": "20:00"}]}';
SET @h0820 = '{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}';
SET @h0817 = '{"type": "regular", "intervals": [{"start": "08:00", "end": "17:00"}]}';
SET @h0813 = '{"type": "regular", "intervals": [{"start": "08:00", "end": "13:00"}]}';
SET @h0821 = '{"type": "regular", "intervals": [{"start": "08:00", "end": "21:00"}]}';
SET @h0715 = '{"type": "regular", "intervals": [{"start": "07:00", "end": "15:00"}]}';
SET @h0815 = '{"type": "regular", "intervals": [{"start": "08:00", "end": "15:00"}]}';
SET @h0714 = '{"type": "regular", "intervals": [{"start": "07:00", "end": "14:00"}]}';
SET @h0814 = '{"type": "regular", "intervals": [{"start": "08:00", "end": "14:00"}]}';

INSERT INTO tmp_mojlab VALUES
-- Bolnica 24/7 (поликлиника при ней ежедневно 07–22, у больницы как места — круглосуточно)
('moj-lab-bolnica-podgorica', 1, 'Moj Lab Bolnica Podgorica', 'Мој Лаб Болница (Подгорица)',
	'Bulevar 21. maj, Donja Gorica', 'Булевар 21. мај, Доња Горица', '', '', '81000',
	42.42221764, 19.21575000, NULL,
	'bolnica@mojlab.me', 'https://mojlab.me/lokacije/bolnica', '1,3',
	@h24, @h24, @h24, @h24, @h24, @h24, @h24),
-- Laboratorija Podgorica (Moskovska): пн–пт 07–20, сб 08–20, вс 08–17
('moj-lab-laboratorija-podgorica-moskovska', 1, 'Moj Lab Laboratorija Podgorica Moskovska', 'Мој Лаб Лабораторија (Подгорица, Московска)',
	'Moskovska 2b', 'Московска 2б', '', '', '81000',
	42.44026710, 19.24710420, NULL,
	'laboratorija@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-podgorica', '4',
	@h0720, @h0720, @h0720, @h0720, @h0720, @h0820, @h0817),
-- Laboratorija City kvart (в здании педиатрии): пн–сб 08–20, вс 08–13
('moj-lab-laboratorija-city-kvart', 1, 'Moj Lab Laboratorija City kvart', 'Мој Лаб Лабораторија (Сити кварт)',
	'Vojvode Maša Đurovića bb', 'Војводе Маша Ђуровића бб', '', '', '81000',
	NULL, NULL, 'moj-lab-pedijatria-podgorica',
	'laboratorija@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-city-kvart', '4',
	@h0820, @h0820, @h0820, @h0820, @h0820, @h0820, @h0813),
-- Laboratorija Budva: пн–пт 07–20, сб–вс 08–20
('moj-lab-laboratorija-budva', 3, 'Moj Lab Laboratorija Budva', 'Мој Лаб Лабораторија (Будва)',
	'Filipa Kovačevića bb', 'Филипа Ковачевића бб', '', '', '85310',
	NULL, NULL, 'moj-lab-budva',
	'laboratorija.bd@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-budva', '4',
	@h0720, @h0720, @h0720, @h0720, @h0720, @h0820, @h0820),
-- Laboratorija Ulcinj: пн–пт 07–14, сб 08–13 (часы, которые раньше стояли у moj-lab-ulcinj)
('moj-lab-laboratorija-ulcinj', 5, 'Moj Lab Laboratorija Ulcinj', 'Мој Лаб Лабораторија (Улцињ)',
	'Đeranje 1', 'Ђерање 1', '', '', '85360',
	NULL, NULL, 'moj-lab-ulcinj',
	'laboratorija.ul@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-ulcinj', '4',
	@h0714, @h0714, @h0714, @h0714, @h0714, @h0813, @closed),
-- Laboratorija Cetinje: пн–пт 07–15, сб 08–15
('moj-lab-laboratorija-cetinje', 10, 'Moj Lab Laboratorija Cetinje', 'Мој Лаб Лабораторија (Цетиње)',
	'Vuka Mićunovića bb', 'Вука Мићуновића бб', '', '', '81250',
	42.38975217, 18.92680668, NULL,
	'laboratorija.ct@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-cetinje', '4',
	@h0715, @h0715, @h0715, @h0715, @h0715, @h0815, @closed),
-- Laboratorija Herceg Novi (Meljine): пн–пт 07–15, сб 08–15
('moj-lab-laboratorija-herceg-novi', 8, 'Moj Lab Laboratorija Herceg Novi', 'Мој Лаб Лабораторија (Херцег Нови)',
	'Braće Pedišić 16', 'Браће Педишић 16', 'Meljine', 'Мељине', '85340',
	42.45499890, 18.55923410, NULL,
	'laboratorija.hn@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-herceg-novi', '4',
	@h0715, @h0715, @h0715, @h0715, @h0715, @h0815, @closed),
-- Laboratorija Kotor (Dobrota): пн–пт 07–15, сб 08–15
('moj-lab-laboratorija-kotor', 6, 'Moj Lab Laboratorija Kotor', 'Мој Лаб Лабораторија (Котор)',
	'bb', 'бб', 'Dobrota', 'Доброта', '85330',
	42.43515547, 18.76992188, NULL,
	'laboratorija.ko@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-kotor', '4',
	@h0715, @h0715, @h0715, @h0715, @h0715, @h0815, @closed),
-- Laboratorija Nikšić: пн–пт 07–15, сб 08–15
('moj-lab-laboratorija-niksic', 2, 'Moj Lab Laboratorija Nikšić', 'Мој Лаб Лабораторија (Никшић)',
	'Nikole Tesle 1', 'Николе Тесле 1', '', '', '81400',
	42.77464070, 18.95563110, NULL,
	'laboratorija.nk@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-niksic', '4',
	@h0715, @h0715, @h0715, @h0715, @h0715, @h0815, @closed),
-- Laboratorija Tivat: пн–пт 07–14, сб 08–14
('moj-lab-laboratorija-tivat', 4, 'Moj Lab Laboratorija Tivat', 'Мој Лаб Лабораторија (Тиват)',
	'Trg od kulture', 'Трг од културе', '', '', '85320',
	42.43091110, 18.69618250, NULL,
	'laboratorija.tv@mojlab.me', 'https://mojlab.me/lokacije/laboratorija-tivat', '4',
	@h0714, @h0714, @h0714, @h0714, @h0714, @h0814, @closed),
-- Pedijatrija Budva: ежедневно 08–21
('moj-lab-pedijatrija-budva', 3, 'Moj Lab Pedijatrija Budva', 'Мој Лаб Педијатрија (Будва)',
	'Filipa Kovačevića bb', 'Филипа Ковачевића бб', '', '', '85310',
	NULL, NULL, 'moj-lab-budva',
	'pedijatrija@mojlab.me', 'https://mojlab.me/lokacije/pedijatrija-budva', '12,1',
	@h0821, @h0821, @h0821, @h0821, @h0821, @h0821, @h0821),
-- Pedijatrija Ulcinj: ежедневно 08–20
('moj-lab-pedijatrija-ulcinj', 5, 'Moj Lab Pedijatrija Ulcinj', 'Мој Лаб Педијатрија (Улцињ)',
	'Đeranje 1', 'Ђерање 1', '', '', '85360',
	NULL, NULL, 'moj-lab-ulcinj',
	'pedijatrija@mojlab.me', 'https://mojlab.me/lokacije/pedijatrija-ulcinj', '12,1',
	@h0820, @h0820, @h0820, @h0820, @h0820, @h0820, @h0820);

-- Координатный источник педиатрии Podgorica до и после переименования (PART 3) —
-- одна запись; COALESCE ниже покрывает повторный прогон после переименования.
INSERT INTO clinics (
	slug, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	description_sr, description_sr_cyrl, description_ru, description_en, description_de, description_tr,
	logo_url
)
SELECT
	t.slug, 'published', t.city_id,
	t.name_sr, t.name_sr_cyrl, '',
	t.address_sr, t.address_sr_cyrl, t.town_sr, t.town_sr_cyrl, t.postal_code,
	COALESCE(t.latitude, src.latitude, src2.latitude),
	COALESCE(t.longitude, src.longitude, src2.longitude),
	'19989', t.email, t.website, '', '', '', '', '',
	'', '', '', '', '', '',
	(SELECT logo_url FROM (SELECT logo_url FROM clinics WHERE slug = 'moj-lab-podgorica-1') AS logo)
FROM tmp_mojlab t
LEFT JOIN clinics src ON src.slug = t.coord_src_slug
LEFT JOIN clinics src2 ON t.coord_src_slug = 'moj-lab-pedijatria-podgorica' AND src2.slug = 'moj-lab-pedijatrija-podgorica'
WHERE NOT EXISTS (SELECT 1 FROM (SELECT slug FROM clinics) AS ex WHERE ex.slug = t.slug);

INSERT INTO clinic_clinic_types (clinic_id, clinic_type_id)
SELECT c.id, ty.id
FROM tmp_mojlab t
JOIN clinics c ON c.slug = t.slug
JOIN clinic_types ty ON FIND_IN_SET(ty.id, t.types) > 0
WHERE NOT EXISTS (
	SELECT 1 FROM clinic_clinic_types x WHERE x.clinic_id = c.id AND x.clinic_type_id = ty.id
);

-- clinic_languages без UNIQUE — INSERT IGNORE не спасает, только NOT EXISTS.
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT c.id, 1
FROM tmp_mojlab t
JOIN clinics c ON c.slug = t.slug
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages x WHERE x.clinic_id = c.id AND x.language_id = 1);

INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
SELECT c.id,
	CAST(t.h_mon AS JSON), CAST(t.h_tue AS JSON), CAST(t.h_wed AS JSON), CAST(t.h_thu AS JSON),
	CAST(t.h_fri AS JSON), CAST(t.h_sat AS JSON), CAST(t.h_sun AS JSON)
FROM tmp_mojlab t
JOIN clinics c ON c.slug = t.slug
WHERE NOT EXISTS (SELECT 1 FROM clinic_working_hours x WHERE x.clinic_id = c.id);

-- ═══════════════════════════════════════════════════════════════
-- PART 2: часы поликлиники Ulcinj (лабораторные часы ушли в moj-lab-laboratorija-ulcinj)
-- ═══════════════════════════════════════════════════════════════

UPDATE clinic_working_hours w
JOIN clinics c ON c.id = w.clinic_id
SET w.monday = CAST(@h0820 AS JSON), w.tuesday = CAST(@h0820 AS JSON), w.wednesday = CAST(@h0820 AS JSON),
	w.thursday = CAST(@h0820 AS JSON), w.friday = CAST(@h0820 AS JSON), w.saturday = CAST(@h0820 AS JSON),
	w.sunday = CAST(@closed AS JSON)
WHERE c.slug = 'moj-lab-ulcinj'
	AND w.monday = CAST(@h0714 AS JSON)
	AND w.saturday = CAST(@h0813 AS JSON);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: moj-lab-pedijatria-podgorica → moj-lab-pedijatrija-podgorica
-- ═══════════════════════════════════════════════════════════════

-- slug_redirects на базе без 044 — в 0900_ai_ci, отсюда COLLATE в сравнениях.
INSERT INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'clinics', 'moj-lab-pedijatria-podgorica', id
FROM clinics WHERE slug = 'moj-lab-pedijatria-podgorica'
ON DUPLICATE KEY UPDATE entity_id = VALUES(entity_id);

DELETE FROM slug_redirects
WHERE entity_type COLLATE utf8mb4_unicode_ci = 'clinics'
	AND old_slug COLLATE utf8mb4_unicode_ci = 'moj-lab-pedijatrija-podgorica';

UPDATE clinics
SET slug = 'moj-lab-pedijatrija-podgorica', name_sr = 'Moj Lab Pedijatrija Podgorica'
WHERE slug = 'moj-lab-pedijatria-podgorica' AND name_sr = 'Moj Lab Pedijatria Podgorica';

DROP TEMPORARY TABLE tmp_mojlab;

COMMIT;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT c.slug, c.city_id, c.name_sr, c.address_sr, c.town_sr, c.latitude, c.longitude, c.email, c.website,
	(SELECT GROUP_CONCAT(ct.clinic_type_id ORDER BY ct.clinic_type_id) FROM clinic_clinic_types ct WHERE ct.clinic_id = c.id) AS types,
	(SELECT COUNT(*) FROM clinic_languages l WHERE l.clinic_id = c.id) AS langs,
	(SELECT CONCAT(JSON_UNQUOTE(w.monday->'$.type'), ' ', COALESCE(JSON_UNQUOTE(w.monday->'$.intervals[0].start'), ''), '-', COALESCE(JSON_UNQUOTE(w.monday->'$.intervals[0].end'), ''),
		' | sun ', JSON_UNQUOTE(w.sunday->'$.type')) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours_mon_sun
FROM clinics c
WHERE c.slug LIKE 'moj-lab-%'
ORDER BY c.city_id, c.slug;

SELECT r.old_slug, c.slug AS target_slug
FROM slug_redirects r JOIN clinics c ON c.id = r.entity_id
WHERE r.entity_type COLLATE utf8mb4_unicode_ci = 'clinics'
	AND r.old_slug COLLATE utf8mb4_unicode_ci LIKE 'moj-lab-%';
