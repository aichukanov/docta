import { executeQuery } from '~/server/common/db-mysql';
import {
	ERROR_CODES,
	createErrorResult,
	createValidResult,
	type ApiResult,
} from './api-codes';

const TOKEN_EXPIRATION_TIME = 3600; // 1 час в секундах

/**
 * Создать токен для восстановления пароля
 */
export async function createPasswordResetToken(
	userId: number,
): Promise<string> {
	const token = crypto.randomUUID();
	const expiresAt = Math.floor(Date.now() / 1000) + TOKEN_EXPIRATION_TIME;

	await executeQuery(
		`INSERT INTO auth_password_reset_tokens (user_id, token, expires_at, used)
     VALUES (?, ?, ?, FALSE)`,
		[userId, token, expiresAt],
	);

	return token;
}

/**
 * Проверить и получить токен восстановления
 */
export async function validatePasswordResetToken(
	token: string,
): Promise<ApiResult<{ userId: number }>> {
	const results = await executeQuery(
		`SELECT user_id, expires_at, used 
     FROM auth_password_reset_tokens 
     WHERE token = ?`,
		[token],
	);

	if (results.length === 0) {
		return createErrorResult(ERROR_CODES.TOKEN_NOT_FOUND);
	}

	const tokenData = results[0] as any;

	if (tokenData.used) {
		return createErrorResult(ERROR_CODES.TOKEN_ALREADY_USED);
	}

	const currentTime = Math.floor(Date.now() / 1000);
	if (tokenData.expires_at < currentTime) {
		return createErrorResult(ERROR_CODES.TOKEN_EXPIRED);
	}

	return createValidResult({ userId: tokenData.user_id });
}

/**
 * Пометить токен как использованный
 */
export async function markTokenAsUsed(token: string): Promise<void> {
	await executeQuery(
		'UPDATE auth_password_reset_tokens SET used = TRUE WHERE token = ?',
		[token],
	);
}

/**
 * Удалить все неиспользованные токены пользователя
 */
export async function deleteUserPasswordResetTokens(
	userId: number,
): Promise<void> {
	await executeQuery(
		'DELETE FROM auth_password_reset_tokens WHERE user_id = ? AND used = FALSE',
		[userId],
	);
}
