import crypto from 'crypto';

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
 * Проверка подлинности данных от Telegram Login Widget
 * https://core.telegram.org/widgets/login#checking-authorization
 */
export function verifyTelegramAuth(
	data: TelegramAuthData,
	botToken: string,
): boolean {
	const { hash, ...checkData } = data;

	console.log('[Telegram Auth] Received data:', {
		id: data.id,
		first_name: data.first_name,
		has_hash: !!hash,
		auth_date: data.auth_date,
	});

	// Создаем строку для проверки - ТОЛЬКО поля с определенными значениями
	const dataCheckString = Object.keys(checkData)
		.filter((key) => checkData[key as keyof typeof checkData] !== undefined)
		.sort()
		.map((key) => `${key}=${checkData[key as keyof typeof checkData]}`)
		.join('\n');

	console.log('[Telegram Auth] Data check string:', dataCheckString);

	// Создаем секретный ключ из bot token
	const secretKey = crypto.createHash('sha256').update(botToken).digest();

	// Вычисляем hash
	const computedHash = crypto
		.createHmac('sha256', secretKey)
		.update(dataCheckString)
		.digest('hex');

	console.log('[Telegram Auth] Hash comparison:', {
		received: hash,
		computed: computedHash,
		match: computedHash === hash,
	});

	// Проверяем совпадение
	if (computedHash !== hash) {
		console.error('[Telegram Auth] Hash mismatch!');
		return false;
	}

	// Проверяем что данные не старше 24 часов
	const authDate = data.auth_date;
	const currentTime = Math.floor(Date.now() / 1000);
	const maxAge = 86400; // 24 часа
	const age = currentTime - authDate;

	console.log('[Telegram Auth] Time check:', {
		auth_date: authDate,
		current_time: currentTime,
		age_seconds: age,
		max_age_seconds: maxAge,
		is_valid: age <= maxAge,
	});

	if (currentTime - authDate > maxAge) {
		console.error('[Telegram Auth] Data too old!');
		return false;
	}

	console.log('[Telegram Auth] ✅ Verification successful');
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
