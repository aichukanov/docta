-- Insert Google Maps reviews for dr Abramović
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dr-abramovic-a-medical-bar.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dr-abramovic-a-medical-bar');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina Teglasi', 'https://lh3.googleusercontent.com/a-/ALV-UjWe3aZwTNt_TfB_pLmw-H9KZ6Jq0RLxGu2l95qs9x3RvJa9JKhq7w=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/108165414941998109519/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108165414941998109519/reviews');
SET @user_jasmina_teglasi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108165414941998109519/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dm d', 'https://lh3.googleusercontent.com/a/ACg8ocIhGTXWXuQ0eJzWAAbHetZOog4TBYtv_MK_mc5FjcbhRX4cGw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107511092677090812344/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107511092677090812344/reviews');
SET @user_dm_d = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107511092677090812344/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dacho', 'https://lh3.googleusercontent.com/a/ACg8ocKHr7TuhbQme_0UkIbzEut07A8HTPQvkn6XXIxNN1V00esIllPQ=s128-c0x00000000-cc-rp-mo-ba6', 'https://www.google.com/maps/contrib/117786931075400799617/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117786931075400799617/reviews');
SET @user_dacho = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117786931075400799617/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Victoria', 'https://lh3.googleusercontent.com/a-/ALV-UjVed_2g8K_ved93KJuKuC6wAdjgf9-C9x6ezpvdpq-V9sQ0mi1F=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105407438010925102777/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105407438010925102777/reviews');
SET @user_victoria = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105407438010925102777/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Tanja', 'https://lh3.googleusercontent.com/a/ACg8ocLa0uMQ9P0V7OZ-tNw78WeWifoOGFFtkBTqp2ZB4nkNVWYN1Q=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/115408932787741681907/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115408932787741681907/reviews');
SET @user_tanja_tanja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115408932787741681907/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Knežević', 'https://lh3.googleusercontent.com/a/ACg8ocLtCjKFUeqrtuJ40JSuXW4Pj7Eld1EukXmkk7B7hRuzmSOVWA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106816724498360445604/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106816724498360445604/reviews');
SET @user_vladimir_kneevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106816724498360445604/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIuVb2esNLRx389Z6xbJwRRkEF4urW7IJhT4b_MsovXt_eRhg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107191170081057832184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');
SET @user_marko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_jasmina_teglasi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ87q7SAB0ThMRIed9XD0ALgs/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1c3N6cnVBRRAB',
    5, 'hr', 'Sve pohvale strucni i usluzni!',
    'Sve pohvale strucni i usluzni!', NULL, NULL, NULL, NULL, NULL,
    1, '2022-08-17 13:12:57'),

(@user_dm_d, @clinic_id, NULL, 'google_maps',
    'places/ChIJ87q7SAB0ThMRIed9XD0ALgs/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnNVo3azJRRRAB',
    5, 'en', 'super specialist. tactful, attentive and knows what he\'s doing. I recommend',
    'Super stručnjak. Taktičan, pažljiv i zna šta radi. Preporučujem.', 'Супер стручњак. Тактичан, пажљив и зна шта ради. Препоручујем.', 'super specialist. tactful, attentive and knows what he\'s doing. I recommend', NULL, NULL, NULL,
    1, '2025-02-19 10:34:14'),

(@user_dacho, @clinic_id, NULL, 'google_maps',
    'places/ChIJ87q7SAB0ThMRIed9XD0ALgs/reviews/ChdDSUhNMG9nS0VJQ0FnSUNJazQ3MjlnRRAB',
    5, 'en', 'Professional. Fast.',
    'Profesionalno. Brzo.', 'Професионално. Брзо.', 'Professional. Fast.', NULL, NULL, NULL,
    2, '2018-12-05 11:24:43'),

(@user_victoria, @clinic_id, NULL, 'google_maps',
    'places/ChIJ87q7SAB0ThMRIed9XD0ALgs/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwdzhuRllREAE',
    5, 'ru', 'Большое спасибо!',
    'Hvala vam puno!', 'Хвала вам пуно!', NULL, 'Большое спасибо!', NULL, NULL,
    1, '2023-08-09 11:10:37'),

(@user_tanja_tanja, @clinic_id, NULL, 'google_maps',
    'places/ChIJ87q7SAB0ThMRIed9XD0ALgs/reviews/ChZDSUhNMG9nS0VJQ0FnSURVc28ySUhREAE',
    5, 'bs', 'Zanimljivo',
    'Zanimljivo', 'Занимљиво', NULL, NULL, NULL, NULL,
    1, '2019-08-19 07:34:19'),

(@user_vladimir_kneevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ87q7SAB0ThMRIed9XD0ALgs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOb1FYSjNTVEUxV0V0RVJUUTRNMU5uUWtacFpXYxAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_marko_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ87q7SAB0ThMRIed9XD0ALgs/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twd1MwZFJSazVYT0RZeFRWcHhiR2hKV0ZoWVlsRRAB',
    5, 'hr', 'Vrhunski.Nasao mi je sve probleme u abdomenu koje sam ima.',
    'Vrhunski.Nasao mi je sve probleme u abdomenu koje sam ima.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
