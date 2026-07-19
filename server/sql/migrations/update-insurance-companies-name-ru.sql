-- Убирает шум "Страховая компания" в начале русских названий (одинаково для
-- всех 5 карточек на странице списка) и приводит кавычки к единому виду —
-- переносит описание в конец через тире: "{Бренд} — страховая компания".
--
-- Apply:
--   mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/update-insurance-companies-name-ru.sql

SET NAMES utf8mb4;

UPDATE insurance_companies SET name_ru = 'Сава — страховая компания' WHERE slug = 'sava';
UPDATE insurance_companies SET name_ru = 'Ловчен — страховая компания' WHERE slug = 'lovcen';
UPDATE insurance_companies SET name_ru = 'Uniqa — страховая компания' WHERE slug = 'uniqa';
UPDATE insurance_companies SET name_ru = 'Generali — страховая компания' WHERE slug = 'generali';
UPDATE insurance_companies SET name_ru = 'Grawe — страховая компания' WHERE slug = 'grawe';
