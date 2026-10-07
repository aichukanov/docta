SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 050: дубли в каталоге анализов, найденные при сопоставлении перечня Moj Lab (2026-10-02).
--
-- Кандидатов было 25 пар. Слиты 18: ни одна клиника не держит обе записи
-- пары — у каждой клиники свой вариант названия одного и того же теста.
--
-- НЕ слиты — одна клиника держит обе записи с РАЗНЫМИ кодами или ценами
-- (решает код прайса, а не похожесть названия):
--   anti-hbc-total-elisa / anti-hbc-antibody-test   — Bolnica Danilo: K03126 11.90 и X12058 26.35
--   anti-hbe-elisa / anti-hbe-antibody-test         — Bolnica Danilo: K03128 11.90 и X12057 26.35
--   hbsab / anti-hbs-antibody-test                  — Bolnica Danilo: K03129 и X12059
--   anti-gad-antibodies / gad-antibodies            — Milmedika Nikšić: 28 и 48
--   aquaporin-4-antibodies / aquaporin-antibodies   — Novi Standard: 35 и 34
--   c1-inhibitor / c1-inactivator                   — Novi Standard: 16 (серум) и 24 (цитратная плазма)
--   diamine-oxidase / diamine-oxidase-dao-histamine — Novi Standard: 31 и 33
--   influenza-a-plus-b-iht / influenza-ab-rapid-test — Milmedika Nikšić: 22 и 36
--   drug-panel-10 / drug-panel-10-ii                — Novi Standard: 45 и 40
--   psychoactive-substances-panel-10-parameters — к какой из двух панелей относится, неизвестно
--
-- Процедура — из 041 с одной правкой: переносится is_obsolete (колонка из 045).
-- Слаги дубликатов уходят в slug_redirects (301), старые id — в lab_test_redirects.
-- Справки (lab_test_reference_info) переезжают, если у основной своей нет.

DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;

DELIMITER $$

CREATE PROCEDURE dedup_merge_lab_test(IN p_primary INT, IN p_secondary INT)
BEGIN
	IF (SELECT COUNT(*) FROM lab_tests WHERE id IN (p_primary, p_secondary)) = 2 THEN

		-- 1. Связи с клиниками
		INSERT IGNORE INTO clinic_lab_tests
			(lab_test_id, clinic_id, price, price_max, code, is_price_outdated, is_obsolete)
		SELECT p_primary, clinic_id, price, price_max, code, is_price_outdated, is_obsolete
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
		       p.code      = COALESCE(p.code, s.code),
		       -- строка актуальна, если актуальна хотя бы одна из двух (045)
		       p.is_obsolete = LEAST(p.is_obsolete, s.is_obsolete)
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

		-- 4.2 Тарифы ФЗОЦГ
		UPDATE medical_service_tariffs
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

CREATE PROCEDURE dedup_merge_lab_test_by_slug(IN p_primary VARCHAR(280), IN p_secondary VARCHAR(280))
BEGIN
	DECLARE v_primary INT DEFAULT NULL;
	DECLARE v_secondary INT DEFAULT NULL;
	-- Параметр берёт коллацию БАЗЫ на момент CREATE PROCEDURE, а она на
	-- локальной и прод-БД разная (0900_ai_ci / unicode_ci) — без явного
	-- COLLATE локально ERROR 1267.
	SET v_primary = (SELECT id FROM lab_tests WHERE slug = p_primary COLLATE utf8mb4_unicode_ci);
	SET v_secondary = (SELECT id FROM lab_tests WHERE slug = p_secondary COLLATE utf8mb4_unicode_ci);
	IF v_primary IS NOT NULL AND v_secondary IS NOT NULL AND v_primary <> v_secondary THEN
		CALL dedup_merge_lab_test(v_primary, v_secondary);
	END IF;
END$$

DELIMITER ;

-- Zaušnjaci IgM: у Novi Standard та же серология под другим именем
CALL dedup_merge_lab_test_by_slug('mumps-igm', 'mumps-virus-igm');
-- то же для IgG
CALL dedup_merge_lab_test_by_slug('mumps-igg', 'mumps-virus-igg');
-- «I» и «1» — один антиген; Milmedika против In Vitro/Moj Lab
CALL dedup_merge_lab_test_by_slug('beta-2-glycoprotein-i-igg', 'beta-2-glycoprotein-1-igg');
-- то же для IgM
CALL dedup_merge_lab_test_by_slug('beta-2-glycoprotein-i-igm', 'beta-2-glycoprotein-1-igm');
-- PH полипа шейки матки; Novi Standard против In Vitro/Moj Lab
CALL dedup_merge_lab_test_by_slug('histopathology-cervical-polyp-examination', 'polyp-biopsy-cervical');
-- основная — запись с уточнённым названием: в неё пишет ещё не применённый insert-clinic-prices-vase-zdravlje-podgorica.sql
CALL dedup_merge_lab_test_by_slug('triple-test-second-trimester-screening', 'triple-test');
-- комбинированный тест HIV 1/2 Ag/Ab (4-е поколение)
CALL dedup_merge_lab_test_by_slug('hiv-ag-ab', 'hiv-1-plus-2-ag-ab');
-- «Factor II» у Dr Zejnilović — мутация протромбина G20210A (синоним «Prothrombin Mutation»), не фактор свёртывания
CALL dedup_merge_lab_test_by_slug('prothrombin-ii-locus-20210-pcr', 'factor-ii');
-- «Factor V» у Dr Zejnilović — мутация Leiden (name_sr «Faktor V Leiden»); фактор свёртывания V — coagulation-factor-v, не трогается
CALL dedup_merge_lab_test_by_slug('factor-v-leiden-locus-1691', 'factor-v');
-- HLA DQ2/DQ8, генетика целиакии
CALL dedup_merge_lab_test_by_slug('hla-dq2-dq8-typing', 'hla-dq-2-8');
-- микроделеции AZF-региона Y-хромосомы
CALL dedup_merge_lab_test_by_slug('y-chromosome-microdeletion', 'azf-y-chromosome-deletions');
-- «11» — хвост названия из прайса Novi Standard, тест тот же
CALL dedup_merge_lab_test_by_slug('y-chromosome-microdeletion', 'y-chromosome-microdeletion-11');
-- бакпосев мазка из цервикального канала
CALL dedup_merge_lab_test_by_slug('cervical-swab-bacteria', 'bacteriological-examination-cervical-swab');
-- то же на грибы
CALL dedup_merge_lab_test_by_slug('cervical-swab-fungi', 'fungal-examination-cervical-swab');
-- посев спермы на грибы
CALL dedup_merge_lab_test_by_slug('sperm-culture-fungi', 'seminal-fluid-fungal-test');
-- токсины A/B C. difficile; справка у дубликата теряется, у основной своя
CALL dedup_merge_lab_test_by_slug('clostridium-difficile-toxin-a-and-b', 'clostridium-difficile-toxin-ab');
-- «grupa vaginalnog sekreta» (степень чистоты)
CALL dedup_merge_lab_test_by_slug('vaginal-discharge-dmp', 'vaginal-secretion-group');
-- белок в разовой моче; у Novi Standard суточная — отдельная запись protein-in-24h-urine
CALL dedup_merge_lab_test_by_slug('protein-in-urine', 'protein-in-random-urine');

DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;

-- ═══ VERIFICATION ═══

-- Дубликатов не осталось (ожидается пусто)
SELECT slug AS still_exists FROM lab_tests WHERE slug IN ('mumps-virus-igm', 'mumps-virus-igg', 'beta-2-glycoprotein-1-igg', 'beta-2-glycoprotein-1-igm', 'polyp-biopsy-cervical', 'triple-test', 'hiv-1-plus-2-ag-ab', 'factor-ii', 'factor-v', 'hla-dq-2-8', 'azf-y-chromosome-deletions', 'y-chromosome-microdeletion-11', 'bacteriological-examination-cervical-swab', 'fungal-examination-cervical-swab', 'seminal-fluid-fungal-test', 'clostridium-difficile-toxin-ab', 'vaginal-secretion-group', 'protein-in-random-urine');

-- Редиректы со слагов дубликатов (ожидается 18 строк)
SELECT r.old_slug, lt.slug AS target
FROM slug_redirects r JOIN lab_tests lt ON lt.id = r.entity_id
WHERE r.entity_type COLLATE utf8mb4_unicode_ci = 'labtests'
	AND r.old_slug COLLATE utf8mb4_unicode_ci IN ('mumps-virus-igm', 'mumps-virus-igg', 'beta-2-glycoprotein-1-igg', 'beta-2-glycoprotein-1-igm', 'polyp-biopsy-cervical', 'triple-test', 'hiv-1-plus-2-ag-ab', 'factor-ii', 'factor-v', 'hla-dq-2-8', 'azf-y-chromosome-deletions', 'y-chromosome-microdeletion-11', 'bacteriological-examination-cervical-swab', 'fungal-examination-cervical-swab', 'seminal-fluid-fungal-test', 'clostridium-difficile-toxin-ab', 'vaginal-secretion-group', 'protein-in-random-urine')
ORDER BY lt.slug;

-- Основные записи: клиник и справок
SELECT lt.slug, COUNT(DISTINCT clt.clinic_id) AS clinics,
	(SELECT COUNT(*) FROM lab_test_reference_info r WHERE r.lab_test_id = lt.id) AS reference_cards
FROM lab_tests lt LEFT JOIN clinic_lab_tests clt ON clt.lab_test_id = lt.id
WHERE lt.slug IN ('beta-2-glycoprotein-i-igg', 'beta-2-glycoprotein-i-igm', 'cervical-swab-bacteria', 'cervical-swab-fungi', 'clostridium-difficile-toxin-a-and-b', 'factor-v-leiden-locus-1691', 'histopathology-cervical-polyp-examination', 'hiv-ag-ab', 'hla-dq2-dq8-typing', 'mumps-igg', 'mumps-igm', 'protein-in-urine', 'prothrombin-ii-locus-20210-pcr', 'sperm-culture-fungi', 'triple-test-second-trimester-screening', 'vaginal-discharge-dmp', 'y-chromosome-microdeletion')
GROUP BY lt.slug ORDER BY lt.slug;
