import type { H3Event } from 'h3';

/**
 * Получить IP адрес клиента из запроса.
 *
 * За Cloudflare достоверен только CF-Connecting-IP: в X-Forwarded-For
 * Cloudflare дописывает реальный IP в конец, поэтому первый элемент
 * клиент может подделать своим заголовком.
 */
export function getClientIp(event: H3Event): string {
	const cfConnectingIp = getRequestHeader(event, 'cf-connecting-ip');
	if (cfConnectingIp) {
		return cfConnectingIp.trim();
	}

	// Запрос пришёл не через Cloudflare (локальная разработка, прямой
	// доступ к origin) — обычные прокси-заголовки
	const xForwardedFor = getRequestHeader(event, 'x-forwarded-for');
	if (xForwardedFor) {
		return xForwardedFor.split(',')[0].trim();
	}

	const xRealIp = getRequestHeader(event, 'x-real-ip');
	if (xRealIp) {
		return xRealIp;
	}

	return event.node.req.socket.remoteAddress || 'unknown';
}
