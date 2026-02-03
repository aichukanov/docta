-- Migration: Password Reset Tokens
-- Создание таблицы для токенов восстановления пароля

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID токен для сброса пароля',
    expires_at BIGINT NOT NULL COMMENT 'Время истечения токена (UNIX timestamp)',
    used BOOLEAN DEFAULT FALSE COMMENT 'Использован ли токен',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_token (token),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Токены для восстановления пароля';
