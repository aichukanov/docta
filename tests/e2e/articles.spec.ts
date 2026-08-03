import { test, expect } from '@playwright/test';
import type { Page } from '@playwright/test';
import { URLS } from '../utils/constants';
import { ARTICLE_SLUGS } from '../../common/articles';

// Статьи не проходят через ListPage/EntityPage: листинг — свои `.article-card`,
// страница — `components/article-page.vue`. Соответствие ARTICLE_SLUGS файлам
// и sitemap проверяет tests/unit/article-slugs.spec.ts, здесь — рендер.

const articleCards = (page: Page) => page.locator('.article-card');

test.describe('Листинг статей', () => {
	test.beforeEach(async ({ page }) => {
		await page.goto(URLS.ARTICLES, { waitUntil: 'domcontentloaded' });
	});

	test('открывается и показывает карточки', async ({ page }) => {
		await expect(page).toHaveURL(/\/articles(?:[/?#]|$)/);
		expect(await articleCards(page).count()).toBeGreaterThan(0);
	});

	test('на листинге есть ссылка на каждую статью', async ({ page }) => {
		// Расхождение здесь означает статью, до которой нельзя дойти по сайту.
		// Unit-тест сверяет ARTICLE_SLUGS с файлами и исходником листинга,
		// этот — с тем, что реально отрисовалось.
		const hrefs = await page
			.locator('.article-card a[href^="/articles/"], a.article-card')
			.evaluateAll((links) =>
				links.map((l) => (l.getAttribute('href') || '').split(/[?#]/)[0]),
			);
		const rendered = new Set(hrefs.map((h) => h.replace('/articles/', '')));

		expect([...rendered].sort()).toEqual([...ARTICLE_SLUGS].sort());
	});

	test('у карточки есть заголовок и описание', async ({ page }) => {
		const first = articleCards(page).first();
		expect(
			((await first.locator('h2, h3').first().textContent()) || '').trim()
				.length,
		).toBeGreaterThan(0);
		expect(
			((await first.locator('p').first().textContent()) || '').trim().length,
		).toBeGreaterThan(0);
	});

	test('переход в статью по клику', async ({ page }) => {
		await articleCards(page).first().click();
		await page.waitForURL(/\/articles\/[^/?#]+/);
	});
});

test.describe('Страница статьи', () => {
	test.beforeEach(async ({ page }) => {
		await page.goto(URLS.ARTICLES, { waitUntil: 'domcontentloaded' });
		await articleCards(page).first().click();
		await page.waitForURL(/\/articles\/[^/?#]+/);
	});

	test('есть заголовок, описание и текст', async ({ page }) => {
		await expect(page.locator('.article-page h1')).toBeVisible();
		await expect(page.locator('.article-page .description')).toBeVisible();
		await expect(page.locator('.article-page .article-body')).toBeVisible();
	});

	test('хлебные крошки возвращают на листинг', async ({ page }) => {
		const articleUrl = page.url();
		const breadcrumb = page
			.locator('nav.app-breadcrumbs a.app-breadcrumbs__link[href="/articles"]')
			.first();

		await breadcrumb.waitFor({ state: 'visible' });
		await breadcrumb.click();

		await page.waitForURL(/\/articles(?:\/)?(?:\?.*)?$/);
		expect(page.url()).not.toBe(articleUrl);
	});

	test('canonical указывает на саму статью', async ({ page }) => {
		const canonical = await page
			.locator('link[rel="canonical"]')
			.getAttribute('href');
		expect(canonical).toContain(new URL(page.url()).pathname);
	});
});
