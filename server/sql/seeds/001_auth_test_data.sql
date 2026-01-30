-- Seed Data: Test Authentication Data
-- Created: 2026-01-30
-- Description: Creates test users for development and testing
--
-- IMPORTANT: These are TEST CREDENTIALS for local development only!
-- DO NOT use these in production environments.

-- ============================================================================
-- Test Admin User
-- ============================================================================
-- Email: admin@docta.me
-- Password: admin123
-- Bcrypt hash generated with cost=10

INSERT INTO users (email, name, password_hash, is_admin) VALUES
('admin@docta.me', 'Admin User', '$2b$10$rKjHZpVqJYqZ1Y5KQx9D4.OZ7qYJZXqVZkQbXqZkQbXqZkQbXqZkQb', TRUE)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    password_hash = VALUES(password_hash),
    is_admin = VALUES(is_admin);

-- Get the admin user ID for creating a session
SET @admin_user_id = (SELECT id FROM users WHERE email = 'admin@docta.me');

-- ============================================================================
-- Test OAuth User (Regular User)
-- ============================================================================
-- Email: user@example.com
-- Login method: OAuth (Google)
-- No password_hash (NULL) since this is an OAuth user

INSERT INTO users (email, name, photo_url, is_admin) VALUES
('user@example.com', 'Test User', 'https://via.placeholder.com/150', FALSE)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    photo_url = VALUES(photo_url),
    is_admin = VALUES(is_admin);

-- Get the regular user ID
SET @user_id = (SELECT id FROM users WHERE email = 'user@example.com');

-- ============================================================================
-- OAuth Account for Test User
-- ============================================================================
-- Links the test OAuth user to a Google account

INSERT INTO oauth_accounts (user_id, provider, provider_account_id) VALUES
(@user_id, 'google', 'google_test_id_123')
ON DUPLICATE KEY UPDATE
    provider_account_id = VALUES(provider_account_id);

-- ============================================================================
-- Active Sessions for Testing
-- ============================================================================
-- Creates active sessions for both admin and regular user
-- Sessions expire in 30 days from now

-- Admin session
INSERT INTO sessions (id, user_id, expires_at) VALUES
('admin_session_123', @admin_user_id, UNIX_TIMESTAMP(DATE_ADD(NOW(), INTERVAL 30 DAY)))
ON DUPLICATE KEY UPDATE
    expires_at = VALUES(expires_at);

-- Regular user session
INSERT INTO sessions (id, user_id, expires_at) VALUES
('user_session_456', @user_id, UNIX_TIMESTAMP(DATE_ADD(NOW(), INTERVAL 30 DAY)))
ON DUPLICATE KEY UPDATE
    expires_at = VALUES(expires_at);

-- ============================================================================
-- Seed Data Complete
-- ============================================================================
-- Test credentials created:
--
-- ADMIN:
--   Email: admin@docta.me
--   Password: admin123
--   Session ID: admin_session_123
--
-- OAUTH USER:
--   Email: user@example.com
--   Provider: Google
--   Provider ID: google_test_id_123
--   Session ID: user_session_456
--
-- To test admin login:
--   curl -X POST http://localhost:3000/api/admin/auth/login \
--     -H "Content-Type: application/json" \
--     -d '{"email":"admin@docta.me","password":"admin123"}'
--
-- To manually set admin session cookie (for testing):
--   document.cookie = "session_id=admin_session_123; path=/; max-age=2592000"

-- ============================================================================
-- HOW TO GENERATE A NEW PASSWORD HASH
-- ============================================================================
-- Use Node.js with bcrypt:
--
-- const bcrypt = require('bcrypt');
-- bcrypt.hash('your_password', 10).then(console.log);
--
-- Or use this one-liner:
-- node -e "const bcrypt = require('bcrypt'); bcrypt.hash('your_password', 10).then(console.log)"
