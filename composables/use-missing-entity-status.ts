import { isGonePayload } from '~/common/gone';

/**
 * Ставит честный код для страницы сущности, которой публично нет:
 * 410 Gone — если админ скрыл её намеренно (маркер `{ gone: true }` из details),
 * 404 — во всех остальных случаях (нет такого слага, черновик, самоскрытие).
 *
 * Вызывать только когда данных нет: на SSR, иначе no-op.
 * См. prd/silent-200-index-hygiene — коды ответа должны быть честными.
 */
export function setMissingEntityStatus(payload: unknown): void {
	if (!import.meta.server) return;

	const event = useRequestEvent();
	if (!event) return;

	setResponseStatus(event, isGonePayload(payload) ? 410 : 404);
}
