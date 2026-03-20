-- Telegram reviews import: МЕДИЦИНА | ВРАЧИ | ЧЕРНОГОРИЯ
-- Generated: 2026-03-20T10:55:37.694Z
-- Source: data/review-import-configs/telegram-medicina-cg.json
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-reviews-telegram-medicina-cg.sql

SET NAMES utf8mb4;

-- =====================================================
-- PART 1: Phantom users
-- =====================================================

-- User: valdas2020 (telegram:485544391)
SET @tg_user_485544391 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '485544391'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'valdas2020', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_485544391 IS NULL;
SET @tg_user_485544391 = COALESCE(@tg_user_485544391, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_485544391, 'telegram', '485544391', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 485544391, 'valdas2020', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '485544391';

-- User: Tim (telegram:6422508308)
SET @tg_user_6422508308 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6422508308'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Tim', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6422508308 IS NULL;
SET @tg_user_6422508308 = COALESCE(@tg_user_6422508308, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6422508308, 'telegram', '6422508308', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6422508308, 'Tim', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6422508308';

-- User: Luciana ✨ (telegram:1567355729)
SET @tg_user_1567355729 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1567355729'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Luciana ✨', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1567355729 IS NULL;
SET @tg_user_1567355729 = COALESCE(@tg_user_1567355729, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1567355729, 'telegram', '1567355729', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1567355729, 'Luciana ✨', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1567355729';

-- =====================================================
-- PART 2: Reviews
-- =====================================================

-- Review by valdas2020 (2026-01-26T20:35:11)
INSERT INTO reviews (
  user_id, clinic_id, doctor_id,
  provider, provider_review_id,
  rating, original_language, original_text,
  text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr,
  published_at
) VALUES (
  @tg_user_485544391, 57, 627,
  'telegram', 'tg_1590026293_108177',
  5, 'ru', 'Хочу оставить отзыв о докторе Олеге Виноградове, неврологе. Замечательный доктор, на прошлой неделе был у него на приеме (в Будве), многие проблемы стали понятны, буду продолжать у него лечиться.\n👍\nРекомендую всем, кому нужна неврология.💯',
  'Želim da ostavim recenziju o doktoru Olegu Vinogradovu, neurologu. Izvanredan doktor, prošle nedelje sam bio kod njega na pregledu (u Budvi), mnogi problemi su postali jasniji, nastaviću da se lečim kod njega.\n👍\nPreporučujem svima kojima je potrebna neurologija.💯', 'Желим да оставим рецензију о доктору Олегу Виноградову, неврологу. Изванредан доктор, прошле недеље сам био код њега на прегледу (у Будви), многи проблеми су постали јаснији, наставићу да се лечим код њега.\n👍\nПрепоручујем свима којима је потребна неурологија.💯', 'I want to leave a review about Dr. Oleg Vinogradov, a neurologist. An excellent doctor, last week I had an appointment with him (in Budva), many issues became clearer, and I will continue my treatment with him.\n👍\nI recommend him to everyone who needs neurology.💯', 'Хочу оставить отзыв о докторе Олеге Виноградове, неврологе. Замечательный доктор, на прошлой неделе был у него на приеме (в Будве), многие проблемы стали понятны, буду продолжать у него лечиться.\n👍\nРекомендую всем, кому нужна неврология.💯', 'Ich möchte eine Bewertung über Dr. Oleg Vinogradov, einen Neurologen, hinterlassen. Ein hervorragender Arzt, letzte Woche war ich bei ihm in der Sprechstunde (in Budva), viele Probleme wurden klarer, ich werde meine Behandlung bei ihm fortsetzen.\n👍\nIch empfehle ihn allen, die Neurologie brauchen.💯', 'Nörolog Dr. Oleg Vinogradov hakkında bir değerlendirme bırakmak istiyorum. Mükemmel bir doktor, geçen hafta Budva\'da muayenesine gittim, birçok sorun netleşti, tedavime onunla devam edeceğim.\n👍\nNörolojiye ihtiyacı olan herkese tavsiye ediyorum.💯',
  '2026-01-26T20:35:11'
)
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = VALUES(text_sr), text_sr_cyrl = VALUES(text_sr_cyrl),
  text_en = VALUES(text_en), text_ru = VALUES(text_ru),
  text_de = VALUES(text_de), text_tr = VALUES(text_tr);

-- NOTE: Doctor Яна Соловцова is NOT in our database — this review has no doctor_id/clinic_id link. Consider adding this doctor to the DB.
-- SKIPPED: review 108783 (Tim) — no clinic_id or doctor_id mapped
-- Text: Хочу оставить отзыв о дерматологе Яна Соловцова @yanasolovtsova, которая принимает в Баре. Выбрал им...

-- Review by Luciana ✨ (2026-03-03T17:10:43)
INSERT INTO reviews (
  user_id, clinic_id, doctor_id,
  provider, provider_review_id,
  rating, original_language, original_text,
  text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr,
  published_at
) VALUES (
  @tg_user_1567355729, 17, 317,
  'telegram', 'tg_1590026293_108929',
  NULL, 'ru', 'Советую Владимира из Боно медики',
  'Preporučujem Vladimira iz BonoMedica', 'Препоручујем Владимира из BonoMedica', 'I recommend Vladimir from BonoMedica', 'Советую Владимира из Боно медики', 'Ich empfehle Vladimir von BonoMedica', 'BonoMedica\'dan Vladimir\'i tavsiye ederim',
  '2026-03-03T17:10:43'
)
ON DUPLICATE KEY UPDATE
  original_text = VALUES(original_text),
  text_sr = VALUES(text_sr), text_sr_cyrl = VALUES(text_sr_cyrl),
  text_en = VALUES(text_en), text_ru = VALUES(text_ru),
  text_de = VALUES(text_de), text_tr = VALUES(text_tr);

-- =====================================================
-- PART 3: Validation
-- =====================================================

SELECT 'telegram_reviews' AS source, COUNT(*) AS cnt FROM reviews WHERE provider = 'telegram';
