-- Insert Google Maps reviews for Ambulanta
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ginekoloska-ordinacija-vita-feminae-kotor.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ginekoloska-ordinacija-vita-feminae-kotor');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_predrag_djurovic = (SELECT id FROM doctors WHERE slug = 'predrag-djurovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Savovic 2', 'https://lh3.googleusercontent.com/a-/ALV-UjUnhFX756nASCOJqY6oEHBvSDl1T1wZHLyK4fELLeyChayyiAqk=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100118504106980038146/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100118504106980038146/reviews');
SET @user_savovic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100118504106980038146/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dóri', 'https://lh3.googleusercontent.com/a-/ALV-UjWUjvx79b7DCqVrL-AkUXpXWjrQi8p_v10d6b6rX0hU3yyeOFR0XA=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/108345951798553059152/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108345951798553059152/reviews');
SET @user_dri = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108345951798553059152/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Selen', 'https://lh3.googleusercontent.com/a-/ALV-UjXYmKVzjZCtG-B9TuoVst8tmYFDgXsmDQK_cE1XVOkQno31EPE=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/118006642595674113174/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118006642595674113174/reviews');
SET @user_selen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118006642595674113174/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maya Pogosyan', 'https://lh3.googleusercontent.com/a-/ALV-UjWtA9dG1Is2SAq3ay5z2B2b8Z8Rep278WiXYxQKtOG62Iq-jPiA=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/106736540638071941958/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106736540638071941958/reviews');
SET @user_maya_pogosyan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106736540638071941958/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Madina Karagoishina', 'https://lh3.googleusercontent.com/a-/ALV-UjUwVnBzTeB2MnFg5-BURDDhHV4hx7yh7HNHpLxhpVMtjw_9voM=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106750833670129966899/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106750833670129966899/reviews');
SET @user_madina_karagoishina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106750833670129966899/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Michaela Milošević', 'https://lh3.googleusercontent.com/a-/ALV-UjUpZzzR9LHdZmhwpUraKY8m-mXrWyzB0xK1Bsu-AP-1uE04HShbLg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112485946060508742693/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112485946060508742693/reviews');
SET @user_michaela_miloevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112485946060508742693/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dingo Dingo', 'https://lh3.googleusercontent.com/a/ACg8ocJrgtYRCRMFv_LYx-WOWU_FTplsyxSrifCJiDfLuhG5ecHcOQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102969264602028603355/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102969264602028603355/reviews');
SET @user_dingo_dingo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102969264602028603355/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Ivanovic', 'https://lh3.googleusercontent.com/a/ACg8ocI9zb94xxzPTMH7xznNn7gk0jE088sWPvXuf_KCVoNSvwxPvQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104704147224105368908/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104704147224105368908/reviews');
SET @user_jelena_ivanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104704147224105368908/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina', 'https://lh3.googleusercontent.com/a/ACg8ocLTHuoLwwKeifDRdmJxjKntQRZBcsa4zhhItYGg98PAf3crjw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105432574948791193734/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105432574948791193734/reviews');
SET @user_nina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105432574948791193734/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marija Stankovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU9QFv8o47bDw57H39j-kc6zDepWrJlVMI_KXHb4LkWnNH2Lfc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117980975658617464723/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117980975658617464723/reviews');
SET @user_marija_stankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117980975658617464723/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Pavićević', 'https://lh3.googleusercontent.com/a/ACg8ocJ7cJTRtNUe-1IQFd1KaN2TClmgnFuZvoeNjog248yL8gaKFg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110995264552410124087/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995264552410124087/reviews');
SET @user_kristina_pavievi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110995264552410124087/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Milenkovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVrK9SSIqcoNIzcEG7rc4knFwqVa6_RRZAzAnpWLPxSs7ypUVNN=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106174273483187200794/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106174273483187200794/reviews');
SET @user_ana_milenkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106174273483187200794/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Slađana', 'https://lh3.googleusercontent.com/a/ACg8ocI2-3rrNHXzK9-e3tGGoIXRjZLGuVMjwzErXQdVhcjnlA4cdg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100102369415907482715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100102369415907482715/reviews');
SET @user_slaana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100102369415907482715/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Teya Teya', 'https://lh3.googleusercontent.com/a-/ALV-UjWFb2iwZArPG4wMVpSsq-Q8Y0zgcWyK_WCkwwrM3YOtghy9FEQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107030048941339260184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107030048941339260184/reviews');
SET @user_teya_teya = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107030048941339260184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Pocanic', 'https://lh3.googleusercontent.com/a/ACg8ocKZk66ijiT_JqUj8dCd6XyyL-coYaGizEa3Uc32sUDFN-tBpQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109238643531592326132/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109238643531592326132/reviews');
SET @user_milica_pocanic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109238643531592326132/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Boskovic', 'https://lh3.googleusercontent.com/a/ACg8ocJG9zrTsGNLpIrhLPNE8kcJ_-EO__TzRSH3CGjQBmpiXHUsOQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107533057131538952624/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107533057131538952624/reviews');
SET @user_dragana_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107533057131538952624/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja BB', 'https://lh3.googleusercontent.com/a/ACg8ocLINnxNAKw1ZEXG15SbsoJIhxL_Srb85dhv6qYn_JYMTXaLJZs8=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103309334616941776901/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103309334616941776901/reviews');
SET @user_sanja_bb = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103309334616941776901/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Đešević', 'https://lh3.googleusercontent.com/a/ACg8ocKYH825OOmBjUVb7Pm9n6ypIiWsr72TV4qJ_uQSGmpg3DRCXQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110096677830654958432/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110096677830654958432/reviews');
SET @user_kristina_eevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110096677830654958432/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anja Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocIVTGYRGoYYXkKQOg8XDgrHmJxufSMq1_69FNjBRcMIwU_aqQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117544377002104316233/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117544377002104316233/reviews');
SET @user_anja_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117544377002104316233/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Vukovic', 'https://lh3.googleusercontent.com/a-/ALV-UjX_DvQQPD9xI-nkTSVyTnxL7jJm_NvjYnlWVt1XB88VTg6xom5l=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107189457081605054632/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107189457081605054632/reviews');
SET @user_dragana_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107189457081605054632/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa', 'https://lh3.googleusercontent.com/a-/ALV-UjUpdTQTEz8YwHp9RN9kMC4qVASZNyHoaRU3GIF1w9QJOIcnWjM=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113162818075291182007/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113162818075291182007/reviews');
SET @user_natasa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113162818075291182007/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Janovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWdcMf85c0OdV2TNFzmgGzHRjJ28VTYdy3b2f50w3wWbiaRdQ3n=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112319656598152625762/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112319656598152625762/reviews');
SET @user_ivana_janovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112319656598152625762/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Alea M.', 'https://lh3.googleusercontent.com/a-/ALV-UjUl5AZFT0Dr_Qi6tqSJ7SqXmh3bMPOV5maRMGUjskmAHnKGYf-G=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113674920917401178954/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113674920917401178954/reviews');
SET @user_alea_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113674920917401178954/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Savic', 'https://lh3.googleusercontent.com/a/ACg8ocJz0uhEk6DsiEO8pNlmi-hm6XwxFri2YbAeZ94IH1qx5q-Cfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113657352454382937905/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113657352454382937905/reviews');
SET @user_maja_savic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113657352454382937905/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nina pavlovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWPyWAdQO2TRlSl82KAiNTY3-dHawjHRhSgTR5hATWhw3mfPvdj=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117248284113476807538/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117248284113476807538/reviews');
SET @user_nina_pavlovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117248284113476807538/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocLLwl9Umb8RgglkSx4J_0LQVw8to8A7FcloeI1toOde2Fy6XQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108089732268736237155/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108089732268736237155/reviews');
SET @user_marijana_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108089732268736237155/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina', 'https://lh3.googleusercontent.com/a/ACg8ocIHd351gNdwOmHYWfkteiywxWFYYVuVR0KusyjDgrsAiBTpT6o=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/114405381163398674963/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114405381163398674963/reviews');
SET @user_jasmina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114405381163398674963/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sonja Radonjic', 'https://lh3.googleusercontent.com/a/ACg8ocIKqI9778SKsKQYVJcA75-l141NHtoMBIsrlBZ8XBNdTcNw1w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114880140102430211765/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114880140102430211765/reviews');
SET @user_sonja_radonjic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114880140102430211765/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'kristina radonjic', 'https://lh3.googleusercontent.com/a/ACg8ocLdVEXHPCHq9_-yXP2rlNgytw3jyanTpgiQhXtvJJwqjjT_7b4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116177823713940772006/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116177823713940772006/reviews');
SET @user_kristina_radonjic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116177823713940772006/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrea Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocLfSAYa6DQ5qaOrL8AtElwaqTNQfkStUjBtokswAeAu7ou3hQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103849972217361113576/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103849972217361113576/reviews');
SET @user_andrea_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103849972217361113576/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aida Khubaeva', 'https://lh3.googleusercontent.com/a-/ALV-UjWnKcBrmwXGNUC386uvPArMaFMmABs03TWgY2UpAjAJSjjrc6o2=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106236842729815139254/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106236842729815139254/reviews');
SET @user_aida_khubaeva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106236842729815139254/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina T', 'https://lh3.googleusercontent.com/a-/ALV-UjU4USPcplPHfbljYvaIm1ZoOWeElTNkJX4X9mhgtLcZ1gKMyYxr=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114272875093002734350/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114272875093002734350/reviews');
SET @user_irina_t = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114272875093002734350/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana B', 'https://lh3.googleusercontent.com/a/ACg8ocLwcMjoaYsxu12zjZ78ApAMHaSN_bpnAUGVILQzcewqG-pcDMk=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106766695452050926001/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106766695452050926001/reviews');
SET @user_sladjana_b = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106766695452050926001/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Kolak', 'https://lh3.googleusercontent.com/a-/ALV-UjWjCE-uODGwFOxcH6X7qCvpCycWiQxuMDTc37Yt11QL496QlO2d=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100450273094591787123/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100450273094591787123/reviews');
SET @user_ana_kolak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100450273094591787123/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Theo known as Ellen', 'https://lh3.googleusercontent.com/a-/ALV-UjVgApJlPrUFgfZ65XCiz92JyOZ6u-MvxmOAKHLrToO7Ffncyng=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/118098542779729850381/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118098542779729850381/reviews');
SET @user_theo_known_as_ellen = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118098542779729850381/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Polina Lazareva', 'https://lh3.googleusercontent.com/a-/ALV-UjWbmF7vWDr7JQLoRPr3FSn5QjJjA9AlVAOZBc63dIGufG3BWTryuA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110576720339199212527/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110576720339199212527/reviews');
SET @user_polina_lazareva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110576720339199212527/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irina Grgurevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUIy30clvH3k_JZwmi9ar6Bm0bUZ2gWdCKAM13iy54VX5hHqb19=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/118031321623048288477/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118031321623048288477/reviews');
SET @user_irina_grgurevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118031321623048288477/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maja Balic', 'https://lh3.googleusercontent.com/a-/ALV-UjXzuvL-niSdwLONXqNpADh_LvFBpIpn8QqETIIM_ouvC5jwVfQARA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105888557822159877823/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105888557822159877823/reviews');
SET @user_maja_balic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105888557822159877823/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Jancic', 'https://lh3.googleusercontent.com/a/ACg8ocL_o86RlBrEYrlay-AsQGDVKhDPAZPGjeEAYH6KxE2fCKgsPg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113080626588747079614/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113080626588747079614/reviews');
SET @user_mirjana_jancic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113080626588747079614/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radovan Buric', 'https://lh3.googleusercontent.com/a/ACg8ocLE1AhExISKXUHAd_Zys2Dn9wVXSqPuW4D36i3LwARS6rdqrg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105570199017597880219/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105570199017597880219/reviews');
SET @user_radovan_buric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105570199017597880219/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Vuceljic', 'https://lh3.googleusercontent.com/a/ACg8ocIwhUFY4DSadf21FNJEEBn9CuFhSz6CMLO5S11QKAy9umQng4Y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101001615314343095068/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101001615314343095068/reviews');
SET @user_aleksandra_vuceljic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101001615314343095068/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Margaux Schlosmacher', 'https://lh3.googleusercontent.com/a-/ALV-UjUbsnaexLFOCf9bXdtGND8XC-m3KxISBUYd363NB900oW7feS3L=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110810031214546434276/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110810031214546434276/reviews');
SET @user_margaux_schlosmacher = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110810031214546434276/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kostiantyn Bukov', 'https://lh3.googleusercontent.com/a-/ALV-UjXIvW0nfFiXTSakLgGvKaf2xCzo2QQGP1LvPhmSNHxrnAp2nHAZ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106125659778314482614/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106125659778314482614/reviews');
SET @user_kostiantyn_bukov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106125659778314482614/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocJmRcF3aP2zHh96mUtwFo5chM8zuTpNXQHtCYeWh2fYyBe0T70=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112635150567353807764/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112635150567353807764/reviews');
SET @user_ivana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112635150567353807764/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Grbovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXTDWxqdILrHduwT8bibv7qwfnsDwjhKmAemP77WVsyMn27GJGf=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/106050788860386261137/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106050788860386261137/reviews');
SET @user_milena_grbovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106050788860386261137/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Icloud Iphone', 'https://lh3.googleusercontent.com/a/ACg8ocLugBZstwbOcV_2OpAeIiCNjjwPxgeYBaSnzZ3rutgKm68tsw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113022368311808298570/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113022368311808298570/reviews');
SET @user_icloud_iphone = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113022368311808298570/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stefani S', 'https://lh3.googleusercontent.com/a/ACg8ocIbGAE15qQMBpYsr0bo0LpZuG7fQa8XJ-WsVNWQjmbpFRZ3UQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106573557094672463416/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106573557094672463416/reviews');
SET @user_stefani_s = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106573557094672463416/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Юлия Наумова', 'https://lh3.googleusercontent.com/a/ACg8ocJ6DnZKnKFscp2FHAh2v8QnO6eYyQ1UA2GusXQ0bjpBre-Hiw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/107726465934354093361/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107726465934354093361/reviews');
SET @user_yuliya_naumova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107726465934354093361/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Rakicevic', 'https://lh3.googleusercontent.com/a-/ALV-UjVj-6Ro2AAy5Od7dUY_aV2CP9R_QGuCP3xxP8BKi7a37qTXJoG4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105187103628324850799/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105187103628324850799/reviews');
SET @user_milena_rakicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105187103628324850799/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Liki', 'https://lh3.googleusercontent.com/a-/ALV-UjU5eOOi8OA_Nq-Tqiar6SoyNvJMmpwEgFXCB0wGd87NxSkvtKFp=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110109504877608254937/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110109504877608254937/reviews');
SET @user_liki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110109504877608254937/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Kruta', 'https://lh3.googleusercontent.com/a/ACg8ocJVKhfJpp-drsLPxAcuEyxljKC2bMD4KBYX64hPJMN1BiyU2A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106878226982830764063/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106878226982830764063/reviews');
SET @user_natasa_kruta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106878226982830764063/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natasa Timotijevic', 'https://lh3.googleusercontent.com/a-/ALV-UjWdy2YeSmR-ZnpTXdj9wT_bqhFNyHQcKpZ94r1i4kBaV_1--zYv=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114457723821197362979/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114457723821197362979/reviews');
SET @user_natasa_timotijevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114457723821197362979/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Peric', 'https://lh3.googleusercontent.com/a-/ALV-UjUWYuul-Z4Zb94L6XVTCpbK42n23Nah9la0hU-xf829FAZcDel_=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115851262548303695932/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115851262548303695932/reviews');
SET @user_ana_peric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115851262548303695932/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'lia mjau', 'https://lh3.googleusercontent.com/a/ACg8ocLLEqC4DK7M9D4LKnzSszKW2L8s6MT0LKRhVh8aiQEjtxFEhg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101923972795940972262/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101923972795940972262/reviews');
SET @user_lia_mjau = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101923972795940972262/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Samardzic', 'https://lh3.googleusercontent.com/a-/ALV-UjV35-dDwU48Q22e6qPeda6YOCt-Afk_Ws3SVFISrV6IVNHZ-KIU=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115050148368665543916/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115050148368665543916/reviews');
SET @user_jovana_samardzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115050148368665543916/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Živaljević', 'https://lh3.googleusercontent.com/a-/ALV-UjXymNkqt3nyTnb52Lzv5KPYwQJHpEoJ9bBn6sYwC0in-EpK2W-GQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116391967031793230689/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116391967031793230689/reviews');
SET @user_milica_ivaljevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116391967031793230689/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Magdalena Minić', 'https://lh3.googleusercontent.com/a/ACg8ocIoJO6NNntE9sMFrsuQ7SClBFYF4LONGCwF0bxX-mjeIMPCwQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104515803006276419053/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104515803006276419053/reviews');
SET @user_magdalena_mini = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104515803006276419053/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladenka Lazarevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXW_1UuxrXMWGOhNhR2hApr-3DbFAPxJd1Ew_AIrL2oPuCNA6Y=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113206286899221905721/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113206286899221905721/reviews');
SET @user_mladenka_lazarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113206286899221905721/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dolores Orlando', 'https://lh3.googleusercontent.com/a/ACg8ocIGG8lPwkJUB7iJxm3l4j2mWa_bhwnkD9pWH15sbMwkgfOlrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117730573765446494855/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117730573765446494855/reviews');
SET @user_dolores_orlando = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117730573765446494855/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andja Trninic', 'https://lh3.googleusercontent.com/a/ACg8ocKsqvnpy5ZTy-wlEpMhnWCFmfcMsK55Gqh3vox1H5DGEWyzWA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112646865835268376751/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112646865835268376751/reviews');
SET @user_andja_trninic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112646865835268376751/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marina Sarenac', 'https://lh3.googleusercontent.com/a/ACg8ocKdqo3dPKQZvguchv7Av2dcm04HHHs4-htmqUUcL1sQHrS8kg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113541177723736492471/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113541177723736492471/reviews');
SET @user_marina_sarenac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113541177723736492471/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrea Vulevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUa7BlPfJAQMkdTpSsEbBHIn_lyyVpSzXjtkINbDTGh4iAhg1nj=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117239826012099775178/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117239826012099775178/reviews');
SET @user_andrea_vulevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117239826012099775178/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kety', 'https://lh3.googleusercontent.com/a/ACg8ocLmKA_k15IJYaRq-08diLyey5OUHIoUbbib-l66r1DqyNeVhA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110793609866715043006/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110793609866715043006/reviews');
SET @user_kety = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110793609866715043006/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Djuraskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXypwh40fmiJYC8zoCCF8tEYcE2fuVKebL26Ck7bICxsJJRR1rj=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110039362221580078964/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110039362221580078964/reviews');
SET @user_dijana_djuraskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110039362221580078964/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Madzarevic', 'https://lh3.googleusercontent.com/a/ACg8ocJ7jhcGn7UjvkwRP0PjD1ES7DV8A6b2W7CsC7evRoNknAmUSg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106322761665042905212/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106322761665042905212/reviews');
SET @user_jelena_madzarevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106322761665042905212/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Лирика Карловна', 'https://lh3.googleusercontent.com/a/ACg8ocJ1S53a7ESwJVC-lC05kWcMetAOBiYJFaM68t-pT7ygzsAjVA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115237658300809808266/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115237658300809808266/reviews');
SET @user_lirika_karlovna = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115237658300809808266/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suzana Stanic', 'https://lh3.googleusercontent.com/a/ACg8ocJU28XeGSiSLVbZ5hf70mAtKbgD0EKbu2-2zWY4iBAraAHZpg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116044601278030902278/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116044601278030902278/reviews');
SET @user_suzana_stanic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116044601278030902278/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Vukovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVhHziKgbnG6wD2jwVsNoNqBbBIMDLHS-uG1TZ_ueQyuztts7cq=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107710609172477631257/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107710609172477631257/reviews');
SET @user_jelena_vukovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107710609172477631257/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marijana Kezija', 'https://lh3.googleusercontent.com/a/ACg8ocJ5LDN8FudrIvt2YCvkK4-EvS5U2Mqel2aQVetMgcr79LzCwQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104197219928872312180/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104197219928872312180/reviews');
SET @user_marijana_kezija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104197219928872312180/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Meri Zornija', 'https://lh3.googleusercontent.com/a-/ALV-UjUAHwphN6jbccAIjEAEyTltyTyPU5-EQfEQJ972H1V_wZxmxZK7DA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107921539148240424966/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107921539148240424966/reviews');
SET @user_meri_zornija = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107921539148240424966/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Artem Serhakov', 'https://lh3.googleusercontent.com/a-/ALV-UjUnsCOnkxtngOXjH0r-6eZCKkRPFyjjKJwzCkiiuts1v60_I5k=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111785323633222192135/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111785323633222192135/reviews');
SET @user_artem_serhakov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111785323633222192135/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_savovic_2, @clinic_id, @doctor_predrag_djurovic, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WQlYxSm9UVFZpVmxKUFRGZGFSVEF5YnpNd1MzYxAB',
    5, 'bs', 'Dr. Djurovic profesionalan,kao i sestre sto vas sacekaju.Pratio je trudnocu mojoj supruzi do 6og mjeseca i uvjek bio spreman da pomogne u vezi svega.Mnogo prijatni ljudi.Necete cekati kad zakazete kao sto je slucaj u vecini klinika i Crnoj Gori.',
    'dr. Đurović je profesionalac, kao i sestre koje te čekaju. Pratio je trudnoću moje žene do 6. meseca i uvek je bio spreman da pomogne u svemu. Veoma prijatni ljudi. Nećete čekati kada zakažete, kao što je slučaj u većini klinika u Crnoj Gori.', 'др. Ђуровић је професионалац, као и сестре које те чекају. Пратио је трудноћу моје жене до 6. месеца и увек је био спреман да помогне у свему. Веома пријатни људи. Нећете чекати када закажете, као што је случај у већини клиника у Црној Гори.', NULL, NULL, NULL, NULL,
    0, '2025-12-03 06:38:59'),

(@user_dri, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUR2Z3Vub0JBEAE',
    5, 'hr', 'Veoma ljubazan doktor, maksimalno uslužan, sve jasno objašnjava čak i ako si stranac, jer on govori odlično i engleski. Izuzetno je ljubazan i strpljiv. Ordinacija je prijatna, čista i prostrana. Iskreno preporučujem. Ja ću se ovdje vraćati.',
    'Veoma ljubazan doktor, maksimalno uslužan, sve jasno objašnjava čak i ako si stranac, jer on govori odlično i engleski. Izuzetno je ljubazan i strpljiv. Ordinacija je prijatna, čista i prostrana. Iskreno preporučujem. Ja ću se ovdje vraćati.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-12-18 18:47:05'),

(@user_selen, @clinic_id, @doctor_predrag_djurovic, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNiaHVETHZRRRAB',
    5, 'en', 'Dr. Predrag is very professional, kind and nice person. He and his assistant can speaks English. They explain everything with a nice attitude. If you are tourist or expat you can trust him. Highly recommended.',
    'Dr Predrag je veoma profesionalan, ljubazan i prijatan čovek. On i njegova asistentkinja govore engleski. Sve objašnjavaju sa lepim stavom. Ako ste turista ili stranac, možete mu verovati. Toplo ga preporučujem.', 'Др Предраг је веома професионалан, љубазан и пријатан човек. Он и његова асистенткиња говоре енглески. Све објашњавају са лепим ставом. Ако сте туриста или странац, можете му веровати. Топло га препоручујем.', 'Dr. Predrag is very professional, kind and nice person. He and his assistant can speaks English. They explain everything with a nice attitude. If you are tourist or expat you can trust him. Highly recommended.', NULL, NULL, NULL,
    0, '2024-07-26 09:59:09'),

(@user_maya_pogosyan, @clinic_id, @doctor_predrag_djurovic, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwMXA3NWFBEAE',
    5, 'en', 'Dr. Predrag is the best! Very attentive, calm and professional. He speaks English perfectly and always makes sure to explain you every detail, showing great care. I had a great experience with this clinic, highly recommended.',
    'Dr Predrag je najbolji! Veoma pažljiv, smiren i profesionalan. Savršeno govori engleski i uvek se trudi da vam objasni svaki detalj, pokazujući veliku pažnju. Imao sam sjajno iskustvo sa ovom klinikom, toplo preporučujem.', 'Др Предраг је најбољи! Веома пажљив, смирен и професионалан. Савршено говори енглески и увек се труди да вам објасни сваки детаљ, показујући велику пажњу. Имао сам сјајно искуство са овом клиником, топло препоручујем.', 'Dr. Predrag is the best! Very attentive, calm and professional. He speaks English perfectly and always makes sure to explain you every detail, showing great care. I had a great experience with this clinic, highly recommended.', NULL, NULL, NULL,
    0, '2025-04-24 20:49:53'),

(@user_madina_karagoishina, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ3aG8yQlhBEAE',
    5, 'ru', 'Проходила 2 скрининг беременности в этой клинике.
Было очень волнительно и тревожно проходить этот опыт в другой стране. мы с мужем остались очень довольны, приятная, уютная атмосфера в клинике и очень профессиональные врачи. Очень подробно все объяснили, очень рады что выбрали именно эту клинику! + в копилку воспоминание об отпуске в Черногории. Спасибо за вашу работу! 🙏🏽❤️',
    'Drugi put sam imala pregled za trudnoću u ovoj klinici.
Bilo je i nervozno i uznemirujuće proći kroz ovo iskustvo u drugoj zemlji. Moj muž i ja smo bili veoma zadovoljni. Klinika je imala prijatnu, ugodnu atmosferu, a lekari su bili veoma profesionalni. Sve su objasnili veoma detaljno. Veoma smo srećni što smo izabrali ovu kliniku! Pored toga, to je divna uspomena na naš odmor u Crnoj Gori. Hvala vam na vašem trudu! 🙏🏽❤️', 'Други пут сам имала преглед за трудноћу у овој клиници.
Било је и нервозно и узнемирујуће проћи кроз ово искуство у другој земљи. Мој муж и ја смо били веома задовољни. Клиника је имала пријатну, угодну атмосферу, а лекари су били веома професионални. Све су објаснили веома детаљно. Веома смо срећни што смо изабрали ову клинику! Поред тога, то је дивна успомена на наш одмор у Црној Гори. Хвала вам на вашем труду! 🙏🏽❤️', NULL, 'Проходила 2 скрининг беременности в этой клинике.
Было очень волнительно и тревожно проходить этот опыт в другой стране. мы с мужем остались очень довольны, приятная, уютная атмосфера в клинике и очень профессиональные врачи. Очень подробно все объяснили, очень рады что выбрали именно эту клинику! + в копилку воспоминание об отпуске в Черногории. Спасибо за вашу работу! 🙏🏽❤️', NULL, NULL,
    0, '2024-08-23 20:20:14'),

(@user_michaela_miloevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ST1oybElhM0V0VmtsR1lUWnJZV001UTBreWNHYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_dingo_dingo, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwbGRVaFFiMVZ0YzNWaWJ6aDJURmRqZFZGM1FtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jelena_ivanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Vd1RrUXRVMDVSTjNOWmJrMWpOWGh3YXkwMlpuYxAB',
    5, 'bs', 'Sve ono što očekujete od dobrog ljekara — stručnost, pažnju, razumijevanje i ljudski pristup — ovdje ćete dobiti. Doktor uliva veliko povjerenje i zaista se posveti pacijentu.
Ordinacija je veoma čista i prijatna.
Sestra Danijela takodje izuzetno divna, susretljiva i srdačna.
Hvala na divnom odnosu i profesionalnosti. Sve preporuke 🫂',
    'Sve ono što očekujete od dobrog ljekara — stručnost, pažnju, razumijevanje i ljudski pristup — ovdje ćete dobiti. Doktor uliva veliko povjerenje i zaista se posveti pacijentu.
Ordinacija je veoma čista i prijatna.
Sestra Danijela takodje izuzetno divna, susretljiva i srdačna.
Hvala na divnom odnosu i profesionalnosti. Sve preporuke 🫂', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_nina, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t0TU5rTlFjRVJsVkdkUmIyRlBWV05uWTNSMFptYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_marija_stankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2toVlozVldObVY0V25OM2R6Tk9TM1JvVTNadGJVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_kristina_pavievi, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsdmVIWTRkVWQyYkU1d1ZHdG5hRTVpYUdOMFltYxAB',
    5, 'bs', 'Najbolji ginekolog ikada. Vec nekoliko godina idem kod njega, a sada mi je vodio i trudnocu do pred kraj. Profesionalnost, ljubaznost, smirenost,... ma sve na veoma visokom nivou',
    'Najbolji ginekolog ikada. Vec nekoliko godina idem kod njega, a sada mi je vodio i trudnocu do pred kraj. Profesionalnost, ljubaznost, smirenost,... ma sve na veoma visokom nivou', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_ana_milenkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2psRWRVRmhTRUZZVjJwcVlWOTVlVkkwTVRsQ2MyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_slaana, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT210cldrOUxiazFJVTFkTFdHMWpNMHRYTm1KTFVVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_teya_teya, @clinic_id, @doctor_predrag_djurovic, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCdWNHTm9OV1p6TFRCaVNtNDRXSGRLVmpKd1kxRRAB',
    5, 'bs', 'Peđa Đurović najbolji ginekolog u Boku Kotorsku, vrijedi svaku paru, opušten, profesionalan i strpljiv! Nije bilo uopšte neprijatno iskustvo kao što bude sa većinom naših ginekologa i akušera, pogotovo državnih',
    'Peđa Đurović najbolji ginekolog u Boku Kotorsku, vrijedi svaku paru, opušten, profesionalan i strpljiv! Nije bilo uopšte neprijatno iskustvo kao što bude sa većinom naših ginekologa i akušera, pogotovo državnih', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_milica_pocanic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poUkxVZG9Na2RqVlVWdE5EYzJSVGhIU3psalZVRRAB',
    5, 'hr', 'Veoma ljubazni!',
    'Veoma ljubazni!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dragana_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnTUNveUptd19nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sanja_bb, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURYbElPOFJ3EAE',
    5, 'bs', 'Doktor Ðurović je veoma pazljiv i ljubazan, a svojim velikim znanjem uliva 100% poverenje. Ni za živu glavu ne idem kod drugih!!😉',
    'Doktor Ðurović je veoma pazljiv i ljubazan, a svojim velikim znanjem uliva 100% poverenje. Ni za živu glavu ne idem kod drugih!!😉', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_kristina_eevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3NmNLQ0Z3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_anja_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURycmRuUDN3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dragana_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURyaFlqRTR3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_natasa, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURyc3EtMkRREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_ivana_janovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNUcWEtT0ZBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_alea_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURqckxiQWNBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_maja_savic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURENU0zeklREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nina_pavlovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUQxcUtXSHR3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_marijana_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUMxcHFiYTRRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_jasmina, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURabDc2WGFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_sonja_radonjic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURwdmFYZ0NREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_kristina_radonjic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURwdmZtdzRBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_andrea_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURwNmFfWEl3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_aida_khubaeva, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURwc0pHQXdnRRAB',
    5, 'ru', 'Это самый лучший гинеколог, у которого я была, а у кого я только ни была, и в разных клиниках. Не задавал идиотских вопросов по типу: а почему не рожаем? Часики то тикают! И не давал неуместных и мягко говоря непрофессиональных советов вроде: надо рожать и вообще больше проблем не будет ни с кистами, ни с болями во время месячных. Был крайне аккуратен, что тоже редкость. Четко, быстро и ничего лишнего.',
    NULL, NULL, NULL, 'Это самый лучший гинеколог, у которого я была, а у кого я только ни была, и в разных клиниках. Не задавал идиотских вопросов по типу: а почему не рожаем? Часики то тикают! И не давал неуместных и мягко говоря непрофессиональных советов вроде: надо рожать и вообще больше проблем не будет ни с кистами, ни с болями во время месячных. Был крайне аккуратен, что тоже редкость. Четко, быстро и ничего лишнего.', NULL, NULL,
    4, '2023-10-29 00:00:00'),

(@user_irina_t, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwNl9McmN3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_sladjana_b, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNwbzl6Umx3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_ana_kolak, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwcWVtdklnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_theo_known_as_ellen, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNKOFBlTjJ3RRAB',
    5, 'en', 'Great experience! Very professional, considerate doctor, who explains everything calmly, and confidently and is easy to understand. The assistant is very nice too.',
    NULL, NULL, 'Great experience! Very professional, considerate doctor, who explains everything calmly, and confidently and is easy to understand. The assistant is very nice too.', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_polina_lazareva, @clinic_id, @doctor_predrag_djurovic, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4NjRUdmZnEAE',
    5, 'ru', 'Приятный, рассудительный доктор Джурович. Говорит по-английски. Мы поняли друг друга. Доктор очень аккуратный, бережный, проводит осмотр максимально комфортно. Спасибо что вы есть!❤️',
    NULL, NULL, NULL, 'Приятный, рассудительный доктор Джурович. Говорит по-английски. Мы поняли друг друга. Доктор очень аккуратный, бережный, проводит осмотр максимально комфортно. Спасибо что вы есть!❤️', NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_irina_grgurevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4clAtMEdREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_maja_balic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUN4elBPUjdRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_mirjana_jancic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUN4ek03a0d3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_radovan_buric, @clinic_id, @doctor_predrag_djurovic, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURCdVliNGF3EAE',
    5, 'hr', 'Neverovatni ljudi!
Dr Predrag je predrag...izuzetno pazljiv,razumljiv i temeljit...Zbog njega nocas mirno spavam!',
    'Neverovatni ljudi!
Dr Predrag je predrag...izuzetno pazljiv,razumljiv i temeljit...Zbog njega nocas mirno spavam!', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_aleksandra_vuceljic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtaTUyeC1RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_margaux_schlosmacher, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtMzl1THBBRRAB',
    5, 'en', 'Very nice people. They took me earlier than expected and gave me all the explanations needed during my appointment. I recommend!',
    NULL, NULL, 'Very nice people. They took me earlier than expected and gave me all the explanations needed during my appointment. I recommend!', NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_kostiantyn_bukov, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURldWM2N3p3RRAB',
    5, 'ru', 'Приятная клиника, компетентный врач. Жена осталась довольна, спасибо',
    NULL, NULL, NULL, 'Приятная клиника, компетентный врач. Жена осталась довольна, спасибо', NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_ivana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNla2JxVk5BEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_milena_grbovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlcXB5VHdBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_icloud_iphone, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUR1My1fdXJ3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_stefani_s, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUR1M3YybU5REAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_yuliya_naumova, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUN1eXR2WjV3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_milena_rakicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNPaklpUWFnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_liki, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNXLWNpa0JnEAE',
    5, 'hr', 'Odli na klinika. Ljubazno osoblje. Pristupacni, sa osmjehom. Sve lijepo objasne',
    'Odli na klinika. Ljubazno osoblje. Pristupacni, sa osmjehom. Sve lijepo objasne', NULL, NULL, NULL, NULL, NULL,
    2, '2022-10-29 00:00:00'),

(@user_natasa_kruta, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNHMi1hVW9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_natasa_timotijevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNHMjV5cDJBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_ana_peric, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2d1ozell3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_lia_mjau, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURhc0xfeXZBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_jovana_samardzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNxX3VtQWd3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_milica_ivaljevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNLMVlpN053EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_magdalena_mini, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5LXM2YkF3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_mladenka_lazarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUN5OTczclNBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_dolores_orlando, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURpMmJ6d29nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_andja_trninic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUNpeDZmVURnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_marina_sarenac, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURjaW95aTN3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_andrea_vulevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURNdzZmVXVnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_kety, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUQwNk11dUd3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_dijana_djuraskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSUMwdlppdGVBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_jelena_madzarevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURVc3I2NF9nRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_lirika_karlovna, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNVaUpMVDFnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_suzana_stanic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURrczVEZzR3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_jelena_vukovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNvNGZmMjR3RRAB',
    5, 'en', 'Amazing hospital',
    NULL, NULL, 'Amazing hospital', NULL, NULL, NULL,
    0, '2019-10-29 00:00:00'),

(@user_marijana_kezija, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSURnaXFTZHhRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_meri_zornija, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNRcHBMdTlnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00'),

(@user_artem_serhakov, @clinic_id, NULL, 'google_maps',
    'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChZDSUhNMG9nS0VJQ0FnSURBODh2U2RnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2018-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJs2drV3kzTBMRGL56vSwCVSQ/reviews/ChdDSUhNMG9nS0VJQ0FnSUNiaHVETHZRRRAB'),
  'clinic', @clinic_id,
  'Thank you for the kind words, Selen! We’re glad you enjoyed your visit with us!', 'en',
  NULL, NULL, 'Thank you for the kind words, Selen! We’re glad you enjoyed your visit with us!', NULL, NULL, NULL,
  'google_maps', '2024-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
