import type { H3Event } from 'h3';
import { executeQuery } from '~/server/common/db-mysql';

const SESSION_DURATION = 365 * 24 * 60 * 60; // 1 год в секундах

export interface User {
	id: number;
	email: string;
	name: string;
	username: string | null;
	photo_url: string | null;
	is_admin: boolean;
}

/**
 * Создает новую сессию для пользователя
 * @param userId - ID пользователя
 * @returns ID созданной сессии
 */
export async function createSession(userId: number): Promise<string> {
	const sessionId = crypto.randomUUID();
	const expiresAt = Math.floor(Date.now() / 1000) + SESSION_DURATION;

	await executeQuery(
		'INSERT INTO auth_sessions (id, user_id, expires_at) VALUES (?, ?, ?)',
		[sessionId, userId, expiresAt],
	);

	return sessionId;
}

/**
 * Устанавливает session cookie
 * @param event - H3 event
 * @param sessionId - ID сессии
 */
export function setSessionCookie(event: H3Event, sessionId: string): void {
	setCookie(event, 'session_id', sessionId, {
		httpOnly: true,
		secure: process.env.NODE_ENV === 'production',
		sameSite: 'lax',
		maxAge: SESSION_DURATION,
		path: '/',
	});
}

/**
 * Удаляет сессию из БД
 * @param sessionId - ID сессии
 */
export async function deleteSession(sessionId: string): Promise<void> {
	await executeQuery('DELETE FROM auth_sessions WHERE id = ?', [sessionId]);
}

/**
 * Очищает session cookie
 * @param event - H3 event
 */
export function clearSessionCookie(event: H3Event): void {
	deleteCookie(event, 'session_id', {
		path: '/',
	});
}

/**
 * Получает пользователя из сессии
 * @param sessionId - ID сессии
 * @returns Пользователь или null если сессия недействительна
 */
export async function getUserFromSession(
	sessionId: string,
): Promise<User | null> {
	const results = await executeQuery<User>(
		`SELECT u.id, u.email, COALESCE(NULLIF(u.name, ''), u.email) AS name, u.username, u.photo_url, u.is_admin 
     FROM auth_users u
     JOIN auth_sessions s ON u.id = s.user_id
     WHERE s.id = ? AND s.expires_at > UNIX_TIMESTAMP()`,
		[sessionId],
	);

	return results[0] || null;
}

/**
 * Получает пользователя по email
 * @param email - Email пользователя
 * @returns Пользователь со всеми полями (включая password_hash) или null
 */
export async function getUserByEmail(email: string): Promise<any | null> {
	const results = await executeQuery(
		'SELECT * FROM auth_users WHERE email = ?',
		[email],
	);

	return results[0] || null;
}
