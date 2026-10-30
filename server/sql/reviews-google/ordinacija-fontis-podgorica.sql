-- Insert Google Maps reviews for Ordinacija Fontis - Interna medicina
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ordinacija-fontis-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-fontis-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vanja', 'https://lh3.googleusercontent.com/a/ACg8ocI5U_XgxTlUZroBKWcAw3geoycUBmf2-Jhu14gyd5Vi_Yj5bw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117036710942513194982/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117036710942513194982/reviews');
SET @user_vanja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117036710942513194982/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljko Lukacevic', 'https://lh3.googleusercontent.com/a/ACg8ocJpgAo20hDDWVrlyD6QbDcoa4DGA6P07kiWEEn5y__f2dE8SA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105836895455277354966/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105836895455277354966/reviews');
SET @user_veljko_lukacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105836895455277354966/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kendra Leis', 'https://lh3.googleusercontent.com/a/ACg8ocLpxAKMF9fc33sJLVnBKhj9kvY65Boqq5SXKWjNMnoA8Pvp4w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118281303467194963458/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118281303467194963458/reviews');
SET @user_kendra_leis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118281303467194963458/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Lucic', 'https://lh3.googleusercontent.com/a/ACg8ocJhm12GElVmHLfOZPY4IEAsxyQa6L--_WXKFzsJPYOORBn-xA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116298884543901732688/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116298884543901732688/reviews');
SET @user_marija_lucic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116298884543901732688/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Lučić', 'https://lh3.googleusercontent.com/a/ACg8ocJ3hDAKlI9fs6iVg1QoU98yrW6yiu-lBe2CvEQpSaI0nWSlBg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103650132017696201323/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103650132017696201323/reviews');
SET @user_dijana_lui = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103650132017696201323/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko top 10 Krivokapic', 'https://lh3.googleusercontent.com/a/ACg8ocL1oH70qGmxgKRrbWGLtqpDSmkXtndPNKf5f_jzFcDmugzjZw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111285072799310268243/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111285072799310268243/reviews');
SET @user_mirko_top_10_krivokapic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111285072799310268243/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavica Vucurovic', 'https://lh3.googleusercontent.com/a/ACg8ocJxo1YYBp2ZNFC-WaJciSn8MrqIwE_4wKnC-Im_64D4E4yZ2A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105603936467307333264/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105603936467307333264/reviews');
SET @user_slavica_vucurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105603936467307333264/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'iva perovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXTJ6UpWhoHQO1keyP91t2ozjhMH_auSDn24LBij79MTkEmtxM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117540602752032796699/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117540602752032796699/reviews');
SET @user_iva_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117540602752032796699/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Velisa Terzic', 'https://lh3.googleusercontent.com/a/ACg8ocL7a0UaHHJbiGqoKA2eBKlYoj9vmQndsvBKgkB8j05E-7a5vw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106381767166109957504/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106381767166109957504/reviews');
SET @user_velisa_terzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106381767166109957504/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadja C', 'https://lh3.googleusercontent.com/a/ACg8ocIo6SzAoNmr3bhosxBzay-w2IC0p3JouV3kGMlPv3NUT6LfpA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108223880099198255536/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108223880099198255536/reviews');
SET @user_nadja_c = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108223880099198255536/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Krivokapic', 'https://lh3.googleusercontent.com/a/ACg8ocIw5L0Uk6wXxcCaOuMZ-AP7atZ-FGcqD0pk3JXShY_d9bJR=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105505201614150504737/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105505201614150504737/reviews');
SET @user_stefan_krivokapic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105505201614150504737/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Potpara', 'https://lh3.googleusercontent.com/a/ACg8ocJ6RjYIy0UsT37YVRK9vFwXUFf9ipuU-eTCQdr2lQl7FiPnhg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110557160827046997031/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110557160827046997031/reviews');
SET @user_bojana_potpara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110557160827046997031/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'marija marija', 'https://lh3.googleusercontent.com/a-/ALV-UjWe3nSodp81yAYvMBMqosLW-j61_kRc3YHl1sQwGX4n2lk3ivX8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103249861724097708714/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103249861724097708714/reviews');
SET @user_marija_marija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103249861724097708714/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Benn Djokic', 'https://lh3.googleusercontent.com/a-/ALV-UjVQTQF6lry5T2kCFtCCm-t5qHEHki6aZuRnJyul7qEQbrNd6H8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114926142109873135456/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114926142109873135456/reviews');
SET @user_benn_djokic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114926142109873135456/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Moračanin', 'https://lh3.googleusercontent.com/a/ACg8ocLGUkn7T9i8Yd-W4nqOJ1wBY7GsGYhZH5nrUehARZS1DlsvEA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116485196344052550823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116485196344052550823/reviews');
SET @user_dragana_moraanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116485196344052550823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alo Alo', 'https://lh3.googleusercontent.com/a/ACg8ocItzI7fw4KhECt9fCBqa6tIwdyjJIO8_ugBfK9iIH-hmG8LIQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107071673421233901382/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107071673421233901382/reviews');
SET @user_alo_alo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107071673421233901382/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Lakovic', 'https://lh3.googleusercontent.com/a/ACg8ocLGLmfF1Jadh-fQcr4ZW2WfGK_OsnJb7e8ufio7LWpZXChLug=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115322951281047367610/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115322951281047367610/reviews');
SET @user_marija_lakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115322951281047367610/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irena Mijuskovic', 'https://lh3.googleusercontent.com/a/ACg8ocJASDwU0av-KigvDhNGHzaW_0TXpA1_C8ercdhb7l5OX2aD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105986132560180215056/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105986132560180215056/reviews');
SET @user_irena_mijuskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105986132560180215056/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_vanja, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoT1FqbHdSRWw0VFhsNVVIUTBMVFJGZW5kamJGRRAB',
    5, 'hr', 'Prije 2 godine radila sam epilaciju u ordinaciji Fontis. Predivno iskustvo! Ordinacija je čista i moderno opremljena sa najnovijim aparatima. Ono što me je najvise oduševilo jeste izuzetno ljubazno i profesionalno osoblje koje sve detaljno objasni prije samog tretmana. Rezultati su odlični – koža glatka i bez iritacija, čak i nakon 2 godine od tretmana. Svaka preporuka!',
    'Pre 2 godine, uradila sam epilaciju u kancelariji Fontis. Divno iskustvo! Kancelarija je čista i savremeno opremljena najsavremenijom opremom. Ono što me je najviše oduševilo je izuzetno ljubazno i profesionalno osoblje koje je sve detaljno objasnilo pre samog tretmana. Rezultati su odlični - koža je glatka i bez iritacija čak i nakon 2 godine tretmana. Svaka preporuka!', 'Пре 2 године, урадила сам епилацију у канцеларији Фонтис. Дивно искуство! Канцеларија је чиста и савремено опремљена најсавременијом опремом. Оно што ме је највише одушевило је изузетно љубазно и професионално особље које је све детаљно објаснило пре самог третмана. Резултати су одлични - кожа је глатка и без иритација чак и након 2 године третмана. Свака препорука!', NULL, NULL, NULL, NULL,
    0, '2025-10-29 19:38:08'),

(@user_veljko_lukacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNad1o2RG1nRRAB',
    1, 'hr', 'Uzmu novac i ne pomognu!',
    'Uzimaju pare i ne pomažu!', 'Узимају паре и не помажу!', NULL, NULL, NULL, NULL,
    0, '2023-09-11 20:49:47'),

(@user_kendra_leis, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChdDSUhNMG9nS0VJQ0FnSUROdzVhMnN3RRAB',
    1, 'de', 'Schlechter Service.',
    'Loša usluga.', 'Лоша услуга.', NULL, NULL, 'Schlechter Service.', NULL,
    0, '2024-01-25 12:27:26'),

(@user_marija_lucic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCWGJHOHRWVTFpUldsME1tVmxaRTVhY21RMWFsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-25 09:38:01'),

(@user_dijana_lui, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKWWRXSlJURGhWUlMxUGJqUXpNbFkyTjFSNE0wRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-25 08:39:43'),

(@user_mirko_top_10_krivokapic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psMVJXcG9SeTFxVm5aS1ZHWnFUemxSVjBSbU1GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_slavica_vucurovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twQ1FtWlJlV0o2YWpCNFQwWnVRUzFGVEhoclFYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_iva_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wVUxYSTFjMHh2ZGtGV2MxQkJXbXRwV2tkMFJIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_velisa_terzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OV04xUjZhMHhwVEdoaWNIZDVhR2huU25sRlJHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_nadja_c, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pabk5WSmFiREJmYjNNdGNuaDZXRlJvYmt0S0xWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_stefan_krivokapic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oUmNFUmpia2t3WjFoQkxYUktVM05sV1ZjMlMzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_bojana_potpara, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tseWVFOXFkSFozZGtaaU9IVnRTMmhrZVVzNFlYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_marija_marija, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChdDSUhNMG9nS0VQWFozYmkya2M3QW1BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_benn_djokic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChZDSUhNMG9nS0VJQ0FnSUM0eE83b0N3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_dragana_moraanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChZDSUhNMG9nS0VJQ0FnSURRdXBHdmRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_alo_alo, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChdDSUhNMG9nS0VJQ0FnSURnaGEyY21RRRAB',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_marija_lakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChdDSUhNMG9nS0VJQ0FnSURBMXFuUnd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2016-10-29 00:00:00'),

(@user_irena_mijuskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChdDSUhNMG9nS0VJQ0FnSURBcklmQXBRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2016-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoT1FqbHdSRWw0VFhsNVVIUTBMVFJGZW5kamJGRRAB'),
  'clinic', @clinic_id,
  'Draga Vanja,
Hvala Vam na divnoj recenziji i preporuci! 💙
Drago nam je što ste i nakon dvije godine zadovoljni rezultatima epilacije.
Posebno nas raduje što ste istakli ljubaznost i profesionalnost našeg tima, jer nam je to uvijek na prvom mjestu.
Hvala Vam na povjerenju i lijepim riječima.

Srdačan pozdrav,
Vaš Fontis tim', 'hr',
  'Draga Vanja,
Hvala Vam na divnoj recenziji i preporuci! 💙
Drago nam je što ste i nakon dvije godine zadovoljni rezultatima epilacije.
Posebno nas raduje što ste istakli ljubaznost i profesionalnost našeg tima, jer nam je to uvijek na prvom mjestu.
Hvala Vam na povjerenju i lijepim riječima.

Srdačan pozdrav,
Vaš Fontis tim', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-01-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJeemPdTrrTRMRDf_15muQOhc/reviews/ChZDSUhNMG9nS0VJQ0FnSURRdXBHdmRREAE'),
  'clinic', @clinic_id,
  'Hvala na lepoj oceni.
Srdačan pozdrav', 'bs',
  'Hvala na lepoj oceni.
Srdačan pozdrav', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2018-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
