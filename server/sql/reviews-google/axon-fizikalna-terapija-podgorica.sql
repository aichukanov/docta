-- Insert Google Maps reviews for Axon fizikalna terapija
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/axon-fizikalna-terapija-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'axon-fizikalna-terapija-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_srdjan_mijovic = (SELECT id FROM doctors WHERE slug = 'srdjan-mijovic');
SET @doctor_marko_mickovic = (SELECT id FROM doctors WHERE slug = 'marko-mickovic');
SET @doctor_djordje_barovic = (SELECT id FROM doctors WHERE slug = 'djordje-barovic');
SET @doctor_andrija_golubovic = (SELECT id FROM doctors WHERE slug = 'andrija-golubovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Enesa', 'https://lh3.googleusercontent.com/a/ACg8ocL4awO63GtronjVnpnpA5ENj2bkp_FCpJAXEEt9XrHOEr_d5Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114402048824757193876/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114402048824757193876/reviews');
SET @user_enesa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114402048824757193876/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Mucibabic', 'https://lh3.googleusercontent.com/a-/ALV-UjUGkAkH75PB_Ox_Fs1gRV-qjhTFEsWqnOzdpfoAWZwCRk_s6vDy=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/105896463469234995790/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105896463469234995790/reviews');
SET @user_jelena_mucibabic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105896463469234995790/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nik', 'https://lh3.googleusercontent.com/a-/ALV-UjVkxhimUgUe5GfHtGJklS-C-q3D_i6haXaeE40f2m7rZIREA1sd=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/107464699661379151817/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107464699661379151817/reviews');
SET @user_nik = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107464699661379151817/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olia', 'https://lh3.googleusercontent.com/a-/ALV-UjU93RmHR3g8XU-9NNOamDy8R7xGQi-2zXQSFqG_zmo0ppANwssN=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/107053218562211046414/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107053218562211046414/reviews');
SET @user_olia = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107053218562211046414/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag', 'https://lh3.googleusercontent.com/a-/ALV-UjXxolbPT8uceDjM6N4gdQM0VHMRRd-jmtpBVJXQWaJ2M2N60Qo=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/107063924701900275243/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107063924701900275243/reviews');
SET @user_predrag = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107063924701900275243/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina Markovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU838xggHgcmla_7jftZZIUJ4mZjeeOKA4PtwCmUPLoWG7DMyoT=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107023616841565349753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107023616841565349753/reviews');
SET @user_jasmina_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107023616841565349753/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Reglaza trapa Ivanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUNDa68DybSae6DJMWcQ7toeSDl_XLScjXSEh0QrDTJd1ZLwZ8=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105329914152382191040/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105329914152382191040/reviews');
SET @user_reglaza_trapa_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105329914152382191040/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maximus Emperor', 'https://lh3.googleusercontent.com/a-/ALV-UjW_M2BWD4mA-jjviJgJWSdGfphQQQvjP_oNhtR_a9QO5nFuyLI=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110628799100793877560/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110628799100793877560/reviews');
SET @user_maximus_emperor = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110628799100793877560/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anica Popović', 'https://lh3.googleusercontent.com/a/ACg8ocJBxIkaa5lJqqXiKaiJPDp3neWPwHeRk32AAshDhZVFQBYvzQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118143892513312943758/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118143892513312943758/reviews');
SET @user_anica_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118143892513312943758/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rada Popović', 'https://lh3.googleusercontent.com/a/ACg8ocK82gR0IUALXipFU66-HHiURo5FvJc_cWwWVs-aXLCMCevQkQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106496125340381274018/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106496125340381274018/reviews');
SET @user_rada_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106496125340381274018/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka glusica', 'https://lh3.googleusercontent.com/a/ACg8ocI6aI5etgyq36ZtAEfVZhNUO_mU0_RlcdZ_RLeM9hrRvWOa_A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102189596654235300118/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102189596654235300118/reviews');
SET @user_luka_glusica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102189596654235300118/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Glusica', 'https://lh3.googleusercontent.com/a/ACg8ocIxHlfugdp043Jo3AD6aVLIwOXQlIRclqdLmhQVi_gUUSpSlQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102599512995553180834/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102599512995553180834/reviews');
SET @user_dragan_glusica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102599512995553180834/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'andrija golubovic', 'https://lh3.googleusercontent.com/a/ACg8ocLQdt4-QMg0rP7w8KOLJOQo8qrIDUbfBVn23wMuyVS3YHg7SQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100450683789961372185/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100450683789961372185/reviews');
SET @user_andrija_golubovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100450683789961372185/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Poznanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLjNNjXVylrkk1cHU5IQ1K8UMwHV7WUipkTxjtYEFdok2ZHBw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114407553713245692921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114407553713245692921/reviews');
SET @user_milica_poznanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114407553713245692921/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jaksa Gosovic', 'https://lh3.googleusercontent.com/a/ACg8ocJnafW9ZFaoWCDvxREtvP0tjPVfkQwimcEbEzzBJU3dWvVRoQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110017330034205354076/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110017330034205354076/reviews');
SET @user_jaksa_gosovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110017330034205354076/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Dragicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWhAZrzv419EylUVjQ0c56GLOuWiUupJIhlAIvMiYhVPkLILvWVnA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111163764844097565451/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111163764844097565451/reviews');
SET @user_ivana_dragicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111163764844097565451/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Petar Mitrovic', 'https://lh3.googleusercontent.com/a/ACg8ocKvY5cGTiat15zlDd2rp15RxFOaWNevJGIWvlWVRzNt2xkmrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106316408252537825008/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106316408252537825008/reviews');
SET @user_petar_mitrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106316408252537825008/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Djordje Barovic', 'https://lh3.googleusercontent.com/a/ACg8ocIBVzS8pB-7rppIoJ4hr2aSVryLcdsYWULuG2QBouL_Dau0UA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115866151824230697691/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115866151824230697691/reviews');
SET @user_djordje_barovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115866151824230697691/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zoran Dragicevic', 'https://lh3.googleusercontent.com/a/ACg8ocI5yolu1ERJpSp8TogCerbggB2M0pAz1jak8rQyCkTqEsqyAA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111712435092885695135/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111712435092885695135/reviews');
SET @user_zoran_dragicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111712435092885695135/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bogdan Vukcevic BV COMPANY', 'https://lh3.googleusercontent.com/a/ACg8ocL8XYjmGdYTfdGCXWZJtB1v0EALTLqU1KtvDI4SBTRbPGAwZv4=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100055698881952607047/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100055698881952607047/reviews');
SET @user_bogdan_vukcevic_bv_company = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100055698881952607047/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Balsa Stojanovic', 'https://lh3.googleusercontent.com/a/ACg8ocJkN2gkritpL1LLSaYRhZHX0HL51YT90p3jRoazOZuFzx5N7w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103975242279873296174/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103975242279873296174/reviews');
SET @user_balsa_stojanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103975242279873296174/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gamze Coşkun', 'https://lh3.googleusercontent.com/a-/ALV-UjWI_IIW7BvBsHHdfmkmvhdukE9Tdp3lWlGysOgRFIvxIXx-dIIQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112218727440561943123/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112218727440561943123/reviews');
SET @user_gamze_cokun = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112218727440561943123/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Hakan Uzel', 'https://lh3.googleusercontent.com/a-/ALV-UjUTAwFChc17TY3r7XJvc3Wi6oow0oMDRPUfAXG4ZdEZFEQLO7-O=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110696127722982523362/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110696127722982523362/reviews');
SET @user_hakan_uzel = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110696127722982523362/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'LD', 'https://lh3.googleusercontent.com/a/ACg8ocKqv5-f1Sra2i3lEMCLJoTrLDSjg3Fk5030gTKVbC8Iw9QqkQAO=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115327389837138663721/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115327389837138663721/reviews');
SET @user_ld = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115327389837138663721/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vojislav Svicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWBqKTC7bHqb-n4lNcYlZnwI589l5WtD9cX88US4AyIsFEB6EHZ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113299077853495330881/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113299077853495330881/reviews');
SET @user_vojislav_svicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113299077853495330881/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubisa Dulovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWsFlk7E_22TJL0717xjulfpDIQQCh0gcntnQeQVe_lM2-OSu89=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103538019005403020618/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103538019005403020618/reviews');
SET @user_ljubisa_dulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103538019005403020618/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'MILICA BOSKOVIC', 'https://lh3.googleusercontent.com/a-/ALV-UjV_3KiW9ZbV6k-spVkk35fPNclcYWIkO0U_hoIPgmcYtY1EUanh=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112702204057552920012/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112702204057552920012/reviews');
SET @user_milica_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112702204057552920012/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dr Copy', 'https://lh3.googleusercontent.com/a-/ALV-UjWe4mhbMQ1lCojJjNq8NrV2Cu-zlwigIP01-1rJghJXM50o6J4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104214260787092652864/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104214260787092652864/reviews');
SET @user_dr_copy = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104214260787092652864/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alen Babačić', 'https://lh3.googleusercontent.com/a/ACg8ocKfMLvZeU1EwRBwmusormXPLnBcoHV5_COBd2RZBZFSJ8C6etQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114477476063367707167/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114477476063367707167/reviews');
SET @user_alen_babai = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114477476063367707167/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'dzenana Marić', 'https://lh3.googleusercontent.com/a/ACg8ocIRbUlTPfZMMR0CP0ctwUMAqXzaeNcFvSjpqsm5V2rAsi4N7A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110009401518197571936/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110009401518197571936/reviews');
SET @user_dzenana_mari = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110009401518197571936/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena G', 'https://lh3.googleusercontent.com/a-/ALV-UjV5zgG1rGrLg0dyQ5CpgHbL-1ZjoGlp0SdZRXV4c8GB24_MvlFDNA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118021898042796744698/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118021898042796744698/reviews');
SET @user_jelena_g = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118021898042796744698/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja Zindovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUCYciGqokEeBGn87zAlpGn9TgiuGv3oV5Mo7YkNBwQ_kVN2xTHSA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108544820574645528463/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108544820574645528463/reviews');
SET @user_nemanja_zindovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108544820574645528463/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Edvin Strujic', 'https://lh3.googleusercontent.com/a-/ALV-UjW_j6fGdy6EsMn0_KMomHx7NvVoHxNTofEf1Ij-rYuIKpHgVfJfpg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107767863023172095982/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107767863023172095982/reviews');
SET @user_edvin_strujic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107767863023172095982/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jana Vukadinovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWwzutDc3emiBYj1xec75yzgbPUw7s-WEzUh8k6JwTD00c12aeN0Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114614394716524959516/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114614394716524959516/reviews');
SET @user_jana_vukadinovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114614394716524959516/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slavica Carapic', 'https://lh3.googleusercontent.com/a-/ALV-UjWUdku31UESZQ3tUtshHN0kpUvEQMXQMd_dLKyI_loqOUnEJYcHJw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101840466286772186636/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101840466286772186636/reviews');
SET @user_slavica_carapic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101840466286772186636/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radovan Krsmanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXmvSmPxGSRh25eWesTNHCIpNJHbh4sbDzS_TqwIJKxuFvhntSAUA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102612486648169551720/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102612486648169551720/reviews');
SET @user_radovan_krsmanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102612486648169551720/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zaro Rackovic', 'https://lh3.googleusercontent.com/a/ACg8ocIzXwlFuHsrdoI_eJwHfnV7cNzA5rxjNCoFGm8eKjbDEcToZA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113222211636915961884/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113222211636915961884/reviews');
SET @user_zaro_rackovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113222211636915961884/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragan Bozovic', 'https://lh3.googleusercontent.com/a/ACg8ocKeLkguTJWL8SWYG7aDxKb5te4mQjIqZa2OtXRfxZvVZuAD-g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111855463710175305115/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111855463710175305115/reviews');
SET @user_dragan_bozovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111855463710175305115/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Redzo Mulić', 'https://lh3.googleusercontent.com/a/ACg8ocKaj3iLa1p3cGl8sdVQjiUnS0cX7TGfbhS2pVxbWMfDHCWHjA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113982680575088531026/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113982680575088531026/reviews');
SET @user_redzo_muli = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113982680575088531026/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Ivan', 'https://lh3.googleusercontent.com/a/ACg8ocKFQz9Z8RKkcO_OZhbfkhLcTgw5-gU0Sjd2ch2zjPPE5OEy8Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113297508772444417240/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113297508772444417240/reviews');
SET @user_ivan_ivan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113297508772444417240/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Bulatović', 'https://lh3.googleusercontent.com/a-/ALV-UjVUXlUshQB6FShfI6hmdPycmvFq7G7D_M5CbhhkHE-zjn79wJs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114339732466018235343/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114339732466018235343/reviews');
SET @user_sanja_bulatovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114339732466018235343/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Muratovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWDL5sYmJwu7hTcQiA-Sz0ISRlOmBSsM3pLFotkcUtKxzsGvTE=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105147964980572495746/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105147964980572495746/reviews');
SET @user_jovana_muratovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105147964980572495746/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Coa Fifa', 'https://lh3.googleusercontent.com/a-/ALV-UjXjO713TAE58GIHX3bIKjfeALGTo9WRBBg_wvif8_BdVuMoZrpS=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110586648689355429715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110586648689355429715/reviews');
SET @user_coa_fifa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110586648689355429715/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sonja Rakovic', 'https://lh3.googleusercontent.com/a/ACg8ocKpXUap17OZ10YZuYGBokBL31YQwvKe2Q3k5QVVJKhnJYW4qA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103139814572343778153/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103139814572343778153/reviews');
SET @user_sonja_rakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103139814572343778153/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'M M', 'https://lh3.googleusercontent.com/a/ACg8ocKXzKVt0KxlKf8h_vW6o5mYQZWsY4d6LCj31fjaklZNv55_qA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102053739238151572984/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102053739238151572984/reviews');
SET @user_m_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102053739238151572984/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'filip boljevic', 'https://lh3.googleusercontent.com/a/ACg8ocKMmayWDcy3dDbjKQ_Vzv43Mruyx69Q_NvUyxp3T2WYGwPGYQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112833939579356886658/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112833939579356886658/reviews');
SET @user_filip_boljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112833939579356886658/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Brnovic', 'https://lh3.googleusercontent.com/a/ACg8ocK0k0BGP5xrnfNR6SQOkOW3faE5DLMVeEZzSxWb_24vXzf27Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117483010276026014458/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117483010276026014458/reviews');
SET @user_milan_brnovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117483010276026014458/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'pavle boljevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWzuwm0L_puz6_sYbSF3LQigdgIu4yM_bJUWbIK8Gmo_laPeRPx=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/115130670182054292107/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115130670182054292107/reviews');
SET @user_pavle_boljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115130670182054292107/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Mickovic', 'https://lh3.googleusercontent.com/a/ACg8ocLwTl4Pg3-BSvFn4mV6VwxqH_hQ6opZ_d9E4wzyCmtKuJybJA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104576861828386231306/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104576861828386231306/reviews');
SET @user_marko_mickovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104576861828386231306/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_enesa, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOSWNUUXhZemQxVTFWc1RWaHBiVk13U1hoNlFsRRAB',
    5, 'bs', 'Imala sam 4operacije diskus hernije. Na četvrtoj su mu ugradjeni implatanti     Operisana sam tačno tri mjeseca od poslednje operacije, predložili su mi da počnem sa fizikalnim terapijama. Došla sam na pregled i receneno mi je da ce oporavak biti malo duzi period.Počela sam na fizikalnoj terapiji AXON . Danas mi je 11 terapija mogu samo da kažem da fizoterapeuti koji rade da su vrhunski i da su posvećeni pacijentima i da se ja nakon 11 terapije već osjećam odlično. Predlažem svima koji imaju problem sličan meni da dodju i da se uvjere.Srdacan pozdrav💕🥰🙏',
    'Imala sam 4 operacije disk hernije. Četvrta je bila sa ugradnjom implantata. Operaciju sam imala tačno tri meseca nakon poslednje operacije, predložili su mi da počnem sa fizikalnom terapijom. Došla sam na kontrolu i rečeno mi je da će period oporavka biti malo duži. Počela sam sa fizikalnom terapijom u AXON-u. Danas mi je 11. terapija, mogu samo da kažem da su fizioterapeuti koji tamo rade vrhunski i posvećeni svojim pacijentima, i da se posle 11 terapija već osećam odlično. Predlažem svima koji imaju problem sličan mom da dođu i sami se uvere. Srdačan pozdrav💕🥰🙏', 'Имала сам 4 операције диск херније. Четврта је била са уградњом имплантата. Операцију сам имала тачно три месеца након последње операције, предложили су ми да почнем са физикалном терапијом. Дошла сам на контролу и речено ми је да ће период опоравка бити мало дужи. Почела сам са физикалном терапијом у AXON-у. Данас ми је 11. терапија, могу само да кажем да су физиотерапеути који тамо раде врхунски и посвећени својим пацијентима, и да се после 11 терапија већ осећам одлично. Предлажем свима који имају проблем сличан мом да дођу и сами се увере. Срдачан поздрав💕🥰🙏', NULL, NULL, NULL, NULL,
    0, '2026-02-24 16:53:51'),

(@user_jelena_mucibabic, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxTk5VNUhNRXRpZVdKZk4xVnRhM0JzTlZsemMyYxAB',
    5, 'bs', 'Željela bih da pohvalim cijeli fizioterapeutski tim, a posebno Marka, zbog izuzetne posvećenosti koju su pokazali tokom mog oporavka. Timski rad i koordinacija su bili besprekorni, a njihova predanost pacijentima je učinila moj oporavak mnogo lakšim i bržim. Sve preporuke, najbolji u Podgorici!',
    'Želeo bih da pohvalim ceo tim fizioterapije, a posebno Marka, na izuzetnoj posvećenosti koju su pokazali tokom mog oporavka. Timski rad i koordinacija su bili besprekorni, a njihova posvećenost pacijentima učinili su moj oporavak mnogo lakšim i bržim. Sve preporuke, najbolje u Podgorici!', 'Желео бих да похвалим цео тим физиотерапије, а посебно Марка, на изузетној посвећености коју су показали током мог опоравка. Тимски рад и координација су били беспрекорни, а њихова посвећеност пацијентима учинили су мој опоравак много лакшим и бржим. Све препоруке, најбоље у Подгорици!', NULL, NULL, NULL, NULL,
    0, '2025-11-25 15:22:29'),

(@user_nik, @clinic_id, @doctor_srdjan_mijovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VKT05tZlhlNi02TGlBRRAB',
    5, 'en', 'I had an outstanding experience at this facility thanks to Srdja Mijovic. He was absolutely extraordinary—knowledgeable, kind, and incredibly polite. I was in severe pain and didn’t have an appointment, but he kindly accepted me and provided exceptional care. It’s the first time in my life I’ve met a doctor who made me feel so respected and well taken care of. I now understand why he’s so busy— Srdja is truly one of the best doctors I’ve ever encountered. If you’re planning a visit, make sure to call ahead and book in advance. Thank you so much,Srdja!',
    'Imao sam izuzetno iskustvo u ovoj ustanovi zahvaljujući Srđi Mijoviću. Bio je apsolutno izvanredan — obrazovan, ljubazan i neverovatno ljubazan. Imao sam jake bolove i nisam imao termin, ali me je ljubazno prihvatio i pružio izuzetnu negu. To je prvi put u mom životu da sam sreo doktora zbog kojeg sam se osećao tako poštovanim i zbrinutim. Sada razumem zašto je toliko zauzet – Srđa je zaista jedan od najboljih doktora koje sam ikada sreo. Ako planirate posetu, obavezno nazovite unapred i rezervišite unapred. Hvala puno, Srđa!', 'Имао сам изузетно искуство у овој установи захваљујући Срђи Мијовићу. Био је апсолутно изванредан — образован, љубазан и невероватно љубазан. Имао сам јаке болове и нисам имао термин, али ме је љубазно прихватио и пружио изузетну негу. То је први пут у мом животу да сам срео доктора због којег сам се осећао тако поштованим и збринутим. Сада разумем зашто је толико заузет – Срђа је заиста један од најбољих доктора које сам икада срео. Ако планирате посету, обавезно назовите унапред и резервишите унапред. Хвала пуно, Срђа!', 'I had an outstanding experience at this facility thanks to Srdja Mijovic. He was absolutely extraordinary—knowledgeable, kind, and incredibly polite. I was in severe pain and didn’t have an appointment, but he kindly accepted me and provided exceptional care. It’s the first time in my life I’ve met a doctor who made me feel so respected and well taken care of. I now understand why he’s so busy— Srdja is truly one of the best doctors I’ve ever encountered. If you’re planning a visit, make sure to call ahead and book in advance. Thank you so much,Srdja!', NULL, NULL, NULL,
    0, '2025-05-05 21:13:12'),

(@user_olia, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VLM2pzTmE2aWRHaXdRRRAB',
    5, 'en', 'I came to see Srdja with serious pain in my neck and left shoulder, and I couldn’t be more thankful. He was incredibly knowledgeable, took the time to explain the issue, and made sure I felt comfortable throughout the entire session. On top of that, he provided me with exercises to do on my own to support my recovery, which was a huge help. Srdja truly goes above and beyond—one of the best specialists I’ve ever met. Highly recommend!',
    'Došao sam kod Srđe sa ozbiljnim bolovima u vratu i levom ramenu i nisam mogao biti više zahvalan. Bio je neverovatno obrazovan, odvojio je vreme da objasni problem i pobrinuo se da se osećam prijatno tokom cele sesije. Povrh toga, obezbedio mi je vežbe koje sam mogao da radim kako bih podržao oporavak, što je bila ogromna pomoć. Srđa zaista ide iznad i dalje - jedan od najboljih specijalista koje sam ikada sreo. Toplo preporučujem!', 'Дошао сам код Срђе са озбиљним боловима у врату и левом рамену и нисам могао бити више захвалан. Био је невероватно образован, одвојио је време да објасни проблем и побринуо се да се осећам пријатно током целе сесије. Поврх тога, обезбедио ми је вежбе које сам могао да радим како бих подржао опоравак, што је била огромна помоћ. Срђа заиста иде изнад и даље - један од најбољих специјалиста које сам икада срео. Топло препоручујем!', 'I came to see Srdja with serious pain in my neck and left shoulder, and I couldn’t be more thankful. He was incredibly knowledgeable, took the time to explain the issue, and made sure I felt comfortable throughout the entire session. On top of that, he provided me with exercises to do on my own to support my recovery, which was a huge help. Srdja truly goes above and beyond—one of the best specialists I’ve ever met. Highly recommend!', NULL, NULL, NULL,
    0, '2025-05-07 09:17:39'),

(@user_predrag, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT201S1NXaGFjRVJSTFc1RU4zb3dNMU0zYUhCT1dHYxAB',
    5, 'hr', 'Odlična ustanova za fizkalnu terapiju. Moj terapeut je bio Marko, sjajan mladi čovjek, stručan,pažljiv i pun znanja. Bio sam dvije nedelje pacijent, mnogo mi je pomogao. Uslovi za rad su idealni, sve ima. Higijena na visokom nivou. Maksimalno korektan čovjek. Moja preporuka kome je ovakva usluga potrebna, samo Axon 1/1. Ocjena čista 10 ka. Hvala Marko.',
    'Odličan kabinet za fizikalnu terapiju. Moj terapeut je bio Marko, sjajan mladić, profesionalan, pažljiv i pun znanja. Bio sam pacijent dve nedelje, mnogo mi je pomogao. Uslovi za rad su idealni, sve je na svom mestu. Higijena na visokom nivou. Veoma korektan čovek. Moja preporuka svima kojima je potrebna ovakva usluga, samo Akson 1/1. Čista ocena 10 od 10. Hvala Marko.', 'Одличан кабинет за физикалну терапију. Мој терапеут је био Марко, сјајан младић, професионалан, пажљив и пун знања. Био сам пацијент две недеље, много ми је помогао. Услови за рад су идеални, све је на свом месту. Хигијена на високом нивоу. Веома коректан човек. Моја препорука свима којима је потребна оваква услуга, само Аксон 1/1. Чиста оцена 10 од 10. Хвала Марко.', NULL, NULL, NULL, NULL,
    0, '2025-12-16 07:15:10'),

(@user_jasmina_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wRVF6VlFaa05qWVhGa04yWTNReTA0TlhKSlYyYxAB',
    5, 'bs', 'Moli se Google za opciju 10 zvezdica :)
Od organizacije i komunikacije do profesionalnosti i odnosa prema ljudima, sve je zaista bez greške.
Andrija, Srđa i Marko su sjajni, stručni, posvećeni i uvek tu da objasne, prilagode trening i motivišu. Odluka da počnem da vežbam kod njih definitivno je jedna od najboljih odluka koje sam donela u 2026.
Od mene velika preporuka.',
    'Moli se Google za opciju 10 zvezdica :)
Od organizacije i komunikacije do profesionalnosti i odnosa prema ljudima, sve je zaista bez greške.
Andrija, Srđa i Marko su sjajni, stručni, posvećeni i uvek tu da objasne, prilagode trening i motivišu. Odluka da počnem da vežbam kod njih definitivno je jedna od najboljih odluka koje sam donela u 2026.
Od mene velika preporuka.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_reglaza_trapa_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxd2MwSXRNWEY1TmxWQ2VuZFdiVXR2WkVwa1drRRAB',
    5, 'hr', 'Broj 1 u Crnoj Gori !',
    'Broj 1 u Crnoj Gori !', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_maximus_emperor, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGalNGQkdUR3hhTUVoUGNFdGphRnAzTTFKek4zYxAB',
    5, 'hr', 'Djole, Srdja, Marko. Profesionalni, posvećeni, ljubazni, nasmijani.... jednom riječju Legende!',
    'Djole, Srdja, Marko. Profesionalni, posvećeni, ljubazni, nasmijani.... jednom riječju Legende!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_anica_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twaU1uVnhXRE5SUmtoSmNtaHBiWE42VVdSdWRtYxAB',
    5, 'bs', 'Sjajno iskustvo sa profesionalnim i stručnim timom u veoma prijatnom ambijentu. Ljubaznost, stučnost i posvećenost osoblja daju povjerenje i čine svaki boravak prijatnim. Sve pohvale za Axon tim!',
    'Sjajno iskustvo sa profesionalnim i stručnim timom u veoma prijatnom ambijentu. Ljubaznost, stučnost i posvećenost osoblja daju povjerenje i čine svaki boravak prijatnim. Sve pohvale za Axon tim!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_rada_popovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GblRXSjZjWFpwVUVKQ1Vqa3RVV0pMWXpKMFkwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_luka_glusica, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GS1ZHOVlWa2t4Tm5aVmNUQTVlbUUzVldWUlRYYxAB',
    5, 'hr', 'U Axon fizikalnom centru sam trenirao posljednja tri mjeseca nakon liječenja multiple skleroze u Rusiji. Njihov individualni pristup i strpljiv rad mnogo su mi pomogli da povratim mobilnost i snagu. Nisam dobio samo stručnu terapiju, već i iskrenu podršku  nisu samo zaposleni, već i prijatelji koji podstiču na borbu i šire dobru energiju. Zahvalan sam cijelom timu i od srca preporučujem ovaj centar svima kojima je potrebna ozbiljna, posvećena rehabilitacija.

Posebno mi je značilo što su vježbe bile prilagođene baš mom stanju, uz stalno praćenje napretka i ohrabrivanje da idem korak po korak. U centru se od prve posjete osjeća profesionalnost, ali i toplina, što je jako važno kad prolaziš kroz težak period bolesti.

Zahvaljujući njima, danas se osjećam sigurnije u pokretu i snažnije, i imam više samopouzdanja za dalji oporavak.',
    'U Axon fizikalnom centru sam trenirao posljednja tri mjeseca nakon liječenja multiple skleroze u Rusiji. Njihov individualni pristup i strpljiv rad mnogo su mi pomogli da povratim mobilnost i snagu. Nisam dobio samo stručnu terapiju, već i iskrenu podršku  nisu samo zaposleni, već i prijatelji koji podstiču na borbu i šire dobru energiju. Zahvalan sam cijelom timu i od srca preporučujem ovaj centar svima kojima je potrebna ozbiljna, posvećena rehabilitacija.

Posebno mi je značilo što su vježbe bile prilagođene baš mom stanju, uz stalno praćenje napretka i ohrabrivanje da idem korak po korak. U centru se od prve posjete osjeća profesionalnost, ali i toplina, što je jako važno kad prolaziš kroz težak period bolesti.

Zahvaljujući njima, danas se osjećam sigurnije u pokretu i snažnije, i imam više samopouzdanja za dalji oporavak.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_dragan_glusica, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT201RVgyY3hTRkJFZW1oWWEyZDBkVlJPVTNGSExWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_andrija_golubovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t3dFptUXlOMko1UlVjNE4yWnJRa0pOVGxkZlUyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_milica_poznanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pnM2QyRktlbWxrUVdod1JsSjRSM2xpY0VWUlkyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_jaksa_gosovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pONWFFZ3phVzlMYmxrMVdYZFdUbkZ2VUZSUVUwRRAB',
    5, 'bs', 'Svaka preporuka. Odlican odnos cijene i kvaliteta usluge.',
    'Svaka preporuka. Odlican odnos cijene i kvaliteta usluge.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_ivana_dragicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21jMmJtUm5hVXd5Y1hCQlFVcGpRa3hxTVVsTllYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_petar_mitrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WNFJFOW9NMlJQWWxwZmVtcGlRemhYV0hBeU4wRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_djordje_barovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5cFdWcEdVSGd5YkZsYVpYUkxaVjh6YWxaT1RrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_zoran_dragicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wTVNVSjROeTB6UTJGcE1tRnJjaTB5YTFjd2VsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_bogdan_vukcevic_bv_company, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toMVpubG5aVGhHY1dnM1VFMHpZMnczT1RKU01IYxAB',
    5, 'bs', 'Marko je izuzetan fizioterapeut i neko kome zaista možete vjerovati kada je u pitanju oporavak kičme. Kod njega dolazim na fizikalne terapije i vježbe zbog diskus hernije na nivou L5–S1 i mogu reći da sam prezadovoljan napretkom.

Prije njega sam bio kod više drugih fizioterapeuta, ali iskreno nisam bio zadovoljan ni pristupom ni rezultatima. Tek kod Marka sam dobio pravi osjećaj da neko zaista razumije problem i zna kako da ga riješi.

Od prvog dolaska sve detaljno objasni – šta se dešava sa kičmom, zašto se određene vježbe rade i kako tačno pomažu oporavku. Terapije su profesionalno vođene, ali istovremeno prilagođene svakom pacijentu. Zahvaljujući pravilnim vježbama i njegovom radu osjetio sam značajno smanjenje bola i veću pokretljivost.

Posebno bih izdvojio Markovu posvećenost, strpljenje i energiju koju ulaže u svakog pacijenta. Ne radi samo rutinski terapije, već zaista prati napredak i motiviše vas da istrajete u procesu oporavka.

Ako imate problema sa kičmom, diskus hernijom ili vam je potrebna kvalitetna fizikalna terapija, Marko je definitivno neko koga bih iskreno preporučio. I još da ne zaboravim, Marko i njegov tim su zaslužni zato što sam izbjegao sigurnu operaciju, koju je preporučio jedan od neurohirurga.',
    'Marko je izuzetan fizioterapeut i neko kome zaista možete vjerovati kada je u pitanju oporavak kičme. Kod njega dolazim na fizikalne terapije i vježbe zbog diskus hernije na nivou L5–S1 i mogu reći da sam prezadovoljan napretkom.

Prije njega sam bio kod više drugih fizioterapeuta, ali iskreno nisam bio zadovoljan ni pristupom ni rezultatima. Tek kod Marka sam dobio pravi osjećaj da neko zaista razumije problem i zna kako da ga riješi.

Od prvog dolaska sve detaljno objasni – šta se dešava sa kičmom, zašto se određene vježbe rade i kako tačno pomažu oporavku. Terapije su profesionalno vođene, ali istovremeno prilagođene svakom pacijentu. Zahvaljujući pravilnim vježbama i njegovom radu osjetio sam značajno smanjenje bola i veću pokretljivost.

Posebno bih izdvojio Markovu posvećenost, strpljenje i energiju koju ulaže u svakog pacijenta. Ne radi samo rutinski terapije, već zaista prati napredak i motiviše vas da istrajete u procesu oporavka.

Ako imate problema sa kičmom, diskus hernijom ili vam je potrebna kvalitetna fizikalna terapija, Marko je definitivno neko koga bih iskreno preporučio. I još da ne zaboravim, Marko i njegov tim su zaslužni zato što sam izbjegao sigurnu operaciju, koju je preporučio jedan od neurohirurga.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_balsa_stojanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xvMFRWVjBiblJwUkRCSU1VTmxhVXBsTW5OcWFuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_gamze_cokun, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pob00yTkVabUkwWlVaM1ZuZExORmd4YjFweE9VRRAB',
    5, 'en', 'Fzt. Marco is the best 👏🏼👏🏼👏🏼',
    NULL, NULL, 'Fzt. Marco is the best 👏🏼👏🏼👏🏼', NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_hakan_uzel, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xweE4yUk5hakppWWtGSWJUSk5OSGhwUmxCT1gyYxAB',
    5, 'tr', 'Bu adamların parmakları sihirli. Bu şehirde bir kaç fizyoterapist gezdim. Fakat bu kadar beni ve ağrılarımı anlamaya çalışan başka bir fizyoterapist olmadı. Ağrıdan uyuyamıyordum ve bu durumu benim kadar kafaya taktı. Ağrılarımı geçirdi. Marko Brate moj Hvala Puno.',
    NULL, NULL, NULL, NULL, NULL, 'Bu adamların parmakları sihirli. Bu şehirde bir kaç fizyoterapist gezdim. Fakat bu kadar beni ve ağrılarımı anlamaya çalışan başka bir fizyoterapist olmadı. Ağrıdan uyuyamıyordum ve bu durumu benim kadar kafaya taktı. Ağrılarımı geçirdi. Marko Brate moj Hvala Puno.',
    0, '2025-12-29 00:00:00'),

(@user_ld, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGaVJrRlNTek14YW1KT1VteG1WamRyTUY5WlNuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_vojislav_svicevic, @clinic_id, @doctor_srdjan_mijovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4RFkxUkRjVk5OVUZZME0yeFVWa0pXUVRkMUxVRRAB',
    5, 'en', 'The team delivers top-quality work, and Srdjan is an exceptional expert.',
    NULL, NULL, 'The team delivers top-quality work, and Srdjan is an exceptional expert.', NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_ljubisa_dulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT214ZmVtY3lXREl4U1c1UExYVXRORTlTUm5SWlIwRRAB',
    5, 'bs', 'Sve preporuke za sjajne i profesionalne momke. Odlična energija i posvećenost na vodjenim treninzima. 💪🏻🙌🏻',
    'Sve preporuke za sjajne i profesionalne momke. Odlična energija i posvećenost na vodjenim treninzima. 💪🏻🙌🏻', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_milica_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT213NFgxOXFRM2N0T1ZWZlEyRjBiMm8yZFVVMFkxRRAB',
    5, 'hr', 'Kada na trening dolazite ranije, i kada se završi, želite da ostanete još, E, TO JE TO!
Uz ljubazan i stručan tim, rezultati su neizbježni. SVE PREPORUKE AXON FIZIKALNA TERAPIJA! HVALA od ❤️
MARKO...SRDJAN i DJORDJE SJAJNI!',
    'Kada na trening dolazite ranije, i kada se završi, želite da ostanete još, E, TO JE TO!
Uz ljubazan i stručan tim, rezultati su neizbježni. SVE PREPORUKE AXON FIZIKALNA TERAPIJA! HVALA od ❤️
MARKO...SRDJAN i DJORDJE SJAJNI!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_dr_copy, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SUmFGZEplVFJ0Y3psT1ExZFJNRGhOTkRsNVpXYxAB',
    5, 'bs', 'Vrhunski fizioterapeuti a prije svega momci!
Veoma pozitivan odnos sa pacijentima i velika je prednost sto je sve na jednom mjestu-od treninga do fizikalnog tretmana.
Sve pohvale!',
    'Vrhunski fizioterapeuti a prije svega momci!
Veoma pozitivan odnos sa pacijentima i velika je prednost sto je sve na jednom mjestu-od treninga do fizikalnog tretmana.
Sve pohvale!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_alen_babai, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oMk5GRlhZM1ZVWkZOb1pucEdXRU5XWkd3MVpWRRAB',
    5, 'en', 'I am  incredibly pleased with my experience at Axon ! From the moment I arrived, the staff was exceptional.
The training and therapy programs were top-notch and tailored specifically to my needs. The dedication of the team truly made a difference in my recovery journey.',
    NULL, NULL, 'I am  incredibly pleased with my experience at Axon ! From the moment I arrived, the staff was exceptional.
The training and therapy programs were top-notch and tailored specifically to my needs. The dedication of the team truly made a difference in my recovery journey.', NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_dzenana_mari, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWRmVuRmhYemt4YkdGTWNHOHRTRXBrWWw5bGQwRRAB',
    5, 'hr', 'Odlična usluga u Axon fizikalnoj! Marko je izuzetno stručan, posvećen i organizovan. Svaka terapija je precizno prilagođena i uvijek se osjeti njegov profesionalan pristup. Topla preporuka!',
    'Odlična usluga u Axon fizikalnoj! Marko je izuzetno stručan, posvećen i organizovan. Svaka terapija je precizno prilagođena i uvijek se osjeti njegov profesionalan pristup. Topla preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_g, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ORldrbGlTVkY1WVRSemFsQlZlVWxSZDNCc1gyYxAB',
    5, 'bs', 'Odlično iskustvo! Marko je sjajan – stručan, pažljiv i posvećen. Ekipa je mlada, profesionalna i veoma organizovana. Prijatna atmosfera i odlični rezultati. Sve preporuke!',
    'Odlično iskustvo! Marko je sjajan – stručan, pažljiv i posvećen. Ekipa je mlada, profesionalna i veoma organizovana. Prijatna atmosfera i odlični rezultati. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_nemanja_zindovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT25NNGRrUlNWVVJqY0dSNlFuUnpSV0Z6Y3poZlpHYxAB',
    5, 'bs', 'Od srca preporučujem Axon fizikalnu terapiju!
Imao sam izuzetno pozitivno iskustvo – od samog prijema, preko terapija, pa sve do individualno prilagođenih vježbi. Stručan i ljubazan tim uliva povjerenje i zaista se osjeća njihova posvećenost svakom pacijentu(korisniku).
Već nakon nekoliko dolazaka osjetio sam konkretno poboljšanje, a atmosfera u centru dodatno motiviše da nastavite s prilagođenim treninzima. Ako tražite mjesto gdje su znanje, iskustvo i ljudskost spojeni na jednom mjestu – Axon je pravi izbor!',
    'Od srca preporučujem Axon fizikalnu terapiju!
Imao sam izuzetno pozitivno iskustvo – od samog prijema, preko terapija, pa sve do individualno prilagođenih vježbi. Stručan i ljubazan tim uliva povjerenje i zaista se osjeća njihova posvećenost svakom pacijentu(korisniku).
Već nakon nekoliko dolazaka osjetio sam konkretno poboljšanje, a atmosfera u centru dodatno motiviše da nastavite s prilagođenim treninzima. Ako tražite mjesto gdje su znanje, iskustvo i ljudskost spojeni na jednom mjestu – Axon je pravi izbor!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_edvin_strujic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxTFVFeEpPVnBLYW1Sb1VsaFliblJMYkU5S1ZGRRAB',
    5, 'hr', 'Momci su jako dobri. I kao ljudi i kao profesionalci. Atmosfera prijatna, a moje rame nikada nije bilo bolje 💪',
    'Momci su jako dobri. I kao ljudi i kao profesionalci. Atmosfera prijatna, a moje rame nikada nije bilo bolje 💪', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jana_vukadinovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21wUVkzZFZWVWxCV1dWUFZWTnJUbmRzTUVoTlMxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_slavica_carapic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWc2RVbE9NRlpTTkVadmFVaGZiRkYxWldSaFdHYxAB',
    5, 'bs', 'Osoblje na fizikalnoj terapiji jako strucno , srdacni i veoma pazljivi .Atosfera je prijatna a svaki dolazak na terapiju protice u podrsci i pozitivnom duhu . Uvjek se osjecam saslusano i podrzano sto mi jako znaci kad god imam neki problem sa ledjima . Topla preporuka za ovaj tim 😃',
    'Osoblje na fizikalnoj terapiji jako strucno , srdacni i veoma pazljivi .Atosfera je prijatna a svaki dolazak na terapiju protice u podrsci i pozitivnom duhu . Uvjek se osjecam saslusano i podrzano sto mi jako znaci kad god imam neki problem sa ledjima . Topla preporuka za ovaj tim 😃', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_radovan_krsmanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VPS1ZyNExhMTkyX0dnEAE',
    5, 'bs', 'Majka rađa a Axon fizikalna terapija preporađa. U moru lažnih ,,terapeuta,, tračak nade. Riješili su mi problem profesionalno i stručno, jako pristojni momci i prijateljska atmosfera. Da napomenem da ne rade stvari na pamet kao većina ,,instagram terapeuta,, već za ozbiljne probleme imaju ozbiljan pristup.
Hvala Axon-u na svemu !',
    'Majka rađa a Axon fizikalna terapija preporađa. U moru lažnih ,,terapeuta,, tračak nade. Riješili su mi problem profesionalno i stručno, jako pristojni momci i prijateljska atmosfera. Da napomenem da ne rade stvari na pamet kao većina ,,instagram terapeuta,, već za ozbiljne probleme imaju ozbiljan pristup.
Hvala Axon-u na svemu !', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_zaro_rackovic, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VKemN5TmZTeF9hX01BEAE',
    5, 'bs', 'Axson fizikalna terapija koju sam poceo koristiti zbog povrede ramena.Terapeut Marko Mickovic mi je poceo raditi tretmane.Posle prvog odradjenog tretmana sam osjetio veliko poboljsanje i upola smanjen bol.Dosao sam po preporuci i nisam zazalio.Tako da vam najiskrenije preporucujem ovu adresu na kojoj  se radi profesionalno i posteno.Hvala im na profesionalizmu.',
    'Axson fizikalna terapija koju sam poceo koristiti zbog povrede ramena.Terapeut Marko Mickovic mi je poceo raditi tretmane.Posle prvog odradjenog tretmana sam osjetio veliko poboljsanje i upola smanjen bol.Dosao sam po preporuci i nisam zazalio.Tako da vam najiskrenije preporucujem ovu adresu na kojoj  se radi profesionalno i posteno.Hvala im na profesionalizmu.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragan_bozovic, @clinic_id, @doctor_marko_mickovic, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VJQ3BycFhrd2FUY2h3RRAB',
    5, 'bs', 'Sve pohvale za Marka i Srdju za nevjerovatno ostvaren rezultat u roku od mjesec dana.Nastavljamo dalje',
    'Sve pohvale za Marka i Srdju za nevjerovatno ostvaren rezultat u roku od mjesec dana.Nastavljamo dalje', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_redzo_muli, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VKYnMzYzIxdXY2X1N3EAE',
    5, 'hr', 'Topla preporuka za ovu kliniku! Radio sam terapije za rame, donja leđa i skočni zglob i već nakon prvih tretmana osetio sam značajno poboljšanje. Stručno i ljubazno osoblje, sjajna atmosfera i individualan pristup svakom pacijentu. Hvala na posvećenosti momci !!!',
    'Topla preporuka za ovu kliniku! Radio sam terapije za rame, donja leđa i skočni zglob i već nakon prvih tretmana osetio sam značajno poboljšanje. Stručno i ljubazno osoblje, sjajna atmosfera i individualan pristup svakom pacijentu. Hvala na posvećenosti momci !!!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ivan_ivan, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VLQzkyOUhZMzlXb0pREAE',
    5, 'en', 'I had a great experience at Axon Physiotherapy centre. The care I received was top-notch, and I highly recommend them. I especially want to give a shoutout to Marko and Srdjan. Their expertise, professionalism, and dedication were truly remarkable. They were both incredibly knowledgeable and attentive helping me throughout my treatment. If you\'re looking for a fantastic physiotherapy clinic, Axon is the place to go!',
    NULL, NULL, 'I had a great experience at Axon Physiotherapy centre. The care I received was top-notch, and I highly recommend them. I especially want to give a shoutout to Marko and Srdjan. Their expertise, professionalism, and dedication were truly remarkable. They were both incredibly knowledgeable and attentive helping me throughout my treatment. If you\'re looking for a fantastic physiotherapy clinic, Axon is the place to go!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sanja_bulatovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VQeXkwdEw1ektXWk13EAE',
    5, 'hr', 'Najbolji u Podgorici.',
    'Najbolji u Podgorici.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_muratovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VJQ0FnSURfX09tN3ZnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_coa_fifa, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VJQ0FnSURfdkttbXlBRRAB',
    5, 'hr', 'Imao sam povredu ručnog zgloba duže vrijeme i izliječili su mi je posle samo nekoliko terapija, baš sam zadovoljan i preporučujem ih.',
    'Imao sam povredu ručnog zgloba duže vrijeme i izliječili su mi je posle samo nekoliko terapija, baš sam zadovoljan i preporučujem ih.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sonja_rakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VJQ0FnSUNmOHV5cVdnEAE',
    5, 'hr', 'Sve preporuke',
    'Sve preporuke', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_m_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VJQ0FnSURQNjdLNnBRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_filip_boljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VJQ0FnSURQa2J1ekNBEAE',
    5, 'bs', 'Od srca želim pohvaliti tim fizioterapeuta na profesionalnom i pažljivom pristupu. Svaki tretman je bio prilagođen mojim potrebama, a stručnost i posvećenost su zaista impresivni. Atmosfera je prijatna i opuštajuća, što čini ceo proces još ugodnijim. Već nakon nekoliko dolazaka osećam značajno poboljšanje, i sa sigurnošću mogu reći da su nadmašili moja očekivanja. Preporučujem ih svima koji traže kvalitetnu i efikasnu fizioterapiju. Hvala vam na svemu!',
    'Od srca želim pohvaliti tim fizioterapeuta na profesionalnom i pažljivom pristupu. Svaki tretman je bio prilagođen mojim potrebama, a stručnost i posvećenost su zaista impresivni. Atmosfera je prijatna i opuštajuća, što čini ceo proces još ugodnijim. Već nakon nekoliko dolazaka osećam značajno poboljšanje, i sa sigurnošću mogu reći da su nadmašili moja očekivanja. Preporučujem ih svima koji traže kvalitetnu i efikasnu fizioterapiju. Hvala vam na svemu!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milan_brnovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VJQ0FnSURQZ2VhYjF3RRAB',
    5, 'en', 'Extraordinary service',
    NULL, NULL, 'Extraordinary service', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_pavle_boljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VJQ0FnSURQZ1lhbTNnRRAB',
    5, 'hr', 'Sve pohvale! 👏🏻👏🏻👏🏻',
    'Sve pohvale! 👏🏻👏🏻👏🏻', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marko_mickovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VJQ0FnSURQNW9uTmZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOSWNUUXhZemQxVTFWc1RWaHBiVk13U1hoNlFsRRAB'),
  'clinic', @clinic_id,
  'Hvala na povjerenju. Drago nam je da smo pomogli☺️🙌🏻', 'hr',
  'Hvala na povjerenju. Drago nam je da smo pomogli☺️🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxTk5VNUhNRXRpZVdKZk4xVnRhM0JzTlZsemMyYxAB'),
  'clinic', @clinic_id,
  'Hvala na povjerenju!🙌🏻💪', 'hr',
  'Hvala na povjerenju!🙌🏻💪', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VKT05tZlhlNi02TGlBRRAB'),
  'clinic', @clinic_id,
  'Thank you for your kind words. We are glad that you are satisfied with our service.', 'en',
  NULL, NULL, 'Thank you for your kind words. We are glad that you are satisfied with our service.', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VLM2pzTmE2aWRHaXdRRRAB'),
  'clinic', @clinic_id,
  'Thank you very much for your support.', 'en',
  NULL, NULL, 'Thank you very much for your support.', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT201S1NXaGFjRVJSTFc1RU4zb3dNMU0zYUhCT1dHYxAB'),
  'clinic', @clinic_id,
  'Hvala, Pedja na ukazanom povjerenju. Bilo je zadovoljstvo raditi sa tobom☺️', 'hr',
  'Hvala, Pedja na ukazanom povjerenju. Bilo je zadovoljstvo raditi sa tobom☺️', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wRVF6VlFaa05qWVhGa04yWTNReTA0TlhKSlYyYxAB'),
  'clinic', @clinic_id,
  'Hvala na divnom komentaru i podrsci🔥🙌🏻', 'bs',
  'Hvala na divnom komentaru i podrsci🔥🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxd2MwSXRNWEY1TmxWQ2VuZFdiVXR2WkVwa1drRRAB'),
  'clinic', @clinic_id,
  '🙌🏻🙌🏻', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGalNGQkdUR3hhTUVoUGNFdGphRnAzTTFKek4zYxAB'),
  'clinic', @clinic_id,
  '🙌🏻🙌🏻', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twaU1uVnhXRE5SUmtoSmNtaHBiWE42VVdSdWRtYxAB'),
  'clinic', @clinic_id,
  '🙌🏻🙌🏻', 'en-GB',
  NULL, NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GS1ZHOVlWa2t4Tm5aVmNUQTVlbUUzVldWUlRYYxAB'),
  'clinic', @clinic_id,
  'Hvala na ukazanom povjerenju.
Zadovoljstvo nam je da makar i malim dijelom mozemo podrzati tvoju borbu!💪🏻', 'hr',
  'Hvala na ukazanom povjerenju.
Zadovoljstvo nam je da makar i malim dijelom mozemo podrzati tvoju borbu!💪🏻', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-06-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toMVpubG5aVGhHY1dnM1VFMHpZMnczT1RKU01IYxAB'),
  'clinic', @clinic_id,
  'Veliko nam je zadovoljstvo sto smo uspjeli da pomognemo. Hvala na poverenju🙌🏻', 'bs',
  'Veliko nam je zadovoljstvo sto smo uspjeli da pomognemo. Hvala na poverenju🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pob00yTkVabUkwWlVaM1ZuZExORmd4YjFweE9VRRAB'),
  'clinic', @clinic_id,
  'Thank you!🙌🏻', 'en',
  NULL, NULL, 'Thank you!🙌🏻', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xweE4yUk5hakppWWtGSWJUSk5OSGhwUmxCT1gyYxAB'),
  'clinic', @clinic_id,
  'Thank you for your trust. We are glad that you finally can sleep and live without pain!🤩🥂', 'en',
  NULL, NULL, 'Thank you for your trust. We are glad that you finally can sleep and live without pain!🤩🥂', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT214ZmVtY3lXREl4U1c1UExYVXRORTlTUm5SWlIwRRAB'),
  'clinic', @clinic_id,
  'Hvala na povjerenju!💪💪', 'hr',
  'Hvala na povjerenju!💪💪', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT213NFgxOXFRM2N0T1ZWZlEyRjBiMm8yZFVVMFkxRRAB'),
  'clinic', @clinic_id,
  'Hvala na lijepim rijecima!🙌🏻', 'hr',
  'Hvala na lijepim rijecima!🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SUmFGZEplVFJ0Y3psT1ExZFJNRGhOTkRsNVpXYxAB'),
  'clinic', @clinic_id,
  'Hvala na lijepim rijecima🙌🏻👊', 'hr',
  'Hvala na lijepim rijecima🙌🏻👊', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT21oMk5GRlhZM1ZVWkZOb1pucEdXRU5XWkd3MVpWRRAB'),
  'clinic', @clinic_id,
  'Hvala na povjerenju!💪', 'hr',
  'Hvala na povjerenju!💪', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWRmVuRmhYemt4YkdGTWNHOHRTRXBrWWw5bGQwRRAB'),
  'clinic', @clinic_id,
  'Hvala na ukazanom povjerenju!🙌🏻', 'hr',
  'Hvala na ukazanom povjerenju!🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ORldrbGlTVkY1WVRSemFsQlZlVWxSZDNCc1gyYxAB'),
  'clinic', @clinic_id,
  'Hvala puno na ukazanom povjerenju!🙌🏻😁', 'hr',
  'Hvala puno na ukazanom povjerenju!🙌🏻😁', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT25NNGRrUlNWVVJqY0dSNlFuUnpSV0Z6Y3poZlpHYxAB'),
  'clinic', @clinic_id,
  'Hvala puno na ukazanom povjerenju!🙌🏻', 'hr',
  'Hvala puno na ukazanom povjerenju!🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxTFVFeEpPVnBLYW1Sb1VsaFliblJMYkU5S1ZGRRAB'),
  'clinic', @clinic_id,
  'Hvala puno na lijepim riječima i ukazanom povjerenju!🙌🏻', 'hr',
  'Hvala puno na lijepim riječima i ukazanom povjerenju!🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VPS1ZyNExhMTkyX0dnEAE'),
  'clinic', @clinic_id,
  'Puno hvala na ovako lijepim rijecima. Drago nam je da smo pomogli😊😁', 'hr',
  'Puno hvala na ovako lijepim rijecima. Drago nam je da smo pomogli😊😁', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VKemN5TmZTeF9hX01BEAE'),
  'clinic', @clinic_id,
  'Hvala puno na lijepim rijecima. Drago nam je da smo pomogli😊', 'hr',
  'Hvala puno na lijepim rijecima. Drago nam je da smo pomogli😊', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChdDSUhNMG9nS0VJQ3BycFhrd2FUY2h3RRAB'),
  'clinic', @clinic_id,
  'Hvala na ukazanom povjerenju!🙌🏻', 'hr',
  'Hvala na ukazanom povjerenju!🙌🏻', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VKYnMzYzIxdXY2X1N3EAE'),
  'clinic', @clinic_id,
  'Hvala puno na lijepim riječima. Drago nam je da smo opravdali očekivanja!', 'hr',
  'Hvala puno na lijepim riječima. Drago nam je da smo opravdali očekivanja!', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJNWX6KgDrTRMRskpO74r8428/reviews/ChZDSUhNMG9nS0VLQzkyOUhZMzlXb0pREAE'),
  'clinic', @clinic_id,
  'Thank you for your trust. We are glad that we lived up to your expectations.🙌🏻', 'en',
  NULL, NULL, 'Thank you for your trust. We are glad that we lived up to your expectations.🙌🏻', NULL, NULL, NULL,
  'google_maps', '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
