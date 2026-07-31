import crypto from 'node:crypto';
import { authLogger } from './logger';

/**
 * Telegram Login Widget data
 */
export interface TelegramAuthData {
	id: number;
	first_name: string;
	last_name?: string;
	username?: string;
	photo_url?: string;
	auth_date: number;
	hash: string;
}

/**
 * Проверка подлинности данных от Telegram
 * https://core.telegram.org/widgets/login#checking-authorization
 *
 * `fields` — ВСЕ полученные от Telegram поля кроме hash, в исходном строковом
 * виде. Подпись считается по ним, а не по заранее известному списку: если
 * Telegram добавит поле, оно попадёт в его hash, и фиксированный список молча
 * перестал бы сходиться.
 */
export function verifyTelegramAuth(
	fields: Record<string, string>,
	hash: string,
	botToken: string,
): boolean {
	authLogger.debug('Telegram auth data received', {
		fields: Object.keys(fields).sort(),
		has_hash: !!hash,
	});

	const dataCheckString = Object.keys(fields)
		.sort()
		.map((key) => `${key}=${fields[key]}`)
		.join('\n');

	authLogger.debug('Telegram data check string', { dataCheckString });

	// Создаем секретный ключ из bot token
	const secretKey = crypto.createHash('sha256').update(botToken).digest();

	// Вычисляем hash
	const computedHash = crypto
		.createHmac('sha256', secretKey)
		.update(dataCheckString)
		.digest('hex');

	authLogger.debug('Telegram hash comparison', {
		received: hash,
		computed: computedHash,
		match: computedHash === hash,
	});

	// Проверяем совпадение
	if (computedHash !== hash) {
		// Логируем публичную часть токена (bot_id): частая причина расхождения —
		// сервер проверяет подпись токеном не того бота, которым авторизовался
		// пользователь.
		authLogger.error('Telegram hash mismatch', {
			telegramUserId: fields.id,
			serverBotId: botToken.split(':')[0] || '(no token)',
			fields: Object.keys(fields).sort(),
		});
		return false;
	}

	// Проверяем что данные не старше 24 часов
	const authDate = Number(fields.auth_date);
	const currentTime = Math.floor(Date.now() / 1000);
	const maxAge = 86400; // 24 часа
	const age = currentTime - authDate;

	authLogger.debug('Telegram time check', {
		auth_date: authDate,
		current_time: currentTime,
		age_seconds: age,
		max_age_seconds: maxAge,
		is_valid: age <= maxAge,
	});

	if (!authDate || age > maxAge) {
		authLogger.error('Telegram data too old', {
			telegramUserId: fields.id,
			authDate: fields.auth_date,
			ageSeconds: age,
		});
		return false;
	}

	authLogger.debug('Telegram verification successful');
	return true;
}

/**
 * Получить полное имя из Telegram данных
 */
export function getTelegramFullName(data: TelegramAuthData): string {
	if (data.last_name) {
		return `${data.first_name} ${data.last_name}`;
	}
	return data.first_name;
}

/**
 * Получить username или fallback на имя
 */
export function getTelegramUsername(data: TelegramAuthData): string {
	return data.username || data.first_name.toLowerCase().replace(/\s+/g, '_');
}
