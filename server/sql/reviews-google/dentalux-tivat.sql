-- Insert Google Maps reviews for Stomatološka ordinacija Dentalux
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/dentalux-tivat.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'dentalux-tivat');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_jasminka_andjelic = (SELECT id FROM doctors WHERE slug = 'jasminka-andjelic');
SET @doctor_snezana_matijevic = (SELECT id FROM doctors WHERE slug = 'snezana-matijevic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ellen R (Monet)', 'https://lh3.googleusercontent.com/a-/ALV-UjUYxJ2marlcj8M8TCK3FaSC5g3NfLWoOzUccblX93aMFmUjTmOr=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/100470588701999846499/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100470588701999846499/reviews');
SET @user_ellen_r_monet = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100470588701999846499/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ната Ли', 'https://lh3.googleusercontent.com/a/ACg8ocKvTszk7r5IoIpKwBHiU96bpYloxz-xbWNBsUIVDFnVlA8XWQ=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/109591354847762883478/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109591354847762883478/reviews');
SET @user_nata_li = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109591354847762883478/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Celanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLo6zq6rThmc74UmLTXbwK9W8Doe9cMIp8E4ba5GeKGTBonTQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/110318195549198410326/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110318195549198410326/reviews');
SET @user_sanja_celanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110318195549198410326/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zorica Kovačević', 'https://lh3.googleusercontent.com/a-/ALV-UjWyMf_8X2CVE4rJR0QCIhUCKmTIk2homj3oCzonhNAhvzfafs78=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114537648782640127620/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114537648782640127620/reviews');
SET @user_zorica_kovaevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114537648782640127620/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jordanka M.', 'https://lh3.googleusercontent.com/a-/ALV-UjWQ-w_n3gzla3Wjop8lfplyh2rw42JAYv5aFLHNUpakyYVhtzo=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/103506334269599121939/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103506334269599121939/reviews');
SET @user_jordanka_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103506334269599121939/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adrijana Skorupan', 'https://lh3.googleusercontent.com/a/ACg8ocJEsKVNDR8DLfsu-QHUvE_Efygr3rI6j7AM_1MQOeNn8HtSfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106892852049484188850/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106892852049484188850/reviews');
SET @user_adrijana_skorupan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106892852049484188850/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Jelovac', 'https://lh3.googleusercontent.com/a-/ALV-UjWqX0nEq7vciQrXygO_XSbpuP9NjEO0yHlAKaxi__FsS4jV_SMO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109253354749011936667/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109253354749011936667/reviews');
SET @user_bojana_jelovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109253354749011936667/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Prelević', 'https://lh3.googleusercontent.com/a/ACg8ocLukTqkwfpYS_O4eJ5MUW5ErCzrKeYw8-BbP4PsIvM1c-DZzw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108890577762070937582/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108890577762070937582/reviews');
SET @user_marijana_prelevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108890577762070937582/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'V', 'https://lh3.googleusercontent.com/a/ACg8ocKXrG5nN1eRRGJ7hMVVzl-R5QBggho_cbCjUhO3OGJMeULXJ9cT=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109087051633247930841/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109087051633247930841/reviews');
SET @user_user_109087051633247930841 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109087051633247930841/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'elias del barco', 'https://lh3.googleusercontent.com/a-/ALV-UjU3-pz-Am8eJ5ghishRg1BrY_Xdt6P7GPQSz07-777l02qeYrw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106272762228178841428/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106272762228178841428/reviews');
SET @user_elias_del_barco = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106272762228178841428/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mario Kurtin', 'https://lh3.googleusercontent.com/a/ACg8ocI4M3oopDIWU2YbjkLTSDLc5petAjEc3XnSIoogwFMUuNR8zg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103639096944300222741/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103639096944300222741/reviews');
SET @user_mario_kurtin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103639096944300222741/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vuk Tomanovic', 'https://lh3.googleusercontent.com/a/ACg8ocKA-CshUR7kwgfhgvNeUO0iZVv_c1yaWyK4E95dikkaJ1v9Ug=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107119602523813226093/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107119602523813226093/reviews');
SET @user_vuk_tomanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107119602523813226093/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Iliana Bakmaz', 'https://lh3.googleusercontent.com/a-/ALV-UjUhNvxSBorHRxGZ8zMeakZL1SzdxwfnS7NGiC4uwq69em1G9mZ0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111008865946206759327/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111008865946206759327/reviews');
SET @user_iliana_bakmaz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111008865946206759327/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Martina Mušura', 'https://lh3.googleusercontent.com/a/ACg8ocL3jZ9YKf-_PjGWYDseQSRJDXeLKd0iw9CoOkH-BccbD-pjWw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110577138653227102247/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110577138653227102247/reviews');
SET @user_martina_muura = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110577138653227102247/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ognjen Pavicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXSyKTVtHjuq4ZdYIIvgwJ0Kyy8TkTIoWrp7fFZ35MRkwUdREXG=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113168749660461327127/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113168749660461327127/reviews');
SET @user_ognjen_pavicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113168749660461327127/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mija Milunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVVsY4ArHMhWU5FCQxlGjYV9Kxf6y5onxiR9fidI8c_vVFoORrR=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103963421792469981841/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103963421792469981841/reviews');
SET @user_mija_milunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103963421792469981841/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lena Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocJzGN4k5eo7uJWGfelGph252VA7fw3mSNdwLdEt9QrIHB2Pig=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102574094851609554028/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102574094851609554028/reviews');
SET @user_lena_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102574094851609554028/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boris Mirkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKFB-B-cAvYetkridzRpQWQxx95DuvfqXZOJ44x-OMoGH6oMA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110270560459684664401/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110270560459684664401/reviews');
SET @user_boris_mirkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110270560459684664401/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boạn Mladenovic', 'https://lh3.googleusercontent.com/a/ACg8ocKZFXo-Q3TFQkDTm0sO42FTdUvd8V9m5qLN2ypg8C0-OkaEGg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107182279860390962748/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107182279860390962748/reviews');
SET @user_bon_mladenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107182279860390962748/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Wander Gaze', 'https://lh3.googleusercontent.com/a/ACg8ocLcXv1efz88UCWwEEjdoCrrCm5KzAKQM161DLcQqrEpfL1m5A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105003745608317509189/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105003745608317509189/reviews');
SET @user_wander_gaze = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105003745608317509189/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dilan Boyraz', 'https://lh3.googleusercontent.com/a-/ALV-UjV-9To_fF6hUMh8UTsW7qOVM9poxv6aY_3OofZd8e_IE_-Uswc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117412433778292212593/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117412433778292212593/reviews');
SET @user_dilan_boyraz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117412433778292212593/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Teodora Peric', 'https://lh3.googleusercontent.com/a-/ALV-UjWKoWW8txoQCc5X2MDYcubsbpSFWVC4-UB90WBty2GxgipTuH7y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116706336950569826540/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116706336950569826540/reviews');
SET @user_teodora_peric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116706336950569826540/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Boskovic', 'https://lh3.googleusercontent.com/a/ACg8ocLvKzlH1OlY7UcK0TgjwJyjsuEke29wxn83y-85ohwAPaUMvw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117415922884782783812/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117415922884782783812/reviews');
SET @user_nina_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117415922884782783812/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dimitrije Zivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocIPI-hnH8FfKpjC7SzNnBGFknGeP8ZmZLzOd5soD14zo7A5ViU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117397634815818780215/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117397634815818780215/reviews');
SET @user_dimitrije_zivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117397634815818780215/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragoljub Kovacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXGr1d5Yi8v83c3d_Ok_TWACIeEuUoGQ_qiiHKGxtVFSx0mL4TW=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113212075583301961002/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113212075583301961002/reviews');
SET @user_dragoljub_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113212075583301961002/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Joncic', 'https://lh3.googleusercontent.com/a-/ALV-UjXI3BUy99bDzSekOLpg8caHb8-i3T_OJtRlYXSCIzczJ139QJJZ3w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111402048849295828893/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111402048849295828893/reviews');
SET @user_natasa_joncic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111402048849295828893/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Кристина Кориевская', 'https://lh3.googleusercontent.com/a/ACg8ocLzSCjxx1hW5zUzs5Nasf_58WOW3WvnAv4zJ7IA4ObvK9Iygw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109544991914032647811/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109544991914032647811/reviews');
SET @user_kristina_korievskaya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109544991914032647811/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nela Radunovic', 'https://lh3.googleusercontent.com/a/ACg8ocJXhgP6N2PUBlmpA4th4kiJHjn5WUsh_xDElHk2DlFIExRCyA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112059802093079045645/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112059802093079045645/reviews');
SET @user_nela_radunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112059802093079045645/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'STAN STAN', 'https://lh3.googleusercontent.com/a/ACg8ocLECq7IquaYgiQgUfmbzH66CY0hOMmtZRcBzC9q1yYRttZi6Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109525666697839997182/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109525666697839997182/reviews');
SET @user_stan_stan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109525666697839997182/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andreano Celentano', 'https://lh3.googleusercontent.com/a-/ALV-UjVNGOeuIdv9DYxAHIbdXXS3dA0QltLH2DFIz5tUlH5MzmGgFELK=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102590478724331696989/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102590478724331696989/reviews');
SET @user_andreano_celentano = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102590478724331696989/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milovan Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXDYFo9c4HxVRwNyw5DPiNv421sx5It7vGU-pr2UtI4bhhkFls=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109213072282298452133/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109213072282298452133/reviews');
SET @user_milovan_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109213072282298452133/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Игорь Румянцев', 'https://lh3.googleusercontent.com/a-/ALV-UjWtyqYcOCV_xqHKyts3wXh5DDvPfK4rw5OE17JOvbD4eUyiEuNv=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100232997823865082204/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100232997823865082204/reviews');
SET @user_igor_rumyantsev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100232997823865082204/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Fantic', 'https://lh3.googleusercontent.com/a/ACg8ocIdKm5Ue7-dzK4bgtwzfz7pVbOEXQXuas1RBTwzlVBaQtcXuw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113025449482908067926/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113025449482908067926/reviews');
SET @user_dijana_fantic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113025449482908067926/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Morovan', 'https://lh3.googleusercontent.com/a/ACg8ocI1mmBYMfI5RB_Q9uql6tZGZ68hixqAXIX8P1gFASyHdoY50f0f=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110462956588085570272/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110462956588085570272/reviews');
SET @user_milica_morovan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110462956588085570272/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ellen_r_monet, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kNE1sQmxNMDQwWkRGUFkxcGFWVE00ZUVaTk9XYxAB',
    1, 'en', 'I had braces here a year and a half ago, and I’m still dealing with the consequences - they installed the molar bands and to fit them they shaved the teeth instead of using the spacers in advance, and covered everything with some adhesive, all that of course destroyed the teeth, plus the neighbouring tooth got chipped during that procedure and ofc that chip further developed into a big hole. Now I’m in Germany and doctors here are shocked seeing what’s been done, cz shaving the perfectly healthy teeth is not even allowed here as it obviously destroys them. So now I’ll have to pay a ton of money to recover all that. And don’t even get me started on the hygiene of that place - blood spills all over the chair, hair on the tools, dirty masks and uniforms, gloves are worn just symbolically (I mean if a doctor speaks on the phone, touches everything around and then reaches to your mouth while wearing the same gloves, it screams anti sanitary). Signing the contract and issuing receipts are also unheard of, so you don’t even have proofs if anything goes wrong.
I was sent to this office by the dentist in Herceg Novi whom I trust, but this level of “medicine” was sth very new to me. Never again!',
    'Pre godinu i po dana sam ovde nosio protezu i još uvek se borim sa posledicama - postavili su mi kutnjake i da bi ih postavili, obrijali su zube umesto da unapred koriste odstojnike, i sve su prekrili lepkom, sve je to naravno uništilo zube, plus susedni zub se odlomio tokom tog postupka i naravno to odlomljenje se dalje razvilo u veliku rupu. Sada sam u Nemačkoj i lekari ovde su šokirani videvši šta je urađeno, jer brijanje savršeno zdravih zuba ovde nije ni dozvoljeno jer ih očigledno uništava. Dakle, sada ću morati da platim gomilu novca da bih sve to nadoknadio. I nemojte me ni početi o higijeni tog mesta - krv ​​se prosipa po stolici, dlake na alatima, prljave maske i uniforme, rukavice se nose samo simbolično (mislim, ako lekar razgovara telefonom, dodiruje sve oko sebe, a zatim vam posegne za ustima dok nosi iste rukavice, to je potpuno antihigijenski). Potpisivanje ugovora i izdavanje računa su takođe nečuveni, tako da nemate ni dokaze ako nešto krene po zlu. U ovu ordinaciju me je uputio stomatolog iz Herceg Novog kome verujem, ali ovaj nivo „medicine“ je bio nešto novo za mene. Nikad više!', 'Пре годину и по дана сам овде носио протезу и још увек се борим са последицама - поставили су ми кутњаке и да би их поставили, обријали су зубе уместо да унапред користе одстојнике, и све су прекрили лепком, све је то наравно уништило зубе, плус суседни зуб се одломио током тог поступка и наравно то одломљење се даље развило у велику рупу. Сада сам у Немачкој и лекари овде су шокирани видевши шта је урађено, јер бријање савршено здравих зуба овде није ни дозвољено јер их очигледно уништава. Дакле, сада ћу морати да платим гомилу новца да бих све то надокнадио. И немојте ме ни почети о хигијени тог места - крв ​​се просипа по столици, длаке на алатима, прљаве маске и униформе, рукавице се носе само симболично (мислим, ако лекар разговара телефоном, додирује све око себе, а затим вам посегне за устима док носи исте рукавице, то је потпуно антихигијенски). Потписивање уговора и издавање рачуна су такође нечувени, тако да немате ни доказе ако нешто крене по злу. У ову ординацију ме је упутио стоматолог из Херцег Новог коме верујем, али овај ниво „медицине“ је био нешто ново за мене. Никад више!', 'I had braces here a year and a half ago, and I’m still dealing with the consequences - they installed the molar bands and to fit them they shaved the teeth instead of using the spacers in advance, and covered everything with some adhesive, all that of course destroyed the teeth, plus the neighbouring tooth got chipped during that procedure and ofc that chip further developed into a big hole. Now I’m in Germany and doctors here are shocked seeing what’s been done, cz shaving the perfectly healthy teeth is not even allowed here as it obviously destroys them. So now I’ll have to pay a ton of money to recover all that. And don’t even get me started on the hygiene of that place - blood spills all over the chair, hair on the tools, dirty masks and uniforms, gloves are worn just symbolically (I mean if a doctor speaks on the phone, touches everything around and then reaches to your mouth while wearing the same gloves, it screams anti sanitary). Signing the contract and issuing receipts are also unheard of, so you don’t even have proofs if anything goes wrong.
I was sent to this office by the dentist in Herceg Novi whom I trust, but this level of “medicine” was sth very new to me. Never again!', NULL, NULL, NULL,
    0, '2025-08-18 11:11:53'),

(@user_nata_li, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQyd0p1UTBnRRAB',
    1, 'ru', 'Некачественно! Плохой сервис! Очень больно!
У меня отклеился зубной ретейнер и нужно было приклеить обратно.
Было очень больно когда доктор пыталась снять инструментом предыдущий пломбирующий материал с зубов...инструмент постоянно соскальзывал и ударял в соседние зубы...я скривилась от сильной боли...после этого доктор додумалась взять правильный сверлящий инструмент и снять пломбирующий материал.
Доктор работала без маски и в момент когда она разговаривала с напарницей то плевала мне на лицо, слюна доктора попала мне в глаз...это ужас.
Далее доктор промахнулась и пролила жидкость для рта мне в лицо, глаз и шею  после чего подняла салфетку С ПОЛА и начала протирать мой залитый глаз, лицо и шею...доктора не смутила что салфетка была на полу. Плохой сервис! Некачественно!
Обеспокоена действиями доктора и я не уверена что инструменты дезинфицируют.  Я переживаю за свое здоровье поэтому буду сдавать анализы на ВИЧ и Гепатит.
За то что я иностранка с меня взяли оплату в три раза выше чем для местных жителей. 50 евро чтобы приклеить обратно зубной ретейнер',
    'Loš kvalitet! Loša usluga! Veoma bolno!
Moj zubni držač je otpao i trebalo ga je ponovo pričvrstiti.
Bilo je neverovatno bolno kada je doktor pokušao da ukloni prethodni materijal za punjenje iz mojih zuba instrumentom... instrument je stalno klizio i udarao u susedne zube... Trznula sam se od jakog bola... onda je doktor pronašao odgovarajući instrument za bušenje i uklonio materijal za punjenje.
Doktorka je radila bez maske, a dok je razgovarala sa partnerom pljunula mi je u lice, a malo doktorkine pljuvačke mi je ušlo u oko... bilo je užasno.
Onda je doktor promašio i prosuo mi vodicu za ispiranje usta po licu, oku i vratu, zatim je podigao salvetu sa poda i počeo da mi briše zakrvavljeno oko, lice i vrat... činilo se da doktoru nije smetalo što je salveta bila na podu. Loša usluga! Loš kvalitet!
Zabrinut sam zbog postupaka doktora, i nisam siguran da dezinfikuju instrumente. Zabrinut sam za svoje zdravlje, pa ću se testirati na HIV i hepatitis.
Pošto sam stranac, naplatili su mi tri puta veću lokalnu taksu — 50 evra — da ponovo pričvrstim zubni držač.', 'Лош квалитет! Лоша услуга! Веома болно!
Мој зубни држач је отпао и требало га је поново причврстити.
Било је невероватно болно када је доктор покушао да уклони претходни материјал за пуњење из мојих зуба инструментом... инструмент је стално клизио и ударао у суседне зубе... Трзнула сам се од јаког бола... онда је доктор пронашао одговарајући инструмент за бушење и уклонио материјал за пуњење.
Докторка је радила без маске, а док је разговарала са партнером пљунула ми је у лице, а мало докторкине пљувачке ми је ушло у око... било је ужасно.
Онда је доктор промашио и просуо ми водицу за испирање уста по лицу, оку и врату, затим је подигао салвету са пода и почео да ми брише закрвављено око, лице и врат... чинило се да доктору није сметало што је салвета била на поду. Лоша услуга! Лош квалитет!
Забринут сам због поступака доктора, и нисам сигуран да дезинфикују инструменте. Забринут сам за своје здравље, па ћу се тестирати на ХИВ и хепатитис.
Пошто сам странац, наплатили су ми три пута већу локалну таксу — 50 евра — да поново причврстим зубни држач.', NULL, 'Некачественно! Плохой сервис! Очень больно!
У меня отклеился зубной ретейнер и нужно было приклеить обратно.
Было очень больно когда доктор пыталась снять инструментом предыдущий пломбирующий материал с зубов...инструмент постоянно соскальзывал и ударял в соседние зубы...я скривилась от сильной боли...после этого доктор додумалась взять правильный сверлящий инструмент и снять пломбирующий материал.
Доктор работала без маски и в момент когда она разговаривала с напарницей то плевала мне на лицо, слюна доктора попала мне в глаз...это ужас.
Далее доктор промахнулась и пролила жидкость для рта мне в лицо, глаз и шею  после чего подняла салфетку С ПОЛА и начала протирать мой залитый глаз, лицо и шею...доктора не смутила что салфетка была на полу. Плохой сервис! Некачественно!
Обеспокоена действиями доктора и я не уверена что инструменты дезинфицируют.  Я переживаю за свое здоровье поэтому буду сдавать анализы на ВИЧ и Гепатит.
За то что я иностранка с меня взяли оплату в три раза выше чем для местных жителей. 50 евро чтобы приклеить обратно зубной ретейнер', NULL, NULL,
    10, '2022-05-03 09:28:14'),

(@user_sanja_celanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQwb2VtZ0x3EAE',
    5, 'bs', 'Imam dobro iskustvo sa ovom stomatoloskom ordinacijom. Redovno vodim svoju sedmogodisnju cerku u Dentalux 2. Usluga je za djecu besplatna. Sve u svemu zadovoljna sam.',
    'Imao sam dobro iskustvo sa ovom stomatološkom ordinacijom. Svoju sedmogodišnju ćerku redovno vodim u Dentaluk 2. Usluga je besplatna za decu. Sve u svemu, zadovoljan sam.', 'Имао сам добро искуство са овом стоматолошком ординацијом. Своју седмогодишњу ћерку редовно водим у Денталук 2. Услуга је бесплатна за децу. Све у свему, задовољан сам.', NULL, NULL, NULL, NULL,
    0, '2019-11-08 13:01:22'),

(@user_zorica_kovaevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjMzZhb0NREAE',
    5, 'bs', 'Profesionalnost i ljubaznost je na visokom nivou. Ako ste u potrazi za stomatoloskom ordinacijom u Tivtu,imate sve moje preporuke.',
    'Profesionalizam i ljubaznost su na visokom nivou. Ako tražite stomatološku ordinaciju u Tivtu, imate sve moje preporuke.', 'Професионализам и љубазност су на високом нивоу. Ако тражите стоматолошку ординацију у Тивту, имате све моје препоруке.', NULL, NULL, NULL, NULL,
    2, '2020-05-06 13:36:49'),

(@user_jordanka_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwcmNuMDJnRRAB',
    5, 'bs', 'Profesionalan pristup, moderna oprema, ljubazno i stručno osoblje, za svaku pohvalu i preporuku!',
    'Profesionalni pristup, moderna oprema, ljubazno i stručno osoblje, za svaku pohvalu i preporuku!', 'Професионални приступ, модерна опрема, љубазно и стручно особље, за сваку похвалу и препоруку!', NULL, NULL, NULL, NULL,
    0, '2019-11-15 21:53:28'),

(@user_adrijana_skorupan, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WWk16Sk1hWEpTWWpsMVkzQnFlV2RqY2xseE5IYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_bojana_jelovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w4d2RGcEdSemRFZEc5aE4wSXlMV05sUTJneVlXYxAB',
    5, 'en', 'During my vacation, when you least expect any problems, a wire from my braces turned a carefree holiday into days of pain and discomfort. On the recommendation of my younger sister Dragana, whose orthodontic treatment was completed by Prof. Dr. Snežana Matijević and Prof. Dr. Jasminka Anđelić with outstanding results, I reached out to them for help.

From the moment I walked into the clinic, I felt I was in the right place. They saw me immediately, without any waiting, and within just a few minutes resolved the problem that had been causing me severe pain and bleeding. Their knowledge, expertise, confidence, built on decades of experience, and exceptional professionalism are matched only by the kindness, warmth, and genuine care they show every patient.

It is often said that true professionals reveal themselves when they are needed most. Prof. Dr. Snežana Matijević and Prof. Dr. Jasminka Anđelić proved exactly that through their prompt response, dedication, and willingness to help without hesitation. I believe that every great profession is founded on a love for one’s work, but above all, on compassion for the person who places their trust in your hands. It is this rare combination of outstanding expertise and genuine humanity that truly sets them apart.

My heartfelt thanks to Prof. Dr. Snežana Matijević and Prof. Dr. Jasminka Anđelić for their swift help, compassion, and exceptional care. Dentalux has my warmest recommendation to anyone seeking excellence, professionalism, and a truly caring approach. I wish you continued success and many more happy, smiling patients',
    NULL, NULL, 'During my vacation, when you least expect any problems, a wire from my braces turned a carefree holiday into days of pain and discomfort. On the recommendation of my younger sister Dragana, whose orthodontic treatment was completed by Prof. Dr. Snežana Matijević and Prof. Dr. Jasminka Anđelić with outstanding results, I reached out to them for help.

From the moment I walked into the clinic, I felt I was in the right place. They saw me immediately, without any waiting, and within just a few minutes resolved the problem that had been causing me severe pain and bleeding. Their knowledge, expertise, confidence, built on decades of experience, and exceptional professionalism are matched only by the kindness, warmth, and genuine care they show every patient.

It is often said that true professionals reveal themselves when they are needed most. Prof. Dr. Snežana Matijević and Prof. Dr. Jasminka Anđelić proved exactly that through their prompt response, dedication, and willingness to help without hesitation. I believe that every great profession is founded on a love for one’s work, but above all, on compassion for the person who places their trust in your hands. It is this rare combination of outstanding expertise and genuine humanity that truly sets them apart.

My heartfelt thanks to Prof. Dr. Snežana Matijević and Prof. Dr. Jasminka Anđelić for their swift help, compassion, and exceptional care. Dentalux has my warmest recommendation to anyone seeking excellence, professionalism, and a truly caring approach. I wish you continued success and many more happy, smiling patients', NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_marijana_prelevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sQ1FYZGpPVkZaTmtRdFpWWlhaSGhpT1doM1NVRRAB',
    1, 'hr', 'Od sitnog problema, nakon noṣ̌enja fiksne, napravljeno ṣ̌est novih. Izvađena 4 (četiri!) zdrava zuba bez ikakve potrebe, nisu čak ni protezom mogli da zatvore ṣ̌upljine. Naravno, zbog viṣ̌ka prostora su se i svi ostali zubi razdvojili, tako da umjesto "osmijeha za cijeli život" imam katastrofu za cijeli život! Nakon dvije godine sam se vratila da pokažem ṣ̌ta se desilo sa zubima, a "doktorica" Anđelić je nonṣ̌alantno rekla:"Pa nisu se ustabilili"🤣 Bez trunke odgovornosti i empatije. Izbjegavajte ovu ordinaciju u ṣ̌irokom luku!',
    'Od sitnog problema, nakon noṣ̌enja fiksne, napravljeno ṣ̌est novih. Izvađena 4 (četiri!) zdrava zuba bez ikakve potrebe, nisu čak ni protezom mogli da zatvore ṣ̌upljine. Naravno, zbog viṣ̌ka prostora su se i svi ostali zubi razdvojili, tako da umjesto "osmijeha za cijeli život" imam katastrofu za cijeli život! Nakon dvije godine sam se vratila da pokažem ṣ̌ta se desilo sa zubima, a "doktorica" Anđelić je nonṣ̌alantno rekla:"Pa nisu se ustabilili"🤣 Bez trunke odgovornosti i empatije. Izbjegavajte ovu ordinaciju u ṣ̌irokom luku!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_user_109087051633247930841, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkUVpsRnBNbTVTYmpSMGQyOXRUMFJPV21sbFluYxAB',
    5, 'hr', 'Najbolje i najdivnije doktorice ♥️♥️♥️',
    'Najbolje i najdivnije doktorice ♥️♥️♥️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_elias_del_barco, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT201alMzYzJhWEJQU1haUFdGWjRURkU0VVhkMWJHYxAB',
    5, 'en', 'So so good service!!! I love this ladies!!',
    NULL, NULL, 'So so good service!!! I love this ladies!!', NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_mario_kurtin, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0cFQwTm1URzA1YjBjeWEyOHdaMlIxY0hGM1ZtYxAB',
    5, 'hr', 'Jako sam zadovoljan sa rezultatima koje smo postigli nošenjem fiksne proteze za samo godinu dana smo riješili problem za koji su mnogi ortodonti rekli da se mora radit operacija,imao sam otvoren zagrižaj i usku vilicu ,zahvaljujući njima sada je sve oky.
Preporučio bih svako me ovakve eksperte u svome poslu ..veliko vam hvala

I am very satisfied with the results we achieved by wearing fixed prostheses, in just one year we solved the problem that many orthodontists said required surgery, I had an open bite and a narrow jaw, thanks to them everything is ok now.
I would recommend such experts to everyone in their work...thank you very much',
    'Jako sam zadovoljan sa rezultatima koje smo postigli nošenjem fiksne proteze za samo godinu dana smo riješili problem za koji su mnogi ortodonti rekli da se mora radit operacija,imao sam otvoren zagrižaj i usku vilicu ,zahvaljujući njima sada je sve oky.
Preporučio bih svako me ovakve eksperte u svome poslu ..veliko vam hvala

I am very satisfied with the results we achieved by wearing fixed prostheses, in just one year we solved the problem that many orthodontists said required surgery, I had an open bite and a narrow jaw, thanks to them everything is ok now.
I would recommend such experts to everyone in their work...thank you very much', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_vuk_tomanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xONk9EZEVRM2t6YnkxMlZHOVBibE5qTkZNM1ZWRRAB',
    5, 'en', 'Very fast visible results, pleasant and professional staff, I highly recommend!',
    NULL, NULL, 'Very fast visible results, pleasant and professional staff, I highly recommend!', NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_iliana_bakmaz, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s1SWFqZEdaa054U0Zwa1RHNXJNVkZNUWpkR1dXYxAB',
    5, 'bs', 'Sve pohvale za moje drage doktorice! Od prvog dolaska osjećala sam se ugodno i sigurno. Doktorice su izuzetno ljubazne, profesionalne i posvećene svom radu i svakom pacijentu. Rad je vrhunski, sve je detaljno objašnjeno a rezultat je odličan. Zaista se vidi da im je stalo do kvalitete usluge i zadovoljstva pacijenata. Iskreno preporučujem Dentalux Dental Clinic svima koji traže vrhunsku stomatološku uslugu. Hvala vam na svemu!💕pozdrav sa Aljaske😘',
    'Sve pohvale za moje drage doktorice! Od prvog dolaska osjećala sam se ugodno i sigurno. Doktorice su izuzetno ljubazne, profesionalne i posvećene svom radu i svakom pacijentu. Rad je vrhunski, sve je detaljno objašnjeno a rezultat je odličan. Zaista se vidi da im je stalo do kvalitete usluge i zadovoljstva pacijenata. Iskreno preporučujem Dentalux Dental Clinic svima koji traže vrhunsku stomatološku uslugu. Hvala vam na svemu!💕pozdrav sa Aljaske😘', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_martina_muura, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaRWJFRkZTV3BtWkRVdFZEUlNXVWhsUms1RFlYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_ognjen_pavicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tZMmVFSnlVR1pxY1ZCcmN6bENlR1I1ZERJdFpFRRAB',
    5, 'hr', 'Preporuka od srca!
Konacno imam osmijeh sa kojim sam zadovoljan',
    'Preporuka od srca!
Konacno imam osmijeh sa kojim sam zadovoljan', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_mija_milunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SeWNVNUVVbFZPVjJNMVlWVjVSR1JXY0c1UE5WRRAB',
    5, 'hr', 'U ovu ordinaciju sam dolazila još kao dijete, a nakon nekoliko godina ponovo sam se vratila i kvalitet usluge je i dalje na vrhunskom nivou. Doktorke su ljubazne, srdačne i veoma stručne. Sve preporuke!',
    'U ovu ordinaciju sam dolazila još kao dijete, a nakon nekoliko godina ponovo sam se vratila i kvalitet usluge je i dalje na vrhunskom nivou. Doktorke su ljubazne, srdačne i veoma stručne. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_lena_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tVNWMwMVFNVmxXZUZsQk5tODNiVjlPYzBzeE5YYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_boris_mirkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21vMk0weHpabWRsVG5kcU9VTTNVSFV3U21kQmVFRRAB',
    1, 'bs', 'Najgora klinika u Tivtu!!!',
    'Najgora klinika u Tivtu!!!', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_bon_mladenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxa1JWQmhXV0Z0VWxoa1dEaFRhMXBhZVdoNlJuYxAB',
    1, 'hr', 'Najgora klinika!',
    'Najgora klinika!', NULL, NULL, NULL, NULL, NULL,
    1, '2025-10-29 00:00:00'),

(@user_wander_gaze, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sTVIyUndSbkJzWVVaeWVGVkNTWFZ6T0ZGS1UyYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dilan_boyraz, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkQlozSndVRFk1V0ZwQk5tdFJXbUY2WkVKcFUxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_teodora_peric, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2trMGNqQnpOMmx0YVU1bVQyMHlkemRzTlVObFZHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_nina_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xBdFZtaEJNVjk1TlV0alRGOTBVemRWWmxjelEyYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dimitrije_zivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnTUN3MXYzcFNREAE',
    5, 'hr', 'Najbolja preporuka. Highly recommended',
    'Najbolja preporuka. Highly recommended', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragoljub_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNuMzh1Q1h3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_natasa_joncic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSURwb3NIbEpBEAE',
    1, 'en', 'First they ask what is the issue than if it is something small for a kid they say no no we are not open on saturday.',
    NULL, NULL, 'First they ask what is the issue than if it is something small for a kid they say no no we are not open on saturday.', NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_kristina_korievskaya, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChdDSUhNMG9nS0VJQ0FnSURwbElDZnlBRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_nela_radunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChdDSUhNMG9nS0VJQ0FnSURoc0tPUDBBRRAB',
    1, 'bs', 'Odlicni u marketngu, za to cista petica.',
    'Odlicni u marketngu, za to cista petica.', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_stan_stan, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSURCcnJtWkt3EAE',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_andreano_celentano, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUMtcGFEcFFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_milovan_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUMtd2JlcE9REAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_igor_rumyantsev, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSURjNUtqX0J3EAE',
    5, 'ru', 'Качественная стоматология и отличный сервис! Рекомендую!',
    NULL, NULL, NULL, 'Качественная стоматология и отличный сервис! Рекомендую!', NULL, NULL,
    2, '2020-10-29 00:00:00'),

(@user_dijana_fantic, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQwb2VtMll3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_milica_morovan, @clinic_id, NULL, 'google_maps',
    'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwb1l6YnBBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUQwb2VtZ0x3EAE'),
  'clinic', @clinic_id,
  'Hvala Vam na povjerenju.', 'hr',
  'Hvala Vam na povjerenju.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2020-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJe7RkFpYxTBMRHTr3t1ahdTY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjMzZhb0NREAE'),
  'clinic', @clinic_id,
  'Od srca Vam hvala na povjerenju i preporuci!', 'hr',
  'Od srca Vam hvala na povjerenju i preporuci!', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2020-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
