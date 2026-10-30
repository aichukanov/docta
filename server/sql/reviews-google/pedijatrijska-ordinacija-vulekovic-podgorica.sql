-- Insert Google Maps reviews for Privatna ordinacija "Vuleković"
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/pedijatrijska-ordinacija-vulekovic-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'pedijatrijska-ordinacija-vulekovic-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zivojin Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocICnfWQy0C_KZdMuJCwzUs8xmCCnpqvzqRfwN5RjjgWn572Aw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112421043713211566105/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112421043713211566105/reviews');
SET @user_zivojin_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112421043713211566105/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rania Yehia', 'https://lh3.googleusercontent.com/a/ACg8ocLQ8k0MgcoASW_Z3MIV7695yfDAGDqrU422CXw8puoZc12k7w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115244187369070351432/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115244187369070351432/reviews');
SET @user_rania_yehia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115244187369070351432/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nađa', 'https://lh3.googleusercontent.com/a-/ALV-UjW-7D-IzovrlyYPWQJZ3p-pzkY_UAvTR1lCYdvQD25vngrlTI8=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109442628356955051655/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109442628356955051655/reviews');
SET @user_naa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109442628356955051655/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'coze zeco', 'https://lh3.googleusercontent.com/a-/ALV-UjUaw6BPIu5hidyBbb9p-a-3uVNTjkr_3xTWy2yidbXOop_c4n0=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108736899531047330825/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108736899531047330825/reviews');
SET @user_coze_zeco = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108736899531047330825/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milija Jevric', 'https://lh3.googleusercontent.com/a/ACg8ocIn7kqjN5Q4qUs8K5o3ZJWjpk7Z0_b97moHk9s6q4HO0QEnXA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100037648540157718780/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100037648540157718780/reviews');
SET @user_milija_jevric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100037648540157718780/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Perisa Markovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU9LoF7uKhp4ZrYrDjEVTpLeK9LEhNpbp3Acour6Jp1s6N7RDWz=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100706534407362772406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100706534407362772406/reviews');
SET @user_perisa_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100706534407362772406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Radonjić', 'https://lh3.googleusercontent.com/a/ACg8ocLwW8IC2Cssar5wM3lAAeG94atma-ONtYQSC_GIV1_iU6Egq_Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118153131895955551049/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118153131895955551049/reviews');
SET @user_bojana_radonji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118153131895955551049/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nenad Pejović', 'https://lh3.googleusercontent.com/a-/ALV-UjUBkW1pY6GSdXOcBtTW7nar7BFQC2XRulGNf7EJ0hQr_2EPA-Q9=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103583282429688551217/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103583282429688551217/reviews');
SET @user_nenad_pejovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103583282429688551217/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Mijuskovic', 'https://lh3.googleusercontent.com/a/ACg8ocIQiRH_O6XYW7YqZUCZ190EQhXotuLGN-Fa_WOamGgQW27aGDdH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107577071415319726838/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107577071415319726838/reviews');
SET @user_natasa_mijuskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107577071415319726838/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Radonjić', 'https://lh3.googleusercontent.com/a-/ALV-UjXfG1MijnjXx5VlJTzwReL63fHGZK5-6D6qlfeccSsABlFJZCOW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110689639655407442818/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110689639655407442818/reviews');
SET @user_jelena_radonji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110689639655407442818/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_zivojin_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1OU0zcFl3EAE',
    5, 'hr', 'Najbolji doktor , sve pohvale !!',
    'Najbolji doktor, sve pohvale!!', 'Најбољи доктор, све похвале!!', NULL, NULL, NULL, NULL,
    0, '2023-10-11 10:22:45'),

(@user_rania_yehia, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtMHFXXzFnRRAB',
    5, 'en', 'Excellent clinic for kids',
    'Odlična klinika za decu', 'Одлична клиника за децу', 'Excellent clinic for kids', NULL, NULL, NULL,
    0, '2022-10-31 08:41:34'),

(@user_naa, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChZDSUhNMG9nS0VJQ0FnSUR0NUxLYVNnEAE',
    5, 'hr', 'Najbolji! 🤍😍',
    'Najbolji! 🤍😍', 'Најбољи! 🤍😍', NULL, NULL, NULL, NULL,
    0, '2024-02-02 16:21:15'),

(@user_coze_zeco, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2amJfeDFBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-07 11:58:25'),

(@user_milija_jevric, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2dktQQ2tnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-09-23 17:40:58'),

(@user_perisa_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwblQyUkljbGRyVEVKU1ZtWlJSM0JyWjA1SGJsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_bojana_radonji, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzN2V2djF3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_nenad_pejovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChZDSUhNMG9nS0VJQ0FnSUQwNU5XN0RnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_natasa_mijuskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChdDSUhNMG9nS0VJQ0FnSUMwMk4tZjRRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_jelena_radonji, @clinic_id, NULL, 'google_maps',
    'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChdDSUhNMG9nS0VJQ0FnSUNVb0txYm9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChZDSUhNMG9nS0VJQ0FnSUM1OU0zcFl3EAE'),
  'clinic', @clinic_id,
  'Hvala puno :)', 'hr',
  'Hvala puno :)', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJYWpwNDHrTRMRbH9EJu0L02c/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtMHFXXzFnRRAB'),
  'clinic', @clinic_id,
  'Thank you very much!', 'en',
  NULL, NULL, 'Thank you very much!', NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
