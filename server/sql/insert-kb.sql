-- Knowledge Base data import
-- Generated: 2026-03-20T09:38:01.159Z
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-kb.sql

SET NAMES utf8mb4;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

-- =====================================================
-- PART 1: Sources (channels)
-- =====================================================

INSERT INTO kb_sources (provider, provider_source_id, name, metadata)
VALUES ('telegram', '1590026293', 'МЕДИЦИНА | ВРАЧИ | ЧЕРНОГОРИЯ', '{"type":"public_supergroup"}')
ON DUPLICATE KEY UPDATE name = VALUES(name), metadata = VALUES(metadata);

-- =====================================================
-- PART 2: Phantom users from Telegram
-- =====================================================

-- User: Anton (telegram:63044576)
SET @tg_user_63044576 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '63044576'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Anton', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_63044576 IS NULL;
SET @tg_user_63044576 = COALESCE(@tg_user_63044576, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_63044576, 'telegram', '63044576', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 63044576, 'Anton', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '63044576';

-- User: Larissa Blank (telegram:79144498)
SET @tg_user_79144498 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '79144498'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Larissa Blank', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_79144498 IS NULL;
SET @tg_user_79144498 = COALESCE(@tg_user_79144498, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_79144498, 'telegram', '79144498', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 79144498, 'Larissa Blank', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '79144498';

-- User: MACLAUD (telegram:102281608)
SET @tg_user_102281608 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '102281608'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'MACLAUD', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_102281608 IS NULL;
SET @tg_user_102281608 = COALESCE(@tg_user_102281608, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_102281608, 'telegram', '102281608', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 102281608, 'MACLAUD', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '102281608';

-- User: Viktor (telegram:105291894)
SET @tg_user_105291894 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '105291894'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Viktor', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_105291894 IS NULL;
SET @tg_user_105291894 = COALESCE(@tg_user_105291894, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_105291894, 'telegram', '105291894', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 105291894, 'Viktor', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '105291894';

-- User: Masha Molokova (telegram:120048668)
SET @tg_user_120048668 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '120048668'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Masha Molokova', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_120048668 IS NULL;
SET @tg_user_120048668 = COALESCE(@tg_user_120048668, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_120048668, 'telegram', '120048668', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 120048668, 'Masha Molokova', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '120048668';

-- User: Tatyana О. (telegram:126367478)
SET @tg_user_126367478 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '126367478'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Tatyana О.', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_126367478 IS NULL;
SET @tg_user_126367478 = COALESCE(@tg_user_126367478, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_126367478, 'telegram', '126367478', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 126367478, 'Tatyana О.', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '126367478';

-- User: Лариса (telegram:140512321)
SET @tg_user_140512321 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '140512321'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Лариса', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_140512321 IS NULL;
SET @tg_user_140512321 = COALESCE(@tg_user_140512321, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_140512321, 'telegram', '140512321', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 140512321, 'Лариса', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '140512321';

-- User: Ksenia (telegram:173827874)
SET @tg_user_173827874 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '173827874'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ksenia', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_173827874 IS NULL;
SET @tg_user_173827874 = COALESCE(@tg_user_173827874, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_173827874, 'telegram', '173827874', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 173827874, 'Ksenia', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '173827874';

-- User: Светлана (telegram:183191358)
SET @tg_user_183191358 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '183191358'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Светлана', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_183191358 IS NULL;
SET @tg_user_183191358 = COALESCE(@tg_user_183191358, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_183191358, 'telegram', '183191358', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 183191358, 'Светлана', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '183191358';

-- User: Илья Вайнер (telegram:211301931)
SET @tg_user_211301931 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '211301931'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Илья Вайнер', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_211301931 IS NULL;
SET @tg_user_211301931 = COALESCE(@tg_user_211301931, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_211301931, 'telegram', '211301931', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 211301931, 'Илья Вайнер', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '211301931';

-- User: Matt Scarab (telegram:234397392)
SET @tg_user_234397392 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '234397392'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Matt Scarab', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_234397392 IS NULL;
SET @tg_user_234397392 = COALESCE(@tg_user_234397392, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_234397392, 'telegram', '234397392', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 234397392, 'Matt Scarab', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '234397392';

-- User: André (telegram:284957956)
SET @tg_user_284957956 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '284957956'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'André', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_284957956 IS NULL;
SET @tg_user_284957956 = COALESCE(@tg_user_284957956, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_284957956, 'telegram', '284957956', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 284957956, 'André', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '284957956';

-- User: TNSG (telegram:315702534)
SET @tg_user_315702534 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '315702534'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'TNSG', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_315702534 IS NULL;
SET @tg_user_315702534 = COALESCE(@tg_user_315702534, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_315702534, 'telegram', '315702534', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 315702534, 'TNSG', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '315702534';

-- User: Banana (telegram:320596110)
SET @tg_user_320596110 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '320596110'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Banana', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_320596110 IS NULL;
SET @tg_user_320596110 = COALESCE(@tg_user_320596110, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_320596110, 'telegram', '320596110', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 320596110, 'Banana', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '320596110';

-- User: Мила (telegram:332181129)
SET @tg_user_332181129 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '332181129'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Мила', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_332181129 IS NULL;
SET @tg_user_332181129 = COALESCE(@tg_user_332181129, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_332181129, 'telegram', '332181129', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 332181129, 'Мила', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '332181129';

-- User: А͜͡л͜͡ь͜͡к͜͡а͜͡❦А͜͡л͜͡ь͜͡к͜͡а͜͡ (telegram:332313768)
SET @tg_user_332313768 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '332313768'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'А͜͡л͜͡ь͜͡к͜͡а͜͡❦А͜͡л͜͡ь͜͡к͜͡а͜͡', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_332313768 IS NULL;
SET @tg_user_332313768 = COALESCE(@tg_user_332313768, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_332313768, 'telegram', '332313768', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 332313768, 'А͜͡л͜͡ь͜͡к͜͡а͜͡❦А͜͡л͜͡ь͜͡к͜͡а͜͡', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '332313768';

-- User: Котов Сергей (telegram:338203277)
SET @tg_user_338203277 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '338203277'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Котов Сергей', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_338203277 IS NULL;
SET @tg_user_338203277 = COALESCE(@tg_user_338203277, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_338203277, 'telegram', '338203277', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 338203277, 'Котов Сергей', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '338203277';

-- User: Светлана (telegram:361370649)
SET @tg_user_361370649 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '361370649'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Светлана', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_361370649 IS NULL;
SET @tg_user_361370649 = COALESCE(@tg_user_361370649, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_361370649, 'telegram', '361370649', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 361370649, 'Светлана', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '361370649';

-- User: Tania (telegram:370265591)
SET @tg_user_370265591 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '370265591'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Tania', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_370265591 IS NULL;
SET @tg_user_370265591 = COALESCE(@tg_user_370265591, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_370265591, 'telegram', '370265591', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 370265591, 'Tania', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '370265591';

-- User: Людмила (telegram:379372693)
SET @tg_user_379372693 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '379372693'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Людмила', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_379372693 IS NULL;
SET @tg_user_379372693 = COALESCE(@tg_user_379372693, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_379372693, 'telegram', '379372693', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 379372693, 'Людмила', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '379372693';

-- User: Roman (telegram:381708485)
SET @tg_user_381708485 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '381708485'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Roman', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_381708485 IS NULL;
SET @tg_user_381708485 = COALESCE(@tg_user_381708485, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_381708485, 'telegram', '381708485', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 381708485, 'Roman', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '381708485';

-- User: Alex Vin (telegram:387091776)
SET @tg_user_387091776 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '387091776'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Alex Vin', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_387091776 IS NULL;
SET @tg_user_387091776 = COALESCE(@tg_user_387091776, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_387091776, 'telegram', '387091776', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 387091776, 'Alex Vin', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '387091776';

-- User: Zaitceva Oxana (telegram:393615923)
SET @tg_user_393615923 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '393615923'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Zaitceva Oxana', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_393615923 IS NULL;
SET @tg_user_393615923 = COALESCE(@tg_user_393615923, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_393615923, 'telegram', '393615923', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 393615923, 'Zaitceva Oxana', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '393615923';

-- User: Mikhail Kozyrev (telegram:398192727)
SET @tg_user_398192727 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '398192727'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Mikhail Kozyrev', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_398192727 IS NULL;
SET @tg_user_398192727 = COALESCE(@tg_user_398192727, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_398192727, 'telegram', '398192727', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 398192727, 'Mikhail Kozyrev', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '398192727';

-- User: Alina Vayner (telegram:414229249)
SET @tg_user_414229249 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '414229249'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Alina Vayner', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_414229249 IS NULL;
SET @tg_user_414229249 = COALESCE(@tg_user_414229249, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_414229249, 'telegram', '414229249', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 414229249, 'Alina Vayner', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '414229249';

-- User: Катерина Филиппова (telegram:418176416)
SET @tg_user_418176416 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '418176416'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Катерина Филиппова', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_418176416 IS NULL;
SET @tg_user_418176416 = COALESCE(@tg_user_418176416, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_418176416, 'telegram', '418176416', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 418176416, 'Катерина Филиппова', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '418176416';

-- User: Svetlana Alpatova (telegram:422859962)
SET @tg_user_422859962 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '422859962'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Svetlana Alpatova', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_422859962 IS NULL;
SET @tg_user_422859962 = COALESCE(@tg_user_422859962, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_422859962, 'telegram', '422859962', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 422859962, 'Svetlana Alpatova', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '422859962';

-- User: Mary Yakovlieva (telegram:439303151)
SET @tg_user_439303151 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '439303151'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Mary Yakovlieva', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_439303151 IS NULL;
SET @tg_user_439303151 = COALESCE(@tg_user_439303151, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_439303151, 'telegram', '439303151', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 439303151, 'Mary Yakovlieva', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '439303151';

-- User: Mikhail (telegram:449894837)
SET @tg_user_449894837 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '449894837'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Mikhail', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_449894837 IS NULL;
SET @tg_user_449894837 = COALESCE(@tg_user_449894837, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_449894837, 'telegram', '449894837', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 449894837, 'Mikhail', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '449894837';

-- User: € (telegram:453115212)
SET @tg_user_453115212 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '453115212'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT '€', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_453115212 IS NULL;
SET @tg_user_453115212 = COALESCE(@tg_user_453115212, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_453115212, 'telegram', '453115212', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 453115212, '€', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '453115212';

-- User: Iren (telegram:479029454)
SET @tg_user_479029454 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '479029454'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Iren', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_479029454 IS NULL;
SET @tg_user_479029454 = COALESCE(@tg_user_479029454, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_479029454, 'telegram', '479029454', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 479029454, 'Iren', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '479029454';

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

-- User: A✨ (telegram:489330193)
SET @tg_user_489330193 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '489330193'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'A✨', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_489330193 IS NULL;
SET @tg_user_489330193 = COALESCE(@tg_user_489330193, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_489330193, 'telegram', '489330193', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 489330193, 'A✨', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '489330193';

-- User: Sofia (telegram:494082504)
SET @tg_user_494082504 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '494082504'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Sofia', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_494082504 IS NULL;
SET @tg_user_494082504 = COALESCE(@tg_user_494082504, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_494082504, 'telegram', '494082504', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 494082504, 'Sofia', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '494082504';

-- User: Irina Kucenko (telegram:509405298)
SET @tg_user_509405298 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '509405298'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Irina Kucenko', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_509405298 IS NULL;
SET @tg_user_509405298 = COALESCE(@tg_user_509405298, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_509405298, 'telegram', '509405298', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 509405298, 'Irina Kucenko', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '509405298';

-- User: Mnd Barber ✂️ (telegram:527808678)
SET @tg_user_527808678 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '527808678'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Mnd Barber ✂️', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_527808678 IS NULL;
SET @tg_user_527808678 = COALESCE(@tg_user_527808678, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_527808678, 'telegram', '527808678', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 527808678, 'Mnd Barber ✂️', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '527808678';

-- User: Alexander (telegram:618028075)
SET @tg_user_618028075 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '618028075'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Alexander', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_618028075 IS NULL;
SET @tg_user_618028075 = COALESCE(@tg_user_618028075, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_618028075, 'telegram', '618028075', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 618028075, 'Alexander', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '618028075';

-- User: Дмитрий Крищанович (telegram:673058403)
SET @tg_user_673058403 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '673058403'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Дмитрий Крищанович', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_673058403 IS NULL;
SET @tg_user_673058403 = COALESCE(@tg_user_673058403, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_673058403, 'telegram', '673058403', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 673058403, 'Дмитрий Крищанович', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '673058403';

-- User: Arina (telegram:678254807)
SET @tg_user_678254807 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '678254807'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Arina', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_678254807 IS NULL;
SET @tg_user_678254807 = COALESCE(@tg_user_678254807, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_678254807, 'telegram', '678254807', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 678254807, 'Arina', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '678254807';

-- User: Лилуша (telegram:700020194)
SET @tg_user_700020194 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '700020194'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Лилуша', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_700020194 IS NULL;
SET @tg_user_700020194 = COALESCE(@tg_user_700020194, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_700020194, 'telegram', '700020194', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 700020194, 'Лилуша', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '700020194';

-- User: Максим (telegram:724952512)
SET @tg_user_724952512 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '724952512'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Максим', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_724952512 IS NULL;
SET @tg_user_724952512 = COALESCE(@tg_user_724952512, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_724952512, 'telegram', '724952512', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 724952512, 'Максим', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '724952512';

-- User: Никита Бернатов (telegram:745569250)
SET @tg_user_745569250 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '745569250'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Никита Бернатов', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_745569250 IS NULL;
SET @tg_user_745569250 = COALESCE(@tg_user_745569250, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_745569250, 'telegram', '745569250', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 745569250, 'Никита Бернатов', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '745569250';

-- User: Дарья (telegram:762035998)
SET @tg_user_762035998 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '762035998'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Дарья', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_762035998 IS NULL;
SET @tg_user_762035998 = COALESCE(@tg_user_762035998, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_762035998, 'telegram', '762035998', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 762035998, 'Дарья', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '762035998';

-- User: Алекс React (telegram:762313704)
SET @tg_user_762313704 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '762313704'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Алекс React', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_762313704 IS NULL;
SET @tg_user_762313704 = COALESCE(@tg_user_762313704, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_762313704, 'telegram', '762313704', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 762313704, 'Алекс React', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '762313704';

-- User: Надежда (telegram:809428768)
SET @tg_user_809428768 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '809428768'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Надежда', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_809428768 IS NULL;
SET @tg_user_809428768 = COALESCE(@tg_user_809428768, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_809428768, 'telegram', '809428768', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 809428768, 'Надежда', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '809428768';

-- User: Natalia (telegram:857477445)
SET @tg_user_857477445 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '857477445'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Natalia', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_857477445 IS NULL;
SET @tg_user_857477445 = COALESCE(@tg_user_857477445, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_857477445, 'telegram', '857477445', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 857477445, 'Natalia', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '857477445';

-- User: Лихачева Мэ (telegram:861525386)
SET @tg_user_861525386 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '861525386'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Лихачева Мэ', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_861525386 IS NULL;
SET @tg_user_861525386 = COALESCE(@tg_user_861525386, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_861525386, 'telegram', '861525386', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 861525386, 'Лихачева Мэ', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '861525386';

-- User: Tatiana (telegram:868999124)
SET @tg_user_868999124 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '868999124'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Tatiana', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_868999124 IS NULL;
SET @tg_user_868999124 = COALESCE(@tg_user_868999124, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_868999124, 'telegram', '868999124', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 868999124, 'Tatiana', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '868999124';

-- User: Anastasiia Tsoy (telegram:872257424)
SET @tg_user_872257424 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '872257424'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Anastasiia Tsoy', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_872257424 IS NULL;
SET @tg_user_872257424 = COALESCE(@tg_user_872257424, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_872257424, 'telegram', '872257424', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 872257424, 'Anastasiia Tsoy', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '872257424';

-- User: Maria Golubova (telegram:876192977)
SET @tg_user_876192977 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '876192977'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Maria Golubova', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_876192977 IS NULL;
SET @tg_user_876192977 = COALESCE(@tg_user_876192977, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_876192977, 'telegram', '876192977', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 876192977, 'Maria Golubova', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '876192977';

-- User: Anna Shvets (telegram:916842662)
SET @tg_user_916842662 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '916842662'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Anna Shvets', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_916842662 IS NULL;
SET @tg_user_916842662 = COALESCE(@tg_user_916842662, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_916842662, 'telegram', '916842662', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 916842662, 'Anna Shvets', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '916842662';

-- User: Dmitry Dylinov (telegram:941907339)
SET @tg_user_941907339 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '941907339'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Dmitry Dylinov', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_941907339 IS NULL;
SET @tg_user_941907339 = COALESCE(@tg_user_941907339, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_941907339, 'telegram', '941907339', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 941907339, 'Dmitry Dylinov', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '941907339';

-- User: Марина (telegram:949782922)
SET @tg_user_949782922 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '949782922'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Марина', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_949782922 IS NULL;
SET @tg_user_949782922 = COALESCE(@tg_user_949782922, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_949782922, 'telegram', '949782922', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 949782922, 'Марина', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '949782922';

-- User: Mila (telegram:970422846)
SET @tg_user_970422846 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '970422846'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Mila', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_970422846 IS NULL;
SET @tg_user_970422846 = COALESCE(@tg_user_970422846, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_970422846, 'telegram', '970422846', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 970422846, 'Mila', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '970422846';

-- User: кинезиолог, реабилитолог, тренер с 35 - летним стажем Pavel Krylov (telegram:1013791589)
SET @tg_user_1013791589 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1013791589'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'кинезиолог, реабилитолог, тренер с 35 - летним стажем Pavel Krylov', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1013791589 IS NULL;
SET @tg_user_1013791589 = COALESCE(@tg_user_1013791589, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1013791589, 'telegram', '1013791589', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1013791589, 'кинезиолог, реабилитолог, тренер с 35 - летним стажем Pavel Krylov', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1013791589';

-- User: Ivan Lavrinenko (telegram:1026575105)
SET @tg_user_1026575105 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1026575105'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ivan Lavrinenko', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1026575105 IS NULL;
SET @tg_user_1026575105 = COALESCE(@tg_user_1026575105, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1026575105, 'telegram', '1026575105', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1026575105, 'Ivan Lavrinenko', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1026575105';

-- User: Наташа Aqua FIT Montenegro (telegram:1035996277)
SET @tg_user_1035996277 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1035996277'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Наташа Aqua FIT Montenegro', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1035996277 IS NULL;
SET @tg_user_1035996277 = COALESCE(@tg_user_1035996277, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1035996277, 'telegram', '1035996277', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1035996277, 'Наташа Aqua FIT Montenegro', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1035996277';

-- User: Lena Cherniaeva (telegram:1040724631)
SET @tg_user_1040724631 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1040724631'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Lena Cherniaeva', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1040724631 IS NULL;
SET @tg_user_1040724631 = COALESCE(@tg_user_1040724631, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1040724631, 'telegram', '1040724631', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1040724631, 'Lena Cherniaeva', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1040724631';

-- User: Сабина (telegram:1067084108)
SET @tg_user_1067084108 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1067084108'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Сабина', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1067084108 IS NULL;
SET @tg_user_1067084108 = COALESCE(@tg_user_1067084108, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1067084108, 'telegram', '1067084108', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1067084108, 'Сабина', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1067084108';

-- User: Екатерина Цывкина (telegram:1102351030)
SET @tg_user_1102351030 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1102351030'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Екатерина Цывкина', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1102351030 IS NULL;
SET @tg_user_1102351030 = COALESCE(@tg_user_1102351030, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1102351030, 'telegram', '1102351030', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1102351030, 'Екатерина Цывкина', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1102351030';

-- User: Aleksandra Grakova (telegram:1107393828)
SET @tg_user_1107393828 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1107393828'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Aleksandra Grakova', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1107393828 IS NULL;
SET @tg_user_1107393828 = COALESCE(@tg_user_1107393828, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1107393828, 'telegram', '1107393828', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1107393828, 'Aleksandra Grakova', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1107393828';

-- User: Marina Sosnina (telegram:1134374569)
SET @tg_user_1134374569 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1134374569'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Marina Sosnina', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1134374569 IS NULL;
SET @tg_user_1134374569 = COALESCE(@tg_user_1134374569, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1134374569, 'telegram', '1134374569', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1134374569, 'Marina Sosnina', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1134374569';

-- User: Maria Vassine (telegram:1138313294)
SET @tg_user_1138313294 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1138313294'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Maria Vassine', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1138313294 IS NULL;
SET @tg_user_1138313294 = COALESCE(@tg_user_1138313294, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1138313294, 'telegram', '1138313294', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1138313294, 'Maria Vassine', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1138313294';

-- User: Alec (telegram:1149743584)
SET @tg_user_1149743584 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1149743584'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Alec', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1149743584 IS NULL;
SET @tg_user_1149743584 = COALESCE(@tg_user_1149743584, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1149743584, 'telegram', '1149743584', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1149743584, 'Alec', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1149743584';

-- User: Unknown (telegram:1160243571)
SET @tg_user_1160243571 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1160243571'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Unknown', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1160243571 IS NULL;
SET @tg_user_1160243571 = COALESCE(@tg_user_1160243571, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1160243571, 'telegram', '1160243571', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1160243571, 'Unknown', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1160243571';

-- User: V. V. (telegram:1163694673)
SET @tg_user_1163694673 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1163694673'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'V. V.', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1163694673 IS NULL;
SET @tg_user_1163694673 = COALESCE(@tg_user_1163694673, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1163694673, 'telegram', '1163694673', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1163694673, 'V. V.', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1163694673';

-- User: Evgeniya Alexandrova (telegram:1205087381)
SET @tg_user_1205087381 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1205087381'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Evgeniya Alexandrova', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1205087381 IS NULL;
SET @tg_user_1205087381 = COALESCE(@tg_user_1205087381, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1205087381, 'telegram', '1205087381', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1205087381, 'Evgeniya Alexandrova', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1205087381';

-- User: Nuta 🐻‍❄️ (telegram:1267013651)
SET @tg_user_1267013651 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1267013651'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Nuta 🐻‍❄️', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1267013651 IS NULL;
SET @tg_user_1267013651 = COALESCE(@tg_user_1267013651, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1267013651, 'telegram', '1267013651', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1267013651, 'Nuta 🐻‍❄️', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1267013651';

-- User: Антон Синицын (telegram:1290025537)
SET @tg_user_1290025537 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1290025537'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Антон Синицын', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1290025537 IS NULL;
SET @tg_user_1290025537 = COALESCE(@tg_user_1290025537, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1290025537, 'telegram', '1290025537', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1290025537, 'Антон Синицын', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1290025537';

-- User: Rita Rad (telegram:1301490980)
SET @tg_user_1301490980 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1301490980'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Rita Rad', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1301490980 IS NULL;
SET @tg_user_1301490980 = COALESCE(@tg_user_1301490980, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1301490980, 'telegram', '1301490980', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1301490980, 'Rita Rad', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1301490980';

-- User: Natalia_K (telegram:1317801545)
SET @tg_user_1317801545 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1317801545'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Natalia_K', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1317801545 IS NULL;
SET @tg_user_1317801545 = COALESCE(@tg_user_1317801545, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1317801545, 'telegram', '1317801545', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1317801545, 'Natalia_K', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1317801545';

-- User: Ивета Рыкова (telegram:1338156010)
SET @tg_user_1338156010 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1338156010'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ивета Рыкова', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1338156010 IS NULL;
SET @tg_user_1338156010 = COALESCE(@tg_user_1338156010, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1338156010, 'telegram', '1338156010', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1338156010, 'Ивета Рыкова', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1338156010';

-- User: Татьяна (telegram:1343571341)
SET @tg_user_1343571341 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1343571341'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Татьяна', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1343571341 IS NULL;
SET @tg_user_1343571341 = COALESCE(@tg_user_1343571341, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1343571341, 'telegram', '1343571341', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1343571341, 'Татьяна', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1343571341';

-- User: Nat (telegram:1347874718)
SET @tg_user_1347874718 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1347874718'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Nat', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1347874718 IS NULL;
SET @tg_user_1347874718 = COALESCE(@tg_user_1347874718, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1347874718, 'telegram', '1347874718', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1347874718, 'Nat', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1347874718';

-- User: Irina Galushka (telegram:1348871566)
SET @tg_user_1348871566 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1348871566'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Irina Galushka', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1348871566 IS NULL;
SET @tg_user_1348871566 = COALESCE(@tg_user_1348871566, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1348871566, 'telegram', '1348871566', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1348871566, 'Irina Galushka', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1348871566';

-- User: Алексей Березов (telegram:1372341210)
SET @tg_user_1372341210 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1372341210'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Алексей Березов', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1372341210 IS NULL;
SET @tg_user_1372341210 = COALESCE(@tg_user_1372341210, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1372341210, 'telegram', '1372341210', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1372341210, 'Алексей Березов', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1372341210';

-- User: Anna Tkachenko (telegram:1389113731)
SET @tg_user_1389113731 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1389113731'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Anna Tkachenko', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1389113731 IS NULL;
SET @tg_user_1389113731 = COALESCE(@tg_user_1389113731, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1389113731, 'telegram', '1389113731', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1389113731, 'Anna Tkachenko', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1389113731';

-- User: Екатерина Яковлева (telegram:1411450220)
SET @tg_user_1411450220 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1411450220'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Екатерина Яковлева', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1411450220 IS NULL;
SET @tg_user_1411450220 = COALESCE(@tg_user_1411450220, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1411450220, 'telegram', '1411450220', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1411450220, 'Екатерина Яковлева', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1411450220';

-- User: Evgenija Viter (telegram:1431915921)
SET @tg_user_1431915921 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1431915921'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Evgenija Viter', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1431915921 IS NULL;
SET @tg_user_1431915921 = COALESCE(@tg_user_1431915921, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1431915921, 'telegram', '1431915921', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1431915921, 'Evgenija Viter', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1431915921';

-- User: Arseniy Chernichenko WindyMadCap (telegram:1522284115)
SET @tg_user_1522284115 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1522284115'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Arseniy Chernichenko WindyMadCap', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1522284115 IS NULL;
SET @tg_user_1522284115 = COALESCE(@tg_user_1522284115, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1522284115, 'telegram', '1522284115', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1522284115, 'Arseniy Chernichenko WindyMadCap', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1522284115';

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

-- User: Nailia Ivanova🤗 (telegram:1631168589)
SET @tg_user_1631168589 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1631168589'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Nailia Ivanova🤗', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1631168589 IS NULL;
SET @tg_user_1631168589 = COALESCE(@tg_user_1631168589, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1631168589, 'telegram', '1631168589', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1631168589, 'Nailia Ivanova🤗', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1631168589';

-- User: Александра Сагайдакова (telegram:1646819030)
SET @tg_user_1646819030 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1646819030'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Александра Сагайдакова', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1646819030 IS NULL;
SET @tg_user_1646819030 = COALESCE(@tg_user_1646819030, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1646819030, 'telegram', '1646819030', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1646819030, 'Александра Сагайдакова', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1646819030';

-- User: Yana Yana (telegram:1649059956)
SET @tg_user_1649059956 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1649059956'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Yana Yana', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1649059956 IS NULL;
SET @tg_user_1649059956 = COALESCE(@tg_user_1649059956, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1649059956, 'telegram', '1649059956', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1649059956, 'Yana Yana', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1649059956';

-- User: Катя (telegram:1800392657)
SET @tg_user_1800392657 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '1800392657'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Катя', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_1800392657 IS NULL;
SET @tg_user_1800392657 = COALESCE(@tg_user_1800392657, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_1800392657, 'telegram', '1800392657', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 1800392657, 'Катя', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '1800392657';

-- User: Elena Grosheva (telegram:2132156571)
SET @tg_user_2132156571 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '2132156571'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Elena Grosheva', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_2132156571 IS NULL;
SET @tg_user_2132156571 = COALESCE(@tg_user_2132156571, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_2132156571, 'telegram', '2132156571', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 2132156571, 'Elena Grosheva', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '2132156571';

-- User: SANDRA B. (telegram:6355229848)
SET @tg_user_6355229848 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6355229848'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'SANDRA B.', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6355229848 IS NULL;
SET @tg_user_6355229848 = COALESCE(@tg_user_6355229848, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6355229848, 'telegram', '6355229848', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6355229848, 'SANDRA B.', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6355229848';

-- User: Mak_tattoo (telegram:6300002559)
SET @tg_user_6300002559 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6300002559'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Mak_tattoo', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6300002559 IS NULL;
SET @tg_user_6300002559 = COALESCE(@tg_user_6300002559, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6300002559, 'telegram', '6300002559', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6300002559, 'Mak_tattoo', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6300002559';

-- User: Alexandra Lamsal (telegram:5200272780)
SET @tg_user_5200272780 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5200272780'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Alexandra Lamsal', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5200272780 IS NULL;
SET @tg_user_5200272780 = COALESCE(@tg_user_5200272780, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5200272780, 'telegram', '5200272780', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5200272780, 'Alexandra Lamsal', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5200272780';

-- User: Natasa (telegram:7306956325)
SET @tg_user_7306956325 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '7306956325'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Natasa', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_7306956325 IS NULL;
SET @tg_user_7306956325 = COALESCE(@tg_user_7306956325, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_7306956325, 'telegram', '7306956325', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 7306956325, 'Natasa', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '7306956325';

-- User: Din Don (telegram:8279962746)
SET @tg_user_8279962746 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '8279962746'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Din Don', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_8279962746 IS NULL;
SET @tg_user_8279962746 = COALESCE(@tg_user_8279962746, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_8279962746, 'telegram', '8279962746', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 8279962746, 'Din Don', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '8279962746';

-- User: Marina (telegram:5204554091)
SET @tg_user_5204554091 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5204554091'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Marina', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5204554091 IS NULL;
SET @tg_user_5204554091 = COALESCE(@tg_user_5204554091, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5204554091, 'telegram', '5204554091', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5204554091, 'Marina', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5204554091';

-- User: Vika (telegram:6556943473)
SET @tg_user_6556943473 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6556943473'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Vika', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6556943473 IS NULL;
SET @tg_user_6556943473 = COALESCE(@tg_user_6556943473, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6556943473, 'telegram', '6556943473', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6556943473, 'Vika', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6556943473';

-- User: Ekaterina Fimina (telegram:5908536544)
SET @tg_user_5908536544 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5908536544'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ekaterina Fimina', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5908536544 IS NULL;
SET @tg_user_5908536544 = COALESCE(@tg_user_5908536544, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5908536544, 'telegram', '5908536544', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5908536544, 'Ekaterina Fimina', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5908536544';

-- User: Oleg (telegram:5800820503)
SET @tg_user_5800820503 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5800820503'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Oleg', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5800820503 IS NULL;
SET @tg_user_5800820503 = COALESCE(@tg_user_5800820503, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5800820503, 'telegram', '5800820503', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5800820503, 'Oleg', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5800820503';

-- User: Kristina (telegram:6243122935)
SET @tg_user_6243122935 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6243122935'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Kristina', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6243122935 IS NULL;
SET @tg_user_6243122935 = COALESCE(@tg_user_6243122935, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6243122935, 'telegram', '6243122935', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6243122935, 'Kristina', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6243122935';

-- User: Светлана Аппартаменты у моря (telegram:5126183100)
SET @tg_user_5126183100 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5126183100'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Светлана Аппартаменты у моря', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5126183100 IS NULL;
SET @tg_user_5126183100 = COALESCE(@tg_user_5126183100, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5126183100, 'telegram', '5126183100', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5126183100, 'Светлана Аппартаменты у моря', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5126183100';

-- User: Степан Давидович (telegram:6102534187)
SET @tg_user_6102534187 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6102534187'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Степан Давидович', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6102534187 IS NULL;
SET @tg_user_6102534187 = COALESCE(@tg_user_6102534187, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6102534187, 'telegram', '6102534187', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6102534187, 'Степан Давидович', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6102534187';

-- User: arina (telegram:7981910575)
SET @tg_user_7981910575 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '7981910575'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'arina', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_7981910575 IS NULL;
SET @tg_user_7981910575 = COALESCE(@tg_user_7981910575, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_7981910575, 'telegram', '7981910575', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 7981910575, 'arina', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '7981910575';

-- User: Ekaterina Kalashnikova (telegram:7753285808)
SET @tg_user_7753285808 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '7753285808'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ekaterina Kalashnikova', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_7753285808 IS NULL;
SET @tg_user_7753285808 = COALESCE(@tg_user_7753285808, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_7753285808, 'telegram', '7753285808', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 7753285808, 'Ekaterina Kalashnikova', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '7753285808';

-- User: Юля (telegram:6496976723)
SET @tg_user_6496976723 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6496976723'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Юля', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6496976723 IS NULL;
SET @tg_user_6496976723 = COALESCE(@tg_user_6496976723, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6496976723, 'telegram', '6496976723', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6496976723, 'Юля', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6496976723';

-- User: Баира 08 (telegram:5170542298)
SET @tg_user_5170542298 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5170542298'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Баира 08', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5170542298 IS NULL;
SET @tg_user_5170542298 = COALESCE(@tg_user_5170542298, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5170542298, 'telegram', '5170542298', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5170542298, 'Баира 08', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5170542298';

-- User: Svetlana (telegram:5688262835)
SET @tg_user_5688262835 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5688262835'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Svetlana', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5688262835 IS NULL;
SET @tg_user_5688262835 = COALESCE(@tg_user_5688262835, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5688262835, 'telegram', '5688262835', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5688262835, 'Svetlana', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5688262835';

-- User: Ольга (telegram:5292316649)
SET @tg_user_5292316649 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5292316649'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ольга', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5292316649 IS NULL;
SET @tg_user_5292316649 = COALESCE(@tg_user_5292316649, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5292316649, 'telegram', '5292316649', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5292316649, 'Ольга', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5292316649';

-- User: Инна Жохова (telegram:7386477515)
SET @tg_user_7386477515 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '7386477515'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Инна Жохова', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_7386477515 IS NULL;
SET @tg_user_7386477515 = COALESCE(@tg_user_7386477515, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_7386477515, 'telegram', '7386477515', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 7386477515, 'Инна Жохова', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '7386477515';

-- User: Volod (telegram:5704023431)
SET @tg_user_5704023431 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5704023431'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Volod', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5704023431 IS NULL;
SET @tg_user_5704023431 = COALESCE(@tg_user_5704023431, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5704023431, 'telegram', '5704023431', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5704023431, 'Volod', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5704023431';

-- User: Svetlana (telegram:7339597906)
SET @tg_user_7339597906 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '7339597906'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Svetlana', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_7339597906 IS NULL;
SET @tg_user_7339597906 = COALESCE(@tg_user_7339597906, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_7339597906, 'telegram', '7339597906', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 7339597906, 'Svetlana', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '7339597906';

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

-- User: Windsurfing MNE 🌬️ (telegram:5160850474)
SET @tg_user_5160850474 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5160850474'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Windsurfing MNE 🌬️', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5160850474 IS NULL;
SET @tg_user_5160850474 = COALESCE(@tg_user_5160850474, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5160850474, 'telegram', '5160850474', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5160850474, 'Windsurfing MNE 🌬️', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5160850474';

-- User: Михаил (telegram:5261313329)
SET @tg_user_5261313329 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5261313329'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Михаил', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5261313329 IS NULL;
SET @tg_user_5261313329 = COALESCE(@tg_user_5261313329, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5261313329, 'telegram', '5261313329', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5261313329, 'Михаил', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5261313329';

-- User: ТANYA (telegram:5645781017)
SET @tg_user_5645781017 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5645781017'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'ТANYA', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5645781017 IS NULL;
SET @tg_user_5645781017 = COALESCE(@tg_user_5645781017, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5645781017, 'telegram', '5645781017', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5645781017, 'ТANYA', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5645781017';

-- User: Svetlana Nikitiuk (telegram:5471723943)
SET @tg_user_5471723943 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5471723943'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Svetlana Nikitiuk', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5471723943 IS NULL;
SET @tg_user_5471723943 = COALESCE(@tg_user_5471723943, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5471723943, 'telegram', '5471723943', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5471723943, 'Svetlana Nikitiuk', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5471723943';

-- User: Ольга (telegram:5663175852)
SET @tg_user_5663175852 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5663175852'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ольга', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5663175852 IS NULL;
SET @tg_user_5663175852 = COALESCE(@tg_user_5663175852, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5663175852, 'telegram', '5663175852', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5663175852, 'Ольга', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5663175852';

-- User: Natalii (telegram:5369422021)
SET @tg_user_5369422021 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5369422021'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Natalii', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5369422021 IS NULL;
SET @tg_user_5369422021 = COALESCE(@tg_user_5369422021, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5369422021, 'telegram', '5369422021', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5369422021, 'Natalii', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5369422021';

-- User: Perfect Name (telegram:6858662892)
SET @tg_user_6858662892 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6858662892'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Perfect Name', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6858662892 IS NULL;
SET @tg_user_6858662892 = COALESCE(@tg_user_6858662892, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6858662892, 'telegram', '6858662892', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6858662892, 'Perfect Name', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6858662892';

-- User: Михаил Протасов (telegram:5669928231)
SET @tg_user_5669928231 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5669928231'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Михаил Протасов', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5669928231 IS NULL;
SET @tg_user_5669928231 = COALESCE(@tg_user_5669928231, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5669928231, 'telegram', '5669928231', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5669928231, 'Михаил Протасов', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5669928231';

-- User: Ирина (telegram:5413913406)
SET @tg_user_5413913406 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '5413913406'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Ирина', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_5413913406 IS NULL;
SET @tg_user_5413913406 = COALESCE(@tg_user_5413913406, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_5413913406, 'telegram', '5413913406', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 5413913406, 'Ирина', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '5413913406';

-- User: Axel (telegram:6045022658)
SET @tg_user_6045022658 = (
  SELECT au.id FROM auth_users au
  JOIN auth_oauth_accounts aoa ON aoa.user_id = au.id
  WHERE aoa.provider = 'telegram' AND aoa.provider_account_id = '6045022658'
  LIMIT 1
);

INSERT INTO auth_users (name, is_phantom, primary_oauth_provider, created_at)
SELECT 'Axel', TRUE, 'telegram', NOW()
FROM DUAL WHERE @tg_user_6045022658 IS NULL;
SET @tg_user_6045022658 = COALESCE(@tg_user_6045022658, LAST_INSERT_ID());

INSERT IGNORE INTO auth_oauth_accounts (user_id, provider, provider_account_id, created_at)
VALUES (@tg_user_6045022658, 'telegram', '6045022658', NOW());

INSERT IGNORE INTO auth_oauth_profiles_telegram (oauth_account_id, telegram_id, first_name, created_at)
SELECT id, 6045022658, 'Axel', NOW()
FROM auth_oauth_accounts WHERE provider = 'telegram' AND provider_account_id = '6045022658';

-- =====================================================
-- PART 3: Messages
-- =====================================================

-- Channel: МЕДИЦИНА | ВРАЧИ | ЧЕРНОГОРИЯ (244 messages)

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1431915921, '107733', 'other', '#dermatologbudva спасибо.', 'ru', '2026-01-02T19:29:18', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762313704, '107736', 'question', 'Добрый вечер, температура 39,1 второй день. Подскажите есть ли кто в Будве кто может сделать выезд на дом?', 'ru', '2026-01-03T16:11:04', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6355229848, '107737', 'answer', 'Алексей добрый вечер!Помог парацетамол и нужно взять полотенце намочить не холодной водой и обтерется ноги руки подмышки лицо , мы только так и спаслись, витамин с ,чай мятный ,вода и морсы', 'ru', '2026-01-03T16:16:20', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6355229848, '107738', 'other', 'Рапидол с помог моему мужу .И антибиотики на 3 дня ,но нужно идти к терапевту .', 'ru', '2026-01-03T16:17:26', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_361370649, '107755', 'question', 'Добрый день! Кто-нибудь знает какая сегодня стомотология работает? Отклеился ретейнер. В идеале Тиват, ХН, Котор, Будва', 'ru', '2026-01-05T13:11:26', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_387091776, '107786', 'other', 'Здравствуйте! Подскажите клинику, желательно в Баре, куда пойти на плановое обследование, кровь, ЭКГ, гинеколог для девушки, узи, флюорограмма', 'ru', '2026-01-08T08:35:31', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '107787', 'answer', 'Не видел, чтобы плановое где-то предлагалось, но в Novi Standard есть "полное УЗИ для женщин", стоит 110 евро\nЭКГ там 5 евро\nОбщий анализ крови 5 евро', 'ru', '2026-01-08T08:55:50', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_387091776, '107788', 'answer', 'Благодарю! Думали ехать в А3 на чек-ап, но теперь сомневаюсь. Novi standard может и лучше будет', 'ru', '2026-01-08T09:34:28', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_126367478, '107792', 'question', 'Утро доброе и солнечное!\nПодскажите, пожалуйста, если кто знает - где в Будве лучше сдавать кровь на анализы для эндокринолога (ттг,т3, т4 и т.д.)?', 'ru', '2026-01-08T10:54:24', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_678254807, '107798', 'question', 'Добрый день!\nПорекомендуйте , плиз, гастроэнтеролога и где сделать фгдс?', 'ru', '2026-01-08T16:52:25', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '107799', 'answer', 'В каком городе?', 'ru', '2026-01-08T16:53:45', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_678254807, '107800', 'other', 'Подгорица/бар', 'ru', '2026-01-08T16:54:30', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '107801', 'other', 'В Сутоморе клиника А3.\nВ Подгорице клиника Кодра, клиника Кербер.', 'ru', '2026-01-08T16:57:11', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1389113731, '107805', 'question', 'Подскажите, что бы купить противо паразитарные препараты, нужен ли рецепт?', 'ru', '2026-01-08T20:53:33', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1160243571, '107807', 'answer', 'Нет', 'ru', '2026-01-08T21:58:41', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1317801545, '107808', 'answer', 'Солтрик продают без рецепта', 'ru', '2026-01-08T21:58:55', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '107812', 'other', 'Для пациентов с аллергией на домашнюю пыль и клещей домашней пыли! \nОбработка мягкой мебели специальным пылесосом против ПЫЛЕВЫХ КЛЕЩЕЙ (включает ультрафиолет, ультразвук, локальный нагрев, высокую силу всасывания), без применения химических средств. \nДанная обработка проводится 1 раз в 3-6 месяцев.  \nОставляйте заявку @Dust_Mite_Vacuum_Cleaner', 'ru', '2026-01-09T14:41:56', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1290025537, '107814', 'question', 'Друзья, добрый день! Можете ли посоветовать мазь? Подвернул ногу, появился отек', 'ru', '2026-01-09T15:55:22', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1013791589, '107815', 'answer', '"Deksalgin " + возвышение, охлаждение первые 2 дня.\nИммобилизация.', 'ru', '2026-01-09T16:13:45', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1290025537, '107816', 'answer', 'Благодарю Вас!', 'ru', '2026-01-09T16:19:13', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_673058403, '107820', 'answer', 'Если из-за боли не можете наступить на ногу - обязательно в специализированное лечебное учреждение.\nЕсли боль постепенно уменьшается - обеспечьте покой конечности и, по возможности, её горизонтальное или возвышенное положение. Первые сутки-двое можете прикладывать холод.\nЕсли боль мешает сну - пероральный нпвс (brufen800, aflamil).\nНи в коем случае не накладывать сдавливающих повязки- это нарушает микроциркуляцию и удлиняет процесс заживления тканей!\nЕсли остались вопросы, - пишите мне в л.с.', 'ru', '2026-01-09T19:17:41', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1800392657, '107850', 'other', 'Добрый день! Посоветуйте, пожалуйста, хорошего врача узи 🙏 Желательно в Будве и желательно русскоговорящего)', 'ru', '2026-01-11T15:57:24', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6300002559, '107861', 'question', 'Добрый день, подскажите есть ли Гениколог в Баре ?', 'ru', '2026-01-12T10:52:56', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '107862', 'answer', 'В А3 работает Vesna Čolaković-Popović\nВряд ли по-русски говорит, но есть сопровождение на русском от клиники.', 'ru', '2026-01-12T10:58:28', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_370265591, '107875', 'question', 'Добрый вечер подскажите пожалуйста,есть кардиолог в Подгорице(русскоговорящий? Спасибо.', 'ru', '2026-01-12T22:31:42', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '107876', 'answer', 'Вроде нет, но в Kerber и Codra есть кардиологи и сопровождение на русском', 'ru', '2026-01-12T22:39:04', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '107877', 'answer', 'Добрый вечер, в Подгорице русскоговорящих нет, есть в Тивате (Александр Виллер) и в Херцег-Нови (Хомякова Татьяна). Поиском по чату можете найти контакты, кто заинтересовал.', 'ru', '2026-01-12T22:39:18', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_618028075, '107886', 'question', 'Добрый день!\nЕсть ли в Черногории ветеринарная инспекция, где можно получить международный сертификат на авиаперевозку кошки?', 'ru', '2026-01-13T10:04:06', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1290025537, '107891', 'other', 'Друзья, добрый день! Подскажите, пожалуйста, хорошего  русскоязычного стоматолога в Будве/ Которе.', 'ru', '2026-01-13T12:29:45', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_79144498, '107892', 'answer', 'Едете лучше в Тиват. Там хорошие все( русскоговорящие все тоже😊) в Dental Expert.', 'ru', '2026-01-13T12:38:47', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '107893', 'answer', 'Есть в Подгорице. Но чтобы получить сертификат на выезд вам не обязательно обращаться самому в ветинспекцию. Вам нужно с животным обратится к ветеринару в клинику, там осмотрят животного, проверят наличие прививок, чипа, если надо титров и выпишут справку, с этой справкой вам уже нужно обратится к ветинспектору(Whatsapp), иногда клиника сама связывается с  инспектором (в Тивате было такое в адриа вет). Их, вроде, два работают на побережье, он запросит фото справки, паспорта и привезет вам готовый сертификат. Подробнее в чате "Черногория с животными".', 'ru', '2026-01-13T13:43:15', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '107894', 'answer', 'Есть в Будве хорошие стоматологи : Данис, Регина. Ищите контакты в чате поиском по имени.', 'ru', '2026-01-13T13:44:49', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_618028075, '107895', 'answer', 'Спасибо за ответ!\nДело в том, что в ветеринарке это все сделали и номер это инспектора дали, но вот проблема - инспектор этот (miki) - весьма полако и от него хрен чего добьешься - ни сроков , ни цены, ни где вообще!\nЯ бы не спрашивал…', 'ru', '2026-01-13T13:48:00', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '107896', 'answer', 'Вы ему сообщили, когда рейс? Он не особо отвечает, но ,вроде, все делает. Если у вас совсем нет в нем уверенности, посмотрите в чате "Черногория с животными", там описывали опыт прямого обращения в ветеринарную инспекцию в Подгорице. Поищите там контакты или спросите. Сертификат не раньше чем за три дня до вылета дают.', 'ru', '2026-01-13T13:52:15', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_618028075, '107898', 'answer', 'конечно, всю информацию сразу дали, в том числе время рейса!\nа то, что не особо отвечает - это мягко сказано )\nМожет вы сможете просветить - сколько его услуги стоят? а то реально какая-то странная ситуация - получается, что у меня  и выбора-то не будет - какую сумму назовёт, ту и придётся выложить - авиабилеты-то невозвратные!', 'ru', '2026-01-13T14:53:58', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '107899', 'answer', 'Раньше 30 евро стоил сертификат, но это не свежая информация, я давно выезжала.', 'ru', '2026-01-13T14:58:17', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_332313768, '107904', 'question', 'Добрый вечер, подскажите , есть ли Лор хороший в Будве или может Которе?', 'ru', '2026-01-13T19:34:48', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1646819030, '107921', 'question', 'Здравствуйте! Знает ли кто то русскоговорящего гинеколога в Будве?', 'ru', '2026-01-14T15:49:41', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1107393828, '107929', 'other', 'Отдвм 23 таблетки мвмалака,срок до конца февраля,Будва', 'ru', '2026-01-14T19:11:19', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_332313768, '107932', 'answer', 'В клинике Humana reprodukcija Мария Петричевич говорит немного по русски, хорошая доктор', 'ru', '2026-01-15T00:43:09', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1646819030, '107935', 'answer', 'Спасибо огромное!', 'ru', '2026-01-15T08:44:37', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_418176416, '107969', 'question', 'Подскажите есть восемь связаться с А3 медикал в сутоморе кроме телефона?', 'ru', '2026-01-17T09:14:50', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '107973', 'answer', '@a3medicalme', 'ru', '2026-01-17T10:48:14', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5200272780, '107975', 'other', 'Добрый день. Подскажите кто в теме, телефон гастроэнтеролога в Тивате. Либо его электронный адрес или сайт. Заранее благодарю', 'ru', '2026-01-17T13:06:03', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '107976', 'answer', 'Не уверена, но, по-моему, гастроэнтеролога в Тивате нет', 'ru', '2026-01-17T13:08:14', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '107979', 'answer', 'Раньше была ординация доктора Голо, но закрылась. В новой милмедике в Порто возможно есть гастроэнтеролог, посмотрите на сайте.', 'ru', '2026-01-17T17:31:31', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1160243571, '107997', 'other', 'Доброе утро порекомендуйте хорошего хирурга для удаления липомы 🌺', 'ru', '2026-01-18T10:48:58', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_7306956325, '107998', 'answer', 'Dr Miljan Zindovic Bono Medica Budva', 'ru', '2026-01-18T11:21:37', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1631168589, '107999', 'answer', 'Вы писали мне в личку. Я в настоящее время на больничном. По выходу с больнице я напишу вам в личку. С уважением,  Наиля Иванова', 'ru', '2026-01-18T11:33:36', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_332181129, '108030', 'other', 'Добрый вечер! Порекомендуйте педиатра с возможностью сделать Узи в Баре. Миленку знаем, не подходит.', 'ru', '2026-01-19T19:44:34', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_8279962746, '108041', 'other', 'Добрый день, посоветуете пожалуйста семенного психолога с очным приемом в Будве/окрестностях.', 'ru', '2026-01-20T13:36:15', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5204554091, '108047', 'question', 'Добрый вечер. Может здесь в чате есть кто может достать таблетки Кветиапин?', 'ru', '2026-01-20T19:02:34', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_494082504, '108048', 'other', 'Подскажите кто обращался к врачу Сенник И.В. \nПотеряла контакт этого врача. \nЕсли у кого есть, пришлите, пожалуйста.', 'ru', '2026-01-20T20:21:30', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_284957956, '108049', 'other', 'Добрый день, посоветуйте пожалуйста хорошего офтальмолога (окулиста), любой город, главное чтобы хороший и со всем необходимым оборудованием. Заранее спасибо!', 'ru', '2026-01-20T20:54:09', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108050', 'answer', 'Необходимым для чего?\nЕсли что-то сложное, то Алпатов в клинике Optimal в Подгорице или Светлость в Будве', 'ru', '2026-01-20T22:01:21', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_284957956, '108051', 'answer', 'спасибо за ответ, нужна диагностика глаза из-за резкого ухудшения зрения', 'ru', '2026-01-20T22:02:43', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108052', 'answer', 'Тогда Алпатов, но у него часто очереди на месяц.\nВ Светлость обычно легче попасть, особенно, если дело срочное. Там у них даже врач Йован есть, он по-русски хорошо говорит. Но не факт, что к нему получится записаться. У них тоже все нужное есть', 'ru', '2026-01-20T22:12:20', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_284957956, '108053', 'answer', 'большое спасибо за совет!', 'ru', '2026-01-20T22:12:51', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108054', 'answer', 'Это случайно не гинеколог, принимала  в Сутоморе в частном кабинете? Если да, то вроде уехала давно, ещё в 2023 году.', 'ru', '2026-01-20T22:40:17', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_393615923, '108059', 'other', 'Уже сегодня, в среду, 21 января в 19:00 мы приглашаем вас в Auditoria Budva на лекцию «Инсульт и инфаркт миокарда: как защитить себя от катастрофы», первую в новом году встречу в рамках цикла «Доказательная медицина в Черногории».\n\nНевролог Олег Виноградов и кардиолог Татьяна Хомякова расскажут о возможности профилактики таких грозных заболеваний как инсульт и инфаркт миокарда. \n\nДоступно и понятным языком вместе разберёмся:\n- как понять, есть ли лично у вас высокий риск инсульта и инфаркта миокарда\n- как выявить все факторы риска\n- какие изменения образа жизни могут снизить не только риски инсульта и инфаркта миокарда, но и онкологии\n- нужны ли вам препараты от повышенного артериального давления и статины\n- нужно ли вам принимать аспирин\nЭксперты ответят на все интересующие вопросы из зала.\n\nОлег Виноградов — невролог, д.м.н., профессор, президент АНО «Общество доказательной неврологии».\nТатьяна Хомякова — кардиолог, врач функциональной диагностики, к.м.н.\n\nВход donation\nРегистрация @AuditoriaBudva', 'ru', '2026-01-21T10:05:22', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6556943473, '108061', 'question', 'Здравствуйте, подскажите есть ли тут Гепаризин ?', 'ru', '2026-01-21T13:13:23', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1372341210, '108102', 'question', 'Добрый день! Скажите пожалуйста, знаете ли вы хорошего стоматолога который бы мог сделать чистку Зубов в Которе, Тивте, Будве?', 'ru', '2026-01-23T14:56:52', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108109', 'answer', 'Поиском по чату поищите, писали много раз.', 'ru', '2026-01-23T19:35:53', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1026575105, '108130', 'question', 'Всем привет! 👋 Кто то сталкивался с проблемой подбора оправы для очков в Черногории? Я заметил что во всех салонах оптики на побережье одни и те же модели, что дешёвые что дорогие. И они мне не оч. подходят. Еду в Подгорицу походить посмотреть. Может кто поможет советом', 'ru', '2026-01-24T11:49:57', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_857477445, '108144', 'other', 'Доброй ночи , нужен хороший эндокринолог чтобы мог сделать пункцию узла , можно местного 🙏🏻', 'ru', '2026-01-24T23:19:47', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1348871566, '108145', 'other', 'Добрый вечер, узи сердца нужно сделать у кардиолога?', 'ru', '2026-01-24T23:28:53', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1040724631, '108173', 'other', 'Инсульт и инфаркт миокарда: что делать, если катастрофа произошла в Черногории\n\n28 января в Focuss.space состоится встреча с неврологом и кардиологом, на которой обсудим возможности лечения в Черногории инсульта и инфаркта миокарда.\n\nДоступно и понятным языком вместе разберёмся:\n\n- как распознать симптомы инсульта и инфаркта миокарда,\n- причины развития этих грозных заболеваний,\n- что нужно делать и куда обращаться, если развился инсульт или инфаркт миокарда,\n- какую неотложную помощь нужно оказать,\n- какие есть современные возможности лечения инсульта и инфаркта миокарда, и о чем нужно говорить с врачами для получения адекватной помощи.\n\nЭксперты ответят на все интересующие вопросы.\nСпикеры:\n\nОлег Виноградов - невролог, д.м.н., профессор, президент АНО “Общество доказательной неврологии”.\n\nТатьяна Хомякова - кардиолог, врач функциональной диагностики, к.м.н.\n‌ \nЛекция пройдет в рамках цикла “Доказательная медицина в Черногории”\n\n🗓 Ср, 28 января в 19:00\n💰 donation\n👉🏼 Запись\n\n📍г. Бар, коворкинг Focuss.space. Вход с ул. Маршала Тито, 10, рядом с Hipotekarna Banka. 4й этаж (работает лифт)', 'ru', '2026-01-26T18:25:30', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_509405298, '108174', 'answer', 'Конечно . Хотя есть « узисты» на все руки- но  лучше у профильного доктора, тем более они в Черногории есть. Сразу и эхографию сосудов тоже делают', 'ru', '2026-01-26T18:29:05', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_485544391, '108177', 'other', 'Добрый вечер!\nХочу оставить отзыв о докторе Олеге Виноградове, неврологе. \nЗамечательный доктор, на прошлой неделе был у него на приеме (в Будве), многие проблемы стали понятны, буду продолжать у него лечиться.\n👍\nЕго контакт в Телеграм +79162704705\nРекомендую всем, кому нужна неврология.💯', 'ru', '2026-01-26T20:35:11', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5908536544, '108180', 'answer', 'Здравствуйте! Помогу Вам разобраться с причинами того, что Вас беспокоит. Семейный психолог, экзистенциальный терапевт, опыт 15 лет. Обращайтесь в личные сообщения.', 'ru', '2026-01-26T23:05:05', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5800820503, '108184', 'other', 'Добрый день!\nПосоветуйте пожалуйста врача дерматолога в Баре. Для ребенка.', 'ru', '2026-01-27T10:08:25', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_102281608, '108214', 'question', 'Кто то попадал к неврологу в Рисане? Есть упут на время, но вот уже три часа прошло, прошло два человека, и кафа)', 'ru', '2026-01-28T12:47:34', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6243122935, '108238', 'other', 'Добрый день, порекомендуйте пожалуйста гастроэнтеролога. Желательно русскоговорящего.', 'ru', '2026-01-29T09:26:42', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1067084108, '108244', 'question', 'Здравствуйте! Где сейчас можно сделать Узи сердца (эхо кг)? Город любой', 'ru', '2026-01-29T14:24:15', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108247', 'answer', 'много где, на самом деле. из крупных:\nА3, Конзилиум, Милмедика, Натал', 'ru', '2026-01-29T14:47:47', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108248', 'answer', 'Иван Носов, контакт поиском по чату. Других русскоговорящих в Черногории, вроде, нет.', 'ru', '2026-01-29T15:00:12', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_949782922, '108254', 'other', 'Здравствуйте! Срочно ищу нуждающихся в препаратах:\n\n1. Утрожестан (прогестерон) 2 пачки по 200 мг, срок годности до августа 2026 года.\n\n2. Фенибут 3 пачки по 250 мг, в одной пачке 46 штук, в двух других по 50. Срок годности до мая 2028 года.\n\nОтдам одну пачку за одно помело или связку бананов :3\n\nТак же продам линзы ILLUSION CLEAR квартальные (замена каждые три месяца), совершенно невскрытые, 2 пачки по 4 линзы в каждой. Диоприи -5.00. Одну пачку продам за 25 евро.\n\nПодгорица', 'ru', '2026-01-29T17:00:13', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5126183100, '108302', 'question', 'Всем здравствуйте 😊Подскажите пожалуйста, есть ли в продаже Глюкофаж?Будва', 'ru', '2026-01-31T11:09:39', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108303', 'answer', 'Да, в любой аптеке есть. Причем, именно глюкофаж, не аналоги', 'ru', '2026-01-31T11:31:32', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_338203277, '108315', 'question', 'Добрый вечер! Подскажите как найти терапевта с выездом на дом? В закрепе ничего не нашел', 'ru', '2026-01-31T18:48:08', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108319', 'answer', 'Если Будва и окрестности, ищите поиском по чату Ашихмин Олег. А так тут самому в скорую надо ехать, если срочно, скорая на дом не выезжает.', 'ru', '2026-01-31T21:11:21', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_449894837, '108320', 'other', 'Коллеги, добрый день! Порекомендуйте пожалуйста в личку варианты добровольного страхования на себя и детей, которые реально работают.', 'ru', '2026-01-31T23:14:22', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6102534187, '108323', 'other', 'Добрый вечер , посоветуйте пожалуйста детского дерматолога , спасибо 🙏', 'ru', '2026-02-01T02:09:51', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_489330193, '108337', 'other', 'Добрый вечер, посоветуйте к какому врачу обратиться с головной болью болит около 10 дней', 'ru', '2026-02-01T16:54:03', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_673058403, '108338', 'answer', 'Прежде всего к неврологу.', 'ru', '2026-02-01T17:18:38', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_7981910575, '108361', 'other', 'Добрый вечер,подскажите пожалуйста есть ли у кого то роаккутан, любой дозировки', 'ru', '2026-02-02T19:31:52', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108362', 'answer', 'В Черногории нет деления на взрослый детский, из русскоговорящих дерматологов- Яна Соловцова (Бар, Будва) и Евгения Витер (Будва), контакты поиском по чату поищите.', 'ru', '2026-02-02T20:40:58', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_370265591, '108363', 'other', 'Добрый вечер. Посоветуйте русскоговорящего ендокринолога.Спасибо.', 'ru', '2026-02-02T21:08:16', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108367', 'answer', 'Доктор Деева в Medical Vranes в Баре', 'ru', '2026-02-02T22:25:13', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '108369', 'other', '🆘 Срочно нужна помощь‼️\n\n🩸Нужны ДОНОРЫ КРОВИ 🩸\nВторая положительная \n2 А+\n\n‼️завтра 3 февраля в 7 утра \n\nСдавать кровь нужно\n\n‼️в Подгорице\n\nв Клиническом центра на \nфамилию Александр Васильев\n\nКонтакт для связи с Марией\n tg:  @molokova_masha\n+38267529432', 'ru', '2026-02-02T22:43:44', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_120048668, '108372', 'answer', 'Спасибо всем огромное за помощь! Мы нашли нужное количество людей, если скажут что еще не хватает, то на среду могут назначить еще сдачу крови, я обязательно тут напишу. И после поделюсь как происходят операции в Черногории, потому что пока что вся логистика просто жесть((((', 'ru', '2026-02-02T23:11:43', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5126183100, '108374', 'other', 'Добрый день! Казалось, что уже давно раскрыта схема мошенников про покупки лекарств в аэропорту! Но увы🥵Уже не только сообщение о « помощи « пишут, но и нагло звонят и молчат! И это в 5,30 утра! Будьте осторожны ❗️❗️❗️', 'ru', '2026-02-03T09:35:08', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_7753285808, '108379', 'other', 'Добрый день. Подскажите, пожалуйста, контакты хирурга-ортопеда. Спасибо', 'ru', '2026-02-03T12:28:23', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_673058403, '108383', 'answer', 'Если речь идёт об острой травме, Вам следует обратиться в клинику Бара, Рисана или KCCG.\nЕсли процесс хронический или касается консультативной ортопедии, можете обратиться ко мне.', 'ru', '2026-02-03T13:11:58', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_7753285808, '108390', 'answer', 'Спасибо. Написала Вам личное сообщение', 'ru', '2026-02-03T15:05:31', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_872257424, '108408', 'question', 'Добрый день! Подскажите, пожалуйста, у кого-нибудь есть актуальное расписание приема психиатра в доме здравля в Будве?', 'ru', '2026-02-04T11:23:31', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6496976723, '108410', 'answer', 'Была на прошлой неделе там ,вроде до 14.00 с 9', 'ru', '2026-02-04T13:29:53', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5170542298, '108413', 'other', '25е. Нахожусь в Которе, могу привезти в ПГ. \nКонтакты 067852939.', 'ru', '2026-02-04T13:45:11', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1301490980, '108418', 'other', 'добрый день, где в будве можно убрать миллиум в уголке глаза. Или вообще в Черногории', 'ru', '2026-02-04T16:04:47', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_745569250, '108427', 'question', 'Добрый день!\n\nЕсть ли в Черногории врачи которые работают с коагулятором?\n\n( Производят удаление папилом и тд )', 'ru', '2026-02-04T23:09:28', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1160243571, '108428', 'answer', 'В Херцег нови врач\n@dermatologvenerolog', 'ru', '2026-02-04T23:12:44', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_745569250, '108429', 'answer', 'А в Подгорице есть такие же специалисты?', 'ru', '2026-02-04T23:13:14', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1160243571, '108430', 'answer', 'Может напишут,ждите', 'ru', '2026-02-04T23:13:34', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1160243571, '108431', 'other', 'Ещё в Будве есть Витер', 'ru', '2026-02-04T23:13:45', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1160243571, '108432', 'other', '@Evgenija_viter', 'ru', '2026-02-04T23:14:23', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_745569250, '108433', 'other', 'Благодарю, спасибо 🙏🏻!', 'ru', '2026-02-04T23:27:00', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_970422846, '108439', 'answer', 'Яна в Баре очень качественно все удаляет', 'ru', '2026-02-05T06:39:09', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108443', 'answer', 'Яна? А где она работает?', 'ru', '2026-02-05T09:41:36', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108444', 'answer', 'Ищите поиском выше в чате контакт "Яна Соловцова".', 'ru', '2026-02-05T09:49:29', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108445', 'answer', 'Я все посмотрел, нашел ее профиль, только там не написано, где именно принимает, только города. И сама она писала о себе только в 2023 году. Она все еще в Черногории? На дому принимает или в какой-то клинике / студии?', 'ru', '2026-02-05T09:52:55', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108446', 'answer', 'Вроде в Черногории, напишите ей, чтобы получить ответы, она принимает в частном кабинете в Баре и в Будве в салоне красоты раз в неделю.', 'ru', '2026-02-05T09:54:01', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_970422846, '108458', 'answer', '@yanasolovtsova', 'ru', '2026-02-05T17:56:35', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1267013651, '108466', 'question', 'Добрый вечер!\nМожно ли купить свечи нурофен детские в Черногории?\nНе могу найти', 'ru', '2026-02-05T20:18:50', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5688262835, '108484', 'question', 'Добрый день.Может есть у кого викасол ?Срочно.Будва', 'ru', '2026-02-06T11:01:00', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5292316649, '108486', 'other', 'Продаю [сроки до 27/28 года]\n1. Орниона экстриол крем -15 г- 20 евро\n2. ДляДженс 15 свечей по 0,5- 20 евро\nБудва', 'ru', '2026-02-06T11:32:13', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1343571341, '108488', 'other', 'Обменяю остатки на €. \n1. Анжелик 28таб = 16 €\n2.Энтерофурил200мг×16таб=8€\n3.Магнерот500мг×100таб =15€\n4.ФеррумЛек100мг×10таб=1€\n5.Дексазон05мг×48таб = 1€\n6.Кофеин100мг×10таб=1,5€\n7.Ипигрикс20мг×75таб=30€. Будва. Район TQ PLAZA.', 'ru', '2026-02-06T11:56:36', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1631168589, '108549', 'other', 'Уважаемые пациенты, меня зовут Наиля Иванова. \nСпешу оповестить📢:\nДом Здравлья Будва, вновь возобновляет Бесплатно ☝️ Тестирование на ВИЧ инфекцию 🦠, Гепатиты В и C🧬 \nТестирование провожу я, каждый рабочий день с 9.00 до 11.00.\nСовершенно бесплатно и анонимно.\nЗа необходимой информацией,  можно в личку. С уважением,  Наиля.', 'ru', '2026-02-10T20:33:40', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5170542298, '108554', 'other', '25е.\n067852939', 'ru', '2026-02-11T13:48:03', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_418176416, '108560', 'other', 'Продам мазь  солантра ( ивермектин) не вскрыта. Срок годности до 01.27. 25 евро Бар', 'ru', '2026-02-11T14:58:36', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_211301931, '108569', 'answer', 'Нет их тут', 'ru', '2026-02-11T21:19:49', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_916842662, '108577', 'question', 'Здравствуйте. А есть ли в Черногории  психотерапевт, работающий по методу ДПДГ (EMDR)? Желательно Бар, но вобще город не важен...', 'ru', '2026-02-12T09:25:03', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_7386477515, '108578', 'answer', 'Здравствуйте, Анна. Я принимаю в Будве.  Владею не только EMDR.', 'ru', '2026-02-12T09:37:54', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_453115212, '108582', 'question', 'Доброго дня есть у кого возможность достать таблетки Ферритаб 2-3 упаковки ? Они без рецепта продаются', 'ru', '2026-02-12T15:54:12', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5704023431, '108588', 'question', 'Добрый день! Может быть кто-то обладает информацией,  дробят ли в Черногории камни в почках ультразвуком?', 'ru', '2026-02-13T15:58:04', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_941907339, '108591', 'answer', 'Дистанционным дроблением камней занимаются только в клиническом центре насколько я знаю. Но это не ультразвуком, а ударно-волновое дробление.', 'ru', '2026-02-14T11:06:01', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_379372693, '108597', 'question', 'Добрый день, есть ли в Черногории русскоязычные урологи?🙏', 'ru', '2026-02-15T14:09:18', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108598', 'answer', 'вот выше вашего сообщения русскоязычный уролог в Черногории)', 'ru', '2026-02-15T14:20:01', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_7339597906, '108605', 'other', 'Здравствуйте! Подскажите где можно посетить и пройти обследование молочных желез, желательно  к русскоговорящего врача 🙏', 'ru', '2026-02-16T06:45:18', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108607', 'answer', 'Русскоговорящего не посоветую, клиника natal Подгорица УЗИ и цифровой маммограф, профессор др Драгана Богданович-Стоянович специализируется на болезнях молочных желез. Говорит на ломаном русском , английским владеет.', 'ru', '2026-02-16T11:30:23', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1338156010, '108611', 'other', 'Куплю милдронат', 'ru', '2026-02-16T14:50:42', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1649059956, '108612', 'answer', 'Могу продать в Будве', 'ru', '2026-02-16T15:00:36', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1035996277, '108695', 'question', 'Доброе утро! Где можно арендовать или купить ходунки для взрослого?', 'ru', '2026-02-19T07:25:08', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '108776', 'answer', 'https://maps.app.goo.gl/DES4kJ6rDo7fYE6M8\n\nКупить можно здесь! Рудо , Подгорица.', 'ru', '2026-02-21T23:36:06', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1035996277, '108779', 'answer', 'Спасибо большое🙏', 'ru', '2026-02-22T06:40:59', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_876192977, '108781', 'other', 'Адвантан Мазь 0,1%, 30 гр\n\nПродам, новый\n5€, г. Бар\nСрок до 09.2026', 'ru', '2026-02-22T11:07:06', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6422508308, '108783', 'other', 'Добрый день! Хочу оставить отзыв о дерматологе Яна Соловцова @yanasolovtsova, которая принимает в Баре. Выбрал именно ее за профессиональный подход при первичном дистанционном общении. Приехал из другого города на прием. Не пожалел, даже потратив 2 часа на дорогу.\n\nЛечение начали оперативно после сдачи анализов в Баре сразу после приема. Яна отвечала на все вопросы и очень помогала на всем пути выздоровления. Однозначно рекомендую, как замечательного специалиста и очень приятного человека! Это тот уникальный врач, который не пугает, а настраивает на позитивное лечение. Всем рекомендую.', 'ru', '2026-02-22T12:16:10', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '108784', 'answer', '#отзыв #дерматолог', 'ru', '2026-02-22T13:13:28', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1347874718, '108787', 'other', 'Добрый день. Подскажите пожалуйста успокоительное, которое можно купить без рецепта. Или угостите пожалуйста. Предстоит очень волнительный день завтра, а я максимально тяжело переношу стрессы, физически, мне уже плохо( Будва.', 'ru', '2026-02-23T10:30:17', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108792', 'question', 'Подскажите в Будве ЛОРа? Срочно надо. Желательно на дом. Просто диагностика. Лечение онлайн', 'ru', '2026-02-23T12:07:53', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1347874718, '108793', 'other', 'Извините, не указала, Будва', 'ru', '2026-02-23T12:36:01', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108794', 'question', 'Приветствую.\nМожет быть вы видели пост про бабу Любу, которой в 3 больницах в Чг  в лечение отказали, приняти в Брезовике, Никшич\nhttps://www.facebook.com/share/p/1FkcVYW1mC/\nЕсть ли у нас на связи тут или в любой точке мира хирург торокальный? Который мог бы проконсультировать? Кипа анализов, узи, кт и прочее..\nИ абсолютно ничего не понятно. То ли такое осложнение на корону, длящееся полгода, вообщем с диагностикой тут беда(да вы и так знатее, кому я говорю)\nАпд.\nСостояние на 23 февраля:\nВрачи якобы онкологию НЕ нашли. Пришли результаты гистологии, биопсии. И с другими органами тоже проблем нет. Только лёгкие. Что именно выясняют полако. Отправили анализ на туберкулез- это протокол такой?\nВрачи запретили в таком состоянии больную везти куда то. Говорят не дают разрешения на транспортировку, не перенесет дороги(\nЖдем среды и еще результов анализов. И результата терапий? \nИ счета будут вечером ( Пока информации по счетам нет, так что по этой теме подскажите, может фонды какие?страховку поздно уже помочь ей?)', 'ru', '2026-02-23T12:58:47', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1343571341, '108797', 'answer', 'Здравствуйте!\nВам верно сказали, что она не выдержит самостоятельный перелёт, если это только не СанАвиация. Вообще то давно надо было обратиться в Представительство вашей державы, это входит в их функции - помощь соотечественникам, оказавшимся в критической ситуации за рубежом. Гидроторакс сам не рассосётся, нужен реальный торакальный хирург и операционная, а не виртуальное вот это всё.', 'ru', '2026-02-23T17:05:53', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108798', 'answer', 'Спасибо. Попробуем помочь ей обратиться . Но сами понимаете... Черногория недружественная страна. Если бы Тайланд, (подругу мед.самолетом мчс  переправляли в Москву, у азиатов нету отрицательной группы крови от природы)', 'ru', '2026-02-23T17:22:51', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108799', 'question', 'А есть прецеденты сотрудничества МЧС рф с Чернргорией?', 'ru', '2026-02-23T17:26:42', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1343571341, '108800', 'answer', 'Не знаю, я здесь недавно, но    маршрутизацией занимается именно  Представительство РФ.', 'ru', '2026-02-23T17:46:11', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5160850474, '108803', 'question', 'Здравствуйте. Подскажите пожалуйста,есть ли врач ЛОР в Тивате???', 'ru', '2026-02-23T22:36:46', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1040724631, '108809', 'other', 'Тренинг по спасению жизни с отработкой техники сердечно-лёгочной реанимации под эгидой Красного креста Черногории\n\n‌По многочисленным просьбам повторяем тренинг, который будет полезен каждому, ведь он буквально может спасти жизнь человеку при потере сознания, остановке дыхания и сердечной деятельности.\n\nБудет уникальная возможность научиться на манекене (это невероятно, что удалось такой раздобыть!) техникам сердечно-легочной реанимации при критических для жизни состояниях. Эти приемы позволят в 4 раза увеличить шансы пострадавшего на выживание.\n\nПриходите! Эти знания могут подарить годы жизни находящемуся рядом с вами человеку, если он попал в беду. \n\nМероприятие пройдёт на русском и черногорском языках.\n\nЭксперты: \nOgnjen Vučinić — эксперт Красного Креста в области оказания первой помощи\nВиноградов Олег Иванович — невролог, д.м.н., профессор, президент АНО «Общество доказательной неврологии» (тел. 067372005)\n\n🗓 5 марта в 19:00\n💰 donation\n👉🏻 Записаться\n\n📍г. Бар, коворкинг Focuss.space. Вход с ул. Маршала Тито, 10, рядом с Hipotekarna Banka. 4й этаж (работает лифт)', 'ru', '2026-02-24T16:51:58', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_315702534, '108810', 'question', 'Добрый день!\nЕсть рецепт на препарат SERTRALINA полученный в Испании\nВ нескольких аптеках Будвы его нет в наличии\nПодскажите, можно ли его здесь найти, может у него другое торговое название здесь?', 'ru', '2026-02-24T17:27:10', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1205087381, '108811', 'other', 'Город Бар. Продам две пачки Джес плюс. Срок годности до 10/27. Стоимость - 20 евро каждая.', 'ru', '2026-02-24T20:21:16', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5261313329, '108812', 'question', 'Здравствуйте.\nМожет кто-то покупал лекарство Victoza 0.6? И есть чек от него.\nМожно мне фото чека в личку прислать?', 'ru', '2026-02-24T22:14:35', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5645781017, '108821', 'other', 'Здравствуйте! Может кто-то посоветовать врача маммолога , желательно Будва, но можно и другие города. Спасибо!', 'ru', '2026-02-25T10:01:12', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1631168589, '108822', 'answer', 'Буду рада Вам помочь', 'ru', '2026-02-25T10:07:23', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_439303151, '108829', 'question', 'Добрый день, подскажите, где в Черногории можно сделать обследование почек? Нужна реносцинтиграфия почек (динамическая нефросцинтиграфия)', 'ru', '2026-02-25T16:16:57', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5471723943, '108831', 'question', 'Добрый день! Есть ли у кого-то антибиотик авелокс? Или аналог?моксифлоксацин - действующее вещество. Срочно надо. Приедем, выкупим. Верю в силу чата!', 'ru', '2026-02-25T16:25:51', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_414229249, '108836', 'other', 'Здравствуйте, отдам миртазапин, полная пачка, годен до августа 2026, Будва', 'ru', '2026-02-25T18:41:37', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1631168589, '108837', 'answer', 'Написала вам в личку', 'ru', '2026-02-25T19:29:22', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108841', 'answer', 'Я могу ошибаться, но обратитесь сюда. Мне тут делали обследование почек, и доктор грамотный, (если нужно, вспомню имя)) https://maps.app.goo.gl/g7idfrQsTVfTze4u5', 'ru', '2026-02-25T20:33:58', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108842', 'other', 'Там прям на урологию ориентировано было. Сейчас не знаю как', 'ru', '2026-02-25T20:34:45', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108843', 'answer', 'В Черногории официально работает русскоязычный уролог @Dmitriydylinov Дмитрий Дылинов, работает в А3, попробуйте его спросить.', 'ru', '2026-02-25T21:00:59', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_381708485, '108850', 'other', 'Скажите пожалуйста, а здесь делают лапароскопическую/малоинвазивную стерилизацию кошек. МонтВет сказал, что нет. Извиняюсь, если здесь только для людей🤷‍♂️', 'ru', '2026-02-26T08:47:35', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_2132156571, '108851', 'question', 'Добрый день! \nИщем крем Скиноклир. Если кто-то знает где можно приобрести? \nСпасибо', 'ru', '2026-02-26T09:06:17', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5471723943, '108852', 'answer', 'Спросите в хасвет в подгорице.', 'ru', '2026-02-26T09:21:51', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_381708485, '108854', 'answer', 'Не, там уже тоже спрашивал', 'ru', '2026-02-26T09:31:57', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108855', 'answer', 'Нет, не делают, но в Хасвет Владислав делает очень аккуратную операцию👌 с маленьким шовчиком.', 'ru', '2026-02-26T09:36:02', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1317801545, '108856', 'answer', 'Подтверждаю. Шов на вторые сутки.', 'ru', '2026-02-26T09:52:10', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_173827874, '108857', 'question', 'Здравствуйте! Такой вопрос, у меня подкожное образование, которое хирург постановил вырезать, и мой лаб поставил ценник 1500 евро. Скажите, это обычная стоимость для подобной операции или все же можно где-то это сделать дешевле?', 'ru', '2026-02-26T09:56:47', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108858', 'answer', 'Если это "хирургическое вмешательство под общей анестезией", то да, цена обычная.\nЕсли под местной или это "Иссечение кожных и подкожных образований", то дорого', 'ru', '2026-02-26T10:04:46', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_381708485, '108859', 'answer', 'А это чей прайс? Мне ноготь сыну резали за 200 в кажется Поповичах, а тут дешевле в два раза. Причем Страховая не вернула деньги, сказали хронической заболевание😡', 'ru', '2026-02-26T10:07:21', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108860', 'answer', 'Это Милмедика Никшич', 'ru', '2026-02-26T10:07:46', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_381708485, '108861', 'answer', 'Спасибо. Не Попович была клиника Филипович😂', 'ru', '2026-02-26T10:08:55', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108862', 'answer', 'Дорого, конечно.\nЕсли в Никшич не хочется ехать, то в А3 всего 130 евро просят за вросший ноготь.', 'ru', '2026-02-26T10:10:48', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_173827874, '108863', 'other', 'Спасибо большое, у меня как раз подкожное, и мне кажется цена в 1500 неадекватной', 'ru', '2026-02-26T10:14:09', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108864', 'answer', 'Даже не придумывайте ничего. Анюта Подолог лучшая в Черногории!! Дуклей. Около 100 была цена, договоритесь', 'ru', '2026-02-26T10:32:17', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108865', 'other', '+79197791414 подолог Анюта, вотсап', 'ru', '2026-02-26T10:32:42', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108866', 'answer', 'Так есть же спец.чаты, они все знают https://t.me/cg_stray', 'ru', '2026-02-26T10:35:36', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_183191358, '108867', 'question', 'Друзья, очень нужен совет. Мне для рабочей визы нужно предоставить в посольство результаты мед анализов и флюорографии на Английском и с апостилем . Кто-то знает, где такое могут сделать? В Будве или хоть где то в ЧГ', 'ru', '2026-02-26T16:01:56', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108868', 'answer', 'Так сделайте где угодно, все равно на черногорском имхо сделают. \nА потом перевод на анг?\nInvitro, Hipokrat?\nИли тут спросите.\nhttps://t.me/UristMontenegro', 'ru', '2026-02-26T16:17:59', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_183191358, '108869', 'answer', 'Меня просят с апостилем. Я не понимаю, что это такое ( но все верно, вопрос скорее юридический', 'ru', '2026-02-26T16:19:46', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5663175852, '108871', 'answer', 'Перевод сделайте у судског преводилаца( судебного переводчика с черногорского на английский), их списки есть по городам , погуглите. А потом этот перевод заверяете в суде ( это и есть проставление апостиля- подтверждение уполномоченным гос органом , что преводилац такой есть и этот документ легален за границей чг)', 'ru', '2026-02-26T16:24:25', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5369422021, '108872', 'question', 'Добрый день. \nУважаемая аудитория,может был у кого-то опыт общения с отоларнигологом в Которе, поделитесь впечатлениями,пожалуйста 🙏 можно ли рассчитывать на квалифицированную  помощь при гайморите?', 'ru', '2026-02-26T16:28:20', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_183191358, '108873', 'answer', 'Спасибо! У меня просто уже целый пакет документов и с остальными такое не прокатило', 'ru', '2026-02-26T16:46:41', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6858662892, '108874', 'answer', 'В больницу сына возил на прием к лору. Не сказал бы что которский ценник хоть как-то оправдан.\nСамо здание где принимали - древнее и плачет по ремонту. Выписали антибиотик, но за рецептом отправляйтесь к себе в город, к терапевту. Вот вам бумажечка, может страховая примет. Уверен, что в частной будет не дороже, но всяко комфортнее.', 'ru', '2026-02-26T18:20:08', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5369422021, '108875', 'answer', 'Спасибо', 'ru', '2026-02-26T18:30:13', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108876', 'answer', 'Котор чисто разводилово для туристов', 'ru', '2026-02-26T18:57:36', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108877', 'other', 'Роды так ценник космос. В Дёблинг в Австрии почти такой же, но качество не сравнимо со средневековым городом🤣', 'ru', '2026-02-26T18:58:39', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_381708485, '108878', 'answer', 'Может это оффтоп, но я думаю, что которский ценник ни в каой области не оправдан)', 'ru', '2026-02-26T19:44:12', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '108879', 'answer', 'Напишите Наиле Nailia \nОна работает в Боно Медика в Будве и доме здравля. Может, она подскажет, можно ли это образование удалить где-то дешевле. Может, у них в клинике делается. \n\nСложно сказать об адекватности цены, Когда не знаешь какая у вас проблема.', 'ru', '2026-02-26T21:45:00', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '108880', 'answer', 'Вообще апостилируют документы (вне зависимости что это за документ медицинский или нет) министерство юстиции или суд. \nПопробуйте уточнить вот в этой юридической группе в Фейсбуке\n https://www.facebook.com/groups/ChernogoriyaYurinfo/?ref=share&mibextid=NSMWBT', 'ru', '2026-02-26T21:48:38', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1522284115, '108895', 'question', 'Добрый день! Может ли кто-нибудь подсказать русскоязычного невролога?', 'ru', '2026-02-28T17:10:01', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1102351030, '108896', 'answer', 'Ольга Ваганова \n#самореклама #невролог #выезднадом \n\nВрач общей практики, невролог\n\nЛицензия на медицинскую деятельность в Черногории.\n\n✔️Вся неврология. Люблю разбираться в сложных случаях.\n✔️Ведение онлайн на период лечения или диагностики.\n✔️Индивидуальный подбор упражнений при болевых синдромах.\n✔️Посмотрим вместе ваши МРТ, переведу на понятный язык результаты анализов и обследований. \n✔️Базовая терапевтическая помощь, маршрутизация по врачам/клиникам Черногории. \nПринимаю детей с 6 лет.\n\nПишу о неврологии в Черногории https://t.me/neurotivat\n\nПринимаю:\nв клинике в Тивате (рецепты, документы для страховой)\nонлайн\nна дому\n\nСвязь:  телеграм @averataker (всегда на связи)', 'ru', '2026-02-28T17:16:11', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_361370649, '108899', 'answer', 'В Тивате обращались к лору с гайморитом. https://t.me/vraciicliniki/74856', 'ru', '2026-02-28T22:50:22', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5471723943, '108901', 'answer', 'Она в отъезде. Будет в марте.', 'ru', '2026-03-01T08:18:59', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5369422021, '108902', 'answer', 'Спасибо', 'ru', '2026-03-01T14:06:22', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5261313329, '108903', 'question', 'Здравствуйте.\nМожет кто-то покупал лекарство Victoza 0.6? И есть чек от него.\nМожно мне фото чека в личку прислать?', 'ru', '2026-03-01T16:35:41', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1343571341, '108915', 'other', 'Обменяю остатки на €. \n1. Анжелик 28таб = 14 €\n2.Энтерофурил200мг×16таб=5€\n3.Магнерот500мг×100таб =14€\n4.Дексазон05мг×48таб = 1€\n5.Кофеин100мг×10таб=1,5€\n6.Ипигрикс20мг×75таб=30€. Будва. Район TQ PLAZA.', 'ru', '2026-03-02T17:40:22', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1411450220, '108917', 'answer', 'В милмедике дают версию на английском, если попросить .\nВ Тивате в порто точно.', 'ru', '2026-03-02T19:47:25', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108919', 'answer', 'А в чем прикол?', 'ru', '2026-03-02T20:34:27', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108920', 'other', 'Можно я тоже так обменяю🤣', 'ru', '2026-03-02T20:34:55', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1343571341, '108921', 'answer', 'Можно😆', 'ru', '2026-03-02T21:00:32', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_868999124, '108927', 'question', 'Здравствуйте, у кого-нибудь есть левомеколь?', 'ru', '2026-03-03T13:52:11', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1567355729, '108929', 'answer', 'Советую Владимира из Боно медики', 'ru', '2026-03-03T17:10:43', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1134374569, '108930', 'question', 'Друзья!\nМожет кто подскажет где можно купить без рецепта монурал? Спокойно раньше покупала, сейчас строго по рецепту- в Будве..', 'ru', '2026-03-03T17:31:06', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1040724631, '108931', 'other', 'Уже в этот четверг состоится тренинг по спасению жизни с отработкой техники сердечно-лёгочной реанимации под эгидой Красного креста Черногории\n\n‌По многочисленным просьбам повторяем тренинг, который будет полезен каждому, ведь он буквально может спасти жизнь человеку при потере сознания, остановке дыхания и сердечной деятельности.\n\nБудет уникальная возможность научиться на манекене (это невероятно, что удалось такой раздобыть!) техникам сердечно-легочной реанимации при критических для жизни состояниях. Эти приемы позволят в 4 раза увеличить шансы пострадавшего на выживание.\n\nПриходите! Эти знания могут подарить годы жизни находящемуся рядом с вами человеку, если он попал в беду. \n\nМероприятие пройдёт на русском и черногорском языках.\n\nЭксперты: \nOgnjen Vučinić — эксперт Красного Креста в области оказания первой помощи\nВиноградов Олег Иванович — невролог, д.м.н., профессор, президент АНО «Общество доказательной неврологии» (тел. 067372005)\n\n🗓 5 марта в 19:00\n💰 donation\n👉🏻 Записаться\n\n📍г. Бар, коворкинг Focuss.space. Вход с ул. Маршала Тито, 10, рядом с Hipotekarna Banka. 4й этаж (работает лифт)', 'ru', '2026-03-03T18:09:58', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_700020194, '108948', 'question', 'Добрый день! Подскажите, пожалуйста, детского хирурга(Бар, Подгорица, Будва)? У ребенка(11месяцев), на большом пальце руки растёт не ровный ноготь и вокруг него палец розовый.', 'ru', '2026-03-05T12:37:13', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_398192727, '108951', 'question', 'Всем привет!\nКто-то может подсказать - есть ли в прейскурантах местных клиниках "КТ костей черепа"?\n\nЧтобы захватывал череп полностью - и мозговой отдел и лицевой', 'ru', '2026-03-05T18:59:58', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_63044576, '108952', 'answer', 'в местных клиниках редко можно найти прейскурант в открытом доступе, но в Конзилиуме предлагают "CT kostiju lica" за 115 евро\nЕще есть "CT mozga sa kostima lica" за 165\nИ височная кость отдельно - "CT temporalne kosti" - 115 евро', 'ru', '2026-03-05T19:19:59', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_398192727, '108953', 'answer', 'Спасибо большое', 'ru', '2026-03-05T19:20:32', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5669928231, '108960', 'question', 'Добрый вечер. Лаборатория в будванском доме здравля работает по субботам, подскажите, пожалуйста?', 'ru', '2026-03-06T21:51:49', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1631168589, '108961', 'answer', 'Только экстренно по направлению врача', 'ru', '2026-03-06T21:53:05', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5669928231, '108962', 'answer', 'Есть направление от педиатра для дочки на бактериальную инфекцию кровь. Можем приехать рано утром как в обычный день?', 'ru', '2026-03-06T22:00:00', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1317801545, '108964', 'answer', 'Экстренно, это когда на упуте пометка Cito!.', 'ru', '2026-03-07T04:52:17', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108970', 'question', 'Кто может на дому ставить капельницы?', 'ru', '2026-03-07T16:11:41', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108971', 'other', 'Забыла добавить. Будва', 'ru', '2026-03-07T16:40:55', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '108972', 'answer', '-Ашихмин Олег, поищите контакт поиском по чату.', 'ru', '2026-03-07T16:52:57', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1149743584, '108982', 'other', 'Если кто-то нуждается в проведении в/в инфузионной терапии, пишите, чем смогу- помогу', 'ru', '2026-03-08T19:56:36', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_479029454, '108983', 'question', 'Город?', 'ru', '2026-03-08T19:57:00', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1149743584, '108984', 'other', 'Будва', 'ru', '2026-03-08T19:59:58', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108985', 'answer', 'Вы доктор? Можете прийти, пациента посмотреть и назначить капельницы?', 'ru', '2026-03-08T23:25:10', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1149743584, '108986', 'question', 'Да я врач, а что с пациентом?', 'ru', '2026-03-08T23:26:28', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108987', 'answer', 'https://www.facebook.com/share/p/1KcbSREBjr/', 'ru', '2026-03-08T23:32:13', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108988', 'answer', 'Если коротко.  Была следующая ситуация у б.Любы (возможно после короны, с сентября 2025 года еще) жидкость в легких, больницы ни котор ни подгорица, ни А3 ее не взяли что бы эту "воду" откачать. причины не назввли сказали ей езжайте домой , (вероятно из за того что возраст 70+) Мы договорились ,определили в Брезовик(2 недели) ,все откачали  брезовик + подгорица кбц(дренаж и 3 дня в кбц), чтобы подготовить ее к отправке в рф\n Но дома ей становится хуже , жидкость возможно продолжает скапливается , причину скопления  не обнаружили ,диагноза толком никакого нет. Че только не делали уже, кт, узи, анализы...не нашли ничего. только прописали антибиотики и выписали домой.\nПолагаю возможно неправильно леченная в Которе и в Будве пневмония полгода назад, переросла в хронь(тк онко в роду нет ни у кого и в 21 году она обследовалась полностью, не было ничего)\nНужен док, кто в Будве придет лично все посмотрит и поставит капельницы. И по честному сказать можно ли ее подготовить к транспортировке в рф.', 'ru', '2026-03-08T23:40:34', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108989', 'other', 'Другие органы тоже обследовали, почки, сердце, вроде все норм', 'ru', '2026-03-08T23:44:33', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1149743584, '108990', 'question', 'Хорошо, завтра я смогу ее посмотреть во второй половине дня. Вас устроит?', 'ru', '2026-03-08T23:45:02', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '108991', 'answer', 'Да\n Пришлите в лс телефон?', 'ru', '2026-03-08T23:45:35', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_320596110, '109007', 'question', 'здравствуйте! есть терапевт, кто сможет принять завтра (тиват/котор/будва) на диагностику и выписать лечение? 3-й день небольшая температура, боль в горле', 'ru', '2026-03-09T15:46:14', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1205087381, '109009', 'other', 'Продам две упаковки Джес Плюс, срок годности до 10/27, стоимость - 20 евро каждая.', 'ru', '2026-03-09T16:29:59', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5204554091, '109013', 'question', 'Добрый вечер. Подскажите пожалуйста в Баре офтальмолога русскоговорящего если есть?', 'ru', '2026-03-09T20:19:01', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_140512321, '109014', 'question', 'Добрый вечер! Может у кого то есть такой препарат? Отзовитесь!', 'ru', '2026-03-09T21:28:27', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5413913406, '109019', 'answer', 'Добрый вечер! Яковлев Василий Евгеньевич принимает в Баре @YakovlevBarBot', 'ru', '2026-03-10T01:28:53', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_6045022658, '109024', 'question', 'Подскажите пожалуйста, продаётся ли в аптеках мелисса в капсулах/таблетках? Как называется?', 'ru', '2026-03-10T12:31:52', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_234397392, '109026', 'other', 'Белара, один блистер, срок до 06/2026. 12€, Бар', 'ru', '2026-03-10T14:09:37', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_5663175852, '109028', 'answer', 'Odoval S, валериана +мелисса., а так мелисса matičnjak.', 'ru', '2026-03-10T16:56:47', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1163694673, '109055', 'other', 'Подскажите пожалуйста детского стоматолога в Баре', 'ru', '2026-03-12T13:31:43', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '109061', 'other', 'Если вы в Черногории, попробуйте невролога, бывшая заведующая кбц неврологии в Подгорице. Крутой спец старой закалки с кучей оборудования\nПоставила свекровь и знакомую на ноги после инсульта. Обе лежали полупарализованные в лёжку. У одной сняла диагноз Альцгеймера, поставленный светилами в Москве. Бабулька в 78 еще и замуж выходила потом!\nОчень достойный специалист для Черногории\n Она подняла много кого !\n И остеопат Граненко (приедет с 15 -19 в Черногорию) берется за сложные случаи. Все это стоит на порядок дешевле. Раз так в 5', 'ru', '2026-03-12T18:44:15', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '109063', 'other', 'И не слушайте про "быстрое"\nПоднять то на ноги можно, вопрос что б рецидивов не было.\nЭто огромная работа, желательно не только с медиками , неврологами и реабилитологами, но и с психотерапевтом. Причина обычно глубже', 'ru', '2026-03-12T18:48:17', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_527808678, '109067', 'question', 'Друзья, есть номер ветеринара, который может сейчас приехать?', 'ru', '2026-03-13T01:08:35', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_809428768, '109069', 'answer', 'Ветеренары тут по домам не ездят. Но вы не там спрашиваете\nЗооволонтеры:\nhttps://t.me/cg_stray', 'ru', '2026-03-13T06:18:25', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_724952512, '109076', 'answer', 'Знаю прекрасного стоматолога… только в Будве @drReginaDentist', 'ru', '2026-03-13T17:18:26', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_762035998, '109077', 'answer', 'Если вам ещё не сказали, в Подгорице круглосуточно работает вет.клиника hasvet', 'ru', '2026-03-13T17:28:10', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_105291894, '109078', 'other', 'Добрый вечер. Ищу доктора кто может выдать рецепт на эсцилопрам 10мг. \nЕсть рецепт из России, но его не принимают нигде. \nБуду благодарен помощи.', 'ru', '2026-03-13T20:16:47', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_861525386, '109104', 'question', 'Доброе утро! Ищу ЛОР-врача в Будве. Подскажите, пожалуйста, куда можно обратиться?', 'ru', '2026-03-16T09:03:29', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_422859962, '109132', 'other', 'Алпатова Светлана \nСтоматолог врач высшей категории\nЛицензия  на медицинскую деятельность в Черногории \nСпециализация- терапевтичкская стоматология,  эстетическая реставрация, эндодонтия, проф гигиена и профилактика стом заболеваний.\nПриём пациентов по страховка Unika и Sava.\nПринимаю в г Podgorica  ordinacija Dr Senad.', 'ru', '2026-03-17T20:38:16', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1343571341, '109145', 'other', 'Обменяю остатки на €. \n1. Анжелик 28таб = 14 €\n2.Энтерофурил200мг×16таб=5€\n3.Магнерот500мг×100таб =12€\n4.Дексазон0,5мг×48таб = 1€\n5.Кофеин100мг×10таб=1,5€\n6.Ипигрикс20мг×50таб=20€. Будва. Район TQ PLAZA.', 'ru', '2026-03-18T17:27:59', 0, NULL)
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

INSERT INTO kb_messages (source_id, user_id, provider_message_id, message_type, original_text, original_language, published_at, has_media, media_type)
VALUES ((SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293'), @tg_user_1138313294, '109153', 'other', 'Продам Редуксин 15 мг (препарат для снижения веса и контроля аппетита).\nПокупала в России неделю назад. Упаковка 90 капсул. Осталось 83 капсулы (почти полный курс).\nМне не подошёл, поэтому продаю.\nЦена: 95 €.\nХерцег Нови.\nПишите в личку.', 'ru', '2026-03-20T04:58:37', 1, 'photo')
ON DUPLICATE KEY UPDATE original_text = VALUES(original_text), message_type = VALUES(message_type);

-- Set reply_to_id references
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107712') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107733' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107736') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107737' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107786') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107787' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107787') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107788' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107798') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107799' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107805') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107807' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107805') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107808' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107814') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107815' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107815') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107816' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107814') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107820' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107861') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107862' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107875') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107876' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107875') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107877' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107891') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107892' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107886') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107893' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107891') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107894' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107893') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107895' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107895') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107896' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107896') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107898' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107898') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107899' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107921') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107932' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107932') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107935' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107969') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107973' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107975') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107976' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107975') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107979' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107997') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107998' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107997') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '107999' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108049') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108050' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108050') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108051' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108051') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108052' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108052') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108053' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108048') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108054' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108102') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108109' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108137') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108145' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108145') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108174' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108041') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108180' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108244') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108247' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108238') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108248' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108302') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108303' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108315') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108319' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108337') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108338' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108323') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108362' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108363') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108367' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108369') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108372' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108379') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108383' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108383') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108390' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108408') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108410' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108427') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108428' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108428') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108429' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108429') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108430' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108427') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108439' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108439') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108443' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108443') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108444' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108444') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108445' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108445') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108446' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108444') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108458' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108466') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108569' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108577') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108578' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108588') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108591' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108597') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108598' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108605') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108607' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108611') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108612' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108695') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108776' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108776') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108779' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108783') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108784' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108791') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108793' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108794') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108797' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108797') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108798' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108799') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108800' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108821') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108822' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108831') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108837' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108829') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108841' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108829') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108843' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108850') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108852' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108852') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108854' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108850') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108855' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108855') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108856' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108857') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108858' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108858') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108859' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108859') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108860' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108860') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108861' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108861') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108862' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108862') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108864' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108850') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108866' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108867') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108868' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108868') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108869' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108869') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108871' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108871') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108873' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108872') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108874' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108874') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108875' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108874') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108876' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108874') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108878' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108863') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108879' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108873') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108880' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108895') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108896' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108872') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108899' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108899') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108901' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108901') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108902' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108867') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108917' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108915') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108919' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108920') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108921' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108821') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108929' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108951') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108952' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108952') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108953' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108960') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108961' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108961') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108962' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108962') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108964' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108971') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108972' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108982') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108985' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108986') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108987' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108986') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108988' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108990') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '108991' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109013') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109019' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109024') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109028' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109067') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109069' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109055') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109076' AND reply_to_id IS NULL;
UPDATE kb_messages SET reply_to_id = (
  SELECT id FROM (SELECT id FROM kb_messages WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109067') AS t
) WHERE source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293') AND provider_message_id = '109077' AND reply_to_id IS NULL;

-- =====================================================
-- PART 4: Tags
-- =====================================================

INSERT IGNORE INTO kb_tags (slug) VALUES ('topic');
INSERT IGNORE INTO kb_tags (slug) VALUES ('city');
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:vyzov-na-dom', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('city:budva', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'city') AS t));
INSERT IGNORE INTO kb_tags (slug) VALUES ('terapija');
INSERT IGNORE INTO kb_tags (slug) VALUES ('ginekologija');
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('city:bar', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'city') AS t));
INSERT IGNORE INTO kb_tags (slug) VALUES ('kardiologija');
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('city:podgorica', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'city') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('city:tivat', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'city') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('city:herceg-novi', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'city') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:uzi', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:ekg', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug) VALUES ('otorinolaringologija');
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('city:kotor', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'city') AS t));
INSERT IGNORE INTO kb_tags (slug) VALUES ('dermatologija');
INSERT IGNORE INTO kb_tags (slug) VALUES ('nevrologija');
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:gastroenterologija', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug) VALUES ('urologija');
INSERT IGNORE INTO kb_tags (slug) VALUES ('oftalmologija');
INSERT IGNORE INTO kb_tags (slug) VALUES ('psihijatrija');
INSERT IGNORE INTO kb_tags (slug) VALUES ('stomatologija');
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:lechenie-zubov', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:apteka', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:analizy', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug) VALUES ('endokrinologija');
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:rentgen', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:ceny', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:strahovanje', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug, parent_id) VALUES ('topic:dokumenty', (SELECT id FROM (SELECT id FROM kb_tags WHERE slug = 'topic') AS t));
INSERT IGNORE INTO kb_tags (slug) VALUES ('hirurgija');

-- =====================================================
-- PART 5: Q&A Threads
-- =====================================================

-- qa-001: Можно ли вызвать врача на дом в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('mozhno-li-vyzvat-vracha-na-dom-v-chernogorii', 'draft',
  'Da li je moguće pozvati lekara na kućnu posetu u Crnoj Gori?', 'Да ли је могуће позвати лекара на кућну посету у Црној Гори?', 'Is it possible to call a doctor for a home visit in Montenegro?', 'Можно ли вызвать врача на дом в Черногории?', 'Kann man in Montenegro einen Arzt zu einem Hausbesuch rufen?', 'Karadağ\'da eve doktor çağırmak mümkün mü?',
  'U Crnoj Gori hitna pomoć ne izlazi na kućne adrese — u hitnim slučajevima morate sami doći u hitnu pomoć (Hitna pomoć). Međutim, postoje privatni lekari koji dolaze na kućne posete. U Budvi i okolini možete pronaći terapeuta Olega Ašihmina pretragom u medicinskim četovima. Takođe, neke medicinske sestre nude usluge intravenske infuzione terapije (infuzija) kod kuće. Kod visoke temperature, do dolaska lekara pomaže paracetamol, obloge vlažnim peškirom, obilno pijenje tečnosti i vitamin C.', 'У Црној Гори хитна помоћ не излази на кућне адресе — у хитним случајевима морате сами доћи у хитну помоћ (Hitna pomoć). Међутим, постоје приватни лекари који долазе на кућне посете. У Будви и околини можете пронаћи терапеута Олега Ашихмина претрагом у медицинским четовима. Такође, неке медицинске сестре нуде услуге интравенске инфузионе терапије (инфузија) код куће. Код високе температуре, до доласка лекара помаже парацетамол, облоге влажним пешкиром, обилно пијење течности и витамин C.', 'In Montenegro, the ambulance service does not make house calls — in emergencies, you need to go to the emergency room (Hitna pomoć) yourself. However, there are private doctors who make home visits. In Budva and the surrounding area, you can find the therapist Oleg Ashikhmin by searching in medical chat groups. Some nurses also offer intravenous infusion therapy (IV drips) at home. For a high fever while waiting for the doctor, paracetamol, wiping down with a damp towel, plenty of fluids, and vitamin C can help.', 'В Черногории скорая помощь на дом не выезжает — при экстренных случаях нужно самому ехать в скорую (Hitna pomoć). Однако есть частные врачи, которые делают выезды на дом. В Будве и окрестностях можно найти терапевта Олега Ашихмина через поиск в медицинских чатах. Также некоторые медсёстры предлагают услуги по проведению внутривенной инфузионной терапии (капельниц) на дому. При высокой температуре до приезда врача помогает парацетамол, обтирание влажным полотенцем, обильное питьё и витамин C.', 'In Montenegro kommt der Rettungsdienst nicht zu Hausbesuchen — in Notfällen müssen Sie selbst zur Notaufnahme (Hitna pomoć) fahren. Es gibt jedoch private Ärzte, die Hausbesuche machen. In Budva und Umgebung können Sie den Therapeuten Oleg Ashikhmin über medizinische Chatgruppen finden. Einige Krankenschwestern bieten auch intravenöse Infusionstherapie (Tropfinfusionen) zu Hause an. Bei hohem Fieber helfen bis zum Eintreffen des Arztes Paracetamol, Abreiben mit einem feuchten Handtuch, reichlich Flüssigkeitszufuhr und Vitamin C.', 'Karadağ\'da acil servis eve gelmiyor — acil durumlarda acil servise (Hitna pomoć) kendiniz gitmeniz gerekiyor. Ancak eve gelen özel doktorlar mevcut. Budva ve çevresinde, tıbbi sohbet gruplarında arama yaparak terapist Oleg Ashikhmin\'i bulabilirsiniz. Ayrıca bazı hemşireler evde intravenöz infüzyon tedavisi (serum takma) hizmeti sunmaktadır. Yüksek ateşte doktor gelene kadar parasetamol, nemli havluyla silme, bol sıvı tüketimi ve C vitamini yardımcı olur.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'mozhno-li-vyzvat-vracha-na-dom-v-chernogorii' AND tg.slug = 'topic:vyzov-na-dom';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'mozhno-li-vyzvat-vracha-na-dom-v-chernogorii' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'mozhno-li-vyzvat-vracha-na-dom-v-chernogorii' AND tg.slug = 'terapija';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'mozhno-li-vyzvat-vracha-na-dom-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107736';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'mozhno-li-vyzvat-vracha-na-dom-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107737';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'mozhno-li-vyzvat-vracha-na-dom-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108315';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'mozhno-li-vyzvat-vracha-na-dom-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108982';

-- qa-002: Где найти гинеколога в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-ginekologa-v-chernogorii', 'draft',
  'Gde pronaći ginekologa u Crnoj Gori?', 'Где пронаћи гинеколога у Црној Гори?', 'Where to find a gynecologist in Montenegro?', 'Где найти гинеколога в Черногории?', 'Wo findet man einen Gynäkologen in Montenegro?', 'Karadağ\'da jinekolog nerede bulunur?',
  'U Baru ginekolog prima u klinici A3 Medical (Sutomore) — Vesna Čolaković-Popović. Klinika nudi podršku na ruskom jeziku. U Budvi možete se obratiti klinici Humana reprodukcija kod doktorke Marije Petričević — ona malo govori ruski. Takođe, u okviru planskih pregleda, ginekološke usluge su dostupne u Novi Standard i drugim većim klinikama.', 'У Бару гинеколог прима у клиници A3 Medical (Суторме) — Vesna Čolaković-Popović. Клиника нуди подршку на руском језику. У Будви можете се обратити клиници Humana reprodukcija код докторке Марије Петричевић — она мало говори руски. Такође, у оквиру планских прегледа, гинеколошке услуге су доступне у Novi Standard и другим већим клиникама.', 'In Bar, a gynecologist sees patients at the A3 Medical clinic (Sutomore) — Vesna Čolaković-Popović. The clinic offers Russian-language assistance. In Budva, you can visit the Humana reprodukcija clinic and see Dr. Marija Petričević — she speaks some Russian. Gynecological services are also available for routine examinations at Novi Standard and other major clinics.', 'В Баре гинеколог принимает в клинике A3 Medical (Сутоморе) — Vesna Čolaković-Popović. Клиника предлагает сопровождение на русском языке. В Будве можно обратиться в клинику Humana reprodukcija к доктору Марии Петричевич — она немного говорит по-русски. Также в рамках планового обследования гинекологические услуги доступны в Novi Standard и других крупных клиниках.', 'In Bar praktiziert eine Gynäkologin in der Klinik A3 Medical (Sutomore) — Vesna Čolaković-Popović. Die Klinik bietet Betreuung auf Russisch an. In Budva können Sie die Klinik Humana reprodukcija aufsuchen und Dr. Marija Petričević konsultieren — sie spricht etwas Russisch. Im Rahmen von Routineuntersuchungen sind gynäkologische Leistungen auch bei Novi Standard und anderen größeren Kliniken verfügbar.', 'Bar\'da jinekolog A3 Medical kliniğinde (Sutomore) hasta kabul ediyor — Vesna Čolaković-Popović. Klinik Rusça destek sunmaktadır. Budva\'da Humana reprodukcija kliniğine Dr. Marija Petričević\'e başvurabilirsiniz — biraz Rusça konuşmaktadır. Ayrıca rutin muayeneler kapsamında jinekolojik hizmetler Novi Standard ve diğer büyük kliniklerde de mevcuttur.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii' AND tg.slug = 'ginekologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii' AND tg.slug = 'city:bar';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 15 FROM kb_threads t WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107861';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107862';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107921';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107922';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-ginekologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107923';

-- qa-003: Где найти кардиолога и сделать УЗИ сердца (ЭхоКГ) в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii', 'draft',
  'Gde pronaći kardiologa i uraditi ultrazvuk srca (ehokardiografiju) u Crnoj Gori?', 'Где пронаћи кардиолога и урадити ултразвук срца (ехокардиографију) у Црној Гори?', 'Where to find a cardiologist and get a cardiac ultrasound (echocardiography) in Montenegro?', 'Где найти кардиолога и сделать УЗИ сердца (ЭхоКГ) в Черногории?', 'Wo findet man einen Kardiologen und kann eine Herzultraschalluntersuchung (Echokardiographie) in Montenegro durchführen lassen?', 'Karadağ\'da kardiyolog nerede bulunur ve kalp ultrasonu (ekokardiyografi) nerede yaptırılır?',
  'U Podgorici nema kardiologa koji govore ruski, ali možete se obratiti klinikama sa podrškom na ruskom jeziku: Kerber i Codra Hospital u Podgorici. Kardiolozi koji govore ruski postoje u Tivtu (Aleksandar Viler, klinika DrViller Reheart) i u Herceg Novom (Tatjana Homjakova). Ultrazvuk srca (ehokardiografiju) rade u mnogim klinikama: A3 Medical, Konzilium, Milmedika, Natal.', 'У Подгорици нема кардиолога који говоре руски, али можете се обратити клиникама са подршком на руском језику: Kerber и Codra Hospital у Подгорици. Кардиолози који говоре руски постоје у Тивту (Александар Вилер, клиника DrViller Reheart) и у Херцег Новом (Татјана Хомјакова). Ултразвук срца (ехокардиографију) раде у многим клиникама: A3 Medical, Конзилиум, Милмедика, Натал.', 'There are no Russian-speaking cardiologists in Podgorica, but you can visit clinics with Russian-language support: Kerber and Codra Hospital in Podgorica. Russian-speaking cardiologists are available in Tivat (Aleksandr Viller, DrViller Reheart clinic) and in Herceg Novi (Tatyana Khomyakova). Cardiac ultrasound (echocardiography) is performed at many clinics: A3 Medical, Konzilium, Milmedika, Natal.', 'Русскоязычных кардиологов в Подгорице нет, но можно обратиться в клиники с русскоязычным сопровождением: Kerber и Codra Hospital в Подгорице. Русскоговорящие кардиологи есть в Тивате (Александр Виллер, клиника DrViller Reheart) и в Херцег-Нови (Татьяна Хомякова). УЗИ сердца (ЭхоКГ) делают во многих клиниках: A3 Medical, Конзилиум, Милмедика, Натал.', 'In Podgorica gibt es keine russischsprachigen Kardiologen, aber Sie können Kliniken mit russischsprachiger Betreuung aufsuchen: Kerber und Codra Hospital in Podgorica. Russischsprachige Kardiologen gibt es in Tivat (Aleksandr Viller, Klinik DrViller Reheart) und in Herceg Novi (Tatyana Khomyakova). Herzultraschall (Echokardiographie) wird in vielen Kliniken durchgeführt: A3 Medical, Konzilium, Milmedika, Natal.', 'Podgorica\'da Rusça konuşan kardiyolog bulunmamaktadır, ancak Rusça destek sunan kliniklere başvurabilirsiniz: Podgorica\'da Kerber ve Codra Hospital. Rusça konuşan kardiyologlar Tivat\'ta (Aleksandr Viller, DrViller Reheart kliniği) ve Herceg Novi\'de (Tatyana Khomyakova) mevcuttur. Kalp ultrasonu (ekokardiyografi) birçok klinikte yapılmaktadır: A3 Medical, Konzilium, Milmedika, Natal.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii' AND tg.slug = 'kardiologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii' AND tg.slug = 'city:podgorica';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii' AND tg.slug = 'city:tivat';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii' AND tg.slug = 'city:herceg-novi';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii' AND tg.slug = 'topic:uzi';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii' AND tg.slug = 'topic:ekg';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 29 FROM kb_threads t WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 28 FROM kb_threads t WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 24 FROM kb_threads t WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 15 FROM kb_threads t WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107875';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107876';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107877';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108244';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-kardiologa-i-sdelat-uzi-serdca-ehokg-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108245';

-- qa-004: Где найти ЛОР-врача (отоларинголога) в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-lor-vracha-otolaringologa-v-chernogorii', 'draft',
  'Gde pronaći ORL lekara (otorinolaringologa) u Crnoj Gori?', 'Где пронаћи ОРЛ лекара (оториноларинголога) у Црној Гори?', 'Where to find an ENT doctor (otolaryngologist) in Montenegro?', 'Где найти ЛОР-врача (отоларинголога) в Черногории?', 'Wo findet man einen HNO-Arzt (Hals-Nasen-Ohren-Arzt) in Montenegro?', 'Karadağ\'da KBB doktoru (kulak burun boğaz uzmanı) nerede bulunur?',
  'ORL lekari su dostupni u nekoliko gradova. U državnoj bolnici u Kotoru postoji prijem po uputu, ali su utisci nejednoznačni — cene su visoke uz nedovoljno kvalitetnu uslugu. U Tivtu postoji privatni ORL lekar sa dobrim ocenama. U Budvi možete se obratiti domu zdravlja za uput. Takođe, u Herceg Novom radi ORL Klinika dr Barjaktarović. Kod sinuzitisa se preporučuje obraćanje privatnim klinikama — tamo je obično brže i udobnije.', 'ОРЛ лекари су доступни у неколико градова. У државној болници у Котору постоји пријем по упуту, али су утисци неједнозначни — цене су високе уз недовољно квалитетну услугу. У Тивту постоји приватни ОРЛ лекар са добрим оценама. У Будви можете се обратити дому здравља за упут. Такође, у Херцег Новом ради ORL Klinika dr Barjaktarović. Код синузитиса се препоручује обраћање приватним клиникама — тамо је обично брже и удобније.', 'ENT doctors are available in several cities. The public hospital in Kotor accepts patients with a referral (uput), but reviews are mixed — prices are high while service quality is mediocre. In Tivat, there is a private ENT doctor with good reviews. In Budva, you can visit the dom zdravlja (health center) to get a referral. In Herceg Novi, ORL Klinika dr Barjaktarović is available. For sinusitis, it is recommended to visit private clinics — they are usually faster and more convenient.', 'ЛОР-врачи доступны в нескольких городах. В государственной больнице в Которе есть приём по направлению (упут), но отзывы неоднозначные — ценник высокий при невысоком качестве сервиса. В Тивате есть частный ЛОР с хорошими отзывами. В Будве можно обратиться в дом здравља за направлением. Также в Херцег-Нови работает ORL Klinika dr Barjaktarović. При гайморите рекомендуется обращаться в частные клиники — там обычно быстрее и удобнее.', 'HNO-Ärzte sind in mehreren Städten verfügbar. Im staatlichen Krankenhaus in Kotor gibt es Termine mit Überweisung (Uput), aber die Bewertungen sind gemischt — die Preise sind hoch bei mäßiger Servicequalität. In Tivat gibt es einen privaten HNO-Arzt mit guten Bewertungen. In Budva können Sie das Dom zdravlja (Gesundheitszentrum) für eine Überweisung aufsuchen. In Herceg Novi ist die ORL Klinika dr Barjaktarović tätig. Bei Sinusitis wird empfohlen, private Kliniken aufzusuchen — dort geht es in der Regel schneller und bequemer.', 'KBB doktorları birkaç şehirde mevcuttur. Kotor\'daki devlet hastanesinde sevk (uput) ile muayene yapılmaktadır, ancak yorumlar karışıktır — hizmet kalitesi düşükken fiyatlar yüksektir. Tivat\'ta iyi yorumlara sahip özel bir KBB doktoru bulunmaktadır. Budva\'da sevk almak için dom zdravlja\'ya (sağlık merkezine) başvurabilirsiniz. Herceg Novi\'de ise ORL Klinika dr Barjaktarović hizmet vermektedir. Sinüzit durumunda özel kliniklere başvurmanız tavsiye edilir — genellikle daha hızlı ve daha konforludur.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii' AND tg.slug = 'otorinolaringologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii' AND tg.slug = 'city:kotor';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii' AND tg.slug = 'city:tivat';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii' AND tg.slug = 'city:herceg-novi';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 22 FROM kb_threads t WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108872';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108873';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108874';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108875';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108876';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108877';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108878';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-lor-vracha-otolaringologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108879';

-- qa-005: Где в Черногории удалить папилломы и другие кожные образования?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya', 'draft',
  'Gde u Crnoj Gori ukloniti papilome i druge kožne izraštaje?', 'Где у Црној Гори уклонити папиломе и друге кожне израштаје?', 'Where to remove papillomas and other skin growths in Montenegro?', 'Где в Черногории удалить папилломы и другие кожные образования?', 'Wo kann man in Montenegro Papillome und andere Hautveränderungen entfernen lassen?', 'Karadağ\'da papillom ve diğer cilt oluşumları nerede aldırılır?',
  'U Crnoj Gori uklanjanjem kožnih izraštaja (papiloma, mladeža itd.) pomoću koagulatora bavi se nekoliko specijalista. U Baru i Budvi prima dermatolog Jana Solovcova (@yanasolovtsova) — radi u privatnoj ordinaciji u Baru i jednom nedeljno u kozmetičkom salonu u Budvi. U Herceg Novom postoji dermatolog-venerolog (@dermatologvenerolog). Prilikom izbora specijaliste preporučuje se proveriti posedovanje licence za medicinsku delatnost u Crnoj Gori.', 'У Црној Гори уклањањем кожних израштаја (папилома, младежа итд.) помоћу коагулатора бави се неколико специјалиста. У Бару и Будви прима дерматолог Јана Соловцова (@yanasolovtsova) — ради у приватној ординацији у Бару и једном недељно у козметичком салону у Будви. У Херцег Новом постоји дерматолог-венеролог (@dermatologvenerolog). Приликом избора специјалисте препоручује се проверити поседовање лиценце за медицинску делатност у Црној Гори.', 'In Montenegro, several specialists perform removal of skin growths (papillomas, moles, etc.) using a coagulator. In Bar and Budva, dermatologist Yana Solovtsova (@yanasolovtsova) sees patients — she works in a private office in Bar and once a week at a beauty salon in Budva. In Herceg Novi, there is a dermatovenerologist (@dermatologvenerolog). When choosing a specialist, it is recommended to verify that they hold a medical license for practice in Montenegro.', 'В Черногории удалением кожных образований (папиллом, родинок и т.д.) с помощью коагулятора занимаются несколько специалистов. В Баре и Будве принимает дерматолог Яна Соловцова (@yanasolovtsova) — работает в частном кабинете в Баре и раз в неделю в салоне красоты в Будве. В Херцег-Нови есть дерматолог-венеролог (@dermatologvenerolog). При выборе специалиста рекомендуется уточнять наличие лицензии на медицинскую деятельность в Черногории.', 'In Montenegro befassen sich mehrere Spezialisten mit der Entfernung von Hautveränderungen (Papillome, Muttermale usw.) mittels Koagulator. In Bar und Budva praktiziert die Dermatologin Yana Solovtsova (@yanasolovtsova) — sie arbeitet in einer Privatpraxis in Bar und einmal pro Woche in einem Kosmetiksalon in Budva. In Herceg Novi gibt es einen Dermatovenerologen (@dermatologvenerolog). Bei der Wahl eines Spezialisten wird empfohlen, das Vorhandensein einer Lizenz für medizinische Tätigkeit in Montenegro zu überprüfen.', 'Karadağ\'da birkaç uzman koagülatör kullanarak cilt oluşumlarının (papillom, ben vb.) alınmasıyla ilgilenmektedir. Bar ve Budva\'da dermatolog Yana Solovtsova (@yanasolovtsova) hasta kabul etmektedir — Bar\'da özel muayenehanesinde ve haftada bir Budva\'daki bir güzellik salonunda çalışmaktadır. Herceg Novi\'de bir dermatovenerolog (@dermatologvenerolog) bulunmaktadır. Uzman seçerken, Karadağ\'da tıbbi faaliyet lisansının olup olmadığını kontrol etmeniz tavsiye edilir.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya' AND tg.slug = 'dermatologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya' AND tg.slug = 'city:bar';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya' AND tg.slug = 'city:herceg-novi';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108427';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108428';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108429';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108430';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108431';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108432';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108433';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108434';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108435';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-v-chernogorii-udalit-papillomy-i-drugie-kozhnye-obrazovaniya'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108436';

-- qa-006: Есть ли русскоязычный невролог в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('est-li-russkoyazychnyj-nevrolog-v-chernogorii', 'draft',
  'Da li u Crnoj Gori postoji neurolog koji govori ruski?', 'Да ли у Црној Гори постоји неуролог који говори руски?', 'Is there a Russian-speaking neurologist in Montenegro?', 'Есть ли русскоязычный невролог в Черногории?', 'Gibt es einen russischsprachigen Neurologen in Montenegro?', 'Karadağ\'da Rusça konuşan bir nörolog var mı?',
  'Da, u Crnoj Gori praktikuje neurolog Ольга Ваганова — lekar opšte prakse i neurolog sa licencom za medicinsku delatnost u Crnoj Gori. Specijalizovana je za sve oblasti neurologije, uključujući složene slučajeve. Nudi onlajn praćenje tokom perioda lečenja ili dijagnostike, kao i individualni izbor vežbi za bolne sindrome. Dostupna je i kućna poseta.', 'Да, у Црној Гори практикује неуролог Ольга Ваганова — лекар опште праксе и неуролог са лиценцом за медицинску делатност у Црној Гори. Специјализована је за све области неурологије, укључујући сложене случајеве. Нуди онлајн праћење током периода лечења или дијагностике, као и индивидуални избор вежби за болне синдроме. Доступна је и кућна посета.', 'Yes, neurologist Ольга Ваганова practices in Montenegro — she is a general practitioner and neurologist licensed to practice medicine in Montenegro. She specializes in all areas of neurology, including complex cases. She offers online support during treatment or diagnostic periods, as well as personalized exercise programs for pain syndromes. Home visits are available.', 'Да, в Черногории практикует невролог Ольга Ваганова — врач общей практики и невролог с лицензией на медицинскую деятельность в Черногории. Специализируется на всех направлениях неврологии, включая сложные случаи. Предлагает онлайн-сопровождение на период лечения или диагностики, а также индивидуальный подбор упражнений при болевых синдромах. Доступен выезд на дом.', 'Ja, in Montenegro praktiziert die Neurologin Ольга Ваганова — Allgemeinmedizinerin und Neurologin mit einer Lizenz für medizinische Tätigkeit in Montenegro. Sie ist auf alle Bereiche der Neurologie spezialisiert, einschließlich komplexer Fälle. Sie bietet Online-Begleitung während der Behandlungs- oder Diagnostikphase sowie individuell ausgewählte Übungen bei Schmerzsyndromen an. Hausbesuche sind möglich.', 'Evet, Karadağ\'da nörolog Ольга Ваганова çalışmaktadır — Karadağ\'da tıbbi faaliyet lisansına sahip genel pratisyen hekim ve nörolog. Karmaşık vakalar dahil nörolojinin tüm alanlarında uzmanlaşmıştır. Tedavi veya teşhis sürecinde çevrimiçi takip ile ağrı sendromları için bireysel egzersiz programları sunmaktadır. Eve ziyaret hizmeti mevcuttur.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'est-li-russkoyazychnyj-nevrolog-v-chernogorii' AND tg.slug = 'nevrologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'est-li-russkoyazychnyj-nevrolog-v-chernogorii' AND tg.slug = 'topic:vyzov-na-dom';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'est-li-russkoyazychnyj-nevrolog-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108895';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'est-li-russkoyazychnyj-nevrolog-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108896';

-- qa-007: Где найти гастроэнтеролога и сделать ФГДС (гастроскопию) в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii', 'draft',
  'Gde pronaći gastroenterologa i uraditi EGDS (gastroskopiju) u Crnoj Gori?', 'Где пронаћи гастроентеролога и урадити ЕГДС (гастроскопију) у Црној Гори?', 'Where can I find a gastroenterologist and get an upper endoscopy (gastroscopy) in Montenegro?', 'Где найти гастроэнтеролога и сделать ФГДС (гастроскопию) в Черногории?', 'Wo finde ich einen Gastroenterologen und kann eine Ösophagogastroduodenoskopie (Gastroskopie) in Montenegro durchführen lassen?', 'Karadağ\'da gastroenterolog nerede bulunur ve üst gastrointestinal endoskopi (gastroskopi) nerede yaptırılır?',
  'Gastroenterolozi primaju u nekoliko gradova Crne Gore. U Tivtu postoji specijalista (preporučuje se proveriti kontakte putem medicinskih četova). Prilikom traženja gastroenterologa koji govori ruski, treba imati u vidu da ih nema mnogo — češće su dostupni crnogorski specijalisti sa mogućnošću pratnje na ruskom u većim klinikama. EGDS (gastroskopija) je dostupna u nekoliko privatnih klinika. Prilikom obraćanja navedite grad, jer su specijalisti raspoređeni po različitim naseljima.', 'Гастроентеролози примају у неколико градова Црне Горе. У Тивту постоји специјалиста (препоручује се проверити контакте путем медицинских четова). Приликом тражења гастроентеролога који говори руски, треба имати у виду да их нема много — чешће су доступни црногорски специјалисти са могућношћу пратње на руском у већим клиникама. ЕГДС (гастроскопија) је доступна у неколико приватних клиника. Приликом обраћања наведите град, јер су специјалисти распоређени по различитим насељима.', 'Gastroenterologists practice in several cities in Montenegro. There is a specialist in Tivat (it is recommended to verify contact details through medical chat groups). When looking for a Russian-speaking gastroenterologist, keep in mind that there are few — Montenegrin specialists with Russian-language support at larger clinics are more commonly available. Upper endoscopy (gastroscopy) is available at several private clinics. When making an appointment, specify your city, as specialists are distributed across different locations.', 'Гастроэнтерологи принимают в нескольких городах Черногории. В Тивате есть специалист (рекомендуется уточнить контакты через медицинские чаты). При поиске русскоговорящего гастроэнтеролога стоит учитывать, что их немного — чаще доступны черногорские специалисты с возможностью сопровождения на русском в крупных клиниках. ФГДС (гастроскопия) доступна в нескольких частных клиниках. При обращении уточняйте город, так как специалисты распределены по разным населённым пунктам.', 'Gastroenterologen praktizieren in mehreren Städten Montenegros. In Tivat gibt es einen Spezialisten (es wird empfohlen, die Kontaktdaten über medizinische Chatgruppen zu überprüfen). Bei der Suche nach einem russischsprachigen Gastroenterologen sollte man bedenken, dass es nur wenige gibt — häufiger stehen montenegrinische Spezialisten mit russischsprachiger Begleitung in größeren Kliniken zur Verfügung. Die Ösophagogastroduodenoskopie (Gastroskopie) ist in mehreren Privatkliniken verfügbar. Geben Sie bei der Terminvereinbarung Ihre Stadt an, da die Spezialisten auf verschiedene Orte verteilt sind.', 'Gastroenterologlar Karadağ\'ın birkaç şehrinde hasta kabul etmektedir. Tivat\'ta bir uzman bulunmaktadır (iletişim bilgilerini tıbbi sohbet grupları aracılığıyla doğrulamanız önerilir). Rusça konuşan gastroenterolog ararken, sayılarının az olduğunu göz önünde bulundurun — daha büyük kliniklerde Rusça eşlik desteği sunan Karadağlı uzmanlar daha yaygın olarak mevcuttur. Üst gastrointestinal endoskopi (gastroskopi) birkaç özel klinikte yapılabilmektedir. Randevu alırken şehrinizi belirtin, çünkü uzmanlar farklı yerleşim yerlerinde dağılmıştır.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii' AND tg.slug = 'topic:gastroenterologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii' AND tg.slug = 'city:tivat';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107798';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107799';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107975';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107976';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107977';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108238';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-gastroenterologa-i-sdelat-fgds-gastroskopiyu-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108239';

-- qa-008: Где найти уролога и пройти обследование почек в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii', 'draft',
  'Gde pronaći urologa i obaviti pregled bubrega u Crnoj Gori?', 'Где пронаћи уролога и обавити преглед бубрега у Црној Гори?', 'Where can I find a urologist and get a kidney examination in Montenegro?', 'Где найти уролога и пройти обследование почек в Черногории?', 'Wo finde ich einen Urologen und kann eine Nierenuntersuchung in Montenegro durchführen lassen?', 'Karadağ\'da ürolog nerede bulunur ve böbrek muayenesi nerede yaptırılır?',
  'U Crnoj Gori radi urolog koji govori ruski — Дмитрий Дылинов (@Dmitriydylinov) — prima u klinici A3 Medical (Sutomore). Njemu se možete obratiti za pregled bubrega, uključujući upućivanje na renoscintigrafiju. Ekstrakorporalna litotripsija udarnim talasima (ESWL) obavlja se u Kliničkom centru Crne Gore (Podgorica) — radi se o litotripsiji udarnim talasima, ne ultrazvučnoj.', 'У Црној Гори ради уролог који говори руски — Дмитрий Дылинов (@Dmitriydylinov) — прима у клиници A3 Medical (Sutomore). Њему се можете обратити за преглед бубрега, укључујући упућивање на реносцинтиграфију. Екстракорпорална литотрипсија ударним таласима (ESWL) обавља се у Клиничком центру Црне Горе (Подгорица) — ради се о литотрипсији ударним таласима, не ултразвучној.', 'In Montenegro, the Russian-speaking urologist Дмитрий Дылинов (@Dmitriydylinov) practices at A3 Medical clinic (Sutomore). You can consult him regarding kidney examinations, including referrals for renal scintigraphy. Extracorporeal shock wave lithotripsy (ESWL) for kidney stones is performed at the Clinical Center of Montenegro (Podgorica) — this is shock wave lithotripsy, not ultrasound-based.', 'В Черногории работает русскоязычный уролог Дмитрий Дылинов (@Dmitriydylinov) — принимает в клинике A3 Medical (Сутоморе). К нему можно обратиться по вопросам обследования почек, в том числе для назначения реносцинтиграфии. Дистанционное дробление камней в почках (литотрипсия) проводится в Клиническом центре Черногории (Подгорица) — это ударно-волновое дробление, не ультразвуковое.', 'In Montenegro praktiziert der russischsprachige Urologe Дмитрий Дылинов (@Dmitriydylinov) — er empfängt Patienten in der Klinik A3 Medical (Sutomore). An ihn können Sie sich bei Fragen zur Nierenuntersuchung wenden, einschließlich der Überweisung zur Nierenszintigraphie. Die extrakorporale Stoßwellenlithotripsie (ESWL) bei Nierensteinen wird im Klinischen Zentrum Montenegros (Podgorica) durchgeführt — es handelt sich um Stoßwellenlithotripsie, nicht um Ultraschall.', 'Karadağ\'da Rusça konuşan ürolog Дмитрий Дылинов (@Dmitriydylinov) A3 Medical kliniğinde (Sutomore) hasta kabul etmektedir. Böbrek muayenesi konusunda, renal sintigrafi sevki dahil, kendisine başvurabilirsiniz. Böbrek taşları için vücut dışı şok dalga litotripsi (ESWL) Karadağ Klinik Merkezinde (Podgorica) yapılmaktadır — bu ultrason değil, şok dalga litotripsidir.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii' AND tg.slug = 'urologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii' AND tg.slug = 'city:bar';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii' AND tg.slug = 'city:podgorica';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 15 FROM kb_threads t WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108588';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108589';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108597';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108598';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108829';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108830';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-urologa-i-projti-obsledovanie-pochek-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108831';

-- qa-009: Где найти офтальмолога (окулиста) в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-oftal-mologa-okulista-v-chernogorii', 'draft',
  'Gde pronaći oftalmologa (okulista) u Crnoj Gori?', 'Где пронаћи офталмолога (окулисту) у Црној Гори?', 'Where can I find an ophthalmologist (eye doctor) in Montenegro?', 'Где найти офтальмолога (окулиста) в Черногории?', 'Wo finde ich einen Augenarzt (Ophthalmologen) in Montenegro?', 'Karadağ\'da göz doktoru (oftalmolog) nerede bulunur?',
  'U Baru prima oftalmolog koji govori ruski — Василий Евгеньевич Яковлев (zakazivanje putem @YakovlevBarBot). U Budvi radi oftalmološka klinika Svjetlost Eye Clinic. Prilikom izbora specijaliste važno je proveriti da li raspolažu potrebnom opremom za vaš pregled. Takođe, možete zatražiti uput u dom zdravlja za pregled kod državnog oftalmologa.', 'У Бару прима офталмолог који говори руски — Василий Евгеньевич Яковлев (заказивање путем @YakovlevBarBot). У Будви ради офталмолошка клиника Svjetlost Eye Clinic. Приликом избора специјалисте важно је проверити да ли располажу потребном опремом за ваш преглед. Такође, можете затражити упут у дом здравља за преглед код државног офталмолога.', 'In Bar, the Russian-speaking ophthalmologist Василий Евгеньевич Яковлев sees patients (book via @YakovlevBarBot). In Budva, the Svjetlost Eye Clinic is available. When choosing a specialist, it is important to verify that they have the necessary equipment for your examination. You can also request a referral from a dom zdravlja (public health center) for an appointment with a state ophthalmologist.', 'В Баре принимает русскоговорящий офтальмолог Василий Евгеньевич Яковлев (запись через @YakovlevBarBot). В Будве работает офтальмологическая клиника Svjetlost Eye Clinic. При выборе специалиста важно уточнить наличие необходимого оборудования для вашего обследования. Также можно обратиться за направлением в дом здравља для приёма у государственного офтальмолога.', 'In Bar empfängt der russischsprachige Augenarzt Василий Евгеньевич Яковлев Patienten (Terminbuchung über @YakovlevBarBot). In Budva ist die Augenklinik Svjetlost Eye Clinic tätig. Bei der Wahl eines Spezialisten ist es wichtig zu klären, ob die erforderliche Ausrüstung für Ihre Untersuchung vorhanden ist. Sie können auch eine Überweisung im Dom zdravlja (öffentliches Gesundheitszentrum) für einen Termin beim staatlichen Augenarzt beantragen.', 'Bar\'da Rusça konuşan göz doktoru Василий Евгеньевич Яковлев hasta kabul etmektedir (randevu @YakovlevBarBot üzerinden). Budva\'da Svjetlost Eye Clinic göz kliniği bulunmaktadır. Uzman seçerken, muayeneniz için gerekli ekipmanın mevcut olup olmadığını doğrulamanız önemlidir. Ayrıca devlet oftalmologunda muayene için dom zdravlja\'dan (kamu sağlık merkezi) sevk talebinde bulunabilirsiniz.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii' AND tg.slug = 'oftalmologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii' AND tg.slug = 'city:bar';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 26 FROM kb_threads t WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '109013';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '109014';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108049';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108050';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108051';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108052';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-oftal-mologa-okulista-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108053';

-- qa-010: Где найти психотерапевта или психиатра в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii', 'draft',
  'Gde pronaći psihoterapeuta ili psihijatra u Crnoj Gori?', 'Где пронаћи психотерапеута или психијатра у Црној Гори?', 'Where can I find a psychotherapist or psychiatrist in Montenegro?', 'Где найти психотерапевта или психиатра в Черногории?', 'Wo finde ich einen Psychotherapeuten oder Psychiater in Montenegro?', 'Karadağ\'da psikoterapist veya psikiyatrist nerede bulunur?',
  'U Crnoj Gori postoji nekoliko opcija. Državni psihijatar prima u domu zdravlja u Budvi — prijem je otprilike od 9:00 do 14:00 (preporučuje se proveriti raspored). Od privatnih specijalista: u Budvi prima psihoterapeut Инна Жохова, koja vlada metodom EMDR (desenzitizacija i reprocesiranje pokretima očiju) i drugim pristupima. Za pronalaženje porodičnog psihologa sa ličnim prijemom u Budvi i okolini, preporučuje se proveriti dostupnost aktuelnih specijalista putem medicinskih zajednica.', 'У Црној Гори постоји неколико опција. Државни психијатар прима у дому здравља у Будви — пријем је отприлике од 9:00 до 14:00 (препоручује се проверити распоред). Од приватних специјалиста: у Будви прима психотерапеут Инна Жохова, која влада методом EMDR (десензитизација и репроцесирање покретима очију) и другим приступима. За проналажење породичног психолога са личним пријемом у Будви и околини, препоручује се проверити доступност актуелних специјалиста путем медицинских заједница.', 'There are several options in Montenegro. A state psychiatrist sees patients at the dom zdravlja (public health center) in Budva — appointments are approximately from 9:00 to 14:00 (it is recommended to verify the schedule). Among private specialists: psychotherapist Инна Жохова practices in Budva and is proficient in EMDR (Eye Movement Desensitization and Reprocessing) and other therapeutic approaches. To find a family psychologist offering in-person sessions in Budva and the surrounding area, it is recommended to check availability through medical communities.', 'В Черногории есть несколько вариантов. Государственный психиатр принимает в доме здравља в Будве — приём примерно с 9:00 до 14:00 (рекомендуется уточнять расписание). Из частных специалистов: в Будве принимает психотерапевт Инна Жохова, владеющая методом EMDR (ДПДГ) и другими подходами. Для поиска семейного психолога с очным приёмом в Будве и окрестностях рекомендуется уточнять наличие актуальных специалистов через медицинские сообщества.', 'In Montenegro gibt es mehrere Möglichkeiten. Ein staatlicher Psychiater empfängt Patienten im Dom zdravlja (öffentliches Gesundheitszentrum) in Budva — die Sprechzeiten sind ungefähr von 9:00 bis 14:00 Uhr (es wird empfohlen, den Zeitplan zu überprüfen). Unter den privaten Spezialisten: In Budva praktiziert die Psychotherapeutin Инна Жохова, die die EMDR-Methode (Eye Movement Desensitization and Reprocessing) und andere therapeutische Ansätze beherrscht. Für die Suche nach einem Familienpsychologen mit persönlichen Sitzungen in Budva und Umgebung wird empfohlen, die Verfügbarkeit über medizinische Gemeinschaften zu prüfen.', 'Karadağ\'da birkaç seçenek mevcuttur. Devlet psikiyatristi Budva\'daki dom zdravlja\'da (kamu sağlık merkezi) hasta kabul etmektedir — randevular yaklaşık 9:00-14:00 saatleri arasındadır (programı doğrulamanız önerilir). Özel uzmanlar arasında: Budva\'da psikoterapist Инна Жохова hasta kabul etmektedir; EMDR (Göz Hareketleriyle Duyarsızlaştırma ve Yeniden İşleme) yöntemi ve diğer terapötik yaklaşımlarda uzmandır. Budva ve çevresinde yüz yüze seans yapan bir aile psikoloğu bulmak için tıbbi topluluklar aracılığıyla güncel uzman mevcudiyetini kontrol etmeniz önerilir.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii' AND tg.slug = 'psihijatrija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108408';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108409';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108577';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108578';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108041';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-psihoterapevta-ili-psihiatra-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108042';

-- qa-011: Где найти стоматолога в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-najti-stomatologa-v-chernogorii', 'draft',
  'Gde pronaći stomatologa u Crnoj Gori?', 'Где пронаћи стоматолога у Црној Гори?', 'Where to find a dentist in Montenegro?', 'Где найти стоматолога в Черногории?', 'Wo findet man einen Zahnarzt in Montenegro?', 'Karadağ\'da diş hekimi nerede bulunur?',
  'Stomatološke klinike postoje u svim većim gradovima Crne Gore. U Podgorici radi stomatologija Temel Dental (sa podrškom na ruskom, crnogorskom, engleskom i turskom jeziku, tel: +382 67 994 255). U Baru — Pavlin Dental Clinic. Za pronalaženje stomatologa koji govori ruski u Budvi i Kotoru preporučuje se proveriti aktuelne kontakte preko medicinskih zajednica, jer se sastav specijalista redovno menja. Ukoliko je potreban dečji stomatolog u Baru, takođe se možete obratiti lokalnim klinikama.', 'Стоматолошке клинике постоје у свим већим градовима Црне Горе. У Подгорици ради стоматологија Temel Dental (са подршком на руском, црногорском, енглеском и турском језику, тел: +382 67 994 255). У Бару — Pavlin Dental Clinic. За проналажење стоматолога који говори руски у Будви и Котору препоручује се проверити актуелне контакте преко медицинских заједница, јер се састав специјалиста редовно мења. Уколико је потребан дечји стоматолог у Бару, такође се можете обратити локалним клиникама.', 'Dental clinics are available in all major cities of Montenegro. In Podgorica, Temel Dental operates with support in Russian, Montenegrin, English, and Turkish (tel: +382 67 994 255). In Bar — Pavlin Dental Clinic. To find a Russian-speaking dentist in Budva and Kotor, it is recommended to check current contacts through medical communities, as the roster of specialists changes regularly. If you need a pediatric dentist in Bar, you can also contact local clinics.', 'Стоматологические клиники есть во всех крупных городах Черногории. В Подгорице работает стоматология Temel Dental (с сопровождением на русском, черногорском, английском и турецком, тел: +382 67 994 255). В Баре — Pavlin Dental Clinic. Для поиска русскоговорящего стоматолога в Будве и Которе рекомендуется уточнять актуальные контакты через медицинские сообщества, так как состав специалистов регулярно меняется. При необходимости детского стоматолога в Баре также можно обратиться в местные клиники.', 'Zahnkliniken gibt es in allen größeren Städten Montenegros. In Podgorica arbeitet die Zahnarztpraxis Temel Dental (mit Betreuung auf Russisch, Montenegrinisch, Englisch und Türkisch, Tel.: +382 67 994 255). In Bar — Pavlin Dental Clinic. Um einen russischsprachigen Zahnarzt in Budva und Kotor zu finden, empfiehlt es sich, aktuelle Kontakte über medizinische Gemeinschaften zu erfragen, da sich die Zusammensetzung der Fachärzte regelmäßig ändert. Bei Bedarf an einem Kinderzahnarzt in Bar können Sie sich ebenfalls an örtliche Kliniken wenden.', 'Karadağ\'ın tüm büyük şehirlerinde diş klinikleri bulunmaktadır. Podgorica\'da Temel Dental kliniği Rusça, Karadağca, İngilizce ve Türkçe destek ile hizmet vermektedir (tel: +382 67 994 255). Bar\'da — Pavlin Dental Clinic. Budva ve Kotor\'da Rusça konuşan bir diş hekimi bulmak için, uzman kadrosu düzenli olarak değiştiğinden, güncel iletişim bilgilerini tıbbi topluluklar aracılığıyla kontrol etmeniz önerilir. Bar\'da çocuk diş hekimine ihtiyaç duyulması halinde de yerel kliniklere başvurabilirsiniz.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii' AND tg.slug = 'stomatologija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii' AND tg.slug = 'city:podgorica';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii' AND tg.slug = 'city:bar';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii' AND tg.slug = 'city:kotor';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii' AND tg.slug = 'topic:lechenie-zubov';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 19 FROM kb_threads t WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 20 FROM kb_threads t WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108102';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108103';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107891';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107892';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107893';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '109055';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-najti-stomatologa-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '109056';

-- qa-012: Какие лекарства можно купить в аптеках Черногории? Нужен ли рецепт?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept', 'draft',
  'Koje lekove je moguće kupiti u apotekama Crne Gore? Da li je potreban recept?', 'Које лекове је могуће купити у апотекама Црне Горе? Да ли је потребан рецепт?', 'What medications can you buy in pharmacies in Montenegro? Is a prescription required?', 'Какие лекарства можно купить в аптеках Черногории? Нужен ли рецепт?', 'Welche Medikamente kann man in Apotheken in Montenegro kaufen? Ist ein Rezept erforderlich?', 'Karadağ\'daki eczanelerde hangi ilaçlar satın alınabilir? Reçete gerekli mi?',
  'Mnogi lekovi u Crnoj Gori su dostupni bez recepta, ali neki (na primer, Monural) zahtevaju recept. Posebnosti:\n\n— Antiparazitski lekovi (Soltrik) — prodaju se bez recepta\n— Glucophage — dostupan u svakoj apoteci, originalni preparat\n— Matičnjak — prodaje se kao Odoval S (valerijana + matičnjak), pojedinačno se matičnjak zove matičnjak\n— Nurofen dečje supozitorije — ne prodaju se u Crnoj Gori\n— Monural — prodaje se isključivo na recept\n\nNazivi preparata mogu se razlikovati od uobičajenih. Ako niste pronašli potreban lek, pitajte u apoteci po aktivnoj supstanci.', 'Многи лекови у Црној Гори су доступни без рецепта, али неки (на пример, Monural) захтевају рецепт. Посебности:\n\n— Антипаразитски лекови (Soltrik) — продају се без рецепта\n— Glucophage — доступан у свакој апотеци, оригинални препарат\n— Матичњак — продаје се као Odoval S (валеријана + матичњак), појединачно се матичњак зове matičnjak\n— Nurofen дечје супозиторије — не продају се у Црној Гори\n— Monural — продаје се искључиво на рецепт\n\nНазиви препарата могу се разликовати од уобичајених. Ако нисте пронашли потребан лек, питајте у апотеци по активној супстанци.', 'Many medications in Montenegro are available without a prescription, but some (e.g., Monural) require one. Key details:\n\n— Antiparasitic drugs (Soltrik) — available without a prescription\n— Glucophage — available at any pharmacy, the original brand product\n— Lemon balm — sold as Odoval S (valerian + lemon balm); lemon balm on its own is called matičnjak\n— Nurofen children\'s suppositories — not sold in Montenegro\n— Monural — available strictly by prescription only\n\nMedication names may differ from what you are used to. If you cannot find the medication you need, ask the pharmacist using the active ingredient name.', 'Многие лекарства в Черногории доступны без рецепта, но некоторые (например, Монурал) требуют рецепт. Особенности:\n\n— Противопаразитарные (Солтрик / Soltrik) — продаются без рецепта\n— Глюкофаж — есть в любой аптеке, именно оригинальный препарат\n— Мелисса — продаётся как Odoval S (валериана + мелисса), отдельно мелисса называется matičnjak\n— Детские свечи Нурофен — в Черногории не продаются\n— Монурал — продаётся строго по рецепту\n\nНазвания препаратов могут отличаться от привычных. Если не нашли нужное лекарство, спросите в аптеке по действующему веществу.', 'Viele Medikamente sind in Montenegro rezeptfrei erhältlich, einige (z. B. Monural) erfordern jedoch ein Rezept. Besonderheiten:\n\n— Antiparasitäre Mittel (Soltrik) — rezeptfrei erhältlich\n— Glucophage — in jeder Apotheke erhältlich, das Originalpräparat\n— Melisse — wird als Odoval S (Baldrian + Melisse) verkauft; einzeln heißt Melisse matičnjak\n— Nurofen Kinderzäpfchen — werden in Montenegro nicht verkauft\n— Monural — ausschließlich auf Rezept erhältlich\n\nMedikamentennamen können von den gewohnten abweichen. Wenn Sie das benötigte Medikament nicht finden, fragen Sie in der Apotheke nach dem Wirkstoff.', 'Karadağ\'da birçok ilaç reçetesiz satılmaktadır, ancak bazıları (örneğin Monural) reçete gerektirir. Önemli noktalar:\n\n— Antiparaziter ilaçlar (Soltrik) — reçetesiz satılır\n— Glucophage — her eczanede bulunur, orijinal preparat\n— Melisa otu — Odoval S (kediotu + melisa) olarak satılır; tek başına melisa matičnjak olarak adlandırılır\n— Nurofen çocuk fitilleri — Karadağ\'da satılmamaktadır\n— Monural — yalnızca reçete ile satılır\n\nİlaç isimleri alışık olduklarınızdan farklı olabilir. Aradığınız ilacı bulamıyorsanız, eczanede etken madde adıyla sorun.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept' AND tg.slug = 'topic:apteka';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107805';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107806';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107807';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108302';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108303';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108466';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108467';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '109024';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kakie-lekarstva-mozhno-kupit-v-aptekah-chernogorii-nuzhen-li-recept'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '109025';

-- qa-013: Где сдать анализы крови в Черногории и сколько это стоит?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit', 'draft',
  'Gde se mogu uraditi analize krvi u Crnoj Gori i koliko to košta?', 'Где се могу урадити анализе крви у Црној Гори и колико то кошта?', 'Where can you get blood tests done in Montenegro and how much does it cost?', 'Где сдать анализы крови в Черногории и сколько это стоит?', 'Wo kann man in Montenegro Bluttests machen lassen und wie viel kostet das?', 'Karadağ\'da kan tahlili nerede yaptırılır ve ne kadara mal olur?',
  'Analize krvi mogu se uraditi u privatnim klinikama i u državnim domovima zdravlja.\n\nU Baru: klinika Novi Standard — kompletna krvna slika 5 evra, EKG 5 evra, kompletan ultrazvuk za žene 110 evra. Takođe u A3 Medical (Sutomore) dostupni su čekap programi.\n\nU Budvi: laboratorija u domu zdravlja radi radnim danima, subotom — samo hitno po uputu lekara sa oznakom «Cito!». Privatne laboratorije primaju bez ograničenja.\n\nZa analize hormona (TSH, T3, T4 i dr.) obratite se privatnim laboratorijama — Milmedika, Moj Lab i druge rade širom zemlje.', 'Анализе крви могу се урадити у приватним клиникама и у државним домовима здравља.\n\nУ Бару: клиника Novi Standard — комплетна крвна слика 5 евра, ЕКГ 5 евра, комплетан ултразвук за жене 110 евра. Такође у A3 Medical (Сутоморе) доступни су чекап програми.\n\nУ Будви: лабораторија у дому здравља ради радним данима, суботом — само хитно по упуту лекара са ознаком «Cito!». Приватне лабораторије примају без ограничења.\n\nЗа анализе хормона (TSH, T3, T4 и др.) обратите се приватним лабораторијама — Milmedika, Moj Lab и друге раде широм земље.', 'Blood tests can be done at private clinics and at public health centers (dom zdravlja).\n\nIn Bar: Novi Standard clinic — complete blood count 5 euros, ECG 5 euros, full ultrasound for women 110 euros. A3 Medical (Sutomore) also offers check-up programs.\n\nIn Budva: the laboratory at the dom zdravlja operates on weekdays; on Saturdays — only emergencies with a doctor\'s referral marked «Cito!». Private laboratories accept patients without restrictions.\n\nFor hormone tests (TSH, T3, T4, etc.) contact private laboratories — Milmedika, Moj Lab, and others operate throughout the country.', 'Сдать анализы крови можно в частных клиниках и в государственных домах здравља.\n\nВ Баре: клиника Novi Standard — общий анализ крови 5 евро, ЭКГ 5 евро, полное УЗИ для женщин 110 евро. Также в A3 Medical (Сутоморе) доступны чек-ап программы.\n\nВ Будве: лаборатория в доме здравља работает в будни, по субботам — только экстренно по направлению врача с пометкой «Cito!». Частные лаборатории принимают без ограничений.\n\nДля анализов на гормоны (ТТГ, Т3, Т4 и др.) обращайтесь в частные лаборатории — Милмедика, Moj Lab и другие работают по всей стране.', 'Bluttests können in Privatkliniken und in staatlichen Gesundheitshäusern (dom zdravlja) durchgeführt werden.\n\nIn Bar: Klinik Novi Standard — großes Blutbild 5 Euro, EKG 5 Euro, vollständiger Ultraschall für Frauen 110 Euro. In A3 Medical (Sutomore) sind ebenfalls Check-up-Programme verfügbar.\n\nIn Budva: Das Labor im dom zdravlja arbeitet werktags; samstags — nur in Notfällen mit ärztlicher Überweisung mit dem Vermerk «Cito!». Privatlabore nehmen ohne Einschränkungen an.\n\nFür Hormonuntersuchungen (TSH, T3, T4 u. a.) wenden Sie sich an Privatlabore — Milmedika, Moj Lab und andere sind landesweit tätig.', 'Kan tahlilleri özel kliniklerde ve devlet sağlık merkezlerinde (dom zdravlja) yaptırılabilir.\n\nBar\'da: Novi Standard kliniği — tam kan sayımı 5 euro, EKG 5 euro, kadınlar için tam ultrason 110 euro. A3 Medical\'de (Sutomore) check-up programları da mevcuttur.\n\nBudva\'da: dom zdravlja\'daki laboratuvar hafta içi çalışır; cumartesi günleri — yalnızca «Cito!» notu taşıyan doktor sevki ile acil durumlar için. Özel laboratuvarlar kısıtlama olmaksızın hasta kabul eder.\n\nHormon testleri (TSH, T3, T4 vb.) için özel laboratuvarlara başvurun — Milmedika, Moj Lab ve diğerleri ülke genelinde hizmet vermektedir.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit' AND tg.slug = 'topic:analizy';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit' AND tg.slug = 'city:bar';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit' AND tg.slug = 'city:budva';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit' AND tg.slug = 'endokrinologija';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 15 FROM kb_threads t WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 4 FROM kb_threads t WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 7 FROM kb_threads t WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107786';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107787';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107788';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '107792';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108960';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108961';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108962';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdat-analizy-krovi-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108963';

-- qa-014: Где сделать КТ в Черногории и сколько это стоит?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('gde-sdelat-kt-v-chernogorii-i-skol-ko-eto-stoit', 'draft',
  'Gde se može uraditi CT u Crnoj Gori i koliko to košta?', 'Где се може урадити CT у Црној Гори и колико то кошта?', 'Where can you get a CT scan in Montenegro and how much does it cost?', 'Где сделать КТ в Черногории и сколько это стоит?', 'Wo kann man in Montenegro eine CT-Untersuchung machen lassen und wie viel kostet sie?', 'Karadağ\'da BT (bilgisayarlı tomografi) nerede çekilir ve ne kadara mal olur?',
  'Kompjuterizovana tomografija (CT) radi se u nekoliko privatnih klinika. Približne cene u klinici Konzilijum:\n\n— CT kostiju lica — 115 evra\n— CT mozga sa kostima lica — 165 evra\n— CT temporalne kosti — 115 evra\n\nCenovnici u lokalnim klinikama retko su javno dostupni — preporučuje se da pozovete i unapred proverite cenu.', 'Компјутеризована томографија (CT) ради се у неколико приватних клиника. Приближне цене у клиници Конзилијум:\n\n— CT костију лица — 115 евра\n— CT мозга са костима лица — 165 евра\n— CT темпоралне кости — 115 евра\n\nЦеновници у локалним клиникама ретко су јавно доступни — препоручује се да позовете и унапред проверите цену.', 'CT scans (computed tomography) are performed at several private clinics. Approximate prices at the Konzilijum clinic:\n\n— CT of facial bones (CT kostiju lica) — 115 euros\n— CT of the brain with facial bones (CT mozga sa kostima lica) — 165 euros\n— CT of the temporal bone (CT temporalne kosti) — 115 euros\n\nPrice lists at local clinics are rarely publicly available — it is recommended to call and confirm the cost in advance.', 'Компьютерную томографию (КТ) делают в нескольких частных клиниках. Примерные цены в клинике Конзилиум:\n\n— КТ костей лица (CT kostiju lica) — 115 евро\n— КТ мозга с костями лица (CT mozga sa kostima lica) — 165 евро\n— КТ височной кости (CT temporalne kosti) — 115 евро\n\nПрейскуранты в местных клиниках редко доступны в открытом виде — рекомендуется звонить и уточнять стоимость заранее.', 'Computertomographie (CT) wird in mehreren Privatkliniken durchgeführt. Ungefähre Preise in der Klinik Konzilijum:\n\n— CT der Gesichtsknochen (CT kostiju lica) — 115 Euro\n— CT des Gehirns mit Gesichtsknochen (CT mozga sa kostima lica) — 165 Euro\n— CT des Schläfenbeins (CT temporalne kosti) — 115 Euro\n\nPreislisten der örtlichen Kliniken sind selten öffentlich zugänglich — es wird empfohlen, vorher anzurufen und die Kosten zu erfragen.', 'Bilgisayarlı tomografi (BT) birkaç özel klinikte yapılmaktadır. Konzilijum kliniğindeki yaklaşık fiyatlar:\n\n— Yüz kemikleri BT\'si (CT kostiju lica) — 115 euro\n— Yüz kemikleri ile birlikte beyin BT\'si (CT mozga sa kostima lica) — 165 euro\n— Temporal kemik BT\'si (CT temporalne kosti) — 115 euro\n\nYerel kliniklerin fiyat listeleri nadiren kamuya açıktır — önceden arayıp maliyeti öğrenmeniz tavsiye edilir.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-sdelat-kt-v-chernogorii-i-skol-ko-eto-stoit' AND tg.slug = 'topic:rentgen';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'gde-sdelat-kt-v-chernogorii-i-skol-ko-eto-stoit' AND tg.slug = 'topic:ceny';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdelat-kt-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108951';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdelat-kt-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108952';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'gde-sdelat-kt-v-chernogorii-i-skol-ko-eto-stoit'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108953';

-- qa-015: Как получить медицинские документы на английском языке с апостилем в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii', 'draft',
  'Kako dobiti medicinsku dokumentaciju na engleskom jeziku sa apostilom u Crnoj Gori?', 'Како добити медицинску документацију на енглеском језику са апостилом у Црној Гори?', 'How to obtain medical documents in English with an apostille in Montenegro?', 'Как получить медицинские документы на английском языке с апостилем в Черногории?', 'Wie erhält man medizinische Dokumente auf Englisch mit Apostille in Montenegro?', 'Karadağ\'da apostilli İngilizce tıbbi belgeler nasıl alınır?',
  'Za dobijanje medicinskih dokumenata na engleskom sa apostilom:\n\n1. Uradite analize / pregledajte se u bilo kojoj klinici. U Milmedika i Porto Montenegro (Tivat) mogu izdati rezultate na engleskom na zahtev.\n2. Ako su dokumenti na crnogorskom — naručite prevod kod sudskog prevodioca (sudski prevodilac). Spiskovi prevodilaca po gradovima dostupni su putem pretrage.\n3. Overite prevod apostilom — to se radi u sudu (Osnovni sud) ili Ministarstvu pravde. Apostil potvrđuje legalnost dokumenta i prevodioca.\n\nApostiliranje dokumenata je standardna procedura, nezavisno od vrste dokumenta (medicinski ili drugi).', 'За добијање медицинских докумената на енглеском са апостилом:\n\n1. Урадите анализе / прегледајте се у било којој клиници. У Milmedika и Porto Montenegro (Тиват) могу издати резултате на енглеском на захтев.\n2. Ако су документи на црногорском — наручите превод код судског преводиоца (sudski prevodilac). Спискови преводилаца по градовима доступни су путем претраге.\n3. Оверите превод апостилом — то се ради у суду (Основни суд) или Министарству правде. Апостил потврђује легалност документа и преводиоца.\n\nАпостилирање докумената је стандардна процедура, независно од врсте документа (медицински или други).', 'To obtain medical documents in English with an apostille:\n\n1. Get your tests done / have an examination at any clinic. Milmedika and Porto Montenegro (Tivat) can issue results in English upon request.\n2. If the documents are in Montenegrin — order a translation from a court-certified translator (sudski prevodilac). Lists of translators by city are available via online search.\n3. Have the translation certified with an apostille — this is done at the court (Osnovni sud) or the Ministry of Justice. The apostille confirms the legality of the document and the translator.\n\nApostille certification of documents is a standard procedure, regardless of the document type (medical or otherwise).', 'Для получения медицинских документов на английском с апостилем:\n\n1. Сдайте анализы / пройдите обследование в любой клинике. В Милмедике и Porto Montenegro (Тиват) могут выдать результаты на английском по запросу.\n2. Если документы на черногорском — закажите перевод у судебного переводчика (sudski prevodilac). Списки переводчиков по городам доступны через поиск.\n3. Заверьте перевод апостилем — это делается в суде (Основни суд) или Министерстве юстиции. Апостиль подтверждает легальность документа и переводчика.\n\nАпостилирование документов — стандартная процедура, не зависящая от типа документа (медицинский или иной).', 'Um medizinische Dokumente auf Englisch mit Apostille zu erhalten:\n\n1. Lassen Sie Ihre Tests durchführen / eine Untersuchung in einer beliebigen Klinik. Bei Milmedika und Porto Montenegro (Tivat) können die Ergebnisse auf Anfrage auf Englisch ausgestellt werden.\n2. Wenn die Dokumente auf Montenegrinisch sind — beauftragen Sie eine Übersetzung bei einem vereidigten Übersetzer (sudski prevodilac). Listen der Übersetzer nach Städten sind über die Suche verfügbar.\n3. Lassen Sie die Übersetzung mit einer Apostille beglaubigen — dies geschieht beim Gericht (Osnovni sud) oder beim Justizministerium. Die Apostille bestätigt die Rechtmäßigkeit des Dokuments und des Übersetzers.\n\nDie Apostillierung von Dokumenten ist ein Standardverfahren, unabhängig von der Art des Dokuments (medizinisch oder anderweitig).', 'Apostilli İngilizce tıbbi belgeler almak için:\n\n1. Herhangi bir klinikte tahlillerinizi yaptırın / muayene olun. Milmedika ve Porto Montenegro (Tivat) talep üzerine sonuçları İngilizce düzenleyebilir.\n2. Belgeler Karadağca ise — yeminli tercümandan (sudski prevodilac) çeviri yaptırın. Şehirlere göre tercüman listeleri çevrimiçi arama yoluyla bulunabilir.\n3. Çeviriyi apostil ile onaylatın — bu işlem mahkemede (Osnovni sud) veya Adalet Bakanlığı\'nda yapılır. Apostil, belgenin ve tercümanın yasallığını doğrular.\n\nBelgelerin apostillenmesi, belge türünden (tıbbi veya diğer) bağımsız olarak standart bir prosedürdür.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii' AND tg.slug = 'topic:strahovanje';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii' AND tg.slug = 'topic:dokumenty';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 1 FROM kb_threads t WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108867';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108868';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108869';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108870';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108871';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108872';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'kak-poluchit-medicinskie-dokumenty-na-anglijskom-yazyke-s-apostilem-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108873';

-- qa-016: Сколько стоят хирургические операции в Черногории?...
INSERT INTO kb_threads (slug, status, title_sr, title_sr_cyrl, title_en, title_ru, title_de, title_tr, answer_sr, answer_sr_cyrl, answer_en, answer_ru, answer_de, answer_tr)
VALUES ('skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii', 'draft',
  'Koliko koštaju hirurške operacije u Crnoj Gori?', 'Колико коштају хируршке операције у Црној Гори?', 'How much do surgical operations cost in Montenegro?', 'Сколько стоят хирургические операции в Черногории?', 'Wie viel kosten chirurgische Eingriffe in Montenegro?', 'Karadağ\'da cerrahi operasyonlar ne kadara mal olur?',
  'Cena u velikoj meri zavisi od vrste intervencije i klinike:\n\n— Ekscizija potkožne tvorevine pod opštom anestezijom — oko 1500 evra (standardna cena za operacije pod opštom anestezijom)\n— Ekscizija pod lokalnom anestezijom — znatno jeftinije, proverite u klinici\n— Uklanjanje uraslog nokta — od 130 evra (A3 Medical, Sutomore) do 200 evra (Poliklinika Filipović, Podgorica)\n\nCene u Nikšiću (Milmedika) su obično niže nego na primorju. Preporučuje se uporediti cenovnike nekoliko klinika pre procedure.', 'Цена у великој мери зависи од врсте интервенције и клинике:\n\n— Ексцизија поткожне творевине под општом анестезијом — око 1500 евра (стандардна цена за операције под општом анестезијом)\n— Ексцизија под локалном анестезијом — знатно јефтиније, проверите у клиници\n— Уклањање урасног нокта — од 130 евра (A3 Medical, Сутоморе) до 200 евра (Poliklinika Filipović, Подгорица)\n\nЦене у Никшићу (Milmedika) су обично ниже него на приморју. Препоручује се упоредити ценовнике неколико клиника пре процедуре.', 'The cost depends heavily on the type of procedure and the clinic:\n\n— Excision of a subcutaneous mass under general anesthesia — approximately 1500 euros (standard price for operations under general anesthesia)\n— Excision under local anesthesia — significantly cheaper, check with the clinic\n— Ingrown toenail removal — from 130 euros (A3 Medical, Sutomore) to 200 euros (Poliklinika Filipović, Podgorica)\n\nPrices in Nikšić (Milmedika) are usually lower than on the coast. It is recommended to compare price lists from several clinics before the procedure.', 'Стоимость сильно зависит от типа вмешательства и клиники:\n\n— Иссечение подкожного образования под общей анестезией — около 1500 евро (стандартная цена для операций под общим наркозом)\n— Иссечение под местной анестезией — значительно дешевле, уточняйте в клинике\n— Удаление вросшего ногтя — от 130 евро (A3 Medical, Сутоморе) до 200 евро (Poliklinika Filipović, Подгорица)\n\nЦены в Никшиче (Милмедика) обычно ниже, чем на побережье. Рекомендуется сравнивать прайсы нескольких клиник перед процедурой.', 'Die Kosten hängen stark von der Art des Eingriffs und der Klinik ab:\n\n— Exzision einer subkutanen Raumforderung unter Vollnarkose — etwa 1500 Euro (Standardpreis für Operationen unter Vollnarkose)\n— Exzision unter Lokalanästhesie — deutlich günstiger, erkundigen Sie sich in der Klinik\n— Entfernung eines eingewachsenen Nagels — von 130 Euro (A3 Medical, Sutomore) bis 200 Euro (Poliklinika Filipović, Podgorica)\n\nDie Preise in Nikšić (Milmedika) sind in der Regel niedriger als an der Küste. Es empfiehlt sich, vor dem Eingriff die Preislisten mehrerer Kliniken zu vergleichen.', 'Maliyet, müdahalenin türüne ve kliniğe büyük ölçüde bağlıdır:\n\n— Genel anestezi altında cilt altı kitle eksizyonu — yaklaşık 1500 euro (genel anestezi altında yapılan operasyonlar için standart fiyat)\n— Lokal anestezi altında eksizyon — önemli ölçüde daha ucuz, kliniğe danışın\n— Batık tırnak çıkarma — 130 eurodan (A3 Medical, Sutomore) 200 euroya kadar (Poliklinika Filipović, Podgorica)\n\nNikšić\'teki (Milmedika) fiyatlar genellikle sahil bölgesinden daha düşüktür. İşlem öncesinde birkaç kliniğin fiyat listelerini karşılaştırmanız tavsiye edilir.'
)
ON DUPLICATE KEY UPDATE title_ru = VALUES(title_ru), answer_ru = VALUES(answer_ru);

INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii' AND tg.slug = 'hirurgija';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii' AND tg.slug = 'topic:ceny';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii' AND tg.slug = 'city:bar';
INSERT IGNORE INTO kb_thread_tags (thread_id, tag_id)
SELECT t.id, tg.id FROM kb_threads t, kb_tags tg WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii' AND tg.slug = 'city:podgorica';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 15 FROM kb_threads t WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 23 FROM kb_threads t WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii';
INSERT IGNORE INTO kb_entity_links (linkable_type, linkable_id, entity_type, entity_id)
SELECT 'thread', t.id, 'clinic', 2 FROM kb_threads t WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108857';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108858';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108859';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108860';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108861';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108862';
INSERT IGNORE INTO kb_thread_sources (thread_id, message_id)
SELECT t.id, m.id FROM kb_threads t, kb_messages m
WHERE t.slug = 'skol-ko-stoyat-hirurgicheskie-operacii-v-chernogorii'
AND m.source_id = (SELECT id FROM kb_sources WHERE provider = 'telegram' AND provider_source_id = '1590026293')
AND m.provider_message_id = '108863';

-- =====================================================
-- PART 6: Articles
-- =====================================================

-- =====================================================
-- PART 7: Validation
-- =====================================================

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

SELECT "kb_sources" AS `table`, COUNT(*) AS cnt FROM kb_sources
UNION ALL SELECT "kb_messages", COUNT(*) FROM kb_messages
UNION ALL SELECT "kb_tags", COUNT(*) FROM kb_tags
UNION ALL SELECT "kb_threads", COUNT(*) FROM kb_threads
UNION ALL SELECT "kb_articles", COUNT(*) FROM kb_articles
UNION ALL SELECT "kb_entity_links", COUNT(*) FROM kb_entity_links;
