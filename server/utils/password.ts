import bcrypt from 'bcrypt';
import {
	ERROR_CODES,
	createErrorResult,
	createValidResult,
	type ApiResult,
} from './api-codes';

const SALT_ROUNDS = 10;

/**
 * Хеширование пароля с использованием bcrypt
 */
export async function hashPassword(password: string): Promise<string> {
	return await bcrypt.hash(password, SALT_ROUNDS);
}

/**
 * Проверка пароля
 */
export async function verifyPassword(
	password: string,
	hash: string,
): Promise<boolean> {
	return await bcrypt.compare(password, hash);
}

/**
 * Валидация пароля
 * Требования:
 * - Минимум 8 символов
 * - Минимум 1 цифра
 * - Минимум 1 буква
 */
export function validatePassword(password: string): ApiResult {
	const errors: ERROR_CODES[] = [];

	if (password.length < 8) {
		errors.push(ERROR_CODES.PASSWORD_TOO_SHORT);
	}

	if (!/\d/.test(password)) {
		errors.push(ERROR_CODES.PASSWORD_MISSING_DIGIT);
	}

	if (!/[a-zA-Z]/.test(password)) {
		errors.push(ERROR_CODES.PASSWORD_MISSING_LETTER);
	}

	if (errors.length > 0) {
		return createErrorResult(ERROR_CODES.INVALID_PASSWORD, errors);
	}

	return createValidResult();
}

/**
 * Валидация email
 */
export function validateEmail(email: string): boolean {
	const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	return emailRegex.test(email);
}
