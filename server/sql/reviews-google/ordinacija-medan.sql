-- Insert Google Maps reviews for Ginekološko Ordinacija Ranko Medan
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ordinacija-medan.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-medan');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_ranko_medan = (SELECT id FROM doctors WHERE slug = 'ranko-medan');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Şevval Anbarlı', 'https://lh3.googleusercontent.com/a/ACg8ocKl8hQPqLbkzs-dFxGY4gOd7qMoTJS5FezPJQiQ0MSqLUOPDw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112404189028584628493/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112404189028584628493/reviews');
SET @user_evval_anbarl = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112404189028584628493/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikoleta Perosevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUOfLstJoflbSvfn-7bVl9OdcELuxcrblr8ryk70s42-hvp63GP=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109993084154229040143/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109993084154229040143/reviews');
SET @user_nikoleta_perosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109993084154229040143/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Verica Lekovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUOYFVQ8O2d7Xk7YFJ3FOiHstHIL9oLSkOmybv9Nn1eKqY7Rw_i=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107698541097616428375/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107698541097616428375/reviews');
SET @user_verica_lekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107698541097616428375/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Verica Lekovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWRR9By_q4KIScyFtIRS2VDX0-zcrkOSsEFkq7EBtp1E5q9ay-C5w=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/109459787291102150820/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109459787291102150820/reviews');
SET @user_verica_lekovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109459787291102150820/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pg Fantom', 'https://lh3.googleusercontent.com/a-/ALV-UjWmfpPF0GRp_PiFy51belD_b8_-JtHgw9d4admAqLnd1Sa2rRZV=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105891319052796194918/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105891319052796194918/reviews');
SET @user_pg_fantom = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105891319052796194918/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Iv', 'https://lh3.googleusercontent.com/a-/ALV-UjUD9wEXWyAzTJsjXodoMBRGqT-g5M17upCaGxqe5D1QjDC-0Gvt=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115384152764946736754/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115384152764946736754/reviews');
SET @user_jelena_iv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115384152764946736754/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_evval_anbarl, @clinic_id, @doctor_ranko_medan, 'google_maps',
    'places/ChIJ0-168kbrTRMRqN1N4-W4bak/reviews/ChdDSUhNMG9nS0VJQ0FnSUN6cUwtQzl3RRAB',
    5, 'hr', 'dragi doktor Medan i njegov dragi asistent su obrazovani, iskusni, ljubazni ljudi.  hvala vam puno.',
    'Poštovani dr Medan i njegov dragi asistent su obrazovani, iskusni, ljubazni ljudi. Hvala vam puno.', 'Поштовани др Медан и његов драги асистент су образовани, искусни, љубазни људи. Хвала вам пуно.', NULL, NULL, NULL, NULL,
    0, '2024-05-30 11:06:24'),

(@user_nikoleta_perosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0-168kbrTRMRqN1N4-W4bak/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taelRHdFBOVkpqZUZSaWR6UnBjRkZpUmpab1psRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-17 17:21:43'),

(@user_verica_lekovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0-168kbrTRMRqN1N4-W4bak/reviews/Ci9DQUlRQUNvZENodHljRjlvT25vM1VEY3RMVVZGVEZSdFJXRjBTbE5XYVVSUVRIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-03 15:47:34'),

(@user_verica_lekovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0-168kbrTRMRqN1N4-W4bak/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkRmQwdGlWWFp5ZUhaUlprMDVTWFpEUW5CSVZrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-30 22:13:27'),

(@user_pg_fantom, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0-168kbrTRMRqN1N4-W4bak/reviews/ChZDSUhNMG9nS0VJQ0FnSUN1dlpLcWRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-08-04 10:11:45'),

(@user_jelena_iv, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0-168kbrTRMRqN1N4-W4bak/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SSGVrUkNSME53TFROdVdrSmxSbEp3VGpOWmIxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
