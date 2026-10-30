-- Insert Google Maps reviews for Pat Lab
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/pat-lab-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'pat-lab-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'asmir agovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVTWiKcj_-Wyb8ZfRlvjKciCx-oIGZ9ao3HiZ0-FyrKHBuQs9w=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/118022367534697209784/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118022367534697209784/reviews');
SET @user_asmir_agovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118022367534697209784/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina Radulovic', 'https://lh3.googleusercontent.com/a-/ALV-UjViudiepVlVN66rncvFq1eK14eS6kfOhvs8bX2tFovCEQKE5GjJZQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100274811949575807486/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100274811949575807486/reviews');
SET @user_mina_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100274811949575807486/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sergei Pavlovich', 'https://lh3.googleusercontent.com/a/ACg8ocL-HEeG6eBrbPYw8acOvtinmPJ51Rlxj5BtWJu4bT0AB29PxQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101815806376814242398/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101815806376814242398/reviews');
SET @user_sergei_pavlovich = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101815806376814242398/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Drobnjak', 'https://lh3.googleusercontent.com/a/ACg8ocJldNREeeH8EUfDx-2Fk8pcH-8_otlJzlEsvT7jwDK6GZcMDA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104708088663045943930/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104708088663045943930/reviews');
SET @user_milica_drobnjak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104708088663045943930/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Krgović', 'https://lh3.googleusercontent.com/a/ACg8ocL0w-IjQakTeKqkbHyoy7LXLvOuEBgICGlWb4Ao34JYYVc0wA=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/104163679697891142357/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104163679697891142357/reviews');
SET @user_ivan_krgovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104163679697891142357/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dušan Radojicic', 'https://lh3.googleusercontent.com/a/ACg8ocJW1mB5O-YQiE-BADZPiWt3ZJCYQ6J-QYfLTnzEO0MJ2ppj3Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116621244473122180287/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116621244473122180287/reviews');
SET @user_duan_radojicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116621244473122180287/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Drobnjak', 'https://lh3.googleusercontent.com/a/ACg8ocIcVKLHgPfer9lk-_Zf0QbLyhq0XftOA-6r7yY4WqexLE3fbA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103009181506741407996/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103009181506741407996/reviews');
SET @user_milica_drobnjak_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103009181506741407996/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milovan Drobnjak', 'https://lh3.googleusercontent.com/a/ACg8ocII-86SQuCSFM6OqoCmODb0PqUNl4TUKAhkZlgOl_q6R_aj3Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108149507663580295672/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108149507663580295672/reviews');
SET @user_milovan_drobnjak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108149507663580295672/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Drobnjak', 'https://lh3.googleusercontent.com/a/ACg8ocJK1-vqki9HCVTfE8gILe_yOEyDEJq4hoyuLCJgPVevlixgbg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104720138248463479839/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104720138248463479839/reviews');
SET @user_jovana_drobnjak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104720138248463479839/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milutin Micko Jovancevic', 'https://lh3.googleusercontent.com/a/ACg8ocIqCHiq2UagtlFRzUndqmhSqwfDRrXqmOqqhRzhp0ISlyKk4yA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100956645186935914137/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100956645186935914137/reviews');
SET @user_milutin_micko_jovancevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100956645186935914137/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Nikolić', 'https://lh3.googleusercontent.com/a-/ALV-UjWX9U-PyPqn6az0QDPnqPsSSe6K8aPJ2C0-wZN0jmpHNcCzhYT0=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115432119712380496379/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115432119712380496379/reviews');
SET @user_aleksandra_nikoli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115432119712380496379/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Brandmajer', 'https://lh3.googleusercontent.com/a/ACg8ocKsyVKf7dB3by0_qpaaGOCpvnk1JyxuI5dj69jv_E4TGI5btg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109412017071162087874/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109412017071162087874/reviews');
SET @user_tijana_brandmajer = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109412017071162087874/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Zecevic', 'https://lh3.googleusercontent.com/a/ACg8ocIBgXslCMwlrEvu-MIaAa36nCt-JKx5YCWLHbCoGUBux6FZIw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112506108821716567262/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112506108821716567262/reviews');
SET @user_aleksandra_zecevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112506108821716567262/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Joksimovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVdpJINeSuQfAxCY2DJ6HrjB6KAzs1W19T9PcSD79a0I5soYiM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106552440782363511143/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106552440782363511143/reviews');
SET @user_ivan_joksimovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106552440782363511143/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pat Lab', 'https://lh3.googleusercontent.com/a/ACg8ocKWxA8QAwjLBbVDF5X6Yi1cvGdfGQ4IZV8tUshGBFwZIEpYtw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106384495217677774311/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106384495217677774311/reviews');
SET @user_pat_lab = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106384495217677774311/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_asmir_agovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsV01XbEJYeTE0VTJKSWFFUndkV2RJTjFOeWRIYxAB',
    1, 'bs', 'Poseta laboratoriji bila je razočaravajuća. Osoblje na šalteru nervozno i neljubazno, krajnje neprofesionalno. Zaista, nikad gore iskustvo – čak i u državnim ustanovama, gde su usluge besplatne, tamo sam susreo  mnogo prijatnije osoblje. Ni u drugim privatnim ustanovama nisam naišao na ovakvo ponašanje.

Nova laboratorija i novo negativno iskustvo.',
    'Poseta laboratoriji je bila razočaravajuća. Osoblje na šalteru je bilo nervozno i neljubazno, krajnje neprofesionalno. Zaista, nikad gore iskustvo – čak i u državnim institucijama, gde su usluge besplatne, tamo sam upoznao mnogo lepše osoblje. Ni u drugim privatnim ustanovama nisam se susreo sa takvim ponašanjem.

Nova laboratorija i novo negativno iskustvo.', 'Посета лабораторији је била разочаравајућа. Особље на шалтеру је било нервозно и нељубазно, крајње непрофесионално. Заиста, никад горе искуство – чак и у државним институцијама, где су услуге бесплатне, тамо сам упознао много лепше особље. Ни у другим приватним установама нисам се сусрео са таквим понашањем.

Нова лабораторија и ново негативно искуство.', NULL, NULL, NULL, NULL,
    0, '2025-09-25 22:55:25'),

(@user_mina_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25RMVZsVktZa0ZTTlc5cmEwUkpkVUUwVjNkRFduYxAB',
    5, 'bs', 'Nevjerovatan profesionalizam i ljubaznost!
Pocev od sestre koja nas je docekala na pultu do rezultata koji su bili u tacno navedenom roku.',
    'Neverovatan profesionalizam i ljubaznost!
Počev od medicinske sestre koja nas je dočekala na šalteru do rezultata koji su bili tačno na vreme.', 'Невероватан професионализам и љубазност!
Почев од медицинске сестре која нас је дочекала на шалтеру до резултата који су били тачно на време.', NULL, NULL, NULL, NULL,
    0, '2025-09-28 20:29:46'),

(@user_sergei_pavlovich, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poNk0zQTJTbWczUTNka2FVOWxSRTVEVlcwNWNHYxAB',
    5, 'en', 'Friendly approach, very kind and professional employees.
Me and my family are thankful for your support and assistance.
Deadlines met, results satisfying at the end.
All the best!',
    'Ljubazan pristup, veoma ljubazni i profesionalni radnici.
Ja i moja porodica smo zahvalni na vašoj podršci i pomoći.
Rokovi ispoštovani, rezultati na kraju zadovoljavajući.
Sve najbolje!', 'Љубазан приступ, веома љубазни и професионални радници.
Ја и моја породица смо захвални на вашој подршци и помоћи.
Рокови испоштовани, резултати на крају задовољавајући.
Све најбоље!', 'Friendly approach, very kind and professional employees.
Me and my family are thankful for your support and assistance.
Deadlines met, results satisfying at the end.
All the best!', NULL, NULL, NULL,
    0, '2025-09-29 13:24:00'),

(@user_milica_drobnjak, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oS05raHdia1Z2VkRFd2NYVjFaMlJJWTBvdGRGRRAB',
    5, 'hr', 'Preljubaazni, profesionalni i odgovorni, svaka čast! Velika preporuka!! 👍',
    'Veoma ljubazno, profesionalno i odgovorno, čestitam! Toplo preporučujem!! 👍', 'Веома љубазно, професионално и одговорно, честитам! Топло препоручујем!! 👍', NULL, NULL, NULL, NULL,
    0, '2025-09-28 17:46:56'),

(@user_ivan_krgovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SaGNrVnRVR1JwY3pneVdESnFZVE15WnpJMlltYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-24 16:33:50'),

(@user_duan_radojicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pnM04zUmpVa0psWjBacGVVSXhMVmRCTTFKRmRWRRAB',
    5, 'sr', 'Свака част на љубазности и професионализму особља. Велика захвалност невјероватно доброј и предивној госпођи Проф др Лидији Ињац Стевовић. Разговор са њом је велики благослов.',
    'Svaka čast na ljubaznosti i profesionalizmu osoblja. Velika zahvalnost nevjerovatno dobroj i predivnoj gospođi Prof dr Lidiji Injac Stevović. Razgovor sa njom je veliki blagoslov.', 'Свака част на љубазности и професионализму особља. Велика захвалност невјероватно доброј и предивној госпођи Проф др Лидији Ињац Стевовић. Разговор са њом је велики благослов.', NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_milica_drobnjak_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSblRHTlBRalV4TURaamRHWkVjRmM0VDNZMFFWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_milovan_drobnjak, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KVFlXUXpTRGszTkVGV2NXeFdkMVpDVDAxVk1WRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_drobnjak, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xRlpuRXlUa3BDYkROTFpYRnBOMGROY2xZMFZrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milutin_micko_jovancevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGdVJERndTbUpYTVVoNU1WUlRkR050ZDNCMVEyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aleksandra_nikoli, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/ChdDSUhNMG9nS0VJQ0FnTUR3OE16ajRnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_tijana_brandmajer, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/ChZDSUhNMG9nS0VJQ0FnTUNneHBtSmN3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aleksandra_zecevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/ChdDSUhNMG9nS0VJQ0FnTURBM0xTMHJnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ivan_joksimovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBdzUtTm5nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_pat_lab, @clinic_id, NULL, 'google_maps',
    'places/ChIJ7wtduerrTRMRbP8KNitEJW4/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBOGRpZlRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
