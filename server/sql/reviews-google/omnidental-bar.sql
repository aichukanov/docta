-- Insert Google Maps reviews for Omnidental
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/omnidental-bar.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'omnidental-bar');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Toma Kovaliuk', 'https://lh3.googleusercontent.com/a/ACg8ocJgVXTQsr5bM0rjw8fnOURgDdSzRxrx25EQfZiqK-w3OdHldg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105995287619893753389/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105995287619893753389/reviews');
SET @user_toma_kovaliuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105995287619893753389/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Silvana Gabic', 'https://lh3.googleusercontent.com/a/ACg8ocIzwy6y34fgRN1R7v4gMHlgIeGP99r9hve_N4Q6IWkOs6zB=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104215604735104547393/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104215604735104547393/reviews');
SET @user_silvana_gabic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104215604735104547393/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'EVA', 'https://lh3.googleusercontent.com/a-/ALV-UjUVXf-VNB4k4kKNyX9zVviYLNYuVXwkseIyJtxoylOXvj5mOgx0=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100635683686456485167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100635683686456485167/reviews');
SET @user_eva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100635683686456485167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Barbara Sekulic', 'https://lh3.googleusercontent.com/a-/ALV-UjUsu4guSd2gOmVqeehpDyKMdIEEMJBAJmlzUPWkW72l1XildBVqpA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103696628454199903280/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103696628454199903280/reviews');
SET @user_barbara_sekulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103696628454199903280/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ognjen Petrovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXMr1r_wCHMeydkcmlwTxW17VgjvI6Isl8J7ELJzzG3hRpzcE8=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117714317409203470624/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117714317409203470624/reviews');
SET @user_ognjen_petrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117714317409203470624/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja', 'https://lh3.googleusercontent.com/a/ACg8ocJTtdjpPOLBXlaMhanRXxDpBaVyvysV_nje-k3w32FV1cPQjQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111475401779411331820/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111475401779411331820/reviews');
SET @user_anja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111475401779411331820/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Jaric', 'https://lh3.googleusercontent.com/a/ACg8ocL3hhEvCQq0_9w2rMfPAszwCpcuGsGOOPAn8gHJkfBVg4-mug=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117484422309576146600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117484422309576146600/reviews');
SET @user_marija_jaric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117484422309576146600/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Milovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJtcIljBcP_1QI5mHNG4Ju48GkWV5pbnfwxc4L4wJ9WmPWckQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108416156277261596039/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108416156277261596039/reviews');
SET @user_bojana_milovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108416156277261596039/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragica Erkic', 'https://lh3.googleusercontent.com/a/ACg8ocKPGVHLpVpPIa6oYp7j4N_ZIAQ6rhSFkXwx36PUyjMQn6vWFA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114158778344106506381/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114158778344106506381/reviews');
SET @user_dragica_erkic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114158778344106506381/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vera Kovačević', 'https://lh3.googleusercontent.com/a/ACg8ocLheCwJuH2yVXaX4zLwil4bZ-PHk_TlU-0HBKwrWAbU9CmkvA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110812917294550067255/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110812917294550067255/reviews');
SET @user_vera_kovaevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110812917294550067255/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorka Gojkovic', 'https://lh3.googleusercontent.com/a/ACg8ocIWTDlcT_M3rvjV9jnMCe8D9fmwhnFGaELei84DA3DyGXZS1Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110315547453981984047/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110315547453981984047/reviews');
SET @user_zorka_gojkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110315547453981984047/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miloš Kovačević', 'https://lh3.googleusercontent.com/a/ACg8ocJteP0ua5gu9kwNdgdgtMYIdysUhPehoLWdhllSdnvvLEM3DA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113401585489827587267/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113401585489827587267/reviews');
SET @user_milo_kovaevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113401585489827587267/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vojo Zivkovic', 'https://lh3.googleusercontent.com/a/ACg8ocIX6JTiO55LN88T342z1frh7FTuECCIglkzYGT_vT30XT0y6w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116815978861713786564/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116815978861713786564/reviews');
SET @user_vojo_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116815978861713786564/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gordana Erkić', 'https://lh3.googleusercontent.com/a-/ALV-UjWFlC439HfLG14FrwvCRbERXiM0gTbkajPr4aeZzlduY_la7pI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108103641263127223361/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108103641263127223361/reviews');
SET @user_gordana_erki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108103641263127223361/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Markus Rammler', 'https://lh3.googleusercontent.com/a-/ALV-UjUN_20zNgmbeq8a84yIT3ZtuNZhk2H8MYSH_XcBVkNTHTWgFMoT=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115403138130238300672/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115403138130238300672/reviews');
SET @user_markus_rammler = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115403138130238300672/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jinjon Kart', 'https://lh3.googleusercontent.com/a/ACg8ocKbYag_1AEYYqrSxH_YLcSOTFuUY1URPQ6MCC4SVTc8qoSGoQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116578193699301727002/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116578193699301727002/reviews');
SET @user_jinjon_kart = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116578193699301727002/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jaksa Vuckovic', 'https://lh3.googleusercontent.com/a/ACg8ocImzUT5znotKaKbJ96_uTog6Gnkm-6XwnQtY9b5HPHObqRRtn6R=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105442462881551531470/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105442462881551531470/reviews');
SET @user_jaksa_vuckovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105442462881551531470/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Nilović', 'https://lh3.googleusercontent.com/a-/ALV-UjVqAakPpPeOOd5-bOCV2k2bAp19K_8OuxDtkkuvSsl_T4-znuQs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117204229037705647237/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117204229037705647237/reviews');
SET @user_danijela_nilovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117204229037705647237/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gabi Hörold-Langenhan', 'https://lh3.googleusercontent.com/a/ACg8ocLIgTHmUU2HWyYZT1pjjgQzI-rfbisvfhlzRddlW3Sq1YYiNg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106463299515381074281/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106463299515381074281/reviews');
SET @user_gabi_hroldlangenhan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106463299515381074281/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ilija Erkić', 'https://lh3.googleusercontent.com/a-/ALV-UjXtnC8E5y9zK41ObPQmpAWH9-kDNBWbWnBBCkilBAyCDBAFWdka=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100655467616035136283/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100655467616035136283/reviews');
SET @user_ilija_erki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100655467616035136283/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_toma_kovaliuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KRlRFUkdTalJVTjNwSmNtdFhOa2t4YWtJeFdXYxAB',
    5, 'en', 'I had a wonderful experience at this dental clinic. The doctor was incredibly kind, caring, and compassionate. I highly recommend this clinic to anyone looking for excellent dental care. Thank you so much! ❤️',
    'Imala sam divno iskustvo u ovoj stomatološkoj ordinaciji. Doktor je bio neverovatno ljubazan, brižan i saosećajan. Toplo preporučujem ovu kliniku svima koji traže odličnu stomatološku negu. Hvala vam puno! ❤️', 'Имала сам дивно искуство у овој стоматолошкој ординацији. Доктор је био невероватно љубазан, брижан и саосећајан. Топло препоручујем ову клинику свима који траже одличну стоматолошку негу. Хвала вам пуно! ❤️', 'I had a wonderful experience at this dental clinic. The doctor was incredibly kind, caring, and compassionate. I highly recommend this clinic to anyone looking for excellent dental care. Thank you so much! ❤️', NULL, NULL, NULL,
    0, '2026-06-30 18:11:52'),

(@user_silvana_gabic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWS1JYZElWRVJRVUU4eGIxZHFVbXR2Y0haVFdYYxAB',
    5, 'hr', 'Doktorka Danijela, divna, ljubazna i profesionalna 🍀',
    'Doktorka Danijela, divna, ljubazna i profesionalna 🍀', 'Докторка Данијела, дивна, љубазна и професионална 🍀', NULL, NULL, NULL, NULL,
    0, '2026-06-19 10:55:49'),

(@user_eva, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNmeklhVUhREAE',
    5, 'en', 'Our family have such a wonderful experience with the young beautiful doctor Danijela, who is very professional, she has excellent people skills and a very kind heart. She’s been truly a blessing to our family. My case wasn’t easy, but Danijela has done outstanding job and gave me a new life with my great new look. I love my beautiful white smile that I have now!
Thank you so much for being so great!
Happy Holidays! We wish your practice to prosper and flourish for years to come!',
    'Naša porodica ima divno iskustvo sa mladom, prelepom doktorkom Danijelom, koja je veoma profesionalna, ima odlične veštine u komunikaciji sa ljudima i veoma je ljubazna. Ona je zaista bila blagoslov za našu porodicu. Moj slučaj nije bio lak, ali Danijela je obavila izvanredan posao i dala mi novi život sa mojim sjajnim novim izgledom. Volim svoj prelepi beli osmeh koji sada imam!

Hvala vam puno što ste tako sjajni!

Srećni praznici! Želimo da vaša ordinacija napreduje i cveta godinama koje dolaze!', 'Наша породица има дивно искуство са младом, прелепом докторком Данијелом, која је веома професионална, има одличне вештине у комуникацији са људима и веома је љубазна. Она је заиста била благослов за нашу породицу. Мој случај није био лак, али Данијела је обавила изванредан посао и дала ми нови живот са мојим сјајним новим изгледом. Волим свој прелепи бели осмех који сада имам!

Хвала вам пуно што сте тако сјајни!

Срећни празници! Желимо да ваша ординација напредује и цвета годинама које долазе!', 'Our family have such a wonderful experience with the young beautiful doctor Danijela, who is very professional, she has excellent people skills and a very kind heart. She’s been truly a blessing to our family. My case wasn’t easy, but Danijela has done outstanding job and gave me a new life with my great new look. I love my beautiful white smile that I have now!
Thank you so much for being so great!
Happy Holidays! We wish your practice to prosper and flourish for years to come!', NULL, NULL, NULL,
    0, '2024-12-26 18:13:57'),

(@user_barbara_sekulic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGYWEwSnVTRUZZT0ZCSlpUQnBkRE5JWTNSVVpVRRAB',
    5, 'hr', 'Veoma profesionalna, detaljna i pažljiva u svom radu. Preporučujem da posjetite ordinaciju, nećete pogriješiti. 🥰',
    'Veoma profesionalna, detaljna i pažljiva u svom radu. Preporučujem vam da posetite ordinaciju, nećete pogrešiti. 🥰', 'Веома професионална, детаљна и пажљива у свом раду. Препоручујем вам да посетите ординацију, нећете погрешити. 🥰', NULL, NULL, NULL, NULL,
    0, '2025-07-12 16:08:03'),

(@user_ognjen_petrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tScVlWQmljMWREV2taSlduUkdjbVU0T1djMVpFRRAB',
    5, 'bs', 'Topla preporuka svima koji traže kvalitetnog zubara i prijatan ambijent.',
    'Toplo preporučujem svima koji traže kvalitetnog stomatologa i prijatnu atmosferu.', 'Топло препоручујем свима који траже квалитетног стоматолога и пријатну атмосферу.', NULL, NULL, NULL, NULL,
    0, '2025-07-15 12:42:57'),

(@user_anja, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tFMFZYRldNV1F6ZGpOaGExRkVXVTFvTlRSWVRuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_marija_jaric, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT210R1Rqa3dVbE5SVFdaQ1VsZEhRbEZWT1VwcWNHYxAB',
    5, 'hr', 'Konačno zubar kod kog se osjećam opušteno i sigurno. Sve preporuke! ❤️',
    'Konačno zubar kod kog se osjećam opušteno i sigurno. Sve preporuke! ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_bojana_milovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsQlRqaENaaTEwWlRKcWJHcHNjSGQwZDBWV2VIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragica_erkic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCRlRrdzFWbTFxTXpkb2NUSXhYMVl0TjFweFNWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vera_kovaevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWS1VVcHNhVGRyWDBsU00wbG9WbXRmYTNvelIyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_zorka_gojkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Wb1oxYzNaaTFaYlVoSVNYUkhWVVJXUTBJMFgyYxAB',
    5, 'bs', 'Imala sam veliki strah od zubara,zahvaljujući divnoj dr Danijeli prevazišla sam ga😊',
    'Imala sam veliki strah od zubara,zahvaljujući divnoj dr Danijeli prevazišla sam ga😊', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milo_kovaevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaSVkyZFpNbE5PVTFJeFdEQlBSeTFrVWxKaFYyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vojo_zivkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GcFVXRmZjWFpXVEZGUldWcEtOV1l3VjJvdFZXYxAB',
    5, 'hr', 'Najbolja ordinacija u Baru! Sve pohvale !',
    'Najbolja ordinacija u Baru! Sve pohvale !', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_gordana_erki, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25veWEza3dRbTlOVEZJeE5qQnpNMG81UVZOdFoxRRAB',
    5, 'hr', 'Divna ordinacija jos divniji stomatolog😊',
    'Divna ordinacija jos divniji stomatolog😊', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_markus_rammler, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCWVF6aDRTa2N6Tm1ZeldVUTFNM1Z2VG5KYVRtYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jinjon_kart, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNZektTbnNBRRAB',
    5, 'de', 'Sehr gute zahnärtztin',
    NULL, NULL, NULL, NULL, 'Sehr gute zahnärtztin', NULL,
    0, '2025-10-29 00:00:00'),

(@user_jaksa_vuckovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNIdWNLT25BRRAB',
    5, 'en', 'Such a kind and caring doctor that I married her.',
    NULL, NULL, 'Such a kind and caring doctor that I married her.', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_danijela_nilovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3M09qckt3EAE',
    5, 'hr', 'Jako prijatna, posvećena i temeljna doktorka. Sve preporuke!',
    'Jako prijatna, posvećena i temeljna doktorka. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_gabi_hroldlangenhan, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEc2VLSWp3RRAB',
    5, 'de', 'Sehr moderne, kleine Praxis mit englischsprachiger, junger Ärztin. Hatte ein Inlay verloren, welches sie mir ohne weiteres wieder einsetzte. 👍',
    NULL, NULL, NULL, NULL, 'Sehr moderne, kleine Praxis mit englischsprachiger, junger Ärztin. Hatte ein Inlay verloren, welches sie mir ohne weiteres wieder einsetzte. 👍', NULL,
    3, '2024-10-29 00:00:00'),

(@user_ilija_erki, @clinic_id, NULL, 'google_maps',
    'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM5NC1mdlNREAE',
    5, 'ru', NULL,
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

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KRlRFUkdTalJVTjNwSmNtdFhOa2t4YWtJeFdXYxAB'),
  'clinic', @clinic_id,
  'Thank you for your kind review.', 'en',
  NULL, NULL, 'Thank you for your kind review.', NULL, NULL, NULL,
  'google_maps', '2026-07-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNmeklhVUhREAE'),
  'clinic', @clinic_id,
  'Thank you so much for your kind review.', 'en',
  NULL, NULL, 'Thank you so much for your kind review.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCWVF6aDRTa2N6Tm1ZeldVUTFNM1Z2VG5KYVRtYxAB'),
  'clinic', @clinic_id,
  'Dear Mr Rammler,we are struggling to understand and we\'re hoping that you will help us.We received you in our office even though you didn\'t have an appointment because you had an urgent problem which we were able to fix quickly and efficiently. Did something happen later to prompt you to leave this review?We are asking this because we are committed to all our patients having a great experience when with us.Thank you.', 'en',
  NULL, NULL, 'Dear Mr Rammler,we are struggling to understand and we\'re hoping that you will help us.We received you in our office even though you didn\'t have an appointment because you had an urgent problem which we were able to fix quickly and efficiently. Did something happen later to prompt you to leave this review?We are asking this because we are committed to all our patients having a great experience when with us.Thank you.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNZektTbnNBRRAB'),
  'clinic', @clinic_id,
  'Thank you very much.', 'en',
  NULL, NULL, 'Thank you very much.', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNyvgJdZzThMRHMKtcvw2gvo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEc2VLSWp3RRAB'),
  'clinic', @clinic_id,
  'Thank you for your review,especially for "young doctor"🙂', 'en',
  NULL, NULL, 'Thank you for your review,especially for "young doctor"🙂', NULL, NULL, NULL,
  'google_maps', '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
