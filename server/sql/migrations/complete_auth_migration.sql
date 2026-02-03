-- ============================================================================
-- ПОЛНАЯ МИГРАЦИЯ СИСТЕМЫ АВТОРИЗАЦИИ
-- Дата: 2026-01-30
-- База данных: docta_me
-- ============================================================================
-- 
-- Все таблицы авторизации имеют префикс auth_
-- 
-- Таблицы:
--   - auth_users
--   - auth_oauth_accounts
--   - auth_oauth_profiles_google
--   - auth_oauth_profiles_telegram
--   - auth_sessions
--   - auth_password_reset_tokens
--   - auth_email_verification_tokens
--   - auth_login_history
--
-- Использование:
--   mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/complete_auth_migration.sql
--
-- ============================================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ============================================================================
-- MIGRATION 001: Базовые таблицы авторизации
-- ============================================================================

-- Таблица: auth_users
CREATE TABLE IF NOT EXISTS auth_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    `name` VARCHAR(255),
    username VARCHAR(255),
    photo_url VARCHAR(500),
    password_hash VARCHAR(255) NULL COMMENT 'Bcrypt hash for admin users. NULL for OAuth users.',
    is_admin BOOLEAN DEFAULT FALSE COMMENT 'True for administrators, false for regular users',
    email_verified BOOLEAN DEFAULT FALSE COMMENT 'Подтвержден ли email',
    primary_oauth_provider VARCHAR(50) DEFAULT NULL COMMENT 'Основной OAuth провайдер для отображения данных (google, telegram, NULL для email)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_is_admin (is_admin),
    INDEX idx_username (username),
    INDEX idx_email_verified (email_verified),
    INDEX idx_primary_provider (primary_oauth_provider)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User accounts - both admins (email/password) and regular users (OAuth)';

-- Таблица: auth_oauth_accounts
CREATE TABLE IF NOT EXISTS auth_oauth_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    `provider` VARCHAR(50) NOT NULL COMMENT 'OAuth provider: google, telegram',
    provider_account_id VARCHAR(255) NOT NULL COMMENT 'User ID from OAuth provider',
    access_token TEXT COMMENT 'OAuth access token (optional, may be stored encrypted)',
    refresh_token TEXT COMMENT 'OAuth refresh token (optional)',
    expires_at BIGINT COMMENT 'Token expiration timestamp (UNIX)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_provider_account (`provider`, provider_account_id),
    INDEX idx_user_id (user_id),
    INDEX idx_provider (`provider`, provider_account_id),
    
    FOREIGN KEY (user_id) REFERENCES auth_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='OAuth provider accounts linked to users';

-- Таблица: auth_sessions
CREATE TABLE IF NOT EXISTS auth_sessions (
    id VARCHAR(255) PRIMARY KEY COMMENT 'Session ID (UUID)',
    user_id INT NOT NULL,
    expires_at BIGINT NOT NULL COMMENT 'Session expiration timestamp (UNIX)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    
    FOREIGN KEY (user_id) REFERENCES auth_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User sessions with expiration tracking';

-- ============================================================================
-- MIGRATION 002: Восстановление пароля
-- ============================================================================

CREATE TABLE IF NOT EXISTS auth_password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID токен для сброса пароля',
    expires_at BIGINT NOT NULL COMMENT 'Время истечения токена (UNIX timestamp)',
    used BOOLEAN DEFAULT FALSE COMMENT 'Использован ли токен',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_token (token),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    
    FOREIGN KEY (user_id) REFERENCES auth_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Токены для восстановления пароля';

-- ============================================================================
-- MIGRATION 003: Подтверждение email
-- ============================================================================

CREATE TABLE IF NOT EXISTS auth_email_verification_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID токен для подтверждения email',
    email VARCHAR(255) NOT NULL COMMENT 'Email который нужно подтвердить',
    expires_at BIGINT NOT NULL COMMENT 'Время истечения токена (UNIX timestamp)',
    verified BOOLEAN DEFAULT FALSE COMMENT 'Подтвержден ли email',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_token (token),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    
    FOREIGN KEY (user_id) REFERENCES auth_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Токены для подтверждения email';

-- ============================================================================
-- MIGRATION 004: История входов
-- ============================================================================

CREATE TABLE IF NOT EXISTS auth_login_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ip_address VARCHAR(45) COMMENT 'IP адрес (IPv4 или IPv6)',
    user_agent TEXT COMMENT 'User Agent строка',
    location VARCHAR(255) COMMENT 'Геолокация (город, страна)',
    login_method VARCHAR(50) COMMENT 'Метод входа: email, google, telegram',
    success BOOLEAN DEFAULT TRUE COMMENT 'Успешный ли вход',
    failure_reason VARCHAR(255) COMMENT 'Причина неудачи (если success=false)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at),
    INDEX idx_success (success),
    INDEX idx_user_recent (user_id, created_at DESC),
    
    FOREIGN KEY (user_id) REFERENCES auth_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='История входов пользователей';

-- ============================================================================
-- MIGRATION 005: OAuth профили (отдельные таблицы)
-- ============================================================================

-- Таблица для Google OAuth профилей
CREATE TABLE IF NOT EXISTS auth_oauth_profiles_google (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oauth_account_id INT NOT NULL COMMENT 'Связь с auth_oauth_accounts',
    
    -- Данные от Google
    google_id VARCHAR(255) NOT NULL COMMENT 'Google User ID',
    email VARCHAR(255) NOT NULL COMMENT 'Email от Google',
    verified_email TINYINT(1) DEFAULT 0 COMMENT 'Email подтвержден Google',
    `name` VARCHAR(255) COMMENT 'Полное имя',
    given_name VARCHAR(255) COMMENT 'Имя',
    family_name VARCHAR(255) COMMENT 'Фамилия',
    picture TEXT COMMENT 'URL аватара',
    locale VARCHAR(10) COMMENT 'Локаль (ru, en и т.д.)',
    
    -- Сырые данные для расширяемости
    raw_data JSON COMMENT 'Полный ответ от Google в JSON',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_oauth_account (oauth_account_id),
    INDEX idx_google_id (google_id),
    INDEX idx_email (email),
    
    FOREIGN KEY (oauth_account_id) REFERENCES auth_oauth_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Google OAuth профили';

-- Таблица для Telegram OAuth профилей
CREATE TABLE IF NOT EXISTS auth_oauth_profiles_telegram (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oauth_account_id INT NOT NULL COMMENT 'Связь с auth_oauth_accounts',
    
    -- Данные от Telegram
    telegram_id BIGINT NOT NULL COMMENT 'Telegram User ID',
    first_name VARCHAR(255) NOT NULL COMMENT 'Имя',
    last_name VARCHAR(255) COMMENT 'Фамилия',
    username VARCHAR(255) COMMENT 'Username без @',
    photo_url TEXT COMMENT 'URL аватара',
    auth_date BIGINT COMMENT 'Дата авторизации (UNIX timestamp)',
    
    -- Сырые данные для расширяемости
    raw_data JSON COMMENT 'Полный ответ от Telegram в JSON',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_oauth_account (oauth_account_id),
    INDEX idx_telegram_id (telegram_id),
    INDEX idx_username (username),
    
    FOREIGN KEY (oauth_account_id) REFERENCES auth_oauth_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Telegram OAuth профили';

-- ============================================================================
-- МИГРАЦИЯ ЗАВЕРШЕНА
-- ============================================================================

SELECT 'Migration completed successfully!' as status;
SELECT CONCAT('Tables created: ', COUNT(*)) as tables_count 
FROM information_schema.tables 
WHERE table_schema = 'docta_me' AND table_name LIKE 'auth_%';
