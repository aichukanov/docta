-- Insert Google Maps reviews for Moj Lab (Podgorica 2)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/moj-lab-magnetna-rezonanca-podgorica.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = 6;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nazim Lekic', 'https://lh3.googleusercontent.com/a/ACg8ocLIcfR-JEsil0zXevn-8pM823rKYf6QdJKmhJVmATcJcP4sbg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102404900674217258779/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102404900674217258779/reviews');
SET @user_nazim_lekic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102404900674217258779/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'aleksandra ck', 'https://lh3.googleusercontent.com/a-/ALV-UjVQe3JPoXhnPPIwgKefJjCuHISHbFfZ-huSFZZrXRFYiXVgciC3GA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111706094714897904135/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111706094714897904135/reviews');
SET @user_aleksandra_ck = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111706094714897904135/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivan Šćepanović', 'https://lh3.googleusercontent.com/a-/ALV-UjVyfDsvl9EKkHvf_mmpcmJ04LZTolLTAVvdtexkizBSVvoK_swQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100895271679490990213/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100895271679490990213/reviews');
SET @user_ivan_epanovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100895271679490990213/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sanja Abramovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVhDx6NSFk3g4DqAvrBfjCh1sHpo8hhWuVobQ1cXYkhSH5DvaT1=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110457024792225718600/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110457024792225718600/reviews');
SET @user_sanja_abramovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110457024792225718600/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'nikola nikolic', 'https://lh3.googleusercontent.com/a/ACg8ocIXIifEu4oa3xeMHZk651V64GHJK1LmGD4ne48ET00BXExl5w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106991174779907950485/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106991174779907950485/reviews');
SET @user_nikola_nikolic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106991174779907950485/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Janko Jankovic', 'https://lh3.googleusercontent.com/a/ACg8ocIEEeU8N1Me5GIFfhasWoaVw8yAWjmIidMJ4xb1yy7AEYHoGA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106159677531552384207/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106159677531552384207/reviews');
SET @user_janko_jankovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106159677531552384207/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Petar Boljevic', 'https://lh3.googleusercontent.com/a/ACg8ocKF0o8X3pdJG6ScLm9iKguIwcCMryLbTWi78i2Z2oUHFDnfHw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101606194928657958983/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101606194928657958983/reviews');
SET @user_petar_boljevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101606194928657958983/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jusuf Mehonjić', 'https://lh3.googleusercontent.com/a-/ALV-UjVQ8h2SA_hXGj2iRdO97s8GlBPXJGrK8lNh_aMgsSIwOS3WaPNClw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114598590463606787880/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114598590463606787880/reviews');
SET @user_jusuf_mehonji = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114598590463606787880/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jovana Delibašić', 'https://lh3.googleusercontent.com/a-/ALV-UjWxlL77XBdm-C_FmL1nMrlf7t9UrN2PwXtg6t1gMszfCrfOEhjH=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112750170580635387565/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112750170580635387565/reviews');
SET @user_jovana_delibai = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112750170580635387565/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusan', 'https://lh3.googleusercontent.com/a/ACg8ocKEM6KYQqGiQpb9iuu1ttJxHmFVp-P-5aJvr8BRkwlSEntA4g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/106667221687420783791/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106667221687420783791/reviews');
SET @user_dusan = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106667221687420783791/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danilo Danilovic', 'https://lh3.googleusercontent.com/a/ACg8ocKWPsml91Va11dHKHHi-U6T6ewDNnXj-ySvU6Olt2e1nZIeWQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105879724833495947172/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105879724833495947172/reviews');
SET @user_danilo_danilovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105879724833495947172/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Marko Markovic', 'https://lh3.googleusercontent.com/a/ACg8ocLGie9oOV1sFRTbUKO0_2Kfiv5O8bxOsmErosfSYbihoMBuRQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107513227767748887917/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107513227767748887917/reviews');
SET @user_marko_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107513227767748887917/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Seka Djordjevic', 'https://lh3.googleusercontent.com/a/ACg8ocLkbSJsmQ2OFrN6lx5WvhtRPGHApz2U8fUA4Cfl0B3_FFmkSg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113695272037428619788/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113695272037428619788/reviews');
SET @user_seka_djordjevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113695272037428619788/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bojana Franeta8', 'https://lh3.googleusercontent.com/a/ACg8ocLBwitNvg5439gLdnUV0Nzawxm44McJmtTGuiMUZejaZv6dFQ=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/103214441105966271571/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103214441105966271571/reviews');
SET @user_bojana_franeta8 = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103214441105966271571/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aleksandra Djurisic', 'https://lh3.googleusercontent.com/a/ACg8ocI231zLLGg2rZsbnCQdORBVrKyKESuIl8hxUBjZlUp8E47B=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109495843350223679890/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109495843350223679890/reviews');
SET @user_aleksandra_djurisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109495843350223679890/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zana Djokic', 'https://lh3.googleusercontent.com/a/ACg8ocL6IPEtKaZI4JFzwwJeN66UnGlJZsElXDEOwdwbIFJjyVJ8XA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111795360406149541199/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111795360406149541199/reviews');
SET @user_zana_djokic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111795360406149541199/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maša Mijović', 'https://lh3.googleusercontent.com/a/ACg8ocLA942I-5_IdVpfxSbryW25uZ2kKXgEP4ECZ2y_Udj2Te98RaBd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103689040198062981573/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103689040198062981573/reviews');
SET @user_maa_mijovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103689040198062981573/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Djurisic', 'https://lh3.googleusercontent.com/a-/ALV-UjWvZPfky4jg4iPO5n6D6o4zL0bMqNCLkrUL1OX0zaUGPyY6VtV-=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100496956034682111644/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100496956034682111644/reviews');
SET @user_jelena_djurisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100496956034682111644/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Lukic', 'https://lh3.googleusercontent.com/a/ACg8ocLIEZVRNmGNoX4LBpTa5_HL2haeFJDU3NIChJPNuu1Dr_qidw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107859728829120229098/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107859728829120229098/reviews');
SET @user_luka_lukic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107859728829120229098/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Suzana Kisic', 'https://lh3.googleusercontent.com/a/ACg8ocKGNxV3Fa4Bh3xz4CaIU1K-iCcjBaB3fiv4xjeRtiNAhf5nOA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108247520748622190332/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108247520748622190332/reviews');
SET @user_suzana_kisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108247520748622190332/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алена Суетина', 'https://lh3.googleusercontent.com/a/ACg8ocIzJcPXbI-d2S7hAdpmCb0yspKXuZt8ZaubXSdpaQmmQ1-PFA=w36-h36-p-rp-mo-ba2-br100', 'https://www.google.com/maps/contrib/116203209301059245774/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116203209301059245774/reviews');
SET @user_alena_suetina = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116203209301059245774/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Stanka Cana', 'https://lh3.googleusercontent.com/a/ACg8ocLQ2B-y9_fkRiF3dTgQ0Kp4iuDg7fFUTvN1sJ215-zjmpGREQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113519053933028110430/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113519053933028110430/reviews');
SET @user_stanka_cana = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113519053933028110430/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Tanja Tomasevic', 'https://lh3.googleusercontent.com/a/ACg8ocKHymlu18-zeEe8hyYL8w1T1M-iAn8d2SvnpuhA4BciTtwJ6A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102380081583963686199/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102380081583963686199/reviews');
SET @user_tanja_tomasevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102380081583963686199/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ljubo Puric', 'https://lh3.googleusercontent.com/a/ACg8ocJQuIw6x-mqko2mY5V2k6qnejzrbW8RFcERDNhFe4US8ysZSw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109757094055863251259/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109757094055863251259/reviews');
SET @user_ljubo_puric = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109757094055863251259/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natalija L', 'https://lh3.googleusercontent.com/a/ACg8ocLbceapYZuWixnzTgjq_27XWihWYUxkIrs7PQfkecz6RigvSn7G=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/112187668855978279739/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112187668855978279739/reviews');
SET @user_natalija_l = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112187668855978279739/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emir Kosuta', 'https://lh3.googleusercontent.com/a-/ALV-UjVWgkhpD_Esgi63TxqZqlyDVKECAMwjHGRDdKfBOBFnPieiINss5A=w36-h36-p-rp-mo-ba4-br100', 'https://www.google.com/maps/contrib/110596876219465537540/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110596876219465537540/reviews');
SET @user_emir_kosuta = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110596876219465537540/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bosko Cejovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVyqkVMgXYyCXJhCp_x8ufF6RniQ4PoMCyuAxCZ-InlczdvMDnELw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115424175829377153632/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115424175829377153632/reviews');
SET @user_bosko_cejovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115424175829377153632/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Ponoš', 'https://lh3.googleusercontent.com/a-/ALV-UjWsiFsg8vv86vt96XsfN8riPg_0FMsoNPI2E5yDld3CYF9bLt7a=w36-h36-p-rp-mo-ba3-br100', 'https://www.google.com/maps/contrib/108092268582418701160/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108092268582418701160/reviews');
SET @user_ana_pono = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108092268582418701160/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_nazim_lekic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twTk5IWkVUMDlWTWw5eGFXaDNTWE5FVm1kSGIxRRAB',
    1, 'bs', 'Cekali sat vremena iako imamo termin plus naplacivali nam pregled dva puta',
    'Cekali sat vremena iako imamo termin plus naplacivali nam pregled dva puta', 'Чекали сат времена иако имамо термин плус наплаћивали нам преглед два пута', 'We waited an hour even though we had an appointment, plus they charged us for the examination twice', 'Ждали час, хотя у нас был назначен приём, к тому же дважды взяли оплату за осмотр', 'Wir warteten eine Stunde, obwohl wir einen Termin hatten, und wurden außerdem zweimal für die Untersuchung berechnet', 'Randevumuz olmasına rağmen bir saat bekledik ve üstelik muayene için iki kez ücret aldılar',
    0, '2026-02-24 00:00:00'),

(@user_aleksandra_ck, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21WTlpGWkRkSFl3Y25aeWVHOUViWFZpVVRkVE5rRRAB',
    5, 'hr', 'Zadovolja sam uslugom koja mi je pruzena, preporuka.',
    'Zadovolja sam uslugom koja mi je pruzena, preporuka.', 'Задовољна сам услугом која ми је пружена, препорука.', 'I am satisfied with the service provided to me, I recommend it.', 'Довольна услугами, которые мне оказали, рекомендую.', 'Ich bin mit dem mir erbrachten Service zufrieden, Empfehlung.', 'Bana sunulan hizmetten memnunum, öneririm.',
    0, '2026-02-24 00:00:00'),

(@user_ivan_epanovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkV1JFOTJkbEJLZERsSWVWcG9NMmh2VUhseVdFRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_sanja_abramovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aa1h6SlBaeTFJVUVwNU0wcGZaMXBGVUZCVFpIYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_nikola_nikolic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25aVWFGcDZjVXBzY2s5R1EyZE9ZMEV4YUdGVlpHYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_janko_jankovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21nM2VtWkNUa0pLTTNod2RsZHFUR1V0VUd4RWMwRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_petar_boljevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xONlVETm9kVXh3YVZCTE0waFhNRVoxYVhSVGJYYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_jusuf_mehonji, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT25OUWRVZEpXRmQ2V0RWeFExRXRabTUyVTJkVWRsRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_jovana_delibai, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xnNFluVmlkbE0zYlU5VVlYcHRiVmxoY1RsUlRVRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_dusan, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SUVRUVnBTRFI2T1ZkbVVVOU1lRE5UT1dkRlJYYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_danilo_danilovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkbE9HSlJUbGhFZWtwMlNtOU9MUzFPY0VFeVEwRRAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_marko_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCRGFWSk9TMUpQWDJwelFtbEtNVlJ3TVUxUlRIYxAB',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-12-24 00:00:00'),

(@user_seka_djordjevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xnNU4ycEZZa05xZVY5UlJqVjRSRGxIWlhaRU1IYxAB',
    5, 'hr', 'Klaustrofobična sam, ali zahvaljujući razgovoru i ljubaznosti radiologa uspjela sam obaviti snimanje. Magnetna ima nesto siri tunel, nije bucana, osvjetljena je.  Preporucila bih svakome ko ima problem kao ja. Nalazi stigli u dogovoreno vrijeme. Odlicni!',
    'Klaustrofobična sam, ali zahvaljujući razgovoru i ljubaznosti radiologa uspjela sam obaviti snimanje. Magnetna ima nesto siri tunel, nije bucana, osvjetljena je.  Preporucila bih svakome ko ima problem kao ja. Nalazi stigli u dogovoreno vrijeme. Odlicni!', 'Клаустрофобична сам, али захваљујући разговору и љубазности радиолога успела сам да обавим снимање. Магнетна има нешто шири тунел, није бучна, осветљена је. Препоручила бих свакоме ко има проблем као ја. Налази стигли у договорено време. Одлични!', 'I am claustrophobic, but thanks to the conversation and the radiologist\'s kindness, I managed to complete the scan. The MRI has a slightly wider tunnel, it\'s not noisy and is well-lit. I would recommend it to anyone who has the same problem as me. The results arrived at the agreed time. Excellent!', 'Я клаустрофобик, но благодаря разговору и любезности рентгенолога мне удалось пройти сканирование. У аппарата МРТ несколько более широкий тоннель, он не шумный и хорошо освещён. Рекомендую всем, у кого такая же проблема. Результаты пришли в оговорённое время. Отлично!', 'Ich habe Klaustrophobie, aber dank dem Gespräch und der Freundlichkeit des Radiologen konnte ich die Aufnahme durchführen. Das MRT hat einen etwas breiteren Tunnel, ist nicht laut und gut beleuchtet. Ich würde es jedem empfehlen, der ein ähnliches Problem hat. Die Befunde kamen zur vereinbarten Zeit. Ausgezeichnet!', 'Klostrofobi hastasıyım ama radyologun konuşması ve nezaketi sayesinde çekimi tamamlayabildim. MR\'ın biraz daha geniş bir tüneli var, gürültülü değil ve iyi aydınlatılmış. Benim gibi sorunu olan herkese öneririm. Sonuçlar kararlaştırılan zamanda geldi. Mükemmel!',
    0, '2025-11-24 00:00:00'),

(@user_bojana_franeta8, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xCZk9TMHhWWE5ZYUV4MFNXdGpWRkJ3UzA0M1RVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-24 00:00:00'),

(@user_aleksandra_djurisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tsM1UxOWlZM05OVjB4dGRrTjNNRzVJYTFWMlQxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-09-24 00:00:00'),

(@user_zana_djokic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoMGJUZGFNVmxDWlhsNVFtSnVRelZ3ZEV0WFNtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-24 00:00:00'),

(@user_maa_mijovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xrMVRXSTNaV0pHUlVJM1JGOW5WbGg1T1ZaRWExRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-24 00:00:00'),

(@user_jelena_djurisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twa1FUbHZNMWg1ZGxsc2RFVmZURE5EVW5sTWJHYxAB',
    1, 'bs', 'I ova 1 zvezdica je mnogo za njih.
2 puta u godinu dana radim MR oba puta cekam nalaz vise od obecanog.
Za javljanje na tel da ne pricam..
UŽAS!',
    'I ova 1 zvezdica je mnogo za njih.
2 puta u godinu dana radim MR oba puta cekam nalaz vise od obecanog.
Za javljanje na tel da ne pricam..
UŽAS!', 'И ова 1 звездица је много за њих.
2 пута годишње радим МР, оба пута чекам налаз више од обећаног.
За јављање на тел да не причам..
УЖАС!', 'Even this 1 star is too many for them.
I do MRI 2 times a year and both times I wait longer for the results than promised.
As for answering the phone, don\'t even get me started..
HORRIBLE!', 'И эта 1 звезда — слишком много для них.
2 раза в год делаю МРТ, оба раза жду результат дольше обещанного.
Чтобы дозвониться — вообще молчу..
УЖАС!', 'Selbst dieser 1 Stern ist zu viel für sie.
2 Mal im Jahr mache ich ein MRT, und beide Male warte ich länger auf den Befund als versprochen.
Von der Erreichbarkeit per Telefon gar nicht erst anfangen..
HORRIBEL!', 'Bu 1 yıldız bile onlar için fazla.
Yılda 2 kez MR yaptırıyorum ve her iki seferinde de sonucu vaadedilenden daha uzun bekliyorum.
Telefona çıkmaları konusunda hiç başlamayalım..
KORKUNÇ!',
    0, '2025-08-24 00:00:00'),

(@user_luka_lukic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSZmVISm9MVFo0TlZoeVZHUTRZalpFTkhoV01HYxAB',
    1, 'bs', 'Od momenta kada sam ušao na kliniku, pa do momenta kada sam izašao sa klinike - jako neprofesionalan odnos! Djevojka koja radi na pultu nije znala moje ime i prezime, datum rođenja, dan i vrijeme kada sam zakazao magnetnu rezonancu. Nakon toga, medicinski tehničar se pita da li treba da mi da kontrast ili ne. Nijesu me uopšte uputili u mogućnost da ponovo dolazim i dodatno plaćam za kontrast kako bi opis bio jasan. Zaobilazite ih u širokom luku.',
    'Od momenta kada sam ušao na kliniku, pa do momenta kada sam izašao sa klinike - jako neprofesionalan odnos! Djevojka koja radi na pultu nije znala moje ime i prezime, datum rođenja, dan i vrijeme kada sam zakazao magnetnu rezonancu. Nakon toga, medicinski tehničar se pita da li treba da mi da kontrast ili ne. Nijesu me uopšte uputili u mogućnost da ponovo dolazim i dodatno plaćam za kontrast kako bi opis bio jasan. Zaobilazite ih u širokom luku.', 'Од момента када сам ушао на клинику, па до момента када сам изашао са клинике — јако непрофесионалан однос! Девојка која ради на пулту није знала моје име и презиме, датум рођења, дан и вријеме када сам заказао магнетну резонанцу. Након тога, медицински техничар се пита да ли треба да ми да контраст или не. Нису ме уопште упутили у могућност да поново долазим и додатно плаћам за контраст како би опис био јасан. Заобилазите их у широком луку.', 'From the moment I entered the clinic to the moment I left — a very unprofessional attitude! The girl at the reception didn\'t know my name and surname, date of birth, the day and time I had booked the MRI. After that, the medical technician wondered whether he should give me contrast or not. They did not inform me at all about the possibility of coming back and paying extra for contrast so that the description would be clear. Avoid them at all costs.', 'С момента, как я вошёл в клинику, и до момента, как вышел — крайне непрофессиональное отношение! Девушка на ресепшн не знала ни моего имени и фамилии, ни даты рождения, ни дня и времени, на которые я записался на МРТ. После этого медицинский техник задавался вопросом: давать мне контраст или нет. Меня вообще не предупредили о возможности прийти повторно и доплатить за контраст, чтобы описание было точным. Обходите их стороной.', 'Vom Moment, als ich die Klinik betrat, bis zum Moment, als ich sie verließ — ein sehr unprofessionelles Verhalten! Die Dame an der Rezeption wusste meinen Namen, Nachnamen, das Geburtsdatum, den Tag und die Uhrzeit meiner gebuchten MRT nicht. Danach fragte sich der medizinische Techniker, ob er mir Kontrastmittel geben soll oder nicht. Es wurde mir nicht mitgeteilt, dass ich wiederkommen und extra für das Kontrastmittel bezahlen könnte, damit die Beschreibung klar ist. Meiden Sie sie mit großem Abstand.', 'Kliniğe girdiğim andan çıktığım ana kadar son derece profesyonelsiz bir tutum! Resepsiyondaki kız adımı soyadımı, doğum tarihimi, MR randevumu aldığım gün ve saati bilmiyordu. Bundan sonra tıbbi teknisyen bana kontrast madde verip vermeyeceğini merak etti. Açıklamanın net olması için geri gelip kontrast için ekstra ödeme yapabileceğim ihtimalinden hiç bahsetmediler. Onlardan uzak durun.',
    0, '2025-08-24 00:00:00'),

(@user_suzana_kisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2poWWNqWjNaRFEyYVRWU2FrOUdjVkEwWldKeWNFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-08-24 00:00:00'),

(@user_alena_suetina, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pWWmIyRkpUbFJLVTJ0dGJrTnlNRXRFU2poeGJuYxAB',
    5, 'ru', 'Делала МРТ шейного отдела позвоночника.
Впечатление осталось положительное.
Персонал дружелюбный, все показал, объяснил. Результаты МРТ выдали на диске и прислали в течении дня заключение.
Спасибо за быструю и качественную работу!',
    'Radila sam MRT vratne kičme.
Utisak ostao pozitivan.
Osoblje je prijatno, sve su pokazali i objasnili. Rezultate MRT-a su dali na disku i poslali zaključak tokom dana.
Hvala za brz i kvalitetan rad!', 'Радила сам МРТ вратне кичме.
Утисак остао позитиван.
Особље је пријатно, све су показали и објаснили. Резултате МРТ-а су дали на диску и послали закључак током дана.
Хвала за брз и квалитетан рад!', 'I had an MRI of the cervical spine.
The impression was positive.
The staff is friendly, showed and explained everything. The MRI results were given on a disc and the report was sent during the day.
Thank you for the quick and quality work!', 'Делала МРТ шейного отдела позвоночника.
Впечатление осталось положительное.
Персонал дружелюбный, все показал, объяснил. Результаты МРТ выдали на диске и прислали в течении дня заключение.
Спасибо за быструю и качественную работу!', 'Ich habe eine MRT der Halswirbelsäule gemacht.
Der Eindruck war positiv.
Das Personal ist freundlich und hat alles gezeigt und erklärt. Die MRT-Ergebnisse wurden auf einer Disc ausgegeben und der Befund wurde noch am selben Tag zugesandt.
Danke für die schnelle und qualitativ hochwertige Arbeit!', 'Boyun omurgasının MR\'ını yaptırdım.
İzlenim olumlu kaldı.
Personel dostane davrandı, her şeyi gösterip açıkladı. MR sonuçları disk üzerinde verildi ve raporlar gün içinde gönderildi.
Hızlı ve kaliteli iş için teşekkürler!',
    0, '2025-06-24 00:00:00'),

(@user_stanka_cana, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvNklEcEpnEAE',
    1, 'hr', 'Najgora privatna klinika ikad!',
    'Najgora privatna klinika ikad!', 'Најгора приватна клиника икад!', 'The worst private clinic ever!', 'Худшая частная клиника за всё время!', 'Die schlimmste Privatklinik aller Zeiten!', 'Her zamanki en kötü özel klinik!',
    0, '2025-04-24 00:00:00'),

(@user_tanja_tomasevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/ChZDSUhNMG9nS0VJQ0FnTUR3Z2NIZFdBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-04-24 00:00:00'),

(@user_ljubo_puric, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/ChZDSUhNMG9nS0VJQ0FnTUR3N0wzNGNBEAE',
    1, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-04-24 00:00:00'),

(@user_natalija_l, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/ChZDSUhNMG9nS0VJQ0FnTUNReW91SmJnEAE',
    1, 'bs', 'Nazalost, razocaravajuce iskustvo sa osobljem za razliku od tima zaposlenih Moj lab Budva i Kolasin.
Nedostatak informisanja i empatije u jednoj humanoj djelatnosti, narocito izbjegavanje konsultacije na nasu molbu.
Necemo pisati detalje vec samo navesti da ista prethodno zakazana usluga, odradjena je isti dan u drugu privatnu kliniku, bez mnogo tenzija, a na isti zahtjev.
Nadam se da cete stav promijeniti.',
    'Nazalost, razocaravajuce iskustvo sa osobljem za razliku od tima zaposlenih Moj lab Budva i Kolasin.
Nedostatak informisanja i empatije u jednoj humanoj djelatnosti, narocito izbjegavanje konsultacije na nasu molbu.
Necemo pisati detalje vec samo navesti da ista prethodno zakazana usluga, odradjena je isti dan u drugu privatnu kliniku, bez mnogo tenzija, a na isti zahtjev.
Nadam se da cete stav promijeniti.', 'Нажалост, разочаравајуће искуство са особљем за разлику од тима запослених Moj lab Будва и Колашин.
Недостатак информисања и емпатије уједној хуманој делатности, нарочито избегавање консултације на наш захтев.
Нећемо писати детаље већ само навести да иста претходно заказана услуга, урађена је исти дан у другој приватној клиници, без много тензија, а на исти захтев.
Надам се да ћете став промијенити.', 'Unfortunately, a disappointing experience with the staff, unlike the team at Moj lab Budva and Kolašin.
Lack of information and empathy in a humane profession, especially avoiding consultation at our request.
We won\'t go into details, just note that the same previously scheduled service was performed the same day at another private clinic without much tension, and on the same request.
I hope you will change your attitude.', 'К сожалению, разочаровывающий опыт работы с персоналом, в отличие от команды Moj lab Budva и Колашин.
Нехватка информирования и эмпатии в гуманной профессии, особенно избегание консультации по нашей просьбе.
Мы не будем писать детали, только отметим, что та же ранее заказанная услуга была выполнена в тот же день в другой частной клинике без лишнего напряжения и по тому же запросу.
Надеюсь, вы измените своё отношение.', 'Leider eine enttäuschende Erfahrung mit dem Personal, im Gegensatz zum Team von Moj lab Budva und Kolašin.
Mangelnde Information und Empathie in einem humanitären Bereich, insbesondere die Vermeidung einer Beratung auf unsere Bitte hin.
Wir werden keine Details nennen, nur anmerken, dass dieselbe zuvor gebuchte Leistung am selben Tag in einer anderen Privatklinik ohne viele Spannungen und auf dieselbe Anfrage hin durchgeführt wurde.
Ich hoffe, Sie werden Ihre Einstellung ändern.', 'Ne yazık ki, Moj lab Budva ve Kolašin ekibinden farklı olarak personelle hayal kırıklığı yaratan bir deneyim.
İnsancıl bir meslekte bilgi ve empati eksikliği, özellikle ricamız üzerine konsültasyondan kaçınma.
Ayrıntılara girmeyeceğiz, sadece aynı önceden planlanmış hizmetin aynı gün başka bir özel klinikte fazla gerginlik olmadan ve aynı talep üzerine yapıldığını belirteceğiz.
Umarım tutumunuzu değiştirirsiniz.',
    0, '2025-03-24 00:00:00'),

(@user_emir_kosuta, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/ChdDSUhNMG9nS0VJQ0FnSURfeExMRWlnRRAB',
    5, 'en', 'I had a great experience with the MRI service. The staff was polite and professional, the facility was modern and well-equipped, and everything was very clean. The process was quick with no waiting time, and the scan itself took about 40 minutes. Highly recommend!',
    'Imao sam sjajno iskustvo sa uslugom MRT-a. Osoblje je bilo ljubazno i profesionalno, objekat je moderan i dobro opremljen, a sve je veoma čisto. Proces je bio brz bez čekanja, a samo snimanje je trajalo oko 40 minuta. Toplo preporučujem!', 'Имао сам сјајно искуство са услугом МРТ-а. Особље је bilo љубазно и професионално, објекат је модеран и добро опремљен, а све је веома чисто. Процес је bio брз без чекања, а само снимање је трајало око 40 минута. Топло препоручујем!', 'I had a great experience with the MRI service. The staff was polite and professional, the facility was modern and well-equipped, and everything was very clean. The process was quick with no waiting time, and the scan itself took about 40 minutes. Highly recommend!', 'У меня был отличный опыт с услугой МРТ. Персонал был вежливым и профессиональным, учреждение современное и хорошо оснащённое, везде очень чисто. Процесс прошёл быстро без ожидания, а само сканирование заняло около 40 минут. Настоятельно рекомендую!', 'Ich hatte eine großartige Erfahrung mit dem MRT-Service. Das Personal war höflich und professionell, die Einrichtung war modern und gut ausgestattet, und alles war sehr sauber. Der Prozess war schnell ohne Wartezeit, und das eigentliche Scanning dauerte etwa 40 Minuten. Sehr empfehlenswert!', 'MR hizmetiyle harika bir deneyim yaşadım. Personel kibar ve profesyoneldi, tesis modern ve iyi donanımlıydı ve her şey çok temizdi. Süreç bekleme olmadan hızlıydı ve taramanın kendisi yaklaşık 40 dakika sürdü. Kesinlikle tavsiye ederim!',
    0, '2025-03-24 00:00:00'),

(@user_bosko_cejovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/ChdDSUhNMG9nS0VJQ0FnSURiaUs3THFnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-03-24 00:00:00'),

(@user_ana_pono, @clinic_id, NULL, 'google_maps',
    'places/ChIJBylDTw_rTRMRI9d21sskRh0/reviews/ChZDSUhNMG9nS0VJQ0FnSUMxMG96d2FREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-03-24 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
