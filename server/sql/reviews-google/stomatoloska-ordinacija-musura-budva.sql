-- Insert Google Maps reviews for Stomatološka ordinacija Mušura (Budva)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/stomatoloska-ordinacija-musura-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = 142;
SET @doctor_dejan_musura = (SELECT id FROM doctors WHERE slug = 'dejan-musura');
SET @doctor_nikola_musura = (SELECT id FROM doctors WHERE slug = 'nikola-musura');
SET @doctor_dragana_bjelica = (SELECT id FROM doctors WHERE slug = 'dragana-bjelica');
SET @doctor_jelena_potpara = (SELECT id FROM doctors WHERE slug = 'jelena-potpara');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ivana stanarevic', 'https://lh3.googleusercontent.com/a/ACg8ocIkD62A2wHVdC7VSOQVaZD92frNEzaxbA98M2kHgxtD57acTQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116414514913008576368/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116414514913008576368/reviews');
SET @user_ivana_stanarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116414514913008576368/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Vujovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXeZZgkQgKAiVOxhwe7K6vyEhJbfZb2Okq23X8QRYjUB0CwFfIc=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115455234738792739684/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115455234738792739684/reviews');
SET @user_ivana_vujovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115455234738792739684/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrej Nikolić', 'https://lh3.googleusercontent.com/a-/ALV-UjVIbcPPWA5bhXLV7BaFst-WfAz9NEw1kqL1hTX70GQDRfz5dd4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111545140712701696390/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111545140712701696390/reviews');
SET @user_andrej_nikoli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111545140712701696390/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Life in Nature', 'https://lh3.googleusercontent.com/a/ACg8ocK1imSUgLpaulAyr2t9zIr5QVF3e90Su0uTYaWBNv0wEu1c3A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115415055079392428200/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115415055079392428200/reviews');
SET @user_life_in_nature = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115415055079392428200/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan', 'https://lh3.googleusercontent.com/a/ACg8ocJ2BvPzzbnZ2GpN7pFcOSF_F4BKP_abXXSFeSjRMpdxxDMrHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116135098171738885550/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116135098171738885550/reviews');
SET @user_dejan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116135098171738885550/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefan Ajdukovic', 'https://lh3.googleusercontent.com/a/ACg8ocIxZMq83F_i5FPsSKtKdlBGDXhoJ3Rv_2d-sD1nVOX1Dx5YOA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100970956562939547394/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100970956562939547394/reviews');
SET @user_stefan_ajdukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100970956562939547394/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Елесина', 'https://lh3.googleusercontent.com/a/ACg8ocL4uHpXVWvSz0r6e3hdrR7S2Q3HqEYrLkV4N0cuLwX24Dck5g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108277179163025735491/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108277179163025735491/reviews');
SET @user_elena_elesina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108277179163025735491/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Drobnjak', 'https://lh3.googleusercontent.com/a/ACg8ocLRNNN3ap_XcGHSIOjiZM5iWv8ivLAgEaTljt-f4OIhDESiRQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104227523736742026108/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104227523736742026108/reviews');
SET @user_jelena_drobnjak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104227523736742026108/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dean Plavsic', 'https://lh3.googleusercontent.com/a/ACg8ocKYQWeOGIj6-QNOnhhJfS28hcqNo9PXS-v5wXOmS2T_478qkw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109652670666285275884/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109652670666285275884/reviews');
SET @user_dean_plavsic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109652670666285275884/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Branko Dragisic', 'https://lh3.googleusercontent.com/a-/ALV-UjVefhASna8JbRHL5tWnj15hmtOg2jhkIHpfm3yjoYUuCa0iZQkFJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116537378538677511876/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116537378538677511876/reviews');
SET @user_branko_dragisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116537378538677511876/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasna Jovic', 'https://lh3.googleusercontent.com/a/ACg8ocIL6CqVGYYAQWF3LBBFNtg-HhrgMWxjDfMJnUdiJPFJBFJgXQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112300242186583159581/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112300242186583159581/reviews');
SET @user_jasna_jovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112300242186583159581/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S Belmont', 'https://lh3.googleusercontent.com/a/ACg8ocKRcfQ3Tv2cCoYyKd3ZmN4k4G-IZpb7rdaJ9TsQFjWrHSoN7Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102050736971909740063/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102050736971909740063/reviews');
SET @user_s_belmont = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102050736971909740063/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Relja Mucalica', 'https://lh3.googleusercontent.com/a/ACg8ocKy-5CozDuZRyI_QRVCVly0YO0F7KbmXzQUCb1v7olurdmWqg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109476544347860299615/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109476544347860299615/reviews');
SET @user_relja_mucalica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109476544347860299615/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Zec', 'https://lh3.googleusercontent.com/a/ACg8ocKD66xEjrN0B_Y3E7mnuwIiffLrehiq0kGkW3h_5ayrSoa3vw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104905518745254783315/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104905518745254783315/reviews');
SET @user_sara_zec = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104905518745254783315/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko79 Colan', 'https://lh3.googleusercontent.com/a-/ALV-UjW9zDsz_WUCmKB2NW9rCiTXTprrb4PZq_tsq_8_qauExc3knxLk=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117522727253360730756/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117522727253360730756/reviews');
SET @user_marko79_colan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117522727253360730756/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Lazarevic', 'https://lh3.googleusercontent.com/a/ACg8ocJDdV6QgDifcQGvG5Dlb_EJXRGgTQmBnQmfyU-nYCp7dShRkQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105930774760692438820/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105930774760692438820/reviews');
SET @user_ksenija_lazarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105930774760692438820/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suad Becic', 'https://lh3.googleusercontent.com/a-/ALV-UjX6bueAnlD0Ez3ljAW64i9cgS4gggh5XzzW4Zm-LJloHgxuCjU_BA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107587051560350750690/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107587051560350750690/reviews');
SET @user_suad_becic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107587051560350750690/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ena Vuckovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU6GG5NEFX4OMYuuqKeoYidmcC5AunludamcSCI7oOQn_7HDZRmBA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103006212958790279393/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103006212958790279393/reviews');
SET @user_ena_vuckovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103006212958790279393/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Raine Hailshard', 'https://lh3.googleusercontent.com/a-/ALV-UjXxUJam9xh2z_qi6Yz-uIsATeF21WngPszyOnT_288R4_-EpkY=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113248716561229749861/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113248716561229749861/reviews');
SET @user_raine_hailshard = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113248716561229749861/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Roman Kirov', 'https://lh3.googleusercontent.com/a-/ALV-UjUG9QN38aMbDyR9byacBhSk-0p36D4C8-KGZfMLmbk3mMIu4N-x=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116924237155170520417/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116924237155170520417/reviews');
SET @user_roman_kirov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116924237155170520417/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nevena Dragicevic', 'https://lh3.googleusercontent.com/a/ACg8ocK7keg-OgQE0PSv2vU2QtNMni3W1OBTINVduKIQ74NaG1Bc6OA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104207562640100266209/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104207562640100266209/reviews');
SET @user_nevena_dragicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104207562640100266209/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veljo Milicevic', 'https://lh3.googleusercontent.com/a/ACg8ocKkxHSoyAGylzkOpOtg4FQYTVce5jRVNXMYWsNfN5q5IluIVA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117674507014577825155/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117674507014577825155/reviews');
SET @user_veljo_milicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117674507014577825155/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hana Vujacic', 'https://lh3.googleusercontent.com/a-/ALV-UjWRKfc5EF-HTIqof6ADNcEJHMqB3g2qyMmsw1q63BiKfBuHRYs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104852606401533373072/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104852606401533373072/reviews');
SET @user_hana_vujacic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104852606401533373072/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marianna Marushchak', 'https://lh3.googleusercontent.com/a-/ALV-UjX9FaJlgUs0JREDUcgmgJAAWRs9UFF-mxKj4-Es6EAhm4mHp-Vm=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113028023757028570874/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113028023757028570874/reviews');
SET @user_marianna_marushchak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113028023757028570874/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'LJUBISA MILADIC', 'https://lh3.googleusercontent.com/a-/ALV-UjXHlrdLVTzzCecJBAIMX7e7BV1Q4SPOB7xiLh3csEz2-tuJvDfcHg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108841774622830172506/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108841774622830172506/reviews');
SET @user_ljubisa_miladic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108841774622830172506/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Zekic', 'https://lh3.googleusercontent.com/a/ACg8ocJLevRm6Kl0vNPBoa9Ff8AAIZJkGXhi5px6DuEvkonO42vuyQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113669475152243406496/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113669475152243406496/reviews');
SET @user_marija_zekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113669475152243406496/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Guenter Hopmann', 'https://lh3.googleusercontent.com/a/ACg8ocJaC1XV63tvr5DU_86bmUnmPwEvtMg-ZESLgBNubWAu4FgPIg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112197776597392600753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112197776597392600753/reviews');
SET @user_guenter_hopmann = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112197776597392600753/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lidija Todorovic', 'https://lh3.googleusercontent.com/a/ACg8ocJTM2twE4MaBeN05GBrSy6Zrcb2yM3iv07AUqBmELIBE_K9=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110102801169610110108/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110102801169610110108/reviews');
SET @user_lidija_todorovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110102801169610110108/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena', 'https://lh3.googleusercontent.com/a-/ALV-UjUXuLagkNJAMdJBD28K1qtkjWauAs6edIiMsW9Bf3NGwx-FcgtrKA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113185176221253258315/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113185176221253258315/reviews');
SET @user_jelena = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113185176221253258315/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Maric', 'https://lh3.googleusercontent.com/a/ACg8ocJwDFLzyrdLNhoIUnm_QdcNdvhOC4FMIPpcy62TDwKITWM9H0Y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113763261786933731678/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113763261786933731678/reviews');
SET @user_nina_maric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113763261786933731678/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Matea Odalovic', 'https://lh3.googleusercontent.com/a/ACg8ocLUbJ27CyGudTlCaWdBoTByGK53ccAQhgpLxdCDrDTaWCEZ_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101992468342616825115/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101992468342616825115/reviews');
SET @user_matea_odalovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101992468342616825115/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Janketić', 'https://lh3.googleusercontent.com/a/ACg8ocKjCzIC9Y5-KEHuOTa0mV1eBYqFFmpvYx4PHRRiUl-nxRDA3lw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112291160320725998902/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112291160320725998902/reviews');
SET @user_sanja_janketi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112291160320725998902/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina Kalezic', 'https://lh3.googleusercontent.com/a-/ALV-UjXOWnTgTEiwjUL6KjTEx-mWcCSarD4hrgXmDZdAtRs7I3z9Ug=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116842504702838163842/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116842504702838163842/reviews');
SET @user_mina_kalezic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116842504702838163842/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Vuckovic', 'https://lh3.googleusercontent.com/a/ACg8ocIIJ1UsUBuwWUig9ACzkNJ8TpYXQ2T3GDnyY282SEvycyLenw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102028276045974094803/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102028276045974094803/reviews');
SET @user_vesna_vuckovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102028276045974094803/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anet', 'https://lh3.googleusercontent.com/a/ACg8ocLrM-81EuyhTk8LsAB2P5xFyKyl8pXf8aHUBKKobxF_DTLM1w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108802562359347130248/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108802562359347130248/reviews');
SET @user_anet = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108802562359347130248/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Zizic', 'https://lh3.googleusercontent.com/a/ACg8ocIQvfCkSTno4IXyaMrqku-2dOkMXJy29ZkZ_ZDJsH_xs82RvQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111112738431340936941/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111112738431340936941/reviews');
SET @user_ana_zizic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111112738431340936941/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'S L', 'https://lh3.googleusercontent.com/a-/ALV-UjWlx-pqJpP_3-KnIAFT-PbI1HP6Yj5IBcNghzrSo7kDQW7Q0WVJ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111737274934019742905/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111737274934019742905/reviews');
SET @user_s_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111737274934019742905/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Merima Karastanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVQVNNtEZlUFGRYJ69v717pjIkJeXJkQcgKeq1a5w9bmpm6HHtJKg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115290884130105796982/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115290884130105796982/reviews');
SET @user_merima_karastanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115290884130105796982/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, '何彬', 'https://lh3.googleusercontent.com/a-/ALV-UjXxGu8NsFzgCXhTVpw4o_cyLhfzPcirPlxb_7AorAJkbeJ_PR0=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107286232325674158568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107286232325674158568/reviews');
SET @user_user_107286232325674158568 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107286232325674158568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Cory Pidhaichuk', 'https://lh3.googleusercontent.com/a-/ALV-UjUq8Q-Fs8b6Gdxz66H9LSNN4_vix7PgHKkuEVOSHFXwIY9GkCdI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103168769012832193518/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103168769012832193518/reviews');
SET @user_cory_pidhaichuk = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103168769012832193518/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zeljka Mandic', 'https://lh3.googleusercontent.com/a/ACg8ocKG8UXoHi2wYBBW6LI_gkkpThmdnqLS3kJa0FCnKjpaxHxPpw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112283963586797198200/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112283963586797198200/reviews');
SET @user_zeljka_mandic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112283963586797198200/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Mišić', 'https://lh3.googleusercontent.com/a/ACg8ocKn54jKpdOsXvK34p7d4tvBiIZMihlV4w_lQfRAmOVSGD-NEw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110184384426092947071/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110184384426092947071/reviews');
SET @user_predrag_mii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110184384426092947071/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Julian', 'https://lh3.googleusercontent.com/a-/ALV-UjUs1riNxlBs18zcaIALaPEnDultUGHzhBnL5vWZq5znpdff4I2VnA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108850582183838268414/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108850582183838268414/reviews');
SET @user_julian = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108850582183838268414/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'PETAR DIMITRIJEVIC', 'https://lh3.googleusercontent.com/a/ACg8ocJ4CY4-SPrapAr2R-Y46789_dbSiHCIwAUT3tPoy25NeNNgTw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117391018500040810012/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117391018500040810012/reviews');
SET @user_petar_dimitrijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117391018500040810012/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Musura', 'https://lh3.googleusercontent.com/a/ACg8ocIgvaURSUZRyaVzE5EkY4oHpWWmxkia7V6qlBWR70W9_SJZig=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109648481346545464645/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109648481346545464645/reviews');
SET @user_nikola_musura = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109648481346545464645/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'R F', 'https://lh3.googleusercontent.com/a-/ALV-UjUE99RxkO7EibHGSE0S8pxS1TO5bN4GPqqEImL1wyOncUB2pIrg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111295994087692867461/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111295994087692867461/reviews');
SET @user_r_f = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111295994087692867461/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anuska Pesic', 'https://lh3.googleusercontent.com/a-/ALV-UjVgEbERCJ-6JcKyx4slwSlhLAFUUy_UjNgtNlBPOpVWtcyGGaiaGg=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/101334973230005153790/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101334973230005153790/reviews');
SET @user_anuska_pesic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101334973230005153790/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Spremo', 'https://lh3.googleusercontent.com/a/ACg8ocJVGyvjnIsukemlvY6XySWlsvH1iIRguPvsMdT5LhhOpIA-Gw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102280226642136754522/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102280226642136754522/reviews');
SET @user_maja_spremo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102280226642136754522/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sera N.', 'https://lh3.googleusercontent.com/a-/ALV-UjXsn0NENDEYalVtORc3x1RT-h349lKFIkJmL6DGzEyfxtg-wbTd=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104547779453955123785/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104547779453955123785/reviews');
SET @user_sera_n = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104547779453955123785/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Petkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWSOk_pIbjdI_HWkcVZK419pd6CVDNDLzLkPoQobqj9itTvBzVW=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114442310507141162976/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114442310507141162976/reviews');
SET @user_dragana_petkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114442310507141162976/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Trifunovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU2polNEKoqYSMF5WD3kS3C6EC_ejIIWQcNdeC-Srru4wgO0M4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102762765403141746917/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102762765403141746917/reviews');
SET @user_marija_trifunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102762765403141746917/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rita', 'https://lh3.googleusercontent.com/a-/ALV-UjU89w0txUdTDZ3_s_g3kFA2aMJfewrvmM-CEhRZ52blTpwV9wBu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115005388952024416124/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115005388952024416124/reviews');
SET @user_rita = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115005388952024416124/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dejan Stanisic', 'https://lh3.googleusercontent.com/a/ACg8ocJimxnUbBGMBsuJ4cFZ01utCuwOapYbYjCd-kbJ0PL6Q-DPLA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114178954497922887522/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114178954497922887522/reviews');
SET @user_dejan_stanisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114178954497922887522/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Matijas', 'https://lh3.googleusercontent.com/a-/ALV-UjXq_Yrbd0eoP4N71EGigqeFF_VK3K2xjPcLMBwKYr81HxIwkcLB0g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105390893214772734918/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105390893214772734918/reviews');
SET @user_jelena_matijas = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105390893214772734918/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Krsto Kovacevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXQAokcjXFLo-VzLb61-E2RXtuOj2h7F3aroyNUtAFr-OuMRviE3Q=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100954268948958954129/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100954268948958954129/reviews');
SET @user_krsto_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100954268948958954129/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Vujovic', 'https://lh3.googleusercontent.com/a/ACg8ocI4T4LQKI1iDpgpIISXcfJxmsdVUbXGTSbiChcn9p9rAJnVaVZj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111951661735508769566/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111951661735508769566/reviews');
SET @user_ivana_vujovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111951661735508769566/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'milutin pavićević', 'https://lh3.googleusercontent.com/a-/ALV-UjUWv2JXf74N7nFw2td_UvrBgKnpsFhe-abnxv09rKM7AvP_ymfR=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115596208959498812972/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115596208959498812972/reviews');
SET @user_milutin_pavievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115596208959498812972/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jürgen André', 'https://lh3.googleusercontent.com/a/ACg8ocKR6_ERCBcFLTlFnpeOTqtdzW6GtcYC0tbjGN7UegpXHs6i7A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115901198954330850476/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115901198954330850476/reviews');
SET @user_jrgen_andr = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115901198954330850476/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mitar', 'https://lh3.googleusercontent.com/a/ACg8ocLioAl-mf39Xho1tKqR0fVzPHrkBga7vFo_l4o27tQZd3rdDw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/103967671964642638073/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103967671964642638073/reviews');
SET @user_mitar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103967671964642638073/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Maljevic', 'https://lh3.googleusercontent.com/a/ACg8ocLW1sTnLUEgHTh6QcGVxsNy44iTuzvhtRPBViD2NzNPMAi1Aw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107689915103294715621/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107689915103294715621/reviews');
SET @user_emir_maljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107689915103294715621/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'tijana mugosa', 'https://lh3.googleusercontent.com/a/ACg8ocIRvEF2Skvta-LsK0xKVOIcgHk98wXAmJpjTAgEJ2wOey74ig=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105886171760490491137/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105886171760490491137/reviews');
SET @user_tijana_mugosa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105886171760490491137/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Mandic', 'https://lh3.googleusercontent.com/a/ACg8ocLVXCWFfLnDSlzKb7xz09Cy2JPQBCxpmYquoXlmVs53qQFtMA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106482508254832731136/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106482508254832731136/reviews');
SET @user_kristina_mandic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106482508254832731136/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Monika Rondovic', 'https://lh3.googleusercontent.com/a/ACg8ocKON9Y7St0qiHrrue_3u29z72RG61trBWYGICI4PM9n32L7aQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100752586507572908216/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100752586507572908216/reviews');
SET @user_monika_rondovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100752586507572908216/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nevena Pantić', 'https://lh3.googleusercontent.com/a-/ALV-UjVrZ4YzpWw77N_kDfZIUB3qDm5ojYYg9kDYKF2B6B2DVXOg1quC=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111577667233646241568/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111577667233646241568/reviews');
SET @user_nevena_panti = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111577667233646241568/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Spalevic', 'https://lh3.googleusercontent.com/a-/ALV-UjX8d5OfSOg_Fuwbj7Gw_1JBQagDTuO_XQSxJ6CNLfCN7l3xQESJ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105009572710686132793/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105009572710686132793/reviews');
SET @user_marija_spalevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105009572710686132793/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Martinovic M', 'https://lh3.googleusercontent.com/a/ACg8ocLOW2cUPYuBWdL33au39IBbkKTMHKB5TL54DkBcMjLyq62H0g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103555651151249259749/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103555651151249259749/reviews');
SET @user_martinovic_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103555651151249259749/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna', 'https://lh3.googleusercontent.com/a-/ALV-UjViVEEStyNEhvZK5g1rNfQA6BkYWpmwdSIMIVdbozvJ6KYyPedO=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112793489578571288760/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112793489578571288760/reviews');
SET @user_vesna = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112793489578571288760/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Eldar Sadykhov', 'https://lh3.googleusercontent.com/a-/ALV-UjVn4Mh3MROLkZGnFzLNLBfihHfiUPU8uJcTkFzT2-Nvatui0_kS=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/116699883830993900753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116699883830993900753/reviews');
SET @user_eldar_sadykhov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116699883830993900753/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Cumic', 'https://lh3.googleusercontent.com/a/ACg8ocInDIGA1f5HlFlgjgrfxU4zArLiO8ocd7hsqRCkNqpC0enqKQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115926799988071030374/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115926799988071030374/reviews');
SET @user_tamara_cumic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115926799988071030374/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_ivana_stanarevic, @clinic_id, @doctor_nikola_musura, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tOR1VuUnplVEZmV1RGWVYyOW9XRFV5VEVoblJXYxAB',
    5, 'bs', 'Veliko hvala doktoru Nikoli koji je resio svojom predanoscu i znanjem ono sto niz stomatoloskih ordinacija nije uspelo! Svaka cast na strucnosti i ljubaznosti kompletnog osoblja! Sve pohvale i svaka preporuka!',
    'Veliko hvala doktoru Nikoli koji je resio svojom predanoscu i znanjem ono sto niz stomatoloskih ordinacija nije uspelo! Svaka cast na strucnosti i ljubaznosti kompletnog osoblja! Sve pohvale i svaka preporuka!', 'Велико хвала доктору Николи који је ријешио својом преданошћу и знањем оно што низ стоматолошких ординација није успио! Свака част на стручности и љубазности комплетног особља! Све похвале и свака препорука!', 'Many thanks to Dr Nikola, who through his dedication and knowledge solved what a string of other dental practices could not! Hats off to the expertise and kindness of the entire staff! All praise and every recommendation!', 'Большое спасибо доктору Николе, который своей преданностью делу и знаниями решил то, с чем не справился целый ряд стоматологических кабинетов! Респект профессионализму и любезности всего персонала! Все похвалы и всяческие рекомендации!', 'Vielen Dank an Dr. Nikola, der mit seinem Engagement und seinem Wissen gelöst hat, was eine ganze Reihe anderer Zahnarztpraxen nicht geschafft hat! Hut ab vor der Fachkompetenz und Freundlichkeit des gesamten Teams! Alles Lob und jede Empfehlung!', 'Bir dizi başka diş kliniğinin başaramadığını, özverisi ve bilgisiyle çözen Dr Nikola\'ya çok teşekkürler! Tüm ekibin uzmanlığı ve nezaketi takdire şayan! Her türlü övgü ve tavsiye!',
    0, '2026-07-24 00:00:00'),

(@user_ivana_vujovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT201eU9VbDJUa0Y0YkRseVUwdDNVMEUzUjA5bVRWRRAB',
    5, 'bs', 'Profesionalan pristup, savremena oprema i izuzetno prijatna atmosfera. Doktor i foktorka su veoma pažljivi i posvećeni pacijentu. Svaki problem rešavaju brzo i bez ikakve neprijatnosti. Definitivno moja topla preporuka za sve koji traže pouzdanog stomatologa',
    'Profesionalan pristup, savremena oprema i izuzetno prijatna atmosfera. Doktor i foktorka su veoma pažljivi i posvećeni pacijentu. Svaki problem rešavaju brzo i bez ikakve neprijatnosti. Definitivno moja topla preporuka za sve koji traže pouzdanog stomatologa', 'Професионалан приступ, савремена опрема и изузетно пријатна атмосфера. Доктор и докторка су веома пажљиви и посвећени пацијенту. Сваки проблем рјешавају брзо и без икакве непријатности. Дефинитивно моја топла препорука за све који траже поузданог стоматолога', 'A professional approach, modern equipment and an exceptionally pleasant atmosphere. The doctor and the lady doctor are very attentive and dedicated to the patient. They solve every problem quickly and without any discomfort. Definitely my warm recommendation to anyone looking for a reliable dentist', 'Профессиональный подход, современное оборудование и исключительно приятная атмосфера. Доктор и докторша очень внимательны и заботятся о пациенте. Любую проблему решают быстро и без всякого дискомфорта. Однозначно моя тёплая рекомендация всем, кто ищет надёжного стоматолога', 'Professionelles Vorgehen, moderne Ausstattung und eine ausgesprochen angenehme Atmosphäre. Der Arzt und die Ärztin sind sehr aufmerksam und dem Patienten zugewandt. Jedes Problem lösen sie schnell und ohne jede Unannehmlichkeit. Definitiv meine herzliche Empfehlung an alle, die einen verlässlichen Zahnarzt suchen', 'Profesyonel bir yaklaşım, modern donanım ve son derece hoş bir ortam. Hekim ve hanım hekim hastaya karşı çok dikkatli ve özenli. Her sorunu hızlıca ve hiçbir rahatsızlık vermeden çözüyorlar. Güvenilir bir diş hekimi arayan herkese içtenlikle tavsiye ederim',
    0, '2026-07-19 00:00:00'),

(@user_andrej_nikoli, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT25rdFdUUTVXamwyVUV4UWQwSmFVMGRZUWs0NVNIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-26 00:00:00'),

(@user_life_in_nature, @clinic_id, @doctor_dragana_bjelica, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWa1lXa3hkWEJrVkdWeU9HSnZTR1pmZFVkSVgxRRAB',
    5, 'hr', 'Doktorka Dragana je naaaajstravija na svetu☀️',
    'Doktorka Dragana je naaaajstravija na svetu☀️', 'Докторка Драгана је нааајстрашнија на свету☀️', 'Dr Dragana is the aaaawesomest in the world☀️', 'Доктор Драгана — самаааая лучшая на свете☀️', 'Dr. Dragana ist die aaallerbeste auf der Welt☀️', 'Dr Dragana dünyanın eeen harika hekimi☀️',
    0, '2026-05-26 00:00:00'),

(@user_dejan, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGV1prZFhRekJQVnpsa1lXdFJkMGxKWjJ4T1ZrRRAB',
    5, 'hr', 'Sve pohvale i preporuke',
    'Sve pohvale i preporuke', 'Све похвале и препоруке', 'All praise and recommendations', 'Все похвалы и рекомендации', 'Alles Lob und Empfehlungen', 'Her türlü övgü ve tavsiye',
    0, '2026-05-26 00:00:00'),

(@user_stefan_ajdukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSbE4wMVZiSHB2VWxsM1QzQnlTWHBFYTFvMloxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-26 00:00:00'),

(@user_elena_elesina, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT25kaFZVcFZRME14U2pBMGJXRjVSbXB5ZFhSblNXYxAB',
    1, 'ru', 'Я пришла на чистку, а в итоге лишилась части нижних зубов, из-за чего у меня изменился прикус. Докторица решила подправить мне прикус, не согласовав со мной свои действия - просто подпилила часть нижних зубов. Я не успела среагировать, как она уже спилила "лишнее". Теперь не знаю, как быть, нужно как-то восстанавливать эти миллиметры. И вообще, впервые сталкиваюсь с тем, что приходишь на чистку, а тебе еще и спиливают зубы, хотя чистку делаю регулярно много лет. Сама чистка прошла плохо, было больно и не работал нормально аппарат Эйр флоу, в один момент насадка просто вылетела под давлением мне в рот. Деньги, между тем, взяли в полном объеме. До этого однажды уже делала чистку в этой клинике, тогда всё было нормально, но работал молодой человек. В этой же клинике ставила мост - ну, не идельно они сделали, есть зазор между мостом и соседним зубом, где скапливается пища, приходится постоянно его прочищать, травмируя десну. А еще ранее приходила к ним с отстрым воспалением - прописали антибиотик и ничего не сделали, я не стала ждать и вылечила зуб в другой клинике. В общем, так себе больница. Чуть дешевле, чем в других местах, но экономия сомнительная. Чистка с подпиливанием добила, буду писать на них жалобу во Врачебную палату.',
    'Došla sam na čišćenje, a na kraju sam ostala bez dijela donjih zuba, zbog čega mi se promijenio zagriz. Doktorica je odlučila da mi ispravi zagriz ne dogovorivši se sa mnom — prosto je pobrusila dio donjih zuba. Nisam uspjela da reagujem, a ona je već sturgala „višak“. Sada ne znam šta ću, treba nekako da vraćam te milimetre. I uopšte, prvi put mi se dešava da dođeš na čišćenje, a oni ti još i bruse zube, iako čišćenje redovno radim godinama. Samo čišćenje je prošlo loše, bilo je bolno i aparat Air Flow nije radio kako treba, u jednom trenutku mi je nastavak prosto izletio pod pritiskom u usta. Pare su, međutim, uzeli u punom iznosu. Prije toga sam jednom već radila čišćenje u ovoj klinici, tada je sve bilo u redu, ali je radio mlad čovjek. U istoj klinici sam radila i most — nisu ga uradili idealno, ima zazor između mosta i susjednog zuba, gdje se skuplja hrana, pa ga stalno moram čistiti i pritom povređujem desni. A još ranije sam im dolazila sa akutnom upalom — prepisali su antibiotik i ništa nisu uradili, nisam htjela da čekam i zub sam izliječila u drugoj klinici. Ukratko, tako-tako bolnica. Malo je jeftinije nego na drugim mjestima, ali je ušteda sumnjiva. Čišćenje sa brušenjem me je dotuklo, pisaću žalbu na njih Ljekarskoj komori.', 'Дошла сам на чишћење, а на крају сам остала без дијела доњих зуба, због чега ми се промијенио загриз. Докторица је одлучила да ми исправи загриз не договоривши се са мном — просто је побрусила дио доњих зуба. Нисам успјела да реагујем, а она је већ стургала „вишак“. Сада не знам шта ћу, треба некако да враћам те милиметре. И уопште, први пут ми се дешава да дођеш на чишћење, а они ти још и брусе зубе, иако чишћење редовно радим годинама. Само чишћење је прошло лоше, било је болно и апарат Air Flow није радио како треба, у једном тренутку ми је наставак просто излетио под притиском у уста. Паре су, међутим, узели у пуном износу. Прије тога сам једном већ радила чишћење у овој клиници, тада је све било у реду, али је радио млад човјек. У истој клиници сам радила и мост — нису га урадили идеално, има зазор између моста и сусједног зуба, гдје се скупља храна, па га стално морам чистити и притом повређујем десни. А још раније сам им долазила са акутном упалом — преписали су антибиотик и ништа нису урадили, нисам хтјела да чекам и зуб сам излијечила у другој клиници. Укратко, тако-тако болница. Мало је јефтиније него на другим мјестима, али је уштеда сумњива. Чишћење са брушењем ме је дотукло, писаћу жалбу на њих Љекарској комори.', 'I came in for a cleaning and ended up losing part of my lower teeth, which changed my bite. The doctor decided to correct my bite without discussing it with me — she simply filed down part of my lower teeth. Before I could react she had already ground off the "excess". Now I don\'t know what to do; those millimetres have to be restored somehow. And in general, this is the first time I have encountered coming in for a cleaning and having your teeth filed down as well, even though I have had cleanings regularly for many years. The cleaning itself went badly, it was painful and the Air Flow unit was not working properly — at one point the tip simply shot out under pressure into my mouth. They charged the full amount, however. I had had a cleaning at this clinic once before, and that time everything was fine, but a young man did it. I also had a bridge fitted at this clinic — they did not do it perfectly, there is a gap between the bridge and the adjacent tooth where food collects, so I constantly have to clean it out and injure my gum in the process. And even earlier I came to them with acute inflammation — they prescribed an antibiotic and did nothing; I did not want to wait and had the tooth treated at another clinic. In short, a so-so practice. A little cheaper than elsewhere, but the saving is questionable. The cleaning with the filing was the last straw — I am going to file a complaint against them with the Medical Chamber.', 'Я пришла на чистку, а в итоге лишилась части нижних зубов, из-за чего у меня изменился прикус. Докторица решила подправить мне прикус, не согласовав со мной свои действия - просто подпилила часть нижних зубов. Я не успела среагировать, как она уже спилила "лишнее". Теперь не знаю, как быть, нужно как-то восстанавливать эти миллиметры. И вообще, впервые сталкиваюсь с тем, что приходишь на чистку, а тебе еще и спиливают зубы, хотя чистку делаю регулярно много лет. Сама чистка прошла плохо, было больно и не работал нормально аппарат Эйр флоу, в один момент насадка просто вылетела под давлением мне в рот. Деньги, между тем, взяли в полном объеме. До этого однажды уже делала чистку в этой клинике, тогда всё было нормально, но работал молодой человек. В этой же клинике ставила мост - ну, не идельно они сделали, есть зазор между мостом и соседним зубом, где скапливается пища, приходится постоянно его прочищать, травмируя десну. А еще ранее приходила к ним с отстрым воспалением - прописали антибиотик и ничего не сделали, я не стала ждать и вылечила зуб в другой клинике. В общем, так себе больница. Чуть дешевле, чем в других местах, но экономия сомнительная. Чистка с подпиливанием добила, буду писать на них жалобу во Врачебную палату.', 'Ich kam zu einer Zahnreinigung und verlor am Ende einen Teil meiner unteren Zähne, wodurch sich mein Biss verändert hat. Die Ärztin beschloss, meinen Biss zu korrigieren, ohne sich mit mir abzustimmen — sie hat einfach einen Teil der unteren Zähne abgeschliffen. Bevor ich reagieren konnte, hatte sie das „Überschüssige“ schon abgetragen. Jetzt weiß ich nicht, was ich tun soll; diese Millimeter müssen irgendwie wiederhergestellt werden. Überhaupt erlebe ich das zum ersten Mal, dass man zur Reinigung kommt und dazu noch die Zähne abgeschliffen bekommt, obwohl ich seit vielen Jahren regelmäßig Reinigungen machen lasse. Die Reinigung selbst verlief schlecht, sie war schmerzhaft und das Air-Flow-Gerät funktionierte nicht richtig — an einem Punkt schoss der Aufsatz einfach unter Druck in meinen Mund. Das Geld haben sie allerdings in voller Höhe genommen. Zuvor hatte ich in dieser Klinik schon einmal eine Reinigung, damals war alles in Ordnung, aber es hat ein junger Mann gearbeitet. In derselben Klinik habe ich auch eine Brücke machen lassen — sie wurde nicht perfekt gearbeitet, zwischen Brücke und Nachbarzahn ist ein Spalt, in dem sich Essen sammelt, sodass ich ihn ständig reinigen und dabei das Zahnfleisch verletzen muss. Und noch früher kam ich mit einer akuten Entzündung zu ihnen — sie verschrieben ein Antibiotikum und taten nichts; ich wollte nicht warten und habe den Zahn in einer anderen Klinik behandeln lassen. Kurz gesagt, eine mittelmäßige Praxis. Ein wenig günstiger als anderswo, aber die Ersparnis ist zweifelhaft. Die Reinigung mit dem Abschleifen war der letzte Tropfen — ich werde eine Beschwerde gegen sie bei der Ärztekammer einreichen.', 'Diş temizliği için gittim ve sonunda alt dişlerimin bir kısmını kaybettim, bu yüzden kapanışım değişti. Hekim, benimle görüşmeden kapanışımı düzeltmeye karar verdi — alt dişlerimin bir kısmını öylece törpüledi. Ben tepki veremeden "fazlalığı" çoktan aşındırmıştı. Şimdi ne yapacağımı bilmiyorum, o milimetrelerin bir şekilde geri kazanılması gerekiyor. Genel olarak, yıllardır düzenli temizlik yaptırmama rağmen, temizliğe gidip üstüne bir de dişlerinin törpülenmesiyle ilk kez karşılaşıyorum. Temizliğin kendisi de kötü geçti, acı vericiydi ve Air Flow cihazı düzgün çalışmıyordu; bir anda başlık basınçla ağzıma fırladı. Parayı ise tam olarak aldılar. Daha önce bu klinikte bir kez temizlik yaptırmıştım, o zaman her şey yolundaydı ama işlemi genç bir adam yapmıştı. Aynı klinikte köprü de yaptırdım — kusursuz yapmadılar, köprü ile komşu diş arasında yemek biriken bir boşluk var, sürekli temizlemek zorunda kalıyorum ve bu sırada diş etimi yaralıyorum. Daha da önce akut iltihapla gitmiştim — antibiyotik yazdılar ve hiçbir şey yapmadılar; beklemek istemedim ve dişimi başka bir klinikte tedavi ettirdim. Kısacası, vasat bir klinik. Diğer yerlerden biraz daha ucuz ama tasarruf şüpheli. Törpülemeli temizlik bardağı taşırdı, haklarında Tabipler Odasına şikâyet dilekçesi vereceğim.',
    0, '2026-04-26 00:00:00'),

(@user_jelena_drobnjak, @clinic_id, @doctor_jelena_potpara, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWM1ZVMUZZMUpSVW1kU1duUnBTMDR4VUVOd0xVRRAB',
    5, 'en', 'My sincere recommendation for Dr Jelena Potpara!',
    'Moja iskrena preporuka za dr Jelenu Potparu!', 'Моја искрена препорука за др Јелену Потпару!', 'My sincere recommendation for Dr Jelena Potpara!', 'Моя искренняя рекомендация доктору Елене Потпаре!', 'Meine aufrichtige Empfehlung für Dr. Jelena Potpara!', 'Dr Jelena Potpara için içten tavsiyem!',
    0, '2026-04-26 00:00:00'),

(@user_dean_plavsic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t3ME9XRTRRMUYzWTFkcWNIQnJRV1l5Tldsak5uYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-26 00:00:00'),

(@user_branko_dragisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5RFVGZFJkRFJNUTI5TlpXOTBNa3hzWjJGbE5YYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-26 00:00:00'),

(@user_jasna_jovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWT2NEZFFOVWsyTUdwd1ZVeGFkbkYxVGxGdFMwRRAB',
    5, 'sr', '👍🏻👍🏻 …',
    '👍🏻👍🏻 …', '👍🏻👍🏻 …', '👍🏻👍🏻', '👍🏻👍🏻', '👍🏻👍🏻', '👍🏻👍🏻',
    0, '2026-03-26 00:00:00'),

(@user_s_belmont, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT25rMU5rZ3RNRVpxVUhodlVsUjVha3czVkhabVEzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-26 00:00:00'),

(@user_relja_mucalica, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwdmRXbHVkVmg2U1ZsbFgyNHhSV2hMYWxaSmQyYxAB',
    5, 'bs', 'Sve odlicno',
    'Sve odlicno', 'Све одлично', 'Everything excellent', 'Всё отлично', 'Alles ausgezeichnet', 'Her şey mükemmel',
    0, '2026-02-26 00:00:00'),

(@user_sara_zec, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT25keGVtZFVibVpRYms4M2QycENVRk14T0ZkRVZWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-26 00:00:00'),

(@user_marko79_colan, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s0M05GOHlTekpRTVZWalpEbGZlVU5EUldwdmEzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-26 00:00:00'),

(@user_ksenija_lazarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT25waFEyVnVSR3MzUm1KVVNrdExWRzV6WVV4eE1tYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-26 00:00:00'),

(@user_suad_becic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oa1UwdDZWeTFXVVZCRFZ6QlhUVkpmWjNrNE9HYxAB',
    5, 'hr', 'Sve pohvale za cijeli tim.',
    'Sve pohvale za cijeli tim.', 'Све похвале за цијели тим.', 'All praise to the whole team.', 'Все похвалы всей команде.', 'Alles Lob an das ganze Team.', 'Tüm ekibe övgüler.',
    0, '2025-12-26 00:00:00'),

(@user_ena_vuckovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSNlEyTlRPRUpqVm1ScGJsbHplbVpTVlU5amJFRRAB',
    5, 'bs', 'Najaci u Budvu, posebno sestre :)',
    'Najaci u Budvu, posebno sestre :)', 'Најјачи у Будву, посебно сестре :)', 'The best in Budva, especially the nurses :)', 'Лучшие в Будве, особенно медсёстры :)', 'Die Besten in Budva, besonders die Schwestern :)', 'Budva\'nın en iyileri, özellikle hemşireler :)',
    0, '2025-12-26 00:00:00'),

(@user_raine_hailshard, @clinic_id, @doctor_dragana_bjelica, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGRlRsTnhTMWRzVDNSa2VFWlBjbTR6UmpsU1dIYxAB',
    5, 'en', 'We wish to express our gratitude to Dr Dragana Bjelica. Huge professional who tackles difficult cases with a firm hand, sharp eye and very kind approach. This a doctor that cares about her patients and their teeth. Hvala puno 🤍🦷 …',
    'Želimo da izrazimo svoju zahvalnost dr Dragani Bjelici. Veliki profesionalac koji teške slučajeve rješava sigurnom rukom, izoštrenim okom i veoma ljubaznim pristupom. Ovo je doktorka koja brine o svojim pacijentima i njihovim zubima. Hvala puno 🤍🦷', 'Желимо да изразимо своју захвалност др Драгани Бјелици. Велики професионалац који тешке случајеве рјешава сигурном руком, изоштреним оком и веома љубазним приступом. Ово је докторка која брине о својим пацијентима и њиховим зубима. Хвала пуно 🤍🦷', 'We wish to express our gratitude to Dr Dragana Bjelica. Huge professional who tackles difficult cases with a firm hand, sharp eye and very kind approach. This a doctor that cares about her patients and their teeth. Hvala puno 🤍🦷 …', 'Хотим выразить благодарность доктору Драгане Бьелице. Огромный профессионал, который берётся за сложные случаи — твёрдая рука, острый глаз и очень доброжелательный подход. Это доктор, которая заботится о своих пациентах и их зубах. Hvala puno 🤍🦷', 'Wir möchten Dr. Dragana Bjelica unseren Dank aussprechen. Eine großartige Fachfrau, die schwierige Fälle mit sicherer Hand, geschultem Blick und sehr freundlichem Umgang angeht. Das ist eine Ärztin, die sich um ihre Patienten und deren Zähne kümmert. Hvala puno 🤍🦷', 'Dr Dragana Bjelica\'ya şükranlarımızı sunmak istiyoruz. Zor vakaların üstesinden emin bir el, keskin bir göz ve çok nazik bir yaklaşımla gelen büyük bir profesyonel. Hastalarını ve dişlerini gerçekten önemseyen bir hekim. Hvala puno 🤍🦷',
    0, '2025-10-26 00:00:00'),

(@user_roman_kirov, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pseVZqRjBYMGRyZFhwV2RIVkZaR2RxYTJSUExYYxAB',
    1, 'ru', 'Если хотите качественно сделать зубы, вам не в эту клинику. Делал зубы одна пломба откололась через 5 дней, во второй трещина между стенкой зуба и пломбой через 1 месяц. У моей подруги два зуба нужно переделывать воспаление канала после того как она из сделал в этой клинике. У моего товарища воспаление он обращался два раза, в первый раз поставили пломбу но зуб не переставал болеть, во второй раз сделали рентген было воспаление в канале прописали антибиотики и не записали даже на повторную консультацию в итоге улетел в Россию делать нормально зуб так как болела голова постоянно, сейчас вырвали ему зуб т.к. нет возможности залечить и теперь ставят имплант в челюсть это не быстрая и не дешевая процедура. Обходите эту клинику стороной.',
    'Ako želite kvalitetno da vam poprave zube, ovo nije klinika za vas. Radio sam zube — jedna plomba se odlomila nakon 5 dana, na drugoj se nakon mjesec dana pojavila pukotina između zida zuba i plombe. Mojoj drugarici dva zuba moraju da se prerađuju zbog upale kanala nakon što ih je radila u ovoj klinici. Moj prijatelj je imao upalu i obraćao se dva puta: prvi put su stavili plombu, ali zub nije prestao da boli, drugi put su uradili rendgen, bila je upala u kanalu, prepisali su antibiotike i nisu ga zakazali čak ni na kontrolu. Na kraju je odletio u Rusiju da mu zub urade kako treba, jer ga je stalno boljela glava; sada su mu izvadili zub jer nije bilo mogućnosti da se izliječi i ugrađuju mu implant u vilicu — a to nije ni brza ni jeftina procedura. Zaobiđite ovu kliniku.', 'Ако желите квалитетно да вам поправе зубе, ово није клиника за вас. Радио сам зубе — једна пломба се одломила након 5 дана, на другој се након мјесец дана појавила пукотина између зида зуба и пломбе. Мојој другарици два зуба морају да се прерађују због упале канала након што их је радила у овој клиници. Мој пријатељ је имао упалу и обраћао се два пута: први пут су ставили пломбу, али зуб није престао да боли, други пут су урадили рендген, била је упала у каналу, преписали су антибиотике и нису га заказали чак ни на контролу. На крају је одлетио у Русију да му зуб ураде како треба, јер га је стално бољела глава; сада су му извадили зуб јер није било могућности да се излијечи и уграђују му имплант у вилицу — а то није ни брза ни јефтина процедура. Заобиђите ову клинику.', 'If you want your teeth done properly, this is not the clinic for you. I had work done here — one filling chipped off after 5 days, and on another a crack appeared between the tooth wall and the filling after a month. A friend of mine has to have two teeth redone because of root canal inflammation after having them treated at this clinic. Another friend had an inflammation and went twice: the first time they put in a filling but the tooth kept hurting; the second time they took an X-ray, there was inflammation in the canal, they prescribed antibiotics and did not even schedule a follow-up. In the end he flew to Russia to have the tooth done properly, because he had constant headaches; now the tooth has been extracted because it could not be saved and he is getting an implant in his jaw — which is neither a quick nor a cheap procedure. Steer clear of this clinic.', 'Если хотите качественно сделать зубы, вам не в эту клинику. Делал зубы одна пломба откололась через 5 дней, во второй трещина между стенкой зуба и пломбой через 1 месяц. У моей подруги два зуба нужно переделывать воспаление канала после того как она из сделал в этой клинике. У моего товарища воспаление он обращался два раза, в первый раз поставили пломбу но зуб не переставал болеть, во второй раз сделали рентген было воспаление в канале прописали антибиотики и не записали даже на повторную консультацию в итоге улетел в Россию делать нормально зуб так как болела голова постоянно, сейчас вырвали ему зуб т.к. нет возможности залечить и теперь ставят имплант в челюсть это не быстрая и не дешевая процедура. Обходите эту клинику стороной.', 'Wenn Sie Ihre Zähne ordentlich behandelt haben wollen, ist dies nicht die richtige Klinik. Ich habe hier Zähne machen lassen — eine Füllung brach nach 5 Tagen ab, bei einer anderen zeigte sich nach einem Monat ein Riss zwischen Zahnwand und Füllung. Bei einer Freundin müssen zwei Zähne neu gemacht werden, weil sich nach der Behandlung in dieser Klinik der Wurzelkanal entzündet hat. Ein Bekannter hatte eine Entzündung und war zweimal dort: beim ersten Mal setzten sie eine Füllung, doch der Zahn schmerzte weiter; beim zweiten Mal machten sie ein Röntgenbild, im Kanal war eine Entzündung, sie verschrieben Antibiotika und vereinbarten nicht einmal einen Kontrolltermin. Am Ende flog er nach Russland, um den Zahn richtig behandeln zu lassen, weil er ständig Kopfschmerzen hatte; nun wurde der Zahn gezogen, weil er nicht zu retten war, und er bekommt ein Implantat in den Kiefer — das ist weder ein schnelles noch ein günstiges Verfahren. Meiden Sie diese Klinik.', 'Dişlerinizin düzgün yapılmasını istiyorsanız burası size uygun bir klinik değil. Burada diş yaptırdım — bir dolgu 5 gün sonra kırıldı, bir diğerinde ise bir ay sonra diş duvarı ile dolgu arasında çatlak oluştu. Bir arkadaşımın bu klinikte tedavi ettirdiği iki dişi, kanal iltihabı nedeniyle yeniden yapılmak zorunda. Başka bir arkadaşım iltihap şikâyetiyle iki kez gitti: ilk seferinde dolgu yaptılar ama diş ağrımaya devam etti, ikinci seferinde röntgen çektiler, kanalda iltihap vardı, antibiyotik yazdılar ve kontrol randevusu bile vermediler. Sonunda sürekli baş ağrısı çektiği için dişini düzgün yaptırmak üzere Rusya\'ya uçtu; şimdi diş kurtarılamadığı için çekildi ve çenesine implant yapılıyor — bu da ne hızlı ne de ucuz bir işlem. Bu klinikten uzak durun.',
    0, '2025-09-26 00:00:00'),

(@user_nevena_dragicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWQmVtVnNXbkJoU1RacU1VYzRlWGw0WVZwblZFRRAB',
    5, 'bs', 'Sve preporuke!
Profesionalizam, znanje, tradicija i iskrena briga i posvećenost svaki put kada bismo došli i ja i cijela porodica.
Posebna pohvala za pristup i odnos prema djeci.',
    'Sve preporuke!
Profesionalizam, znanje, tradicija i iskrena briga i posvećenost svaki put kada bismo došli i ja i cijela porodica.
Posebna pohvala za pristup i odnos prema djeci.', 'Све препоруке!
Професионализам, знање, традиција и искрена брига и посвећеност сваки пут када бисмо дошли и ја и цијела породица.
Посебна похвала за приступ и однос према дјеци.', 'Highly recommended!
Professionalism, knowledge, tradition, and genuine care and dedication every time my whole family and I came in.
Special praise for their approach and attitude towards children.', 'Всячески рекомендую!
Профессионализм, знания, традиция, искренняя забота и внимание каждый раз, когда приходили я и вся моя семья.
Особая похвала за подход и отношение к детям.', 'Uneingeschränkt empfehlenswert!
Professionalität, Fachwissen, Tradition sowie aufrichtige Sorgfalt und Hingabe bei jedem Besuch von mir und meiner ganzen Familie.
Besonderes Lob für den Umgang mit Kindern.', 'Kesinlikle tavsiye ederim!
Ben ve tüm ailem her gelişimizde profesyonellik, bilgi, gelenek, içten bir özen ve bağlılık gördük.
Çocuklara yaklaşımları ve ilgileri için ayrıca övgüyü hak ediyorlar.',
    0, '2025-08-26 00:00:00'),

(@user_veljo_milicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aNFYwMW9WMmxNTURsS1gyNWphWEJzZDFsdVJVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-26 00:00:00'),

(@user_hana_vujacic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5UmFTMURUSEZWVmxkZmJHNW5SV0Z3Vlc0MU0wRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-07-26 00:00:00'),

(@user_marianna_marushchak, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kMU1FcGpXalpNWm1SQ1ZGa3RURk5EWWpoWU0zYxAB',
    1, 'en', 'The service from the nurses and the administrator was super , they were very kind and polite. The service from the dentist (I don’t remember the name but please see this woman on the attached picture) who did an x-ray of one tooth complete trash. I sat down in the cabinet to get an x-ray and this doctor spoke to me rudely and boorishly , I didn’t understand all the words and she raised her voice , waved her hands nervously and behaved disrespectfully , loudly said “OPEN YOUR MOUTH” and so on. This is unacceptable. I believe that since I am a client and pay money for services (which also go into her salary) , and especially since I am also a patient with a dental problem which I’m worried about , she is obliged to remember this and show maximum respect. For me , such behavior does not characterize such an employee/doctor as a professional. Now get ready , she inserted the x-ray sensor , which should be done before the x-ray , WITH BARE HANDS, WITHOUT GLOVES. And then she took the rubber band off this sensor and I saw that she put it in a cup where there were other similar rubber bands 🤮 that is , I can’t be sure how disinfected her hands were , after the previous patients , whose rubber bands she put in exactly the same way with her bare hands in that cup. Disgusting , I’m just shocked… you say that a doctor disinfects her hands before entering and starting - maybe then let’s surgeons also perform operations without gloves ? Or gynecologists ? I have wounds in my mouth , how can I know what kind of micro scratches she has on her hands or what\'s under the nails ? 😳',
    'Usluga sestara i administratorke bila je super, bile su veoma ljubazne i uljudne. Usluga stomatologinje (ne pamtim ime, ali pogledajte tu ženu na priloženoj slici) koja mi je uradila snimak jednog zuba — potpuno smeće. Sjela sam u ordinaciju da mi se uradi snimak i ta doktorka mi se obraćala grubo i prostački, nisam razumjela sve riječi, a ona je podizala glas, nervozno mahala rukama i ponašala se bez poštovanja, glasno je rekla „OTVORI USTA“ i tako dalje. To je neprihvatljivo. Smatram da, s obzirom na to da sam klijent i plaćam za usluge (koje idu i u njenu platu), a posebno zato što sam i pacijentkinja sa zubnim problemom koji me brine, ona je dužna da to ima na umu i pokaže maksimum poštovanja. Za mene takvo ponašanje ne opisuje takvog zaposlenog/doktora kao profesionalca. A sad se pripremite: senzor za snimanje, koji se postavlja prije snimka, ubacila je GOLIM RUKAMA, BEZ RUKAVICA. A zatim je skinula gumicu s tog senzora i vidjela sam da je stavlja u čašu u kojoj su bile druge slične gumice 🤮 — to znači da ne mogu biti sigurna koliko su joj ruke bile dezinfikovane, nakon prethodnih pacijenata čije je gumice na potpuno isti način golim rukama stavljala u tu čašu. Odvratno, prosto sam šokirana… kažete da doktor dezinfikuje ruke prije ulaska i početka rada — možda onda i hirurzi da operišu bez rukavica? Ili ginekolozi? Imam rane u ustima, kako mogu znati kakve mikroogrebotine ima na rukama ili šta joj je pod nokrima? 😳', 'Услуга сестара и администраторке била је супер, биле су веома љубазне и уљудне. Услуга стоматологиње (не памтим име, али погледајте ту жену на приложеној слици) која ми је урадила снимак једног зуба — потпуно смеће. Сјела сам у ординацију да ми се уради снимак и та докторка ми се обраћала грубо и простачки, нисам разумјела све ријечи, а она је подизала глас, нервозно махала рукама и понашала се без поштовања, гласно је рекла „ОТВОРИ УСТА“ и тако даље. То је неприхватљиво. Сматрам да, с обзиром на то да сам клијент и плаћам за услуге (које иду и у њену плату), а посебно зато што сам и пацијенткиња са зубним проблемом који ме брине, она је дужна да то има на уму и покаже максимум поштовања. За мене такво понашање не описује таквог запосленог/доктора као професионалца. А сад се припремите: сензор за снимање, који се поставља прије снимка, убацила је ГОЛИМ РУКАМА, БЕЗ РУКАВИЦА. А затим је скинула гумицу с тог сензора и видјела сам да је ставља у чашу у којој су биле друге сличне гумице 🤮 — то значи да не могу бити сигурна колико су јој руке биле дезинфиковане, након претходних пацијената чије је гумице на потпуно исти начин голим рукама стављала у ту чашу. Одвратно, просто сам шокирана… кажете да доктор дезинфикује руке прије уласка и почетка рада — можда онда и хирурзи да оперишу без рукавица? Или гинеколози? Имам ране у устима, како могу знати какве микроогреботине има на рукама или шта јој је под ноктима? 😳', 'The service from the nurses and the administrator was super , they were very kind and polite. The service from the dentist (I don’t remember the name but please see this woman on the attached picture) who did an x-ray of one tooth complete trash. I sat down in the cabinet to get an x-ray and this doctor spoke to me rudely and boorishly , I didn’t understand all the words and she raised her voice , waved her hands nervously and behaved disrespectfully , loudly said “OPEN YOUR MOUTH” and so on. This is unacceptable. I believe that since I am a client and pay money for services (which also go into her salary) , and especially since I am also a patient with a dental problem which I’m worried about , she is obliged to remember this and show maximum respect. For me , such behavior does not characterize such an employee/doctor as a professional. Now get ready , she inserted the x-ray sensor , which should be done before the x-ray , WITH BARE HANDS, WITHOUT GLOVES. And then she took the rubber band off this sensor and I saw that she put it in a cup where there were other similar rubber bands 🤮 that is , I can’t be sure how disinfected her hands were , after the previous patients , whose rubber bands she put in exactly the same way with her bare hands in that cup. Disgusting , I’m just shocked… you say that a doctor disinfects her hands before entering and starting - maybe then let’s surgeons also perform operations without gloves ? Or gynecologists ? I have wounds in my mouth , how can I know what kind of micro scratches she has on her hands or what\'s under the nails ? 😳', 'Работа медсестёр и администратора была супер, они были очень любезны и вежливы. А вот работа стоматолога (имени не помню, но посмотрите на эту женщину на прикреплённом фото), которая сделала мне снимок одного зуба, — полный мусор. Я села в кабинете, чтобы сделать снимок, и эта доктор обращалась ко мне грубо и по-хамски, я не понимала всех слов, а она повышала голос, нервно махала руками и вела себя без уважения, громко сказала «ОТКРОЙ РОТ» и так далее. Это недопустимо. Считаю, что раз я клиент и плачу за услуги (которые идут и в её зарплату), и тем более раз я ещё и пациент с зубной проблемой, которая меня беспокоит, она обязана об этом помнить и проявлять максимум уважения. Для меня такое поведение не характеризует такого сотрудника/врача как профессионала. А теперь приготовьтесь: сенсор для снимка, который устанавливают перед съёмкой, она вставила ГОЛЫМИ РУКАМИ, БЕЗ ПЕРЧАТОК. А потом сняла с этого сенсора резинку, и я увидела, что она кладёт её в стакан, где лежали другие такие же резинки 🤮 — то есть я не могу быть уверена, насколько продезинфицированы были её руки после предыдущих пациентов, чьи резинки она точно так же голыми руками складывала в этот стакан. Мерзко, я просто в шоке… вы говорите, что врач дезинфицирует руки перед входом и началом работы — может, тогда и хирурги пусть оперируют без перчаток? Или гинекологи? У меня раны в рту, откуда мне знать, какие у неё микроцарапины на руках или что у неё под ногтями? 😳', 'Der Service der Schwestern und der Administratorin war super, sie waren sehr freundlich und höflich. Der Service der Zahnärztin (ich erinnere mich nicht an den Namen, aber sehen Sie sich diese Frau auf dem beigefügten Bild an), die eine Röntgenaufnahme eines Zahns machte, war kompletter Müll. Ich setzte mich im Behandlungsraum für die Aufnahme hin, und diese Ärztin sprach grob und ungehobelt mit mir, ich verstand nicht alle Worte, und sie erhob die Stimme, fuchtelte nervös mit den Händen und verhielt sich respektlos, sagte laut „MUND AUF“ und so weiter. Das ist unakzeptabel. Ich finde, da ich Kundin bin und für Leistungen bezahle (die auch in ihr Gehalt fließen), und besonders da ich auch Patientin mit einem Zahnproblem bin, das mich beunruhigt, ist sie verpflichtet, daran zu denken und größten Respekt zu zeigen. Für mich zeichnet ein solches Verhalten eine solche Mitarbeiterin/Ärztin nicht als Fachkraft aus. Und jetzt halten Sie sich fest: den Röntgensensor, der vor der Aufnahme eingesetzt wird, hat sie MIT BLOSSEN HÄNDEN, OHNE HANDSCHUHE eingeführt. Und dann nahm sie das Gummiband von diesem Sensor ab, und ich sah, dass sie es in einen Becher legte, in dem andere ähnliche Gummibänder lagen 🤮 — das heißt, ich kann nicht sicher sein, wie desinfiziert ihre Hände waren, nach den vorherigen Patienten, deren Gummibänder sie genau so mit bloßen Händen in diesen Becher legte. Widerlich, ich bin einfach schockiert… Sie sagen, eine Ärztin desinfiziere ihre Hände vor dem Betreten und dem Beginn — vielleicht sollen dann auch Chirurgen ohne Handschuhe operieren? Oder Gynäkologen? Ich habe Wunden im Mund, woher soll ich wissen, welche Mikrokratzer sie an den Händen hat oder was sich unter ihren Nägeln befindet? 😳', 'Hemşirelerin ve resepsiyon görevlisinin hizmeti harikaydı, çok nazik ve kibarlardı. Bir dişimin röntgenini çeken diş hekiminin (adını hatırlamıyorum ama ekli fotoğraftaki kadına bakın) hizmeti ise tam bir felaket. Röntgen için odaya oturdum ve bu hekim bana kaba ve nezaketsiz bir şekilde hitap etti, bütün kelimeleri anlamadım, o ise sesini yükseltti, ellerini sinirli sinirli savurdu ve saygısızca davrandı, yüksek sesle "AĞZINI AÇ" dedi ve devam etti. Bu kabul edilemez. Müşteri olduğum ve hizmet için para ödediğim (ki bu para onun maaşına da gidiyor), üstelik beni endişelendiren bir diş sorunu olan bir hasta olduğum düşünüldüğünde, bunu hatırlaması ve azami saygıyı göstermesi gerektiğini düşünüyorum. Bana göre böyle bir davranış, böyle bir çalışanı/hekimi profesyonel olarak nitelendirmez. Şimdi hazır olun: röntgenden önce yerleştirilmesi gereken sensörü ÇIPLAK ELLE, ELDİVENSİZ taktı. Sonra bu sensörün lastiğini çıkardı ve onu, içinde benzer başka lastiklerin bulunduğu bir bardağa koyduğunu gördüm 🤮 — yani, lastiklerini aynı şekilde çıplak elle o bardağa koyduğu önceki hastalardan sonra ellerinin ne kadar dezenfekte edildiğinden emin olamıyorum. İğrenç, gerçekten şoktayım… hekimin girerken ve işe başlarken ellerini dezenfekte ettiğini söylüyorsunuz — o zaman belki cerrahlar da eldivensiz ameliyat etsin? Ya da jinekologlar? Ağzımda yaralar var, ellerinde ne tür mikro çizikler olduğunu ya da tırnaklarının altında ne olduğunu nasıl bilebilirim? 😳',
    0, '2025-07-26 00:00:00'),

(@user_ljubisa_miladic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VNamJtb0RRN2ZyZy1BRRAB',
    5, 'hr', 'Ljubazno osoblje  sve pohvale',
    'Ljubazno osoblje  sve pohvale', 'Љубазно особље, све похвале', 'Kind staff, all praise', 'Любезный персонал, все похвалы', 'Freundliches Personal, alles Lob', 'Nazik personel, her türlü övgü',
    0, '2025-07-26 00:00:00'),

(@user_marija_zekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VNS1Btc0RzZ05QdVF3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-07-26 00:00:00'),

(@user_guenter_hopmann, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VNYTVvYW1yeS1lSTRnRRAB',
    5, 'de', 'Mir ist im Urlaub in Budva eine Krone los gegangen. Google gefragt, und die Zahnarztpraxis „Musura“ gefunden.
Tolle, sehr moderne und einladende  Praxis.
Hatte wohl Glück. Keine Wartezeit, 5 Minuten, und eine junge Zahnärztin begrüßte mich.
In 15 Minuten war die Krone wieder an Ort und Stelle.
Schnelle und saubere Arbeit.
Alle sehr freundlich. Kann ich mit gutem Gewissen nur weiter empfehlen.
Vielen lieben Dank.',
    'Na odmoru u Budvi ispala mi je krunica. Pitao sam Google i našao stomatološku ordinaciju „Musura“.
Sjajna, veoma moderna i primamljiva ordinacija.
Očigledno sam imao sreće. Nikakvog čekanja, 5 minuta, i pozdravila me je mlada stomatologinja.
Za 15 minuta krunica je bila ponovo na svom mjestu.
Brz i čist rad.
Svi veoma ljubazni. Mogu da preporučim s čistom savješću.
Hvala vam najlepše.', 'На одмору у Будви испала ми је круница. Питао сам Google и нашао стоматолошку ординацију „Musura“.
Сјајна, веома модерна и примамљива ординација.
Очигледно сам имао среће. Никаквог чекања, 5 минута, и поздравила ме је млада стоматологиња.
За 15 минута круница је била поново на свом мјесту.
Брз и чист рад.
Сви веома љубазни. Могу да препоручим с чистом савјешћу.
Хвала вам најлепше.', 'A crown came loose while I was on holiday in Budva. I asked Google and found the dental practice "Musura".
A great, very modern and inviting practice.
I was clearly lucky. No waiting time, 5 minutes, and a young dentist greeted me.
Within 15 minutes the crown was back in place.
Quick and clean work.
Everyone very friendly. I can recommend them with a clear conscience.
Many thanks.', 'Во время отпуска в Будве у меня отвалилась коронка. Спросил Google и нашёл стоматологический кабинет «Musura».
Отличный, очень современный и располагающий кабинет.
Видимо, мне повезло. Никакого ожидания, 5 минут, и меня встретила молодая врач-стоматолог.
За 15 минут коронка была снова на месте.
Быстрая и чистая работа.
Все очень приветливы. Могу рекомендовать с чистой совестью.
Большое спасибо.', 'Mir ist im Urlaub in Budva eine Krone los gegangen. Google gefragt, und die Zahnarztpraxis „Musura“ gefunden.
Tolle, sehr moderne und einladende  Praxis.
Hatte wohl Glück. Keine Wartezeit, 5 Minuten, und eine junge Zahnärztin begrüßte mich.
In 15 Minuten war die Krone wieder an Ort und Stelle.
Schnelle und saubere Arbeit.
Alle sehr freundlich. Kann ich mit gutem Gewissen nur weiter empfehlen.
Vielen lieben Dank.', 'Budva\'da tatildeyken bir kronum düştü. Google\'a sordum ve "Musura" diş kliniğini buldum.
Harika, çok modern ve davetkâr bir klinik.
Belli ki şanslıydım. Hiç bekleme yok, 5 dakika, ve genç bir diş hekimi beni karşıladı.
15 dakika içinde kron yerine geri kondu.
Hızlı ve temiz bir iş.
Herkes çok güler yüzlü. Gönül rahatlığıyla tavsiye edebilirim.
Çok teşekkür ederim.',
    0, '2025-07-26 00:00:00'),

(@user_lidija_todorovic, @clinic_id, @doctor_dejan_musura, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnTURvLTZDUlFnEAE',
    5, 'bs', 'Trideset godina idem kod Doktora Dejana Mušure. Sve najbolje mogu reći za Doktora Mušuru. Veoma profesionalan i jako dobar Doktor. Brine o svojim pacijenatima i uvek je na raspolaganju.  Sve preporuke . Doktore hvala Vam što sam vaša pacijentkinja.',
    'Trideset godina idem kod Doktora Dejana Mušure. Sve najbolje mogu reći za Doktora Mušuru. Veoma profesionalan i jako dobar Doktor. Brine o svojim pacijenatima i uvek je na raspolaganju.  Sve preporuke . Doktore hvala Vam što sam vaša pacijentkinja.', 'Тридесет година идем код Доктора Дејана Мушуре. Све најбоље могу рећи за Доктора Мушуру. Веома професионалан и јако добар Доктор. Брине о својим пацијентима и увек је на располагању. Све препоруке. Докторе, хвала Вам што сам ваша пацијенткиња.', 'I have been going to Dr Dejan Mušura for thirty years. I can only say the best about Dr Mušura. A very professional and very good doctor. He cares about his patients and is always available. Highly recommended. Doctor, thank you for having me as your patient.', 'Тридцать лет я хожу к доктору Деяну Мушуре. О докторе Мушуре могу сказать только самое лучшее. Очень профессиональный и очень хороший доктор. Заботится о своих пациентах и всегда доступен. Всячески рекомендую. Доктор, спасибо Вам за то, что я ваша пациентка.', 'Seit dreißig Jahren gehe ich zu Dr. Dejan Mušura. Über Dr. Mušura kann ich nur das Beste sagen. Ein sehr professioneller und sehr guter Arzt. Er kümmert sich um seine Patienten und ist immer erreichbar. Uneingeschränkt empfehlenswert. Herr Doktor, danke, dass ich Ihre Patientin sein darf.', 'Otuz yıldır Dr Dejan Mušura\'ya gidiyorum. Dr Mušura hakkında sadece en güzel şeyleri söyleyebilirim. Çok profesyonel ve çok iyi bir hekim. Hastalarını önemsiyor ve her zaman ulaşılabilir. Kesinlikle tavsiye ederim. Doktor, hastanız olduğum için size teşekkür ederim.',
    0, '2025-07-26 00:00:00'),

(@user_jelena, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNQNlpUT19RRRAB',
    3, 'bs', 'Osoblje je divno, prijatno, sve pohvale za sestre koje rade tamo.
A doktorica je gruba i sva komunikacija sa njom je bila neprijatna zbog njene neljubaznosti. U svakom slučaju ne preporučujem bilo kome ko traži profesionalnu i pažljivu uslugu.',
    'Osoblje je divno, prijatno, sve pohvale za sestre koje rade tamo.
A doktorica je gruba i sva komunikacija sa njom je bila neprijatna zbog njene neljubaznosti. U svakom slučaju ne preporučujem bilo kome ko traži profesionalnu i pažljivu uslugu.', 'Особље је дивно, пријатно, све похвале за сестре које раде тамо.
А докторица је груба и сва комуникација са њом је била непријатна због њене нељубазности. У сваком случају не препоручујем било коме ко тражи професионалну и пажљиву услугу.', 'The staff is wonderful and pleasant, all praise to the nurses who work there.
But the lady doctor is rude and all communication with her was unpleasant because of her unkindness. In any case I would not recommend it to anyone looking for professional and attentive service.', 'Персонал прекрасный, приятный, все похвалы медсёстрам, которые там работают.
А докторша грубая, и всё общение с ней было неприятным из-за её нелюбезности. В любом случае не рекомендую никому, кто ищет профессиональное и внимательное обслуживание.', 'Das Personal ist wunderbar und angenehm, alles Lob an die Schwestern, die dort arbeiten.
Die Ärztin hingegen ist grob, und die ganze Kommunikation mit ihr war wegen ihrer Unfreundlichkeit unangenehm. In jedem Fall empfehle ich es niemandem, der professionellen und aufmerksamen Service sucht.', 'Personel harika ve hoş, orada çalışan hemşirelere her türlü övgü.
Hanım hekim ise kaba ve nezaketsizliği yüzünden onunla tüm iletişim rahatsız ediciydi. Her hâlükârda profesyonel ve özenli hizmet arayan hiç kimseye tavsiye etmiyorum.',
    0, '2025-07-26 00:00:00'),

(@user_nina_maric, @clinic_id, @doctor_nikola_musura, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2LU5qM2d3RRAB',
    5, 'bs', 'Izuzetno profesionalni, opremljeni najsavremenijom opremom, ordinacija sa nevjerovatnom atmosferom i vrlo ljubaznim osobljem.Posebne pohvale za mladog dr Nikolu. Sve preporuke!',
    'Izuzetno profesionalni, opremljeni najsavremenijom opremom, ordinacija sa nevjerovatnom atmosferom i vrlo ljubaznim osobljem.Posebne pohvale za mladog dr Nikolu. Sve preporuke!', 'Изузетно професионални, опремљени најсавременијом опремом, ординација са невјероватном атмосфером и врло љубазним особљем. Посебне похвале за младог др Николу. Све препоруке!', 'Exceptionally professional, equipped with state-of-the-art technology, a practice with an incredible atmosphere and very kind staff. Special praise for the young Dr Nikola. Highly recommended!', 'Исключительно профессиональные, оснащены самым современным оборудованием, кабинет с невероятной атмосферой и очень любезным персоналом. Особые похвалы молодому доктору Николе. Всячески рекомендую!', 'Äußerst professionell, mit modernster Technik ausgestattet, eine Praxis mit unglaublicher Atmosphäre und sehr freundlichem Personal. Besonderes Lob für den jungen Dr. Nikola. Uneingeschränkt empfehlenswert!', 'Son derece profesyonel, en modern donanımla döşenmiş, inanılmaz bir atmosfere ve çok nazik bir personele sahip bir klinik. Genç Dr Nikola\'ya özel övgüler. Kesinlikle tavsiye ederim!',
    0, '2025-07-26 00:00:00'),

(@user_matea_odalovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2Mk1uQnZnRRAB',
    5, 'bs', 'Divan kolektiv, ljubazno i edukovano osoblje. Sve preporuke!',
    'Divan kolektiv, ljubazno i edukovano osoblje. Sve preporuke!', 'Диван колектив, љубазно и едуковано особље. Све препоруке!', 'A wonderful team, kind and well-trained staff. Highly recommended!', 'Прекрасный коллектив, любезный и образованный персонал. Всячески рекомендую!', 'Ein wunderbares Team, freundliches und gut ausgebildetes Personal. Uneingeschränkt empfehlenswert!', 'Harika bir ekip, nazik ve iyi eğitimli personel. Kesinlikle tavsiye ederim!',
    0, '2025-07-26 00:00:00'),

(@user_sanja_janketi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2Mko3WGVBEAE',
    5, 'en', 'Amazing service!',
    'Neverovatna usluga!', 'Невјероватна услуга!', 'Amazing service!', 'Потрясающее обслуживание!', 'Erstaunlicher Service!', 'Muhteşem hizmet!',
    0, '2025-07-26 00:00:00'),

(@user_mina_kalezic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUN2Mk82UUpBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-07-26 00:00:00'),

(@user_vesna_vuckovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSURMcmJLX2lBRRAB',
    1, 'bs', 'Loša usluga',
    'Loša usluga', 'Лоша услуга', 'Poor service', 'Плохое обслуживание', 'Schlechter Service', 'Kötü hizmet',
    0, '2024-07-26 00:00:00'),

(@user_anet, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSURMcHJUVE53EAE',
    5, 'en', 'Nice helpful personel',
    'Ljubazno i uslužno osoblje', 'Љубазно и услужно особље', 'Nice helpful personel', 'Милый и отзывчивый персонал', 'Freundliches und hilfsbereites Personal', 'Nazik ve yardımcı personel',
    0, '2024-07-26 00:00:00'),

(@user_ana_zizic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSURENlpHM2hBRRAB',
    5, 'hr', 'Najljubazniji kolektiv sa zasigurno najstručnijim i najprofesionalnijim zaposlenim ljudima u oblasti stomatologije. Uvijek obavljam sve vrste preglede, kao i interevencije u stomatološkoj ordinaciji Mušura unazad godinama. Najiskrenija preporuka za najbolju uslugu! :)',
    'Najljubazniji kolektiv sa zasigurno najstručnijim i najprofesionalnijim zaposlenim ljudima u oblasti stomatologije. Uvijek obavljam sve vrste preglede, kao i interevencije u stomatološkoj ordinaciji Mušura unazad godinama. Najiskrenija preporuka za najbolju uslugu! :)', 'Најљубазнији колектив са засигурно најстручнијим и најпрофесионалнијим запосленим људима у области стоматологије. Увијек обављам све врсте прегледа, као и интервенције у стоматолошкој ординацији Мушура уназад годинама. Најискренија препорука за најбољу услугу! :)', 'The kindest team, with surely the most skilled and most professional people employed in the field of dentistry. For years now I have had all kinds of check-ups as well as procedures done at the Mušura dental practice. My most sincere recommendation for the best service! :)', 'Самый любезный коллектив, где работают, безусловно, самые знающие и самые профессиональные люди в области стоматологии. Уже много лет я прохожу все виды осмотров, а также лечение в стоматологическом кабинете Мушура. Самая искренняя рекомендация — лучшее обслуживание! :)', 'Das freundlichste Team mit sicherlich den fachlich besten und professionellsten Mitarbeitern im Bereich der Zahnmedizin. Seit Jahren lasse ich alle Arten von Untersuchungen sowie Behandlungen in der Zahnarztpraxis Mušura durchführen. Meine aufrichtigste Empfehlung für den besten Service! :)', 'En nazik ekip ve diş hekimliği alanında kuşkusuz en bilgili, en profesyonel çalışanlar. Yıllardır her türlü muayenemi ve tedavimi Mušura diş kliniğinde yaptırıyorum. En iyi hizmet için en içten tavsiyem! :)',
    0, '2024-07-26 00:00:00'),

(@user_s_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSURENmY3dld3EAE',
    5, 'hr', 'Sve pohvale za Ljubazno Osoblje, rade i Subotom.
Ordinacija super opremljena i cista.',
    'Sve pohvale za Ljubazno Osoblje, rade i Subotom.
Ordinacija super opremljena i cista.', 'Све похвале за љубазно особље, раде и субботом.
Ординација супер опремљена и чиста.', 'All praise for the kind staff, they work on Saturdays too.
The practice is very well equipped and clean.', 'Все похвалы любезному персоналу, работают и по субботам.
Кабинет прекрасно оснащён и чистый.', 'Alles Lob für das freundliche Personal, sie arbeiten auch samstags.
Die Praxis ist super ausgestattet und sauber.', 'Nazik personele her türlü övgü, cumartesi günleri de çalışıyorlar.
Klinik çok iyi donatılmış ve temiz.',
    0, '2024-07-26 00:00:00'),

(@user_merima_karastanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNOeE5LcDRnRRAB',
    5, 'en', 'This review has been long overdue. In an unfortunate situation where my teenage daughter broke her front tooth, we were fortunate to find a dentist of Dr. Mušura\'s caliber. After witnessing the exceptional work he had done on my nephew\'s front tooth, which was also broken, I immediately decided that my daughter would have her tooth fixed by Dr. Mušura.
Despite living in Chicago, where two different dentists saw my daughter within our dental insurance network for the same tooth, their attempts to fix it were subpar. In light of this, my daughter flew to Montenegro specifically to visit Dr. Mušura and his team, who performed an extraordinary feat. It\'s impossible to discern which tooth was worked on; the result is impeccable.
I wholeheartedly recommend Dr. Mušura and his team to all my family, friends, and anyone needing superb dental care. Their expertise and artistry are truly commendable.
Sincerely,
Selma’s mom',
    'Ova recenzija je davno trebalo da bude napisana. U nesrećnoj situaciji kada je moja kćerka tinejdžerka slomila prednji zub, imali smo sreću da nađemo stomatologa kalibra dr Mušure. Nakon što sam vidjela izuzetan rad koji je uradio na prednjem zubu mog nećaka, koji je takođe bio slomljen, odmah sam odlučila da će moja kćerka zub popraviti kod dr Mušure.
Iako živimo u Čikagu, gdje su dva različita stomatologa iz naše mreže zubnog osiguranja pregledala moju kćerku za isti zub, njihovi pokušaji da ga poprave bili su ispod svakog nivoa. S obzirom na to, moja kćerka je odletjela u Crnu Goru posebno da posjeti dr Mušuru i njegov tim, koji su napravili nešto izvanredno. Nemoguće je razaznati na kojem je zubu rađeno; rezultat je besprijekoran.
Od srca preporučujem dr Mušuru i njegov tim svojoj familiji, prijateljima i svima kojima je potrebna vrhunska stomatološka njega. Njihova stručnost i umješnost zaista zaslužuju pohvalu.
S poštovanjem,
Selmina mama', 'Ова рецензија је давно требало да буде написана. У несрећној ситуацији када је моја кћерка тинејџерка сломила предњи зуб, имали смо срећу да нађемо стоматолога калибра др Мушуре. Након што сам видјела изузетан рад који је урадио на предњем зубу мог нећака, који је такође био сломљен, одмах сам одлучила да ће моја кћерка зуб поправити код др Мушуре.
Иако живимо у Чикагу, гдје су два различита стоматолога из наше мреже зубног осигурања прегледала моју кћерку за исти зуб, њихови покушаји да га поправе били су испод сваког нивоа. С обзиром на то, моја кћерка је одлетјела у Црну Гору посебно да посјети др Мушуру и његов тим, који су направили нешто изванредно. Немогуће је разазнати на којем је зубу рађено; резултат је беспријекоран.
Од срца препоручујем др Мушуру и његов тим својој фамилији, пријатељима и свима којима је потребна врхунска стоматолошка њега. Њихова стручност и умјешност заиста заслужују похвалу.
С поштовањем,
Селмина мама', 'This review has been long overdue. In an unfortunate situation where my teenage daughter broke her front tooth, we were fortunate to find a dentist of Dr. Mušura\'s caliber. After witnessing the exceptional work he had done on my nephew\'s front tooth, which was also broken, I immediately decided that my daughter would have her tooth fixed by Dr. Mušura.
Despite living in Chicago, where two different dentists saw my daughter within our dental insurance network for the same tooth, their attempts to fix it were subpar. In light of this, my daughter flew to Montenegro specifically to visit Dr. Mušura and his team, who performed an extraordinary feat. It\'s impossible to discern which tooth was worked on; the result is impeccable.
I wholeheartedly recommend Dr. Mušura and his team to all my family, friends, and anyone needing superb dental care. Their expertise and artistry are truly commendable.
Sincerely,
Selma’s mom', 'Этот отзыв нужно было написать давно. В неприятной ситуации, когда моя дочь-подросток сломала передний зуб, нам повезло найти стоматолога уровня доктора Мушуры. Увидев исключительную работу, которую он сделал на переднем зубе моего племянника, тоже сломанном, я сразу решила, что зуб дочери будет лечить доктор Мушура.
Хотя мы живём в Чикаго, где двое разных стоматологов из нашей сети стоматологического страхования осматривали дочь по поводу того же зуба, их попытки его восстановить были ниже всякого уровня. Поэтому дочь специально прилетела в Черногорию к доктору Мушуре и его команде, и они сделали нечто выдающееся. Невозможно определить, какой зуб восстанавливали; результат безупречный.
От всего сердца рекомендую доктора Мушуру и его команду всей своей семье, друзьям и всем, кому нужна первоклассная стоматологическая помощь. Их профессионализм и мастерство действительно достойны похвалы.
С уважением,
мама Сельмы', 'Diese Bewertung ist längst überfällig. In der unglücklichen Situation, dass meine Tochter im Teenageralter sich einen Schneidezahn abgebrochen hatte, hatten wir das Glück, einen Zahnarzt vom Kaliber Dr. Mušuras zu finden. Nachdem ich die außergewöhnliche Arbeit gesehen hatte, die er am ebenfalls abgebrochenen Schneidezahn meines Neffen geleistet hatte, entschied ich sofort, dass meine Tochter ihren Zahn bei Dr. Mušura richten lassen würde.
Obwohl wir in Chicago leben, wo zwei verschiedene Zahnärzte aus unserem Versicherungsnetz meine Tochter wegen desselben Zahns untersucht haben, waren ihre Versuche, ihn zu richten, unzureichend. Daher flog meine Tochter speziell nach Montenegro, um Dr. Mušura und sein Team zu besuchen, die etwas Außergewöhnliches vollbracht haben. Es ist unmöglich zu erkennen, an welchem Zahn gearbeitet wurde; das Ergebnis ist einwandfrei.
Ich empfehle Dr. Mušura und sein Team von Herzen meiner ganzen Familie, meinen Freunden und allen, die hervorragende Zahnbehandlung brauchen. Ihre Fachkompetenz und ihr Können sind wirklich lobenswert.
Mit freundlichen Grüßen,
Selmas Mutter', 'Bu yorumu çoktan yazmalıydım. Ergen kızımın ön dişini kırdığı o talihsiz durumda, Dr. Mušura kalibresinde bir diş hekimi bulacak kadar şanslıydık. Yeğenimin yine kırılmış olan ön dişinde yaptığı olağanüstü işi gördükten sonra, kızımın dişini Dr. Mušura\'nın yapmasına hemen karar verdim.
Chicago\'da yaşamamıza ve diş sigortası ağımızdaki iki farklı hekimin kızımı aynı diş için görmesine rağmen, dişi onarma girişimleri yetersiz kaldı. Bu nedenle kızım, özellikle Dr. Mušura ve ekibini görmek için Karadağ\'a uçtu ve onlar olağanüstü bir iş çıkardılar. Hangi dişe müdahale edildiğini ayırt etmek imkânsız; sonuç kusursuz.
Dr. Mušura ve ekibini tüm aileme, arkadaşlarıma ve üstün diş bakımına ihtiyaç duyan herkese gönülden tavsiye ediyorum. Uzmanlıkları ve sanatkârlıkları gerçekten takdire değer.
Saygılarımla,
Selma\'nın annesi',
    0, '2024-07-26 00:00:00'),

(@user_user_107286232325674158568, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNsbTctcExREAE',
    5, 'zh', '作为一个中国游客，我住在这里，牙齿开始发炎，我痛不欲生，从进去他们的诊所，得到很好服务和照顾，完美解决我的痛楚，手法很娴熟。专业的给出方案，合理的收费，我又可以继续我的旅行，真的非常感谢这么专业团队。',
    'Kao kineski turist koji je ovdje boravio, zub mi se zapalio i imao sam nepodnošljive bolove. Od trenutka kada sam ušao u njihovu ordinaciju, dobio sam veoma dobru uslugu i brigu; savršeno su riješili moje bolove, tehnika im je vrlo vješta. Profesionalno su predložili plan liječenja po razumnoj cijeni, i mogao sam nastaviti svoje putovanje. Zaista sam veoma zahvalan ovako profesionalnom timu.', 'Као кинески турист који је овдје боравио, зуб ми се запалио и имао сам неподношљиве болове. Од тренутка када сам ушао у њихову ординацију, добио сам веома добру услугу и бригу; савршено су ријешили моје болове, техника им је врло вјешта. Професионално су предложили план лијечења по разумној цијени, и могао сам наставити своје путовање. Заиста сам веома захвалан овако професионалном тиму.', 'As a Chinese tourist staying here, my tooth became inflamed and I was in unbearable pain. From the moment I walked into their clinic I received very good service and care; they resolved my pain perfectly, their technique is very skilled. They professionally proposed a treatment plan at a reasonable price, and I was able to continue my trip. I am truly very grateful to such a professional team.', 'Как китайский турист, живший здесь, я столкнулся с воспалением зуба и невыносимой болью. С момента, как я вошёл в их клинику, я получил очень хорошее обслуживание и заботу; они прекрасно избавили меня от боли, техника у них очень умелая. Профессионально предложили план лечения по разумной цене, и я смог продолжить путешествие. Искренне очень благодарен такой профессиональной команде.', 'Als chinesischer Tourist, der hier wohnte, entzündete sich mein Zahn und ich hatte unerträgliche Schmerzen. Von dem Moment an, als ich ihre Praxis betrat, erhielt ich sehr guten Service und gute Betreuung; sie haben meine Schmerzen perfekt beseitigt, ihre Technik ist sehr geschickt. Sie schlugen professionell einen Behandlungsplan zu einem angemessenen Preis vor, und ich konnte meine Reise fortsetzen. Ich bin diesem so professionellen Team wirklich sehr dankbar.', 'Burada konaklayan bir Çinli turist olarak dişim iltihaplandı ve dayanılmaz ağrılar çektim. Kliniklerine girdiğim andan itibaren çok iyi hizmet ve ilgi gördüm; ağrımı kusursuz bir şekilde giderdiler, teknikleri çok ustaca. Makul bir fiyata profesyonel bir tedavi planı sundular ve yolculuğuma devam edebildim. Bu kadar profesyonel bir ekibe gerçekten çok minnettarım.',
    0, '2024-07-26 00:00:00'),

(@user_cory_pidhaichuk, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNaZ2Zpc2ZnEAE',
    5, 'en', 'Great hours, great staff. Spoke english, and got us in right away.

Free consultation. Very professional, Highly Recommended if you are in Budva.',
    'Sjajno radno vrijeme, sjajno osoblje. Govorili su engleski i primili nas odmah.

Besplatna konsultacija. Veoma profesionalno, najtoplija preporuka ako ste u Budvi.', 'Сјајно радно вријеме, сјајно особље. Говорили су енглески и примили нас одмах.

Бесплатна консултација. Веома професионално, најтоплија препорука ако сте у Будви.', 'Great hours, great staff. Spoke english, and got us in right away.

Free consultation. Very professional, Highly Recommended if you are in Budva.', 'Отличные часы работы, отличный персонал. Говорили по-английски и приняли нас сразу.

Бесплатная консультация. Очень профессионально, настоятельно рекомендую, если вы в Будве.', 'Großartige Öffnungszeiten, großartiges Personal. Sie sprachen Englisch und nahmen uns sofort auf.

Kostenlose Beratung. Sehr professionell, sehr empfehlenswert, wenn Sie in Budva sind.', 'Harika çalışma saatleri, harika personel. İngilizce konuştular ve bizi hemen aldılar.

Ücretsiz konsültasyon. Çok profesyonel, Budva\'daysanız kesinlikle tavsiye ederim.',
    0, '2024-07-26 00:00:00'),

(@user_zeljka_mandic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSURwd2RlSlFBEAE',
    5, 'bs', 'Ljubazni doktori, sin i otac, pristupili drugarski mom sinu (5 godina). Primili su nas, iako nismo imali zakazan termin, kada smo prvi put dosli. Pozdrav od Rastka',
    'Ljubazni doktori, sin i otac, pristupili drugarski mom sinu (5 godina). Primili su nas, iako nismo imali zakazan termin, kada smo prvi put dosli. Pozdrav od Rastka', 'Љубазни доктори, син и отац, приступили другарски мом сину (5 година). Примили су нас, иако нисмо имали заказан термин, када смо први пут дошли. Поздрав од Растка', 'Kind doctors, son and father, took a friendly approach to my son (5 years old). They took us in even though we had no appointment, the first time we came. Greetings from Rastko', 'Любезные доктора, сын и отец, по-дружески отнеслись к моему сыну (5 лет). Приняли нас, хотя у нас не было записи, когда мы пришли в первый раз. Привет от Растко', 'Freundliche Ärzte, Sohn und Vater, gingen kameradschaftlich mit meinem Sohn (5 Jahre) um. Sie nahmen uns beim ersten Besuch auf, obwohl wir keinen Termin hatten. Grüße von Rastko', 'Nazik hekimler, oğul ve baba, 5 yaşındaki oğluma arkadaşça yaklaştılar. İlk gelişimizde randevumuz olmamasına rağmen bizi kabul ettiler. Rastko\'dan selamlar',
    0, '2024-07-26 00:00:00'),

(@user_predrag_mii, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwMWNfUHJBRRAB',
    5, 'de', 'Hervorragende Praxis. Ich war mit einer entzündeten Zahnwurzel in die Praxis gekommen. Man hat mir sofort geholfen und ich habe die Praxis schmerzfrei wieder verlassen. Sie arbeiten sehr professionel. Mir wurde jeder Arbeitsschritt ausführlich erklärt.',
    'Izvanredna ordinacija. Došao sam u ordinaciju sa upaljenim korijenom zuba. Odmah su mi pomogli i ordinaciju sam napustio bez bolova. Rade veoma profesionalno. Svaki korak rada mi je detaljno objašnjen.', 'Изванредна ординација. Дошао сам у ординацију са упаљеним коријеном зуба. Одмах су ми помогли и ординацију сам напустио без болова. Раде веома професионално. Сваки корак рада ми је детаљно објашњен.', 'An outstanding practice. I came in with an inflamed tooth root. They helped me immediately and I left the practice pain-free. They work very professionally. Every step of the treatment was explained to me in detail.', 'Превосходная клиника. Я пришёл с воспалённым корнем зуба. Мне сразу помогли, и я вышел из клиники без боли. Работают очень профессионально. Каждый этап работы мне подробно объяснили.', 'Hervorragende Praxis. Ich war mit einer entzündeten Zahnwurzel in die Praxis gekommen. Man hat mir sofort geholfen und ich habe die Praxis schmerzfrei wieder verlassen. Sie arbeiten sehr professionel. Mir wurde jeder Arbeitsschritt ausführlich erklärt.', 'Mükemmel bir klinik. İltihaplı bir diş köküyle gittim. Bana hemen yardım ettiler ve klinikten ağrısız çıktım. Çok profesyonel çalışıyorlar. İşin her adımı bana ayrıntılı olarak açıklandı.',
    0, '2024-07-26 00:00:00'),

(@user_julian, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNKa2ZTS0NBEAE',
    5, 'en', 'The founder of the dental dynasty Musura was the first dentist in Budva.  Now his son, grandson and granddaughter work here.  Excellent professionals who value their well-deserved reputation.  And we were very pleased with the customer service, thank you.',
    'Osnivač stomatološke dinastije Mušura bio je prvi zubar u Budvi. Danas ovdje rade njegov sin, unuk i unuka. Odlični profesionalci koji cijene svoju zasluženu reputaciju. A i uslugom smo bili veoma zadovoljni, hvala vam.', 'Оснивач стоматолошке династије Мушура био је први зубар у Будви. Данас овдје раде његов син, унук и унука. Одлични професионалци који цијене своју заслужену репутацију. А и услугом смо били веома задовољни, хвала вам.', 'The founder of the dental dynasty Musura was the first dentist in Budva.  Now his son, grandson and granddaughter work here.  Excellent professionals who value their well-deserved reputation.  And we were very pleased with the customer service, thank you.', 'Основатель стоматологической династии Мушура был первым зубным врачом в Будве. Сейчас здесь работают его сын, внук и внучка. Отличные профессионалы, которые дорожат своей заслуженной репутацией. И обслуживанием мы были очень довольны, спасибо.', 'Der Begründer der Zahnarztdynastie Mušura war der erste Zahnarzt in Budva. Heute arbeiten hier sein Sohn, sein Enkel und seine Enkelin. Ausgezeichnete Fachleute, die ihren wohlverdienten Ruf zu schätzen wissen. Und auch mit dem Service waren wir sehr zufrieden, vielen Dank.', 'Mušura diş hekimliği hanedanının kurucusu, Budva\'nın ilk diş hekimiydi. Bugün burada oğlu, erkek torunu ve kız torunu çalışıyor. Hak ettikleri itibara değer veren mükemmel profesyoneller. Hizmetten de çok memnun kaldık, teşekkür ederiz.',
    0, '2023-07-26 00:00:00'),

(@user_petar_dimitrijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4c2EtVmlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-07-26 00:00:00'),

(@user_nikola_musura, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4eUxhZVFREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-07-26 00:00:00'),

(@user_r_f, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUMtdTh1QVdBEAE',
    1, 'hr', 'Katastrofa Ne idite kod njih preko 100e sam dao za zub svako 10 dana ispane plomba 3 x mjesecno te ovo te ono uzas zivi ,zena radila ista stvar jedino sto znaju tamo je  da sve debelo naplate a da urade nemaju pojma',
    'Katastrofa Ne idite kod njih preko 100e sam dao za zub svako 10 dana ispane plomba 3 x mjesecno te ovo te ono uzas zivi ,zena radila ista stvar jedino sto znaju tamo je  da sve debelo naplate a da urade nemaju pojma', 'Катастрофа. Не идите код њих. Преко 100 евра сам дао за зуб, свако 10 дана испане пломба, 3 пута мјесечно те ово те оно, ужас живи. Жена радила иста ствар. Једино што знају тамо је да све дебело наплате, а да ураде немају појма', 'A disaster. Don\'t go to them. I paid over €100 for one tooth, the filling falls out every 10 days, three times a month it\'s one thing after another, an absolute nightmare. My wife had the same thing. The only thing they know there is how to charge a hefty price — they have no idea how to do the work', 'Катастрофа. Не ходите к ним. Больше 100 евро отдал за зуб, каждые 10 дней пломба выпадает, три раза в месяц то одно, то другое — сущий ужас. У жены то же самое. Единственное, что там умеют, — брать втридорога, а работать не имеют понятия', 'Eine Katastrophe. Geht nicht zu ihnen. Über 100 Euro habe ich für einen Zahn bezahlt, alle 10 Tage fällt die Füllung heraus, dreimal im Monat mal das eine, mal das andere, der reine Horror. Meiner Frau ging es genauso. Das Einzige, was sie dort können, ist ordentlich abrechnen — von der Arbeit haben sie keine Ahnung', 'Tam bir felaket. Onlara gitmeyin. Bir diş için 100 avrodan fazla ödedim, her 10 günde bir dolgu düşüyor, ayda üç kez bir o bir bu, tam bir kâbus. Eşimin de aynısı oldu. Orada bildikleri tek şey fahiş ücret almak — işi yapmaktan hiç anlamıyorlar',
    0, '2023-07-26 00:00:00'),

(@user_anuska_pesic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNlZ19xZ0ZREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-07-26 00:00:00'),

(@user_maja_spremo, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1bmUzVXNBRRAB',
    5, 'hr', 'Sve pohvale Ljubazno Osoblje i Doktorica.Bili smo kao Turisti rade i Subotom.Ordinacija super opremljena.',
    'Sve pohvale Ljubazno Osoblje i Doktorica.Bili smo kao Turisti rade i Subotom.Ordinacija super opremljena.', 'Све похвале, љубазно особље и докторица. Били смо као туристи, раде и субботом. Ординација супер опремљена.', 'All praise, kind staff and the lady doctor. We were there as tourists, they work on Saturdays too. The practice is very well equipped.', 'Все похвалы, любезный персонал и докторша. Мы были как туристы, работают и по субботам. Кабинет прекрасно оснащён.', 'Alles Lob, freundliches Personal und die Ärztin. Wir waren als Touristen dort, sie arbeiten auch samstags. Die Praxis ist super ausgestattet.', 'Her türlü övgü, nazik personel ve hanım hekim. Turist olarak gittik, cumartesi günleri de çalışıyorlar. Klinik çok iyi donatılmış.',
    0, '2023-07-26 00:00:00'),

(@user_sera_n, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1dkxfM3NnRRAB',
    5, 'de', 'wunderbare Zahnärztin. Ich war davor bei einem anderen Zahnarzt , er hat sich alles kurz angeschaut und nix gemacht. Sie hat mich gleich behandelt, obwohl ich kein Termin hatte. Ich war im Urlaub in Budva,  wurde jedoch wie eine Stammkundin behandelt. Nur zu empfehlen,  Dankeschön für alles. Liebe Grüße aus Deutschland',
    'Divna stomatologinja. Prije toga sam bio kod drugog stomatologa, on je sve kratko pogledao i ništa nije uradio. Ona me je odmah primila na tretman, iako nisam imao zakazan termin. Bio sam na odmoru u Budvi, a ophodili su se prema meni kao prema stalnoj pacijentkinji. Samo za preporuku, hvala vam za sve. Srdačan pozdrav iz Njemačke', 'Дивна стоматологиња. Прије тога сам био код другог стоматолога, он је све кратко погледао и ништа није урадио. Она ме је одмах примила на третман, иако нисам имао заказан термин. Био сам на одмору у Будви, а опходили су се према мени као према сталној пацијенткињи. Само за препоруку, хвала вам за све. Срдачан поздрав из Њемачке', 'A wonderful dentist. Before that I had been to another dentist, who took a quick look at everything and did nothing. She treated me right away, even though I had no appointment. I was on holiday in Budva, yet I was treated like a regular patient. Only to be recommended, thank you for everything. Warm greetings from Germany', 'Замечательная врач-стоматолог. До этого я был у другого стоматолога, он коротко всё осмотрел и ничего не сделал. Она сразу взялась меня лечить, хотя записи у меня не было. Я был в отпуске в Будве, но обошлись со мной как с постоянной пациенткой. Только рекомендовать, спасибо за всё. Сердечный привет из Германии', 'wunderbare Zahnärztin. Ich war davor bei einem anderen Zahnarzt , er hat sich alles kurz angeschaut und nix gemacht. Sie hat mich gleich behandelt, obwohl ich kein Termin hatte. Ich war im Urlaub in Budva,  wurde jedoch wie eine Stammkundin behandelt. Nur zu empfehlen,  Dankeschön für alles. Liebe Grüße aus Deutschland', 'Harika bir diş hekimi. Öncesinde başka bir diş hekimine gitmiştim, kısaca bakıp hiçbir şey yapmadı. O ise randevum olmamasına rağmen beni hemen tedaviye aldı. Budva\'da tatildeydim ama bana düzenli bir hasta gibi davrandılar. Sadece tavsiye edilir, her şey için teşekkürler. Almanya\'dan sevgiler',
    0, '2023-07-26 00:00:00'),

(@user_dragana_petkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUN1MWJxRmFREAE',
    1, 'bs', 'Krajnje razocarenje, za izvikanu ordinaciju. Pozvani su dan ranije radi zakazivanja pregleda. Medicinska sestra je rekla da se pregledi ne zakazuju i da dodjem u dogovorenom terminu. Nakon dolaska u ordinaciju govore kako imaju zakazane preglede unapred 15 dana I da ću čekati 40 min.
Krajnje neprovesionalno ponašanje osoblja sa dozom bezobrazluka, na moje iznošenje činjenica koje su gore navedene.
Izbegavati u širem krugu!!!!',
    'Krajnje razocarenje, za izvikanu ordinaciju. Pozvani su dan ranije radi zakazivanja pregleda. Medicinska sestra je rekla da se pregledi ne zakazuju i da dodjem u dogovorenom terminu. Nakon dolaska u ordinaciju govore kako imaju zakazane preglede unapred 15 dana I da ću čekati 40 min.
Krajnje neprovesionalno ponašanje osoblja sa dozom bezobrazluka, na moje iznošenje činjenica koje su gore navedene.
Izbegavati u širem krugu!!!!', 'Крајње разочарење, за извикану ординацију. Позвани су дан раније ради заказивања прегледа. Медицинска сестра је рекла да се прегледи не заказују и да дођем у договореном термину. Након доласка у ординацију говоре како имају заказане прегледе унапред 15 дана и да ћу чекати 40 минута.
Крајње непрофесионално понашање особља са дозом безобразлука, на моје изношење горе наведених чињеница.
Избјегавати у ширем кругу!!!!', 'Utter disappointment for a practice with such a reputation. I called the day before to book a check-up. The nurse said check-ups are not booked and that I should come at the agreed time. After arriving at the practice they tell me they have check-ups booked 15 days in advance and that I will be waiting 40 minutes.
Utterly unprofessional behaviour from the staff, with a dose of rudeness, when I pointed out the facts above.
Avoid by a wide margin!!!!', 'Полное разочарование — и это в кабинете с такой репутацией. Звонили за день, чтобы записаться на осмотр. Медсестра сказала, что на осмотры не записывают и чтобы я пришёл в согласованное время. После прихода в кабинет говорят, что осмотры у них записаны на 15 дней вперёд и что мне придётся ждать 40 минут.
Крайне непрофессиональное поведение персонала с долей хамства в ответ на изложение указанных выше фактов.
Обходить по широкой дуге!!!!', 'Eine völlige Enttäuschung für eine Praxis mit solchem Ruf. Ich hatte am Tag zuvor angerufen, um eine Untersuchung zu vereinbaren. Die Schwester sagte, Untersuchungen würden nicht terminiert und ich solle zur abgesprochenen Zeit kommen. Nach der Ankunft in der Praxis sagen sie, sie hätten Untersuchungen 15 Tage im Voraus vergeben und ich müsse 40 Minuten warten.
Höchst unprofessionelles Verhalten des Personals mit einer Portion Unverschämtheit, als ich die oben genannten Tatsachen vorbrachte.
Weiträumig meiden!!!!', 'Bu kadar itibarlı bir klinik için tam bir hayal kırıklığı. Muayene için randevu almak üzere bir gün önce aradık. Hemşire muayeneler için randevu verilmediğini ve kararlaştırılan saatte gelmemi söyledi. Kliniğe vardıktan sonra muayenelerin 15 gün öncesinden randevulu olduğunu ve 40 dakika bekleyeceğimi söylüyorlar.
Yukarıdaki gerçekleri dile getirdiğimde personelin son derece profesyonellikten uzak, bir dozda küstah davranışı.
Geniş bir daire çizip uzak durun!!!!',
    0, '2023-07-26 00:00:00'),

(@user_marija_trifunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUQ2aGJmQmxRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-07-26 00:00:00'),

(@user_rita, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSURhaW9UNjFBRRAB',
    5, 'ru', 'Большое спасибо за отзывчивость и уделённое внимание прекрасной девушке, которая помогла мне с эластиками  ❤️
Желаю клинике процветания!',
    'Veliko hvala za odzivnost i posvećenu pažnju prekrasnoj djevojci koja mi je pomogla sa elastikama ❤️
Želim ordinaciji da napreduje!', 'Велико хвала за одзивност и посвећену пажњу прекрасној дјевојци која ми је помогла са еластикама ❤️
Желим ординацији да напредује!', 'Many thanks for the responsiveness and the attention given by the lovely young woman who helped me with the elastics ❤️
I wish the clinic every success!', 'Большое спасибо за отзывчивость и уделённое внимание прекрасной девушке, которая помогла мне с эластиками  ❤️
Желаю клинике процветания!', 'Vielen Dank für die Hilfsbereitschaft und die Aufmerksamkeit der wunderbaren jungen Frau, die mir mit den Gummizügen geholfen hat ❤️
Ich wünsche der Praxis viel Erfolg!', 'Elastiklerle bana yardım eden o harika genç kadının duyarlılığı ve gösterdiği ilgi için çok teşekkürler ❤️
Kliniğe bol kazanç dilerim!',
    0, '2022-07-26 00:00:00'),

(@user_dejan_stanisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNpZzRuMWhBRRAB',
    5, 'hr', 'Sve pohvale za ljubaznost I profesionalnost.',
    'Sve pohvale za ljubaznost I profesionalnost.', 'Све похвале за љубазност и професионалност.', 'All praise for the kindness and professionalism.', 'Все похвалы за любезность и профессионализм.', 'Alles Lob für die Freundlichkeit und Professionalität.', 'Nezaket ve profesyonellik için her türlü övgü.',
    0, '2021-07-26 00:00:00'),

(@user_jelena_matijas, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNDaTlPb1B3EAE',
    5, 'en', 'Very pleased with service and quality of dental work I received recently as well as more than 20 years ago. I had some fillings done here years ago before moving to the UK and those have lasted very well. Over the past year and last month (Covid interfered), I decided to change some old fillings and crowns. They were flexible taking into account that I am only in Montenegro for a limited amount of time but it never felt rushed and it was only when I was totally satisfied with the look of my new crowns that they were fixed. Three different dentists in the practice were involved and I felt comfortable with all of them. An honest recommendation to all and many thanks to the practice. Brilliant work and quality at the fraction of cost of UK prices.',
    'Veoma sam zadovoljna uslugom i kvalitetom stomatološkog rada koji sam nedavno dobila, kao i onog od prije više od 20 godina. Ovdje su mi davno ugrađene neke plombe, prije nego što sam se preselila u Veliku Britaniju, i one su odlično potrajale. Tokom prošle godine i prošlog mjeseca (COVID je omeo planove) odlučila sam da zamijenim neke stare plombe i krunice. Bili su fleksibilni s obzirom na to da sam u Crnoj Gori samo ograničeno vrijeme, ali se nikada nije osjetila žurba i krunice su fiksirane tek kada sam bila potpuno zadovoljna njihovim izgledom. Bila su uključena tri različita stomatologa iz ordinacije i uz sve sam se osjećala prijatno. Iskrena preporuka svima i mnogo hvala ordinaciji. Sjajan rad i kvalitet za djelić cijene u Velikoj Britaniji.', 'Веома сам задовољна услугом и квалитетом стоматолошког рада који сам недавно добила, као и оног од прије више од 20 година. Овдје су ми давно уграђене неке пломбе, прије него што сам се преселила у Велику Британију, и оне су одлично потрајале. Током прошле године и прошлог мјесеца (COVID је омео планове) одлучила сам да замијеним неке старе пломбе и крунице. Били су флексибилни с обзиром на то да сам у Црној Гори само ограничено вријеме, али се никада није осјетила журба и крунице су фиксиране тек када сам била потпуно задовољна њиховим изгледом. Била су укључена три различита стоматолога из ординације и уз све сам се осјећала пријатно. Искрена препорука свима и много хвала ординацији. Сјајан рад и квалитет за дјелић цијене у Великој Британији.', 'Very pleased with service and quality of dental work I received recently as well as more than 20 years ago. I had some fillings done here years ago before moving to the UK and those have lasted very well. Over the past year and last month (Covid interfered), I decided to change some old fillings and crowns. They were flexible taking into account that I am only in Montenegro for a limited amount of time but it never felt rushed and it was only when I was totally satisfied with the look of my new crowns that they were fixed. Three different dentists in the practice were involved and I felt comfortable with all of them. An honest recommendation to all and many thanks to the practice. Brilliant work and quality at the fraction of cost of UK prices.', 'Я очень довольна обслуживанием и качеством стоматологической работы, которую получила недавно, а также той, что была сделана более 20 лет назад. Здесь мне давно поставили несколько пломб, ещё до переезда в Великобританию, и они прекрасно продержались. За прошедший год и в прошлом месяце (COVID спутал планы) я решила заменить несколько старых пломб и коронок. Они шли навстречу, учитывая, что в Черногории я лишь ограниченное время, но спешки никогда не ощущалось, и коронки зафиксировали только тогда, когда я была полностью довольна их видом. В работе участвовали три разных стоматолога клиники, и со всеми мне было комфортно. Искренняя рекомендация всем и большое спасибо клинике. Блестящая работа и качество за малую долю британских цен.', 'Ich bin mit dem Service und der Qualität der zahnärztlichen Arbeit, die ich kürzlich erhalten habe, sehr zufrieden — ebenso wie mit jener von vor über 20 Jahren. Hier wurden mir vor langer Zeit einige Füllungen gemacht, bevor ich nach Großbritannien zog, und diese haben sehr gut gehalten. Im vergangenen Jahr und im letzten Monat (Covid kam dazwischen) beschloss ich, einige alte Füllungen und Kronen zu ersetzen. Sie waren flexibel, da ich nur begrenzte Zeit in Montenegro bin, doch es fühlte sich nie gehetzt an, und die Kronen wurden erst befestigt, als ich mit ihrem Aussehen völlig zufrieden war. Drei verschiedene Zahnärzte der Praxis waren beteiligt, und bei allen fühlte ich mich wohl. Eine aufrichtige Empfehlung an alle und vielen Dank an die Praxis. Hervorragende Arbeit und Qualität zu einem Bruchteil der britischen Preise.', 'Hem son dönemde aldığım hem de 20 yıldan fazla süre önceki diş tedavisinin hizmetinden ve kalitesinden çok memnunum. Birleşik Krallık\'a taşınmadan önce burada bana bazı dolgular yapılmıştı ve bunlar çok iyi dayandı. Geçen yıl ve geçen ay boyunca (Covid araya girdi) bazı eski dolgu ve kronları değiştirmeye karar verdim. Karadağ\'da yalnızca sınırlı bir süre bulunduğumu göz önünde bulundurarak esnek davrandılar, ama hiçbir zaman acele ettirilmiş gibi hissetmedim ve kronlar ancak görünümlerinden tamamen memnun kaldığımda sabitlendi. Klinikten üç farklı diş hekimi işin içindeydi ve hepsiyle rahat hissettim. Herkese içten tavsiyem ve kliniğe çok teşekkürler. Birleşik Krallık fiyatlarının çok altında muhteşem bir iş ve kalite.',
    0, '2021-07-26 00:00:00'),

(@user_krsto_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNDOGRDaXNnRRAB',
    5, 'bs', 'Higijena na visokom nivou, stručnost, ljubaznost, posvećenost, iskustvo,... Kvalitet! 👏 …',
    'Higijena na visokom nivou, stručnost, ljubaznost, posvećenost, iskustvo,... Kvalitet! 👏 …', 'Хигијена на високом нивоу, стручност, љубазност, посвећеност, искуство... Квалитет! 👏', 'Hygiene at a high level, expertise, kindness, dedication, experience... Quality! 👏', 'Гигиена на высоком уровне, профессионализм, любезность, отдача, опыт... Качество! 👏', 'Hygiene auf hohem Niveau, Fachkompetenz, Freundlichkeit, Hingabe, Erfahrung... Qualität! 👏', 'Yüksek düzeyde hijyen, uzmanlık, nezaket, özveri, deneyim... Kalite! 👏',
    0, '2021-07-26 00:00:00'),

(@user_ivana_vujovic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUM4NHR1N0tnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-07-26 00:00:00'),

(@user_milutin_pavievi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjbjhiTk9nEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-07-26 00:00:00'),

(@user_jrgen_andr, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNjdDczTS1RRRAB',
    1, 'en', 'I got back a patient from this colleague. Never seen such a bad quality of dental work. He did 33-37 and 45-47. The fixation 46 47 was done with half of the filling and now a lot of waster underneath the crowns. Nothing fitted to the brim, nor occlusion (off 2-3 mm) - the patient has to bite on the frontal teeth and now gots problems with incisors.
Take that colleague the permission to work away or send him to master classes to learn at minimum level what is dentistry.
I get angry if I see what he is doing. He did and does not understood nothing from at least prosthetics.',
    'Dobio sam natrag pacijenta od ovog kolege. Nikada nisam vidio tako lošu kvalitetu stomatološkog rada. Radio je 33-37 i 45-47. Fiksacija 46 i 47 urađena je s pola ispuna, a sada je ispod krunica mnogo nečistoće. Ništa nije prilijegalo do ruba, kao ni okluzija (odstupanje 2-3 mm) — pacijent mora da zagriza na prednjim zubima i sada ima problema sa sjekutićima. Tom kolegi treba oduzeti dozvolu za rad ili ga poslati na majstorske kurseve da nauči minimum onoga što je stomatologija. Naljutim se kad vidim šta radi. Nije razumio i ne razumije ništa barem od protetike.', 'Добио сам натраг пацијента од овог колеге. Никада нисам видио тако лошу квалитету стоматолошког рада. Радио је 33-37 и 45-47. Фиксација 46 и 47 урађена је с пола испуна, а сада је испод круница много нечистоће. Ништа није прилијегало до руба, као ни оклузија (одступање 2-3 mm) — пацијент мора да загриза на предњим зубима и сада има проблема са сјекутићима. Том колеги треба одузети дозволу за рад или га послати на мајсторске курсеве да научи минимум онога што је стоматологија. Наљутим се кад видим шта ради. Није разумио и не разумије ништа барем од протетике.', 'I got back a patient from this colleague. Never seen such a bad quality of dental work. He did 33-37 and 45-47. The fixation 46 47 was done with half of the filling and now a lot of waster underneath the crowns. Nothing fitted to the brim, nor occlusion (off 2-3 mm) - the patient has to bite on the frontal teeth and now gots problems with incisors.
Take that colleague the permission to work away or send him to master classes to learn at minimum level what is dentistry.
I get angry if I see what he is doing. He did and does not understood nothing from at least prosthetics.', 'Я получил обратно пациента от этого коллеги. Никогда не видел такого низкого качества стоматологической работы. Он делал 33-37 и 45-47. Фиксация 46 и 47 выполнена наполовину пломбой, и теперь под коронками масса загрязнений. Ничего не прилегало по краю, как и окклюзия (отклонение 2-3 мм) — пациент вынужден смыкать на передних зубах и теперь имеет проблемы с резцами. Этого коллегу нужно лишить права работать или отправить на мастер-классы, чтобы он выучил хотя бы минимум того, что такое стоматология. Меня злит, когда я вижу, что он делает. Он не понимал и не понимает ничего хотя бы в протезировании.', 'Ich habe einen Patienten von diesem Kollegen zurückerhalten. Ich habe nie eine so schlechte Qualität zahnärztlicher Arbeit gesehen. Er hat 33-37 und 45-47 gemacht. Die Befestigung von 46 und 47 wurde mit der Hälfte der Füllung ausgeführt, und nun ist unter den Kronen viel Verunreinigung. Nichts saß randdicht, auch die Okklusion nicht (Abweichung 2-3 mm) — der Patient muss auf den Frontzähnen beißen und hat nun Probleme mit den Schneidezähnen. Diesem Kollegen sollte man die Berufserlaubnis entziehen oder ihn zu Meisterkursen schicken, damit er zumindest das Minimum davon lernt, was Zahnmedizin ist. Es macht mich wütend, wenn ich sehe, was er tut. Er hat zumindest von Prothetik nichts verstanden und versteht nichts.', 'Bu meslektaştan bir hastayı geri aldım. Hiç bu kadar kötü kalitede bir diş işi görmedim. 33-37 ve 45-47 yaptı. 46 ve 47\'nin sabitlemesi dolgunun yarısıyla yapılmış ve şimdi kronların altında bir sürü kirlilik var. Hiçbiri kenara tam oturmamış, okluzyon da öyle (2-3 mm sapma) — hasta ön dişleriyle kapatmak zorunda ve şimdi kesici dişlerinde sorun yaşıyor. Bu meslektaşın çalışma iznini almalı ya da diş hekimliğinin en azından ne olduğunu öğrenmesi için onu ustalık kurslarına göndermeli. Yaptığını görünce sinirleniyorum. En azından protezden hiçbir şey anlamamış ve anlamıyor.',
    0, '2020-07-26 00:00:00'),

(@user_mitar, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNzNTlEeHR3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-07-26 00:00:00'),

(@user_emir_maljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSURVbU83YWNBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-07-26 00:00:00'),

(@user_tijana_mugosa, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNVNUxMall3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-07-26 00:00:00'),

(@user_kristina_mandic, @clinic_id, @doctor_dragana_bjelica, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNVNklueFRREAE',
    1, 'bs', 'Ne znam za ostale, ali moj savet je da u sirokom luku
izbegavate "zubarku" Draganu ukoliko vam treba zubar za mladje dete (u ovom slucaju devojcica od 5 godina). Zbog pretrpanog rasporeda i skorasnjeg odlaska na odmor gorepomenuta je detetu koje se rasplakalo, pocela da vice da prekine i pozvala sestru da joj drzi glavu. Zbog takvog pristupa devojcica ne dozvoljava ni jednom stomatologu da joj pridje. Tako da... Gospodja za izbegavanje!',
    'Ne znam za ostale, ali moj savet je da u sirokom luku
izbegavate "zubarku" Draganu ukoliko vam treba zubar za mladje dete (u ovom slucaju devojcica od 5 godina). Zbog pretrpanog rasporeda i skorasnjeg odlaska na odmor gorepomenuta je detetu koje se rasplakalo, pocela da vice da prekine i pozvala sestru da joj drzi glavu. Zbog takvog pristupa devojcica ne dozvoljava ni jednom stomatologu da joj pridje. Tako da... Gospodja za izbegavanje!', 'Не знам за остале, али мој савјет је да у широком луку избјегавате „зубарку“ Драгану уколико вам треба зубар за млађе дијете (у овом случају дјевојчица од 5 година). Због претрпаног распореда и скорашњег одласка на одмор горепоменута је дјетету које се расплакало почела да виче да прекине и позвала сестру да јој држи главу. Због таквог приступа дјевојчица не дозвољава ни једном стоматологу да јој приђе. Тако да... Госпођа за избјегавање!', 'I don\'t know about the others, but my advice is to steer well clear of "dentist" Dragana if you need a dentist for a younger child (in this case a 5-year-old girl). Because of an overloaded schedule and an upcoming holiday, the aforementioned started shouting at the child, who had burst into tears, to stop, and called the nurse to hold her head. Because of that approach the girl now won\'t let any dentist near her. So... A lady to be avoided!', 'Не знаю насчёт остальных, но мой совет — обходить по широкой дуге «зубного врача» Драгану, если вам нужен стоматолог для маленького ребёнка (в данном случае девочка 5 лет). Из-за перегруженного расписания и скорого отъезда в отпуск упомянутая начала кричать на расплакавшегося ребёнка, чтобы тот прекратил, и позвала медсестру держать ей голову. Из-за такого подхода девочка теперь не подпускает к себе ни одного стоматолога. Так что... Дама, которую стоит избегать!', 'Ich weiß nicht, wie es bei den anderen ist, aber mein Rat ist, die „Zahnärztin“ Dragana weiträumig zu meiden, wenn Sie einen Zahnarzt für ein kleineres Kind brauchen (in diesem Fall ein fünfjähriges Mädchen). Wegen eines überfüllten Terminplans und eines bevorstehenden Urlaubs fing die Genannte an, das in Tränen ausgebrochene Kind anzuschreien, es solle aufhören, und rief die Schwester, damit sie den Kopf festhält. Wegen dieses Umgangs lässt das Mädchen nun keinen Zahnarzt mehr an sich heran. Also... Eine Dame, die man meiden sollte!', 'Diğerlerini bilmiyorum ama tavsiyem, küçük bir çocuk için diş hekimine ihtiyacınız varsa (bu durumda 5 yaşında bir kız çocuğu) "diş hekimi" Dragana\'dan geniş bir daire çizerek uzak durmanız. Aşırı yoğun programı ve yaklaşan tatili nedeniyle söz konusu kişi, ağlamaya başlayan çocuğa susması için bağırmaya başladı ve başını tutması için hemşireyi çağırdı. Bu yaklaşım nedeniyle kız artık hiçbir diş hekiminin kendisine yaklaşmasına izin vermiyor. Yani... Uzak durulması gereken bir hanım!',
    0, '2019-07-26 00:00:00'),

(@user_monika_rondovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNJMV96aWlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-07-26 00:00:00'),

(@user_nevena_panti, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNnLXBtUjR3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-07-26 00:00:00'),

(@user_marija_spalevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSURnc182Y25nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-07-26 00:00:00'),

(@user_martinovic_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSURBelAzdWtBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-07-26 00:00:00'),

(@user_vesna, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSURnd3BPVWRBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-07-26 00:00:00'),

(@user_eldar_sadykhov, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBd0lISEhBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2017-07-26 00:00:00'),

(@user_tamara_cumic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNBN00zS09REAE',
    1, 'bs', 'Ortodontkinja koja dolazi u ovu ordinaciju je kompletno nesposobna i neprofesionalna.
Savjet zaobidjite u sirokom luku.',
    'Ortodontkinja koja dolazi u ovu ordinaciju je kompletno nesposobna i neprofesionalna.
Savjet zaobidjite u sirokom luku.', 'Ортодонткиња која долази у ову ординацију је комплетно неспособна и непрофесионална.
Савјет: заобиђите у широком луку.', 'The orthodontist who comes to this practice is completely incompetent and unprofessional.
Advice: steer well clear.', 'Ортодонт, которая приезжает в этот кабинет, совершенно некомпетентна и непрофессиональна.
Совет: обходите по широкой дуге.', 'Die Kieferorthopädin, die in diese Praxis kommt, ist völlig unfähig und unprofessionell.
Rat: weiträumig meiden.', 'Bu kliniğe gelen ortodontist tamamen yetersiz ve profesyonellikten uzak.
Tavsiye: geniş bir daire çizip uzak durun.',
    0, '2017-07-26 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kMU1FcGpXalpNWm1SQ1ZGa3RURk5EWWpoWU0zYxAB'),
  'clinic', @clinic_id,
  'Dear Nika,

Thank you for taking the time to leave a review and share your experience. We are truly sorry to hear that you were not satisfied with the service at our clinic, and we sincerely apologize for any discomfort and disappointment you have felt, especially from dentist.

We would like to emphasize that hygiene and patient safety are our top priorities. Hand disinfection is mandatory upon entering the treatment room. 
Regarding the orthodontic elastics, we strictly separate them using two clearly marked containers, one exclusively for unused elastics and the other for those that have already been used. This system ensures that a patient can never receive an elastic that has been previously touched or used.

Once again, we appreciate your feedback and hope we will have the opportunity to improve your impression of our clinic in the future.

Kind regards,
Dental Musura', 'en',
  'Draga Nika,

Hvala Vam što ste odvojili vrijeme da napišete recenziju i podijelite svoje iskustvo. Zaista nam je žao što niste bili zadovoljni uslugom u našoj ordinaciji i iskreno se izvinjavamo za svaku nelagodu i razočarenje koje ste osjetili, posebno od strane stomatologa.

Željeli bismo da istaknemo da su higijena i bezbjednost pacijenata naši najveći prioriteti. Dezinfekcija ruku je obavezna pri ulasku u ordinaciju.
Što se tiče ortodontskih elastika, strogo ih razdvajamo u dvije jasno označene posude — jednu isključivo za neupotrijebljene elastike, a drugu za one koje su već korišćene. Ovaj sistem obezbjeđuje da pacijent nikada ne može dobiti elastiku koja je prethodno dirana ili upotrijebljena.

Još jednom, cijenimo Vašu povratnu informaciju i nadamo se da ćemo u budućnosti imati priliku da poboljšamo Vaš doživljaj naše ordinacije.

S poštovanjem,
Dental Musura', 'Драга Ника,

Хвала Вам што сте одвојили вријеме да напишете рецензију и подијелите своје искуство. Заиста нам је жао што нисте били задовољни услугом у нашој ординацији и искрено се извињавамо за сваку нелагоду и разочарење које сте осјетили, посебно од стране стоматолога.

Жељели бисмо да истакнемо да су хигијена и безбједност пацијената наши највећи приоритети. Дезинфекција руку је обавезна при уласку у ординацију.
Што се тиче ортодонтских еластика, строго их раздвајамо у двије јасно означене посуде — једну искључиво за неупотријебљене еластике, а другу за оне које су већ коришћене. Овај систем обезбјеђује да пацијент никада не може добити еластику која је претходно дирана или употријебљена.

Још једном, цијенимо Вашу повратну информацију и надамо се да ћемо у будућности имати прилику да побољшамо Ваш доживљај наше ординације.

С поштовањем,
Dental Musura', 'Dear Nika,

Thank you for taking the time to leave a review and share your experience. We are truly sorry to hear that you were not satisfied with the service at our clinic, and we sincerely apologize for any discomfort and disappointment you have felt, especially from dentist.

We would like to emphasize that hygiene and patient safety are our top priorities. Hand disinfection is mandatory upon entering the treatment room. 
Regarding the orthodontic elastics, we strictly separate them using two clearly marked containers, one exclusively for unused elastics and the other for those that have already been used. This system ensures that a patient can never receive an elastic that has been previously touched or used.

Once again, we appreciate your feedback and hope we will have the opportunity to improve your impression of our clinic in the future.

Kind regards,
Dental Musura', 'Дорогая Ника,

Спасибо, что нашли время написать отзыв и поделиться своим опытом. Нам искренне жаль, что вы остались недовольны обслуживанием в нашей клинике, и мы приносим искренние извинения за любой дискомфорт и разочарование, которые вы испытали, особенно со стороны врача.

Хотим подчеркнуть, что гигиена и безопасность пациентов — наши главные приоритеты. Дезинфекция рук обязательна при входе в кабинет.
Что касается ортодонтических эластиков, мы строго разделяем их в двух чётко маркированных контейнерах: один — исключительно для неиспользованных эластиков, другой — для уже использованных. Эта система гарантирует, что пациент никогда не получит эластик, к которому ранее прикасались или который уже использовался.

Ещё раз благодарим за обратную связь и надеемся, что в будущем у нас будет возможность улучшить ваше впечатление о нашей клинике.

С уважением,
Dental Musura', 'Liebe Nika,

vielen Dank, dass Sie sich die Zeit genommen haben, eine Bewertung zu schreiben und Ihre Erfahrung zu teilen. Es tut uns wirklich leid, dass Sie mit dem Service in unserer Praxis nicht zufrieden waren, und wir entschuldigen uns aufrichtig für jedes Unbehagen und jede Enttäuschung, die Sie empfunden haben, insbesondere seitens der Zahnärztin.

Wir möchten betonen, dass Hygiene und Patientensicherheit unsere höchsten Prioritäten sind. Die Händedesinfektion ist beim Betreten des Behandlungsraums verpflichtend.
Was die orthodontischen Gummizüge betrifft, trennen wir sie strikt in zwei deutlich gekennzeichneten Behältern: einer ausschließlich für unbenutzte Gummizüge, der andere für bereits verwendete. Dieses System stellt sicher, dass ein Patient niemals einen Gummizug erhalten kann, der zuvor berührt oder benutzt wurde.

Nochmals: Wir schätzen Ihr Feedback und hoffen, dass wir künftig die Gelegenheit haben, Ihren Eindruck von unserer Praxis zu verbessern.

Mit freundlichen Grüßen,
Dental Musura', 'Sayın Nika,

Bir değerlendirme yazmak ve deneyiminizi paylaşmak için zaman ayırdığınız için teşekkür ederiz. Kliniğimizdeki hizmetten memnun kalmadığınızı duymaktan gerçekten üzgünüz ve özellikle diş hekimi kaynaklı yaşadığınız her türlü rahatsızlık ve hayal kırıklığı için içtenlikle özür dileriz.

Hijyen ve hasta güvenliğinin en büyük önceliğimiz olduğunu vurgulamak isteriz. Muayene odasına girişte el dezenfeksiyonu zorunludur.
Ortodontik elastiklere gelince, bunları açıkça işaretlenmiş iki ayrı kapta kesin olarak ayırıyoruz: biri yalnızca kullanılmamış elastikler, diğeri ise kullanılmış olanlar için. Bu sistem, bir hastanın daha önce dokunulmuş veya kullanılmış bir elastiği asla alamayacağını güvence altına alır.

Geri bildiriminiz için tekrar teşekkür ederiz ve gelecekte kliniğimize dair izlenimlerinizi iyileştirme fırsatı bulacağımızı umuyoruz.

Saygılarımızla,
Dental Musura',
  'google_maps', '2025-07-26 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2LU5qM2d3RRAB'),
  'clinic', @clinic_id,
  'Hvala draga Nina na podijeljenom iskustvu i ovim riječima 🦷 …', 'bs',
  'Hvala draga Nina na podijeljenom iskustvu i ovim riječima 🦷 …', 'Хвала драга Нина на подијељеном искуству и овим ријечима 🦷', 'Thank you, dear Nina, for sharing your experience and for these words 🦷', 'Спасибо, дорогая Нина, за то, что поделились опытом, и за эти слова 🦷', 'Danke, liebe Nina, dass Sie Ihre Erfahrung und diese Worte mit uns geteilt haben 🦷', 'Deneyiminizi ve bu sözleri paylaştığınız için teşekkürler sevgili Nina 🦷',
  'google_maps', '2025-07-26 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUN2Mk1uQnZnRRAB'),
  'clinic', @clinic_id,
  'Hvala na povratnoj informaciji 🦷 …', 'bs',
  'Hvala na povratnoj informaciji 🦷 …', 'Хвала на повратној информацији 🦷', 'Thank you for your feedback 🦷', 'Спасибо за обратную связь 🦷', 'Danke für Ihr Feedback 🦷', 'Geri bildiriminiz için teşekkürler 🦷',
  'google_maps', '2025-07-26 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChdDSUhNMG9nS0VJQ0FnSUNOeE5LcDRnRRAB'),
  'clinic', @clinic_id,
  'Dear Merima,  

Thank you for feedback and review. 
Special thanks to your wonderful daughter who was very responsible and cooperative patient. 

These words are satisfaction for us but also an obligation to justify 
your trust and keep improving our services for better patient experience! 

Best regards from Budva,
Dental Musura team', 'en',
  'Draga Merima,

Hvala Vam na povratnoj informaciji i recenziji.
Posebno hvala Vašoj divnoj kćerki koja je bila veoma odgovorna pacijentkinja i spremna na saradnju.

Ove riječi su za nas zadovoljstvo, ali i obaveza da opravdamo Vaše povjerenje i da nastavimo da unapređujemo naše usluge za bolje iskustvo pacijenata!

Srdačan pozdrav iz Budve,
Dental Musura tim', 'Драга Мерима,

Хвала Вам на повратној информацији и рецензији.
Посебно хвала Вашој дивној кћерки која је била веома одговорна пацијенткиња и спремна на сарадњу.

Ове ријечи су за нас задовољство, али и обавеза да оправдамо Ваше повјерење и да настaвимо да унапређујемо наше услуге за боље искуство пацијената!

Срдачан поздрав из Будве,
Dental Musura тим', 'Dear Merima,  

Thank you for feedback and review. 
Special thanks to your wonderful daughter who was very responsible and cooperative patient. 

These words are satisfaction for us but also an obligation to justify 
your trust and keep improving our services for better patient experience! 

Best regards from Budva,
Dental Musura team', 'Дорогая Мерима,

Спасибо за обратную связь и отзыв.
Особая благодарность вашей замечательной дочери, которая была очень ответственной и готовой к сотрудничеству пациенткой.

Эти слова для нас — радость, но и обязательство оправдать ваше доверие и продолжать улучшать наши услуги ради лучшего опыта пациентов!

С сердечным приветом из Будвы,
команда Dental Musura', 'Liebe Merima,

vielen Dank für Ihr Feedback und Ihre Bewertung.
Besonderen Dank an Ihre wunderbare Tochter, die eine sehr verantwortungsvolle und kooperative Patientin war.

Diese Worte sind für uns eine Freude, aber auch eine Verpflichtung, Ihr Vertrauen zu rechtfertigen und unsere Leistungen für ein besseres Patientenerlebnis weiter zu verbessern!

Herzliche Grüße aus Budva,
Dental Musura Team', 'Sayın Merima,

Geri bildiriminiz ve değerlendirmeniz için teşekkür ederiz.
Çok sorumlu ve iş birliğine açık bir hasta olan harika kızınıza özellikle teşekkürler.

Bu sözler bizim için bir mutluluk, ama aynı zamanda güveninizi hak etmek ve daha iyi bir hasta deneyimi için hizmetlerimizi geliştirmeye devam etmek adına bir yükümlülük!

Budva\'dan sıcak selamlar,
Dental Musura ekibi',
  'google_maps', '2024-07-26 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUMtdTh1QVdBEAE'),
  'clinic', @clinic_id,
  'Poštovani, jako nam je žao što ste imali negativno iskustvo u našoj ordinaciji.
Tim smo koji veoma vodi računa o zdravlju i zadovoljstvu pacijenata te prihvatamo reklamacije i stojimo na raspolaganju da porazgovaramo i  nađemo rješenje za Vaš problem. 
Stomatološka ordinacija Mušura', 'bs',
  'Poštovani, jako nam je žao što ste imali negativno iskustvo u našoj ordinaciji.
Tim smo koji veoma vodi računa o zdravlju i zadovoljstvu pacijenata te prihvatamo reklamacije i stojimo na raspolaganju da porazgovaramo i  nađemo rješenje za Vaš problem. 
Stomatološka ordinacija Mušura', 'Поштовани, јако нам је жао што сте имали негативно искуство у нашој ординацији.
Тим смо који веома води рачуна о здрављу и задовољству пацијената те прихватамо рекламације и стојимо на располагању да поразговарамо и нађемо рјешење за Ваш проблем.
Стоматолошка ординација Мушура', 'Dear Sir/Madam, we are very sorry that you had a negative experience at our practice.
We are a team that cares a great deal about the health and satisfaction of our patients, we accept complaints and remain available to talk and find a solution to your problem.
Mušura Dental Practice', 'Уважаемый пациент, нам очень жаль, что у вас остался негативный опыт в нашей клинике.
Мы команда, которая очень заботится о здоровье и удовлетворённости пациентов, мы принимаем претензии и готовы поговорить и найти решение вашей проблемы.
Стоматологическая клиника Мушура', 'Sehr geehrte Damen und Herren, es tut uns sehr leid, dass Sie eine negative Erfahrung in unserer Praxis gemacht haben.
Wir sind ein Team, dem die Gesundheit und Zufriedenheit der Patienten sehr am Herzen liegt; wir nehmen Beschwerden an und stehen zur Verfügung, um zu sprechen und eine Lösung für Ihr Problem zu finden.
Zahnarztpraxis Mušura', 'Sayın hastamız, kliniğimizde olumsuz bir deneyim yaşadığınız için çok üzgünüz.
Hastalarımızın sağlığına ve memnuniyetine büyük önem veren bir ekibiz; şikâyetleri kabul ediyor ve sorununuzu konuşup bir çözüm bulmak için hizmetinizde olmaya devam ediyoruz.
Mušura Diş Kliniği',
  'google_maps', '2023-07-26 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNDaTlPb1B3EAE'),
  'clinic', @clinic_id,
  'Thank you Jelena for your review!
It is our pleasure to have you as patient.
Our team is sending you all warm greetings from Budva.
See you next summer,
Musura team.', 'en',
  'Hvala Vam, Jelena, na recenziji!
Zadovoljstvo nam je što ste naša pacijentkinja.
Naš tim Vam šalje najtoplije pozdrave iz Budve.
Do sljedećeg ljeta,
Musura tim.', 'Хвала Вам, Јелена, на рецензији!
Задовољство нам је што сте наша пацијенткиња.
Наш тим Вам шаље најтоплије поздраве из Будве.
До сљедећег љета,
Musura тим.', 'Thank you Jelena for your review!
It is our pleasure to have you as patient.
Our team is sending you all warm greetings from Budva.
See you next summer,
Musura team.', 'Спасибо вам, Елена, за отзыв!
Для нас радость, что вы наша пациентка.
Наша команда передаёт вам самые тёплые приветы из Будвы.
До следующего лета,
команда Musura.', 'Vielen Dank, Jelena, für Ihre Bewertung!
Es ist uns eine Freude, Sie als Patientin zu haben.
Unser Team sendet Ihnen herzliche Grüße aus Budva.
Bis zum nächsten Sommer,
Musura Team.', 'Değerlendirmeniz için teşekkürler Jelena!
Sizi hastamız olarak görmek bizim için bir mutluluk.
Ekibimiz size Budva\'dan en sıcak selamlarını gönderiyor.
Gelecek yaza kadar,
Musura ekibi.',
  'google_maps', '2021-07-26 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ5_aQDJvUTRMREZMDTbIvs3k/reviews/ChZDSUhNMG9nS0VJQ0FnSUNVNklueFRREAE'),
  'clinic', @clinic_id,
  'Poštovana Kristina, osjećam potrebu da se u svoje lično ime obratim u vezi vašeg komentara. Zbog višegodišnje dobre reputacije ordinacije u kojoj sam zaposlena snosim odgovornost za Vašu izjavu. Ukoliko smatrate da je moja stručna intervencija bila razlog Vašeg nezadovoljstva, primite moje javno izvinjenje.
U svoje lično ime i u ime zadovoljnih pacijenata, dr stom. Dragana Bjelica.

U ime stomatološke ordinacije Mušura jako nam je žao što ste vi i Vaše dijete imali negativno iskustvo u našoj ordinaciji, zbog čega Vam se izvinjavamo. Veoma vodimo računa o svakom našem pacijentu, zbog čega Vas pozivamo da nas sa svojim djetetom posjetite kako bismo Vam se i uživo još jednom izvinili i razgovarali sa djetetom u cilju prevazilaženja negativnog iskustva i saradnje sa stomatolizima.
Srdačno,
Vaša stomatološka ordinacija Mušura', 'bs',
  'Poštovana Kristina, osjećam potrebu da se u svoje lično ime obratim u vezi vašeg komentara. Zbog višegodišnje dobre reputacije ordinacije u kojoj sam zaposlena snosim odgovornost za Vašu izjavu. Ukoliko smatrate da je moja stručna intervencija bila razlog Vašeg nezadovoljstva, primite moje javno izvinjenje.
U svoje lično ime i u ime zadovoljnih pacijenata, dr stom. Dragana Bjelica.

U ime stomatološke ordinacije Mušura jako nam je žao što ste vi i Vaše dijete imali negativno iskustvo u našoj ordinaciji, zbog čega Vam se izvinjavamo. Veoma vodimo računa o svakom našem pacijentu, zbog čega Vas pozivamo da nas sa svojim djetetom posjetite kako bismo Vam se i uživo još jednom izvinili i razgovarali sa djetetom u cilju prevazilaženja negativnog iskustva i saradnje sa stomatolizima.
Srdačno,
Vaša stomatološka ordinacija Mušura', 'Поштована Кристина, осјећам потребу да се у своје лично име обратим у вези Вашег коментара. Због вишегодишње добре репутације ординације у којој сам запослена сносим одговорност за Вашу изјаву. Уколико сматрате да је моја стручна интервенција била разлог Вашег незадовољства, примите моје јавно извињење.
У своје лично име и у име задовољних пацијената, др стом. Драгана Бјелица.

У име стоматолошке ординације Мушура јако нам је жао што сте Ви и Ваше дијете имали негативно искуство у нашој ординацији, због чега Вам се извињавамо. Веома водимо рачуна о сваком нашем пацијенту, због чега Вас позивамо да нас са својим дјететом посјетите како бисмо Вам се и уживо још једном извинили и разговарали са дјететом у циљу превазилажења негативног искуства и сарадње са стоматолозима.
Срдачно,
Ваша стоматолошка ординација Мушура', 'Dear Kristina, I feel the need to address your comment in my own name. Because of the many years of good reputation of the practice where I am employed, I bear responsibility for your statement. If you believe that my professional intervention was the reason for your dissatisfaction, please accept my public apology.
In my own name and on behalf of our satisfied patients, dr stom. Dragana Bjelica.

On behalf of the Mušura dental practice, we are very sorry that you and your child had a negative experience at our practice, for which we apologise. We care a great deal about every one of our patients, which is why we invite you to visit us with your child so that we can apologise once more in person and talk with the child in order to overcome the negative experience and restore cooperation with dentists.
Kind regards,
Your Mušura dental practice', 'Уважаемая Кристина, чувствую необходимость обратиться к вам от своего личного имени по поводу вашего комментария. Учитывая многолетнюю хорошую репутацию клиники, в которой я работаю, я несу ответственность за ваше заявление. Если вы считаете, что причиной вашего недовольства стало моё профессиональное вмешательство, примите мои публичные извинения.
От своего личного имени и от имени довольных пациентов, др стом. Драгана Бьелица.

От имени стоматологической клиники Мушура: нам очень жаль, что у вас и вашего ребёнка остался негативный опыт в нашей клинике, за что мы извиняемся. Мы очень внимательны к каждому нашему пациенту, поэтому приглашаем вас прийти к нам с ребёнком, чтобы мы могли извиниться ещё раз лично и поговорить с ребёнком, чтобы преодолеть негативный опыт и вернуть готовность сотрудничать со стоматологами.
Сердечно,
ваша стоматологическая клиника Мушура', 'Sehr geehrte Kristina, ich sehe mich veranlasst, im eigenen Namen auf Ihren Kommentar zu antworten. Wegen des langjährigen guten Rufs der Praxis, in der ich angestellt bin, trage ich Verantwortung für Ihre Aussage. Sollten Sie der Ansicht sein, dass mein fachlicher Eingriff der Grund für Ihre Unzufriedenheit war, nehmen Sie bitte meine öffentliche Entschuldigung an.
In meinem eigenen Namen und im Namen der zufriedenen Patienten, dr stom. Dragana Bjelica.

Im Namen der Zahnarztpraxis Mušura: Es tut uns sehr leid, dass Sie und Ihr Kind eine negative Erfahrung in unserer Praxis gemacht haben, wofür wir uns entschuldigen. Uns liegt jeder einzelne Patient sehr am Herzen, weshalb wir Sie einladen, uns mit Ihrem Kind zu besuchen, damit wir uns auch persönlich noch einmal entschuldigen und mit dem Kind sprechen können, um die negative Erfahrung zu überwinden und die Zusammenarbeit mit Zahnärzten wiederherzustellen.
Herzlichst,
Ihre Zahnarztpraxis Mušura', 'Sayın Kristina, yorumunuzla ilgili olarak kendi adıma size hitap etme ihtiyacı duyuyorum. Çalıştığım kliniğin uzun yıllara dayanan iyi itibarı nedeniyle beyanınızın sorumluluğunu taşıyorum. Memnuniyetsizliğinizin nedeninin benim mesleki müdahalem olduğunu düşünüyorsanız, lütfen açık özrümü kabul edin.
Kendi adıma ve memnun hastalarımız adına, dr stom. Dragana Bjelica.

Mušura diş kliniği adına, sizin ve çocuğunuzun kliniğimizde olumsuz bir deneyim yaşamış olmasından dolayı çok üzgünüz ve bunun için özür dileriz. Her bir hastamıza büyük özen gösteriyoruz; bu nedenle sizi çocuğunuzla birlikte bizi ziyaret etmeye davet ediyoruz; böylece yüz yüze bir kez daha özür dileyebilir ve olumsuz deneyimin aşılması ile diş hekimleriyle iş birliğinin yeniden kurulması için çocukla konuşabiliriz.
Saygılarımızla,
Mušura diş kliniğiniz',
  'google_maps', '2019-07-26 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
