-- Insert Google Maps reviews for MEDCONTOUR INSTITUTE
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/medcontour-institute-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'medcontour-institute-budva');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena T', 'https://lh3.googleusercontent.com/a/ACg8ocK5cTLXwocn0MKlVYp2r1KQ3FSSR-pf4hRgbk_y029XLuM1GA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116904277738043938698/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116904277738043938698/reviews');
SET @user_jelena_t = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116904277738043938698/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Александра Скосырева', 'https://lh3.googleusercontent.com/a/ACg8ocIbO4pIE4CxMd-C6_smHgmKtmXAkzpCaWiv3lJbV26N57oQNA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103829858018238060822/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103829858018238060822/reviews');
SET @user_aleksandra_skosyreva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103829858018238060822/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goran Popovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWHeyTqWTteoNFLDyioWvj-mkpyEPmqetw7S8-0tUMpA2S-V_97=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/112058146499755473837/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112058146499755473837/reviews');
SET @user_goran_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112058146499755473837/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Bozovic', 'https://lh3.googleusercontent.com/a/ACg8ocId8DLp4CzUqyuWoN4Ckn4RkuvIR8rUcuSAlKab-KSVsO5-jQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107995002277583354231/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107995002277583354231/reviews');
SET @user_jelena_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107995002277583354231/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVrkLBSPIc7G_HqkrYIp_2fncg4nUUVKfZN7mot4vGuTES9CN_v=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107704292089558610279/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107704292089558610279/reviews');
SET @user_jelena_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107704292089558610279/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Ikovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUBgeD0glh3T8eXcMZepiB2DFcl_imxOy_Km8BuuYhDAmYh5VI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117264563286253423817/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117264563286253423817/reviews');
SET @user_jovana_ikovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117264563286253423817/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'natasa slavovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXN-h_81jpAzXkXDbTKDDW_X2L9XuEQNcbKYV-CGze5pIUzpbJYYg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106689095318819856700/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106689095318819856700/reviews');
SET @user_natasa_slavovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106689095318819856700/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adrijana Slavovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVYLdDt8XOEoBZe-NAnFc1vxUxwsLdOae7zKRhPRI_PEVfA-ouwsA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101292245642829869973/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101292245642829869973/reviews');
SET @user_adrijana_slavovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101292245642829869973/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Monika Vujovic', 'https://lh3.googleusercontent.com/a/ACg8ocKC5fTidz6AQ8Y1G1w8oj7i2v-2wC6zcZp4hlw2TvPa3Ovn6w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106130823820462566864/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106130823820462566864/reviews');
SET @user_monika_vujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106130823820462566864/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_jelena_t, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxcVJqWllSamcxWHkwNFIyMUZVbWhTT0VaSVVFRRAB',
    5, 'bs', 'Vrlo moderan i prijatan ambijent u kombinaciji sa ljubaznim i stručnim osobljem. Posebne pohvale za Moniku!😊 Na osnovu pozitivnog ličnog iskustva, toplo preporučujem tretmane laserske epilacije i tretmane lica.🤗',
    'Veoma moderna i prijatna atmosfera u kombinaciji sa ljubaznim i profesionalnim osobljem. Posebna pohvala za Moniku!😊 Na osnovu pozitivnog ličnog iskustva, toplo preporučujem lasersko uklanjanje dlačica i tretmane lica.🤗', 'Веома модерна и пријатна атмосфера у комбинацији са љубазним и професионалним особљем. Посебна похвала за Монику!😊 На основу позитивног личног искуства, топло препоручујем ласерско уклањање длачица и третмане лица.🤗', NULL, NULL, NULL, NULL,
    0, '2025-11-25 13:16:19'),

(@user_aleksandra_skosyreva, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ad09ERjJWbDlYVjFWZlRsOWlhbTFFWnkxSlVVRRAB',
    5, 'ru', 'Ткперь здесь работает отличный доктор из Питера (Мария). Рекомендую!',
    'Sada ovde radi sjajna doktorka iz Sankt Peterburga (Marija). Preporučujem je!', 'Сада овде ради сјајна докторка из Санкт Петербурга (Марија). Препоручујем је!', NULL, 'Ткперь здесь работает отличный доктор из Питера (Мария). Рекомендую!', NULL, NULL,
    0, '2025-10-15 16:53:18'),

(@user_goran_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s0M1pXUktRMVZrUVdweFNYbFBVMVYzY0RKR2FIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-12 11:04:13'),

(@user_jelena_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Kck5rMXRSVEI2V20xeFdWOVFaamd0ZEdsQlkxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-23 12:50:58'),

(@user_jelena_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kaFgzZFpjSGg2YVdoUFVWZzRhMGhDUTBwMmVXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-17 09:52:11'),

(@user_jovana_ikovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxQ1IzRlVhMUZ6VUdsb2FHOUtOblJJWTFGaWNtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_natasa_slavovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwWlFYTmtlblk0UVRCWFVYcExORE54UmpGWlFYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_adrijana_slavovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oTmJUQjBaamhLUkdKS2VHcHFOMFo1ZEZwdWQzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_monika_vujovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-2WsBQDVTRMRVEi1vkLXjaw/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sdmRrWkZkM1pQT0RCU1lrMXFaRjkwYVZaTFJFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
