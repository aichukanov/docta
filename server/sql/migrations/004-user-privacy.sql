-- User profile privacy (prd/user-profile, iterations 3-4)
-- Public profile: author name/photo shown next to own reviews.
-- Private profile: reviews are displayed anonymously.
-- Default is PRIVATE for real users (privacy by default, see prd/prompts/06).
-- Phantom users (imported reviews) are public: their names came from public
-- sources (Google Maps etc.) and must stay visible; the flag survives claiming.

ALTER TABLE auth_users
ADD COLUMN is_profile_public BOOLEAN NOT NULL DEFAULT FALSE AFTER is_phantom;

UPDATE auth_users SET is_profile_public = TRUE WHERE is_phantom = TRUE;

-- Rollback:
-- ALTER TABLE auth_users DROP COLUMN is_profile_public;
