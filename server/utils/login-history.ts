import type { H3Event } from 'h3';
import { executeQuery } from '~/server/common/db-mysql';
import { authLogger } from './logger';
import type { AuthMethod } from './oauth-providers';

export interface LoginHistoryEntry {
	id: number;
	user_id: number;
	ip_address: string | null;
	user_agent: string | null;
	location: string | null;
	login_method: string;
	success: boolean;
	failure_reason: string | null;
	created_at: string;
}

/**
 * Получить IP адрес из запроса
 */
export function getClientIp(event: H3Event): string {
	// Проверяем заголовки от прокси/балансировщика
	const xForwardedFor = getRequestHeader(event, 'x-forwarded-for');
	if (xForwardedFor) {
		return xForwardedFor.split(',')[0].trim();
	}

	const xRealIp = getRequestHeader(event, 'x-real-ip');
	if (xRealIp) {
		return xRealIp;
	}

	// Fallback на адрес из запроса
	return event.node.req.socket.remoteAddress || 'unknown';
}

/**
 * Получить User Agent из запроса
 */
export function getUserAgent(event: H3Event): string {
	return getRequestHeader(event, 'user-agent') || 'unknown';
}

/**
 * Логировать успешный вход
 */
export async function logSuccessfulLogin(
	userId: number,
	event: H3Event,
	method: AuthMethod,
): Promise<void> {
	const ipAddress = getClientIp(event);
	const userAgent = getUserAgent(event);

	// TODO: В будущем можно добавить геолокацию через API
	// const location = await getLocationFromIp(ipAddress);

	await executeQuery(
		`INSERT INTO auth_login_history (user_id, ip_address, user_agent, location, login_method, success)
     VALUES (?, ?, ?, NULL, ?, TRUE)`,
		[userId, ipAddress, userAgent, method],
	);

	authLogger.info('Successful login', {
		userId,
		method,
		ip: ipAddress,
	});
}

/**
 * Логировать неудачную попытку входа
 */
export async function logFailedLogin(
	userId: number | null,
	event: H3Event,
	method: AuthMethod,
	reason: string,
): Promise<void> {
	const ipAddress = getClientIp(event);
	const userAgent = getUserAgent(event);

	// Если userId неизвестен (например, email не существует), используем -1
	const logUserId = userId || -1;

	await executeQuery(
		`INSERT INTO auth_login_history (user_id, ip_address, user_agent, location, login_method, success, failure_reason)
     VALUES (?, ?, ?, NULL, ?, FALSE, ?)`,
		[logUserId, ipAddress, userAgent, method, reason],
	);

	authLogger.warn('Failed login attempt', {
		userId: logUserId,
		method,
		ip: ipAddress,
		reason,
	});
}

/**
 * Получить историю входов пользователя
 */
export async function getUserLoginHistory(
	userId: number,
	limit: number = 50,
): Promise<LoginHistoryEntry[]> {
	const safeLimit = Math.max(1, Math.min(Number(limit) || 50, 1000));
	const results = await executeQuery<LoginHistoryEntry>(
		`SELECT * FROM auth_login_history 
     WHERE user_id = ? AND success = TRUE
     ORDER BY created_at DESC 
     LIMIT ${safeLimit}`,
		[userId],
	);

	return results;
}

/**
 * Получить последний успешный вход (кроме текущего)
 */
export async function getLastSuccessfulLogin(
	userId: number,
): Promise<LoginHistoryEntry | null> {
	const results = await executeQuery<LoginHistoryEntry>(
		`SELECT * FROM auth_login_history 
     WHERE user_id = ? AND success = TRUE
     ORDER BY created_at DESC 
     LIMIT 1, 1`,
		[userId],
	);

	return results[0] || null;
}

/**
 * Проверить подозрительную активность (много неудачных попыток)
 */
export async function checkSuspiciousActivity(
	userId: number,
	timeWindowMinutes: number = 30,
): Promise<{ suspicious: boolean; failedAttempts: number }> {
	const timeWindowSeconds = timeWindowMinutes * 60;
	const cutoffTime = Math.floor(Date.now() / 1000) - timeWindowSeconds;

	const results = await executeQuery(
		`SELECT COUNT(*) as count FROM auth_login_history 
     WHERE user_id = ? AND success = FALSE 
     AND UNIX_TIMESTAMP(created_at) > ?`,
		[userId, cutoffTime],
	);

	const failedAttempts = (results[0] as any).count;
	const suspicious = failedAttempts >= 5; // 5+ неудачных попыток за 30 минут

	return { suspicious, failedAttempts };
}

/**
 * Получить статистику входов по методам
 */
export async function getLoginMethodStats(
	userId: number,
): Promise<Record<string, number>> {
	const results = await executeQuery(
		`SELECT login_method, COUNT(*) as count 
     FROM auth_login_history 
     WHERE user_id = ? AND success = TRUE
     GROUP BY login_method`,
		[userId],
	);

	const stats: Record<string, number> = {};
	for (const row of results) {
		const r = row as any;
		stats[r.login_method] = r.count;
	}

	return stats;
}
