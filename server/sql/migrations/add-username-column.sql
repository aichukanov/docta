-- Добавление колонки username в таблицу users
-- Для хранения Telegram username (@chukanov)

ALTER TABLE users ADD COLUMN username VARCHAR(255) NULL AFTER name;

-- Создаем индекс для быстрого поиска по username
CREATE INDEX idx_users_username ON users(username);
