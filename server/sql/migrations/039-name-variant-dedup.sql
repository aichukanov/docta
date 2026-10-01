-- 039: дубли каталога, различающиеся одним словом или языком записи.
--
-- Собрано scripts/services/build-name-variant-dedup-sql.mjs из
-- data/service-names/_dedup-039.json — руками не править.
-- Применять ПОСЛЕ 038: слияние ergometry-stress-test ← exercise-ecg-ergometry
-- рассчитано на то, что 038 уже слила туда ergometry-ecg-stress-test, а три
-- пары ниже пересматривают отказы 038.
--
-- ОТКУДА ПАРЫ. Агенты волны 3 справок отметили около двадцати дублей
-- (prd/service-reference-content/PROGRESS.md). Остальное найдено тремя
-- проходами по базе: один код ФЗОЦГ на разных записях каталога, слаги с
-- разницей в одно «пустое» слово (test, culture, total, rapid…), совпадение
-- названия или синонима одной записи с названием другой на любом языке.
-- Слияний: услуг — 44, анализов — 23; отказов — 2.
--
-- ПРАВИЛО ПРЕЖНЕЕ (027–034): решает код прайса. Один код в разных клиниках —
-- дубль. Обе записи в одной клинике по разной цене — разные позиции (так
-- отклонены грибы из зева и метанефрины у клиники 64). Коды PZZ и
-- секундарного прайса в блоках H, I03, J, K и X03/X14/X15 совпадают по
-- смыслу — это проверено по названиям обоих прайсов, поэтому строки ДЗ 80/127
-- и больниц 88/131/137 с одним кодом сливаются. В X01/X02 коды ДЗ
-- Херцег-Нови сдвинуты, там решает название.
--
-- ПЕРЕСМОТР ОТКАЗОВ 038. Три пары 038 отклоняет, здесь они сливаются:
--   * x-ray-chest-heart / x-ray-chest-and-heart — отказ верный по сути
--     (J06010 — снимок сердца, J06051 — лёгких и сердца), но лечится переносом
--     J06010 на heart-teleradiography, как 038 сама сделала с panoramic-x-ray
--     и J11001. После переноса обе записи — снимок лёгких и сердца.
--   * mri-pelvic-organs / mri-pelvis — отказ по контрасту (J09017 / J09018),
--     но МРТ в каталоге по контрасту не делится нигде: у клиники 88 все
--     исследования блока J09 лежат на одной записи с двумя кодами и диапазоном.
--   * dental-sinus-lift / sinus-lift-with-augmentation — отказ «клиника 117
--     держит обе», но обе её строки без цены, а на её сайте одна процедура
--     синус-лифта с костным графтом.
--
-- ЧТО ТЕРЯЕТСЯ. Строка клиники 88 X12055 «Combo test Ag/At HCV» стояла на
-- hcv-total-antibodies, хотя это другой тест (антиген + антитела); своей
-- записи у него нет, и при слиянии в anti-hcv она уходит. Справки дублей,
-- если у основной есть своя, удаляются каскадом — в data/entity-reference
-- они убраны тем же коммитом, чтобы пересборка справок не упала на NULL в FK.
--
-- Процедуры создаются и удаляются внутри файла. CREATE PROCEDURE делает неявный
-- COMMIT, поэтому транзакции нет; повторный прогон безопасен: слияние
-- проверяет, что обе половинки ещё на месте, подготовка — что строки ещё в
-- старом виде.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';


-- ═══ 1. Подготовка: диапазоны цен и перенос строк по коду ═══

-- x-ray-chest-and-heart, клиника opsta-bolnica-niksic: клиника 137 держит J06052 «Teleradiografija pluća i srca uz RTGsk» (12,53 €) на heart-teleradiography — это снимок лёгких и сердца с рентгеноскопией, а не сердца. Сворачиваем в диапазон на записи лёгких и сердца — так же лежит строка клиники 88 (J06051/J06052, 7,50–15,03)
UPDATE clinic_medical_services SET price_max = 12.53, code = 'J06051/J06052'
 WHERE medical_service_id = (SELECT id FROM medical_services WHERE slug = 'x-ray-chest-and-heart')
   AND clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic')
   AND price_max IS NULL
   AND code = 'J06051';
-- heart-teleradiography, клиника opsta-bolnica-niksic: её цена перенесена шагом выше; освобождает место под J06010 этой же клиники
DELETE FROM clinic_medical_services
 WHERE medical_service_id = (SELECT id FROM medical_services WHERE slug = 'heart-teleradiography') AND clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic') AND code = 'J06052';
-- x-ray-chest-heart → heart-teleradiography, код J06010: J06010 — «Teleradiografija srca – za svaki pravac» (снимок сердца) и в PZZ, и в секундарном прайсе, и в прайсах Данило и Никшича. На x-ray-chest-heart («RTG pluća i srca») его держали 85, 88 и 137, отсюда и отказ в 038. Клиника 85 стоит на обеих записях с одной строкой прайса — её копия на x-ray-chest-heart удаляется
SET @move_from = (SELECT id FROM medical_services WHERE slug = 'x-ray-chest-heart');
SET @move_to = (SELECT id FROM medical_services WHERE slug = 'heart-teleradiography');
UPDATE IGNORE clinic_medical_service_doctors d
  JOIN clinic_medical_services c ON c.clinic_id = d.clinic_id AND c.medical_service_id = d.medical_service_id
   SET d.medical_service_id = @move_to
 WHERE d.medical_service_id = @move_from AND c.code = 'J06010' AND @move_to IS NOT NULL;
UPDATE IGNORE clinic_medical_services SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = 'J06010' AND @move_to IS NOT NULL;
-- Остались строки клиник, которые уже стояли на цели с тем же кодом: это копия, а не вторая позиция.
-- Строка, у которой на цели другой код, остаётся на месте — её разбирать руками.
DELETE d FROM clinic_medical_service_doctors d
  JOIN clinic_medical_services s ON s.clinic_id = d.clinic_id AND s.medical_service_id = d.medical_service_id
  JOIN clinic_medical_services t ON t.clinic_id = s.clinic_id AND t.medical_service_id = @move_to AND t.code = s.code
 WHERE d.medical_service_id = @move_from AND s.code = 'J06010';
DELETE s FROM clinic_medical_services s
  JOIN clinic_medical_services t ON t.clinic_id = s.clinic_id AND t.medical_service_id = @move_to AND t.code = s.code
 WHERE s.medical_service_id = @move_from AND s.code = 'J06010';
UPDATE medical_service_tariffs SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = 'J06010' AND @move_to IS NOT NULL;
-- mri-pelvic-organs, клиника opsta-bolnica-niksic: МРТ в каталоге по контрасту не делится: у клиники 88 все 13 исследований блока J09 лежат на одной записи с двумя кодами и диапазоном. Клиника 137 держит J09017 (без контраста, 90 €) на mri-pelvic-organs и J09018 (с контрастом, 117 €) на mri-pelvis — после слияния будет 90–117 €, как у других её МРТ
UPDATE clinic_medical_services SET price_max = 117.00, code = 'J09017/J09018'
 WHERE medical_service_id = (SELECT id FROM medical_services WHERE slug = 'mri-pelvic-organs')
   AND clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic')
   AND price_max IS NULL
   AND code = 'J09017';
-- frenectomy, клиника buntic-stomatoloska-ordinacija-bar: клиника 60 держит «Frenektomija» за 50 € и «Frenulektomija» за 70 €. Это одна операция (иссечение уздечки), чем различаются две строки прайса, не установить: сайт клиники больше не работает, домен продаётся. Чтобы не потерять ни одну цену, ставим диапазон 50–70 €
UPDATE clinic_medical_services SET price_max = 70.00
 WHERE medical_service_id = (SELECT id FROM medical_services WHERE slug = 'frenectomy')
   AND clinic_id = (SELECT id FROM clinics WHERE slug = 'buntic-stomatoloska-ordinacija-bar')
   AND price_max IS NULL
   AND price = 50.00;

-- ═══ 2. Слияния услуг ═══

-- Процедура слияния — дословно из 030 (там же разобрано, что и в каком порядке она переносит).
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;

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

-- после переноса J06010 обе записи — снимок лёгких и сердца (J06051/J06052 у 88, 131, 137, «RTG pluća i srca» у Milmedika). Основная — старшая запись: её справка из батча 1 и URL с июля
CALL dedup_merge_medical_service_by_slug('x-ray-chest-heart', 'x-ray-chest-and-heart');
-- «Telekardiografija» ДЗ 80/127 = «Teleradiografija srca»: код J06010 у всех, цены 7,00–7,74
CALL dedup_merge_medical_service_by_slug('heart-teleradiography', 'telecardiography');
-- МРТ малого таза: J09017/J09018 (см. подготовку). Основная держит тарифы J09017 и категорию MRI
CALL dedup_merge_medical_service_by_slug('mri-pelvic-organs', 'mri-pelvis');
-- синус-лифт — это и есть подъём дна пазухи с аугментацией. У клиники 117 на сайте одна процедура «Sinus lift» с костным графтом Bio-Oss; обе её строки без цены, поэтому отказ 038 («117 держит обе») не держится. Цены остальных клиник те же 700–1000 €
CALL dedup_merge_medical_service_by_slug('dental-sinus-lift', 'sinus-lift-with-augmentation');
-- френэктомия = френулэктомия, иссечение уздечки. У клиники 117 на сайте одно «uklanjanje frenuluma»; цены клиники 60 — см. подготовку
CALL dedup_merge_medical_service_by_slug('frenectomy', 'frenulectomy');
-- «Aplikacija štrajfne u uho» = «Plasiranje štrajfne za uho»; основная держит код X07063
CALL dedup_merge_medical_service_by_slug('ear-wick-application', 'ear-wick-placement');
-- «Davanje klistira» = клизма. Код HN_X01006 в расчёт не берём: в X01 коды ДЗ Херцег-Нови сдвинуты, решает название
CALL dedup_merge_medical_service_by_slug('enema', 'enema-administration');
-- «Bris grla» = «Bris ždrijela» (K01007 у 80 и 137)
CALL dedup_merge_medical_service_by_slug('throat-swab-culture', 'throat-swab');
-- одна проба, единственное и множественное число; код X06050
CALL dedup_merge_medical_service_by_slug('glaucoma-provocation-test', 'glaucoma-provocation-tests');
-- «Primarna obrada rane bez šivenja» = «(bez šavova)», X01014
CALL dedup_merge_medical_service_by_slug('primary-wound-care-without-sutures', 'primary-wound-treatment-without-suturing');
-- «Primarna obrada rane sa šivenjem» = «(sa šavovima)», X02036
CALL dedup_merge_medical_service_by_slug('primary-wound-care-with-sutures', 'primary-wound-treatment-with-suturing');
-- сербское название совпадает дословно, у всех код X15011
CALL dedup_merge_medical_service_by_slug('lumbar-sacral-or-coccygeal-block', 'lumbar-sacral-and-coccygeal-block');
-- «Naknada za uzimanje krvi» частных лабораторий — та же манипуляция, что «Uzimanje krvi iz vene» (Z04001). Отказ 038 venous-blood-draw ≠ venipuncture не задет: венопункция там — трансфузиологическая X12033
CALL dedup_merge_medical_service_by_slug('venous-blood-draw', 'blood-collection-fee');
-- один код J01001 «Prvi specijalistički pregled (radiolog)» у клиники 85 и у 80/88/127/131/137
CALL dedup_merge_medical_service_by_slug('first-radiologist-examination', 'radiologist-examination');
-- J06001 «Snimanje skeleta lobanje i lica – za svaki snimak» у 85, 88, 137; краниограмма — название той же позиции у клиники 88
CALL dedup_merge_medical_service_by_slug('x-ray-head-craniogram', 'x-ray-skull-and-face');
-- тот же J06001 у ДЗ 80/127, название дословно из прайса. Тариф PZZ J06001, который 038 переносит сюда, слиянием вернётся на основную вместе с секундарным
CALL dedup_merge_medical_service_by_slug('x-ray-head-craniogram', 'skull-and-face-x-ray-per-image');
-- J06004 «Lokalizacija stranog tijela u bilo kojem organu» у ДЗ 80/127
CALL dedup_merge_medical_service_by_slug('foreign-body-localization-x-ray-except-eye', 'foreign-body-localization-imaging');
-- J06004 у клиники 85
CALL dedup_merge_medical_service_by_slug('foreign-body-localization-x-ray-except-eye', 'x-ray-foreign-body-localization');
-- K01003 «Uzimanje uzorka» — в PZZ и секундарном прайсе одна позиция микробиологии
CALL dedup_merge_medical_service_by_slug('microbiology-sample-collection', 'sample-collection');
-- X03002: «Defibrilacija» в PZZ, «Spoljašnja defibrilacija srca» в секундарном
CALL dedup_merge_medical_service_by_slug('external-cardiac-defibrillation', 'defibrillation');
-- X14003 «Dinamska elektrokardiografija (ergometrija)» у клиники 131; 88/137 с этим кодом сливаются в ту же основную в 038 (ergometry-ecg-stress-test)
CALL dedup_merge_medical_service_by_slug('ergometry-stress-test', 'exercise-ecg-ergometry');
-- X14004 у клиники 131 — полное название той же позиции
CALL dedup_merge_medical_service_by_slug('ergocycle-stress-test-with-complete-ecg', 'submaximal-exercise-stress-test-on-bicycle-ergometer-with-complete-ecg');
-- X14006 у клиники 131, название то же плюс «(stres eho test)»
CALL dedup_merge_medical_service_by_slug('pharmacological-test-for-ischemia-or-myocardial-viability', 'pharmacological-stress-echocardiography-for-myocardial-ischemia-and-viability-assessment');
-- X15001 — «Spinalna anestezija/analgezija» (прайс Данило); «Specijalna» у клиники 131 — ошибка распознавания FINAL.json
CALL dedup_merge_medical_service_by_slug('spinal-anesthesiaanalgesia', 'specialized-anesthesia-analgesia');
-- X15018 у клиники 131 — полное название той же позиции
CALL dedup_merge_medical_service_by_slug('treatment-of-patients-with-respiratory-insufficiency', 'treatment-of-patients-with-respiratory-insufficiency-on-a-ventilator-per-hour-of-effective-specialist-work-maximum-2-hours');
-- H01004: «Površna individualna terapija (savjeti pacijentu)» в PZZ = «Površinska individualna psihoterapija, savjetovanje» в секундарном; тариф PZZ уже стоит на основной
CALL dedup_merge_medical_service_by_slug('individual-supportive-psychotherapy-and-counseling', 'individual-psychiatric-therapy-counseling');
-- H01007 — групповая психотерапия зависимых в обоих прайсах
CALL dedup_merge_medical_service_by_slug('group-psychotherapy-session-for-addictions', 'addiction-group-psychotherapy');
-- H01008 — семейная психотерапия в обоих прайсах
CALL dedup_merge_medical_service_by_slug('family-psychotherapy-session', 'family-and-couples-psychotherapy');
-- H01009: «Analitički usmjerena terapija» (PZZ) = «Seansa dubinske (analitički orijentisane) psihoterapije»; название дубля «Analitički sumnjivni razgovor» — ошибка распознавания
CALL dedup_merge_medical_service_by_slug('analytically-oriented-depth-psychotherapy-session', 'analytical-therapy-session');
-- H01017 — название в обоих прайсах дословно одно
CALL dedup_merge_medical_service_by_slug('personality-structure-assessment-for-adults', 'adult-personality-structure-assessment');
-- H02001: «Anamneza, dijagnostički intervju» (PZZ) = «Intervju psihologa»; тариф PZZ уже стоит на основной
CALL dedup_merge_medical_service_by_slug('psychologist-interview', 'anamnesis-diagnostic-interview');
-- H02002 — название в обоих прайсах одно
CALL dedup_merge_medical_service_by_slug('psychological-testing-category-a', 'psychological-test-data-collection-category-a');
-- H02003
CALL dedup_merge_medical_service_by_slug('psychological-testing-category-b', 'psychological-test-data-collection-category-b');
-- H02004
CALL dedup_merge_medical_service_by_slug('psychological-testing-category-c', 'psychological-test-data-collection-category-c');
-- H02005
CALL dedup_merge_medical_service_by_slug('psychological-testing-category-d', 'psychological-test-data-collection-category-d');
-- I03001 — двойник из шапки 033 («artikulacijskih»/«artikulacionih»)
CALL dedup_merge_medical_service_by_slug('pediatric-articulation-speech-therapy-assessment', 'speech-therapy-assessment-of-childs-articulation-abilities');
-- I03002 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('speech-fluency-assessment', 'speech-therapy-assessment-of-stuttering-severity');
-- I03004 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('specific-reading-disorder-assessment', 'speech-therapy-assessment-of-specific-learning-disorders');
-- I03005 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('combined-logopedic-somatopedic-oligophrenological-psychomotor-assessment', 'speech-therapy-somatopedic-and-oligophrenological-assessment');
-- I03012 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('psychomotor-instability-defectology-treatment', 'defectological-or-speech-therapy-treatment-of-a-child-with-pdd');
-- I03018 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('defectologist-parental-counseling', 'counseling-for-parents');
-- I03020 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('pedagogical-assessment', 'consultation-for-school-or-kindergarten-educator');
-- I03021 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('defectology-multidisciplinary-patient-workup', 'team-based-patient-evaluation');
-- I03022 — двойник из шапки 033
CALL dedup_merge_medical_service_by_slug('learning-disorder-defectology-speech-therapy', 'defectological-speech-therapy-treatment-of-a-child-with-disabilities');

-- ═══ 3. Слияния анализов ═══

-- Процедура слияния — из 030, плюс шаг 4.2 (перенос тарифов).
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;

DELIMITER $$

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

		-- 4.2 Тарифы ФЗОЦГ (добавлено в 039: lab_test_id появился в 028, FK стоит
		-- на SET NULL — без переноса код молча отвязался бы от каталога)
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
	-- SET, а не SELECT … INTO: пустая выборка в INTO поднимает условие NOT FOUND
	SET v_primary = (SELECT id FROM lab_tests WHERE slug = p_primary COLLATE utf8mb4_unicode_ci);
	SET v_secondary = (SELECT id FROM lab_tests WHERE slug = p_secondary COLLATE utf8mb4_unicode_ci);
	IF v_primary IS NOT NULL AND v_secondary IS NOT NULL AND v_primary <> v_secondary THEN
		CALL dedup_merge_lab_test(v_primary, v_secondary);
	END IF;
END$$

DELIMITER ;

-- экспресс-тест из мазка зева — это и есть тест на антиген стрептококка группы A
CALL dedup_merge_lab_test_by_slug('rapid-strep-a', 'rapid-strep-test');
-- посев мокроты; у клиники 88 на основной K01026 «Sputum kultura»
CALL dedup_merge_lab_test_by_slug('sputum-bacteria', 'sputum-culture-bacteria');
-- посев мокроты на грибы, пара к предыдущей
CALL dedup_merge_lab_test_by_slug('sputum-fungi', 'sputum-culture-fungi');
-- один ПЦР-тест, «COVID-19 PCR» уже синоним основной
CALL dedup_merge_lab_test_by_slug('sars-cov-2-pcr', 'covid-19-pcr');
-- Z02025 «T3 (trijodtironin ukupni)»: T3 без уточнения — общий T3, свободный лежит отдельно
CALL dedup_merge_lab_test_by_slug('t3', 'total-t3');
-- Z02026 «T4 (tiroksin ukupni)», как с T3
CALL dedup_merge_lab_test_by_slug('t4', 'total-t4');
-- частные «HCV ukupna antitela» = Anti-HCV. Клиника 88 держала на дубле X12055 «Combo test Ag/At HCV» — другой тест (антиген + антитела) из трансфузиологического блока; своей записи в каталоге у него нет, и при слиянии эта строка уходит (на основной у 88 остаётся X12025 «Anti HCV antitijela»)
CALL dedup_merge_lab_test_by_slug('anti-hcv', 'hcv-total-antibodies');
-- антитела к рецептору ТТГ (TRAb), клиники не пересекаются
CALL dedup_merge_lab_test_by_slug('anti-tshr', 'anti-tshr-antibodies');
-- HSV1 = Herpes simplex I; клиника 48 держала обе записи по одной цене 14 €
CALL dedup_merge_lab_test_by_slug('herpes-simplex-i-igg', 'hsv1-igg');
-- HSV2 = Herpes simplex II; та же картина у клиники 48
CALL dedup_merge_lab_test_by_slug('herpes-simplex-ii-igg', 'hsv2-igg');
-- посев мочи на грибы; клиники не пересекаются
CALL dedup_merge_lab_test_by_slug('urine-fungi', 'urine-culture-fungi');
-- посев спермы на бактерии (русское название совпадает дословно)
CALL dedup_merge_lab_test_by_slug('sperm-culture-bacteria', 'semen-culture-bacteria');
-- посев спермы на грибы (турецкое название совпадает дословно)
CALL dedup_merge_lab_test_by_slug('sperm-culture-fungi', 'semen-culture-fungi');
-- мазок раны на грибы, «aerobni uslovi» — формулировка прайса Milmedika (немецкое название совпадает дословно)
CALL dedup_merge_lab_test_by_slug('wound-swab-fungi', 'wound-swab-aerobic-fungi');
-- один коммерческий тест HPV Quant-4 (типы 6, 11, 16, 18)
CALL dedup_merge_lab_test_by_slug('hpv-quant-4', 'hpv-quant-4-types-pcr');
-- то же, третья запись
CALL dedup_merge_lab_test_by_slug('hpv-quant-4', 'hpv-quant-4-6-11-16-18');
-- HPV Quant-21
CALL dedup_merge_lab_test_by_slug('hpv-quant-21', 'hpv-quant-21-types-pcr');
-- HPV Quant-21, третья запись
CALL dedup_merge_lab_test_by_slug('hpv-quant-21', 'hpv-quant-21-6-11-16-18-26-31-33-35-39-44-45-51-52-53-56-58-59-66-68-73-82');
-- HPV Quant-15
CALL dedup_merge_lab_test_by_slug('hpv-quant-15-types-pcr', 'hpv-quant-15-6-11-16-18-31-33-35-39-45-51-52-56-58-59-68');
-- PCP — это и есть фенциклидин
CALL dedup_merge_lab_test_by_slug('phencyclidine', 'phencyclidine-pcp');
-- Z01063 «Određivanje alfa amilaze u urinu» у 88 стоит на основной, у 80/127/137 — на дубле
CALL dedup_merge_lab_test_by_slug('amylase-in-urine', 'alpha-amylase-in-urine');
-- Z02111 «Brojanje eozinofilnih granulocita u komori» у 88 и 131 стоит на основной, у 137 — на дубле
CALL dedup_merge_lab_test_by_slug('blood-eosinophils', 'absolute-eosinophil-count-manual-chamber-method');
-- клиника 64 держала обе записи по одной цене 25 €, у основной справка
CALL dedup_merge_lab_test_by_slug('mycoplasma-hominis-ureaplasma', 'mycoplasma-hominis-ureaplasma-culture');

-- ═══ 4. Отказы — чтобы детектор дублей не поднимал эти пары снова ═══

-- throat-swab-fungi ≠ throat-swab-fungi-culture: клиника 64 держит обе по разной цене (5 и 10 €)
INSERT INTO lab_test_duplicate_candidates (lab_test_id_a, lab_test_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:name-variants-2026-10', 'dismissed', NOW()
  FROM lab_tests a JOIN lab_tests b ON a.slug = 'throat-swab-fungi' AND b.slug = 'throat-swab-fungi-culture'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();
-- metanephrines-in-urine ≠ metanephrine-in-urine: клиника 64 держит обе по разной цене (46 и 48 €): метанефрины суммарно и один метанефрин
INSERT INTO lab_test_duplicate_candidates (lab_test_id_a, lab_test_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:name-variants-2026-10', 'dismissed', NOW()
  FROM lab_tests a JOIN lab_tests b ON a.slug = 'metanephrines-in-urine' AND b.slug = 'metanephrine-in-urine'
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();

-- ═══ 5. Синонимы, совпавшие с собственным названием после слияний (как 031) ═══

DELETE syn FROM lab_test_synonyms syn
  JOIN lab_tests e ON e.id = syn.lab_test_id
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN e.name_en
           WHEN 'sr' THEN e.name_sr
           WHEN 'sr-cyrl' THEN e.name_sr_cyrl
           WHEN 'ru' THEN e.name_ru
           WHEN 'de' THEN e.name_de
           WHEN 'tr' THEN e.name_tr
           ELSE NULL
       END;

DELETE syn FROM medical_service_synonyms syn
  JOIN medical_services e ON e.id = syn.medical_service_id
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN e.name_en
           WHEN 'sr' THEN e.name_sr
           WHEN 'sr-cyrl' THEN e.name_sr_cyrl
           WHEN 'ru' THEN e.name_ru
           WHEN 'de' THEN e.name_de
           WHEN 'tr' THEN e.name_tr
           ELSE NULL
       END;

DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
