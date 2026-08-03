import { test, expect } from '@playwright/test';
import { URLS } from '../utils/constants';
import { LISTING_SECTIONS } from '../utils/sections';
import { SITE_URL } from '../../common/constants';

// Индексационная обвязка: robots.txt, sitemap, редиректы и noindex.
// Unit-тесты (canonical-url, retired-filter-ids, duplicate-surface-noindex)
// проверяют чистые функции; здесь — что до HTTP-ответа это доезжает.
// Все проверки идут через API-запросы без рендера, поэтому спек быстрый.

test.describe('robots.txt', () => {
	test('отдаётся как текст и ведёт на sitemap', async ({ request }) => {
		const response = await request.get('/robots.txt');

		expect(response.status()).toBe(200);
		expect(response.headers()['content-type']).toContain('text/plain');

		const body = await response.text();
		expect(body).toMatch(/^User-agent:/m);
		expect(body).toMatch(/Sitemap:\s*https?:\/\//i);
	});

	test('закрыты приватные разделы', async ({ request }) => {
		const body = await (await request.get('/robots.txt')).text();
		for (const path of ['/admin/', '/login', '/profile']) {
			expect(body, `${path} должен быть в Disallow`).toContain(
				`Disallow: ${path}`,
			);
		}
	});

	test('не отвечает редиректом на cookie локали', async ({ request }) => {
		// С cookie `locale` fixUrlRegionalParams раньше уводил .txt на ?lang=,
		// а верификация IndexNow и парсеры robots.txt ждут ровно 200.
		const response = await request.get('/robots.txt', {
			headers: { cookie: 'locale=ru' },
			maxRedirects: 0,
		});
		expect(response.status()).toBe(200);
	});
});

test.describe('sitemap.xml', () => {
	test('валидный XML с абсолютными ссылками', async ({ request }) => {
		const response = await request.get('/sitemap.xml');

		expect(response.status()).toBe(200);
		expect(response.headers()['content-type']).toContain('xml');

		const body = await response.text();
		expect(body).toContain('<urlset');
		expect(body).toContain('</urlset>');

		const locs = [...body.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]);
		expect(locs.length).toBeGreaterThan(0);
		for (const loc of locs) {
			expect(loc, 'в sitemap только абсолютные URL').toMatch(/^https?:\/\//);
		}
	});

	test('содержит все листинги', async ({ request }) => {
		const body = await (await request.get('/sitemap.xml')).text();
		for (const section of LISTING_SECTIONS) {
			expect(body, `нет ${section.url}`).toContain(`${section.url}</loc>`);
		}
	});

	test('нет дублей URL', async ({ request }) => {
		const body = await (await request.get('/sitemap.xml')).text();
		const locs = [...body.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]);
		const duplicates = locs.filter((loc, i) => locs.indexOf(loc) !== i);
		expect([...new Set(duplicates)]).toEqual([]);
	});
});

test.describe('Редиректы', () => {
	test('числовой ID уходит на слаг одним хопом', async ({ request }) => {
		const response = await request.get('/clinics/95', { maxRedirects: 0 });

		expect(response.status()).toBe(301);
		const location = response.headers()['location'];
		expect(location).toMatch(/\/clinics\/[a-z0-9-]+$/);
		expect(location, 'редирект не должен вести снова на число').not.toMatch(
			/\/clinics\/\d+$/,
		);

		// Цель редиректа сама редиректу не подлежит
		const target = await request.get(location, { maxRedirects: 0 });
		expect(target.status()).toBe(200);
	});

	test('дефолтная локаль в query отдаёт 301 без lang', async ({ request }) => {
		const response = await request.get('/doctors?lang=sr', {
			maxRedirects: 0,
		});

		expect(response.status()).toBe(301);
		expect(response.headers()['location']).not.toContain('lang=sr');
	});

	test('снятый ID фильтра уходит на преемника', async ({ request }) => {
		// 73 → PHYSIOTHERAPY, см. server/common/redirect/retired-filter-ids.ts
		const response = await request.get('/doctors?specialtyIds=73', {
			maxRedirects: 0,
		});

		expect(response.status()).toBe(301);
		const location = response.headers()['location'];
		expect(location).toContain('specialtyIds=');
		expect(location).not.toContain('specialtyIds=73');

		const target = await request.get(location, { maxRedirects: 0 });
		expect(target.status(), 'второго хопа быть не должно').toBe(200);
	});
});

test.describe('Коды ответа', () => {
	test('несуществующий слаг клиники — 404', async ({ request }) => {
		const response = await request.get('/clinics/no-such-clinic-xyz');
		expect(response.status()).toBe(404);
	});

	test('несуществующая статья — 404', async ({ request }) => {
		const response = await request.get('/articles/no-such-article-xyz');
		expect(response.status()).toBe(404);
	});
});

test.describe('Мета-разметка листингов', () => {
	for (const section of LISTING_SECTIONS) {
		test(`${section.url}: canonical на себя и hreflang`, async ({ page }) => {
			await page.goto(section.url, { waitUntil: 'domcontentloaded' });

			const canonical = await page
				.locator('link[rel="canonical"]')
				.getAttribute('href');
			// canonical всегда прод-домен, даже когда тесты идут по localhost
			expect(canonical).toBe(`${SITE_URL}${section.url}`);

			const alternates = await page
				.locator('link[rel="alternate"][hreflang]')
				.count();
			expect(alternates).toBeGreaterThan(1);
		});
	}

	test('мусорное значение фильтра закрывается от индексации', async ({
		page,
	}) => {
		// Store молча выбрасывает невалидный ID, страница отдаёт полный каталог
		// с 200 — без noindex это неограниченная поверхность дублей (пункт 7d).
		await page.goto('/doctors?specialtyIds=99999', {
			waitUntil: 'domcontentloaded',
		});

		const robots = await page
			.locator('meta[name="robots"]')
			.getAttribute('content');
		expect(robots).toContain('noindex');
	});

	test('чистый листинг от индексации не закрыт', async ({ page }) => {
		await page.goto(URLS.DOCTORS, { waitUntil: 'domcontentloaded' });

		const robots = await page
			.locator('meta[name="robots"]')
			.getAttribute('content')
			.catch(() => null);
		expect(robots ?? '').not.toContain('noindex');
	});
});
