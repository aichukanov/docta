/\*\*

- Пример использования централизованной системы OAuth провайдеров
  \*/

// ============================================================================
// Импорты
// ============================================================================

import {
OAUTH_PROVIDERS,
AUTH_METHODS,
type OAuthProvider,
type AuthMethod,
isValidOAuthProvider,
isValidAuthMethod,
isValidPrimaryProvider,
getAvailableProviders,
} from '~/server/utils/oauth-providers';

// ============================================================================
// Пример 1: Валидация провайдера в API endpoint
// ============================================================================

export default defineEventHandler(async (event) => {
const provider = getRouterParam(event, 'provider');

    // ✅ ПРАВИЛЬНО: Используем функцию валидации
    if (!provider || !isValidOAuthProvider(provider)) {
    	throw createError({
    		statusCode: 400,
    		statusMessage: 'Invalid provider',
    	});
    }

    // Теперь TypeScript знает, что provider имеет тип OAuthProvider
    // provider: 'google' | 'telegram' | 'facebook'
    console.log(provider);

    // ❌ НЕПРАВИЛЬНО: Хардкодить список провайдеров
    // if (!provider || !['google', 'telegram', 'facebook'].includes(provider)) {
    //   throw createError({ statusCode: 400 });
    // }

});

// ============================================================================
// Пример 2: Валидация primary provider (может быть null)
// ============================================================================

export default defineEventHandler(async (event) => {
const body = await readBody(event);
const { provider } = body;

    // ✅ ПРАВИЛЬНО: Валидация с поддержкой null
    if (!isValidPrimaryProvider(provider)) {
    	createErrorResponse(400, ERROR_CODES.INVALID_PROVIDER);
    }

    // provider: 'google' | 'telegram' | 'facebook' | null
    await setPrimaryOAuthProvider(userId, provider);

});

// ============================================================================
// Пример 3: Типизация функций
// ============================================================================

// ✅ ПРАВИЛЬНО: Используем типы из модуля
async function logSuccessfulLogin(
userId: number,
event: H3Event,
method: AuthMethod, // 'email' | 'google' | 'telegram' | 'facebook'
): Promise<void> {
// ...
}

// ✅ ПРАВИЛЬНО: Типизация для OAuth профилей
async function setPrimaryOAuthProvider(
userId: number,
provider: OAuthProvider | null, // 'google' | 'telegram' | 'facebook' | null
): Promise<void> {
// ...
}

// ❌ НЕПРАВИЛЬНО: Хардкодить типы
// async function logSuccessfulLogin(
// userId: number,
// event: H3Event,
// method: 'email' | 'google' | 'telegram' | 'facebook', // жестко заданный тип
// ): Promise<void> {
// // ...
// }

// ============================================================================
// Пример 4: Получение списка провайдеров
// ============================================================================

// ✅ ПРАВИЛЬНО: Получаем список из константы
const providers = getAvailableProviders(); // ['google', 'telegram', 'facebook']

// Или напрямую из константы
const allProviders = OAUTH_PROVIDERS; // readonly ['google', 'telegram', 'facebook']

// Перебор всех провайдеров
for (const provider of OAUTH_PROVIDERS) {
console.log(`Processing ${provider}`);
// TypeScript знает, что provider имеет тип 'google' | 'telegram' | 'facebook'
}

// ============================================================================
// Пример 5: Проверка метода аутентификации (включая email)
// ============================================================================

async function trackAuthMethod(method: unknown) {
// ✅ ПРАВИЛЬНО: Валидация метода аутентификации
if (!isValidAuthMethod(method)) {
throw new Error('Invalid auth method');
}

    // method: 'email' | 'google' | 'telegram' | 'facebook'
    await saveAuthLog(method);

}

// ============================================================================
// Пример 6: Динамическое создание URL для OAuth
// ============================================================================

function getOAuthUrls() {
const urls: Record<OAuthProvider, string> = {} as any;

    // ✅ ПРАВИЛЬНО: Динамически создаем URL для всех провайдеров
    for (const provider of OAUTH_PROVIDERS) {
    	urls[provider] = `/api/auth/${provider}`;
    }

    return urls;
    // {
    //   google: '/api/auth/google',
    //   telegram: '/api/auth/telegram',
    //   facebook: '/api/auth/facebook'
    // }

}

// ============================================================================
// Пример 7: Conditional checks с type narrowing
// ============================================================================

function processProvider(provider: OAuthProvider) {
// TypeScript автоматически проверяет, что все провайдеры обработаны
switch (provider) {
case 'google':
return processGoogleAuth();
case 'telegram':
return processTelegramAuth();
case 'facebook':
return processFacebookAuth();
// Если добавить новый провайдер, TypeScript выдаст ошибку здесь
}
}

// ============================================================================
// Пример 8: Миграция существующего кода
// ============================================================================

// ❌ БЫЛО (старый код):
// if (provider && !['google', 'telegram'].includes(provider)) {
// throw createError({ statusCode: 400 });
// }

// ✅ СТАЛО (новый код):
import { isValidOAuthProvider } from '~/server/utils/oauth-providers';

if (!provider || !isValidOAuthProvider(provider)) {
throw createError({ statusCode: 400 });
}
