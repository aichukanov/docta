-- Insert Google Maps reviews for Specijalistička ordinacija dr Rahović
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ordinacija-dr-rahovic-bijelo-polje.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-dr-rahovic-bijelo-polje');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Timotijevic', 'https://lh3.googleusercontent.com/a/ACg8ocJlnR5rqlpyhGs_7Exnvv61hmByO8gRbtKmMSLoGNjkdGwMZw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116005457707637327502/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116005457707637327502/reviews');
SET @user_nikola_timotijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116005457707637327502/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'HIDAJET HODZIC', 'https://lh3.googleusercontent.com/a-/ALV-UjVS-oqUvhJyjK27Y6swMhTVcVQDFYJRwdcsgiVqyBh8kM2WshZ2=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106886444809359602083/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106886444809359602083/reviews');
SET @user_hidajet_hodzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106886444809359602083/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radojka Pejovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ9nhcV1M_cHF62e5NbZwzbhhwG6i7oZlgw8E7_pVp6oD9sVQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100253617739236809747/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100253617739236809747/reviews');
SET @user_radojka_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100253617739236809747/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Pejovic', 'https://lh3.googleusercontent.com/a/ACg8ocKQClERNttFCNXcDO5l37tZMW3T4Q0nJj5M5L7eunakMOLqpg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115919393721748286130/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115919393721748286130/reviews');
SET @user_jovan_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115919393721748286130/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Sara', 'https://lh3.googleusercontent.com/a/ACg8ocLijMxcvIIMZDmJBrmc2gEn8-1Ik8mPZTT_Lbled7Y0rkxhJuQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104833759234271543603/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104833759234271543603/reviews');
SET @user_sara_sara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104833759234271543603/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija V. Tomović', 'https://lh3.googleusercontent.com/a-/ALV-UjUke6Lh7iU1bvX6hR4Yctk-tSKa5kSdzHCqIl9OMTcR_vgXtfOT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103839000335525426225/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103839000335525426225/reviews');
SET @user_ksenija_v_tomovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103839000335525426225/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_nikola_timotijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJf5_pUe2jUhMRCQ-FegySUig/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t3eWRWbHJibEpCU21weVl6ZE9RMEl4T0VGNVYyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-14 12:22:35'),

(@user_hidajet_hodzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJf5_pUe2jUhMRCQ-FegySUig/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tZNU1IbExWSHBITTJWSVYwdDNTVmRQTURGdFZFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-06-18 19:21:17'),

(@user_radojka_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJf5_pUe2jUhMRCQ-FegySUig/reviews/ChdDSUhNMG9nS0VJQ0FnTURRdl95VmxnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-15 16:07:16'),

(@user_jovan_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJf5_pUe2jUhMRCQ-FegySUig/reviews/ChZDSUhNMG9nS0VJQ0FnTURROV9EMVp3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-15 07:44:22'),

(@user_sara_sara, @clinic_id, NULL, 'google_maps',
    'places/ChIJf5_pUe2jUhMRCQ-FegySUig/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBcTc3VjJRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-02-04 11:06:13'),

(@user_ksenija_v_tomovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJf5_pUe2jUhMRCQ-FegySUig/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xdU1rbFhPV3Q1VDFSNWNVNDVWRzVDV1ZWNE1WRRAB',
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
