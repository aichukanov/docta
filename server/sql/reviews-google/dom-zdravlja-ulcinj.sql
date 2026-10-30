-- Insert Google Maps reviews for Health center Ulcinj
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-ulcinj.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-ulcinj');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_maida_gjoni = (SELECT id FROM doctors WHERE slug = 'maida-gjoni');
SET @doctor_sanela_abazovic_hot = (SELECT id FROM doctors WHERE slug = 'sanela-abazovic-hot');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'meto odobasic', 'https://lh3.googleusercontent.com/a-/ALV-UjXe6rukhsV8dP-3CrCTc_8pSr-o6yJB6Hlgd0GfqMS2V9ZozEo=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/102597399933018880509/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102597399933018880509/reviews');
SET @user_meto_odobasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102597399933018880509/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Edin Mujanović', 'https://lh3.googleusercontent.com/a-/ALV-UjU3u50e48R6yokcKWAZS0vceTRJ1GQJ1_-3CQrFk5kM0AKVqNxe2Q=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/112384769069884846047/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112384769069884846047/reviews');
SET @user_edin_mujanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112384769069884846047/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'gjonson simoni', 'https://lh3.googleusercontent.com/a-/ALV-UjUJdtjIEHbmXoHc0ekKEhFiuSuW6sIUnurdD7u-C9pKPxqUFFXsOQ=s128-c0x00000000-cc-rp-mo-ba6', 'https://www.google.com/maps/contrib/103476084440050708779/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103476084440050708779/reviews');
SET @user_gjonson_simoni = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103476084440050708779/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selina H.', 'https://lh3.googleusercontent.com/a-/ALV-UjXJALDGAFH_6Vfk22f-iyp4pK4jTPdBP3JEyoHDlnnNzGuDhpdV=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116934438950793574837/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116934438950793574837/reviews');
SET @user_selina_h = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116934438950793574837/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branislaw 549', 'https://lh3.googleusercontent.com/a-/ALV-UjUxkR0PZbR3VT1niac7TVfWd5wRsbvWT68tobG0Av1PGde5MB9Z=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/108624083426648107769/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108624083426648107769/reviews');
SET @user_branislaw_549 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108624083426648107769/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vanessa Ducke', 'https://lh3.googleusercontent.com/a/ACg8ocKzVM7bpONzUYcd2NdXfRb8GZqLREcq9vynCcNF-B2MeBCt4A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110386258001347474969/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110386258001347474969/reviews');
SET @user_vanessa_ducke = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110386258001347474969/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mustafa Okić', 'https://lh3.googleusercontent.com/a/ACg8ocI3OrjhDMUh5YRVR-W6q7XggFIyJgQ4rtx44CU7acSo_OBzwQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110995198126902959498/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995198126902959498/reviews');
SET @user_mustafa_oki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995198126902959498/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Kitanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKw9eWXepzXS8rdR8gzrbbVNy30UWnDmgQp5-pJZWMGaweagQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100791623853974881824/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100791623853974881824/reviews');
SET @user_predrag_kitanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100791623853974881824/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Janosch Süberkrüb', 'https://lh3.googleusercontent.com/a-/ALV-UjVzqd_1nXMfr9Zp4kFUui16BOY5wogtw4s1fmcPOMqFzgKUCse3=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111870930390512586386/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111870930390512586386/reviews');
SET @user_janosch_sberkrb = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111870930390512586386/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Arlind Lika', 'https://lh3.googleusercontent.com/a-/ALV-UjXBIW1gxpdHU7bcgomElEXittnvMqXrNmNxi0uQRaseq33__0BmfQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112941878648840399477/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112941878648840399477/reviews');
SET @user_arlind_lika = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112941878648840399477/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Žarčanin', 'https://lh3.googleusercontent.com/a-/ALV-UjXjA3IbGNDjbILrw_dadwfa3VTk9Qlq8brko69uwW2iRQ9doSsp=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100491810872811573139/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100491810872811573139/reviews');
SET @user_andjela_aranin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100491810872811573139/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Blerim Zogaj', 'https://lh3.googleusercontent.com/a-/ALV-UjVrZAjRfXQxWVsRr0OHkZ0xd-MuezEkOnsmO3tcK3W5j9GdwAs=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109673664400552162923/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109673664400552162923/reviews');
SET @user_blerim_zogaj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109673664400552162923/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ENVER. R. BAHTIJA', 'https://lh3.googleusercontent.com/a-/ALV-UjUf1dvHJv3KNday9bCwIYQAJ71SMH8fVZzktv-D9FMf23Kadggb=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100053111393325290234/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100053111393325290234/reviews');
SET @user_enver_r_bahtija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100053111393325290234/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Meriton Zherka', 'https://lh3.googleusercontent.com/a-/ALV-UjVhqY3gpAoJJMKjP16uO4PP3iQxjTgOEVYKQLlBcLpB67Wve49Ixw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103819372168689287731/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103819372168689287731/reviews');
SET @user_meriton_zherka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103819372168689287731/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Margaretha Kuci', 'https://lh3.googleusercontent.com/a/ACg8ocK1O9Dy6w498WCg-M0-5EJi1kI9DvXhXDftzVo0u-R0skm-hQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104138748428188831557/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104138748428188831557/reviews');
SET @user_margaretha_kuci = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104138748428188831557/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jamin', 'https://lh3.googleusercontent.com/a-/ALV-UjVI9F4eXLxOQgOVBtzELf2IY75U0mTspRG107T5mXHF6YorGgTl=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101653233865597227149/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101653233865597227149/reviews');
SET @user_jamin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101653233865597227149/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alem Dzehverovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWGAcQW03qhvYX8jx9IHVpM3_WP_KwCXXdIA6XQup6UnEYa-Kl6rg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103699124023730713743/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103699124023730713743/reviews');
SET @user_alem_dzehverovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103699124023730713743/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Coco puppy', 'https://lh3.googleusercontent.com/a-/ALV-UjWTIsuar3Kve5aJvo1rNdptNH7LggkHYX48lRDpVTw4WRw2mEEd=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117646584333961267677/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117646584333961267677/reviews');
SET @user_coco_puppy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117646584333961267677/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'majdam100', 'https://lh3.googleusercontent.com/a/ACg8ocIW8HmRjv35o7fQ5WMjTsrTEM5-PzZ6VnDqAuyMxLIa2WtLSQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105218751516307214371/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105218751516307214371/reviews');
SET @user_majdam100 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105218751516307214371/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marie Vanek', 'https://lh3.googleusercontent.com/a/ACg8ocJM-b-t-HRsM54OR_G7v6uJhCfQNzQJpjqR7Hr7YyX_yIRQiTqi=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107322867214579814067/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107322867214579814067/reviews');
SET @user_marie_vanek = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107322867214579814067/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bajazit Lajka', 'https://lh3.googleusercontent.com/a/ACg8ocL3zpJ4-wyLcQ6pafWT7MNSE33kB07h8lmjfxbIJB1uuCwNdw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105641438224634041157/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105641438224634041157/reviews');
SET @user_bajazit_lajka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105641438224634041157/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Stanisic', 'https://lh3.googleusercontent.com/a-/ALV-UjU8mIxILNho2A9JSyLlUrrRkRc5wlg54wfZm-5tbcAk0Lcm4o4w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117493268370382603135/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117493268370382603135/reviews');
SET @user_marija_stanisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117493268370382603135/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Michal Budek', 'https://lh3.googleusercontent.com/a-/ALV-UjU6JnUQrFNmnnHRERzZnR1SsOaDlqwnMaG5V_jhVNgljm_BJ8uZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109864039661317581448/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109864039661317581448/reviews');
SET @user_michal_budek = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109864039661317581448/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Erman Jaho', 'https://lh3.googleusercontent.com/a-/ALV-UjWDkpIOecjycJ75icIP5ygHBiwQfEtIaR-Ci2cyndAq0k7frNyy=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100081550007415204652/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100081550007415204652/reviews');
SET @user_erman_jaho = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100081550007415204652/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Roman Karandiuk', 'https://lh3.googleusercontent.com/a/ACg8ocKDp79hPl1jruo8pF5SwO7NWT_sjfK9dg365IMHD3VtqTUgHw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100505388658701211353/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100505388658701211353/reviews');
SET @user_roman_karandiuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100505388658701211353/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Vučić', 'https://lh3.googleusercontent.com/a-/ALV-UjUORl3cG_bDtJ8Z6rdTBgYLT3TrGlgFoFLT_2KK16Id1P8xy8rT=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113891392843444177120/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113891392843444177120/reviews');
SET @user_nikola_vui = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113891392843444177120/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nina 999', 'https://lh3.googleusercontent.com/a/ACg8ocJYowUKFkGdoDidjibuOyBTcgRVmZBmjUg29qY53qrApuAZVg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104847702218517007921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104847702218517007921/reviews');
SET @user_nina_999 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104847702218517007921/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Blerim Mandija', 'https://lh3.googleusercontent.com/a-/ALV-UjUlAVe3JUEbK2G5MSXfLBj2pk4-dg4lxmBDyzFQjMIRxru9YT0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111171609303930298767/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111171609303930298767/reviews');
SET @user_blerim_mandija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111171609303930298767/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_meto_odobasic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChZDSUhNMG9nS0VJQ0FnSURRNklyTlFREAE',
    5, 'en', 'This a main healthcare poin  in Ulcinj. They offer healthcare service for locals but also for tourist. Mostly you will get help here very fast. For some most serious cases you will be ask to go to Hospital in Bar. Staff is mostly friendly even they have lots to do.',
    'Ovo je glavna zdravstvena tačka u Ulcinju. Nude zdravstvene usluge za lokalno stanovništvo, ali i za turiste. Uglavnom ćete ovde vrlo brzo dobiti pomoć. Za neke najteže slučajeve od vas će se tražiti da odete u bolnicu u Baru. Osoblje je uglavnom ljubazno, iako imaju mnogo posla.', 'Ово је главна здравствена тачка у Улцињу. Нуде здравствене услуге за локално становништво, али и за туристе. Углавном ћете овде врло брзо добити помоћ. За неке најтеже случајеве од вас ће се тражити да одете у болницу у Бару. Особље је углавном љубазно, иако имају много посла.', 'This a main healthcare poin  in Ulcinj. They offer healthcare service for locals but also for tourist. Mostly you will get help here very fast. For some most serious cases you will be ask to go to Hospital in Bar. Staff is mostly friendly even they have lots to do.', NULL, NULL, NULL,
    2, '2018-07-22 10:03:19'),

(@user_edin_mujanovi, @clinic_id, @doctor_sanela_abazovic_hot, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pJemJHNTFSaTF1U0hacmF6aHhTbkZ0UjJjdFpuYxAB',
    4, 'bs', 'dosli smo na urgetni cenrer sa dijetom zbog stomacnih problema.malo smo cekali dok neotpocne pedijatrija  sa radom Malo se ceka kod prijema da pocnu sa radom
Klinika je okkk.
Hvala dok. Saneli Abazovic na prijemu i uputama za daljnje lijecenje',
    'Došli smo u Urgentni centar sa dijetom zbog stomačnih tegoba. Sačekali smo malo dok ne proradi pedijatrija. Na recepciji se čeka malo da počnu da rade
Klinika je ok.
Hvala doc. Saneli Abazović za prijem i uputstvo za dalje lečenje', 'Дошли смо у Ургентни центар са дијетом због стомачних тегоба. Сачекали смо мало док не проради педијатрија. На рецепцији се чека мало да почну да раде
Клиника је ок.
Хвала доц. Санели Абазовић за пријем и упутство за даље лечење', NULL, NULL, NULL, NULL,
    0, '2025-08-13 09:31:32'),

(@user_gjonson_simoni, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ3dmRuT29nRRAB',
    4, 'sq', 'Diskriminim shum i madh,nese s\'je banor i Montenegros duhet te paguash 32€,higjiena eshte shume mire edhe stafi na kan prit mire,ama shum diskriminim',
    'Veoma velika diskriminacija, ako niste stanovnik Crne Gore morate platiti 32€, higijena je jako dobra i osoblje nas je dobro dočekalo, ali dosta diskriminacije', 'Веома велика дискриминација, ако нисте становник Црне Горе морате платити 32€, хигијена је јако добра и особље нас је добро дочекало, али доста дискриминације', NULL, NULL, NULL, NULL,
    0, '2024-08-27 15:25:35'),

(@user_selina_h, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNud0lMTDN3RRAB',
    5, 'de', 'Wir waren hier mit der Behandlung sehr zufrieden. Ich bin mit Beschwerden her, wir waren sehr schnell dran und es wurde sich liebevoll um mich gekümmert.
Die Kommunikation in Englisch lief hervorragend. Vielen Dank für eure Hilfe! 🌸',
    'Bili smo veoma zadovoljni tretmanom ovde. Došao sam sa malo neprijatnosti, vrlo brzo smo primljeni i odlično sam zbrinut.

Komunikacija na engleskom je bila odlična. Hvala vam puno na pomoći! 🌸', 'Били смо веома задовољни третманом овде. Дошао сам са мало непријатности, врло брзо смо примљени и одлично сам збринут.

Комуникација на енглеском је била одлична. Хвала вам пуно на помоћи! 🌸', NULL, NULL, 'Wir waren hier mit der Behandlung sehr zufrieden. Ich bin mit Beschwerden her, wir waren sehr schnell dran und es wurde sich liebevoll um mich gekümmert.
Die Kommunikation in Englisch lief hervorragend. Vielen Dank für eure Hilfe! 🌸', NULL,
    0, '2024-09-21 15:01:28'),

(@user_branislaw_549, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChdDSUhNMG9nS0VJQ0FnSUMyZ1l2Z3pnRRAB',
    5, 'hr', 'Sve pohvale za osoblje.
Mladi, ljubazni, spretni i profesionalni.',
    'Sve pohvale za osoblje.
Mladi, ljubazni, vešti i profesionalni.', 'Све похвале за особље.
Млади, љубазни, вешти и професионални.', NULL, NULL, NULL, NULL,
    1, '2022-04-22 13:49:08'),

(@user_vanessa_ducke, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sTlFVSTJibTVxVkZSdGJUbFNTR1ZuUmw5VVIxRRAB',
    5, 'en', '⭐⭐⭐⭐⭐

During my vacation in Ulcinj, I developed a severe eczema flare-up and needed medical attention. I visited the Health Center Ulcinj and felt comfortable and well taken care of from the very beginning.

The entire medical team was incredibly friendly, kind, and helpful. I received excellent care during all three of my visits and always felt welcome and in good hands.

Needing medical treatment while abroad can be stressful, but the staff made the whole experience very pleasant and reassuring. I genuinely felt comfortable throughout my treatment.

If I ever experience any health problems during another vacation in Ulcinj, I would definitely come back to this health center without hesitation.

A huge thank you to the entire team for their kindness and wonderful care. Highly recommended!

And a very special thank you to the nurse who treated me. I truly appreciate your kindness and care! ❤️',
    NULL, NULL, '⭐⭐⭐⭐⭐

During my vacation in Ulcinj, I developed a severe eczema flare-up and needed medical attention. I visited the Health Center Ulcinj and felt comfortable and well taken care of from the very beginning.

The entire medical team was incredibly friendly, kind, and helpful. I received excellent care during all three of my visits and always felt welcome and in good hands.

Needing medical treatment while abroad can be stressful, but the staff made the whole experience very pleasant and reassuring. I genuinely felt comfortable throughout my treatment.

If I ever experience any health problems during another vacation in Ulcinj, I would definitely come back to this health center without hesitation.

A huge thank you to the entire team for their kindness and wonderful care. Highly recommended!

And a very special thank you to the nurse who treated me. I truly appreciate your kindness and care! ❤️', NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_mustafa_oki, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tRM1FWUjFiSGxPZWt0clJrSjZlbk0zTW01c1JrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_predrag_kitanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKRWFVbEhORTE2ZFcxVlUwaFFXbEIyUVRsMWEwRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_janosch_sberkrb, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkaVExTXdORVYzVVdwV1gyVXdjMHhqVmtSYVMyYxAB',
    2, 'de', 'Die Haupteingangstur ist verschlossen, weswegen man rechts am Haus vorbei muss und vor der Notaufnahme des eigentlichen Krankenhauses nach links durch die dortige Tür.
Wir wurden erst empfangen, kamen aber im Schichtwechsel, weswegen wir dann zur Notaufnahme geschickt wurden. Dort nahm man uns auch gut auf und unkte selber "man spielt hier gerne Volleyball" 😜',
    NULL, NULL, NULL, NULL, 'Die Haupteingangstur ist verschlossen, weswegen man rechts am Haus vorbei muss und vor der Notaufnahme des eigentlichen Krankenhauses nach links durch die dortige Tür.
Wir wurden erst empfangen, kamen aber im Schichtwechsel, weswegen wir dann zur Notaufnahme geschickt wurden. Dort nahm man uns auch gut auf und unkte selber "man spielt hier gerne Volleyball" 😜', NULL,
    0, '2026-09-29 00:00:00'),

(@user_arlind_lika, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGaFdVUmhlWGx6V1Y5aVRrbGlaMlJQVmpoUWFsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_andjela_aranin, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oT0xXTlBkM05NUlVSaGRURllUMmhFWW5GRmIzYxAB',
    5, 'hr', 'Ljubazno osoblje i brzo delovanje!',
    'Ljubazno osoblje i brzo delovanje!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_blerim_zogaj, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4TlEyRklXazV6WDNOallVeG5aM2gzZHpSblNrRRAB',
    5, 'sq', 'Faleminderit për të gjithë stafin mjeksor, sidomos dr. Teuta Gjecbritaj.
Mjeke me etikë të lartë dhe profesionalizëm të dëshmuar.',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_enver_r_bahtija, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSNVJIRlZNWGRmTkUxNVFuVlpNa2xqZW1SdU0xRRAB',
    5, 'hr', 'Dobro je',
    'Dobro je', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_meriton_zherka, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkMGNWTkpSMUJpYkRkeWFsbFhRamt4TkZwUlprRRAB',
    1, 'en', 'I came here with my 4 month baby and the pediatric doctor (old lady) was only interested in our money she kept mentioning that we have to pay 34 euros for her to look at the baby and in the end she just mentiones that they have a dress code she didnt mention that before only after asking about the money, she started to do ordinary checkup on the baby she didnt even look at what the babys problem was very very bad very rude dont you make a mistake coming here',
    NULL, NULL, 'I came here with my 4 month baby and the pediatric doctor (old lady) was only interested in our money she kept mentioning that we have to pay 34 euros for her to look at the baby and in the end she just mentiones that they have a dress code she didnt mention that before only after asking about the money, she started to do ordinary checkup on the baby she didnt even look at what the babys problem was very very bad very rude dont you make a mistake coming here', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_margaretha_kuci, @clinic_id, @doctor_maida_gjoni, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CR2NVbGZhSE55VlhCM1JrcEVURTFKTkdGeExVRRAB',
    1, 'de', 'Ich war in der letzten Woche mit einer akuten Appendizitis dort, die Ärztin Maida, hat nach ihrer Untersuchung  erklärt, das sie mir mir eine Schmerzinfusion gibt und ich auf keinen Fall eine Appendizitis habe, weil mein Bauch nicht bretthart ist. Laboruntersuchungen sind ab 14 Uhr nicht möglich und ein Ultraschallgerät steht auch nicht zur Verfügung. Wenn die Schmerzen nicht besser werden soll ich morgen wieder kommen, mein Fazit nach 14 Uhr Pech gehabt. Wir haben uns entschieden nach Bar zu fahren um die erforderlichen Untersuchung durchzuführen zu lassen. Ich wurde in der Nacht operiert an einer perforierten Appendizitis, dort hat man mir mein Leben gerettet. Fazit am besten gleich nach Bar fahren.',
    NULL, NULL, NULL, NULL, 'Ich war in der letzten Woche mit einer akuten Appendizitis dort, die Ärztin Maida, hat nach ihrer Untersuchung  erklärt, das sie mir mir eine Schmerzinfusion gibt und ich auf keinen Fall eine Appendizitis habe, weil mein Bauch nicht bretthart ist. Laboruntersuchungen sind ab 14 Uhr nicht möglich und ein Ultraschallgerät steht auch nicht zur Verfügung. Wenn die Schmerzen nicht besser werden soll ich morgen wieder kommen, mein Fazit nach 14 Uhr Pech gehabt. Wir haben uns entschieden nach Bar zu fahren um die erforderlichen Untersuchung durchzuführen zu lassen. Ich wurde in der Nacht operiert an einer perforierten Appendizitis, dort hat man mir mein Leben gerettet. Fazit am besten gleich nach Bar fahren.', NULL,
    0, '2026-08-29 00:00:00'),

(@user_jamin, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCalJFdEhaSHB3TlVKWVZVWmFaelZMWmpsVmRGRRAB',
    5, 'de', 'Hallo,

Wir mussten Notfall mässig ins Spital, wir wurden am Empfang sehr nett empfangen bedient von Zwei älteren Frauen, sehr gutes saubere Notfallstation.',
    NULL, NULL, NULL, NULL, 'Hallo,

Wir mussten Notfall mässig ins Spital, wir wurden am Empfang sehr nett empfangen bedient von Zwei älteren Frauen, sehr gutes saubere Notfallstation.', NULL,
    0, '2026-08-29 00:00:00'),

(@user_alem_dzehverovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xjNFlubGxTbTFmU2pCbWMwVkhORU5pU0hNNE1HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_coco_puppy, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT214aloyNTRiSHBqZDNOWFRVaEhRelJhTFU5cWNHYxAB',
    5, 'en', 'During our vacation in Ulcinj, our three kids got food poisoning or some kind of stomach virus/bacteria after eating pizza at Sparta Beach Club. They suffered the worst vomiting and diarrhea I have ever seen, to the point that they were unable to control their bowels. My 10-year-old daughter was vomiting every hour, so we took her to the hospital.
The medical care was quick and excellent. The doctors and nurses were caring, kind, and very helpful. Because she was dehydrated, she was given IV fluids. We paid only 37 euros for the consultation.
It\'s also possible they caught a virus or bacteria from the sea. Ulcinj is a beautiful city, but it has a serious sewage problem. Wastewater is discharged into the Adriatic Sea.
On Teuta Boulevard, there is an open ditch filled with dirty, foul-smelling water, where you can clearly see pipes from nearby buildings discharging wastewater. That polluted water eventually flows into the sea.',
    NULL, NULL, 'During our vacation in Ulcinj, our three kids got food poisoning or some kind of stomach virus/bacteria after eating pizza at Sparta Beach Club. They suffered the worst vomiting and diarrhea I have ever seen, to the point that they were unable to control their bowels. My 10-year-old daughter was vomiting every hour, so we took her to the hospital.
The medical care was quick and excellent. The doctors and nurses were caring, kind, and very helpful. Because she was dehydrated, she was given IV fluids. We paid only 37 euros for the consultation.
It\'s also possible they caught a virus or bacteria from the sea. Ulcinj is a beautiful city, but it has a serious sewage problem. Wastewater is discharged into the Adriatic Sea.
On Teuta Boulevard, there is an open ditch filled with dirty, foul-smelling water, where you can clearly see pipes from nearby buildings discharging wastewater. That polluted water eventually flows into the sea.', NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_majdam100, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CaU1qSXdVbmRGZEZZemJrUkVSMWh1Y1dWMU4yYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_marie_vanek, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGcmJqVjVNRVZ4ZUhKWVZqWXhhRmRSUVdkVmJVRRAB',
    5, 'fr', 'Je recommande vivement cette maison de santé. J’ai dû me rendre en urgence pour une thrombose. Ma prise en charge a été immédiate, compétente et efficace. La communication avec le médecin était claire et bonne. La facture de ce traitement tout compris a été de 46.-€.',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_bajazit_lajka, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChdDSUhNMG9nS0VJQ0FnSURRbTlteHFRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_marija_stanisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toelF6SkpXVE5QYkVNdFMwSTNSM1p6WWpaME4yYxAB',
    1, 'hr', 'Nikada se niko na telefon ne javlja',
    'Nikada se niko na telefon ne javlja', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_michal_budek, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChZDSUhNMG9nS0VJQ0FnSURwal9pU1B3EAE',
    1, 'en', 'I was there with leg injury, can\'t help me as basic examination was done. Sent me to ambulance on the other side of building.',
    NULL, NULL, 'I was there with leg injury, can\'t help me as basic examination was done. Sent me to ambulance on the other side of building.', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_erman_jaho, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChdDSUhNMG9nS0VJQ0FnSURwbWIySXJRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_roman_karandiuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNhbF9YNzFBRRAB',
    4, 'ru', 'Сделали бесплатный тест на Covid для возвращения домой. Сутра сдали на следующий  день забрали. Быстро и без каких либо проблем.',
    NULL, NULL, NULL, 'Сделали бесплатный тест на Covid для возвращения домой. Сутра сдали на следующий  день забрали. Быстро и без каких либо проблем.', NULL, NULL,
    3, '2021-10-29 00:00:00'),

(@user_nikola_vui, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3dElfUEl3EAE',
    5, 'en', 'Sincerely, I did not expect a normal attitude towards patients at this unhospitable Montenegro, but it was OK !',
    NULL, NULL, 'Sincerely, I did not expect a normal attitude towards patients at this unhospitable Montenegro, but it was OK !', NULL, NULL, NULL,
    1, '2018-10-29 00:00:00'),

(@user_nina_999, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChdDSUhNMG9nS0VJQ0FnSURBby1uWjF3RRAB',
    5, 'hr', 'Dok je Dr. Pajo na čelu, nema zime',
    'Dok je Dr. Pajo na čelu, nema zime', NULL, NULL, NULL, NULL, NULL,
    1, '2017-10-29 00:00:00'),

(@user_blerim_mandija, @clinic_id, NULL, 'google_maps',
    'places/ChIJkVrkFGQTThMRiBnsu9NYcLM/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3MF9IVE13EAE',
    5, 'en', 'good service , limited in some services',
    NULL, NULL, 'good service , limited in some services', NULL, NULL, NULL,
    2, '2017-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
