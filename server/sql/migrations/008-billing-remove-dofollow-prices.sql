-- Биллинг: убираем DOFOLLOW из каталога продажи, новые цены HIGHLIGHT/APPROVED.
--
-- DOFOLLOW (id 1) больше не продаётся: продажа ссылок, передающих PageRank,
-- нарушает Google link spam policy (риск manual action для docta.me).
-- Строка в billing_paid_services остаётся — на неё ссылаются выданные через
-- админку покупки; деактивируем только цены. Каталог
-- (/api/billing/services/catalog) скрывает услуги без активных цен,
-- создание заказа (orders/create) принимает только активные пары
-- (service_id, months) — продажа отключается целиком.
--
-- HIGHLIGHT (id 2): 10 €/мес, скидка за длительность — 9/8/7 €/мес за 3/6/12 мес
-- (та же кривая ×0.9/×0.8/×0.7, что была в сиде 007).
-- APPROVED (id 3): символическая цена, только два периода — 1 €/мес и 10 €/год;
-- периоды 3 и 6 мес деактивируются (каталог и заказы видят только активные).
--
-- Цены обновляются in-place: история фактических цен фиксируется
-- в billing_order_items на момент заказа, отдельные строки не нужны.
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/008-billing-remove-dofollow-prices.sql

UPDATE billing_service_prices SET active = FALSE WHERE service_id = 1;

UPDATE billing_service_prices SET price_cents = 1000 WHERE service_id = 2 AND months = 1;
UPDATE billing_service_prices SET price_cents = 2700 WHERE service_id = 2 AND months = 3;
UPDATE billing_service_prices SET price_cents = 4800 WHERE service_id = 2 AND months = 6;
UPDATE billing_service_prices SET price_cents = 8400 WHERE service_id = 2 AND months = 12;

UPDATE billing_service_prices SET price_cents = 100 WHERE service_id = 3 AND months = 1;
UPDATE billing_service_prices SET active = FALSE WHERE service_id = 3 AND months IN (3, 6);
UPDATE billing_service_prices SET price_cents = 1000 WHERE service_id = 3 AND months = 12;
