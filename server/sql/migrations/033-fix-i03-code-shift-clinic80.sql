-- Сдвиг кодов блока I03 у клиники 80 (ДЗ Херцег-Нови) и привязка тарифов.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/033-fix-i03-code-shift-clinic80.sql
--
-- Блок I03 прайса ФЗОЦГ — логопед и дефектолог в центре психического здоровья.
-- В прайсе клиники 80 перед этим блоком стоит СВОЯ позиция «Logopedski
-- preventivni pregled», которой в ФЗОЦГ нет. Импорт раздал коды по порядку,
-- начиная с I03001, — и вся остальная часть блока уехала на единицу вниз:
-- название услуги соответствует коду N, а записан код N+1.
--
-- ДОКАЗАТЕЛЬСТВА (не догадка):
--   1. Четыре названия совпадают с прайсом ДОСЛОВНО, и каждое смещено на 1:
--      «Logopedska procjena govorne razvijenosti» = I03003, записано I03004;
--      «Defektološko ispitivanje malog djeteta»   = I03006, записано I03007;
--      «Defektološko ispitivanje školskog djeteta»= I03007, записано I03008;
--      «Defektološki grupni tretman školskog djeteta» = I03017, записано I03018.
--   2. Клиника 131 те же три услуги закодировала НЕЗАВИСИМО и верно —
--      I03006, I03007, I03017. После слияний 030 обе строки живут на одной
--      записи каталога, и на странице видно два разных кода сразу.
--   3. На конце блока сдвига НЕТ: «Timska obrada pacijenta» (7202) и
--      «Defektološko-logopedski tretman … u učenju» (7203) совпадают с
--      I03021 и I03022 дословно при текущих кодах. Значит между 7200 и 7202
--      прайс клиники пропускает позицию I03019 «Nalaz i mišljenje
--      defektologa» — и выравнивание восстанавливается само.
-- Итог: чинить надо ровно 7182–7200, хвост 7201–7203 трогать нельзя.
--
-- ЧТО ЭТО ЛОМАЛО. medical_service_tariffs привязывались по коду, поэтому на
-- странице услуги показывалась карточка чужого тарифа: на «обследовании
-- малого ребёнка» — тариф обследования ШКОЛЬНИКА и его цена.
--
-- Скрипт идемпотентен: значения присваиваются абсолютные, а не сдвигом.
--
-- ОСТАЁТСЯ ПОСЛЕ ЭТОЙ МИГРАЦИИ — 9 пар-двойников. Клиники 80 и 131 завели
-- одни и те же позиции блока разными формулировками («artikulacionih» против
-- «artikulacijskih»), детектор их не поймал. После починки кодов они станут
-- доказуемыми: один код ФЗОЦГ в двух клиниках — это дубль (по тому же
-- правилу, что и 80 слияний в 027/030). Готовый список, основная ← дубликат:
--   7183 ← 8008 (I03001), 7184 ← 8009 (I03002), 7186 ← 8010 (I03004),
--   7187 ← 8011 (I03005), 7194 ← 8014 (I03012), 7200 ← 8016 (I03018),
--   7201 ← 8018 (I03020), 7202 ← 8019 (I03021), 7203 ← 8020 (I03022).
-- Услуга 8017 «Nalaz i mišljenje defektologa» (I03019) двойника не имеет —
-- у клиники 80 этой позиции нет, она остаётся отдельной записью.
-- Отдельной миграцией, чтобы сдвиг можно было применить и проверить сам по себе.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ===========================================================================
-- A. КОДЫ В ПРАЙСЕ КЛИНИКИ 80
--
--    idx_code неуникален, поэтому порядок присвоений не важен —
--    промежуточных коллизий не будет.
-- ===========================================================================

-- Своя позиция клиники, в прайсе ФЗОЦГ соответствия нет — код снимаем,
-- иначе он продолжит указывать на чужую строку прайса.
UPDATE clinic_medical_services SET code = NULL
 WHERE clinic_id = 80 AND medical_service_id = 7182;

UPDATE clinic_medical_services SET code = 'I03001' WHERE clinic_id = 80 AND medical_service_id = 7183;
UPDATE clinic_medical_services SET code = 'I03002' WHERE clinic_id = 80 AND medical_service_id = 7184;
UPDATE clinic_medical_services SET code = 'I03003' WHERE clinic_id = 80 AND medical_service_id = 7185;
UPDATE clinic_medical_services SET code = 'I03004' WHERE clinic_id = 80 AND medical_service_id = 7186;
UPDATE clinic_medical_services SET code = 'I03005' WHERE clinic_id = 80 AND medical_service_id = 7187;
UPDATE clinic_medical_services SET code = 'I03006' WHERE clinic_id = 80 AND medical_service_id = 7188;
UPDATE clinic_medical_services SET code = 'I03007' WHERE clinic_id = 80 AND medical_service_id = 7189;
UPDATE clinic_medical_services SET code = 'I03008' WHERE clinic_id = 80 AND medical_service_id = 7190;
UPDATE clinic_medical_services SET code = 'I03009' WHERE clinic_id = 80 AND medical_service_id = 7191;
UPDATE clinic_medical_services SET code = 'I03010' WHERE clinic_id = 80 AND medical_service_id = 7192;
UPDATE clinic_medical_services SET code = 'I03011' WHERE clinic_id = 80 AND medical_service_id = 7193;
UPDATE clinic_medical_services SET code = 'I03012' WHERE clinic_id = 80 AND medical_service_id = 7194;
UPDATE clinic_medical_services SET code = 'I03013' WHERE clinic_id = 80 AND medical_service_id = 7195;
UPDATE clinic_medical_services SET code = 'I03014' WHERE clinic_id = 80 AND medical_service_id = 7196;
UPDATE clinic_medical_services SET code = 'I03015' WHERE clinic_id = 80 AND medical_service_id = 7197;
UPDATE clinic_medical_services SET code = 'I03016' WHERE clinic_id = 80 AND medical_service_id = 7198;
UPDATE clinic_medical_services SET code = 'I03017' WHERE clinic_id = 80 AND medical_service_id = 7199;
UPDATE clinic_medical_services SET code = 'I03018' WHERE clinic_id = 80 AND medical_service_id = 7200;

-- 7201–7203 не трогаем: их коды I03020–I03022 уже верны, см. шапку.

-- ===========================================================================
-- B. ПРИВЯЗКА ТАРИФОВ
--
--    Только fzocg-pzz: в fzocg-drg есть свои две строки с префиксом I03,
--    это другая нумерация и другой смысл.
-- ===========================================================================

UPDATE medical_service_tariffs SET medical_service_id = 7183 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03001';
UPDATE medical_service_tariffs SET medical_service_id = 7184 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03002';
UPDATE medical_service_tariffs SET medical_service_id = 7185 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03003';
UPDATE medical_service_tariffs SET medical_service_id = 7186 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03004';
UPDATE medical_service_tariffs SET medical_service_id = 7187 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03005';
UPDATE medical_service_tariffs SET medical_service_id = 7188 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03006';
UPDATE medical_service_tariffs SET medical_service_id = 7189 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03007';
UPDATE medical_service_tariffs SET medical_service_id = 7190 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03008';
UPDATE medical_service_tariffs SET medical_service_id = 7191 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03009';
UPDATE medical_service_tariffs SET medical_service_id = 7192 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03010';
UPDATE medical_service_tariffs SET medical_service_id = 7193 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03011';
UPDATE medical_service_tariffs SET medical_service_id = 7194 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03012';
UPDATE medical_service_tariffs SET medical_service_id = 7195 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03013';
UPDATE medical_service_tariffs SET medical_service_id = 7196 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03014';
UPDATE medical_service_tariffs SET medical_service_id = 7197 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03015';
UPDATE medical_service_tariffs SET medical_service_id = 7198 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03016';
UPDATE medical_service_tariffs SET medical_service_id = 7199 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03017';
UPDATE medical_service_tariffs SET medical_service_id = 7200 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03018';

-- I03019 «Nalaz i mišljenje defektologa» — позиции нет у клиники 80,
-- зато есть у 131 (услуга 8017). Раньше тариф висел на 7200 «Savjet
-- roditeljima defektolog», то есть на чужой услуге.
UPDATE medical_service_tariffs SET medical_service_id = 8017 WHERE tariff_source = 'fzocg-pzz' AND code = 'I03019';

-- I03020–I03022 уже привязаны верно (7201, 7202, 7203) — не трогаем.
