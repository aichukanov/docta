-- Insert Google Maps reviews for Медицинский Центр доктора ЗОБИНА
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/medicinski-centar-dr-zobin-kotor.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'medicinski-centar-dr-zobin-kotor');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darja Perisic', 'https://lh3.googleusercontent.com/a-/ALV-UjWIlxmBpBHvWTC27klXEfc_nrvK19ZQB0vDWPfKbHy039oStZCfYQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102427799749981641461/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102427799749981641461/reviews');
SET @user_darja_perisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102427799749981641461/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Gugolj', 'https://lh3.googleusercontent.com/a-/ALV-UjWn2SFRb1wAPxCHVfV_R5do3l4xy1FmBlNXOSruJcXIWJdArgX4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108140632064490204906/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108140632064490204906/reviews');
SET @user_dragana_gugolj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108140632064490204906/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_darja_perisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJF5cdFWYzTBMReM2jCGw4OrM/reviews/ChZDSUhNMG9nS0VJQ0FnSURwanJDOUdnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-08-21 22:40:54'),

(@user_dragana_gugolj, @clinic_id, NULL, 'google_maps',
    'places/ChIJF5cdFWYzTBMReM2jCGw4OrM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsbmQyVnlSWE5CU0ZOMU5IRkpkRXBhY3pOckxWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
