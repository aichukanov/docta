-- Insert Google Maps reviews for Stomatološka ordinacija Lopičić
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/lopicic-stomatoloska-ordinacija-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'lopicic-stomatoloska-ordinacija-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_aleksandar_lopicic = (SELECT id FROM doctors WHERE slug = 'aleksandar-lopicic');
SET @doctor_amra_amidovic_hamzic = (SELECT id FROM doctors WHERE slug = 'amra-amidovic-hamzic');
SET @doctor_andjela_djurisic = (SELECT id FROM doctors WHERE slug = 'andjela-djurisic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Gajevic', 'https://lh3.googleusercontent.com/a/ACg8ocIQFddW5Kb2sqjr-Ebs1Esy-cRbzOfSQq3HineZ_RhNoWJ5cw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103788194232154602276/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103788194232154602276/reviews');
SET @user_luka_gajevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103788194232154602276/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusica Janjevic', 'https://lh3.googleusercontent.com/a/ACg8ocIwxcchIuoNG-S0TMPVo5axZxMGM_rhcyysv_RWfNrbE9tr0g=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100541077593029502570/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100541077593029502570/reviews');
SET @user_dusica_janjevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100541077593029502570/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Damjanović', 'https://lh3.googleusercontent.com/a-/ALV-UjVzAr48Y0ik3G-ICRmIsb_6Djblv9jP0uijui_QCpp7ILU9h6DB=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107481156508352737572/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107481156508352737572/reviews');
SET @user_sanja_damjanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107481156508352737572/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Almira S', 'https://lh3.googleusercontent.com/a-/ALV-UjUE8H6ODBcU_DI94F_Kb32DakxjgisnDalWumcys9SfmvZuKoMW=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107636962206886947635/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107636962206886947635/reviews');
SET @user_almira_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107636962206886947635/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jole', 'https://lh3.googleusercontent.com/a/ACg8ocI8RMplPVQiWqDjLTf6oaBGdQDnDp-f78J9kQF7x3K8Cs-RfQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104251222603199347218/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104251222603199347218/reviews');
SET @user_jole = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104251222603199347218/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alexandr Simanov', 'https://lh3.googleusercontent.com/a/ACg8ocKcZ028c-MmgbLd8OflqM2ZAAfvEZeL47m9nmgXiVNPqR_rPA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108723011032636424482/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108723011032636424482/reviews');
SET @user_alexandr_simanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108723011032636424482/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Davorin Milacic', 'https://lh3.googleusercontent.com/a/ACg8ocLpNrDMYuAFs9LtUuiy6yYBIppNK6bg7ovYs6Z77T_V_d69_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109507225915244061952/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109507225915244061952/reviews');
SET @user_davorin_milacic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109507225915244061952/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Optimus Solutions', 'https://lh3.googleusercontent.com/a/ACg8ocL2iAPBWATob0ERGtWsvVsosri8e1WNiCE4tRIrdqd4rvVw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100519008813680069240/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100519008813680069240/reviews');
SET @user_optimus_solutions = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100519008813680069240/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sekule Raicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVM6MQ31jfMMkIKRkwTNr9umJU51UB-3XgBnmkxyxwteYcSaJ9O=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115778257255384704077/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115778257255384704077/reviews');
SET @user_sekule_raicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115778257255384704077/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Prelević', 'https://lh3.googleusercontent.com/a/ACg8ocLukTqkwfpYS_O4eJ5MUW5ErCzrKeYw8-BbP4PsIvM1c-DZzw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108890577762070937582/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108890577762070937582/reviews');
SET @user_marijana_prelevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108890577762070937582/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'DR RADUNOVIĆ', 'https://lh3.googleusercontent.com/a-/ALV-UjU39QNafemqDDHbWadIjR8BoFtJr6-8RGjm_9uFe4K7OGzS4Xkf=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102939682871624801294/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102939682871624801294/reviews');
SET @user_dr_radunovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102939682871624801294/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Muamer Dizdarević', 'https://lh3.googleusercontent.com/a-/ALV-UjVqbQQdSyM7nGPw3J3cuG8A0_igxi80UCQKcAqDXhkb2jB80UI=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114353687511741432855/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114353687511741432855/reviews');
SET @user_muamer_dizdarevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114353687511741432855/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Ljucovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUPUrwLYd5F-Z4hacR1XLtMCIi0T0CKmv_hBJSuIz_bfWsMCfKX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114871417034282419235/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114871417034282419235/reviews');
SET @user_sanja_ljucovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114871417034282419235/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nađa Ašanin', 'https://lh3.googleusercontent.com/a-/ALV-UjUX5cpSw77gl54YYEJPDpmaJweAMKoWl8fAP_0S1ct8s45JS0aD9w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100790544642579814511/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100790544642579814511/reviews');
SET @user_naa_aanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100790544642579814511/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Jelic', 'https://lh3.googleusercontent.com/a/ACg8ocKwDtdcPi_ImMDEhb3jMndL3Y7TQeOQmKXTcUhy70pIYkM1pw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107293657679230251053/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107293657679230251053/reviews');
SET @user_jovana_jelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107293657679230251053/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Martinovic', 'https://lh3.googleusercontent.com/a/ACg8ocKt5-JBPeoIORAAVCylifr1h64K-HBY-KojCE89Mfjy_UcxAQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100734700105027941432/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100734700105027941432/reviews');
SET @user_jovana_martinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100734700105027941432/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nikola popovic', 'https://lh3.googleusercontent.com/a/ACg8ocK5NDeWv1M7fZoYEF_619Wr8qBU2DXHt1DjurzRTJ0a-dL1aw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114506755390338868305/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114506755390338868305/reviews');
SET @user_nikola_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114506755390338868305/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica', 'https://lh3.googleusercontent.com/a/ACg8ocI_nWT-nE82kInEF0u-dweI5xVYczEv64kx23nQgzA8rxNjNQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100839738783549988974/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100839738783549988974/reviews');
SET @user_milica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100839738783549988974/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'BBISER', 'https://lh3.googleusercontent.com/a/ACg8ocJCloi4u9UGGodNJoMNYVTOiigkVUt-e4w9nFQgTDgcCqfdUg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102105763279928396286/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102105763279928396286/reviews');
SET @user_bbiser = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102105763279928396286/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vila Stoliv', 'https://lh3.googleusercontent.com/a/ACg8ocJ46xZfjU2F_bdzjmhoTSW0sQJnDRu1RR_n3BAoRMT951arMw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115290477876972347011/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115290477876972347011/reviews');
SET @user_vila_stoliv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115290477876972347011/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Mijovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVbrq50pntPwEdzo6jI1klbb_ER4NuGZRAmSLRrjwQgzY7b0aM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115642777677216633552/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115642777677216633552/reviews');
SET @user_sandra_mijovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115642777677216633552/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Savovic', 'https://lh3.googleusercontent.com/a/ACg8ocIgGNKRkkxwFR3QFF8VeVQK1Ze813XWj09RtA0PXEbPqtQGuw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114502408085839300242/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114502408085839300242/reviews');
SET @user_luka_savovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114502408085839300242/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Kostic', 'https://lh3.googleusercontent.com/a-/ALV-UjVffoDasIJRmet9uFNzjDZGeLRggsqEVHOddfV9PGEILXdcjPTZ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102166275143057404518/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102166275143057404518/reviews');
SET @user_dragana_kostic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102166275143057404518/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milorad Prascevic', 'https://lh3.googleusercontent.com/a/ACg8ocL9kDSN0-5TGIZLrOjuSlrovVPY0_VK2AiJcVhWemSWBuSs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101596957530791611679/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101596957530791611679/reviews');
SET @user_milorad_prascevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101596957530791611679/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'amar sabotic', 'https://lh3.googleusercontent.com/a/ACg8ocIktFLAgDI5omE2F6wd2GWmEQN4a5YT2J5G1S_KPaBU40cJLg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104077082885250342336/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104077082885250342336/reviews');
SET @user_amar_sabotic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104077082885250342336/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Radivojevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWO0vvWBIhYLrRb2-XgFb6EJYuDMljiYI59YzlIjSQzMeKZsa3h=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109201990582436807503/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109201990582436807503/reviews');
SET @user_marijana_radivojevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109201990582436807503/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selma Banda', 'https://lh3.googleusercontent.com/a/ACg8ocLqk0_CB6YSFzUqZ7Msf_edcIqzgZmnmOQkbhTtWryaQmBlDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118162629290641812336/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118162629290641812336/reviews');
SET @user_selma_banda = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118162629290641812336/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'legendary plays', 'https://lh3.googleusercontent.com/a-/ALV-UjU8vC9dYcN7pCPoLV2MYLv5-3DuMOsFfw0NKq02Co4GFtE2Pn43=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116418780990050938676/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116418780990050938676/reviews');
SET @user_legendary_plays = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116418780990050938676/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vojislav Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJZ99FxiBGl7JqMJW1EGAZnwsrXg9nzoHHWyigU0m54Fod0lw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106419086187167284873/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106419086187167284873/reviews');
SET @user_vojislav_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106419086187167284873/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Bujisic', 'https://lh3.googleusercontent.com/a/ACg8ocK2LdZTQ6hRnblQVZXAqNzQV1hWT3Le5RAwmnmgAxUX4OjQBAg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111780914417757951193/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111780914417757951193/reviews');
SET @user_jovana_bujisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111780914417757951193/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Pejović', 'https://lh3.googleusercontent.com/a-/ALV-UjUUzt7XHtJZRQ57auJ_o-pWqGD01p72qfrEmgNHYEaLtGWWp60=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105156794368436796207/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105156794368436796207/reviews');
SET @user_marina_pejovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105156794368436796207/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladen Popović', 'https://lh3.googleusercontent.com/a/ACg8ocLXsrfxuuYwA1vB3isXxJJ8eduLMQCtUkjsiX8mN2vnri0S7A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105217498860329367515/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105217498860329367515/reviews');
SET @user_mladen_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105217498860329367515/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Most Want', 'https://lh3.googleusercontent.com/a-/ALV-UjXaQ96ZXX73x32ZJ6qH-OITVejS1HvVsV6ngV8UAq3zbDUGvow=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104355839764132959172/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104355839764132959172/reviews');
SET @user_most_want = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104355839764132959172/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rasovo Resnik', 'https://lh3.googleusercontent.com/a/ACg8ocLMM1Ss4Vu2AaHYSSm2yyjRKNc8lCz2pCsvzTWvF6vfyCId3w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103867842063418270775/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103867842063418270775/reviews');
SET @user_rasovo_resnik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103867842063418270775/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Hamidovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVsHySr6gnssmn_Jhm6WQP5fMy5HUYyB6NRYTp4zMf1S6aPTV-k=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110874830655088538584/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110874830655088538584/reviews');
SET @user_emir_hamidovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110874830655088538584/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bane', 'https://lh3.googleusercontent.com/a-/ALV-UjXM_hbrE7AhOEf4qD8cGUDw_QEkwrutOO0D14hZqD4V2WIU_xqb=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116703170030603305071/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116703170030603305071/reviews');
SET @user_bane = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116703170030603305071/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirela Spahic', 'https://lh3.googleusercontent.com/a/ACg8ocKxmAYYf0ZMF80vlEEVLTki8Yq1MCNsNxSXa-1RdbbxY1hC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100534997621403064158/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100534997621403064158/reviews');
SET @user_mirela_spahic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100534997621403064158/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavica Vukicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW2voV8OP53upQi83Bg49wIyV75IUmkFh71fic2f_fywcuV_OhP=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103900993125431041644/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103900993125431041644/reviews');
SET @user_slavica_vukicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103900993125431041644/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Đikanović Matija', 'https://lh3.googleusercontent.com/a/ACg8ocLjCAXioNi-aUGkTojOogXqFounueYOjVqk1r6hVPyvhnR_i0Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114833020522188639967/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114833020522188639967/reviews');
SET @user_ikanovi_matija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114833020522188639967/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'JOVAN RACKOVIC', 'https://lh3.googleusercontent.com/a-/ALV-UjXFNs2kWc9RQoPCxHbjF86OzFvwTBysPVZjrhPFqEv5AdFQEse_Nw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112331072581733446526/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112331072581733446526/reviews');
SET @user_jovan_rackovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112331072581733446526/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Gazivoda', 'https://lh3.googleusercontent.com/a/ACg8ocLuyS8bb0dJg9znaLwqeu2lCqPAUY9lEvRAFDJN_yWPFN3ERQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109790163043024763959/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109790163043024763959/reviews');
SET @user_milena_gazivoda = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109790163043024763959/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Mugoša', 'https://lh3.googleusercontent.com/a/ACg8ocLyxZ0jY69VhPOEB5uNc5NGF7jIzv39uh2iIieLiKNbYOxKaSE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118404227716628635937/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118404227716628635937/reviews');
SET @user_jovana_mugoa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118404227716628635937/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubica Nikolic', 'https://lh3.googleusercontent.com/a-/ALV-UjVjb232MY8xmoY_6dKaPVloyvBfQtQIAaF01_MuyB9dj5wo01AK=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116005896780097250522/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116005896780097250522/reviews');
SET @user_ljubica_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116005896780097250522/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Ljumovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX1DUYCBvopP7Jygvyj285mL-jUIM0v9-8gCbE_kWIKV-DZIcFdAQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108155874700091751926/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108155874700091751926/reviews');
SET @user_marina_ljumovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108155874700091751926/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Darija Tomovic', 'https://lh3.googleusercontent.com/a/ACg8ocILkpcGA2eAX3JoLiM2n48QqoizFWf5zEsJsARLPDaw0torrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113854549090204296123/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113854549090204296123/reviews');
SET @user_darija_tomovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113854549090204296123/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Laketic', 'https://lh3.googleusercontent.com/a/ACg8ocJP-piJ0RF2aVA2dbHlxrzQZ1qpgybByi8SGrPlDIN4-uyxgg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111091874845186910588/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111091874845186910588/reviews');
SET @user_nikola_laketic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111091874845186910588/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Vulas', 'https://lh3.googleusercontent.com/a/ACg8ocLa93gi_x0AiEsYpSC1JeCF3Gxo7KRktBs0kMKvXDgIOP9fXw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111119081276370240197/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111119081276370240197/reviews');
SET @user_nikola_vulas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111119081276370240197/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Vidic', 'https://lh3.googleusercontent.com/a-/ALV-UjVNaoii718eJQx40mn065ZwVkDKlEXpLKb2CkTZH2V4k9zdNCwW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117482049857765939259/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117482049857765939259/reviews');
SET @user_milos_vidic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117482049857765939259/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Westmeier', 'https://lh3.googleusercontent.com/a/ACg8ocK-2ZEwJgPDHi8_8uwuVi48_B_rVqZo8Z_tQ5XVM0x3R8xzxw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104506561029864502616/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104506561029864502616/reviews');
SET @user_vesna_westmeier = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104506561029864502616/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danka Sekulic', 'https://lh3.googleusercontent.com/a-/ALV-UjURRw1q1Cj3Q1CB6v3NR5BDOUTJ-XbpHDRa8EbkRtUQbUHyfk_O=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102343732129147301661/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102343732129147301661/reviews');
SET @user_danka_sekulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102343732129147301661/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Scepanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJV9TAhWqvfcBm0kQYT_jikbqcV6lakKSXCSeJ__jonSK__bA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114020469554777585986/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114020469554777585986/reviews');
SET @user_danijela_scepanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114020469554777585986/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Gagovic', 'https://lh3.googleusercontent.com/a/ACg8ocK-OWmAdsWsM9bFP0MeM2CwYR-z1o4ZR3vny1TThuXWe7tMUdo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111825784264606049641/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111825784264606049641/reviews');
SET @user_jelena_gagovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111825784264606049641/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'maja bogetic', 'https://lh3.googleusercontent.com/a-/ALV-UjVf5NPD7FGKK4AuSlFLkRs4bRiGQ2bknhB0NR4Bznl1dVCu6cn6CA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117855878715400233868/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117855878715400233868/reviews');
SET @user_maja_bogetic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117855878715400233868/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Jovanović', 'https://lh3.googleusercontent.com/a-/ALV-UjVBob11-_WYrEyQdLo80mPhjfPqkeTwsAvT6FzPb5bs0FoXNPii=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111072192005310189863/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111072192005310189863/reviews');
SET @user_marija_jovanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111072192005310189863/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina P', 'https://lh3.googleusercontent.com/a/ACg8ocIafUVe1N-jO3N9EFBeKVbq9kS32uGGfZ06vzumbu0b4NUJFw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117755775417004434645/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117755775417004434645/reviews');
SET @user_marina_p = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117755775417004434645/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Spaic', 'https://lh3.googleusercontent.com/a/ACg8ocJR7mqb3xvAYnj9qlBA2viUtcix3YWqaP7fu0F0bGD8OK3Kug=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101442837568860200855/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101442837568860200855/reviews');
SET @user_maja_spaic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101442837568860200855/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Samir Mehovic', 'https://lh3.googleusercontent.com/a/ACg8ocKVEWtBknS-4OQebBjaXM3YGf14RCHGv0MNyBjn6-RgQTh39A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104510108854252371462/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104510108854252371462/reviews');
SET @user_samir_mehovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104510108854252371462/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sena Chupka', 'https://lh3.googleusercontent.com/a/ACg8ocL37qA7EhCraKvXwl6wPlfjFPLvhjFNlIN-uoah0ykggIKPBw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108690922163158805053/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108690922163158805053/reviews');
SET @user_sena_chupka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108690922163158805053/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocI_OUBIYTaCjztlcsKWSqs6dqT_PU3kmVkzx_-B4hc9Ne0qEw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112140236508677703365/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112140236508677703365/reviews');
SET @user_jovan_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112140236508677703365/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'M K', 'https://lh3.googleusercontent.com/a-/ALV-UjXJKzJ6npyS3nw5jNszz4xc8BH75wzjGyB1Nrpxi8Fpm1TihbtU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113957965659366966808/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113957965659366966808/reviews');
SET @user_m_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113957965659366966808/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Helen Shmelen', 'https://lh3.googleusercontent.com/a-/ALV-UjWEPzqueIbctPanSqpyBf4ya54nr8nhoX97918zrh_iGnIOMgrD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108892487192964398227/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108892487192964398227/reviews');
SET @user_helen_shmelen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108892487192964398227/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina KM', 'https://lh3.googleusercontent.com/a/ACg8ocJD2HVsLGBsmFCjDvLMXlloVmfjZ3kp3LR9tqUPPbW1VdwaMA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111765855560648468566/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111765855560648468566/reviews');
SET @user_mina_km = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111765855560648468566/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Parente', 'https://lh3.googleusercontent.com/a-/ALV-UjWLjqjj1u8IqMoaV5Jowz2PC1LSiI8D88zoSPv3uZzj5LE0Cdg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116673552709624982645/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116673552709624982645/reviews');
SET @user_marija_parente = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116673552709624982645/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Allan Cunha', 'https://lh3.googleusercontent.com/a-/ALV-UjVMO6SvcUMmEqwDFoDuYOdmOqXgzp0tTe8gZ1uSe9R4-Z-ITgO4=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101106759281895541159/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101106759281895541159/reviews');
SET @user_allan_cunha = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101106759281895541159/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubisa Marinkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKLECDLwpfHTDjMO2xSElxfKdyjQ0lUFuaQiI4lp3S0ef9hgHo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113911048354639631515/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113911048354639631515/reviews');
SET @user_ljubisa_marinkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113911048354639631515/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'igor tomic', 'https://lh3.googleusercontent.com/a/ACg8ocLqBefSZT-OOMMqTHs5RCcnot1yYuv3NHOtOJqwwzTv8PWEKg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102645878757753673648/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102645878757753673648/reviews');
SET @user_igor_tomic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102645878757753673648/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Đikanović', 'https://lh3.googleusercontent.com/a-/ALV-UjU9d_mAx5WCQDnNde8MZ_La8wdrwTLRijgEGehAg2vOkzOE-48=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113725881875962448103/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113725881875962448103/reviews');
SET @user_marina_ikanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113725881875962448103/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Go America', 'https://lh3.googleusercontent.com/a/ACg8ocLROAHa2IPn6zCp2-vjTheSVdHXOwLZM2g1DPU5ipRPBYf2VA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117787921240589818651/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117787921240589818651/reviews');
SET @user_go_america = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117787921240589818651/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivona Vujisić', 'https://lh3.googleusercontent.com/a/ACg8ocIABynERkyUGEkLqS_iQMCOr-et3DZw-YCiyTzfo6IkP7bnmjM=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106676202687201149355/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106676202687201149355/reviews');
SET @user_ivona_vujisi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106676202687201149355/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vuković Ksenija', 'https://lh3.googleusercontent.com/a-/ALV-UjWz5VCt61b70evACxRQ8Idtp4FAtV_N2m8A91e7h6axQtKci2fo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103691010344569093004/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103691010344569093004/reviews');
SET @user_vukovi_ksenija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103691010344569093004/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milesa Piper', 'https://lh3.googleusercontent.com/a/ACg8ocJhbpbQDJrqH2AmfDjMMaNtFUZs_vBHhhfu48gxs_8xqH-C=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115551982473689071745/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115551982473689071745/reviews');
SET @user_milesa_piper = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115551982473689071745/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorana Djokic', 'https://lh3.googleusercontent.com/a-/ALV-UjU5bbL2twk22Nsfb_bngMzieKJLUNzc9c-MMbfP-CuCFwuu6kdh=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108848463074509412028/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108848463074509412028/reviews');
SET @user_zorana_djokic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108848463074509412028/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Ljumovic', 'https://lh3.googleusercontent.com/a/ACg8ocJVEL0Zi66KX-hcA6oA3F4oQoJyLagXdxuNrj6Hj1xMC8Jk2A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113889802720551534226/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113889802720551534226/reviews');
SET @user_nikola_ljumovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113889802720551534226/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_luka_gajevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Gc01ISjBTUzFvYVdsMlJuTlBhV05XZUdoV1pXYxAB',
    5, 'bs', 'Profesionalni, ljubazni i veoma pažljivi. Sve pohvale za tim i uslugu. Preporučujem!',
    'Profesionalni, ljubazni i veoma pažljivi. Svaka čast timu i usluzi. Preporučujem!', 'Професионални, љубазни и веома пажљиви. Свака част тиму и услузи. Препоручујем!', NULL, NULL, NULL, NULL,
    0, '2026-03-08 21:38:23'),

(@user_dusica_janjevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21RMVoycG5la2R6UzE5a1pESktPR2syVmtSbFZtYxAB',
    5, 'bs', 'Atmosfera u ordinaciji je veoma prijatna.Izuzetno ljubazno osoblje uvijek spremno da pomogne i da pravu informaciju, vrhunski strucni doktori maksimalno posveceni svom radu.Pristup pacijentima je pun strpljenja i paznje. Sve je na najvecem mogucem nivou pocevsi od higijene, najsavremenije tehnologije, profesionalizma i do osjecaja tople ljudske strane tima.I sto je najvaznije prezadovoljna sam ishodom rada na mojim zubima.Iskrena preporuka svima 😊',
    'Atmosfera u ordinaciji je veoma prijatna.Izuzetno ljubazno osoblje uvijek spremno da pomogne i da pravu informaciju, vrhunski strucni doktori maksimalno posveceni svom radu.Pristup pacijentima je pun strpljenja i paznje. Sve je na najvecem mogucem nivou pocevsi od higijene, najsavremenije tehnologije, profesionalizma i do osjecaja tople ljudske strane tima.I sto je najvaznije prezadovoljna sam ishodom rada na mojim zubima.Iskrena preporuka svima 😊', NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-22 04:42:50'),

(@user_sanja_damjanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kRFNUSkxWRUZETWtKWFJXWk9WamRDTTIxZmFFRRAB',
    1, 'en', 'A similar situation happened to me as in the comments below, the appointment was not met. Without any explanation that something is happening, with the excuse of the sister that it will be \'quick\'. That quickly took at least 2 hours. Disappointing, considering the doctor is great. I think that in those situations it is necessary to offer patients a discount as compensation. All the best in your future work',
    'Desila mi se slična situacija kao u komentarima ispod, termin nije ispunjen. Bez ikakvog objašnjenja da se nešto dešava, uz izgovor sestre da će to biti \'brzo\'. To je brzo trajalo najmanje 2 sata. Razočaravajuće, s obzirom da je doktor odličan. Mislim da je u tim situacijama neophodno pacijentima ponuditi popust kao nadoknadu. Sve najbolje u daljem radu', 'Десила ми се слична ситуација као у коментарима испод, термин није испуњен. Без икаквог објашњења да се нешто дешава, уз изговор сестре да ће то бити \'брзо\'. То је брзо трајало најмање 2 сата. Разочаравајуће, с обзиром да је доктор одличан. Мислим да је у тим ситуацијама неопходно пацијентима понудити попуст као надокнаду. Све најбоље у даљем раду', 'A similar situation happened to me as in the comments below, the appointment was not met. Without any explanation that something is happening, with the excuse of the sister that it will be \'quick\'. That quickly took at least 2 hours. Disappointing, considering the doctor is great. I think that in those situations it is necessary to offer patients a discount as compensation. All the best in your future work', NULL, NULL, NULL,
    0, '2025-09-20 11:25:54'),

(@user_almira_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBbC1XeUFREAE',
    5, 'en', 'I went to this dr through recommendation and I was so happy I did that. He is a great doctor,so knowledgeable and yet so calm ...you get no feeling that you are at a dentist office. He did an amazing job... 3 root canals ,2 crowns and 4 fillings done in 2 weeks! I can’t recommend him enough. I also did laser whitening and was so happy with that. You will not regret,I have been to many of them and he is one of the best.',
    'Otišla sam kod ovog doktora po preporuci i bila sam presrećna što sam to uradila. On je odličan doktor, tako stručan, a opet tako smiren... nemate osećaj da ste u stomatološkoj ordinaciji. Uradio je neverovatan posao... 3 lečenja korenskih kanala, 2 krunice i 4 plombe urađene za 2 nedelje! Ne mogu ga dovoljno preporučiti. Takođe sam radila lasersko izbeljivanje zuba i bila sam presrećna. Nećete se pokajati, bila sam kod mnogih njih i on je jedan od najboljih.', 'Отишла сам код овог доктора по препоруци и била сам пресрећна што сам то урадила. Он је одличан доктор, тако стручан, а опет тако смирен... немате осећај да сте у стоматолошкој ординацији. Урадио је невероватан посао... 3 лечења коренских канала, 2 крунице и 4 пломбе урађене за 2 недеље! Не могу га довољно препоручити. Такође сам радила ласерско избељивање зуба и била сам пресрећна. Нећете се покајати, била сам код многих њих и он је један од најбољих.', 'I went to this dr through recommendation and I was so happy I did that. He is a great doctor,so knowledgeable and yet so calm ...you get no feeling that you are at a dentist office. He did an amazing job... 3 root canals ,2 crowns and 4 fillings done in 2 weeks! I can’t recommend him enough. I also did laser whitening and was so happy with that. You will not regret,I have been to many of them and he is one of the best.', NULL, NULL, NULL,
    3, '2021-08-23 12:57:40'),

(@user_jole, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCQmJrZHNUV053UVVGWlNWWlRiRFZXY1dKcVZVRRAB',
    1, 'bs', 'Procitah jedan komentar ranije - oko nepoštovanja termina, slicno iskustvo sam imao. Samo sam ja tek sledeci dan dobio poziv za novi termin. Osoba koja je ukočila pred moj termin nije djelovala uopste kao neko u bolovima...',
    'Ranije sam pročitao komentar - o neodržavanju termina, imao sam slično iskustvo. Samo što sam dobio poziv za novi termin tek sutradan. Osoba koja se ukočila pre mog zakazivanja uopšte nije delovala kao neko u bolu...', 'Раније сам прочитао коментар - о неодржавању термина, имао сам слично искуство. Само што сам добио позив за нови термин тек сутрадан. Особа која се укочила пре мог заказивања уопште није деловала као неко у болу...', NULL, NULL, NULL, NULL,
    1, '2025-09-03 15:14:02'),

(@user_alexandr_simanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xRM1RqVk9hazFCWVZsUlYxQmxUVlZXVjBzelJGRRAB',
    1, 'ru', 'Всё очень плохо цены космические, персонал грубый и не вежливый.',
    NULL, NULL, NULL, 'Всё очень плохо цены космические, персонал грубый и не вежливый.', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_davorin_milacic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twM05uTlJORFpqTWtGbWFITk9WR2xIWnkwd1NVRRAB',
    5, 'hr', 'S velikim postovanjem mogu da kazem da u svom zivotu koliko smo posjecivali zubare sa nasom drugom  djecom  nismo naisli na takvu osobu kao sto je Dr. Selma   djecak od 3 godine sa kojim je bilo misaona imenica poci kod zubara ona je uspjela da ga oslobodi da on sam trazi da ide kod zubara i da sam sjedi na stolici dok mu ona popravlja zubice. Tolika smirenost toliko strpljenje toliko ljubaznosti toliku poscecenost djetetu da bi mu popravila zubice je zaista tesko naci u danasnje  vrijeme. Zaista sve pohvale i sve moguce preporuke i svu srecu u daljem radu i napredovanju zelimo od sveg srca.',
    'S velikim postovanjem mogu da kazem da u svom zivotu koliko smo posjecivali zubare sa nasom drugom  djecom  nismo naisli na takvu osobu kao sto je Dr. Selma   djecak od 3 godine sa kojim je bilo misaona imenica poci kod zubara ona je uspjela da ga oslobodi da on sam trazi da ide kod zubara i da sam sjedi na stolici dok mu ona popravlja zubice. Tolika smirenost toliko strpljenje toliko ljubaznosti toliku poscecenost djetetu da bi mu popravila zubice je zaista tesko naci u danasnje  vrijeme. Zaista sve pohvale i sve moguce preporuke i svu srecu u daljem radu i napredovanju zelimo od sveg srca.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_optimus_solutions, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWM1RGTXhUR2xpVVhWallURTBPR1Y1YTJwZk9HYxAB',
    5, 'hr', 'Najbolji!',
    'Najbolji!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_sekule_raicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkbWRHcHNMVzh6Y2xKR1RWQnhla0ZtVTFKRU9IYxAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_marijana_prelevi, @clinic_id, @doctor_aleksandar_lopicic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xZMGVrcFpSemh3Y2tzM09XMWtOMmhCVldsRlVFRRAB',
    1, 'bs', 'Jako loṣ̌a energija u ordinaciji uz nepoṣ̌tovanje zakazanog termina pacijenta. Koliko god da se kasni, "hvala ṣ̌to ste čekali" predstavlja osnovno poṣ̌tovanje pacijenta. Pritom, doktor Aleksandar nadobudan, na stranu to ṣ̌to je dao miṣ̌ljenje da se brusi 18 zdravih zuba i da se stave viniri kao jedini način podizanja nivoa estetike. Konsultacije trajale možda desetak minuta i naplaćeno 30€. Ne preporučujem.',
    'Jako loṣ̌a energija u ordinaciji uz nepoṣ̌tovanje zakazanog termina pacijenta. Koliko god da se kasni, "hvala ṣ̌to ste čekali" predstavlja osnovno poṣ̌tovanje pacijenta. Pritom, doktor Aleksandar nadobudan, na stranu to ṣ̌to je dao miṣ̌ljenje da se brusi 18 zdravih zuba i da se stave viniri kao jedini način podizanja nivoa estetike. Konsultacije trajale možda desetak minuta i naplaćeno 30€. Ne preporučujem.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_dr_radunovi, @clinic_id, @doctor_amra_amidovic_hamzic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4UVlXVllVMFJuTmxsek1GSldhVWRhVlVveWRFRRAB',
    5, 'bs', 'Dr Amra odlična sa djecom.',
    'Dr Amra odlična sa djecom.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_muamer_dizdarevi, @clinic_id, @doctor_andjela_djurisic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KNmVFdExiV1V0U0ZZeE0xSjZOVmd0UWxOdWFFRRAB',
    5, 'hr', 'Odlična usluga i vrlo ljubazno osoblje. Sve je odrađeno profesionalno, bezbolno i uz ugodnu atmosferu. Sve pohvale za doktoricu Anđelu. Topla preporuka svima koji traže kvalitetnog zubara 👏',
    'Odlična usluga i vrlo ljubazno osoblje. Sve je odrađeno profesionalno, bezbolno i uz ugodnu atmosferu. Sve pohvale za doktoricu Anđelu. Topla preporuka svima koji traže kvalitetnog zubara 👏', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_sanja_ljucovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWamFXUXhZVWRpYzBWME16RmxaRFF5YmxaUWRVRRAB',
    5, 'hr', 'Najbolji naš stomatolog',
    'Najbolji naš stomatolog', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_naa_aanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oNE5XbHhkM2xqU1RoSFFXY3dSbVZhY0hKQ04xRRAB',
    5, 'hr', 'Najbolja ordinacija! 🩵🤗',
    'Najbolja ordinacija! 🩵🤗', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_jovana_jelic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCcWR6QkRRbmd0ZDA1VGVWRmpZbDkyYjBwVFVtYxAB',
    5, 'hr', 'Ljubaznost, stručnost i profesionalnost na najvećem mogućem nivou, kako od strane doktora, tako i od ostalog osoblja.',
    'Ljubaznost, stručnost i profesionalnost na najvećem mogućem nivou, kako od strane doktora, tako i od ostalog osoblja.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_jovana_martinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoMmMzWTVlalV0WVdwQlpGWnFkRXBKY0VWRWJtYxAB',
    5, 'hr', 'Doktori profesionalni i veoma stručni. Tehničari preljubazni, sve pohvale za cijeli tim! ❤️',
    'Doktori profesionalni i veoma stručni. Tehničari preljubazni, sve pohvale za cijeli tim! ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_nikola_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKd1QyUmtRV2xsWkVwRGEwMUdXR05rZVU1Q2RrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_milica, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWMGFETnRORTUwU1hsR2FGRk9UR0paWkRoYWQyYxAB',
    5, 'bs', 'Ovo je ubjedljivo najbolja ordinacija koju čovjek može da posjeti ako želi da priušti sebi najbolje za sebe-svoje zdravlje, zato vas rado preporučujem svima ko god me pita za "znaš li nekog dobrog zubara-I dje si ti radila te tvoje zube"
Znam da sam na pravo mjesto svaki put kad podjem kod vas i da nemam šta da brinem niti da mislim..od manje do veće intervencije.
Imala sam režanj operaciju cijele vilice, a ja ne znam da li je bolje prošla operacija ili oporavak ili sami ishod
zahvaljujući najboljem dr. Aleksandru..
prezadovoljna sam sa njim,sa svima,
njihovim radom..njihovim timom..trudom..korektnošću i tačnošću.
Samo riječi hvale za Najbolju ekipu.

Vi niste za 5⭐⭐⭐⭐⭐,
VI STE ZA 555⭐ ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐',
    'Ovo je ubjedljivo najbolja ordinacija koju čovjek može da posjeti ako želi da priušti sebi najbolje za sebe-svoje zdravlje, zato vas rado preporučujem svima ko god me pita za "znaš li nekog dobrog zubara-I dje si ti radila te tvoje zube"
Znam da sam na pravo mjesto svaki put kad podjem kod vas i da nemam šta da brinem niti da mislim..od manje do veće intervencije.
Imala sam režanj operaciju cijele vilice, a ja ne znam da li je bolje prošla operacija ili oporavak ili sami ishod
zahvaljujući najboljem dr. Aleksandru..
prezadovoljna sam sa njim,sa svima,
njihovim radom..njihovim timom..trudom..korektnošću i tačnošću.
Samo riječi hvale za Najbolju ekipu.

Vi niste za 5⭐⭐⭐⭐⭐,
VI STE ZA 555⭐ ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐', NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_bbiser, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kaE5qRlpXbEpaYjNSblNVNXpUR05RWmtSRU4zYxAB',
    5, 'hr', 'Sve pohvale!!!!',
    'Sve pohvale!!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_vila_stoliv, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT201dFZVMWlNVGhtY0ZCNWJ6SkxjRkI0TTJOU1NtYxAB',
    1, 'bs', 'Molim ih vec 2 ili 3 put da mi posalju snimak na mail.Niko nista ne salje.',
    'Molim ih vec 2 ili 3 put da mi posalju snimak na mail.Niko nista ne salje.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_sandra_mijovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w4MFpsOWhTa3RFTWtSa1RtNTVURWRQWTJOVGJGRRAB',
    5, 'bs', 'Imam odlično iskustvo sa ovom ordinacijom, veoma su ljubazni i sve sto sam radila je urađeno po najboljim standardima. I dalje cemo se druziti.',
    'Imam odlično iskustvo sa ovom ordinacijom, veoma su ljubazni i sve sto sam radila je urađeno po najboljim standardima. I dalje cemo se druziti.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_luka_savovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkcE5WaHZUelkwWjNab05rMWtSSHBWTFhORlZWRRAB',
    5, 'hr', 'Sve preporuke za ordinaciju,osoblje ljubazno i profesionalno!',
    'Sve preporuke za ordinaciju,osoblje ljubazno i profesionalno!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragana_kostic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SYVdqaDFZVXhDYzFaa09GRnlkMmM0VERSTVdIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milorad_prascevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5MmMyUnpNREI0ZUdJdFMzTnpiM0l4VEZSamExRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_amar_sabotic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psalZuaEhiVTg0Y21sVWVuWkZUV0ZJTUdseFRXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marijana_radivojevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xZd2JuZHRNMlZvTjBjeGJtNXZVVVpsTTJnMFNFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_selma_banda, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2todlUxcEdibEJ5VldaSk5uTjJTMEZqV0hFeVJuYxAB',
    5, 'hr', 'Topla preporuka svima koji traze kvalitetnog stomatologa uz profesionalan pristup!',
    'Topla preporuka svima koji traze kvalitetnog stomatologa uz profesionalan pristup!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_legendary_plays, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1UVJHUm1aVVJyZUdWT09UUm1PV3MyVmtaaFJuYxAB',
    5, 'hr', 'Sve preporuke!',
    'Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vojislav_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWZmFubzRRVWR3UkRSdFoyNUhSVGg2VG5JME1GRRAB',
    5, 'hr', 'Vrlo profesionalni i ljubazni ljudi. Svi od reda.  Brzi i bezbolni tretmani. Topla preporuka!',
    'Vrlo profesionalni i ljubazni ljudi. Svi od reda.  Brzi i bezbolni tretmani. Topla preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_bujisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxS05tSTVNMWM1YW1GNmRWVlZSM2gxZVRaNk1HYxAB',
    5, 'hr', 'Ovo je jedina stomatoloska ordinacija gdje me nikad nije strah posjete. Jako prijatni, profesionalni i strpljivi! 🫶🏻',
    'Ovo je jedina stomatoloska ordinacija gdje me nikad nije strah posjete. Jako prijatni, profesionalni i strpljivi! 🫶🏻', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marina_pejovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSS2EzcGFkMEZrYXpob2VFSktPSE5UTFZKNmMxRRAB',
    5, 'bs', 'Veoma profesionalan pristup i prijatna atmosfera u ordinaciji. Posebno cijenim što se vodi računa o higijeni i komforu pacijenata. Na svaki pregled dolazim bez stresa i s povjerenjem. Zahvalna na svemu što su uradili za mene.❤️',
    'Veoma profesionalan pristup i prijatna atmosfera u ordinaciji. Posebno cijenim što se vodi računa o higijeni i komforu pacijenata. Na svaki pregled dolazim bez stresa i s povjerenjem. Zahvalna na svemu što su uradili za mene.❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mladen_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kwd2NIUktiRVpvWVcxd1QyUjZUMWh5Y25RdFpXYxAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_most_want, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tONlZWUjRRMk5YVmpZNVNVSTJXRE5zV1hOclNIYxAB',
    1, 'hr', 'Previsok rejting za prosjecnu uslugu',
    'Previsok rejting za prosjecnu uslugu', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_rasovo_resnik, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twSlNYaG1jbWMxTkRCWU5YY3hlRWRoYkZOZmNXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_emir_hamidovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wS1VGTnRNalpwVFZRNU9UazRZazk2YWxkZmEzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_bane, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaSWR5MUthM1F5UVRCWFJXVmxSRloxVDBSRVVVRRAB',
    1, 'bs', 'Zakazala sam kod zubara dva mjeseca ranije, u trenutku kada sam zakazana pojavila se ispred mene druga osoba - uz izgovor da ce biti brzo gotova. Posle sat vremena cekanja, dobila sam izvinjenje od sestre - zatim sam otisla, a posle 2:30h sam dobila poziv sa predlogom da sjutra zakažemo termin..
Neprofesionalno, promijenila sam zubara. Sve najbolje u radu',
    'Zakazala sam kod zubara dva mjeseca ranije, u trenutku kada sam zakazana pojavila se ispred mene druga osoba - uz izgovor da ce biti brzo gotova. Posle sat vremena cekanja, dobila sam izvinjenje od sestre - zatim sam otisla, a posle 2:30h sam dobila poziv sa predlogom da sjutra zakažemo termin..
Neprofesionalno, promijenila sam zubara. Sve najbolje u radu', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mirela_spahic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VOWEJtY0tKcmNuWk13EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_slavica_vukicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnTURRM2N2eXd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ikanovi_matija, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBOXJfY3RnRRAB',
    5, 'hr', 'Najbolji svih vremena !',
    'Najbolji svih vremena !', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovan_rackovic, @clinic_id, @doctor_andjela_djurisic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBOXUza2J3EAE',
    5, 'bs', 'Izuzetan  tim, na celu sa doktorom Aleksandrom prije svega veliki covjek pa i strucnjak!
Doktorica Andjela ljubazna i prijatna i posvecena  djeci , moje dijete je odusevljeno.
Lubazno osoblje, pogotovo Kaca prijatna
posvecena poslu i  ljubazna.
Sve preporuke, puno srece i uspjeha u daljem radu💪💪👋👋',
    'Izuzetan  tim, na celu sa doktorom Aleksandrom prije svega veliki covjek pa i strucnjak!
Doktorica Andjela ljubazna i prijatna i posvecena  djeci , moje dijete je odusevljeno.
Lubazno osoblje, pogotovo Kaca prijatna
posvecena poslu i  ljubazna.
Sve preporuke, puno srece i uspjeha u daljem radu💪💪👋👋', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milena_gazivoda, @clinic_id, @doctor_aleksandar_lopicic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNBOXNhblF3EAE',
    5, 'hr', 'Kod vas dolazim bezbrizno, jer znam da sam u sigurnim rukama.
Uvijek topla preporuka je ordinacija " Lopicic" za profesionalan tim sa visokim vjestinama, a i izlaskom iz iste sa najljepsim osmjesima.',
    'Kod vas dolazim bezbrizno, jer znam da sam u sigurnim rukama.
Uvijek topla preporuka je ordinacija " Lopicic" za profesionalan tim sa visokim vjestinama, a i izlaskom iz iste sa najljepsim osmjesima.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_mugoa, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBOXB6dm9nRRAB',
    5, 'hr', 'Ljubazni, prijatni, profesionalni! Odlazak kod zubara bez straha! 🙂',
    'Ljubazni, prijatni, profesionalni! Odlazak kod zubara bez straha! 🙂', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ljubica_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBOXVURF93RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marina_ljumovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIeDVPWkRREAE',
    5, 'en', 'The best dental clinic I\'ve ever been to! Professional and friendly staff, high-quality service. I was satisfied with all the things I did there. I would highly recommend it to everyone!',
    NULL, NULL, 'The best dental clinic I\'ve ever been to! Professional and friendly staff, high-quality service. I was satisfied with all the things I did there. I would highly recommend it to everyone!', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_darija_tomovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIaDRMWFJBEAE',
    5, 'bs', 'Najbolja stomatološka ordinacija u Podgorici. Cjelokupno osoblje je jako ljubazno i prijatno. Doktori strucni i posveceni svakom pacijentu. Odlican odnos cijene i kvaliteta. Sve preporuke!',
    'Najbolja stomatološka ordinacija u Podgorici. Cjelokupno osoblje je jako ljubazno i prijatno. Doktori strucni i posveceni svakom pacijentu. Odlican odnos cijene i kvaliteta. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nikola_laketic, @clinic_id, @doctor_andjela_djurisic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIdTVXb0VBEAE',
    5, 'hr', 'Doktorica Anđela je za svaku preporuku!!!',
    'Doktorica Anđela je za svaku preporuku!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nikola_vulas, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNIdTVtbTZ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_milos_vidic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNIdS1Idjl3RRAB',
    5, 'hr', 'Izuzetan tim na čelu sa doktorom Aleksandrom,jako ljubazno osoblje. Sve preporuke.',
    'Izuzetan tim na čelu sa doktorom Aleksandrom,jako ljubazno osoblje. Sve preporuke.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vesna_westmeier, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSURicFpQV1ZBEAE',
    5, 'de', 'Beste Praxis in Montenegro ❤️❤️❤️',
    NULL, NULL, NULL, NULL, 'Beste Praxis in Montenegro ❤️❤️❤️', NULL,
    0, '2024-10-29 00:00:00'),

(@user_danka_sekulic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSURMXzZiYXdnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_danijela_scepanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5bFBPM2lnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jelena_gagovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSURWellDMGR3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_maja_bogetic, @clinic_id, @doctor_aleksandar_lopicic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNWeFBxT2pnRRAB',
    5, 'bs', 'Toliko strucnosti, pedantnosti i posvecenosti svom poslu, odavno nisam vidjela. Odusevljena sam vasim radom i krajnjim rezultatom. Najiskrenija preporuka za dr Lopicica i njegov tim.',
    'Toliko strucnosti, pedantnosti i posvecenosti svom poslu, odavno nisam vidjela. Odusevljena sam vasim radom i krajnjim rezultatom. Najiskrenija preporuka za dr Lopicica i njegov tim.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marija_jovanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSURGdV9MMjJ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marina_p, @clinic_id, @doctor_aleksandar_lopicic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKX2IyR0dnEAE',
    5, 'en', 'I’m more than satisfied with dr Lopicic and his team. He saved my tooth for which I was sure was lost. He was always ready to help and work long hours as the procedure required several visits. Another time I went there for tooth extraction. It was just before the state holiday when other doctors didn’t dare to take such a responsibility. He did it so remarkably well that the day after I didn’t have any pain, and I have to add that procedure was quite complicated. However, he did it with ease. Not only professional, but always friendly and in bright mood.',
    NULL, NULL, 'I’m more than satisfied with dr Lopicic and his team. He saved my tooth for which I was sure was lost. He was always ready to help and work long hours as the procedure required several visits. Another time I went there for tooth extraction. It was just before the state holiday when other doctors didn’t dare to take such a responsibility. He did it so remarkably well that the day after I didn’t have any pain, and I have to add that procedure was quite complicated. However, he did it with ease. Not only professional, but always friendly and in bright mood.', NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_maja_spaic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4dnFUb0dREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_samir_mehovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4aHQzZWRBEAE',
    5, 'bs', 'Savršen kolektiv, veoma prijatan i stručan.',
    'Savršen kolektiv, veoma prijatan i stručan.', NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_sena_chupka, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4aHRxU0ZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_jovan_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4NnZHZjBnRRAB',
    5, 'en', 'Superb dental services! The team here exudes warmth and professionalism, making every visit comfortable. They always do an excellent job and I recommend them to anyone looking for a reliable dentist.',
    NULL, NULL, 'Superb dental services! The team here exudes warmth and professionalism, making every visit comfortable. They always do an excellent job and I recommend them to anyone looking for a reliable dentist.', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_m_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4bEpXbVJBEAE',
    1, 'en', 'staff is not qualified.  appointment  time not respected',
    NULL, NULL, 'staff is not qualified.  appointment  time not respected', NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_helen_shmelen, @clinic_id, @doctor_amra_amidovic_hamzic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSURoZ2EtX3ZnRRAB',
    5, 'en', 'I had teeth polishing and cavities treatment here. Thanks to Dr Amra A., all went well!',
    NULL, NULL, 'I had teeth polishing and cavities treatment here. Thanks to Dr Amra A., all went well!', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_mina_km, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUMtbk9PeGV3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_marija_parente, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSURPdFBmaUpBEAE',
    5, 'en', 'I had an amazing experience today when I brought my younger son for a visit.  The doctors and the staff were friendly, professional and, most importantly, very patient with my son who was very scared when he first arrived.

I highly recommend them to everyone and will definitely always go here if/when we need dental services while back in Montenegro.
Thank you!

Predivno iskustvo danas sa mladjim sinom koji je bio vrlo uplasen.  Preporucujem!',
    NULL, NULL, 'I had an amazing experience today when I brought my younger son for a visit.  The doctors and the staff were friendly, professional and, most importantly, very patient with my son who was very scared when he first arrived.

I highly recommend them to everyone and will definitely always go here if/when we need dental services while back in Montenegro.
Thank you!

Predivno iskustvo danas sa mladjim sinom koji je bio vrlo uplasen.  Preporucujem!', NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_allan_cunha, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUQydG9hcU1REAE',
    5, 'en', 'Exceptional professional. He saved my honeymoon and did an espetacular job, doing the new restauration much away better than the one has gone. Unfortunately I don’t live in Podgorica to do all my dental needs with him.',
    NULL, NULL, 'Exceptional professional. He saved my honeymoon and did an espetacular job, doing the new restauration much away better than the one has gone. Unfortunately I don’t live in Podgorica to do all my dental needs with him.', NULL, NULL, NULL,
    5, '2022-10-29 00:00:00'),

(@user_ljubisa_marinkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSURHaGQyY25BRRAB',
    5, 'bs', 'Uradio sam na svim zubima: metalo keramicke i bezmetalne krunice. Kvalitetno i strucno odradjeno,  bolje ne moze. Svi koji su mi videli zube, odusevili su se. Dobio sam holivudski osmeh. Ovim putem im se zahvaljujem.. Sve preporuke!',
    'Uradio sam na svim zubima: metalo keramicke i bezmetalne krunice. Kvalitetno i strucno odradjeno,  bolje ne moze. Svi koji su mi videli zube, odusevili su se. Dobio sam holivudski osmeh. Ovim putem im se zahvaljujem.. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_igor_tomic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2dnNIaWJBEAE',
    5, 'en', 'Changed 5 doctors before I got to him, he saved me, did excelent job in one day. I was amazed. Higly recomend to others. Best doctor, best service',
    NULL, NULL, 'Changed 5 doctors before I got to him, he saved me, did excelent job in one day. I was amazed. Higly recomend to others. Best doctor, best service', NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_marina_ikanovi, @clinic_id, @doctor_aleksandar_lopicic, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSURheW9Ia0ZnEAE',
    5, 'bs', 'Stručno osoblje,kvalitetan materijal i odličan pristup pacijentu.Dr Aleksandar Lopičic odličan stomatolog.Sve preporuke',
    'Stručno osoblje,kvalitetan materijal i odličan pristup pacijentu.Dr Aleksandar Lopičic odličan stomatolog.Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_go_america, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSURTdW9tNndRRRAB',
    5, 'en', 'Did a great job, so glad I visited! Nice office and staff, western standards, came highly recommended.',
    NULL, NULL, 'Did a great job, so glad I visited! Nice office and staff, western standards, came highly recommended.', NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_ivona_vujisi, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjZzUzb1VnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_vukovi_ksenija, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUQwd0tPYkhBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_milesa_piper, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSURvOS0tRmFREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_zorana_djokic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChdDSUhNMG9nS0VJQ0FnSURROGVhUjdRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_nikola_ljumovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBOWItME1nEAE',
    5, 'hr', 'to je bog kako radi!',
    'to je bog kako radi!', NULL, NULL, NULL, NULL, NULL,
    2, '2018-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xRM1RqVk9hazFCWVZsUlYxQmxUVlZXVjBzelJGRRAB'),
  'clinic', @clinic_id,
  'Žao nam je što ste imali negativno iskustvo. Meðutim, sadržaj ove recenzije ne odgovara nasim evidencijama niti iskustvima koja imamo sa nasim pacijentima. Takoðe, primijetili smo obrazac vrlo sličnih negativnoh recenzija objavljenih istovremeno o više ordinacija, zbog čega smo ovu recenziju prijavili Google-u radi provjere autentičnosti. 
Poštujemo pravo svakog pacijenta da iznese svoje mišljenje, ali smatramo da recenzije treba da odražavaju stvarno iskustvo pacijenta. Naš tim ostaje posvećen profesionalnom radu, kvalitetu usluge i povjerenju naših pacijenata
Ordinacija Lopičić', 'bs',
  'Žao nam je što ste imali negativno iskustvo. Meðutim, sadržaj ove recenzije ne odgovara nasim evidencijama niti iskustvima koja imamo sa nasim pacijentima. Takoðe, primijetili smo obrazac vrlo sličnih negativnoh recenzija objavljenih istovremeno o više ordinacija, zbog čega smo ovu recenziju prijavili Google-u radi provjere autentičnosti. 
Poštujemo pravo svakog pacijenta da iznese svoje mišljenje, ali smatramo da recenzije treba da odražavaju stvarno iskustvo pacijenta. Naš tim ostaje posvećen profesionalnom radu, kvalitetu usluge i povjerenju naših pacijenata
Ordinacija Lopičić', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xZMGVrcFpSemh3Y2tzM09XMWtOMmhCVldsRlVFRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam na povratnoj informaciji, žao nam je što ste konsultaciju doživjeli na način koji opisujete, ali smatramo da je važno pojasniti nekoliko činjenica.
Prije svega, eventualno čekanje bilo je u pristojnim okvirima, a ne u mjeri da se stekne utisak da se Vaš termin nije poštovao.
Što se tiče preporuke za vinire, ona nije data olako ni kao ,,jedini način”, niti je izrečena sa namjerom da Vas bilo šta obavezuje. Tokom konsultacije uzeli smo u obzir vaše dugogodišnje negativno iskustvo sa ortodontskom terapijom i nošenjem proteza, kao i Vašu želju za poboljšanjem estetike osmijeha. Na osnovu analize i dugogodišnjeg iskustva u protetici i estetskoj stomatologiji iznijeli smo svoje stručno mišljenje o mogućem pristupu i razgovarali o tome sta bi, po našem mišljenju, moglo dati željeni estetski rezultat.

Konsultacija je bila upravo to- konsultacija i stručno mišljenje. Ni u jednom trenutku niste bili u obavezi da prihvatite nas predlog, niti ocekujemo da pacijent prihvati  svaku našu preporuku.

Takoðe, smatramo da vrijeme trajanja konsultacije ne odreðuje kvalitet strucnog misljenja. Za konsultaciju je naplacena standardna cijena koja je bila unaprijed definisana.
Żao nam je što ste stekli utisak  o ,,losoj” energiji i sto nase namjere niste  dozivjeli onako kako su bile zamišljene. Naš cilj je bio da na osnovu Vaših želja i i prethodnog iskustva ponudimo iskren i profesionalan savjet, a konačna odluka je uvijek na pacijentu.
Poštujemo Vaše pravo na drugačije mišljenje, ali stojimo iza profesionalnosti i preporuke koju smo Vam tom prilikom dali.
Pozdrav, Ordinacija Lopičić', 'bs',
  'Hvala Vam na povratnoj informaciji, žao nam je što ste konsultaciju doživjeli na način koji opisujete, ali smatramo da je važno pojasniti nekoliko činjenica.
Prije svega, eventualno čekanje bilo je u pristojnim okvirima, a ne u mjeri da se stekne utisak da se Vaš termin nije poštovao.
Što se tiče preporuke za vinire, ona nije data olako ni kao ,,jedini način”, niti je izrečena sa namjerom da Vas bilo šta obavezuje. Tokom konsultacije uzeli smo u obzir vaše dugogodišnje negativno iskustvo sa ortodontskom terapijom i nošenjem proteza, kao i Vašu želju za poboljšanjem estetike osmijeha. Na osnovu analize i dugogodišnjeg iskustva u protetici i estetskoj stomatologiji iznijeli smo svoje stručno mišljenje o mogućem pristupu i razgovarali o tome sta bi, po našem mišljenju, moglo dati željeni estetski rezultat.

Konsultacija je bila upravo to- konsultacija i stručno mišljenje. Ni u jednom trenutku niste bili u obavezi da prihvatite nas predlog, niti ocekujemo da pacijent prihvati  svaku našu preporuku.

Takoðe, smatramo da vrijeme trajanja konsultacije ne odreðuje kvalitet strucnog misljenja. Za konsultaciju je naplacena standardna cijena koja je bila unaprijed definisana.
Żao nam je što ste stekli utisak  o ,,losoj” energiji i sto nase namjere niste  dozivjeli onako kako su bile zamišljene. Naš cilj je bio da na osnovu Vaših želja i i prethodnog iskustva ponudimo iskren i profesionalan savjet, a konačna odluka je uvijek na pacijentu.
Poštujemo Vaše pravo na drugačije mišljenje, ali stojimo iza profesionalnosti i preporuke koju smo Vam tom prilikom dali.
Pozdrav, Ordinacija Lopičić', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT201dFZVMWlNVGhtY0ZCNWJ6SkxjRkI0TTJOU1NtYxAB'),
  'clinic', @clinic_id,
  'Poštovana, snimak Vam je uredno dva puta poslat na mail ordinacije koji ste trazili, provjerili smo', 'hr',
  'Poštovana, snimak Vam je uredno dva puta poslat na mail ordinacije koji ste trazili, provjerili smo', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-11-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJT3m0yTHrTRMRTG-Eba4IBHo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaSWR5MUthM1F5UVRCWFJXVmxSRloxVDBSRVVVRRAB'),
  'clinic', @clinic_id,
  'Žao nam je što ste imali neprijatno iskustvo u našoj ordinaciji. Iako ponekad dolazi do nepredviðenih situacija koje mogu poremetiti zakazani raspored, razumijemo da Vaše vrijeme zaslužuje poštovanje i iskreno se izvinjavamo zbog čekanja i neprijatnosti koje ste doživjeli. Moguće da je došlo do nesporazuma, jer nikog preko reda ne primamo, a naročito ne u nečiji već zakazani termin. Morate razumjeti da neka akutna stanja i situacije kao što je bol uvijek imaju prioritet. Trudimo se da svima pružimo najbolju moguću uslugu i iz ovog iskustva ćemo svakako izvući pouke kako bismo unaprijedili organizaciju termina. Želimo Vam sve najbolje i zahvaljujemo što ste podijelili mišljenje.', 'bs',
  'Žao nam je što ste imali neprijatno iskustvo u našoj ordinaciji. Iako ponekad dolazi do nepredviðenih situacija koje mogu poremetiti zakazani raspored, razumijemo da Vaše vrijeme zaslužuje poštovanje i iskreno se izvinjavamo zbog čekanja i neprijatnosti koje ste doživjeli. Moguće da je došlo do nesporazuma, jer nikog preko reda ne primamo, a naročito ne u nečiji već zakazani termin. Morate razumjeti da neka akutna stanja i situacije kao što je bol uvijek imaju prioritet. Trudimo se da svima pružimo najbolju moguću uslugu i iz ovog iskustva ćemo svakako izvući pouke kako bismo unaprijedili organizaciju termina. Želimo Vam sve najbolje i zahvaljujemo što ste podijelili mišljenje.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
