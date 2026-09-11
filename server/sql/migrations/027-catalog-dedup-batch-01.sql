-- Дедупликация каталога, батч 1 — 50 пар с наибольшим score из очередей
-- medical_service_duplicate_candidates и lab_test_duplicate_candidates.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/027-catalog-dedup-batch-01.sql
--
-- Очереди наполняют детекторы (сами они ничего не сливают):
--   node scripts/services/find-duplicate-services.mjs
--   node scripts/labtests/find-duplicate-labtests.mjs
-- На момент сборки батча: 465 пар по услугам, 58 по анализам, все pending.
-- Здесь разобраны 50 пар с наибольшим score — это почти весь тир A.
--
-- ИТОГ БАТЧА: 43 слияния (33 услуги + 10 анализов), 7 отказов.
--
-- Скрипт идемпотентен: слияние не делает ничего, если одной из половинок уже
-- нет; переименования и отметки status пишутся по id.
--
-- ЧТО ДЕЛАЕТ СЛИЯНИЕ (повторяет server/api/services/merge.ts и
-- server/api/labtests/merge.ts — те же шаги в том же порядке):
--   1. переносит на основную запись связи с клиниками, категории,
--      специальности, врачей, справку, тарифы ФЗОЦГ, отзывы, синонимы;
--   2. дозаполняет пустые цены основной записи ценами дубликата (клиника
--      могла висеть на обеих);
--   3. заводит названия дубликата синонимами основной записи — иначе
--      формулировка, под которой услугу знает клиника, перестала бы искаться;
--   4. заводит 301 (medical_service_redirects / lab_test_redirects +
--      slug_redirects) и удаляет дубликат.
--
-- ПОБОЧНЫЙ ЭФФЕКТ. Строки очередей исчезают по FK CASCADE вместе с удалённой
-- записью — в том числе пары ВНЕ этого батча, где удалённая запись была второй
-- половинкой. По смыслу это верно (сущности больше нет), но после применения
-- детекторы надо прогнать заново: уцелевшая половинка таких пар может
-- заслуживать сверки уже с основной записью.
--
-- ЧТО НАЙДЕНО ПОПУТНО И СЮДА НЕ ВОШЛО (нужно отдельное решение):
--   * medical_service_tariffs.X01046 = «Endotrahealna intubacija», но привязан
--     к услуге 3603 «Punkcija abdomena», и клиники 88/131/137 держат пункцию
--     абдомена под тем же кодом X01046. Либо код в прайсе клиники ошибочен,
--     либо привязка тарифа — разбирать отдельно.
--   * Один и тот же прайсовый код заведён и услугой, и анализом: K01010
--     (услуга 3336 «Bris nosa» и анализ 1158 «Nose Swab Bacteria»), K01009
--     (услуга 3337 и «Bris jezika»), K01002. Межкаталожные дубли ни детекторы,
--     ни слияние не видят — нужен отдельный проход.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ===========================================================================
-- Процедуры слияния (в конце файла удаляются)
-- ===========================================================================

DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;

DELIMITER $$

CREATE PROCEDURE dedup_merge_medical_service(IN p_primary INT, IN p_secondary INT)
BEGIN
	-- Обе половинки на месте? Иначе слияние уже применяли.
	IF (SELECT COUNT(*) FROM medical_services WHERE id IN (p_primary, p_secondary)) = 2 THEN

		-- 1. Связи с клиниками, которых у основной услуги ещё нет
		INSERT IGNORE INTO clinic_medical_services
			(medical_service_id, clinic_id, price, price_min, price_max, code, is_price_outdated)
		SELECT p_primary, clinic_id, price, price_min, price_max, code, is_price_outdated
		  FROM clinic_medical_services
		 WHERE medical_service_id = p_secondary;

		-- 1.1 Клиника висела на обеих услугах — дозаполняем пустые поля основной.
		-- is_price_outdated присваивается ПЕРВЫМ: MySQL вычисляет SET слева
		-- направо, и после присвоения p.price условие уже не сработает.
		UPDATE clinic_medical_services p
		  JOIN clinic_medical_services s
		    ON s.clinic_id = p.clinic_id AND s.medical_service_id = p_secondary
		   SET p.is_price_outdated = CASE
		           WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated
		           ELSE p.is_price_outdated
		       END,
		       p.price     = COALESCE(p.price, s.price),
		       p.price_min = COALESCE(p.price_min, s.price_min),
		       p.price_max = COALESCE(p.price_max, s.price_max),
		       p.code      = COALESCE(p.code, s.code)
		 WHERE p.medical_service_id = p_primary;

		-- 2. Специальности
		INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
		SELECT p_primary, specialty_id
		  FROM medical_services_specialties
		 WHERE medical_service_id = p_secondary;

		-- 3. Категории
		INSERT IGNORE INTO medical_service_categories_relations
			(medical_service_id, medical_service_category_id)
		SELECT p_primary, medical_service_category_id
		  FROM medical_service_categories_relations
		 WHERE medical_service_id = p_secondary;

		-- 4. Врачи, оказывающие услугу в клинике
		INSERT IGNORE INTO clinic_medical_service_doctors
			(clinic_id, medical_service_id, doctor_id, price, price_max)
		SELECT clinic_id, p_primary, doctor_id, price, price_max
		  FROM clinic_medical_service_doctors
		 WHERE medical_service_id = p_secondary;

		-- 4.1 Справочный контент. На medical_service_id стоит UNIQUE, поэтому
		-- UPDATE IGNORE перенесёт справку только если у основной услуги её ещё
		-- нет; иначе она останется на дубликате и уйдёт по CASCADE.
		UPDATE IGNORE medical_service_reference_info
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.2 Тарифы ФЗОЦГ (FK стоит на SET NULL — без переноса коды молча
		-- отвязались бы от каталога)
		UPDATE medical_service_tariffs
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.3 Отзывы (FK стоит на CASCADE — без переноса удалились бы)
		UPDATE reviews
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.4 Синонимы дубликата
		UPDATE IGNORE medical_service_synonyms
		   SET medical_service_id = p_primary
		 WHERE medical_service_id = p_secondary;

		-- 4.5 Названия дубликата — в синонимы основной услуги.
		-- Совпало с названием основной — синоним не нужен.
		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_en), 'en'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_en, '')) NOT IN ('', TRIM(COALESCE(p.name_en, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr), 'sr'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr, '')) NOT IN ('', TRIM(COALESCE(p.name_sr, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr_cyrl), 'sr-cyrl'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr_cyrl, '')) NOT IN ('', TRIM(COALESCE(p.name_sr_cyrl, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_ru), 'ru'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_ru, '')) NOT IN ('', TRIM(COALESCE(p.name_ru, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_de), 'de'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_de, '')) NOT IN ('', TRIM(COALESCE(p.name_de, '')));

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_primary, TRIM(s.name_tr), 'tr'
		  FROM medical_services s JOIN medical_services p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_tr, '')) NOT IN ('', TRIM(COALESCE(p.name_tr, '')));

		-- 5. Связи дубликата
		DELETE FROM clinic_medical_services WHERE medical_service_id = p_secondary;
		DELETE FROM medical_services_specialties WHERE medical_service_id = p_secondary;
		DELETE FROM medical_service_categories_relations WHERE medical_service_id = p_secondary;
		DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = p_secondary;

		-- 6. Редиректы: сначала перецеливаем существующие, потом заводим новый
		UPDATE medical_service_redirects SET new_id = p_primary WHERE new_id = p_secondary;
		INSERT IGNORE INTO medical_service_redirects (old_id, new_id) VALUES (p_secondary, p_primary);

		-- 6.1 Слаг дубликата
		INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
		SELECT 'services', slug, p_primary
		  FROM medical_services
		 WHERE id = p_secondary AND slug IS NOT NULL AND slug <> '';

		-- 7. Удаляем дубликат
		DELETE FROM medical_services WHERE id = p_secondary;
	END IF;
END$$

CREATE PROCEDURE dedup_merge_lab_test(IN p_primary INT, IN p_secondary INT)
BEGIN
	IF (SELECT COUNT(*) FROM lab_tests WHERE id IN (p_primary, p_secondary)) = 2 THEN

		-- 1. Связи с клиниками
		INSERT IGNORE INTO clinic_lab_tests
			(lab_test_id, clinic_id, price, price_max, code, is_price_outdated)
		SELECT p_primary, clinic_id, price, price_max, code, is_price_outdated
		  FROM clinic_lab_tests
		 WHERE lab_test_id = p_secondary;

		-- 1.1 Клиника висела на обоих анализах — дозаполняем пустые поля
		UPDATE clinic_lab_tests p
		  JOIN clinic_lab_tests s
		    ON s.clinic_id = p.clinic_id AND s.lab_test_id = p_secondary
		   SET p.is_price_outdated = CASE
		           WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated
		           ELSE p.is_price_outdated
		       END,
		       p.price     = COALESCE(p.price, s.price),
		       p.price_max = COALESCE(p.price_max, s.price_max),
		       p.code      = COALESCE(p.code, s.code)
		 WHERE p.lab_test_id = p_primary;

		-- 2. Категории
		INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
		SELECT p_primary, category_id
		  FROM lab_test_categories_relations
		 WHERE lab_test_id = p_secondary;

		-- 3. Синонимы. UNIQUE стоит на (another_name, language), смена
		-- lab_test_id его не задевает — обычного UPDATE достаточно.
		UPDATE lab_test_synonyms SET lab_test_id = p_primary WHERE lab_test_id = p_secondary;

		-- 4. Названия дубликата — в синонимы основного анализа
		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_en), 'en'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_en, '')) NOT IN ('', TRIM(COALESCE(p.name_en, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr), 'sr'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr, '')) NOT IN ('', TRIM(COALESCE(p.name_sr, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr_cyrl), 'sr-cyrl'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr_cyrl, '')) NOT IN ('', TRIM(COALESCE(p.name_sr_cyrl, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_ru), 'ru'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_ru, '')) NOT IN ('', TRIM(COALESCE(p.name_ru, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_de), 'de'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_de, '')) NOT IN ('', TRIM(COALESCE(p.name_de, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_tr), 'tr'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_tr, '')) NOT IN ('', TRIM(COALESCE(p.name_tr, '')));

		-- 4.1 Справочный контент
		UPDATE IGNORE lab_test_reference_info
		   SET lab_test_id = p_primary
		 WHERE lab_test_id = p_secondary;

		-- 5. Связи дубликата
		DELETE FROM clinic_lab_tests WHERE lab_test_id = p_secondary;
		DELETE FROM lab_test_categories_relations WHERE lab_test_id = p_secondary;

		-- 6. Редиректы
		UPDATE lab_test_redirects SET new_id = p_primary WHERE new_id = p_secondary;
		INSERT IGNORE INTO lab_test_redirects (old_id, new_id) VALUES (p_secondary, p_primary);

		-- 6.1 Слаг дубликата
		INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
		SELECT 'labtests', slug, p_primary
		  FROM lab_tests
		 WHERE id = p_secondary AND slug IS NOT NULL AND slug <> '';

		-- 7. Удаляем дубликат
		DELETE FROM lab_tests WHERE id = p_secondary;
	END IF;
END$$

DELIMITER ;

-- ===========================================================================
-- A. СЛИЯНИЯ — АНАЛИЗЫ (10)
--    CALL dedup_merge_lab_test(основной, дубликат)
-- ===========================================================================

-- Interleukin-6 / Interleukin 6 — одно и то же, разница только в дефисе.
-- Основной 555: категория, 4 синонима, 5 клиник.
CALL dedup_merge_lab_test(555, 1786);

-- Nose Swab Bacteria / Nasal Swab Bacteria — «Bris nosa (bakterije)».
CALL dedup_merge_lab_test(1158, 1716);

-- Nose Swab Fungi / Nasal Swab Fungi — «Bris nosa (gljivice)».
CALL dedup_merge_lab_test(1161, 1729);

-- Vulvar / Vulva Swab Bacteria — «Bris vulve (bakterije)».
CALL dedup_merge_lab_test(1184, 1727);

-- Vulvar / Vulva Swab Fungi — «Bris vulve (gljivice)».
CALL dedup_merge_lab_test(1185, 1740);

-- Umbilicus / Umbilical Swab Bacteria — «Bris pupka».
CALL dedup_merge_lab_test(1849, 1997);

-- Monosticon / Monosticon Test — тест на мононуклеоз. Синонимы дубликата
-- («Mononucleosis Test», «Тест на мононуклеоз») переезжают на основной.
CALL dedup_merge_lab_test(238, 1219);

-- HBeAg / HBeAg Test — НЕ сливаем, см. секции C и D.

-- Protia Allergy Q64S, комбинированная панель 63 аллергена.
CALL dedup_merge_lab_test(1668, 1920);

-- Protia Allergy Q64, ингаляционная панель 64 аллергена.
CALL dedup_merge_lab_test(1669, 1921);

-- Protia Allergy Q96M, комбинированная панель 107 аллергенов.
CALL dedup_merge_lab_test(1671, 1923);

-- ===========================================================================
-- B. СЛИЯНИЯ — УСЛУГИ (33)
--    CALL dedup_merge_medical_service(основная, дубликат)
-- ===========================================================================

-- --- B.1 Одна и та же позиция ФЗОЦГ под одним кодом в разных клиниках ------
-- Основной берём запись с привязкой к medical_service_tariffs.

-- Konverzija ritma elektrošokom, X15005 (88/137 и 131).
CALL dedup_merge_medical_service(5826, 7956);

-- VIMA, X15016 (88/137 и 131).
CALL dedup_merge_medical_service(5837, 7963);

-- Centralni nervni blokovi, X15002 (88/137 и 131).
CALL dedup_merge_medical_service(5825, 7955);

-- Priprema opranih eritrocita, X12064 (88/137 и 131).
CALL dedup_merge_medical_service(5814, 8025);

-- Priprema filtriranih eritrocita, X12065 (88/137 и 131).
CALL dedup_merge_medical_service(5815, 8026);

-- Snimanje ždrijela i grkljana, J06005 (88/131/137 и 85).
CALL dedup_merge_medical_service(4926, 7861);

-- Snimanje hepatobilijarnog trakta, J06011 (88/131/137 и 85).
CALL dedup_merge_medical_service(4929, 7865);

-- Fluorografija pluća, J06007 (88/131/137 и 85).
CALL dedup_merge_medical_service(4927, 7862);

-- --- B.2 Прайс ДЗ Херцег-Нови / Мойковац дублирует позицию ФЗОЦГ ----------
-- Коды клиник 80 и 127 — локальные (префиксы HN_, MO_HN_), номер тот же.

-- Repozicija uklještene kile, X02020 / HN_X02015.
CALL dedup_merge_medical_service(5327, 7064);

-- Elektroforeza (физиотерапия), M02021 / HN_M01009.
CALL dedup_merge_medical_service(1631, 7389);

-- Heteroanamneza, H01021 в обеих записях.
CALL dedup_merge_medical_service(5206, 7123);

-- Ispiranje cerumena, X01005 / HN_X01005 / X01005_KO.
CALL dedup_merge_medical_service(1513, 7045);

-- Snimanje urotrakta, J06012 / HN_J06012.
CALL dedup_merge_medical_service(2038, 7215);

-- Uzimanje sputuma za citološku analizu, X01029 / HN_TBCX03011.
CALL dedup_merge_medical_service(5301, 7106);

-- Prijem materijala i davanje sterilnih posuda, K01002 / HN_K01002.
CALL dedup_merge_medical_service(4983, 7232);

-- Aparaturna masaža, M02003 / HN_M01003.
CALL dedup_merge_medical_service(5140, 7384);

-- Bris nosa, K01010 / HN_K01010.
CALL dedup_merge_medical_service(3336, 7240);

-- Bris jezika, K01009 / HN_K01009.
CALL dedup_merge_medical_service(3337, 7239);

-- --- B.3 Разный порядок слов, одна услуга ---------------------------------

-- Rendgen sinusa (paranazalnih šupljina). Основная 3202: 4 клиники и тариф
-- J06040, у 2296 только клиника 2.
CALL dedup_merge_medical_service(3202, 2296);

-- Holter EKG.
CALL dedup_merge_medical_service(7410, 7949);

-- Kontrolni pregled ORL specijaliste.
CALL dedup_merge_medical_service(1511, 1956);

-- MR mekih tkiva vrata.
CALL dedup_merge_medical_service(3151, 3806);

-- MR multiparametrija prostate.
CALL dedup_merge_medical_service(3174, 3813);

-- Hemijski piling lica.
CALL dedup_merge_medical_service(4143, 4427);

-- Davanje injekcije s.c. — та же подкожная инъекция, что и 1591.
CALL dedup_merge_medical_service(1591, 7772);

-- Davanje injekcije i.m. — та же внутримышечная инъекция, что и 1592.
CALL dedup_merge_medical_service(1592, 7771);

-- --- B.4 Одна процедура, заведённая от разных отделений и клиник ----------

-- Incizija apscesa intraoralno. Основная 5579 держит и ORL (X07065),
-- и максиллофациальный (X28005) коды; 1734 — та же процедура из прайсов
-- стоматологий.
CALL dedup_merge_medical_service(5579, 1734);

-- Incizija apscesa ekstraoralno, X07079 / X28004.
CALL dedup_merge_medical_service(5589, 1735);

-- Punkcija abdomena / paracenteza. Основная 3603: 5 клиник, 3 категории.
CALL dedup_merge_medical_service(3603, 3353);

-- Komplikovano vađenje zuba / Kompleksna ekstrakcija zuba.
-- Клиника 117 держала обе записи — это один импорт, разошедшийся в переводе.
CALL dedup_merge_medical_service(1717, 4025);

-- Kauzalna parodontološka terapija — название совпадает дословно,
-- клиники 107 и 117 держали обе записи. Основная 1745 несёт справку.
CALL dedup_merge_medical_service(1745, 4034);

-- Uvećanje usana — «Lip Augmentation» и «Lip Augmentation Fillers»,
-- клиники 90 и 116 держали обе. Основной берём родовое название: филлеры —
-- лишь один из способов увеличения губ.
CALL dedup_merge_medical_service(4151, 4186);

-- Obrada rane, малая. СПОРНОЕ: клиника 3 держит обе записи с разной ценой
-- (170 и 200). Названия совпадают дословно («Mala obrada rane» /
-- «Obrada rane - mala»), поэтому в каталоге это одна услуга; основной берём
-- 2140 — она часть явного ряда velika/srednja/mala. Цена 170 у клиники 3
-- теряется. Если строка 170 в прайсе клиники реальна и отличается по сути —
-- эту пару из батча надо убрать.
CALL dedup_merge_medical_service(2140, 2136);

-- ===========================================================================
-- C. ОТКАЗЫ — не дубликаты (7)
--    status = 'dismissed', чтобы пара не всплыла при следующем прогоне
-- ===========================================================================

-- HBeAg (329) и HBeAg Test (2325) — разные позиции прайса, а не дубль:
-- 329 идёт по коду лаборатории (K03167, клиника 88 — 11.90 €; клиника 48),
-- 2325 — по коду трансфузиологии X12056 «Test na Hbe Ag» (26.35 €), это
-- скрининг донорской крови. Аналит один, но услуга и цена разные, поэтому
-- обе записи остаются; 2325 разводится по названию в секции D.
UPDATE lab_test_duplicate_candidates
   SET status = 'dismissed', decided_at = NOW()
 WHERE lab_test_id_a = 329 AND lab_test_id_b = 2325;

-- Parcijalna ekscizija kosti: D05025 — при остеомиелите бедренной/берцовых
-- костей (93.60 €), D05090 — лучевой/локтевой (54.60 €). Разные операции,
-- совпали потому, что в каталог попали усечённые названия.
UPDATE medical_service_duplicate_candidates
   SET status = 'dismissed', decided_at = NOW()
 WHERE service_id_a = 6414 AND service_id_b = 6464;

-- Fiksacioni zavoj: X09044/X09049/X09050/X09051 — процедура иммобилизации
-- (раздел «27. ORTOPEDIJA I TRAUMATOLOGIJA»), Y10014/Y10017/Y10019/Y10020 —
-- расход гипсового бинта (раздел «1. OPŠTE USLUGE», подраздел «Utrošak
-- gipsanih zavoja»). Это материал, а не процедура: цены разные, и у Y-позиций
-- нет амбулаторной цены вообще.
UPDATE medical_service_duplicate_candidates
   SET status = 'dismissed', decided_at = NOW()
 WHERE (service_id_a, service_id_b) IN ((5652, 6992), (5655, 6986), (5656, 6989), (5657, 6991));

-- Obrada rezultata, integracija, pisanje nalaza: H01020 и H02024 — одна
-- формулировка в двух блоках прайса центра психического здоровья. H01* —
-- приём и терапия психиатра, H02* — психологическое тестирование
-- (в «секундарном» прайсе те же префиксы разведены по разделам
-- «18. PSIHIJATRIJA» и «61. PSIHOLOGIJA»). Разные специалисты, разные цены
-- (133 и 109 € у клиники 80) — две услуги.
UPDATE medical_service_duplicate_candidates
   SET status = 'dismissed', decided_at = NOW()
 WHERE service_id_a = 7122 AND service_id_b = 7149;

-- ===========================================================================
-- D. РАЗВЕДЕНИЕ НАЗВАНИЙ по отказам из секции C
--
-- Отказ убирает пару из очереди, но на сайте остаются две записи, которые
-- пользователь не отличит: названия совпадают дословно. Здесь они приводятся
-- к источнику — ФЗОЦГ различает эти позиции, каталог обязан тоже.
--
-- Слаги намеренно не трогаем: смена слага требует своей записи в
-- slug_redirects, а старые адреса уже в индексе.
--
-- Эту секцию можно выкинуть целиком, если переименования не нужны, —
-- на слияния и отказы она не влияет.
-- ===========================================================================

-- D05025 — остеомиелит бедренной, большеберцовой, малоберцовой
UPDATE medical_services SET
	name_en      = 'Partial Bone Excision for Osteomyelitis of Femur, Tibia or Fibula',
	name_sr      = 'Parcijalna ekscizija kosti (kiretaža, sekvestracija, dijafizektomija) kod osteomijelitisa femura, tibije ili fibule',
	name_sr_cyrl = 'Парцијална ексцизија кости (киретажа, секвестрација, дијафизектомија) код остеомијелитиса фемура, тибије или фибуле',
	name_ru      = 'Частичная резекция кости (кюретаж, секвестрэктомия, диафизэктомия) при остеомиелите бедренной, большеберцовой или малоберцовой кости',
	name_de      = 'Partielle Knochenexzision (Kürettage, Sequestrektomie, Diaphysektomie) bei Osteomyelitis von Femur, Tibia oder Fibula',
	name_tr      = 'Femur, tibia veya fibula osteomiyelitinde parsiyel kemik eksizyonu (küretaj, sekestrektomi, diyafizektomi)'
 WHERE id = 6414;

-- D05090 — остеомиелит лучевой или локтевой
UPDATE medical_services SET
	name_en      = 'Partial Bone Excision for Osteomyelitis of Radius or Ulna',
	name_sr      = 'Parcijalna ekscizija kosti (kiretaža, sekvestracija, dijafizektomija) kod osteomijelitisa radijusa ili ulne',
	name_sr_cyrl = 'Парцијална ексцизија кости (киретажа, секвестрација, дијафизектомија) код остеомијелитиса радијуса или улне',
	name_ru      = 'Частичная резекция кости (кюретаж, секвестрэктомия, диафизэктомия) при остеомиелите лучевой или локтевой кости',
	name_de      = 'Partielle Knochenexzision (Kürettage, Sequestrektomie, Diaphysektomie) bei Osteomyelitis von Radius oder Ulna',
	name_tr      = 'Radius veya ulna osteomiyelitinde parsiyel kemik eksizyonu (küretaj, sekestrektomi, diyafizektomi)'
 WHERE id = 6464;

-- Y10020 — расход гипсового бинта, голеностоп.
-- Заодно чинится name_sr_cyrl: там была latinица посреди кириллицы
-- («Фиксациони завој гležnja»).
UPDATE medical_services SET
	name_en      = 'Ankle Fixation Bandage (Plaster Material)',
	name_sr      = 'Fiksacioni zavoj gležnja (utrošak gipsanog zavoja)',
	name_sr_cyrl = 'Фиксациони завој глежња (утрошак гипсаног завоја)',
	name_ru      = 'Фиксирующая повязка голеностопа (расход гипсового бинта)',
	name_de      = 'Sprunggelenk-Fixationsverband (Gipsmaterial)',
	name_tr      = 'Ayak bileği fiksasyon bandajı (alçı malzemesi)'
 WHERE id = 6992;

-- Y10014 — расход гипсового бинта, грудная клетка
UPDATE medical_services SET
	name_en      = 'Thorax Fixation Bandage (Plaster Material)',
	name_sr      = 'Fiksacioni zavoj toraksa (utrošak gipsanog zavoja)',
	name_sr_cyrl = 'Фиксациони завој торакса (утрошак гипсаног завоја)',
	name_ru      = 'Фиксирующая повязка грудной клетки (расход гипсового бинта)',
	name_de      = 'Thorax-Fixationsverband (Gipsmaterial)',
	name_tr      = 'Toraks fiksasyon bandajı (alçı malzemesi)'
 WHERE id = 6986;

-- Y10017 — расход гипсового бинта, локоть или лучезапястный сустав
UPDATE medical_services SET
	name_en      = 'Elbow or Wrist Fixation Bandage (Plaster Material)',
	name_sr      = 'Fiksacioni zavoj lakta ili zgloba ručja (utrošak gipsanog zavoja)',
	name_sr_cyrl = 'Фиксациони завој лакта или зглоба ручја (утрошак гипсаног завоја)',
	name_ru      = 'Фиксирующая повязка локтя или запястья (расход гипсового бинта)',
	name_de      = 'Ellbogen- oder Handgelenk-Fixationsverband (Gipsmaterial)',
	name_tr      = 'Dirsek veya el bileği fiksasyon bandajı (alçı malzemesi)'
 WHERE id = 6989;

-- Y10019 — расход гипсового бинта, колено
UPDATE medical_services SET
	name_en      = 'Knee Fixation Bandage (Plaster Material)',
	name_sr      = 'Fiksacioni zavoj koljena (utrošak gipsanog zavoja)',
	name_sr_cyrl = 'Фиксациони завој кољена (утрошак гипсаног завоја)',
	name_ru      = 'Фиксирующая повязка колена (расход гипсового бинта)',
	name_de      = 'Knie-Fixationsverband (Gipsmaterial)',
	name_tr      = 'Diz fiksasyon bandajı (alçı malzemesi)'
 WHERE id = 6991;

-- Анализ 2325, X12056 — скрининг донорской крови в трансфузиологии.
-- Без пометки он неотличим от обычного HBeAg (анализ 329).
UPDATE lab_tests SET
	name_en      = 'HBeAg Test (Transfusion Screening)',
	name_sr      = 'Test na HBeAg (transfuziološki skrining)',
	name_sr_cyrl = 'Тест на HBeAg (трансфузиолошки скрининг)',
	name_ru      = 'Тест на HBeAg (трансфузиологический скрининг)',
	name_de      = 'HBeAg-Test (Transfusionsscreening)',
	name_tr      = 'HBeAg testi (transfüzyon taraması)'
 WHERE id = 2325;

-- H01020 — блок психиатра
UPDATE medical_services SET
	name_en      = 'Results Processing and Report Writing (Psychiatry)',
	name_sr      = 'Obrada rezultata, integracija i pisanje nalaza (psihijatrija)',
	name_sr_cyrl = 'Обрада резултата, интеграција и писање налаза (психијатрија)',
	name_ru      = 'Обработка и интеграция результатов, написание заключения (психиатрия)',
	name_de      = 'Ergebnisverarbeitung, Integration und Befundschreiben (Psychiatrie)',
	name_tr      = 'Sonuç işleme, entegrasyon ve rapor yazımı (psikiyatri)'
 WHERE id = 7122;

-- H02024 — блок психолога
UPDATE medical_services SET
	name_en      = 'Results Processing and Report Writing (Psychology)',
	name_sr      = 'Obrada rezultata, integracija i pisanje nalaza (psihologija)',
	name_sr_cyrl = 'Обрада резултата, интеграција и писање налаза (психологија)',
	name_ru      = 'Обработка и интеграция результатов, написание заключения (психология)',
	name_de      = 'Ergebnisverarbeitung, Integration und Befundschreiben (Psychologie)',
	name_tr      = 'Sonuç işleme, entegrasyon ve rapor yazımı (psikoloji)'
 WHERE id = 7149;

-- ===========================================================================

DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
