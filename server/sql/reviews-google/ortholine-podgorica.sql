-- Insert Google Maps reviews for Stomatoloska Ordinacija Ortholine
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/ortholine-podgorica.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ortholine-podgorica');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);
SET @doctor_dubravka_babic = (SELECT id FROM doctors WHERE slug = 'dubravka-babic');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Olja Matkovic', 'https://lh3.googleusercontent.com/a/ACg8ocIlNrMDFxws_SwTUpwZvVoCMd8v_7Ps-RdtHRVNox3UH9luVw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/111596334422230121523/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111596334422230121523/reviews');
SET @user_olja_matkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111596334422230121523/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milena Vujacic', 'https://lh3.googleusercontent.com/a/ACg8ocK956olODC9HEutWdABlJOwGCre1JKJlPlAaej6_TZTslKl4A=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/115576516523588236279/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115576516523588236279/reviews');
SET @user_milena_vujacic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/115576516523588236279/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Futura NVO', 'https://lh3.googleusercontent.com/a-/ALV-UjURlFZnJePCIDjBhcU4b0RG9iJtpR3mC_w3L4hCrmJqai9egQk=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114889018779144481607/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114889018779144481607/reviews');
SET @user_futura_nvo = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114889018779144481607/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мария Малыхова', 'https://lh3.googleusercontent.com/a/ACg8ocJtimAcGBXYpydleea_efgdEUbMjThKIHaQpcXXmK7wna7ltA=s128-c0x00000000-cc-rp-mo-ba3', 'https://www.google.com/maps/contrib/117409298130368499266/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117409298130368499266/reviews');
SET @user_mariya_malykhova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/117409298130368499266/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Bozidar Perovic', 'https://lh3.googleusercontent.com/a-/ALV-UjWYZemHPTHVtAVQVMBhN5zvI1q4slsv3XBQYs9pZRmR7ufBZP0=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100408958855614593858/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100408958855614593858/reviews');
SET @user_bozidar_perovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100408958855614593858/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Nese Guclu', 'https://lh3.googleusercontent.com/a-/ALV-UjX82Bm54LKbBh9c_I0toef3jHiFv0zq3V4JfHbtVL2b-vDRRRzD=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/107534922071332713708/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107534922071332713708/reviews');
SET @user_nese_guclu = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107534922071332713708/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Luka Femić', 'https://lh3.googleusercontent.com/a-/ALV-UjXk4mFXkq21w0ahV3O-T_aubWH9DrokXREKnIql05SxXXQgKtCA=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/116852956317113948993/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116852956317113948993/reviews');
SET @user_luka_femi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/116852956317113948993/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Jelena M', 'https://lh3.googleusercontent.com/a-/ALV-UjXDNqgIh3z-IINyomGvAoMrp-holnVbDgRHa6hM8g06eYWTLN8v=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/100327445673736621772/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100327445673736621772/reviews');
SET @user_jelena_m = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100327445673736621772/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Volim Slatkise', 'https://lh3.googleusercontent.com/a-/ALV-UjXYLJAmTV7YuLFXQxcWMRsD9ijmECl9RskktC55dD9VbZRi9AEM=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/110525057606311263290/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110525057606311263290/reviews');
SET @user_volim_slatkise = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/110525057606311263290/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'svjetlana zivkovic', 'https://lh3.googleusercontent.com/a/ACg8ocJEAIL1jk3mhHpX3qPE14IWFJNaXKN5KNRn1G1XRxl2B449Rg=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/111650998903824536879/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111650998903824536879/reviews');
SET @user_svjetlana_zivkovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/111650998903824536879/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_olja_matkovic, @clinic_id, @doctor_dubravka_babic, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChZDSUhNMG9nS0VJQ0FnSUN3eGRQYldREAE',
    5, 'bs', 'Izuzetno profesionalno osoblje i strpljenje Dr. Dubravke ucinilli su lecenje mojih zuba potpuno bezbolnim. Odusevljena sam tretmanom!!! Ovo je definitivno najbolja ordinacija u Podgorici 💎💎💎',
    'Izuzetno profesionalno osoblje i strpljenje dr Dubravke učinili su moj stomatološki tretman potpuno bezbolnim. Oduševljena sam tretmanom!!! Ovo je definitivno najbolja stomatološka ordinacija u Podgorici 💎💎💎', 'Изузетно професионално особље и стрпљење др Дубравке учинили су мој стоматолошки третман потпуно безболним. Одушевљена сам третманом!!! Ово је дефинитивно најбоља стоматолошка ординација у Подгорици 💎💎💎', NULL, NULL, NULL, NULL,
    2, '2018-08-02 12:59:59'),

(@user_milena_vujacic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChdDSUhNMG9nS0VJQ0FnSUMtOHRqdW5RRRAB',
    5, 'hr', 'Sve pohvale za profesionalnost, stručnost i ljubaznost cijelog tima.',
    'Sve pohvale za profesionalnost, stručnost i ljubaznost celog tima.', 'Све похвале за професионалност, стручност и љубазност целог тима.', NULL, NULL, NULL, NULL,
    0, '2022-10-31 14:37:43'),

(@user_futura_nvo, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChZDSUhNMG9nS0VJQ0FnSURnOC1PY2JBEAE',
    5, 'bs', 'Najbolji u Crnoj Gori definitivno .Strucni,ljubazni i opremljeni savremenom tehnologijom.',
    'Definitivno najbolji u Crnoj Gori. Profesionalni, ljubazni i opremljeni savremenom tehnologijom.', 'Дефинитивно најбољи у Црној Гори. Професионални, љубазни и опремљени савременом технологијом.', NULL, NULL, NULL, NULL,
    2, '2018-04-21 08:01:20'),

(@user_mariya_malykhova, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNlOHNUX3hRRRAB',
    1, 'ru', 'С маленьким ребёнком не рекомендую. Просто разводят руками, что не могут ничего сделать тк ребёнок боится.',
    'Ne preporučujem to sa malim detetom. Oni samo sležu ramenima, govoreći da ne mogu ništa jer se dete plaši.', 'Не препоручујем то са малим дететом. Они само слежу раменима, говорећи да не могу ништа јер се дете плаши.', NULL, 'С маленьким ребёнком не рекомендую. Просто разводят руками, что не могут ничего сделать тк ребёнок боится.', NULL, NULL,
    0, '2022-09-10 15:30:12'),

(@user_bozidar_perovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChdDSUhNMG9nS0VLR2gyS21sd2JtU3pRRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-06-12 07:23:27'),

(@user_nese_guclu, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/Ci9DQUlRQUNvZENodHljRjlvT21GS2REWm9NVkJPVmtsWGIzaFpUM2x3T0hSd1pHYxAB',
    5, 'tr', 'Kızımın ortodontik tedavisini yapıyor ve çok memnunuz. İlgisi, yaklaşımı ve tedavisinden çok memnun kaldık. Kesinlikle tavsiye ederim.',
    NULL, NULL, NULL, NULL, NULL, 'Kızımın ortodontik tedavisini yapıyor ve çok memnunuz. İlgisi, yaklaşımı ve tedavisinden çok memnun kaldık. Kesinlikle tavsiye ederim.',
    0, '2026-10-08 00:00:00'),

(@user_luka_femi, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tFM0xXMUJUazVWU0daQlUyeElOakozYzE5YVdYYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-06-29 00:00:00'),

(@user_jelena_m, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChZDSUhNMG9nS0VJQ0FnSUQ5aDlqZ0RnEAE',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2024-10-29 00:00:00'),

(@user_volim_slatkise, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChdDSUhNMG9nS0VJQ0FnSUR5bHVhX3NBRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2021-10-29 00:00:00'),

(@user_svjetlana_zivkovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJ4XH3VlLrTRMRIsNalxWsYSE/reviews/ChdDSUhNMG9nS0VJQ0FnSUNBdHFLbmhnRRAB',
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
