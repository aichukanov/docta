-- Insert Google Maps reviews for Zdravstvena ustanova SANICARD
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/sanicard-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'sanicard-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'slaven crepulja', 'https://lh3.googleusercontent.com/a-/ALV-UjXsW7CwLqz7FuJjW4TxN4h7cjs3VKCBnEyafWoklNcVwhCo96c=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111492689050882904231/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111492689050882904231/reviews');
SET @user_slaven_crepulja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111492689050882904231/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dunja Zekovic', 'https://lh3.googleusercontent.com/a/ACg8ocKLwQFSDPQpOoNwL3RxQb5hBWvcfNWTNCPnV75MPd7j73vYEQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112451241685852492568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451241685852492568/reviews');
SET @user_dunja_zekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451241685852492568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIuVb2esNLRx389Z6xbJwRRkEF4urW7IJhT4b_MsovXt_eRhg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107191170081057832184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');
SET @user_marko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_slaven_crepulja, @clinic_id, NULL, 'google_maps',
    'places/ChIJk8O8ac7rTRMRFUCm_58AP9U/reviews/ChZDSUhNMG9nS0VJQ0FnSUNNdTR5NGFREAE',
    5, 'bs', 'Super usluga i stručnost doktorke.
Hvala vam.',
    'Super usluga i stručnost doktora.
Hvala vam.', 'Супер услуга и стручност доктора.
Хвала вам.', NULL, NULL, NULL, NULL,
    1, '2019-12-07 12:12:55'),

(@user_dunja_zekovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJk8O8ac7rTRMRFUCm_58AP9U/reviews/ChdDSUhNMG9nS0VJQ0FnSUNVd3V6TTRnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-07-21 17:46:02'),

(@user_marko_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJk8O8ac7rTRMRFUCm_58AP9U/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkTlpuaDFiVEp6ZDJ0a1pWOUhVVVpTYVZoTFoxRRAB',
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
