-- 042: ремонт прода после 039 и 040 — клиника адресовалась локальным id.
--
-- Run: применять на проде; на локальной БД — тоже можно, там все условия
-- уже не совпадают и файл ничего не меняет.
--
-- ЧТО СЛУЧИЛОСЬ. В подготовке 039 и в первой версии 040 Opšta bolnica Nikšić
-- была записана id 137 — это её локальный id. На проде она 141, а 137 там —
-- Opšta bolnica Berane. Остальные id из этих файлов (60, 80, 85, 88, 131) на
-- проде совпадают — сверено по API клиник 2026-10-01.
--
-- Последствия на проде (сверено по публичному API):
--   * Беране получила два чужих анализа — ЛДГ (Z01104, 3,18 €) и CA-125
--     (Z02081, 23,73 €) из INSERT в 040. До этого анализов у неё не было вовсе.
--   * Перепривязки 040 для Никшича не сработали (условие clinic_id = 137) —
--     их делает исправленная 040, её нужно прогнать на проде повторно.
--   * Подготовка 039 для Никшича не сработала, а слияния прошли:
--       x-ray-chest-heart      — код J06010 (снимок сердца) вместо J06051/J06052;
--       heart-teleradiography  — J06052 за 12,53 € (лёгкие и сердце со скопией)
--                                вместо своего J06010 за 6,25 €;
--       mri-pelvic-organs      — J09017, 90 €; цена с контрастом 117 € пропала
--                                при слиянии mri-pelvis.
--     Ниже — то же состояние, что получилось локально, где подготовка отработала.
--
-- Порядок с повторным прогоном 040 не важен. Все UPDATE с условием на старые
-- значения — повторный запуск безопасен.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @niksic = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic');
SET @berane = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-berane');

START TRANSACTION;

-- ── Беране: две строки, вставленные 040 не той клинике

DELETE FROM clinic_lab_tests
 WHERE clinic_id = @berane AND code = 'Z01104' AND price = 3.18
   AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'ldh');
DELETE FROM clinic_lab_tests
 WHERE clinic_id = @berane AND code = 'Z02081' AND price = 23.73
   AND lab_test_id = (SELECT id FROM lab_tests WHERE slug = 'ca-125');

-- ── Никшич: подготовка 039 в состоянии «после слияний»

-- Снимок сердца: на своей записи J06010 за 6,25 € (цена из PDF Никшича), а не J06052
UPDATE clinic_medical_services SET code = 'J06010', price = 6.25, price_min = 6.25, price_max = NULL
 WHERE clinic_id = @niksic AND code = 'J06052'
   AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'heart-teleradiography');

-- Лёгкие и сердце: J06051 без скопии 6,25 € и J06052 со скопией 12,53 € — диапазоном, как у клиники 88
UPDATE clinic_medical_services SET code = 'J06051/J06052', price_max = 12.53
 WHERE clinic_id = @niksic AND code = 'J06010' AND price_max IS NULL
   AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'x-ray-chest-heart');

-- МРТ малого таза: без контраста 90 €, с контрастом 117 € — диапазоном, как у других её МРТ
UPDATE clinic_medical_services SET code = 'J09017/J09018', price_max = 117.00
 WHERE clinic_id = @niksic AND code = 'J09017' AND price_max IS NULL
   AND medical_service_id = (SELECT id FROM medical_services WHERE slug = 'mri-pelvic-organs');

COMMIT;

-- ── Проверка: у Беране анализов 0; у Никшича три строки как в комментариях выше
SELECT 'berane-labs' AS what, COUNT(*) AS n FROM clinic_lab_tests WHERE clinic_id = @berane;
SELECT s.slug, c.code, c.price, c.price_min, c.price_max
  FROM clinic_medical_services c JOIN medical_services s ON s.id = c.medical_service_id
 WHERE c.clinic_id = @niksic AND s.slug IN ('x-ray-chest-heart', 'heart-teleradiography', 'mri-pelvic-organs')
 ORDER BY s.slug;
