-- Insert Google Maps reviews for LLOLLA DENT
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/llolla-dent-ulcinj.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'llolla-dent-ulcinj');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Сергей Окоповой', 'https://lh3.googleusercontent.com/a-/ALV-UjXheNlJPIymu8woYLPZuSgGrzO32KFmjpw2PbEnUSqwX3XxSUPl=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/110479538411066468228/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110479538411066468228/reviews');
SET @user_sergey_okopovoy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110479538411066468228/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina', 'https://lh3.googleusercontent.com/a/ACg8ocLH_RkTQdFeuh_k_EX48RVNua8neXv3mysWjD9G5Jj9zxoUG2Q=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/106490434422585472392/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106490434422585472392/reviews');
SET @user_jasmina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106490434422585472392/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sylvia Isler', 'https://lh3.googleusercontent.com/a-/ALV-UjWTpduwICRAB9pm8Mfo9R5L3XPIWAp7CpNyeyjgtndsXBrLzmcSTg=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/105690007459371628320/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105690007459371628320/reviews');
SET @user_sylvia_isler = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105690007459371628320/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Jokic Dobrovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXqEU8MX7MVe_lvHH_zC_Kvs0aKVVQxORHAHOTHSJAT6VW9CmwJvA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/106207795437584686241/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106207795437584686241/reviews');
SET @user_jelena_jokic_dobrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106207795437584686241/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Behudina Alic', 'https://lh3.googleusercontent.com/a/ACg8ocJ1uE8Wi4lKc8qxAh8fIJBreSF6voZmepzZLMZEShYzPHuYeQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107774127477556913351/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107774127477556913351/reviews');
SET @user_behudina_alic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107774127477556913351/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mark Pej', 'https://lh3.googleusercontent.com/a/ACg8ocJ7CF9ZnCIqqFfAAZxzYW47EipD-ghxUoVxtrjNrfloDTMeQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112978211954831913335/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112978211954831913335/reviews');
SET @user_mark_pej = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112978211954831913335/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alim Truma', 'https://lh3.googleusercontent.com/a-/ALV-UjUJuY5gudLPwht3Pb1QOMccbCQBEuoZucS7wq73H-Lk2DFnIvKp=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116245923307066271545/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116245923307066271545/reviews');
SET @user_alim_truma = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116245923307066271545/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sead Salihovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWyTJ_IpdLK2fJ1jEKefDJA8WG0qSrTDWUpeU7bWN1zFTQs1lr4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113240773010295053617/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113240773010295053617/reviews');
SET @user_sead_salihovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113240773010295053617/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Armin Huric', 'https://lh3.googleusercontent.com/a/ACg8ocLyThhviM6bBGMhM31IUjziEfLRH3I52yZs5gCjEtHB9jXBQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102580817022819016519/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102580817022819016519/reviews');
SET @user_armin_huric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102580817022819016519/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Dančetović', 'https://lh3.googleusercontent.com/a/ACg8ocJ3iuvbihdsiHdGtYOaHTPJiDw6-K8NWdsa6y4Bz38uL4f85w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115011644892166882850/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115011644892166882850/reviews');
SET @user_marko_danetovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115011644892166882850/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mare', 'https://lh3.googleusercontent.com/a-/ALV-UjVPs1rsBf1QmnZN6nBLS__bOO93b00NUfCO3eWxoaTS8_j_dLk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113628988458551392804/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113628988458551392804/reviews');
SET @user_mare = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113628988458551392804/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Cirovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXfKRXKoubIFVLQt5Njqs-dh95Oy1m1DYD3biPxdlASL8vdxHEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111012591676465944649/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111012591676465944649/reviews');
SET @user_nina_cirovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111012591676465944649/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nataša', 'https://lh3.googleusercontent.com/a/ACg8ocJTtUqQFwT_zn_z7GTYVHD4X7NMqYVbG6YW3C17LAOC4qcJ5cM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114590493308249465797/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114590493308249465797/reviews');
SET @user_nataa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114590493308249465797/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_sergey_okopovoy, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KMWJHUjZRMEZCYURGUWFIVkxhVWh1U3pGMGFWRRAB',
    5, 'uk', 'Були з дружиною у липні 2022 року. Робили мости та імпланти. Дуже задоволині.. Велике дякую доктору та його команді. Обов\'язково приїдемо ще...',
    'Moja žena i ja smo bili tamo u julu 2022. Uradili smo mostove i implantate. Veoma sam zadovoljan.. Veliko hvala doktoru i njegovom timu. Svakako ćemo ponovo doći...', 'Моја жена и ја смо били тамо у јулу 2022. Урадили смо мостове и имплантате. Веома сам задовољан.. Велико хвала доктору и његовом тиму. Свакако ћемо поново доћи...', NULL, NULL, NULL, NULL,
    0, '2026-02-16 11:04:21'),

(@user_jasmina, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OSGExaEtVVzB5UkdKWFNWWXplbTk1UTJVM2FsRRAB',
    5, 'hr', 'Najbolja Ordinacija što postoji , Dr. Llolla je veoma smiren i ljubazan, a Osoblje je isto veoma ljubazno. ****',
    'Najbolja ordinacija koja postoji, dr Ljola je veoma mirna i ljubazna, a osoblje je takođe veoma ljubazno. ****', 'Најбоља ординација која постоји, др Љола је веома мирна и љубазна, а особље је такође веома љубазно. ****', NULL, NULL, NULL, NULL,
    0, '2025-09-22 08:21:30'),

(@user_sylvia_isler, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChZDSUhNMG9nS0VJQ0FnTURvNDktVVNBEAE',
    5, 'de', 'Ich habe meinen Oberkiefer mit 5 Implantaten machen lassen. Super Arbeit. Ein super Zahnarzt. Die Schwestern sind immer freundlich und hilfsbereit. Ich kann ihn mit💯👍weiterempfehlen. Ganz großes Lob 🤗🤗',
    'Uradio sam gornju vilicu sa 5 implantata. Odličan posao. Fantastičan zubar. Pomoćnici su uvek ljubazni i od pomoći. Toplo ga preporučujem. Ogromne pohvale! 🤗🤗', 'Урадио сам горњу вилицу са 5 имплантата. Одличан посао. Фантастичан зубар. Помоћници су увек љубазни и од помоћи. Топло га препоручујем. Огромне похвале! 🤗🤗', NULL, NULL, 'Ich habe meinen Oberkiefer mit 5 Implantaten machen lassen. Super Arbeit. Ein super Zahnarzt. Die Schwestern sind immer freundlich und hilfsbereit. Ich kann ihn mit💯👍weiterempfehlen. Ganz großes Lob 🤗🤗', NULL,
    0, '2025-04-28 12:01:53'),

(@user_jelena_jokic_dobrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNicE5iZGtRRRAB',
    1, 'bs', 'Jako bezobrazno i nekulturno! Žena se javila na telefon i rekla da mora da proveri da li doktor može da nas primi i javlja se za 2 minuta. Nije zvala ni za 20 minuta a kada sam ponovo zvala ordinaciju nije se niko javljao na telefon. Jako je čudno bilo i pitanje ODAKLE STE VI???',
    'Veoma grubo i nepristojno! Žena se javila na telefon i rekla da mora da proveri da li doktor može da nas primi i da će pozvati za 2 minuta. Nije se javila 20 minuta, a kada sam ponovo pozvala ordinaciju, niko se nije javio na telefon. Pitanje ODAKLE STE??? je takođe bilo veoma čudno.', 'Веома грубо и непристојно! Жена се јавила на телефон и рекла да мора да провери да ли доктор може да нас прими и да ће позвати за 2 минута. Није се јавила 20 минута, а када сам поново позвала ординацију, нико се није јавио на телефон. Питање ОДАКЛЕ СТЕ??? је такође било веома чудно.', NULL, NULL, NULL, NULL,
    0, '2024-07-23 13:52:35'),

(@user_behudina_alic, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3d2FhVWNBEAE',
    5, 'bs', 'Hvala sto ste izasli u susret i sve pohvale za ljubaznost i profesionalnost,uljepsali ste mi ljetovanje hvala vam 🥇pozdrav od sarajlija',
    'Hvala na gostoprimstvu i sve pohvale za ljubaznost i profesionalnost, ulepšali ste mi letovanje, hvala 🥇 pozdrav iz Sarajeva', 'Хвала на гостопримству и све похвале за љубазност и професионалност, улепшали сте ми летовање, хвала 🥇 поздрав из Сарајева', NULL, NULL, NULL, NULL,
    0, '2024-08-16 09:01:21'),

(@user_mark_pej, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/Ci9DQUlRQUNvZENodHljRjlvT25FeFZVOXNjMUZTVkRseWJtTnFOa3B1ZGtKelVWRRAB',
    5, 'bs', 'Da ima 10 zvezdica to bi bilo. Usluga više nego profesionalna a cena simbolična!',
    'Da ima 10 zvezdica to bi bilo. Usluga više nego profesionalna a cena simbolična!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_alim_truma, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4RGFtaHRTVzlRUkVSRk4wdFFTVTVCVW5CU1RVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_sead_salihovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSWlNHMTNkWGhuT1cxMk0xZHFORFUwU1dsaVVrRRAB',
    5, 'en', 'Great staff, done several fillings and cleanings there, nice young doctor! All the best from Sead!',
    NULL, NULL, 'Great staff, done several fillings and cleanings there, nice young doctor! All the best from Sead!', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_armin_huric, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChdDSUhNMG9nS0VJQ0FnTURBckk3WF9RRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marko_danetovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChZDSUhNMG9nS0VJQ0FnSURKenBfak53EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_mare, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1emU3X0JnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_nina_cirovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxaDlPb0J3EAE',
    5, 'hr', 'Большой!!!',
    'Большой!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_nataa, @clinic_id, NULL, 'google_maps',
    'places/ChIJSXExDCITThMRP9seBhnncR8/reviews/ChdDSUhNMG9nS0VJQ0FnSUN5NjdiZi1RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
