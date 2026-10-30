-- Insert Google Maps reviews for Stomatološka Ordinacija "Polident" Dom zdravlja Bijela
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/polident-bijela.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'polident-bijela');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_sandra_brkic = (SELECT id FROM doctors WHERE slug = 'sandra-brkic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Čedo Sladojević', 'https://lh3.googleusercontent.com/a-/ALV-UjVk523PqgxKghtBiDZUAo1YmVnXsm6WrifB9j5V8qB3Rd6Vir_Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118392211373202028190/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118392211373202028190/reviews');
SET @user_edo_sladojevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118392211373202028190/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luna Ivetic', 'https://lh3.googleusercontent.com/a-/ALV-UjWBwTHeRuAWqTpS0RbyMR0_gjyZ2ra8ChzHt0be-I8CO6hZfHC1=s128-c0x00000000-cc-rp-mo-ba5', 'https://www.google.com/maps/contrib/112246082313372295873/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112246082313372295873/reviews');
SET @user_luna_ivetic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112246082313372295873/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nermin Beslic', 'https://lh3.googleusercontent.com/a/ACg8ocK7Jz8aipkosenGodOrbUWtC5FNb9OmuXyy0jVtrAXOBuBhkQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100173692945476094921/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100173692945476094921/reviews');
SET @user_nermin_beslic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100173692945476094921/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pedja i Gaga', 'https://lh3.googleusercontent.com/a/ACg8ocLuYQOWGV1diDpO2R8XsmNc5uF1138laNjGxuedUxWtQKBqvQ=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/116671439612240773483/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116671439612240773483/reviews');
SET @user_pedja_i_gaga = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116671439612240773483/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olja Jegeš', 'https://lh3.googleusercontent.com/a-/ALV-UjUE5ZB3vb_R6JNIN086_1_yIwnxmX6O-8ti2ajtEFeAj5mwrQk=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/108478014992798900498/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108478014992798900498/reviews');
SET @user_olja_jege = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108478014992798900498/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Arina Serditova', 'https://lh3.googleusercontent.com/a/ACg8ocIP1M3iUlyF_at1cKqQCzvg66O7z26fhIHpPOSJzIdh0Ob_eQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106826993882633796850/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106826993882633796850/reviews');
SET @user_arina_serditova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106826993882633796850/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Majdov', 'https://lh3.googleusercontent.com/a/ACg8ocIVZT75G7Ka5Eb3Sog3jcZcarQtb5bTnjWb5snDgRAzH5-cZQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103139684904101785951/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103139684904101785951/reviews');
SET @user_dragana_majdov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103139684904101785951/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jakov Smoljan', 'https://lh3.googleusercontent.com/a/ACg8ocL22K0NAcszdVHPzKu_1SXjxPvI1C2ggeGSEuES3kH3eqW-v64=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113728398725860384100/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113728398725860384100/reviews');
SET @user_jakov_smoljan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113728398725860384100/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocKkDU3D-WoGMUQ5pf6lQuZYHKQbPdLqrTtRVqNihEPU2fmhHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106654463772928796522/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106654463772928796522/reviews');
SET @user_dragana_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106654463772928796522/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marie Dzananovic', 'https://lh3.googleusercontent.com/a/ACg8ocKeikJJNAIsOfk0D2j7DSOc2LI0-8RgZggLEXkj18VQzBBE5A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113484079073905892640/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113484079073905892640/reviews');
SET @user_marie_dzananovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113484079073905892640/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olja Milovanović', 'https://lh3.googleusercontent.com/a/ACg8ocJKvDSKgfa4lVTvisuCB78dR0XIld01i4Aa8u8cFG1BMjiPag=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108790829238301872822/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108790829238301872822/reviews');
SET @user_olja_milovanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108790829238301872822/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ertan sancak', 'https://lh3.googleusercontent.com/a-/ALV-UjVkUNFOmztGzQjQTBP4lCKeWMPCT1teNWsRkqcFTaGwSaiqyzw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/105609386700862346744/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105609386700862346744/reviews');
SET @user_ertan_sancak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105609386700862346744/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Snežana Milić', 'https://lh3.googleusercontent.com/a-/ALV-UjXzbiHFcGNf91fIwLmt-waxoZ6u6TYyrL5_MIBVb1oIYuECQ8f4CA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/109887372623437751613/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109887372623437751613/reviews');
SET @user_sneana_mili = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109887372623437751613/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Gordana Petrovic', 'https://lh3.googleusercontent.com/a/ACg8ocKUmnmDtwU6Q28QqD8uu4SAdDQmVm-e0-gTODMu-tITddHOkg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110400753919430260656/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110400753919430260656/reviews');
SET @user_gordana_petrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110400753919430260656/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aiym Bakytty', 'https://lh3.googleusercontent.com/a/ACg8ocKCzQiT9a7jJs_6qBqZQt_efj2EtGuBgHqu4efhikqL75PyMg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102513089639426552406/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102513089639426552406/reviews');
SET @user_aiym_bakytty = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102513089639426552406/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocK7xslS9Uwv-gv_cPRsV1tkSEF3cGufb3EVwaRh0fxKj-qhyVRu=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101947635261183200124/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101947635261183200124/reviews');
SET @user_luka_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101947635261183200124/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mladen Korlin', 'https://lh3.googleusercontent.com/a-/ALV-UjVBSZl6D4AmAoUUmH-MyTGAL1dq42dai_gLyC3r-DSYjCOlmfF0=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106603861556672919212/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106603861556672919212/reviews');
SET @user_mladen_korlin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106603861556672919212/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mirjana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocLDWKzqUl-ptkHRyfK7agEDPzs9oNxNFyMqimiiog8gJ_zVAQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100074610937760781901/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100074610937760781901/reviews');
SET @user_mirjana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100074610937760781901/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dragana Vlaovic', 'https://lh3.googleusercontent.com/a/ACg8ocKIwgdk2ve6VGm_n32qroPuepSApkEmnEu9S0fmlX3K7nY86g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108242897899736626780/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108242897899736626780/reviews');
SET @user_dragana_vlaovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108242897899736626780/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'sonja tds', 'https://lh3.googleusercontent.com/a/ACg8ocIWn_iQ0NDPEuzqf0-bWJCr54Z92EmTngW3Qma3gdWobCm1vg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111630208368136088498/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111630208368136088498/reviews');
SET @user_sonja_tds = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111630208368136088498/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nenad Tomic', 'https://lh3.googleusercontent.com/a/ACg8ocIg-FZfS6Xf2aFTBxCWyUEkE2b_AxFBpoH1tc7GLJplBVxoGQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116277070267347883891/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116277070267347883891/reviews');
SET @user_nenad_tomic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116277070267347883891/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tijana Miseljic', 'https://lh3.googleusercontent.com/a/ACg8ocJIS0TEBVh8BpBoigkgv9ptnCirArVguzvQX3bvIU_c78cE-Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105628006435119079772/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105628006435119079772/reviews');
SET @user_tijana_miseljic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105628006435119079772/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'vanja nuhefendic', 'https://lh3.googleusercontent.com/a/ACg8ocIpfI1r9x-Lob7FqX9QCj6e-W53m1l4xeO9tc9eXlJrk-bEQg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109417567019849666598/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109417567019849666598/reviews');
SET @user_vanja_nuhefendic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109417567019849666598/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Igi Bro', 'https://lh3.googleusercontent.com/a-/ALV-UjWxK1qhdKxiot07-YIJh2ZUOw0xVmrKyDKpnYN7vccb6nzv024a=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103179281300536255712/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103179281300536255712/reviews');
SET @user_igi_bro = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103179281300536255712/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Tomic', 'https://lh3.googleusercontent.com/a-/ALV-UjWg6t8TRv2vwg0IkyFyKQjedf-2d8KvscUcQodBqsVSWg3H99U=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100230928493069068607/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100230928493069068607/reviews');
SET @user_ivana_tomic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100230928493069068607/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjoo', 'https://lh3.googleusercontent.com/a-/ALV-UjW3_AWnILlxkX-FPXZY6zOPVQrsvNWhNy-m-2x_SBEVfyIApz-A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100636480182237670439/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100636480182237670439/reviews');
SET @user_sladjoo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100636480182237670439/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Damir Brkic', 'https://lh3.googleusercontent.com/a-/ALV-UjVfG4lwyVmu8X-UxUbXTKf5UAZ0ZThmJpyMVxI1sTHgDVw3NkDe=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117014772615666992826/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117014772615666992826/reviews');
SET @user_damir_brkic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117014772615666992826/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sladjana Asanovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXhfSorj2ItSaNwQCO-SA0Ew3JIIu5DIj8XLUUHPNMhV_tp7Iyz=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101024720390608761908/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101024720390608761908/reviews');
SET @user_sladjana_asanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101024720390608761908/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'bojana palevic', 'https://lh3.googleusercontent.com/a-/ALV-UjW46pbQ7jdaJ-k-C1JjuxaPxAu1bJGLgYAqhpTXdzvdggmnbrI=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105125297374279933443/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105125297374279933443/reviews');
SET @user_bojana_palevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105125297374279933443/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'danka miseljic', 'https://lh3.googleusercontent.com/a/ACg8ocKlAnlgcxg2AU_CAG7M_nHaoTwzc-QENyNcPHK6vIsvFYfQJg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113675226827104995819/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113675226827104995819/reviews');
SET @user_danka_miseljic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113675226827104995819/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'malisa rajak', 'https://lh3.googleusercontent.com/a/ACg8ocLlfAlkG4K86ZsMfcNHwPcdJpTbAaZK5XjtwBSP7l3ZVcqwgw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104488070056988805349/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104488070056988805349/reviews');
SET @user_malisa_rajak = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104488070056988805349/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Mijović', 'https://lh3.googleusercontent.com/a/ACg8ocJ_YPyht4Pl03DcENnASAUo3ytfBZixzKu5DWiRTUNCB2718w=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/102253891361743774826/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102253891361743774826/reviews');
SET @user_predrag_mijovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102253891361743774826/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Miriam K.', 'https://lh3.googleusercontent.com/a-/ALV-UjVmcW43sb-1v3rTg6k1BVtgN55xJQpxmxru3oFbBuYttETVrLPR=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107167231387629496100/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107167231387629496100/reviews');
SET @user_miriam_k = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107167231387629496100/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_edo_sladojevi, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSURibEk3TkxnEAE',
    5, 'sr', 'Ординација "Полидент" и др Сандра Бркић су за сваку похвалу. 👍
Осим што су чистоћа и хигијена на највишем нивоу приступ према сваком пацијенту је непосредан и пријатељски.
Др Сандра Бркић је својим радом и приступом успела да разбије мој страх од одласка код зубара. 🙂',
    'Ordinacija "Polident" i dr Sandra Brkić su za svaku pohvalu. 👍
Osim što su čistoća i higijena na najvišem nivou pristup prema svakom pacijentu je neposredan i prijateljski.
Dr Sandra Brkić je svojim radom i pristupom uspela da razbije moj strah od odlaska kod zubara. 🙂', 'Ординација "Полидент" и др Сандра Бркић су за сваку похвалу. 👍
Осим што су чистоћа и хигијена на највишем нивоу приступ према сваком пацијенту је непосредан и пријатељски.
Др Сандра Бркић је својим радом и приступом успела да разбије мој страх од одласка код зубара. 🙂', NULL, NULL, NULL, NULL,
    1, '2024-08-02 09:56:56'),

(@user_luna_ivetic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GWGVtUlVka3gxU1hSb1dHUmljRFUyUzFBM1RXYxAB',
    5, 'bs', 'Ja sam oduševljena ljubaznošću, profesionalnošću i toplinom koju doktorka nosi j sa kojom me je dočekala. Javila sam se u nedelju i u ponedeljak prepodne sam imala zub! U pitanju je bio lom jedinice. Ne verovatna je, svaka čast i beskrajno hvala!!!! U njenim rukama ste sigurni.',
    'Oduševljena sam ljubaznošću, profesionalizmom i toplinom koju doktorka nosi sa sobom i sa kojom me je dočekala. Pozvala sam u nedelju, a u ponedeljak ujutru mi je ispao zub! Bio je to polomljeni zub. To nije moguće, sve najbolje i beskrajno hvala!!!! U njenim rukama ste bezbedni.', 'Одушевљена сам љубазношћу, професионализмом и топлином коју докторка носи са собом и са којом ме је дочекала. Позвала сам у недељу, а у понедељак ујутру ми је испао зуб! Био је то поломљени зуб. То није могуће, све најбоље и бескрајно хвала!!!! У њеним рукама сте безбедни.', NULL, NULL, NULL, NULL,
    0, '2025-07-21 11:26:07'),

(@user_nermin_beslic, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWU1kwOXdRblV5ZEVkYWExWkdaMGwxWjNKclpWRRAB',
    5, 'hr', 'Nemam dovoljno riječi pohvale i preporuke za dr. Sandru Brkić! Kćerka je imala zubobolju i kontaktirali smo doktoricu, koja je na neradni dan, u subotu poslijepodne došla u ordinaciju i primila nas tako ljubazno i prijateljski kao da se to podrazumijeva. Nakon vrlo detaljnog pregleda ustanovila je problem i riješila ga jako temeljito i stručno. Čak je usput otklonila i neke sitne nedostatke besplatno! 😀
Zaista takav spoj ljubaznosti, neposrednosti i stručnosti se ne sreće često. Još jednom sve preporuke i veliko hvala!',
    'Ne mogu reći dovoljno dobrih stvari o dr Sandri Brkić! Ćerku je zaboleo zub i kontaktirali smo doktora, koji je došao u ordinaciju subotom popodne, neradnim danom, i primio nas tako ljubazno i prijateljski kao da se podrazumeva. Nakon veoma detaljnog pregleda, identifikovala je problem i veoma temeljno i profesionalno ga rešila. Čak je besplatno popravila neke manje nedostatke! 😀
Zaista ne nailazite često na takvu kombinaciju ljubaznosti, direktnosti i stručnosti. Još jednom, sve preporuke i puno hvala!', 'Не могу рећи довољно добрих ствари о др Сандри Бркић! Ћерку је заболео зуб и контактирали смо доктора, који је дошао у ординацију суботом поподне, нерадним даном, и примио нас тако љубазно и пријатељски као да се подразумева. Након веома детаљног прегледа, идентификовала је проблем и веома темељно и професионално га решила. Чак је бесплатно поправила неке мање недостатке! 😀
Заиста не наилазите често на такву комбинацију љубазности, директности и стручности. Још једном, све препоруке и пуно хвала!', NULL, NULL, NULL, NULL,
    0, '2025-08-12 12:39:21'),

(@user_pedja_i_gaga, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaQ2RrZGhkMlZIZURaYWVHVmhNMDF1WVV4QmQxRRAB',
    5, 'bs', 'Na letovanju u Baosicima u Crnoj Gori sam imala problem sa zubom koji me uzasno boleo a inace imam strah od zubara. Po preporuci sam otisla u Stomatolosku Ordinaciju "Polident" Dom zdravlja Bijela kod Doktorke SANDRE BRKIC kojoj moram da napisem ime velikim slovima zato sto je izuzetana doktorka stomatologije a pored toga sto je izuzetni strucnjak u svom poslu pre svega je jedan veliki veliki covek',
    'Dok sam bio na odmoru u Baošićima, u Crnoj Gori, imao sam problem sa zubom koji mi je izazivao strašne bolove, a obično se plašim zubara. Na osnovu preporuke, otišao sam u Stomatološku ordinaciju „Polident“ u Domu zdravlja Bijela, gde sam video dr SANDRU BRKIĆ, čije ime moram da napišem velikim slovima jer je izuzetan stomatolog i, pored toga što je izuzetan stručnjak u svojoj oblasti, pre svega je sjajna osoba.', 'Док сам био на одмору у Баошићима, у Црној Гори, имао сам проблем са зубом који ми је изазивао страшне болове, а обично се плашим зубара. На основу препоруке, отишао сам у Стоматолошку ординацију „Полидент“ у Дому здравља Бијела, где сам видео др САНДРУ БРКИЋ, чије име морам да напишем великим словима јер је изузетан стоматолог и, поред тога што је изузетан стручњак у својој области, пре свега је сјајна особа.', NULL, NULL, NULL, NULL,
    0, '2025-09-10 15:30:55'),

(@user_olja_jege, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT21OQmVuaDNhelpFUnpNeGMzZERRWEk0ZFRCTmMxRRAB',
    5, 'hr', 'Beskrajno hvala doktorki koja me je primila odmah nakon što sam objasnila svoj problem koji mi se desio na letovanju. Brzom intervencijom oslobodila me je bola i dala detaljna uputstva kako da se ponašam dok ne stignem kod stomatologa u svom gradu. Doktorka je prijatna, temeljna, stručna i neko ko očigledno voli ljude i svoj posao. Svaka preporuka! 🙂',
    'Veliko hvala doktorki koja me je primila odmah nakon što sam joj objasnila svoj problem koji mi se dogodio na odmoru. Brzom intervencijom, oslobodila me je bola i dala detaljna uputstva kako da se ponašam dok ne stignem kod zubara u mom gradu. Doktorka je prijatna, temeljna, profesionalna i neko ko očigledno voli ljude i svoj posao. Svaka preporuka! 🙂', 'Велико хвала докторки која ме је примила одмах након што сам јој објаснила свој проблем који ми се догодио на одмору. Брзом интервенцијом, ослободила ме је бола и дала детаљна упутства како да се понашам док не стигнем код зубара у мом граду. Докторка је пријатна, темељна, професионална и неко ко очигледно воли људе и свој посао. Свака препорука! 🙂', NULL, NULL, NULL, NULL,
    0, '2025-08-22 10:21:15'),

(@user_arina_serditova, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT25GdlduQXdTVXhxYlZRME5IWndMWE5EZWtKVE4wRRAB',
    5, 'ru', 'Это самая лучшая клиника в Черногории . Прекрасная Сандра мне вылечила зуб , когда другие стоматологи не хотели браться за лечение и сказали удалять . Весь процесс лечения доктор был со мной на связи , каждый этап в лечении она мне расписывала подробно и каждый раз делала рентген. Я не перестану благодарить эту клинику за спасенный зуб .  Спасибо всем сотрудникам этой стоматологии. ♥️♥️♥️',
    NULL, NULL, NULL, 'Это самая лучшая клиника в Черногории . Прекрасная Сандра мне вылечила зуб , когда другие стоматологи не хотели браться за лечение и сказали удалять . Весь процесс лечения доктор был со мной на связи , каждый этап в лечении она мне расписывала подробно и каждый раз делала рентген. Я не перестану благодарить эту клинику за спасенный зуб .  Спасибо всем сотрудникам этой стоматологии. ♥️♥️♥️', NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_dragana_majdov, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOUWMwODJTMGRWVm5Gb1YzcHlMVWhIWHkxWVkyYxAB',
    5, 'hr', 'Dr.Brkic izuzetno profesionalna,ljubazna,pristupacna.Sve pohvale i preporuke...',
    'Dr.Brkic izuzetno profesionalna,ljubazna,pristupacna.Sve pohvale i preporuke...', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_jakov_smoljan, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xGTVdYUXdXRVZOUVU5NWVFOW1WSGhVYlZOMGVFRRAB',
    1, 'bs', 'Pozdrav narode!
Osoba sam koja je u invalidskim kolicima vec nekoliko godina. Da skratim priču. Stomaltog po imenu  Sanadra Brkić iz Herceg Novog koja radi u domu zdravlja u Bijelu. Obratijo sam joj se po pitanju problema sa zubima.Rekla mi je da mogu da izvadim papir da troskove plati fond sto sam odradio jer sam u kolicima.Sve je ona mene fino primila i to sto ide ali sto se tice poravke zuba uništila mi je zub napravila dodatnu štetu.Prvo mi ga je plombirala jedan dan plomba nije stajala sedmice dana ispala prilikom pranja zuba.Zatim sam se obratio ponovo.( Požalio sam joj se da mi je na zub plomba ispla sto je ona kontrirala sa je tu imao sam blagu bol na zubu.. Zakazala mi je termin medjutim mi je rekla da je sve ok a kod mene drugi osjećaj jer plombe na zubu nije bilo. Tom prilikom mi je napravila još veću štetu na zubu koju sam morao da saniram negdje drugo oštetila zub namjerno a plombe nidje na vidiku nije bilo.) Napisao sam sa sam u invalidskim kolicima,što se mene tiče ako vam treba bilo kakva pomoć oko sanacije zuba idite negdje drugo . Moj savjet.
Srdačan pozdrav.',
    'Pozdrav narode!
Osoba sam koja je u invalidskim kolicima vec nekoliko godina. Da skratim priču. Stomaltog po imenu  Sanadra Brkić iz Herceg Novog koja radi u domu zdravlja u Bijelu. Obratijo sam joj se po pitanju problema sa zubima.Rekla mi je da mogu da izvadim papir da troskove plati fond sto sam odradio jer sam u kolicima.Sve je ona mene fino primila i to sto ide ali sto se tice poravke zuba uništila mi je zub napravila dodatnu štetu.Prvo mi ga je plombirala jedan dan plomba nije stajala sedmice dana ispala prilikom pranja zuba.Zatim sam se obratio ponovo.( Požalio sam joj se da mi je na zub plomba ispla sto je ona kontrirala sa je tu imao sam blagu bol na zubu.. Zakazala mi je termin medjutim mi je rekla da je sve ok a kod mene drugi osjećaj jer plombe na zubu nije bilo. Tom prilikom mi je napravila još veću štetu na zubu koju sam morao da saniram negdje drugo oštetila zub namjerno a plombe nidje na vidiku nije bilo.) Napisao sam sa sam u invalidskim kolicima,što se mene tiče ako vam treba bilo kakva pomoć oko sanacije zuba idite negdje drugo . Moj savjet.
Srdačan pozdrav.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-29 00:00:00'),

(@user_dragana_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsS1gzaFBOSE4xTVZnMmNrTllNV05yU2tZMFJWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_marie_dzananovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWSmFsQTJZemh4ZG5SSE5URkxMV0pmWW04Mk5uYxAB',
    5, 'bs', '⭐⭐⭐⭐⭐
Oduševljeni smo! Doktorka je ne samo izuzetno profesionalna, već i neverovatno ljubazna i pažljiva prema svojim pacijentima. Od samog početka osećate se sigurno i u dobrim rukama. Sve tretmane detaljno objašnjava i sprovodi ih sa puno strpljenja i razumevanja. Cene su više nego fer – prava retkost danas. Prezadovoljni smo i od srca je preporučujemo!

Hvala na svemu,
Milica Dzananovic',
    '⭐⭐⭐⭐⭐
Oduševljeni smo! Doktorka je ne samo izuzetno profesionalna, već i neverovatno ljubazna i pažljiva prema svojim pacijentima. Od samog početka osećate se sigurno i u dobrim rukama. Sve tretmane detaljno objašnjava i sprovodi ih sa puno strpljenja i razumevanja. Cene su više nego fer – prava retkost danas. Prezadovoljni smo i od srca je preporučujemo!

Hvala na svemu,
Milica Dzananovic', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_olja_milovanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT25nMFFUUXdjWGQyYkVWWGFVMW9ZM0kyV0VaTWJYYxAB',
    5, 'hr', 'Sve preporuke za divnu doktoricu.',
    'Sve preporuke za divnu doktoricu.', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_ertan_sancak, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tGVVNWbGFMVWxpYzIxUVIxTllaV1JrUVZWaWEzYxAB',
    5, 'en', 'On Sunday, my tooth broke and I contacted her. She gave me an appointment on Monday morning and treated me right away. Sandru Brkić is extremely warm, friendly, and reassuring. She explained every step in detail, which made me feel comfortable, and the treatment went very well. It’s clear that she truly loves her work. I can wholeheartedly recommend her.',
    NULL, NULL, 'On Sunday, my tooth broke and I contacted her. She gave me an appointment on Monday morning and treated me right away. Sandru Brkić is extremely warm, friendly, and reassuring. She explained every step in detail, which made me feel comfortable, and the treatment went very well. It’s clear that she truly loves her work. I can wholeheartedly recommend her.', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_sneana_mili, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4MFJqWnFRakJMWnpSS1pXTTVhM3BKZWtSdFJtYxAB',
    5, 'hr', 'Zaslužuje 10 ⭐️....',
    'Zaslužuje 10 ⭐️....', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_gordana_petrovic, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnTUN3alp5Y0RnEAE',
    5, 'bs', 'Bilo koja intervencija, uz zadovoljstvo! U Polident-u sa nasmejanom i dragom dr Sandrom 🙂. Provereno i preporuka od srca ! ❤️',
    'Bilo koja intervencija, uz zadovoljstvo! U Polident-u sa nasmejanom i dragom dr Sandrom 🙂. Provereno i preporuka od srca ! ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aiym_bakytty, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURfbTVhbzlRRRAB',
    5, 'en', 'I had strong headaches for days and when I connected it to my tooth it was already Saturday. The pain was insufferable and I called dr. Sandra as I was around this area. She came from her home (as they don’t work on Saturdays) to the office and helped me with a scan and removing of the tooth. Great doctor and even better person!',
    NULL, NULL, 'I had strong headaches for days and when I connected it to my tooth it was already Saturday. The pain was insufferable and I called dr. Sandra as I was around this area. She came from her home (as they don’t work on Saturdays) to the office and helped me with a scan and removing of the tooth. Great doctor and even better person!', NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_luka_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURfbTRydXdnRRAB',
    5, 'hr', 'Sve najbolje!’',
    'Sve najbolje!’', NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_mladen_korlin, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSUM3ejRybVdBEAE',
    5, 'hr', 'Toliko ljubazna,pristojna,profesionalna,stručna, sve najbolje o doktorici.',
    'Toliko ljubazna,pristojna,profesionalna,stručna, sve najbolje o doktorici.', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_mirjana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSUM3ei1LR2lRRRAB',
    5, 'bs', 'Divna, ljubazna i posvecena doktorica. Sve pohvale 🌞',
    'Divna, ljubazna i posvecena doktorica. Sve pohvale 🌞', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_dragana_vlaovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURibDRtbTdRRRAB',
    5, 'hr', 'Sve pohvale i preporuke. Profesionalni i ljubazni...',
    'Sve pohvale i preporuke. Profesionalni i ljubazni...', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sonja_tds, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURiNVlhRGhRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_nenad_tomic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSURiMnRqT0F3EAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_tijana_miseljic, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURicW9mNjVBRRAB',
    5, 'bs', 'Kada je riječ o stomatološkim uslugama, ne postoji bolji izbor od doktorke Sandre.
Njena profesionalnost i pažnja prema detaljima su zaista impresivni.
Ona ne samo da razumije sve aspekte stomatološke struke, već i prikazuje izuzetnu empatiju prema svojim pacijentima. Njena sposobnost da jasno objasni sve procedurе i odgovori na svako pitanje sa strpljenjem, čini svaki susret prijatnijim.

Ako tražite stomatologa koji kombinuje vrhunski profesionalizam sa iskrenom brigom za svoje pacijente, nema potrebe da trazite dalje od Bijele :D

Hvala vam Sandra, sada se stomatoloski pregledi osjećaju manje kao obaveza, a više kao prijatno iskustvo!',
    'Kada je riječ o stomatološkim uslugama, ne postoji bolji izbor od doktorke Sandre.
Njena profesionalnost i pažnja prema detaljima su zaista impresivni.
Ona ne samo da razumije sve aspekte stomatološke struke, već i prikazuje izuzetnu empatiju prema svojim pacijentima. Njena sposobnost da jasno objasni sve procedurе i odgovori na svako pitanje sa strpljenjem, čini svaki susret prijatnijim.

Ako tražite stomatologa koji kombinuje vrhunski profesionalizam sa iskrenom brigom za svoje pacijente, nema potrebe da trazite dalje od Bijele :D

Hvala vam Sandra, sada se stomatoloski pregledi osjećaju manje kao obaveza, a više kao prijatno iskustvo!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_vanja_nuhefendic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSURia3NxX1hnEAE',
    5, 'hr', 'Super, uvijek na usluzi',
    'Super, uvijek na usluzi', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_igi_bro, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURiNHBPNmxRRRAB',
    5, 'hr', 'Najbolji zubar u Herceg Novom. Sjajna usluga i profesionalnost. Sve preporuke!',
    'Najbolji zubar u Herceg Novom. Sjajna usluga i profesionalnost. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    1, '2024-10-29 00:00:00'),

(@user_ivana_tomic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSURiNHRLY01REAE',
    5, 'hr', 'Malo je reći hvala,za ljubaznost,profesionalnost .Preporuka za predivnu doktorku .',
    'Malo je reći hvala,za ljubaznost,profesionalnost .Preporuka za predivnu doktorku .', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sladjoo, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURiOUxqQmdBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_damir_brkic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURiOUxqZXF3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_sladjana_asanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSURiOU1pYkR3EAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_bojana_palevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSURiMUp2aVFREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_danka_miseljic, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSURibEt5N3p3RRAB',
    5, 'bs', 'Prezadovoljna pacijentkinja, Sandra je za sve preporuke!!!!',
    'Prezadovoljna pacijentkinja, Sandra je za sve preporuke!!!!', NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_malisa_rajak, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNMa3Y3eGp3RRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_predrag_mijovi, @clinic_id, @doctor_sandra_brkic, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSUNwemVDV1d3EAE',
    5, 'hr', 'Nenajavljen,posle neprospavane noći došao u ordinaciju dr Sandre Brkić.Posle dugotrajne borbe oko moje šestice, zajednički odlučimo da je bolje da se izvadi.I bogami je izvadi, bez problema, iako sam bio malo skeptičan.Dr Sandra Brkić, za svaku pohvalu.
Verovatno bih više platio u Novom Sadu, opet pozitivno iskustvo',
    'Nenajavljen,posle neprospavane noći došao u ordinaciju dr Sandre Brkić.Posle dugotrajne borbe oko moje šestice, zajednički odlučimo da je bolje da se izvadi.I bogami je izvadi, bez problema, iako sam bio malo skeptičan.Dr Sandra Brkić, za svaku pohvalu.
Verovatno bih više platio u Novom Sadu, opet pozitivno iskustvo', NULL, NULL, NULL, NULL, NULL,
    2, '2023-10-29 00:00:00'),

(@user_miriam_k, @clinic_id, NULL, 'google_maps',
    'places/ChIJLY89jhUxTBMRtWuukyexrlE/reviews/ChZDSUhNMG9nS0VJQ0FnSURKbjlHX2JnEAE',
    5, 'de', 'Ich war dort weil ich zu Anfang unseres Urlaubs Zahnschmerzen bekommen habe. Wir sind morgens ohne Termin hin und wurden direkt herzlich aufgenommen und mir wurde geholfen. Ich habe meine erste Wurzelbehandlung bei ihr gehabt, sie hat meine Angst vor dem Zahnarzt berücksichtigt und war so vorsichtig wie möglich. Ich habe 2 weitere Termine bekommen um die Behandlung zu beenden und eine Füllung zu bekommen. Heute war der letzte Termin, ich habe keine Schmerzen mehr und hoffe es bleibt so. Danke für alles 🙏🏼',
    NULL, NULL, NULL, NULL, 'Ich war dort weil ich zu Anfang unseres Urlaubs Zahnschmerzen bekommen habe. Wir sind morgens ohne Termin hin und wurden direkt herzlich aufgenommen und mir wurde geholfen. Ich habe meine erste Wurzelbehandlung bei ihr gehabt, sie hat meine Angst vor dem Zahnarzt berücksichtigt und war so vorsichtig wie möglich. Ich habe 2 weitere Termine bekommen um die Behandlung zu beenden und eine Füllung zu bekommen. Heute war der letzte Termin, ich habe keine Schmerzen mehr und hoffe es bleibt so. Danke für alles 🙏🏼', NULL,
    2, '2023-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
