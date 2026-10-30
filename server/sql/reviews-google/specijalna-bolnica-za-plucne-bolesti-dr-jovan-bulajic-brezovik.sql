-- Insert Google Maps reviews for JZU Bolnica za plućne bolesti "Dr Jovan Bulajić" Brezovik
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'specijalna-bolnica-za-plucne-bolesti-dr-jovan-bulajic-brezovik');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srdjan Drakic', 'https://lh3.googleusercontent.com/a/ACg8ocJoi2Mvhy9AmIVu5RP0EBZs_FUquZzDqfSq9a3hiFfm6HJo_Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115837766244959610898/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115837766244959610898/reviews');
SET @user_srdjan_drakic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115837766244959610898/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Maja', 'https://lh3.googleusercontent.com/a-/ALV-UjV5huF2BcsQ7BL0zvdMdyDB6Xkm-SJG26MTV4HyWnkkdpiTi5uIxA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102325119462281503819/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102325119462281503819/reviews');
SET @user_maja_maja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102325119462281503819/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Beba Katona', 'https://lh3.googleusercontent.com/a-/ALV-UjUy8Ay5kc9SE_HpysCUe-4S2dzXuDHkLqvJolIJX-TMvU0SuoJn=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/103778829423656290674/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103778829423656290674/reviews');
SET @user_beba_katona = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103778829423656290674/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovanovic Blaženka', 'https://lh3.googleusercontent.com/a/ACg8ocLpHuoCaa9hAdcsJ6qMWpblNY3Pk8QbRl_8S3i5J-ihXR4D_U5S=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/116222205057361961596/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116222205057361961596/reviews');
SET @user_jovanovic_blaenka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116222205057361961596/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristof Lastic', 'https://lh3.googleusercontent.com/a-/ALV-UjWXXMPBCeKzxISNYozg7iY6_CvwxhVhlF4pAFXzv2A1f3K5Zco=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/101937647147071255189/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101937647147071255189/reviews');
SET @user_kristof_lastic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101937647147071255189/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Duško Bodrožić', 'https://lh3.googleusercontent.com/a-/ALV-UjUYvNAtVJa5dNHG5OcPM-xY3Bs2oAgnj3FQsSqP9w2HBp9OMZi3=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100907855703963808406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100907855703963808406/reviews');
SET @user_duko_bodroi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100907855703963808406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'filip bozovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWeETrPzRZyMnmj_lIFj1oETspTE7SODEXvlecp4rcDJRNaLVxj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108108077818230171739/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108108077818230171739/reviews');
SET @user_filip_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108108077818230171739/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Toni Ante Pejic', 'https://lh3.googleusercontent.com/a-/ALV-UjUSs6HouwEr0C5Kl4048DPlo6J1GDWTR3HllUUhhoYgZ6RN-DvZqw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115799921796286111609/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115799921796286111609/reviews');
SET @user_toni_ante_pejic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115799921796286111609/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Spasova', 'https://lh3.googleusercontent.com/a/ACg8ocK2qdyoEuq2Ihzf4ThgmV2gC5hmN4EkIiDZOIxTOrB0iSmHDA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116976410726991117239/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116976410726991117239/reviews');
SET @user_sanja_spasova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116976410726991117239/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Caka Pekic', 'https://lh3.googleusercontent.com/a-/ALV-UjWZr8105DClq3yz3Dvs3ZU5oXEyKvFNADooRvCveq5W2Ad550c=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117024436135689958384/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117024436135689958384/reviews');
SET @user_caka_pekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117024436135689958384/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vera Pepdjonovic', 'https://lh3.googleusercontent.com/a/ACg8ocKyCzLdZpyYVXTmBIyW95JiEALHRI4SOEj9JMwTggt_I49uuiK2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101474480660400278019/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101474480660400278019/reviews');
SET @user_vera_pepdjonovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101474480660400278019/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljepa Bulajic', 'https://lh3.googleusercontent.com/a/ACg8ocLBtXPlGlF9FIwDRNJkUGSOXaog4Pc2kreoudUlBTl6e8uhCw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112903474458526229334/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112903474458526229334/reviews');
SET @user_ljepa_bulajic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112903474458526229334/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Milošević', 'https://lh3.googleusercontent.com/a-/ALV-UjXBWR0Z79K4fHIVwMXQ0KJM8S_hB4m0rbxxdM_31WisvsyLZp8h=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112451610222066329097/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451610222066329097/reviews');
SET @user_nikola_miloevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451610222066329097/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_srdjan_drakic, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwenJUbThnRRAB',
    5, 'bs', 'Zadnja linija odbrane za plucne bolesti i ostaloga u CG. Dje su jos doktori i osoblje na nivou i dje su i dalje ostali strucnjaci u svojoj struki...
Sve pohvale i sve najljepse osoblju i doktorima. Zivjeli...',
    'Zadnja linija odbrane za plucne bolesti i ostaloga u CG. Dje su jos doktori i osoblje na nivou i dje su i dalje ostali strucnjaci u svojoj struki...
Sve pohvale i sve najljepse osoblju i doktorima. Zivjeli...', NULL, NULL, NULL, NULL, NULL,
    5, '2019-11-05 08:33:14'),

(@user_maja_maja, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChdDSUhNMG9nS0VJQ0FnSUNHdS1tODlRRRAB',
    5, 'bs', 'Da pohvalim najbolje osoblje bolnice,posebno Doktoricu Zoju,Sestre Sonju i Miru.Hvala vam do neba i Bog vam dao sve sto pozeljele.🥰🥰🥰🥰🥰🥰',
    'Želela bih da pohvalim najbolje osoblje u bolnici, posebno doktorku Zoju, sestre Sonju i Miru. Hvala vam do neba i neka vam Bog podari sve što poželite.🥰🥰🥰🥰🥰🥰', 'Желела бих да похвалим најбоље особље у болници, посебно докторку Зоју, сестре Соњу и Миру. Хвала вам до неба и нека вам Бог подари све што пожелите.🥰🥰🥰🥰🥰🥰', NULL, NULL, NULL, NULL,
    1, '2021-11-10 15:42:01'),

(@user_beba_katona, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ4amJhODFRRRAB',
    5, 'hr', 'Brezovik prelepo mesto, hladovina i ova kamena fontana',
    'Brezovik je prelepo mesto, sa hladovinom i ovom kamenom česmom', 'Брезовик је прелепо место, са хладовином и овом каменом чесмом', NULL, NULL, NULL, NULL,
    1, '2020-07-24 16:53:36'),

(@user_jovanovic_blaenka, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChdDSUhNMG9nS0VJQ0FnSUNXNzczZnR3RRAB',
    5, 'bs', 'Odlično',
    'Odlično', 'Одлично', NULL, NULL, NULL, NULL,
    1, '2022-03-10 14:49:01'),

(@user_kristof_lastic, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChdDSUhNMG9nS0VJQ0FnSURBdlAzS3ZBRRAB',
    5, 'en', 'A+',
    'Odlično', 'Одлично', 'A+', NULL, NULL, NULL,
    0, '2018-10-02 15:27:03'),

(@user_duko_bodroi, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pNMmQxQmxSVXd5UTJKWWJsVTJURGd5T0dsZk0yYxAB',
    5, 'hr', 'vrhunska zdravstvena usluga za plućne bolesti, čisto i uredno mesto, hrana korektna i adekvatna, za svaku pohvalu',
    'vrhunska zdravstvena usluga za plućne bolesti, čisto i uredno mesto, hrana korektna i adekvatna, za svaku pohvalu', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_filip_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2trd1JEZzVhbU5vYlZoUE9FcG5kRFIzTFZvd2NGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_toni_ante_pejic, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OYVprOUtTMUZzV25BeE4zTlZSV2xsZGpadFFtYxAB',
    5, 'en', 'Specijalna bolnica Brezovik is a well-known medical facility located in a peaceful, green area just outside Nikšić. Surrounded by nature and fresh air, it offers a calm environment that supports recovery and rest.

The staff is generally professional and dedicated, providing care and support to patients with attention and responsibility. The surroundings add to the overall positive feeling, making it a place where medical care meets a quiet and healing atmosphere.

A respected institution with a long tradition, known for its serene location and important role in healthcare in Montenegro.',
    NULL, NULL, 'Specijalna bolnica Brezovik is a well-known medical facility located in a peaceful, green area just outside Nikšić. Surrounded by nature and fresh air, it offers a calm environment that supports recovery and rest.

The staff is generally professional and dedicated, providing care and support to patients with attention and responsibility. The surroundings add to the overall positive feeling, making it a place where medical care meets a quiet and healing atmosphere.

A respected institution with a long tradition, known for its serene location and important role in healthcare in Montenegro.', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_sanja_spasova, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChZDSUhNMG9nS0VJQ0FnSUNkbkxxZ0FREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_caka_pekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChZDSUhNMG9nS0VJQ0FnSUNSbEtUNEZnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_vera_pepdjonovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHNHV2M093EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_ljepa_bulajic, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChZDSUhNMG9nS0VJQ0FnSUNDbTVQbERREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_nikola_miloevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJy5wi0kIHTRMR0eD89BXfMkA/reviews/ChZDSUhNMG9nS0VJQ0FnSURzaktiZkJBEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
