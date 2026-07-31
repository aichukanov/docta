/**
 * Ответ details-эндпоинта для сущности, скрытой администратором.
 *
 * `null` из details означает «нет такой страницы» → 404. Но скрытие админом —
 * намеренное и постоянное удаление из индекса, для него правильный код 410 Gone:
 * Google и Яндекс выбрасывают такие URL быстрее, чем по 404. Чтобы страница
 * могла различить два случая (SSR-вызов эндпоинта — отдельный event, его статус
 * до рендера страницы не доезжает), эндпоинт возвращает этот маркер вместо
 * данных — без единого поля контента.
 *
 * Скрытие врачом самого себя и черновики остаются 404: они обратимы.
 */
export interface GonePayload {
	gone: true;
}

export const GONE_PAYLOAD: GonePayload = { gone: true };

export function isGonePayload(value: unknown): value is GonePayload {
	return (
		typeof value === 'object' &&
		value !== null &&
		(value as { gone?: unknown }).gone === true
	);
}
