import crypto from 'node:crypto';
import { executeQuery } from '~/server/common/db-mysql';
import { authLogger } from './logger';
import {
	ERROR_CODES,
	createErrorResult,
	createValidResult,
	type ApiResult,
} from './api-codes';

const TOKEN_EXPIRATION_TIME = 3600; // 1 час в секундах

/**
 * Создать токен для изменения email
 */
export async function createEmailChangeToken(
	userId: number,
	newEmail: string,
): Promise<string> {
	const token = crypto.randomUUID();
	const expiresAt = Math.floor(Date.now() / 1000) + TOKEN_EXPIRATION_TIME;

	// Используем ту же таблицу auth_email_verification_tokens
	await executeQuery(
		`INSERT INTO auth_email_verification_tokens (user_id, email, token, expires_at, verified)
     VALUES (?, ?, ?, ?, FALSE)`,
		[userId, newEmail, token, expiresAt],
	);

	return token;
}

/**
 * Валидировать и применить изменение email
 */
export async function validateAndApplyEmailChange(
	token: string,
): Promise<ApiResult<{ userId: number; newEmail: string; oldEmail: string }>> {
	const results = await executeQuery(
		`SELECT user_id, email, expires_at, verified 
     FROM auth_email_verification_tokens 
     WHERE token = ?`,
		[token],
	);

	if (results.length === 0) {
		return createErrorResult(ERROR_CODES.TOKEN_NOT_FOUND);
	}

	const tokenData = results[0] as any;

	if (tokenData.verified) {
		return createErrorResult(ERROR_CODES.TOKEN_ALREADY_USED);
	}

	const currentTime = Math.floor(Date.now() / 1000);
	if (tokenData.expires_at < currentTime) {
		return createErrorResult(ERROR_CODES.TOKEN_EXPIRED);
	}

	const userId = tokenData.user_id;
	const newEmail = tokenData.email;

	// Получаем старый email перед изменением
	const userResults = await executeQuery(
		'SELECT email FROM auth_users WHERE id = ?',
		[userId],
	);

	if (userResults.length === 0) {
		return createErrorResult(ERROR_CODES.USER_NOT_FOUND);
	}

	const oldEmail = userResults[0].email;

	// Проверяем, не занят ли новый email
	const existingUsers = await executeQuery(
		'SELECT id FROM auth_users WHERE email = ? AND id != ?',
		[newEmail, userId],
	);

	if (existingUsers.length > 0) {
		return createErrorResult(ERROR_CODES.EMAIL_ALREADY_IN_USE);
	}

	// Обновляем email пользователя
	await executeQuery(
		'UPDATE auth_users SET email = ?, email_verified = TRUE WHERE id = ?',
		[newEmail, userId],
	);

	// Помечаем токен как использованный
	await executeQuery(
		'UPDATE auth_email_verification_tokens SET verified = TRUE WHERE token = ?',
		[token],
	);

	authLogger.info('Email changed successfully', { userId, oldEmail, newEmail });

	return createValidResult({ userId, newEmail, oldEmail });
}
