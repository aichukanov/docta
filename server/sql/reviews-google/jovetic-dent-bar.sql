-- Insert Google Maps reviews for Jovetić dent
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/jovetic-dent-bar.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'jovetic-dent-bar');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bato Jakic', 'https://lh3.googleusercontent.com/a-/ALV-UjUpnbrdo998SN-j1mMdzW2n70whM9m3hI7InZu_7GlZNzc8edcl=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/104901749091538508922/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104901749091538508922/reviews');
SET @user_bato_jakic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104901749091538508922/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milenko Drljevic', 'https://lh3.googleusercontent.com/a/ACg8ocJC2EqEaN3wbBJ5d1LmjQWqNYJDvpOXEDB4mWo-8-4-GIZB9A=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107061692607615421708/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107061692607615421708/reviews');
SET @user_milenko_drljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107061692607615421708/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_bato_jakic, @clinic_id, NULL, 'google_maps',
    'places/ChIJE_UW1QF1ThMRAHhN76mLBr8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKMV9pdktREAE',
    5, 'hr', 'Vrhunski profesionalci i dobri ljudi. Za svaku preporuku...',
    'Vrhunski profesionalci i dobri ljudi. Za svaku preporuku...', 'Врхунски професионалци и добри људи. За сваку препоруку...', NULL, NULL, NULL, NULL,
    0, '2023-07-06 19:50:54'),

(@user_milenko_drljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJE_UW1QF1ThMRAHhN76mLBr8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGT2FTMUJaelJyVEU1bFlqZGtTRVJmZUZWemFuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-08 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
