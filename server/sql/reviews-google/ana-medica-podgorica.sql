-- Insert Google Maps reviews for Ana Medica
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ana-medica-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ana-medica-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_ana_popovic = (SELECT id FROM doctors WHERE slug = 'ana-popovic');
SET @doctor_marija_bijelic = (SELECT id FROM doctors WHERE slug = 'marija-bijelic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Vukovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXNBYh4f96BAgpDCnSSY7iT6KfJt_XmpkFPaAATb7J2UXIRDsuguw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104906773302003875296/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104906773302003875296/reviews');
SET @user_anastasija_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104906773302003875296/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pedja Lalicic', 'https://lh3.googleusercontent.com/a-/ALV-UjXAL0mc70aOE7mmqnitQdYqV018tGgikXfnUpAZVE0FVgVTh8Rp=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110508606837742723968/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110508606837742723968/reviews');
SET @user_pedja_lalicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110508606837742723968/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Uros Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocK1U90xHnNN3zb0jQwcTHDCMK6U2jolBKzrTjZwjUWRemy0Hg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107565657466987294565/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107565657466987294565/reviews');
SET @user_uros_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107565657466987294565/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Roxanne Alibangbang', 'https://lh3.googleusercontent.com/a-/ALV-UjWvnJc4v_YWAaC6fmDLhFPREHXdV2xInT_TIJ1EpRGGUZb9OEc7=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108266351410706666086/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108266351410706666086/reviews');
SET @user_roxanne_alibangbang = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108266351410706666086/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Pjescic', 'https://lh3.googleusercontent.com/a-/ALV-UjVGRDhznkzRogTq815OQ2j8KSOrrzUKkpfVWWRN8B7JiXUsaRF0iw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102868303024714463353/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102868303024714463353/reviews');
SET @user_tanja_pjescic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102868303024714463353/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana', 'https://lh3.googleusercontent.com/a/ACg8ocKfFdmm0blP1GYmE8rwdnWvaUsa80JDvqSYWxi67YfTOlT0eQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100066302759332698621/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100066302759332698621/reviews');
SET @user_sladjana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100066302759332698621/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dušan Joksimović', 'https://lh3.googleusercontent.com/a-/ALV-UjUg0Z_L0eawQIsyqYsyefl07o_S6xfd72qcJ6CKNdYWWHM-G5KNeA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113007664099120580802/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113007664099120580802/reviews');
SET @user_duan_joksimovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113007664099120580802/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Elma M.', 'https://lh3.googleusercontent.com/a-/ALV-UjVqLeNsQNvE6_GwoTHsYrS1BCS8gqm8Ef64uf3LINQj6q1WQvg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109841723984886408400/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109841723984886408400/reviews');
SET @user_elma_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109841723984886408400/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Djurdjevac', 'https://lh3.googleusercontent.com/a/ACg8ocLFMErs7WC4RLxN8M0oxWB_c4o_lRYrK2eNyEsIFUIsw97V=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105635422907430032032/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105635422907430032032/reviews');
SET @user_dijana_djurdjevac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105635422907430032032/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Acimic Auto', 'https://lh3.googleusercontent.com/a-/ALV-UjU4UrW8eRp94tBH2ghl57UIiuheydH-R985A6JEnvmxJGC_mP41=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118022311437941793804/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118022311437941793804/reviews');
SET @user_acimic_auto = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118022311437941793804/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sofia Zivadinovic', 'https://lh3.googleusercontent.com/a/ACg8ocIER6pjesh_MCA8sZMOPbQJMU3ly2HgJpD1UbIcEXQwacJ3Cw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110623443952629118596/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110623443952629118596/reviews');
SET @user_sofia_zivadinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110623443952629118596/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Zivadinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVYg4TeQrBgbIo9-thOoVcfqBaYhRyjGab73HOor3UHLPa1Ry7J=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102432458568200522286/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102432458568200522286/reviews');
SET @user_jelena_zivadinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102432458568200522286/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marjorie Mudia', 'https://lh3.googleusercontent.com/a/ACg8ocJI2QEJKaradWXybcIBI4frYtf12a3MPImschNgEM3AxslXvsE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113178008383443687945/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113178008383443687945/reviews');
SET @user_marjorie_mudia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113178008383443687945/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boris Bijelic', 'https://lh3.googleusercontent.com/a-/ALV-UjUHYlabtHg5Aj1zSXDnZkLhKJlz4VJIDXuwHUp0KXonmLHYU3IW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100640014814294956320/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100640014814294956320/reviews');
SET @user_boris_bijelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100640014814294956320/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ariane Mae', 'https://lh3.googleusercontent.com/a/ACg8ocJAS8a-K6WDon-gJV0AkeqgCaZGwm0VTQz95r7CsdI8Y4QHnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107997888646286263499/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107997888646286263499/reviews');
SET @user_ariane_mae = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107997888646286263499/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Vujosevic Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLnks1zx-77mpdk8FMIa0B41QRYor24R6RPw6dWdzHXxJ8rcQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111257910128092880633/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111257910128092880633/reviews');
SET @user_sara_vujosevic_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111257910128092880633/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mitar Vujosevic', 'https://lh3.googleusercontent.com/a/ACg8ocKbLJ6KDnR5DKAGgBwkt_0bHHO1h-Q4rY317Epz7mnpTR1Lfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117087633121575072967/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117087633121575072967/reviews');
SET @user_mitar_vujosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117087633121575072967/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dimitrije Jovanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWjkD9HQtf30BTH1t2NTkN0gfLMWaOBRauSCXJD4AJc4nHGfav8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102132540738971966010/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102132540738971966010/reviews');
SET @user_dimitrije_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102132540738971966010/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Nikolić', 'https://lh3.googleusercontent.com/a/ACg8ocLJbG1uEP_yS0lBj5qhD8i_Ddp2z7HNh7Chz_zTqfMal0wNlg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109969123428188119610/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109969123428188119610/reviews');
SET @user_dijana_nikoli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109969123428188119610/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Scekic', 'https://lh3.googleusercontent.com/a/ACg8ocKGqicyDajUlNDdLnh16gG4ByHr9YnCACLhtEp-tw6DrjdF=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109979092598176876126/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109979092598176876126/reviews');
SET @user_maja_scekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109979092598176876126/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Filipovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVQA6nRIrPp395r3e11tUV5KJ8fP7GJTAJ6GqaoUmTtY22qAgWu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103689776191445208891/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103689776191445208891/reviews');
SET @user_nina_filipovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103689776191445208891/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorica Manojlović', 'https://lh3.googleusercontent.com/a/ACg8ocLIMp0nGjLvd7C2qQl3jS_O0pX2aUAqNu0q5nntfXorDDFHrnY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113902326163519627602/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113902326163519627602/reviews');
SET @user_zorica_manojlovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113902326163519627602/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'rada kovacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWpGkHl_3u5rCMK9EV4fgHzGnPxC77nxHo87xx0yxjVpGXtg_Aq=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114558988563857777802/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114558988563857777802/reviews');
SET @user_rada_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114558988563857777802/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igor Madzarovic', 'https://lh3.googleusercontent.com/a/ACg8ocKjgxbfzCW-zHFcGdwHJzjrHqtZLbHsdNxg-YCrMgViKeX4xA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114679641972136837427/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114679641972136837427/reviews');
SET @user_igor_madzarovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114679641972136837427/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Владимир Цаберябый', 'https://lh3.googleusercontent.com/a-/ALV-UjVMexbz6Nz_IWJEDnFbSvCa3q-y3Xr1cfNwvILcG00cgHPc8Y4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110861787494816903585/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110861787494816903585/reviews');
SET @user_vladimir_tsaberyabyy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110861787494816903585/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Perovic', 'https://lh3.googleusercontent.com/a/ACg8ocLIW1QoTw2r22xnexBxUpgBmzWj1Z2rocMzfDXj52jVMZcsrg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110973078718814282760/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110973078718814282760/reviews');
SET @user_marija_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110973078718814282760/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Simon Pajovic', 'https://lh3.googleusercontent.com/a/ACg8ocLNb-0gCHliFdJNL3a_aFIRr578uW8rX7DHf1Aq6Nise5eTiA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114365567483131270086/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114365567483131270086/reviews');
SET @user_simon_pajovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114365567483131270086/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Popović', 'https://lh3.googleusercontent.com/a-/ALV-UjXgMwev6WqQB2Jn2q_oeTDEfip-n1WOnCIlugrwMhyp0zupS_eU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104733885701688626808/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104733885701688626808/reviews');
SET @user_vladimir_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104733885701688626808/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Milosevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW6xrKKGZH8uAcbNNqDD3XmtRQaI7S16BjumvguOpTlqsrdzdM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101094967023764002798/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101094967023764002798/reviews');
SET @user_jovan_milosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101094967023764002798/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladislav Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocISyVt8q8AQZOJJfn_56j3SjRM1SELq42sspimeHpyK_24Kmw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108770416037508119945/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108770416037508119945/reviews');
SET @user_vladislav_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108770416037508119945/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljko Mijuskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXqio-SSySdgu2HWUAaVosqPzgNptgwJKc_9MjyXqJZEMzWHQA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103383333349864480337/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103383333349864480337/reviews');
SET @user_zeljko_mijuskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103383333349864480337/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljiljana Ljuljovic', 'https://lh3.googleusercontent.com/a/ACg8ocIDz_tRso76YRmi63dcDolItqYBXeAm_AIqtB4vC9pr37Nmag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106432042699357626932/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106432042699357626932/reviews');
SET @user_ljiljana_ljuljovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106432042699357626932/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daliborka Zaric', 'https://lh3.googleusercontent.com/a/ACg8ocIMPcePClIYR1nwHwI9Z1lDC06PflDUZew3jSfYziIzHQgFvA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114792794984615445309/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114792794984615445309/reviews');
SET @user_daliborka_zaric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114792794984615445309/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Kaludjerovic', 'https://lh3.googleusercontent.com/a/ACg8ocLNSWf8-9F6fBhDb8AyyiFN99ET5Gl9CAnwLLPZdZsYJ8JE6jg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104075414735140924610/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104075414735140924610/reviews');
SET @user_milica_kaludjerovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104075414735140924610/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Mitrovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVq3XMH9LK4uPE_M9NFFrjVgLZiP_7_Lg8bzTmghYKaIGgDzxbL=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109461942128579724595/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109461942128579724595/reviews');
SET @user_luka_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109461942128579724595/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoran Mandić', 'https://lh3.googleusercontent.com/a-/ALV-UjWNVMppMEgCNQhVjytZU7nvHgS17l-3ha8TSDZNvNMqCnGsqdbHFg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100104587388520118438/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100104587388520118438/reviews');
SET @user_zoran_mandi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100104587388520118438/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danilo Gardasevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUls0kIzXjgbHHE_irS2bWEn2bIBCReUtLxStksz5GFGJjsZiM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111679694370688087199/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111679694370688087199/reviews');
SET @user_danilo_gardasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111679694370688087199/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Janko Nesovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWqAA1cRERQVH5ncld9Yi0ODb8K-XbCzEBkHRJZP5ID7VjBKk2C=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116956948421936145828/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116956948421936145828/reviews');
SET @user_janko_nesovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116956948421936145828/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Daliborka Vujovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ77oKJipyI9KtBBHvRMSmPA274hCU9yGdSLU0tcV76QJTFLg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102641228443341367375/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102641228443341367375/reviews');
SET @user_daliborka_vujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102641228443341367375/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andreja Vujovic', 'https://lh3.googleusercontent.com/a/ACg8ocKTBE2U_1OBRuQbV8a0M9KL_HqLR3Xw5F86pBxYwldqw9DKxlA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107403201275420358380/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107403201275420358380/reviews');
SET @user_andreja_vujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107403201275420358380/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljko Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocKhublouVF9rlx8Nj9r3pxWPSN3-1wupn-9jY9OsCph9Huw8w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117652545770627960422/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117652545770627960422/reviews');
SET @user_veljko_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117652545770627960422/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Jovanic', 'https://lh3.googleusercontent.com/a-/ALV-UjUDuG77L366a7r4kFbDpZkvxUOqFDCQo2FCZgF0qLr4vDzM-CA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109307620195994979279/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109307620195994979279/reviews');
SET @user_dragan_jovanic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109307620195994979279/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'FILIP Lopicic', 'https://lh3.googleusercontent.com/a/ACg8ocLQqa3HqUtBSdnEp0flRSlbsERXHntMPI8_Ige63YYpw7iTsA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103911850464707792207/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103911850464707792207/reviews');
SET @user_filip_lopicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103911850464707792207/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Arsenije Milovic', 'https://lh3.googleusercontent.com/a/ACg8ocK9MO81lmMRbDFwW488-7jKP8S-7r4KK_UXHBOmQIob75mpgw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100243873912001418093/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100243873912001418093/reviews');
SET @user_arsenije_milovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100243873912001418093/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matea Mugosa', 'https://lh3.googleusercontent.com/a/ACg8ocJ4u8IXIfQkqJ9HMHhe7hPh7OzXwprR8lL7C_yVOPOBLVsiFA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102986679120785758716/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102986679120785758716/reviews');
SET @user_matea_mugosa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102986679120785758716/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maša Šćekić', 'https://lh3.googleusercontent.com/a/ACg8ocLazsvdvzXwsVNWdpxDPzEfTnYLvogYYpUFctrW_kZtIkE6zA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103495384194981796347/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103495384194981796347/reviews');
SET @user_maa_eki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103495384194981796347/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lana Koprivica', 'https://lh3.googleusercontent.com/a/ACg8ocJOHE8BaT3oQFWvxMrpIfxSpzMjAzU2Yqp5m8p1PJVJaEDGKg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116975891336537550513/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116975891336537550513/reviews');
SET @user_lana_koprivica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116975891336537550513/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Arsenije Jovanovic', 'https://lh3.googleusercontent.com/a/ACg8ocK9P2D_kd9XVdbY-1mWcIqUl5pQmCgyOJZIQFrxl463VcziAA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117211272461077371198/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117211272461077371198/reviews');
SET @user_arsenije_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117211272461077371198/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusan Raznatovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWsKxvZVZRnU3v6cGJB5b5A0sdTj5XoceMlGQ9vWfLgR0ND0fLt=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105325419477966986509/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105325419477966986509/reviews');
SET @user_dusan_raznatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105325419477966986509/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matija Rosario', 'https://lh3.googleusercontent.com/a/ACg8ocJUX51pFLc9dLHcZygvKPt2sq_ErO4wNmGgl9Z9FqPJo2A4PHE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106943278105134964298/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106943278105134964298/reviews');
SET @user_matija_rosario = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106943278105134964298/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojan Djinovic', 'https://lh3.googleusercontent.com/a/ACg8ocIxjHXEyEy9sszXYLsWXlPBVvXAexJvMyTU3xGhC9kpt1Ig=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114124914260015885638/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114124914260015885638/reviews');
SET @user_bojan_djinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114124914260015885638/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maksim Cavic', 'https://lh3.googleusercontent.com/a/ACg8ocJixGkjEfEvRY6cDckf80UgvHDBonVj-Fq-CXevbagpy3nMmJI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112237640227404574219/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112237640227404574219/reviews');
SET @user_maksim_cavic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112237640227404574219/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'asda dsadovic', 'https://lh3.googleusercontent.com/a/ACg8ocIrdoljmzLonhWfCoEztpTwFMO49FnqVsDUGdrkyGbzqh2UmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108224053718169885886/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108224053718169885886/reviews');
SET @user_asda_dsadovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108224053718169885886/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iva Vujovic', 'https://lh3.googleusercontent.com/a/ACg8ocLtPZqze7CUE142D5lsCw1Z7BQNX8cTSMF4nSTLu1sPsVW_kA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114214589525802552269/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114214589525802552269/reviews');
SET @user_iva_vujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114214589525802552269/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_anastasija_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwQ09VNHlOV1JhVUdveFlqTlJlRFkxUlUwdFpXYxAB',
    5, 'sr', 'Изузетно сам задовољна услугом у ординацији Ана Медика. Особље је љубазно, професионално и посвећено сваком пацијенту. Ординација пружа широк спектар дерматолошких услуга, од опште и дјечје дерматологије до специјалистичких прегледа и савјетовања, а посебно бих похвалила стручност љекара и индивидуалан приступ.
Амбијент је пријатан, ординација уредна и модерно опремљена, а заказивање термина једноставно и брзо. Све препоруке за Ана Медику свима који траже квалитетну, стручну и поуздану здравствену његу.',
    'Izuzetno sam zadovoljna uslugom u ordinaciji Ana Medika. Osoblje je ljubazno, profesionalno i posvećeno svakom pacijentu. Ordinacija pruža širok spektar dermatoloških usluga, od opšte i dječje dermatologije do specijalističkih pregleda i savjetovanja, a posebno bih pohvalila stručnost ljekara i individualan pristup.
Ambijent je prijatan, ordinacija uredna i moderno opremljena, a zakazivanje termina jednostavno i brzo. Sve preporuke za Ana Mediku svima koji traže kvalitetnu, stručnu i pouzdanu zdravstvenu njegu.', 'Изузетно сам задовољна услугом у ординацији Ана Медика. Особље је љубазно, професионално и посвећено сваком пацијенту. Ординација пружа широк спектар дерматолошких услуга, од опште и дјечје дерматологије до специјалистичких прегледа и савјетовања, а посебно бих похвалила стручност љекара и индивидуалан приступ.
Амбијент је пријатан, ординација уредна и модерно опремљена, а заказивање термина једноставно и брзо. Све препоруке за Ана Медику свима који траже квалитетну, стручну и поуздану здравствену његу.', NULL, NULL, NULL, NULL,
    0, '2026-06-30 17:22:49'),

(@user_pedja_lalicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWbk9EWnhVRTk0YlhwT01rbHpUV0pMT1dsMmQwRRAB',
    5, 'hr', 'Doktorica je sve detaljno objasnila, saslušala moje probleme i pružila najbolje moguće savjete. Prijatan i opušten pristup tokom cijele posjete..Profesionalnost, stručnost i ljubazan odnos prema pacijentima su na najvišem nivou. Ambulanta je uredna, organizovana, a osoblje uvijek nasmijano i spremno pomoći. Hvala vam na posvećenosti i kvalitetnoj njezi. Sve pohvale i iskrena preporuka.',
    'Doktor je sve detaljno objasnio, saslušao moje probleme i pružio najbolji mogući savet. Prijatan i opušten pristup tokom cele posete. Profesionalizam, stručnost i prijateljski odnos prema pacijentima su na najvišem nivou. Klinika je uredna, organizovana, a osoblje je uvek nasmejano i spremno da pomogne. Hvala vam na posvećenosti i kvalitetnoj nezi. Sve pohvale i iskrena preporuka.', 'Доктор је све детаљно објаснио, саслушао моје проблеме и пружио најбољи могући савет. Пријатан и опуштен приступ током целе посете. Професионализам, стручност и пријатељски однос према пацијентима су на највишем нивоу. Клиника је уредна, организована, а особље је увек насмејано и спремно да помогне. Хвала вам на посвећености и квалитетној нези. Све похвале и искрена препорука.', NULL, NULL, NULL, NULL,
    0, '2026-07-04 09:27:55'),

(@user_uros_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0RWQwMVRkR0p1WVZaNkxUUk1aRjk0V1V0SVMzYxAB',
    5, 'bs', 'Veoma strucan tim rijesili su mi problem samo za dvije posjete dermatologu . Svima pradlezem koji imaju kožne probleme da posjete ovu kliniku.',
    'Veoma profesionalan tim je rešio moj problem za samo dve posete dermatologu. Preporučujem svima koji imaju problema sa kožom da posete ovu kliniku.', 'Веома професионалан тим је решио мој проблем за само две посете дерматологу. Препоручујем свима који имају проблема са кожом да посете ову клинику.', NULL, NULL, NULL, NULL,
    0, '2026-07-04 13:05:45'),

(@user_roxanne_alibangbang, @clinic_id, @doctor_ana_popovic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GdmJESjJXV1JYVkRsSlNUVnhaQzB0V1doSmFuYxAB',
    5, 'en', 'Dr. Popović is simply outstanding. Professional, highly skilled, and always welcoming with a warm smile. She has a remarkable ability to turn every concern into a success story, making even the most challenging situations feel effortless. Her expertise, kindness, and dedication give you complete confidence from the very first visit. Truly an exceptional doctor—I couldn’t recommend her more highly.',
    'Dr Popović je jednostavno izvanredna. Profesionalna, visokokvalifikovana i uvek gostoljubiva sa toplim osmehom. Ona ima izvanrednu sposobnost da svaku brigu pretvori u priču o uspehu, čineći da čak i najteže situacije budu bez napora. Njena stručnost, ljubaznost i posvećenost vam daju potpuno poverenje od prve posete. Zaista izuzetan lekar - ne bih je mogao bolje preporučiti.', 'Др Поповић је једноставно изванредна. Професионална, висококвалификована и увек гостољубива са топлим осмехом. Она има изванредну способност да сваку бригу претвори у причу о успеху, чинећи да чак и најтеже ситуације буду без напора. Њена стручност, љубазност и посвећеност вам дају потпуно поверење од прве посете. Заиста изузетан лекар - не бих је могао боље препоручити.', 'Dr. Popović is simply outstanding. Professional, highly skilled, and always welcoming with a warm smile. She has a remarkable ability to turn every concern into a success story, making even the most challenging situations feel effortless. Her expertise, kindness, and dedication give you complete confidence from the very first visit. Truly an exceptional doctor—I couldn’t recommend her more highly.', NULL, NULL, NULL,
    0, '2026-07-05 08:47:48'),

(@user_tanja_pjescic, @clinic_id, @doctor_ana_popovic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taeWFWSjNkWGw0ZWs5UmFYQk5WVUZoUm5sdmQyYxAB',
    5, 'bs', 'Iskrena preporuka za dermatologa dr Anu Popovic.Strucna,profesionalna,sve objasni do tancina,a rezultati su vidljivi.Prosto , osjetite da ste u sigurnim rukama.',
    'Iskrena preporuka za dermatologa dr Anu Popović. Stručna, profesionalna, sve detaljno objašnjava, a rezultati su vidljivi. Jednostavno rečeno, osećate se kao da ste u sigurnim rukama.', 'Искрена препорука за дерматолога др Ану Поповић. Стручна, професионална, све детаљно објашњава, а резултати су видљиви. Једноставно речено, осећате се као да сте у сигурним рукама.', NULL, NULL, NULL, NULL,
    0, '2026-02-05 15:00:04'),

(@user_sladjana, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xadWVWTTJObEpQTUVGelgwaGFhMVp5TTNnNGJFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_duan_joksimovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21nMVlWVnRXblJLT1VzNFExUk1kVmR2VkhwRmQzYxAB',
    5, 'bs', 'Fantasticno osoblje i profesijalan rad, imao sam akne vec 7 godina i nista mi nije pomagalo, za samo 2 nedelje postignuti rezultati bili su bolji nego sve drugo sto sam koristio zajedno',
    'Fantasticno osoblje i profesijalan rad, imao sam akne vec 7 godina i nista mi nije pomagalo, za samo 2 nedelje postignuti rezultati bili su bolji nego sve drugo sto sam koristio zajedno', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_elma_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCNWMwZGFNV3B0VEdkTVYzcFRkM2cxTkVwcVlYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_dijana_djurdjevac, @clinic_id, @doctor_marija_bijelic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsRmQycHZUMFJGYVRGeFdrdHRVV1UwVWxWQ2QwRRAB',
    5, 'bs', 'Sve pohvale za Ana Medica ordinaciju, a posebno za dr Mariju Bijelić. Zaista sam prezadovoljna pristupom, stručnošću i pažnjom koju doktorica posvećuje pacijentu. Sve lijepo objasni, sasluša i uliva veliko povjerenje. Osjeti se da joj je zaista stalo da pronađe najbolje rješenje i da prati pacijenta kroz cijeli proces. Uz to, ordinacija je veoma prijatna, a osoblje ljubazno i profesionalno. Dr Mariju od srca preporučujem svima koji traže stručnog i posvećenog dermatologa.',
    'Sve pohvale za Ana Medica ordinaciju, a posebno za dr Mariju Bijelić. Zaista sam prezadovoljna pristupom, stručnošću i pažnjom koju doktorica posvećuje pacijentu. Sve lijepo objasni, sasluša i uliva veliko povjerenje. Osjeti se da joj je zaista stalo da pronađe najbolje rješenje i da prati pacijenta kroz cijeli proces. Uz to, ordinacija je veoma prijatna, a osoblje ljubazno i profesionalno. Dr Mariju od srca preporučujem svima koji traže stručnog i posvećenog dermatologa.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_acimic_auto, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kTmVUZ3pXbmRIT1RRNFFqY3RWRXhMVFZwbE9HYxAB',
    5, 'en', 'Oustanding service and people',
    NULL, NULL, 'Oustanding service and people', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_sofia_zivadinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWSFdpMUtiRWh1VkVsWFZURk9ja3ByYlRWQ1gwRRAB',
    5, 'hr', 'Najbolja dermatoloska Klinike. Divne doktorice! Sve preporuke! 💕💕💕',
    'Najbolja dermatoloska Klinike. Divne doktorice! Sve preporuke! 💕💕💕', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_jelena_zivadinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT201aVFrVjBUakkzZUVJMFZHUkdiMDlDYTFsTFgxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_marjorie_mudia, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WWWNUSlZSRWMzVm5reVRrdFVOVXBTU1RaS1drRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_boris_bijelic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkcVV6SklRV0ZtY1RacFJtRjBkVXhhUTJSNFMwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_ariane_mae, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxbmNuUmFTR3huYkY5d1lYWTVNR1I0TjJSc1ZFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_sara_vujosevic_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oWWNFWkpVVkU1VTNOa2ExTjVPVXRTVTFCMmNIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_mitar_vujosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT210WWIwNDBZemxLYjJoSWNFVkpNVjlmV1dGNU9WRRAB',
    5, 'bs', 'Divne doktorice profesionalne ljubazne I geo strucne',
    'Divne doktorice profesionalne ljubazne I geo strucne', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_dimitrije_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsNFNISXhlWEZ5Vm05VlMyRnhjM05FWTJwRVZrRRAB',
    5, 'hr', 'Super doktorice. Veoma profesionalne. Topla preporuka',
    'Super doktorice. Veoma profesionalne. Topla preporuka', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_dijana_nikoli, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pSMFNUbFBSRGhtVnpoUlNtUk5TSEV3TFVoalpGRRAB',
    5, 'bs', 'Sve pohvale za cijeli tim Ana Medica.
Ljubaznost i profesionalnost na visokom nivou.Svima bih preporučila ordinaciju.',
    'Sve pohvale za cijeli tim Ana Medica.
Ljubaznost i profesionalnost na visokom nivou.Svima bih preporučila ordinaciju.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_maja_scekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsaFNVdFRlRzlNUWtGME5IVktjMjVJYzJ3eU5sRRAB',
    5, 'hr', 'Prezadovoljna❤️',
    'Prezadovoljna❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_nina_filipovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oSVVrOVJSa04yWnpVelFYUTRXSGRwWTNJelNYYxAB',
    5, 'hr', 'Svaka preporuka!',
    'Svaka preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_zorica_manojlovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25BeFRIZEtVa2hNUkRKUlpYTlZVSGRuYm1kUVdrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_rada_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psak5IaG5UVXRoY1dwNFpWbExTMVJGVHpWck9GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_igor_madzarovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOVVVqSXRlR2hrZUc4eFVFODFhbXAzUkMxWk5uYxAB',
    5, 'hr', 'Najbolji !',
    'Najbolji !', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_vladimir_tsaberyabyy, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SVk0yY3hRbkZyUW5veU9HSlhYMFZTTjB0UlIyYxAB',
    1, 'en', 'Never have your moles removed by this doctor!!

I came in with this request, and instead of removing the mole, the doctor only cut off part of it.

On top of that, for some reason the procedure was done WITHOUT anesthesia using a radio-wave method. As a result, I was left with an open wound and parts of the mole still remaining around the edges. I paid money, and for my own money I was harmed.

I don’t know how anyone can even offer services of such poor quality…',
    NULL, NULL, 'Never have your moles removed by this doctor!!

I came in with this request, and instead of removing the mole, the doctor only cut off part of it.

On top of that, for some reason the procedure was done WITHOUT anesthesia using a radio-wave method. As a result, I was left with an open wound and parts of the mole still remaining around the edges. I paid money, and for my own money I was harmed.

I don’t know how anyone can even offer services of such poor quality…', NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_marija_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OU2JsSTVTRmxKV0VOelMzbGtZblpPU2kxd1FVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_simon_pajovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkWFJEZFpTMFUxVkhkcVEwNUJSMHh4ZVhSSmVGRRAB',
    5, 'hr', 'Izuzetno stručna doktorka sa profesionalnim pristupom i vrlo ljubazno osoblje',
    'Izuzetno stručna doktorka sa profesionalnim pristupom i vrlo ljubazno osoblje', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_vladimir_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OQlFrNDJYMWMwYWtGWGVuVlFWVXgxY2xGaU5rRRAB',
    5, 'en', 'Outstanding level of professionalism.
I could not believe myself that the clinic like this exists in Podgorica.

I would give them 10 stars if possible!',
    NULL, NULL, 'Outstanding level of professionalism.
I could not believe myself that the clinic like this exists in Podgorica.

I would give them 10 stars if possible!', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_jovan_milosevic, @clinic_id, @doctor_ana_popovic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pnMVpETmZSazVYZEZOMllrVlJka1ZWU1d0VFpsRRAB',
    5, 'hr', 'Dr Ana Popovic , svaka pohvala na posvećenosti i stručnosti! Preporuka.',
    'Dr Ana Popovic , svaka pohvala na posvećenosti i stručnosti! Preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_vladislav_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCT1drRnFlbVpIYlVRMFJqSlVjRE5JTFVwSlFrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_zeljko_mijuskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21JeWVGbHFRMjlEUkRZdE1tbDBOakZDVm1aNVRXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_ljiljana_ljuljovic, @clinic_id, @doctor_ana_popovic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21RM04wSlllSEk1U2tsd2NGOVhhRGQ1Wm1OcmVVRRAB',
    5, 'bs', 'Želim da podijelim moje iskustvo iz ordinacije ,,Ana Medica" kod dermatologa, dr Ane Popović.
Odlično iskustvo, znanje koje dr Ana Popović posjeduje i ljubazno osoblje, uz prijatan ambijent, zaslužuju preporuke od mene. Hvala na svemu.',
    'Želim da podijelim moje iskustvo iz ordinacije ,,Ana Medica" kod dermatologa, dr Ane Popović.
Odlično iskustvo, znanje koje dr Ana Popović posjeduje i ljubazno osoblje, uz prijatan ambijent, zaslužuju preporuke od mene. Hvala na svemu.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_daliborka_zaric, @clinic_id, @doctor_ana_popovic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSU1QwTmhjbDlGVWtSb1gzUjFYMGhZUm5sSU9IYxAB',
    5, 'bs', 'Dr Ana Popović kojoj dugujem zahvalnost jer se izuzetno posvetila mom zdravstvenom problemu. Dr Popović je dermatološkinja kojoj se vjeruje i koja se nesebično i plemenito zalaže za izlečenje pacijenata.',
    'Dr Ana Popović kojoj dugujem zahvalnost jer se izuzetno posvetila mom zdravstvenom problemu. Dr Popović je dermatološkinja kojoj se vjeruje i koja se nesebično i plemenito zalaže za izlečenje pacijenata.', NULL, NULL, NULL, NULL, NULL,
    1, '2026-03-01 00:00:00'),

(@user_milica_kaludjerovic, @clinic_id, @doctor_ana_popovic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psbVpXZGhaVzFuVTBKMVRVVnlSa3h3VkVGZmVGRRAB',
    5, 'hr', 'Moje iskustvo u Ana Medica ordinaciji je odlično. Dermatolog , dr Ana Popović je precizna, stručna i profesionalna. Najljepśe pohvale za dr Anu Popović i ljubazno osoblje.',
    'Moje iskustvo u Ana Medica ordinaciji je odlično. Dermatolog , dr Ana Popović je precizna, stručna i profesionalna. Najljepśe pohvale za dr Anu Popović i ljubazno osoblje.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_luka_mitrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwdVExaE9TR2RuTFdWU2JsaFVNVjlvVm1rMmIwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_zoran_mandi, @clinic_id, @doctor_ana_popovic, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pKb05URnFVemx1ZVZOR1IxcFVUMDVuY1RGUlpuYxAB',
    5, 'bs', 'Dr Ana Popović, sjajna i profesionalna. Dr Ana Popović je dermatolog i njena odgovornost i posvećenost pacijentima je za poštovanje.',
    'Dr Ana Popović, sjajna i profesionalna. Dr Ana Popović je dermatolog i njena odgovornost i posvećenost pacijentima je za poštovanje.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_danilo_gardasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWNU9HaHZOaTFqT1Y5d09HWm9iSGN4Y0cwNWEwRRAB',
    5, 'bs', 'Odlična usluga i profesionalan tim. Problem riješen brzo i efikasno. Preporučujem!',
    'Odlična usluga i profesionalan tim. Problem riješen brzo i efikasno. Preporučujem!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_janko_nesovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkc1RVbE5RVVJYYW14aE0zVk5ZV0ZyYlZoVFVHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_daliborka_vujovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGTExVdzVVMFZFTFdZMGVHVldhM3B6Y1UxNGRrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_andreja_vujovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xjMVpGTmtjVUU1U0RkRldubzRabmM0TW5oWU9IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_veljko_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2swelVESXdlblJMVWw5S0xXUm1Ua2h3UVcxNmIxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_dragan_jovanic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKTWVXdE5hRjlJVkc4MmRGWnJjVXROVW5vek1rRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_filip_lopicic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1RWFYaG5jVE4xUzJ3M1FrOUtVbE5UV1dNd1oxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_arsenije_milovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21KQlJYZ3hNRzFpWHpoblJHTnZabU5PVW1oV00xRRAB',
    5, 'bs', 'Bio sam kod doktorice Ane prije nekih 15ak dana, vrlo fina i prijatna zena. Sve procedure smo obavili veoma brzo i efikasno. Djevojka sto je rsdila na pultu je takodje vrlo ljubazna. Sve preporuke',
    'Bio sam kod doktorice Ane prije nekih 15ak dana, vrlo fina i prijatna zena. Sve procedure smo obavili veoma brzo i efikasno. Djevojka sto je rsdila na pultu je takodje vrlo ljubazna. Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_matea_mugosa, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT214ME1ITjFjMkpxVFdwa1JFMXBaRFZJV1hWclVGRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_maa_eki, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WNmFEaFljMUpUUVVGUGNWaDJVRmx3V0hCemIxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_lana_koprivica, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkeVoycGlWRjlXVXpJeWNWZDFPWGc1Y1c1akxXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_arsenije_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xacU56WTVSRlJ5ZDBGQ1pYcHBielJIV0ZjMFNuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_dusan_raznatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SUlJuVllkaTEzWkdSc1VYTlBlR2RsWTBac2RVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_matija_rosario, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwdE5DMXNiMmxPY2pKUFNWWkhZMjlJT0haV1lWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_bojan_djinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KQmEzTTBZbkZHZURndGIyOVFhelF5TVV0b2NVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_maksim_cavic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kbmRYTjFaWFpGZFRnek9HWkVNRkpIVmtFMWRFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_asda_dsadovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGaWExVnVZbkZ6WlcxR1JFcGZVVWRKVlZSMVZHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_iva_vujovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA5G1lTTrTRMRz1RQ8FugQoI/reviews/Ci9DQUlRQUNvZENodHljRjlvT2trMlRFVm5NbTEyYTB0RVFVWkpTVTB0U2pSMmJHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
