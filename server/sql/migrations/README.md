# Authentication Migration Guide

## Overview

This guide explains how to apply the authentication database migrations for the docta.me project.

## Migration Files

- **`001_auth_basic.sql`** - Creates tables: `users`, `oauth_accounts`, `sessions`
- **`001_auth_basic_rollback.sql`** - Rollback script (drops all auth tables)
- **`seeds/001_auth_test_data.sql`** - Test data for local development

## Prerequisites

- MySQL 5.7+ or MariaDB 10.2+
- Access to the database with CREATE TABLE privileges
- bcrypt library for generating password hashes (Node.js: `npm install bcrypt`)

## Step 1: Apply Migration

### Option A: MySQL CLI

```bash
# Connect to your database
mysql -u your_user -p your_database

# Run the migration
source server/sql/migrations/001_auth_basic.sql;

# Verify tables were created
SHOW TABLES LIKE '%users%';
SHOW TABLES LIKE '%oauth_accounts%';
SHOW TABLES LIKE '%sessions%';
```

### Option B: MySQL Client (e.g., DBeaver, phpMyAdmin)

1. Open `server/sql/migrations/001_auth_basic.sql`
2. Copy the entire content
3. Paste and execute in your MySQL client

### Option C: Command Line (one-liner)

```bash
mysql -u your_user -p your_database < server/sql/migrations/001_auth_basic.sql
```

## Step 2: Load Test Data (Development Only)

**⚠️ WARNING: Only for local development! Do not run in production.**

```bash
mysql -u your_user -p your_database < server/sql/seeds/001_auth_test_data.sql
```

This creates:
- Admin user: `admin@docta.me` / `admin123`
- Regular user: `user@example.com` (OAuth)
- Active sessions for both users

## Step 3: Verify Installation

Run these queries to verify the migration:

```sql
-- Check users table structure
DESCRIBE users;

-- Check if test admin exists
SELECT id, email, name, is_admin, created_at 
FROM users 
WHERE is_admin = TRUE;

-- Check oauth_accounts table
DESCRIBE oauth_accounts;

-- Check sessions table
DESCRIBE sessions;

-- Count records (should be 2 users if you loaded test data)
SELECT COUNT(*) as user_count FROM users;
```

Expected output:
- `users` table should have columns: `id`, `email`, `name`, `photo_url`, `password_hash`, `is_admin`, `created_at`, `updated_at`
- Admin user `admin@docta.me` should exist
- Test data should show 2 users, 1 oauth account, 2 sessions

## Step 4: Create Your First Real Admin

**Important:** Test credentials should only be used in development.

### Generate Password Hash

```bash
# Install bcrypt if not already installed
npm install bcrypt

# Generate hash for your password
node -e "const bcrypt = require('bcrypt'); bcrypt.hash('YourSecurePassword123!', 10).then(console.log)"
```

### Insert Admin User

```sql
-- Replace YOUR_EMAIL, YOUR_NAME, and PASSWORD_HASH
INSERT INTO users (email, name, password_hash, is_admin) VALUES
('your.email@example.com', 'Your Name', 'PASSWORD_HASH_HERE', TRUE);
```

Example:
```sql
INSERT INTO users (email, name, password_hash, is_admin) VALUES
('john.admin@docta.me', 'John Admin', '$2b$10$abcdefg...', TRUE);
```

## Rollback

If you need to rollback the migration:

```bash
# ⚠️ WARNING: This will delete all users, sessions, and OAuth accounts!
mysql -u your_user -p your_database < server/sql/migrations/001_auth_basic_rollback.sql
```

## Troubleshooting

### Error: Table already exists

If you see "Table 'users' already exists":
1. The migration uses `CREATE TABLE IF NOT EXISTS`, so this shouldn't happen
2. If it does, check if you have a conflicting `users` table
3. Either rename the old table or drop it (if safe)

### Error: Cannot add foreign key constraint

If foreign key creation fails:
1. Check that the parent table (`users`) was created successfully
2. Verify InnoDB engine is used: `SHOW CREATE TABLE users;`
3. Check MySQL/MariaDB version supports foreign keys

### Password hash not working

If password authentication fails:
1. Verify bcrypt cost factor is 10: `bcrypt.hash(password, 10)`
2. Check hash length is exactly 60 characters
3. Ensure hash starts with `$2b$10$` or `$2a$10$`

## Next Steps

After completing this migration:

1. ✅ **Iteration 1 Complete:** Database tables created
2. ⏭️ **Next:** Iteration 2 - Implement admin authentication
   - Create `/admin/login` page
   - Create API endpoints: `/api/admin/auth/login`, `/api/admin/auth/logout`
   - Create middleware for session validation
   - See: `prd/auth/iterations/iteration-02-admin-auth.md`

## Security Notes

1. **Never commit real passwords or hashes to git**
2. **Use strong passwords** for admin accounts (min 12 characters)
3. **Test credentials** (`admin@docta.me` / `admin123`) should be deleted in production
4. **Session IDs** should be random UUIDs (use `crypto.randomUUID()`)
5. **Bcrypt cost factor** should be at least 10 (higher = more secure but slower)

## References

- Migration file: `server/sql/migrations/001_auth_basic.sql`
- Seed data: `server/sql/seeds/001_auth_test_data.sql`
- PRD: `prd/auth/index.md`
- Iteration details: `prd/auth/iterations/iteration-01-database.md`
