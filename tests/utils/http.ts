import type { Page } from '@playwright/test';

// Прод за Cloudflare и отдаёт 403 всему, что похоже на автоматизацию:
// `request.get()` там непригоден (замерено — curl и настоящий Chrome
// получают 200, APIRequestContext 403). Поэтому и статусы, и тела ответов
// добываются через страницу.

export interface VisitResult {
	/** Конечный статус: браузер сам идёт по редиректам */
	status: number;
	/** URL после всех редиректов, вместе с фрагментом */
	url: string;
	/** Сколько редиректов прошло по пути */
	hops: number;
}

/** Навигация — для проверки статусов и редиректов. */
export async function visit(page: Page, url: string): Promise<VisitResult> {
	const response = await page.goto(url, { waitUntil: 'commit' });
	if (!response) {
		throw new Error(`нет ответа на ${url}`);
	}

	let hops = 0;
	let from = response.request().redirectedFrom();
	while (from) {
		hops++;
		from = from.redirectedFrom();
	}

	return { status: response.status(), url: page.url(), hops };
}

export interface FetchResult {
	status: number;
	contentType: string;
	body: string;
	/** Был ли редирект по пути */
	redirected: boolean;
}

/**
 * Тело ответа — через `fetch` внутри страницы, а не навигацией.
 *
 * У навигации две проблемы. Первая: sitemap.xml несёт XSL-стилизацию, и
 * браузер отдаёт уже преобразованный HTML вместо исходного XML. Вторая:
 * `.txt` и `.xml` браузер оборачивает в свою страницу-просмотрщик.
 * Внутристраничный fetch отдаёт ровно то, что прислал сервер, и при этом
 * идёт с полными признаками живого браузера.
 */
export async function fetchText(page: Page, url: string): Promise<FetchResult> {
	// fetch должен уйти с нужного origin — иначе он и не сработает, и cookie
	// не приложатся
	if (!page.url().startsWith('http')) {
		await page.goto('/', { waitUntil: 'commit' });
	}

	return await page.evaluate(async (target) => {
		const response = await fetch(target);
		return {
			status: response.status,
			contentType: response.headers.get('content-type') || '',
			body: await response.text(),
			redirected: response.redirected,
		};
	}, url);
}
