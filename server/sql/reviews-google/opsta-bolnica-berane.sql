-- Insert Google Maps reviews for General Hospital Berane
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/opsta-bolnica-berane.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'opsta-bolnica-berane');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_marijana_pesic = (SELECT id FROM doctors WHERE slug = 'marijana-pesic');
SET @doctor_igor_babic = (SELECT id FROM doctors WHERE slug = 'igor-babic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusan Raicevic', 'https://lh3.googleusercontent.com/a/ACg8ocKVd36zcYJagieC7UMhjbjnGNUSIUhpsKTb9cN1balk-09__Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108771197912039879304/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108771197912039879304/reviews');
SET @user_dusan_raicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108771197912039879304/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elma Kožar', 'https://lh3.googleusercontent.com/a/ACg8ocL-9JKfTsAuuUceyfq2Ds_Ak9IB4N8lpoHz5NlUG5rM786N=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110468806422185965031/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110468806422185965031/reviews');
SET @user_elma_koar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110468806422185965031/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marinko Perusko', 'https://lh3.googleusercontent.com/a-/ALV-UjVOJSWRdLFbPSdXXoDYeRvpezXtc4HAmAHDfx_PsOMzeVdRxiht=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118392878885038301314/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118392878885038301314/reviews');
SET @user_marinko_perusko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118392878885038301314/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'marko polis', 'https://lh3.googleusercontent.com/a-/ALV-UjXnS01QKMM4YdaRklk1DiRz1Y7yPIoC_yLfNvACufVb6ygSCT_e=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110707718628716105493/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110707718628716105493/reviews');
SET @user_marko_polis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110707718628716105493/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '3mr3', 'https://lh3.googleusercontent.com/a-/ALV-UjUZnfYM8Osfg8r_iCJtD8j1BX5dygqHDhgiQ106WnLtj8ujcXM=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110358205191187791688/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110358205191187791688/reviews');
SET @user_3mr3 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110358205191187791688/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'eL eLo', 'https://lh3.googleusercontent.com/a/ACg8ocIS0j3fgsModXP7AWO6uE3KS4gqN5R7wYl3G7W4GJ7yQfAhaw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104785767189748877333/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104785767189748877333/reviews');
SET @user_el_elo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104785767189748877333/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mensur Sabotic', 'https://lh3.googleusercontent.com/a-/ALV-UjXNmW7fhNqg0NJWlPCbcpsOgkjYCT6yT59dRkBsAo5cJFbz-TE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101808170935424420478/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101808170935424420478/reviews');
SET @user_mensur_sabotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101808170935424420478/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Eko Polir', 'https://lh3.googleusercontent.com/a-/ALV-UjVn-3DSPawSC60TUYqewZo3P-7cl1jWf44PqQ6_uUbjBH7WOh-p=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114852838092191208610/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114852838092191208610/reviews');
SET @user_eko_polir = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114852838092191208610/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanel Agovic', 'https://lh3.googleusercontent.com/a/ACg8ocIsjCqPkmHmWiFNRC2sOGwtJjfsaKo80eJyBeKuLTyzJi1GuA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117855296707125107778/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117855296707125107778/reviews');
SET @user_sanel_agovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117855296707125107778/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mila Stojkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU_Xr2X-be-t4lKIEIB6LODBpBCggQ3O6r4IdRYRVFpRLIs-oMO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106218813778441596808/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106218813778441596808/reviews');
SET @user_mila_stojkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106218813778441596808/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'napravisajt', 'https://lh3.googleusercontent.com/a/ACg8ocJLRlET0Q4WU5koFHTlCpjJ5OkoIC_0-1BHHQVLpsweDf5wlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113040770629023175564/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113040770629023175564/reviews');
SET @user_napravisajt = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113040770629023175564/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Deleta Otovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXJUSd4cePOWDvdSnTJuOvrv5GIClKnqAQztfxiwNo7lA1rKWhE=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109525470506173002906/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109525470506173002906/reviews');
SET @user_deleta_otovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109525470506173002906/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Durio Uturinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUKiTpfIpXb7V1pvsyeb0ff2tFaEwONbh1Q2JfGbTJFnZsSYFKCiA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116575366961396306186/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116575366961396306186/reviews');
SET @user_durio_uturinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116575366961396306186/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladen Đukić', 'https://lh3.googleusercontent.com/a/ACg8ocJD4lvZrRlMcK1HEnqK4gXUkdYLxa7kFGaoBTSLH4KBiMzgLQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102818993404331765003/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102818993404331765003/reviews');
SET @user_mladen_uki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102818993404331765003/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elzo Mehovic', 'https://lh3.googleusercontent.com/a/ACg8ocKp2NfjnWU9V_PLbG4R9RZmqVLYpBru1Zr1OMQbw_O15do5uA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104504709765253221597/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104504709765253221597/reviews');
SET @user_elzo_mehovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104504709765253221597/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lekso Saičić', 'https://lh3.googleusercontent.com/a-/ALV-UjXUCqGlEl8lDezSFyZ4bSJoNvF6zC0dimWwNjwHkx_dIPbLZKw1=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113121230478629676289/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113121230478629676289/reviews');
SET @user_lekso_saii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113121230478629676289/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_dusan_raicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCZk4xTTJSbUZFT1cxblNYcGlUamxZVUROWVJtYxAB',
    5, 'sr', 'Похвали бих предивног доктора ФАХРУДИНА ХАДРОВИЋА ЗА ИЗУЗЕТАН ПРИЈЕМ И ПРЕГЛЕД моје таште .
Велика је ствар имати таквог лекара у својој кући као што је болница у Беранама
Похвалио бих и хигијену у ентеријеру и екстеријеру
Све похвале !!!',
    'Pohvali bih predivnog doktora FAHRUDINA HADROVIĆA ZA IZUZETAN PRIJEM I PREGLED moje tašte .
Velika je stvar imati takvog lekara u svojoj kući kao što je bolnica u Beranama
Pohvalio bih i higijenu u enterijeru i eksterijeru
Sve pohvale !!!', 'Похвали бих предивног доктора ФАХРУДИНА ХАДРОВИЋА ЗА ИЗУЗЕТАН ПРИЈЕМ И ПРЕГЛЕД моје таште .
Велика је ствар имати таквог лекара у својој кући као што је болница у Беранама
Похвалио бих и хигијену у ентеријеру и екстеријеру
Све похвале !!!', NULL, NULL, NULL, NULL,
    0, '2025-07-31 14:09:48'),

(@user_elma_koar, @clinic_id, @doctor_marijana_pesic, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/Ci9DQUlRQUNvZENodHljRjlvT200NWRWSkRRWFJhV1hKNGFFaFlWbk40T0hKelFsRRAB',
    1, 'bs', 'Porodila sam se u Beranama prije devet mjeseci.Porodila me je doktorica Maja Pešić od svih sestrica i doktorica mogu da izdvojim najvise dvije koje su ljubazne i spremne da pomognu dok doktorica koja je mene poradjala drzala me je 14 sati na indukciju i pored svega toga zaboravila posteljicu  evo devet meseci kasnije i dalje imam posledice svega toga i dalje se lijecim',
    'Ja sam se porodila u Beranama pre devet meseci. Isporučila me je dr Maja Pešić. Od svih medicinskih sestara i lekara mogu da izdvojim samo dve koje su ljubazne i spremne da pomognu. Doktor koji me je porodio zadržao me je 14 sati na indukciji i povrh svega zaboravio posteljicu. Devet meseci kasnije i dalje imam posledice svega toga i još uvek se lečim.', 'Ја сам се породила у Беранама пре девет месеци. Испоручила ме је др Маја Пешић. Од свих медицинских сестара и лекара могу да издвојим само две које су љубазне и спремне да помогну. Доктор који ме је породио задржао ме је 14 сати на индукцији и поврх свега заборавио постељицу. Девет месеци касније и даље имам последице свега тога и још увек се лечим.', NULL, NULL, NULL, NULL,
    0, '2025-10-11 11:09:42'),

(@user_marinko_perusko, @clinic_id, @doctor_igor_babic, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoMk1XWndUM2RtV2tsb1pHcGtUbGRUTTAxU1NGRRAB',
    5, 'hr', 'Od prijema do otpusta bez ijedne zamjerke.Jako ljubazno i strucno osoblje Kardio klinike ,profesionalnost na nivou.Posebna zahvalnost ekipi u Angio sali sa Dr Igorom Dragovicem na celu.Hvala jos jednom i samo tako nastavite.Mozete posluziti kao primjer vecini bolnica u Cg.Svako dobro',
    'Od prijema do otpusta bez ijedne zamjerke.Jako ljubazno i strucno osoblje Kardio klinike ,profesionalnost na nivou.Posebna zahvalnost ekipi u Angio sali sa Dr Igorom Dragovicem na celu.Hvala jos jednom i samo tako nastavite.Mozete posluziti kao primjer vecini bolnica u Cg.Svako dobro', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-01 13:14:22'),

(@user_marko_polis, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChdDSUhNMG9nS0VJQ0FnSURJZ3F1ZXZnRRAB',
    5, 'bs', 'odlicna bolnica sa odlicnim medicinskim osobljem. sve pohvale.',
    'Odlična bolnica sa odličnim medicinskim osobljem. Sve pohvale.', 'Одлична болница са одличним медицинским особљем. Све похвале.', NULL, NULL, NULL, NULL,
    1, '2018-12-27 17:12:36'),

(@user_3mr3, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChZDSUhNMG9nS0VJQ0FnSUNlOG9LZExnEAE',
    5, 'bs', 'Odlicna i brza reakcija doktora na hitnoj.',
    'Odličan i brz odgovor lekara hitne pomoći.', 'Одличан и брз одговор лекара хитне помоћи.', NULL, NULL, NULL, NULL,
    0, '2022-09-10 15:56:42'),

(@user_el_elo, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/Ci9DQUlRQUNvZENodHljRjlvT214aU1rWjNNbWxGZUVGaVlWbzNhVk5sVGpSbGRYYxAB',
    1, 'en', 'My experience with this hospital has been absolutely devastating, and I feel compelled to share what happened to my uncle.

My uncle was admitted to this hospital with medical problems. When he was admitted, he was still able to walk and communicate. He remained in the hospital for approximately three and a half months, and sadly, he passed away there.

During those months, I visited him several times. In my 40 years, I have never seen a hospital in such poor condition. Even the walkway outside is in such bad shape that you have to be extremely careful not to injure yourself. Unfortunately, the conditions inside were even more disturbing.

The toilets I saw were shockingly dirty, with black, brown, and yellow staining. In my opinion, these conditions are completely unacceptable for a healthcare facility. Hospital management should be deeply ashamed that patients and their families are expected to use facilities in this condition.

What concerns me even more, however, is the medical care my uncle received. Despite being hospitalized for months, our family was left without a clear understanding of his diagnosis. Around the third month of his stay, he also suffered two strokes while in the hospital.

My uncle entered this hospital able to walk and talk. After three and a half months, he never came home.

This experience has left our family with serious questions about the medical care he received, the communication with our family, and the overall standards and hygiene of this hospital. Losing a family member is already extremely painful, but being left with so many unanswered questions makes it even harder.

I sincerely hope that hospital management takes complaints like this seriously and investigates both the standard of care and the conditions within the hospital. Patients deserve proper medical attention, clear communication, dignity, and a clean and safe environment.',
    NULL, NULL, 'My experience with this hospital has been absolutely devastating, and I feel compelled to share what happened to my uncle.

My uncle was admitted to this hospital with medical problems. When he was admitted, he was still able to walk and communicate. He remained in the hospital for approximately three and a half months, and sadly, he passed away there.

During those months, I visited him several times. In my 40 years, I have never seen a hospital in such poor condition. Even the walkway outside is in such bad shape that you have to be extremely careful not to injure yourself. Unfortunately, the conditions inside were even more disturbing.

The toilets I saw were shockingly dirty, with black, brown, and yellow staining. In my opinion, these conditions are completely unacceptable for a healthcare facility. Hospital management should be deeply ashamed that patients and their families are expected to use facilities in this condition.

What concerns me even more, however, is the medical care my uncle received. Despite being hospitalized for months, our family was left without a clear understanding of his diagnosis. Around the third month of his stay, he also suffered two strokes while in the hospital.

My uncle entered this hospital able to walk and talk. After three and a half months, he never came home.

This experience has left our family with serious questions about the medical care he received, the communication with our family, and the overall standards and hygiene of this hospital. Losing a family member is already extremely painful, but being left with so many unanswered questions makes it even harder.

I sincerely hope that hospital management takes complaints like this seriously and investigates both the standard of care and the conditions within the hospital. Patients deserve proper medical attention, clear communication, dignity, and a clean and safe environment.', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_mensur_sabotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wM1VUSTBjM1JyWVdFeFZrMWpNR1IyWDBrMmRWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_eko_polir, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChdDSUhNMG9nS0VKX2Q2cVdxcDR2NDNnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sanel_agovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChdDSUhNMG9nS0VJQ0FnSUR2M3NyaXlRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mila_stojkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChdDSUhNMG9nS0VJQ0FnSURQXzZMYmlRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_napravisajt, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzbHN1S3RBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_deleta_otovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChZDSUhNMG9nS0VJQ0FnSURIMF9QMUlREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_durio_uturinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChZDSUhNMG9nS0VJQ0FnSURob05mUEJBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_mladen_uki, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyaDZfcjFRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_elzo_mehovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChdDSUhNMG9nS0VJQ0FnSURDdXVxbzNRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_lekso_saii, @clinic_id, NULL, 'google_maps',
    'places/ChIJHeBZc8KTUhMRHpseyw1JK3Y/reviews/ChZDSUhNMG9nS0VJQ0FnSURBZ0lLSFBnEAE',
    5, 'en', 'good',
    NULL, NULL, 'good', NULL, NULL, NULL,
    0, '2016-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
