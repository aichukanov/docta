-- Insert Google Maps reviews for POLIKLINIKA AK MEDICA
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/reviews-google/poliklinika-ak-medica-bijelo-polje.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 0: Clinic and doctor IDs
-- ═══════════════════════════════════════════════════════════════

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-ak-medica-bijelo-polje');
SET @clinic_guard = (SELECT 1 UNION ALL SELECT 1 FROM dual WHERE @clinic_id IS NULL);

-- ═══════════════════════════════════════════════════════════════
-- PART 1: Create phantom users + set user_id variables
-- ═══════════════════════════════════════════════════════════════

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Narcisa Muric-Skoko', 'https://lh3.googleusercontent.com/a/ACg8ocLxeo1SRpR53i2Q782MJ1M7iKMNSEG6-ea1kz_Bju50Ms6nD-U=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104460353787682224651/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104460353787682224651/reviews');
SET @user_narcisa_muricskoko = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104460353787682224651/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Rasema Spahić', 'https://lh3.googleusercontent.com/a-/ALV-UjXRCh39Ap2lrbjaRl9SFAZ7r4d1RYDxEhQKsECFKQ2xrGdjqQk=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/104866340924657956345/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104866340924657956345/reviews');
SET @user_rasema_spahi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/104866340924657956345/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Milica. Zindovic', 'https://lh3.googleusercontent.com/a/ACg8ocLWSZnVOS9GtcCjWHK3MdMJj0gG_1LhWfv3a3hB8MnFRczPJQ=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/107897893191126923192/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107897893191126923192/reviews');
SET @user_milica_zindovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/107897893191126923192/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adis Kucevic', 'https://lh3.googleusercontent.com/a/ACg8ocKizgjgY5RNRlMQTjSodZb9LHBJurwKhBEHPOLXt1BtU-g9pw=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/100804804885820258804/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100804804885820258804/reviews');
SET @user_adis_kucevic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100804804885820258804/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Irena Veličković', 'https://lh3.googleusercontent.com/a-/ALV-UjU3SvignpHT4ZNfRCXoIGPVYP-iTBoSqjXTr7aw0g9xafYEvza0=s128-c0x00000000-cc-rp-mo', 'https://www.google.com/maps/contrib/114085004341064142969/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114085004341064142969/reviews');
SET @user_irena_velikovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/114085004341064142969/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Dženita Mahmutović', 'https://lh3.googleusercontent.com/a-/ALV-UjXjI70UpUJT8_xIyzRYJyRE9xZet6JTS0t2KjTwyQAiqfnTJ1vs=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/109788713935326372588/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109788713935326372588/reviews');
SET @user_denita_mahmutovi = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/109788713935326372588/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Adis Trubljanin', 'https://lh3.googleusercontent.com/a/ACg8ocIjNRDt4kpfunYnCBnldV9Kn-tjIzqU9rRDkbFoBy2f0YRpqQ=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/103239749759756278103/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103239749759756278103/reviews');
SET @user_adis_trubljanin = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/103239749759756278103/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Demir Seratlic', 'https://lh3.googleusercontent.com/a/ACg8ocJdAk0HlMb1-Eu40xxIAE9alLM-WZPSh2yhutSX5WdDW9Opjw=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/100101781143776831408/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100101781143776831408/reviews');
SET @user_demir_seratlic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/100101781143776831408/reviews');

INSERT INTO auth_users (email, name, photo_url, profile_url, is_phantom)
SELECT NULL, 'Ena Muhovic', 'https://lh3.googleusercontent.com/a/ACg8ocI5NW7M6muhZIBfCvgl8ZKg1pvIseDq56MOXpaa6w5BuyHPC70=w36-h36-p-rp-mo-br100', 'https://www.google.com/maps/contrib/105033274141882810238/reviews', TRUE
FROM dual WHERE NOT EXISTS (SELECT 1 FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105033274141882810238/reviews');
SET @user_ena_muhovic = (SELECT id FROM auth_users WHERE profile_url = 'https://www.google.com/maps/contrib/105033274141882810238/reviews');

-- ═══════════════════════════════════════════════════════════════
-- PART 2: Insert reviews
-- ═══════════════════════════════════════════════════════════════

INSERT INTO reviews (user_id, clinic_id, doctor_id, provider, provider_review_id, rating, original_language, original_text, text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr, likes_count, published_at) VALUES
(@user_narcisa_muricskoko, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT2sxMFZXbEdkR05zYkcxMWEzcHllbU5GTldKTFRFRRAB',
    3, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-02-26 03:37:09'),

(@user_rasema_spahi, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT2twbk4xTkdOM1IxTFZvd0xWOU9TMFJGUVVkZmJFRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-12 09:15:54'),

(@user_milica_zindovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xSSVNrdGxVVUZhWms1eE1HeE1NVTF2WlRocFlXYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-08 14:05:41'),

(@user_adis_kucevic, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT2tSTmF6TlFRbTVpV0d0VFRpMTBVMGRQVlhSMlFWRRAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-11-08 14:05:26'),

(@user_irena_velikovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT2xsb09XeGxXSFJPVURWUmVscE5jMDVtZEVWRmEzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2025-10-10 08:34:26'),

(@user_denita_mahmutovi, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT25ack9XOXpXak5yTlVoRlJ6bERNMUkxWkdscVduYxAB',
    5, 'en', 'Very kind and friendly staff. The doctors are attentive and professional. The clinic is clean and well-organized, with minimal waiting time. Highly recommended.',
    NULL, NULL, 'Very kind and friendly staff. The doctors are attentive and professional. The clinic is clean and well-organized, with minimal waiting time. Highly recommended.', NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_adis_trubljanin, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT25Zd0xYTXliV3BsWTA0MU1IRnlNRzFVZEVZNU1uYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_demir_seratlic, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT25wRVgyNVhaMEZIYWpOUGREa3hVMXBvTVZkcGMzYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00'),

(@user_ena_muhovic, @clinic_id, NULL, 'google_maps',
    'places/ChIJp_rPsp2lUhMRAP5YnLNnO7I/reviews/Ci9DQUlRQUNvZENodHljRjlvT2podFNVUlhYMWQzZUZORGExcGthekptY0dsbWRHYxAB',
    5, 'ru', NULL,
    NULL, NULL, NULL, NULL, NULL, NULL,
    0, '2026-04-29 00:00:00')
ON DUPLICATE KEY UPDATE
  rating = VALUES(rating), likes_count = VALUES(likes_count),
  text_sr = COALESCE(VALUES(text_sr), text_sr),
  text_sr_cyrl = COALESCE(VALUES(text_sr_cyrl), text_sr_cyrl),
  text_en = COALESCE(VALUES(text_en), text_en),
  text_ru = COALESCE(VALUES(text_ru), text_ru),
  text_de = COALESCE(VALUES(text_de), text_de),
  text_tr = COALESCE(VALUES(text_tr), text_tr);
