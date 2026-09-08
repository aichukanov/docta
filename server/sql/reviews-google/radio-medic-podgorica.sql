-- Insert Google Maps reviews for Radio Medic — centar za radiološku dijagnostiku (Podgorica)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/radio-medic-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ-fDjmKTtTRMRm7C_ZAf5_uA' LIMIT 1);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Gošović', 'https://lh3.googleusercontent.com/a/ACg8ocIimbF2Har5Ht1o969oDKx8STgCg0IuaaZzqtbmGCGO9Erzj_BF=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100571598422620411092/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100571598422620411092/reviews');
SET @user_danijela_goovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100571598422620411092/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dunja Obradovic', 'https://lh3.googleusercontent.com/a/ACg8ocLMSCsKdNlY0jIPUrAxudEMihoSHfc8ZcWBHxZ2Ek3smeDrDg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104584951097232781799/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104584951097232781799/reviews');
SET @user_dunja_obradovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104584951097232781799/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrija Vulic', 'https://lh3.googleusercontent.com/a/ACg8ocL7PC8ZZn9aJm8Wgr3H0lHgWCuaaN_19EqEJ4ivi1ieQ8bqYA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101859985787952083896/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101859985787952083896/reviews');
SET @user_andrija_vulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101859985787952083896/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'danijel colovic', 'https://lh3.googleusercontent.com/a/ACg8ocLPuaT1IzwCe4672yzIW7bAApqfNiS1o5q6AuAdA9S-TyaZvQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107680595744214338966/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107680595744214338966/reviews');
SET @user_danijel_colovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107680595744214338966/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Klikovac', 'https://lh3.googleusercontent.com/a-/ALV-UjV4p4zHDzGO8tGy_G1TNlB6zoXqd3D1EtRPoHnb3joW7yC4BdEd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117898145054486343071/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117898145054486343071/reviews');
SET @user_tijana_klikovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117898145054486343071/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Savic Medenica', 'https://lh3.googleusercontent.com/a/ACg8ocJX4-LxN1OO1YT0tMltUWLhTryP-ye26kUoC6HrM5AHXCYRkw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108793998367104917162/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108793998367104917162/reviews');
SET @user_savic_medenica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108793998367104917162/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andjela Abazovic', 'https://lh3.googleusercontent.com/a/ACg8ocLkKBZJd6BAY3-bpq4KRnSX7Zm_uD_DL4jljeU0L_pUDW01hw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116547653085275283762/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116547653085275283762/reviews');
SET @user_andjela_abazovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116547653085275283762/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Golubović', 'https://lh3.googleusercontent.com/a-/ALV-UjVaW7ZnM1m4gtJa6HM5IMrCKzQrHHBSKTrd9mHqDJAXd-Fb6w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118054789841203529046/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118054789841203529046/reviews');
SET @user_milica_golubovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118054789841203529046/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Büşra Özel', 'https://lh3.googleusercontent.com/a-/ALV-UjUBaFx8Z13ZJ-A2c0XN5VXaL0vFKZ9hQC26svOX3CWB72TOqq-T=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111433313456052633715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111433313456052633715/reviews');
SET @user_bra_zel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111433313456052633715/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Perovic', 'https://lh3.googleusercontent.com/a/ACg8ocKBGndUMQKjjFgSC4VA2CKJgToSSMqEKuwkw84HYsQj5bzcKg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117811479640083616067/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117811479640083616067/reviews');
SET @user_milan_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117811479640083616067/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ANA Perovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWvJUSz2sxNAz5q_VZuT5-k5dKAcJOXngH4O9M2ppe8CU_EiuKd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107321766560825234482/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107321766560825234482/reviews');
SET @user_ana_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107321766560825234482/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gordana Grbic', 'https://lh3.googleusercontent.com/a-/ALV-UjXJplmEf1JGGek9B4vUmqK797jXk7g1IJrzt2_SR6S4mHEVJDHX=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117305328075564199426/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117305328075564199426/reviews');
SET @user_gordana_grbic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117305328075564199426/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ulqin Samsung', 'https://lh3.googleusercontent.com/a/ACg8ocJc5r1b7xAV9eXXKX5ISDtCo3NXYn-tESfKsecQyvtjCt7zdg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104321913851651804534/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104321913851651804534/reviews');
SET @user_ulqin_samsung = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104321913851651804534/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Korovic', 'https://lh3.googleusercontent.com/a/ACg8ocKF2vb8KX412A6W4eI5CMdNYN2Zle5C7QD3IDhuqS4JK6qhCg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110434933664749382401/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110434933664749382401/reviews');
SET @user_vesna_korovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110434933664749382401/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina Saveleva', 'https://lh3.googleusercontent.com/a/ACg8ocLBit9xxw7f91vWaCYKT1wP3YHK2nLjkCFOf7f10Hv7yQVisg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106905404488925710834/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106905404488925710834/reviews');
SET @user_irina_saveleva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106905404488925710834/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljiljana Blagojevic', 'https://lh3.googleusercontent.com/a/ACg8ocKXX-Z1hpYKH_hsxY4JwD-DMU25rWRfMDMsegq94Y4DTDYJaw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100865043289643233428/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100865043289643233428/reviews');
SET @user_ljiljana_blagojevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100865043289643233428/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Milic', 'https://lh3.googleusercontent.com/a/ACg8ocI9jP_rDJvkV0n6DVNV4XVMwOvS7ziHyfrCQN2QVeiT8FLzjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100250943490812365127/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100250943490812365127/reviews');
SET @user_milos_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100250943490812365127/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Scekic', 'https://lh3.googleusercontent.com/a/ACg8ocLgrNhGB7OiaYXbKrZd3edifVqB6-QGSWOiryPeI4-cAm5VjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115318702797006662153/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115318702797006662153/reviews');
SET @user_tanja_scekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115318702797006662153/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Diko Jevremovic', 'https://lh3.googleusercontent.com/a/ACg8ocLrpJ2AI4Kuiov-kjLSLaK2elWcp6wd9c2iBKC6tdiwHE_HVQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106232280346125350825/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106232280346125350825/reviews');
SET @user_diko_jevremovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106232280346125350825/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Rakic', 'https://lh3.googleusercontent.com/a/ACg8ocJMdMPKpribItv0x_MAvfv4IuEHSTQwHsj6bZIRwC9YLO-28w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116525836189919581197/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116525836189919581197/reviews');
SET @user_milos_rakic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116525836189919581197/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branka Stijepovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUh9iOc4laO2_6RwCIPzQ_qTZVQXt4MBk8nu9g4NAKhrb3BEys=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102146045840334263084/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102146045840334263084/reviews');
SET @user_branka_stijepovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102146045840334263084/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Auto Servis', 'https://lh3.googleusercontent.com/a/ACg8ocLpqaCmU6ZoH4xwYUHfh8yoo0qIe-fNLxo11C6yeTeynDiOWg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114024694295266471689/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114024694295266471689/reviews');
SET @user_auto_servis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114024694295266471689/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Esma Erovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUnHy3VLBMqvcyEl5U7fmYcHferpqPLnHC6h6Ryp3lws3nxK0UR=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108628602127133427938/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108628602127133427938/reviews');
SET @user_esma_erovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108628602127133427938/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elida Ećo', 'https://lh3.googleusercontent.com/a-/ALV-UjWUcOzD5sUDf8YYAkQFu1mUmjkLEuGXq5amD7scY3P4_77jU2sl=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102360150672689349210/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102360150672689349210/reviews');
SET @user_elida_eo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102360150672689349210/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ali salih', 'https://lh3.googleusercontent.com/a/ACg8ocKt0MUD4FUGDIZYFPFjNwk0kl4TjVVzPtwLgLT834N2DfOPGw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101830358443020688405/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101830358443020688405/reviews');
SET @user_ali_salih = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101830358443020688405/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lena Ulicevic', 'https://lh3.googleusercontent.com/a/ACg8ocJVHPvROYzYtwd4utzRrjCGvFRDgIPEabGkirJcLGWjzN7EIg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107663232196721803603/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107663232196721803603/reviews');
SET @user_lena_ulicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107663232196721803603/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Micanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjV9a80z88FI8B8cK3Emscjsvt0u2cE0zx8Cl1WJ2bqEjYzxrKc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100822540899844229736/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100822540899844229736/reviews');
SET @user_sara_micanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100822540899844229736/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoran Basanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ33WCa_PvqBDLg3MCM3IAC8ikW_dWmHTxN6w6t613ujlT8O6E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107841666874089669521/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107841666874089669521/reviews');
SET @user_zoran_basanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107841666874089669521/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igor S', 'https://lh3.googleusercontent.com/a/ACg8ocIHMPLK7Pb8unv56_C-9IZpH6sTCHemnYKXEg9ozLayB3fe2Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103572683830048578818/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103572683830048578818/reviews');
SET @user_igor_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103572683830048578818/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Simićević', 'https://lh3.googleusercontent.com/a/ACg8ocLu6g4xA4HJgpqVm7VjNEp6d0pZtvHYeGbo3ZbAme09Pr5aag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107531643727166238764/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107531643727166238764/reviews');
SET @user_milena_simievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107531643727166238764/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirela Sljivancanin', 'https://lh3.googleusercontent.com/a-/ALV-UjV15FWsEXV-H4dpdyB7UNli3fum7qGsCWrikClYwQcP2CsTBsDC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117184372312762213365/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117184372312762213365/reviews');
SET @user_mirela_sljivancanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117184372312762213365/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Dzankic', 'https://lh3.googleusercontent.com/a/ACg8ocKIcJmxsgAoFkWSqIYrWlK3M4Z2HILtmKPZ2iZmrW-5zGAPPg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117132076070136176625/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117132076070136176625/reviews');
SET @user_jovana_dzankic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117132076070136176625/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dusan vujovic', 'https://lh3.googleusercontent.com/a/ACg8ocKZBqSJkBn0R9iI5B2Cj15ARnN37tRbzo5K7hnupiSsKVy4RA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110119316278975047253/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110119316278975047253/reviews');
SET @user_dusan_vujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110119316278975047253/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selma Softic', 'https://lh3.googleusercontent.com/a/ACg8ocK5yLVl1yOBMnd8McdjRPBgkSQOURIUzggHrl94QqiqH-GgTA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103226425891905157564/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103226425891905157564/reviews');
SET @user_selma_softic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103226425891905157564/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Softic Elvis', 'https://lh3.googleusercontent.com/a/ACg8ocJym5kpS_zHQL2_UEKraaXt76k0IuT0U85M_evNux8Y-5JK_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105668809057409291701/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105668809057409291701/reviews');
SET @user_softic_elvis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105668809057409291701/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Leovac', 'https://lh3.googleusercontent.com/a/ACg8ocLJlM8e_k2zCs8j2hm4NjgfCY8goVkkYEqOrYFUxoaIPXrfdA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116161213461781403294/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116161213461781403294/reviews');
SET @user_biljana_leovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116161213461781403294/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sanja dragas', 'https://lh3.googleusercontent.com/a/ACg8ocLgjTH35I53gCO_qEvYkJ4Low0ixUdtnWk9oeJHq26KYMrDNA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100063548176198108706/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100063548176198108706/reviews');
SET @user_sanja_dragas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100063548176198108706/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Miranovic', 'https://lh3.googleusercontent.com/a/ACg8ocKWZAhOkVrxz3aHHM4ETMd3AqaAqF3vrnn62Xdh_bo-zUSK9w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113736315255358223664/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113736315255358223664/reviews');
SET @user_ivan_miranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113736315255358223664/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Sestovic', 'https://lh3.googleusercontent.com/a/ACg8ocJDVV4a1ZebozWNW6eqoCOfzeVA4aDZv74BoQtJvS9rmxjG3w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103348479223714522334/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103348479223714522334/reviews');
SET @user_mirko_sestovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103348479223714522334/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'KK KK', 'https://lh3.googleusercontent.com/a/ACg8ocLNlcNEiQgIifU23Y85hZiJhmfXQDbL6hs0Id3uOmg5xy6aSQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114878655185492096159/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114878655185492096159/reviews');
SET @user_kk_kk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114878655185492096159/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Šoškić', 'https://lh3.googleusercontent.com/a-/ALV-UjVnA4_lYSQV1QPLacv0fXLA3CCZSkJREDn_mMrTE59mdMGaYYL3=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100266396115415325667/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100266396115415325667/reviews');
SET @user_aleksandra_oki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100266396115415325667/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ilirian Ljuljduraj', 'https://lh3.googleusercontent.com/a/ACg8ocKB1M6FdkZggKbyR4lnmYZNNAX3FLaSnJ7uYd4n4B4hwxDI9Y8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102186146051875487844/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102186146051875487844/reviews');
SET @user_ilirian_ljuljduraj = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102186146051875487844/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nadja Bakovic', 'https://lh3.googleusercontent.com/a/ACg8ocKzqxnv5_Poiy2rf5ICVmFP0bjZC7myXbd7nVUxXa0EhD5z7A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105081950246113303888/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105081950246113303888/reviews');
SET @user_nadja_bakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105081950246113303888/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'M K', 'https://lh3.googleusercontent.com/a-/ALV-UjWQiV2svNG_dWDtVj1K1sX6VjwqWId_eMAYW31gE4wq6GullZ1P=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117454389966974198985/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117454389966974198985/reviews');
SET @user_m_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117454389966974198985/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'V V', 'https://lh3.googleusercontent.com/a/ACg8ocLoyJUKpf0eXyPmSmcJ3IjWMwDytX6epyb1spvUQEXfJZ6VNns2=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118337592656338953261/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118337592656338953261/reviews');
SET @user_v_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118337592656338953261/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mandozica', 'https://lh3.googleusercontent.com/a-/ALV-UjVvQfTij51W_nX3x2EWevVIxQNn4a-Qx1m95ke39qwHkKWlglLJ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110933780404679125417/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110933780404679125417/reviews');
SET @user_mandozica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110933780404679125417/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ana lana', 'https://lh3.googleusercontent.com/a/ACg8ocJspXoIDBQ-xKFJnVlZBmASumU2herEQ1G4MFwY9Mc_EegLPg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111586140763606482065/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111586140763606482065/reviews');
SET @user_ana_lana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111586140763606482065/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena', 'https://lh3.googleusercontent.com/a-/ALV-UjXKyOilHh7omI2iIkxjH0ER6lQJSZaGNQD9ZPm5tBI8ZM_fujM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101132454211295789053/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101132454211295789053/reviews');
SET @user_jelena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101132454211295789053/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocLyQSiXvz7X3WqtMlLA8jIH68MGU32-jtugbHgYzxuwPyczEO4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116981949930770796544/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116981949930770796544/reviews');
SET @user_aleksandra_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116981949930770796544/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorica Sekulovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ5B7p31bFLaecU025wcwtJ7sBOSsVL3tZbWMiAUWcvPn7tjg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108420813140764782859/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108420813140764782859/reviews');
SET @user_zorica_sekulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108420813140764782859/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rada Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocKHgGHYBfS3hd2uSU7QBOGCPuEAdY0SbHladrBbY4fl7xofAQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101078069858560392454/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101078069858560392454/reviews');
SET @user_rada_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101078069858560392454/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojan Ivanović', 'https://lh3.googleusercontent.com/a/ACg8ocI6LNCarSXxvvR_amX6I0WVz8CY_jr6-gb4nyVBqBIxrzlvRA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105037274522874123422/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105037274522874123422/reviews');
SET @user_bojan_ivanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105037274522874123422/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Damjanović', 'https://lh3.googleusercontent.com/a/ACg8ocJ5NwrOLnu8ScDI7kqPZlqkPI-wvW8VInZDU0nAG-tSp4TjHA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117512294946471589835/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117512294946471589835/reviews');
SET @user_jelena_damjanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117512294946471589835/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja Popović', 'https://lh3.googleusercontent.com/a-/ALV-UjXO04_h5WHlIGQSakGwUh81ZJfuyrJTPDLIwyH0DPCveyBCJI8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112220497910881241846/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112220497910881241846/reviews');
SET @user_nemanja_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112220497910881241846/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Mickovic', 'https://lh3.googleusercontent.com/a/ACg8ocLwTl4Pg3-BSvFn4mV6VwxqH_hQ6opZ_d9E4wzyCmtKuJybJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104576861828386231306/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104576861828386231306/reviews');
SET @user_marko_mickovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104576861828386231306/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mila Nenezic', 'https://lh3.googleusercontent.com/a/ACg8ocJJomQ35hLEvfyMnaNKa2BcI7n1V_hOWFh2M54gsP2xrQ8Ivg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110677845520201576587/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110677845520201576587/reviews');
SET @user_mila_nenezic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110677845520201576587/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Došljak', 'https://lh3.googleusercontent.com/a/ACg8ocIWCJWB1A8V28xGekeBcUaZePrf-FXZ4ajONSpBZ7oFsalsVw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115548697491421390466/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115548697491421390466/reviews');
SET @user_sanja_doljak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115548697491421390466/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Iv', 'https://lh3.googleusercontent.com/a-/ALV-UjUD9wEXWyAzTJsjXodoMBRGqT-g5M17upCaGxqe5D1QjDC-0Gvt=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115384152764946736754/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115384152764946736754/reviews');
SET @user_jelena_iv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115384152764946736754/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Mikic', 'https://lh3.googleusercontent.com/a/ACg8ocIAIaT63-RBLIT6tvGktiWDnqVCsUZRkDOpSo8AcBKpx_e3HQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107887361797145768062/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107887361797145768062/reviews');
SET @user_jovana_mikic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107887361797145768062/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'jelena jelena', 'https://lh3.googleusercontent.com/a-/ALV-UjWov--XHiXeVSKDz2OOZ2i7ya-KMuFzUP-u5VfwcFqqtmlBrK8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109717697020585897483/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109717697020585897483/reviews');
SET @user_jelena_jelena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109717697020585897483/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'SpongerBomber', 'https://lh3.googleusercontent.com/a-/ALV-UjUw7SDnyBUWx8aav-P2akBwYXcL6sFY8TM9Y1euiFB-e_qaf0nG=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117587156472811016103/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117587156472811016103/reviews');
SET @user_spongerbomber = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117587156472811016103/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radovan Cirkovic', 'https://lh3.googleusercontent.com/a/ACg8ocItGv3USsj2ZFcKeo1_w2l2VmF-rMAth2U6Wlu5fKwhYouY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100059546876851246661/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100059546876851246661/reviews');
SET @user_radovan_cirkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100059546876851246661/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Pavkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ1Oxt6PfF8XCLUjxR4wJtHpmC6HNWnvlrIUolH-nNNY-wsAQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114531408279168820157/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114531408279168820157/reviews');
SET @user_ivana_pavkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114531408279168820157/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Mihajlovic', 'https://lh3.googleusercontent.com/a/ACg8ocK_bK4bCNUnv0HDYmEZmQno03R7Ar9kkYSoy5ENJUSg84VyuQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101288095655347779687/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101288095655347779687/reviews');
SET @user_ivana_mihajlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101288095655347779687/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lana Andric', 'https://lh3.googleusercontent.com/a/ACg8ocLjCzPX3Gyn52crBRiVrEFD4-2Z1f88phVUjJDznfX0xqFKbg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108311834474536703973/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108311834474536703973/reviews');
SET @user_lana_andric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108311834474536703973/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ana damjanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXS2dAvWvPh1BpQkCDBJdidpyOM12c2ylO8ml-vNcUK0diKKOw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105955689266429235183/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105955689266429235183/reviews');
SET @user_ana_damjanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105955689266429235183/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nebo Backovic', 'https://lh3.googleusercontent.com/a/ACg8ocIMRGCxNe3Ar75R1OL_5lBm4I-lYy5Iy4KuYRBFK7eylnp__g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107300709193498261314/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107300709193498261314/reviews');
SET @user_nebo_backovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107300709193498261314/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miloš Radonjić', 'https://lh3.googleusercontent.com/a/ACg8ocIdlOgxwknJQQPA2JOkB04fXTAR9SJYEvB-NQScVuxmHh3odA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114357228368244612115/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114357228368244612115/reviews');
SET @user_milo_radonji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114357228368244612115/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ema Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ6cwmKpqO5oWdEJY4bzlCXcUke--2hs1uKAn3RddUzdEzkwg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116674427801472006308/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116674427801472006308/reviews');
SET @user_ema_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116674427801472006308/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja Raickovic', 'https://lh3.googleusercontent.com/a/ACg8ocLJaLdIWnJoxkwmigdfB9r41Ig-0V-pDeCuNg_5Ecre-2IBwg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109935901214774685204/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109935901214774685204/reviews');
SET @user_nemanja_raickovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109935901214774685204/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Armelle Anderson', 'https://lh3.googleusercontent.com/a/ACg8ocJkSNMoHOOF2enX78fJrURaWBwadkJT48bc-3FlzaPA0QqGaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116269195750741428728/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116269195750741428728/reviews');
SET @user_armelle_anderson = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116269195750741428728/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Max Clean d.o.o.', 'https://lh3.googleusercontent.com/a/ACg8ocI2r6-EhrD8RRa8yi-_huf9Fe1x9o4gUVUb0yOhb_5hzlP3pw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100162391370677573474/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100162391370677573474/reviews');
SET @user_max_clean_doo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100162391370677573474/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Vuksanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKqXff5TIt1XXHscR2XwvO3AhtW_PXYq6bWwZPofZuZ_LmuVw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108409623187485644220/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108409623187485644220/reviews');
SET @user_vesna_vuksanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108409623187485644220/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Zekovic', 'https://lh3.googleusercontent.com/a/ACg8ocID3ZNnzi1bdHGFSvxT8WN717THHGVOuja5eefc0EiFcE53-w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114752096135113496455/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114752096135113496455/reviews');
SET @user_emir_zekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114752096135113496455/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrija Stamatovic', 'https://lh3.googleusercontent.com/a/ACg8ocLJxIO2AZuM9yPOOZyu7yKFboex-IDoDaWh08Mlk7DdWGizeg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118407348116807271288/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118407348116807271288/reviews');
SET @user_andrija_stamatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118407348116807271288/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana Lakicevic', 'https://lh3.googleusercontent.com/a/ACg8ocJkbISs8lcW6kCDUEoQsXOXyJCaR5AYxQNy1mbJQLP9Lk63h1s=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107312776833979943787/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107312776833979943787/reviews');
SET @user_sladjana_lakicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107312776833979943787/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocL2e7DP-oG0WH615bznQ0U7FdjxqI8EJIkb70K1jsIvp6yfKQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108397209253585216004/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108397209253585216004/reviews');
SET @user_predrag_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108397209253585216004/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocK4vnPcnftg3F5aVonYv8y4dtREwfUN5BjP08__m-wrmUNnBg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114239951660755023205/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114239951660755023205/reviews');
SET @user_dragana_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114239951660755023205/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dusko mrdak', 'https://lh3.googleusercontent.com/a-/ALV-UjU4j5hRzhlQ8nWel3PAGkjS_-_bsnxbiqozbmsReOWEJeN2gEnMPQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117097353409499604643/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117097353409499604643/reviews');
SET @user_dusko_mrdak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117097353409499604643/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Asmir Pepić', 'https://lh3.googleusercontent.com/a-/ALV-UjXA-0D_pC2U10jxbUI_nmwiTDQLiwnOiJBZovId2aJa8zgdMpsE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105610358283092615537/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105610358283092615537/reviews');
SET @user_asmir_pepi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105610358283092615537/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Kandic', 'https://lh3.googleusercontent.com/a/ACg8ocJ4gK-R8vpvjIRwBdSy1TR2Ho2q5FrZIBYlmBvE8uEeBsz69g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113375229488649046178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113375229488649046178/reviews');
SET @user_nikola_kandic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113375229488649046178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Radović Pejović', 'https://lh3.googleusercontent.com/a/ACg8ocLHIhf7JSaU0rOUrxjl82gaE-abgWCc269PxSrZR60V7qyw1A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116367146149479470119/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116367146149479470119/reviews');
SET @user_tamara_radovi_pejovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116367146149479470119/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Đorđije Dabović', 'https://lh3.googleusercontent.com/a/ACg8ocIYZkcV715lDHhH4jd1_y-LbPJwcowwRWzGeipwvqng9epPKgY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104626547218416628541/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104626547218416628541/reviews');
SET @user_orije_dabovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104626547218416628541/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Tepsa', 'https://lh3.googleusercontent.com/a-/ALV-UjWkY4VqjPa-RQww6jONCqZOCeuTpoN7XLKnIEVWBhMTu4FS-MQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117920864808546631726/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117920864808546631726/reviews');
SET @user_predrag_tepsa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117920864808546631726/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tatijana Begovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUFahmJW8feUbaJeFIHy9Fhz2xrBAeLhdWdQhPx7TJfDOVj1Zg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109207098175339768200/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109207098175339768200/reviews');
SET @user_tatijana_begovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109207098175339768200/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ella Mubis', 'https://lh3.googleusercontent.com/a-/ALV-UjXXKtSl3qsDVH-9Wma9EQ9aZJLUpKhzLdbRY091qwRlVs-Wyu_7yg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117147748992935875980/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117147748992935875980/reviews');
SET @user_ella_mubis = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117147748992935875980/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Vasovic', 'https://lh3.googleusercontent.com/a/ACg8ocIedcHh2AkvRVIrYV9vOgCJa1XeGHncqv-T4lRzGz3uGo4yYg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106426751405067822142/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106426751405067822142/reviews');
SET @user_milos_vasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106426751405067822142/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladan Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocIwF-RXbPRWwydEMgO946pGMcLas_nu9HS7ynLAJKBei80UBQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118102184537399651574/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118102184537399651574/reviews');
SET @user_vladan_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118102184537399651574/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bozidar ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLv13sMJ7el9Lg7NJLxyAUORpw7huNuQNbbnUyLnWVyyes8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117929554812823303107/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117929554812823303107/reviews');
SET @user_bozidar_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117929554812823303107/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miroslav Vešović', 'https://lh3.googleusercontent.com/a/ACg8ocK8_6n0Fw-ipzBXpm8ILstzxFG2aM0DA7XMj3X5Xd3nmOLvQA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103636082137497068870/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103636082137497068870/reviews');
SET @user_miroslav_veovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103636082137497068870/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Popović', 'https://lh3.googleusercontent.com/a-/ALV-UjXsRBEQG9thbwi0cPubJ9-8uEbkOb-5o_8h4vm5HEwyCjIUzqoT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105102747339945417884/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105102747339945417884/reviews');
SET @user_marko_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105102747339945417884/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Misurovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXbqCizsR06LAbACLC0TS0QTc7pUqnacHBBMB1EyXPzFXBSICZZUQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103650222451585945695/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103650222451585945695/reviews');
SET @user_tamara_misurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103650222451585945695/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nada rasovic', 'https://lh3.googleusercontent.com/a/ACg8ocJwcIi-7bzxyHdUQyAs8jFbq5X7BUZ0BpO81qBU9JhH8QFmXA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113687946276168823459/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113687946276168823459/reviews');
SET @user_nada_rasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113687946276168823459/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Stojanović', 'https://lh3.googleusercontent.com/a-/ALV-UjXzZPB1mTnAiSOpQLQAkSTmS5KgWTW63iDwSPm-YBBMUiZXxljE=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112975527586580668507/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112975527586580668507/reviews');
SET @user_milan_stojanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112975527586580668507/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Milović', 'https://lh3.googleusercontent.com/a-/ALV-UjW4f-InFPSMYY9GghuGKV4GfkBFpgdvm0LA0R7gfCQXosC0vl9N=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105559899438519546994/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105559899438519546994/reviews');
SET @user_danijela_milovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105559899438519546994/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'brano cicarevic', 'https://lh3.googleusercontent.com/a-/ALV-UjV9wDe14IsNpLHko5aZnwTSV5NtzG025dTeBmhXzRfk8AfEjD--=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112926928263739548107/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112926928263739548107/reviews');
SET @user_brano_cicarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112926928263739548107/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tomo Begovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWbjxKNHUrjVl_5j5xua8JSGmdf_qT1zUef1Qf9f_y1OQPKICkm=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110830396927590591960/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110830396927590591960/reviews');
SET @user_tomo_begovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110830396927590591960/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rada Popović', 'https://lh3.googleusercontent.com/a/ACg8ocK82gR0IUALXipFU66-HHiURo5FvJc_cWwWVs-aXLCMCevQkQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106496125340381274018/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106496125340381274018/reviews');
SET @user_rada_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106496125340381274018/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasna Maras', 'https://lh3.googleusercontent.com/a/ACg8ocKcX6hxnnNd_kR3mv6pA8Hj-Zn4LNIHesj7TTQk0SfciuSbnQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116274948157018890548/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116274948157018890548/reviews');
SET @user_jasna_maras = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116274948157018890548/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radonja Zekovic', 'https://lh3.googleusercontent.com/a/ACg8ocIFccO7CGh3Iratmz34AcoppqyTh3Ttgvwk6U6M3zalDpJ8WQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106627280889745616106/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106627280889745616106/reviews');
SET @user_radonja_zekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106627280889745616106/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan S.', 'https://lh3.googleusercontent.com/a/ACg8ocJt3E0sWV5NOrprEPPs0HoMah3PX1XlEnY1aZ5nrPT78mXEbA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105140573398657567513/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105140573398657567513/reviews');
SET @user_milan_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105140573398657567513/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_danijela_goovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaNGMzUTVlRE5RUmtaRFRGOVdTbEpGYzFwVVZIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-03 00:00:00'),

(@user_dunja_obradovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psNmFWWmpRVkExYW04eldETm1SV3gwWjBGNGRrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-03 00:00:00'),

(@user_andrija_vulic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pjd05VbzJXRzB0VDJONFlsSXRaazVQUTBabWQxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_danijel_colovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WaFNsQllVR1JmVm01VGRVaENXVzVVTUMxc2RtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_tijana_klikovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsQmEyWnJOMWcxVnpkS05YWTNWazB6VTFWdFZYYxAB',
    5, 'bs', 'Preljubazno osoblje,sve zavrseno u sto kracem roku❤️',
    'Preljubazno osoblje,sve zavrseno u sto kracem roku❤️', 'Прељубазно особље, све завршено у што краћем року❤️', 'Extremely kind staff, everything finished as quickly as possible❤️', 'Очень любезный персонал, всё сделали в кратчайшие сроки❤️', 'Sehr freundliches Personal, alles in kürzester Zeit erledigt❤️', 'Son derece nazik personel, her şey en kısa sürede tamamlandı❤️',
    0, '2026-08-27 00:00:00'),

(@user_savic_medenica, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT210NVNUQnZTelZMUkVsdGRYTm9lbmR6TmpReE1FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_andjela_abazovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xNeWFWY3dXR3B5UjFwTk5tbzJZVVI1Y2t0Qk5XYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_milica_golubovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5Uk4zTTBaMVpwY1V4bVlXbEZURFJxWmpOd1RGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_bra_zel, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KMlFUWnhVblZIWW1OSmJETkZiWEJRVmtoWlJIYxAB',
    5, 'en', 'Super 🙏🏻 …',
    'Super 🙏🏻 …', 'Супер 🙏🏻 …', 'Super 🙏🏻 …', 'Супер 🙏🏻 …', 'Super 🙏🏻 …', 'Süper 🙏🏻 …',
    0, '2026-08-27 00:00:00'),

(@user_milan_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paTWFVMTRlVUp3VTJGc2NVSkNTRzFrU1dkZmEzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_ana_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25CWlFYbHZhR0YzVDJWWE5sTlBiR2RtUjJwM2IwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_gordana_grbic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xnMWJ6SlZOMHhHVjBVMkxYVjJTbVV6WVU5c2NGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_ulqin_samsung, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WblJGSTNiM0pITUZsYVRISlNhVzUxYjNReFltYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-27 00:00:00'),

(@user_vesna_korovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wRGQzZFZkWEpvZG5oelppMWxRWFE0UjFKWk0wRRAB',
    5, 'bs', 'Ljubazno osoblje, profesionalan i stručan tehničar na MR-u, lokacija laka za pronaći, sve preporuke.',
    'Ljubazno osoblje, profesionalan i stručan tehničar na MR-u, lokacija laka za pronaći, sve preporuke.', 'Љубазно особље, професионалан и стручан техничар на МР-у, локација лака за пронаћи, све препоруке.', 'Kind staff, a professional and skilled MRI technician, the location is easy to find, fully recommended.', 'Любезный персонал, профессиональный и грамотный техник на МРТ, локацию легко найти, всем рекомендую.', 'Freundliches Personal, ein professioneller und kompetenter MRT-Techniker, der Standort ist leicht zu finden, absolut empfehlenswert.', 'Nazik personel, profesyonel ve bilgili MR teknikeri, konumu bulmak kolay, herkese tavsiye ederim.',
    0, '2026-08-27 00:00:00'),

(@user_irina_saveleva, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWUFRsSlJhR2d4ZEhoWmRtZDVNRzVDWmpCMGEwRRAB',
    5, 'ru', 'Прекрасная клиника. Записывалась через инстаграм, предложили самое удобное время для меня. Процедура (МРТ) была быстрой и комфортной! Благодарю персонал за доброе отношение!',
    'Divna klinika. Termin sam zakazala preko Instagrama, ponudili su mi najpogodnije vrijeme. Pregled (MR) je bio brz i komforan! Hvala osoblju na ljubaznom pristupu!', 'Дивна клиника. Термин сам заказала преко Instagrama, понудили су ми најпогодније вријеме. Преглед (МР) је био брз и комфоран! Хвала особљу на љубазном приступу!', 'A wonderful clinic. I booked through Instagram and they offered me the most convenient time. The procedure (MRI) was quick and comfortable! Thank you to the staff for their kind attitude!', 'Прекрасная клиника. Записывалась через инстаграм, предложили самое удобное время для меня. Процедура (МРТ) была быстрой и комфортной! Благодарю персонал за доброе отношение!', 'Eine wunderbare Klinik. Ich habe über Instagram einen Termin gebucht, und man hat mir die günstigste Zeit angeboten. Die Untersuchung (MRT) war schnell und angenehm! Danke an das Personal für die freundliche Behandlung!', 'Harika bir klinik. Instagram üzerinden randevu aldım, bana en uygun saati önerdiler. İşlem (MR) hızlı ve konforluydu! Nazik yaklaşımları için personele teşekkür ederim!',
    0, '2026-08-27 00:00:00'),

(@user_ljiljana_blagojevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCaVMzZGhkMGhqYzJGcmJraGhlVWcwYjBWS1ozYxAB',
    5, 'bs', 'Ljubazno i profesionalno  osoblje,savremena oprema,korektne cijene,za svaku preporuku!',
    'Ljubazno i profesionalno  osoblje,savremena oprema,korektne cijene,za svaku preporuku!', 'Љубазно и професионално особље, савремена опрема, коректне цијене, за сваку препоруку!', 'Kind and professional staff, modern equipment, fair prices — highly recommended!', 'Любезный и профессиональный персонал, современное оборудование, корректные цены — рекомендую!', 'Freundliches und professionelles Personal, moderne Ausstattung, faire Preise — sehr empfehlenswert!', 'Nazik ve profesyonel personel, modern ekipman, uygun fiyatlar — kesinlikle tavsiye ederim!',
    0, '2026-08-27 00:00:00'),

(@user_milos_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0aVRub3RNMlZFY2s0emJrTmtWM1ZVWkROdk5IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_tanja_scekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT201Q1VteElabk5VZFMxWVRETldkWGRQTFRoTmVGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_diko_jevremovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tONVYyVm1UR3MyTmpkRE5HSlVRVm80YkdsQmJrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_milos_rakic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT20wMlpXdG1lbXBTWVV0SldFSkhWemd0TUZKa2NVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_branka_stijepovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KTFlteDBlbnBaTWpCalpYSllVR3d3VGtOa1VtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_auto_servis, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oV1pWQkZUamhYUlc1cldtWkVkbkIwYUVwVU5VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_esma_erovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSWk5YSkpZWGR3ZFhoNFh6TlFlblJHWlVkWVVsRRAB',
    5, 'hr', 'ljubazna usluga, brzo i efikasno',
    'ljubazna usluga, brzo i efikasno', 'љубазна услуга, брзо и ефикасно', 'friendly service, quick and efficient', 'любезное обслуживание, быстро и эффективно', 'freundlicher Service, schnell und effizient', 'nazik hizmet, hızlı ve verimli',
    0, '2026-08-20 00:00:00'),

(@user_elida_eo, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoTWVVNDJTMUUxY0RSdk5uQm9kVlJPUnpaNlZVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_ali_salih, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xOclpFUTBla3huWVdWdlRXRmhaRFptZG1SelExRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-20 00:00:00'),

(@user_lena_ulicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5dVFWTllSekpqUVdkMmFIWjBURGxDWm00eE1GRRAB',
    5, 'hr', 'Stručno i ljubazno osoblje!',
    'Stručno i ljubazno osoblje!', 'Стручно и љубазно особље!', 'Professional and kind staff!', 'Грамотный и любезный персонал!', 'Kompetentes und freundliches Personal!', 'Bilgili ve nazik personel!',
    0, '2026-08-13 00:00:00'),

(@user_sara_micanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xNelNsSnFlWHBOU1hSNFZHTkdkMXBZVkZOZk9HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-13 00:00:00'),

(@user_zoran_basanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21FeldERk9RMkk1WlhvNGFUTjZRamxNTXpCc09GRRAB',
    5, 'hr', 'Odlicna i brza usluga, sve pohvale',
    'Odlicna i brza usluga, sve pohvale', 'Одлична и брза услуга, све похвале', 'Excellent and fast service, all praise', 'Отличное и быстрое обслуживание, все похвалы', 'Ausgezeichneter und schneller Service, nur Lob', 'Mükemmel ve hızlı hizmet, her şey için övgü',
    0, '2026-08-13 00:00:00'),

(@user_igor_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT201WmFsTldNWFZ4V2tKRFNYTlpVWGhHVVRrNVRsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-13 00:00:00'),

(@user_milena_simievi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJd1kzRTVObEp1UVRWTldFOWxRV1IzVERWZlZrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-13 00:00:00'),

(@user_mirela_sljivancanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGdmNFZGlNV28zTWtaVlFXUlhiV3RaUTNKUmVWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-13 00:00:00'),

(@user_jovana_dzankic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkMWF6UjFTazB0WldodmJsTXdjVzFIVDFwaE1tYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-13 00:00:00'),

(@user_dusan_vujovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT205Q1UxVkpRVFI1WWtkMmJVRndWbTkwVDJOQmJHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-13 00:00:00'),

(@user_selma_softic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pJd1NrSktPRXd5TVMxdFNrWlJZbm8xZGtGb2VrRRAB',
    5, 'hr', 'Cijelo osoblje je izuzetno ljubazno, profesionalno i susretljivo. Od samog prijema pa do pregleda osjećali smo se opušteno i u sigurnim rukama. Topla preporuka svima kojima je potrebna radiološka dijagnostika.',
    'Cijelo osoblje je izuzetno ljubazno, profesionalno i susretljivo. Od samog prijema pa do pregleda osjećali smo se opušteno i u sigurnim rukama. Topla preporuka svima kojima je potrebna radiološka dijagnostika.', 'Цијело особље је изузетно љубазно, професионално и сусретљиво. Од самог пријема па до прегледа осјећали смо се опуштено и у сигурним рукама. Топла препорука свима којима је потребна радиолошка дијагностика.', 'The entire staff is exceptionally kind, professional and helpful. From admission right through to the examination we felt relaxed and in safe hands. Warmly recommended to anyone who needs radiological diagnostics.', 'Весь персонал исключительно любезный, профессиональный и отзывчивый. С самого приёма и до обследования мы чувствовали себя спокойно и в надёжных руках. Тепло рекомендую всем, кому нужна радиологическая диагностика.', 'Das ganze Personal ist außerordentlich freundlich, professionell und hilfsbereit. Von der Aufnahme bis zur Untersuchung fühlten wir uns entspannt und in sicheren Händen. Eine herzliche Empfehlung an alle, die eine radiologische Diagnostik brauchen.', 'Tüm personel son derece nazik, profesyonel ve yardımsever. Kayıttan muayeneye kadar kendimizi rahat ve güvende hissettik. Radyolojik teşhise ihtiyacı olan herkese içtenlikle tavsiye ederim.',
    0, '2026-08-06 00:00:00'),

(@user_softic_elvis, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKeGNXNXVNSGgyVkRWVlgxaExOM1Z3TTE5VVkyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-06 00:00:00'),

(@user_biljana_leovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaVlJUZExhM2hpU3pabFFYWjRSMFV0TFVRMFYyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_sanja_dragas, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xJeGFIaENPRUpNTlc1cWRuRkhaMnRRZEU5UE5XYxAB',
    5, 'hr', 'Veoma ljubazno i stručno osoblje. Sve pohvale. Svaka čast!!!',
    'Veoma ljubazno i stručno osoblje. Sve pohvale. Svaka čast!!!', 'Веома љубазно и стручно особље. Све похвале. Свака част!!!', 'Very kind and professional staff. All praise. Well done!!!', 'Очень любезный и грамотный персонал. Все похвалы. Респект!!!', 'Sehr freundliches und kompetentes Personal. Nur Lob. Alle Achtung!!!', 'Çok nazik ve bilgili personel. Her şey için övgü. Helal olsun!!!',
    0, '2026-08-03 00:00:00'),

(@user_ivan_miranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25vMVgyVTBTSEI2T0doeFdVSkVkMVZtT0dKU1VVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_mirko_sestovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwS1MwZFlNMWs0WW1KSmF6RlFWRFJxU205dU5HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_kk_kk, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwNFVYUlFaMVEwTjI5RVlVOVVNRFo2U0dweVUxRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_aleksandra_oki, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxS1Eyd3hhR2hHVTJOd01DMTFhRXhVVW1sd2JVRRAB',
    5, 'bs', 'Srdačna preporuka, pogotovo za klaustrofobične pacijente, da ne brinu i da ne odlažu 😉 Veliki RESPECT! 🙌💘💘💘 …',
    'Srdačna preporuka, pogotovo za klaustrofobične pacijente, da ne brinu i da ne odlažu 😉 Veliki RESPECT! 🙌💘💘💘 …', 'Срдачна препорука, поготово за клаустрофобичне пацијенте, да не брину и да не одлажу 😉 Велики RESPECT! 🙌💘💘💘 …', 'A heartfelt recommendation, especially for claustrophobic patients — don\'t worry and don\'t put it off 😉 Big RESPECT! 🙌💘💘💘 …', 'Сердечно рекомендую, особенно клаустрофобным пациентам — не переживайте и не откладывайте 😉 Большой RESPECT! 🙌💘💘💘 …', 'Eine herzliche Empfehlung, besonders für klaustrophobische Patienten — keine Sorge und nicht aufschieben 😉 Großer RESPECT! 🙌💘💘💘 …', 'Özellikle klostrofobik hastalara içtenlikle tavsiye ederim — endişelenmeyin ve ertelemeyin 😉 Büyük RESPECT! 🙌💘💘💘 …',
    0, '2026-08-03 00:00:00'),

(@user_ilirian_ljuljduraj, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkVFRXVXhRMUJwZUZkelQyaHFaa1JsUlVGNWFrRRAB',
    5, 'en', 'The staff is very friendly and welcoming!
They took good care of us',
    'Osoblje je veoma ljubazno i gostoprimljivo!
Dobro su se pobrinuli za nas', 'Особље је веома љубазно и гостопримљиво!
Добро су се побринули за нас', 'The staff is very friendly and welcoming!
They took good care of us', 'Персонал очень дружелюбный и приветливый!
О нас хорошо позаботились', 'Das Personal ist sehr freundlich und einladend!
Man hat sich gut um uns gekümmert', 'Personel çok cana yakın ve misafirperver!
Bizimle çok iyi ilgilendiler',
    0, '2026-08-03 00:00:00'),

(@user_nadja_bakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xFd2JXNWpiRWhGVjNjd1VsZDRjRFpQYjFkclFWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_m_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCMVptaGphMEZKUlUxalJuRjVSVkZXWlhCdWNIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_v_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOa1NEQm9PRUUwTlRkMFVrUnhUVVZIV2psdFRGRRAB',
    5, 'bs', 'Zaista ljubazno osoblje, čisto, uredno, prijatan  ambijent.
Lako se pronalazi lokacija.
Prilikom rada MR-a trude se da snimanje učine što prijatnijim.',
    'Zaista ljubazno osoblje, čisto, uredno, prijatan  ambijent.
Lako se pronalazi lokacija.
Prilikom rada MR-a trude se da snimanje učine što prijatnijim.', 'Заиста љубазно особље, чисто, уредно, пријатан амбијент.
Лако се проналази локација.
Приликом рада МР-а труде се да снимање учине што пријатнијим.', 'Really kind staff, clean, tidy, pleasant surroundings.
The location is easy to find.
During the MRI scan they do their best to make the imaging as pleasant as possible.', 'Действительно любезный персонал, чисто, аккуратно, приятная атмосфера.
Локацию легко найти.
Во время МРТ стараются сделать процедуру максимально приятной.', 'Wirklich freundliches Personal, sauber, ordentlich, angenehmes Ambiente.
Der Standort ist leicht zu finden.
Während der MRT-Aufnahme geben sie sich Mühe, die Untersuchung so angenehm wie möglich zu machen.', 'Gerçekten nazik personel, temiz, düzenli, hoş bir ortam.
Konumu bulmak kolay.
MR çekimi sırasında görüntülemeyi olabildiğince rahat hale getirmeye çalışıyorlar.',
    0, '2026-08-03 00:00:00'),

(@user_mandozica, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoM1dtTXlSbkpCZFZJM1ZWRkJORkJ6VEVwemNVRRAB',
    5, 'hr', 'Sjajna klinika sa veoma ljubaznim osobljem, pogotovo nasmijana, harizmatična i pozitivna Vanja Matović. Sve preporuke.',
    'Sjajna klinika sa veoma ljubaznim osobljem, pogotovo nasmijana, harizmatična i pozitivna Vanja Matović. Sve preporuke.', 'Сјајна клиника са веома љубазним особљем, поготово насмијана, харизматична и позитивна Вања Матовић. Све препоруке.', 'A great clinic with very kind staff, especially the smiling, charismatic and positive Vanja Matović. Fully recommended.', 'Прекрасная клиника с очень любезным персоналом, особенно улыбчивая, харизматичная и позитивная Vanja Matović. Всем рекомендую.', 'Eine großartige Klinik mit sehr freundlichem Personal, besonders die lächelnde, charismatische und positive Vanja Matović. Absolut empfehlenswert.', 'Çok nazik personeli olan harika bir klinik, özellikle güler yüzlü, karizmatik ve pozitif Vanja Matović. Herkese tavsiye ederim.',
    0, '2026-08-03 00:00:00'),

(@user_ana_lana, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKVWJuZEdiMVZMWW00dGNFaEhRMk0xZGtoV2RWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_jelena, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21ka1FsWmZSbW8yY1cxZlJsbHJZa05uZFU5Sk5YYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_aleksandra_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25vek0xcHFSa3RoTTNOWVoxRlNTbWhLVGpKRlNuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_zorica_sekulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4TVducFVlR3d6Wm1ka00xVkZURWhoTmtkd1duYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-03 00:00:00'),

(@user_rada_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GeVZVVXdabUo2VEdOU2VuRnZjazVQYVdRemFFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_bojan_ivanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoUE4wcFVWa2xSVFhGbloyODNRMEZYY0d4MFVuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_jelena_damjanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Nd2FEWTJabkpCVERSdkxYRmZPRk5KYTBGRlYyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_nemanja_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tacldVdG9WWE5hT0RaeFUyOXRiMHhWZDFwTE5YYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_marko_mickovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xFNVgyWTRYMk13WDJZMmVsbHhRazQzUTBvd1NGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_mila_nenezic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsT2ExOHpUbmxzZEhwSVQyRkZOV3hMYWxCRE9FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_sanja_doljak, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOWVF6TnhVVU5mTlZFd1YxYzJUR2hIYjBVMVYwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_jelena_iv, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kSk0wSjNlRGxoTkc5RlZYRlZiamt6ZWtkT2QwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-03 00:00:00'),

(@user_jovana_mikic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ST2ExZGxibHA1V25ab1NDMVZNSEpMT0VkUk5sRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_jelena_jelena, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aYWQwUmxPWHBtTTA1QlJXZHpNME5pYnpjeVpWRRAB',
    5, 'hr', 'Sve pohvale 🙂
Doktorica Mirela Kalic strucna i preljubazna.
Svo osoblje je predivno. …',
    'Sve pohvale 🙂
Doktorica Mirela Kalic strucna i preljubazna.
Svo osoblje je predivno. …', 'Све похвале 🙂
Докторица Мирела Калић стручна и прељубазна.
Сво особље је предивно. …', 'All praise 🙂
Dr Mirela Kalić is skilled and extremely kind.
The whole staff is wonderful. …', 'Все похвалы 🙂
Доктор Mirela Kalić — грамотная и очень любезная.
Весь персонал прекрасный. …', 'Nur Lob 🙂
Die Ärztin Mirela Kalić ist kompetent und ausgesprochen freundlich.
Das ganze Personal ist wunderbar. …', 'Her şey için övgü 🙂
Doktor Mirela Kalić bilgili ve son derece nazik.
Tüm personel harika. …',
    1, '2026-06-03 00:00:00'),

(@user_spongerbomber, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGTFpVY3lhRXcxY1daVlpGUkZaMVl5VTJveVYyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_radovan_cirkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxTmRteFNRVzB0WTFGRFRsaDBTMWx5ZG5jelgwRRAB',
    5, 'bs', 'Veoma odgovorna i profesionalna klinika. Usluga i ljubaznost na najvecem nivou!!!',
    'Veoma odgovorna i profesionalna klinika. Usluga i ljubaznost na najvecem nivou!!!', 'Веома одговорна и професионална клиника. Услуга и љубазност на највећем нивоу!!!', 'A very responsible and professional clinic. Service and kindness at the highest level!!!', 'Очень ответственная и профессиональная клиника. Обслуживание и любезность на высшем уровне!!!', 'Eine sehr verantwortungsvolle und professionelle Klinik. Service und Freundlichkeit auf höchstem Niveau!!!', 'Çok sorumlu ve profesyonel bir klinik. Hizmet ve nezaket en üst düzeyde!!!',
    1, '2026-06-03 00:00:00'),

(@user_ivana_pavkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25JNVRYSnVVbFJ3YkhjMFVFSTVWbDlGTW5jek5VRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_ivana_mihajlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOU1dEVkhWR0oxT0RneGNHeG1OVjlSZURkclYyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_lana_andric, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tZMmVWTTFNV3RvUmxkcE1FTnVMVTl2VjB3NWVFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_ana_damjanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKQ2JpMXRVbUk0UW10TmEzcFhVRkZ2VFRCalZuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_nebo_backovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25keVpGRk5OWHAzWjJacVRYTjRVV3RWU2tKbWRtYxAB',
    5, 'hr', 'kompletno osoblje ima posebnu energiju !!!
Sve pohvale !',
    'kompletno osoblje ima posebnu energiju !!!
Sve pohvale !', 'комплетно особље има посебну енергију !!!
Све похвале !', 'the whole staff has a special energy !!!
All praise !', 'у всего персонала особая энергетика !!!
Все похвалы !', 'das gesamte Personal hat eine besondere Energie !!!
Nur Lob !', 'tüm personelin özel bir enerjisi var !!!
Her şey için övgü !',
    0, '2026-06-03 00:00:00'),

(@user_milo_radonji, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WclFsVm1aVlZzYkhKVFNtczVSRXRTUkhnMVowRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-03 00:00:00'),

(@user_ema_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKa1FUVnhOM1J2VDA0dFZXRjNZV3c1ZGxaTWVFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_nemanja_raickovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOTlduWmZUaTFFV1hwc2JUTm5OVVJSVEZoRmFXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_armelle_anderson, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pRNFVFRTRPWHA1VkRaRGVXUkxWVEpSZVRrME1uYxAB',
    5, 'en', 'Excellent communication, nice people. Amazing time here',
    'Odlična komunikacija, dragi ljudi. Sjajno iskustvo ovdje', 'Одлична комуникација, драги људи. Сјајно искуство овдје', 'Excellent communication, nice people. Amazing time here', 'Отличная коммуникация, приятные люди. Замечательно провели время здесь', 'Ausgezeichnete Kommunikation, nette Menschen. Eine wunderbare Zeit hier', 'Mükemmel iletişim, hoş insanlar. Burada harika bir deneyim',
    0, '2026-05-03 00:00:00'),

(@user_max_clean_doo, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OWmJIZDVRMDVuTWtobk1ITlpRMnN5VkcwMVNWRRAB',
    5, 'hr', 'Profesionalno i tacno.
Sve pohvale i preporuke.',
    'Profesionalno i tacno.
Sve pohvale i preporuke.', 'Професионално и тачно.
Све похвале и препоруке.', 'Professional and punctual.
All praise and recommendations.', 'Профессионально и точно.
Все похвалы и рекомендации.', 'Professionell und pünktlich.
Nur Lob und Empfehlungen.', 'Profesyonel ve dakik.
Her şey için övgü ve tavsiye.',
    0, '2026-05-03 00:00:00'),

(@user_vesna_vuksanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkR2VHNWpSbU5yTjBrNGJDMXZhbWx3UWtORE5WRRAB',
    5, 'hr', 'Ljubazno osoblje,MR aparat komforan.Sve preporuke.🤗 …',
    'Ljubazno osoblje,MR aparat komforan.Sve preporuke.🤗 …', 'Љубазно особље, МР апарат комфоран. Све препоруке.🤗 …', 'Kind staff, the MRI machine is comfortable. Fully recommended.🤗 …', 'Любезный персонал, аппарат МРТ комфортный. Всем рекомендую.🤗 …', 'Freundliches Personal, das MRT-Gerät ist komfortabel. Absolut empfehlenswert.🤗 …', 'Nazik personel, MR cihazı konforlu. Herkese tavsiye ederim.🤗 …',
    0, '2026-05-03 00:00:00'),

(@user_emir_zekovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOSVVVaG9kV2x0YWtkbVlXRmxWMmwyVDNreU1tYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_andrija_stamatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xrNFFYVlRTVVpDWWxCVk4yUXRVRkpSZDFSMVluYxAB',
    5, 'bs', 'Topla preporuka svima kojima je potrebna pouzdana i profesionalna radiološka dijagnostika.',
    'Topla preporuka svima kojima je potrebna pouzdana i profesionalna radiološka dijagnostika.', 'Топла препорука свима којима је потребна поуздана и професионална радиолошка дијагностика.', 'Warmly recommended to anyone who needs reliable and professional radiological diagnostics.', 'Тепло рекомендую всем, кому нужна надёжная и профессиональная радиологическая диагностика.', 'Eine herzliche Empfehlung an alle, die eine zuverlässige und professionelle radiologische Diagnostik brauchen.', 'Güvenilir ve profesyonel radyolojik teşhise ihtiyacı olan herkese içtenlikle tavsiye ederim.',
    0, '2026-05-03 00:00:00'),

(@user_sladjana_lakicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25FdFUwRlhZa2htYmxWbk5tUkJZVXcxVHpKR05GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_predrag_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT210UU9HSnZkR00wVFdFeFptOVpSVWRuY0U1aU9HYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_dragana_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSeVJ6UTNXVkZLVTBzd1lYRTFSMVI0YjJkc05YYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_dusko_mrdak, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4UFFtdDRWa0ZwVDNSdFVYaEJkVkpqZUZwMmJWRRAB',
    5, 'bs', 'Dunja je odlicna!',
    'Dunja je odlicna!', 'Дуња је одлична!', 'Dunja is excellent!', 'Dunja — отличная!', 'Dunja ist ausgezeichnet!', 'Dunja harika!',
    0, '2026-05-03 00:00:00'),

(@user_asmir_pepi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xjeFQyMUZhbVpJTjJob0xYSmhhV2Q0UkU1a1lsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_nikola_kandic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWdlFUaFFTMDEwWWxSVlNVUlFkR2xSVFRkTWJVRRAB',
    5, 'hr', 'Profesionalna usluga!
Za svaku pohvalu!',
    'Profesionalna usluga!
Za svaku pohvalu!', 'Професионална услуга!
За сваку похвалу!', 'Professional service!
Deserves every praise!', 'Профессиональное обслуживание!
Все похвалы!', 'Professioneller Service!
Jedes Lob wert!', 'Profesyonel hizmet!
Her türlü övgüye değer!',
    0, '2026-05-03 00:00:00'),

(@user_tamara_radovi_pejovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KT2RVZE1UbGQyY21kWlptTjNiVlUzYTJaV1pWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_orije_dabovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxbmJGZExWSFpMWVdOT05XcEpRV2t0U21aamMwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_predrag_tepsa, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21Sd2RWWklORnB0UTFSS05FVjJlREppTmpkVE1WRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_tatijana_begovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psZmRqQlBVVFJ3UmtOelIyeE9RMUZyYW0xVWIxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_ella_mubis, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GcFlrNDRlbE4wUzJkWFIxOVlkbk4yTVZKWmVrRRAB',
    5, 'hr', 'Ljubazni najbolji puno srece u radu',
    'Ljubazni najbolji puno srece u radu', 'Љубазни, најбољи, пуно среће у раду', 'Kind, the best, much success in your work', 'Любезные, самые лучшие, удачи в работе', 'Freundlich, die Besten, viel Erfolg bei der Arbeit', 'Nazik, en iyiler, işlerinizde bol şans',
    1, '2026-05-03 00:00:00'),

(@user_milos_vasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGblJFazNNRUpWU1RSV2RrTnpNa0Z4V0RkamJHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_vladan_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT21Zd2MwbGZWVEV0TjNSRE9XRllRWE5KTWpKTlVIYxAB',
    5, 'hr', 'Sve pohvale za osoblje i uslugu! Izuzetno ljubazni, profesionalni i organizovani. Osjećaj sigurnosti i brige od prvog trenutka!!',
    'Sve pohvale za osoblje i uslugu! Izuzetno ljubazni, profesionalni i organizovani. Osjećaj sigurnosti i brige od prvog trenutka!!', 'Све похвале за особље и услугу! Изузетно љубазни, професионални и организовани. Осјећај сигурности и бриге од првог тренутка!!', 'All praise for the staff and the service! Exceptionally kind, professional and organised. A feeling of safety and care from the very first moment!!', 'Все похвалы персоналу и обслуживанию! Исключительно любезные, профессиональные и организованные. Ощущение безопасности и заботы с первой минуты!!', 'Nur Lob für das Personal und den Service! Außerordentlich freundlich, professionell und organisiert. Ein Gefühl von Sicherheit und Fürsorge vom ersten Moment an!!', 'Personel ve hizmet için her şey için övgü! Son derece nazik, profesyonel ve organize. İlk andan itibaren güven ve ilgi hissi!!',
    1, '2026-05-03 00:00:00'),

(@user_bozidar_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoUk9FTllTamN4WHkxRFgwaElXV1poVXpocVpFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_miroslav_veovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT201bE5IQlhiek15T1dweGIyVmlTR2hpTVdkWk5tYxAB',
    5, 'hr', 'Sve je extra. Od usluge, stručnosti, ljubaznosti, tehnologije...ali što je direktorica gospoče 👌🏽👍🏽 …',
    'Sve je extra. Od usluge, stručnosti, ljubaznosti, tehnologije...ali što je direktorica gospoče 👌🏽👍🏽 …', 'Све је екстра. Од услуге, стручности, љубазности, технологије...али што је директорица госпоче 👌🏽👍🏽 …', 'Everything is top notch. The service, the expertise, the kindness, the technology... and what a lady the director is 👌🏽👍🏽 …', 'Всё супер. И обслуживание, и профессионализм, и любезность, и технологии... а какая же дама директор 👌🏽👍🏽 …', 'Alles ist top. Vom Service über die Fachkompetenz und Freundlichkeit bis zur Technik ... und was für eine Dame die Direktorin ist 👌🏽👍🏽 …', 'Her şey mükemmel. Hizmet, uzmanlık, nezaket, teknoloji... ve müdür ne hanımefendi 👌🏽👍🏽 …',
    0, '2026-05-03 00:00:00'),

(@user_marko_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4U2VsUk1Va010VURGR1MwUkNWMkpJTFVkWGVWRRAB',
    5, 'en', '👍 …',
    '👍 …', '👍 …', '👍 …', '👍 …', '👍 …', '👍 …',
    0, '2026-05-03 00:00:00'),

(@user_tamara_misurovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KTWEyMDFkMVYyYmpCbmNrZ3pjRkZXYzJnM05tYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-03 00:00:00'),

(@user_nada_rasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSVlNsRkdjMlF5Y3pReVZHUkdZeTFqVUVGRlRuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-03 00:00:00'),

(@user_milan_stojanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkak1GbEpNWEZ4WHpVNVNrOVZlV1prZFRCRFoyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-03 00:00:00'),

(@user_danijela_milovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWSVRVUjNWek5PTUVkcmRGTTFhazAyYUV0UFZuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-03 00:00:00'),

(@user_brano_cicarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paaU1EaDZaRUZFUVdweWJXNXVkazExVFZOQ1gwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-03 00:00:00'),

(@user_tomo_begovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxSE56VTBXREpOWm1vNVJFd3lUWGxUYkZOTE5uYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-03 00:00:00'),

(@user_rada_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oeVMwcFlOVXBQWDBjeE9YRXRSM0ZWYzAxWE5XYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-03 00:00:00'),

(@user_jasna_maras, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKWFoxSXlUekpDYld4blVYcEVja1pHWmpjdE0zYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-03 00:00:00'),

(@user_radonja_zekovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWcWFtVkVkQzFNTTFaUFkyTmlWV1V3TVVKblgxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-03 00:00:00'),

(@user_milan_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJ-fDjmKTtTRMRm7C_ZAf5_uA/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GbVJqSjFSWEJ4ZHpKZlYySmlTR1E1VDFZM2FuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-03 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
