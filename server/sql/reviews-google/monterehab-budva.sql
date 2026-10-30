-- Insert Google Maps reviews for MonteRehab
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/monterehab-budva.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'monterehab-budva');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Мертвый Глаз', 'https://lh3.googleusercontent.com/a/ACg8ocLEY1njgT74IzYP097H79regQ-TT6Hm4ph9lUYC7viG_lqvSw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/118281718540924984414/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118281718540924984414/reviews');
SET @user_mertvyy_glaz = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/118281718540924984414/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Mary Mur', 'https://lh3.googleusercontent.com/a-/ALV-UjWyIcdPADkgsx2LgMFEaLJBUjCmKT_k2-1P9K4qdh0Nqi-rUb4O=s128-c0x00000000-cc-rp-mo-ba4', 'https://www.google.com/maps/contrib/113319146990555290412/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113319146990555290412/reviews');
SET @user_mary_mur = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113319146990555290412/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Valeriia Bulhakova', 'https://lh3.googleusercontent.com/a-/ALV-UjXcZ6nh_uWmlPMkaXt_Mh-_h0islKoKB5ue4rCuFGDa3y_vntY=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/106378709722775751176/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106378709722775751176/reviews');
SET @user_valeriia_bulhakova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/106378709722775751176/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Елена Егорова', 'https://lh3.googleusercontent.com/a-/ALV-UjVsyOlvaMLprf00dTlXg09LCIEs2rMpT1qySxcRpuMZz5aZnRr8=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/102421218156952015165/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102421218156952015165/reviews');
SET @user_elena_egorova = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/102421218156952015165/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Геннадий Ли', 'https://lh3.googleusercontent.com/a/ACg8ocL0Myl6rM-wDo0N6s8I5dCo22_glxWr-3ml5q9cA3iYM4PpfQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114581709333782149208/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114581709333782149208/reviews');
SET @user_gennadiy_li = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114581709333782149208/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Дмитрий Чуга (Forex трейдер)', 'https://lh3.googleusercontent.com/a-/ALV-UjUNgX9wNFacEpkwR5kGQWl8BVy0DTNhs8qK0Nq2hPl6_Y7nOkwriA=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/113924294904988366188/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113924294904988366188/reviews');
SET @user_dmitriy_chuga_forex_treyder = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/113924294904988366188/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Timur Rubanov', 'https://lh3.googleusercontent.com/a-/ALV-UjWghsxXbv8dXvkEvyMGv-1NZxlFoOnwequPAlaWusH7FvLdZzcB=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/104409150463829876702/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104409150463829876702/reviews');
SET @user_timur_rubanov = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104409150463829876702/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Максимилиан Домбровски', 'https://lh3.googleusercontent.com/a-/ALV-UjW51NsP0zCC4i2pVHGJ6lYf8_dBY_rr9QBwnM_w7upnDYm2W4nP=w36-h36-p-rp-mo-ba12-br100', 'https://www.google.com/maps/contrib/112500579951200929589/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112500579951200929589/reviews');
SET @user_maksimilian_dombrovski = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/112500579951200929589/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Алексей Пронин', 'https://lh3.googleusercontent.com/a-/ALV-UjWbox2eN0C0oyWUUs37NhjmtGTx3nQ9SVxt4vEByzhVVMe9kAXB=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/101148013051060497610/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101148013051060497610/reviews');
SET @user_aleksey_pronin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/101148013051060497610/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_mertvyy_glaz, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2pGTFUxSkJOMkZhTjIxZlRscGlZbmhSYlUxdFQwRRAB',
    5, 'ru', 'ProfReab — это место, где действительно помогают. Без осуждения, без формальности, с вниманием к каждому. Здесь чувствуешь себя не пациентом, а человеком, у которого есть шанс начать заново. Спасибо команде — за поддержку, честность и профессионализм.',
    'ProfReab je mesto gde oni zaista pomažu. Nema presude, nema formalnosti i prema svima se postupa pažljivo. Ovde se ne osećate kao pacijent, već kao osoba sa šansom da počne iznova. Hvala timu na podršci, poštenju i profesionalnosti.', 'ПрофРеаб је место где они заиста помажу. Нема пресуде, нема формалности и према свима се поступа пажљиво. Овде се не осећате као пацијент, већ као особа са шансом да почне изнова. Хвала тиму на подршци, поштењу и професионалности.', NULL, 'ProfReab — это место, где действительно помогают. Без осуждения, без формальности, с вниманием к каждому. Здесь чувствуешь себя не пациентом, а человеком, у которого есть шанс начать заново. Спасибо команде — за поддержку, честность и профессионализм.', NULL, NULL,
    0, '2025-10-29 17:26:28'),

(@user_mary_mur, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvaXB5RVBnEAE',
    5, 'en', 'The powerful therapy for people with addictions. It works!
(including special healers - doggies)',
    'Snažna terapija za osobe sa zavisnostima. Radi!
(uključujući posebne iscelitelje - kučiće)', 'Снажна терапија за особе са зависностима. Ради!
(укључујући посебне исцелитеље - кучиће)', 'The powerful therapy for people with addictions. It works!
(including special healers - doggies)', NULL, NULL, NULL,
    0, '2025-04-16 14:58:00'),

(@user_valeriia_bulhakova, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/ChZDSUhNMG9nS0VJQ0FnTUNvNHBqVEpBEAE',
    5, 'ru', 'Люблю это место и сотрудников центра. И собак! 😅

Благодарность  ❤️',
    'Volim ovo mesto i osoblje. I psi! 😅

Hvala ti ❤', 'Волим ово место и особље. И пси! 😅

Хвала ти ❤', NULL, 'Люблю это место и сотрудников центра. И собак! 😅

Благодарность  ❤️', NULL, NULL,
    0, '2025-04-15 20:47:43'),

(@user_elena_egorova, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/ChZDSUhNMG9nS0VJQ0FnTUNveXRqTlpBEAE',
    5, 'ru', 'Невероятной красоты место, прекрасная, профессиональная команда.',
    'Neverovatno lepo mesto, divan, profesionalan tim.', 'Невероватно лепо место, диван, професионалан тим.', NULL, 'Невероятной красоты место, прекрасная, профессиональная команда.', NULL, NULL,
    0, '2025-04-16 07:01:29'),

(@user_gennadiy_li, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT201TGRXRTJXVWxZZVZWbVNsZHdkbnBuTUhCRldFRRAB',
    5, 'ru', 'Мне тут помогли',
    'Ovde su mi pomogli', 'Овде су ми помогли', NULL, 'Мне тут помогли', NULL, NULL,
    0, '2025-10-21 19:00:00'),

(@user_dmitriy_chuga_forex_treyder, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tneWIzTnViM1ZxV0RaMGFFMXpVR00zVlc1S1kwRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-09-29 00:00:00'),

(@user_timur_rubanov, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/ChdDSUhNMG9nS0VJQ0FnTUNvNnZLTjZ3RRAB',
    5, 'ru', 'То, что я называю домом',
    NULL, NULL, NULL, 'То, что я называю домом', NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_maksimilian_dombrovski, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/ChZDSUhNMG9nS0VJQ0FnTUNva3FpOEVBEAE',
    5, 'ru', 'Команда профессионалов!',
    NULL, NULL, NULL, 'Команда профессионалов!', NULL, NULL,
    0, '2025-10-29 00:00:00'),

(@user_aleksey_pronin, @clinic_id, NULL, 'google_maps',
    'places/ChIJH5qWtknXTRMRvbZK1sxa4XQ/reviews/ChdDSUhNMG9nS0VJQ0FnTUNva3Fqa2xRRRAB',
    5, 'ru', 'Кофе вкусный',
    NULL, NULL, NULL, 'Кофе вкусный', NULL, NULL,
    0, '2025-10-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
