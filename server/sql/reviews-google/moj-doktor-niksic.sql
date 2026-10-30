-- Insert Google Maps reviews for Moj Doktor
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/moj-doktor-niksic.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'moj-doktor-niksic');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Rocenovic', 'https://lh3.googleusercontent.com/a/ACg8ocIgELtnteK-EZvCg1ptJY_rmCbCEOL8zr0Wq8VXPsMiij0stg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117717299102429005494/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117717299102429005494/reviews');
SET @user_luka_rocenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117717299102429005494/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Budimir', 'https://lh3.googleusercontent.com/a-/ALV-UjU9mCgDEOAtyTiEukaS2SdqI6TDKBT566KozBPEdj7YlmXfe2c=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107401564525465698237/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107401564525465698237/reviews');
SET @user_budimir = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107401564525465698237/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aco Tadic', 'https://lh3.googleusercontent.com/a-/ALV-UjUfbatcMhr69VCDpqbFf2RGbcMFAxbrsp3MYQVsLgbF_mB9S6BE=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110122561613032951341/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110122561613032951341/reviews');
SET @user_aco_tadic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110122561613032951341/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_luka_rocenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJbaoQbACpTRMRFwDCc29-_GY/reviews/ChZDSUhNMG9nS0VJQ0FnTUNRNmVtZVJ3EAE',
    1, 'bs', 'Neljubaznost žene sa crvenom kosom za pultom, nije htjela da mi iskopira ljekarsko uvjerenje, a uredno je uzela 45 eura.',
    'Nepristojnost žene sa crvenom kosom na šalteru, nije htela da mi kopira lekarsko uverenje, a uredno je uzela 45 evra.', 'Непристојност жене са црвеном косом на шалтеру, није хтела да ми копира лекарско уверење, а уредно је узела 45 евра.', NULL, NULL, NULL, NULL,
    0, '2025-03-05 15:58:50'),

(@user_budimir, @clinic_id, NULL, 'google_maps',
    'places/ChIJbaoQbACpTRMRFwDCc29-_GY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paZk4waFNhalJwUm1kbk1ERkJka001ZG1reFMzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-07-18 07:18:11'),

(@user_aco_tadic, @clinic_id, NULL, 'google_maps',
    'places/ChIJbaoQbACpTRMRFwDCc29-_GY/reviews/ChZDSUhNMG9nS0VKT3V4OG1XNE43NVp3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-05-09 07:45:16')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
