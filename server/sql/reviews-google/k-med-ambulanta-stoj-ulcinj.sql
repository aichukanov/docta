-- Insert Google Maps reviews for K med Ambulanta Shtoj
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/k-med-ambulanta-stoj-ulcinj.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'k-med-ambulanta-stoj-ulcinj');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Popović', 'https://lh3.googleusercontent.com/a-/ALV-UjWOXSCorykjgwFNv5xAH_OCSroWp0kBvNFMJFJEfeHzj2AZc8Wu=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/104577291527779011486/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104577291527779011486/reviews');
SET @user_marko_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104577291527779011486/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina K', 'https://lh3.googleusercontent.com/a/ACg8ocKKGdtcLUd1uFaGpr5eCW70Bc-uJjlUZ1uTrtc47JMNRXApvg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110209604021602438859/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110209604021602438859/reviews');
SET @user_kristina_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110209604021602438859/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana R.', 'https://lh3.googleusercontent.com/a-/ALV-UjXTEyCD9M5w6HXIhZjx_ZAri9fAPI0W5MoqZE6DWRx-9WWEUhs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108480786331201967600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108480786331201967600/reviews');
SET @user_ana_r = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108480786331201967600/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_marko_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJqZQJIAkXThMRqZz8bZpOss0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWSU1XSTVVekoyY2w4M2JVSnVNSFpRUmpsUE9FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-08 05:42:45'),

(@user_kristina_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJqZQJIAkXThMRqZz8bZpOss0/reviews/ChZDSUhNMG9nS0VJQ0FnSURiOHFDZ0FnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-03 21:37:55'),

(@user_ana_r, @clinic_id, NULL, 'google_maps',
    'places/ChIJqZQJIAkXThMRqZz8bZpOss0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21FM1dVWmtlVFZLZFhneGFVOVpMVXQxY1hoT01YYxAB',
    1, 'bs', 'Pozvala sam kliniku, ali...Nema vremena, u guzvi je"',
    'Pozvala sam kliniku, ali...Nema vremena, u guzvi je"', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
