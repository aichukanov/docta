-- Insert Google Maps reviews for Special psychiatric hospital "Dobrota" Kotor
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/specijalna-bolnica-za-psihijatriju-dobrota-kotor.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'specijalna-bolnica-za-psihijatriju-dobrota-kotor');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ugljesa jurosevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVDNlNa90f_rN4AjqoHzBQVMEdIO6cUJlfukFARkRIMG-tGyNI=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101917397345746445781/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101917397345746445781/reviews');
SET @user_ugljesa_jurosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101917397345746445781/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bobo Bobić', 'https://lh3.googleusercontent.com/a/ACg8ocJSyyon-RORuaJrlAuUPmutWYuV7Aq4wH5t7P4GQCClZbfSEA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108229257764625812623/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108229257764625812623/reviews');
SET @user_bobo_bobi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108229257764625812623/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lazar Sekulic', 'https://lh3.googleusercontent.com/a-/ALV-UjVR4m2eVqst1dVGICMO5NQ0WvR8i8_cOvA5wB-TA_Dv1l6ZmYbu=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104706893973345476066/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104706893973345476066/reviews');
SET @user_lazar_sekulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104706893973345476066/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'eveni', 'https://lh3.googleusercontent.com/a-/ALV-UjUE-mlyjmEMo3HGuXpsNZbFWvOT_yNaCYauOogzDQ0MBdG1ocM=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113713098964862329543/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113713098964862329543/reviews');
SET @user_eveni = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113713098964862329543/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Airnicco', 'https://lh3.googleusercontent.com/a-/ALV-UjVBoAl9r-xveq7Z4sNyPnQUYoO9pkb9cH4abj9UdJK0D6HOOMTU=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/105278971614423022271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105278971614423022271/reviews');
SET @user_airnicco = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105278971614423022271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'шура', 'https://lh3.googleusercontent.com/a-/ALV-UjUmCB0Rpum01eMg40IKyJ5h3Elpz_AbKerJJcbiIgBFEvKJ_Y73tA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111394646098334123700/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111394646098334123700/reviews');
SET @user_shura = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111394646098334123700/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Юрий Шерстюк', 'https://lh3.googleusercontent.com/a-/ALV-UjUHa9Mo2MYyQfPD90t_py_XaJXJ9ps9zZhuJnJ6z6FXXPyZDwz5=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109164591940101357161/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109164591940101357161/reviews');
SET @user_yuriy_sherstyuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109164591940101357161/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sojka ptica', 'https://lh3.googleusercontent.com/a/ACg8ocJ6LpvtH0YfPDIIOlkqxo2mr-JvAvR-8TPZ-ulSbVHNMs6NXA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113327122607778618983/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113327122607778618983/reviews');
SET @user_sojka_ptica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113327122607778618983/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Mihailovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV9t8go1tkFluK8fDu-AMSgnW6s0rJeLe5eq9LSuMLwRYxQuAhr=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115373066429166248553/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115373066429166248553/reviews');
SET @user_filip_mihailovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115373066429166248553/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lena K', 'https://lh3.googleusercontent.com/a-/ALV-UjWXrYLS2bIMYE19t8hNw12oFH73LXUlmEPWDD3JjEt-ja5CpQU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102575361475288692745/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102575361475288692745/reviews');
SET @user_lena_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102575361475288692745/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zehra', 'https://lh3.googleusercontent.com/a-/ALV-UjUW_f_7CXlB6GH_2tfQ3IKr_W3ZEtynlOeUjIqjdpceLiROEg8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117781375904427157276/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117781375904427157276/reviews');
SET @user_zehra = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117781375904427157276/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tea Tea', 'https://lh3.googleusercontent.com/a-/ALV-UjU8ufipDsD_iq9rXED3F8EqwbF-oFdUl-gObWDs1z8s7hPaVd9v=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103416536324921089900/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103416536324921089900/reviews');
SET @user_tea_tea = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103416536324921089900/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ђорђе Поповић', 'https://lh3.googleusercontent.com/a-/ALV-UjWF7kteUXS-RbI9WAml5HjUECHwL9qTM2cxf7u0nqv6CnNhFCw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100692445816435001609/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100692445816435001609/reviews');
SET @user_djordje_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100692445816435001609/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Astra Manojlović', 'https://lh3.googleusercontent.com/a/ACg8ocIMSbxlvexmgupimguubAa-tNsi9YmnqLYqArY64igoLxWm2g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109773472146028673155/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109773472146028673155/reviews');
SET @user_astra_manojlovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109773472146028673155/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Torbica Jovo', 'https://lh3.googleusercontent.com/a-/ALV-UjWpkxmPhMI0q8RNNQlWdjKoGQ4XJAUFGGIfFlP8ljwooTFovPW1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115734945797631062000/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115734945797631062000/reviews');
SET @user_torbica_jovo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115734945797631062000/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Damjan Stanojevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVuBBlM84b3mnZ1mI9gUHkkG5WuQ-76yD3QzZkItdobhijjOwNs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108141256240620081548/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108141256240620081548/reviews');
SET @user_damjan_stanojevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108141256240620081548/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vlado Kojić', 'https://lh3.googleusercontent.com/a-/ALV-UjXIJhxvj0A5PgmQX5yOdN1Sr8WmuhNTj6BteXdniLnzMNcC4zLA5A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108772311683407242721/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108772311683407242721/reviews');
SET @user_vlado_koji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108772311683407242721/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Retro 87', 'https://lh3.googleusercontent.com/a-/ALV-UjVUHBj5UlJYwlOOwF81xt2vrTH7nMhSghFvHXSoJH8GYRU7Q_vm=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114179966645460529648/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114179966645460529648/reviews');
SET @user_retro_87 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114179966645460529648/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Oliveric', 'https://lh3.googleusercontent.com/a-/ALV-UjUUJqDdwhaHyqJQzsgS56qnzw_zuz4P6gNw9BSp8nYdrft2CC4k=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110213040403734350716/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110213040403734350716/reviews');
SET @user_aleksandar_oliveric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110213040403734350716/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'let\'s go to hell and get my boyfriend back', 'https://lh3.googleusercontent.com/a/ACg8ocL8FtwjkSYE5t2-xTZC8yKM3CeQykP6XgMB6ZpBsIy5wp1S4TQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106125020855357952157/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106125020855357952157/reviews');
SET @user_lets_go_to_hell_and_get_my_boyfriend_back = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106125020855357952157/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Uros Radomirovic', 'https://lh3.googleusercontent.com/a/ACg8ocKcH-GTUjB-xDc2YXGpDBXlbAbkevXD2wC8tt8jjovHkq0s1h8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116286473166791352168/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116286473166791352168/reviews');
SET @user_uros_radomirovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116286473166791352168/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'NikolaJovanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWfURf6rtWsfVwsj_ZRqKzIDybFzNMTT-OBwG4X201EfOpyA-eG=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112560873702638536346/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112560873702638536346/reviews');
SET @user_nikolajovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112560873702638536346/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Fatbardh', 'https://lh3.googleusercontent.com/a/ACg8ocL6-e9obc6ct0JIsTU0LhQa0x8grQfrNwBjHOWlbb-rhgToepo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104323161103823808975/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104323161103823808975/reviews');
SET @user_fatbardh = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104323161103823808975/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Silver Ghost', 'https://lh3.googleusercontent.com/a-/ALV-UjXPpttRNFZWShd5kJQLZ39WGRXzLyyDsP3b_v7TVPCuLt-QDotA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106423246271035156280/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106423246271035156280/reviews');
SET @user_silver_ghost = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106423246271035156280/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Debelnogic', 'https://lh3.googleusercontent.com/a-/ALV-UjWUiQ8IdjF8sEaHDbmjWc2N3YAvtfLx8UBnMnuAJ3LtHNPewSc=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115778026743978761986/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115778026743978761986/reviews');
SET @user_luka_debelnogic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115778026743978761986/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darko Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVUIrHwgH1swtG8abXIO_LoUB1kUafxLgTP5jy9ADRnFpzZZxM=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115706976222137722027/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115706976222137722027/reviews');
SET @user_darko_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115706976222137722027/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljupka Vergic', 'https://lh3.googleusercontent.com/a/ACg8ocLT15feZiBInbhO66h7JwhUU3i26qFm3NqMBM6Rzp6AMFGiwg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102085078710627827089/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102085078710627827089/reviews');
SET @user_ljupka_vergic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102085078710627827089/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Renato Grgurevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWpF-aaf7_fyIrCIx-lZnlB_z8tWY9o1axPELsDjG5eVtGMI95U4w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103611090427444244485/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103611090427444244485/reviews');
SET @user_renato_grgurevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103611090427444244485/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Ristelic', 'https://lh3.googleusercontent.com/a/ACg8ocK3AkrR0qO5y4K-v69uy8CpXIbfeza6ARcTW7iZzZkz-ft3hw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105332447449764738875/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105332447449764738875/reviews');
SET @user_natasa_ristelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105332447449764738875/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Blerim Mandija', 'https://lh3.googleusercontent.com/a-/ALV-UjUlAVe3JUEbK2G5MSXfLBj2pk4-dg4lxmBDyzFQjMIRxru9YT0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111171609303930298767/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111171609303930298767/reviews');
SET @user_blerim_mandija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111171609303930298767/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Ivanaj', 'https://lh3.googleusercontent.com/a/ACg8ocK6XEvdo02z5AaPjZlRNdhcSLZEcYuwP9JHUf2pW6GIMnBPQQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101821537315572179075/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101821537315572179075/reviews');
SET @user_ivan_ivanaj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101821537315572179075/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ugljesa_jurosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSWlFuQkRRbmRUWm1sYVJWVmlNUzF1VDBwSlNIYxAB',
    3, 'bs', 'Bilo je divno posetiti ovu ustanovu, bio sam poslan tamo zbog silovanja svog deteta i prisiljavanje komsije da snima, mislio sam da ce biti uzasno ali grdno sam se prevario kada sam upoznao gospodina doktora Fedju i od tad, sve se promenilo...
Fedja je bio jako fin i razuman individualac i svaki put kada neko nije obracao paznju ja bi se ugodno smjestio u njegovom krilu dok mi je on davao magicne lekove iglom
Iz nekog razloga svaki lijek se morao topiti upaljacem u kasicici medjutim meni to nije smetalo jer bi nakon njih zaboravio na sve probleme
Jedan od ljepsih trenutaka je bilo kada nas je posetio Zeks da bi mu doneo jos magicnog praha
Bilo je divno iskustvo i svima preporucujem pogotovo ako su devojcice ispod 12 godina!😊😊😊',
    'Bilo je divno posetiti ovu ustanovu, tamo sam poslata jer sam silovala svoje dete i terala komšiju da to snima, mislila sam da će biti strašno, ali sam mnogo pogrešila kada sam upoznala gospodina doktora Feđu i od tada se sve promenilo...
Feđa je bio veoma fin i razuman čovek i svaki put kada neko nije obraćao pažnju ja bih mu udobno seo u krilo dok mi je iglom davao magične lekove
Iz nekog razloga svaki lek je morao da se rastopi sa upaljačem u kašičici, međutim meni nije smetalo jer bih posle uzimanja zaboravio na sve svoje probleme
Jedan od najlepših trenutaka bio je kada nas je posetio Zeks da mu donese još magičnog praha
Bilo je to divno iskustvo i preporučujem ga svima, posebno ako su devojke mlađe od 12 godina!😊😊😊', 'Било је дивно посетити ову установу, тамо сам послата јер сам силовала своје дете и терала комшију да то снима, мислила сам да ће бити страшно, али сам много погрешила када сам упознала господина доктора Феђу и од тада се све променило...
Феђа је био веома фин и разуман човек и сваки пут када неко није обраћао пажњу ја бих му удобно сео у крило док ми је иглом давао магичне лекове
Из неког разлога сваки лек је морао да се растопи са упаљачем у кашичици, међутим мени није сметало јер бих после узимања заборавио на све своје проблеме
Један од најлепших тренутака био је када нас је посетио Зекс да му донесе још магичног праха
Било је то дивно искуство и препоручујем га свима, посебно ако су девојке млађе од 12 година!😊😊😊', NULL, NULL, NULL, NULL,
    0, '2025-11-04 08:44:00'),

(@user_bobo_bobi, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VMVDdnYlN5LTdEZ053EAE',
    5, 'hr', 'Završio sam u ovom divnom mjestu iz razloga što sam hladno ubio profesoricu baleta moje kćeri pred svom djecom

Kad sam došao ovdje, mislio sam da sam gotov. Ipak, divni gospodin Feđa mi je svaki dan učinio posebnim sa njegovim nesebičnim dobrim djelima. Kad nisam mogao spavam, ispod nosa bi mi stavio bijeli misteriozni prah koji bi me smirio i pomogao da zaspim.
Kad bih imao strašne šizofrenične napade, gurao bi mi posebno dugu iglu u moje intimne dijelove i pomogao bi mi svako veče da ih čistim.

Sve preporuke ovoj ustanovi, i našem najboljem doktoru FEĐI! Nezaboravno iskustvo. ❤️❤️❤️❤️',
    'Završila sam na ovom divnom mestu jer sam hladnokrvno ubila učiteljicu baleta svoje ćerke pred svojom decom.

Kada sam došla ovde, mislila sam da sam gotova. Međutim, divni gospodin Feđa je svaki dan činio posebnim za mene svojim nesebičnim dobrim delima. Kada nisam mogla da spavam, stavljao bi mi beli misteriozni prah ispod nosa koji bi me smirivao i pomagao mi da zaspim.
Kada sam imala strašne napade šizofrenije, zabadao bi mi posebno dugačku iglu u intimne delove i pomagao mi da ih čistim svake večeri.

Sve preporuke ovoj ustanovi i našem najboljem doktoru FEĐI! Nezaboravno iskustvo. ❤️❤️❤️❤️', 'Завршила сам на овом дивном месту јер сам хладнокрвно убила учитељицу балета своје ћерке пред својом децом.

Када сам дошла овде, мислила сам да сам готова. Међутим, дивни господин Феђа је сваки дан чинио посебним за мене својим несебичним добрим делима. Када нисам могла да спавам, стављао би ми бели мистериозни прах испод носа који би ме смиривао и помагао ми да заспим.
Када сам имала страшне нападе шизофреније, забадао би ми посебно дугачку иглу у интимне делове и помагао ми да их чистим сваке вечери.

Све препоруке овој установи и нашем најбољем доктору ФЕЂИ! Незаборавно искуство. ❤️❤️❤️❤️', NULL, NULL, NULL, NULL,
    0, '2025-06-16 11:54:33'),

(@user_lazar_sekulic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSURyeDRXeFNREAE',
    5, 'en', 'Most refreshing experience I\'ve had in my life and it only was possible because of Dr. Feđa.I was sent there for having really intimate time with my bosses car but thanks to Feđa I dont feel such needs anymore, also I had a bit of nicotine addiction problem which caused me to scrape of the paint of the walls in my room.Thankfully Feđa had just the cure, it was some kind of green cigarette that made me feel really relaxed and happy for about 4 hours or so.They were lightly laced with tobacco and some kind of yellow particles(it was probably nothing meaningful) and the therapy lasted for about a month.Now free from any of my addictions or weird intentions I roam throughout the city named Kotor trying to find new start at life.
Thank you doctor Feđa!❤️',
    'Najosvežavajuće iskustvo koje sam imao u životu, a to je bilo moguće samo zahvaljujući dr Feđi. Poslat sam tamo zbog intimnog vremena provedenog sa šefovim autom, ali zahvaljujući Feđi više ne osećam takvu potrebu. Takođe sam imao mali problem sa zavisnošću od nikotina zbog čega sam strugao farbu sa zidova u svojoj sobi. Srećom, Feđa je imao pravi lek, neku vrstu zelene cigarete koja me je opuštala i činila srećnom oko 4 sata. Bile su blago pomešane sa duvanom i nekom vrstom žutih čestica (verovatno ništa značajno) i terapija je trajala oko mesec dana. Sada, oslobođen svih zavisnosti ili čudnih namera, lutam po gradu Kotoru pokušavajući da pronađem novi početak u životu.
Hvala vam, doktore Feđa!❤️', 'Најосвежавајуће искуство које сам имао у животу, а то је било могуће само захваљујући др Феђи. Послат сам тамо због интимног времена проведеног са шефовим аутом, али захваљујући Феђи више не осећам такву потребу. Такође сам имао мали проблем са зависношћу од никотина због чега сам стругао фарбу са зидова у својој соби. Срећом, Феђа је имао прави лек, неку врсту зелене цигарете која ме је опуштала и чинила срећном око 4 сата. Биле су благо помешане са дуваном и неком врстом жутих честица (вероватно ништа значајно) и терапија је трајала око месец дана. Сада, ослобођен свих зависности или чудних намера, лутам по граду Котору покушавајући да пронађем нови почетак у животу.
Хвала вам, докторе Феђа!❤️', 'Most refreshing experience I\'ve had in my life and it only was possible because of Dr. Feđa.I was sent there for having really intimate time with my bosses car but thanks to Feđa I dont feel such needs anymore, also I had a bit of nicotine addiction problem which caused me to scrape of the paint of the walls in my room.Thankfully Feđa had just the cure, it was some kind of green cigarette that made me feel really relaxed and happy for about 4 hours or so.They were lightly laced with tobacco and some kind of yellow particles(it was probably nothing meaningful) and the therapy lasted for about a month.Now free from any of my addictions or weird intentions I roam throughout the city named Kotor trying to find new start at life.
Thank you doctor Feđa!❤️', NULL, NULL, NULL,
    4, '2024-07-20 20:11:09'),

(@user_eveni, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSURaNUtpNlJ3EAE',
    5, 'en', 'Very lovely place. I got taken in for mass murder and shizophrenyia and when I meet dr Fedja my life turned around. Such lovely man, he gave me some special powder medicine and I never feeled so good. I never killed any people after that. Although he was aggressive sometimes and I was almost molested I\'m giving 9/10 service. Keep being hard! 💓',
    'Veoma lepo mesto. Priveden sam zbog masovnog ubistva i šizofrenije i kada sam upoznao dr Feđu život mi se preokrenuo. Tako divan čovek, dao mi je neki specijalni lek u prahu i nikad se nisam osećao tako dobro. Nikada posle toga nisam ubio nikoga. Iako je ponekad bio agresivan i skoro sam bio maltretiran, dajem uslugu 9/10. Budite naporni! 💓', 'Веома лепо место. Приведен сам због масовног убиства и шизофреније и када сам упознао др Феђу живот ми се преокренуо. Тако диван човек, дао ми је неки специјални лек у праху и никад се нисам осећао тако добро. Никада после тога нисам убио никога. Иако је понекад био агресиван и скоро сам био малтретиран, дајем услугу 9/10. Будите напорни! 💓', 'Very lovely place. I got taken in for mass murder and shizophrenyia and when I meet dr Fedja my life turned around. Such lovely man, he gave me some special powder medicine and I never feeled so good. I never killed any people after that. Although he was aggressive sometimes and I was almost molested I\'m giving 9/10 service. Keep being hard! 💓', NULL, NULL, NULL,
    0, '2023-09-24 20:48:51'),

(@user_airnicco, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSURaeWR1OGdnRRAB',
    5, 'en', 'Great place, I went their because I had a bit
of an episode and killed my daughter\'s cat
Infront of her when I was angry and
proceeded to use the corpse as a puppet,
also I stabed her in the leg. But it\'s in the
past. I mean my daughter still won\'t forgive
me for it even though we all make mistakes
Through that difficult time in the ward to
help me cope was the great Dr. Fedja. He
was always there for me and in the long
lonely nights he wound come in my room
and stand next to my head and watch me
sleep while he brushed his knife on my face
making me feel safe. He would always
make my meals extra delicious by adding
some of his home made white powder that
would really wake me up. I recommend
going there just for our amazing friend
Fedja, mister Fedja rocks,',
    'Odlično mesto, otišao sam tamo jer sam imao mali
napad i ubio mačku moje ćerke
pred njom kada sam bio ljut i
koristio sam leš kao lutku,
takođe sam je ubo nožem u nogu. Ali to je u
prošlosti. Mislim da mi ćerka još uvek neće oprostiti
za to iako svi grešimo.
Tokom tog teškog perioda na odeljenju, da mi
pomogne da se nosim sa tim, bio je sjajni dr Feđa. On
je uvek bio tu za mene i u dugim
usamljenim noćima je dolazio u moju sobu
i stajao pored moje glave i gledao me kako
spavam dok je nožem četkao moje lice
čineći da se osećam sigurno. Uvek bi
moje obroke učinio dodatno ukusnim dodajući
malo svog domaćeg belog praha koji
bi me zaista probudio. Preporučujem
da odete tamo samo zbog našeg neverovatnog prijatelja
Feđe, gospodin Feđa je super.', 'Одлично место, отишао сам тамо јер сам имао мали
напад и убио мачку моје ћерке
пред њом када сам био љут и
користио сам леш као лутку,
такође сам је убо ножем у ногу. Али то је у
прошлости. Мислим да ми ћерка још увек неће опростити
за то иако сви грешимо.
Током тог тешког периода на одељењу, да ми
помогне да се носим са тим, био је сјајни др Феђа. Он
је увек био ту за мене и у дугим
усамљеним ноћима је долазио у моју собу
и стајао поред моје главе и гледао ме како
спавам док је ножем четкао моје лице
чинећи да се осећам сигурно. Увек би
моје оброке учинио додатно укусним додајући
мало свог домаћег белог праха који
би ме заиста пробудио. Препоручујем
да одете тамо само због нашег невероватног пријатеља
Феђе, господин Феђа је супер.', 'Great place, I went their because I had a bit
of an episode and killed my daughter\'s cat
Infront of her when I was angry and
proceeded to use the corpse as a puppet,
also I stabed her in the leg. But it\'s in the
past. I mean my daughter still won\'t forgive
me for it even though we all make mistakes
Through that difficult time in the ward to
help me cope was the great Dr. Fedja. He
was always there for me and in the long
lonely nights he wound come in my room
and stand next to my head and watch me
sleep while he brushed his knife on my face
making me feel safe. He would always
make my meals extra delicious by adding
some of his home made white powder that
would really wake me up. I recommend
going there just for our amazing friend
Fedja, mister Fedja rocks,', NULL, NULL, NULL,
    13, '2023-10-03 17:42:01'),

(@user_shura, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OMFIycDBUSEY1TFZOT1UyeHNlRkJsWkdjeGJWRRAB',
    5, 'ru', 'лечила тяжелую депрессию и шизофрению, спасибо доктору федже! стало все намного хуже',
    NULL, NULL, NULL, 'лечила тяжелую депрессию и шизофрению, спасибо доктору федже! стало все намного хуже', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_yuriy_sherstyuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKT2JIaExjbmRUY1ZWRmRVdFBRbk5HY0ZOYVIyYxAB',
    1, 'uk', 'Громадянина України утримують у лікарні проти його волі. Родичів до нього не допускають. Зв’язку з сім’єю немає взагалі. На письмове звернення лікарня не відповідає.
:
Državljanin Ukrajine se zadržava u bolnici protiv svoje volje. Porodici se ne omogućava pristup. Nikakav kontakt sa porodicom nije omogućen. Bolnica ne odgovara na pisano obraćanje.

Просимо допомоги!

Molimo za pomoć!',
    NULL, NULL, NULL, NULL, NULL, NULL,
    1, '2026-08-29 00:00:00'),

(@user_sojka_ptica, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tReUxWVmhjR2hNYUZNMVoxaGpValZMZEZrNFRtYxAB',
    5, 'en', 'I had the best experience out there! Because I got addicted to commenting on instagram reels people sent me to Dr Fedja. He was deeply aroused by me. everytime I wanted to comment on something he would tie my hands, tape my mouth shut and put me to sleep🥰. I liked that experience but they kicked me out as soon as they found out I was pregnant with Fedja\'s child. I don\'t remember exactly how I got pregnant but Dr Fedja was such a nice man and told me not to worry or tell anyone because he would end my visit there so I didn\'t. But they eventually found out unfortunately😡..And soon I\'m going there to visit with my 4yr old child to meet his father ❤️ Fedja if you see this I still love you baby come home meet your son Charlie 😘
Greetings Sojka Kirk😍❤️🥰',
    NULL, NULL, 'I had the best experience out there! Because I got addicted to commenting on instagram reels people sent me to Dr Fedja. He was deeply aroused by me. everytime I wanted to comment on something he would tie my hands, tape my mouth shut and put me to sleep🥰. I liked that experience but they kicked me out as soon as they found out I was pregnant with Fedja\'s child. I don\'t remember exactly how I got pregnant but Dr Fedja was such a nice man and told me not to worry or tell anyone because he would end my visit there so I didn\'t. But they eventually found out unfortunately😡..And soon I\'m going there to visit with my 4yr old child to meet his father ❤️ Fedja if you see this I still love you baby come home meet your son Charlie 😘
Greetings Sojka Kirk😍❤️🥰', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_filip_mihailovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4RE4zTklURXhUZEZaSVJtbEpVVFpXUmxGU1VWRRAB',
    5, 'hr', 'ZU Specijalna bolnica za psihijatriju Dobrota Kotor',
    'ZU Specijalna bolnica za psihijatriju Dobrota Kotor', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_lena_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCdU0zaHNjVnAwTmt4NGVtaFJkMnhqUzBSZlJVRRAB',
    5, 'en', 'Dr Ana and her team helped me in an emergency department for the acute insomnia and anxiety when the nearest hospital was empty. The nurses were very friendly and supportive. I am very grateful that they helped me in that late hour and I was able to recover fast. I wish them the best in this difficult job that they do 🙏🏻🍀',
    NULL, NULL, 'Dr Ana and her team helped me in an emergency department for the acute insomnia and anxiety when the nearest hospital was empty. The nurses were very friendly and supportive. I am very grateful that they helped me in that late hour and I was able to recover fast. I wish them the best in this difficult job that they do 🙏🏻🍀', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_zehra, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oSlZIWTBlbHByVUZSTVFqUnFXVE5WTmtOWUxXYxAB',
    5, 'hr', 'gde da se javimo fedji, preko nam je potreban🙏',
    'gde da se javimo fedji, preko nam je potreban🙏', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_tea_tea, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VOR1ZtWmJVeTlQMDVRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_djordje_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNQMnRQUG1BRRAB',
    1, 'hr', 'Ovi nisu svi svoji',
    'Ovi nisu svi svoji', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_astra_manojlovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNEdE9DRnJnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_torbica_jovo, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSUM5a0lfMm9BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_damjan_stanojevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSUNkelB1eVR3EAE',
    5, 'mt', 'Fedja Fedja Fedja Fedja Fedja Fedja mmmmm...',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vlado_koji, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSUMxcktqVmtnRRAB',
    1, 'en', 'Fedja sterilized me ☹️',
    NULL, NULL, 'Fedja sterilized me ☹️', NULL, NULL, NULL,
    5, '2024-10-29 00:00:00'),

(@user_retro_87, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSURaeHBQRXpBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_aleksandar_oliveric, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSURaeHVPTGVREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_lets_go_to_hell_and_get_my_boyfriend_back, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSURaa3AyZklnEAE',
    5, 'hr', 'Hvala Feđolino wtp',
    'Hvala Feđolino wtp', NULL, NULL, NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_uros_radomirovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSURab3NUZlN3EAE',
    5, 'bs', 'Svaka čast Feđi za trud, odgovornost i pomoć. Bravo Feđa meštre',
    'Svaka čast Feđi za trud, odgovornost i pomoć. Bravo Feđa meštre', NULL, NULL, NULL, NULL, NULL,
    9, '2023-10-29 00:00:00'),

(@user_nikolajovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSURaX0xhcGl3RRAB',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_fatbardh, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSUQtaE5yMmZnEAE',
    5, 'en', 'Beautiful soft approach team',
    NULL, NULL, 'Beautiful soft approach team', NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_silver_ghost, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSUNlMzd6cGZ3EAE',
    5, 'en', 'Hello, I would like assistance with one of your previous patient named Zeljko Franovic. His assigned care taker was Dr. Fedja, who he used to talk alot about with love and care. It seems they had a close relationship. Zeljko commited a crime and killed a stray cat named Starboy, which was burried near the Kotor coast using a rusty spoon. If you can give me any information about him I would appreciate it. Zeljko is my cousin, and I worry about him and his mother Slavica. He hits her hard everyday, and is very instable. Please help me spread this message and find Zeljko and help him. Thanks. Love from Titovgrad.',
    NULL, NULL, 'Hello, I would like assistance with one of your previous patient named Zeljko Franovic. His assigned care taker was Dr. Fedja, who he used to talk alot about with love and care. It seems they had a close relationship. Zeljko commited a crime and killed a stray cat named Starboy, which was burried near the Kotor coast using a rusty spoon. If you can give me any information about him I would appreciate it. Zeljko is my cousin, and I worry about him and his mother Slavica. He hits her hard everyday, and is very instable. Please help me spread this message and find Zeljko and help him. Thanks. Love from Titovgrad.', NULL, NULL, NULL,
    9, '2022-10-29 00:00:00'),

(@user_luka_debelnogic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2NlB1VUlnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_darko_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSURNN29TS2xnRRAB',
    5, 'en', 'I was there for about 4 years and all I have to say is awesome service! I had disabled hands and there was this nice guy Fedja that helped me clean my intimate parts every morning and evening, sometimes even after lunch. 5 stars for Fedja and Kotor Hospital!',
    NULL, NULL, 'I was there for about 4 years and all I have to say is awesome service! I had disabled hands and there was this nice guy Fedja that helped me clean my intimate parts every morning and evening, sometimes even after lunch. 5 stars for Fedja and Kotor Hospital!', NULL, NULL, NULL,
    13, '2020-10-29 00:00:00'),

(@user_ljupka_vergic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3amZ2UzNnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_renato_grgurevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3bUlhUjFBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_natasa_ristelic, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChZDSUhNMG9nS0VJQ0FnSURBLWZtVFdREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_blerim_mandija, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3czlTV3FRRRAB',
    4, 'en', 'Nice place and very good service',
    NULL, NULL, 'Nice place and very good service', NULL, NULL, NULL,
    2, '2017-10-29 00:00:00'),

(@user_ivan_ivanaj, @clinic_id, NULL, 'google_maps',
    'places/ChIJxfzC83QzTBMRaa2hAKYOkTE/reviews/ChdDSUhNMG9nS0VJQ0FnSURRNTZ1WDB3RRAB',
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
