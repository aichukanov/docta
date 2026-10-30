-- Insert Google Maps reviews for Nova Medicina Rada
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/nova-medicina-rada-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'nova-medicina-rada-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija M', 'https://lh3.googleusercontent.com/a/ACg8ocIGDzu2u_Jv-Ve-APrYucshIXXHIfSB-Q_Nco_ItZi6tmGm=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101118193014646469835/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101118193014646469835/reviews');
SET @user_marija_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101118193014646469835/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Canovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUVTJYpumlLJRbI3LSOrtz2TP-cqkFgaV_dQdU9aAC-Wnpm5gugug=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111356633790802148285/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111356633790802148285/reviews');
SET @user_nina_canovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111356633790802148285/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miroslav', 'https://lh3.googleusercontent.com/a/ACg8ocKG-GFKW45S23kZJx6u1nflh6dkRK_Yyb4Oo0fEho4UggC5XQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112174185780976452860/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112174185780976452860/reviews');
SET @user_miroslav = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112174185780976452860/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aja Zlatković', 'https://lh3.googleusercontent.com/a-/ALV-UjWkqj8Y6q1WwFvNGoun1_cn8D46NApGHeuyzbTFiAuX7FBn4ELa=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116147785462518868774/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116147785462518868774/reviews');
SET @user_aja_zlatkovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116147785462518868774/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Draza Mihajlovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW0dcDGoi0gmJORUwLT98LPk1E9hFJh9f0VTXagSq2bMG714j-x=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/112404707262230958390/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112404707262230958390/reviews');
SET @user_draza_mihajlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112404707262230958390/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dzeno Preljevic', 'https://lh3.googleusercontent.com/a/ACg8ocLaaxLZa-F_w6DkwB779cC6yDBkrGCnOs0eWAM-uoXav-pbtw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102272429544058884075/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102272429544058884075/reviews');
SET @user_dzeno_preljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102272429544058884075/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aida Bahović', 'https://lh3.googleusercontent.com/a-/ALV-UjU-sgEKOyagcyX3W-lKdFdTUa_dCPUBZFPYlmoL5Zo4-UbXIbjX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115117395690417340934/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115117395690417340934/reviews');
SET @user_aida_bahovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115117395690417340934/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hogar Strasni', 'https://lh3.googleusercontent.com/a/ACg8ocLLB4Cd_YXCrvwnZQ4WoRZTvLt3wJxKEY29beHP_hlaYzVHtQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101864573305241154852/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101864573305241154852/reviews');
SET @user_hogar_strasni = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101864573305241154852/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_marija_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1OVpmNS13RRAB',
    5, 'hr', 'Najbolja usluga, ljubazno osoblje i naravno najljepse sestre ❤️ Sve preporuke !!!',
    'Najbolja usluga, ljubazno osoblje i naravno najlepše medicinske sestre ❤️ Sve preporuke!!!', 'Најбоља услуга, љубазно особље и наравно најлепше медицинске сестре ❤️ Све препоруке!!!', NULL, NULL, NULL, NULL,
    0, '2022-08-26 11:25:33'),

(@user_nina_canovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNzME1mTVhREAE',
    5, 'bs', 'Sjajni profesionalnci i veoma ljubazno osoblje.',
    'Odlični profesionalci i veoma ljubazno osoblje.', 'Одлични професионалци и веома љубазно особље.', NULL, NULL, NULL, NULL,
    0, '2020-01-19 10:21:37'),

(@user_miroslav, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzMFBmMnpRRRAB',
    5, 'bs', 'Veoma sam zadovoljan vasom uslugom',
    'Veoma sam zadovoljan vašom uslugom', 'Веома сам задовољан вашом услугом', NULL, NULL, NULL, NULL,
    0, '2020-01-19 10:37:45'),

(@user_aja_zlatkovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzMEl1OWtRRRAB',
    5, 'hr', 'Sjajna usluga!',
    'Odlična usluga!', 'Одлична услуга!', NULL, NULL, NULL, NULL,
    0, '2020-01-19 09:59:51'),

(@user_draza_mihajlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/ChZDSUhNMG9nS0VJQ0FnSURmN2N2Z1lREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-01-09 10:40:27'),

(@user_dzeno_preljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4UVZURk9NbUpCT0RKek9GQTJabXhrTWpkVFNHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_aida_bahovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/ChdDSUhNMG9nS0VJQ0FnSURQeFBYYnBRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_hogar_strasni, @clinic_id, NULL, 'google_maps',
    'places/ChIJ0yT2MFfrTRMRH4vGudufERY/reviews/ChdDSUhNMG9nS0VJQ0FnSUR6ai12SnhBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
