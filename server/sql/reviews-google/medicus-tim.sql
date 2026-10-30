-- Insert Google Maps reviews for Medicus tim
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/medicus-tim.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'medicus-tim');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIuVb2esNLRx389Z6xbJwRRkEF4urW7IJhT4b_MsovXt_eRhg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107191170081057832184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');
SET @user_marko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sinanovic Boris', 'https://lh3.googleusercontent.com/a-/ALV-UjVfxPiv-gF5zx0jFzPoaGu-bm74v6JJhtarV7AsRa-LAUP2zuE6=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100053020187663797431/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100053020187663797431/reviews');
SET @user_sinanovic_boris = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100053020187663797431/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Gosovic', 'https://lh3.googleusercontent.com/a/ACg8ocI4BWgWNUsffVpHjBRg2aKV2liGqkG6jDz_ATgX1jmQntqAmg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106650993042940227835/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106650993042940227835/reviews');
SET @user_marija_gosovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106650993042940227835/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ranko Vukcevic', 'https://lh3.googleusercontent.com/a/ACg8ocKwaCbnW02NNbGDUrz-i_1rrc7ZsNn8kPt1c8nBXN2Mz_4shA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111305635173455506245/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111305635173455506245/reviews');
SET @user_ranko_vukcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111305635173455506245/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Gosovix', 'https://lh3.googleusercontent.com/a/ACg8ocLpWSTJUlmkc7Nmfzmf5YVmMncsMHMagASZfk1tjcaXubCTFw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115583619708606726538/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115583619708606726538/reviews');
SET @user_elena_gosovix = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115583619708606726538/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar K', 'https://lh3.googleusercontent.com/a/ACg8ocKQtis3Wvnr8J5pHRQOmqj3Hm44IxQo798B0fyXee1kajGjWg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116134224428468135347/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116134224428468135347/reviews');
SET @user_aleksandar_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116134224428468135347/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_marko_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpa36GwCTTRMR4xp8dn6lX_Q/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKVWJXbDFjazlsWDNWVVNXTkJUQzEwUjNKd1EzYxAB',
    5, 'hr', 'Najbolja labaratorija.',
    'Najbolja laboratorija.', 'Најбоља лабораторија.', NULL, NULL, NULL, NULL,
    0, '2026-03-12 10:27:08'),

(@user_sinanovic_boris, @clinic_id, NULL, 'google_maps',
    'places/ChIJpa36GwCTTRMR4xp8dn6lX_Q/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ocGVsSldPV2MwVEdVdE1rNDBPR2RpZVZNek4yYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-04 12:10:31'),

(@user_marija_gosovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpa36GwCTTRMR4xp8dn6lX_Q/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWNFRIQkVRVVpLWkdKWGFtcFdSbEJDVkZSNGFXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-27 18:04:57'),

(@user_ranko_vukcevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpa36GwCTTRMR4xp8dn6lX_Q/reviews/Ci9DQUlRQUNvZENodHljRjlvT21nd1RtZHNNWEl4ZGpCb1NIWkRUMkZ4Ym13MWNFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-06 21:09:50'),

(@user_elena_gosovix, @clinic_id, NULL, 'google_maps',
    'places/ChIJpa36GwCTTRMR4xp8dn6lX_Q/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KemRuVTRaVVZLTFZOS05qWmlXR3hLVDNGWFQyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_aleksandar_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJpa36GwCTTRMR4xp8dn6lX_Q/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOSk1VOHpUbUYwTm5oelduTkpWbkZ2YURKcVRrRRAB',
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
