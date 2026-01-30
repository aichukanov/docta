-- Проверка OAuth пользователя Google

-- 1. Проверить пользователя и его OAuth аккаунт
SELECT 
    u.id,
    u.email,
    u.name,
    u.photo_url,
    u.is_admin,
    u.password_hash,
    oa.provider,
    oa.provider_account_id,
    u.created_at
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
WHERE oa.provider = 'google';

-- 2. Проверить сессию
SELECT 
    s.id as session_id,
    s.user_id,
    u.email,
    FROM_UNIXTIME(s.expires_at) as expires_at,
    s.created_at
FROM sessions s
JOIN users u ON s.user_id = u.id
WHERE u.id IN (SELECT user_id FROM oauth_accounts WHERE provider = 'google')
ORDER BY s.created_at DESC
LIMIT 1;

-- 3. Проверить что is_admin=FALSE и password_hash=NULL
SELECT 
    id,
    email,
    is_admin,
    password_hash,
    CASE 
        WHEN is_admin = 0 THEN '✅ Правильно (не админ)'
        ELSE '❌ Ошибка! Должен быть 0'
    END as is_admin_check,
    CASE 
        WHEN password_hash IS NULL THEN '✅ Правильно (OAuth пользователь)'
        ELSE '❌ Ошибка! Должен быть NULL'
    END as password_check
FROM users
WHERE id IN (SELECT user_id FROM oauth_accounts WHERE provider = 'google');
