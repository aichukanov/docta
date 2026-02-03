-- Migration 005: OAuth Profiles
-- Создание отдельных таблиц для хранения специфичных данных каждого OAuth провайдера
-- Решает проблему конфликтов и потери данных при множественных OAuth

-- ============================================================================
-- Таблица: oauth_profiles_google
-- ============================================================================
-- Хранит специфичные данные от Google OAuth

CREATE TABLE IF NOT EXISTS oauth_profiles_google (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oauth_account_id INT NOT NULL COMMENT 'Связь с oauth_accounts',
    
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
    
    FOREIGN KEY (oauth_account_id) REFERENCES oauth_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Google OAuth профили';

-- ============================================================================
-- Таблица: oauth_profiles_telegram
-- ============================================================================
-- Хранит специфичные данные от Telegram OAuth

CREATE TABLE IF NOT EXISTS oauth_profiles_telegram (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oauth_account_id INT NOT NULL COMMENT 'Связь с oauth_accounts',
    
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
    
    FOREIGN KEY (oauth_account_id) REFERENCES oauth_accounts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Telegram OAuth профили';

-- ============================================================================
-- Таблица users: добавляем поле для приоритетного провайдера
-- ============================================================================

-- Добавляем поле для выбора основного провайдера
ALTER TABLE users ADD COLUMN primary_oauth_provider VARCHAR(50) DEFAULT NULL 
    COMMENT 'Основной OAuth провайдер для отображения данных (google, telegram, NULL для email)';

-- Индекс для быстрого поиска
ALTER TABLE users ADD INDEX idx_primary_provider (primary_oauth_provider);
