SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Решения юзера 2026-10-06 по карте прайсов (data/clinic-pricelists/):
--   1. Konzilijum — так же, как A3: цены с сайта сняты (страницы /cjenovnik-* после
--      переделки 2024-06 содержат только описания; таблицы с ценами — в Wayback 2022),
--      услуги клиника по-прежнему перечисляет → все строки с ценой is_price_outdated = 1.
--      Подтверждённых сайтом цен нет ни одной, исключений нет. Локально 215 услуг; анализов нет.
--   2. SmartMed Kotor — website очищается: страница филиала на poliklinikasmartmed.me
--      «Page Not Found», филиала нет в sitemap. Пустой сайт в clinics — '' (не NULL).
-- Клиники только по slug. Повторный прогон ничего не меняет.

-- ═══ 1. Konzilijum ═══

SET @konz = (SELECT id FROM clinics WHERE slug = 'konzilijum-poliklinika-i-bolnica-podgorica');

UPDATE clinic_medical_services SET is_price_outdated = 1
WHERE clinic_id = @konz AND is_price_outdated = 0
	AND (price IS NOT NULL OR price_min IS NOT NULL OR price_max IS NOT NULL);

UPDATE clinic_lab_tests SET is_price_outdated = 1
WHERE clinic_id = @konz AND is_price_outdated = 0
	AND (price IS NOT NULL OR price_max IS NOT NULL);

-- ═══ 2. SmartMed Kotor ═══

UPDATE clinics SET website = ''
WHERE slug = 'smartmed-kotor'
	AND website = 'https://www.poliklinikasmartmed.me/usluge/poliklinika-smart-med-kotor';

-- ═══ VERIFICATION ═══

SELECT 'konzilijum services' AS what, COUNT(*) AS total,
	SUM(price IS NOT NULL OR price_min IS NOT NULL OR price_max IS NOT NULL) AS priced,
	SUM(is_price_outdated = 1) AS outdated, SUM(is_obsolete = 1) AS obsolete
FROM clinic_medical_services WHERE clinic_id = @konz;
-- ожидание (локально): 238 / 215 / 215 / 0

SELECT slug, website FROM clinics WHERE slug = 'smartmed-kotor';
-- ожидание: website = ''
