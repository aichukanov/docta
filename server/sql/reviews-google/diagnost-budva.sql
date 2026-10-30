-- Insert Google Maps reviews for Diagnost - ultrasound diagnostic clinic Montenegro
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/diagnost-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'diagnost-budva');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_marija_mandic = (SELECT id FROM doctors WHERE slug = 'marija-mandic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirka Knezevic', 'https://lh3.googleusercontent.com/a/ACg8ocKE2Vb_Li5wg4fR6IYfsG3r6L_msG70dskRg2vfXAAMety6-w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104922208658548611425/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104922208658548611425/reviews');
SET @user_mirka_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104922208658548611425/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Игорь Дмитриев', 'https://lh3.googleusercontent.com/a-/ALV-UjVRhofZ-VoGwh94HPMOAAVzBVKmvHSvFmJPpga04A7sS_3b7Trr=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104319126376939682531/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104319126376939682531/reviews');
SET @user_igor_dmitriev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104319126376939682531/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Villa Wellness', 'https://lh3.googleusercontent.com/a-/ALV-UjVY-OveOewpFpteki0xUorYMq73JXoI-wmbAlzEcDFDUEhgN8E=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106551044738696448922/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106551044738696448922/reviews');
SET @user_villa_wellness = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106551044738696448922/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Mihaljica', 'https://lh3.googleusercontent.com/a/ACg8ocKXX2pxxd3cs8iza3ZqImXbEU6JY649c0AH769pZuCiRidS7g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110379263963151241201/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110379263963151241201/reviews');
SET @user_tanja_mihaljica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110379263963151241201/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алина Мороховец', 'https://lh3.googleusercontent.com/a-/ALV-UjWlK4Ae1_RIdYpn24RZiHO5qubXOAGZqihFXvj1zm0P2jGS1fQ=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/112918282012684892609/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112918282012684892609/reviews');
SET @user_alina_morokhovets = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112918282012684892609/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Violetta Leonova', 'https://lh3.googleusercontent.com/a/ACg8ocJcePYGuU9Lh6pdJajCZTo6F9FVtltPEWnLo-wj8ATitd7pXA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117074868305293235471/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117074868305293235471/reviews');
SET @user_violetta_leonova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117074868305293235471/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Lazarevic', 'https://lh3.googleusercontent.com/a/ACg8ocJDdV6QgDifcQGvG5Dlb_EJXRGgTQmBnQmfyU-nYCp7dShRkQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105930774760692438820/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105930774760692438820/reviews');
SET @user_ksenija_lazarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105930774760692438820/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jadranka Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocLs3XfaNfoGkCm1dsxduUCnxcFwjd38h7dKuaj_pd-R755cnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109606255264451294410/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109606255264451294410/reviews');
SET @user_jadranka_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109606255264451294410/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Paula Zifra', 'https://lh3.googleusercontent.com/a-/ALV-UjV_fb2YW_jswpITXye4sr9srhcZmPQX4wYl2f6kTBE73uLtb-Ud=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117210307665801580508/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117210307665801580508/reviews');
SET @user_paula_zifra = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117210307665801580508/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ganna Bogomaz', 'https://lh3.googleusercontent.com/a/ACg8ocL5ABNbEiiqPBuvGIGtx5gVyjOjrgZvHTwJRsDWI7codRnu5w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117757644614338477392/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117757644614338477392/reviews');
SET @user_ganna_bogomaz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117757644614338477392/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Павел Рожков', 'https://lh3.googleusercontent.com/a-/ALV-UjUTVx3b9mqIuIW_S0q5dj1OadpIzequiRW6T_sbW5yNrFCl7IQB=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101500828575729066977/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101500828575729066977/reviews');
SET @user_pavel_rozhkov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101500828575729066977/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Perosevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUikKSP-FCT3vVj0juAV5EARPqMobuPBs85ZQSH29PQsMiHa_00=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110532652638662031439/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110532652638662031439/reviews');
SET @user_sandra_perosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110532652638662031439/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Jovovic', 'https://lh3.googleusercontent.com/a/ACg8ocL4H-yo4ooX0yC8PyQrn8DZVsVl4hwbvkVTCfI-8UNyQD2jDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117276227006274942650/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117276227006274942650/reviews');
SET @user_bojana_jovovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117276227006274942650/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadia', 'https://lh3.googleusercontent.com/a-/ALV-UjWDyNNcKrQLIiYW8rRBoehP-LPOk2hAiWGvMI8lgjfrPuN9gfWhwg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100013793153353595866/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100013793153353595866/reviews');
SET @user_nadia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100013793153353595866/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'aleksandra radulovic', 'https://lh3.googleusercontent.com/a/ACg8ocJxNb-t5EQqh-T2RPgsNGVQqsXJDpyYw-XuQ9nSFPQd5vWhew=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101597939551460918452/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101597939551460918452/reviews');
SET @user_aleksandra_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101597939551460918452/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darko Mandic', 'https://lh3.googleusercontent.com/a-/ALV-UjWCI6ibW3TaS8BqbAkfOnmXuyh_eE-TULHWkeQ1N7SSxiEKIj-I=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100944463650974874110/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100944463650974874110/reviews');
SET @user_darko_mandic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100944463650974874110/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Papic', 'https://lh3.googleusercontent.com/a/ACg8ocJBu6-0VXsC1xp4OkUZHNL3Q42YH0wKsGIdwJHe8UPRlBChWg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114246512498707105181/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114246512498707105181/reviews');
SET @user_nikola_papic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114246512498707105181/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pedja Zivkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJc3oHisXR0mhKx-PzNNX2FB9wKLmdKfwFg-ecDuaQwRwUM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100782373733726982367/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100782373733726982367/reviews');
SET @user_pedja_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100782373733726982367/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'luka skodric', 'https://lh3.googleusercontent.com/a/ACg8ocI94FZmfv46EfB5RaNik7vO_PjPqmiCPGKyDv1xLW3XBEhWnw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103904518811794676334/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103904518811794676334/reviews');
SET @user_luka_skodric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103904518811794676334/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kseniia Kseniia', 'https://lh3.googleusercontent.com/a-/ALV-UjU-JAUbD3HKkPwOOezgKGTNBRnwmKZQWF6Kx8UKDwZGppMdc-Jf=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115880129547903009816/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115880129547903009816/reviews');
SET @user_kseniia_kseniia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115880129547903009816/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Isidora Vitezovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWj1wBU3pVGQMLWBAdLg1C-qpq7FlNRaEPKt-5hP6fVbJvJYQD6=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115586745359132322952/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115586745359132322952/reviews');
SET @user_isidora_vitezovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115586745359132322952/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_mirka_knezevic, @clinic_id, @doctor_marija_mandic, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21scFVVcGxSREZhV1hGeFIxOXRWRGQ1YjNKVVVrRRAB',
    5, 'bs', 'Vrhunski tim strucnjaka. Najbolji radiolozi dr Marija i dr Igor. Sve preporuke.',
    'Vrhunski tim stručnjaka. Najbolji radiolozi dr Marija i dr Igor. Sve preporuke.', 'Врхунски тим стручњака. Најбољи радиолози др Марија и др Игор. Све препоруке.', NULL, NULL, NULL, NULL,
    0, '2025-08-14 13:56:28'),

(@user_igor_dmitriev, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqdjczRzFBRRAB',
    5, 'ru', 'Сделал узи колена за 40 евро. Осматривала врач, неплохо говорящая по русски, все хорошо объяснила. Спасибо',
    'Uradio sam ultrazvuk kolena za 40 evra. Doktor koji me je pregledao je dobro govorio ruski i sve je lepo objasnio. Hvala vam.', 'Урадио сам ултразвук колена за 40 евра. Доктор који ме је прегледао је добро говорио руски и све је лепо објаснио. Хвала вам.', NULL, 'Сделал узи колена за 40 евро. Осматривала врач, неплохо говорящая по русски, все хорошо объяснила. Спасибо', NULL, NULL,
    0, '2024-04-27 18:03:06'),

(@user_villa_wellness, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUR4NWJiMjdRRRAB',
    5, 'ru', 'Сделали узи малышу, приятная доктор, все объяснила. Рекомендую!',
    'Imali smo ultrazvuk za našu bebu. Doktorka je bila veoma ljubazna i sve je objasnila. Toplo je preporučujem!', 'Имали смо ултразвук за нашу бебу. Докторка је била веома љубазна и све је објаснила. Топло је препоручујем!', NULL, 'Сделали узи малышу, приятная доктор, все объяснила. Рекомендую!', NULL, NULL,
    1, '2023-06-12 12:08:22'),

(@user_tanja_mihaljica, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnSURIb2VIdENnEAE',
    5, 'bs', 'Sve preporuke za doktorku, strucnost i ljubaznost na nivou 😊',
    'Sve preporuke za doktora, profesionalizam i ljubaznost na najvišem nivou 😊', 'Све препоруке за доктора, професионализам и љубазност на највишем нивоу 😊', NULL, NULL, NULL, NULL,
    0, '2024-09-16 19:58:22'),

(@user_alina_morokhovets, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxNWIybEZTSEZLTlRsNkxXMUdVMWxXUjFScmVWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-11 21:58:12'),

(@user_violetta_leonova, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GWGNVWmlTMkp4TFZwRFkyRndiMWxhZUhaR1psRRAB',
    5, 'ru', 'Очень приятная доктор, объяснила грамотно и доступно',
    NULL, NULL, NULL, 'Очень приятная доктор, объяснила грамотно и доступно', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_ksenija_lazarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paT1VqRnNURTFMTmkwMFNrOXdVakEwVEhKaVdHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jadranka_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psS1VHOXhkMGh4UzJJNWRIcHNNMkZ0ZFVkTWIwRRAB',
    5, 'hr', 'Profesionalna usluga,vrlo zadovoljni, za svaku preporuku.',
    'Profesionalna usluga,vrlo zadovoljni, za svaku preporuku.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_paula_zifra, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kWE5WbDBZVEpmWXpoQkxUWjBUR1ppTkdzM1psRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_ganna_bogomaz, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaNE5VOUtTRVJHUzNNNWJVaFJXRkJTT0ZScmNuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_pavel_rozhkov, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5TFZsZEJjVUk0TTBWUVdGZHVjalZGWDAxMGNtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_sandra_perosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnTURnajdmTEFREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_bojana_jovovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSURmMXVTRG9nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_nadia, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2MXVYM2VREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aleksandra_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3c2F2OVRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_darko_mandic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNoLXB6cy1nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nikola_papic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNWc3REQWxnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_pedja_zivkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSURwX3NpWTl3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_luka_skodric, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnSURwX29pM1ZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_kseniia_kseniia, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnSUNCdTdMVWJnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_isidora_vitezovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlOS02WW1BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21scFVVcGxSREZhV1hGeFIxOXRWRGQ1YjNKVVVrRRAB'),
  'clinic', @clinic_id,
  'Hvala puno!!!', 'hr',
  'Hvala puno!!!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqdjczRzFBRRAB'),
  'clinic', @clinic_id,
  'Hvala puno!Pozdrav', 'hr',
  'Hvala puno!Pozdrav', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUR4NWJiMjdRRRAB'),
  'clinic', @clinic_id,
  'Hvala puno!!!Pozdrav', 'hr',
  'Hvala puno!!!Pozdrav', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GWGNVWmlTMkp4TFZwRFkyRndiMWxhZUhaR1psRRAB'),
  'clinic', @clinic_id,
  'Hvala puno!', 'hr',
  'Hvala puno!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-09-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psS1VHOXhkMGh4UzJJNWRIcHNNMkZ0ZFVkTWIwRRAB'),
  'clinic', @clinic_id,
  'Hvala puno', 'hr',
  'Hvala puno', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kWE5WbDBZVEpmWXpoQkxUWjBUR1ppTkdzM1psRRAB'),
  'clinic', @clinic_id,
  'Hvala puno', 'hr',
  'Hvala puno', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaNE5VOUtTRVJHUzNNNWJVaFJXRkJTT0ZScmNuYxAB'),
  'clinic', @clinic_id,
  'Hvala puno', 'hr',
  'Hvala puno', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5TFZsZEJjVUk0TTBWUVdGZHVjalZGWDAxMGNtYxAB'),
  'clinic', @clinic_id,
  'Hvala puno!
Diagnost', 'hr',
  'Hvala puno!
Diagnost', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnTURnajdmTEFREAE'),
  'clinic', @clinic_id,
  'Hvala puno!!!', 'hr',
  'Hvala puno!!!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2MXVYM2VREAE'),
  'clinic', @clinic_id,
  'Hvala puno', 'hr',
  'Hvala puno', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJKQtwIC_VTRMRbjpsrWfQwiI/reviews/ChdDSUhNMG9nS0VJQ0FnSUNWc3REQWxnRRAB'),
  'clinic', @clinic_id,
  'Hvala!!!', 'hr',
  'Hvala!!!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
