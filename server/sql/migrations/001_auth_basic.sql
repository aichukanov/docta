-- Migration 001: Basic Authentication Tables
-- Created: 2026-01-30
-- Description: Creates users, oauth_accounts, and sessions tables for authentication system
--
-- Features:
-- - Email/password authentication for admins
-- - OAuth authentication for regular users (Google, Telegram)
-- - Session management

-- ============================================================================
-- Table: users
-- ============================================================================
-- Stores both admin users (with password_hash) and OAuth users (without password_hash)

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    photo_url VARCHAR(500),
    password_hash VARCHAR(255) NULL COMMENT 'Bcrypt hash for admin users. NULL for OAuth users.',
    is_admin BOOLEAN DEFAULT FALSE COMMENT 'True for administrators, false for regular users',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_is_admin (is_admin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User accounts - both admins (email/password) and regular users (OAuth)';

-- ============================================================================
-- Table: oauth_accounts
-- ============================================================================
-- Links users to OAuth providers (Google, Telegram)
-- Supports multiple OAuth providers per user (e.g., one user can login via both Google and Telegram)

CREATE TABLE IF NOT EXISTS oauth_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(50) NOT NULL COMMENT 'OAuth provider: google, telegram',
    provider_account_id VARCHAR(255) NOT NULL COMMENT 'User ID from OAuth provider',
    access_token TEXT COMMENT 'OAuth access token (optional, may be stored encrypted)',
    refresh_token TEXT COMMENT 'OAuth refresh token (optional)',
    expires_at BIGINT COMMENT 'Token expiration timestamp (UNIX)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_provider_account (provider, provider_account_id),
    INDEX idx_user_id (user_id),
    INDEX idx_provider (provider, provider_account_id),
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='OAuth provider accounts linked to users';

-- ============================================================================
-- Table: sessions
-- ============================================================================
-- Database-based session storage for both admins and regular users
-- HTTPOnly cookies store session_id, actual session data is in DB

CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(255) PRIMARY KEY COMMENT 'Session ID (UUID)',
    user_id INT NOT NULL,
    expires_at BIGINT NOT NULL COMMENT 'Session expiration timestamp (UNIX)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='User sessions with expiration tracking';

-- ============================================================================
-- Migration Complete
-- ============================================================================
-- Next steps:
-- 1. Run this migration on your database
-- 2. Create test admin user (see seeds/001_auth_test_data.sql)
-- 3. Implement authentication endpoints (Iteration 2)
