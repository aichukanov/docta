-- ============================================================================
-- Migration: Add preferred_locale to auth_users
-- ============================================================================
-- Добавляет поле для сохранения предпочитаемого языка пользователя

-- Добавляем колонку preferred_locale
ALTER TABLE auth_users 
ADD COLUMN preferred_locale VARCHAR(10) DEFAULT NULL 
COMMENT 'Preferred language: sr, sr-cyrl, en, ru, de, tr' 
AFTER primary_oauth_provider;

-- Добавляем индекс для быстрого поиска
ALTER TABLE auth_users 
ADD INDEX idx_preferred_locale (preferred_locale);

-- ============================================================================
-- Описание полей:
-- ============================================================================
-- preferred_locale: Предпочитаемый язык пользователя (NULL = автоопределение)
--   Допустимые значения: 'sr', 'sr-cyrl', 'en', 'ru', 'de', 'tr'
--   NULL означает, что используется автоопределение через Accept-Language или Google OAuth
-- ============================================================================
