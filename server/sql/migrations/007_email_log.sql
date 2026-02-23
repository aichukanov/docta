-- ============================================================================
-- MIGRATION 007: Лог отправленных писем
-- Дата: 2026-02-23
-- ============================================================================
--
-- Использование:
--   mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/007_email_log.sql
--

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS auth_email_log (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    to_email    VARCHAR(255)    NOT NULL COMMENT 'Адрес получателя',
    subject     VARCHAR(500)    NOT NULL COMMENT 'Тема письма',
    html        MEDIUMTEXT      NOT NULL COMMENT 'HTML-тело письма',
    text_body   TEXT            NULL     COMMENT 'Текстовая версия письма',
    status      ENUM('sent', 'failed', 'dev') NOT NULL DEFAULT 'sent' COMMENT 'Статус отправки',
    error       TEXT            NULL     COMMENT 'Сообщение об ошибке при status=failed',
    created_at  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_to_email  (to_email),
    INDEX idx_status    (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Лог всех отправленных email-сообщений';
