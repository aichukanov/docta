import { getOAuthConfig } from '~/server/utils/oauth-config';
import {
	verifyTelegramAuth,
	getTelegramFullName,
	type TelegramAuthData,
} from '~/server/utils/telegram-auth';
import {
	findUserByOAuth,
	createOAuthUser,
	findUserByEmail,
	linkOAuthAccount,
} from '~/server/utils/oauth';
import { createSession, setSessionCookie } from '~/server/utils/session';

// Вспомогательная функция для очистки undefined строк
function cleanValue(value: unknown): string | undefined {
	if (value === undefined || value === null || value === 'undefined' || value === '') {
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
		console.error('Missing required Telegram data');
		setCookie(event, 'auth_error', 'Некорректные данные от Telegram', {
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
			console.error('Invalid Telegram authentication');
			setCookie(event, 'auth_error', 'Не удалось проверить данные Telegram', {
				maxAge: 10,
				path: '/',
			});
			return sendRedirect(event, '/login');
		}

		// Проверяем существует ли пользователь с этим Telegram ID
		let user = await findUserByOAuth('telegram', String(telegramData.id));

		const fullName = getTelegramFullName(telegramData);
		const photoUrl = telegramData.photo_url || null;

		if (user) {
			// Пользователь уже существует - используем его
		} else {
			// Проверяем есть ли текущая сессия (для привязки аккаунта)
			const sessionId = getCookie(event, 'session_id');
			let currentUserId: number | null = null;

			if (sessionId) {
				const { getUserFromSession } = await import(
					'~/server/utils/session'
				);
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

				user = { id: currentUserId };
			} else {
				// Новый пользователь - создаем
				// Telegram не предоставляет email, используем telegram_id@telegram
				const email = `telegram_${telegramData.id}@telegram.user`;

				const userId = await createOAuthUser(
					email,
					fullName,
					photoUrl,
					'telegram',
					String(telegramData.id),
					null,
					null,
					null,
				);

				user = {
					id: userId,
					email,
					name: fullName,
					photo_url: photoUrl,
					is_admin: false,
				};
			}
		}

		// Создаем новую сессию
		const sessionId = await createSession(user.id);
		setSessionCookie(event, sessionId);

		// Редиректим на главную страницу
		return sendRedirect(event, '/');
	} catch (err) {
		console.error('Telegram callback error:', err);
		setCookie(event, 'auth_error', 'Произошла ошибка при входе через Telegram', {
			maxAge: 10,
			path: '/',
		});
		return sendRedirect(event, '/login');
	}
});
