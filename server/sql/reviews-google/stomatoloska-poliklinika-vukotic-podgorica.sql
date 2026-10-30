-- Insert Google Maps reviews for Stomatološka Poliklinika "Vukotić"
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/stomatoloska-poliklinika-vukotic-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'stomatoloska-poliklinika-vukotic-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ena Korać', 'https://lh3.googleusercontent.com/a-/ALV-UjWwR4DjxCLNzdk8eyo1dW_NQcE5ZlhKesMhhojGFv8GEkuDSxU=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116401132755541199450/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116401132755541199450/reviews');
SET @user_ena_kora = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116401132755541199450/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nena Saveljic', 'https://lh3.googleusercontent.com/a/ACg8ocL5mrjRB_IGW2mK2BCkec63ldJnowYg-f3J8A1MWvtMGT3NRw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112291642926692387523/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112291642926692387523/reviews');
SET @user_nena_saveljic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112291642926692387523/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Bogicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjU21PZLK2PGQPnAwsmuqEEC6gZXBrBWknUM9HG0veCoZn9JEkgh=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106386225982338145320/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106386225982338145320/reviews');
SET @user_biljana_bogicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106386225982338145320/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ena_kora, @clinic_id, NULL, 'google_maps',
    'places/ChIJD4HEq07rTRMRt07EFEmcmMw/reviews/ChdDSUhNMG9nS0VJQ0FnSUN5MmNPbTNRRRAB',
    5, 'bs', 'Najbolja ordinacija u Crnoj Gori!!! Ja imam fobiju od zubara i Dr Vuković je jedini kod kojeg bez problema sjiednem na stolicu i ne brinem da će me imalo zaboljeli.
Preporučujem svima koji imaju strah od zubara i plaše se da će ih imalo boliti intervencija.
Takođe je izvanredan stomatolog za djecu. Jer sam ja upravo zbog lošeg iskustva kao djete, dobila fobiju. A moja djeca tu sreću imaju,da tako nešto nikada neće doživeti.
Dr Vukotić ne samo da je zubar,već i Dentalni hirurg. Tako da sve pohvale za njegov rad i rad njegovog tima. Verujte mi da će te jako zadovoljni šta god da vam je potrebno,pa makar i samo kontrola.
Kvalitet, vrhunska usluga, najnovija Dentalna tehnologija koja postoji u CG i cijene korektne.',
    'Najbolja stomatološka ordinacija u Crnoj Gori!!! Imam fobiju od zubara i dr Vuković je jedini gde mogu bez problema da sedim u stolici i da ne brinem da će me uopšte boleti.
Preporučujem ga svima koji se plaše stomatologa i plaše se da će im intervencija uopšte škoditi.
Takođe je odličan stomatolog za decu. Zato što sam razvila fobiju upravo zbog lošeg iskustva u detinjstvu. A moja deca imaju tu sreću da nikada ne dožive tako nešto.
Dr Vukotić nije samo stomatolog, već i stomatolog. Tako da sve pohvale za njegov rad i rad njegovog tima. Verujte mi, bićete veoma zadovoljni onim što vam treba, pa makar to bila samo kontrola.
Kvalitetna, vrhunska usluga, najnovija stomatološka tehnologija koja postoji u Crnoj Gori i korektne cijene.', 'Најбоља стоматолошка ординација у Црној Гори!!! Имам фобију од зубара и др Вуковић је једини где могу без проблема да седим у столици и да не бринем да ће ме уопште болети.
Препоручујем га свима који се плаше стоматолога и плаше се да ће им интервенција уопште шкодити.
Такође је одличан стоматолог за децу. Зато што сам развила фобију управо због лошег искуства у детињству. А моја деца имају ту срећу да никада не доживе тако нешто.
Др Вукотић није само стоматолог, већ и стоматолог. Тако да све похвале за његов рад и рад његовог тима. Верујте ми, бићете веома задовољни оним што вам треба, па макар то била само контрола.
Квалитетна, врхунска услуга, најновија стоматолошка технологија која постоји у Црној Гори и коректне цијене.', NULL, NULL, NULL, NULL,
    3, '2021-02-10 12:27:03'),

(@user_nena_saveljic, @clinic_id, NULL, 'google_maps',
    'places/ChIJD4HEq07rTRMRt07EFEmcmMw/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkbWRXOXpRbll6WDFkZmVVVlRhWEJ0VUZGNE9HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_biljana_bogicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJD4HEq07rTRMRt07EFEmcmMw/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KSE0wOUxaRFI2VUZWM1ZUbEdhRGhOUkZVeVNIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
