-- Insert Google Maps reviews for Stomatološka ordinacija Stefanija Dental
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/stefanija-dental-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'stefanija-dental-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_stefanija_pantovic = (SELECT id FROM doctors WHERE slug = 'stefanija-pantovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Azra Deljanin', 'https://lh3.googleusercontent.com/a/ACg8ocKhNOsAnaBtr_lNgeNaO9ZH6FOYosWbDdkL66tq0c0d-0_GogA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102955291737818256019/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102955291737818256019/reviews');
SET @user_azra_deljanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102955291737818256019/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anna Dmitrieva', 'https://lh3.googleusercontent.com/a/ACg8ocKAgjjFcRPr9yyQvoC315XhkmYEGj0uF1XYS9qWTLZ0WFo1Iw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/117199482157579567472/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117199482157579567472/reviews');
SET @user_anna_dmitrieva = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117199482157579567472/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Milošević', 'https://lh3.googleusercontent.com/a/ACg8ocLSrXsjxwyxagiAr0H0NZd0fZmZy-nV6OjzgpvBSVPOPYKUAg=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114317228649465709101/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114317228649465709101/reviews');
SET @user_kristina_miloevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114317228649465709101/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bezz imeni', 'https://lh3.googleusercontent.com/a/ACg8ocJ51gUByICgGEgyb5pWvhqTuubF-dfmJpHG2kaUxQCHmDBI2w=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106598467592031165116/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106598467592031165116/reviews');
SET @user_bezz_imeni = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106598467592031165116/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Martin Leberle', 'https://lh3.googleusercontent.com/a-/ALV-UjXoL39E_huFlVemvi5_16uSMEvG5ScjkD6tmeYvk19aBKH4bEzh=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111706370377950704901/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111706370377950704901/reviews');
SET @user_martin_leberle = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111706370377950704901/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anđela Jakić', 'https://lh3.googleusercontent.com/a/ACg8ocLQ0xdtOMUKmYNCvhVVhOUD58D93Q1IlR9vL4zqxPDzYWkeKnY=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115914949004586413058/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115914949004586413058/reviews');
SET @user_anela_jaki = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115914949004586413058/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jason Wingo', 'https://lh3.googleusercontent.com/a/ACg8ocJGQnXuEOMvL7iVbHxAhs3Ny6tWtva9J91xBSMjATK-P4M26g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114594433783153010184/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114594433783153010184/reviews');
SET @user_jason_wingo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114594433783153010184/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Košuta', 'https://lh3.googleusercontent.com/a-/ALV-UjU7kv8ni0E27yS3eWA4vu0QILMpsUVcMkGxw7JAuml-iyDbJ-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107862420437044697307/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107862420437044697307/reviews');
SET @user_emir_kouta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107862420437044697307/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goran Pantovic', 'https://lh3.googleusercontent.com/a/ACg8ocI_Zcf5Qf3RE-i0xahczpJQQXugm--Q3_BEAbB1-YG4Tj2jZw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107288448017340426644/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107288448017340426644/reviews');
SET @user_goran_pantovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107288448017340426644/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katarina St', 'https://lh3.googleusercontent.com/a-/ALV-UjVpSm54LpfOpegSr3eW4fu2M_MfJ_i2d6AER-K9q3ui-YjYaJo7sA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104504997578561102499/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104504997578561102499/reviews');
SET @user_katarina_st = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104504997578561102499/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Popović', 'https://lh3.googleusercontent.com/a/ACg8ocIxjEwbrecUw_NMwPuNwV8chjWBgY1xUPIkym0YOfxgp5YqcA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117760416604243244336/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117760416604243244336/reviews');
SET @user_jelena_popovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117760416604243244336/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Khasrul Alam', 'https://lh3.googleusercontent.com/a-/ALV-UjX--UYtpA2SPHc4eKusiqgGnc6f_CeBvEoiACEtBmBpVxTzXArl=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110548126652318837835/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110548126652318837835/reviews');
SET @user_khasrul_alam = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110548126652318837835/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Savica Klikovac', 'https://lh3.googleusercontent.com/a/ACg8ocJxBr5iWCBV-3WGINJXigTOSG6YtiN0m8lNRu2vMQyH9GF1qOaA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114703158743501287700/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114703158743501287700/reviews');
SET @user_savica_klikovac = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114703158743501287700/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mijat Janjic', 'https://lh3.googleusercontent.com/a/ACg8ocJtrfz6AZkUfi0RbYkrDCGi_eJiEzkX0bLiZu7oBhGTI1vs3A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106614930105930000454/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106614930105930000454/reviews');
SET @user_mijat_janjic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106614930105930000454/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vladimir Dragovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUgwV20VftshTM3kURyJf9bDFgWQV_xPNUaVB7AY1SVR7WJUUNr=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/111655674773286091482/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111655674773286091482/reviews');
SET @user_vladimir_dragovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111655674773286091482/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mina Ivanović', 'https://lh3.googleusercontent.com/a/ACg8ocK2ukzkVtZlWhrZdUYRKqJ8PU2KvQ9baztyJz7qA9Xr9-4q0g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115709789491364587384/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115709789491364587384/reviews');
SET @user_mina_ivanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115709789491364587384/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'David Ivezic', 'https://lh3.googleusercontent.com/a/ACg8ocIDUYUU7SL9sOjqq00yazcT3jTIvovU0sAcT2euUh9Yox7uAg4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104150000521979030310/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104150000521979030310/reviews');
SET @user_david_ivezic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104150000521979030310/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'E.V', 'https://lh3.googleusercontent.com/a/ACg8ocJ_A09rCNI4tiD073r80vIA8YMtUpaxfdNwO_fNE6kC9R1R2qs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109144973015246503599/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109144973015246503599/reviews');
SET @user_ev = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109144973015246503599/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milan Stojanović', 'https://lh3.googleusercontent.com/a-/ALV-UjXzZPB1mTnAiSOpQLQAkSTmS5KgWTW63iDwSPm-YBBMUiZXxljE=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112975527586580668507/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112975527586580668507/reviews');
SET @user_milan_stojanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112975527586580668507/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Grba', 'https://lh3.googleusercontent.com/a-/ALV-UjVyS_wXSD3A4uBVYCB1Hl11mV_3rMx0IQnhYlEarhlLFTqrVgQO=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109232257741680259251/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109232257741680259251/reviews');
SET @user_ana_grba = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109232257741680259251/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrijana Djokic', 'https://lh3.googleusercontent.com/a/ACg8ocKnwxr1TBIrTSFK3apTQHeLrV20z2I47xL6dtmr2uVp_jBcxw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102721251570163881703/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102721251570163881703/reviews');
SET @user_andrijana_djokic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102721251570163881703/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Vratnica', 'https://lh3.googleusercontent.com/a/ACg8ocJVu7mZdrii45lPE7kSP3XpHRPx3HOg3L9NDHusPML73wvfrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108323294897445088468/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108323294897445088468/reviews');
SET @user_jelena_vratnica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108323294897445088468/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Pajović', 'https://lh3.googleusercontent.com/a/ACg8ocI2dndYJIehPNCsqAtdKfMUDwbJg3tqCULhuViBdTXDqRJPsg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112822503311345008286/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112822503311345008286/reviews');
SET @user_nina_pajovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112822503311345008286/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Jovanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXDn87TA8P5CAy7FKjIRUxPtc9Q3-myBD1OsAg393lR1BiIcHB_=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112967621779585174782/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112967621779585174782/reviews');
SET @user_mirjana_jovanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112967621779585174782/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'A&N', 'https://lh3.googleusercontent.com/a/ACg8ocIoLOO93UxcYuFOZQVA12mSRX5NlQA8OVb_J1jbhMyYdNx-Lg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117154000199424634848/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117154000199424634848/reviews');
SET @user_an = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117154000199424634848/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Simonovic', 'https://lh3.googleusercontent.com/a/ACg8ocLkmTrwGr3oyZyi9jDdkGtsJzFJSc0R82BomWNWnUbDotUlHA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113129856177878766773/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113129856177878766773/reviews');
SET @user_aleksandra_simonovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113129856177878766773/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tamara Campar', 'https://lh3.googleusercontent.com/a-/ALV-UjWEePdok_WZDUpXPc1uaeX66hvHcCO39TKAfGjR2l_a3nW94L6a=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102699088273947548749/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102699088273947548749/reviews');
SET @user_tamara_campar = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102699088273947548749/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Map Бу', 'https://lh3.googleusercontent.com/a/ACg8ocISeUSNJfxC4of6oSEcMVouiApMnEl0KNZ22hxn3H7XMZFIYQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113033447235492989855/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113033447235492989855/reviews');
SET @user_map_bu = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113033447235492989855/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Srba Veljic', 'https://lh3.googleusercontent.com/a/ACg8ocLPvsZbsD9s24aVZFWFQNSiXuR9GuwLof0-hJpTy8TX2pjVhQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116864257020467546764/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116864257020467546764/reviews');
SET @user_srba_veljic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116864257020467546764/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Savovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWsv7qaWnf70DiMWVkTDNnIVlDojTWzBIbZaZfG3DYDgnkwAcxx=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116724406344705131123/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116724406344705131123/reviews');
SET @user_milos_savovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116724406344705131123/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milos Novakovic', 'https://lh3.googleusercontent.com/a/ACg8ocKJ_1IGioVE_L1jgFyGvw1l1RWoe2YeogHsduPlWWu-4EL8XQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111074444358409856260/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111074444358409856260/reviews');
SET @user_milos_novakovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111074444358409856260/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katarina Bojović', 'https://lh3.googleusercontent.com/a/ACg8ocI-EQaF5j4ZJz9zGh7VaetaAi6Y5aqhBnTYxv0Tp0Xl4HtaAg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103190113602917191154/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103190113602917191154/reviews');
SET @user_katarina_bojovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103190113602917191154/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'kocka dragana', 'https://lh3.googleusercontent.com/a-/ALV-UjUCtuMUUsacUAwgLzxI8Rgy3mYJ2q0HPyPg6HZ8f-Ou97JKPdAJ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108334272592432968488/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108334272592432968488/reviews');
SET @user_kocka_dragana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108334272592432968488/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stevica Radosavovic', 'https://lh3.googleusercontent.com/a/ACg8ocKRHleMg-JOx9MG_tc35Zqhz-9xgI3PKWo0bzGcQ7FgRejRfw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108318836456892893011/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108318836456892893011/reviews');
SET @user_stevica_radosavovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108318836456892893011/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radmila Srzentic', 'https://lh3.googleusercontent.com/a/ACg8ocL5j9LXv135FN62X5igUVQ21731dalhur9T24gRi6ujQF7gJQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113186881538161454603/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113186881538161454603/reviews');
SET @user_radmila_srzentic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113186881538161454603/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Karadzic', 'https://lh3.googleusercontent.com/a/ACg8ocLO_ggCLAKJGfsg5PdvQ-uourJIUq7IoK7m3gOgpZXkV6No8w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101282455232812463139/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101282455232812463139/reviews');
SET @user_jelena_karadzic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101282455232812463139/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Karadzic', 'https://lh3.googleusercontent.com/a/ACg8ocJQB90hjFEyx7wXOkK_7MR0lUdvCRQHdt3YHHprD2n3BFq9qg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114851270841639626867/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114851270841639626867/reviews');
SET @user_jelena_karadzic_2 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114851270841639626867/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pharmacy Corner', 'https://lh3.googleusercontent.com/a/ACg8ocL3CWQ0OmCqlZLeahSx9i-SDfMo4PUWqi9qymCvOm2o6TOmkw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115633010069210590199/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115633010069210590199/reviews');
SET @user_pharmacy_corner = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115633010069210590199/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anica Đurišić', 'https://lh3.googleusercontent.com/a-/ALV-UjWV5bWI34Y3MogNFGEiBmJeCbc3mPJVxd04RTDEcDj_XWR5_JMf8w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102097622736060910773/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102097622736060910773/reviews');
SET @user_anica_urii = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102097622736060910773/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Pejovic', 'https://lh3.googleusercontent.com/a/ACg8ocIom3Xauqt4LamEk2bxOKr7TV6QsbIqHPBpsDpz0GJOktqc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117127060420422219880/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117127060420422219880/reviews');
SET @user_jovana_pejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117127060420422219880/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Nikcevic', 'https://lh3.googleusercontent.com/a-/ALV-UjXvHpHKMN0oRKbsQb9RzN85pUxbMEvIpQHgoDjUD5UjJ5k9Q5JC=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111755497884357011089/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111755497884357011089/reviews');
SET @user_jovana_nikcevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111755497884357011089/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dina Zejnilovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWSq3d4sdEvub7qmrOGP0OQEag5HN_rss_TmkdcARxL5af3Lr4=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103449401557455809571/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103449401557455809571/reviews');
SET @user_dina_zejnilovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103449401557455809571/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katarina Bucin', 'https://lh3.googleusercontent.com/a-/ALV-UjWRvMt-fVfHehs26Nh3I_3N9JXdZSLhQqdb0jTxAO1Xu0CJ30E=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105389771044215375736/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105389771044215375736/reviews');
SET @user_katarina_bucin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105389771044215375736/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Anastasija Perunicic', 'https://lh3.googleusercontent.com/a/ACg8ocIRm5fVVCwZrizjXlvP1jQQgl595y0yx1IlRmAxiy7u_iYmag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101589845029496671603/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101589845029496671603/reviews');
SET @user_anastasija_perunicic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101589845029496671603/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vilko Mulic', 'https://lh3.googleusercontent.com/a-/ALV-UjWYgsA1O2Z2m4wPhL2IedGLmPy2GqU1X0I89W5bcWRfrvmFhqA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109761996598005071203/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109761996598005071203/reviews');
SET @user_vilko_mulic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109761996598005071203/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'J Милош', 'https://lh3.googleusercontent.com/a/ACg8ocJsPbHuza1d40VfUNc3Si90CwZ4TO11LDV3SZ1zAXWqe5CDew=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110622287129895897934/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110622287129895897934/reviews');
SET @user_j_milosh = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110622287129895897934/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dijana Pantovic - Jekic', 'https://lh3.googleusercontent.com/a-/ALV-UjW4YcF4pS5YoAAfwG3wAOQlrEWX0FnlHXWTwMlGH_b7BldutsH7=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116130745797152040080/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116130745797152040080/reviews');
SET @user_dijana_pantovic_jekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116130745797152040080/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirko Pantovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVwrFZ_ZjKEjS_HgY_Sn3PGaanYO9jxWXvSLO0AkJMlYdeg3Ky-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107055931837175765444/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107055931837175765444/reviews');
SET @user_mirko_pantovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107055931837175765444/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_azra_deljanin, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kRVYwcE5lVVYwU1Y5MmFWRjVkVzB3ZEdGMVRuYxAB',
    5, 'hr', 'Prošle godine, u trenutku kada mi je bila potrebna hitna  pomoć, dr Stefanija je reagovala brzo, pažljivo i s izuzetnom posvećenošću. U vrlo kratkom roku pronašla je rješenje koje mi je vratilo osjećaj sigurnosti i mira. To iskustvo mi je potvrdilo ne samo njenu stručnost, već i koliko joj je istinski stalo do dobrobiti svakog pacijenta.

U svakom koraku pristupa s pažnjom, strpljenjem i iskrenom željom da postigne najbolji mogući rezultat. Dr Stefanija je izuzetno nježna u radu, temeljna, precizna i uvijek realna u procjeni. Stvara atmosferu povjerenja u kojoj se sve obavlja bez žurbe i bez stresa, što za pacijenta znači zaista mnogo.

Zato od srca preporučujem dr Stefaniju svima koji žele vrhunski stomatološki tretman, profesionalnost, kao i toplinu u pristupu. Hvala Vam na svemu do sada — i radujem se našem finalnom rezultatu.

🦋🐦‍🔥',
    'Prošle godine, kada mi je bila potrebna hitna pomoć, dr Stefanija je reagovala brzo, pažljivo i sa izuzetnom posvećenošću. Za vrlo kratko vreme našla je rešenje koje mi je vratilo osećaj sigurnosti i mira. To iskustvo je potvrdilo ne samo njenu stručnost, već i koliko joj je zaista stalo do dobrobiti svakog pacijenta.

Svakom koraku pristupa sa pažnjom, strpljenjem i iskrenom željom da postigne što bolji rezultat. Dr Stefanija je izuzetno nežna u poslu, temeljna, precizna i uvek realna u proceni. Ona stvara atmosferu poverenja u kojoj se sve radi bez žurbe i stresa, što pacijentu mnogo znači.

Zato od srca preporučujem dr Stefaniju svima koji žele vrhunski stomatološki tretman, profesionalnost i toplinu u njenom pristupu. Hvala vam na svemu do sada — i radujem se našem konačnom rezultatu.

🦋🐦‍🔥', 'Прошле године, када ми је била потребна хитна помоћ, др Стефанија је реаговала брзо, пажљиво и са изузетном посвећеношћу. За врло кратко време нашла је решење које ми је вратило осећај сигурности и мира. То искуство је потврдило не само њену стручност, већ и колико јој је заиста стало до добробити сваког пацијента.

Сваком кораку приступа са пажњом, стрпљењем и искреном жељом да постигне што бољи резултат. Др Стефанија је изузетно нежна у послу, темељна, прецизна и увек реална у процени. Она ствара атмосферу поверења у којој се све ради без журбе и стреса, што пацијенту много значи.

Зато од срца препоручујем др Стефанију свима који желе врхунски стоматолошки третман, професионалност и топлину у њеном приступу. Хвала вам на свему до сада — и радујем се нашем коначном резултату.

🦋🐦‍🔥', NULL, NULL, NULL, NULL,
    0, '2025-11-29 12:24:38'),

(@user_anna_dmitrieva, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsV1Ztc3pUa0pUYVU4eVZESm1NM296TmxGdmExRRAB',
    5, 'en', 'I\'m so happy I found Stefanija. She\'s truly a gifted doctor. Smart, beautiful, talented, very sensitive, and meticulous. Her professionalism is so profound that I\'m truly impressed. She\'ll put any anxious person at ease. And since I still have a lot of dental work to do, I\'m really looking forward to my next visit with Stefanija ❤️',
    'Tako sam srećan što sam našao Stefaniju. Ona je zaista nadaren doktor. Pametan, lep, talentovan, veoma osetljiv i pedantan. Njen profesionalizam je toliko dubok da sam zaista impresioniran. Ona će smiriti svaku zabrinutu osobu. A pošto me čeka još dosta stomatoloških poslova, zaista se radujem sledećoj poseti Stefaniji ❤', 'Тако сам срећан што сам нашао Стефанију. Она је заиста надарен доктор. Паметан, леп, талентован, веома осетљив и педантан. Њен професионализам је толико дубок да сам заиста импресиониран. Она ће смирити сваку забринуту особу. А пошто ме чека још доста стоматолошких послова, заиста се радујем следећој посети Стефанији ❤', 'I\'m so happy I found Stefanija. She\'s truly a gifted doctor. Smart, beautiful, talented, very sensitive, and meticulous. Her professionalism is so profound that I\'m truly impressed. She\'ll put any anxious person at ease. And since I still have a lot of dental work to do, I\'m really looking forward to my next visit with Stefanija ❤️', NULL, NULL, NULL,
    0, '2025-10-17 08:25:56'),

(@user_kristina_miloevi, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOdVVWbHVUR2xzVVhkaWRrTlBjMHBaYkZWS1ZYYxAB',
    5, 'en', 'I’m really happy with my experience with Dr. Stefanija. From the very first visit, everything was clearly explained. She showed me every step, suggested the best option, and the whole aligners treatment went smoothly. Dr. Stefanija is extremely professional, attentive to detail, and genuinely kind. Truly a great experience!',
    'Zaista sam zadovoljna svojim iskustvom sa dr Stefanijom. Od prve posete sve je bilo jasno objašnjeno. Pokazala mi je svaki korak, predložila najbolju opciju i ceo tretman alajnerima je prošao bez problema. Dr Stefanija je izuzetno profesionalna, pažljiva prema detaljima i iskreno ljubazna. Zaista sjajno iskustvo!', 'Заиста сам задовољна својим искуством са др Стефанијом. Од прве посете све је било јасно објашњено. Показала ми је сваки корак, предложила најбољу опцију и цео третман алајнерима је прошао без проблема. Др Стефанија је изузетно професионална, пажљива према детаљима и искрено љубазна. Заиста сјајно искуство!', 'I’m really happy with my experience with Dr. Stefanija. From the very first visit, everything was clearly explained. She showed me every step, suggested the best option, and the whole aligners treatment went smoothly. Dr. Stefanija is extremely professional, attentive to detail, and genuinely kind. Truly a great experience!', NULL, NULL, NULL,
    0, '2025-11-12 15:41:29'),

(@user_bezz_imeni, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5NloydHhZMmx5YTAxbFJ6RjNkRVZRVEZSMFRsRRAB',
    5, 'bs', 'Dr. Stefanija pokazuje visok nivo stručnosti i posvećenosti pacijentima. Dolazak kod nje iz drugog grada nije cimanje već zadovoljstvo. Njena preciznost, komunikacija i pažnja prema najsitnijim detaljima ulivaju poverenje. Topla preporuka svima koji traže pouzdanog stomatologa, a moj je od 2018 godine 🤗',
    'Dr Stefanija pokazuje visok nivo stručnosti i posvećenosti svojim pacijentima. Dolazak kod nje iz drugog grada nije muka, već zadovoljstvo. Njena preciznost, komunikativnost i pažnja do najsitnijih detalja ulivaju poverenje. Toplo preporučujem svima koji traže pouzdanog stomatologa, a ona je moja od 2018. 🤗', 'Др Стефанија показује висок ниво стручности и посвећености својим пацијентима. Долазак код ње из другог града није мука, већ задовољство. Њена прецизност, комуникативност и пажња до најситнијих детаља уливају поверење. Топло препоручујем свима који траже поузданог стоматолога, а она је моја од 2018. 🤗', NULL, NULL, NULL, NULL,
    0, '2025-10-17 10:23:05'),

(@user_martin_leberle, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT21rMlJFVkpNWFV5TnpOcFNVUlFjRkJoVDJWSE5HYxAB',
    5, 'en', 'I am a big macho hero, but not on the chair at the dentist ;-) But Dr. Stefanija gave me from first second the feeling of professionalism, trust and competence. My total make-over took 2-3 month, without a single painful moment and with an excellent result. Hvala, Dr. Stefanija!',
    'Ja sam veliki mačo heroj, ali ne na stolici kod zubara ;-) Ali dr Stefanija mi je od prve sekunde pružila osećaj profesionalizma, poverenja i kompetentnosti. Moj totalni make-over trajao je 2-3 meseca, bez ijednog bolnog trenutka i sa odličnim rezultatom. Hvala dr Stefanija!', 'Ја сам велики мачо херој, али не на столици код зубара ;-) Али др Стефанија ми је од прве секунде пружила осећај професионализма, поверења и компетентности. Мој тотални маке-овер трајао је 2-3 месеца, без иједног болног тренутка и са одличним резултатом. Хвала др Стефанија!', 'I am a big macho hero, but not on the chair at the dentist ;-) But Dr. Stefanija gave me from first second the feeling of professionalism, trust and competence. My total make-over took 2-3 month, without a single painful moment and with an excellent result. Hvala, Dr. Stefanija!', NULL, NULL, NULL,
    0, '2025-10-19 16:46:47'),

(@user_anela_jaki, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WMlNXdEllV0pKVW5NdGVERkRiVFF4ZEVwSVYyYxAB',
    5, 'hr', 'Kvalitet i usluga srazmjerni znanju i posvećenosti!',
    'Kvalitet i usluga srazmjerni znanju i posvećenosti!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-22 00:00:00'),

(@user_jason_wingo, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sweVF6Vm1RUzF0ZW5CalVGTTFOekJrZFcxWlJtYxAB',
    5, 'en', 'Dr Stefanija Pantovic is an amazing dentist and is truly skilled at her craft and is very professional. She takes the time to explain everything to the patient and is meticulous when it comes to getting things done correctly. I went to her for cleanings, fillings and crowns and could not be happier with the work that she did and the service that I received. I would recommend Dr Stefanija Pantovic to anyone in Podgorica that is looking for a dentist.',
    NULL, NULL, 'Dr Stefanija Pantovic is an amazing dentist and is truly skilled at her craft and is very professional. She takes the time to explain everything to the patient and is meticulous when it comes to getting things done correctly. I went to her for cleanings, fillings and crowns and could not be happier with the work that she did and the service that I received. I would recommend Dr Stefanija Pantovic to anyone in Podgorica that is looking for a dentist.', NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_emir_kouta, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT214aFZ6QjBVRUYzYmxJd1dscHVSV0YxWldGMWVuYxAB',
    5, 'bs', 'Profesionalna usluga, prijateljsko okruzenje 🙂',
    'Profesionalna usluga, prijateljsko okruzenje 🙂', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_goran_pantovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT210S09WUkNUVU5HWWpaME5IaEZabmhWYWxSWE0wRRAB',
    5, 'hr', '👌👌👌',
    '👌👌👌', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_katarina_st, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxbmRDMVBiVEpTU2sxSmFXaGthMHBOWWtkVlRXYxAB',
    5, 'bs', 'Dr Stefanija i njena medicinska sestra imaju savršen pristup pacijentu. Komunikacija, pažnja i posvećenost prisutne su sve vrijeme. Predivan ambijent i atmosfera u ordinaciji upotpunjuju iskustvo. Najiskrenije preporuke! 💕',
    'Dr Stefanija i njena medicinska sestra imaju savršen pristup pacijentu. Komunikacija, pažnja i posvećenost prisutne su sve vrijeme. Predivan ambijent i atmosfera u ordinaciji upotpunjuju iskustvo. Najiskrenije preporuke! 💕', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_jelena_popovi, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoMlZHOURUbU5LYVZrd2VGZGhaekphVTBjM2JIYxAB',
    5, 'lt', 'Best Stefanija !!!',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_khasrul_alam, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tocVZXRklXbEJEYW5aS1ptdEplRkpVTFdaNUxWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_savica_klikovac, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s5eGVXcGlZMmMxWm1aak9DMUVVMGhEZUV0VFNrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_mijat_janjic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OcGMzQk1hMUZ0UVRWNGVWSnBaVjlKTFMxNk1GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_vladimir_dragovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT21FM016WnFSRkZtYVZScWFuUkJUR1F0TTFKb2NHYxAB',
    5, 'hr', 'Mirna ruka. Prijatna atmosfera.',
    'Mirna ruka. Prijatna atmosfera.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_mina_ivanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2w5M1lrbGhZVkJuWW5SRFdFSjBhbXBsWlZCMVUxRRAB',
    5, 'hr', 'Profesionalnost, stručnost i posvećenost pacijentima na najvećem mogućem nivou!',
    'Profesionalnost, stručnost i posvećenost pacijentima na najvećem mogućem nivou!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_david_ivezic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsUFRXSm5XVlJIU2poMFFtVm1NM1I0ZERCalNtYxAB',
    5, 'bs', 'Odlična ordinacija, trude se maksimalno da pomognu pacijentima!',
    'Odlična ordinacija, trude se maksimalno da pomognu pacijentima!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_ev, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aMmJtcEVUbVI1ZURkMmFERjFORWRJVDNCaE9WRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_milan_stojanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oVmVrczBaRnBSUmxVNU5ITjNZbE00WTJkQkxVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-29 00:00:00'),

(@user_ana_grba, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pCcVQxTlNUa3hTTUhreVVHdEJUMHBaYm1Sc1puYxAB',
    5, 'hr', 'Sjajni 😊🥰',
    'Sjajni 😊🥰', NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_andrijana_djokic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCQk1GOWxlbGcyTVdSUloxWkVVR2hvT1Y5aVkwRRAB',
    5, 'en', 'The best 🌟',
    NULL, NULL, 'The best 🌟', NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_jelena_vratnica, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSbk1XeDRSVkl5WDBzd2EycFZTM2R5T1VaRWJHYxAB',
    5, 'en', 'The best ! ❤️',
    NULL, NULL, 'The best ! ❤️', NULL, NULL, NULL,
    0, '2025-12-29 00:00:00'),

(@user_nina_pajovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tvMU9Vc3hVSEJKVlZSMFIxaDZZVk5xU2twak9FRRAB',
    5, 'bs', 'Topla preporuka svima koji traže kvalitetnu stomatološku uslugu i tim koji zaista brine o svojim pacijentima!',
    'Topla preporuka svima koji traže kvalitetnu stomatološku uslugu i tim koji zaista brine o svojim pacijentima!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-29 00:00:00'),

(@user_mirjana_jovanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twWVVtNUllWHBxWDBsaVlVVmpUSFZMWDFNM2IyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_an, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT205M1pUWnhkRW93TVdocmNGODJSRFZVZEV0NFdtYxAB',
    5, 'hr', 'Preporuka od srca! Zaista zubar koji zna znanje! Radi sa velikom pažnjom i sigurnošću. Svaki zahvat izveden besprijekorno, uz maksimalnu posvećenost pacijentu. Sve pohvale!',
    'Preporuka od srca! Zaista zubar koji zna znanje! Radi sa velikom pažnjom i sigurnošću. Svaki zahvat izveden besprijekorno, uz maksimalnu posvećenost pacijentu. Sve pohvale!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aleksandra_simonovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWdmRua3lXVjloZFdwdFkyMTZUMnAxVWs4MGFtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_tamara_campar, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWQlZWVk5jV1JKTVdKWk5scHBNblJxUlVodlQzYxAB',
    5, 'en', 'If anyone is unsure which dentist to choose, Stefanija Dental is the right choice!
Kind, smiling, and professional 👏
She creates a warm atmosphere and has truly golden hands. 🦷💛',
    NULL, NULL, 'If anyone is unsure which dentist to choose, Stefanija Dental is the right choice!
Kind, smiling, and professional 👏
She creates a warm atmosphere and has truly golden hands. 🦷💛', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_map_bu, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkdFZEWkpibFZ4WDBrM1lUbEtUemR4TlZWSU5GRRAB',
    5, 'bs', 'Izuzetno profesionalna, ljubazna i pažljiva! Rad je precizan, bezbolan i kvalitetan. Svaka preporuka!',
    'Izuzetno profesionalna, ljubazna i pažljiva! Rad je precizan, bezbolan i kvalitetan. Svaka preporuka!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_srba_veljic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT214TFlsazVTa2hrWmxoMFIxUmZWWE5qYzJwMWEyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milos_savovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poU1puRlNUbUpLUXpJNGRtSnlXREJvZDFndFdIYxAB',
    5, 'bs', 'Vrlo profesionalni, ljubazni i temeljni. Preporučujem svakome ko traži kvalitetnu stomatološku uslugu!',
    'Vrlo profesionalni, ljubazni i temeljni. Preporučujem svakome ko traži kvalitetnu stomatološku uslugu!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_milos_novakovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxSlRqUktTbTUwUVdKRWVGSndOemhDZDI5dmVIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_katarina_bojovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT205b1N6Uk1ZMWh6UTBOTVdFSm1UVU53TUdOamVuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_kocka_dragana, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT214YWJ6Y3pNV3B2YkhkblJXZDNhVjlzYzNCR1YyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_stevica_radosavovic, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pBemNqTkxaVzFETVVNd1luWnpPSGxYUmpSMlpHYxAB',
    5, 'bs', 'Kod doktorke Stefanije sam se prvi put stvarno osećao potpuno sigurno na zubarskoj stolici. Njena preciznost, smirenost i profesionalan pristup su na vrhunskom nivou. Iako sam inače skeptičan kad su u pitanju lekari, kod nje sam imao osećaj da sam u pravim rukama – sve mi je objasnila jasno, bez žurbe i s mnogo strpljenja. Vidi se da voli to što radi. Za mene
top stomatolog. Iskreno preporučujem!',
    'Kod doktorke Stefanije sam se prvi put stvarno osećao potpuno sigurno na zubarskoj stolici. Njena preciznost, smirenost i profesionalan pristup su na vrhunskom nivou. Iako sam inače skeptičan kad su u pitanju lekari, kod nje sam imao osećaj da sam u pravim rukama – sve mi je objasnila jasno, bez žurbe i s mnogo strpljenja. Vidi se da voli to što radi. Za mene
top stomatolog. Iskreno preporučujem!', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_radmila_srzentic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT20xbE1HZE9VRUpuVFRWSVowVkRjRmxOY1Zsa0xXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_karadzic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xWU1gxODNSa05CTFV0YVZVVjRXV05EVERGdWRrRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jelena_karadzic_2, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT205WlNIbFdhRUYzT1UxcGJsTklSa0pUVWxoUVozYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_pharmacy_corner, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT25rNFVIUkhNMWh5WmxWUVFUZE5WRkZTWmprNFMxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anica_urii, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGVWQweEhabkV0VUVaQ05rYzNSalppUjJRdE1rRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_pejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT21RMVFXNXVNVzFPU1hWTFpEVm9MVk5CVG0xRWIyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jovana_nikcevic, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT21zeVpVTkJZa2RDV1cweVkyMUtWWGw1TjI5TU5rRRAB',
    5, 'it', 'I began my treatment with a basic dental check-up shortly after this clinic opened, and that’s when I met Dr. Stefanija Pantović – a young, highly dedicated and exceptionally professional dental specialist. Since then, years have passed, and now not only I, but also my family and friends trust her with all of our dental care.

Over time, I’ve had several procedures done: cavity fillings, replacing old fillings, and eventually I opted for a gum contouring procedure (professionally known as gingivectomy), which significantly enhanced my smile. After that, I also underwent professional in-office teeth whitening, with results that are still visible even two years later.

I truly recommend this clinic to everyone – whether you’re staying briefly in Podgorica or Montenegro, or if you’re in need of a trusted, long-term dentist.

Ho iniziato il mio trattamento con un semplice controllo odontoiatrico, poco dopo l’apertura di questo studio, ed è proprio in quell’occasione che ho conosciuto la dottoressa Stefanija Pantović – una giovane, eccezionalmente professionale e dedita specialista. Da allora, sono passati diversi anni e oggi non solo io, ma anche la mia famiglia e i miei amici ci affidiamo completamente alle sue cure.

Nel corso del tempo, ho effettuato diverse cure dentali, tra cui otturazioni e sostituzioni di vecchie amalgame. Successivamente, ho deciso di affrontare un intervento gengivale (chiamato in modo professionale “gengivectomia”), che mi ha permesso di migliorare l’estetica del sorriso. Dopo l’intervento, ho fatto anche lo sbiancamento dentale professionale in studio, il cui effetto è visibile anche a due anni di distanza.

Consiglio sinceramente questo studio a chiunque: sia a chi si trovi a Podgorica o in Montenegro per un breve periodo, sia a chi cerca un dentista affidabile e competente per cure a lungo termine.

Svoj tretman sam počela osnovnim stomatološkim pregledom odmah po otvaranju ove ordinacije, i tada sam upoznala doktoricu Stefaniju Pantović – mladu, izuzetno profesionalnu i posvećenu stomatološkinju. Danas, par godina kasnije, ne samo ja, već i moja porodica i prijatelji redovno dolazimo kod nje.

Tokom godina radila sam popravke zuba, zamjene starih plombi, a zatim sam se odlučila za lgingivektomiju, što mi je znatno poboljšalo izgled osmijeha. Nakon toga sam uradila i ordinacijsko izbijeljivanje zuba, čiji se efekat vidi i nakon dvije godine.

Iskreno preporučujem ovu ordinaciju svima, bilo da se kratko zadržavate u Podgorici ili Crnoj Gori, ili ako vam je potreban kvalitetan stomatolog na duže staze.',
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dina_zejnilovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xKdFFrRnVibXAwZWpWR2NHcHlaME42YjBVd09IYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_katarina_bucin, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oTVN6bEJhRjlSUzI5TWVWQnNSV3RqUWt0cE5VRRAB',
    5, 'hr', 'Tople preporuke za dr Stefaniju.
Veoma stručna, pažljiva i posvećena.Usluga je na visokom nivou, pristup pacijentu je divan – bez žurbe, bez stresa, sve lijepo objasni i tretman prođe lagano. Ordinacija odiše kvalitetom i povjerenjem.',
    'Tople preporuke za dr Stefaniju.
Veoma stručna, pažljiva i posvećena.Usluga je na visokom nivou, pristup pacijentu je divan – bez žurbe, bez stresa, sve lijepo objasni i tretman prođe lagano. Ordinacija odiše kvalitetom i povjerenjem.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_anastasija_perunicic, @clinic_id, @doctor_stefanija_pantovic, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/ChZDSUhNMG9nS0VJQ0FnTURJMG95d0x3EAE',
    5, 'hr', 'Profesionalna usluga, savremena oprema i izuzetno ljubazno osoblje. Dr Stefanija  je strpljiva, temeljna i uliva potpuno povjerenje,cijeli tretman je prošao bez stresa i bola. Hvala vam što ste mi vratili osmijeh!❤️',
    'Profesionalna usluga, savremena oprema i izuzetno ljubazno osoblje. Dr Stefanija  je strpljiva, temeljna i uliva potpuno povjerenje,cijeli tretman je prošao bez stresa i bola. Hvala vam što ste mi vratili osmijeh!❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vilko_mulic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4a2NYQkhVVTFQVWpObGNVVjBhRTVDTWpKNlYyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_j_milosh, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvdkx5ak9BEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_dijana_pantovic_jekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/ChZDSUhNMG9nS0VJQ0FnTURJc3BqSUR3EAE',
    5, 'bs', 'Doktorkin magicni osmeh , takve i stvara 🫶🏾',
    'Doktorkin magicni osmeh , takve i stvara 🫶🏾', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mirko_pantovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJGfZDbdTrTRMRgSNa8wqx50s/reviews/ChdDSUhNMG9nS0VJQ0FnSUNPNXRqai1BRRAB',
    5, 'en', 'Montenegro’s finest!',
    NULL, NULL, 'Montenegro’s finest!', NULL, NULL, NULL,
    0, '2022-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
