-- Insert Google Maps reviews for Ordinacija Dr Janković
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ordinacija-dr-jankovic-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-dr-jankovic-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Montenegro Tour guide', 'https://lh3.googleusercontent.com/a-/ALV-UjVatIiyY8_izGp_hpMTdj7StWQNs5XSIsbw3N2tNyTE4CIQ4yBwbA=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/100983629475728651549/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100983629475728651549/reviews');
SET @user_montenegro_tour_guide = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100983629475728651549/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Janković', 'https://lh3.googleusercontent.com/a/ACg8ocJ2U-z8r5mtraTyf5fhnFeDPgUdx7x5DFnpluKx5mwsa1RakA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112223278239055097411/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112223278239055097411/reviews');
SET @user_marija_jankovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112223278239055097411/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina Jaramaz', 'https://lh3.googleusercontent.com/a-/ALV-UjXmKuBfr_POM8UXF-W9RJc6gzfs25OTfFAO3vCknnsqfJtrLtHQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116682294518280026284/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116682294518280026284/reviews');
SET @user_mina_jaramaz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116682294518280026284/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_montenegro_tour_guide, @clinic_id, NULL, 'google_maps',
    'places/ChIJlytQ7C7rTRMRDPUgGS8McXQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEZ3BxZjl3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-25 22:31:44'),

(@user_marija_jankovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJlytQ7C7rTRMRDPUgGS8McXQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUN5eVpibG1nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-02-04 09:32:53'),

(@user_mina_jaramaz, @clinic_id, NULL, 'google_maps',
    'places/ChIJlytQ7C7rTRMRDPUgGS8McXQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT25saVlXbFlWMHg0WlVKUE5WOW9jbk13ZVZkcU9VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJlytQ7C7rTRMRDPUgGS8McXQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT25saVlXbFlWMHg0WlVKUE5WOW9jbk13ZVZkcU9VRRAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-04-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
