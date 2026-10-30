-- Insert Google Maps reviews for HIRURGIJA Dr Eli
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/hirurgija-dr-eli-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'hirurgija-dr-eli-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrija Pavicevic', 'https://lh3.googleusercontent.com/a/ACg8ocJKGmtDB1sYvmWULL8fsEDsvPJxkq8auFkBEN_I-4dMK1WQiA=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/103090778657694776380/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103090778657694776380/reviews');
SET @user_andrija_pavicevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103090778657694776380/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Vesna Belojevic', 'https://lh3.googleusercontent.com/a/ACg8ocLGdlqc99PqcQda3JGwdRMtEHXDHHFNOH2AOXGQC29tZO5_vw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/101200523857944322886/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101200523857944322886/reviews');
SET @user_vesna_belojevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101200523857944322886/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Amar Agić', 'https://lh3.googleusercontent.com/a-/ALV-UjV1qkaQwrKCMGk9iiFAhDnAxg92kKvZaz7kft2-xzAWjLb7Esnb=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115038948518933281450/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115038948518933281450/reviews');
SET @user_amar_agi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115038948518933281450/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ivana Bakic', 'https://lh3.googleusercontent.com/a/ACg8ocJWunKD3BeqnIn21wFaDz755CjVg6hCjlDpox3YIUgz2z29mQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111989752884101544684/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111989752884101544684/reviews');
SET @user_ivana_bakic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111989752884101544684/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Masa Kovacevic', 'https://lh3.googleusercontent.com/a/ACg8ocKy9AMtJChGJJROg6J6bDd1F9Ap6Vmk-v_mi1kRYtkzgNEwtw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/108386718332294056252/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108386718332294056252/reviews');
SET @user_masa_kovacevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/108386718332294056252/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Emina Avdić', 'https://lh3.googleusercontent.com/a/ACg8ocKkudSD_wZt-4V36kPBWSo25oXycToMXp02p7romioCuB7shgc=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117972487655222293221/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117972487655222293221/reviews');
SET @user_emina_avdi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117972487655222293221/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dražen Vukčević', 'https://lh3.googleusercontent.com/a-/ALV-UjVDkWhMYUj3ebOt9HJMl9wJtk2DhHIaZ3JUV8vAWRaHyysTNyo=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/117227610416959273650/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117227610416959273650/reviews');
SET @user_draen_vukevi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117227610416959273650/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valentina Kuburović', 'https://lh3.googleusercontent.com/a/ACg8ocIUD04BfIXSy05vwAGudIbQaVRyhEff_kbuhLcjnV4BBRKaKQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109904784495939037704/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109904784495939037704/reviews');
SET @user_valentina_kuburovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109904784495939037704/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Andrea', 'https://lh3.googleusercontent.com/a/ACg8ocJ-EwZBa5BRnTaMxDBZ4JfUunpL4NOxHynuUalRvhPxp_laU8U=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/102369600754132910368/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102369600754132910368/reviews');
SET @user_andrea = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102369600754132910368/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dzavid Lamezevic', 'https://lh3.googleusercontent.com/a/ACg8ocI-IghGT9OdwzlwJ7UyMpzv2zgercbCizOSHLo7hj4zy5u8Rg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107960307765321031224/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107960307765321031224/reviews');
SET @user_dzavid_lamezevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107960307765321031224/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Jovovic', 'https://lh3.googleusercontent.com/a/ACg8ocJgwVB-X7fpDZ5De6MzDAxLL71LnIgonyCVZ-hE-qTrpcEFyA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/113918358855414527259/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113918358855414527259/reviews');
SET @user_luka_jovovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113918358855414527259/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ela', 'https://lh3.googleusercontent.com/a/ACg8ocK9xNOT6Itp0NOFmc4X_tsT8Mg2tB-Ocbg-DciUmb_WEIS0zA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/114360109507045380916/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114360109507045380916/reviews');
SET @user_ela = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114360109507045380916/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_andrija_pavicevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT25sSFZrUTRMVzVwTkV0RVdrODJWR0pDUjNsRU5WRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-14 10:23:57'),

(@user_vesna_belojevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xaaGFqZFhlamhrVFdKNVdHdG9NbGxKWTNCV01sRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-14 10:22:28'),

(@user_amar_agi, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xkelgyWkRiVUpVU1RRMFQwMXVNMDltYWt4eVlVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-01-14 10:21:38'),

(@user_ivana_bakic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT214SFVteDFkV05xY0VOSGNFUnZWMUZrV2xnd2IzYxAB',
    5, 'hr', 'Очень любезные и профессиональные! Заслуживают всяческих похвал!',
    'Очень любезные и профессиональные! Заслуживают всяческих похвал!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-26 00:00:00'),

(@user_masa_kovacevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Sb1drMDNaV3cxVUdkUWFtTTVjV2xQUXpaNGQxRRAB',
    5, 'hr', 'Браво больнице! Забота о пациентах и ​​качество обслуживания на высоком уровне. Рекомендую всем!',
    'Браво больнице! Забота о пациентах и ​​качество обслуживания на высоком уровне. Рекомендую всем!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-26 00:00:00'),

(@user_emina_avdi, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tvNGJEVkZNVE5vU2xWdGNFMVhOVlF3T0dod1RIYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-26 00:00:00'),

(@user_draen_vukevi, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tVd01HVTNVM1U1U0MxblEyWTVkVmhoT1RZd1JFRRAB',
    5, 'hr', 'Вся хвала!',
    'Вся хвала!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-26 00:00:00'),

(@user_valentina_kuburovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pZNGFIbDBVMlpYV0RSd1FuWmpiWFpVTjI5VU4xRRAB',
    5, 'bs', 'Профессионализм и доброжелательность на высшем уровне, все рекомендации приветствуются!',
    'Профессионализм и доброжелательность на высшем уровне, все рекомендации приветствуются!', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-25 00:00:00'),

(@user_andrea, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wWU1WQnRNMkZLU0dwbFltVlJXRzlEUXpCRmNXYxAB',
    5, 'hr', 'Профессиональные, эффективные и доброжелательные. Вся хвала команде доктора Эли 🤗',
    'Профессиональные, эффективные и доброжелательные. Вся хвала команде доктора Эли 🤗', NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_dzavid_lamezevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT25oWFMzQnBWR1phTWt0UWFFNUxVbGhXUkhOcVRVRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-10-08 00:00:00'),

(@user_luka_jovovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT2t4QlkwdHZPVll6UTFnMU5FSkVPRkZaVlVVd05tYxAB',
    5, 'hr', 'Первоклассное обслуживание и отличное отношение к пациентам. Рекомендую! ❤️',
    'Первоклассное обслуживание и отличное отношение к пациентам. Рекомендую! ❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-07-29 00:00:00'),

(@user_ela, @clinic_id, NULL, 'google_maps',
    'places/ChIJA_Lh-JHrTRMRR79x3vcFnik/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GVmR6Um9aMHRQTmw5NmJFMHRSa0ZHZDFrelNuYxAB',
    5, 'hr', 'Доброта и профессионализм.

💯 Лучшие!

❤️',
    'Доброта и профессионализм.

💯 Лучшие!

❤️', NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
