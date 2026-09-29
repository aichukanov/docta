-- Осиротевшие связи каталога: уборка и внешние ключи, чтобы не повторялось.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/032-orphan-relations-cleanup.sql
--
-- Найдено при проверке после дедупликации (027–031), но к ней НЕ относится:
-- ни один осиротевший id не входит в 248 записей, удалённых теми миграциями.
-- Это старый мусор от удалений через админку.
--
-- ОТКУДА БЕРЁТСЯ. Пять таблиц связей не имели внешнего ключа на каталог, а
-- эндпоинты удаления чистили не всё:
--   * server/api/services/remove.ts не удалял medical_service_categories_relations
--     и clinic_medical_service_doctors → 9 и 6 строк соответственно;
--   * server/api/doctors/remove.ts не удалял clinic_medical_service_doctors
--     → 5 строк на несуществующих врачей;
--   * server/api/clinics/remove.ts тоже его не удалял — там сейчас 0 строк,
--     но только потому, что не совпали обстоятельства.
-- Соседние таблицы (clinic_medical_services, clinic_lab_tests) всё это время
-- имели FK с CASCADE и потому чистые. Эндпоинты правятся в той же ветке.
--
-- Осиротевшая строка не видна на сайте, но искажает подсчёты (число услуг в
-- категории, число врачей у услуги) и мешает поставить внешний ключ.
--
-- Скрипт идемпотентен: повторный запуск не находит ни строк, ни отсутствующих
-- ключей. Секции независимы — A можно применить без B.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ===========================================================================
-- A. УБОРКА
--    Удаляем по LEFT JOIN, а не по списку id: на проде состав строк может
--    отличаться, а условие «ссылка ведёт в никуда» верно везде.
-- ===========================================================================

DELETE x FROM medical_service_categories_relations x
  LEFT JOIN medical_services m ON m.id = x.medical_service_id
 WHERE m.id IS NULL;

DELETE x FROM medical_services_specialties x
  LEFT JOIN medical_services m ON m.id = x.medical_service_id
 WHERE m.id IS NULL;

DELETE x FROM clinic_medical_service_doctors x
  LEFT JOIN medical_services m ON m.id = x.medical_service_id
 WHERE m.id IS NULL;

DELETE x FROM clinic_medical_service_doctors x
  LEFT JOIN doctors d ON d.id = x.doctor_id
 WHERE d.id IS NULL;

DELETE x FROM clinic_medical_service_doctors x
  LEFT JOIN clinics c ON c.id = x.clinic_id
 WHERE c.id IS NULL;

DELETE x FROM lab_test_categories_relations x
  LEFT JOIN lab_tests t ON t.id = x.lab_test_id
 WHERE t.id IS NULL;

DELETE x FROM lab_test_synonyms x
  LEFT JOIN lab_tests t ON t.id = x.lab_test_id
 WHERE t.id IS NULL;

-- ===========================================================================
-- B. ВНЕШНИЕ КЛЮЧИ
--
--    ON DELETE CASCADE повторяет поведение уже существующих ключей на
--    clinic_medical_services и clinic_lab_tests: удалили запись каталога —
--    связи уходят сами, независимо от того, вспомнил ли о них эндпоинт.
--
--    Секцию можно не применять, если схему трогать не хочется: уборка из A
--    и правки remove-эндпоинтов закрывают проблему и без неё. Но тогда
--    следующий забытый DELETE заведёт сирот заново.
--
--    У clinic_medical_service_doctors единственный подходящий индекс —
--    unique_doctor_clinic_service (doctor_id, clinic_id, medical_service_id),
--    и medical_service_id в нём не первый. MySQL заведёт под этот ключ свой
--    индекс сам; таблица маленькая (199 строк), это не проблема.
-- ===========================================================================

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
	    AND CONSTRAINT_NAME = 'fk_mscr_service') = 0,
	'ALTER TABLE `medical_service_categories_relations`
		ADD CONSTRAINT `fk_mscr_service` FOREIGN KEY (`medical_service_id`)
		REFERENCES `medical_services` (`id`) ON DELETE CASCADE',
	'SELECT ''fk_mscr_service already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
	    AND CONSTRAINT_NAME = 'fk_msspec_service') = 0,
	'ALTER TABLE `medical_services_specialties`
		ADD CONSTRAINT `fk_msspec_service` FOREIGN KEY (`medical_service_id`)
		REFERENCES `medical_services` (`id`) ON DELETE CASCADE',
	'SELECT ''fk_msspec_service already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
	    AND CONSTRAINT_NAME = 'fk_cmsd_service') = 0,
	'ALTER TABLE `clinic_medical_service_doctors`
		ADD CONSTRAINT `fk_cmsd_service` FOREIGN KEY (`medical_service_id`)
		REFERENCES `medical_services` (`id`) ON DELETE CASCADE',
	'SELECT ''fk_cmsd_service already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
	    AND CONSTRAINT_NAME = 'fk_cmsd_doctor') = 0,
	'ALTER TABLE `clinic_medical_service_doctors`
		ADD CONSTRAINT `fk_cmsd_doctor` FOREIGN KEY (`doctor_id`)
		REFERENCES `doctors` (`id`) ON DELETE CASCADE',
	'SELECT ''fk_cmsd_doctor already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
	    AND CONSTRAINT_NAME = 'fk_cmsd_clinic') = 0,
	'ALTER TABLE `clinic_medical_service_doctors`
		ADD CONSTRAINT `fk_cmsd_clinic` FOREIGN KEY (`clinic_id`)
		REFERENCES `clinics` (`id`) ON DELETE CASCADE',
	'SELECT ''fk_cmsd_clinic already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
	    AND CONSTRAINT_NAME = 'fk_ltcr_labtest') = 0,
	'ALTER TABLE `lab_test_categories_relations`
		ADD CONSTRAINT `fk_ltcr_labtest` FOREIGN KEY (`lab_test_id`)
		REFERENCES `lab_tests` (`id`) ON DELETE CASCADE',
	'SELECT ''fk_ltcr_labtest already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_TYPE = 'FOREIGN KEY'
	    AND CONSTRAINT_NAME = 'fk_lts_labtest') = 0,
	'ALTER TABLE `lab_test_synonyms`
		ADD CONSTRAINT `fk_lts_labtest` FOREIGN KEY (`lab_test_id`)
		REFERENCES `lab_tests` (`id`) ON DELETE CASCADE',
	'SELECT ''fk_lts_labtest already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
