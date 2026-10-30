-- Insert Google Maps reviews for Privatna zdravstvenaustanova Malbaski
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/malbaski-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'malbaski-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mira Bubanja', 'https://lh3.googleusercontent.com/a/ACg8ocJB6ZiNoD7F2vAZwnKNlzxOxMGzarKuC5S8lsDR4-JVRn2l6w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115078484529125874689/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115078484529125874689/reviews');
SET @user_mira_bubanja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115078484529125874689/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danka Lubarda', 'https://lh3.googleusercontent.com/a/ACg8ocLHlAgn-QPmWTo3IQ1Nd7y0BsoWKv0LHaZnWs5OgAxIyPedqQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101834666147684461097/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101834666147684461097/reviews');
SET @user_danka_lubarda = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101834666147684461097/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Rnkovic', 'https://lh3.googleusercontent.com/a/ACg8ocK7DeTdAreaECuTTNm1ecs_FElDk-WC7qlz2zmUIro0NL9tyg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118167388009540842638/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118167388009540842638/reviews');
SET @user_dragana_rnkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118167388009540842638/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Blagojevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWb1iALMSja8TazTK1zfQ24N2CjTmjGy0vPuD4nWPfi0_RTwCWXZg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112385269455780105453/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112385269455780105453/reviews');
SET @user_vesna_blagojevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112385269455780105453/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Property in Montenegro', 'https://lh3.googleusercontent.com/a-/ALV-UjUvtDQqbErJozOHYjL7ANP9JDULSgt4buCqn6XlsQ4MJjTU2CEj=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/115931929452529999658/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115931929452529999658/reviews');
SET @user_property_in_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115931929452529999658/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_mira_bubanja, @clinic_id, NULL, 'google_maps',
    'places/ChIJMSy4XGjrTRMROwxAqX1_dhM/reviews/ChZDSUhNMG9nS0VJQ0FnSURibF9qQUdnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-10 08:16:34'),

(@user_danka_lubarda, @clinic_id, NULL, 'google_maps',
    'places/ChIJMSy4XGjrTRMROwxAqX1_dhM/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ4cjlfdlpREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-08-04 10:50:56'),

(@user_dragana_rnkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJMSy4XGjrTRMROwxAqX1_dhM/reviews/ChdDSUhNMG9nS0VJQ0FnSURjcjRtYTF3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-06-20 06:44:40'),

(@user_vesna_blagojevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJMSy4XGjrTRMROwxAqX1_dhM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNjOGNYTXVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-03-14 06:49:53'),

(@user_property_in_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJMSy4XGjrTRMROwxAqX1_dhM/reviews/ChdDSUhNMG9nS0VJQ0FnSURNak9DYXZnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-12-19 02:04:44')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
