-- Insert Google Maps reviews for Mela Sana
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-mela-sana-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-mela-sana-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_radomir_rakocevic = (SELECT id FROM doctors WHERE slug = 'radomir-rakocevic');
SET @doctor_nebojsa_brnovic = (SELECT id FROM doctors WHERE slug = 'nebojsa-brnovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Kojic', 'https://lh3.googleusercontent.com/a/ACg8ocIDX3QrQyphDCIoiOiwf4EpxHAPPcx3rQIoiVnWsdO5t5kY9w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110326788745386054597/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110326788745386054597/reviews');
SET @user_dejan_kojic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110326788745386054597/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Lekovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX3XAQEZa8FVNOnC1BR1mv8Q4aJjw0KIzUCryrjUOmbpK8zJs8=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/117217322701501016000/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117217322701501016000/reviews');
SET @user_andjela_lekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117217322701501016000/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragica Vučetić', 'https://lh3.googleusercontent.com/a-/ALV-UjWYRGV7srX3wKvdMN0RoHA7eCpeJMlnbkbPnDaoJ4IHlwktF-Pb2A=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115302193315403548395/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115302193315403548395/reviews');
SET @user_dragica_vueti = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115302193315403548395/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Milic', 'https://lh3.googleusercontent.com/a-/ALV-UjUfXlfa19qlKExh6JZV8h3t2Gy2aJwEXpr0h9MLY3KgPydGeLE=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117298846154851594462/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117298846154851594462/reviews');
SET @user_iva_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117298846154851594462/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S L', 'https://lh3.googleusercontent.com/a/ACg8ocJx78STan83AOq1_43aBK58-S7Z91YCuSORHCojzv-rxKp3jg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115781297803498262597/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115781297803498262597/reviews');
SET @user_s_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115781297803498262597/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIuVb2esNLRx389Z6xbJwRRkEF4urW7IJhT4b_MsovXt_eRhg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107191170081057832184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');
SET @user_marko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nadja kazic', 'https://lh3.googleusercontent.com/a/ACg8ocIfqkHyPicFdHZvmeC9dVM7u7IT9x2ithA1Ay2Mvv7CWq0sgA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101262544062621899971/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101262544062621899971/reviews');
SET @user_nadja_kazic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101262544062621899971/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Јован Чобановић', 'https://lh3.googleusercontent.com/a-/ALV-UjX2wTxZ5Yvn_Po6mzsCGG98yFxYnGypjzJAgZ7ipyqpgCYx9Oxh=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104474609978444155385/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104474609978444155385/reviews');
SET @user_jovan_chobanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104474609978444155385/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Pajovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW1K6UYovv56mbsvkUGaHzz2QYXqM27kCDFi1V9oj8mHxWu2OqJ7g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110774500129256726544/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110774500129256726544/reviews');
SET @user_nikola_pajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110774500129256726544/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Iv', 'https://lh3.googleusercontent.com/a-/ALV-UjUD9wEXWyAzTJsjXodoMBRGqT-g5M17upCaGxqe5D1QjDC-0Gvt=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115384152764946736754/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115384152764946736754/reviews');
SET @user_jelena_iv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115384152764946736754/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Vujisic', 'https://lh3.googleusercontent.com/a-/ALV-UjW77UYCrgst82JfEn3hmPxnp1HqTpO04Kxyl2rNMK8pOWsv3CEA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107866594211529074510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107866594211529074510/reviews');
SET @user_ivana_vujisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107866594211529074510/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ayla Schaafs', 'https://lh3.googleusercontent.com/a-/ALV-UjXdqOn1aH2syziJrdjJv4jztVkD_EwicvyioLbZfLdaxVY4IWJ-=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101049611392175069852/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101049611392175069852/reviews');
SET @user_ayla_schaafs = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101049611392175069852/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Vujisic', 'https://lh3.googleusercontent.com/a/ACg8ocLRXMX3lVqaUzMpU5hzOSZajgtCCDin5aML9Td_7uigsPW0_A=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115661250006348311473/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115661250006348311473/reviews');
SET @user_dejan_vujisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115661250006348311473/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zanka Stankovic', 'https://lh3.googleusercontent.com/a/ACg8ocI-CSbHNDNp7PiIT_WWWGK4ZFtPhJEcEW2GRaKBxEHqJcr2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105228119362678027075/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105228119362678027075/reviews');
SET @user_zanka_stankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105228119362678027075/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ryan Carrera', 'https://lh3.googleusercontent.com/a-/ALV-UjUF_MZ2hS0D8sQZK93cgaV2-2CXjbc3-Dn1bRqfOYb_nQ07iouG=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108072046136810266850/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108072046136810266850/reviews');
SET @user_ryan_carrera = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108072046136810266850/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sokoly alfa', 'https://lh3.googleusercontent.com/a-/ALV-UjXf8Jp1zmEYKEAsTDWeEmXaVn4SM__kbkbNOPweA2mhSpo3Gi_s=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100748731272617296981/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100748731272617296981/reviews');
SET @user_sokoly_alfa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100748731272617296981/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Smislov pg', 'https://lh3.googleusercontent.com/a-/ALV-UjXB7tWpnAgJSVdZeDK3vOHMggmh4LccDjiGVx2lmgM4aM5VKVsw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102052143566777380764/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102052143566777380764/reviews');
SET @user_smislov_pg = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102052143566777380764/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Malenki jez', 'https://lh3.googleusercontent.com/a/ACg8ocLV5d8PfAkaSx8nDnxPfC3bu_kfVZcUBlYwUUMgVzrjU-x8vw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116300650682066473212/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116300650682066473212/reviews');
SET @user_nina_malenki_jez = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116300650682066473212/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milorad Krusica', 'https://lh3.googleusercontent.com/a/ACg8ocKNe--ouFM22J1XSAe7VgrrKecoj1xGrN_kRIPRoMCaqjRO1w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105447625371643497910/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105447625371643497910/reviews');
SET @user_milorad_krusica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105447625371643497910/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Vukovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUOHiKKN_V0NSg4kSV8pVXxfraaGN9h6MJZlfVkKreTLyZARWNlrw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112985300068192380297/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112985300068192380297/reviews');
SET @user_ana_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112985300068192380297/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zana Bulatovic', 'https://lh3.googleusercontent.com/a/ACg8ocIQIX-tK8_rncEGkqMwLZo9ExXtC4iHIboV-eRVkak8tSVvDA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116973118247827552204/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116973118247827552204/reviews');
SET @user_zana_bulatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116973118247827552204/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svjetlana Kiehl', 'https://lh3.googleusercontent.com/a/ACg8ocIy8bUmUdoJe5GEgCWXCiDVdLkmUQzhQSVgdx8wKe22iCv9kA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100334976008268678353/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100334976008268678353/reviews');
SET @user_svjetlana_kiehl = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100334976008268678353/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bojana p', 'https://lh3.googleusercontent.com/a/ACg8ocKSCdARXhe1l0TJTOj7TnUV8mRJQzDDKUAll2EYe7KKI7T5cA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115396949860918211276/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115396949860918211276/reviews');
SET @user_bojana_p = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115396949860918211276/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Galic', 'https://lh3.googleusercontent.com/a/ACg8ocI2Zcato66Zs6JPMrjtntoa73NU3tZb8r_UPZD5wD8_9Sn9Gw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109467966406263578077/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109467966406263578077/reviews');
SET @user_maja_galic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109467966406263578077/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'A D', 'https://lh3.googleusercontent.com/a/ACg8ocK-k6lhBYnH54Y6tM0MF9-lVmFbuh7mgQ8-nHju25h6-EvWnjI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108191059648226524712/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108191059648226524712/reviews');
SET @user_a_d = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108191059648226524712/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_dejan_kojic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKeFExWldNM0owU1RrdFVIazFVa3R5Y25sVmRXYxAB',
    1, 'bs', 'Usluga kućne posjete radi uključivanja vitaminskih infuzija ne funkcioniše. Ne preporučujem.',
    'Usluga kućne posete koja uključuje vitaminske infuzije ne funkcioniše. ne preporučujem.', 'Услуга кућне посете која укључује витаминске инфузије не функционише. не препоручујем.', NULL, NULL, NULL, NULL,
    0, '2025-11-27 16:33:41'),

(@user_andjela_lekovic, @clinic_id, @doctor_radomir_rakocevic, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3cDYzLXd3RRAB',
    1, 'bs', 'Zakazala sam termin kod Doktora Radomira Rakocevica u 13:45 gdje me sekretarica zove u 13h i kaze da dodjemo ranije ili Doktor mora otkazati termin uz objasnjenje da je zavrsio ranije i da ne moze cekati.

Termin je otkazan, jer sekretarica ne moze da iskordinise sa doktorom da me sacekaju za pregled.

Jako neprofesionalno. Pregled nije odradjen.

Ne preporucujem zakazazivanje ovdje u Mela Sani kao ni kod Doktora Radomira Rakocevica.',
    'Zakazala sam termin kod Doktora Radomira Rakocevica u 13:45 gdje me sekretarica zove u 13h i kaze da dodjemo ranije ili Doktor mora otkazati termin uz objasnjenje da je zavrsio ranije i da ne moze cekati.

Termin je otkazan, jer sekretarica ne moze da iskordinise sa doktorom da me sacekaju za pregled.

Jako neprofesionalno. Pregled nije odradjen.

Ne preporucujem zakazazivanje ovdje u Mela Sani kao ni kod Doktora Radomira Rakocevica.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-08-29 11:02:27'),

(@user_dragica_vueti, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSURfMnRmWkZ3EAE',
    1, 'bs', 'Sramotan pristup dr radiologa prema pacijentu sa viskom kilograma!
Za istog 0 iz ljekarske profesije!',
    'Sraman pristup radiologa prema pacijentu sa prekomernom težinom!
0 od medicinske struke za isto!', 'Сраман приступ радиолога према пацијенту са прекомерном тежином!
0 од медицинске струке за исто!', NULL, NULL, NULL, NULL,
    0, '2025-01-23 14:56:28'),

(@user_iva_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkaVRYZHhjUzFxYWs5dExUbGFiVU5wT1Y4ME5sRRAB',
    3, 'hr', 'Srednja mediciska usluga .Prosjecna usluga.',
    'Srednja medicinska usluga. Prosečna usluga.', 'Средња медицинска услуга. Просечна услуга.', NULL, NULL, NULL, NULL,
    0, '2025-11-27 10:52:34'),

(@user_s_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNsZzlpaDJnRRAB',
    4, 'bs', 'Divni profesionalni ljekari, sa izuzetkom sestre koja odgovara na pozive, treba joj riječi kliještima iz usta vaditi',
    'Divni profesionalni lekari, sa izuzetkom medicinske sestre koja odgovara na pozive, njoj treba kleštima izvaditi reči iz usta.', 'Дивни професионални лекари, са изузетком медицинске сестре која одговара на позиве, њој треба клештима извадити речи из уста.', NULL, NULL, NULL, NULL,
    0, '2023-11-25 12:27:01'),

(@user_marko_milic, @clinic_id, @doctor_nebojsa_brnovic, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWUmMyaG1jRlI1Y0hKZllXSkplVk5mTFZsclkyYxAB',
    3, 'bs', 'Prosjecna usluga.Doktor Brnovic jako los doktor.',
    'Prosjecna usluga.Doktor Brnovic jako los doktor.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_nadja_kazic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1bmJVdDVVRUpPUjBob1RVYzJTRnBXY2tSRlEwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_jovan_chobanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tZeWVFSTBXV1ZEUm5wRVpVRnRkWFJSYjNaRmNHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_nikola_pajovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pNNVkxUkRjMGd5ZWpNMVR6aE9aemhRTlRaTWRsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_jelena_iv, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t3MU9XdDBia2R3YUhGaGFGUXRlVnBJUkVkbFMwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ivana_vujisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNYcW9xckVnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ayla_schaafs, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaUVUxQTNZamczV2pjM0xYWlNVSFJRVEdabloyYxAB',
    5, 'fr', 'Très accueillant et très professionnel personnelles...
Ils méritent ⭐️⭐️⭐️⭐️⭐️',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dejan_vujisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkSE1HZElPVjlhTW05TFZHRkVUVTVHTjJsa1ZIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_zanka_stankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psaVFqRnFYMHBoYlZCa2FUSlFXVTVmUkhsTlpGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ryan_carrera, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUMmZhZnR3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sokoly_alfa, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNEcFp6UVJnEAE',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_smislov_pg, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5Z3EtVGhRRRAB',
    5, 'hr', 'Vrlo profesionalni, strucni i ljubazni! Svaka preporuka',
    'Vrlo profesionalni, strucni i ljubazni! Svaka preporuka', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nina_malenki_jez, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSUMxaTZlT1d3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_milorad_krusica, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKZzRDY013EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_ana_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKc011Ty13RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_zana_bulatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSURPOS1uOEdREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_svjetlana_kiehl, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSURXMnRpZmJREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_bojana_p, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHN0pQRVhREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_maja_galic, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNLc1pUbHVBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_a_d, @clinic_id, NULL, 'google_maps',
    'places/ChIJz2FctqnrTRMRclWJwV6YtEM/reviews/ChZDSUhNMG9nS0VJQ0FnSURDOHNIUlp3EAE',
    5, 'hr', 'Ljubazno i stručno osoblje, vrlo prijatan ambijent. Sve preporuke!',
    'Ljubazno i stručno osoblje, vrlo prijatan ambijent. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    1, '2020-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
