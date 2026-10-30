-- Insert Google Maps reviews for ZU Dom zdravlja Nikšić
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dom-zdravlja-niksic.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-niksic');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_vuk_dubak = (SELECT id FROM doctors WHERE slug = 'vuk-dubak');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Banjo Miric', 'https://lh3.googleusercontent.com/a/ACg8ocIGYvOcqXhESPRrjhFEeVqtpY5DNnjX2aT6hULUc_gC75Il3w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118149303525105552869/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118149303525105552869/reviews');
SET @user_banjo_miric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118149303525105552869/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Milic', 'https://lh3.googleusercontent.com/a/ACg8ocKox07SURkkTJ6Dka3yjKB7D-Q7lg--kEcNjmpytsHpUVK-Wg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102547561655511812281/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102547561655511812281/reviews');
SET @user_ana_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102547561655511812281/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrija Bozovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ4raez7LCKw_9NCnB3WKJ4lxP25M4E_hRzYE569FSXvEGRStQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109271690221659574344/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109271690221659574344/reviews');
SET @user_andrija_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109271690221659574344/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Torbica Jovo', 'https://lh3.googleusercontent.com/a-/ALV-UjWpkxmPhMI0q8RNNQlWdjKoGQ4XJAUFGGIfFlP8ljwooTFovPW1=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115734945797631062000/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115734945797631062000/reviews');
SET @user_torbica_jovo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115734945797631062000/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Delic', 'https://lh3.googleusercontent.com/a/ACg8ocKRxBsjDL0xoOmoxFv1-KtXFE7BpqLuZMXxr9Bx2MJva2nGzQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117352120726206401617/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117352120726206401617/reviews');
SET @user_milica_delic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117352120726206401617/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rada Susic', 'https://lh3.googleusercontent.com/a-/ALV-UjVxu0WV1kXW-hiK1-2VbukTc_l10tHodzp3Lhzh4SOvR4xMFyGL=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114523105231358408693/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114523105231358408693/reviews');
SET @user_rada_susic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114523105231358408693/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra C', 'https://lh3.googleusercontent.com/a-/ALV-UjWzbh0xqcUolsqjIcIrG4TBrR66x3cl7onrni5iLlvLDqwFUPdNkg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113860447438539647904/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113860447438539647904/reviews');
SET @user_sandra_c = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113860447438539647904/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vuk S', 'https://lh3.googleusercontent.com/a-/ALV-UjWqAUj93-z-bFLyEXAvmxmgG63U2IhLEzZrcK_A16-e3gBoctr3=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117452221690169095579/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117452221690169095579/reviews');
SET @user_vuk_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117452221690169095579/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja', 'https://lh3.googleusercontent.com/a/ACg8ocLwQBeeWZ6ACC5XxYwB7fm6eyA0Z_JG4uC85okC-me9etsIeWw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117514935526731413539/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117514935526731413539/reviews');
SET @user_sanja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117514935526731413539/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sofia Tifani', 'https://lh3.googleusercontent.com/a-/ALV-UjVemcsXXLgKSx6DqxVI4js1McNPhpbSqu3f6bzLibtmhbmRfX8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116869480746122545411/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116869480746122545411/reviews');
SET @user_sofia_tifani = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116869480746122545411/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Teya Teya', 'https://lh3.googleusercontent.com/a-/ALV-UjWFb2iwZArPG4wMVpSsq-Q8Y0zgcWyK_WCkwwrM3YOtghy9FEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107030048941339260184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107030048941339260184/reviews');
SET @user_teya_teya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107030048941339260184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alba Caka', 'https://lh3.googleusercontent.com/a-/ALV-UjVSYrIagbUiHOfIwQJ0VhidfHuOA84h0qE2G60bR3d0IKPuJjxn=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110157267131655033178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110157267131655033178/reviews');
SET @user_alba_caka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110157267131655033178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olivera Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocIEAZpSTXN5Yup1TkidLCdDrhD1BvWeAA9ryMZfIyH8LS45Ew=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110534422648491123840/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110534422648491123840/reviews');
SET @user_olivera_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110534422648491123840/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Toni Jankovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUxao0wcukvjaMX5yXFOzVlzgMSlUGX4OqEo1alPLuIXoHFdpM1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100158146141226272669/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100158146141226272669/reviews');
SET @user_toni_jankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100158146141226272669/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Слободан Стојановић', 'https://lh3.googleusercontent.com/a-/ALV-UjXmhR_tV6YZLnfMrKmA-0E017qtkFD6VjHV6V55ygyTA9wSi9oyMQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103567745208139659687/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103567745208139659687/reviews');
SET @user_slobodan_stojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103567745208139659687/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Lazović', 'https://lh3.googleusercontent.com/a-/ALV-UjWaAe0jb_Lll7AhgoDFJwq8n-H5B6qRuzGfy8lY0Mg-8tJuvDib=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114987843862595946305/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114987843862595946305/reviews');
SET @user_stefan_lazovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114987843862595946305/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Milošević', 'https://lh3.googleusercontent.com/a-/ALV-UjXBWR0Z79K4fHIVwMXQ0KJM8S_hB4m0rbxxdM_31WisvsyLZp8h=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112451610222066329097/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451610222066329097/reviews');
SET @user_nikola_miloevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451610222066329097/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasilije Aleksic', 'https://lh3.googleusercontent.com/a/ACg8ocLQs0_c5qR6IlH4VLC5Xs_mwyLdL2DxK8AZ026d99OcoAA_Zg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115130330526491439213/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115130330526491439213/reviews');
SET @user_vasilije_aleksic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115130330526491439213/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Papic', 'https://lh3.googleusercontent.com/a/ACg8ocIWTM8HbgMsTCaqq_-kSi3xKaGqBCcClkLv2aBZjM02OELm6w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104502377717072523299/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104502377717072523299/reviews');
SET @user_marijana_papic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104502377717072523299/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_banjo_miric, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChdDSUhNMG9nS0VJQ0FnSURCeXBYajhRRRAB',
    1, 'sr', 'Имам један прост и ефикасан предлог- ДА БИ СЕ ИСБЈЕГЛЕ ГУЖВЕ И УЛАСЦИ ПРЕКО РЕДА СКРОЗ ПРОСТ И ЈЕДНОСТАВАН СИСТЕМ: ДОВОЉНО ЈЕ ДА СЕ ОДШТАМПАЈУ НАЈОБИЧНИЈИ БРОЈЕБИ (ШТО БИ УСТАНОВУ КОШТАЛО 2 ЕВРА. СИСТЕМ ЈЕ СЛЕДЕЋИ, КО СЕ ПРВИ ПРИЈАВИ ДОБИЈЕ БРОЈ 1, ДРУГИ БРОЈ 2, ТРЕЋИ БРОЈ 3... И ТАКО ДАЉЕ!!! ПАЦИЈЕНТИ НЕ БИ МОРАЛИ ДА ЧЕКАЈУ ПО 8+ САТИ НЕГО БИ ЗНАЛИ ОДПРИЛИКЕ КАД СУ И НЕ БИ СЕ СТВАРАЛЕ ГУЖВЕ У ЧЕКАОНИЦИ И САМИМ ТИМ НЕ БИ БИЛИ ИЗЛОЖЕНИ РАЗНИМ ПРЕНОСИВИМ БОЛЕСТИМА.., ЈЕДИНИ ПРОБЛЕМ ЈЕ ШТО НЕ БИ ОНДА МОГЛИ СВОЈЕ ДА УБАЦАТЕ НА ПРОТЕКЦИЈУ НЕГО БЕ ЕТО СВИ БИЛИ ЈЕДНАКИ!
Господо из управе можда би могли размотрити овај предлог',
    'Imam jedan prost i efikasan predlog- DA BI SE ISBJEGLE GUŽVE I ULASCI PREKO REDA SKROZ PROST I JEDNOSTAVAN SISTEM: DOVOLjNO JE DA SE ODŠTAMPAJU NAJOBIČNIJI BROJEBI (ŠTO BI USTANOVU KOŠTALO 2 EVRA. SISTEM JE SLEDEĆI, KO SE PRVI PRIJAVI DOBIJE BROJ 1, DRUGI BROJ 2, TREĆI BROJ 3... I TAKO DALjE!!! PACIJENTI NE BI MORALI DA ČEKAJU PO 8+ SATI NEGO BI ZNALI ODPRILIKE KAD SU I NE BI SE STVARALE GUŽVE U ČEKAONICI I SAMIM TIM NE BI BILI IZLOŽENI RAZNIM PRENOSIVIM BOLESTIMA.., JEDINI PROBLEM JE ŠTO NE BI ONDA MOGLI SVOJE DA UBACATE NA PROTEKCIJU NEGO BE ETO SVI BILI JEDNAKI!
Gospodo iz uprave možda bi mogli razmotriti ovaj predlog', 'Имам један прост и ефикасан предлог- ДА БИ СЕ ИСБЈЕГЛЕ ГУЖВЕ И УЛАСЦИ ПРЕКО РЕДА СКРОЗ ПРОСТ И ЈЕДНОСТАВАН СИСТЕМ: ДОВОЉНО ЈЕ ДА СЕ ОДШТАМПАЈУ НАЈОБИЧНИЈИ БРОЈЕБИ (ШТО БИ УСТАНОВУ КОШТАЛО 2 ЕВРА. СИСТЕМ ЈЕ СЛЕДЕЋИ, КО СЕ ПРВИ ПРИЈАВИ ДОБИЈЕ БРОЈ 1, ДРУГИ БРОЈ 2, ТРЕЋИ БРОЈ 3... И ТАКО ДАЉЕ!!! ПАЦИЈЕНТИ НЕ БИ МОРАЛИ ДА ЧЕКАЈУ ПО 8+ САТИ НЕГО БИ ЗНАЛИ ОДПРИЛИКЕ КАД СУ И НЕ БИ СЕ СТВАРАЛЕ ГУЖВЕ У ЧЕКАОНИЦИ И САМИМ ТИМ НЕ БИ БИЛИ ИЗЛОЖЕНИ РАЗНИМ ПРЕНОСИВИМ БОЛЕСТИМА.., ЈЕДИНИ ПРОБЛЕМ ЈЕ ШТО НЕ БИ ОНДА МОГЛИ СВОЈЕ ДА УБАЦАТЕ НА ПРОТЕКЦИЈУ НЕГО БЕ ЕТО СВИ БИЛИ ЈЕДНАКИ!
Господо из управе можда би могли размотрити овај предлог', NULL, NULL, NULL, NULL,
    4, '2023-01-16 15:51:22'),

(@user_ana_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4WGJGWmhaMm90VkVZeFRHaFljblZLYnpkNVJIYxAB',
    1, 'bs', 'Ogromne gužve, ulazi se preko reda, čeka se po 4 h.',
    'Ogromne gužve, uđete kroz red, morate čekati 4 sata.', 'Огромне гужве, уђете кроз ред, морате чекати 4 сата.', NULL, NULL, NULL, NULL,
    0, '2025-10-13 10:18:36'),

(@user_andrija_bozovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChdDSUhNMG9nS0VJQ0FnSURybWJQd3l3RRAB',
    1, 'hr', 'Jadno i žalosno, kao i sve ostalo što nam je. Samo se ovdje radi o zdravlju ljudi, ali nikoga nije briga.',
    'Jadno je i tužno, baš kao i sve ostalo što imamo. Radi se samo o zdravlju ljudi, ali nikoga nije briga.', 'Јадно је и тужно, баш као и све остало што имамо. Ради се само о здрављу људи, али никога није брига.', NULL, NULL, NULL, NULL,
    0, '2024-07-18 14:30:33'),

(@user_torbica_jovo, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChZDSUhNMG9nS0VJQ0FnSURMaHRUa0N3EAE',
    1, 'bs', 'Užas jedan ,Ne daj Bože bolesti kako ljude bez empatije gledaju i dočekuju a bio sam prisutan dje 2 mlade sestre rugaju se i komentarišuu na najgori nacin sa najgorim epitetima prema zavisnicima koji primaju terapiju a to su skoro pa izliječeni ljudi koji neki imaju škole i odličan renome,ali partijsko zapošljavanje ne prestaje !!!',
    'Užasno je, ne daj Bože, kako se ljudi gledaju i dočekuju bez empatije, a bila sam prisutna kada su se 2 mlade medicinske sestre podsmevale i komentarisale na najgori način sa najgorim epitetima prema zavisnicima koji primaju terapiju, a to su skoro izlečeni ljudi, od kojih neki imaju škole i odličan ugled, ali partijsko regrutovanje ne prestaje!!!', 'Ужасно је, не дај Боже, како се људи гледају и дочекују без емпатије, а била сам присутна када су се 2 младе медицинске сестре подсмевале и коментарисале на најгори начин са најгорим епитетима према зависницима који примају терапију, а то су скоро излечени људи, од којих неки имају школе и одличан углед, али партијско регрутовање не престаје!!!', NULL, NULL, NULL, NULL,
    0, '2024-06-27 08:13:52'),

(@user_milica_delic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChZDSUhNMG9nS0VJQ0FnSUNxOE5HN0lBEAE',
    1, 'sl', 'Cista 0!',
    'Čisto 0!', 'Чисто 0!', NULL, NULL, NULL, NULL,
    2, '2021-05-24 18:48:43'),

(@user_rada_susic, @clinic_id, @doctor_vuk_dubak, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSVFYzcFdibTlVYlRCb2NTMDRUemxGY25KRk5GRRAB',
    5, 'hr', 'Pohvala za dr Dubak
Moja topla preporuka',
    'Pohvala za dr Dubak
Moja topla preporuka', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-29 00:00:00'),

(@user_sandra_c, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT201eGNVTTNORTVCTld0ZmJsTnFYemR1WlY5eGJuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_vuk_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0TFV6ZExTRVZHUzBWMllWWnlSMHQyZW5nd04yYxAB',
    1, 'bs', 'Samo su tako organizovani... dosao na sistemacki u 2, 3 tri nam govore kako doktor jos nije dosao.',
    'Samo su tako organizovani... dosao na sistemacki u 2, 3 tri nam govore kako doktor jos nije dosao.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_sanja, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5a1JuWlpVV0pNVUdaak9FWnFWVEpGT1ZGWlkxRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_sofia_tifani, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kelJuVmxUVzFmTjBKSGRsOVpjRkpzYXpOZlEyYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_teya_teya, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJeFp6UTNhRUo1V0U1dlJHaE1VRUUxY1MxUFlWRRAB',
    5, 'bs', 'Najbolji DZ u ovoj državi, ne čeka se previše, sestre i doktori žele da pomognu i slušaju šta im pacjent govori. Prije ovdje završim sve što moram nego u opštini u kojoj sam prijavljena kao pacijent!',
    'Najbolji DZ u ovoj državi, ne čeka se previše, sestre i doktori žele da pomognu i slušaju šta im pacjent govori. Prije ovdje završim sve što moram nego u opštini u kojoj sam prijavljena kao pacijent!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_alba_caka, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChdDSUhNMG9nS0VJQ0FnSUNuelB1enV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_olivera_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChdDSUhNMG9nS0VJQ0FnSUNkNU5PNGtnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_toni_jankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKMFlhdjJBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_slobodan_stojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChdDSUhNMG9nS0VJQ0FnSURLajRmem5nRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_stefan_lazovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChZDSUhNMG9nS0VJQ0FnSURDMzc2aUZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_nikola_miloevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChZDSUhNMG9nS0VJQ0FnSUNzNWRTbEFREAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_vasilije_aleksic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChZDSUhNMG9nS0VJQ0FnSUQwNU0tZlJREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_marijana_papic, @clinic_id, NULL, 'google_maps',
    'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/ChZDSUhNMG9nS0VJQ0FnSURVNU9yVlh3EAE',
    1, 'ru', NULL,
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

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJpxHe9q2pTRMRPnJUfQGgX_s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJeFp6UTNhRUo1V0U1dlJHaE1VRUUxY1MxUFlWRRAB'),
  'clinic', @clinic_id,
  'Veliko hvala u ime čitavog kolektiva ZU Dom zdravlja Nikšić.', 'bs',
  'Veliko hvala u ime čitavog kolektiva ZU Dom zdravlja Nikšić.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-04-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
