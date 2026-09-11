-- Перенос анализов из каталога услуг в каталог анализов (и одной услуги
-- обратно). 162 пары, найденные сверкой отпечатков названий между
-- medical_services и lab_tests по шести языковым колонкам.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/029-move-labtests-out-of-services.sql
--
-- ПОРЯДОК ПРИМЕНЕНИЯ: 027 → 028 → 029.
--   027 сливает дубли внутри каталогов; одна его цель учтена здесь (см. ниже).
--   028 добавляет slug_redirects.target_entity_type и
--       medical_service_tariffs.lab_test_id — без них этот скрипт не выполнится.
-- Вместе с 028 должны быть выкачены правки кода: кросс-каталожный 301
-- (server/common/redirect/slug-redirects.ts) и вывод тарифов на странице
-- анализа (server/api/labtests/details.ts).
--
-- ИТОГ: 160 переносов услуга → анализ, 1 перенос анализ → услуга, 1 отказ.
--
-- Скрипт идемпотентен: перенос не делает ничего, если одной из половинок нет.
--
-- ОТКУДА ВЗЯЛИСЬ ДУБЛИ
-- Три импорта прайсов завели лабораторные позиции в medical_services:
-- клиника 137 (Општа болница Никшич) — 147 штук, 80 (ДЗ Херцег-Нови) — 33,
-- 127 (ДЗ Мойковац) — 9. У клиники 88 те же позиции с теми же кодами ФЗОЦГ
-- и теми же ценами лежат в lab_tests — то есть каталог правильный, а эти
-- строки просто попали не в ту таблицу. Справок, отзывов и привязок врачей
-- на них нет, категории не переносим: у услуг и анализов разные таксономии.
--
-- РАЗОБРАННЫЕ ВРУЧНУЮ ИСКЛЮЧЕНИЯ
--
-- 1. svc 2241 «Uzimanje ginekoloških briseva» ← lt 1748. Единственная пара,
--    где лишний как раз анализ: взятие мазка — процедура в клинике, а не
--    исследование. У услуги 5 клиник и категория «Гинекология», у анализа
--    2 клиники и ни одной категории. Переносим в обратную сторону.
--
-- 2. svc 3971 «Biopsija grlića + Histopatološka analiza» и lt 1858
--    «PH biopsije grlića materice» — НЕ дубль: услуга это связка «процедура +
--    анализ», анализ — только патогистология. Не трогаем.
--    Чистая патогистология шейки матки (svc 5106, код L01126) в анализ 1858
--    при этом переезжает.
--
-- 3. svc 7243 «Bris pupka» переносится в анализ 1849, а не в 1997: 1997
--    удаляет миграция 027, слив его в 1849.
--
-- 4. svc 7235 «Antibiogram» (клиника 80, код HN_K01005, 2.00 €) переносится
--    в анализ 288 «Аминовый тест», а НЕ в 1999 «Изготовление антибиограммы»,
--    и его названия НЕ заводятся синонимами. Обоснование: коды ДЗ Херцег-Нови
--    позиционно повторяют ФЗОЦГ (HN_K01002 = приём материала, HN_K01006 =
--    Treponema pallidum, HN_K01009 = бриз языка — всё совпадает), а
--    ФЗОЦГ K01005 это «Aminski test», который клиники 88 и 137 держат по
--    1.98 €. Цена 2.00 € сходится с аминовым тестом и не сходится с
--    антибиограммой, которая в том же прайсе ДЗ ХН лежит отдельной строкой
--    HN_K01028 по 8.00 €. То есть строка в прайсе названа ошибочно.
--    ЕСЛИ ЭТО РЕШЕНИЕ НЕ ПРИНИМАЕТСЯ — уберите одну строку
--    `CALL dedup_move_service_to_lab_test(288, 7235, 0);`, остальное не
--    затрагивается.
--
-- ЧТО ТЕРЯЕТСЯ
--   * clinic_medical_services.price_min — в clinic_lab_tests такой колонки
--     нет. У переезжающих строк price_min всегда равен price (проверено,
--     расхождений 0), так что потери нет.
--   * Категории услуг (все 159 — «Laboratory Services») не переносятся:
--     в lab_test_categories своя нумерация и свой смысл.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ===========================================================================
-- Процедуры переноса (в конце файла удаляются)
-- ===========================================================================

DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test;
DROP PROCEDURE IF EXISTS dedup_move_lab_test_to_service;

DELIMITER $$

/**
 * Услуга → анализ.
 *
 * p_keep_names = 0 означает «название услуги неверно, синонимом не заводить»
 * (единственный случай — svc 7235, см. шапку).
 */
CREATE PROCEDURE dedup_move_service_to_lab_test(
	IN p_lab_test_id INT,
	IN p_service_id INT,
	IN p_keep_names TINYINT
)
BEGIN
	IF (SELECT COUNT(*) FROM medical_services WHERE id = p_service_id) = 1
	   AND (SELECT COUNT(*) FROM lab_tests WHERE id = p_lab_test_id) = 1 THEN

		-- 1. Цены клиник. price_min не переносим — колонки нет, и он равен price.
		INSERT IGNORE INTO clinic_lab_tests
			(lab_test_id, clinic_id, price, price_max, code, is_price_outdated)
		SELECT p_lab_test_id, clinic_id, price, price_max, code, is_price_outdated
		  FROM clinic_medical_services
		 WHERE medical_service_id = p_service_id;

		-- 1.1 Клиника уже была у анализа — дозаполняем пустые поля.
		-- is_price_outdated присваивается ПЕРВЫМ: MySQL вычисляет SET слева
		-- направо, и после присвоения t.price условие уже не сработает.
		UPDATE clinic_lab_tests t
		  JOIN clinic_medical_services s
		    ON s.clinic_id = t.clinic_id AND s.medical_service_id = p_service_id
		   SET t.is_price_outdated = CASE
		           WHEN t.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated
		           ELSE t.is_price_outdated
		       END,
		       t.price     = COALESCE(t.price, s.price),
		       t.price_max = COALESCE(t.price_max, s.price_max),
		       t.code      = COALESCE(t.code, s.code)
		 WHERE t.lab_test_id = p_lab_test_id;

		-- 2. Синонимы услуги переезжают всегда: под ними анализ ищут.
		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_lab_test_id, another_name, language
		  FROM medical_service_synonyms
		 WHERE medical_service_id = p_service_id;

		-- 3. Названия услуги — синонимами анализа, чтобы формулировка клиники
		-- продолжала находиться после переноса.
		IF p_keep_names = 1 THEN
			INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
			SELECT p_lab_test_id, TRIM(s.name_en), 'en' FROM medical_services s
			 WHERE s.id = p_service_id AND TRIM(COALESCE(s.name_en, '')) <> '';
			INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
			SELECT p_lab_test_id, TRIM(s.name_sr), 'sr' FROM medical_services s
			 WHERE s.id = p_service_id AND TRIM(COALESCE(s.name_sr, '')) <> '';
			INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
			SELECT p_lab_test_id, TRIM(s.name_sr_cyrl), 'sr-cyrl' FROM medical_services s
			 WHERE s.id = p_service_id AND TRIM(COALESCE(s.name_sr_cyrl, '')) <> '';
			INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
			SELECT p_lab_test_id, TRIM(s.name_ru), 'ru' FROM medical_services s
			 WHERE s.id = p_service_id AND TRIM(COALESCE(s.name_ru, '')) <> '';
			INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
			SELECT p_lab_test_id, TRIM(s.name_de), 'de' FROM medical_services s
			 WHERE s.id = p_service_id AND TRIM(COALESCE(s.name_de, '')) <> '';
			INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
			SELECT p_lab_test_id, TRIM(s.name_tr), 'tr' FROM medical_services s
			 WHERE s.id = p_service_id AND TRIM(COALESCE(s.name_tr, '')) <> '';
		END IF;

		-- 3.1 Синоним, совпавший с собственным названием анализа, бесполезен
		-- и засоряет выдачу — чистим сразу, тем же условием, что и разовая
		-- чистка синонимов (duplicate-synonyms-fix.txt).
		--
		-- COLLATE обязателен: lab_test_synonyms создана в utf8mb4_0900_ai_ci,
		-- а lab_tests — в utf8mb4_unicode_ci, и сравнение колонок напрямую
		-- падает с ERROR 1267 «Illegal mix of collations». SET NAMES в шапке
		-- тут не спасает: он задаёт коллацию литералов, а не колонок.
		DELETE syn FROM lab_test_synonyms syn
		  JOIN lab_tests t ON t.id = syn.lab_test_id
		 WHERE syn.lab_test_id = p_lab_test_id
		   AND syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
		           WHEN 'en' THEN t.name_en
		           WHEN 'sr' THEN t.name_sr
		           WHEN 'sr-cyrl' THEN t.name_sr_cyrl
		           WHEN 'ru' THEN t.name_ru
		           WHEN 'de' THEN t.name_de
		           WHEN 'tr' THEN t.name_tr
		           ELSE NULL
		       END;

		-- 4. Тарифы ФЗОЦГ переезжают в лабораторную колонку. Обе ссылки
		-- присваиваются ОДНИМ UPDATE — промежуточного состояния, в котором
		-- тариф висит сразу на двух каталогах, не возникает (ограничением БД
		-- это не выразить, см. конец миграции 028).
		UPDATE medical_service_tariffs
		   SET lab_test_id = p_lab_test_id, medical_service_id = NULL
		 WHERE medical_service_id = p_service_id;

		-- 5. 301 со старого адреса услуги на карточку анализа.
		INSERT IGNORE INTO slug_redirects
			(entity_type, old_slug, entity_id, target_entity_type)
		SELECT 'services', slug, p_lab_test_id, 'labtests'
		  FROM medical_services
		 WHERE id = p_service_id AND slug IS NOT NULL AND slug <> '';

		-- 5.1 Редиректы, которые вели на эту услугу, перецеливаем — иначе
		-- цепочка обрывается на удалённой записи и старый адрес отдаст 404.
		UPDATE slug_redirects
		   SET entity_id = p_lab_test_id, target_entity_type = 'labtests'
		 WHERE entity_type = 'services'
		   AND COALESCE(target_entity_type, 'services') = 'services'
		   AND entity_id = p_service_id;

		-- 6. Связи и сама услуга. medical_service_redirects каскадом не
		-- чистится — таблица без FK, убираем явно. Перецелить эти строки
		-- некуда: new_id — это id услуги, а нумерации каталогов независимы,
		-- так что числовой /services/<id> после переноса отдаст 404 вместо
		-- 301. На текущих данных таких строк нет ни одной (проверено), и
		-- числовой URL никогда не был каноническим.
		DELETE FROM clinic_medical_services WHERE medical_service_id = p_service_id;
		DELETE FROM medical_services_specialties WHERE medical_service_id = p_service_id;
		DELETE FROM medical_service_categories_relations WHERE medical_service_id = p_service_id;
		DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = p_service_id;
		DELETE FROM medical_service_redirects WHERE old_id = p_service_id OR new_id = p_service_id;
		DELETE FROM medical_services WHERE id = p_service_id;
	END IF;
END$$

/** Анализ → услуга. Зеркало предыдущей, нужна ровно одному случаю. */
CREATE PROCEDURE dedup_move_lab_test_to_service(
	IN p_service_id INT,
	IN p_lab_test_id INT
)
BEGIN
	IF (SELECT COUNT(*) FROM medical_services WHERE id = p_service_id) = 1
	   AND (SELECT COUNT(*) FROM lab_tests WHERE id = p_lab_test_id) = 1 THEN

		INSERT IGNORE INTO clinic_medical_services
			(medical_service_id, clinic_id, price, price_max, code, is_price_outdated)
		SELECT p_service_id, clinic_id, price, price_max, code, is_price_outdated
		  FROM clinic_lab_tests
		 WHERE lab_test_id = p_lab_test_id;

		UPDATE clinic_medical_services s
		  JOIN clinic_lab_tests t
		    ON t.clinic_id = s.clinic_id AND t.lab_test_id = p_lab_test_id
		   SET s.is_price_outdated = CASE
		           WHEN s.price IS NULL AND t.price IS NOT NULL THEN t.is_price_outdated
		           ELSE s.is_price_outdated
		       END,
		       s.price     = COALESCE(s.price, t.price),
		       s.price_max = COALESCE(s.price_max, t.price_max),
		       s.code      = COALESCE(s.code, t.code)
		 WHERE s.medical_service_id = p_service_id;

		INSERT IGNORE INTO medical_service_synonyms
			(medical_service_id, another_name, language)
		SELECT p_service_id, another_name, language
		  FROM lab_test_synonyms
		 WHERE lab_test_id = p_lab_test_id;

		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_service_id, TRIM(t.name_en), 'en' FROM lab_tests t
		 WHERE t.id = p_lab_test_id AND TRIM(COALESCE(t.name_en, '')) <> '';
		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_service_id, TRIM(t.name_sr), 'sr' FROM lab_tests t
		 WHERE t.id = p_lab_test_id AND TRIM(COALESCE(t.name_sr, '')) <> '';
		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_service_id, TRIM(t.name_sr_cyrl), 'sr-cyrl' FROM lab_tests t
		 WHERE t.id = p_lab_test_id AND TRIM(COALESCE(t.name_sr_cyrl, '')) <> '';
		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_service_id, TRIM(t.name_ru), 'ru' FROM lab_tests t
		 WHERE t.id = p_lab_test_id AND TRIM(COALESCE(t.name_ru, '')) <> '';
		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_service_id, TRIM(t.name_de), 'de' FROM lab_tests t
		 WHERE t.id = p_lab_test_id AND TRIM(COALESCE(t.name_de, '')) <> '';
		INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
		SELECT p_service_id, TRIM(t.name_tr), 'tr' FROM lab_tests t
		 WHERE t.id = p_lab_test_id AND TRIM(COALESCE(t.name_tr, '')) <> '';

		DELETE syn FROM medical_service_synonyms syn
		  JOIN medical_services m ON m.id = syn.medical_service_id
		 WHERE syn.medical_service_id = p_service_id
		   AND syn.another_name = CASE syn.language
		           WHEN 'en' THEN m.name_en
		           WHEN 'sr' THEN m.name_sr
		           WHEN 'sr-cyrl' THEN m.name_sr_cyrl
		           WHEN 'ru' THEN m.name_ru
		           WHEN 'de' THEN m.name_de
		           WHEN 'tr' THEN m.name_tr
		           ELSE NULL
		       END;

		UPDATE medical_service_tariffs
		   SET medical_service_id = p_service_id, lab_test_id = NULL
		 WHERE lab_test_id = p_lab_test_id;

		INSERT IGNORE INTO slug_redirects
			(entity_type, old_slug, entity_id, target_entity_type)
		SELECT 'labtests', slug, p_service_id, 'services'
		  FROM lab_tests
		 WHERE id = p_lab_test_id AND slug IS NOT NULL AND slug <> '';

		UPDATE slug_redirects
		   SET entity_id = p_service_id, target_entity_type = 'services'
		 WHERE entity_type = 'labtests'
		   AND COALESCE(target_entity_type, 'labtests') = 'labtests'
		   AND entity_id = p_lab_test_id;

		DELETE FROM clinic_lab_tests WHERE lab_test_id = p_lab_test_id;
		DELETE FROM lab_test_categories_relations WHERE lab_test_id = p_lab_test_id;
		DELETE FROM lab_test_redirects WHERE old_id = p_lab_test_id OR new_id = p_lab_test_id;
		DELETE FROM lab_tests WHERE id = p_lab_test_id;
	END IF;
END$$

DELIMITER ;

-- ===========================================================================
-- A. АНАЛИЗ → УСЛУГА (1)
-- ===========================================================================

-- Взятие гинекологических мазков — процедура, а не исследование.
CALL dedup_move_lab_test_to_service(2241, 1748);

-- ===========================================================================
-- B. УСЛУГА → АНАЛИЗ (160)
--    CALL dedup_move_service_to_lab_test(анализ, услуга, заводить_синонимы)
-- ===========================================================================

-- Histopathology of Liver Biopsy | Pregled biopsije jetre
CALL dedup_move_service_to_lab_test(1884, 5029, 1);
-- Histopathology of Cervical Biopsy | Pregled biopsije cerviksa uterusa
CALL dedup_move_service_to_lab_test(1858, 5106, 1);
-- Histopathology of Vulvar Biopsy | Pregled biopsije vulve
CALL dedup_move_service_to_lab_test(1879, 5109, 1);
-- Streptococcus Rapid Test | Test streptokoka
CALL dedup_move_service_to_lab_test(1148, 7040, 1);
-- Antibiogram | Antibiogram
CALL dedup_move_service_to_lab_test(288, 7235, 0);
-- Treponema Pallidum Microscopy | Mikroskopski pregled na Treponema pallidum
CALL dedup_move_service_to_lab_test(1996, 7236, 1);
-- Umbilical Swab Culture | Bris pupka
CALL dedup_move_service_to_lab_test(1849, 7243, 1);
-- Urine Culture | Urinokultura
CALL dedup_move_service_to_lab_test(1182, 7251, 1);
-- Stool Culture | Koprokultura
CALL dedup_move_service_to_lab_test(1154, 7252, 1);
-- Vibrio Cholerae Culture | Kultura na Vibrio cholerae
CALL dedup_move_service_to_lab_test(1998, 7254, 1);
-- Antibiogram Production | Izrada antibiograma
CALL dedup_move_service_to_lab_test(1999, 7257, 1);
-- Hair Dermatomycosis Examination | Pregled preparata dermatomikoze dlake
CALL dedup_move_service_to_lab_test(2000, 7260, 1);
-- Fungal Identification | Identifikacija gljivica
CALL dedup_move_service_to_lab_test(2003, 7273, 1);
-- Antimycogram | Izrada antimikograma
CALL dedup_move_service_to_lab_test(2004, 7274, 1);
-- Cryptosporidium Stool Examination Ziehl-Neelsen | Parazitološki pregled stolice Cryptosporidium Ziehl-Neelsen
CALL dedup_move_service_to_lab_test(2008, 7279, 1);
-- VDRL Test | VDRL
CALL dedup_move_service_to_lab_test(239, 7284, 1);
-- Waaler-Rose Test | WALLER-ROSE TEST
CALL dedup_move_service_to_lab_test(875, 7293, 1);
-- Antimicrobial Antibody Indirect Immunofluorescence | Detekcija antimikrobnih antitijela indirektnom imunofluorescencijom
CALL dedup_move_service_to_lab_test(2012, 7297, 1);
-- Microbial Antigen Direct Immunofluorescence | Detekcija mikrobnih antigena direktnom imunofluorescencijom
CALL dedup_move_service_to_lab_test(2013, 7298, 1);
-- Differential Blood Count | Diferencijalna krvna slika
CALL dedup_move_service_to_lab_test(4, 7308, 1);
-- Erythrocyte Sedimentation Rate | Sedimentacija eritrocita SE
CALL dedup_move_service_to_lab_test(328, 7310, 1);
-- Bleeding Time | Određivanje vremena krvarenja
CALL dedup_move_service_to_lab_test(7, 7312, 1);
-- Coagulation Time | Određivanje vremena koagulacije
CALL dedup_move_service_to_lab_test(8, 7313, 1);
-- Fibrinogen | Određivanje fibrinogena
CALL dedup_move_service_to_lab_test(6, 7314, 1);
-- Urine Creatinine | Kreatinin u urinu
CALL dedup_move_service_to_lab_test(88, 7340, 1);
-- Urine Urea | Urea u urinu
CALL dedup_move_service_to_lab_test(91, 7341, 1);
-- Urea Clearance | Klirens uree
CALL dedup_move_service_to_lab_test(93, 7342, 1);
-- Creatinine Clearance | Klirens kreatinina
CALL dedup_move_service_to_lab_test(90, 7343, 1);
-- Urine Uric Acid | Mokraćna kiselina u urinu
CALL dedup_move_service_to_lab_test(97, 7344, 1);
-- Urine Calcium | Kalcijum u urinu
CALL dedup_move_service_to_lab_test(99, 7345, 1);
-- Urine Phosphorus | Fosfor u urinu
CALL dedup_move_service_to_lab_test(101, 7346, 1);
-- Urine Urobilinogen | Urobilinogen u urinu
CALL dedup_move_service_to_lab_test(1978, 7350, 1);
-- Urine Bilirubin | Bilirubin u urinu
CALL dedup_move_service_to_lab_test(1975, 7351, 1);
-- Urine Alpha Amylase | Alfa amilaza u urinu
CALL dedup_move_service_to_lab_test(1427, 7352, 1);
-- HDL Cholesterol | HDL holesterol
CALL dedup_move_service_to_lab_test(24, 7357, 1);
-- Urine Chloride | Hloridi u urinu
CALL dedup_move_service_to_lab_test(1980, 7361, 1);
-- Aerobic Bacterial Culture of Blood | Bakteriološko ispitivanje krvi - aerobno
CALL dedup_move_service_to_lab_test(2020, 8030, 1);
-- Aerobic Bacterial Culture of Cerebrospinal Fluid | Bakteriološko ispitivanje likvora - aerobno
CALL dedup_move_service_to_lab_test(2021, 8031, 1);
-- Aerobic Bacterial Culture of Bile | Bakteriološko ispitivanje žuči - aerobno
CALL dedup_move_service_to_lab_test(2022, 8032, 1);
-- Ureaplasma urealyticum Culture | Kultura na Ureaplasma urealyticum
CALL dedup_move_service_to_lab_test(2023, 8033, 1);
-- Chlamydia trachomatis Culture | Kultura na Chlamydia trachomatis
CALL dedup_move_service_to_lab_test(2024, 8034, 1);
-- Mycoplasma hominis Culture | Kultura na Mycoplasma hominis
CALL dedup_move_service_to_lab_test(2025, 8035, 1);
-- Gonococcus Culture | Kultura na gonococcus
CALL dedup_move_service_to_lab_test(2026, 8036, 1);
-- Aerobic Bacterial Culture of Deep Throat Swab | Bakteriološko ispitivanje dubokog brisa grla - aerobno
CALL dedup_move_service_to_lab_test(2027, 8039, 1);
-- Aerobic Bacterial Culture of Blood Swab | Bakteriološko ispitivanje brisa krvi - aerobno
CALL dedup_move_service_to_lab_test(2028, 8040, 1);
-- Aerobic Bacterial Culture of Central Venous Catheter Insertion Site Swab | Bakteriološko ispitivanje brisa ulaznog mjesta centralnog venskog katetera - aerobno
CALL dedup_move_service_to_lab_test(2029, 8041, 1);
-- Aerobic Bacterial Culture of Urinary Catheter Tip Swab | Bakteriološko ispitivanje brisa vrha urinarnog katetera - aerobno
CALL dedup_move_service_to_lab_test(2030, 8042, 1);
-- Aerobic Bacterial Culture of Swan-Ganz Catheter Swab | Bakteriološko ispitivanje brisa Swan-Ganz katetera - aerobno
CALL dedup_move_service_to_lab_test(2031, 8043, 1);
-- Aerobic Bacterial Culture of Small Intestine Swab | Bakteriološko ispitivanje brisa tankog crijeva - aerobno
CALL dedup_move_service_to_lab_test(2032, 8044, 1);
-- Aerobic Bacterial Culture of Thoracic Drain Swab | Bakteriološko ispitivanje brisa torakalnog drena - aerobno
CALL dedup_move_service_to_lab_test(2033, 8045, 1);
-- Aerobic Bacterial Culture of Tracheobronchial Tree Swab | Bakteriološko ispitivanje brisa traheo-bronhijalnog stabla - aerobno
CALL dedup_move_service_to_lab_test(2034, 8046, 1);
-- Aerobic Bacterial Culture of Tracheoflex Tube Swab | Bakteriološko ispitivanje brisa traheofleksa - aerobno
CALL dedup_move_service_to_lab_test(2035, 8047, 1);
-- Aerobic Bacterial Culture of Endotracheal Tube Swab | Bakteriološko ispitivanje brisa tubusa - aerobno
CALL dedup_move_service_to_lab_test(2036, 8048, 1);
-- Aerobic Bacterial Culture of Gastric Content Swab | Bakteriološko ispitivanje brisa želudačnog sadržaja - aerobno
CALL dedup_move_service_to_lab_test(2037, 8049, 1);
-- Aerobic Bacterial Culture of Cannula Swab | Bakteriološko ispitivanje brisa kanile - aerobno
CALL dedup_move_service_to_lab_test(2039, 8051, 1);
-- Aerobic Bacterial Culture of Corneal Swab | Bakteriološko ispitivanje brisa rožnjače - aerobno
CALL dedup_move_service_to_lab_test(2040, 8052, 1);
-- Aerobic Bacterial Culture of Lochia Swab | Bakteriološko ispitivanje brisa lohija - aerobno
CALL dedup_move_service_to_lab_test(2041, 8053, 1);
-- Aerobic Bacterial Culture of Nephrostomy Tube Swab | Bakteriološko ispitivanje brisa nefrostome - aerobno
CALL dedup_move_service_to_lab_test(2042, 8054, 1);
-- Aerobic Bacterial Culture of Skin Around Central Venous Catheter Swab | Bakteriološko ispitivanje brisa okoline centralnog venskog katetera - aerobno
CALL dedup_move_service_to_lab_test(2043, 8055, 1);
-- Aerobic Bacterial Culture of External Fixator Pin Site Swab | Bakteriološko ispitivanje brisa okoline fiksatora - aerobno
CALL dedup_move_service_to_lab_test(2044, 8056, 1);
-- Aerobic Bacterial Culture of Intestinal Serosa Swab | Bakteriološko ispitivanje brisa ovojnice crijeva - aerobno
CALL dedup_move_service_to_lab_test(2045, 8057, 1);
-- Aerobic Bacterial Culture of Peritoneal Swab | Bakteriološko ispitivanje brisa peritoneuma - aerobno
CALL dedup_move_service_to_lab_test(2046, 8058, 1);
-- Aerobic Bacterial Culture of Pleural Swab | Bakteriološko ispitivanje brisa pleure - aerobno
CALL dedup_move_service_to_lab_test(2047, 8059, 1);
-- Aerobic Bacterial Culture of Abdominal Drain Swab | Bakteriološko ispitivanje brisa abdominalnog drena - aerobno
CALL dedup_move_service_to_lab_test(2048, 8060, 1);
-- Aerobic Bacterial Culture of Axillary Region Swab | Bakteriološko ispitivanje brisa aksilarne regije - aerobno
CALL dedup_move_service_to_lab_test(2049, 8061, 1);
-- Aerobic Bacterial Culture of Aortic Valve Swab | Bakteriološko ispitivanje brisa aortne valvule - aerobno
CALL dedup_move_service_to_lab_test(2050, 8062, 1);
-- Aerobic Bacterial Culture of Arterial Catheter Swab | Bakteriološko ispitivanje brisa arterijskog katetera - aerobno
CALL dedup_move_service_to_lab_test(2051, 8063, 1);
-- Aerobic Bacterial Culture of Aspiration Tube Swab | Bakteriološko ispitivanje brisa aspiracione sonde - aerobno
CALL dedup_move_service_to_lab_test(2052, 8064, 1);
-- Aerobic Bacterial Culture of Intravascular Catheter Tip | Bakteriološko ispitivanje vrha intravaskularnog katetera - aerobno
CALL dedup_move_service_to_lab_test(2053, 8065, 1);
-- Aerobic Bacterial Culture of Buccal Mucosa Swab | Bakteriološko ispitivanje brisa bukalne sluznice - aerobno
CALL dedup_move_service_to_lab_test(2054, 8066, 1);
-- Aerobic Bacterial Culture of Central Venous Catheter Swab | Bakteriološko ispitivanje brisa centralnog venskog katetera - aerobno
CALL dedup_move_service_to_lab_test(2055, 8067, 1);
-- Aerobic Bacterial Culture of Colon Swab | Bakteriološko ispitivanje brisa debelog crijeva - aerobno
CALL dedup_move_service_to_lab_test(2056, 8068, 1);
-- Aerobic Bacterial Culture of Inguinal Region Swab | Bakteriološko ispitivanje brisa ingvinalne regije - aerobno
CALL dedup_move_service_to_lab_test(2057, 8069, 1);
-- Aerobic Bacterial Culture of Intravascular Catheter Sheath Swab | Bakteriološko ispitivanje brisa intravaskularnog katetera (šita) - aerobno
CALL dedup_move_service_to_lab_test(2058, 8070, 1);
-- Aerobic Bacterial Culture of Expressed Prostatic Secretion | Bakteriološko ispitivanje eksprimata prostate - aerobno
CALL dedup_move_service_to_lab_test(2060, 8072, 1);
-- Aerobic Bacterial Culture of Nasogastric Tube Lavage Fluid | Bakteriološko ispitivanje lavata nazogastrične sonde - aerobno
CALL dedup_move_service_to_lab_test(2061, 8073, 1);
-- Aerobic Bacterial Culture of Peritoneal Fluid | Bakteriološko ispitivanje peritonealne tečnosti - aerobno
CALL dedup_move_service_to_lab_test(2063, 8074, 1);
-- Aerobic Bacterial Culture of Adnexal Contents | Bakteriološko ispitivanje sadržaja adneksa - aerobno
CALL dedup_move_service_to_lab_test(2064, 8075, 1);
-- Aerobic Bacterial Culture of Drain Fluid | Bakteriološko ispitivanje sadržaja drena - aerobno
CALL dedup_move_service_to_lab_test(2065, 8076, 1);
-- Aerobic Bacterial Culture of Middle Ear Secretion | Bakteriološko ispitivanje sekreta iz srednjeg uva - aerobno
CALL dedup_move_service_to_lab_test(2066, 8077, 1);
-- Aerobic Bacterial Culture of Urethroprostatic Secretion | Bakteriološko ispitivanje uretroprostatičnog sekreta - aerobno
CALL dedup_move_service_to_lab_test(2067, 8078, 1);
-- Aerobic Bacterial Culture of Nephrostomy Urine | Bakteriološko ispitivanje urina (nefrostome) - aerobno
CALL dedup_move_service_to_lab_test(2068, 8079, 1);
-- Aerobic Bacterial Culture of Arterial Catheter Tip | Bakteriološko ispitivanje vrha arterijskog katetera - aerobno
CALL dedup_move_service_to_lab_test(2069, 8080, 1);
-- Aerobic Bacterial Culture of Aspiration Catheter Tip | Bakteriološko ispitivanje vrha aspiracionog katetera - aerobno
CALL dedup_move_service_to_lab_test(2070, 8081, 1);
-- Aerobic Bacterial Culture of Bronchoscope Swab | Bakteriološko ispitivanje brisa bronhoskopa - aerobno
CALL dedup_move_service_to_lab_test(2071, 8083, 1);
-- Aerobic Bacterial Culture of Central Venous Catheter Tip | Bakteriološko ispitivanje vrha centralnog venskog katetera - aerobno
CALL dedup_move_service_to_lab_test(2072, 8084, 1);
-- Aerobic Bacterial Culture of Gastric Content | Bakteriološko ispitivanje želudačnog sadržaja - aerobno
CALL dedup_move_service_to_lab_test(2073, 8085, 1);
-- Aerobic Bacterial Culture of Cannula Insertion Site | Bakteriološko ispitivanje otvora kanile - aerobno
CALL dedup_move_service_to_lab_test(2075, 8086, 1);
-- Aerobic Bacterial Culture of Placental Tissue | Bakteriološko ispitivanje tkiva posteljice - aerobno
CALL dedup_move_service_to_lab_test(2078, 8089, 1);
-- Anaerobic Bacterial Culture of Small Intestine Swab | Bakteriološko ispitivanje brisa tankog crijeva - anaerobno
CALL dedup_move_service_to_lab_test(2081, 8092, 1);
-- Anaerobic Bacterial Culture of Thoracic Drain Swab | Bakteriološko ispitivanje brisa torakalnog drena - anaerobno
CALL dedup_move_service_to_lab_test(2082, 8093, 1);
-- Anaerobic Bacterial Culture of Intestinal Serosa Swab | Bakteriološko ispitivanje brisa ovojnice crijeva - anaerobno
CALL dedup_move_service_to_lab_test(2083, 8094, 1);
-- Anaerobic Bacterial Culture of Peritoneum Swab | Bakteriološko ispitivanje brisa peritoneuma - anaerobno
CALL dedup_move_service_to_lab_test(2084, 8095, 1);
-- Anaerobic Bacterial Culture of Abdominal Drain Swab | Bakteriološko ispitivanje brisa abdominalnog drena - anaerobno
CALL dedup_move_service_to_lab_test(2085, 8096, 1);
-- Anaerobic Bacterial Culture of Wound Swab | Bakteriološko ispitivanje brisa rane - anaerobno
CALL dedup_move_service_to_lab_test(2086, 8097, 1);
-- Anaerobic Bacterial Culture of Abscess Content | Bakteriološko ispitivanje sadržaja abscesa - anaerobno
CALL dedup_move_service_to_lab_test(2087, 8098, 1);
-- Anaerobic Bacterial Culture of Uterine Cavity Swab | Bakteriološko ispitivanje brisa iz cavum uterusa - anaerobno
CALL dedup_move_service_to_lab_test(2088, 8099, 1);
-- Anaerobic Bacterial Culture of Adnexal Content | Bakteriološko ispitivanje sadržaja adneksa - anaerobno
CALL dedup_move_service_to_lab_test(2089, 8100, 1);
-- Anaerobic Bacterial Culture of Blood | Bakteriološko ispitivanje krvi - anaerobno
CALL dedup_move_service_to_lab_test(2090, 8101, 1);
-- Anaerobic Bacterial Culture of Placental Segment | Bakteriološko ispitivanje isječka posteljice - anaerobno
CALL dedup_move_service_to_lab_test(2092, 8103, 1);
-- Anaerobic Bacterial Culture of Large Intestine Swab | Bakteriološko ispitivanje brisa debelog crijeva - anaerobno
CALL dedup_move_service_to_lab_test(2094, 8104, 1);
-- Anaerobic Bacterial Culture of Peritoneal Fluid | Bakteriološko ispitivanje peritonealne tečnosti - anaerobno
CALL dedup_move_service_to_lab_test(2095, 8105, 1);
-- Echinococcus spp. Detection - Stained Preparation | Ispitivanje prisustva Echinococcus spp. - bojeni preparat
CALL dedup_move_service_to_lab_test(2097, 8107, 1);
-- Echinococcus spp. Detection - Native Preparation | Ispitivanje prisustva Echinococcus spp. - nativni preparat
CALL dedup_move_service_to_lab_test(2098, 8108, 1);
-- Babesia spp. Detection - Stained Thick Blood Film | Ispitivanje prisustva Babesia spp. - bojeni preparat guste kapi
CALL dedup_move_service_to_lab_test(2099, 8109, 1);
-- Babesia spp. Detection - Stained Blood Smear | Ispitivanje prisustva Babesia spp. - bojeni preparat krvnog razmaza
CALL dedup_move_service_to_lab_test(2100, 8110, 1);
-- Cryptococcus spp. Detection - Culture | Ispitivanje prisustva Cryptococcus spp. - kultivacija
CALL dedup_move_service_to_lab_test(2101, 8111, 1);
-- Cryptococcus spp. Detection - Stained Preparation | Ispitivanje prisustva Cryptococcus spp. - bojeni preparat
CALL dedup_move_service_to_lab_test(2102, 8112, 1);
-- Cryptococcus spp. Detection - India Ink Preparation | Ispitivanje prisustva Cryptococcus spp. - tuš preparat
CALL dedup_move_service_to_lab_test(2103, 8113, 1);
-- Blood and Tissue Parasites Detection - Stained Thick Blood Film | Ispitivanje prisustva krvnih i tkivnih parazita - bojeni preparat guste kapi
CALL dedup_move_service_to_lab_test(2104, 8114, 1);
-- Blood and Tissue Parasites Detection - Stained Blood Smear | Ispitivanje prisustva krvnih i tkivnih parazita - bojeni preparat krvnog razmaza
CALL dedup_move_service_to_lab_test(2105, 8115, 1);
-- Blood and Tissue Parasites Detection - Native Preparation | Ispitivanje prisustva krvnih i tkivnih parazita - nativni preparat
CALL dedup_move_service_to_lab_test(2106, 8116, 1);
-- Leishmania spp. Detection - Stained Preparation of Bone Marrow Aspirate | Ispitivanje prisustva Leishmania spp. - bojeni preparat punktata koštane srži
CALL dedup_move_service_to_lab_test(2107, 8118, 1);
-- Plasmodium spp. Detection - Stained Thick Blood Film | Ispitivanje prisustva Plasmodium spp. - bojeni preparat guste kapi
CALL dedup_move_service_to_lab_test(2108, 8119, 1);
-- Plasmodium spp. Detection - Stained Blood Smear | Ispitivanje prisustva Plasmodium spp. - bojeni preparat krvnog razmaza
CALL dedup_move_service_to_lab_test(2109, 8120, 1);
-- Toxoplasma gondii Detection - Stained Preparation | Ispitivanje prisustva Toxoplasma gondii - bojeni preparat
CALL dedup_move_service_to_lab_test(2110, 8121, 1);
-- Brucella Abortus Antibodies (Agglutination) | Anti Brucella abortus antitijela - aglutinacija
CALL dedup_move_service_to_lab_test(2111, 8125, 1);
-- Brucella Melitensis Antibodies (Agglutination) | Anti Brucella melitensis antitijela - aglutinacija
CALL dedup_move_service_to_lab_test(2112, 8126, 1);
-- Brucella IgG Antibodies (ELISA) | Anti Brucella IgG antitijela - ELISA
CALL dedup_move_service_to_lab_test(2113, 8128, 1);
-- Brucella IgA Antibodies (ELISA) | Anti Brucella IgA antitijela - ELISA
CALL dedup_move_service_to_lab_test(2114, 8129, 1);
-- Anti-Echinococcus granulosus Antibodies (Indirect Hemagglutination) | Anti Echinococcus granulosus antitijela - indirektna hemaglutinacija
CALL dedup_move_service_to_lab_test(2121, 8140, 1);
-- Anti-HBc Antibodies (ELISA) | Anti HBc antitijela - ELISA
CALL dedup_move_service_to_lab_test(2124, 8143, 1);
-- Anti-HBc IgM Antibodies (ELISA) | Anti HBc IgM antitijela - ELISA
CALL dedup_move_service_to_lab_test(2125, 8144, 1);
-- Anti-HIV 1 Antibodies - Confirmatory Test (Western Blot) | Anti HIV 1 antitijela - potvrdni test - Western Blot
CALL dedup_move_service_to_lab_test(2130, 8152, 1);
-- Anti-HIV 2 Antibodies - Confirmatory Test (Western Blot) | Anti HIV 2 antitijela - potvrdni test - Western Blot
CALL dedup_move_service_to_lab_test(2131, 8153, 1);
-- Influenza A Virus IgG ELISA | Anti influenza A virus IgG - ELISA
CALL dedup_move_service_to_lab_test(2135, 8157, 1);
-- Legionella Pneumophila IgA ELISA | Anti Legionella pneumophila IgA - ELISA
CALL dedup_move_service_to_lab_test(2136, 8160, 1);
-- Leishmania Donovani Antibodies (Indirect Hemagglutination) | Anti Leishmania donovani antitijela - indirektna hemaglutinacija
CALL dedup_move_service_to_lab_test(2138, 8161, 1);
-- Leptospira IgM ELISA | Anti Leptospira IgM - ELISA
CALL dedup_move_service_to_lab_test(2139, 8162, 1);
-- Leptospira IgG ELISA | Anti Leptospira IgG - ELISA
CALL dedup_move_service_to_lab_test(2140, 8163, 1);
-- Rubella Virus IgG Western Blot | Anti rubella virus IgG - Western Blot
CALL dedup_move_service_to_lab_test(2141, 8164, 1);
-- Salmonella Group A, H Antibodies (Widal Agglutination) | Anti Salmonella gr. A, H antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2142, 8165, 1);
-- Salmonella Group A, O Antibodies (Widal Agglutination) | Anti Salmonella gr. A, O antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2143, 8166, 1);
-- Salmonella Group B, H Antibodies (Widal Agglutination) | Anti Salmonella gr. B, H antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2144, 8167, 1);
-- Salmonella Group B, O Antibodies (Widal Agglutination) | Anti Salmonella gr. B, O antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2145, 8168, 1);
-- Salmonella Group C, H Antibodies (Widal Agglutination) | Anti Salmonella gr. C, H antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2146, 8169, 1);
-- Salmonella Group C, O Antibodies (Widal Agglutination) | Anti Salmonella gr. C, O antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2147, 8170, 1);
-- Salmonella Group D, H Antibodies (Widal Agglutination) | Anti Salmonella gr. D, H antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2148, 8171, 1);
-- Salmonella Group D, O Antibodies (Widal Agglutination) | Anti Salmonella gr. D, O antitijela (Vidal) - aglutinacija
CALL dedup_move_service_to_lab_test(2149, 8172, 1);
-- Trichinella Spiralis Antibodies (Indirect Immunofluorescence) | Anti Trichinella spiralis antitijela - indirektna imunofluorescencija
CALL dedup_move_service_to_lab_test(2150, 8175, 1);
-- HBs Antigen Detection - Confirmatory Test (ELISA) | Ispitivanje prisustva HBs antigena - potvrdni test - ELISA
CALL dedup_move_service_to_lab_test(2154, 8185, 1);
-- Herpes Simplex Virus Type 1 Detection (Direct Immunofluorescence) | Ispitivanje prisustva Herpes Simplex virusa tip 1 - direktna imunofluorescencija
CALL dedup_move_service_to_lab_test(2155, 8186, 1);
-- Herpes Simplex Virus Type 2 Detection (Direct Immunofluorescence) | Ispitivanje prisustva Herpes Simplex virusa tip 2 - direktna imunofluorescencija
CALL dedup_move_service_to_lab_test(2156, 8187, 1);
-- P24 Antigen Detection - Confirmatory Test (ELISA) | Ispitivanje prisustva P24 antigena - potvrdni test - ELISA
CALL dedup_move_service_to_lab_test(2158, 8189, 1);
-- Urethral, Vaginal or Cervical Gonorrhea Smear Examination | Pregled preparata uretralnog, vaginalnog ili cervikalnog brisa na gonoreju
CALL dedup_move_service_to_lab_test(1995, 8190, 1);
-- Amine Test | Aminski test
CALL dedup_move_service_to_lab_test(288, 8191, 1);
-- Stool Protozoa Microscopy - Concentration Method | Mikroskopski pregled stolice na protozoe (metoda koncentracije)
CALL dedup_move_service_to_lab_test(2006, 8199, 1);
-- Native Microscopic Preparation for Amoebae with Provocation | Nativni mikroskopski preparat na amebe sa provokacijom
CALL dedup_move_service_to_lab_test(2007, 8200, 1);
-- Post-Transfusion Reaction Testing | Ispitivanje posttransfuzionih reakcija
CALL dedup_move_service_to_lab_test(2316, 8204, 1);
-- Immune Antibody Testing | Ispitivanje imunih antitijela
CALL dedup_move_service_to_lab_test(2317, 8205, 1);
-- Hgb/Hct Determination | Određivanje Hgb/Hct
CALL dedup_move_service_to_lab_test(2318, 8206, 1);
-- Rh Phenotype Testing (Gel Method) | Ispitivanje Rh-fenotipa/gel metoda
CALL dedup_move_service_to_lab_test(2319, 8211, 1);
-- Serial ABO/Rh Blood Group Testing (Microtiter Plate) | Serijsko ispitivanje ABO/Rh krvnih grupa - mikrotitar ploča
CALL dedup_move_service_to_lab_test(2320, 8212, 1);
-- Serial ABO/Rh Blood Group Testing (Gel Method) | Serijsko ispitivanje ABO/Rh krvnih grupa - gel tehnika
CALL dedup_move_service_to_lab_test(2321, 8213, 1);
-- Antibody Identification (Gel Method) | Identifikacija antitijela/gel metoda
CALL dedup_move_service_to_lab_test(2324, 8216, 1);
-- HBeAg Test | Test na HBeAg
CALL dedup_move_service_to_lab_test(2325, 8218, 1);
-- Anti-HBe Antibody Test | Test na Anti-HBe antitijela
CALL dedup_move_service_to_lab_test(2326, 8219, 1);
-- Anti-HBc Antibody Test | Test na Anti-HBc antitijela
CALL dedup_move_service_to_lab_test(2327, 8220, 1);
-- Anti-HBs Antibody Test | Test na Anti-HBs antitijela
CALL dedup_move_service_to_lab_test(2328, 8221, 1);
-- Spermogram | Spermogram
CALL dedup_move_service_to_lab_test(253, 8222, 1);
-- ===========================================================================

DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test;
DROP PROCEDURE IF EXISTS dedup_move_lab_test_to_service;
