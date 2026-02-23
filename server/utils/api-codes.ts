/**
 * API Response Codes
 * Used for consistent error/success messaging across all endpoints
 */

// ===== SUCCESS CODES =====
export enum SUCCESS_CODES {
	// Auth - General
	LOGIN_SUCCESS = 'LOGIN_SUCCESS',
	LOGOUT_SUCCESS = 'LOGOUT_SUCCESS',
	REGISTRATION_SUCCESS = 'REGISTRATION_SUCCESS',

	// Password Management
	PASSWORD_CHANGED = 'PASSWORD_CHANGED',
	PASSWORD_RESET_EMAIL_SENT = 'PASSWORD_RESET_EMAIL_SENT',

	// Email Management
	EMAIL_CHANGED = 'EMAIL_CHANGED',
	EMAIL_VERIFIED = 'EMAIL_VERIFIED',
	EMAIL_CHANGE_CONFIRMATION_SENT = 'EMAIL_CHANGE_CONFIRMATION_SENT',
	VERIFICATION_EMAIL_SENT = 'VERIFICATION_EMAIL_SENT',

	// Profile
	NAME_UPDATED = 'NAME_UPDATED',
	PRIMARY_PROVIDER_UPDATED = 'PRIMARY_PROVIDER_UPDATED',
	LOCALE_UPDATED = 'LOCALE_UPDATED',

	// Session Management
	SESSION_DELETED = 'SESSION_DELETED',
	ALL_SESSIONS_DELETED = 'ALL_SESSIONS_DELETED',

	// OAuth
	ACCOUNT_LINKED = 'ACCOUNT_LINKED',
	ACCOUNT_UNLINKED = 'ACCOUNT_UNLINKED',
}

// ===== ERROR CODES =====
export enum ERROR_CODES {
	// Auth / OAuth Errors
	UNAUTHORIZED = 'UNAUTHORIZED',
	INVALID_CREDENTIALS = 'INVALID_CREDENTIALS',
	OAUTH_FAILED = 'OAUTH_FAILED',
	NO_CODE = 'NO_CODE',
	STATE_MISMATCH = 'STATE_MISMATCH',
	EMAIL_NOT_VERIFIED = 'EMAIL_NOT_VERIFIED',
	EMAIL_NOT_PROVIDED = 'EMAIL_NOT_PROVIDED',
	OAUTH_CALLBACK_FAILED = 'OAUTH_CALLBACK_FAILED',
	TELEGRAM_INVALID_DATA = 'TELEGRAM_INVALID_DATA',
	TELEGRAM_VERIFICATION_FAILED = 'TELEGRAM_VERIFICATION_FAILED',
	TELEGRAM_AUTH_ERROR = 'TELEGRAM_AUTH_ERROR',

	// Validation Errors
	INVALID_EMAIL = 'INVALID_EMAIL',
	INVALID_PASSWORD = 'INVALID_PASSWORD',
	INVALID_LOCALE = 'INVALID_LOCALE',
	EMAIL_REQUIRED = 'EMAIL_REQUIRED',
	PASSWORD_REQUIRED = 'PASSWORD_REQUIRED',
	NAME_REQUIRED = 'NAME_REQUIRED',
	LOCALE_REQUIRED = 'LOCALE_REQUIRED',
	ALL_FIELDS_REQUIRED = 'ALL_FIELDS_REQUIRED',
	PASSWORDS_DO_NOT_MATCH = 'PASSWORDS_DO_NOT_MATCH',
	NAME_TOO_LONG = 'NAME_TOO_LONG',
	NAME_EMPTY = 'NAME_EMPTY',
	CURRENT_PASSWORD_REQUIRED = 'CURRENT_PASSWORD_REQUIRED',
	NEW_PASSWORD_REQUIRED = 'NEW_PASSWORD_REQUIRED',
	PASSWORD_TOO_SHORT = 'PASSWORD_TOO_SHORT',
	PASSWORD_MISSING_DIGIT = 'PASSWORD_MISSING_DIGIT',
	PASSWORD_MISSING_LETTER = 'PASSWORD_MISSING_LETTER',

	// User Errors
	USER_NOT_FOUND = 'USER_NOT_FOUND',
	USER_ALREADY_EXISTS = 'USER_ALREADY_EXISTS',
	EMAIL_ALREADY_IN_USE = 'EMAIL_ALREADY_IN_USE',
	EMAIL_SAME_AS_CURRENT = 'EMAIL_SAME_AS_CURRENT',
	INVALID_CURRENT_PASSWORD = 'INVALID_CURRENT_PASSWORD',

	// Token Errors
	TOKEN_NOT_FOUND = 'TOKEN_NOT_FOUND',
	INVALID_TOKEN = 'INVALID_TOKEN',
	TOKEN_EXPIRED = 'TOKEN_EXPIRED',
	TOKEN_ALREADY_USED = 'TOKEN_ALREADY_USED',
	EMAIL_ALREADY_VERIFIED = 'EMAIL_ALREADY_VERIFIED',

	// Session Errors
	SESSION_ID_REQUIRED = 'SESSION_ID_REQUIRED',
	SESSION_NOT_FOUND = 'SESSION_NOT_FOUND',

	// Provider Errors
	INVALID_PROVIDER = 'INVALID_PROVIDER',

	// Permission Errors
	FORBIDDEN = 'FORBIDDEN',

	// Generic Errors
	INTERNAL_ERROR = 'INTERNAL_ERROR',
	ERROR_CREATING_ACCOUNT = 'ERROR_CREATING_ACCOUNT',
	ERROR_SENDING_EMAIL = 'ERROR_SENDING_EMAIL',
	ERROR_UPDATING_NAME = 'ERROR_UPDATING_NAME',
	ERROR_CHANGING_PASSWORD = 'ERROR_CHANGING_PASSWORD',
	ERROR_CHANGING_EMAIL = 'ERROR_CHANGING_EMAIL',
	ERROR_VERIFYING_EMAIL = 'ERROR_VERIFYING_EMAIL',
	ERROR_RESETTING_PASSWORD = 'ERROR_RESETTING_PASSWORD',
	ERROR_REQUESTING_EMAIL_CHANGE = 'ERROR_REQUESTING_EMAIL_CHANGE',
	ERROR_UPDATING_PRIMARY_PROVIDER = 'ERROR_UPDATING_PRIMARY_PROVIDER',
	ERROR_UPDATING_LOCALE = 'ERROR_UPDATING_LOCALE',
	ERROR_DURING_LOGIN = 'ERROR_DURING_LOGIN',
	ERROR_PROCESSING_REQUEST = 'ERROR_PROCESSING_REQUEST',
}

// ===== INTERFACES =====

/**
 * Стандартный успешный ответ API
 */
export interface ApiSuccessResponse<T = any> {
	success: true;
	code: SUCCESS_CODES;
	data?: T;
}

/**
 * Стандартный ответ с ошибкой для внутренних функций
 */
export interface ApiErrorResult {
	valid: false;
	code: ERROR_CODES;
	details?: any;
}

/**
 * Стандартный успешный результат для внутренних функций
 */
export interface ApiValidResult<T = any> {
	valid: true;
	data?: T;
}

/**
 * Объединенный тип для результатов валидации
 */
export type ApiResult<T = any> = ApiValidResult<T> | ApiErrorResult;

// ===== HELPER FUNCTIONS =====

/**
 * Создать успешный ответ API
 */
export function createSuccessResponse<T = any>(
	code: SUCCESS_CODES,
	data?: T,
): ApiSuccessResponse<T> {
	return {
		success: true,
		code,
		...(data && { data }),
	};
}

/**
 * Создать и выбросить ошибку API
 */
export function createErrorResponse(
	statusCode: number,
	code: ERROR_CODES,
	details?: any,
): never {
	throw createError({
		statusCode,
		statusMessage: code,
		data: { code, details },
	});
}

/**
 * Создать результат ошибки для внутренних функций
 */
export function createErrorResult(
	code: ERROR_CODES,
	details?: any,
): ApiErrorResult {
	return {
		valid: false,
		code,
		...(details && { details }),
	};
}

/**
 * Создать результат успеха для внутренних функций
 */
export function createValidResult<T = any>(data?: T): ApiValidResult<T> {
	return {
		valid: true,
		...(data && { data }),
	};
}
