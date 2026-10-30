-- Insert Google Maps reviews for Hospital
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/opsta-bolnica-bijelo-polje.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-bijelo-polje');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Schepan Mali', 'https://lh3.googleusercontent.com/a/ACg8ocLug4lWII4gFkhMTg5HWSfEWIwXGffF2sMJ7vmQwwGKBXOg0Tix=s128-c0x00000000-cc-rp-mo-ba6', 'https://www.google.com/maps/contrib/116944437927069739601/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116944437927069739601/reviews');
SET @user_schepan_mali = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116944437927069739601/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Admir Sabotic', 'https://lh3.googleusercontent.com/a-/ALV-UjUEbxK0HYmnlsRlAvcgc3HY0Ciq9PPn58bXI8Hc4JSdvqK33dHo=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/117765373280393429735/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117765373280393429735/reviews');
SET @user_admir_sabotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117765373280393429735/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zivomir Radosavljevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUJH1VThG17aMVTdfuF-ijep2NAjoRBCK6SyuwyTamDIG3nDdCLsA=s128-c0x00000000-cc-rp-mo-ba7', 'https://www.google.com/maps/contrib/117391198243044826092/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117391198243044826092/reviews');
SET @user_zivomir_radosavljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117391198243044826092/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dacho PG', 'https://lh3.googleusercontent.com/a/ACg8ocKHr7TuhbQme_0UkIbzEut07A8HTPQvkn6XXIxNN1V00esIllPQ=s128-c0x00000000-cc-rp-mo-ba6', 'https://www.google.com/maps/contrib/117786931075400799617/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117786931075400799617/reviews');
SET @user_dacho_pg = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117786931075400799617/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Obradović', 'https://lh3.googleusercontent.com/a-/ALV-UjUtwhrhRoCrcqMFbXeCOvkofgB7dKn3M3T1Iwa9O9ZcFsON0AHGng=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/107151327531579123046/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107151327531579123046/reviews');
SET @user_nina_obradovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107151327531579123046/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'κωστας λιοντος', 'https://lh3.googleusercontent.com/a-/ALV-UjXyTOrv0HomYz4AY5q-VFQdiPpgutP4VYM_4Ef_ls3MwVNn8EJC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115820063863998959190/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115820063863998959190/reviews');
SET @user_user_115820063863998959190 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115820063863998959190/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zarko Popović', 'https://lh3.googleusercontent.com/a/ACg8ocKQS1ipIUphyHrOOEXL5zGnhFDRyiqxZcLAPYdw1VxcEgEyyQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118022706417307065951/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118022706417307065951/reviews');
SET @user_zarko_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118022706417307065951/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marinko Bozovic', 'https://lh3.googleusercontent.com/a/ACg8ocJZd66UXYI71VXYwEzI5T9CFArW-kTY2ckSzUswmIm5uPQ-ig=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113810363184176102468/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113810363184176102468/reviews');
SET @user_marinko_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113810363184176102468/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'vasa voji', 'https://lh3.googleusercontent.com/a/ACg8ocIJs8hImDVHt666jnG0y_lTj0Rp0_DZUtbhGkSvBtQWpMT-qw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109507837009553006572/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109507837009553006572/reviews');
SET @user_vasa_voji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109507837009553006572/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dzenan Gredic', 'https://lh3.googleusercontent.com/a/ACg8ocJ_L2jtWll739IsaBYznrSMMsa2iX2RqREqo3CM0MCRdcBfSQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100012082901055494981/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100012082901055494981/reviews');
SET @user_dzenan_gredic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100012082901055494981/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Nikolić', 'https://lh3.googleusercontent.com/a-/ALV-UjWZKeB3MMzN9BmPS6ls1qoP4w34YIO6zavBAkUEGWdQD4HCL5Zi=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116845080373112643555/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116845080373112643555/reviews');
SET @user_dragan_nikoli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116845080373112643555/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'SA HD', 'https://lh3.googleusercontent.com/a-/ALV-UjVcdufJs4QMrCdZ8plmZCOO6W2zG-crzlLhoak_-Kzv8PI1i2sGqg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106743058626301228517/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106743058626301228517/reviews');
SET @user_sa_hd = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106743058626301228517/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ribnica commrece Servis', 'https://lh3.googleusercontent.com/a-/ALV-UjUov2w-hx8xGFisf8fBM0Q2kdf1yyvsD2TliC63OJZGsHccRTQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112700549810214457184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112700549810214457184/reviews');
SET @user_ribnica_commrece_servis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112700549810214457184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'slavko vujicic', 'https://lh3.googleusercontent.com/a-/ALV-UjWOyMtLu_9E3a5lL1Aiq5DK6ZE7g7SjaBE-JpJ38rIIQzkxxDB0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104699056549757811373/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104699056549757811373/reviews');
SET @user_slavko_vujicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104699056549757811373/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S Mil', 'https://lh3.googleusercontent.com/a/ACg8ocLb2dCf6Botr3y6AgVb55JWyO4x8sSyeRqv70OetYz1hG2rtg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116956021278474015875/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116956021278474015875/reviews');
SET @user_s_mil = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116956021278474015875/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olja Nedovic', 'https://lh3.googleusercontent.com/a/ACg8ocKnM2D8WSIVrmO6h6jaIzYyKvwGdt7iPWF4HfNvB6H_XyG_zQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101211800860233203810/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101211800860233203810/reviews');
SET @user_olja_nedovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101211800860233203810/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Radanovic', 'https://lh3.googleusercontent.com/a/ACg8ocI6_Se4EhKCK-k6l7zQu_wx5-gTqZmVtP-Y51CGKhigfV3_SA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101359851454737972105/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101359851454737972105/reviews');
SET @user_marko_radanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101359851454737972105/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alija Carovac', 'https://lh3.googleusercontent.com/a-/ALV-UjUHKRmUxb7IzInpDZl5mw88PW-nR1UjVIgJ5tXT-iu-UzTODUeH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111246886042908799613/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111246886042908799613/reviews');
SET @user_alija_carovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111246886042908799613/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Armin Spahic', 'https://lh3.googleusercontent.com/a-/ALV-UjWQybR2pzpgjK2dkr5QacLIiUGaeLogM5eL9d4DwDIfEo2wNIt4=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106522271778075579729/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106522271778075579729/reviews');
SET @user_armin_spahic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106522271778075579729/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Schepan Mali', 'https://lh3.googleusercontent.com/a-/ALV-UjXQ6BfEiGZvHJAut1KiQQ5qrFxBX4_v95jY40JD0QPLrxYa4AA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117481444814074557956/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117481444814074557956/reviews');
SET @user_schepan_mali_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117481444814074557956/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mario Bozovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW2ykr1GWL4FnaYzbqDIudvJVWERgWKZSvCN8_QzIDA3SA8lygc=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107725059191124810373/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107725059191124810373/reviews');
SET @user_mario_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107725059191124810373/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_schepan_mali, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRbkpLVnBRRRAB',
    1, 'sr', 'Хигијена је катастрофална.',
    'Higijena je katastrofalna.', 'Хигијена је катастрофална.', NULL, NULL, NULL, NULL,
    4, '2018-09-14 19:40:19'),

(@user_admir_sabotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1eExianVnRRAB',
    4, 'bs', 'Dr. Erovic je preporodio Bolnicu, dokle su bivši menadžmenti pljačkali i kupovali stanove po Beogradu, konačno imamo pravog domaćina na čelu menadžmenta☝️',
    'Dr Erović je oživeo Bolnicu, dok je bivša uprava pljačkala i kupovala stanove po Beogradu, konačno imamo pravog domaćina na čelu uprave☝', 'Др Еровић је оживео Болницу, док је бивша управа пљачкала и куповала станове по Београду, коначно имамо правог домаћина на челу управе☝', NULL, NULL, NULL, NULL,
    1, '2022-07-21 06:07:13'),

(@user_zivomir_radosavljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlNmUtSjl3RRAB',
    5, 'bs', 'Dobra lokacija, sređen sa dobrim enterijerom, usluga na nivou',
    'Dobra lokacija, dobro opremljen sa dobrim enterijerom, vrhunska usluga', 'Добра локација, добро опремљен са добрим ентеријером, врхунска услуга', NULL, NULL, NULL, NULL,
    1, '2022-09-17 22:15:46'),

(@user_dacho_pg, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM5emFlakt3EAE',
    5, 'hr', 'Veoma ljubazno osoblje',
    'Veoma ljubazno osoblje', 'Веома љубазно особље', NULL, NULL, NULL, NULL,
    0, '2024-03-08 09:29:20'),

(@user_nina_obradovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSURuOEtXeXpRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-02 11:31:19'),

(@user_user_115820063863998959190, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25adlIycEdNbk5wV0RJNGRsbEJiRm94ZUVRMmMzYxAB',
    5, 'el', 'Μπράβο στην νευρολόγο του νοσοκομείου',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_zarko_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poU2RVNXRPRmd4TkV0ME4zcFFURUpNY3kxNWRHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_marinko_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xObE9WRkhTaTFWVXpaaGIxSmxaMmxPZW5oalZVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_vasa_voji, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SM1NtMDRXV2hJVFdOTWRYTnNObnAzTUhweGNFRRAB',
    5, 'en', 'Toptop',
    NULL, NULL, 'Toptop', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_dzenan_gredic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxRlpWUnJkMHhtVVZnM1UxUk1ZelpUTVhCWkxWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_dragan_nikoli, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUNXBLcjB3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sa_hd, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChZDSUhNMG9nS0VJQ0FnSURqbl9TV0pnEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ribnica_commrece_servis, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNOX2NUNXZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_slavko_vujicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNPbzlUcmhnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_s_mil, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyMDhDd2lRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_olja_nedovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzdjUybmxnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_marko_radanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChZDSUhNMG9nS0VJQ0FnSURJeGJUVUJ3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_alija_carovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNndWFXODFnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_armin_spahic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNneDZIVm5RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_schepan_mali_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSURnNGFHYndRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_mario_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJOXECWmmjUhMRSgaJ691GRqo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3cmFIWHZRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
