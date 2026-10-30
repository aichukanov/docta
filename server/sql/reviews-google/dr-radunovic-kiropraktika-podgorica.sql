-- Insert Google Maps reviews for Dr Radunovic - Chiropractic & Physical Therapy
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dr-radunovic-kiropraktika-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dr-radunovic-kiropraktika-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_savo_radunovic = (SELECT id FROM doctors WHERE slug = 'savo-radunovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Planinic', 'https://lh3.googleusercontent.com/a/ACg8ocJKz3u-2sv9wLycrtTxi8Jhdwpvt6u0K5jLzJ7B1bqvfBe1Gg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111983048550837847340/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111983048550837847340/reviews');
SET @user_milena_planinic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111983048550837847340/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nenad Pavlicic', 'https://lh3.googleusercontent.com/a-/ALV-UjUwWJCh0HgBjkk1jvD9RaNM2IvBBZ18yGq0VSz2nptYQX7paqPg=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/118339913768097288819/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118339913768097288819/reviews');
SET @user_nenad_pavlicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118339913768097288819/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dianna Carlen', 'https://lh3.googleusercontent.com/a/ACg8ocLJj7tSrwXw2mCiHMjjuCvGhzOVqU50sYb6VQl6BYW5wCOUxw=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/113784342769760074267/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113784342769760074267/reviews');
SET @user_dianna_carlen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113784342769760074267/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hülya Bilgeç', 'https://lh3.googleusercontent.com/a-/ALV-UjXOS8tSH7kd3p_bPFntI1-72hZLTtmSKZ8_8gsUhM9bj47IgTcJ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101060211632221335669/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101060211632221335669/reviews');
SET @user_hlya_bilge = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101060211632221335669/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Balsa Radunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWx_zHTKnFJFnFgIvBsQPr_t4Zft72OcobNu-GEX4NgCW4R8uA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/112060999872158269957/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112060999872158269957/reviews');
SET @user_balsa_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112060999872158269957/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Djuretic', 'https://lh3.googleusercontent.com/a/ACg8ocLBJWhjqISFB47rEJX_oLfb1lkSi8avkH2FvfBhvjx6JVUyrg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116979098500350138380/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116979098500350138380/reviews');
SET @user_milan_djuretic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116979098500350138380/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Clark Orro', 'https://lh3.googleusercontent.com/a-/ALV-UjWN_dcUrFzX6_Fu__xrs55rvRvkxV99MngzFIsmS8UJ5h-gNqx3=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101942057080417773576/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101942057080417773576/reviews');
SET @user_clark_orro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101942057080417773576/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Lukic', 'https://lh3.googleusercontent.com/a/ACg8ocJZJbZlW13iZDf-Usq3CrDMezxY03tdLF8k8cI0IBjh571ByDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108823877114669777600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108823877114669777600/reviews');
SET @user_jelena_lukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108823877114669777600/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goran Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLTjFPhvd4Kotggspf1ROp5lwVK9nv3XOYYxnHjn0iovAbcPg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105220804134782755940/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105220804134782755940/reviews');
SET @user_goran_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105220804134782755940/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rajko Uskokovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVV7bFCdbCZygzVLUQpuBh5F39KY9sWfiFfNHRi5Nbg2UrGxYU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106651285264414278911/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106651285264414278911/reviews');
SET @user_rajko_uskokovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106651285264414278911/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Rabrenovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVnMuKIjFV33TCDygfxm_CjsSf3xKZK5ts63G8yxNmQGI6E6biF=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107767213174208359113/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107767213174208359113/reviews');
SET @user_jovan_rabrenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107767213174208359113/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovo Rabrenovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUTpBH2r-o3tT6HDZsZI6Mk6Hmo96JrQzjLOmTOHjFEFAcsRsI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109796383808822760636/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109796383808822760636/reviews');
SET @user_jovo_rabrenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109796383808822760636/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Institut ekonomskih nauka Crne Gore', 'https://lh3.googleusercontent.com/a-/ALV-UjUdZdyXZCzJGNrkwldDtJgxxM1GY1erOF7V70tiVX7N7uoOu-4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116771800552345840295/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116771800552345840295/reviews');
SET @user_institut_ekonomskih_nauka_crne_gore = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116771800552345840295/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Savo Vrbica', 'https://lh3.googleusercontent.com/a-/ALV-UjVnu93G8DJovOdPUcTdxeBCwDT2bzg-EEm2i6vZsdyEbw_Hpsbp=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103869690282378764212/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103869690282378764212/reviews');
SET @user_savo_vrbica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103869690282378764212/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko', 'https://lh3.googleusercontent.com/a/ACg8ocLTIurmylUkobC4-x5XnwDnxFQeeqLQLTv3AeMKuMMWpRduD1s=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111172985365595403774/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111172985365595403774/reviews');
SET @user_marko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111172985365595403774/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'stanka mihaljevic', 'https://lh3.googleusercontent.com/a-/ALV-UjU_Huct4yVV8xKcyfuepeACRUbAwEwH0zdgliae47DxP8wOxx39=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101319639827596675696/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101319639827596675696/reviews');
SET @user_stanka_mihaljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101319639827596675696/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lire Konik', 'https://lh3.googleusercontent.com/a/ACg8ocIvLiChHUJK56WrHxfecXcdgkeYJdOtevOnwtVNCUeIuxizMA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110292654261804899487/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110292654261804899487/reviews');
SET @user_lire_konik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110292654261804899487/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Simona Petranovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVKJLb7986EksxAqFZ0g_VL_lHJnnlTKYEVcGbjvTFTGsbGWINpKg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101968246237285737340/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101968246237285737340/reviews');
SET @user_simona_petranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101968246237285737340/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavisa Rabrenovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVCEcOgBXjsCeWLq7JJI6DdZ3Rmn7dY9-vQ7MfHPnkhwBW0VDkLQA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103989078283460183131/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103989078283460183131/reviews');
SET @user_slavisa_rabrenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103989078283460183131/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sasa vujosevic', 'https://lh3.googleusercontent.com/a/ACg8ocIWqmyD9LgR5QqZXrhYx38mqyorz7GR6dX9DmXDmHhDdND2VA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101330781637215761664/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101330781637215761664/reviews');
SET @user_sasa_vujosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101330781637215761664/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Vukićević', 'https://lh3.googleusercontent.com/a-/ALV-UjUFpogMaM0_DInXdX0c8EMilUcid8_l0Llri79tAfIA7Rt3zEc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105890356086787581626/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105890356086787581626/reviews');
SET @user_anja_vukievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105890356086787581626/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Naja Halilovic', 'https://lh3.googleusercontent.com/a/ACg8ocK6-aFpu-dTv0qDD75UHHut1gA1rPlOyGv7Nd9ZLBxv_otbtA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105729659135287614506/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105729659135287614506/reviews');
SET @user_naja_halilovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105729659135287614506/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Bajceta', 'https://lh3.googleusercontent.com/a-/ALV-UjVTbnHuHylJrYaZDmAlEsQxcvt3Zj5zABUJ-wzx_Cj9QOusrI7-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100929804756419227081/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100929804756419227081/reviews');
SET @user_stefan_bajceta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100929804756419227081/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Vasilijević', 'https://lh3.googleusercontent.com/a/ACg8ocJs3hXvDZRDlifaCedtPCet3SCvi8CgqfrewipQrd5SwVwXBw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115559085991159495347/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115559085991159495347/reviews');
SET @user_dejan_vasilijevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115559085991159495347/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Marić', 'https://lh3.googleusercontent.com/a/ACg8ocIB_52KfLqS0TxGkHCw2JR4d6zrqapp3qzpbKLptf14dOn8KtLN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112068806441831457026/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112068806441831457026/reviews');
SET @user_jovana_mari = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112068806441831457026/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Teodora Abramovic', 'https://lh3.googleusercontent.com/a/ACg8ocLX2wBMDyr-F-L30e2K2bIpj1Ac5-XATC8IUdIi4cY-OKro-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114739843645313387831/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114739843645313387831/reviews');
SET @user_teodora_abramovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114739843645313387831/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elena Djurovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWW73I2838JiZsMJhRjZa-hGRkeE-YxdmlFUteTaJlkG8088mU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109321901967498510996/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109321901967498510996/reviews');
SET @user_elena_djurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109321901967498510996/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'tijana pejovic', 'https://lh3.googleusercontent.com/a/ACg8ocKl60JeB6dKr-8HTfZ3sdXlutVMt6CtU0LXURpl0KXQhiqu6A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113119225089707873904/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113119225089707873904/reviews');
SET @user_tijana_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113119225089707873904/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijan Kostadinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVPxZVoX-RfmEQbNJbkc9QiiTsIxgCmZHVfY9_n7MCqFPfdieNs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105375983257522711271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105375983257522711271/reviews');
SET @user_marijan_kostadinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105375983257522711271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Colevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUyAH0CtbNui_VUJPbDVDXMsQ6JDakv1-a0x9WaLMw0jqgZc5g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107840568665038619435/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107840568665038619435/reviews');
SET @user_ivana_colevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107840568665038619435/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Kuljak', 'https://lh3.googleusercontent.com/a-/ALV-UjUZFzoGR4I9u68VvwDNQqvU75KmO462cAiNmY80RkXrm1sW7lu-dw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110083257192744035419/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110083257192744035419/reviews');
SET @user_mirjana_kuljak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110083257192744035419/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladan Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLiKjlLpn8DlySFKSh-yvUra2c1RAB3syAffzIkEFV3gRSdwQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107308448543664106796/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107308448543664106796/reviews');
SET @user_vladan_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107308448543664106796/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Simo Videography', 'https://lh3.googleusercontent.com/a-/ALV-UjXoTYmaZOn0chJLis_YcZRXcUqiX_vPBQqx-vdX6Ukmx4rtsqAV=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101051979163848058716/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101051979163848058716/reviews');
SET @user_simo_videography = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101051979163848058716/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bojan radunovic', 'https://lh3.googleusercontent.com/a/ACg8ocIynMsPakb82GrWe1w1-qv3JU70otXM8QwSfHEVHQnbrM_fnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110927364837051301379/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110927364837051301379/reviews');
SET @user_bojan_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110927364837051301379/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'V.', 'https://lh3.googleusercontent.com/a/ACg8ocIMozKNBJFyO6RnCEA7Cgq9Aeq7gUw_W3DLiKOgMzQQD6nG7g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100179660006065180109/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100179660006065180109/reviews');
SET @user_user_100179660006065180109 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100179660006065180109/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'marko duletic', 'https://lh3.googleusercontent.com/a-/ALV-UjXZHxkv_ffRYhIIJstR5lHS4-nFt0hKAZfA7vnYGidlXL-iDau8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107369196818312698459/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107369196818312698459/reviews');
SET @user_marko_duletic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107369196818312698459/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Prava Balerina', 'https://lh3.googleusercontent.com/a-/ALV-UjXEXC-45pgq9gQnVHQj9Tet5xzITsQE-rB2PSS79pjCtXUZeTk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111559617012747285156/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111559617012747285156/reviews');
SET @user_prava_balerina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111559617012747285156/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Radunovic', 'https://lh3.googleusercontent.com/a/ACg8ocJiE5Fa00bDJbunEvrtM9WDxVBMDF9i-wuJN0D3iitaU-tuvQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109855849808459225769/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109855849808459225769/reviews');
SET @user_iva_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109855849808459225769/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovo Rabrenovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWyoGWOHdNg9pPv3gLwyhWVA4a5KSn0QhmGQo9pgP8iHksr3xQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102131036007933161018/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102131036007933161018/reviews');
SET @user_jovo_rabrenovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102131036007933161018/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Stojovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUN6bwUmxuiv-wG9GJfAWxLp4TBEXS8im28M47W6e_9SYn_9X50=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114364082228446184688/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114364082228446184688/reviews');
SET @user_marija_stojovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114364082228446184688/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djordje Djurovic', 'https://lh3.googleusercontent.com/a-/ALV-UjW1pQovCzwKGTXLgy8zlJmlD7q7iS349OQLMrfULqC_JPD4OqNF=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112227019627729761611/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112227019627729761611/reviews');
SET @user_djordje_djurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112227019627729761611/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Edin Alivodic', 'https://lh3.googleusercontent.com/a/ACg8ocIjH8W_HQ66b0MQmgwFIZewC2HJN7hNrNJDbGOICkBYenWovA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103104359786261438111/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103104359786261438111/reviews');
SET @user_edin_alivodic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103104359786261438111/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vincenzo Paielli', 'https://lh3.googleusercontent.com/a-/ALV-UjV2WuBKKTKz6tgH2J37XJzfgvnsXA3_sdV2SyMd7Ikftw-tiDFVVw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103827965821564530909/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103827965821564530909/reviews');
SET @user_vincenzo_paielli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103827965821564530909/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana Dukic', 'https://lh3.googleusercontent.com/a/ACg8ocKT0Ko-s9WdoqR9UjbqBTHeRdSaI7kXFX2Uy8-XlX3yUlsGXQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108510757647343850340/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108510757647343850340/reviews');
SET @user_svetlana_dukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108510757647343850340/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djina Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocKlJbn6C7cSNbeu-YoEcLXvenSmXo2-oO7cCdrYK-W1uEGUiQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107992962953742710745/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107992962953742710745/reviews');
SET @user_djina_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107992962953742710745/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olivera Jukic', 'https://lh3.googleusercontent.com/a/ACg8ocJciQ3Jies-JeNNdSDiUg1hx4atLvKPhi09r5l1FXbNQXB0ag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114595995423074672780/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114595995423074672780/reviews');
SET @user_olivera_jukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114595995423074672780/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mika Colovic', 'https://lh3.googleusercontent.com/a/ACg8ocI7qZJ1ODm6N02J-UMOCrVo2cBtVTr-O0eFeKPtBep3Od5pKQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115529083404309772055/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115529083404309772055/reviews');
SET @user_mika_colovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115529083404309772055/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veroljub Manojlovic', 'https://lh3.googleusercontent.com/a/ACg8ocIA2h3EU6D9lruY6OeuwPuYfSw1fbzWhBm2qHE214lmf3aJ8w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115677666494310265973/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115677666494310265973/reviews');
SET @user_veroljub_manojlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115677666494310265973/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radovan Radulovic', 'https://lh3.googleusercontent.com/a/ACg8ocLuzcwLnyfdbiINtm1UWs1kRsH5WKKogwtbgeRfPOqo_lccNQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116001930519295315618/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116001930519295315618/reviews');
SET @user_radovan_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116001930519295315618/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubica Sofranac', 'https://lh3.googleusercontent.com/a/ACg8ocI8RvOnBqDsrt75EHGQAv6EMO280FCWTIhFWUNKuRNHfrO9GQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100766838425664218208/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100766838425664218208/reviews');
SET @user_ljubica_sofranac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100766838425664218208/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Radulovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWEOdMF1Orh3siUK0sHB1B9voyq7sA_oQ-S8WQXbI_YKWyp14vy=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115929852647571003285/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115929852647571003285/reviews');
SET @user_mirjana_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115929852647571003285/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Martina Slavic', 'https://lh3.googleusercontent.com/a/ACg8ocL2GK_9vpaP0rTvvst-fx04TutbXSB1AilHPuPhGXYU3utShQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110903991549337795131/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110903991549337795131/reviews');
SET @user_martina_slavic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110903991549337795131/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Cerovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVW5YfLN6RvUblOhBnfCJJ6hu4nOWP8gj1r-DvTyoua2IPw804=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111376747431591873932/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111376747431591873932/reviews');
SET @user_milan_cerovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111376747431591873932/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Colovic', 'https://lh3.googleusercontent.com/a/ACg8ocJm1Nds4gneOPGERr_XY_L64wQjWYDX8H1VoMKz3vpbz-cCiv8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105458766280297394557/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105458766280297394557/reviews');
SET @user_ivana_colovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105458766280297394557/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'tijana mugosa', 'https://lh3.googleusercontent.com/a/ACg8ocIRvEF2Skvta-LsK0xKVOIcgHk98wXAmJpjTAgEJ2wOey74ig=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105886171760490491137/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105886171760490491137/reviews');
SET @user_tijana_mugosa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105886171760490491137/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijel Hodzic', 'https://lh3.googleusercontent.com/a-/ALV-UjXTfN6HDzixt80RM6WqQxQYGIEzpkQOWIjodglMNlsCAqrfeko=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105567626383124285459/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105567626383124285459/reviews');
SET @user_danijel_hodzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105567626383124285459/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Pavicevic', 'https://lh3.googleusercontent.com/a/ACg8ocJ_BwqlVQoStyqIQGhzSW7X4aGy18htWuRAkEgqBc8-9kMytw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104868762025044384934/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104868762025044384934/reviews');
SET @user_bojana_pavicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104868762025044384934/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Zivkovic', 'https://lh3.googleusercontent.com/a/ACg8ocIRbCijxDfWAyinkHvQUNhg4RX808JtTqLFewXgQAVj58CCpA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113691240780223962176/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113691240780223962176/reviews');
SET @user_jovana_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113691240780223962176/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadja Mikic', 'https://lh3.googleusercontent.com/a/ACg8ocIEAyGHa_tV09Y_mDw9wUl4q8XX79ZPMdzpwvMbyy_khGUKIA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113540388162105539681/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113540388162105539681/reviews');
SET @user_nadja_mikic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113540388162105539681/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branka Bogdanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKHl75uM454fVXm5S5NALLwr2wSlu2RHyBJMLbSlqDwweLWlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105862169797305355935/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105862169797305355935/reviews');
SET @user_branka_bogdanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105862169797305355935/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Cevuuu89', 'https://lh3.googleusercontent.com/a-/ALV-UjVySJs3g8lsJPEGT9f1Tqn4HInuGXLvmfTsPLjCrz_NGO0nyDg2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106016247833682469790/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106016247833682469790/reviews');
SET @user_cevuuu89 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106016247833682469790/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vuk Radinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWAjt0nrl5nL_CKlbtO5_tGnoVBEwN8iyqCDg3GSCJ8OdEDxzf1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106941334063550515496/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106941334063550515496/reviews');
SET @user_vuk_radinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106941334063550515496/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Tuzovic', 'https://lh3.googleusercontent.com/a/ACg8ocJBw3V93aUmV1eyoTqfY0KVoSpSMypcR9K3QfSNC6GKkBqL0w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118231464987821044108/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118231464987821044108/reviews');
SET @user_emir_tuzovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118231464987821044108/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Ajdukovic', 'https://lh3.googleusercontent.com/a/ACg8ocJu7Yk7x0yHSWjS0Ztf1M1KmM-FV-9Q4TBccPjvFpg4OagciA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102184044701657522489/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102184044701657522489/reviews');
SET @user_tijana_ajdukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102184044701657522489/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pedja Miketic', 'https://lh3.googleusercontent.com/a/ACg8ocLLUbcziVap7jLoofw02MeOTNVLo8kPJliNskDqk1C_H-ZJHQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112786604028008603944/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112786604028008603944/reviews');
SET @user_pedja_miketic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112786604028008603944/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Kijanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLDpmXIgJjkq45wXTnXiuw8g5DOe0hmj-j6fN3eMtfCpW7p=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112692101813026941012/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112692101813026941012/reviews');
SET @user_marija_kijanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112692101813026941012/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Dzikovic', 'https://lh3.googleusercontent.com/a/ACg8ocJVRyMfjcfRzIdbzya01XC5TkdKU5x9nJjKkE0WEnWE1gIRzw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108262897291674787277/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108262897291674787277/reviews');
SET @user_milan_dzikovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108262897291674787277/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Radinovic', 'https://lh3.googleusercontent.com/a/ACg8ocLFkoVkLCLRODm4hUkIqaOPuAR48vQoVFq66hiB8qTMVckX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107931844938945564795/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107931844938945564795/reviews');
SET @user_tijana_radinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107931844938945564795/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Radinovic', 'https://lh3.googleusercontent.com/a/ACg8ocKkCO0cjmhxyvaffaWipje7_9JL9C7GDT7dbl1nY40Y-POdmg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106424616475779799465/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106424616475779799465/reviews');
SET @user_dejan_radinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106424616475779799465/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocJvpRSPUtRkiux8TH80PFilOJWJLL93nj7jFVRB6kdxIXfV1Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108994754590217960469/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108994754590217960469/reviews');
SET @user_milan_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108994754590217960469/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tom Mark', 'https://lh3.googleusercontent.com/a/ACg8ocI0-TTSH5k5kXvg7kHU0tMdrtdZrCQFxHHw3CbZOGcWgjZxHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111464125172814485323/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111464125172814485323/reviews');
SET @user_tom_mark = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111464125172814485323/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goca Manojlovic', 'https://lh3.googleusercontent.com/a/ACg8ocI-k8GttL8ohBl3oBTyQFeuyPykcPcT3Y5u4-lmfgFwaEOU4w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118212235838002754947/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118212235838002754947/reviews');
SET @user_goca_manojlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118212235838002754947/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Mitrovic', 'https://lh3.googleusercontent.com/a/ACg8ocJPbKMq6X7V84uP-bSwKybXTTKIEflg3lBT39_57mn9YaGpLQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111511493159295937818/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111511493159295937818/reviews');
SET @user_milica_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111511493159295937818/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'BOQ Invest', 'https://lh3.googleusercontent.com/a-/ALV-UjV71qmQWWsX0aQpRKRN7x_2XYIBCZc6p-y3Ka30hM-ZX8BuSvCQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105759984480203321133/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105759984480203321133/reviews');
SET @user_boq_invest = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105759984480203321133/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Velinka Perazic', 'https://lh3.googleusercontent.com/a/ACg8ocJ3k4631ZiAe0XoJUtZiTVZBEF1I_Tm0HZ3Y6SdtmkygkmyC2U=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100707819887174731249/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100707819887174731249/reviews');
SET @user_velinka_perazic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100707819887174731249/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljko Popivoda', 'https://lh3.googleusercontent.com/a/ACg8ocIs2kz6bgiB_mc2q55z8qbt1jHqhja7p_GxQFKuDWkG-bTpyQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113303881965635024458/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113303881965635024458/reviews');
SET @user_zeljko_popivoda = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113303881965635024458/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Manojlovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUmFWYqjAuk_0i1JOkdxmU0DJA7_ANQnB1pu3d561WCXB6DVks=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115560888989662017190/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115560888989662017190/reviews');
SET @user_maja_manojlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115560888989662017190/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Klara Dragović', 'https://lh3.googleusercontent.com/a-/ALV-UjVysrlK0imCW6mC9_RGebeSy1Od05f_60NjRg0PjuLZTqi3RV7A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106270689073461650214/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106270689073461650214/reviews');
SET @user_klara_dragovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106270689073461650214/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Drago Marti', 'https://lh3.googleusercontent.com/a/ACg8ocJUMi4UIsEZbZ7HtN-Td19h2vtDKrNL9vVsppeBppSKqe5p=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112741448976126594367/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112741448976126594367/reviews');
SET @user_drago_marti = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112741448976126594367/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Volvo', 'https://lh3.googleusercontent.com/a/ACg8ocKOZvB9p0Km7XeY_YwKakDLqhtvNJc_2cg588g8_ZGECAOANA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117280993579604315811/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117280993579604315811/reviews');
SET @user_anja_volvo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117280993579604315811/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Radunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWdyvqs5TyrwYLZikUVMOkt9YvSycFG0_tAB-okWe0ocbCWm0mq=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103181233510188685432/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103181233510188685432/reviews');
SET @user_anja_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103181233510188685432/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Radunovic', 'https://lh3.googleusercontent.com/a/ACg8ocIrdTfRqmo50pXoZqcTc8JkF6AAaa8ll6QAU4PRHbEHEE8uzg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112002936149852644276/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112002936149852644276/reviews');
SET @user_iva_radunovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112002936149852644276/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'martina djekic', 'https://lh3.googleusercontent.com/a/ACg8ocJ5BLAY4IgsXsR4mscVxHO2bGPVXEJ29gXnBLw1NeyfPgbjQQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105978811012287697450/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105978811012287697450/reviews');
SET @user_martina_djekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105978811012287697450/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selma Tiric', 'https://lh3.googleusercontent.com/a/ACg8ocJXmUZhwFSOZztNcpoDKmN2OkrfcVQHJKpYtaTdW_swzzs8Xg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110214631265544966032/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110214631265544966032/reviews');
SET @user_selma_tiric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110214631265544966032/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Radunovic', 'https://lh3.googleusercontent.com/a/ACg8ocJesZ2tJh-JIaFM60bS49qliT5Pot5dPgcu73TyKBsdzCT3Yg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115158416296952180841/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115158416296952180841/reviews');
SET @user_iva_radunovic_3 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115158416296952180841/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'anita hadzalic', 'https://lh3.googleusercontent.com/a-/ALV-UjVGt32HxeY6vJj3JFSDXgdJ2076Hp_k18uftd07d5o4afG6MQE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106698146296619941703/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106698146296619941703/reviews');
SET @user_anita_hadzalic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106698146296619941703/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miki Barca', 'https://lh3.googleusercontent.com/a/ACg8ocJfU57mVVND6mMoYSz5efSbZVEI8bDBbJV5WEQ8PtU-IkHhDQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108221966559388305707/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108221966559388305707/reviews');
SET @user_miki_barca = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108221966559388305707/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_milena_planinic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvbWNmQVVREAE',
    5, 'hr', 'Sve pohvale za doktora i sestre. Od kako ste me prvi put izliječili i zahvaljujući vama nijesam se operisala, moje liječenje se uvijek tu nastavlja. Hvala vam od srca i da dalje ostanete ljubazni, divni i uspješni.❤️',
    'Sve pohvale za doktora i medicinske sestre. Pošto ste me prvi izlečili i zahvaljujući vama nisam operisan, moje lečenje je uvek nastavljeno tamo. Hvala vam od srca i neka i dalje budete ljubazni, divni i uspešni.❤', 'Све похвале за доктора и медицинске сестре. Пошто сте ме први излечили и захваљујући вама нисам оперисан, моје лечење је увек настављено тамо. Хвала вам од срца и нека и даље будете љубазни, дивни и успешни.❤', NULL, NULL, NULL, NULL,
    0, '2025-04-18 09:17:25'),

(@user_nenad_pavlicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURod2NQTzVnRRAB',
    5, 'bs', 'Vrhunski strucnjak u svom poslu . Posle njega idete uspravno 🙂',
    'Vrhunski stručnjak u svojoj oblasti. Hodaćete uspravno za njim 🙂', 'Врхунски стручњак у својој области. Ходаћете усправно за њим 🙂', NULL, NULL, NULL, NULL,
    2, '2023-03-10 14:26:28'),

(@user_dianna_carlen, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5aFozQktUMFpLUWtGMU5XVnBhMnhVWW5JeFZHYxAB',
    5, 'en', 'Away from home and i needed a remedial massage to help sort out some muscles in spasm. Was a great massage and really helped. Feels very professional.',
    'Daleko od kuće i bila mi je potrebna korektivna masaža da pomognem da sredim neke mišiće u grču. Bila je odlična masaža i zaista je pomogla. Oseća se veoma profesionalno.', 'Далеко од куће и била ми је потребна корективна масажа да помогнем да средим неке мишиће у грчу. Била је одлична масажа и заиста је помогла. Осећа се веома професионално.', 'Away from home and i needed a remedial massage to help sort out some muscles in spasm. Was a great massage and really helped. Feels very professional.', NULL, NULL, NULL,
    0, '2025-07-06 08:55:10'),

(@user_hlya_bilge, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURfcHV2bVZREAE',
    5, 'en', 'As a foreigner, my session with Dr. Radunovic was excellent. He speaks fluent English, which allowed me to clearly explain my situation. The examination was thorough and very accurate. Thank you so much!',
    'Kao stranac, moj sastanak sa dr Radunovićem je bio odličan. Tečno govori engleski, što mi je omogućilo da jasno objasnim svoju situaciju. Pregled je bio temeljan i veoma precizan. Hvala vam puno!', 'Као странац, мој састанак са др Радуновићем је био одличан. Течно говори енглески, што ми је омогућило да јасно објасним своју ситуацију. Преглед је био темељан и веома прецизан. Хвала вам пуно!', 'As a foreigner, my session with Dr. Radunovic was excellent. He speaks fluent English, which allowed me to clearly explain my situation. The examination was thorough and very accurate. Thank you so much!', NULL, NULL, NULL,
    0, '2025-01-23 21:52:05'),

(@user_balsa_radunovic, @clinic_id, @doctor_savo_radunovic, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUMydUxIMVF3EAE',
    5, 'bs', 'Doktor Savo sa kiropraktikom, a njegove kolege sprovodeći fizikalnu terapiju su mi do sad uspješno riješili i probleme sa vratom, i dva pršljena po sredini kičme, kao i petom. Sve preporuke.',
    'Dr Savo je svojom kiropraktikom i njegovim kolegama, svojom fizikalnom terapijom, uspešno rešio moje probleme sa vratom, dva pršljena na sredini kičme i petom. Sve preporuke.', 'Др Саво је својом киропрактиком и његовим колегама, својом физикалном терапијом, успешно решио моје проблеме са вратом, два пршљена на средини кичме и петом. Све препоруке.', NULL, NULL, NULL, NULL,
    4, '2022-04-12 07:11:47'),

(@user_milan_djuretic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GdWRtdEtURzVpZHpGNlpFVkJhamcxTURaNmVtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-29 00:00:00'),

(@user_clark_orro, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5UVgxSmxhams1U210SldYRnFiSHBZWjBveVMyYxAB',
    1, 'ru', 'Рекомендую держаться подальше от этого места. Было жжение в шее. Так называемый доктор посмотрел мой МРТ и сказал что причина в протрузии. Предложил вытягивании шеи, но результат не гарантирует. Нужно пройти 10 сеансов по 70 евро каждый. Этой ерундой в России занимальсь лет 10 назад, а здесь это все ещё предлагают. В итоге, у меня был лямблиоз и проблема решилась через антибиотики. Я с этой проблемой мучался 1 год и 3 месяца, пока не добрался до кинезеолога. Потом я этому же якобы доктору пожаловался на спазмы и жжение в правой ягодице.  Он порекомендовал делать рентген. Замем? Мне до сих пор не понятно.  Я сделал рентген и о не чудо, он ничего необычного не увидел. Отправил на массаж к своим помощницам . В итоге, у меня был порекошен таз и правая нога была короче, что после долгой ходьбы вызывало спазмы. Кинезеолог из России, в Будве, после  20 минут тестов, за 1 сеанс мне рассказал о всех моих проблемах и просто дал упражнения для выполнения дома. (правда для рецепта на антибиотики пришлось идти к эндокринологу.) Красивый кабинет и улыбающиеся девушки на ресепшене не перекроют вашу некомпетентность доктор Радунович.',
    NULL, NULL, NULL, 'Рекомендую держаться подальше от этого места. Было жжение в шее. Так называемый доктор посмотрел мой МРТ и сказал что причина в протрузии. Предложил вытягивании шеи, но результат не гарантирует. Нужно пройти 10 сеансов по 70 евро каждый. Этой ерундой в России занимальсь лет 10 назад, а здесь это все ещё предлагают. В итоге, у меня был лямблиоз и проблема решилась через антибиотики. Я с этой проблемой мучался 1 год и 3 месяца, пока не добрался до кинезеолога. Потом я этому же якобы доктору пожаловался на спазмы и жжение в правой ягодице.  Он порекомендовал делать рентген. Замем? Мне до сих пор не понятно.  Я сделал рентген и о не чудо, он ничего необычного не увидел. Отправил на массаж к своим помощницам . В итоге, у меня был порекошен таз и правая нога была короче, что после долгой ходьбы вызывало спазмы. Кинезеолог из России, в Будве, после  20 минут тестов, за 1 сеанс мне рассказал о всех моих проблемах и просто дал упражнения для выполнения дома. (правда для рецепта на антибиотики пришлось идти к эндокринологу.) Красивый кабинет и улыбающиеся девушки на ресепшене не перекроют вашу некомпетентность доктор Радунович.', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jelena_lukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pocGRVZzNUMGxaUlcxUFpVUmpTblY0U1RkcWRrRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_goran_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KWVNUZDBXV0ZOY2xaWVJFVnpUUzF5TmkxeGNWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_rajko_uskokovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paTmFFeFdTMDR4Vld0dlREWm9TMG8yTkhwNVgzYxAB',
    5, 'en', 'Super .
Everything professional and great',
    NULL, NULL, 'Super .
Everything professional and great', NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_jovan_rabrenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNodDZ5UVJREAE',
    5, 'bs', 'Sjajna usluga uz vrhunskog ljekara i fizioterapeute.',
    'Sjajna usluga uz vrhunskog ljekara i fizioterapeute.', NULL, NULL, NULL, NULL, NULL,
    2, '2026-03-01 00:00:00'),

(@user_jovo_rabrenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSbFRIWk1kelpsYTJwaFZHcFlNREJLTVc1M2RYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_institut_ekonomskih_nauka_crne_gore, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KWmNtWnphMlZVTFhKR04wRmFUbVp3YW5aU1dYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_savo_vrbica, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pJMGFuUmZRbFJsY1VkcFRWbG1ha2t5WTNNM1RYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_marko, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxSll6ZE9ZVVI2WlVoSmRtbDJVRmxXUm1sVVRHYxAB',
    5, 'en', 'Best chiropractor in Montenegro!',
    NULL, NULL, 'Best chiropractor in Montenegro!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_stanka_mihaljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkNmJXTk1PRkZJVlhSVVZYWklkR3hyWm5kMmJrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_lire_konik, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCNVJtTlNjR3BKT1RWdFNtRm5XRTB5WW5ackxXYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_simona_petranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VNZXIzTTY5cXItS293RRAB',
    5, 'hr', 'Najbolji i najbolje osoblje',
    'Najbolji i najbolje osoblje', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_slavisa_rabrenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VOWGx6YmpPMGRMel9BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sasa_vujosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnTURJbEszQzJBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anja_vukievi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNQNnRDR1NREAE',
    5, 'hr', 'Najbolji ste.Hvala Vam',
    'Najbolji ste.Hvala Vam', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_naja_halilovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURmaGFIQm13RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_stefan_bajceta, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUR2aE5XUjN3RRAB',
    5, 'hr', 'Sve preporuke',
    'Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dejan_vasilijevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2bWVtWHNBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_mari, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2MHJpcC1RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_teodora_abramovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNIZ2FQNG9BRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_elena_djurovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURUcWZtc1JnEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_tijana_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5cHMtYmlRRRAB',
    5, 'hr', 'Izuzetno ljubazni i profesionalni, moji tretmani i dalje traju ali vec osjecam olakšanje, sjajan tim',
    'Izuzetno ljubazni i profesionalni, moji tretmani i dalje traju ali vec osjecam olakšanje, sjajan tim', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_marijan_kostadinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5ck4tLXJ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ivana_colevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUM5d1pfTkZnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_mirjana_kuljak, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURkdjgyVElnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vladan_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2M2VyTTd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_simo_videography, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUROc2RPWFlBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_bojan_radunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURWbGN6ZF93RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_user_100179660006065180109, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURWa0tYeFVnEAE',
    5, 'en', 'The most professional chiropractor with the best team. Physical therapy, massage, decompression, electro-therapy, all at the same place.',
    NULL, NULL, 'The most professional chiropractor with the best team. Physical therapy, massage, decompression, electro-therapy, all at the same place.', NULL, NULL, NULL,
    2, '2024-10-29 00:00:00'),

(@user_marko_duletic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURKM283bjRRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_prava_balerina, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURKNHFlMWF3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_iva_radunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURSbGFXaHZRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_jovo_rabrenovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNodDZ6LW9RRRAB',
    5, 'hr', 'Visok nivo stručnosti i profesionalnosti, vrhunski školovano osoblje.',
    'Visok nivo stručnosti i profesionalnosti, vrhunski školovano osoblje.', NULL, NULL, NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_marija_stojovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURCcktpT0RnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_djordje_djurovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1c1pPQVp3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_edin_alivodic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURPbTVUWk5BEAE',
    5, 'hr', 'Težu povredu kičmenog stuba,12-godišnjeg sina,sanirali u potpunosti,u rekordnom roku.Vječno zahvalan!',
    'Težu povredu kičmenog stuba,12-godišnjeg sina,sanirali u potpunosti,u rekordnom roku.Vječno zahvalan!', NULL, NULL, NULL, NULL, NULL,
    7, '2022-10-29 00:00:00'),

(@user_vincenzo_paielli, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUMycnRuMEh3EAE',
    4, 'en', 'Professional',
    NULL, NULL, 'Professional', NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_svetlana_dukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUMya1AzV25BRRAB',
    5, 'hr', 'Vrlo kompetentna, pouzdana I ljubazna ekipa!
Veliko Hvala i Pozdrav iz Austrije !!
Bravo za Ivana (mog terapeuta) Hvala 😊!!',
    'Vrlo kompetentna, pouzdana I ljubazna ekipa!
Veliko Hvala i Pozdrav iz Austrije !!
Bravo za Ivana (mog terapeuta) Hvala 😊!!', NULL, NULL, NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_djina_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURtMGZHeG1BRRAB',
    5, 'bs', 'Najbolji',
    'Najbolji', NULL, NULL, NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_olivera_jukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtcjd1bmxRRRAB',
    5, 'en', 'The best!',
    NULL, NULL, 'The best!', NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_mika_colovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtaDY3S3BRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_veroljub_manojlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURjNW9MNFRBEAE',
    5, 'hr', 'Pravi profesionalci',
    'Pravi profesionalci', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_radovan_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZ0tQc1hREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_ljubica_sofranac, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURHZ01QRnhBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_mirjana_radulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURHZ0lPTmJREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_martina_slavic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHOTdyOEhnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_milan_cerovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2dTRuWXVBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_ivana_colovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2dS1HZHZRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_tijana_mugosa, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2M2Z2LTlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_danijel_hodzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2bmFXTWN3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_bojana_pavicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2blltUzVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_jovana_zivkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2bmZIc1NnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_nadja_mikic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2bmRHTHlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_branka_bogdanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ2blpHVlJBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_cevuuu89, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURheXBIeGh3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_vuk_radinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURheXBIa2d3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_emir_tuzovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURxaWNfNHVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_tijana_ajdukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURxaWJmN0x3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_pedja_miketic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURxaWZ1bEVBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_marija_kijanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURxd2IzcWxBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_milan_dzikovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5a3E3dHJnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_tijana_radinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ4aWRlQnNRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_dejan_radinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ4aWJ2NVRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_milan_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ4MXBiQmFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_tom_mark, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUM4M2RxTWFREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_goca_manojlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURjbThhVzl3RRAB',
    5, 'hr', 'Profesionalnost i dobar kvalitet usluge.',
    'Profesionalnost i dobar kvalitet usluge.', NULL, NULL, NULL, NULL, NULL,
    1, '2020-10-29 00:00:00'),

(@user_milica_mitrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURjM292V293RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_boq_invest, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURjbHZMbE1REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_velinka_perazic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURjNXF5eFhBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_zeljko_popivoda, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURjcHR6NFd3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_maja_manojlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURjLXBmSkN3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_klara_dragovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURja3Vxa0VnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_drago_marti, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQweGNpNjVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_anja_volvo, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNVLWRTWkxnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_anja_radunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNVLWRUcUdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_iva_radunovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNVdVlQOTZBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_martina_djekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUR3MXFlOHFnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_selma_tiric, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURna01UUm5RRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_iva_radunovic_3, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNndEttX21RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_anita_hadzalic, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURnLXV5UElBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_miki_barca, @clinic_id, NULL, 'google_maps',
    'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUN3NHNDT3BnRRAB',
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

-- ═══════════════════════════════════════════════════════════════
-- PART 3: Insert review replies (owner responses)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO review_replies (review_id, responder_type, clinic_id, original_text, original_language, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, provider, published_at)
VALUES (
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvbWNmQVVREAE'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURod2NQTzVnRRAB'),
  'clinic', @clinic_id,
  'Hvala! 🤗', 'hr',
  'Hvala! 🤗', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5aFozQktUMFpLUWtGMU5XVnBhMnhVWW5JeFZHYxAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURfcHV2bVZREAE'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GdWRtdEtURzVpZHpGNlpFVkJhamcxTURaNmVtYxAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KWVNUZDBXV0ZOY2xaWVJFVnpUUzF5TmkxeGNWRRAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-01-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paTmFFeFdTMDR4Vld0dlREWm9TMG8yTkhwNVgzYxAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNodDZ5UVJREAE'),
  'clinic', @clinic_id,
  '❤️🙏', 'en-US',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSbFRIWk1kelpsYTJwaFZHcFlNREJLTVc1M2RYYxAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KWmNtWnphMlZVTFhKR04wRmFUbVp3YW5aU1dYYxAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pJMGFuUmZRbFJsY1VkcFRWbG1ha2t5WTNNM1RYYxAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2025-12-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxSll6ZE9ZVVI2WlVoSmRtbDJVRmxXUm1sVVRHYxAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCNVJtTlNjR3BKT1RWdFNtRm5XRTB5WW5ackxXYxAB'),
  'clinic', @clinic_id,
  '?', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VNZXIzTTY5cXItS293RRAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VOWGx6YmpPMGRMel9BRRAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnTURJbEszQzJBRRAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSUNQNnRDR1NREAE'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURmaGFIQm13RRAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUR2aE5XUjN3RRAB'),
  'clinic', @clinic_id,
  '🙏🤗', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2bWVtWHNBRRAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2MHJpcC1RRRAB'),
  'clinic', @clinic_id,
  '🙏', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ5cHMtYmlRRRAB'),
  'clinic', @clinic_id,
  'Hvala! 🙏', 'hr',
  'Hvala! 🙏', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURWbGN6ZF93RRAB'),
  'clinic', @clinic_id,
  '🤗', 'en-US',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChZDSUhNMG9nS0VJQ0FnSURWa0tYeFVnEAE'),
  'clinic', @clinic_id,
  '❤️', 'en-US',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSURKM283bjRRRRAB'),
  'clinic', @clinic_id,
  '🤗', 'en-US',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJR59Y3w_rTRMRQvdUlNg7kZM/reviews/ChdDSUhNMG9nS0VJQ0FnSUNodDZ6LW9RRRAB'),
  'clinic', @clinic_id,
  '❤️🙏', 'en-US',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
