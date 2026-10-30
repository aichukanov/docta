-- Insert Google Maps reviews for Poliklinika Dr Vuksanović
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-dr-vuksanovic-bar.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-dr-vuksanovic-bar');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Сандра М. Павловић', 'https://lh3.googleusercontent.com/a-/ALV-UjXScIJ0SLHx5KGGqgC0KpseztvOFdg5J7SLg80tVkl6-1Y4-H79=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112199435734091207058/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112199435734091207058/reviews');
SET @user_sandra_m_pavlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112199435734091207058/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljko Milovic', 'https://lh3.googleusercontent.com/a/ACg8ocLwqr1l-cRWxHiXXOxP00HQzEL8v2vuO2UseX3hnmwQnioqTA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105130535816145641152/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105130535816145641152/reviews');
SET @user_zeljko_milovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105130535816145641152/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ruslan', 'https://lh3.googleusercontent.com/a/ACg8ocJE_1fuOJpfDy0a1dKPSVFnqsdFm9PV7wgF_leYTFPXP3rpyg=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/116992781620836568659/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116992781620836568659/reviews');
SET @user_ruslan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116992781620836568659/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrii Fedurko', 'https://lh3.googleusercontent.com/a/ACg8ocK1BiwjGTafWqnsljnYVdgHX_pOdxs4Q8fbZ5PwqXvq2tep06o=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/104710094906940621324/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104710094906940621324/reviews');
SET @user_andrii_fedurko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104710094906940621324/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ekoph onic', 'https://lh3.googleusercontent.com/a-/ALV-UjUGLnOPzec4BTA6gewpm7Hd0jIsO44BUAXisTff3DypRRQQjKWt=s128-c0x00000000-cc-rp-mo-ba7', 'https://www.google.com/maps/contrib/106092373493237664784/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106092373493237664784/reviews');
SET @user_ekoph_onic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106092373493237664784/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Simic', 'https://lh3.googleusercontent.com/a-/ALV-UjVtilmUA2etAVSNA5sj9yOavTsSl3KiXCCRFfuTNYUtRpUZv_FWQw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109489975905030257743/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109489975905030257743/reviews');
SET @user_marija_simic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109489975905030257743/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Kusturin', 'https://lh3.googleusercontent.com/a-/ALV-UjUvS2c9cCqfMWryYM_RAosaEEn-qVXIFHdKoH-uJB8JGdtcQPKT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108433609171297784861/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108433609171297784861/reviews');
SET @user_milena_kusturin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108433609171297784861/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Vuksanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKJXxk17PMrYksNP9JP0iZ-6SRHN5HfhoApJXXYh5Y6uxt4pw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115529907955893878942/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115529907955893878942/reviews');
SET @user_jelena_vuksanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115529907955893878942/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Игорь Симонов', 'https://lh3.googleusercontent.com/a-/ALV-UjXq4pJ9UYCm3SYdVMdIousDYf6Yz_VjGHkdaKlatiWQ_nWtHTqM=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112037884368281991826/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112037884368281991826/reviews');
SET @user_igor_simonov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112037884368281991826/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irena Ryaboval', 'https://lh3.googleusercontent.com/a-/ALV-UjUW0dqZ0tYGIfLs9tRrH6NPX5NNygyvRoUwAseWGSrCAY5ArG75iw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109996024097613117686/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109996024097613117686/reviews');
SET @user_irena_ryaboval = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109996024097613117686/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Kisic', 'https://lh3.googleusercontent.com/a/ACg8ocJOjG4-H_X6UWnp-SN0D1FMJMx0h-bHi9kEPXO1k_GTFLHZNDGv=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102671297673518683953/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102671297673518683953/reviews');
SET @user_ivan_kisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102671297673518683953/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Kunarac', 'https://lh3.googleusercontent.com/a-/ALV-UjXfROThsVHPojuT8iWAQHcHpr6UOaNvePr6JrKkCB-7SjVcJV2q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105714232197807979468/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105714232197807979468/reviews');
SET @user_dragana_kunarac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105714232197807979468/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleekss Aleks14', 'https://lh3.googleusercontent.com/a/ACg8ocL7lKbszDlNdN-QyjWis7Yv4zQjoAWrMtq7AE6JbgNCYDWD5fY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104739700583982613339/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104739700583982613339/reviews');
SET @user_aleekss_aleks14 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104739700583982613339/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Milic', 'https://lh3.googleusercontent.com/a-/ALV-UjUfXlfa19qlKExh6JZV8h3t2Gy2aJwEXpr0h9MLY3KgPydGeLE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117298846154851594462/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117298846154851594462/reviews');
SET @user_iva_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117298846154851594462/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIuVb2esNLRx389Z6xbJwRRkEF4urW7IJhT4b_MsovXt_eRhg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107191170081057832184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');
SET @user_marko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Armenko', 'https://lh3.googleusercontent.com/a/ACg8ocLCCfAcQdQNz_TVmI-_VE69yUjJV55z3x8FolqFipr1HwcrVw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106353461854102785391/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106353461854102785391/reviews');
SET @user_aleksandar_armenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106353461854102785391/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrijana Mitrovic', 'https://lh3.googleusercontent.com/a/ACg8ocJVLxnsu1SsreUvFRewFGrTgaojPdNDe8KUgdr-CvNSm5FHtw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115089024175693797672/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115089024175693797672/reviews');
SET @user_andrijana_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115089024175693797672/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'гена карпов', 'https://lh3.googleusercontent.com/a/ACg8ocIcotxircaK4MM-1jQFvvB2PD64tg8tKrgy_eRxaRV5y5zMCrU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101361923573070760158/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101361923573070760158/reviews');
SET @user_gena_karpov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101361923573070760158/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Turkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXq0bdW6kpTj_aSzWamZ8pgg2-J1W0PJ-rcbrCY1L6PgWIwKnfCmg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112383681702692422463/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112383681702692422463/reviews');
SET @user_nina_turkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112383681702692422463/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Сергей Терещенко', 'https://lh3.googleusercontent.com/a/ACg8ocIYdBQDh8yo8GMLUMJ54VQ12MF2fhv7gpOIxdQHTZzKKkpkeQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101329254532894759206/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101329254532894759206/reviews');
SET @user_sergey_tereshchenko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101329254532894759206/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mala Pala', 'https://lh3.googleusercontent.com/a-/ALV-UjUvF1YRaXkdan7KZZBkkRjFvbSgSzBUA0XrVKnfm8aGMYpRi0E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112617483554024307462/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112617483554024307462/reviews');
SET @user_mala_pala = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112617483554024307462/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darko Milatovic', 'https://lh3.googleusercontent.com/a/ACg8ocKfxmyy0pL6npJsdPp0mrdyUaZlYqIpvVpP8F1w9thjjQmwLVs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106393789502286424035/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106393789502286424035/reviews');
SET @user_darko_milatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106393789502286424035/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Юлия Мачулина', 'https://lh3.googleusercontent.com/a-/ALV-UjVFnnGFH6guav6gPj-K2yOXMEz00_AxGlm9G71QdebEKQ6YymPFZQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113576598377743577485/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113576598377743577485/reviews');
SET @user_yuliya_machulina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113576598377743577485/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elmadina Cucovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUPNqSWXXsdnsxPyNflmJA8uSstIM_T37wZaSt_u6B9Pt3sbw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117560342712099329963/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117560342712099329963/reviews');
SET @user_elmadina_cucovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117560342712099329963/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Isidora Jovanović', 'https://lh3.googleusercontent.com/a-/ALV-UjU3DNWAZU0wVHpyXM63vd3fQm8aEiUKpqnQxsLHuPOOpvr-UmKokA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100206293572260384760/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100206293572260384760/reviews');
SET @user_isidora_jovanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100206293572260384760/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Prelevic', 'https://lh3.googleusercontent.com/a/ACg8ocLLijKB1SSVKfDo1C57vqFrPMSSVzGVk2JUv96EeabgXeTvOg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112228329423829614151/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112228329423829614151/reviews');
SET @user_sandra_prelevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112228329423829614151/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dobrica Asanović', 'https://lh3.googleusercontent.com/a-/ALV-UjUQOVXG58GFiAd5Nc4boUW68_yPTw7udZuJSfUmjBLUZEwKmb9O=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103908283230759179473/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103908283230759179473/reviews');
SET @user_dobrica_asanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103908283230759179473/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Vuksanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUicJhbnxi1dU-semv_boh1ps324KSEy41cof7h_QlZlQEbvbQ1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109310141955226021854/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109310141955226021854/reviews');
SET @user_jelena_vuksanovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109310141955226021854/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'TOP CAT DOO Bar, MONTENEGRO', 'https://lh3.googleusercontent.com/a-/ALV-UjXH0RMhHFWdmkJp1Guowl0-P9eTEKjbxUkFZxDb3m3upQFv6uDB=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115072183633430740793/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115072183633430740793/reviews');
SET @user_top_cat_doo_bar_montenegro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115072183633430740793/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hame Hasanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJuXbjVtqsadKSFNOHDe693iOWBqgJWLvYEl5LvYJAi7ZesBQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105116552998136215793/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105116552998136215793/reviews');
SET @user_hame_hasanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105116552998136215793/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_sandra_m_pavlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJd1dtZENWelJrZEZkTFMwNVlWVmRsYVVWUmEzYxAB',
    5, 'sr', 'Препоручујем свима. Овдје сам прибавила љекарско увјерење за продужење возачке дозволе. Брзи и ефикасни, за сваку похвалу. Особље - прељубазно!!!',
    'Preporučujem svima. Ovdje sam pribavila ljekarsko uvjerenje za produženje vozačke dozvole. Brzi i efikasni, za svaku pohvalu. Osoblje - preljubazno!!!', 'Препоручујем свима. Овдје сам прибавила љекарско увјерење за продужење возачке дозволе. Брзи и ефикасни, за сваку похвалу. Особље - прељубазно!!!', NULL, NULL, NULL, NULL,
    0, '2025-09-22 07:21:29'),

(@user_zeljko_milovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSUMwbTZudXdRRRAB',
    5, 'sr', '👍👍👍👍',
    '👍👍👍👍', '👍👍👍👍', NULL, NULL, NULL, NULL,
    2, '2019-10-11 11:43:13'),

(@user_ruslan, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xJMWRISkNkV0p0YkV4eU0yZHRlalYzYUdReVlXYxAB',
    5, 'uk', 'Сподобалась лабораторія, приємні працівники, взяли кров з вени, без болю, без слідів, з першого разу працівник попав у вену, у мене тонкі вени і погано видно, аналізи уже були готові в цей же день о 10:30 на почті, тільки будьте уважні що аналізи можуть на почті бути в спамі, тільки вечером зайшов в спам і знайшов, що вони були ще зранку готові. Рекомендую, і ціни нормальні, дешевше ніж в Польщі',
    'Svidela mi se laboratorija, osoblje je bilo ljubazno, uzeli su krv iz vene, bez bola, bez tragova, prvi put je zaposleni ušao u venu, imam tanke vene i teško se vide, testovi su bili gotovi istog dana u 10:30 u pošti, samo pazite da testovi mogu biti u spamu u pošti, tek uveče sam otišla u spam i otkrila da su gotovi ujutru. Preporučujem je, a cene su normalne, jeftinije nego u Poljskoj.', 'Свидела ми се лабораторија, особље је било љубазно, узели су крв из вене, без бола, без трагова, први пут је запослени ушао у вену, имам танке вене и тешко се виде, тестови су били готови истог дана у 10:30 у пошти, само пазите да тестови могу бити у спаму у пошти, тек увече сам отишла у спам и открила да су готови ујутру. Препоручујем је, а цене су нормалне, јефтиније него у Пољској.', NULL, NULL, NULL, NULL,
    0, '2026-05-18 17:11:00'),

(@user_andrii_fedurko, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKMWMzZElhM1JFYkRoaFRraENRek5pTUZkS1RFRRAB',
    5, 'uk', 'Здавали з дружиною тут аналізи, все було дуже швидко, прийшли о 8:45, ми були другі в черзі, все зайняло 15хв., результати приходять на електронну почту.',
    'Moja žena i ja smo ovde radili testove, sve je bilo veoma brzo, stigli smo u 8:45, bili smo drugi u redu, sve je trajalo 15 minuta, rezultati stižu putem imejla.', 'Моја жена и ја смо овде радили тестове, све је било веома брзо, стигли смо у 8:45, били смо други у реду, све је трајало 15 минута, резултати стижу путем имејла.', NULL, NULL, NULL, NULL,
    0, '2026-02-16 12:37:19'),

(@user_ekoph_onic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoUGVteFBWM2RCV25aR1NtRjRSRlJHYlhRMGQyYxAB',
    4, 'de', 'Ich wurde in der Poliklinik Dr Vuksanović freundlich empfangen und professionell betreut. Die Abläufe an der Rezeption sind klar strukturiert, die Mitarbeiter arbeiten zügig und respektvoll. Besonders positiv ist die ruhige, saubere Atmosphäre und die sachliche Kommunikation der Ärztinnen und Ärzte.

Man merkt, dass hier medizinische Qualität und Organisation ernst genommen werden. Termine werden zuverlässig eingehalten, Untersuchungen sind präzise und transparent erklärt. Insgesamt ein kompetentes und vertrauenswürdiges medizinisches Zentrum, das ich weiterempfehlen kann.',
    NULL, NULL, NULL, NULL, 'Ich wurde in der Poliklinik Dr Vuksanović freundlich empfangen und professionell betreut. Die Abläufe an der Rezeption sind klar strukturiert, die Mitarbeiter arbeiten zügig und respektvoll. Besonders positiv ist die ruhige, saubere Atmosphäre und die sachliche Kommunikation der Ärztinnen und Ärzte.

Man merkt, dass hier medizinische Qualität und Organisation ernst genommen werden. Termine werden zuverlässig eingehalten, Untersuchungen sind präzise und transparent erklärt. Insgesamt ein kompetentes und vertrauenswürdiges medizinisches Zentrum, das ich weiterempfehlen kann.', NULL,
    0, '2025-10-22 17:21:22'),

(@user_marija_simic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT25salVuQnJjbEY1UldSWWRqa3lZMHBMU21wd1ozYxAB',
    1, 'bs', 'Vadila sam krv pre nedelju dana i dalje imam veliki podliv i modricu. Samo vadjenje je bilo bolno iskustvo, i bol je trajao još 30 min nakon vadjenja krvi. Medjutim kad sam došla kući videla sam da mi je veliki deo oko ruke otekao. I jos uvek me boli ruka. Nikada nisam imala ovakvo iskustvo vadjenja krvi, potpuno nestručno kao i to da sestra nije nosila rukavice.',
    'Vadila sam krv pre nedelju dana i dalje imam veliki podliv i modricu. Samo vadjenje je bilo bolno iskustvo, i bol je trajao još 30 min nakon vadjenja krvi. Medjutim kad sam došla kući videla sam da mi je veliki deo oko ruke otekao. I jos uvek me boli ruka. Nikada nisam imala ovakvo iskustvo vadjenja krvi, potpuno nestručno kao i to da sestra nije nosila rukavice.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_milena_kusturin, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4c1NrdHpRa0puU1RWc1RXcDFNVEZhWWt0VFRIYxAB',
    5, 'hr', 'Odlična usluga, prijatno osoblje. Preporučuje.',
    'Odlična usluga, prijatno osoblje. Preporučuje.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jelena_vuksanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xRM1MzQTNSVFZrYUdWblpWZGxZbHBsTW05WWNXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_igor_simonov, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCcFJFVmFkMVZsWDBKNlYyTndTVWRhWkd4NFJYYxAB',
    4, 'ru', 'Комерческая клиника есть анализы и возможность пройти медкомисию на права',
    NULL, NULL, NULL, 'Комерческая клиника есть анализы и возможность пройти медкомисию на права', NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_irena_ryaboval, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT201SFIxUmhaVXhDWlZGMWQxWTBWVmMzTUZkR04yYxAB',
    5, 'en', 'I could not find any prices on their website nor they replied via email so maybe my pictures help.',
    NULL, NULL, 'I could not find any prices on their website nor they replied via email so maybe my pictures help.', NULL, NULL, NULL,
    1, '2026-01-29 00:00:00'),

(@user_ivan_kisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WQ1ZuWjVUbUY0YmtoZlNqUlNSVXBPYWtoSWEwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_dragana_kunarac, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GQ1ZrSmxOMXB1VkcxWVQzQlVjMGxZVHpodGJsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_aleekss_aleks14, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wVVEzQkZNV1poU2xBMk0zQnFSMkozWjFNMVkyYxAB',
    5, 'hr', 'Jako ljubazne radnice 30.09 ujutro.
Pomogle su da  cerki od 4 godine izvadimo krv iz vene bez muke.
Veliko hvala na strucnosti,ljubaznosti i profesionalnosti.❤️🥰',
    'Jako ljubazne radnice 30.09 ujutro.
Pomogle su da  cerki od 4 godine izvadimo krv iz vene bez muke.
Veliko hvala na strucnosti,ljubaznosti i profesionalnosti.❤️🥰', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_iva_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnTUN3aS0yREFREAE',
    5, 'en', 'Great service.',
    NULL, NULL, 'Great service.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marko_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnTUN3eHFMVFR3EAE',
    5, 'bs', 'Jedna od boljih privatnih labartorija.Cijene su jako povoljne a rezultati tacni i precizni.Hvala.',
    'Jedna od boljih privatnih labartorija.Cijene su jako povoljne a rezultati tacni i precizni.Hvala.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aleksandar_armenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnSURfaExyYURREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_andrijana_mitrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSURfbUpfQzNBRRAB',
    1, 'hr', 'Jako sam razočarana uslugom koju sam dobila u ovoj klinici. Čekala sam predugo, iako sam imala zakazan termin. Osoblje je bilo neljubazno i nije odgovaralo na moja pitanja.

S obzirom na cijenu usluga, očekivala sam puno više. Nadam se da će uložiti više napora u poboljšanje kvalitete usluge.',
    'Jako sam razočarana uslugom koju sam dobila u ovoj klinici. Čekala sam predugo, iako sam imala zakazan termin. Osoblje je bilo neljubazno i nije odgovaralo na moja pitanja.

S obzirom na cijenu usluga, očekivala sam puno više. Nadam se da će uložiti više napora u poboljšanje kvalitete usluge.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_gena_karpov, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnSURQMTZDZk9nEAE',
    1, 'ru', 'Не корректно отлажена работа',
    NULL, NULL, NULL, 'Не корректно отлажена работа', NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_nina_turkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIei1pb05REAE',
    1, 'en', 'Very slow service.',
    NULL, NULL, 'Very slow service.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sergey_tereshchenko, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3NHVXTjhnRRAB',
    5, 'uk', 'Здавав аналізи в лабораторії. Швидко, зручно і недорого. Обслуговування приємне, результати оперативно на e-mail. Дякую',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_mala_pala, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMOGJ2OS13RRAB',
    5, 'hr', 'Sve pohvalem',
    'Sve pohvalem', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_darko_milatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSUREOV9TVnF3RRAB',
    1, 'en', 'Don t go to this place.Service very slow',
    NULL, NULL, 'Don t go to this place.Service very slow', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_yuliya_machulina, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ5NWVPOEpREAE',
    5, 'ru', 'Делала лекарско уверенье за возачка
Очень быстро, заняло 30 минут и 30 евро. Прошла офтальмолога, психиатра и терапевта.',
    NULL, NULL, NULL, 'Делала лекарско уверенье за возачка
Очень быстро, заняло 30 минут и 30 евро. Прошла офтальмолога, психиатра и терапевта.', NULL, NULL,
    2, '2024-10-29 00:00:00'),

(@user_elmadina_cucovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSUM5bnNUaHlnRRAB',
    5, 'bs', 'Zavrsavate za minut ljekarsku ovjerenju bas ste divni hvala',
    'Zavrsavate za minut ljekarsku ovjerenju bas ste divni hvala', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_isidora_jovanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSURPdVBIM3B3RRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_sandra_prelevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2cS1EbG13RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_dobrica_asanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnSURhc01yemV3EAE',
    5, 'hr', 'Vrlo profesionalni i ljubazni!
Sve pohvale!!!',
    'Vrlo profesionalni i ljubazni!
Sve pohvale!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_jelena_vuksanovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnSUNLanVfSVRnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_top_cat_doo_bar_montenegro, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChRDSUhNMG9nS0VJQ0FnSUNpbWUxSBAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_hame_hasanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWw0mSQB0ThMRp5kv75bb8rg/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3bDlHYkp3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
