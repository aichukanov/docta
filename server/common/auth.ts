import type { H3Event } from 'h3';
import { getUserFromSession, type User } from '~/server/utils/session';

// Ключи мемоизации в контексте запроса. Контекст живёт ровно один HTTP-запрос,
// а сессия внутри одного запроса измениться не может.
const SESSION_USER_PROMISE = '__sessionUserPromise';

/**
 * Читает сессию НЕ БОЛЕЕ ОДНОГО РАЗА за запрос.
 *
 * За одну страницу getCurrentUser звался 2–3 раза и больше: сначала
 * regional-settings на каждом не-API запросе, затем каждый вызванный страницей
 * API (таких мест 34). Запрос сессии — это 7 LEFT JOIN по auth_users и трём
 * парам oauth-таблиц (server/utils/session.ts), и он повторялся целиком.
 *
 * Мемоизируем именно промис, а не результат: несколько параллельных вызовов
 * в одном запросе (Promise.all) иначе успели бы разойтись мимо кэша и всё
 * равно сходить в БД по разу каждый.
 */
async function resolveSessionUser(event: H3Event): Promise<User | null> {
	const cached = event.context[SESSION_USER_PROMISE] as
		| Promise<User | null>
		| undefined;

	if (cached) {
		return await cached;
	}

	const promise = (async () => {
		const sessionId = getCookie(event, 'session_id');

		if (!sessionId) {
			return null;
		}

		return await getUserFromSession(sessionId);
	})();

	event.context[SESSION_USER_PROMISE] = promise;

	const user = await promise;

	// event.context.user — уже существующий контракт (его читают админские
	// хендлеры после requireAdmin). Заполняем и здесь, чтобы прочитанную
	// сессию мог переиспользовать любой код запроса, в том числе
	// getUserPreferredLocale, у которого на руках нет event.
	if (user) {
		event.context.user = user;
	}

	return user;
}

/**
 * Возвращает пользователя, уже прочитанного в этом запросе, БЕЗ обращения к БД.
 * Нужен там, где событие есть, а лишний запрос за уже известными полями — нет.
 */
export function getResolvedSessionUser(
	event: H3Event | undefined,
): User | null {
	return (event?.context?.user as User | undefined) ?? null;
}

/**
 * Проверяет права доступа администратора.
 * Проверяет сессию из БД и флаг is_admin.
 * Выбрасывает ошибку 401/403 если доступ запрещён.
 */
export async function requireAdmin(event: H3Event): Promise<void> {
	// 1. Получить session_id из cookie
	const sessionId = getCookie(event, 'session_id');

	if (!sessionId) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized: No session found',
		});
	}

	// 2. Получить пользователя из сессии (из кэша запроса, если уже читали)
	const user = await resolveSessionUser(event);

	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized: Invalid or expired session',
		});
	}

	// 3. Проверить, что пользователь - администратор
	if (!user.is_admin) {
		throw createError({
			statusCode: 403,
			statusMessage: 'Forbidden: Admin access required',
		});
	}

	// 4. Сохранить пользователя в контексте для дальнейшего использования
	event.context.user = user;
}

/**
 * Получает текущего пользователя из сессии (опционально).
 * Не выбрасывает ошибку, если пользователь не авторизован.
 * @returns Пользователь или null
 */
export async function getCurrentUser(event: H3Event): Promise<User | null> {
	return await resolveSessionUser(event);
}
