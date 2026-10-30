-- Insert Google Maps reviews for Dom Zdravlja Kolašin
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-kolasin.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-kolasin');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Драганић Сандра', 'https://lh3.googleusercontent.com/a-/ALV-UjUdUfg0A_zLttgGG7ESVpvBoPyvsmR3uDp-6IAl-m10QwXZl5sIxw=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/110526824399028819470/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110526824399028819470/reviews');
SET @user_draganic_sandra = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110526824399028819470/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'אבי חמו', 'https://lh3.googleusercontent.com/a-/ALV-UjWeY-BWNXZABuuXGAeXcWQT7vhUf31SWQo0ViGgyS4LsmYVpBoLwg=s128-c0x00000000-cc-rp-mo-ba6', 'https://www.google.com/maps/contrib/112331163430153983770/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112331163430153983770/reviews');
SET @user_user_112331163430153983770 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112331163430153983770/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_draganic_sandra, @clinic_id, NULL, 'google_maps',
    'places/ChIJKbCSmQN9TRMR6CXGpE01TPg/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wamRqQlZXRlpTU0Y5SlgzVkVSR1oxZWxOT2RVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-09 06:23:04'),

(@user_user_112331163430153983770, @clinic_id, NULL, 'google_maps',
    'places/ChIJKbCSmQN9TRMR6CXGpE01TPg/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wZk0wVmZRa3hCYWtwRFgwNXJVR0owVGtkcWMxRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-07-17 12:51:30')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
