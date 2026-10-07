SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Слияние трёх записей УЗИ головного мозга младенца (нейросонография через
-- родничок) в одну. Найдено при сверке прайса Poliklinika Natal 2026-10.
--
--   infant-brain-ultrasound-neurosonography     «Ultrazvuk mozga beba»                      medikid-podgorica (без цены)   ← ОСНОВНАЯ
--   ultrasound-infant-cns                       «UZ CNS kod odojčadi»                        konzilijum 40, milmedika-niksic 40; без категорий и специальностей
--   cranial-ultrasound-for-newborns-and-infants «Ultrazvuk mozga novorođenčadi i odojčadi»   teo-med (без цены)
--
-- Одно исследование под тремя названиями: «CNS» здесь — головной мозг,
-- «новорождённые и грудные» — те же пациенты, что «бебы». Кодов ФЗОЦГ, справок,
-- отзывов, врачей и ИИ-сводок нет ни у одной. Клиники не пересекаются — цены
-- переезжают как есть. Прод = локальная (сверено через API 2026-10-05).
--
-- Основная — infant-brain-ultrasound-neurosonography: справок ни у кого нет,
-- значит выбор по названию; у неё самое ходовое («ультразвук мозга бебы») и
-- профессиональное («нейросонография») сразу. Названия дубликатов процедура
-- кладёт в синонимы основной, slug — в slug_redirects.
-- После слияния: категории 4 (Ultrasound) + 25 (Pediatrics), специальности
-- 10 (radiology) + 4 (pediatrics) + 68 (neonatology), клиник 4.
--
-- Процедура — из 039, плюс перенос is_obsolete (как в server/api/services/merge.ts
-- после 045). CREATE PROCEDURE делает неявный COMMIT, транзакции нет; повторный
-- прогон безопасен: слияние проверяет, что обе половинки ещё на месте.

DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;

DELIMITER $$

CREATE PROCEDURE dedup_merge_medical_service(IN p_primary INT, IN p_secondary INT)
BEGIN
	-- Обе половинки на месте? Иначе слияние уже применяли.
	IF (SELECT COUNT(*) FROM medical_services WHERE id IN (p_primary, p_secondary)) = 2 THEN

		-- 1. Связи с клиниками, которых у основной услуги ещё нет
		INSERT IGNORE INTO clinic_medical_services
			(medical_service_id, clinic_id, price, price_min, price_max, code, is_price_outdated, is_obsolete)
		SELECT p_primary, clinic_id, price, price_min, price_max, code, is_price_outdated, is_obsolete
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

-- Вызов по слагу: id на проде и локально могут не совпадать.
CREATE PROCEDURE dedup_merge_medical_service_by_slug(IN p_primary VARCHAR(280), IN p_secondary VARCHAR(280))
BEGIN
	DECLARE v_primary INT DEFAULT NULL;
	DECLARE v_secondary INT DEFAULT NULL;
	-- SET, а не SELECT … INTO: пустая выборка в INTO поднимает условие NOT FOUND
	SET v_primary = (SELECT id FROM medical_services WHERE slug = p_primary COLLATE utf8mb4_unicode_ci);
	SET v_secondary = (SELECT id FROM medical_services WHERE slug = p_secondary COLLATE utf8mb4_unicode_ci);
	IF v_primary IS NOT NULL AND v_secondary IS NOT NULL AND v_primary <> v_secondary THEN
		CALL dedup_merge_medical_service(v_primary, v_secondary);
	END IF;
END$$

DELIMITER ;

CALL dedup_merge_medical_service_by_slug('infant-brain-ultrasound-neurosonography', 'ultrasound-infant-cns');
CALL dedup_merge_medical_service_by_slug('infant-brain-ultrasound-neurosonography', 'cranial-ultrasound-for-newborns-and-infants');

DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;

-- ═══ VERIFICATION ═══

-- Ожидается 0: дубликатов больше нет.
SELECT COUNT(*) AS duplicates_left FROM medical_services
 WHERE slug IN ('ultrasound-infant-cns', 'cranial-ultrasound-for-newborns-and-infants');

-- Ожидается 4 клиники: konzilijum 40, milmedika-niksic 40, medikid NULL, teo-med NULL.
SELECT c.slug, r.price, r.is_price_outdated, r.is_obsolete
  FROM clinic_medical_services r
  JOIN clinics c ON c.id = r.clinic_id
  JOIN medical_services ms ON ms.id = r.medical_service_id
 WHERE ms.slug = 'infant-brain-ultrasound-neurosonography'
 ORDER BY c.slug;

-- Ожидается: categories 4,25; specialties 4,10,68; synonyms 12 (по 6 языков от двух дубликатов, минус совпадения).
SELECT ms.id, ms.slug,
       (SELECT GROUP_CONCAT(medical_service_category_id ORDER BY medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS categories,
       (SELECT GROUP_CONCAT(specialty_id ORDER BY specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specialties,
       (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
  FROM medical_services ms
 WHERE ms.slug = 'infant-brain-ultrasound-neurosonography';

-- Ожидается 2 строки, обе ведут на основную.
SELECT sr.old_slug, ms.slug AS new_slug
  FROM slug_redirects sr
  JOIN medical_services ms ON ms.id = sr.entity_id
 WHERE sr.entity_type = 'services'
   AND sr.old_slug IN ('ultrasound-infant-cns', 'cranial-ultrasound-for-newborns-and-infants');
