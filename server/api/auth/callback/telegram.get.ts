import { getOAuthConfig } from '~/server/utils/oauth-config';
import {
	verifyTelegramAuth,
	type TelegramAuthData,
} from '~/server/utils/telegram-auth';
import {
	findUserByOAuth,
	createOAuthUser,
	linkOAuthAccount,
} from '~/server/utils/oauth';
import {
	getOAuthAccountId,
	saveTelegramProfile,
	setPrimaryOAuthProvider,
} from '~/server/utils/oauth-profiles';
import {
	createSession,
	setSessionCookie,
	getUserFromSession,
} from '~/server/utils/session';
import { executeQuery } from '~/server/common/db-mysql';
import { authLogger, logError } from '~/server/utils/logger';
import { logSuccessfulLogin } from '~/server/utils/login-history';
import { ERROR_CODES } from '~/server/utils/api-codes';

// Вспомогательная функция для очистки undefined строк
function cleanValue(value: unknown): string | undefined {
	if (
		value === undefined ||
		value === null ||
		value === 'undefined' ||
		value === ''
	) {
		return undefined;
	}
	return String(value);
}

export default defineEventHandler(async (event) => {
	const query = getQuery(event);

	// Получаем данные от Telegram (фильтруем "undefined" строки)
	const telegramData: TelegramAuthData = {
		id: Number(query.id),
		first_name: query.first_name as string,
		last_name: cleanValue(query.last_name),
		username: cleanValue(query.username),
		photo_url: cleanValue(query.photo_url),
		auth_date: Number(query.auth_date),
		hash: query.hash as string,
	};

	// Проверяем обязательные поля
	if (!telegramData.id || !telegramData.first_name || !telegramData.hash) {
		authLogger.error('Missing required Telegram data');
		setCookie(event, 'auth_error', ERROR_CODES.TELEGRAM_INVALID_DATA, {
			maxAge: 10,
			path: '/',
		});
		return sendRedirect(event, '/login');
	}

	try {
		const config = getOAuthConfig();
		const { telegram } = config;

		// Проверяем подлинность данных от Telegram
		const isValid = verifyTelegramAuth(telegramData, telegram.botToken);

		if (!isValid) {
			authLogger.error('Invalid Telegram authentication');
			setCookie(event, 'auth_error', ERROR_CODES.TELEGRAM_VERIFICATION_FAILED, {
				maxAge: 10,
				path: '/',
			});
			return sendRedirect(event, '/login');
		}

		// Проверяем существует ли пользователь с этим Telegram ID
		let user = await findUserByOAuth('telegram', String(telegramData.id));

		if (user) {
			// Пользователь уже существует - обновляем профиль провайдера
			const oauthAccountId = await getOAuthAccountId(user.id, 'telegram');
			if (oauthAccountId) {
				await saveTelegramProfile(oauthAccountId, {
					id: telegramData.id,
					first_name: telegramData.first_name,
					last_name: telegramData.last_name,
					username: telegramData.username,
					photo_url: telegramData.photo_url,
					auth_date: telegramData.auth_date,
				});
			}
		} else {
			// Проверяем есть ли текущая сессия (для привязки аккаунта)
			const sessionId = getCookie(event, 'session_id');
			let currentUserId: number | null = null;

			if (sessionId) {
				const currentUser = await getUserFromSession(sessionId);
				if (currentUser) {
					currentUserId = currentUser.id;
				}
			}

			if (currentUserId) {
				// Привязываем Telegram к существующему пользователю
				await linkOAuthAccount(
					currentUserId,
					'telegram',
					String(telegramData.id),
					null,
					null,
					null,
				);

				// Сохраняем полный Telegram профиль
				const oauthAccountId = await getOAuthAccountId(
					currentUserId,
					'telegram',
				);
				if (oauthAccountId) {
					await saveTelegramProfile(oauthAccountId, {
						id: telegramData.id,
						first_name: telegramData.first_name,
						last_name: telegramData.last_name,
						username: telegramData.username,
						photo_url: telegramData.photo_url,
						auth_date: telegramData.auth_date,
					});
					// Если это первый OAuth, делаем его основным
					const userResults = await executeQuery(
						'SELECT primary_oauth_provider FROM auth_users WHERE id = ?',
						[currentUserId],
					);
					if (
						userResults.length > 0 &&
						!(userResults[0] as any).primary_oauth_provider
					) {
						await setPrimaryOAuthProvider(currentUserId, 'telegram');
					}
				}

				user = { id: currentUserId };
			} else {
				// Новый пользователь - создаем (name и photo_url не ставим — берутся из профиля провайдера)
				// Telegram не предоставляет email, используем telegram_id@telegram
				const email = `telegram_${telegramData.id}@telegram.user`;

				const userId = await createOAuthUser(
					email,
					null,
					null,
					'telegram',
					String(telegramData.id),
					null,
					null,
					null,
				);

				const oauthAccountId = await getOAuthAccountId(userId, 'telegram');
				if (oauthAccountId) {
					await saveTelegramProfile(oauthAccountId, {
						id: telegramData.id,
						first_name: telegramData.first_name,
						last_name: telegramData.last_name,
						username: telegramData.username,
						photo_url: telegramData.photo_url,
						auth_date: telegramData.auth_date,
					});
					await setPrimaryOAuthProvider(userId, 'telegram');
				}

				user = { id: userId };
			}
		}

		// Создаем новую сессию
		const sessionId = await createSession(user.id);
		setSessionCookie(event, sessionId);

		await logSuccessfulLogin(user.id, event, 'telegram');

		// Проверяем есть ли сохраненный redirect URL
		const redirectTo = getCookie(event, 'auth_redirect');
		if (redirectTo && redirectTo !== '/login') {
			deleteCookie(event, 'auth_redirect');
			return sendRedirect(event, redirectTo);
		}

		// Редиректим на главную страницу
		return sendRedirect(event, '/');
	} catch (err) {
		logError(authLogger, 'Telegram callback failed', err);
		setCookie(event, 'auth_error', ERROR_CODES.TELEGRAM_AUTH_ERROR, {
			maxAge: 10,
			path: '/',
		});
		return sendRedirect(event, '/login');
	}
});
