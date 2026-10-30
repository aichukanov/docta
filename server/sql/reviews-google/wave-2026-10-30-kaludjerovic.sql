-- Insert Google Maps reviews for ORDINACIJA DR KALUDJEROVIC
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/wave-2026-10-30-kaludjerovic.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-dr-kaludjerovic-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_velimir_kaludjerovic = (SELECT id FROM doctors WHERE slug = 'velimir-kaludjerovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Janković', 'https://lh3.googleusercontent.com/a-/ALV-UjUP66rg_nTfXlT2cdxUxUt7e_qC8nkMCMnYD6RzLNuLBhVgH4Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114878341372404774503/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114878341372404774503/reviews');
SET @user_nikola_jankovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114878341372404774503/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoran Bojanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJU_LIyycrHxTzsxQ1aCp95bWvLqmRWItk5Rj7tFMfo4cCg-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114222919326324236112/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114222919326324236112/reviews');
SET @user_zoran_bojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114222919326324236112/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'perko todorovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV-2xK6OnG0pV-wpG0z6unSVaMhRokrfDOrF_4oLoEkk7DN_EyNJQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104759311569424345814/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104759311569424345814/reviews');
SET @user_perko_todorovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104759311569424345814/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danica Lakovic', 'https://lh3.googleusercontent.com/a/ACg8ocJbqI--eYtjaF1Rc6_IWJ3oz_j9r-vAtIdsfQ1XWiHTY9HFyw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117381627421161906098/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117381627421161906098/reviews');
SET @user_danica_lakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117381627421161906098/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Zivaljevic', 'https://lh3.googleusercontent.com/a/ACg8ocK25nhLLAHizcCNrJ-_5UO_VqApgFaxpgjq-MFlASpQoc3q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105568304998735308941/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105568304998735308941/reviews');
SET @user_nikola_zivaljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105568304998735308941/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Kaludjerovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUbDtW1Q25wxDZVbKQ4F1_9DqXXNaDgxPt59zR_bM46wedJoTSz=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118283255267746687485/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118283255267746687485/reviews');
SET @user_maja_kaludjerovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118283255267746687485/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ognjen Kaludjerovic', 'https://lh3.googleusercontent.com/a/ACg8ocKvJ6QeaZwvmxFgNaGnK7NnLvsLh0wTrup9uAqKmSCuOCjg-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113819984734603542326/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113819984734603542326/reviews');
SET @user_ognjen_kaludjerovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113819984734603542326/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mateja', 'https://lh3.googleusercontent.com/a/ACg8ocII2dn7fFvUiDOFWcrtZp-TCJdTbWlA6pQ0SCjVyQe746IO4w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114630149176988912656/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114630149176988912656/reviews');
SET @user_mateja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114630149176988912656/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Balsa Joncic', 'https://lh3.googleusercontent.com/a-/ALV-UjUWLtbyITjEjikUheQhItXTDW0RIv89QrZpmtJOZmhp5ACV-y_7=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109329802798535094350/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109329802798535094350/reviews');
SET @user_balsa_joncic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109329802798535094350/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'hanna lovre', 'https://lh3.googleusercontent.com/a/ACg8ocKbI0-DBoUC1BRjc-Mdht8v-wtBowL62Gpcs5j_xZJWW6Fn4g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111307707616117985892/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111307707616117985892/reviews');
SET @user_hanna_lovre = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111307707616117985892/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Endorphinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX9zyLld97zCwgczoq3gUxRJL8EvcuJ17oOn3mujsx16CrxrSiq-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106982216600350502697/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106982216600350502697/reviews');
SET @user_milan_endorphinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106982216600350502697/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Raspopovic', 'https://lh3.googleusercontent.com/a/ACg8ocJYAiLZjust9GgU1Ko0VRxVRm4HdhJzAZ2s8U_AnYnZ8doW5Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115992859962626294852/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115992859962626294852/reviews');
SET @user_maja_raspopovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115992859962626294852/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Kankaras', 'https://lh3.googleusercontent.com/a/ACg8ocIH3rLCaZqOBWqvmrV8JwQPFV0nySHtRhbfVXmEE5fqSsjXnQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109501881984322745977/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109501881984322745977/reviews');
SET @user_ksenija_kankaras = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109501881984322745977/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'M', 'https://lh3.googleusercontent.com/a/ACg8ocJ5iFxCVgD_QxjSqABMzE-zbFKEQfbDkWZxNOuWDT0zjn3ufg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104457422112889593340/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104457422112889593340/reviews');
SET @user_user_104457422112889593340 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104457422112889593340/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nemanja Crna Gora', 'https://lh3.googleusercontent.com/a/ACg8ocKnIu5t7ldf1TKr43iy1AKh8HEnD8JYOyupl0QwXRmN_3iKZg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115774797223866637134/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115774797223866637134/reviews');
SET @user_nemanja_crna_gora = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115774797223866637134/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'A D', 'https://lh3.googleusercontent.com/a/ACg8ocKFMTbeIzjTp2Xu2Bs9ZfckdrnnUoQTBmW0J66W7BFFqGqtk8o=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112269388182933338138/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112269388182933338138/reviews');
SET @user_a_d = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112269388182933338138/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Krsto Kovacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXQAokcjXFLo-VzLb61-E2RXtuOj2h7F3aroyNUtAFr-OuMRviE3Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100954268948958954129/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100954268948958954129/reviews');
SET @user_krsto_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100954268948958954129/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Malek Masarani', 'https://lh3.googleusercontent.com/a-/ALV-UjWOdvQVAMetzyzA6iuIIvfRUydhH-bJKnZ2g62DEeeqz_9RhgNl=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102453635723931494768/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102453635723931494768/reviews');
SET @user_malek_masarani = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102453635723931494768/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kosta Mijuskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUTNBCHYciHIOBNIbEBVOeYudEDzs815OwxnQED77U0ZHWgwwI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111400595602888058506/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111400595602888058506/reviews');
SET @user_kosta_mijuskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111400595602888058506/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Blagoje Jankovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVjY2Ue5GLLWgJjkV-FbNwbxQfO0KBqOl38Q4sj0kDlFYD7YIME=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112128596608426549208/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112128596608426549208/reviews');
SET @user_blagoje_jankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112128596608426549208/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Jokovic', 'https://lh3.googleusercontent.com/a/ACg8ocJvVDpyNnb9vrHk8QGwMLu3zFBHUBrhC_ThUu8NSRyzjfAc4g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115313134724497154603/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115313134724497154603/reviews');
SET @user_dejan_jokovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115313134724497154603/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Taric TheGemKnight', 'https://lh3.googleusercontent.com/a-/ALV-UjW7c0NSTSus3q8G1qbc-Yir4aBvVHqCLXPHfCMcpLaNIHVxEN0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106632593798696382701/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106632593798696382701/reviews');
SET @user_taric_thegemknight = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106632593798696382701/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mini Traveler', 'https://lh3.googleusercontent.com/a-/ALV-UjVDyYZzCvNevTwoG0_Y7aLSgvtuEv_mW3mRXm05T3m7_M-tkNY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108575166845021575243/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108575166845021575243/reviews');
SET @user_mini_traveler = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108575166845021575243/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Coco Chanel 007', 'https://lh3.googleusercontent.com/a/ACg8ocJlLGlCqAYc4elB15HSUgz_IdbI2isO4ziwC3MWwFwJ_-h-9g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117233578480845397523/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117233578480845397523/reviews');
SET @user_coco_chanel_007 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117233578480845397523/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matija-Milic Vojinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW21UATK6NYu_w2iK7Dilq5Yry1Bbqp0RmZv1HIloVX69CS1grC=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101159023265279631753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101159023265279631753/reviews');
SET @user_matijamilic_vojinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101159023265279631753/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKU20WJ_qNoo4NxohIoBgWbcjThG3OcryHUA7Fp5uczEeLc3g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114570568077677326657/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114570568077677326657/reviews');
SET @user_jovan_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114570568077677326657/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mijatovic Milos', 'https://lh3.googleusercontent.com/a/ACg8ocKfJ3miRryYa9PimIrNZ0ZnESyS8AOGq9JfeaYA2GCiklfDpA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100863511696949088167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100863511696949088167/reviews');
SET @user_mijatovic_milos = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100863511696949088167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'aleksandra radetić', 'https://lh3.googleusercontent.com/a-/ALV-UjW2BtDWBDuNjElNX2PGAjnLV_1r1oNOgFRycT_gA23cQEogMPVY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101953325282031730413/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101953325282031730413/reviews');
SET @user_aleksandra_radeti = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101953325282031730413/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rade Gardasevic', 'https://lh3.googleusercontent.com/a/ACg8ocJXBMLCel04FLvf9WXkOtqHTCvNbwhOnrakgdpc_gKHpgHe-w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105684841247110390484/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105684841247110390484/reviews');
SET @user_rade_gardasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105684841247110390484/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'whoopty doo', 'https://lh3.googleusercontent.com/a-/ALV-UjXRr1uZAO3wJCntkady17yDrq69VhdBgTJvu03VNa61olF6wBBU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105363170296176932868/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105363170296176932868/reviews');
SET @user_whoopty_doo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105363170296176932868/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alo Alo', 'https://lh3.googleusercontent.com/a/ACg8ocItzI7fw4KhECt9fCBqa6tIwdyjJIO8_ugBfK9iIH-hmG8LIQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107071673421233901382/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107071673421233901382/reviews');
SET @user_alo_alo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107071673421233901382/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_nikola_jankovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkS2J5MWtXVzFoTjJKeGQzVjNNRFZZUTB4M2FGRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-30 00:00:00'),

(@user_zoran_bojanovic, @clinic_id, @doctor_velimir_kaludjerovic, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KbmRtOXVaMDlyU25kMWR6VlZRazVDTURSdWVuYxAB',
    5, 'hr', 'Sve pohvale za dr. Kaludjerovica,
veliki profesionalac u svom poslu .',
    'Sve pohvale za dr. Kaludjerovica,
veliki profesionalac u svom poslu .', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-30 00:00:00'),

(@user_perko_todorovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VLYlZzTlNUdGE2dGRBEAE',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-30 00:00:00'),

(@user_danica_lakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnMHNxNUNnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-30 00:00:00'),

(@user_nikola_zivaljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzeWN2a3F3RRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-30 00:00:00'),

(@user_maja_kaludjerovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSURuMW9ISkpREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-30 00:00:00'),

(@user_ognjen_kaludjerovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURuNXNhNjhBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-30 00:00:00'),

(@user_mateja, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURuNXVyaXBBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-30 00:00:00'),

(@user_balsa_joncic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3cTQyVm5BRRAB',
    5, 'hr', 'Najbolji doktor',
    'Najbolji doktor', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-30 00:00:00'),

(@user_hanna_lovre, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURiOXFTRHFRRRAB',
    1, 'hr', 'UZASAN DOKTOR, LUPA DIJAGNOZE',
    'UZASAN DOKTOR, LUPA DIJAGNOZE', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-30 00:00:00'),

(@user_milan_endorphinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNyeGY2MzZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-30 00:00:00'),

(@user_maja_raspopovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURMdTZ1WG1nRRAB',
    1, 'hr', 'Drski i neljubazni',
    'Drski i neljubazni', NULL, NULL, NULL, NULL, NULL,
    2, '2024-10-30 00:00:00'),

(@user_ksenija_kankaras, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNObDdidnRBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-30 00:00:00'),

(@user_user_104457422112889593340, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ1dTRpOXJnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-30 00:00:00'),

(@user_nemanja_crna_gora, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR4X2RYeXJnRRAB',
    1, 'hr', 'Uzasan doktor samo pare da uzme !
Nikako ne ici kod njega!
Ali nikako!',
    'Uzasan doktor samo pare da uzme !
Nikako ne ici kod njega!
Ali nikako!', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-30 00:00:00'),

(@user_a_d, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUR4NUtyQjdnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-30 00:00:00'),

(@user_krsto_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4cmRYLWRnEAE',
    1, 'en', 'For so many years of experience, much more is expected. we won\'t talk about the details...',
    NULL, NULL, 'For so many years of experience, much more is expected. we won\'t talk about the details...', NULL, NULL, NULL,
    2, '2023-10-30 00:00:00'),

(@user_malek_masarani, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNSOHJpdi1BRRAB',
    1, 'hr', 'Neznanje, toliko....',
    'Neznanje, toliko....', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-30 00:00:00'),

(@user_kosta_mijuskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURtNk8yU253RRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-30 00:00:00'),

(@user_blagoje_jankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtbmFTRDFnRRAB',
    5, 'bs', 'Sve najbolje , svaka čast doktoru na ljubaznošću , humanosti i profesionalnosti.
Jedan čist primjer poštovanja Hipokratove zakletve i poštovanje pacijenta',
    'Sve najbolje , svaka čast doktoru na ljubaznošću , humanosti i profesionalnosti.
Jedan čist primjer poštovanja Hipokratove zakletve i poštovanje pacijenta', NULL, NULL, NULL, NULL, NULL,
    6, '2022-10-30 00:00:00'),

(@user_dejan_jokovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhdXItcTFnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-30 00:00:00'),

(@user_taric_thegemknight, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURxbWVMTjdnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-30 00:00:00'),

(@user_mini_traveler, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5dThDNERBEAE',
    5, 'bs', 'Doktor koji je jako strucan i koji mi je pomogao da riješim dosta dermatoloskih problema davne 2014 godine, doktor kojeg svima preporučujem.',
    'Doktor koji je jako strucan i koji mi je pomogao da riješim dosta dermatoloskih problema davne 2014 godine, doktor kojeg svima preporučujem.', NULL, NULL, NULL, NULL, NULL,
    3, '2021-10-30 00:00:00'),

(@user_coco_chanel_007, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSURpbXE3cVpnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-30 00:00:00'),

(@user_matijamilic_vojinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSUNNbDdfc2ZnEAE',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-30 00:00:00'),

(@user_jovan_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSUNFMDUyS2hRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-30 00:00:00'),

(@user_mijatovic_milos, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSURnNzRYZ2N3EAE',
    5, 'de', 'Top doktor',
    NULL, NULL, NULL, NULL, 'Top doktor', NULL,
    5, '2018-10-30 00:00:00'),

(@user_aleksandra_radeti, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURnc052bWlBRRAB',
    5, 'hr', 'Visok nivo strucnosti,ljubaznosti.
Hvala Vam za sve!',
    'Visok nivo strucnosti,ljubaznosti.
Hvala Vam za sve!', NULL, NULL, NULL, NULL, NULL,
    7, '2018-10-30 00:00:00'),

(@user_rade_gardasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChdDSUhNMG9nS0VJQ0FnSURBdWZlSi1RRRAB',
    4, 'bs', 'Rijetko dobar doktor, sve preporuke, odličan doktor',
    'Rijetko dobar doktor, sve preporuke, odličan doktor', NULL, NULL, NULL, NULL, NULL,
    3, '2018-10-30 00:00:00'),

(@user_whoopty_doo, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3NGRYaE1nEAE',
    5, 'hr', 'Sve  pohvale.',
    'Sve  pohvale.', NULL, NULL, NULL, NULL, NULL,
    4, '2018-10-30 00:00:00'),

(@user_alo_alo, @clinic_id, NULL, 'google_maps',
    'places/ChIJuQhy-znrTRMRvowiO4-vZg0/reviews/ChZDSUhNMG9nS0VJQ0FnSURnaFozelVREAE',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-30 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
