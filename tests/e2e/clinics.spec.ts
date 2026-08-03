import { test, expect } from '@playwright/test';
import type { Page } from '@playwright/test';
import { ListingPage } from '../pages/listing.page';
import { LISTING_SECTIONS, detailUrlPattern } from '../utils/sections';

// Общий контракт листинга и детальной страницы клиник проверяется в
// listings.spec.ts. Здесь — только то, чего нет у других разделов:
// часы работы и подстраницы.

const CLINICS = LISTING_SECTIONS.find((s) => s.key === 'clinics')!;

/** Открыть детальную страницу первой клиники из листинга, вернуть её путь */
async function openFirstClinic(page: Page): Promise<string> {
	const listing = new ListingPage(page, CLINICS);
	await listing.goto();
	await listing.waitForResultsReady();
	await listing.clickFirstItem();
	await page.waitForURL(detailUrlPattern('clinics'));
	return new URL(page.url()).pathname.replace(/\/$/, '');
}

test.describe('Страница клиники', () => {
	test('часы работы: семь строк и статус', async ({ page }) => {
		await openFirstClinic(page);

		const rows = page.locator('.working-hours__row');
		if ((await rows.count()) === 0) {
			test.skip();
			return;
		}

		// Семь дней недели рендерятся всегда, включая выходные
		expect(await rows.count()).toBe(7);
		await expect(page.locator('.status-badge').first()).toBeVisible();
	});

	test('ссылки на подстраницы ведут внутрь той же клиники', async ({
		page,
	}) => {
		const clinicPath = await openFirstClinic(page);

		const hrefs = await page
			.locator(`a[href^="${clinicPath}/"]`)
			.evaluateAll((links) => links.map((l) => l.getAttribute('href') || ''));
		if (hrefs.length === 0) {
			test.skip();
			return;
		}

		const allowed = [
			'doctors',
			'services',
			'labtests',
			'medications',
			'reviews',
		];
		for (const href of hrefs) {
			const tail = href.slice(clinicPath.length + 1).split(/[?#]/)[0];
			expect(allowed, `неожиданная подстраница: ${href}`).toContain(tail);
		}
	});
});

const SUBPAGES = ['services', 'labtests', 'medications', 'doctors'] as const;

test.describe('Подстраницы клиники', () => {
	// Подстраницы — отдельная поверхность индексации (пункт 7e SEO-аудита).
	// Их две разновидности, и обе штатные: у крупного раздела своя страница,
	// у мелкого — 301 на якорь карточки клиники. 404 здесь быть не должно.

	for (const sub of SUBPAGES) {
		test(`/${sub}: своя страница либо 301 на якорь клиники`, async ({
			page,
			request,
		}) => {
			const clinicPath = await openFirstClinic(page);
			const target = `${clinicPath}/${sub}`;

			const response = await request.get(target, { maxRedirects: 0 });
			const status = response.status();
			expect([200, 301], `неожиданный код ${status} на ${target}`).toContain(
				status,
			);

			if (status === 301) {
				expect(response.headers()['location']).toMatch(
					new RegExp(`${clinicPath}#${sub}$`),
				);
				return;
			}

			await page.goto(target, { waitUntil: 'domcontentloaded' });
			await expect(page.locator('.items-page')).toBeVisible();

			const canonical = await page
				.locator('link[rel="canonical"]')
				.getAttribute('href');
			expect(canonical).toContain(target);
		});
	}

	test('на подстранице сортировка закрыта от индексации', async ({ page }) => {
		// `sort` не меняет состав, только порядок — но плодит дубль страницы.
		// См. composables/use-clinic-items-route.ts.
		const clinicPath = await openFirstClinic(page);

		for (const sub of SUBPAGES) {
			const response = await page.goto(`${clinicPath}/${sub}?sort=price`, {
				waitUntil: 'domcontentloaded',
			});
			// мелкий раздел уводит редиректом на карточку клиники — не наш случай
			if (!page.url().includes(`/${sub}`)) continue;
			expect(response?.status()).toBe(200);

			const robots = await page
				.locator('meta[name="robots"]')
				.getAttribute('content');
			expect(robots, `${sub}?sort=price должен быть noindex`).toContain(
				'noindex',
			);
			return;
		}

		test.skip();
	});

	test('/reviews открывается', async ({ page }) => {
		const clinicPath = await openFirstClinic(page);

		const response = await page.goto(`${clinicPath}/reviews`, {
			waitUntil: 'domcontentloaded',
		});
		expect(response?.status()).toBe(200);
		await expect(page.locator('.reviews-page')).toBeVisible();
	});
});
