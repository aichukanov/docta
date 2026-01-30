import { test, expect } from '@playwright/test';
import { HomePage } from '../pages/home.page';

test.describe('Home Page', () => {
	let homePage: HomePage;

	test.beforeEach(async ({ page }) => {
		homePage = new HomePage(page);
		await homePage.goto();
	});

	test('should load home page successfully', async () => {
		const isLoaded = await homePage.isLoaded();
		expect(isLoaded).toBeTruthy();
	});

	test('should have title', async ({ page }) => {
		const title = await page.title();
		expect(title).toBeTruthy();
		expect(title.length).toBeGreaterThan(0);
		// Проверяем что title содержит ключевые слова
		expect(title.toLowerCase()).toMatch(/medic|health|доктор|врач|leka|услуг/);
	});

	test('should have main heading', async () => {
		const heading = await homePage.getMainHeading();
		expect(heading).toBeTruthy();
		expect(heading.length).toBeGreaterThan(0);
	});

	test('should have header and footer', async ({ page }) => {
		await expect(page.locator('header')).toBeVisible();
		await expect(page.locator('footer')).toBeVisible();
	});

	test('should have hero section', async ({ page }) => {
		await expect(page.locator('.hero')).toBeVisible();
		await expect(page.locator('.hero__title')).toBeVisible();
		await expect(page.locator('.hero__subtitle')).toBeVisible();
	});

	test('should have bento cards', async () => {
		const hasBentoCards = await homePage.hasBentoCards();
		expect(hasBentoCards).toBeTruthy();

		// Проверяем что есть хотя бы 5 карточек (основные разделы)
		const cardsCount = await homePage.page.locator('.bento__card').count();
		expect(cardsCount).toBeGreaterThanOrEqual(5);
	});

	test('should navigate when clicking bento card', async ({ page }) => {
		// Получаем первую карточку
		const firstCard = page.locator('.bento__card').first();
		await firstCard.click();

		// Проверяем что произошла навигация
		await page.waitForLoadState('domcontentloaded');
		const url = page.url();
		expect(url).not.toContain('/?');
		expect(url).not.toEqual(expect.stringContaining('/#'));
	});
});
