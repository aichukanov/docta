-- Rollback Migration 001: Basic Authentication Tables
-- Created: 2026-01-30
-- Description: Drops authentication tables created in 001_auth_basic.sql
--
-- WARNING: This will delete all user accounts, OAuth connections, and active sessions!
-- Use with caution in production environments.

-- ============================================================================
-- Drop tables in reverse order (respecting foreign key constraints)
-- ============================================================================

-- Drop sessions table first (has FK to users)
DROP TABLE IF EXISTS sessions;

-- Drop oauth_accounts table (has FK to users)
DROP TABLE IF EXISTS oauth_accounts;

-- Drop users table last
DROP TABLE IF EXISTS users;

-- ============================================================================
-- Rollback Complete
-- ============================================================================
-- All authentication tables have been removed.
