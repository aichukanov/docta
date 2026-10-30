-- Insert Google Maps reviews for Dom zdravlja - Mojkovac
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-bosko-dedeic-mojkovac.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-bosko-dedeic-mojkovac');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dalibor Cosovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV3hN7N3FcdOdlxgG1QrSq8_4yQrRjAFhd5UC7CW-l46oKVGApo=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/111906185483794193167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111906185483794193167/reviews');
SET @user_dalibor_cosovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111906185483794193167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'R F', 'https://lh3.googleusercontent.com/a-/ALV-UjUE99RxkO7EibHGSE0S8pxS1TO5bN4GPqqEImL1wyOncUB2pIrg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111295994087692867461/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111295994087692867461/reviews');
SET @user_r_f = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111295994087692867461/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milly', 'https://lh3.googleusercontent.com/a-/ALV-UjXz-_FTpEzImLHIUOMRrdmT9nSkQRpZvCGodiCJIcgol8nN17A=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/105527720715479608646/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105527720715479608646/reviews');
SET @user_milly = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105527720715479608646/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mili Cence', 'https://lh3.googleusercontent.com/a-/ALV-UjVspemoPg39NFW8cWbjFOErRHIYD8lgFZgkSVO3rhD8d0OQNP8S=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103055292242674219419/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103055292242674219419/reviews');
SET @user_mili_cence = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103055292242674219419/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Durio Uturinović', 'https://lh3.googleusercontent.com/a-/ALV-UjUtQtCaqnvgTVX5sqlCSu16PcBhCI4FVXQ-i3V6nbvwKcUB8ZvR=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/117745048200325579861/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117745048200325579861/reviews');
SET @user_durio_uturinovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117745048200325579861/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_dalibor_cosovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ6Tpog86fUhMRiEMWr3CPlC8/reviews/ChZDSUhNMG9nS0VJQ0FnSUQyOXBTNk9nEAE',
    5, 'hr', 'Želio bih pohvaliti i zahvaliti domu zdravlja na pomoći mom kolegi.Zahvalni moto grupa Tarci.',
    'Želeo bih da pohvalim i zahvalim Domu zdravlja što je pomogao mojoj koleginici. Zahvalnost je moto grupe Tarci.', 'Желео бих да похвалим и захвалим Дому здравља што је помогао мојој колегиници. Захвалност је мото групе Тарци.', NULL, NULL, NULL, NULL,
    0, '2022-05-14 15:07:22'),

(@user_r_f, @clinic_id, NULL, 'google_maps',
    'places/ChIJ6Tpog86fUhMRiEMWr3CPlC8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNoNS1PWGVnEAE',
    1, 'bs', 'Imaju sajt na koji nista ne pise niti broj telefona za informacije,niti rasporedbizabranih ljekara niti bilo sta',
    'Imaju veb stranicu koja nema broj telefona za informacije, raspored izabranih doktora ili bilo šta.', 'Имају веб страницу која нема број телефона за информације, распоред изабраних доктора или било шта.', NULL, NULL, NULL, NULL,
    0, '2023-02-24 05:40:26'),

(@user_milly, @clinic_id, NULL, 'google_maps',
    'places/ChIJ6Tpog86fUhMRiEMWr3CPlC8/reviews/ChZDSUhNMG9nS0VJQ0FnSURIeXJTU0p3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-09-14 15:35:09'),

(@user_mili_cence, @clinic_id, NULL, 'google_maps',
    'places/ChIJ6Tpog86fUhMRiEMWr3CPlC8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKeldEWTNUbXR6U1hKd1JGY3pRbmRoWHpac2JWRRAB',
    1, 'hr', 'Veoma loše,nikad te u ovdje nemogu ljecit nego te salju na druga mesta kao:PG,BP',
    'Veoma loše, ovde vas nikada ne mogu lečiti, šalju vas na druga mesta kao što su: PG, BP', 'Веома лоше, овде вас никада не могу лечити, шаљу вас на друга места као што су: ПГ, БП', NULL, NULL, NULL, NULL,
    0, '2026-03-14 14:45:53'),

(@user_durio_uturinovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ6Tpog86fUhMRiEMWr3CPlC8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKVmFVTkpaMVJJWWpaeFUybDFNRFpUVUZob1dsRRAB',
    1, 'hr', 'Doktori su nesbosobni za liječenje,već ljude konstantno šalju za Bijelo Polje..Sramota!',
    'Lekari su nesposobni da leče, stalno šalju ljude u Bijelo Polje...Sramota!', 'Лекари су неспособни да лече, стално шаљу људе у Бијело Поље...Срамота!', NULL, NULL, NULL, NULL,
    0, '2026-03-14 14:45:05')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
