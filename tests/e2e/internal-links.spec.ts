import { test, expect } from '@playwright/test';
import { URLS } from '../utils/constants';
import { visit } from '../utils/http';

// Внутренняя перелинковка и соответствие разметки видимому.
//
// Обе темы объединяет то, что сломать их можно, ничего не «уронив»: страницы
// продолжат отдавать 200, тесты рендера пройдут, а сайт молча потеряет либо
// обход фасетов, либо право на крошки в выдаче.

test.describe('Хабы фасетов', () => {
	// Панель фильтров — чекбоксы, а не ссылки, поэтому единственный вход в
	// фасетные URL — блок связанных фильтров. Пока он показывался только при
	// уже выбранном фасете, войти в сеть было неоткуда: из 2535 фасетных
	// адресов sitemap ни один не имел входящей HTML-ссылки.
	// Имена параметров у разделов разные и легко путаются: у услуг фасет
	// категории называется `serviceCategoryIds`, у анализов — просто
	// `categoryIds`.
	const listings = [
		{ url: URLS.DOCTORS, param: 'specialtyIds' },
		{ url: URLS.SERVICES, param: 'serviceCategoryIds' },
		{ url: URLS.LABTESTS, param: 'categoryIds' },
		{ url: URLS.CLINICS, param: 'clinicTypeIds' },
	];

	for (const { url, param } of listings) {
		test(`${url}: с нефильтрованного листинга есть вход в фасеты`, async ({
			page,
		}) => {
			await page.goto(url, { waitUntil: 'domcontentloaded' });

			const links = page.locator(`a[href*="${param}="]`);
			await expect(links.first()).toBeAttached({ timeout: 15000 });
			expect(await links.count()).toBeGreaterThan(0);
		});
	}

	test('фасет из хаба индексируется, а не закрыт noindex', async ({ page }) => {
		await page.goto(URLS.DOCTORS, { waitUntil: 'domcontentloaded' });

		const href = await page
			.locator('a[href*="specialtyIds="]')
			.first()
			.getAttribute('href');

		expect(href).toBeTruthy();

		await page.goto(href!, { waitUntil: 'domcontentloaded' });

		// Ссылаться из хаба на страницу, которую сами же закрыли от индексации,
		// значило бы гонять краулера впустую.
		const robots = await page
			.locator('meta[name="robots"]')
			.count()
			.then(async (n) =>
				n ? page.locator('meta[name="robots"]').getAttribute('content') : null,
			);

		expect(robots || '').not.toContain('noindex');
	});
});

test.describe('Крошки: разметка соответствует видимому', () => {
	// Google требует размечать только то, что человек видит. Раньше
	// `BreadcrumbList` отдавали все карточки и листинги, а видимых крошек не
	// было ни на одной — разметка была недействительной по всему сайту.
	const pages = [URLS.DOCTORS, URLS.SERVICES, URLS.CLINICS];

	for (const url of pages) {
		test(`${url}: есть и разметка, и видимые крошки`, async ({ page }) => {
			await page.goto(url, { waitUntil: 'domcontentloaded' });

			const jsonLd = await page
				.locator('script[type="application/ld+json"]')
				.first()
				.textContent();

			if (!jsonLd?.includes('BreadcrumbList')) {
				test.skip(true, 'страница не размечает крошки — проверять нечего');
			}

			await expect(page.locator('nav[aria-label]').first()).toBeAttached();
			// Первая крошка всегда ведёт на главную.
			await expect(page.locator('a[href="/"]').first()).toBeAttached();
		});
	}

	test('карточка сущности показывает крошки', async ({ page }) => {
		await page.goto(URLS.SERVICES, { waitUntil: 'domcontentloaded' });

		const href = await page
			.locator('a[href^="/services/"]')
			.first()
			.getAttribute('href');

		await page.goto(href!, { waitUntil: 'domcontentloaded' });

		const jsonLd = await page
			.locator('script[type="application/ld+json"]')
			.first()
			.textContent();

		expect(jsonLd).toContain('BreadcrumbList');
		await expect(page.locator('a[href="/"]').first()).toBeAttached();
	});
});

test.describe('Обложка статьи', () => {
	// LCP-элемент страницы статьи. Был помечен `loading="lazy"` и без размеров:
	// браузер откладывал его загрузку до layout, а нулевая высота до загрузки
	// сдвигала вниз весь текст. Обе ошибки не видны ничем, кроме прямой
	// проверки атрибутов.
	test('грузится сразу, с размерами и адаптивным набором', async ({ page }) => {
		await page.goto('/articles', { waitUntil: 'domcontentloaded' });

		const href = await page
			.locator('a[href^="/articles/"]')
			.first()
			.getAttribute('href');

		await page.goto(href!, { waitUntil: 'domcontentloaded' });

		const hero = page.locator('img[fetchpriority="high"]').first();
		await expect(hero).toBeAttached();

		expect(await hero.getAttribute('loading')).not.toBe('lazy');
		expect(await hero.getAttribute('width')).toBeTruthy();
		expect(await hero.getAttribute('height')).toBeTruthy();
		expect(await hero.getAttribute('srcset')).toContain('w,');
	});
});

test.describe('Карточки листинга не потеряли клиники', () => {
	// Каталог клиник теперь приезжает в «справочном» режиме — без описаний.
	// Если срезать лишнее, карточки останутся без названий и адресов, а
	// страница по-прежнему будет отдавать 200.
	test('на /services в карточках есть ссылки на клиники', async ({ page }) => {
		await page.goto(URLS.SERVICES, { waitUntil: 'domcontentloaded' });

		const clinicLinks = page.locator('a[href^="/clinics/"]');
		await expect(clinicLinks.first()).toBeAttached({ timeout: 15000 });
		expect(await clinicLinks.count()).toBeGreaterThan(0);
	});

	test('на /clinics список непустой', async ({ page }) => {
		const res = await visit(page, URLS.CLINICS);
		expect(res.status).toBe(200);

		const items = page.locator('a[href^="/clinics/"]');
		await expect(items.first()).toBeAttached({ timeout: 15000 });
	});
});
