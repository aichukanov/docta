-- Insert Google Maps reviews for Институт за јавно здравље
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/institut-za-javno-zdravlje-crne-gore-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'institut-za-javno-zdravlje-crne-gore-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ланчеМи', 'https://lh3.googleusercontent.com/a/ACg8ocJ7HC1eR2ta33ee3D7mnLJomzzSe7Dw4z2aqFKWGqTGUH8YXQ=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/114799261578461793371/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114799261578461793371/reviews');
SET @user_lanchemi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114799261578461793371/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Medarevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUyqwyu6f8k14iwRURwRH5MaDiUjzvdhpyvMcJBi_G3rIr-6vo6=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/103639764491115984371/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103639764491115984371/reviews');
SET @user_aleksandar_medarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103639764491115984371/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Berilazic', 'https://lh3.googleusercontent.com/a/ACg8ocIXEvk_86hGnNVBN6LsafN7UZwEL-hM0Lq7fH9yh-gmy0rsUg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101180173082265429510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101180173082265429510/reviews');
SET @user_marina_berilazic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101180173082265429510/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'KITTY PE', 'https://lh3.googleusercontent.com/a/ACg8ocJCmLtftpW29pyNHPi3qc5u_00S7eEszI32teQ_y_mbVqwZ7g=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/102081309127986131845/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102081309127986131845/reviews');
SET @user_kitty_pe = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102081309127986131845/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Foka Raspala', 'https://lh3.googleusercontent.com/a/ACg8ocKrPzVphN4XLkc9J-FYgG7WJQBZr-2qu46Jyxu0C_oh4_vC2w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107632683169322530158/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107632683169322530158/reviews');
SET @user_foka_raspala = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107632683169322530158/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igor Radetic', 'https://lh3.googleusercontent.com/a/ACg8ocJu0pSWubMROIZAgSSP1QMu94URzcs_AHButTvk7SivJIMdLw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103470774250795033326/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103470774250795033326/reviews');
SET @user_igor_radetic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103470774250795033326/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'oguz capar', 'https://lh3.googleusercontent.com/a-/ALV-UjXv0ILBNcRk6tVzpCXJ-DCimMMEVOQZSo-zkr3TQUsgX0SOmUk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100388763568684358100/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100388763568684358100/reviews');
SET @user_oguz_capar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100388763568684358100/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Boško Vukadinović', 'https://lh3.googleusercontent.com/a-/ALV-UjU2c3-ILXXp8toLdMf5zCQZIXOHH9YdoZ2jWyqvHoQos5l1pP8teg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114043703970999849435/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114043703970999849435/reviews');
SET @user_boko_vukadinovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114043703970999849435/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Janković', 'https://lh3.googleusercontent.com/a/ACg8ocIlu2_z7wOULgg0XF0ruinyCJX6ZO3uumFToak-j2F_r3mznw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115835917294684965133/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115835917294684965133/reviews');
SET @user_ana_jankovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115835917294684965133/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jagos Jelenic', 'https://lh3.googleusercontent.com/a/ACg8ocJ2XEdVwhUtOEc90cclHiAozuugJObyvq7kgjbxdsGrimD-yA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106168261515394844342/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106168261515394844342/reviews');
SET @user_jagos_jelenic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106168261515394844342/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Spasojević', 'https://lh3.googleusercontent.com/a/ACg8ocLroBqwV_Uqsd0400dRevcUMXsC1EOLd15HwEmfuNVq8ga11GM=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108972251675246946521/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108972251675246946521/reviews');
SET @user_ivan_spasojevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108972251675246946521/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vojislav Susa', 'https://lh3.googleusercontent.com/a-/ALV-UjXo6DujfRy1WGKy0zjvSSbtoUvOK4zGQl0HB8yelYdmUquAHgyH=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108860167758902550806/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108860167758902550806/reviews');
SET @user_vojislav_susa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108860167758902550806/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ernad Topuzovic', 'https://lh3.googleusercontent.com/a/ACg8ocKDXd1w_FFqA9JH7prLa2hXs75r7g3uanThK1Mz9P8I81sVM_g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106888845401858909902/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106888845401858909902/reviews');
SET @user_ernad_topuzovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106888845401858909902/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Ristovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXDowoZ52CueCFQ7cVmrmfISED0fm5r9m2m9y7CCOxAMjqhGE-P=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113443849740414355325/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113443849740414355325/reviews');
SET @user_aleksandar_ristovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113443849740414355325/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Momcilo Baranin', 'https://lh3.googleusercontent.com/a-/ALV-UjWro478UT5e18KmC9n-tgEFT27SKtV17_YATIvbOwz93KfKugT5oQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109523007851450089263/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109523007851450089263/reviews');
SET @user_momcilo_baranin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109523007851450089263/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Kuzman', 'https://lh3.googleusercontent.com/a-/ALV-UjVBoCv43CWUqqGBgD0RZwPDLqL3FmG83JKpFbs_j8DrIXSieFY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100012240900091104965/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100012240900091104965/reviews');
SET @user_mirko_kuzman = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100012240900091104965/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danilo Knezevic', 'https://lh3.googleusercontent.com/a-/ALV-UjV-sdJiVne1G88G2M4J6jGL7X9G3lhLBfR0rcuDR1gCsVOfntEY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113998314377361420352/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113998314377361420352/reviews');
SET @user_danilo_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113998314377361420352/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lana Bojic', 'https://lh3.googleusercontent.com/a/ACg8ocIsiIxkXH6Apy85kXXeIB0JFOuBZi0PD5FNChevcw__5uc0og=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108329732149674798585/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108329732149674798585/reviews');
SET @user_lana_bojic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108329732149674798585/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Cvr6cx', 'https://lh3.googleusercontent.com/a-/ALV-UjXWREWC0CHD-L3Nk1k32948Zhj0WSRfSfKEzOuEB8zR0DaqZnYfnQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112784140261517857562/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112784140261517857562/reviews');
SET @user_cvr6cx = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112784140261517857562/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Данијела Прелевић', 'https://lh3.googleusercontent.com/a-/ALV-UjVrh0rs72jHQuTQ6h_KTeVFHUdPXMIuGJmJ9Q657CfOWjt9t23eug=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111134764343409696472/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111134764343409696472/reviews');
SET @user_danijela_prelevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111134764343409696472/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dijana tomasevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXHxuhMoB3r0RStZHrHePLDcOtOpgeyJkycKcmLCb_5d7_a_lJ2=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118366243347299922587/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118366243347299922587/reviews');
SET @user_dijana_tomasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118366243347299922587/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Михаил В.', 'https://lh3.googleusercontent.com/a/ACg8ocIvm-5alZPltJ9O33NDAUvFbVvatxTtvRUhbawpStwHaCdDnw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116514347904631178743/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116514347904631178743/reviews');
SET @user_mikhail_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116514347904631178743/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Milic', 'https://lh3.googleusercontent.com/a/ACg8ocIuVb2esNLRx389Z6xbJwRRkEF4urW7IJhT4b_MsovXt_eRhg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107191170081057832184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');
SET @user_marko_milic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107191170081057832184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irena Ivana Miranovic', 'https://lh3.googleusercontent.com/a/ACg8ocInT2Zl0WJEf3Hhzg_8wfdiw49geGbv_i6Pnn26emlMGIAa9Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100503017250353705926/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100503017250353705926/reviews');
SET @user_irena_ivana_miranovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100503017250353705926/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ariana Rrenja', 'https://lh3.googleusercontent.com/a/ACg8ocKIArdvH3LQ861Ymdt5NbCZ4n7zhZn7R5dwuxT5zeaNMStzZQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117718155040097134175/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117718155040097134175/reviews');
SET @user_ariana_rrenja = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117718155040097134175/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jack', 'https://lh3.googleusercontent.com/a/ACg8ocK87WqVZ3UZe5itTJZfhUrKJozHtYAwbZqEFu9UyoOBVsOygw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101667230253524041017/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101667230253524041017/reviews');
SET @user_jack = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101667230253524041017/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natsukful', 'https://lh3.googleusercontent.com/a-/ALV-UjWGpLrwwbI5eUM3bjtqyyvt6swR4oNjWzWtOdAPMN9dkQdCDEOo=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114010411469339478823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114010411469339478823/reviews');
SET @user_natsukful = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114010411469339478823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matija Blagojević', 'https://lh3.googleusercontent.com/a/ACg8ocJ8Jsy1p4Jsy0RtFkJiNqK6NR_HgEHPDFsBMu4_eqJoSu-izQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112929317324536619386/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112929317324536619386/reviews');
SET @user_matija_blagojevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112929317324536619386/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vlado L.', 'https://lh3.googleusercontent.com/a/ACg8ocJaxrKaTczxE_ECByCYTfraMPXDyNbkLCOo_ImCp5LnrJoG4Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103388639539334734411/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103388639539334734411/reviews');
SET @user_vlado_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103388639539334734411/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikita Terekhov', 'https://lh3.googleusercontent.com/a/ACg8ocIrPEiduQyWVeKW90Q1DtqFmVzBo3d76Ym15HnHzCnRK0xq2EZV=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113100344396388764138/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113100344396388764138/reviews');
SET @user_nikita_terekhov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113100344396388764138/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suat Karabacak', 'https://lh3.googleusercontent.com/a/ACg8ocIdg7kFYd2KfoquW4VLfcTzvrzei_lGsbToHedYB20eAAud6A=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109273026273407839566/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109273026273407839566/reviews');
SET @user_suat_karabacak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109273026273407839566/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'SandraM', 'https://lh3.googleusercontent.com/a-/ALV-UjUy9JCh-NysohshqGkALVRr-lx_SHABXIHElSo7iaUGorwJB5Y=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117075938462103888714/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117075938462103888714/reviews');
SET @user_sandram = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117075938462103888714/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Ajkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKOcyaKDEGQtcDSgmhd52v1bGvAru1tbxycvFkNilj2WMFLmgg2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114810662304971261244/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114810662304971261244/reviews');
SET @user_jelena_ajkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114810662304971261244/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'budva business', 'https://lh3.googleusercontent.com/a-/ALV-UjU4N8Q4xbHmBOatoNB5k5T0BEYhlMB06bX6soc7c7UiCvwKokE7=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111665260739822091049/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111665260739822091049/reviews');
SET @user_budva_business = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111665260739822091049/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Samardzic', 'https://lh3.googleusercontent.com/a-/ALV-UjVsNeuJpTn8MQNlqJ1kKAtT5Tmqw6IaKw12fi1sbbe6IkuQmMIG=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114814168084650064012/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114814168084650064012/reviews');
SET @user_jovan_samardzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114814168084650064012/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елизавета Чепурко', 'https://lh3.googleusercontent.com/a-/ALV-UjXVaLzaRQyLA2ofr4VUgr8uSCasLTKObbhMahQzHESVuDfS4DGu=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106612103122750467885/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106612103122750467885/reviews');
SET @user_elizaveta_chepurko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106612103122750467885/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Filip Ivanović', 'https://lh3.googleusercontent.com/a-/ALV-UjWjkI9UObeptEal7eariQpSNopW0gbIYFkd-8Z3BWDsCi45V5vAtA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106170641695526877970/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106170641695526877970/reviews');
SET @user_filip_ivanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106170641695526877970/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S V', 'https://lh3.googleusercontent.com/a-/ALV-UjUib6kfkk2RAJunOIlJUX87TIcbIwRypXRH1zNCRP6H1rPZ4meZ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107548424702796757263/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107548424702796757263/reviews');
SET @user_s_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107548424702796757263/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovan Samardzic', 'https://lh3.googleusercontent.com/a-/ALV-UjUX7HK9wsMg17U5oBbw8A4QJNFQ1u65ldIeSshrgrF2-gT9OwO_=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111830763582360626805/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111830763582360626805/reviews');
SET @user_jovan_samardzic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111830763582360626805/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Susan Dunlop', 'https://lh3.googleusercontent.com/a/ACg8ocLaB5j2xO_OD6G19qhibQJKyYwzguGf5fOaMlq5Xazz-bkFjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101280191075028560775/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101280191075028560775/reviews');
SET @user_susan_dunlop = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101280191075028560775/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amanda Besirevic', 'https://lh3.googleusercontent.com/a/ACg8ocLhITly8gXZRJKM6t0TigwVZx797ATp-XZe6gh-njjAtjkX7g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116579863719682273974/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116579863719682273974/reviews');
SET @user_amanda_besirevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116579863719682273974/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ACO Ronaldo', 'https://lh3.googleusercontent.com/a-/ALV-UjVUAnfp9qatcJO6MO6EyJZtvR8CorqsAwmShvLpEam3pESaSJ4=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110995361022805361986/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995361022805361986/reviews');
SET @user_aco_ronaldo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995361022805361986/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gruna Stramen', 'https://lh3.googleusercontent.com/a-/ALV-UjUd3I0_y8jLQaXX-xgguIJqlTd3_cbh1QZopCxrdsej1xoBQj4T=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115783742535008756579/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115783742535008756579/reviews');
SET @user_gruna_stramen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115783742535008756579/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branislav Lazovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUO1H5Shwa4auHwSh9uIcHhyJi4Hbifbv-sbzan0wSQJUUVGTMO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113067998480580848510/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113067998480580848510/reviews');
SET @user_branislav_lazovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113067998480580848510/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'pasha savitskiy', 'https://lh3.googleusercontent.com/a/ACg8ocKmOL9eLuINlbpbJ4vsI-9AA5wAz37XHWfYqt1YWLbfde6uqw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101722080736329451708/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101722080736329451708/reviews');
SET @user_pasha_savitskiy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101722080736329451708/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Vukasinovic', 'https://lh3.googleusercontent.com/a/ACg8ocKKkYOoyidD_CSoagD5yuMrZlb2Y8W144amCifsGMBdiLyXZg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117348309267785379176/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117348309267785379176/reviews');
SET @user_anastasija_vukasinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117348309267785379176/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goga Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocJpTBEvEfWhSR0NNs67vMwqyONkiksI4_-qgaOygfJCdGzfGG8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113371533241668830899/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113371533241668830899/reviews');
SET @user_goga_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113371533241668830899/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Олександр Довгорукий', 'https://lh3.googleusercontent.com/a/ACg8ocIn4gsZI1seHNiosraNQdePNB0horMe7-n0O72p33Ah64SlqA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113556027332865938612/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113556027332865938612/reviews');
SET @user_oleksandr_dovgorukiy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113556027332865938612/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Grisonian (Grisonian)', 'https://lh3.googleusercontent.com/a-/ALV-UjU-yrKd7aDljrba98lV1RkiftxN7-CdYLzO4f2W3MhnHpMqeBfl=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114442570274465229317/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114442570274465229317/reviews');
SET @user_grisonian_grisonian = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114442570274465229317/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miodrag Krkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXCf4H4fiAEwj3YW4dfBjHOkIbWJPDfTIwJ8q1oXQ80BF0fSWc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101675937422592793465/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101675937422592793465/reviews');
SET @user_miodrag_krkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101675937422592793465/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Ostojić', 'https://lh3.googleusercontent.com/a/ACg8ocJbGHQE4-gs4YXsPp9Zv3f2H_mGO-21vu3MVAJ7y3eSOXCw0w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108084778807595050507/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108084778807595050507/reviews');
SET @user_nikola_ostoji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108084778807595050507/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivica Vujacic', 'https://lh3.googleusercontent.com/a/ACg8ocKxavCbKX19bCBAQoa8CdA-GjOu4jUVMIhVQnIxo1_LrI8qyg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103940883772622478769/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103940883772622478769/reviews');
SET @user_ivica_vujacic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103940883772622478769/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'armin88 suka', 'https://lh3.googleusercontent.com/a/ACg8ocJvskmABnfDMLrOV6n6rXpdgBNVMF_r_B98MGGKmUlWW4fWjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105580555186791305824/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105580555186791305824/reviews');
SET @user_armin88_suka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105580555186791305824/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stevan Cakic', 'https://lh3.googleusercontent.com/a-/ALV-UjXDmrVeaKFRc8wstDPyL_0USgWduyYRNHwqcQ_48GKocchFtuBV=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109051562761289614476/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109051562761289614476/reviews');
SET @user_stevan_cakic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109051562761289614476/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Verica Lekovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWyb3zbC9k_CKmfLHkRG7onHRD5S7pERiWzNoSJxaV8J0_91Nr0=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107838270548025303206/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107838270548025303206/reviews');
SET @user_verica_lekovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107838270548025303206/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'B. M.', 'https://lh3.googleusercontent.com/a/ACg8ocKDreTEQF9iaI8wEpEOD3yHQYgyW1zP0EXBccUFjUDiSivQ9A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115701588894168923021/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115701588894168923021/reviews');
SET @user_b_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115701588894168923021/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anđela Goranović', 'https://lh3.googleusercontent.com/a/ACg8ocLNnji-X4kj6qrEmSsiNv1U61MawmkJ7MNo_51ZK2TTWteNXg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112933065209739040979/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112933065209739040979/reviews');
SET @user_anela_goranovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112933065209739040979/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kalezić Danijel', 'https://lh3.googleusercontent.com/a-/ALV-UjX8JnU-yxpcwg4ZAdMNcJxr-jHp5WTHG-sdjRUAc-vAMJl3Kxne=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115270104505558978091/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115270104505558978091/reviews');
SET @user_kalezi_danijel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115270104505558978091/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Biljana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocKDOfZUF3X76E3nqBgJ5X0UcWwSrP_EooEksVEHHRGHpd2H0w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110478311578754596964/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110478311578754596964/reviews');
SET @user_biljana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110478311578754596964/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka', 'https://lh3.googleusercontent.com/a-/ALV-UjVauicBuexNNeH3MRm9kOeyFYqpLbfKMEJ3NaHk1iHigYdGa8-U2g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105883676195361895917/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105883676195361895917/reviews');
SET @user_luka = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105883676195361895917/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Azra Suruliz', 'https://lh3.googleusercontent.com/a-/ALV-UjXsry-q6lViZLda2HmR-2kYt-AElvnxzj8J2Kwnb4010pLhHNC-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115302162631665782291/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115302162631665782291/reviews');
SET @user_azra_suruliz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115302162631665782291/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Jablan', 'https://lh3.googleusercontent.com/a-/ALV-UjU1BEtjivWM2PZ8PiHMMOkCOV3Y8cm8bl9UQmFuJjiKLUyrgj_WhA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116534685683498311105/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116534685683498311105/reviews');
SET @user_marko_jablan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116534685683498311105/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Despotović', 'https://lh3.googleusercontent.com/a-/ALV-UjUhhs0yh4qG33lscBmG4GcIO4rZX-3zU6w0zf8Dsosm5sr31y23=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100503107951984865037/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100503107951984865037/reviews');
SET @user_anastasija_despotovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100503107951984865037/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S. Shady', 'https://lh3.googleusercontent.com/a-/ALV-UjVlj-MNZ9hTbMeAZV8e0aBdqBN_8s6oxU9jOEtNA1kFYM3a2hI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102498027637065522994/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102498027637065522994/reviews');
SET @user_s_shady = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102498027637065522994/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Damjanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUQz4muD25Q_VhYbI7KMF3lUu4g9K8ykJc2uzY4QpXBrQzaSVyD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111306756600733175770/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111306756600733175770/reviews');
SET @user_dragana_damjanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111306756600733175770/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Boricic', 'https://lh3.googleusercontent.com/a-/ALV-UjXP_4mSTryor5wDTxIfbsNl6WMBBZ4tHuQk5fNs38al_ILoKXSb=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103421955578094383400/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103421955578094383400/reviews');
SET @user_jovana_boricic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103421955578094383400/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rabbit Shadow', 'https://lh3.googleusercontent.com/a/ACg8ocLcLh2Yr58AhKkzg8qlomAdmoJetVx1Oc61M8Zf-byVFBsz1w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105988949407854823390/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105988949407854823390/reviews');
SET @user_rabbit_shadow = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105988949407854823390/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandron Lajakot', 'https://lh3.googleusercontent.com/a/ACg8ocI19p6T7ARIUV-9pW2cKsoKd3TEWweSGJhtqWGVMCDr2B3jgA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101050868067389088525/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101050868067389088525/reviews');
SET @user_aleksandron_lajakot = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101050868067389088525/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goran Vuletic', 'https://lh3.googleusercontent.com/a-/ALV-UjVDeOYYl87vEgwiKBPiqej0A2VFpRv9aoKxe08RR57-2EkGxNyU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109034346589452452601/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109034346589452452601/reviews');
SET @user_goran_vuletic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109034346589452452601/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'mona maričić', 'https://lh3.googleusercontent.com/a/ACg8ocLkjhstk_aXKCN0lGvgvk1Pr_cXxlF6uZ-SmSKJxUxDF8Y-Uw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101959506335947309485/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101959506335947309485/reviews');
SET @user_mona_marii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101959506335947309485/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Marjanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJ24vM7pgFOKNFVnTVQ1VMCB4XAzqH3eQq6KXGPD6zUOMU1W44=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111012754040382957020/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111012754040382957020/reviews');
SET @user_ana_marjanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111012754040382957020/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'BVB BVB', 'https://lh3.googleusercontent.com/a-/ALV-UjVeDOlCPC3UPDVQrMZCVahYz1vRioTfAgpWmWezDTMKTiuagDU=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114119070656795804669/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114119070656795804669/reviews');
SET @user_bvb_bvb = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114119070656795804669/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nikola markovic', 'https://lh3.googleusercontent.com/a/ACg8ocL1_OBkD1t41pJHDCL4Ly9TwZLbN2yxVDhd6K06tX2MY6jx-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114676870209233598766/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114676870209233598766/reviews');
SET @user_nikola_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114676870209233598766/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijela Knezevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW04mNRQ7mzi7yQ_Zx9bIfptHIHCm6deIIjPGOoa3_ZAB_OOwWh4Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109371602689645927012/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109371602689645927012/reviews');
SET @user_danijela_knezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109371602689645927012/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandar Ristovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVQJGrz6hR6pNs980n1AwyYmPPwpsfA39yloKwk53n7f3mbWBVl=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100825094989176223010/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100825094989176223010/reviews');
SET @user_aleksandar_ristovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100825094989176223010/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ALFA Nekretnine', 'https://lh3.googleusercontent.com/a-/ALV-UjU2HrHpbUytKa0PGSXI3Ddqdt2HGmXtcsjhgexpYhb8XOYZzOw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100761076846767187223/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100761076846767187223/reviews');
SET @user_alfa_nekretnine = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100761076846767187223/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Zivkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVQSFsNeECk0N5-sFBiOJRgCpLLnwrNGd_8JDMeVCYS1oMqCls3=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114725564750942066039/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114725564750942066039/reviews');
SET @user_tamara_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114725564750942066039/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pavle Đurović', 'https://lh3.googleusercontent.com/a-/ALV-UjUh3oB6O1HxdvsaMlwTEaa2WD0yh2vAiccx3PJoIJL1fQEPEWjv=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103813509047746960321/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103813509047746960321/reviews');
SET @user_pavle_urovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103813509047746960321/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'tamara jelic', 'https://lh3.googleusercontent.com/a/ACg8ocKoPSZE-g1BslVqnZdi0mbcY9CqCj1G6ESzo2YRtRVOAlAaTQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103738534925659069828/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103738534925659069828/reviews');
SET @user_tamara_jelic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103738534925659069828/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Max LM', 'https://lh3.googleusercontent.com/a-/ALV-UjUSixXsdN2MuCbXH5UQQvHTBFbt_EU4eBc3vqa-RYtI7gKnU36t=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102090172530098787086/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102090172530098787086/reviews');
SET @user_max_lm = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102090172530098787086/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adri Syaur', 'https://lh3.googleusercontent.com/a/ACg8ocK5ylSBLSUNjF4cForhntwnJHXTY_riXpb4UDUcdBt-55YwOg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110445335876937075921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110445335876937075921/reviews');
SET @user_adri_syaur = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110445335876937075921/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_lanchemi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tzMVNrWkpSbTR0YkhCblJWQk5PVXgwV0hwaFJWRRAB',
    1, 'sr', 'Недељу дана не умијете одговорити на телефон, све вам у дом!',
    'Nedelju dana ne umijete odgovoriti na telefon, sve vam u dom!', 'Недељу дана не умијете одговорити на телефон, све вам у дом!', NULL, NULL, NULL, NULL,
    0, '2026-01-19 11:34:00'),

(@user_aleksandar_medarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSURxOHNmYmFREAE',
    4, 'sr', 'Нови систем за праћење ковида је одличан. Види се да није рађен преко братије.',
    'Novi sistem za praćenje kovida je odličan. Vidi se da nije rađen preko bratije.', 'Нови систем за праћење ковида је одличан. Види се да није рађен преко братије.', NULL, NULL, NULL, NULL,
    0, '2021-11-06 08:30:33'),

(@user_marina_berilazic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUMzNXBqeDhRRRAB',
    1, 'hr', 'Ako trebaš za nalaze da predaš, možeš računati da ćeš ostati pola dana. Uz to parkinga nema. Ljudi koji rade nisu naročito ljubazni, ali u našoj državi u rijetko kojoj instituciji jesu, pa ovo nije novina.',
    'Ako treba da predate rezultate, možete očekivati da ćete ostati pola dana. Pored toga, nema parkinga. Ljudi koji rade nisu naročito ljubazni, ali u našoj zemlji retko su u bilo kojoj ustanovi, tako da ovo nije ništa novo.', 'Ако треба да предате резултате, можете очекивати да ћете остати пола дана. Поред тога, нема паркинга. Људи који раде нису нарочито љубазни, али у нашој земљи ретко су у било којој установи, тако да ово није ништа ново.', NULL, NULL, NULL, NULL,
    0, '2024-11-05 07:40:06'),

(@user_kitty_pe, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNIc3Z5bktREAE',
    1, 'bs', 'Broj nije aktivan, a takvo nesto za instituciju od ovog znacaja je neprihvatljivo. Crna Gora I kum, rodjak, prijatelj.',
    'Broj nije aktivan, a tako nešto za instituciju ovog značaja je neprihvatljivo. Crna Gora I kum, rođak, prijatelj.', 'Број није активан, а тако нешто за институцију овог значаја је неприхватљиво. Црна Гора И кум, рођак, пријатељ.', NULL, NULL, NULL, NULL,
    0, '2024-09-03 09:25:00'),

(@user_foka_raspala, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNDd0ttdU53EAE',
    1, 'hr', 'Web stranica izgleda dobro. Medjutim, danima niko ne odgovara na telefon. Nakon što sam ispunio upitnik na sajtu koji kaže \'\'pozvaće Vas neko iz Instituta\'\' - niko me nije pozvao. Dnevni presjek stanja u 17 sati se objavljuje i nakon 17 sati. Razumijem da se Institut suočava sa ozbiljnom epidemijom, ali građani zaslužuju Institut koji je u stanju da odgovori na pitanja običnih građana koji nisu novinari.',
    'Web stranica izgleda dobro. Medjutim, danima niko ne odgovara na telefon. Nakon što sam ispunio upitnik na sajtu koji kaže \'\'pozvaće Vas neko iz Instituta\'\' - niko me nije pozvao. Dnevni presjek stanja u 17 sati se objavljuje i nakon 17 sati. Razumijem da se Institut suočava sa ozbiljnom epidemijom, ali građani zaslužuju Institut koji je u stanju da odgovori na pitanja običnih građana koji nisu novinari.', NULL, NULL, NULL, NULL, NULL,
    6, '2020-08-06 16:15:18'),

(@user_igor_radetic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWU05WbEZNUzF4YzFCSFlURnlPVGQ1VVdkV1NXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-15 00:00:00'),

(@user_oguz_capar, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toRVZFSmpORmxSVm01algwSkdTelJZU0hoMVJVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_boko_vukadinovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsaFp6RjBaeTFEWmxSRVp6WlFORVZFVEZGV1FWRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_ana_jankovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25adGRFMVNSVEUyUVdOQ05GcE1UMWhSTUU0M1FYYxAB',
    1, 'bs', 'Čekala sam red preko 20 minuta da bi mi na šalteru rekli "nemamo više testova za helikobakteriju".
Mogli ste napisati obavještenje na vrata da ne gubim vrijeme i da pođem privatno dok mi je uzorak i dalje svjež (iako ne kapiram kako je moguće da vam nestanu testovi...).
Užas.',
    'Čekala sam red preko 20 minuta da bi mi na šalteru rekli "nemamo više testova za helikobakteriju".
Mogli ste napisati obavještenje na vrata da ne gubim vrijeme i da pođem privatno dok mi je uzorak i dalje svjež (iako ne kapiram kako je moguće da vam nestanu testovi...).
Užas.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jagos_jelenic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tkVWRGQjJOVXRyUmt4dVNVSnhkR3BGYjI1QlpXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_ivan_spasojevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tJMWVrNTJSMDFsYjNsSWFFNUNUMHBvT0ZOalFWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_vojislav_susa, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT21odFRUUXhVRE5xVG14b00zSnNVRVowVFhwd1EwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_ernad_topuzovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkQ2FqVkZVRFZPWWpoMWJubDJiRE0wU2xoMlRYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_aleksandar_ristovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaS1EzRTNURlZDUW5SMlpXVlZUMlZPUjNkRU1XYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_momcilo_baranin, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT201U1FWSjNSVVpVVnpaWFdqUjRZV1EyVGpneWVWRRAB',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_mirko_kuzman, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oUWJtdGpiMFJyYUVveVpIRnBNRWQxWDBrMk1sRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_danilo_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGR05VdGZVVk0wV0VOS1UyVlRWWEZDZUZJMU1IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_lana_bojic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCalRXcDNaRjlDUjBGRFdtaHNia04yTFRNeFpGRRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_cvr6cx, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxWlNXOHhVR2wzWjJSTVkxZFhRVTl3UTNOV2NVRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_danijela_prelevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SMmNXUXdPRU50ZUU5UGVtaFZRMWRMVFRsYVMxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_dijana_tomasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT210V2RHeHVRWGd4UzNCTlZrVmxTa3c0YTJ0UE0wRRAB',
    3, 'bs', 'I pored digitalizacije prilikom ulaska, prave se velike gužve na prilično makom prostoru, počeli su sa radom sa zakašnjenjem pa je bila još veća gužva, mogli bi biti i ljubazniji kao i brži u poslu',
    'I pored digitalizacije prilikom ulaska, prave se velike gužve na prilično makom prostoru, počeli su sa radom sa zakašnjenjem pa je bila još veća gužva, mogli bi biti i ljubazniji kao i brži u poslu', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_mikhail_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCT2R6aHlaWEJYVWxwWk5GWnhYMFpoYmxOZlJVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_marko_milic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/Ci9DQUlRQUNvZENodHljRjlvT2taTWFXRmhPRzVRZEdKemJFVjRUR1k1VTBrd01IYxAB',
    5, 'bs', 'Profesionalna usluga i vrhunski strucnjaci.',
    'Profesionalna usluga i vrhunski strucnjaci.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_irena_ivana_miranovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJWEVyZlNId3NyT09nEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ariana_rrenja, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnTUNJd2RUV0NREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jack, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUQza0stVzV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_natsukful, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUM5bmZEbkNBEAE',
    5, 'en', 'Very nice place. Came here looking for rabies vaccine. Doctor spoke English very well and was very attentive.',
    NULL, NULL, 'Very nice place. Came here looking for rabies vaccine. Doctor spoke English very well and was very attentive.', NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_matija_blagojevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUQxaFlLTHRRRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vlado_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSURWMktDLVp3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nikita_terekhov, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSURGNVlHQzJ3RRAB',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_suat_karabacak, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSURGbXZ6OTdRRRAB',
    5, 'de', 'Ich wurde von einem Hund in Tirana gebissen. Leider habe ich keinen Impfstoff gegen Tollwut in ganz Tirana finden können. 5 große Krankenhäuser hatten keinen Impfstoff in Tirana. In dem Institut in Podgorica hat man den Impfstoff gehabt.',
    NULL, NULL, NULL, NULL, 'Ich wurde von einem Hund in Tirana gebissen. Leider habe ich keinen Impfstoff gegen Tollwut in ganz Tirana finden können. 5 große Krankenhäuser hatten keinen Impfstoff in Tirana. In dem Institut in Podgorica hat man den Impfstoff gehabt.', NULL,
    1, '2024-10-29 00:00:00'),

(@user_sandram, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSURLb3FybWdnRRAB',
    4, 'bs', 'Komuniciraju s gradjanima koji nisu iz Podgorice, putem emaila. To je Ok.',
    'Komuniciraju s gradjanima koji nisu iz Podgorice, putem emaila. To je Ok.', NULL, NULL, NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_jelena_ajkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwbUt2UGVREAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_budva_business, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKczRYazRnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_jovan_samardzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4bFp2dzRBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_elizaveta_chepurko, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNoMGJuZmd3RRAB',
    5, 'ru', 'Несмотря на то, что многие не понимали английский, мне все равно старались помочь. Пока что положительное впечатление',
    NULL, NULL, NULL, 'Несмотря на то, что многие не понимали английский, мне все равно старались помочь. Пока что положительное впечатление', NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_filip_ivanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNoNnBlanFRRRAB',
    1, 'hr', 'Molite Boga da nikad ne dođete na ovo mjesto.',
    'Molite Boga da nikad ne dođete na ovo mjesto.', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_s_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtMThXVzlnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_jovan_samardzic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSURBdE1IdXhRRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_susan_dunlop, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1dUxENjN3RRAB',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_amanda_besirevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1cHFlazFnRRAB',
    1, 'hr', 'Maknite broj telefona kad se nikad ne javljate na isti.',
    'Maknite broj telefona kad se nikad ne javljate na isti.', NULL, NULL, NULL, NULL, NULL,
    4, '2022-10-29 00:00:00'),

(@user_aco_ronaldo, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNPMTdMWi13RRAB',
    4, 'hr', 'Mi bolji nemamo tako da je dobar',
    'Mi bolji nemamo tako da je dobar', NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_gruna_stramen, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNXX3E2WHVRRRAB',
    1, 'hr', 'Ne umiju se javit na telefon, treba im jm',
    'Ne umiju se javit na telefon, treba im jm', NULL, NULL, NULL, NULL, NULL,
    3, '2022-10-29 00:00:00'),

(@user_branislav_lazovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtMzZfaDRBRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_pasha_savitskiy, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNtaXZ2QWt3RRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_anastasija_vukasinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHMXFlRlp3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_goga_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNHOFBtZVBREAE',
    1, 'en', 'Very unprofessional service: my mother supposed to have 3 tests done, the nurse crossed with the pen 2 of them and wrote:” no tests” without telling anything to my mother. I just saw it now. Also, they contaminated the sample for urine so she needs to go again. They also have her the information that her results will be done in a week, which is not true- we have done it before and it takes about 3 days. It was the same this time as well. have been calling them for 2 hours now to ask about this, either it rings and no reply or busy.  Ridiculous.',
    NULL, NULL, 'Very unprofessional service: my mother supposed to have 3 tests done, the nurse crossed with the pen 2 of them and wrote:” no tests” without telling anything to my mother. I just saw it now. Also, they contaminated the sample for urine so she needs to go again. They also have her the information that her results will be done in a week, which is not true- we have done it before and it takes about 3 days. It was the same this time as well. have been calling them for 2 hours now to ask about this, either it rings and no reply or busy.  Ridiculous.', NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_oleksandr_dovgorukiy, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxcDg2X3ZBRRAB',
    1, 'en', 'Regarding free PCR-test for tourists.
I\'ve got the phone number of the representative in Budva to schedule it... Honestly, there was no common sense to assign a doctor who does not speak both English or Russian to answer the calls from foreigners. Women with kind of the attitude answered... in the local language.
Simply ridiculous and useless governmental initiative.',
    NULL, NULL, 'Regarding free PCR-test for tourists.
I\'ve got the phone number of the representative in Budva to schedule it... Honestly, there was no common sense to assign a doctor who does not speak both English or Russian to answer the calls from foreigners. Women with kind of the attitude answered... in the local language.
Simply ridiculous and useless governmental initiative.', NULL, NULL, NULL,
    1, '2021-10-29 00:00:00'),

(@user_grisonian_grisonian, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUN5bDdmbDRRRRAB',
    5, 'de', 'An dieser Stelle möchte ich mich beim ganzen Team und insbesondere bei Dr. D. Vulikic bedanken; sie leisten eine grossartige Arbeit!',
    NULL, NULL, NULL, NULL, 'An dieser Stelle möchte ich mich beim ganzen Team und insbesondere bei Dr. D. Vulikic bedanken; sie leisten eine grossartige Arbeit!', NULL,
    1, '2021-10-29 00:00:00'),

(@user_miodrag_krkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUN5X29tb2FREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_nikola_ostoji, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNpa0xqYmxnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_ivica_vujacic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSURDZ2NHQ0RBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_armin88_suka, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSURDOE02Y01REAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_stevan_cakic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUM4NnIzLUdnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_verica_lekovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUM4b28yRElBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_b_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUM4aU1lV3hBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_anela_goranovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUM4d1A2Qk5BEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_kalezi_danijel, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSURjcTVmUmdnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_biljana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSURjcU5YVWVnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_luka, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNjemJteXlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_azra_suruliz, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNjemQ2QjJ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_marko_jablan, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjemQ3eUxBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_anastasija_despotovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjelo3X1BBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_s_shady, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjbWNHQldREAE',
    1, 'hr', 'Pocrkali svi',
    'Pocrkali svi', NULL, NULL, NULL, NULL, NULL,
    1, '2020-10-29 00:00:00'),

(@user_dragana_damjanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjaWJuRk1nEAE',
    4, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_jovana_boricic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzdzd2OTVBRRAB',
    1, 'bs', 'Vec treci put dolazim i brojevi nestaju 5min nakon radnog vremena jer se zavrsavaju rodbini ili vec kome...(od 15do7 se ceka)Na aparatu pise jos slobodno mjesto za 22pacijenta(40je maksimalno za dan jer je ginekolosko uzimanje briseva) al aparat ne izbacuje brojeve jer je vec navodno 40pacijenata primljeno(sto je laz ,jer nas ukupno nije bilo 40toro ni unutra ni ispred )A sestre se izjasnjavaju kako ih to ne interesuje i da se pokusa doc drugi dan...sramota!!!!',
    'Vec treci put dolazim i brojevi nestaju 5min nakon radnog vremena jer se zavrsavaju rodbini ili vec kome...(od 15do7 se ceka)Na aparatu pise jos slobodno mjesto za 22pacijenta(40je maksimalno za dan jer je ginekolosko uzimanje briseva) al aparat ne izbacuje brojeve jer je vec navodno 40pacijenata primljeno(sto je laz ,jer nas ukupno nije bilo 40toro ni unutra ni ispred )A sestre se izjasnjavaju kako ih to ne interesuje i da se pokusa doc drugi dan...sramota!!!!', NULL, NULL, NULL, NULL, NULL,
    1, '2020-10-29 00:00:00'),

(@user_rabbit_shadow, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNzOHFmdFJ3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_aleksandron_lajakot, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNzOHFuTUJREAE',
    1, 'bs', 'Iz treceg puta ne uspijevam doci na red za nalaze.Persone u uniformama sprovode rodjake i prijatelje preko reda,brojevi nestaju 5 minuta po pocetku radnog vremena...',
    'Iz treceg puta ne uspijevam doci na red za nalaze.Persone u uniformama sprovode rodjake i prijatelje preko reda,brojevi nestaju 5 minuta po pocetku radnog vremena...', NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_goran_vuletic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUQwMVptWDdBRRAB',
    2, 'bs', 'Radno vrijeme nidje veze sa vezom, zvanično od 7.30 - 15h ali prije 8 ne rade.
U ostalom ka čitavo CG zdravstvo, što bi oni bili izuzetak...',
    'Radno vrijeme nidje veze sa vezom, zvanično od 7.30 - 15h ali prije 8 ne rade.
U ostalom ka čitavo CG zdravstvo, što bi oni bili izuzetak...', NULL, NULL, NULL, NULL, NULL,
    1, '2020-10-29 00:00:00'),

(@user_mona_marii, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUMwNi1lSEN3EAE',
    2, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_ana_marjanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNZcFA3ZlJnEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_bvb_bvb, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNReEkzOHp3RRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_nikola_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNnNjZQdklBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_danijela_knezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSURnbXJyWWxBRRAB',
    5, 'hr', 'Odlicna organozacija.',
    'Odlicna organozacija.', NULL, NULL, NULL, NULL, NULL,
    1, '2018-10-29 00:00:00'),

(@user_aleksandar_ristovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3dlBPWUN3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_alfa_nekretnine, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSURRdHBMQWVBEAE',
    3, 'en', '(+382 20) 412 888',
    NULL, NULL, '(+382 20) 412 888', NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_tamara_zivkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRM1BHSTdnRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-10-29 00:00:00'),

(@user_pavle_urovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChdDSUhNMG9nS0VJQ0FnSURRNjkzTGlRRRAB',
    1, 'hr', 'Gdje je radno vrijeme?',
    'Gdje je radno vrijeme?', NULL, NULL, NULL, NULL, NULL,
    1, '2017-10-29 00:00:00'),

(@user_tamara_jelic, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUNRMFpMZlFREAE',
    1, 'hr', 'Radno vreme?',
    'Radno vreme?', NULL, NULL, NULL, NULL, NULL,
    2, '2017-10-29 00:00:00'),

(@user_max_lm, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3LUwzMUtnEAE',
    1, 'hr', 'Gdje vam je radno vrijeme???',
    'Gdje vam je radno vrijeme???', NULL, NULL, NULL, NULL, NULL,
    2, '2017-10-29 00:00:00'),

(@user_adri_syaur, @clinic_id, NULL, 'google_maps',
    'places/ChIJZXrorSTrTRMRS0H_vRxwHdc/reviews/ChZDSUhNMG9nS0VJQ0FnSURncXR2VERBEAE',
    3, 'ms', 'Betul,untuk apa gedung itu?',
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
