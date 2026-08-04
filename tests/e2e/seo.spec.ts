import { test, expect } from '@playwright/test';
import { URLS } from '../utils/constants';
import { LISTING_SECTIONS } from '../utils/sections';
import { SITE_URL } from '../../common/constants';
import { fetchText, visit } from '../utils/http';

// Индексационная обвязка: robots.txt, sitemap, редиректы и noindex.
// Unit-тесты (canonical-url, retired-filter-ids, duplicate-surface-noindex)
// проверяют чистые функции; здесь — что до HTTP-ответа это доезжает.
//
// Всё идёт через навигацию браузера (`visit`), а не через `request.get()`:
// прод за Cloudflare отдаёт не-браузерным клиентам 403, и такие тесты там
// падали не по делу. Браузер сам следует редиректам, поэтому вместо кода 301
// проверяется число хопов и то, куда в итоге привело.

const locations = (xml: string) =>
	[...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => m[1]);

test.describe('robots.txt', () => {
	test('отдаётся как текст и ведёт на sitemap', async ({ page }) => {
		const res = await fetchText(page, '/robots.txt');

		expect(res.status).toBe(200);
		expect(res.contentType).toContain('text/plain');
		expect(res.body).toMatch(/^User-agent:/m);
		expect(res.body).toMatch(/Sitemap:\s*https?:\/\//i);
	});

	test('закрыты приватные разделы', async ({ page }) => {
		const res = await fetchText(page, '/robots.txt');
		for (const path of ['/admin/', '/login', '/profile']) {
			expect(res.body, `${path} должен быть в Disallow`).toContain(
				`Disallow: ${path}`,
			);
		}
	});

	test('не отвечает редиректом на cookie локали', async ({ page, context }) => {
		// С cookie `locale` fixUrlRegionalParams раньше уводил .txt на ?lang=,
		// а верификация IndexNow и парсеры robots.txt ждут ровно 200.
		const baseURL = process.env.E2E_BASE_URL || 'http://localhost:3000';
		await context.addCookies([{ name: 'locale', value: 'ru', url: baseURL }]);

		const res = await fetchText(page, '/robots.txt');
		expect(res.status).toBe(200);
		expect(res.redirected, 'редиректов быть не должно').toBe(false);
	});
});

test.describe('sitemap.xml', () => {
	test('валидный XML с абсолютными ссылками', async ({ page }) => {
		const res = await fetchText(page, '/sitemap.xml');

		expect(res.status).toBe(200);
		expect(res.contentType).toContain('xml');
		expect(res.body).toContain('<urlset');
		expect(res.body).toContain('</urlset>');

		const locs = locations(res.body);
		expect(locs.length).toBeGreaterThan(0);
		for (const loc of locs) {
			expect(loc, 'в sitemap только абсолютные URL').toMatch(/^https?:\/\//);
		}
	});

	test('содержит все листинги', async ({ page }) => {
		const res = await fetchText(page, '/sitemap.xml');
		for (const section of LISTING_SECTIONS) {
			expect(res.body, `нет ${section.url}`).toContain(`${section.url}</loc>`);
		}
	});

	test('нет дублей URL', async ({ page }) => {
		const locs = locations((await fetchText(page, '/sitemap.xml')).body);
		const duplicates = locs.filter((loc, i) => locs.indexOf(loc) !== i);
		expect([...new Set(duplicates)]).toEqual([]);
	});
});

test.describe('Редиректы', () => {
	test('числовой ID уходит на слаг одним хопом', async ({ page }) => {
		const res = await visit(page, '/clinics/95');

		expect(res.hops, 'ровно один хоп').toBe(1);
		expect(res.status, 'цель редиректа сама редиректу не подлежит').toBe(200);
		expect(new URL(res.url).pathname).toMatch(/^\/clinics\/[a-z0-9-]+$/);
		expect(
			new URL(res.url).pathname,
			'редирект не должен вести снова на число',
		).not.toMatch(/^\/clinics\/\d+$/);
	});

	test('дефолтная локаль в query отдаёт редирект без lang', async ({
		page,
	}) => {
		const res = await visit(page, '/doctors?lang=sr');

		expect(res.hops).toBeGreaterThanOrEqual(1);
		expect(res.status).toBe(200);
		expect(res.url).not.toContain('lang=sr');
	});

	test('снятый ID фильтра уходит на преемника', async ({ page }) => {
		// 73 → PHYSIOTHERAPY, см. server/common/redirect/retired-filter-ids.ts
		const res = await visit(page, '/doctors?specialtyIds=73');

		expect(res.hops, 'второго хопа быть не должно').toBe(1);
		expect(res.status).toBe(200);
		expect(res.url).toContain('specialtyIds=');
		expect(res.url).not.toContain('specialtyIds=73');
	});
});

test.describe('Коды ответа', () => {
	test('несуществующий слаг клиники — 404', async ({ page }) => {
		expect((await visit(page, '/clinics/no-such-clinic-xyz')).status).toBe(404);
	});

	test('несуществующая статья — 404', async ({ page }) => {
		expect((await visit(page, '/articles/no-such-article-xyz')).status).toBe(
			404,
		);
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
