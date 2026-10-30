-- Insert Google Maps reviews for Stomatološka Ordinacija ĐUROVIĆ
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/stomatoloska-ordinacija-djurovic-kolasin.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'stomatoloska-ordinacija-djurovic-kolasin');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_danilo_djurovic = (SELECT id FROM doctors WHERE slug = 'danilo-djurovic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nemanja Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjXJToNNwsXEP44sij5LbVE2MVPhg-2TkqJ5d_z_5p-9XVxtl0Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100997189238088203530/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100997189238088203530/reviews');
SET @user_nemanja_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100997189238088203530/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Simon Northcott', 'https://lh3.googleusercontent.com/a-/ALV-UjVP9BIXcLesCV7BZWelf0bWzy_yr7TAzQ3J27SCjHccnBhu5lCL=s128-c0x00000000-cc-rp-mo-ba2', 'https://www.google.com/maps/contrib/102602567000442756355/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102602567000442756355/reviews');
SET @user_simon_northcott = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102602567000442756355/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Petar Bulatovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUXWcsDSEiE7lS7hYiBEBPKSzuuyZu5n6TMsH_z6GQKADKNf9Q=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106322575742546250303/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106322575742546250303/reviews');
SET @user_petar_bulatovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106322575742546250303/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nikola Simic', 'https://lh3.googleusercontent.com/a-/ALV-UjWMB40wX808vuKvXefltGi4ccJfm97ykrzJFBBBGdxDhhFu0M8=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/112380355466818065904/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112380355466818065904/reviews');
SET @user_nikola_simic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112380355466818065904/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'vesna braunovic', 'https://lh3.googleusercontent.com/a/ACg8ocLQin31uZN8GurTD0hmRdRe51SHnhgugNCZjncx7GD0XekYfw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111772158512127998736/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111772158512127998736/reviews');
SET @user_vesna_braunovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111772158512127998736/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vucic Boskovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVlHN6txiuyH3cX5cSVtq5gIfVut9pbhVcWwAH22nrAdZ_gy8wx=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/117137325445037812297/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117137325445037812297/reviews');
SET @user_vucic_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117137325445037812297/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Zrnojed Zrnojedović', 'https://lh3.googleusercontent.com/a/ACg8ocJhtJdQhrzbi9DIW-PY8i6X2MVQUbvND-anBo09A73l0XK6yQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101353769090888108686/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101353769090888108686/reviews');
SET @user_zrnojed_zrnojedovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101353769090888108686/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ranka Rakocevic', 'https://lh3.googleusercontent.com/a/ACg8ocJzn7ZT-NjMeqSi9I_R__hvV9W-9guPwiLpgqKNN8nTLV7tYg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108502806119683594115/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108502806119683594115/reviews');
SET @user_ranka_rakocevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108502806119683594115/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veselin Boskovic', 'https://lh3.googleusercontent.com/a/ACg8ocJwB16lcJUL2MEsiZvuw3eohiE8TFR-7ApuYSuqf8ieWGWeiQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113394751060464709902/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113394751060464709902/reviews');
SET @user_veselin_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113394751060464709902/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Veso Gjuga', 'https://lh3.googleusercontent.com/a/ACg8ocI7qxIh0IhrNCnsOL8DCxNNopsjlEy5zoj3dsAz4jvNu8YmWA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100018222933118894886/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100018222933118894886/reviews');
SET @user_veso_gjuga = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100018222933118894886/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Sonja Boskovic', 'https://lh3.googleusercontent.com/a/ACg8ocIKnwret2NtXXpuczMu_VaCfMKGx1M12F0Jlqn588JgmSue1Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107845539081267656360/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107845539081267656360/reviews');
SET @user_sonja_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107845539081267656360/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mileva Boskovic', 'https://lh3.googleusercontent.com/a/ACg8ocKuZVr8oRBXopiAWligeJcYWdGo3pVSfm45FXfIw8SMdFsf3Q=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116998941966922821806/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116998941966922821806/reviews');
SET @user_mileva_boskovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116998941966922821806/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Danijel Dulovic', 'https://lh3.googleusercontent.com/a/ACg8ocIWD7arJzrv3xI9qLBolSruBZSBQI9meUdNyte_SZZIcqVB7g=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101744825400246111273/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101744825400246111273/reviews');
SET @user_danijel_dulovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101744825400246111273/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica Pandurica', 'https://lh3.googleusercontent.com/a/ACg8ocJYDcLNY95JvI4t0TlRDffT7OqTUHYYVtrIsoHut8GFDJGW6w=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102886247746325171382/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102886247746325171382/reviews');
SET @user_milica_pandurica = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102886247746325171382/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vasilije Mijovic', 'https://lh3.googleusercontent.com/a-/ALV-UjVci64t8MkmEDhzzyEBIIAdHA1xA2xn-zSQW5OIZobkwpgaLJcKmA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100812483228786251338/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100812483228786251338/reviews');
SET @user_vasilije_mijovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100812483228786251338/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ryme', 'https://lh3.googleusercontent.com/a-/ALV-UjXYAGK3nvquGZT2AAe-BN9AdAiALCh5mB0i2-9QHXBSUGcJlmA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113439821923704414652/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113439821923704414652/reviews');
SET @user_ryme = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113439821923704414652/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Kristina Zindovic', 'https://lh3.googleusercontent.com/a/ACg8ocLP6XKkYSzTNooioaucuMnMPKLuQCd_BrBZNrfQxz_P44sw9A=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101162175475133154819/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101162175475133154819/reviews');
SET @user_kristina_zindovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101162175475133154819/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrija Zirojević', 'https://lh3.googleusercontent.com/a/ACg8ocL3fq_DKba_LWIhyXGkn1nAnNttdAjdq8uyJ6xVmRH6RlgovA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117641684830988128286/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117641684830988128286/reviews');
SET @user_andrija_zirojevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117641684830988128286/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jasna Vukicevic', 'https://lh3.googleusercontent.com/a/ACg8ocIEK_9jTUVArjlK51_79Muhi7DPF3s4FOEMCQ5mMCQLz59Jzg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/115217516801195693004/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115217516801195693004/reviews');
SET @user_jasna_vukicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115217516801195693004/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ksenija Palevic', 'https://lh3.googleusercontent.com/a/ACg8ocIJ3LCrd6Uz4WdG9lzhHQr3ub6BplKCOLL9MXtgjObLGYYaYA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105545709814931514430/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105545709814931514430/reviews');
SET @user_ksenija_palevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105545709814931514430/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena Perovic', 'https://lh3.googleusercontent.com/a-/ALV-UjUdMHvJofmGc7tjI964t8B_WX2Fb05xr87Wu7y1wbz8hq43UMDK=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111966791443911738558/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111966791443911738558/reviews');
SET @user_jelena_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111966791443911738558/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_nemanja_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WTk0wRlVUbDk1WDNoTGJXNDJiSEJUV0hCR2JtYxAB',
    5, 'hr', 'Ovim putem želim izraziti izuzetno zadovoljstvo uslugama. Profesionalnost, stručnost i posvećenost pacijentu su na prvom mjestu!!! Naša topla preporuka!',
    'Želeo bih da iskoristim ovu priliku da izrazim svoje izuzetno zadovoljstvo uslugama. Profesionalizam, stručnost i posvećenost pacijentu su na prvom mestu!!! Naša topla preporuka!', 'Желео бих да искористим ову прилику да изразим своје изузетно задовољство услугама. Професионализам, стручност и посвећеност пацијенту су на првом месту!!! Наша топла препорука!', NULL, NULL, NULL, NULL,
    0, '2026-02-20 16:56:25'),

(@user_simon_northcott, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChZDSUhNMG9nS0VJQ0FnSURkcU83Q013EAE',
    5, 'en', 'Needed a filling on holiday. Waited in line for 30’ then was dealt with very quickly and painlessly',
    'Bila mi je potrebna plomba na odmoru. Čekao sam u redu 30 minuta, a onda je sve rešeno veoma brzo i bezbolno.', 'Била ми је потребна пломба на одмору. Чекао сам у реду 30 минута, а онда је све решено веома брзо и безболно.', 'Needed a filling on holiday. Waited in line for 30’ then was dealt with very quickly and painlessly', NULL, NULL, NULL,
    0, '2024-02-20 16:50:49'),

(@user_petar_bulatovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSdGVEZHNPVVJ3UkRSNk0xcHVVUzFsTmtRNWRGRRAB',
    5, 'hr', 'Sve pohvale',
    'Sve pohvale', 'Све похвале', NULL, NULL, NULL, NULL,
    0, '2026-02-23 10:49:10'),

(@user_nikola_simic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsVE4yTkdUM05XWTB3emQzRjRkMjVYVFRBM09FRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-05 17:25:19'),

(@user_vesna_braunovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT200eVNEY3pkazlNVDNwd2QwZHdiVzkzY0cxUVZIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-25 13:28:18'),

(@user_vucic_boskovic, @clinic_id, @doctor_danilo_djurovic, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pOSE5qSmhja3MyVWtoRFZFVjVlbk51TlhsT1pIYxAB',
    5, 'en', 'We had a really good experience at this dental office. My daughter was a patient here, and the staff made her feel so comfortable and relaxed. Dr. Danilo was super gentle and explained everything clearly. We\'re so happy with the care we got and would totally recommend them to anyone looking for a great dental team. It was a truly positive visit for us!',
    NULL, NULL, 'We had a really good experience at this dental office. My daughter was a patient here, and the staff made her feel so comfortable and relaxed. Dr. Danilo was super gentle and explained everything clearly. We\'re so happy with the care we got and would totally recommend them to anyone looking for a great dental team. It was a truly positive visit for us!', NULL, NULL, NULL,
    0, '2026-08-29 00:00:00'),

(@user_zrnojed_zrnojedovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21SR2RreHBYMnN5T1d0S01XTXRZVzh0ZUROMlUwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-05-29 00:00:00'),

(@user_ranka_rakocevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwUE1FeHZNVWwwYUdSc1dEbHZiamhGYWxkcFVuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_veselin_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GbFdUVTRMVmd0TldaeVQzVnBXa3RNU21KeFJXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_veso_gjuga, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWS1NucERXRmh6T1hWelFYcEpYMVYwTW5JNGFsRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_sonja_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sV0xWUkVkbWh4WkV4UmNVSnpPVkY2VmxoM2EzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_mileva_boskovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkNVQySndlR3hvUkVnMGMwRm1aMVJ1Y25sWFVtYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_danijel_dulovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205WlRXeFNZbGhRVW5Cc1QxWTNTRkJxTlVsaWFVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_milica_pandurica, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s4eFJFWjRSMDV6YlVoMWVsaHlialZwWmxGU1RIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_vasilije_mijovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoZmNtNDJUbkpmUlROZlZYWnVTRWRmYjI5M1VuYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_ryme, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205Wk5scGlNM1pYUzFaTk9GZGpUamREYlZBNGQyYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-03-01 00:00:00'),

(@user_kristina_zindovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkZk5rZzRZbUUzTkU4MWMxWnJRME5UZUZkT09GRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_andrija_zirojevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnanYtWHFRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_jasna_vukicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5X29ueEtnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_ksenija_palevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjbjdlMVhREAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2020-10-29 00:00:00'),

(@user_jelena_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChdDSUhNMG9nS0VJQ0FnSURNaGJDRnBBRRAB',
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT25WTk0wRlVUbDk1WDNoTGJXNDJiSEJUV0hCR2JtYxAB'),
  'clinic', @clinic_id,
  '👍👍👍', 'sr',
  '👍👍👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChZDSUhNMG9nS0VJQ0FnSURkcU83Q013EAE'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSdGVEZHNPVVJ3UkRSNk0xcHVVUzFsTmtRNWRGRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsVE4yTkdUM05XWTB3emQzRjRkMjVYVFRBM09FRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT200eVNEY3pkazlNVDNwd2QwZHdiVzkzY0cxUVZIYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xwUE1FeHZNVWwwYUdSc1dEbHZiamhGYWxkcFVuYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GbFdUVTRMVmd0TldaeVQzVnBXa3RNU21KeFJXYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tWS1NucERXRmh6T1hWelFYcEpYMVYwTW5JNGFsRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT21sV0xWUkVkbWh4WkV4UmNVSnpPVkY2VmxoM2EzYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pkNVQySndlR3hvUkVnMGMwRm1aMVJ1Y25sWFVtYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205WlRXeFNZbGhRVW5Cc1QxWTNTRkJxTlVsaWFVRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2s4eFJFWjRSMDV6YlVoMWVsaHlialZwWmxGU1RIYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xoZmNtNDJUbkpmUlROZlZYWnVTRWRmYjI5M1VuYxAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT205Wk5scGlNM1pYUzFaTk9GZGpUamREYlZBNGQyYxAB'),
  'clinic', @clinic_id,
  '👍👍👍👍', 'sr',
  '👍👍👍👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkZk5rZzRZbUUzTkU4MWMxWnJRME5UZUZkT09GRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChdDSUhNMG9nS0VJQ0FnTUNnanYtWHFRRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChZDSUhNMG9nS0VJQ0FnSUR5X29ueEtnEAE'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChZDSUhNMG9nS0VJQ0FnSUNjbjdlMVhREAE'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
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
  (SELECT id FROM reviews WHERE provider = 'google_maps' AND provider_review_id = 'places/ChIJ1UEIXoF9TRMRmL9j1wA5KOY/reviews/ChdDSUhNMG9nS0VJQ0FnSURNaGJDRnBBRRAB'),
  'clinic', @clinic_id,
  '👍', 'sr',
  '👍', NULL, NULL, NULL, NULL, NULL,
  'google_maps', '2026-03-01 00:00:00')
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
