-- Insert Google Maps reviews for Ordinacija Obradović Medical
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ordinacija-obradovic-medical-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-obradovic-medical-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_mladjen_obradovic = (SELECT id FROM doctors WHERE slug = 'mladjen-obradovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasia Voloboeva', 'https://lh3.googleusercontent.com/a/ACg8ocLuqVO_EpP4avz9gCCkxOvWcg-yrPbD3Sb0YueeTRnES3TkWw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104000736386555299303/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104000736386555299303/reviews');
SET @user_anastasia_voloboeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104000736386555299303/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Zindovic', 'https://lh3.googleusercontent.com/a/ACg8ocLP6XKkYSzTNooioaucuMnMPKLuQCd_BrBZNrfQxz_P44sw9A=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101162175475133154819/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101162175475133154819/reviews');
SET @user_kristina_zindovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101162175475133154819/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Larisa Šipčić', 'https://lh3.googleusercontent.com/a-/ALV-UjUoXg1AolBEhWX5LEt8LIOm5lB2N6LUCKSSHWIjx8FTeJanwt71Lw=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/108743537100747824120/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108743537100747824120/reviews');
SET @user_larisa_ipi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108743537100747824120/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana S', 'https://lh3.googleusercontent.com/a/ACg8ocJJ9IereQTqNuqXODzYE_1XM_dE-9uVvuoH_BtB8SGnQEOLIA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112453430663640198236/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112453430663640198236/reviews');
SET @user_ivana_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112453430663640198236/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nikola marovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUVOdOOKVMyzyY1Myqskd02XBdJXw-ZbsybxuYJo9X-9nq8p1ef=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106932325627030350264/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106932325627030350264/reviews');
SET @user_nikola_marovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106932325627030350264/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Savo Pavicevic', 'https://lh3.googleusercontent.com/a/ACg8ocIznwUQ43Jqowi2vocutCbCyRb3mov2bh0ViTsNUbR8y6Dsxw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117509614995856981144/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117509614995856981144/reviews');
SET @user_savo_pavicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117509614995856981144/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Durovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUIx11jYOM_G99DMaDKoPot8rlTvHtWuyLb8moMiW13SlA_VfoJ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104565314601290998002/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104565314601290998002/reviews');
SET @user_nina_durovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104565314601290998002/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_anastasia_voloboeva, @clinic_id, @doctor_mladjen_obradovic, 'google_maps',
    'places/ChIJ2ZTShGXrTRMRLnoTvuA3lrg/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwbnFyMFBnEAE',
    5, 'en', 'Dr. Obradovic is very attentive and kind.',
    'Dr Obradović je veoma pažljiv i ljubazan.', 'Др Обрадовић је веома пажљив и љубазан.', 'Dr. Obradovic is very attentive and kind.', NULL, NULL, NULL,
    0, '2023-08-04 09:50:17'),

(@user_kristina_zindovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2ZTShGXrTRMRLnoTvuA3lrg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xob2RsTk9WMkZXVUdGSlRHNVdlbmRSWjFCTGNVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-15 12:12:55'),

(@user_larisa_ipi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2ZTShGXrTRMRLnoTvuA3lrg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0TWJEbFVZVWN5V1dJMlJFUmxaR3BKY1d0ZlVHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-04 14:30:04'),

(@user_ivana_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2ZTShGXrTRMRLnoTvuA3lrg/reviews/ChZDSUhNMG9nS0VJQ0FnSUNfcHBmdkp3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-01-15 19:00:59'),

(@user_nikola_marovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2ZTShGXrTRMRLnoTvuA3lrg/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsNmF2MG5nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-11-21 19:51:02'),

(@user_savo_pavicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2ZTShGXrTRMRLnoTvuA3lrg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poa1JYaFJXa054UWtrNE9VdG5URXB1YUVWakxVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_nina_durovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ2ZTShGXrTRMRLnoTvuA3lrg/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4bWN2Z3NnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
