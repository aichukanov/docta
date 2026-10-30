-- Insert Google Maps reviews for Inter Cardio Kotor
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/inter-cardio-kotor.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'inter-cardio-kotor');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_igor_bjeladinovic = (SELECT id FROM doctors WHERE slug = 'igor-bjeladinovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marino Stura', 'https://lh3.googleusercontent.com/a-/ALV-UjWLqkDYjokgvj-aoQCPlTDF5MgBKBQCpSnNnbcpVO1lOmMLqsQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108955266006886350136/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108955266006886350136/reviews');
SET @user_marino_stura = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108955266006886350136/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lucia Kardum', 'https://lh3.googleusercontent.com/a/ACg8ocJryUEG6iD3-DchffAdWO5Yf1vCrCgaFk0aZe032FXkGSbjYVU=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105991540550822521021/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105991540550822521021/reviews');
SET @user_lucia_kardum = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105991540550822521021/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Bogicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjU21PZLK2PGQPnAwsmuqEEC6gZXBrBWknUM9HG0veCoZn9JEkgh=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106386225982338145320/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106386225982338145320/reviews');
SET @user_biljana_bogicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106386225982338145320/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Budo', 'https://lh3.googleusercontent.com/a-/ALV-UjVbMyu-YEUsF-v_GI2IY0LhgT7AdwcZFevp6YRCLEY70LxtObo=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118171003026180834571/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118171003026180834571/reviews');
SET @user_budo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118171003026180834571/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Надя Ч.', 'https://lh3.googleusercontent.com/a-/ALV-UjXgyOvDJKq8lmLom6vSqIxwVpgzgM0W4IxKA6ITbg_AQDPbyJw=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/108036431744710220954/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108036431744710220954/reviews');
SET @user_nadya_ch = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108036431744710220954/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srecna zena', 'https://lh3.googleusercontent.com/a/ACg8ocKVg4kjNxbByky5sTLa8Zyf7CWeaV0fFvcY_ToI1DbO8RriPQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100964442470861997185/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100964442470861997185/reviews');
SET @user_srecna_zena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100964442470861997185/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljiljana Janićijević', 'https://lh3.googleusercontent.com/a-/ALV-UjUCqyAp02kP9v5G-VLEAa6rQpLGVDaS_6dumF5VUX6t4ahfCak=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116825642232042195270/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116825642232042195270/reviews');
SET @user_ljiljana_janiijevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116825642232042195270/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Milicevic', 'https://lh3.googleusercontent.com/a/ACg8ocITa5qNqMEIkefo50U9T3z81voAv5qlKGy6N9Nxwycm1M4r=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106567341167918934973/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106567341167918934973/reviews');
SET @user_mirko_milicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106567341167918934973/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Richard Djuricic', 'https://lh3.googleusercontent.com/a/ACg8ocJls5HgZTGXpPWP4zh_SlIVxmAaWPwjRJUut7-W8oC6X4Hn3A=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105844108437530756827/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105844108437530756827/reviews');
SET @user_richard_djuricic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105844108437530756827/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljko Vulovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW3TpSPV0ZXWA833sHi3AxMUCFyo4eophI4eAbaimCB4oYe0gN9gA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113610391398387401150/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113610391398387401150/reviews');
SET @user_zeljko_vulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113610391398387401150/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocIWnMkQ0IHSVWqSZR8ChaGpvPJtfR2-kE4Z9XOWEUq8L_3vaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110150307208343797097/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110150307208343797097/reviews');
SET @user_ana_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110150307208343797097/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jadranka Lazovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVDbh_6As7jmOfvDALteZPRAn6Qp862T45jVANYA3JXmNh3rf0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117594655041928609632/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117594655041928609632/reviews');
SET @user_jadranka_lazovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117594655041928609632/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Pavicevic', 'https://lh3.googleusercontent.com/a/ACg8ocLVo7LwihZ42cliZhdcztQp8IpdW39OZp3xnwDu3nWdXHaZ4w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110863292819547060775/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110863292819547060775/reviews');
SET @user_dragan_pavicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110863292819547060775/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zvonko Gavrilovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUukQrsfnruYVHXei5iMNlqlzuQ5FBaUQw71CJQXotA_HJa4OdPmw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117240900360942688164/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117240900360942688164/reviews');
SET @user_zvonko_gavrilovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117240900360942688164/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Žana Savić', 'https://lh3.googleusercontent.com/a/ACg8ocLtvc79xO-nqjTL142-cjsSs6NFMhZWuePxZbFD_0S25qQRlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109974573839809352201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109974573839809352201/reviews');
SET @user_ana_savi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109974573839809352201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Ilic', 'https://lh3.googleusercontent.com/a/ACg8ocJ33mqN9xT9limgDA2rgWpiinFRFgPSwa1co-tFhUdXK68oDA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106381880316699481704/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106381880316699481704/reviews');
SET @user_dragana_ilic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106381880316699481704/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boban Vojvoda', 'https://lh3.googleusercontent.com/a/ACg8ocLIoeiUoZxQty9nxxVBL1-Vt4EopQemgaXRtUiNqYKh22ZKZw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101068176754841851962/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101068176754841851962/reviews');
SET @user_boban_vojvoda = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101068176754841851962/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'J Lynn', 'https://lh3.googleusercontent.com/a-/ALV-UjUDM0BSHU5NWZVRjd-j5inqrZ6A8trPFhVLN9seT-rGrSS-md2HNw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106996152816776532307/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106996152816776532307/reviews');
SET @user_j_lynn = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106996152816776532307/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Radulovic', 'https://lh3.googleusercontent.com/a/ACg8ocKw_PGmB9SoRL3h_wX6Mph7KUOCJkGV-Wa8QgKa--EJMmjueQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116144342906859553988/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116144342906859553988/reviews');
SET @user_andjela_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116144342906859553988/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radmila Lazovic', 'https://lh3.googleusercontent.com/a/ACg8ocJT2-qH11uaqcYarr1KSWqERjNZG6tG4z8d6PH4HK1281KU7A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113042990511229487132/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113042990511229487132/reviews');
SET @user_radmila_lazovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113042990511229487132/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Андрей Трофимов', 'https://lh3.googleusercontent.com/a-/ALV-UjXNqZr5tNXdqpkqnGxoYo_eb8uuK14_ixpFeiFWxaeWahBbOBwl=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111382366223216810082/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111382366223216810082/reviews');
SET @user_andrey_trofimov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111382366223216810082/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Dakic', 'https://lh3.googleusercontent.com/a/ACg8ocJRH-DowkKB1zpH1VvqTgyIYmz0CJH6c8yaRQWWm9L_mXXAaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114302562887160763680/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114302562887160763680/reviews');
SET @user_ivana_dakic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114302562887160763680/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_marino_stura, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCd2JqTnFlbHBXZUVkWk9VWkpNbTFmZW5sRWIyYxAB',
    1, 'hr', '👎 DNO DNA 👎
Holter za pritisak uopće nije ispravan
🛑 PAZITE SE!!! 🛑
Uvjerite se sami kad ga stavite obavezno mjerite pritisak sa drugim i zapisujte vrijeme pa ćete sve vidit. 🚨OPREZ!!!
Privatna klinika pa se čeka po sat dva UŽAS!!! To još nisam doživio ali očito je to normalno kod njih kao što kažu. Doktor mi nije uopće uručio nalaz i objasnio nego mi ga sestra dala 🙈',
    '👎 DNO 👎
Merač krvnog pritiska uopšte ne radi
🛑 OPREZ!!! 🛑
Uverite se sami kada ga obučete, obavezno sa još nekim izmerite pritisak i zapišite vreme i sve ćete videti. 🚨OPREZ!!!
Privatna klinika tako da se čeka dva sata STRAŠNO!!! Ja to još nisam doživeo, ali očigledno je to kod njih normalno kako kažu. Doktor mi nije ni dao rezultate i objasnio ih, dala mi ih je sestra 🙈', '👎 ДНО 👎
Мерач крвног притиска уопште не ради
🛑 ОПРЕЗ!!! 🛑
Уверите се сами када га обучете, обавезно са још неким измерите притисак и запишите време и све ћете видети. 🚨ОПРЕЗ!!!
Приватна клиника тако да се чека два сата СТРАШНО!!! Ја то још нисам доживео, али очигледно је то код њих нормално како кажу. Доктор ми није ни дао резултате и објаснио их, дала ми их је сестра 🙈', NULL, NULL, NULL, NULL,
    0, '2025-11-23 02:20:25'),

(@user_lucia_kardum, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xFMWNWVlpXbTUzVVdOQk5rWnNla1ZOWVZsamJGRRAB',
    1, 'hr', 'Pristup osoblja neprofesionalan.
Neorganizirani, dugo se čeka.',
    'Pristup osoblja neprofesionalan.
Neorganizovano, dugo čekanje.', 'Приступ особља непрофесионалан.
Неорганизовано, дуго чекање.', NULL, NULL, NULL, NULL,
    1, '2025-11-23 23:27:08'),

(@user_biljana_bogicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4cU0zaEpXVjloVm5ZdExURTJaV3RMZEdKTU9VRRAB',
    5, 'hr', 'Najbolji doktori na bijelome svijetu. Hvala do Mjeseca i nazad❤️',
    'Najbolji lekari na svetu. Hvala mesecu i nazad❤', 'Најбољи лекари на свету. Хвала месецу и назад❤', NULL, NULL, NULL, NULL,
    0, '2025-09-16 14:26:33'),

(@user_budo, @clinic_id, @doctor_igor_bjeladinovic, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlcE9meV93RRAB',
    5, 'hr', 'Izuzetno profesionalni,uljudni,dobra komunikacija sa pacijentom Dr Bjeladinović i Dr Kumburović za svaku pohvalu. Izuzetno povoljna cijena specijalističkog pregleda.',
    'Izuzetno profesionalna, ljubazna, dobra komunikacija sa pacijentom, dr Bjeladinović i dr Kumburović su za svaku pohvalu. Izuzetno povoljna cena za specijalistički pregled.', 'Изузетно професионална, љубазна, добра комуникација са пацијентом, др Бјеладиновић и др Кумбуровић су за сваку похвалу. Изузетно повољна цена за специјалистички преглед.', NULL, NULL, NULL, NULL,
    2, '2022-09-06 16:29:04'),

(@user_nadya_ch, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNkbUlfX2t3RRAB',
    5, 'ru', 'Делали в Интер Кардио преоперационное  обследование сердца - ЭКГ и консультация врача. Цена 30€ (февраль 2024г.)',
    NULL, NULL, NULL, 'Делали в Интер Кардио преоперационное  обследование сердца - ЭКГ и консультация врача. Цена 30€ (февраль 2024г.)', NULL, NULL,
    1, '2024-02-11 09:44:40'),

(@user_srecna_zena, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OdVRWTTVUSGwyU1d4bVFWSjJNMFZoU3poaGQzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_ljiljana_janiijevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsd1VtZzNRblU0ZERWTFNHSldOVk4wTjFGc1dXYxAB',
    5, 'bs', 'Inter Cardio je poliklinika koja se nalazi u Radanovićima. Idući iz Kotora prema Budvi, kod Zećanke se skreće levo makadamskim putem koji vas vodi do poliklinike. Bili smo kod kardiologa dr Davora Kumburovića radi ultra zvuka srca. U zakazano vreme nas je primio veoma ljubazno, uradio ultra zvuk srca, ekg, i dao savet šta dalje. Preporuka.',
    'Inter Cardio je poliklinika koja se nalazi u Radanovićima. Idući iz Kotora prema Budvi, kod Zećanke se skreće levo makadamskim putem koji vas vodi do poliklinike. Bili smo kod kardiologa dr Davora Kumburovića radi ultra zvuka srca. U zakazano vreme nas je primio veoma ljubazno, uradio ultra zvuk srca, ekg, i dao savet šta dalje. Preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_mirko_milicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aaFlrNWpWSEZMTm1wVU5EWkdZMms1Y1doUWJVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_richard_djuricic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aWlpUbG1WVlJsYmtacVluSnRVVU5WTUdOUVkxRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_zeljko_vulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25odk5WaE9lWEp1TWxWcVZtTmtTV1ZhWjBNMGIwRRAB',
    5, 'en', 'Professional clinic',
    NULL, NULL, 'Professional clinic', NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ana_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSbU9HUktaVFpTWjJOblVFRjZkbVZUVkVKMGVuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jadranka_lazovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kTlduRXpabFJ1TjNZM1dITXpRemR3U25kVFNFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragan_pavicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChdDSUhNMG9nS0VJSFJ5UFdKNHRDYjNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_zvonko_gavrilovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnajUtTEt3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ana_savi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChdDSUhNMG9nS0VJQ0FnSURuamVmTzV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dragana_ilic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNydXNER3R3RRAB',
    5, 'bs', 'Svaka cas sa radom ove ordinacije.
Za zdravlje ne treba gubiti vrijeme prava adresa.Sve preporuke.👏💯🥂🙏',
    'Svaka cas sa radom ove ordinacije.
Za zdravlje ne treba gubiti vrijeme prava adresa.Sve preporuke.👏💯🥂🙏', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_boban_vojvoda, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChZDSUhNMG9nS0VJQ0FnSUNaOHRIdllREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_j_lynn, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChdDSUhNMG9nS0VJQ0FnSUR4NzZYNWtnRRAB',
    5, 'en', 'Professional and detailed exam',
    NULL, NULL, 'Professional and detailed exam', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_andjela_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChZDSUhNMG9nS0VJQ0FnSURCejZudkNBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_radmila_lazovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChZDSUhNMG9nS0VJQ0FnSUM4MnJ2VFZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_andrey_trofimov, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNjeGJXVHZnRRAB',
    5, 'ru', 'Хорошая клиника со всем современным оборудованием и хорошим доктором.',
    NULL, NULL, NULL, 'Хорошая клиника со всем современным оборудованием и хорошим доктором.', NULL, NULL,
    3, '2020-10-29 00:00:00'),

(@user_ivana_dakic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4fK0n8AtTBMRsAgj_O-ihMI/reviews/ChZDSUhNMG9nS0VJQ0FnSUMwaV8zcGZnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
