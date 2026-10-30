-- Insert Google Maps reviews for IMC Fizio
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/imc-fizio-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'imc-fizio-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_filip_pejovic = (SELECT id FROM doctors WHERE slug = 'filip-pejovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nataliia Borshosh', 'https://lh3.googleusercontent.com/a/ACg8ocJWPcmI2WudXl0j8pHLwoxM4i3cebsLtV-r4vjxotkrOsqlVw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105819308937768164746/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105819308937768164746/reviews');
SET @user_nataliia_borshosh = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105819308937768164746/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Drobnjak', 'https://lh3.googleusercontent.com/a-/ALV-UjWbQ6vfiWuuQFFjZEvizYi3xyIMqoOtnvHXA6of8ht21mi66i1f=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117931628959013306251/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117931628959013306251/reviews');
SET @user_jovana_drobnjak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117931628959013306251/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sebastián Moravčík', 'https://lh3.googleusercontent.com/a-/ALV-UjUOMEqd0eJXmkV4qcvFKEhg6keExizt1mshLutcdIAXTuz-L5iW=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/113199396865023719597/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113199396865023719597/reviews');
SET @user_sebastin_moravk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113199396865023719597/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Martinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVoo1_PASMx7N81tdkX0zC96XgR-PI8wUfNt03MIpVunFQtiwFv=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/109238469954923163768/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109238469954923163768/reviews');
SET @user_ivana_martinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109238469954923163768/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Mitrović', 'https://lh3.googleusercontent.com/a/ACg8ocIpAmz_cE0aJ8nfExv7sQUmgCEn4di53Ip8RMxFtjbn9mD8JQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/116572471471782472418/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116572471471782472418/reviews');
SET @user_stefan_mitrovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116572471471782472418/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Panoska', 'https://lh3.googleusercontent.com/a-/ALV-UjVHPIq-TWrJCaIi3rU-72sZJcA2kSm851sSo9cNUcQK1ndqBOJm=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105292691992114059606/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105292691992114059606/reviews');
SET @user_sara_panoska = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105292691992114059606/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slobodan Bukilic', 'https://lh3.googleusercontent.com/a/ACg8ocLAqvHPlbc3gFYiW6qeEXOORj00-kOMJpsNwcZJ1u9FpUCfNA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108191732447266384161/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108191732447266384161/reviews');
SET @user_slobodan_bukilic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108191732447266384161/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Iković', 'https://lh3.googleusercontent.com/a-/ALV-UjUMkKO_okH5_uc4nHwXFz53gRLCSjQwOm06nULrmX4VDy7ILzOz=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104129899436328372014/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104129899436328372014/reviews');
SET @user_marija_ikovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104129899436328372014/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Raicevic', 'https://lh3.googleusercontent.com/a/ACg8ocKkzXZn6RaZqXIMmkk4XdpAVytQ44TLZ36FgATZHwpV5SXfYQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111417393594626986447/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111417393594626986447/reviews');
SET @user_jelena_raicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111417393594626986447/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Snežana Mitrović', 'https://lh3.googleusercontent.com/a/ACg8ocIZ8dvaHU4ah9kVet6nm6SEnbq9cave8o4_j3jDQqDPvXX9=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103007200941866445090/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103007200941866445090/reviews');
SET @user_sneana_mitrovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103007200941866445090/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ksenija rakocevic', 'https://lh3.googleusercontent.com/a/ACg8ocKs4mIMnyFphpkSqvDgKape9fDHFjfdhgwAv6QfuWyZ4VsvzQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102477437405909131209/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102477437405909131209/reviews');
SET @user_ksenija_rakocevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102477437405909131209/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Snezana Milutinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV15YVLSCNgW7DYnkOcgvuXnzmxbXOidEbqdMWIqiJx4T8JgSE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106358794776231497853/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106358794776231497853/reviews');
SET @user_snezana_milutinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106358794776231497853/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mihailo Raspopović', 'https://lh3.googleusercontent.com/a-/ALV-UjVUbV26JB8Ip121LuS1GxQwkwD8nTUozwVLxEJuKX0YH5-GHcDI2A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112005369404743168535/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112005369404743168535/reviews');
SET @user_mihailo_raspopovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112005369404743168535/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Pejovic', 'https://lh3.googleusercontent.com/a/ACg8ocIWQ11LaJ-Aru4O9TU9GytLldtJ0ZdBDtTIhCgq84_a6rdEOA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114215645253698950109/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114215645253698950109/reviews');
SET @user_biljana_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114215645253698950109/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veselin Rasovic', 'https://lh3.googleusercontent.com/a/ACg8ocKPG9juSfnvufn4w9htHGOra290g3GenNKKUS5D9OMaKMoDjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112046167451118728131/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112046167451118728131/reviews');
SET @user_veselin_rasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112046167451118728131/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valentina Gazivoda', 'https://lh3.googleusercontent.com/a/ACg8ocIqt0j8hisba3v6os6N_vARhGkm5ctBPhUMnMJOhEJMWQLuaQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113408928574234395181/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113408928574234395181/reviews');
SET @user_valentina_gazivoda = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113408928574234395181/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Dasic', 'https://lh3.googleusercontent.com/a/ACg8ocLfF_8GAnnS3KjIq6EKs5bciuMAc7wUT_xvcNk43Ie7-Cm4hw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106770419422374202381/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106770419422374202381/reviews');
SET @user_filip_dasic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106770419422374202381/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Velimirovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV-AWH28jll8jEo_vadWw_aiQa3dZtM7D6zP1L2neWLJUDZcEM2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115075771815876050315/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115075771815876050315/reviews');
SET @user_milos_velimirovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115075771815876050315/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nevena Petković', 'https://lh3.googleusercontent.com/a-/ALV-UjUmrcXKS1GnsmJU2XuDTL-g2A2qnk8guLyYFeq5K_kL_OEyxA8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111324820494458957580/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111324820494458957580/reviews');
SET @user_nevena_petkovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111324820494458957580/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Exeterum', 'https://lh3.googleusercontent.com/a/ACg8ocK3EpmnDsS7nCddtI93tBPmn28lLAbUtY6Kd88Ijlz5dLModg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114537492178926997921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114537492178926997921/reviews');
SET @user_exeterum = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114537492178926997921/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Asanović', 'https://lh3.googleusercontent.com/a/ACg8ocK3Ht2voRgfs_qlun3qRGJ3LsNkHXX-MSRGuuEeCRPozWzZ0g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105575930589136119484/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105575930589136119484/reviews');
SET @user_anastasija_asanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105575930589136119484/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Masa RADULOVIC', 'https://lh3.googleusercontent.com/a-/ALV-UjVBrx8qis0IhRaTJsYT2OVG-DIUbMCa8fGOtnHKLW9Om2JAtTfj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102012014445188047406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102012014445188047406/reviews');
SET @user_masa_radulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102012014445188047406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina Hasanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXD7jM90V2wpy-SAMju2yDZfb5DOtES_RnLo5w9nCp2GAHrIBU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100538567899987393581/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100538567899987393581/reviews');
SET @user_jasmina_hasanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100538567899987393581/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ma Ra', 'https://lh3.googleusercontent.com/a-/ALV-UjX7GbvcFsIup5qjziBOJeAqraj8TwDuwt8W9AUkUHu0SQAO0a8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100380564230703367268/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100380564230703367268/reviews');
SET @user_ma_ra = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100380564230703367268/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Raspopovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWRm9Mz2U7w2C7-6Fu9UQMl47ZjpX_4IeisQRn0q40o4E-9Fp6-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107106970029350924577/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107106970029350924577/reviews');
SET @user_marija_raspopovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107106970029350924577/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Pejovic', 'https://lh3.googleusercontent.com/a/ACg8ocIr4FSwJ62YF8Hw67Ou_IWIs41tpkUy_XMtNYbpJMx8vcVR7w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101570502210982371330/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101570502210982371330/reviews');
SET @user_dejan_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101570502210982371330/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mala Sirena', 'https://lh3.googleusercontent.com/a/ACg8ocLOZeMOHiUTKYsPAyA4k1UVbETpmQ8UUjz4vetrOo9icOQoQA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101200160865468321131/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101200160865468321131/reviews');
SET @user_mala_sirena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101200160865468321131/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vanja Vukcevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW_tnwBEICf5yrzSc_pYjklzDV5t28lxsCUOmUm3wvHx2iOUocj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103320330167140810927/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103320330167140810927/reviews');
SET @user_vanja_vukcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103320330167140810927/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'zeljka tomcuk', 'https://lh3.googleusercontent.com/a-/ALV-UjXQ2_ewy5jLk02HaKV1Wa7vSTShb2Baf7d33V8Jw99onZvWMg9g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110742654967405485790/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110742654967405485790/reviews');
SET @user_zeljka_tomcuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110742654967405485790/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Du', 'https://lh3.googleusercontent.com/a-/ALV-UjWmgYO_2i4OGjpJ5FZFHTEGff0ZduFOt3U7dWO5UAQHSQTwBh8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111473666867354855800/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111473666867354855800/reviews');
SET @user_du = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111473666867354855800/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Radenovic', 'https://lh3.googleusercontent.com/a/ACg8ocLEMIvR9Z6MH3dLTlKbAHrr4rqMt4VJGs9FANTlf3smc86SmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107407410558406850686/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107407410558406850686/reviews');
SET @user_jovan_radenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107407410558406850686/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Golubovic', 'https://lh3.googleusercontent.com/a/ACg8ocJerrBsPrIDSh47n24BrjPg1VEQ0RSxlvLpteNsg_tCtt-c-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101324779937629526278/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101324779937629526278/reviews');
SET @user_anja_golubovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101324779937629526278/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dušica J', 'https://lh3.googleusercontent.com/a/ACg8ocKyL67UO6zZsgGvO99Q0EZdamK8ufBTkxMUY8l8MMlIWJVeQA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118067445192859185305/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118067445192859185305/reviews');
SET @user_duica_j = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118067445192859185305/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Dubljević', 'https://lh3.googleusercontent.com/a-/ALV-UjVvCYF3TVPJkqpHo50gGel3h0V24YoMq1h57zTJ5S4ocICTwypw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100370153756968297694/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100370153756968297694/reviews');
SET @user_sanja_dubljevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100370153756968297694/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Helena Brajovic', 'https://lh3.googleusercontent.com/a/ACg8ocK3anz2Z_rpFpg1eFM5tKAD4mDcZ0hUvlHexPStC4Hq9x2G0A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105836830412114866885/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105836830412114866885/reviews');
SET @user_helena_brajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105836830412114866885/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Savic', 'https://lh3.googleusercontent.com/a/ACg8ocJA48MCWhlpQ8pkSi9-d0WzgLQElxhZ2xS_re1DP_y9TRBaDw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114123349271534933271/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114123349271534933271/reviews');
SET @user_ivana_savic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114123349271534933271/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana Maletic', 'https://lh3.googleusercontent.com/a-/ALV-UjX7y_tR5OsVj2jLH5SaNb_uFxAxZO0y408XDmVXHmFlKvyXRco=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113786079418972358989/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113786079418972358989/reviews');
SET @user_sladjana_maletic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113786079418972358989/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zara Brajovic', 'https://lh3.googleusercontent.com/a/ACg8ocI6LHsAATKRxdGA1hEEIVjlXoBI39l-PMExgUkSWOjbLGNooxM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110717694979705743864/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110717694979705743864/reviews');
SET @user_zara_brajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110717694979705743864/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Knežević', 'https://lh3.googleusercontent.com/a-/ALV-UjU6B2gisojcTxTajgARUr-p0_QJvBQMZwHxY7EIwjcbVVQ8lm8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101644738072720714313/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101644738072720714313/reviews');
SET @user_ivana_kneevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101644738072720714313/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatjana Raspopović', 'https://lh3.googleusercontent.com/a/ACg8ocIaEMR3FHS9rpb1nsJ3EVwc-0FMdWu7y9WT9XI1PFHlfn7JBw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116312470239492706212/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116312470239492706212/reviews');
SET @user_tatjana_raspopovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116312470239492706212/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusan Pejovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU63hN-QGHej_abst0gOlNvqJ-Mmqu0TAGzmMgeA5Ax3pUXJYcr=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103135430256974066114/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103135430256974066114/reviews');
SET @user_dusan_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103135430256974066114/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dzingis Kan', 'https://lh3.googleusercontent.com/a/ACg8ocKBEy77yHp8LQZlP5hMxhRuCZlaxMcoeUiI7fwhjwZ2UcxUQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113783057830623646997/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113783057830623646997/reviews');
SET @user_dzingis_kan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113783057830623646997/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emilija Sokolovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVYfG_oDNas2YfquYF9rCv8O8u68SdFBtS26FEtZ82Z_gLx1AwQ8Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100056926667794640491/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100056926667794640491/reviews');
SET @user_emilija_sokolovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100056926667794640491/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Šćepanović', 'https://lh3.googleusercontent.com/a-/ALV-UjXM-r4tvfdJMV0I-rtWvq7GwB_vx5yR4qmW0buzB6SetZFg0Xt2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114160962427330579882/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114160962427330579882/reviews');
SET @user_aleksandar_epanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114160962427330579882/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Jeremic', 'https://lh3.googleusercontent.com/a/ACg8ocIz7JsxNOOI_Z42l2q7ajklHBf6EnVbu93gtXJpWNYCQi_q1g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109201550687575161290/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109201550687575161290/reviews');
SET @user_jelena_jeremic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109201550687575161290/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksa Adžić', 'https://lh3.googleusercontent.com/a-/ALV-UjXUTRI2llY2QgCqB88uK2Vk45aH4NIMVuxEpo8RSq8oQ5a5KM00=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113017787373744095474/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113017787373744095474/reviews');
SET @user_aleksa_adi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113017787373744095474/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Raspopović', 'https://lh3.googleusercontent.com/a/ACg8ocJ3boILf1o8ao6xJN2uzEkygS5cPpLnV9lUT7eudv8_i3aLEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105281394406803195009/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105281394406803195009/reviews');
SET @user_marija_raspopovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105281394406803195009/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_nataliia_borshosh, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toQ05GSm1ibXRxT0ZwRmRHNWphSFJKVEV3eFdIYxAB',
    5, 'en', 'Filip is a great rehabilitologist!
I came for treatment with severe back injury to avoid or at least postpone surgery as long as possible.
The IMC fizio is well equipped, so I could receive all my recommended therapies.
Filip suggested a treatment plan according to my case, with gradual increase of each treatment method. I had Tecar therapy, lazer therapy, elerctrotherapy, stretching, exercises for lower back muscles.
There\'s much more equipment, I just innumerated those I used for my case.

I\'m lucky to have found this place.Not only it has everything for your health, Filip is an incredible person! Very kind and cheerful.
Thank you so much!',
    'Filip je odličan rehabilitolog!
Došao sam na lečenje sa teškom povredom leđa da bih izbegao ili bar odložio operaciju što je duže moguće.
IMC fizio je dobro opremljen, tako da sam mogao da primam sve moje preporučene terapije.
Filip je predložio plan lečenja prema mom slučaju, uz postepeno povećanje svake metode lečenja. Imao sam Tecar terapiju, laser terapiju, elektroterapiju, istezanje, vežbe za mišiće donjeg dela leđa.
Ima mnogo više opreme, samo sam nabrojao one koje sam koristio za svoj slučaj.

Srećan sam što sam našao ovo mesto. Ne samo da ima sve za vaše zdravlje, Filip je neverovatna osoba! Veoma ljubazan i veseo.
Hvala vam puno!', 'Филип је одличан рехабилитолог!
Дошао сам на лечење са тешком повредом леђа да бих избегао или бар одложио операцију што је дуже могуће.
ИМЦ физио је добро опремљен, тако да сам могао да примам све моје препоручене терапије.
Филип је предложио план лечења према мом случају, уз постепено повећање сваке методе лечења. Имао сам Тецар терапију, ласер терапију, електротерапију, истезање, вежбе за мишиће доњег дела леђа.
Има много више опреме, само сам набројао оне које сам користио за свој случај.

Срећан сам што сам нашао ово место. Не само да има све за ваше здравље, Филип је невероватна особа! Веома љубазан и весео.
Хвала вам пуно!', 'Filip is a great rehabilitologist!
I came for treatment with severe back injury to avoid or at least postpone surgery as long as possible.
The IMC fizio is well equipped, so I could receive all my recommended therapies.
Filip suggested a treatment plan according to my case, with gradual increase of each treatment method. I had Tecar therapy, lazer therapy, elerctrotherapy, stretching, exercises for lower back muscles.
There\'s much more equipment, I just innumerated those I used for my case.

I\'m lucky to have found this place.Not only it has everything for your health, Filip is an incredible person! Very kind and cheerful.
Thank you so much!', NULL, NULL, NULL,
    0, '2025-11-24 19:38:56'),

(@user_jovana_drobnjak, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21JeVVFdEtRM05GZVRJNE9VdFRVVVZRVEhoNlJrRRAB',
    5, 'en', 'Huge recommendation! I came to Filip after an exhausting 20-day period of constant pain caused by sciatica inflammation. His approach was extremely professional from the very beginning. He adapted the therapy to the changes in my condition and gave me advice on positions and exercises to help me prevent this condition from happening again. Thank you so much!"',
    'Velika preporuka! Došla sam kod Filipa nakon iscrpljujućih 20 dana stalnih bolova izazvanih upalom išijasa. Njegov pristup je bio izuzetno profesionalan od samog početka. Prilagodio je terapiju promenama u mom stanju i dao mi savete o položajima i vežbama koje će mi pomoći da sprečim da se ovo stanje ponovo pojavi. Hvala vam puno!', 'Велика препорука! Дошла сам код Филипа након исцрпљујућих 20 дана сталних болова изазваних упалом ишијаса. Његов приступ је био изузетно професионалан од самог почетка. Прилагодио је терапију променама у мом стању и дао ми савете о положајима и вежбама које ће ми помоћи да спречим да се ово стање поново појави. Хвала вам пуно!', 'Huge recommendation! I came to Filip after an exhausting 20-day period of constant pain caused by sciatica inflammation. His approach was extremely professional from the very beginning. He adapted the therapy to the changes in my condition and gave me advice on positions and exercises to help me prevent this condition from happening again. Thank you so much!"', NULL, NULL, NULL,
    0, '2026-01-10 14:44:35'),

(@user_sebastin_moravk, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKb1MwNDBiemx1VjBzMWNHZFFNMmt4VFhScWMyYxAB',
    5, 'sk', 'Mám problém a to kompresia nervu, našťastie som vyhľadal odborníka a postupne sa to zlepšuje každou návštevou. Odborný a profesionálny prístup, prehľad, veľa rôznych procesov a odborné vybavenie, môžem len odporučiť. Ďakujem pekne)',
    'Imam problem, odnosno kompresiju nerva, na svu sreću potražio sam specijalistu i svakim posetom se postepeno popravlja. Stručni i profesionalni pristup, pregled, mnogo različitih procesa i profesionalne opreme, mogu samo da preporučim. hvala puno)', 'Имам проблем, односно компресију нерва, на сву срећу потражио сам специјалисту и сваким посетом се постепено поправља. Стручни и професионални приступ, преглед, много различитих процеса и професионалне опреме, могу само да препоручим. хвала пуно)', NULL, NULL, NULL, NULL,
    0, '2025-10-24 07:12:22'),

(@user_ivana_martinovic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxaVptcE5lVFJwTkhOd2QxWmtlVTQ0VFVoMmVrRRAB',
    5, 'bs', 'Terapeut koji me je radio, gospodin Filip, bio je izuzetno profesionalan. Svaki tretman je detaljno objasnio, a takođe mi je pokazao koje vežbe mogu raditi kod kuće. Ima veliko znanje o anatomiji i fiziologiji, što mi je pomoglo da bolje razumem svoj problem.
Topla preporuka 😊',
    'Terapeut koji me je lečio, gospodin Filip, bio je izuzetno profesionalan. Detaljno mi je objasnio svaki tretman i pokazao mi je vežbe koje mogu da radim kod kuće. Ima odlično znanje anatomije i fiziologije, što mi je pomoglo da bolje razumem svoj problem.
Toplo preporučujem 😊', 'Терапеут који ме је лечио, господин Филип, био је изузетно професионалан. Детаљно ми је објаснио сваки третман и показао ми је вежбе које могу да радим код куће. Има одлично знање анатомије и физиологије, што ми је помогло да боље разумем свој проблем.
Топло препоручујем 😊', NULL, NULL, NULL, NULL,
    0, '2025-09-15 14:11:31'),

(@user_stefan_mitrovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkWVltVmZhM0ZuVGxsaFdXazJka1ZSWVhOR1dGRRAB',
    5, 'bs', 'Zadovoljan sam tretmanom. Fizioterapeut je bio profesionalan, objasnio mi sve jasno i pristupio problemu temeljno.Atmosfera tokom terapije je bila prijatna. Preporučujem svakome ko traži stručnu podrsku.',
    'Zadovoljan sam tretmanom. Fizioterapeut je bio profesionalan, sve mi je jasno objasnio i temeljno je pristupio problemu. Atmosfera tokom terapije je bila prijatna. Preporučujem je svima koji traže stručnu podršku.', 'Задовољан сам третманом. Физиотерапеут је био професионалан, све ми је јасно објаснио и темељно је приступио проблему. Атмосфера током терапије је била пријатна. Препоручујем је свима који траже стручну подршку.', NULL, NULL, NULL, NULL,
    0, '2025-07-02 12:55:54'),

(@user_sara_panoska, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkMGNrVktSa0ZyUTFoU2VEUldjVmxCU0RsVmJuYxAB',
    5, 'hr', 'Sve pohvale za IMC Fizio, a posebno za terapeuta Filipa!
Dolazak na fizikalnu terapiju nakon perioda kada mi je noga bila fiksirana bio je velik izazov za mene, ali Filipov profesionalizam, neizmjerno strpljenje i pristupačnost učinili su oporavak mnogo lakšim.
Pomogao mi je, prije svega, da ponovo prohodam pravilno i povratim potpunu fleksibilnost i pokretljivost u koljenu. Njegov ljubazan stav i posvećenost daju veliku podršku i samopouzdanje tokom cijelog procesa. Od srca preporučujem Filipa i IMC Fizio svima kojima je potreban vrhunski oporavak i posvećen terapeut!',
    'Sve pohvale za IMC Fizio, a posebno za terapeuta Filipa!
Dolazak na fizikalnu terapiju nakon perioda kada mi je noga bila fiksirana bio je velik izazov za mene, ali Filipov profesionalizam, neizmjerno strpljenje i pristupačnost učinili su oporavak mnogo lakšim.
Pomogao mi je, prije svega, da ponovo prohodam pravilno i povratim potpunu fleksibilnost i pokretljivost u koljenu. Njegov ljubazan stav i posvećenost daju veliku podršku i samopouzdanje tokom cijelog procesa. Od srca preporučujem Filipa i IMC Fizio svima kojima je potreban vrhunski oporavak i posvećen terapeut!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_slobodan_bukilic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SQmNIWnZSbXRQT0ZaSGVWbExPRUZmVGpscVYxRRAB',
    5, 'bs', 'Vrhunski tretman za rjesavanje problema sa diskus hernijom. Temeljan pristup i profesionalnost na odlicnom nivou',
    'Vrhunski tretman za rjesavanje problema sa diskus hernijom. Temeljan pristup i profesionalnost na odlicnom nivou', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_marija_ikovi, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGV1UwdHNjRFZvUVZGNmFsWnlZekJ0UmkxT04zYxAB',
    5, 'bs', 'Posle 3 fizioterapeuta, Filip je konacno pristupio problemu skocnog zgloba sistematicno i posveceno. Postoperativni period je bio mnogo kraci od ocekivanog. Sve preporuke!',
    'Posle 3 fizioterapeuta, Filip je konacno pristupio problemu skocnog zgloba sistematicno i posveceno. Postoperativni period je bio mnogo kraci od ocekivanog. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jelena_raicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oUGJqWXRjbFJsVEd0T1NVeG5VMEZSTmpkRmFrRRAB',
    5, 'bs', 'Odlican fizioterapeut!Strucnost,pristup i empaticnost na zavidnom nivou,kao i opremljenost  najsavremenijim aparatima.
Iskrene preporuke😊',
    'Odlican fizioterapeut!Strucnost,pristup i empaticnost na zavidnom nivou,kao i opremljenost  najsavremenijim aparatima.
Iskrene preporuke😊', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_sneana_mitrovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnTUNnbGM3a2N3EAE',
    5, 'bs', 'Jako ugodna, prijatna atmosfera. Profesionalnost na najvecem mogucem nivou! Konacno sam pronasla nekog ko mi je rijesio problem. Sve preporuke!',
    'Jako ugodna, prijatna atmosfera. Profesionalnost na najvecem mogucem nivou! Konacno sam pronasla nekog ko mi je rijesio problem. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_ksenija_rakocevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kMFRWUmZOSE56Y0hOMU9WbHRhSEZVWnpsUlJIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_snezana_milutinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tnMWNGaERhRlV0WDJkaWRuUlhhWFJFZFZsT09XYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_mihailo_raspopovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUR6LV9xdll3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_biljana_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaMlUyaDBORU0yWkV4MGExWmlZV0o0WWxGNmQwRRAB',
    5, 'en', 'Good service',
    NULL, NULL, 'Good service', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_veselin_rasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaZmNFRlRiUzFZZFVkMFdqSkRMV1pQU0RSSFIxRRAB',
    5, 'hr', 'Profesionalni, odgovorni i maksimalno posvećeni pacijentima. Svaka preporuka.',
    'Profesionalni, odgovorni i maksimalno posvećeni pacijentima. Svaka preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_valentina_gazivoda, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoTFdHbEhTbkl6U2pSZlh6WmFWbTFtUjNaV2NGRRAB',
    5, 'hr', 'Pohvale za stručnost  i profesionalnost.
Sve preporuke za IMC fizio.',
    'Pohvale za stručnost  i profesionalnost.
Sve preporuke za IMC fizio.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_filip_dasic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kQk16bHhWamQ0VGtWbWIwUTVRVTB6VGpaUWQwRRAB',
    5, 'bs', 'Filip je stručan i posvećen fizioterapeut. Svakom pacijentu pristupa individualno. Došao sam sa povredom skocnog zgloba i nakon par tretmana osjetio sam znacajno poboljšanje. Preporučio bih svima da posjete ovaj fizio centar, sve pohvale za trud i posvećenost.',
    'Filip je stručan i posvećen fizioterapeut. Svakom pacijentu pristupa individualno. Došao sam sa povredom skocnog zgloba i nakon par tretmana osjetio sam znacajno poboljšanje. Preporučio bih svima da posjete ovaj fizio centar, sve pohvale za trud i posvećenost.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milos_velimirovic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/Ci9DQUlRQUNvZENodHljRjlvT25JNGIyb3diVTR4WDBwR1pFWXlkMEpTV1hObU1IYxAB',
    5, 'hr', '“Otključao” mi je ukočeni vrat i ramena u svega par tretmana! Hvala Filipe!',
    '“Otključao” mi je ukočeni vrat i ramena u svega par tretmana! Hvala Filipe!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_nevena_petkovi, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnTURvbzdIM0p3EAE',
    5, 'en', 'When long resting did not help with my bursitis, Filip implemented a series of different therapies, and I felt much better immediately! He always thoughtfully planned each session, followed my rehabilitation process, and gave me valuable advice on how to behave so the pain is gone faster. Also, he introduced me to many different exercises that I can do at home to ensure I don\'t get the same condition again. Thanks a lot! Big recomendation.',
    NULL, NULL, 'When long resting did not help with my bursitis, Filip implemented a series of different therapies, and I felt much better immediately! He always thoughtfully planned each session, followed my rehabilitation process, and gave me valuable advice on how to behave so the pain is gone faster. Also, he introduced me to many different exercises that I can do at home to ensure I don\'t get the same condition again. Thanks a lot! Big recomendation.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_exeterum, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnbGMyZDZ3RRAB',
    5, 'hr', 'Izuzetno prijatan i profesionalan covjek.Pomogao mi je sa dugogodisnjim problem.Zelim da svi imaju iskustvo kao ja i prije svega sve preporuke za ovoga momka!',
    'Izuzetno prijatan i profesionalan covjek.Pomogao mi je sa dugogodisnjim problem.Zelim da svi imaju iskustvo kao ja i prije svega sve preporuke za ovoga momka!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anastasija_asanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnbFpIdGlnRRAB',
    5, 'bs', 'Profesionalno i strucno. Sve pohvale!',
    'Profesionalno i strucno. Sve pohvale!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_masa_radulovic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnTUNBd0k3WWlnRRAB',
    5, 'en', 'Only two weeks into my sessions with Filip, I already feel a lighter and more relaxed back, posture that is in much improved and overall less pain in my body. The use of the state of the art equipment , coupled with Filip’s experience, patience and approach makes physical therapy a joy!',
    NULL, NULL, 'Only two weeks into my sessions with Filip, I already feel a lighter and more relaxed back, posture that is in much improved and overall less pain in my body. The use of the state of the art equipment , coupled with Filip’s experience, patience and approach makes physical therapy a joy!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jasmina_hasanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSURQNzZtejFnRRAB',
    5, 'hr', 'Imala sam problem s kalcifikatom u ramenu i nakon već prve terapije osjećala sam se mnogo bolje. Bol je nakon par tretmana nestala, a pokretljivost se vratila. Fizioterapeut je bio veoma ljubazan, strpljiv i sve mi je jasno objasnio. Svima ga preporučujem!',
    'Imala sam problem s kalcifikatom u ramenu i nakon već prve terapije osjećala sam se mnogo bolje. Bol je nakon par tretmana nestala, a pokretljivost se vratila. Fizioterapeut je bio veoma ljubazan, strpljiv i sve mi je jasno objasnio. Svima ga preporučujem!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ma_ra, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSURYc3R1d1hnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marija_raspopovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSURYc3B1ZzNnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dejan_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSURYcktiNEdBEAE',
    5, 'en', 'Incredible !',
    NULL, NULL, 'Incredible !', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_mala_sirena, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSURMcXB1WEdREAE',
    5, 'hr', 'Nedavno sam završila terpaiju, mogu samo reći da se sada osjećam sjajno, osoblje je izizetno ljubazno, oprema moderna, bolovi su napokon nestali, mogu da funkcionišem normalno. Svima preporučujem od srca da posjete IMC FIZIO, i ja ću se vratiti opet, kako bih svoje stanje očuvala na ovom nivou do kojeg sam došla zahvaljujući njima!',
    'Nedavno sam završila terpaiju, mogu samo reći da se sada osjećam sjajno, osoblje je izizetno ljubazno, oprema moderna, bolovi su napokon nestali, mogu da funkcionišem normalno. Svima preporučujem od srca da posjete IMC FIZIO, i ja ću se vratiti opet, kako bih svoje stanje očuvala na ovom nivou do kojeg sam došla zahvaljujući njima!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vanja_vukcevic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMOElURzVnRRAB',
    5, 'en', 'Filip is a professional. He is dedicated and patient. His knowledge, therapy and advices helped me significantly to overcome severe pain.',
    NULL, NULL, 'Filip is a professional. He is dedicated and patient. His knowledge, therapy and advices helped me significantly to overcome severe pain.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_zeljka_tomcuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUR6X2NyV1V3EAE',
    5, 'hr', 'Isla sam i jos uvjek idem na terapije i mogu samo pohvaliti osoblje.Puni znanja,empatije,sposobni.Sa Sindromom smrznutog ramena,tendinitisom i burzitisom sam se mucila skoro godinu ipo dana dok nisam otisla na pravo mjesto.Hvala od srca.',
    'Isla sam i jos uvjek idem na terapije i mogu samo pohvaliti osoblje.Puni znanja,empatije,sposobni.Sa Sindromom smrznutog ramena,tendinitisom i burzitisom sam se mucila skoro godinu ipo dana dok nisam otisla na pravo mjesto.Hvala od srca.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_du, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNUOHRXanN3RRAB',
    5, 'en', 'I had serious problems with my neck and back pain when I came to this place. Filip is a true professional, who not only works with expertise but explains the process to patients, which, to me is a big part of therapy. I am extremely happy with my progress and will be coming back to sessions regularly. Big plus is also the up to date equipment they got. So, this place is not to miss for anybody needing a good physical therapy in MNE',
    NULL, NULL, 'I had serious problems with my neck and back pain when I came to this place. Filip is a true professional, who not only works with expertise but explains the process to patients, which, to me is a big part of therapy. I am extremely happy with my progress and will be coming back to sessions regularly. Big plus is also the up to date equipment they got. So, this place is not to miss for anybody needing a good physical therapy in MNE', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jovan_radenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUaXFtVFhBEAE',
    5, 'bs', 'Prijatan pristup, profesionalan tretman i vrhunska terapija!',
    'Prijatan pristup, profesionalan tretman i vrhunska terapija!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_anja_golubovic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSURqX3RHemtRRRAB',
    5, 'bs', 'Fantastican i profesionalan pristup!
Masaze su prije svega jako korisne i osjetila sam nevjerovatno olaksanje nakon tretmana. Filip je maksimalno posvecen, koristi najsavremeniju opermu i ovo je najbolji tretman od svega sto sam do sada probala.
Tretmani su u mom slucaju bili sveobuhvatni, od relaks masaze, sok terapije, vjezbi za istezanje, a svaki tretman obuhvata i vjezbe.
Sve preporuke, nisam imala nikakvih problema sa kicmom nakon odradjenog seta terapija.
Sve preporuke!',
    'Fantastican i profesionalan pristup!
Masaze su prije svega jako korisne i osjetila sam nevjerovatno olaksanje nakon tretmana. Filip je maksimalno posvecen, koristi najsavremeniju opermu i ovo je najbolji tretman od svega sto sam do sada probala.
Tretmani su u mom slucaju bili sveobuhvatni, od relaks masaze, sok terapije, vjezbi za istezanje, a svaki tretman obuhvata i vjezbe.
Sve preporuke, nisam imala nikakvih problema sa kicmom nakon odradjenog seta terapija.
Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_duica_j, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqMmQ3VE5REAE',
    5, 'bs', 'Profesionalni,ljubazni,a prije svega oporavljaju!',
    'Profesionalni,ljubazni,a prije svega oporavljaju!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sanja_dubljevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqMlk2eG1nRRAB',
    5, 'bs', 'Zaista ste profesionalni! Svaka čast!!!!',
    'Zaista ste profesionalni! Svaka čast!!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_helena_brajovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqcWViTjFBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ivana_savic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqNGR6U293RRAB',
    5, 'bs', 'Imam odlicno iskustvo sa IMC Fizio ambulantom...u mom slucaju je bio prelom...
Filip je kombinacijom vise terapija uspeo da se krecem bez pomoci staka svega 10 dana posle skidanja gipsa...hvala mu puno
Odlican mladi bracni par koji ima I vreme I korektne cijene pristupacne svakome i odmah se krece sa terapijom, nema cekanja sto je svakako prednost...posebno sve pohvale sto ne gledaju na vreme, uvek terapija traje duze od dogovorenog....
Preporucujem ih svakom, jer znam da cete se posle oporavka vratiti bar na relaks masazu ....ja jesam...',
    'Imam odlicno iskustvo sa IMC Fizio ambulantom...u mom slucaju je bio prelom...
Filip je kombinacijom vise terapija uspeo da se krecem bez pomoci staka svega 10 dana posle skidanja gipsa...hvala mu puno
Odlican mladi bracni par koji ima I vreme I korektne cijene pristupacne svakome i odmah se krece sa terapijom, nema cekanja sto je svakako prednost...posebno sve pohvale sto ne gledaju na vreme, uvek terapija traje duze od dogovorenog....
Preporucujem ih svakom, jer znam da cete se posle oporavka vratiti bar na relaks masazu ....ja jesam...', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sladjana_maletic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqb2RfNlV3EAE',
    5, 'hr', 'Nedavno sam završila svoj tretman fizikalne terapije u Vašoj klinici i moram priznati da sam oduševljena iskustvom. Osoblje je izuzetno stručno i ljubazno, uvijek spremno da odgovori na sva moja pitanja i pruži podršku tokom procesa oporavka. Što se tiče opreme, mogu reći da je vrhunska - moderna, dobro održavana i prilagođena potrebama svakog pacijenta. Ovdje sam doživjela profesionalizam na najvišem nivou i nastaviću da koristim Vaše usluge i ubuduće. Toplo preporučujem svima koji traže kvalitetnu fizikalnu terapiju da posjete ovu ustanovu.',
    'Nedavno sam završila svoj tretman fizikalne terapije u Vašoj klinici i moram priznati da sam oduševljena iskustvom. Osoblje je izuzetno stručno i ljubazno, uvijek spremno da odgovori na sva moja pitanja i pruži podršku tokom procesa oporavka. Što se tiče opreme, mogu reći da je vrhunska - moderna, dobro održavana i prilagođena potrebama svakog pacijenta. Ovdje sam doživjela profesionalizam na najvišem nivou i nastaviću da koristim Vaše usluge i ubuduće. Toplo preporučujem svima koji traže kvalitetnu fizikalnu terapiju da posjete ovu ustanovu.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_zara_brajovic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChRDSUhNMG9nS0VJQ0FnSUNqb2FzRhAB',
    5, 'bs', 'Sve pohvale i preporuke za IMC Fizio, a posebno za Filipa koji je u svakom trenutku spreman da pomogne, da rijesi problem i nadje nacin da se bol otkloni u sto kracem roku. Ambulanta je opremljena najsavremenijom opremom, a osoblje je izuzetno ljubazno i predusretljivo.',
    'Sve pohvale i preporuke za IMC Fizio, a posebno za Filipa koji je u svakom trenutku spreman da pomogne, da rijesi problem i nadje nacin da se bol otkloni u sto kracem roku. Ambulanta je opremljena najsavremenijom opremom, a osoblje je izuzetno ljubazno i predusretljivo.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ivana_kneevi, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqb2IyNF9RRRAB',
    5, 'bs', 'Iskustvo u IMC Fizio je izvanredno. Profesionalan pristup, stručnost i ljubaznost su ono što me najviše impresioniralo. Tretmani su izuzetno efikasni i brzo sam osetila poboljšanje. Filip je izvanredan fizioterapeut! Njegova stručnost, predanost i empatija su neverovatni. Atmosfera u klinici je jako prijatna, što dodatno doprinosi celokupnom iskustvu. Topla preporuka za sve  koji traže vrhunsku fizioterapiju i brzo poboljšanje!',
    'Iskustvo u IMC Fizio je izvanredno. Profesionalan pristup, stručnost i ljubaznost su ono što me najviše impresioniralo. Tretmani su izuzetno efikasni i brzo sam osetila poboljšanje. Filip je izvanredan fizioterapeut! Njegova stručnost, predanost i empatija su neverovatni. Atmosfera u klinici je jako prijatna, što dodatno doprinosi celokupnom iskustvu. Topla preporuka za sve  koji traže vrhunsku fizioterapiju i brzo poboljšanje!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_tatjana_raspopovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqb1phODVRRRAB',
    5, 'bs', 'Prezadovoljna tretmanom. Ispravila kicmu i nemam bolove u vratu. Profesionalan i strucan pristup. Toplo preporucujem',
    'Prezadovoljna tretmanom. Ispravila kicmu i nemam bolove u vratu. Profesionalan i strucan pristup. Toplo preporucujem', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dusan_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqd2F2SGVBEAE',
    5, 'hr', 'Bol u leđima koji sam imao zbog problema sa  diskusom i rada koji obavljam uglavnom sjedeći je, posle odrađenih tretmana, nestao. Sad preventivno dolazim s vremena na vrijeme na tretmane, što je zajedno sa vježbama  koje su mi preporučili u IMC fizio dovelo do toga da mi se bol više nije ponavljala. Sve preporuke !',
    'Bol u leđima koji sam imao zbog problema sa  diskusom i rada koji obavljam uglavnom sjedeći je, posle odrađenih tretmana, nestao. Sad preventivno dolazim s vremena na vrijeme na tretmane, što je zajedno sa vježbama  koje su mi preporučili u IMC fizio dovelo do toga da mi se bol više nije ponavljala. Sve preporuke !', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dzingis_kan, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqZ2V1N0VREAE',
    5, 'bs', 'Sve preporuke od nas!
Nas djecak ide na fizioterapije i prezadovoljni smo,posvecenost,rad,istrajnost,stimulacija...
Hvala jos jednom 🤗🤍',
    'Sve preporuke od nas!
Nas djecak ide na fizioterapije i prezadovoljni smo,posvecenost,rad,istrajnost,stimulacija...
Hvala jos jednom 🤗🤍', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_emilija_sokolovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqZ2VtWkZnEAE',
    5, 'bs', 'Nakon par mjeseci strašnih bolova zbog problema sa diskusima i nemogućnosti da hodam, u ovoj ordinaciji sam se bukvalno preporodila. Poslije prvog tretmana hodala sam skoro bez bola. Nakon nekoliko... napredak je neopisiv!  Posvećenost i strpljivost terapeuta su posebna priča. Iskreno preporučujem🫶
Dekompresioni sto me posebno očarao😊 Ma sve u kompletu!',
    'Nakon par mjeseci strašnih bolova zbog problema sa diskusima i nemogućnosti da hodam, u ovoj ordinaciji sam se bukvalno preporodila. Poslije prvog tretmana hodala sam skoro bez bola. Nakon nekoliko... napredak je neopisiv!  Posvećenost i strpljivost terapeuta su posebna priča. Iskreno preporučujem🫶
Dekompresioni sto me posebno očarao😊 Ma sve u kompletu!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_aleksandar_epanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChZDSUhNMG9nS0VJQ0FnSUNqZ2JtVk5nEAE',
    5, 'bs', 'Sve je radjeno na vrhunskom i profesijonalnom nivou.I vrlo brzo sam  osjetio oporavak i nerava i misica.Ocjena 10. Super mi je pomoglo u svakom obliku,čak u dodatnom razvitku snage.',
    'Sve je radjeno na vrhunskom i profesijonalnom nivou.I vrlo brzo sam  osjetio oporavak i nerava i misica.Ocjena 10. Super mi je pomoglo u svakom obliku,čak u dodatnom razvitku snage.', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_jelena_jeremic, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqZ1lIVHh3RRAB',
    5, 'bs', 'Sve pohvale za posvecenost svom poslu. Vrlo strpljiv, stalozen i najbitnije da su rezultati odmah vidljivi. Filip je postao porodicni fizioterapeut. Najmladjem clanu porodice, bebi od 5 meseci , eleminisao tortikolis za samo mesec dana. Svaka preporuka!',
    'Sve pohvale za posvecenost svom poslu. Vrlo strpljiv, stalozen i najbitnije da su rezultati odmah vidljivi. Filip je postao porodicni fizioterapeut. Najmladjem clanu porodice, bebi od 5 meseci , eleminisao tortikolis za samo mesec dana. Svaka preporuka!', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_aleksa_adi, @clinic_id, @doctor_filip_pejovic, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqZ2Y3OXh3RRAB',
    5, 'en', 'Filip has great knowledge and knows to implement just the right therapy for you.
After not being able to get out from bed because of the back pain, few therapies with Filip and I was like knew.
Highly recommended for everybody with an office job. Have regular therapy sessions with Filip, you will not feel the pain again.',
    NULL, NULL, 'Filip has great knowledge and knows to implement just the right therapy for you.
After not being able to get out from bed because of the back pain, few therapies with Filip and I was like knew.
Highly recommended for everybody with an office job. Have regular therapy sessions with Filip, you will not feel the pain again.', NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marija_raspopovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLfQykhTrTRMRa2HADgzJ7G8/reviews/ChdDSUhNMG9nS0VJQ0FnSUNqNG9LdWtRRRAB',
    5, 'en', 'The professionalism and expertise of the staff at IMC Fizio are unparalleled. The ambulance is equipped with state-of-the-art equipment, ensuring that all patients receive the highest quality care possible. I couldn\'t recommend them more for any issue one may have that requires that kind of expertise.',
    NULL, NULL, 'The professionalism and expertise of the staff at IMC Fizio are unparalleled. The ambulance is equipped with state-of-the-art equipment, ensuring that all patients receive the highest quality care possible. I couldn\'t recommend them more for any issue one may have that requires that kind of expertise.', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
