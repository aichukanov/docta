-- Insert Google Maps reviews for Дом здравља Цетиње
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-cetinje.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-cetinje');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_branislava_markovic = (SELECT id FROM doctors WHERE slug = 'branislava-markovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Baldo', 'https://lh3.googleusercontent.com/a/ACg8ocLxw5h86W7QSgPCdADVM3LD0jtqnbL0wFZvtX1Nza-J_DG2vw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113694105920808209152/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113694105920808209152/reviews');
SET @user_elena_baldo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113694105920808209152/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'aleksandra perovic', 'https://lh3.googleusercontent.com/a/ACg8ocJHbtmziUiA-TamIaWEgDgPLncUMQWeG9q9Hbj8sdY6lRJhBA=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/100735342649474185465/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100735342649474185465/reviews');
SET @user_aleksandra_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100735342649474185465/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lilieae 92', 'https://lh3.googleusercontent.com/a/ACg8ocLMiFix61fJzWfMfx1BQkLtT43kTSW-PwV4UWk69InXIWjBaA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108780339384867630586/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108780339384867630586/reviews');
SET @user_lilieae_92 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108780339384867630586/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rodjeni prokleti', 'https://lh3.googleusercontent.com/a/ACg8ocKs-X4GzteAo8uFOy1CjhoBtG3z6vqHpvuEMtyD5GNJ-VP-tA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106301035501935800524/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106301035501935800524/reviews');
SET @user_rodjeni_prokleti = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106301035501935800524/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natsukful', 'https://lh3.googleusercontent.com/a-/ALV-UjWGpLrwwbI5eUM3bjtqyyvt6swR4oNjWzWtOdAPMN9dkQdCDEOo=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/114010411469339478823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114010411469339478823/reviews');
SET @user_natsukful = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114010411469339478823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kenan Kolić', 'https://lh3.googleusercontent.com/a-/ALV-UjX0pGG_U7C6980SScTOv-bVXTdclpQ5l3aL2TfFyKkYPjfMMtRA2w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107524945655895142693/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107524945655895142693/reviews');
SET @user_kenan_koli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107524945655895142693/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jo Ho', 'https://lh3.googleusercontent.com/a/ACg8ocL3dsJ8qmS_BX9-xnVofC-a-lxRi0Aw_Wbm1KuoRPV3bc8v-w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114864790557388611108/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114864790557388611108/reviews');
SET @user_jo_ho = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114864790557388611108/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Katnic', 'https://lh3.googleusercontent.com/a-/ALV-UjVzr0CW1Za6rZFmvqd-GMCC0ZMHPb1Z6_xdLkVjD8Wd2ZULNS2ggg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117098870097379750632/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117098870097379750632/reviews');
SET @user_ivana_katnic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117098870097379750632/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sofia Tifani', 'https://lh3.googleusercontent.com/a-/ALV-UjVemcsXXLgKSx6DqxVI4js1McNPhpbSqu3f6bzLibtmhbmRfX8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116869480746122545411/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116869480746122545411/reviews');
SET @user_sofia_tifani = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116869480746122545411/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jadranka Jadranka', 'https://lh3.googleusercontent.com/a/ACg8ocL7EnWlDH1oE7ti6lhCRkjRvOcvoHPs5dXrtaqxZGLxNCYkmg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117219272698399314396/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117219272698399314396/reviews');
SET @user_jadranka_jadranka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117219272698399314396/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luaay E', 'https://lh3.googleusercontent.com/a/ACg8ocJbzVmYG2qPzY9Qz_YudIU1fqLqALCoFCxyl9lbeSg8pciftAwF=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110129297403577934662/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110129297403577934662/reviews');
SET @user_luaay_e = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110129297403577934662/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_elena_baldo, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3d056aWFnEAE',
    5, 'it', 'In vacanza a Cetinje, ho avuto bisogno di una visita di Pronto Soccorso per una infezione e ho trovato personale molto preparato e professionale. Nel giro di mezz\'ora sono stata visitata da una dottoressa e una infermiera molto gentili, che mi hanno spiegato tutti i dettagli in inglese. La dottoressa addirittura è venuta con me alla farmacia per acquistare i medicinali prescritti.',
    'Dok sam bio na odmoru na Cetinju, trebalo mi je da odem na hitnu pomoć zbog infekcije i osoblje mi se pokazalo veoma stručnim i profesionalnim. U roku od pola sata, primio me je veoma ljubazan lekar i medicinska sestra, koji su mi sve detalje objasnili na engleskom. Lekar je čak otišao sa mnom do apoteke da kupim prepisane lekove.', 'Док сам био на одмору на Цетињу, требало ми је да одем на хитну помоћ због инфекције и особље ми се показало веома стручним и професионалним. У року од пола сата, примио ме је веома љубазан лекар и медицинска сестра, који су ми све детаље објаснили на енглеском. Лекар је чак отишао са мном до апотеке да купим преписане лекове.', NULL, NULL, NULL, NULL,
    0, '2024-08-11 08:31:23'),

(@user_aleksandra_perovic, @clinic_id, @doctor_branislava_markovic, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNOMWQ2eGFREAE',
    5, 'bs', 'Sve pohvale za tim dr Branislave Markovic. Moje iskustvo kao pacijentkinje zelim prenijeti javno od srca.Ljubazni,svesrdni a narocito sestra Ivana Kaludjerovic. Budite i dalje na tom putu, ljudi to prepoznaju! HVALA!',
    'Sve pohvale za tim dr Branislave Marković. Od srca želim javno da podelim svoje iskustvo pacijenta. Ljubazna, svesrdna, a posebno medicinska sestra Ivana Kaluđerović. Nastavite tim putem, ljudi to prepoznaju! HVALA VAM!', 'Све похвале за тим др Браниславе Марковић. Од срца желим јавно да поделим своје искуство пацијента. Љубазна, свесрдна, а посебно медицинска сестра Ивана Калуђеровић. Наставите тим путем, људи то препознају! ХВАЛА ВАМ!', NULL, NULL, NULL, NULL,
    0, '2024-01-16 12:49:22'),

(@user_lilieae_92, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCd1J6VnpTekU0WDJOaWNXa3RkamxCT1VvdE1VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-15 06:28:10'),

(@user_rodjeni_prokleti, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNOMHNUcDh3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-01-13 08:33:21'),

(@user_natsukful, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/ChdDSUhNMG9nS0VJQ0FnSURacjRLWDdnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-08 23:48:56'),

(@user_kenan_koli, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGa1pHYzBOako2VEd4TmVuZ3plams1VjJ4T2EwRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jo_ho, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1MlEyUXlPRGRGTFRkamRIRjVkeTFuVW5jeFZIYxAB',
    5, 'de', 'Das Personal in der Dialyse Abteilung ist wunderbar!',
    NULL, NULL, NULL, NULL, 'Das Personal in der Dialyse Abteilung ist wunderbar!', NULL,
    0, '2026-09-29 00:00:00'),

(@user_ivana_katnic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5dlkzbzJjbGhhUlZkSFRYZzFVMUpUV205Qk5YYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_sofia_tifani, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Gck1XWlhUMjVRY0dZMWJrZDJRMGxyVFVvemNHYxAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jadranka_jadranka, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/ChdDSUhNMG9nS0VJQ0FnSURaOUllWnpBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_luaay_e, @clinic_id, NULL, 'google_maps',
    'places/ChIJ49c5O17OTRMRuU4JnVePgbc/reviews/ChZDSUhNMG9nS0VJQ0FnSURhb00tbENnEAE',
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
