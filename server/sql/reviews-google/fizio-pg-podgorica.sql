-- Insert Google Maps reviews for Fizio
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/fizio-pg-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'fizio-pg-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_jugoslav_toskovic = (SELECT id FROM doctors WHERE slug = 'jugoslav-toskovic');
SET @doctor_dragana_knezevic_fizioterapeut = (SELECT id FROM doctors WHERE slug = 'dragana-knezevic-fizioterapeut');
SET @doctor_suad_nikocevic = (SELECT id FROM doctors WHERE slug = 'suad-nikocevic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Aimilia Peppa', 'https://lh3.googleusercontent.com/a/ACg8ocKawxubcM4qG871bl4ggPw29voArDRgPdSBDqNtMvyspYSsROQE=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/113097817656987340276/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113097817656987340276/reviews');
SET @user_aimilia_peppa = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113097817656987340276/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Goran Ristic', 'https://lh3.googleusercontent.com/a/ACg8ocKy_ITw_2JtlofN0Tn5lALAiF_VcYZi9DxWC0ZaCI6A3JGBnQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103470302793653589139/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103470302793653589139/reviews');
SET @user_goran_ristic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103470302793653589139/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasmina Markovic', 'https://lh3.googleusercontent.com/a-/ALV-UjU838xggHgcmla_7jftZZIUJ4mZjeeOKA4PtwCmUPLoWG7DMyoT=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/107023616841565349753/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107023616841565349753/reviews');
SET @user_jasmina_markovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107023616841565349753/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Pavle Raickovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXSU9qnZj0E-OLaceHwPPqYa8R1ok2DzSBxgyv-JyuMtyyhxGXHtw=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/103399520655962189983/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103399520655962189983/reviews');
SET @user_pavle_raickovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103399520655962189983/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Lidija Popovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVQCV9zE3F5tP2oSRKdTUeTe18nx0enDcJQKbYaebTXUYEbZi-CLw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107343152560733076622/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107343152560733076622/reviews');
SET @user_lidija_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107343152560733076622/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ana Popovic', 'https://lh3.googleusercontent.com/a/ACg8ocLdMg-keJf_E92ub3hjYYpKOb6H0hDNhLOF9WK40wNX-u5ebw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114206637101818424055/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114206637101818424055/reviews');
SET @user_ana_popovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114206637101818424055/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Nikic', 'https://lh3.googleusercontent.com/a/ACg8ocLqDGUesioYyNv-RXdoy_w4722UnrB27Ml_7G591DgemEn16g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/104203796415488018572/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104203796415488018572/reviews');
SET @user_jelena_nikic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104203796415488018572/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'losmi losmi', 'https://lh3.googleusercontent.com/a-/ALV-UjXjZ6D_S5GD6AvE6uDGpd5jWghvJkk432PdaETMySExVJlfB69B=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109350332642639103785/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109350332642639103785/reviews');
SET @user_losmi_losmi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109350332642639103785/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dusan Zivkovic', 'https://lh3.googleusercontent.com/a/ACg8ocKv0pq7hH-0VXjVXNxBIjLhT7liaOu17kCZiR-nL-wliC971Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113482535701641501732/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113482535701641501732/reviews');
SET @user_dusan_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113482535701641501732/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'DV', 'https://lh3.googleusercontent.com/a-/ALV-UjXbnd5HBCIO8HEocN6ulQo7QaOek8llMqWplxKf7j8NSRcAEfM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109133664195040724472/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109133664195040724472/reviews');
SET @user_dv = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109133664195040724472/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Becir Koljenovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVbBNpFu4GzyoNu3qow7Kh6WzcJcEo6qr-dpYrsphRjW0YYhRQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111892680692911893391/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111892680692911893391/reviews');
SET @user_becir_koljenovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111892680692911893391/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Natalija Scepanovic', 'https://lh3.googleusercontent.com/a/ACg8ocLaPdajujGWPs7GMUJz0GqYSC5cHrF_Jsqrgr4oHCOoKQaBrQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111997577210896890731/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111997577210896890731/reviews');
SET @user_natalija_scepanovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111997577210896890731/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Vukicevic', 'https://lh3.googleusercontent.com/a/ACg8ocLu9psXWBTtEOwaBU_2rXkQ4v29Rz3bu2h83JpAD4w7KGQbaQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101752872427203084346/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101752872427203084346/reviews');
SET @user_jelena_vukicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101752872427203084346/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dado Djurovic', 'https://lh3.googleusercontent.com/a/ACg8ocL5mk9scmCRESUiSaksiKcQ3e9JWZsCU72SFtkT9wBlNh6kBw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113373492935603093235/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113373492935603093235/reviews');
SET @user_dado_djurovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113373492935603093235/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danka Stanic', 'https://lh3.googleusercontent.com/a/ACg8ocKvartRA9cfXBeoqt3p8ZWb1OsQU4Nmdm7cbzqkCkmvDH1vnw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103485625586727844728/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103485625586727844728/reviews');
SET @user_danka_stanic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103485625586727844728/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sara Notte', 'https://lh3.googleusercontent.com/a/ACg8ocI5qIMrfxSuT8JJSGIrYODjWh3_EZVm8SNe23-azY2LqGVPmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109323547268219619935/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109323547268219619935/reviews');
SET @user_sara_notte = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109323547268219619935/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Predrag Djurasovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVBSdMVOXApvVCpCXEi7gOLOATIMlkDH_SC5OOqt1p-OLjKwgVR_g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110549561400333179715/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110549561400333179715/reviews');
SET @user_predrag_djurasovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110549561400333179715/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Svetlana Toskovic', 'https://lh3.googleusercontent.com/a/ACg8ocJWvcetAt-klfPNod2i_sOLFCazhE-JyIv5Q4Limm0c-aa99g=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/110466105224941694745/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110466105224941694745/reviews');
SET @user_svetlana_toskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110466105224941694745/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Maksim Ljucovic', 'https://lh3.googleusercontent.com/a/ACg8ocJSGdamADrfAKlV2OmmidJiZ4aCIazt7wVFGZd4bgPcir_wPQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102817008503107427926/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102817008503107427926/reviews');
SET @user_maksim_ljucovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102817008503107427926/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vukas Vujosevic', 'https://lh3.googleusercontent.com/a-/ALV-UjUkeFKMCxAGWnuwa5y-aWsmmAomhMm6sGq7lThx0jNi2UstuIF6FQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107350275619517489517/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107350275619517489517/reviews');
SET @user_vukas_vujosevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107350275619517489517/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'ALFA Nekretnine', 'https://lh3.googleusercontent.com/a-/ALV-UjU2HrHpbUytKa0PGSXI3Ddqdt2HGmXtcsjhgexpYhb8XOYZzOw=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100761076846767187223/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100761076846767187223/reviews');
SET @user_alfa_nekretnine = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100761076846767187223/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Radoje Mikovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUflQXkqW0-2W474GDlEzdtBtqfXjnSLpqOyNUwziByJZ96rqzd=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113741153464505295322/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113741153464505295322/reviews');
SET @user_radoje_mikovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113741153464505295322/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sandra Vucetic', 'https://lh3.googleusercontent.com/a/ACg8ocKtn9vzIX_VP6LUU47wE0BEHA3tDVVJFdpQQBbmNFnItDYdtg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111465128694603162831/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111465128694603162831/reviews');
SET @user_sandra_vucetic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111465128694603162831/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Гаврило Петровић', 'https://lh3.googleusercontent.com/a-/ALV-UjWtdHWwMje5s53jlgB6yDUVy2wPPGzgmrif_CxEmpMBJ5pWZ9Of=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100552101233994353547/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100552101233994353547/reviews');
SET @user_gavrilo_petrovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100552101233994353547/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Čabarkapa Golović', 'https://lh3.googleusercontent.com/a-/ALV-UjU0tKDkwKREaHI8IiDh9PyNlVOXm0JeJLr6NkiX72R8a2j3u_U2=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115739057312186752721/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115739057312186752721/reviews');
SET @user_ivana_abarkapa_golovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115739057312186752721/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sinan Karadeniz', 'https://lh3.googleusercontent.com/a-/ALV-UjUxMgCOxXkaqblnopEDOo30I6osCwr1WipbXGCl9I5BlB65DL1qbQ=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/108079246388790221182/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108079246388790221182/reviews');
SET @user_sinan_karadeniz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108079246388790221182/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nina Stanisic', 'https://lh3.googleusercontent.com/a/ACg8ocJPY9CXMRBrYAm7B2hq3rGwssZBtGAkseaCfFJve1tBAkyphA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102996021659192942086/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102996021659192942086/reviews');
SET @user_nina_stanisic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102996021659192942086/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Draško king', 'https://lh3.googleusercontent.com/a-/ALV-UjWxgbwvPIY8fwzAeLvY4D9MOwipRuf1zdyrWkMUYKxTCh__C40=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104673630528042633079/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104673630528042633079/reviews');
SET @user_drako_king = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104673630528042633079/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Katarina V', 'https://lh3.googleusercontent.com/a/ACg8ocIurjKcPRy9MowXtDzC9IHpBqG2PF7wnsmj_6351XCtgAfo4A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104117710979528889449/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104117710979528889449/reviews');
SET @user_katarina_v = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104117710979528889449/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_aimilia_peppa, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kwNFFVbDRZVlpSYUVWT1IySnFhMEZ1U2xvd1pGRRAB',
    5, 'en', 'They suggested the appropriate method for my issue, the therapist was always polite and available to provide guidance and explanations. Much appreciated!',
    'Predložili su odgovarajuću metodu za moj problem, terapeut je uvek bio ljubazan i dostupan da pruži smernice i objašnjenja. Veoma hvala!', 'Предложили су одговарајућу методу за мој проблем, терапеут је увек био љубазан и доступан да пружи смернице и објашњења. Веома хвала!', 'They suggested the appropriate method for my issue, the therapist was always polite and available to provide guidance and explanations. Much appreciated!', NULL, NULL, NULL,
    0, '2025-08-06 15:06:36'),

(@user_goran_ristic, @clinic_id, @doctor_jugoslav_toskovic, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtMjc2cXZRRRAB',
    5, 'bs', 'Iskreno zahvaljujem doktoru Jugoslavu Toshkovicu i citavom timu u ordinaciji "Fizio" koji za kratko vrijeme su uspeli da me podignu na noge...Istina , cuo sam za Isusa iz Nazareta sve dok nisam licno upoznao  Isusa iz Podgorice...Hvala Vam puno doktore Toshkovicu...',
    'Iskreno se zahvaljujem dr Jugoslavu Toškoviću i celom timu u ordinaciji „Fizio“ koji su uspeli da me za kratko vreme podignu na noge... Istina je, čuo sam za Isusa iz Nazareta dok nisam lično upoznao Isusa iz Podgorice... Hvala vam puno, dr Toškoviću...', 'Искрено се захваљујем др Југославу Тошковићу и целом тиму у ординацији „Физио“ који су успели да ме за кратко време подигну на ноге... Истина је, чуо сам за Исуса из Назарета док нисам лично упознао Исуса из Подгорице... Хвала вам пуно, др Тошковићу...', NULL, NULL, NULL, NULL,
    2, '2022-12-10 12:46:46'),

(@user_jasmina_markovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSURycElPaUNREAE',
    5, 'bs', 'Najbolji! Jugo, Dragana, Suad. Atmosfera za opuštanje, profesionalni pristup pacijentima, veoma stručni.',
    'Najbolji! Jugo, Dragana, Suad. Opuštajuća atmosfera, profesionalan pristup pacijentima, veoma profesionalan.', 'Најбољи! Југо, Драгана, Суад. Опуштајућа атмосфера, професионалан приступ пацијентима, веома професионалан.', NULL, NULL, NULL, NULL,
    0, '2024-07-15 05:27:37'),

(@user_pavle_raickovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNQdGVuY3FBRRAB',
    5, 'bs', 'Fino uredjen prostor, prijatno osoblje. Toplo preporučujem.',
    'Lepo uređen prostor, ljubazno osoblje. Toplo preporučujem.', 'Лепо уређен простор, љубазно особље. Топло препоручујем.', NULL, NULL, NULL, NULL,
    0, '2024-11-26 17:21:03'),

(@user_lidija_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURCLTdLYm9RRRAB',
    5, 'hr', 'Dugogodišnje iskustvo spojeno sa najnovijim tehnologijama = USPJEH 💫',
    'Višegodišnje iskustvo u kombinaciji sa najnovijim tehnologijama = USPEH 💫', 'Вишегодишње искуство у комбинацији са најновијим технологијама = УСПЕХ 💫', NULL, NULL, NULL, NULL,
    1, '2023-01-30 00:33:46'),

(@user_ana_popovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SeExYVk5ZV3BYYjFWU2NrWmZlV05HVUV4SGNtYxAB',
    5, 'hr', 'Najbolja ordinacija, najveći profesionalci i najljubaznije osoblje...',
    'Najbolja ordinacija, najveći profesionalci i najljubaznije osoblje...', NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_jelena_nikic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kRVptbENkVXhWVDB4TlpuVjJSMjFvT0RSNlRIYxAB',
    5, 'bs', 'Sjajni ste! Dr. Jugo i cijelo osoblje su veoma strucni i ljubazni! Mon sin je imao operaciju nadlaktice i posle nekoliko dana terapije nije vise imao bolove i ruka mu je bila mnogo fleksibilnija. Sve preporuke.',
    'Sjajni ste! Dr. Jugo i cijelo osoblje su veoma strucni i ljubazni! Mon sin je imao operaciju nadlaktice i posle nekoliko dana terapije nije vise imao bolove i ruka mu je bila mnogo fleksibilnija. Sve preporuke.', NULL, NULL, NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_losmi_losmi, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKcFYwczNUM1IxV21kdFRHZDZWekppWld4SWFtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_dusan_zivkovic, @clinic_id, @doctor_dragana_knezevic_fizioterapeut, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT205cGNFRnNTRkZsT1hsQ1QycFpXWGg2YjFoaFZFRRAB',
    5, 'hr', 'Odličan tim stručnjaka koji brinu o svakom pacijentu.. Od prvog dolaska osjetio sam profesionalnost i pažnju. Tretmani su bili efikasni, a rezultati vidljivi već nakon nekoliko posjeta. Preporučujem svima koji traže kvalitetnu fizioterapiju!
P.s. Dragana zaslužuje posebnu pohvalu:)',
    'Odličan tim stručnjaka koji brinu o svakom pacijentu.. Od prvog dolaska osjetio sam profesionalnost i pažnju. Tretmani su bili efikasni, a rezultati vidljivi već nakon nekoliko posjeta. Preporučujem svima koji traže kvalitetnu fizioterapiju!
P.s. Dragana zaslužuje posebnu pohvalu:)', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_dv, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT201a1RXTTJOVTFhY21aSFVsUkpWVkZXWVhjM2VVRRAB',
    5, 'hr', 'Profesionalno i fino osoblje. Mnogo mi je pomoglo, za svaku pohvalu!',
    'Profesionalno i fino osoblje. Mnogo mi je pomoglo, za svaku pohvalu!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_becir_koljenovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkcVRVOVhjSEkwWkc1NU9IWjBNV1JET0ZObVpIYxAB',
    5, 'en', 'Highly recommended, it’s the best in Montenegro!',
    NULL, NULL, 'Highly recommended, it’s the best in Montenegro!', NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_natalija_scepanovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paMVduRlZWRmh1TkRFeWIwNXJPRms1WWpoVWFrRRAB',
    5, 'hr', 'Profesionalan i ljubazan pristup, prijatna atmosfera i zaista se osjeti briga prema klijentima. Nakon tretmana sam se osjećala mnogo bolje. Sve preporuke!',
    'Profesionalan i ljubazan pristup, prijatna atmosfera i zaista se osjeti briga prema klijentima. Nakon tretmana sam se osjećala mnogo bolje. Sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_jelena_vukicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tzdFZsOTVhbWRmZEVwTlVETjJjRmQyWkhwWlNVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_dado_djurovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxMGQwNDNOelZvTldGRVNuRlBRbE5uVGpKdFoyYxAB',
    5, 'bs', 'Usluge i terapije su odlične, sve preporuke!',
    'Usluge i terapije su odlične, sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_danka_stanic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT213eGExUkhNbTFJY1VWQlVVUnFVbEZ0ZDFkcU1FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_sara_notte, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aV1dUTmlYemhoTjI4d01WOVRkRFJKWjFwRmMxRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_predrag_djurasovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xrM2JrcElkVzlJY0dOQk5ERjRhVlIxTTFRMldIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_svetlana_toskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KMk0weFhlRFpVZERkRFp6WlVaMkZxUTJZNE5FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_maksim_ljucovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNRNTR5NlpBEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_vukas_vujosevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURscjctem9RRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_alfa_nekretnine, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ1b3RDY0ZBEAE',
    5, 'en', 'Recomend from ❤️',
    NULL, NULL, 'Recomend from ❤️', NULL, NULL, NULL,
    1, '2023-10-29 00:00:00'),

(@user_radoje_mikovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURaX2F1R3lnRRAB',
    5, 'en', 'The best physiotherapists in Montenegro',
    NULL, NULL, 'The best physiotherapists in Montenegro', NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_sandra_vucetic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURCbV9laWxRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_gavrilo_petrovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtMXR1UWpnRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2023-10-29 00:00:00'),

(@user_ivana_abarkapa_golovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNXXzVqQlVnEAE',
    5, 'hr', 'Najbolji tim. 💪',
    'Najbolji tim. 💪', NULL, NULL, NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_sinan_karadeniz, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSURtd3ZuSEtnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2022-10-29 00:00:00'),

(@user_nina_stanisic, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNtalByTkVREAE',
    5, 'bs', 'Odlicni, sve preporuke!',
    'Odlicni, sve preporuke!', NULL, NULL, NULL, NULL, NULL,
    1, '2022-10-29 00:00:00'),

(@user_drako_king, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2clp1MWJ3EAE',
    5, 'hr', 'Jednostavno najbolji',
    'Jednostavno najbolji', NULL, NULL, NULL, NULL, NULL,
    2, '2021-10-29 00:00:00'),

(@user_katarina_v, @clinic_id, NULL, 'google_maps',
    'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM0NEpTblBREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2019-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kwNFFVbDRZVlpSYUVWT1IySnFhMEZ1U2xvd1pGRRAB'),
  'clinic', @clinic_id,
  'Thank you, we try to maintain quality', 'en',
  NULL, NULL, 'Thank you, we try to maintain quality', NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSUQtMjc2cXZRRRAB'),
  'clinic', @clinic_id,
  'Gorane hvala tebi, ali radi javnosti da ti objasnim da nijesam doktor već fizioterapeut. Drago mi je da si dobro, puno pozdrava.', 'hr',
  'Gorane hvala tebi, ali radi javnosti da ti objasnim da nijesam doktor već fizioterapeut. Drago mi je da si dobro, puno pozdrava.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSURycElPaUNREAE'),
  'clinic', @clinic_id,
  'Hvala Vam Jasmina na lijepim riječima, trudićemo se da budemo još bolji.', 'bs',
  'Hvala Vam Jasmina na lijepim riječima, trudićemo se da budemo još bolji.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2024-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSUNQdGVuY3FBRRAB'),
  'clinic', @clinic_id,
  'Hvala velika.', 'hr',
  'Hvala velika.', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURCLTdLYm9RRRAB'),
  'clinic', @clinic_id,
  'Veliko hvala.', 'hr',
  'Veliko hvala.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25SeExYVk5ZV3BYYjFWU2NrWmZlV05HVUV4SGNtYxAB'),
  'clinic', @clinic_id,
  'Hvala puno Ana', 'hr',
  'Hvala puno Ana', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21kRVptbENkVXhWVDB4TlpuVjJSMjFvT0RSNlRIYxAB'),
  'clinic', @clinic_id,
  'Hvala vam Jelena, javnosti radi ja sam fizioterapeut.
Jugoslav Tošković spec.app.', 'bs',
  'Hvala vam Jelena, javnosti radi ja sam fizioterapeut.
Jugoslav Tošković spec.app.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-08-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tKcFYwczNUM1IxV21kdFRHZDZWekppWld4SWFtYxAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT205cGNFRnNTRkZsT1hsQ1QycFpXWGg2YjFoaFZFRRAB'),
  'clinic', @clinic_id,
  'Hvala puno', 'hr',
  'Hvala puno', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT201a1RXTTJOVTFhY21aSFVsUkpWVkZXWVhjM2VVRRAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkcVRVOVhjSEkwWkc1NU9IWjBNV1JET0ZObVpIYxAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2paMVduRlZWRmh1TkRFeWIwNXJPRms1WWpoVWFrRRAB'),
  'clinic', @clinic_id,
  'Hvala puno', 'hr',
  'Hvala puno', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tzdFZsOTVhbWRmZEVwTlVETjJjRmQyWkhwWlNVRRAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2kxMGQwNDNOelZvTldGRVNuRlBRbE5uVGpKdFoyYxAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT213eGExUkhNbTFJY1VWQlVVUnFVbEZ0ZDFkcU1FRRAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-05-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT21aV1dUTmlYemhoTjI4d01WOVRkRFJKWjFwRmMxRRAB'),
  'clinic', @clinic_id,
  'Hvala vam', 'hr',
  'Hvala vam', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-04-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xrM2JrcElkVzlJY0dOQk5ERjRhVlIxTTFRMldIYxAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/Ci9DQUlRQUNvZENodHljRjlvT25KMk0weFhlRFpVZERkRFp6WlVaMkZxUTJZNE5FRRAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnTUNRNTR5NlpBEAE'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURscjctem9RRRAB'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2024-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ1b3RDY0ZBEAE'),
  'clinic', @clinic_id,
  'Hvala', 'hr',
  'Hvala', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURaX2F1R3lnRRAB'),
  'clinic', @clinic_id,
  'Hvala Vam Radoje na ocjeni.', 'hr',
  'Hvala Vam Radoje na ocjeni.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSURCbV9laWxRRRAB'),
  'clinic', @clinic_id,
  'Hvala Sandra', 'hr',
  'Hvala Sandra', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtMXR1UWpnRRAB'),
  'clinic', @clinic_id,
  'Hvala puno', 'hr',
  'Hvala puno', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNXXzVqQlVnEAE'),
  'clinic', @clinic_id,
  'Hvala puno.', 'hr',
  'Hvala puno.', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2022-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSURtd3ZuSEtnEAE'),
  'clinic', @clinic_id,
  'Hvala vam', 'hr',
  'Hvala vam', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUNtalByTkVREAE'),
  'clinic', @clinic_id,
  'Hvala velika Nina', 'hr',
  'Hvala velika Nina', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2022-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM2clp1MWJ3EAE'),
  'clinic', @clinic_id,
  'Hvala Draško, nikad nije kasno za odgovor', 'hr',
  'Hvala Draško, nikad nije kasno za odgovor', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2023-10-29 00:00:00')
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJCU-J5kLrTRMRvx5Ou2CKSfo/reviews/ChZDSUhNMG9nS0VJQ0FnSUM0NEpTblBREAE'),
  'clinic', @clinic_id,
  'Hvala Vam Kaća', 'hr',
  'Hvala Vam Kaća', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2019-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
