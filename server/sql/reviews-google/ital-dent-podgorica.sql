-- Insert Google Maps reviews for Ital-Dent
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ital-dent-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ital-dent-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Claudia Colli', 'https://lh3.googleusercontent.com/a-/ALV-UjWrMR5iLketpCNnpafjndYxkwl34SVmnBl5AajCDu1lspObSG9YcA=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/115238857777744200681/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115238857777744200681/reviews');
SET @user_claudia_colli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115238857777744200681/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elifgamol', 'https://lh3.googleusercontent.com/a/ACg8ocIlybOy4g4EOCVqFotUSAnTFUmg9A4omrXkQB4ZtnhdwMSyGg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117299361394543911573/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117299361394543911573/reviews');
SET @user_elifgamol = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117299361394543911573/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dragana mirkovic', 'https://lh3.googleusercontent.com/a/ACg8ocISeXo2dfrX-jFws2ilfH4YEuu-GcZFMjaPdSXE8YjtLdoFzA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111979319770689023665/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111979319770689023665/reviews');
SET @user_dragana_mirkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111979319770689023665/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srecko Peralovic', 'https://lh3.googleusercontent.com/a/ACg8ocIQccl0MdjyI8erGD9mHsnPJvOZra6ziI0y8vnMHFjbu8Uqtg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113687329238017028950/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113687329238017028950/reviews');
SET @user_srecko_peralovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113687329238017028950/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stojanka Kikovic', 'https://lh3.googleusercontent.com/a/ACg8ocK_YJy2ksRCXr45G1F-nKhFVJVxVTq09M5Aj0fa3o5pYN_4UA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113434876779867266201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113434876779867266201/reviews');
SET @user_stojanka_kikovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113434876779867266201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Senada Omerbozovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVX3Utfkhr4nokAxwMRHDTy43-1Hok_tzlAvPWlVCb-NkEvFWNxXA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106634542390704764715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106634542390704764715/reviews');
SET @user_senada_omerbozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106634542390704764715/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_claudia_colli, @clinic_id, NULL, 'google_maps',
    'places/ChIJWZaIIQrrTRMRgnAL_yZDUcA/reviews/ChdDSUhNMG9nS0VJQ0FnSUMwdWZTa293RRAB',
    4, 'it', 'Mi riservo di cambiare valutazione nel caso uscirò da questo incubo dei denti... Capisco però chi non vuole andare dal dentista: tempo, soldi (tanti), dolore fisico e sofferenza psicologica... Edit: lo studio è "gemellato" con lo studio del dr Gaspare Sferrazza di Saronno: devo dire che la puntualità non va a loro favore',
    'Zadržavam pravo da promenim mišljenje ako se izvučem iz ove stomatološke noćne more... Međutim, razumem one koji ne žele da idu kod zubara: vreme, novac (mnogo), fizički bol i psihička patnja... Izmena: ordinacija je „pobratimljena“ sa ordinacijom dr Gasparea Ferace u Saronu: Moram reći da im tačnost ne ide u prilog.', 'Задржавам право да променим мишљење ако се извучем из ове стоматолошке ноћне море... Међутим, разумем оне који не желе да иду код зубара: време, новац (много), физички бол и психичка патња... Измена: ординација је „побратимљена“ са ординацијом др Гаспареа Фераце у Сарону: Морам рећи да им тачност не иде у прилог.', NULL, NULL, NULL, NULL,
    4, '2021-06-01 20:21:11'),

(@user_elifgamol, @clinic_id, NULL, 'google_maps',
    'places/ChIJWZaIIQrrTRMRgnAL_yZDUcA/reviews/ChdDSUhNMG9nS0VJQ0FnTURRM2VuQ25nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-13 09:37:16'),

(@user_dragana_mirkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWZaIIQrrTRMRgnAL_yZDUcA/reviews/ChZDSUhNMG9nS0VJQ0FnSUNSbmN5dE13EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-04-08 12:12:41'),

(@user_srecko_peralovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWZaIIQrrTRMRgnAL_yZDUcA/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtM2VHaC1RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-11-11 06:57:29'),

(@user_stojanka_kikovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWZaIIQrrTRMRgnAL_yZDUcA/reviews/ChZDSUhNMG9nS0VJQ0FnSURHOHMzMWVBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-11-23 18:24:52'),

(@user_senada_omerbozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJWZaIIQrrTRMRgnAL_yZDUcA/reviews/ChZDSUhNMG9nS0VJQ0FnSURNd0xqWVBREAE',
    5, 'ru', NULL,
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
