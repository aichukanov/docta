import { request } from '@playwright/test';
import type { APIRequestContext } from '@playwright/test';
import { LISTING_SECTIONS } from './utils/sections';
import { URLS } from './utils/constants';

/**
 * Прогрев маршрутов перед прогоном.
 *
 * `nuxt dev` компилирует страницу при первом заходе, и параллельные воркеры,
 * одновременно постучавшиеся в непрогретый раздел, упирались в таймаут
 * `page.goto` — падения были не по существу. Здесь маршруты запрашиваются
 * заранее и по одному: и листинги, и по одной детальной странице каждого
 * раздела (это отдельный роут, компилируется отдельно).
 *
 * На проде прогрев не нужен и не делается.
 */
export default async function globalSetup() {
	const baseURL = process.env.E2E_BASE_URL || 'http://localhost:3000';
	if (!baseURL.includes('localhost')) return;

	const context = await request.newContext({ baseURL });

	await warm(context, URLS.HOME);
	await warm(context, URLS.ARTICLES);

	for (const section of LISTING_SECTIONS) {
		const html = await warm(context, section.url);
		const detail = html?.match(
			new RegExp(`href="(${section.url}/[^"?#]+)"`),
		)?.[1];
		if (detail) await warm(context, detail);
	}

	await context.dispose();
}

/** Прогрев — лучшее усилие: о непонятной ошибке внятно скажет сам тест */
async function warm(
	context: APIRequestContext,
	path: string,
): Promise<string | null> {
	try {
		const response = await context.get(path, { timeout: 120_000 });
		return await response.text();
	} catch {
		return null;
	}
}
