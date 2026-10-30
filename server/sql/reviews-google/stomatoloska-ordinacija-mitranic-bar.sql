-- Insert Google Maps reviews for Opšta stomatološka ordinacija Mitranić
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/stomatoloska-ordinacija-mitranic-bar.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'stomatoloska-ordinacija-mitranic-bar');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_janko_mitranic = (SELECT id FROM doctors WHERE slug = 'janko-mitranic');
SET @doctor_tamara_mitranic = (SELECT id FROM doctors WHERE slug = 'tamara-mitranic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Тамара Амелина', 'https://lh3.googleusercontent.com/a-/ALV-UjXkyG2miDWAFbTxgoJ5SxTIG7sqfZEIoJbFjHfT7DxfvEMlZ3vIdQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100896489141866594951/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100896489141866594951/reviews');
SET @user_tamara_amelina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100896489141866594951/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alex L', 'https://lh3.googleusercontent.com/a/ACg8ocJCnOcjdOW1qHG5xO31MLJMDIYvFSJ-ziBCa5_sO6ctcgAxOw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108835733253833768574/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108835733253833768574/reviews');
SET @user_alex_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108835733253833768574/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milutin Vujosevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWNJmawvDsP0dpAv_vQJFmEFANrVV39nxrccrXdqsSiOCt1QqCWMg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112242492314876794909/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112242492314876794909/reviews');
SET @user_milutin_vujosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112242492314876794909/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Yurhen Norton', 'https://lh3.googleusercontent.com/a-/ALV-UjXy2iM69X7RVLebFujHgrPw_aKdFzojm1CZg2c2m7qEnBtKb_Xm=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103975585837000615672/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103975585837000615672/reviews');
SET @user_yurhen_norton = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103975585837000615672/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Secicka', 'https://lh3.googleusercontent.com/a/ACg8ocLdJNl4PXbKY57hayfYaFBK-k6nAMBFP6tLXGu9_hzZLBWeRw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100234010033399606997/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100234010033399606997/reviews');
SET @user_secicka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100234010033399606997/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina', 'https://lh3.googleusercontent.com/a/ACg8ocIHd351gNdwOmHYWfkteiywxWFYYVuVR0KusyjDgrsAiBTpT6o=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114405381163398674963/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114405381163398674963/reviews');
SET @user_jasmina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114405381163398674963/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleks Aleks', 'https://lh3.googleusercontent.com/a-/ALV-UjWRQuPBZkbmA0H6hVmz54ZgYMgk92ygr3egHcadZWamLdr3UzM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108548950979769158268/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108548950979769158268/reviews');
SET @user_aleks_aleks = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108548950979769158268/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Escanor Lion\'s Sin', 'https://lh3.googleusercontent.com/a/ACg8ocLhnwPyC-rKfHlQmiXMJc0vhuMksoUOocKlGIEk4746oTm0pg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105894494629399456572/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105894494629399456572/reviews');
SET @user_escanor_lions_sin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105894494629399456572/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'V. B.', 'https://lh3.googleusercontent.com/a/ACg8ocK0ZcK3fjy8WqA-cIfjnNs2j3VGdB8tYwoMcc2HdiTj613tvA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114661436881384701815/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114661436881384701815/reviews');
SET @user_v_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114661436881384701815/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Оксана Морозова', 'https://lh3.googleusercontent.com/a/ACg8ocIVuHy_JxP5LwhBR6na8HnZ0Z70GWfQgzb67HPtM7fRdKgXKA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115326661088870083986/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115326661088870083986/reviews');
SET @user_oksana_morozova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115326661088870083986/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lela Potpara', 'https://lh3.googleusercontent.com/a/ACg8ocLxrFdCtet_2KeKwkt21HlO-c5f-NHsZhOZ1_oZyQsRxvxjEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116261179439536562577/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116261179439536562577/reviews');
SET @user_lela_potpara = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116261179439536562577/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocKF1zJUPiwSC8S9gNcCXlgULa_uSblCp5Ir33GMxQOUiokcGw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108703951914306183583/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108703951914306183583/reviews');
SET @user_aleksandra_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108703951914306183583/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amel Kasumovic', 'https://lh3.googleusercontent.com/a/ACg8ocJwuXPSesOOnSv7WVuRBVzafGHbbNrMRYqf6Ot0d35l_grGKA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109226345536835500293/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109226345536835500293/reviews');
SET @user_amel_kasumovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109226345536835500293/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija', 'https://lh3.googleusercontent.com/a/ACg8ocLhmZomNcd4dsb_Wvxvrg61TnHUfHedQ20NduOFlQjVFs-84A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111898550677462286622/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111898550677462286622/reviews');
SET @user_ksenija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111898550677462286622/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suzana Vukusic', 'https://lh3.googleusercontent.com/a/ACg8ocJR8LVvtFpk95cWG7G0g9fMPjs1YhLrAybwur-8k5kHkjSC5Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104829275111576518856/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104829275111576518856/reviews');
SET @user_suzana_vukusic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104829275111576518856/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'slay you', 'https://lh3.googleusercontent.com/a-/ALV-UjWbcXFcgpz_AM1KPfD0uIaOGrRzM5cozooyppTvwkz0Vs3bGFs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106462281064260316774/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106462281064260316774/reviews');
SET @user_slay_you = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106462281064260316774/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Kopmann', 'https://lh3.googleusercontent.com/a/ACg8ocL03sUL4rpRdCfGKqChEk-o4bkTicIU445iqKbEfNohsOV_Sw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111456855922668660197/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111456855922668660197/reviews');
SET @user_bojana_kopmann = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111456855922668660197/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'slavica vukovic', 'https://lh3.googleusercontent.com/a/ACg8ocJT3YGHtXmyB3PAwThJ6muY5JTNtNGlN4UF7n7l1YdsbN6o1A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113516603109646801008/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113516603109646801008/reviews');
SET @user_slavica_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113516603109646801008/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'NVO PORTRET', 'https://lh3.googleusercontent.com/a-/ALV-UjXZvHzAVJ0P9Kp4Rt6JaQ9Wjqa8vZpbncROiAPbaHCuskkiaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116036634338995296838/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116036634338995296838/reviews');
SET @user_nvo_portret = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116036634338995296838/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavko Śata Kastratovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX_MpWE-F1iFc-IGWpIANo5GKVUbMHdwJlOHtaa0miS7bFJO_8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118057776443910763564/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118057776443910763564/reviews');
SET @user_slavko_ata_kastratovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118057776443910763564/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_tamara_amelina, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOdGVVdzVja3RaVjB4V04xVlZhbEZhZURoVVVtYxAB',
    5, 'ru', 'Доктор Янко — лучший выбор в Баре! Отличный доктор!
Лечим зубы всей семьей. Работа великолепная, цены адекватные.',
    'Dr Janko je najbolji izbor u Baru! Odličan doktor!
Cela porodica dobija stomatološke usluge. Rad je odličan, a cene su razumne.', 'Др Јанко је најбољи избор у Бару! Одличан доктор!
Цела породица добија стоматолошке услуге. Рад је одличан, а цене су разумне.', NULL, 'Доктор Янко — лучший выбор в Баре! Отличный доктор!
Лечим зубы всей семьей. Работа великолепная, цены адекватные.', NULL, NULL,
    0, '2026-03-19 17:28:06'),

(@user_alex_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taVU4yNVpRUzAxYlhGR01GOVZia1Z0ZDI4MVdXYxAB',
    5, 'ru', 'Хороший доктор, спас мне несколько зубов, очень аккуратный специалист, работает без спешки. Делал у него 4 коронки, все стоят как родные зубы. Очень мне помогло то что доктор Янко знает русский язык.',
    'On je odličan doktor, spasao mi je nekoliko zuba, veoma je temeljan specijalista i radi bez žurbe. Uradio mi je četiri krunice i sve izgledaju kao moji zubi. Bilo mi je od velike pomoći što dr Janko govori ruski.', 'Он је одличан доктор, спасао ми је неколико зуба, веома је темељан специјалиста и ради без журбе. Урадио ми је четири крунице и све изгледају као моји зуби. Било ми је од велике помоћи што др Јанко говори руски.', NULL, 'Хороший доктор, спас мне несколько зубов, очень аккуратный специалист, работает без спешки. Делал у него 4 коронки, все стоят как родные зубы. Очень мне помогло то что доктор Янко знает русский язык.', NULL, NULL,
    0, '2025-07-30 16:22:34'),

(@user_milutin_vujosevic, @clinic_id, @doctor_tamara_mitranic, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSURRaU0yYjlRRRAB',
    5, 'hr', 'Aleksa je uživao i jedva čeka da se opet vidi sa njegovom doktoricom Tamarom... Samo riječi hvale za Mitranic Dental...',
    'Aleksa je uživao i jedva čeka da ponovo poseti doktorku Tamaru... Samo reči hvale za Mitranic Dental...', 'Алекса је уживао и једва чека да поново посети докторку Тамару... Само речи хвале за Митраниц Дентал...', NULL, NULL, NULL, NULL,
    0, '2017-09-08 11:11:03'),

(@user_yurhen_norton, @clinic_id, @doctor_janko_mitranic, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSURSNFlfZldBEAE',
    5, 'bs', 'Ja sam iz Ukrajine i privremeno živim u gradu Baru.  Kada mi se neskidiva proteza počela klimati obratila sam se poliklinici "Opšta stomatološka ordinacija Mitranić".
Dr. Janko je profesionalno i skrupulozno pristupio rješenju mog problema: napravio je rendgensku snimku, pažljivo skinuo protezu, izliječio i restaurirao potporne zube, vratio protezu i vratio mi stari osmijeh i sposobnost normalnog i pravilnog žvakanja hrane. .
Hvala dr. Janku i njegovoj sestri Senadi na profesionalnosti, ljubaznosti i dobroj atmosferi koju su mi pružili tijekom liječenja.',
    'Ja sam iz Ukrajine i privremeno živim u gradu Baru. Kada mi je fiksna proteza počela da se klati, obratio sam se poliklinici „Ordinacija opšte stomatologije Mitranić“.
Doktor Janko je profesionalno i savesno pristupio rešavanju mog problema: napravio rendgenski snimak, pažljivo uklonio protezu, lečio i restaurirao potporne zube, vratio protezu i vratio mi stari osmeh i sposobnost da normalno i pravilno žvačem hranu. .
Hvala dr Janku i njegovoj sestri Senadi na profesionalnosti, ljubaznosti i dobroj atmosferi koju su mi pružili tokom lečenja.', 'Ја сам из Украјине и привремено живим у граду Бару. Када ми је фиксна протеза почела да се клати, обратио сам се поликлиници „Ординација опште стоматологије Митранић“.
Доктор Јанко је професионално и савесно приступио решавању мог проблема: направио рендгенски снимак, пажљиво уклонио протезу, лечио и рестаурирао потпорне зубе, вратио протезу и вратио ми стари осмех и способност да нормално и правилно жвачем храну. .
Хвала др Јанку и његовој сестри Сенади на професионалности, љубазности и доброј атмосфери коју су ми пружили током лечења.', NULL, NULL, NULL, NULL,
    2, '2023-04-27 07:29:08'),

(@user_secicka, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSURyaUtfNGhBRRAB',
    5, 'bs', 'Najjbolji definitivno,izuzetno prijatni i profesionalni,tople preporuke❤️❤️❤️
Dr.Janko
Dr.Tamara i
sestra Senada
Divan tim',
    'Definitivno najbolji, izuzetno prijatni i profesionalni, toplo preporučujem❤️❤️❤️
Dr Janko
Dr Tamara i
sestra Senada
Divan tim', 'Дефинитивно најбољи, изузетно пријатни и професионални, топло препоручујем❤️❤️❤️
Др Јанко
Др Тамара и
сестра Сенада
Диван тим', NULL, NULL, NULL, NULL,
    0, '2024-07-13 13:53:44'),

(@user_jasmina, @clinic_id, @doctor_tamara_mitranic, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNmaGRuYmp3RRAB',
    5, 'hr', 'Najdivnija dr Tamara!❤️',
    'Najdivnija dr Tamara!❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aleks_aleks, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSURWeU11NTlRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_escanor_lions_sin, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNGX29Mcnl3RRAB',
    1, 'ru', 'Написано что работают в субботу , приехал, все закрыто , зачем такое писать ?!',
    NULL, NULL, NULL, 'Написано что работают в субботу , приехал, все закрыто , зачем такое писать ?!', NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_v_b, @clinic_id, @doctor_janko_mitranic, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNPNDlPZFBnEAE',
    5, 'hr', 'Doktor Janko i sestra Senada su najbolji izbor u Baru.',
    'Doktor Janko i sestra Senada su najbolji izbor u Baru.', NULL, NULL, NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_oksana_morozova, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwMW9hMm93RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_lela_potpara, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSURoOThQWVRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_aleksandra_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNPMnRlWENBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_amel_kasumovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNVeVBEUENnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_ksenija, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSURrdzlmbWJ3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_suzana_vukusic, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSURZemFDMUVREAE',
    5, 'hr', 'Sve pohvale na profesionalnosti, pomoci  i ljubaznosti prema turistima u Vasem gradu!',
    'Sve pohvale na profesionalnosti, pomoci  i ljubaznosti prema turistima u Vasem gradu!', NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_slay_you, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSURBcG8zTFd3EAE',
    5, 'en', 'This  was  the  Best  dentist visit  I have  ever  had  .All  the  stuff were extremely friendly  and  helpful  Dr.Mitranic made  me feel  totally  comfortable  and relaxed  I will  and have recommended  this  office  to friends  and  family  . Thank you!',
    NULL, NULL, 'This  was  the  Best  dentist visit  I have  ever  had  .All  the  stuff were extremely friendly  and  helpful  Dr.Mitranic made  me feel  totally  comfortable  and relaxed  I will  and have recommended  this  office  to friends  and  family  . Thank you!', NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_bojana_kopmann, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBNXZpbVF3EAE',
    5, 'de', 'Ekzellenter Service, super Qualität und Kundenorientierung. Sehr professionell!',
    NULL, NULL, NULL, NULL, 'Ekzellenter Service, super Qualität und Kundenorientierung. Sehr professionell!', NULL,
    2, '2017-10-29 00:00:00'),

(@user_slavica_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSURRa1puQ3lRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_nvo_portret, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3MXI2dXNnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2016-10-29 00:00:00'),

(@user_slavko_ata_kastratovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJB0JfTwB0ThMRXHNR6Zb9OVU/reviews/ChdDSUhNMG9nS0VJQ0FnSURBdDh1SWtRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2016-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
