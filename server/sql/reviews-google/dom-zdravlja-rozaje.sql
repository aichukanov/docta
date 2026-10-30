-- Insert Google Maps reviews for Health Center Rozaje
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-rozaje.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-rozaje');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Abeer', 'https://lh3.googleusercontent.com/a-/ALV-UjWVM5F6NcBjHn016uscGQnC4TdH48vd5X4hHArslpHAj8lqXEo=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/115051420428694661726/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115051420428694661726/reviews');
SET @user_abeer = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115051420428694661726/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'JLAN', 'https://lh3.googleusercontent.com/a-/ALV-UjU_xQygQPFOaXLHVDf-D1P6oegxH9-doXedxs4ybyl6QZa58P4k=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/107083658425312674446/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107083658425312674446/reviews');
SET @user_jlan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107083658425312674446/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Semir Bakić', 'https://lh3.googleusercontent.com/a-/ALV-UjUkweUg0XiA_CAlvacuEFAN6hdMB8sMOVa2m8DkcAW2pJPB43Ux=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/108142289525224801109/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108142289525224801109/reviews');
SET @user_semir_baki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108142289525224801109/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_abeer, @clinic_id, NULL, 'google_maps',
    'places/ChIJUxlYZUfmUhMRPsI6M2SUK6U/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tablNsTm1ka2hwUVROTlJFdEJiRkJITkRCU01YYxAB',
    5, 'ar', 'اشكر جميع طاقم العاملين في قسم الطوارئ لقد كانو لطيفين و حنونين  واستقبلونا وعالجوا ابنتي بالرغم من اننا من دولة اخرى اهنئ هذا المستشفى بمثل هذا الطاقم 🤍🫡🇲🇪🇸🇦',
    'Zahvaljujem se svim zaposlenima u odeljenju hitne pomoći. Bili su ljubazni i saosećajni, dočekali su nas i lečili moju ćerku iako smo iz druge zemlje. Čestitam ovoj bolnici što ima ovakvo osoblje. 🤍🫡🇲🇪🇸🇦', 'Захваљујем се свим запосленима у одељењу хитне помоћи. Били су љубазни и саосећајни, дочекали су нас и лечили моју ћерку иако смо из друге земље. Честитам овој болници што има овакво особље. 🤍🫡🇲🇪🇸🇦', NULL, NULL, NULL, NULL,
    0, '2025-08-07 17:25:19'),

(@user_jlan, @clinic_id, NULL, 'google_maps',
    'places/ChIJUxlYZUfmUhMRPsI6M2SUK6U/reviews/ChdDSUhNMG9nS0VJQ0FnSURodEpHMnZnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-03-02 15:43:46'),

(@user_semir_baki, @clinic_id, NULL, 'google_maps',
    'places/ChIJUxlYZUfmUhMRPsI6M2SUK6U/reviews/ChZDSUhNMG9nS0VJQ0FnSURBNE5Mc01BEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2016-12-13 18:06:39')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
