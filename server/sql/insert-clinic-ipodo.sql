-- iPODO — podološki kabinet, Budva (Dukley Gardens)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ipodo.sql
--
-- ПРЕРЕКВИЗИТЫ (применить в этом порядке):
--   1. server/sql/migrations/021-add-podology.sql   — clinic_types.25, medical_service_categories.36
--   2. server/sql/insert-podology-services.sql      — каталог услуг подологии
--
-- Источники данных (только открытые):
--   Google Places: data/google-places/budva/ipodo-centre-of-podology-safe-manicure-pedicure.json
--   Сайт ipodo.pro (__NEXT_DATA__): контакты, часы работы, разделы услуг
--
-- ЧЕГО ЗДЕСЬ НЕТ И ПОЧЕМУ:
--   * Цены — iPODO не публикует их в открытом виде (виджеты записи alteg.io
--     закрыты авторизацией). Все услуги идут с NULL по дизайну.
--   * Врач-подолог — в открытых источниках только уменьшительное «Анюта»
--     (отзывы) и адрес anuta.zh@mail.ru. Полного имени нет, выдумывать нельзя.
--   * Услуги за пределами подологии (маникюр, стрижки, окрашивание,
--     косметология) в каталог не заводятся — вне медицинского профиля.
--   * Заявление «ПОДОЛОГ №1 ПРИЗЁР ЕВРОПЫ» в описание не переносится:
--     награда без называющей организации не проверяема.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @google_place_id = 'ChIJZZCl95fVTRMReLlhoR499pY';
SET @city_budva = 3;
SET @type_podology_cabinet = 25;
SET @lang_sr = 1;
SET @lang_ru = 2;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC (идемпотентно по google_place_id)
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);

INSERT INTO clinics (
    slug, google_place_id, status, city_id,
    name_sr, name_sr_cyrl, name_ru,
    address_sr, address_sr_cyrl, town_sr, town_sr_cyrl,
    latitude, longitude,
    phone, email, website, instagram, telegram, whatsapp,
    description_sr, description_sr_cyrl, description_ru,
    description_en, description_de, description_tr,
    created_at
)
SELECT
    'ipodo-centar-za-podologiju-budva', @google_place_id, 'published', @city_budva,
    'iPODO - centar za podologiju', 'iPODO - центар за подологију', 'iPODO — центр подологии',
    'Dukley Gardens, Budva', 'Dukley Gardens, Будва', '', '',
    42.2817772, 18.8592854,
    '+38269295111', 'anuta.zh@mail.ru', 'https://ipodo.pro/', '@ipodo_azh', '@ipodo_bot', '+38269295111',
    'Podološki kabinet u Budvi, u kompleksu Dukley Gardens. Konzervativna podologija: tretman uraslog nokta, korekcija nokta skobicom, medicinski pedikir. Izrađuju individualne ortopedske uloške. Rad po zakazivanju, svakog dana osim nedjelje.',
    'Подолошки кабинет у Будви, у комплексу Dukley Gardens. Конзервативна подологија: третман ураслог нокта, корекција нокта скобицом, медицински педикир. Израђују индивидуалне ортопедске улошке. Рад по заказивању, сваког дана осим недјеље.',
    'Подологический кабинет в Будве, в комплексе Dukley Gardens. Консервативная подология: обработка вросшего ногтя, коррекция ногтя скобой, медицинский педикюр. Изготавливают индивидуальные ортопедические стельки. Приём по записи, ежедневно кроме воскресенья.',
    'Podiatry cabinet in Budva, at the Dukley Gardens complex. Conservative podology: ingrown toenail treatment, nail bracing, medical pedicure. Custom orthopedic insoles are made on site. By appointment, daily except Sunday.',
    'Podologische Praxis in Budva, im Komplex Dukley Gardens. Konservative Podologie: Behandlung eingewachsener Nägel, Nagelspange, medizinische Fußpflege. Individuelle orthopädische Einlagen werden vor Ort angefertigt. Termine nach Vereinbarung, täglich außer Sonntag.',
    'Budva''da, Dukley Gardens kompleksinde bulunan podiyatri kabini. Konservatif podoloji: batık tırnak tedavisi, tırnak teli ile düzeltme, medikal pedikür. Kişiye özel ortopedik tabanlıklar yerinde hazırlanır. Randevu ile, pazar hariç her gün.',
    NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPE — Podiatry Clinic (25)
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id)
VALUES (@clinic_id, @type_podology_cabinet);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: LANGUAGES
-- ═══════════════════════════════════════════════════════════════
-- SR — базовая конвенция каталога. RU — заявлен явно: сайт ipodo.pro
-- целиком на русском, контактный адрес тоже русскоязычный.
-- EN не ставим: англоязычный отзыв подтверждает факт приёма, но сама
-- клиника поддержку на английском нигде не заявляет.
--
-- ⚠️ clinic_languages без UNIQUE — INSERT IGNORE не дедуплицирует,
-- поэтому вставка через NOT EXISTS.

INSERT INTO clinic_languages (clinic_id, language_id, create_time)
SELECT @clinic_id, @lang_sr, NOW() FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM clinic_languages
    WHERE clinic_id = @clinic_id AND language_id = @lang_sr
);

INSERT INTO clinic_languages (clinic_id, language_id, create_time)
SELECT @clinic_id, @lang_ru, NOW() FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM clinic_languages
    WHERE clinic_id = @clinic_id AND language_id = @lang_ru
);

-- ═══════════════════════════════════════════════════════════════
-- PART 4: WORKING HOURS
-- ═══════════════════════════════════════════════════════════════
-- Источник: ipodo.pro → place.workTimeAll. dayOfWeek 1-6 active:true
-- 10:00-20:00, dayOfWeek 0 (воскресенье) active:false.

INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
    @clinic_id,
    '{"type": "regular", "intervals": [{"start": "10:00", "end": "20:00"}]}',
    '{"type": "regular", "intervals": [{"start": "10:00", "end": "20:00"}]}',
    '{"type": "regular", "intervals": [{"start": "10:00", "end": "20:00"}]}',
    '{"type": "regular", "intervals": [{"start": "10:00", "end": "20:00"}]}',
    '{"type": "regular", "intervals": [{"start": "10:00", "end": "20:00"}]}',
    '{"type": "regular", "intervals": [{"start": "10:00", "end": "20:00"}]}',
    '{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
    monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
    thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
    sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 5: SERVICES (цены NULL по дизайну — не публикуются)
-- ═══════════════════════════════════════════════════════════════
-- Только то, что подтверждено открытыми источниками:
--   Podologist Examination            — раздел «ПОДОЛОГИЯ | решение проблем рук и ног»
--   Conservative Ingrown Toenail ...  — отзывы: вросший ноготь вылечен без операции
--   Nail Bracing for Ingrown Toenail  — отзыв: ноготь выравнивался месяцами
--   Medical Pedicure                  — «Безопасный маникюр педикюр», «Высший Ногтевой Сервис»
--   Custom Orthopedic Insoles         — раздел «ОРТОПЕД | индивидуальные стельки»

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, id, NULL, NULL, NULL, NULL FROM medical_services WHERE name_en IN (
    'Podologist Examination',
    'Conservative Ingrown Toenail Treatment',
    'Nail Bracing for Ingrown Toenail',
    'Medical Pedicure',
    'Custom Orthopedic Insoles'
);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT id, slug, status, city_id, name_sr, phone, website FROM clinics WHERE id = @clinic_id;
SELECT clinic_type_id FROM clinic_clinic_types WHERE clinic_id = @clinic_id;
SELECT language_id FROM clinic_languages WHERE clinic_id = @clinic_id;
SELECT ms.slug, cms.price FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id ORDER BY ms.slug;
