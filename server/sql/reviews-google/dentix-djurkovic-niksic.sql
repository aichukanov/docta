-- Insert Google Maps reviews for Dentix - Стоматолошка ординација Др.Ђурковић
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dentix-djurkovic-niksic.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dentix-djurkovic-niksic');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Вуковић', 'https://lh3.googleusercontent.com/a-/ALV-UjV_dSGJbRoH0sn8tsh15gMKQhNJZJND_YzJvwazkxq842eknk_d=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106495403618204946384/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106495403618204946384/reviews');
SET @user_jelena_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106495403618204946384/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Momcilo Dragovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWg2G2aSy3tLVInUTdNnzYJEU9bduI1aCqg6AyoAKxOG5511m-1=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101338403374823611395/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101338403374823611395/reviews');
SET @user_momcilo_dragovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101338403374823611395/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja Krsmanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJzMtPuKPnNFfY_AGUjRquC4Q4YX6vnokr8QL97AsTN-rzwDw=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/111386479418036547988/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111386479418036547988/reviews');
SET @user_nemanja_krsmanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111386479418036547988/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljilja Zivkovic', 'https://lh3.googleusercontent.com/a/ACg8ocIV9EV3_vQt_ElgMmgpjxO97fUqLAWoHxkq6mCKfFD15gMJDw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107011174786336900881/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107011174786336900881/reviews');
SET @user_ljilja_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107011174786336900881/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'milica vulic', 'https://lh3.googleusercontent.com/a-/ALV-UjUcjU-lcDIPDcJ28HrcaPDHul093DINkGALAYS5OU2OfwuTYgDosA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112364282628771128462/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112364282628771128462/reviews');
SET @user_milica_vulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112364282628771128462/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Božidar Urošević', 'https://lh3.googleusercontent.com/a-/ALV-UjXK41QDodvALkv_WUtQw1xq_sbfnqvikGz6M4_tJaUrsD2sZ94w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111758161568746035537/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111758161568746035537/reviews');
SET @user_boidar_uroevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111758161568746035537/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Djurkovic', 'https://lh3.googleusercontent.com/a/ACg8ocI-4FiChpASSFNCQZE91mR9H0oVoHllEyIeK5Sd9GnR450l9w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114451786624423747960/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114451786624423747960/reviews');
SET @user_vesna_djurkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114451786624423747960/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana M.', 'https://lh3.googleusercontent.com/a-/ALV-UjWoTnMogw0YR5P7n9n1lITN4CUIMtRJmRZtUePs8rBxhkUZ6J7Y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113442160089484514836/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113442160089484514836/reviews');
SET @user_bojana_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113442160089484514836/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Djurkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJKhmx39uGHWSfeXnrnk_lwYR7kdAFTPo7X4QaHmBDa05HVGw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114850501479691690839/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114850501479691690839/reviews');
SET @user_sara_djurkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114850501479691690839/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'filip grubac', 'https://lh3.googleusercontent.com/a/ACg8ocKVBbx_5wCA4Ko4PmMgilQw1KgNsl06j_7OdVxUp1LbOUS5=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105573935275104365080/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105573935275104365080/reviews');
SET @user_filip_grubac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105573935275104365080/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Novica Milovic', 'https://lh3.googleusercontent.com/a/ACg8ocKnzuclEKP6cumIvMY2raxqhp-n975-V9hAQHhUCJOLDj8Zzw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109561354394798753553/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109561354394798753553/reviews');
SET @user_novica_milovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109561354394798753553/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Djurkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKw718--1Au7KptsLZxgelCKMRCmS-Ah9II7HdirE-G0Z3Jpw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117224813863086037202/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117224813863086037202/reviews');
SET @user_ivana_djurkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117224813863086037202/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Memedovic', 'https://lh3.googleusercontent.com/a/ACg8ocKjOSV7vNseTxfPr19MbbUnqMGcdnNDm-LBEJLZTXWQn4mG5A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104513300434318762739/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104513300434318762739/reviews');
SET @user_natasa_memedovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104513300434318762739/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocKF1nRNpwaiS63vpd4mUbdCRxps4JsESGbdmQBVaykyXk0jLA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109947131009558489524/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109947131009558489524/reviews');
SET @user_jovana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109947131009558489524/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Kisin', 'https://lh3.googleusercontent.com/a/ACg8ocIGSUpzaojCFDyxln7OVXX4-uH9PyMvmx_4luAGsnKnJgxPxA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106089807815611736358/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106089807815611736358/reviews');
SET @user_branko_kisin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106089807815611736358/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja', 'https://lh3.googleusercontent.com/a/ACg8ocLF3Cy74rH92zkfPkShKRWvwOG7JQOx-sv2dMsMJmoC4_NNvA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105865009425719787703/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105865009425719787703/reviews');
SET @user_nemanja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105865009425719787703/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dajana Dragnic', 'https://lh3.googleusercontent.com/a/ACg8ocLczGNg2QG12yaUQrwqSMYAuTmLDekWBiG8M6j4hVaHyVf1IQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106661939571056106305/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106661939571056106305/reviews');
SET @user_dajana_dragnic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106661939571056106305/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Kandić', 'https://lh3.googleusercontent.com/a-/ALV-UjVZI5d-1WdNmsriuSdPlNpr9Ez4xWaU-LrWd8WaLkGKCqPJraqHQQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113769619354334058902/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113769619354334058902/reviews');
SET @user_jelena_kandi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113769619354334058902/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Knezevic', 'https://lh3.googleusercontent.com/a/ACg8ocJgnDLaDifc-8IY9j5jFmakzcod7_bZ0980tIWqLJs2Askzqw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105807041958463307662/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105807041958463307662/reviews');
SET @user_luka_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105807041958463307662/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Kovačević', 'https://lh3.googleusercontent.com/a/ACg8ocIauTdV43Wts7FDHWCKXH5QPBCPgXdhOidSPqeG5vQSv7fLcQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100740429853386748187/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100740429853386748187/reviews');
SET @user_marija_kovaevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100740429853386748187/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Zivkovic', 'https://lh3.googleusercontent.com/a/ACg8ocL_QCoSB5vJ13d4V5t_9n4dgKsNJMNY8NyvRBIbjxPSQF76_g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107573985768949135784/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107573985768949135784/reviews');
SET @user_tijana_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107573985768949135784/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Becanovic', 'https://lh3.googleusercontent.com/a/ACg8ocK0Rxy8YLv3iGroRGgw-JJWhCIDM2F0Xwc8XLLrbMicxOiGeg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115219493907549054361/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115219493907549054361/reviews');
SET @user_andjela_becanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115219493907549054361/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Djurkovic', 'https://lh3.googleusercontent.com/a/ACg8ocLzqAkyliakp8t8WQovJ7_FHI-du9BPVRdlBSG13mzv8TpYEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113366215749017734444/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113366215749017734444/reviews');
SET @user_jovana_djurkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113366215749017734444/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Никола Жижић', 'https://lh3.googleusercontent.com/a-/ALV-UjXYCSz8ZFbgDouaO7paahL92QkqM775v2c7l1Vp4DhNquIpbwM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112270606844130503615/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112270606844130503615/reviews');
SET @user_nikola_zhizhic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112270606844130503615/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nevena Sundic', 'https://lh3.googleusercontent.com/a-/ALV-UjUndngzgTmAiOqi_MT5itLEObiXDpW0B6Id4kAKrWCTVAJsU9rS=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113085633836420794202/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113085633836420794202/reviews');
SET @user_nevena_sundic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113085633836420794202/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasilije Knezevic', 'https://lh3.googleusercontent.com/a/ACg8ocI8kwmuIHYF2YI1AIeIzstfqQDyAgxBLGzRj4ETmRZYcty7Ozqb=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113748047714715110754/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113748047714715110754/reviews');
SET @user_vasilije_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113748047714715110754/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Velibor Djurkovic', 'https://lh3.googleusercontent.com/a/ACg8ocLnfAwDz-wp6X2B4rVOHmgXJ4WxgdNVZCV-Yj2B3p6_m6cnBQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110052972493819969061/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110052972493819969061/reviews');
SET @user_velibor_djurkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110052972493819969061/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'simonida milicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW_82xqzxAO0Bgpd3pBx3AVYEO7nXrve4cWaSMk36caOnU0DfL9jg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100929808538791840768/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100929808538791840768/reviews');
SET @user_simonida_milicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100929808538791840768/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Milošević', 'https://lh3.googleusercontent.com/a-/ALV-UjXBWR0Z79K4fHIVwMXQ0KJM8S_hB4m0rbxxdM_31WisvsyLZp8h=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112451610222066329097/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451610222066329097/reviews');
SET @user_nikola_miloevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112451610222066329097/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stevan Colovic', 'https://lh3.googleusercontent.com/a/ACg8ocIt1zU2GJA1NiePB5Zovo6t94wfQn1Rd-zwIQ_2NFbzqqdYow=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110044797680953213329/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110044797680953213329/reviews');
SET @user_stevan_colovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110044797680953213329/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vukoman Lalovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVTpWJECUnql_UkfpAIDzqQF8na2eBfZu74WwtvPW9nQLFCmfZg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115610890465757134080/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115610890465757134080/reviews');
SET @user_vukoman_lalovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115610890465757134080/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocJgSy_rDUrV73vhUPTkrkzfEQB0YhfbaB9lvf3T3lQInmc95L8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104602497467493548357/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104602497467493548357/reviews');
SET @user_darko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104602497467493548357/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_jelena_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzaFluNmxnRRAB',
    5, 'hr', 'Sve pohvale i preporuke za ovu ordinaciju ,doktor je super i komunicira sa pacijentima,i medicinska sestra je super.... Stvarno sve pohvale i tople preporuke  😁🥰🥰',
    'Sve pohvale i preporuke za ovu ordinaciju, doktor je odličan i komunicira sa pacijentima, a sestra odlična... Zaista sve pohvale i tople preporuke 😁🥰🥰', 'Све похвале и препоруке за ову ординацију, доктор је одличан и комуницира са пацијентима, а сестра одлична... Заиста све похвале и топле препоруке 😁🥰🥰', NULL, NULL, NULL, NULL,
    0, '2024-11-07 09:13:05'),

(@user_momcilo_dragovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURHZzhUc3FRRRAB',
    5, 'bs', 'Najbolja stomatoloska ordinacija u CG.',
    'Najbolja stomatološka ordinacija u Crnoj Gori.', 'Најбоља стоматолошка ординација у Црној Гори.', NULL, NULL, NULL, NULL,
    2, '2021-12-07 14:03:03'),

(@user_nemanja_krsmanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHNDV2RVN3EAE',
    5, 'en', 'Best!',
    'Najbolje!', 'Најбоље!', 'Best!', NULL, NULL, NULL,
    0, '2022-07-05 04:42:05'),

(@user_ljilja_zivkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSUNoMS1xZGtRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-02-24 12:55:34'),

(@user_milica_vulic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtMkthZTJBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-12-17 17:37:42'),

(@user_boidar_uroevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaQ1VtOTBZbU5CVVVKclVUbFJRMWRuTkVoRk9GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_vesna_djurkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSUNtMlBERklnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_bojana_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSUNtbVBfZUdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_sara_djurkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtbU9fc3FBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_filip_grubac, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtbUxmVzVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_novica_milovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHMl8yRkd3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_ivana_djurkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHeTR2NGVnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_natasa_memedovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURHeTVta3RBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_jovana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHa19MclJnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_branko_kisin, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURHNDV1ejNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_nemanja, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURHNDdPeG1BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_dajana_dragnic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURHZzVQMi1RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_jelena_kandi, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZzdIdUl3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_luka_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZy1HcEpBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_marija_kovaevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZzlhNVJREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_tijana_zivkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZzhhRFZnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_andjela_becanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZzdTV2N3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_jovana_djurkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZzhTbURBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_nikola_zhizhic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURHZzhURXJRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_nevena_sundic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZy1qQ2FnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_vasilije_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURHZ19ERGhRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_velibor_djurkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2MzdTY2JREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_simonida_milicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSUNhOV9TVllREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_nikola_miloevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURLMzdMOHV3RRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_stevan_colovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSURDNy1xeFdnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_vukoman_lalovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChdDSUhNMG9nS0VJQ0FnSURRem9YSDFnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_darko_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJQ8a_pU2oTRMRbxwj1PwkZpk/reviews/ChZDSUhNMG9nS0VJQ0FnSUNRaXVlMEFnEAE',
    1, 'ru', NULL,
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
