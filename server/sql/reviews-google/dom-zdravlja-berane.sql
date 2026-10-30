-- Insert Google Maps reviews for JZU Dom zdravlja Dr Nika Labović
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-berane.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-berane');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ranko R. (Rank0)', 'https://lh3.googleusercontent.com/a-/ALV-UjWrNmH-mXJFcKZx3KHEHcE0PgeXqrgU4fBsa9n8xWF2trqrgr2f=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/100891523704366959835/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100891523704366959835/reviews');
SET @user_ranko_r_rank0 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100891523704366959835/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bolle', 'https://lh3.googleusercontent.com/a-/ALV-UjVJJK6Fm5InVqyJAjFhwGbG5hM-TOD2DnKZ0h9JX3_ohtZUD98=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101617674863291703465/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101617674863291703465/reviews');
SET @user_bolle = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101617674863291703465/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ranko_r_rank0, @clinic_id, NULL, 'google_maps',
    'places/ChIJ6bOlY8KTUhMR1jGc6dKoOkM/reviews/ChZDSUhNMG9nS0VJQ0FnSURPMV9YRkxREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-07-16 13:09:06'),

(@user_bolle, @clinic_id, NULL, 'google_maps',
    'places/ChIJ6bOlY8KTUhMR1jGc6dKoOkM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsM1pHczRSVlJVWld3d1dUQXdZWGs1VlVoV2IxRRAB',
    5, 'hr', 'Trebao bi da bude regionalni centar za sjever Crne Gore',
    'Trebao bi da bude regionalni centar za sjever Crne Gore', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
