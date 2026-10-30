-- Insert Google Maps reviews for Dom zdravlja Andrijevica
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-andrijevica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-andrijevica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_dzemail_gilic = (SELECT id FROM doctors WHERE slug = 'dzemail-gilic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adria Dimitrescu', 'https://lh3.googleusercontent.com/a/ACg8ocKBOArHZdf4hlueSGkuirt5drtB5s1_vEJkzxUuYtfjSvFwVA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106436421585951556243/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106436421585951556243/reviews');
SET @user_adria_dimitrescu = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106436421585951556243/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Auto Slep sluzba Bulajic Podgorica', 'https://lh3.googleusercontent.com/a-/ALV-UjVE01ZaBUV85SCOwkKlw_NfVPJRcATY1CvUSizcWdoCa8JiJ3KGdw=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/109289932369141616202/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109289932369141616202/reviews');
SET @user_auto_slep_sluzba_bulajic_podgorica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109289932369141616202/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija J', 'https://lh3.googleusercontent.com/a-/ALV-UjXTWdOkIF4KgywSRgupvKxU0XPWHRpHnmV3Fyknj5Ul-vdbsmYG=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102171846216227893083/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102171846216227893083/reviews');
SET @user_marija_j = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102171846216227893083/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Bakic', 'https://lh3.googleusercontent.com/a/ACg8ocLbMAUCle92pz4y1bNWPkcdN_ZKEh7_JtmVYzzt0FvdOiKNfQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103730359278831665694/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103730359278831665694/reviews');
SET @user_nikola_bakic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103730359278831665694/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Teodora Vukasinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWmjzs3guzXGhN6acbvcEqftTQf6GQUanbmp5bGxWmlKGK56IPh=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107509483383660137818/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107509483383660137818/reviews');
SET @user_teodora_vukasinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107509483383660137818/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_adria_dimitrescu, @clinic_id, @doctor_dzemail_gilic, 'google_maps',
    'places/ChIJV6XTwTKPUhMRH2CkKTzzSwY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0R1UxQnFjMnh3VDJsMWVHRlhlVTVYYkRONlVHYxAB',
    1, 'hr', 'Nije dobro. Veliki problema. Smeta mi doktor Dzemail',
    'Nije dobro. Veliki problem. Doktor Džemail mi smeta.', 'Није добро. Велики проблем. Доктор Џемаил ми смета.', NULL, NULL, NULL, NULL,
    0, '2025-11-27 10:54:17'),

(@user_auto_slep_sluzba_bulajic_podgorica, @clinic_id, NULL, 'google_maps',
    'places/ChIJV6XTwTKPUhMRH2CkKTzzSwY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5dFFtNWxhSFV3WWpGUVVEbHBiMWh1UkVWa09HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-07 16:54:38'),

(@user_marija_j, @clinic_id, NULL, 'google_maps',
    'places/ChIJV6XTwTKPUhMRH2CkKTzzSwY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNXa2EzZk93EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-01 06:57:27'),

(@user_nikola_bakic, @clinic_id, NULL, 'google_maps',
    'places/ChIJV6XTwTKPUhMRH2CkKTzzSwY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNXa2MyZUVBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-03-01 06:54:56'),

(@user_teodora_vukasinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJV6XTwTKPUhMRH2CkKTzzSwY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNXb2JhakJnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-02-28 21:38:14')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
