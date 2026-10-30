-- Insert Google Maps reviews for Tafica Dental Clinic
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/tafica-dental-clinic-ulcinj.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'tafica-dental-clinic-ulcinj');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_liridon_tafica = (SELECT id FROM doctors WHERE slug = 'liridon-tafica');
SET @doctor_admir_halili = (SELECT id FROM doctors WHERE slug = 'admir-halili');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Isabell Kelch', 'https://lh3.googleusercontent.com/a-/ALV-UjWDb3Ye99cmIFZQnJ17Kq88xXjgttJqL_M8bAjAQGOsEUYa05Tl=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/111290451737789078133/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111290451737789078133/reviews');
SET @user_isabell_kelch = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111290451737789078133/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Holger Blocksdorff', 'https://lh3.googleusercontent.com/a/ACg8ocJv9pCqE-p-_Rgzec6utzs8ascYX0guU-jfAYvDKESjiITUXQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113461102768861664508/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113461102768861664508/reviews');
SET @user_holger_blocksdorff = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113461102768861664508/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Angela Höth', 'https://lh3.googleusercontent.com/a/ACg8ocJ4PfaWRV7hxunqOh2ewN1BG29V4Vi1W6vga93h70dqvp01Hw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111886626427963665895/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111886626427963665895/reviews');
SET @user_angela_hth = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111886626427963665895/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anita Varga', 'https://lh3.googleusercontent.com/a-/ALV-UjWcmtx4gz0qOK2zl3peMP-D5Ohxfl7k3-hVyfzFb-T-_Wz5waQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105965930431685670075/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105965930431685670075/reviews');
SET @user_anita_varga = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105965930431685670075/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dainius', 'https://lh3.googleusercontent.com/a/ACg8ocIDCB1DovR_71LomdE1yLjlT_a3Ui0bmIiSE6_EzJ2OUjdFOA=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/104842674957328635618/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104842674957328635618/reviews');
SET @user_dainius = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104842674957328635618/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tolik Koval', 'https://lh3.googleusercontent.com/a/ACg8ocLbC6_foOKNuJPn-kKVBeUcIT4msnxcgAA5v8KyhoNCUE-sNw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117523601829193879368/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117523601829193879368/reviews');
SET @user_tolik_koval = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117523601829193879368/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Balkanik', 'https://lh3.googleusercontent.com/a-/ALV-UjV7ZqMlaEcFbx3VAOBDifpWMVvNuj0MJLBjcsr70D9igQl56jY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114082086164524838920/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114082086164524838920/reviews');
SET @user_balkanik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114082086164524838920/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Porodica Muratovic', 'https://lh3.googleusercontent.com/a/ACg8ocKzZJ0GAbmj0nqp_pnlXu0dSffqTmHi4IP8pZ4wRmeWlxIaTQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114213974609844923589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114213974609844923589/reviews');
SET @user_porodica_muratovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114213974609844923589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Enver Muratović', 'https://lh3.googleusercontent.com/a-/ALV-UjV9yP5kqB18KYOgUUk4gvL2wC6q6BzoBIPeJRk6Gp1jf612fQw9sQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113474985334732861524/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113474985334732861524/reviews');
SET @user_enver_muratovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113474985334732861524/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ljubicica plava', 'https://lh3.googleusercontent.com/a/ACg8ocIb7f_Yh5XOEnAdARCZytMUOtY_jL1qgLRnuXrcr-A2vUtoGQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116378424585253839954/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116378424585253839954/reviews');
SET @user_ljubicica_plava = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116378424585253839954/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jerzy Szegidewicz', 'https://lh3.googleusercontent.com/a-/ALV-UjVkVuOh2BdOODTKrCqjQXUSSa2weQa5uJP_dGpLUoLX3xK4EDEC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100549450905529127843/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100549450905529127843/reviews');
SET @user_jerzy_szegidewicz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100549450905529127843/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bejhana Hocanin', 'https://lh3.googleusercontent.com/a/ACg8ocLeZppGaJU57NI6N0_YlY17N7HDchghPzHxkpxp5KWhF1RBjg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109682461070662525390/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109682461070662525390/reviews');
SET @user_bejhana_hocanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109682461070662525390/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Jokic Dobrovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVALn2npF37MhTSRCc1iINLschn_z6G_RsS7Sj1bGGcRNHky4ehHQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106207795437584686241/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106207795437584686241/reviews');
SET @user_jelena_jokic_dobrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106207795437584686241/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bobic stefko', 'https://lh3.googleusercontent.com/a/ACg8ocLezbLJ98lKeTMS8hDgSmt1JtzxF1IFrmu6YRApHo2BSN26_w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108198213354822363894/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108198213354822363894/reviews');
SET @user_bobic_stefko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108198213354822363894/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milinko Labovic', 'https://lh3.googleusercontent.com/a/ACg8ocKT9IAkKhrQ7O47MN6HkSfUY9YTZ-Ysdf6SOSlTj7F4SlC06A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117341259034863445243/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117341259034863445243/reviews');
SET @user_milinko_labovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117341259034863445243/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tony Elezovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW5Ys1zPpv_UC54RcCJplrdjSvXK0qqQkzxgVurUnhL4qZ1BjY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104484512335372251107/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104484512335372251107/reviews');
SET @user_tony_elezovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104484512335372251107/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valon Kovaçi', 'https://lh3.googleusercontent.com/a-/ALV-UjXS9SfSiu43JX_LUpVZrHRBhEmoFqP30bh3lPPQg8W7XTAB0gik=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116783457053200064267/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116783457053200064267/reviews');
SET @user_valon_kovai = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116783457053200064267/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_isabell_kelch, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5bFVVVkZaSE5LVDJJNU9ETmZaRlJJTVRaTFIwRRAB',
    5, 'de', 'Dankeschön, bin in unserem Urlaub mit Zahnschmerzen zu diesem Zahnarzt, da ich unglaublich Angst vor dem Zahnarzt habe hatte ich dies erwähnt, der Arzt ist sehr auf mich eingegangen, hat immer wieder nach meinem befinden gefragt und ob ich Schmerzen habe während der Behandlung, wirklich Top. Eine Wurzelbehandlung musste gemacht werden, war wirklich klasse 👍🏻.  Nochmals vielen lieben Dank an den Herrn.',
    'Hvala vam puno! Otišao sam kod ovog zubara dok sam bio na odmoru sa zuboboljom. Spomenuo sam ovo jer se neverovatno plašim zubara. Doktor je bio veoma pažljiv prema mojim potrebama, više puta je pitao kako se osećam i da li me boli tokom lečenja. Bio je zaista odličan. Trebao mi je tretman korenskog kanala, i bilo je zaista fantastično. 👍🏻. Hvala još jednom ovom gospodinu.', 'Хвала вам пуно! Отишао сам код овог зубара док сам био на одмору са зубобољом. Споменуо сам ово јер се невероватно плашим зубара. Доктор је био веома пажљив према мојим потребама, више пута је питао како се осећам и да ли ме боли током лечења. Био је заиста одличан. Требао ми је третман коренског канала, и било је заиста фантастично. 👍🏻. Хвала још једном овом господину.', NULL, NULL, 'Dankeschön, bin in unserem Urlaub mit Zahnschmerzen zu diesem Zahnarzt, da ich unglaublich Angst vor dem Zahnarzt habe hatte ich dies erwähnt, der Arzt ist sehr auf mich eingegangen, hat immer wieder nach meinem befinden gefragt und ob ich Schmerzen habe während der Behandlung, wirklich Top. Eine Wurzelbehandlung musste gemacht werden, war wirklich klasse 👍🏻.  Nochmals vielen lieben Dank an den Herrn.', NULL,
    0, '2025-08-12 11:27:14'),

(@user_holger_blocksdorff, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChZDSUhNMG9nS0VJQ0FnSUQzbk82blN3EAE',
    5, 'de', 'Daaaaaankeschön. Der Arzt (und auch die Arzthelferin) war super freundlich, sprach super Englisch und hat mir genau erklärt, welche Möglichkeiten der Behandlung es für meinen schmerzenden Weisheitszahn gibt. Ich schreibe die Rezession erst jetzt, obwohl die Behandlung schon Mitte September war, weil ich sehen wollte, ob die Behandlung wirklich nachhaltig erfolgreich war. Und das war sie. Schmerzfrei kann ich meine Weltreise fortsetzen. Vielen, vielen Dank nochmals.',
    'Hvala vam puno. Doktor (i asistent) su bili super ljubazni, odlično su govorili engleski i objasnili su tačno koje opcije lečenja su dostupne za moj bolni umnjak. Ovu recenziju pišem tek sada, iako je tretman bio sredinom septembra, jer sam želeo da vidim da li je tretman zaista bio uspešan na duži rok. I bilo je. Mogu da nastavim svoje putovanje oko sveta bez bolova. Hvala vam još jednom.', 'Хвала вам пуно. Доктор (и асистент) су били супер љубазни, одлично су говорили енглески и објаснили су тачно које опције лечења су доступне за мој болни умњак. Ову рецензију пишем тек сада, иако је третман био средином септембра, јер сам желео да видим да ли је третман заиста био успешан на дужи рок. И било је. Могу да наставим своје путовање око света без болова. Хвала вам још једном.', NULL, NULL, 'Daaaaaankeschön. Der Arzt (und auch die Arzthelferin) war super freundlich, sprach super Englisch und hat mir genau erklärt, welche Möglichkeiten der Behandlung es für meinen schmerzenden Weisheitszahn gibt. Ich schreibe die Rezession erst jetzt, obwohl die Behandlung schon Mitte September war, weil ich sehen wollte, ob die Behandlung wirklich nachhaltig erfolgreich war. Und das war sie. Schmerzfrei kann ich meine Weltreise fortsetzen. Vielen, vielen Dank nochmals.', NULL,
    0, '2024-11-13 03:37:06'),

(@user_angela_hth, @clinic_id, @doctor_admir_halili, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUcHZuNGVREAE',
    5, 'de', 'Mir war eine Amalgam Plombe rausgefallen. Herr Dr. Admir Halili hat meinen Urlaub gerettet. Er hat sich viel Zeit genommen. Er spricht fantastisch englisch, ist super, super nett und hat mir einen wunderschönen Backenzahn gemacht. Mit der Anästhesie hatte ich keine Schmerzen. Die Praxis ist tip top. Ich würde sagen, die Behandlung ist besser als in Deutschland - und das zu einem wirklich günstigen Preis!!
Wenn ich mal eine größere Behandlung brauchen würde, steht für mich fest, dass ich dafür zu Dr. Halili fliegen werde.',
    'Ispala mi je amalgamska plomba. Dr Admir Halili mi je spasao odmor. Uzeo je svoje vreme. Govori fantastično engleski, super je, super fin, i popravio mi je prelep kutnjak. Uz anesteziju nisam osećao nikakav bol. Praksa je vrhunska. Rekao bih da je tretman bolji nego u Nemačkoj – i to po zaista razumnoj ceni!
Ako mi ikada zatreba veća procedura, sigurno ću leteti kod dr Halilija.', 'Испала ми је амалгамска пломба. Др Адмир Халили ми је спасао одмор. Узео је своје време. Говори фантастично енглески, супер је, супер фин, и поправио ми је прелеп кутњак. Уз анестезију нисам осећао никакав бол. Пракса је врхунска. Рекао бих да је третман бољи него у Немачкој – и то по заиста разумној цени!
Ако ми икада затреба већа процедура, сигурно ћу летети код др Халилија.', NULL, NULL, 'Mir war eine Amalgam Plombe rausgefallen. Herr Dr. Admir Halili hat meinen Urlaub gerettet. Er hat sich viel Zeit genommen. Er spricht fantastisch englisch, ist super, super nett und hat mir einen wunderschönen Backenzahn gemacht. Mit der Anästhesie hatte ich keine Schmerzen. Die Praxis ist tip top. Ich würde sagen, die Behandlung ist besser als in Deutschland - und das zu einem wirklich günstigen Preis!!
Wenn ich mal eine größere Behandlung brauchen würde, steht für mich fest, dass ich dafür zu Dr. Halili fliegen werde.', NULL,
    0, '2024-05-14 06:58:46'),

(@user_anita_varga, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChZDSUhNMG9nS0VJQ0FnSURrcU4yVkNREAE',
    5, 'hu', 'Rendkívüli hely, fantasztikus fogorvossal, pedig a férjem rendesen meg volt ijedve :) Sok gyermeket is láttam a rendelőben, ami számomra azt bizonyítja, hogy a fogorvos jól bánik a pácienseivel :) Az árak is igazán korrektek, és a munkája is kifogástalan. Bátran ajánlom mindenkinek :)

Great place with fantastic dentist. My husband was afraid :), but everything went just fine :) I saw a lots of kids too, and he was treating them great. The prices are fair, and he\'s work is also great. If you ever need a dentist in Ulcinj, you should visit him for sure :)',
    'Odlično mesto sa fantastičnim zubarom. Moj muž se plašio :), ali sve je prošlo u redu :) Videla sam i mnogo dece, i on se odlično prema njima ponašao. Cene su poštene, a i njegov rad je odličan. Ako vam ikada zatreba zubar u Ulcinju, obavezno ga posetite :)', 'Одлично место са фантастичним зубаром. Мој муж се плашио :), али све је прошло у реду :) Видела сам и много деце, и он се одлично према њима понашао. Цене су поштене, а и његов рад је одличан. Ако вам икада затреба зубар у Улцињу, обавезно га посетите :)', NULL, NULL, NULL, NULL,
    1, '2019-06-23 11:57:02'),

(@user_dainius, @clinic_id, @doctor_liridon_tafica, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChZDSUhNMG9nS0VJQ0FnSURicEtqUE5BEAE',
    5, 'en', 'Sincere thanks to the dentist Liridon Tafica and his colleagues for the qualified help(tooth extraction),which allowed me to continue my vacation without toothache.The greatest recommendations!',
    NULL, NULL, 'Sincere thanks to the dentist Liridon Tafica and his colleagues for the qualified help(tooth extraction),which allowed me to continue my vacation without toothache.The greatest recommendations!', NULL, NULL, NULL,
    0, '2024-08-02 05:40:05'),

(@user_tolik_koval, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xZNVRuZFVVRE50TUdGTU1XWm9SWEpUUjBsaVdFRRAB',
    5, 'uk', 'Дякую! Дуже професійно і швидко полікував всі зуби.
Ціни в порівнянні з Польщею нижчі.
Ще раз сердечно дякую!',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_balkanik, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOcFVWZEVMVXd5UTFaalZqUnNSek5KYW1SME0zYxAB',
    5, 'hr', 'Jednom sedmično dolazi dermatolog gospođa Nora tafica i mogu je svakome slobodno preporučiti moj je sin imao dermatitis ona je to odmah prepoznala i dala nam odgovarajući lijek svaka čast',
    'Jednom sedmično dolazi dermatolog gospođa Nora tafica i mogu je svakome slobodno preporučiti moj je sin imao dermatitis ona je to odmah prepoznala i dala nam odgovarajući lijek svaka čast', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_porodica_muratovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pRMWQwbExZMGt3V21kbGVFTnliRWhJYzJwVWNIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_enver_muratovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWWGNGZDJZbk5YVm05M1RHZFdWa1Y2WmpSV1pXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ljubicica_plava, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s0M1MzZFhUbEZ1TlZCSlN6SlZUalJ6T0ZoUk9FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jerzy_szegidewicz, @clinic_id, @doctor_admir_halili, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIbjRxdENREAE',
    5, 'en', 'Very professional and sympathetic service of Dr Admir Halili.
Tkank you!',
    NULL, NULL, 'Very professional and sympathetic service of Dr Admir Halili.
Tkank you!', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_bejhana_hocanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChZDSUhNMG9nS0VJQ0FnSURidFlxblBBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jelena_jokic_dobrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNicExySndRRRAB',
    5, 'hr', 'Sve pohvale za doktora i sve zaposlene.
Primili su nas isti dan, pregledali i dali terapiju za dete. Svi su jako ljubazni i profesionalni. Hvala najlepše.',
    'Sve pohvale za doktora i sve zaposlene.
Primili su nas isti dan, pregledali i dali terapiju za dete. Svi su jako ljubazni i profesionalni. Hvala najlepše.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_bobic_stefko, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwNjRIcDFnRRAB',
    5, 'hr', 'Super momci svaka cast Professionalci i fer cijene samo rijeci hvale.. Bravo i tako nastavite',
    'Super momci svaka cast Professionalci i fer cijene samo rijeci hvale.. Bravo i tako nastavite', NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_milinko_labovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChdDSUhNMG9nS0VJQ0FnSURDNllLVHdBRRAB',
    5, 'bs', 'Odlicno!!!',
    'Odlicno!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_tony_elezovic, @clinic_id, @doctor_liridon_tafica, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChdDSUhNMG9nS0VJQ0FnSURVZ01HWjRnRRAB',
    5, 'en', 'The best dental experience I have had thus far. Professional, experienced & friendly. I highly recommend Dr. Liridon Tafica',
    NULL, NULL, 'The best dental experience I have had thus far. Professional, experienced & friendly. I highly recommend Dr. Liridon Tafica', NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_valon_kovai, @clinic_id, NULL, 'google_maps',
    'places/ChIJja4C-WQTThMR-4-t1EmDqW8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNneEpUaDVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
