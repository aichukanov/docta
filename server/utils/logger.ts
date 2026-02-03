import { createConsola } from 'consola';

/**
 * Централизованная система логирования для серверных API
 * Использует consola для структурированных логов с временными метками
 */

// Базовый логгер для всего приложения
export const logger = createConsola({
	level: process.env.NODE_ENV === 'production' ? 3 : 4, // info в prod, debug в dev
	formatOptions: {
		date: true,
		colors: true,
	},
});

/**
 * Создает логгер для конкретного модуля с префиксом
 * @param module - название модуля (например, 'auth', 'billing', 'clinics')
 */
export function createModuleLogger(module: string) {
	return logger.withTag(module);
}

// Готовые логгеры для основных модулей
export const authLogger = createModuleLogger('auth');
export const billingLogger = createModuleLogger('billing');
export const dbLogger = createModuleLogger('db');
export const emailLogger = createModuleLogger('email');

/**
 * Логирует начало операции с контекстом
 * @param operation - название операции
 * @param context - контекстные данные (user ID, email и т.д.)
 */
export function logOperation(
	moduleLogger: ReturnType<typeof createModuleLogger>,
	operation: string,
	context: Record<string, any> = {},
) {
	const sanitizedContext = { ...context };
	// Удаляем чувствительные данные из логов
	delete sanitizedContext.password;
	delete sanitizedContext.token;
	delete sanitizedContext.accessToken;

	moduleLogger.info(operation, sanitizedContext);
}

/**
 * Логирует ошибку с полным контекстом
 * @param operation - название операции
 * @param error - объект ошибки
 * @param context - дополнительный контекст
 */
export function logError(
	moduleLogger: ReturnType<typeof createModuleLogger>,
	operation: string,
	error: any,
	context: Record<string, any> = {},
) {
	const sanitizedContext = { ...context };
	delete sanitizedContext.password;
	delete sanitizedContext.token;
	delete sanitizedContext.accessToken;

	moduleLogger.error(operation, {
		...sanitizedContext,
		error: error.message || error,
		stack: error.stack,
	});
}
