-- Insert Google Maps reviews for Opšta bolnica Nikšić
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/opsta-bolnica-niksic.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-niksic');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Draskovic', 'https://lh3.googleusercontent.com/a/ACg8ocLIbCcOmSgVWOLLoPzFkhQfpzv-N-x5KXNN6RCLfltDWJVRmYs=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115939394583809380996/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115939394583809380996/reviews');
SET @user_ksenija_draskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115939394583809380996/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Bečić', 'https://lh3.googleusercontent.com/a-/ALV-UjXjPj5LGuup6SIXkt3SJ6afh_gKjcxQxWKLfT7EAhIx-2pVRIPO=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107149820974647933249/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107149820974647933249/reviews');
SET @user_ana_bei = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107149820974647933249/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana', 'https://lh3.googleusercontent.com/a/ACg8ocI0syl4j9g3DsKqgx01sKi2kixkdBB79T3hm2aCx2_K6ERxIQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110630498923096358125/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110630498923096358125/reviews');
SET @user_ivana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110630498923096358125/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Niki', 'https://lh3.googleusercontent.com/a-/ALV-UjXu7XgOORPLymCNEZoOcUMPXBs7KMlNIAyFn1j744O8tBNamTzq=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116666938063001502846/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116666938063001502846/reviews');
SET @user_niki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116666938063001502846/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alba Caka', 'https://lh3.googleusercontent.com/a-/ALV-UjVyl_HpcL01EiThXnOon5ySAozQ8QMvWfyieNZtcgXtRmP4DCbf=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/110157267131655033178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110157267131655033178/reviews');
SET @user_alba_caka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110157267131655033178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Thalie', 'https://lh3.googleusercontent.com/a/ACg8ocLIUaIPQOGZPb1sZCO70NwQbQHCSY8FiGEg3HmxHsGRilDOpg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116725135465348967280/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116725135465348967280/reviews');
SET @user_thalie = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116725135465348967280/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anđela Zweigel', 'https://lh3.googleusercontent.com/a-/ALV-UjWnai2JN2UqXrpGGMTVve8LYlfky3rztZd-_48QxDOOrsqHcvGMnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113165143001402940690/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113165143001402940690/reviews');
SET @user_anela_zweigel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113165143001402940690/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Philipp Zweigel', 'https://lh3.googleusercontent.com/a-/ALV-UjXo7nD-41HHAYdzPcvT_IxfM2PeZsMLQ8IzRzX9wCBSC7IBJ6U=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114786265735699637852/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114786265735699637852/reviews');
SET @user_philipp_zweigel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114786265735699637852/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Barbara Zakonović', 'https://lh3.googleusercontent.com/a/ACg8ocL5RyVkAu7UYGt4c0vF69pOxhEnIUJDyA13_d9Lh5g4exLLeA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111707294809375275912/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111707294809375275912/reviews');
SET @user_barbara_zakonovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111707294809375275912/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Krzysztof', 'https://lh3.googleusercontent.com/a/ACg8ocIUI77JRU4BN4OYrN-7eg-dz1fa_RyspxElWZq_F2tTWGsYpw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108515186775148712808/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108515186775148712808/reviews');
SET @user_krzysztof = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108515186775148712808/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Pekovic', 'https://lh3.googleusercontent.com/a/ACg8ocJyLZWjCwfFDjre46jQEj7U8tKkzoh5mHlkGv8HKvclZ_P0dA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107719227304053656161/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107719227304053656161/reviews');
SET @user_marko_pekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107719227304053656161/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana K', 'https://lh3.googleusercontent.com/a-/ALV-UjUHmKTobKd-BmL2DvkjhqFM-35HK5fpu0w7A7wXD8LrXYCa9yAS=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112222164204891755482/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112222164204891755482/reviews');
SET @user_ana_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112222164204891755482/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Izzy Husar', 'https://lh3.googleusercontent.com/a-/ALV-UjXxmWrIedo3AxonmTWmrYtC-nnr1GYRSYkeXIoJlMBr7X39jbxQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104865386710254656201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104865386710254656201/reviews');
SET @user_izzy_husar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104865386710254656201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrija Glusica', 'https://lh3.googleusercontent.com/a/ACg8ocL1Y9f9E2Y_GaVJyqQEwjR6oG6nV2vglo1u1q6E7RM4j9If-a0=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105931906871931874698/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105931906871931874698/reviews');
SET @user_andrija_glusica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105931906871931874698/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Koprivica', 'https://lh3.googleusercontent.com/a/ACg8ocKeLQmvUyEdbSXR61X3zUis7vlIH6e8LQ_axfNSADEWTW9gJQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103808652952067732165/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103808652952067732165/reviews');
SET @user_maja_koprivica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103808652952067732165/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ksenija_draskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/ChZDSUhNMG9nS0VJQ0FnTUN3b08tSkFREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-15 23:01:58'),

(@user_ana_bei, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/ChZDSUhNMG9nS0VJQ0FnTURRcjhQbUFREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-15 12:20:52'),

(@user_ivana, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/ChdDSUhNMG9nS0VJQ0FnSURQOUl5ay1nRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-11-29 15:30:55'),

(@user_niki, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/ChdDSUhNMG9nS0VJQ0FnSUN6cThmMG9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-06-05 07:26:56'),

(@user_alba_caka, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/ChdDSUhNMG9nS0VJQ0FnSUREc0ptbm9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-04-04 17:09:16'),

(@user_thalie, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT210eFMwOVJSbkkxWjFwNWMzbFZhRmQwY2pkSU9WRRAB',
    1, 'en', 'Worst hospital I’ve ever gone too. And that’s saying a lot considering I’ve been stuck in hospital in multiple continents, including Africa. Nurses/doctors, especially from the second shift were extremely rude, didn’t want to answer my questions on my health status, basically just wanted to get my money and put us to the door. They didn’t even ask how I was feeling, kept telling them I hit my head really hard and didn’t want to give me a CT scan… a whole nightmare. And if that wasn’t enough, they called the police to drag us out of the hospital as I was still too weak to walk on my own, simply wanting to get a few questions answered on my medical state which they never bother to answer. Left the hospital in the same condition I came in. Worst worst experience EVER. Also had like 2-3 patients for 5-6 doctors so not like they were super busy… they found it funny and amusing that the police showed up to take us outside the hospital??? Never really checked to lower my fever has I was shivering almost the entire time I was there.. don’t go there!',
    NULL, NULL, 'Worst hospital I’ve ever gone too. And that’s saying a lot considering I’ve been stuck in hospital in multiple continents, including Africa. Nurses/doctors, especially from the second shift were extremely rude, didn’t want to answer my questions on my health status, basically just wanted to get my money and put us to the door. They didn’t even ask how I was feeling, kept telling them I hit my head really hard and didn’t want to give me a CT scan… a whole nightmare. And if that wasn’t enough, they called the police to drag us out of the hospital as I was still too weak to walk on my own, simply wanting to get a few questions answered on my medical state which they never bother to answer. Left the hospital in the same condition I came in. Worst worst experience EVER. Also had like 2-3 patients for 5-6 doctors so not like they were super busy… they found it funny and amusing that the police showed up to take us outside the hospital??? Never really checked to lower my fever has I was shivering almost the entire time I was there.. don’t go there!', NULL, NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_anela_zweigel, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaU2VsTlpSV3R3TWt0SldFOU5iazFXYzNwclNGRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_philipp_zweigel, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSbmRWWndhVU54VW1WcFUzZHdibUpYYkRCQlpWRRAB',
    1, 'de', 'Dieses Krankenhaus ist dreckig und unorganisiert. Sogar auf der Intensivstation und der Station für Herzerkrankungen war jeder Desinfektionsspender nicht nur leer, sondern ausgetrocknet. Selbst wenn man nach Desinfektionsmittel für die Hände fragt, sagen sie, dass sie nichts haben. Das sollte man eigentlich dem Gesundheitsamt melden. Und auch sonst herrscht da ein einziges Chaos. Essen steht auf einem Drucker (?), Dreck auf dem Boden und es ist einfach unhygienisch.
Wenn man in Nikšić krank werden sollte, sollte man besser auf eine Privatklinik ausweichen.  Aber Hauptsache man darf nicht mit kurzer Hose rein gehen. Lächerliche Standards werden dort gesetzt.',
    NULL, NULL, NULL, NULL, 'Dieses Krankenhaus ist dreckig und unorganisiert. Sogar auf der Intensivstation und der Station für Herzerkrankungen war jeder Desinfektionsspender nicht nur leer, sondern ausgetrocknet. Selbst wenn man nach Desinfektionsmittel für die Hände fragt, sagen sie, dass sie nichts haben. Das sollte man eigentlich dem Gesundheitsamt melden. Und auch sonst herrscht da ein einziges Chaos. Essen steht auf einem Drucker (?), Dreck auf dem Boden und es ist einfach unhygienisch.
Wenn man in Nikšić krank werden sollte, sollte man besser auf eine Privatklinik ausweichen.  Aber Hauptsache man darf nicht mit kurzer Hose rein gehen. Lächerliche Standards werden dort gesetzt.', NULL,
    0, '2026-08-29 00:00:00'),

(@user_barbara_zakonovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOUlNIb3laMmd0T0ROaGFsVjFiRWd6UlVad1NIYxAB',
    5, 'sr', 'Хирургија-Све похвале за цијели тим,спасили су нам живот
Велики поздрав из Добоја',
    'Hirurgija-Sve pohvale za cijeli tim,spasili su nam život
Veliki pozdrav iz Doboja', 'Хирургија-Све похвале за цијели тим,спасили су нам живот
Велики поздрав из Добоја', NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_krzysztof, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xNNFVHUlBNSHBxZUVSTWREaEplSEppU0c1WmVFRRAB',
    5, 'pl', 'Bardzo dobra i miła obsługa anglojęzyczna. Badania po wypadku wykonane błyskawicznie, trochę długie oczekiwanie na lekarza ortopedę na ostrym dyżurze. Ogólnie bardzo dobrze',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_marko_pekovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOTE0yeDBUelJGTW1kQ2MxOXhVWEJuYmw5b1kwRRAB',
    5, 'bs', 'Stvarno sramota sta rade,
Nikog nije bilo sat vremena sam ceko da me doktor primi, sve prebacuju sa jedne na druge
Ljepse je otići privatno platiti i odma zavrsiti',
    'Stvarno sramota sta rade,
Nikog nije bilo sat vremena sam ceko da me doktor primi, sve prebacuju sa jedne na druge
Ljepse je otići privatno platiti i odma zavrsiti', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_ana_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWdWRtaDRkVzVrUlRGYWRITnRWek5uWWtKMmMyYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_izzy_husar, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sR1QzZzNWbE15V1ZkRFZpMUxjV3B1WkhsR1FrRRAB',
    4, 'hr', 'Ortopedija-  osoblje stvarno daje max od sebe , glavna sestra Mira  je stvarno supper i ostali su stvarno top, bolnica kao bolnca sirom Cg u " rusevini" ali ljudi koje rade tamo za razliku od drugih ustanova stvarno imaju empatiju, strucnost i znanje , stvarno ima hvala',
    'Ortopedija-  osoblje stvarno daje max od sebe , glavna sestra Mira  je stvarno supper i ostali su stvarno top, bolnica kao bolnca sirom Cg u " rusevini" ali ljudi koje rade tamo za razliku od drugih ustanova stvarno imaju empatiju, strucnost i znanje , stvarno ima hvala', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_andrija_glusica, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GQ1RFcG9VVVp2V1V4cU4zRTVPRUV4Um1zM1NXYxAB',
    5, 'hr', 'Stvarno profesionalno i dobra atmosfera',
    'Stvarno profesionalno i dobra atmosfera', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_maja_koprivica, @clinic_id, NULL, 'google_maps',
    'places/ChIJDZZt00qpTRMRHp1jyxuYnes/reviews/ChZDSUhNMG9nS0VJQ0FnSUMxeXVpdFdREAE',
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
