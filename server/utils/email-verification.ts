import crypto from 'node:crypto';
import { executeQuery } from '~/server/common/db-mysql';
import { ERROR_CODES } from './api-codes';

const TOKEN_EXPIRATION_TIME = 86400; // 24 часа в секундах

/**
 * Создать токен для подтверждения email
 */
export async function createEmailVerificationToken(
	userId: number,
	email: string,
): Promise<string> {
	const token = crypto.randomUUID();
	const expiresAt = Math.floor(Date.now() / 1000) + TOKEN_EXPIRATION_TIME;

	await executeQuery(
		`INSERT INTO auth_email_verification_tokens (user_id, email, token, expires_at, verified)
     VALUES (?, ?, ?, ?, FALSE)`,
		[userId, email, token, expiresAt],
	);

	return token;
}

/**
 * Проверить и получить токен верификации
 */
export async function validateEmailVerificationToken(token: string): Promise<{
	valid: boolean;
	userId?: number;
	email?: string;
	error?: string;
}> {
	const results = await executeQuery(
		`SELECT user_id, email, expires_at, verified 
     FROM auth_email_verification_tokens 
     WHERE token = ?`,
		[token],
	);

	if (results.length === 0) {
		return { valid: false, error: ERROR_CODES.TOKEN_NOT_FOUND };
	}

	const tokenData = results[0] as any;

	if (tokenData.verified) {
		return { valid: false, error: ERROR_CODES.EMAIL_ALREADY_VERIFIED };
	}

	const currentTime = Math.floor(Date.now() / 1000);
	if (tokenData.expires_at < currentTime) {
		return { valid: false, error: ERROR_CODES.TOKEN_EXPIRED };
	}

	return {
		valid: true,
		userId: tokenData.user_id,
		email: tokenData.email,
	};
}

/**
 * Пометить email как подтвержденный
 */
export async function markEmailAsVerified(
	userId: number,
	email: string,
): Promise<void> {
	// Обновляем пользователя
	await executeQuery(
		'UPDATE auth_users SET email_verified = TRUE WHERE id = ?',
		[userId],
	);

	// Помечаем все токены для этого email как использованные
	await executeQuery(
		'UPDATE auth_email_verification_tokens SET verified = TRUE WHERE user_id = ? AND email = ?',
		[userId, email],
	);
}

/**
 * Удалить неподтвержденные токены пользователя
 */
export async function deleteUserEmailVerificationTokens(
	userId: number,
): Promise<void> {
	await executeQuery(
		'DELETE FROM auth_email_verification_tokens WHERE user_id = ? AND verified = FALSE',
		[userId],
	);
}

/**
 * Проверить подтвержден ли email пользователя
 */
export async function isEmailVerified(userId: number): Promise<boolean> {
	const results = await executeQuery(
		'SELECT email_verified FROM auth_users WHERE id = ?',
		[userId],
	);

	if (results.length === 0) {
		return false;
	}

	return (results[0] as any).email_verified === 1;
}
