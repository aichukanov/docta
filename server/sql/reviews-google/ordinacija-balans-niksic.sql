-- Insert Google Maps reviews for Privtna Zdravstvena Ustanova BALANS
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ordinacija-balans-niksic.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-balans-niksic');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dušan Radojicic', 'https://lh3.googleusercontent.com/a/ACg8ocJW1mB5O-YQiE-BADZPiWt3ZJCYQ6J-QYfLTnzEO0MJ2ppj3Q=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/116621244473122180287/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116621244473122180287/reviews');
SET @user_duan_radojicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116621244473122180287/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'lila beatovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXUIDAJA9bvsR8x3ghcheAYBVbmjFIeAzNvHF6Q4UfvfoKwG4o=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106527642676428363210/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106527642676428363210/reviews');
SET @user_lila_beatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106527642676428363210/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_duan_radojicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA7RZIkupTRMRwa2rXB1YXuk/reviews/ChdDSUhNMG9nS0VJQ0FnSUNaMUtleXRBRRAB',
    5, 'sr', 'Много љубазни, приступачни, све похвале.',
    'Mnogo ljubazni, pristupačni, sve pohvale.', 'Много љубазни, приступачни, све похвале.', NULL, NULL, NULL, NULL,
    0, '2023-09-05 06:03:22'),

(@user_lila_beatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA7RZIkupTRMRwa2rXB1YXuk/reviews/ChZDSUhNMG9nS0VJQ0FnSURIMzRDX1FREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-09-21 08:36:10')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
