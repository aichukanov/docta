-- 043: лабораторные позиции, заведённые в каталоге услуг (хвост 029).
--
-- Собрано scripts/services/build-cross-catalog-move-sql.mjs из
-- data/service-names/_cross-catalog-043.json — руками не править.
-- Независима от 038–042; 029 должна быть применена (процедура и
-- slug_redirects.target_entity_type оттуда).
--
-- ЧТО ПЕРЕНОСИТСЯ. 142 услуг ДЗ Херцег-Нови, ДЗ Мойковац и Никшича, у которых
-- тот же код прайса у клиники 88 лежит в каталоге анализов: мазки и посевы
-- K01, детекция K02, серология K03, трансфузиологические тесты X12, биохимия
-- Z01/Z02. 029 нашла 160 таких позиций по совпадению отпечатков названий;
-- эти не совпали из-за одного слова («Bris nosa» / «Bris nosa bakterije»).
--
-- КАК ВЫБРАНА ЦЕЛЬ. Анализ клиники 88 с тем же кодом. У строк ДЗ решает
-- название, а не код: коды ДЗ Херцег-Нови местами сдвинуты (HN_K01011 у них
-- «Bris uha», а в ФЗОЦГ K01011 — «Bris oka»). У строк Никшича решает код: код
-- из PDF клиники, а названия её услуг в K03 съехали с соседних позиций
-- FINAL.json (как анализы в 040). Такие названия синонимами анализа НЕ
-- заводятся — иначе «гепатит A» находил бы тест на гепатит E (22 переносов
-- без синонимов).
--
-- НЕ ПЕРЕНОСИТСЯ (3): vaginal-smear-microscopy, joint-fluid-native-preparation, complete-blood-count-with-differential —
-- название ДЗ противоречит коду, и подходящего анализа нет. Причины — в
-- _cross-catalog-043.json.
--
-- ЧТО ДОБАВЛЕНО К ПРОЦЕДУРЕ 029: перенос справки услуги, если у анализа
-- своей нет, и запрет переноса услуги с отзывами. На текущих данных отзывов
-- на переносимых услугах нет, а все четыре справки услуг дублируют справки
-- анализов — они убраны из data/entity-reference тем же коммитом.
--
-- Числовой /services/<id> после переноса отдаёт 404, слаг — 301 на анализ
-- (как в 029). Повторный прогон безопасен: перенос ничего не делает, если
-- услуги уже нет; подготовка — если строки уже не в старом виде.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══ 1. Подготовка ═══

-- Никшич держит HBsAg дважды: ELISA K03168 (11,90 €, сейчас услуга hbs-antigen-detection-elisaantigen) и трансфузиологический X12023 (26,35 €, уже на анализе). Один аналит — диапазон, как у МРТ в 039
UPDATE clinic_lab_tests SET price = 11.90, price_max = 26.35, code = 'K03168/X12023'
 WHERE clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic') AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'hbsag')
   AND code = 'X12023' AND price_max IS NULL;
-- в прайсе Данило K01007 — «Bris ždrijela» (зев), а строка висела на мазке из НОСОГЛОТКИ; сюда же переезжает «Bris ždrijela» ДЗ и Никшича
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'throat-swab-bacteria')
 WHERE clinic_id = (SELECT id FROM clinics WHERE slug = 'bolnica-danilo-i-cetinje') AND code = 'K01007' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'bacteriological-examination-pharyngeal-swab');
-- в прайсе Данило K01011 — «Bris oka» без стороны; «правый глаз» — позиция частных лабораторий, которые делят правый и левый
UPDATE IGNORE clinic_lab_tests SET lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'eye-swab-bacteria')
 WHERE clinic_id = (SELECT id FROM clinics WHERE slug = 'bolnica-danilo-i-cetinje') AND code = 'K01011' AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'right-eye-swab-bacteria');

-- ═══ 2. Переносы услуга → анализ ═══

-- Процедура — из 029 с шагами 3.2 и проверкой отзывов (помечены «043»).
DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test;
DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test_by_slug;

DELIMITER $$

CREATE PROCEDURE dedup_move_service_to_lab_test(
	IN p_lab_test_id INT,
	IN p_service_id INT,
	IN p_keep_names TINYINT
)
BEGIN
	IF (SELECT COUNT(*) FROM medical_services WHERE id = p_service_id) = 1
	   AND (SELECT COUNT(*) FROM lab_tests WHERE id = p_lab_test_id) = 1
	   -- (043) отзывы привязаны только к услуге, FK — CASCADE: такую услугу не трогаем
	   AND (SELECT COUNT(*) FROM reviews WHERE medical_service_id = p_service_id) = 0 THEN

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

		-- 3.2 (043) Справка услуги — анализу, если у него своей нет: колонки
		-- таблиц одинаковые, UNIQUE на lab_test_id не даст затереть существующую.
		INSERT IGNORE INTO lab_test_reference_info
			(lab_test_id, what_en, what_sr, what_sr_cyrl, what_ru, what_de, what_tr,
			 how_en, how_sr, how_sr_cyrl, how_ru, how_de, how_tr,
			 indications_en, indications_sr, indications_sr_cyrl, indications_ru, indications_de, indications_tr,
			 prep_en, prep_sr, prep_sr_cyrl, prep_ru, prep_de, prep_tr,
			 abnormal_en, abnormal_sr, abnormal_sr_cyrl, abnormal_ru, abnormal_de, abnormal_tr)
		SELECT p_lab_test_id, what_en, what_sr, what_sr_cyrl, what_ru, what_de, what_tr,
			 how_en, how_sr, how_sr_cyrl, how_ru, how_de, how_tr,
			 indications_en, indications_sr, indications_sr_cyrl, indications_ru, indications_de, indications_tr,
			 prep_en, prep_sr, prep_sr_cyrl, prep_ru, prep_de, prep_tr,
			 abnormal_en, abnormal_sr, abnormal_sr_cyrl, abnormal_ru, abnormal_de, abnormal_tr
		  FROM medical_service_reference_info
		 WHERE medical_service_id = p_service_id;

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

-- Вызов по слагу. COLLATE обязателен: параметр получает коллацию схемы
-- (локально utf8mb4_0900_ai_ci), а slug — utf8mb4_unicode_ci.
CREATE PROCEDURE dedup_move_service_to_lab_test_by_slug(IN p_lab VARCHAR(280), IN p_service VARCHAR(280), IN p_keep_names TINYINT)
BEGIN
	DECLARE v_lab INT DEFAULT NULL;
	DECLARE v_service INT DEFAULT NULL;
	SET v_lab = (SELECT id FROM lab_tests WHERE slug = p_lab COLLATE utf8mb4_unicode_ci);
	SET v_service = (SELECT id FROM medical_services WHERE slug = p_service COLLATE utf8mb4_unicode_ci);
	IF v_lab IS NOT NULL AND v_service IS NOT NULL THEN
		CALL dedup_move_service_to_lab_test(v_lab, v_service, p_keep_names);
	END IF;
END$$

DELIMITER ;

-- «Pregled preparata na gonoreju» → microscopic-examination-of-swab-for-gonorrhea
CALL dedup_move_service_to_lab_test_by_slug('microscopic-examination-of-swab-for-gonorrhea', 'gonorrhea-smear-examination', 1);
-- «Bris ždrijela» → throat-swab-bacteria
CALL dedup_move_service_to_lab_test_by_slug('throat-swab-bacteria', 'throat-swab-culture', 1);
-- K01008: «Bris usne duplje» → «Bris usne duplje bakterije»
CALL dedup_move_service_to_lab_test_by_slug('oral-cavity-swab-bacteria', 'oral-cavity-swab-culture', 1);
-- K01009: «Bris jezika» → «Bris jezika bakterije»
CALL dedup_move_service_to_lab_test_by_slug('tongue-swab-bacteria', 'tongue-swab', 1);
-- K01010: «Bris nosa» → «Bris nosa bakterije»
CALL dedup_move_service_to_lab_test_by_slug('nose-swab-bacteria', 'nose-swab', 1);
-- «Bris uha» → bacteriological-examination-ear-swab
CALL dedup_move_service_to_lab_test_by_slug('bacteriological-examination-ear-swab', 'ear-swab-culture', 1);
-- «Bris oka» → eye-swab-bacteria
CALL dedup_move_service_to_lab_test_by_slug('eye-swab-bacteria', 'eye-swab-culture', 1);
-- «Bris rane» → wound-swab-bacteria
CALL dedup_move_service_to_lab_test_by_slug('wound-swab-bacteria', 'wound-swab', 1);
-- K01015: «Bris kože» → «Bris kože bakterije»
CALL dedup_move_service_to_lab_test_by_slug('skin-swab-bacteria', 'skin-swab-culture', 1);
-- K01016: «Bris dojke» → «Bris dojke (bakterije)»
CALL dedup_move_service_to_lab_test_by_slug('breast-swab-bacteria', 'breast-swab-culture', 1);
-- K01017: «Bris vagine» → «Bris vagine bakterije»
CALL dedup_move_service_to_lab_test_by_slug('vaginal-swab-bacteria', 'vaginal-swab-culture', 1);
-- K01018: «Bris vulve» → «Bris vulve bakterije»
CALL dedup_move_service_to_lab_test_by_slug('vulvar-swab-bacteria', 'vulvar-swab-culture', 1);
-- K01019: «Bris glansa» → «Bris glansa bakterije»
CALL dedup_move_service_to_lab_test_by_slug('glans-swab-bacteria', 'glans-swab-culture', 1);
-- K01020: «Bris prepucijuma» → «Bris prepucijuma bakterije»
CALL dedup_move_service_to_lab_test_by_slug('prepuce-swab-bacteria', 'prepuce-swab-culture', 1);
-- K01021: «Bris uretre» → «Bris uretre bakterije»
CALL dedup_move_service_to_lab_test_by_slug('urethral-swab-bacteria', 'urethral-swab-culture', 1);
-- K01024: «Bris žmara» → «Perianalni bris»
CALL dedup_move_service_to_lab_test_by_slug('perianal-swab', 'pus-swab-culture', 1);
-- K01026: «Sputum kultura» → «Sputum bakterije»
CALL dedup_move_service_to_lab_test_by_slug('sputum-bacteria', 'sputum-culture', 1);
-- K01027: «Cervikalna kultura» → «Bris cerviksa bakterije»
CALL dedup_move_service_to_lab_test_by_slug('cervical-swab-bacteria', 'cervical-culture', 1);
-- «Mycoplasma kultura sa antibiogramom» → mycoplasma-hominis-ureaplasma
CALL dedup_move_service_to_lab_test_by_slug('mycoplasma-hominis-ureaplasma', 'mycoplasma-culture-with-antibiogram', 1);
-- K01030: «Pregled preparata dermatomikoze nokta» → «Dermatofiti strugotina nokta»
CALL dedup_move_service_to_lab_test_by_slug('dermatophytes-nail-scraping', 'nail-dermatomycosis-examination', 1);
-- «Pregled preparata dermatomikoze kože» → dermatophytes-skin-scraping
CALL dedup_move_service_to_lab_test_by_slug('dermatophytes-skin-scraping', 'skin-dermatomycosis-examination', 1);
-- K01033: «Kultura brisa kože na gljivice» → «Bris kože gljivice»
CALL dedup_move_service_to_lab_test_by_slug('skin-swab-fungi', 'skin-fungal-culture', 1);
-- K01034: «Kultura dlake na gljivice» → «Kultura brisa dlake na gljivice»
CALL dedup_move_service_to_lab_test_by_slug('hair-swab-fungi', 'hair-fungal-culture', 1);
-- K01035: «Kultura nokta na gljivice» → «Bris nokta gljivice»
CALL dedup_move_service_to_lab_test_by_slug('nail-swab-fungi', 'nail-fungal-culture', 1);
-- K01036: «Kultura vaginalnog sekreta na gljivice» → «Bris vagine gljivice»
CALL dedup_move_service_to_lab_test_by_slug('vaginal-swab-fungi', 'vaginal-fungal-culture', 1);
-- K01037: «Kultura vulve na gljivice» → «Bris vulve gljivice»
CALL dedup_move_service_to_lab_test_by_slug('vulvar-swab-fungi', 'vulvar-fungal-culture', 1);
-- K01038: «Kultura brisa glansa na gljivice» → «Bris glansa gljivice»
CALL dedup_move_service_to_lab_test_by_slug('glans-swab-fungi', 'glans-fungal-culture', 1);
-- K01039: «Kultura prepucijuma na gljivice» → «Bris prepucijuma gljivice»
CALL dedup_move_service_to_lab_test_by_slug('prepuce-swab-fungi', 'prepuce-fungal-culture', 1);
-- «Kultura sjemenskog sekreta na gljivice» → sperm-culture-fungi
CALL dedup_move_service_to_lab_test_by_slug('sperm-culture-fungi', 'semen-fungal-culture', 1);
-- K01040: «Kultura uretralnog sekreta na gljivice» → «Bris uretre gljivice»
CALL dedup_move_service_to_lab_test_by_slug('urethral-swab-fungi', 'urethral-fungal-culture', 1);
-- K01041: «Kultura stolice na gljivice» → «Stolica gljivice»
CALL dedup_move_service_to_lab_test_by_slug('stool-fungi', 'stool-fungal-culture', 1);
-- K01042: «Kultura urina na gljivice» → «Urin gljivice»
CALL dedup_move_service_to_lab_test_by_slug('urine-fungi', 'urine-fungal-culture', 1);
-- K01044: «Kultura sputuma na gljivice» → «Sputum gljivice»
CALL dedup_move_service_to_lab_test_by_slug('sputum-fungi', 'sputum-fungal-culture', 1);
-- K01045: «Kultura grla na gljivice» → «Bris grla gljivice»
CALL dedup_move_service_to_lab_test_by_slug('throat-swab-fungi', 'throat-fungal-culture', 1);
-- K01046: «Kultura nepca na gljivice» → «Kultura brisa nepca na gljivice»
CALL dedup_move_service_to_lab_test_by_slug('palate-swab-fungi', 'palate-fungal-culture', 1);
-- «Kultura nosa na gljivice» → nose-swab-fungi
CALL dedup_move_service_to_lab_test_by_slug('nose-swab-fungi', 'nose-fungal-culture', 1);
-- K01047: «Kultura brisa rane na gljivice» → «Bris rane gljivice»
CALL dedup_move_service_to_lab_test_by_slug('wound-swab-fungi', 'wound-fungal-culture', 1);
-- «Pregled preparata na Trichomonas vaginalis nativni» → trichomonas-test
CALL dedup_move_service_to_lab_test_by_slug('trichomonas-test', 'trichomonas-vaginalis-native-examination', 1);
-- «Pregled preparata uretralnog ili vaginalnog brisa na Trichomonas vaginalis (stepen)» → trichomonas-test
CALL dedup_move_service_to_lab_test_by_slug('trichomonas-test', 'urethral-or-vaginal-trichomonas-vaginalis-smear-examination-grading', 1);
-- K01051: «Mikroskopski pregled stolice na helminte (ljepljivim celofanom)» → «Mikroskopski pregled perianalnog otiska ljepljivim celofanom»
CALL dedup_move_service_to_lab_test_by_slug('perianal-cellophane-tape-test-pinworm', 'stool-helminth-microscopy-cellophane-tape-method', 1);
-- «Mikroskopski pregled stolice na helminte» → stool-parasites
CALL dedup_move_service_to_lab_test_by_slug('stool-parasites', 'stool-helminth-microscopy', 1);
-- K01056: «Mikroskopski pregled na malariju» → «Malarija»
CALL dedup_move_service_to_lab_test_by_slug('malaria', 'malaria-microscopy', 1);
-- «Pregled i identifikacija ektoparazita kože» → skin-ectoparasite-identification
CALL dedup_move_service_to_lab_test_by_slug('skin-ectoparasite-identification', 'skin-ectoparasite-identification', 1);
-- «Pregled brisa kose na Demodex» → demodex-species
CALL dedup_move_service_to_lab_test_by_slug('demodex-species', 'hair-demodex-examination', 1);
-- K01061: «ASTO-LATEX» → «ASTO antistreptolizin O»
CALL dedup_move_service_to_lab_test_by_slug('asto', 'aso-latex-test', 1);
-- «Paul-Bunnell reakcija mononukleozni test» → monosticon
CALL dedup_move_service_to_lab_test_by_slug('monosticon', 'paul-bunnell-mononucleosis-reaction', 1);
-- «TPHA» → tpha-treponema-pallidum
CALL dedup_move_service_to_lab_test_by_slug('tpha-treponema-pallidum', 'tpha-test', 1);
-- «Mikroskopski citološki pregled (zapija)» → direct-microscopic-preparation
CALL dedup_move_service_to_lab_test_by_slug('direct-microscopic-preparation', 'cytological-microscopic-examination', 1);
-- K01067: «REUMA FAKTOR (RF) LATEX» → «Reumatoidni faktor»
CALL dedup_move_service_to_lab_test_by_slug('rheumatoid-factor', 'rheumatoid-factor-latex-test', 1);
-- K01070: «Kultura jezika na gljivice» → «Bris jezika (gljivice)»
CALL dedup_move_service_to_lab_test_by_slug('tongue-swab-fungi', 'tongue-fungal-culture', 1);
-- K02001: «Detekcija antimikrobnih antitijela ELISA» → «Detekcija antimikrobnih antitijela ELISA testom»
CALL dedup_move_service_to_lab_test_by_slug('antimicrobial-antibody-detection-by-elisa', 'antimicrobial-antibody-elisa-detection', 1);
-- K02002: «Detekcija mikrobnih antigena ELISA» → «Detekcija mikrobnih antigena ELISA testom»
CALL dedup_move_service_to_lab_test_by_slug('microbial-antigen-detection-by-elisa', 'microbial-antigen-elisa-detection', 1);
-- K02005: «Detekcija antimikrobnih antitijela reakcijom rezigracije komplementa» → «Detekcija antimikrobnih antitijela reakcijom vezivanja komplementa»
CALL dedup_move_service_to_lab_test_by_slug('antimicrobial-antibody-detection-by-complement-fixation', 'antimicrobial-antibody-complement-fixation-reaction', 1);
-- K02006: «Detekcija antitijela testom hemaglutinacije» → «Detekcija antimikrobnih antitijela testom hemaglutinacije»
CALL dedup_move_service_to_lab_test_by_slug('antimicrobial-antibody-detection-by-hemagglutination', 'antibody-hemagglutination-test', 1);
-- «Detekcija antitijela lateks aglutinacijom» → antimicrobial-antibody-detection-by-latex-agglutination
CALL dedup_move_service_to_lab_test_by_slug('antimicrobial-antibody-detection-by-latex-agglutination', 'antibody-latex-agglutination', 1);
-- K02009: «Detekcija mikrobnih antigena testom hibridizacije nukleinskih kiselina» → «Detekcija mikrobnih nukleinskih kiselina testom hibridizacije»
CALL dedup_move_service_to_lab_test_by_slug('microbial-nucleic-acid-detection-by-hybridization', 'microbial-antigen-nucleic-acid-hybridization-test', 1);
-- K03004: «Spermokultura» → «Kultura sperme bakterije»
CALL dedup_move_service_to_lab_test_by_slug('sperm-culture-bacteria', 'sperm-culture', 1);
-- K03019: «Kultura na Campylobacter» → «Campylobacter sp. (kultura)»
CALL dedup_move_service_to_lab_test_by_slug('campylobacter-culture', 'campylobacter-culture', 1);
-- «ELISA anti-Helicobacter pylori» → helicobacter-pylori
CALL dedup_move_service_to_lab_test_by_slug('helicobacter-pylori', 'helicobacter-pylori-antibodies-elisa', 1);
-- K03032: «Bakteriološko ispitivanje brisa bronhoalveolarnog ispirka - aerobno» → «Bakteriološko ispitivanje bronhoalveolarnog ispirka - aerobno»
CALL dedup_move_service_to_lab_test_by_slug('bronchoalveolar-lavage-culture-aerobic', 'aerobic-bacterial-culture-of-bronchoalveolar-lavage', 1);
-- K03053: «Bakteriološko ispitivanje brisa iz cavum uterusa - aerobno» → «Bakteriološko ispitivanje brisa iz cavum uterusa - aerobno»
CALL dedup_move_service_to_lab_test_by_slug('uterine-cavity-swab-culture-aerobic', 'aerobic-bacterial-culture-of-uterine-cavity-swab', 1);
-- K03070: «Bakteriološko ispitivanje dilatacione tečnosti - aerobno» → «Bakteriološko ispitivanje dijalizne tečnosti - aerobno»
CALL dedup_move_service_to_lab_test_by_slug('dialysis-fluid-culture-aerobic', 'aerobic-bacterial-culture-of-dilation-fluid', 1);
-- K03071: «Bakteriološko ispitivanje brisa isječka tkiva - aerobno» → «Bakteriološko ispitivanje isječka tkiva - aerobno»
CALL dedup_move_service_to_lab_test_by_slug('tissue-biopsy-culture-aerobic', 'aerobic-bacterial-culture-of-tissue-segment-swab', 1);
-- K03073: «Ispitivanje prisustva Bordetellae pertussis iz brisa nazofarinksa - aerobno» → «Bordetella pertussis iz brisa nazofarinksa - aerobno»
CALL dedup_move_service_to_lab_test_by_slug('bordetella-pertussis-nasopharyngeal-swab-culture-aerobic', 'bordetella-pertussis-culture-from-nasopharyngeal-swab', 1);
-- K03074: «Ispitivanje prisustva solubilnih bakterijskih antigena u likvoru - latex aglutinacija» → «Solubilni bakterijski antigeni u likvoru - latex aglutinacija»
CALL dedup_move_service_to_lab_test_by_slug('soluble-bacterial-antigens-in-csf-latex-agglutination', 'microbial-antigen-latex-agglutination-detection-in-cerebrospinal-fluid', 1);
-- K03086: «Bakteriološko ispitivanje brisa isječka tkiva - anaerobno» → «Bakteriološko ispitivanje isječka tkiva - anaerobno»
CALL dedup_move_service_to_lab_test_by_slug('tissue-biopsy-culture-anaerobic', 'anaerobic-bacterial-culture-of-tissue-segment-swab', 1);
-- K03101: «Ispitivanje prisustva krvnih i tkivnih parazita - nativni preparat (2)» → «Ispitivanje prisustva krvnih i tkivnih parazita - nativni preparat»
CALL dedup_move_service_to_lab_test_by_slug('blood-and-tissue-parasite-detection-native-preparation', 'blood-and-tissue-parasites-detection-native-preparation-2', 0);
-- K03107: «Anti Borrelia burgdorferi IgG antitijela - potvrdni test (Western Blot)» → «Borrelia Burgdorferi IgG Western Blot»
CALL dedup_move_service_to_lab_test_by_slug('borrelia-burgdorferi-igg-western-blot', 'borrelia-burgdorferi-igg-antibodies-confirmatory-test-western-blot', 1);
-- K03108: «Anti Borrelia burgdorferi IgM antitijela - potvrdni test (Western Blot)» → «Borrelia Burgdorferi IgM Western Blot»
CALL dedup_move_service_to_lab_test_by_slug('borrelia-burgdorferi-igm-western-blot', 'borrelia-burgdorferi-igm-antibodies-confirmatory-test-western-blot', 1);
-- K03111: «Anti Brucella IgM antitijela - ELISA» → «Brucela IgM»
CALL dedup_move_service_to_lab_test_by_slug('brucella-igm', 'brucella-igm-antibodies-elisa', 1);
-- K03114: «Anti Coxiella burnetii IgG antitijela faza 1 - ELISA» → «Anti Coxiella burnetii IgG faza 1 - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('coxiella-burnetii-igg-phase-1-elisa', 'coxiella-burnetii-igg-antibodies-phase-1-elisa', 1);
-- K03115: «Anti Coxiella burnetii IgA antitijela faza 1 - ELISA» → «Anti Coxiella burnetii IgA faza 1 - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('coxiella-burnetii-iga-phase-1-elisa', 'coxiella-burnetii-iga-antibodies-phase-1-elisa', 1);
-- K03116: «Anti Coxiella burnetii IgM antitijela faza 2 - ELISA» → «Anti Coxiella burnetii IgM faza 2 - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('coxiella-burnetii-igm-phase-2-elisa', 'coxiella-burnetii-igm-antibodies-phase-2-elisa', 1);
-- K03117: «Anti Coxiella burnetii IgG antitijela faza 2 - ELISA» → «Anti Coxiella burnetii IgG faza 2 - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('coxiella-burnetii-igg-phase-2-elisa', 'coxiella-burnetii-igg-antibodies-phase-2-elisa', 1);
-- K03118: строка Никшича по коду — «Koksaki B IgM»; название услуги «Anti Coxiella burnetii IgA antitijela faza 2 - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('coxsackie-b-igm', 'coxiella-burnetii-iga-antibodies-phase-2-elisa', 0);
-- K03119: строка Никшича по коду — «Koksaki B IgG»; название услуги «Anti Coxsackie B virus IgM antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('coxsackie-b-igg', 'coxsackie-b-virus-igm-antibodies-elisa', 0);
-- K03120: строка Никшича по коду — «Koksaki virus IgM»; название услуги «Anti Coxsackie B virus IgG antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('coxsackie-virus-igm', 'coxsackie-b-virus-igg-antibodies-elisa', 0);
-- K03121: строка Никшича по коду — «Koksaki virus IgG»; название услуги «Anti Coxsackie virus IgM antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('coxsackie-virus-igg', 'coxsackie-virus-igm-antibodies-elisa', 0);
-- K03122: строка Никшича по коду — «Echinococcus IgG ELISA»; название услуги «Anti Coxsackie virus IgG antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('echinococcus-igg-elisa', 'coxsackie-virus-igg-antibodies-elisa', 0);
-- K03123: «Anti Echinococcus granulosus IgG antitijela - ELISA» → «Anti Echinococcus granulosus antitijela - indirektna hemaglutinacija»
CALL dedup_move_service_to_lab_test_by_slug('echinococcus-granulosus-antibodies-indirect-hemagglutination', 'echinococcus-granulosus-igg-antibodies-elisa', 0);
-- K03125: «Anti Hanta virus IgM antitijela - ELISA» → «Anti Hanta virus IgG - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('hantavirus-igg-elisa', 'anti-hanta-virus-igm-antibodies-elisa', 0);
-- K03126: строка Никшича по коду — «Anti HBc antitijela - ELISA»; название услуги «Anti Hanta virus IgG antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('anti-hbc-total-elisa', 'anti-hanta-virus-igg-antibodies-elisa', 0);
-- K03129: строка Никшича по коду — «HBsAb»; название услуги «Anti HBeAg antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('hbsab', 'anti-hbeag-antibodies-elisa', 0);
-- K03130: строка Никшича по коду — «Anti hepatitis C virus antitijela - imuno blot»; название услуги «Anti HBsAg antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('anti-hcv-antibodies-immunoblot', 'anti-hbsag-antibodies-elisa', 0);
-- K03131: строка Никшича по коду — «Hepatitis A IgM»; название услуги «Anti Hepatitis C virus antitijela - potvrdni test - Immunoblot» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('hav-igm', 'anti-hepatitis-c-virus-antibodies-confirmatory-test-immunoblot', 0);
-- K03132: строка Никшича по коду — «HAV ukupna antitela»; название услуги «Anti Hepatitis A virus IgM antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('hav-total-antibodies', 'anti-hepatitis-a-virus-igm-antibodies-elisa', 0);
-- K03133: «Anti Hepatitis A virus IgG antitijela - ELISA» → «Anti hepatitis E virus IgM - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('anti-hev-igm-elisa', 'anti-hepatitis-a-virus-igg-antibodies-elisa', 0);
-- K03134: «Anti Hepatitis E virus IgM antitijela - ELISA» → «Anti hepatitis E virus IgG - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('anti-hev-igg-elisa', 'anti-hepatitis-e-virus-igm-antibodies-elisa', 0);
-- K03135: строка Никшича по коду — «Anti HIV 1 antitijela - potvrdni test - western blot»; название услуги «Anti Hepatitis E virus IgG antitijela - ELISA» съехало с соседней позиции, синонимом не заводим
CALL dedup_move_service_to_lab_test_by_slug('anti-hiv-1-western-blot-confirmation', 'anti-hepatitis-e-virus-igg-antibodies-elisa', 0);
-- K03138: «Anti Influenza B virus IgM antitijela - ELISA» → «Anti influenza B virus IgG - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('influenza-b-virus-igg-elisa', 'anti-influenza-b-virus-igm-antibodies-elisa', 0);
-- K03139: «Anti Influenza B virus IgG antitijela - ELISA» → «Anti influenza A virus IgM - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('influenza-a-virus-igm-elisa', 'anti-influenza-b-virus-igg-antibodies-elisa', 0);
-- K03140: «Anti Influenza A virus IgM antitijela - ELISA» → «Anti influenza A virus IgG - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('influenza-a-virus-igg-elisa', 'anti-influenza-a-virus-igm-antibodies-elisa', 0);
-- K03142: «Anti Legionella pneumophila IgM - ELISA» → «Legionella Pneumophila IgG»
CALL dedup_move_service_to_lab_test_by_slug('legionella-pneumophila-igg', 'legionella-pneumophila-igm-elisa', 0);
-- K03143: «Anti Legionella pneumophila IgG - ELISA» → «Anti Legionella pneumophila IgA - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('legionella-pneumophila-iga-elisa', 'legionella-pneumophila-igg-elisa', 0);
-- K03157: «Anti Toxocara canis IgG - ELISA» → «Toxocara Canis IgG»
CALL dedup_move_service_to_lab_test_by_slug('toxocara-canis-igg', 'toxocara-canis-igg-elisa', 1);
-- K03158: «Anti Trichinella spiralis IgG antitijela - ELISA» → «Trichinella Spiralis IgG»
CALL dedup_move_service_to_lab_test_by_slug('trichinella-spiralis-igg', 'trichinella-spiralis-igg-antibodies-elisa', 1);
-- K03160: «Anti West Nile virus IgM antitijela - ELISA» → «Anti West Nile virus IgM - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('west-nile-virus-igm-elisa', 'west-nile-virus-igm-antibodies-elisa', 1);
-- K03161: «Anti West Nile virus IgG antitijela - ELISA» → «Anti West Nile virus IgG - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('west-nile-virus-igg-elisa', 'west-nile-virus-igg-antibodies-elisa', 1);
-- «Aviditet Anti Cytomegalovirus IgG antitijela - ELISA/ELFA» → cmv-avidity
CALL dedup_move_service_to_lab_test_by_slug('cmv-avidity', 'cytomegalovirus-igg-antibody-avidity-elisaelfa', 1);
-- K03163: «Aviditet Anti Rubella virus IgG antitijela - ELISA» → «Rubela IgG aviditet»
CALL dedup_move_service_to_lab_test_by_slug('rubella-igg-avidity', 'rubella-virus-igg-antibody-avidity-elisa', 1);
-- K03164: «Aviditet Anti Toxoplasma gondii IgG antitijela - ELISA/ELFA» → «Toxoplasma IgG aviditet»
CALL dedup_move_service_to_lab_test_by_slug('toxoplasma-igg-avidity', 'toxoplasma-gondii-igg-antibody-avidity-elisaelfa', 1);
-- K03165: «Ispitivanje prisustva Clostridium difficile toksina (A i B) - ELISA/ELFA» → «Clostridium Difficile toksin A i B»
CALL dedup_move_service_to_lab_test_by_slug('clostridium-difficile-toxin-a-and-b', 'clostridium-difficile-toxin-ab-detection-elisaelfa', 1);
-- K03166: «Ispitivanje prisustva Cytomegalovirusa - indirektna imunofluorescencija» → «Ispitivanje prisustva Cytomegalovirus antigena - indirektna imunofluorescencija»
CALL dedup_move_service_to_lab_test_by_slug('cytomegalovirus-antigen-indirect-immunofluorescence', 'cytomegalovirus-detection-indirect-immunofluorescence', 1);
-- «Ispitivanje prisustva HBe antigena - ELISA/ANTIGEN» → hbeag
CALL dedup_move_service_to_lab_test_by_slug('hbeag', 'hbe-antigen-detection-elisaantigen', 1);
-- «Ispitivanje prisustva HBs antigena - ELISA/ANTIGEN» → hbsag
CALL dedup_move_service_to_lab_test_by_slug('hbsag', 'hbs-antigen-detection-elisaantigen', 1);
-- K03172: «Ispitivanje prisustva P24 antigena - ELISA/ANTIGEN» → «Ispitivanje prisustva p24 antigena - ELISA»
CALL dedup_move_service_to_lab_test_by_slug('hiv-p24-antigen-elisa', 'p24-antigen-detection-elisaantigen', 1);
-- «PAPA test (laboratorijska analiza)» → pap-papanicolaou-test
CALL dedup_move_service_to_lab_test_by_slug('pap-papanicolaou-test', 'pap-test-lab-analysis', 1);
-- X12024: «Combo test Ag/At HIV 1/2» → «HIV 1 Plus 2 Ag Ab»
CALL dedup_move_service_to_lab_test_by_slug('hiv-1-plus-2-ag-ab', 'hiv-1-2-ag-ab-combo-test', 1);
-- X12025: «Test na HCV - Anti-HCV antitijela» → «Anti-HCV»
CALL dedup_move_service_to_lab_test_by_slug('anti-hcv', 'hcv-antibody-test-anti-hcv', 1);
-- X12052: «Ispitivanje iregularnih antitijela - enzimski skrining test/gel metoda» → «Ispitivanje iregularnih antitijela enzim screening — gel metoda»
CALL dedup_move_service_to_lab_test_by_slug('irregular-antibody-enzyme-screening-gel-method', 'irregular-antibody-screening-test-gel-method', 1);
-- X12053: «Interreakcija/gel metoda» → «Interreakcija — gel metoda»
CALL dedup_move_service_to_lab_test_by_slug('crossmatch-gel-method', 'crossmatch-test-gel-method', 1);
-- Z01009: «Određivanje protrombinskog vremena» → «Protrombinsko vreme PT INR»
CALL dedup_move_service_to_lab_test_by_slug('prothrombin-time-pt-inr', 'prothrombin-time-pt', 1);
-- Z01014: «Ukupni proteini u serumu» → «Ukupni proteini»
CALL dedup_move_service_to_lab_test_by_slug('total-protein', 'serum-total-protein', 1);
-- Z01015: «Ukupni bilirubin u serumu» → «Ukupni bilirubin»
CALL dedup_move_service_to_lab_test_by_slug('total-bilirubin', 'serum-total-bilirubin', 1);
-- Z01016: «Glukoza u serumu» → «Glukoza»
CALL dedup_move_service_to_lab_test_by_slug('glucose', 'serum-glucose', 1);
-- Z01017: «Oralni glukoza tolerans test OGTT» → «Oralni test tolerancije glukoze»
CALL dedup_move_service_to_lab_test_by_slug('oral-glucose-tolerance-test', 'oral-glucose-tolerance-test-ogtt', 1);
-- Z01018: «Trigliceridi u serumu» → «Trigliceridi»
CALL dedup_move_service_to_lab_test_by_slug('triglycerides', 'serum-triglycerides', 1);
-- Z01019: «Holesterol u serumu» → «Holesterol»
CALL dedup_move_service_to_lab_test_by_slug('cholesterol', 'serum-cholesterol', 1);
-- Z01021: «Aktivnost alkalne fosfataze» → «Alkalna fosfataza»
CALL dedup_move_service_to_lab_test_by_slug('alkaline-phosphatase', 'alkaline-phosphatase-activity', 1);
-- «Aktivnost AST» → ast
CALL dedup_move_service_to_lab_test_by_slug('ast', 'ast-activity', 1);
-- «Aktivnost CK-MB» → ck-mb
CALL dedup_move_service_to_lab_test_by_slug('ck-mb', 'ck-mb-activity', 1);
-- «Aktivnost CK» → ck
CALL dedup_move_service_to_lab_test_by_slug('ck', 'ck-activity', 1);
-- Z01027: «Aktivnost gama glutamil transferaza GGT» → «Gama-glutamil transferaza»
CALL dedup_move_service_to_lab_test_by_slug('gamma-gt', 'ggt-activity', 1);
-- Z01031: «Mokraćna kiselina u serumu» → «Mokraćna kiselina»
CALL dedup_move_service_to_lab_test_by_slug('uric-acid', 'serum-uric-acid', 1);
-- Z01032: «Kalijum K u serumu» → «Kalijum»
CALL dedup_move_service_to_lab_test_by_slug('potassium', 'serum-potassium-k', 1);
-- «Određivanje ukupnih kalcijuma u serumu» → calcium
CALL dedup_move_service_to_lab_test_by_slug('calcium', 'total-serum-calcium', 1);
-- «Određivanje gvožđa u serumu» → iron
CALL dedup_move_service_to_lab_test_by_slug('iron', 'serum-iron', 1);
-- Z01037: «Kapacitet vezivanja gvožđa TIBC» → «Ukupni kapacitet vezivanja gvožđa»
CALL dedup_move_service_to_lab_test_by_slug('tibc', 'total-iron-binding-capacity-tibc', 1);
-- «Ispitivanje urina test traka i sediment mikroskopski» → complete-urinalysis
CALL dedup_move_service_to_lab_test_by_slug('complete-urinalysis', 'urinalysis-with-sediment-microscopy', 1);
-- Z01064: «Određivanje direktnog bilirubina u serumu» → «Direktni bilirubin»
CALL dedup_move_service_to_lab_test_by_slug('direct-bilirubin', 'direct-bilirubin-in-serum', 1);
-- Z01066: «Slobodni kapacitet vezivanja gvožđa UIBC» → «Neiskorišćeni kapacitet vezivanja gvožđa»
CALL dedup_move_service_to_lab_test_by_slug('uibc', 'unsaturated-iron-binding-capacity-uibc', 1);
-- Z01084: «Ispitivanje urina sa flow citometrijom» → «Kompletan pregled urina (test traka + flow citometrija sedimenta)»
CALL dedup_move_service_to_lab_test_by_slug('complete-urinalysis-with-flow-cytometry', 'urinalysis-with-flow-cytometry', 1);
-- «Aktivnost ALT» → alt
CALL dedup_move_service_to_lab_test_by_slug('alt', 'alt-activity', 1);
-- Z01097: «Natrijum Na u serumu» → «Natrijum»
CALL dedup_move_service_to_lab_test_by_slug('sodium', 'serum-sodium-na', 1);
-- «Hloridi Cl u serumu» → chloride
CALL dedup_move_service_to_lab_test_by_slug('chloride', 'serum-chloride-cl', 1);
-- «Kalcijum Ca u serumu» → ionized-calcium
CALL dedup_move_service_to_lab_test_by_slug('ionized-calcium', 'serum-calcium-ca', 0);
-- Z01103: «Retikulociti citohemija» → «Retikulociti»
CALL dedup_move_service_to_lab_test_by_slug('reticulocytes', 'reticulocyte-cytochemistry', 1);
-- Z01104: «Aktivnost laktat dehidrogenaze LDH» → «Laktat dehidrogenaza»
CALL dedup_move_service_to_lab_test_by_slug('ldh', 'ldh-activity', 1);
-- «KKS PET PAR DIF» → complete-blood-count-with-leukocyte-formula
CALL dedup_move_service_to_lab_test_by_slug('complete-blood-count-with-leukocyte-formula', 'five-part-differential-cbc', 1);
-- «APTT iz kapilarne krvi» → activated-partial-thromboplastin-time
CALL dedup_move_service_to_lab_test_by_slug('activated-partial-thromboplastin-time', 'aptt-capillary-blood', 1);
-- Z02093: «Određivanje psihoaktivnih supstanci» → «Određivanje pojedinačne psihoaktivne supstance (test traka)»
CALL dedup_move_service_to_lab_test_by_slug('single-psychoactive-substance-test', 'psychoactive-substance-detection', 1);
-- Z02098: «Proteini u urinu kvantitativno (sek)» → «Proteini u urinu»
CALL dedup_move_service_to_lab_test_by_slug('protein-in-urine', 'urine-protein-quantitative-secondary', 1);

DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test_by_slug;
DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test;

-- ═══ Проверка: должно остаться 0 ═══
SELECT COUNT(*) AS services_left FROM medical_services WHERE slug IN (
  'gonorrhea-smear-examination',
  'throat-swab-culture',
  'oral-cavity-swab-culture',
  'tongue-swab',
  'nose-swab',
  'ear-swab-culture',
  'eye-swab-culture',
  'wound-swab',
  'skin-swab-culture',
  'breast-swab-culture',
  'vaginal-swab-culture',
  'vulvar-swab-culture',
  'glans-swab-culture',
  'prepuce-swab-culture',
  'urethral-swab-culture',
  'pus-swab-culture',
  'sputum-culture',
  'cervical-culture',
  'mycoplasma-culture-with-antibiogram',
  'nail-dermatomycosis-examination',
  'skin-dermatomycosis-examination',
  'skin-fungal-culture',
  'hair-fungal-culture',
  'nail-fungal-culture',
  'vaginal-fungal-culture',
  'vulvar-fungal-culture',
  'glans-fungal-culture',
  'prepuce-fungal-culture',
  'semen-fungal-culture',
  'urethral-fungal-culture',
  'stool-fungal-culture',
  'urine-fungal-culture',
  'sputum-fungal-culture',
  'throat-fungal-culture',
  'palate-fungal-culture',
  'nose-fungal-culture',
  'wound-fungal-culture',
  'trichomonas-vaginalis-native-examination',
  'urethral-or-vaginal-trichomonas-vaginalis-smear-examination-grading',
  'stool-helminth-microscopy-cellophane-tape-method',
  'stool-helminth-microscopy',
  'malaria-microscopy',
  'skin-ectoparasite-identification',
  'hair-demodex-examination',
  'aso-latex-test',
  'paul-bunnell-mononucleosis-reaction',
  'tpha-test',
  'cytological-microscopic-examination',
  'rheumatoid-factor-latex-test',
  'tongue-fungal-culture',
  'antimicrobial-antibody-elisa-detection',
  'microbial-antigen-elisa-detection',
  'antimicrobial-antibody-complement-fixation-reaction',
  'antibody-hemagglutination-test',
  'antibody-latex-agglutination',
  'microbial-antigen-nucleic-acid-hybridization-test',
  'sperm-culture',
  'campylobacter-culture',
  'helicobacter-pylori-antibodies-elisa',
  'aerobic-bacterial-culture-of-bronchoalveolar-lavage',
  'aerobic-bacterial-culture-of-uterine-cavity-swab',
  'aerobic-bacterial-culture-of-dilation-fluid',
  'aerobic-bacterial-culture-of-tissue-segment-swab',
  'bordetella-pertussis-culture-from-nasopharyngeal-swab',
  'microbial-antigen-latex-agglutination-detection-in-cerebrospinal-fluid',
  'anaerobic-bacterial-culture-of-tissue-segment-swab',
  'blood-and-tissue-parasites-detection-native-preparation-2',
  'borrelia-burgdorferi-igg-antibodies-confirmatory-test-western-blot',
  'borrelia-burgdorferi-igm-antibodies-confirmatory-test-western-blot',
  'brucella-igm-antibodies-elisa',
  'coxiella-burnetii-igg-antibodies-phase-1-elisa',
  'coxiella-burnetii-iga-antibodies-phase-1-elisa',
  'coxiella-burnetii-igm-antibodies-phase-2-elisa',
  'coxiella-burnetii-igg-antibodies-phase-2-elisa',
  'coxiella-burnetii-iga-antibodies-phase-2-elisa',
  'coxsackie-b-virus-igm-antibodies-elisa',
  'coxsackie-b-virus-igg-antibodies-elisa',
  'coxsackie-virus-igm-antibodies-elisa',
  'coxsackie-virus-igg-antibodies-elisa',
  'echinococcus-granulosus-igg-antibodies-elisa',
  'anti-hanta-virus-igm-antibodies-elisa',
  'anti-hanta-virus-igg-antibodies-elisa',
  'anti-hbeag-antibodies-elisa',
  'anti-hbsag-antibodies-elisa',
  'anti-hepatitis-c-virus-antibodies-confirmatory-test-immunoblot',
  'anti-hepatitis-a-virus-igm-antibodies-elisa',
  'anti-hepatitis-a-virus-igg-antibodies-elisa',
  'anti-hepatitis-e-virus-igm-antibodies-elisa',
  'anti-hepatitis-e-virus-igg-antibodies-elisa',
  'anti-influenza-b-virus-igm-antibodies-elisa',
  'anti-influenza-b-virus-igg-antibodies-elisa',
  'anti-influenza-a-virus-igm-antibodies-elisa',
  'legionella-pneumophila-igm-elisa',
  'legionella-pneumophila-igg-elisa',
  'toxocara-canis-igg-elisa',
  'trichinella-spiralis-igg-antibodies-elisa',
  'west-nile-virus-igm-antibodies-elisa',
  'west-nile-virus-igg-antibodies-elisa',
  'cytomegalovirus-igg-antibody-avidity-elisaelfa',
  'rubella-virus-igg-antibody-avidity-elisa',
  'toxoplasma-gondii-igg-antibody-avidity-elisaelfa',
  'clostridium-difficile-toxin-ab-detection-elisaelfa',
  'cytomegalovirus-detection-indirect-immunofluorescence',
  'hbe-antigen-detection-elisaantigen',
  'hbs-antigen-detection-elisaantigen',
  'p24-antigen-detection-elisaantigen',
  'pap-test-lab-analysis',
  'hiv-1-2-ag-ab-combo-test',
  'hcv-antibody-test-anti-hcv',
  'irregular-antibody-screening-test-gel-method',
  'crossmatch-test-gel-method',
  'prothrombin-time-pt',
  'serum-total-protein',
  'serum-total-bilirubin',
  'serum-glucose',
  'oral-glucose-tolerance-test-ogtt',
  'serum-triglycerides',
  'serum-cholesterol',
  'alkaline-phosphatase-activity',
  'ast-activity',
  'ck-mb-activity',
  'ck-activity',
  'ggt-activity',
  'serum-uric-acid',
  'serum-potassium-k',
  'total-serum-calcium',
  'serum-iron',
  'total-iron-binding-capacity-tibc',
  'urinalysis-with-sediment-microscopy',
  'direct-bilirubin-in-serum',
  'unsaturated-iron-binding-capacity-uibc',
  'urinalysis-with-flow-cytometry',
  'alt-activity',
  'serum-sodium-na',
  'serum-chloride-cl',
  'serum-calcium-ca',
  'reticulocyte-cytochemistry',
  'ldh-activity',
  'five-part-differential-cbc',
  'aptt-capillary-blood',
  'psychoactive-substance-detection',
  'urine-protein-quantitative-secondary'
);
