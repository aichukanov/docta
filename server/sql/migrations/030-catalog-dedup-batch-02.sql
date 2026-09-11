-- Дедупликация каталога, батч 2 — ВЕСЬ остаток очередей после батча 1.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/030-catalog-dedup-batch-02.sql
--
-- ПОРЯДОК ПРИМЕНЕНИЯ: 027 → 028 → 029 → 030.
-- Порядок обязателен: часть решений здесь опирается на то, что 027 и 029 уже
-- отработали (цели перенацелены на уцелевшие записи, см. ниже).
--
-- ИТОГ: 80 слияний (55 услуг + 25 анализов), 349 отказов.
-- Ещё 9 пар в миграции не упомянуты: обе их половинки или одна из них
-- сливаются здесь же, и строки очереди уйдут по FK CASCADE.
-- Вместе с батчем 1 это закрывает очереди целиком: 523 пары из детекторов
-- разобраны, ни одной pending не остаётся.
--
-- ОТКУДА ЦИФРЫ. В очередях было 465 пар по услугам и 58 по анализам.
-- Батч 1 (027) разобрал 50; ещё 29 пар исчезают вместе с записями, которые
-- удаляют 027 и 029. Здесь — оставшиеся 438.
--
-- КАК ПРИНИМАЛИСЬ РЕШЕНИЯ
--
-- Главный различитель — код прайса, а не название. Две записи с РАЗНЫМИ
-- кодами ФЗОЦГ и разной ценой это разные позиции прайса, как бы похоже они
-- ни назывались: прайс сам по себе авторитет. По этому правилу отклонены
-- 136 пар тира C, целиком состоящие из градуированных семейств:
--   * гипс по возрасту (Y10025 «до 10 годин» / Y10026 «изнад 10 годин»);
--   * каутеризация по числу образований (X02031 одно / X02032 два /
--     X02043 три / X02044 четыре / X02045 пять и более);
--   * репозиции переломов по кости и способу (D05051 / D05132, X09085 /
--     X09097 / X09115);
--   * рентген «без профилей» / «с профилями», «за снимок» / всё исследование.
-- Остальные отказы — содержательные пары: родовая услуга против уточнённой
-- («Kontrolni specijalistički pregled» против контроля у конкретного
-- специалиста), процедура против её анализа (биопсия против патогистологии),
-- разные материалы и бренды (коронка CoCr / золото / Shofu, All-on-4
-- Nobel / Straumann / Zimmer, ботокс Bocouture / Xeomin), разный объём
-- (лицо+шея против лицо+шея+декольте), разная анестезия и техника
-- (лапароскопия и лазер против открытой операции).
--
-- Сливались, наоборот, пары с ОДНИМ кодом прайса в разных клиниках и пары,
-- где различие только в формулировке: «Uklanjanje stranog tela iz grla» и
-- «Odstranjivanje stranog tijela iz grla», «Adenoidektomija» и «Adenotomija»,
-- «Resekcija korijena zuba» и «Apikoektomija», «Marihuana» и «Kanabinoidi THC».
--
-- ПЕРЕНАЦЕЛЕННЫЕ СЛИЯНИЯ. Три пары в очереди указывали на запись, которая
-- сама здесь сливается, поэтому цель заменена на уцелевшую:
--   (2291, 3217) → CALL …(2039, 3217)   2291 сливается в 2039
--   (2003, 7223) → CALL …(1552, 7223)   2003 сливается в 1552
--   (2004, 7224) → CALL …(1553, 7224)   2004 сливается в 1553
-- Исходные строки очереди уйдут по CASCADE, отдельного отказа им не нужно.
--
-- ЧТО НАЙДЕНО ПОПУТНО И СЮДА НЕ ВОШЛО (отдельные задачи, не дедупликация)
--
--   * Блок I03 у клиники 80 сдвинут на единицу. Услуга «Defektološko
--     ispitivanje malog djeteta» (7188) несёт код I03007, но в прайсе ФЗОЦГ
--     I03007 — это «ispitivanje školskog djeteta», а «malog» это I03006
--     (клиника 131 проставила верно). Сдвиг сквозной по всему блоку
--     7188–7203, и привязка medical_service_tariffs пошла за неверными
--     кодами: на странице услуги показывается чужой тариф. Нужен отдельный
--     проход по блоку.
--   * Тариф I01002 существует в двух прайсах с разным смыслом («Kontrolni
--     preventivni pregled rizičnog neonatusa» в PZZ и «Ponovni pregled -
--     infektolog» в секундарном) и оба привязаны к услуге 4887.
--   * Анализ 183 «Pro-BNP» держит строку клиники 88 по коду Z02071, который
--     ФЗОЦГ называет просто «BNP». BNP, Pro-BNP и NT-proBNP — три разных
--     аналита, поэтому пары (183, 2348) и (183, 576) отклонены, но название
--     183 стоит перепроверить по прайсу клиники.
--   * svc 3529 «Hirurška korekcija malih usana» — по-сербски это читается и
--     как «коррекция малых губ» (лабиопластика), и как уменьшение губ;
--     цена совпадает с 3487 «Hirurška korekcija usana». Пара отклонена,
--     но формулировку нужно уточнить у клиники 15.
--   * Пары MSCT-ангиографии аорты (3191 / 3877 / 3878) у клиники 68:
--     «abdominalne aorte i donjih ekstremiteta» 285 € и «aorte i donjih
--     ekstremiteta» 325 €, а каталожная 3191 подхватила цену 285. Какая из
--     двух строк прайса ей соответствует, по данным не установить.

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
-- A. СЛИЯНИЯ — УСЛУГИ (55)
-- ===========================================================================

-- Sedation and Anesthesia for Ambulatory Surgery <- Sedation and Anesthesia for Outpatient Surgical Interventions
CALL dedup_merge_medical_service(5828, 7957);
-- Other Peripheral Nerve Block <- Block of Other Peripheral Nerves
CALL dedup_merge_medical_service(5831, 7959);
-- Mediastinum X-Ray <- X-Ray Mediastinum
CALL dedup_merge_medical_service(4928, 7863);
-- First Microbiologist Examination <- First Microbiologist Specialist Examination
CALL dedup_merge_medical_service(4982, 7231);
-- Vulvar and Vaginal Condyloma Abrasion <- Vulva and Vagina Condyloma Removal
CALL dedup_merge_medical_service(5431, 7085);
-- Pregnancy Ultrasound <- Pregnancy Ultrasound Examination
CALL dedup_merge_medical_service(5433, 7070);
-- Single-Point Pharmacopuncture <- Single-Point Application - Pharmacopuncture
CALL dedup_merge_medical_service(5829, 7958);
-- Erythrocyte Suspension in OAS Preparation <- Preparation of Erythrocytes in Additive Solution (SAGM)
CALL dedup_merge_medical_service(5813, 8024);
-- Ergocycle Stress Test with Complete ECG <- Cycle Ergometer Stress Test with Complete ECG
CALL dedup_merge_medical_service(5821, 7433);
-- Brachial Plexus Block <- Plexus Brachialis Block
CALL dedup_merge_medical_service(5836, 7962);
-- Plastic Surgeon Follow-up Examination <- Follow-up Plastic Surgeon Examination
CALL dedup_merge_medical_service(3733, 7967);
-- Foreign Body Removal from Throat <- Foreign Body Removal Throat
CALL dedup_merge_medical_service(7042, 1512);
-- MRI Abdomen with MRCP <- MRCP with Abdomen MRI
CALL dedup_merge_medical_service(3158, 3811);
-- Holter Blood Pressure Monitoring <- Ambulatory Blood Pressure Monitoring (ABPM)
CALL dedup_merge_medical_service(7411, 7953);
-- Intraocular Pressure Determination <- Intraocular Pressure Measurement
CALL dedup_merge_medical_service(1626, 2272);
-- Apicoectomy <- Root Resection Apicoectomy
CALL dedup_merge_medical_service(4027, 1721);
-- Skeletal Partial Denture <- Skeletal Denture
CALL dedup_merge_medical_service(1685, 4014);
-- Ophthalmic Ultrasound (A-Scan and B-Scan) <- A-Scan and B-Scan Ophthalmic Ultrasound
CALL dedup_merge_medical_service(5463, 4726);
-- Topical Fluoride Treatment <- Topical Fluoride Application
CALL dedup_merge_medical_service(4366, 4543);
-- X-Ray Paranasal Sinuses <- X-Ray Sinuses
CALL dedup_merge_medical_service(3202, 2007);
-- Developmental Defectology Assessment Small Child <- Defectological Examination of a Young Child
CALL dedup_merge_medical_service(7188, 8012);
-- Developmental Defectology Assessment School Child <- Defectological Examination of a School-Age Child
CALL dedup_merge_medical_service(7189, 8013);
-- Group Defectology Treatment School Child <- Defectological Group Treatment of a School-Age Child
CALL dedup_merge_medical_service(7199, 8015);
-- Doppler Neck Blood Vessels <- Neck Doppler
CALL dedup_merge_medical_service(1551, 2002);
-- Intravenous Medication Application <- Intravenous Therapy Administration
CALL dedup_merge_medical_service(1980, 1593);
-- Magnetic Therapy <- Magnetotherapy
CALL dedup_merge_medical_service(3265, 7407);
-- Cephalometric X-Ray <- Cephalometric Head Radiograph
CALL dedup_merge_medical_service(4975, 7820);
-- Doppler Upper Extremity Blood Vessels <- Upper Extremity Doppler
CALL dedup_merge_medical_service(1552, 2003);
-- Doppler Lower Extremity Blood Vessels <- Lower Extremity Doppler
CALL dedup_merge_medical_service(1553, 2004);
-- Sinus Ultrasound <- Paranasal Sinus Ultrasound
CALL dedup_merge_medical_service(4893, 4595);
-- Adenotomy <- Adenoidectomy
CALL dedup_merge_medical_service(6351, 4618);
-- Hallux Valgus Surgery <- Bunion Surgery
CALL dedup_merge_medical_service(4705, 7884);
-- Oncological Surgeon Examination <- Oncosurgeon Examination
CALL dedup_merge_medical_service(3721, 3763);
-- Topical Eye Medication Application <- Topical Eye Drug Application
CALL dedup_merge_medical_service(4252, 5469);
-- Follow-up Infectious Disease Specialist Examination <- Follow-up Infectologist Examination
CALL dedup_merge_medical_service(4887, 7827);
-- Artificial Anus Care <- Colostomy Site Care
CALL dedup_merge_medical_service(5296, 7050);
-- Sciatic Nerve Block <- Nervus Ischiadicus Block
CALL dedup_merge_medical_service(5835, 7961);
-- Ultrasound Lymph Nodes <- Lymph Node Ultrasound
CALL dedup_merge_medical_service(3843, 7220);
-- First Psychiatrist Examination <- First Psychiatric Examination
CALL dedup_merge_medical_service(5193, 3773);
-- Follow-up Psychiatrist Examination <- Follow-up Psychiatric Examination
CALL dedup_merge_medical_service(5194, 3774);
-- Lung Fluoroscopy <- Pulmonary Fluoroscopy
CALL dedup_merge_medical_service(4961, 7211);
-- Intraoral X-Ray <- Digital Intraoral X-Ray
CALL dedup_merge_medical_service(1652, 4545);
-- X-Ray Chest <- X-Ray Chest with Profile
CALL dedup_merge_medical_service(2297, 2036);
-- X-Ray Pelvis <- X-Ray Pelvis with Hips
CALL dedup_merge_medical_service(2039, 2291);
-- X-Ray Pelvis <- X-Ray Both Hips with Pelvis
CALL dedup_merge_medical_service(2039, 3217);
-- Face and Body Skin Tightening <- Face and Body Tightening
CALL dedup_merge_medical_service(4205, 4207);
-- Surgical Upper Lip Lift <- Upper Lip Lift
CALL dedup_merge_medical_service(3539, 4154);
-- Home Visit City Center <- Home Visit Center
CALL dedup_merge_medical_service(2067, 260);
-- First Radiologist Examination <- First Radiologist Specialist Examination
CALL dedup_merge_medical_service(4924, 7204);
-- Ultrasound Thyroid and Parathyroid Glands <- Thyroid and Parathyroid Ultrasound
CALL dedup_merge_medical_service(3246, 7221);
-- Doppler Upper Extremity Blood Vessels <- Upper Extremity Doppler Ultrasound
CALL dedup_merge_medical_service(1552, 7223);
-- Doppler Lower Extremity Blood Vessels <- Lower Extremity Doppler Ultrasound
CALL dedup_merge_medical_service(1553, 7224);
-- X-Ray Chest <- Chest X-Ray Lungs
CALL dedup_merge_medical_service(2297, 7212);
-- Hepatobiliary Tract X-Ray <- Hepatobiliary X-Ray
CALL dedup_merge_medical_service(4929, 7214);
-- Atheroma, Cyst, Xanthoma or Small Benign Tumor Excision <- Atheroma Cyst or Benign Tumor Excision
CALL dedup_merge_medical_service(5328, 7065);

-- ===========================================================================
-- B. СЛИЯНИЯ — АНАЛИЗЫ (25)
-- ===========================================================================

-- Vitamin A <- Vitamin A Level
CALL dedup_merge_lab_test(896, 885);
-- Direct Microscopic Preparation <- Direct Microscopic Preparation Swab
CALL dedup_merge_lab_test(300, 303);
-- Valproic Acid <- Valproic Acid Level
CALL dedup_merge_lab_test(58, 1101);
-- Drug Panel 5 New <- Drug Panel 5
CALL dedup_merge_lab_test(708, 118);
-- Protia Allergy Q64 Nutritive Panel 72 Allergens <- Protia Allergy Q64 Food Panel 72 Allergens
CALL dedup_merge_lab_test(1670, 1922);
-- Oral Cavity Fungi <- Oral Cavity Swab Fungi
CALL dedup_merge_lab_test(1157, 1731);
-- Urine Culture <- Bacteriological Examination Urine Culture
CALL dedup_merge_lab_test(1182, 278);
-- Prothrombin Time PT INR <- INR
CALL dedup_merge_lab_test(557, 14);
-- Marijuana <- Cannabinoids THC
CALL dedup_merge_lab_test(120, 608);
-- Ecstasy <- Ecstasy MDMA
CALL dedup_merge_lab_test(124, 695);
-- Ureaplasma Parvum PCR <- Ureaplasma parvum (Real-Time PCR)
CALL dedup_merge_lab_test(1328, 1928);
-- Ureaplasma Urealyticum PCR <- Ureaplasma urealyticum (Real-Time PCR)
CALL dedup_merge_lab_test(1337, 1929);
-- Candida Albicans PCR <- Candida albicans (Real-Time PCR)
CALL dedup_merge_lab_test(1795, 1931);
-- Calprotectin <- Fecal Calprotectin
CALL dedup_merge_lab_test(1119, 1754);
-- PAP Papanicolaou Test <- Pap Smear Test
CALL dedup_merge_lab_test(1305, 1790);
-- Panel 3 (Chlamydia trachomatis; Mycoplasma hominis; Ureaplasma urealyticum) <- Panel 3
CALL dedup_merge_lab_test(1947, 62);
-- Tuna IgE f40 <- Tuna Meat IgE f40
CALL dedup_merge_lab_test(964, 986);
-- SARS-CoV-2 IgG Spike Protein <- SARS-CoV-2 IgG Spike
CALL dedup_merge_lab_test(251, 1298);
-- Glucose Before and 2h After Meal <- Glucose Before and After Meal
CALL dedup_merge_lab_test(580, 327);
-- HCV PCR RNA Quantitative <- HCV PCR Quantitative
CALL dedup_merge_lab_test(1310, 311);
-- Coxsackie Virus IgM <- Coxsackie Virus IgM ELISA
CALL dedup_merge_lab_test(1274, 2119);
-- Coxsackie Virus IgG <- Coxsackie Virus IgG ELISA
CALL dedup_merge_lab_test(1275, 2120);
-- HBV PCR DNA Quantitative <- HBV DNA Quantitative
CALL dedup_merge_lab_test(1308, 316);
-- SARS-CoV-2 PCR <- PCR CoV-2
CALL dedup_merge_lab_test(1780, 319);
-- Eye Swab Chlamydia <- Chlamydia Trachomatis Eye Swab
CALL dedup_merge_lab_test(1718, 1844);

-- ===========================================================================
-- C. ОТКАЗЫ (349)
-- ===========================================================================

UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((2135, 3664), (2017, 2018), (6706, 6707), (2242, 2259), (5700, 5701), (7177, 7375), (6430, 6505), (5951, 6573));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((4299, 8225), (3202, 7207), (3352, 7048), (1709, 4017), (4527, 4528), (2035, 2297), (1929, 1931), (2038, 3218));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((4527, 4530), (1551, 2104), (6975, 6977), (6530, 6532), (5669, 6428), (4926, 4959), (5670, 5677), (5670, 5687));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((2015, 2016), (6997, 6998), (7001, 7002), (7007, 7008), (5332, 5345), (5332, 5333), (5332, 5343), (5332, 5344));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((5333, 5343), (5333, 5344), (5333, 5345), (5343, 5344), (5343, 5345), (5344, 5345), (7003, 7004), (1628, 4254));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1556, 1557), (6995, 6996), (6500, 6515), (4005, 4006), (2145, 3949), (5671, 6408), (5173, 5183), (6650, 6651));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((5686, 6488), (4528, 4530), (6055, 6068), (6974, 6976), (5959, 6044), (5972, 6143), (4878, 4879), (4884, 4885));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((2106, 2107), (6062, 6089), (6664, 6665), (1619, 4879), (1929, 4879), (1929, 4885), (4881, 4885), (7016, 7017));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((4876, 4877), (4882, 4883), (6051, 6086), (7005, 7006), (6366, 6367), (4764, 6105), (6883, 6884), (6315, 6378));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((6689, 6690), (1661, 1662), (6980, 6981), (5945, 5946), (7137, 7138), (1618, 4877), (4862, 4877), (4862, 4883));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((4880, 4883), (5112, 5113), (3686, 3688), (3687, 3688), (1717, 1720), (1719, 1720), (1701, 4017), (6719, 6720));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((6993, 6994), (6982, 6983), (6984, 6985), (6999, 7000), (6976, 6977), (6856, 6857), (4999, 5032), (6674, 6675));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((6674, 6676), (6675, 6676), (4005, 4007), (4006, 4008), (4007, 4008), (2146, 3948), (2165, 2166), (6831, 6832));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((6833, 6834), (6646, 6656), (3487, 3529), (5047, 5064), (6122, 6123), (6644, 6652), (5796, 5797), (6645, 6655));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((5971, 6142), (5867, 5868), (6398, 6492), (6885, 6886), (6647, 6657), (6648, 6659), (3191, 3877), (3191, 3878));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((4636, 4637), (8154, 8156), (8148, 8150), (8149, 8151), (6668, 6669), (3870, 3871), (3284, 3285), (4489, 4492));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((4428, 4429), (4490, 4492), (8135, 8137), (8136, 8138), (2067, 2182), (1491, 4134), (3630, 3634), (3631, 3635));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1929, 4342), (3271, 3273), (4424, 4425), (3727, 3728), (3854, 3857), (1707, 1708), (2044, 2292), (2044, 2294));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((3371, 3372), (4292, 4293), (4294, 4295), (8123, 8124), (2183, 2184), (3782, 3783), (4062, 4063), (1938, 2061));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((3849, 3853), (1528, 1529), (1528, 1530), (2024, 3210), (2043, 2293), (1946, 2171), (1741, 4584), (1718, 7979));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1700, 4017), (4017, 4353), (3321, 3322), (2229, 2230), (2234, 3695), (2234, 4393), (1963, 2056), (3855, 3858));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((8150, 8151), (2194, 3947), (2239, 3700), (3190, 3873), (3190, 3874), (3877, 3878), (3500, 3501), (3438, 3439));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((3657, 4303), (4516, 4518), (4516, 4519), (4518, 4519), (8154, 8155), (7349, 7360), (8130, 8131), (8132, 8133));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((8132, 8134), (8133, 8134), (6934, 6936), (6919, 6930), (6919, 6931), (1639, 1646), (7028, 7075), (1678, 4042));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((6918, 6925), (6918, 6926), (6918, 6927), (6935, 6937), (7029, 7076), (7029, 7095), (6960, 6961), (6919, 6929));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((5328, 5561), (7162, 7165), (7028, 7094), (7028, 7179), (7377, 7380), (7378, 7381), (7379, 7382), (6910, 6911));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((6935, 6938), (7413, 7414), (1938, 1947), (1780, 4572), (1475, 1627), (1475, 3326), (1475, 3346), (2225, 2261));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1929, 2061), (2061, 3339), (2066, 2230), (2104, 3719), (5566, 7041), (4613, 6360), (1627, 7057), (1491, 4342));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1511, 3717), (1929, 4793), (1947, 3293), (3271, 7076), (3300, 4430), (3339, 7095), (1749, 8231), (1750, 8231));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1751, 8231), (1752, 8231), (4384, 8231), (2155, 2203), (5164, 7402), (2274, 5480), (1475, 5608), (1475, 5613));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1502, 4408), (1502, 4413), (4862, 7179), (4873, 7094), (2061, 3904), (2061, 4881), (2061, 5894), (2061, 7029));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1535, 2173), (1620, 1960), (1622, 2171), (1960, 3726), (1500, 4406), (1500, 4411), (1501, 4407), (1501, 4412));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1505, 3370), (1505, 3600), (1505, 3715), (3602, 5005), (1547, 1998), (2041, 3216), (2153, 2199), (3591, 3982));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((4344, 4877), (1701, 4019), (4352, 4850), (3382, 5921), (1765, 8232), (1766, 8232), (5415, 7078), (2229, 3272));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1945, 2302), (4744, 5283), (4762, 6016), (2219, 3756), (4318, 6566), (3875, 4895), (3450, 6155), (3451, 6155));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((3489, 4409), (3489, 4414), (4248, 5460), (3762, 5281), (1931, 2065), (1938, 3717), (1938, 4134), (3273, 5894));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((2148, 6009), (2038, 7216), (3341, 7408), (3343, 7408), (1475, 2307), (1475, 5360), (1475, 5992), (1491, 2061));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((1496, 2061), (1511, 2061), (1534, 2061), (1538, 2061), (1619, 2061), (1624, 2061), (1648, 2061), (2061, 2190));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((2061, 2266), (2061, 2298), (2061, 3271), (2061, 3293), (2061, 3298), (2061, 3776), (2061, 4140), (2061, 4142));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((2061, 4324), (2061, 4430), (2061, 4865), (2061, 4875), (2061, 5194), (2061, 5261), (2061, 5626), (2059, 2171));
UPDATE medical_service_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (service_id_a, service_id_b) IN ((2059, 2172), (2059, 2173), (3158, 3816), (2192, 5028), (3972, 4997), (2192, 3348), (2313, 4660));

UPDATE lab_test_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (lab_test_id_a, lab_test_id_b) IN ((2037, 2073), (26, 1999), (121, 694), (183, 2348), (183, 576), (308, 561), (307, 562), (1858, 1875));
UPDATE lab_test_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (lab_test_id_a, lab_test_id_b) IN ((1853, 1854), (1876, 1877), (282, 284), (283, 285), (2091, 2092), (2020, 2028), (2090, 2093), (294, 300));
UPDATE lab_test_duplicate_candidates SET status='dismissed', decided_at=NOW()
 WHERE (lab_test_id_a, lab_test_id_b) IN ((295, 300), (231, 1277), (1169, 2025), (2029, 2055), (2043, 2055), (1676, 1677));
-- ===========================================================================
-- D. РАЗВЕДЕНИЕ НАЗВАНИЙ по отказу из секции C
--
-- 2135 «Mala hirurška intervencija» (общая малая хирургия) и 3664 —
-- офтальмологическая, категория «Ophthalmic Surgery». По-сербски и по-русски
-- они назывались одинаково, глаз упоминался только в английском.
-- Секцию можно выкинуть, на слияния и отказы она не влияет.
-- ===========================================================================

UPDATE medical_services SET
	name_sr      = 'Mali hirurški zahvat na oku',
	name_sr_cyrl = 'Мали хируршки захват на оку',
	name_ru      = 'Малое хирургическое вмешательство на глазу',
	name_de      = 'Kleiner augenchirurgischer Eingriff',
	name_tr      = 'Küçük göz cerrahisi girişimi'
 WHERE id = 3664;

-- ===========================================================================

DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
