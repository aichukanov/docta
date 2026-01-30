import { test, expect } from '@playwright/test';

test.describe('Smoke tests', () => {
	test('should load home page', async ({ page }) => {
		await page.goto('/', { waitUntil: 'domcontentloaded', timeout: 30000 });

		// Проверяем что страница загрузилась с правильным title
		await expect(page).toHaveTitle(/Medicinske usluge/i);

		// Проверяем что есть какой-то контент
		const body = await page.locator('body').textContent();
		expect(body).toBeTruthy();
	});

	test('should have correct base URL', async ({ page }) => {
		await page.goto('/', { waitUntil: 'domcontentloaded', timeout: 30000 });

		const url = page.url();
		expect(url).toMatch(/localhost:3000|docta\.me/);
	});
});
