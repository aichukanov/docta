import { test, expect } from '@playwright/test';

test.describe('Smoke tests', () => {
	test('should load home page', async ({ page }) => {
		await page.goto('/', { waitUntil: 'domcontentloaded' });

		// Проверяем что страница загрузилась с правильным title
		await expect(page).toHaveTitle(/Medicinske usluge/i);

		// Проверяем что есть какой-то контент
		const body = await page.locator('body').textContent();
		expect(body).toBeTruthy();
	});

	test('should have correct base URL', async ({ page, baseURL }) => {
		await page.goto('/', { waitUntil: 'domcontentloaded' });

		// Сверяем с настроенным адресом, а не со списком «localhost:3000 или
		// docta.me»: прогон против собранного билда на другом порту — обычное
		// дело, и захардкоженный список ронял тест не по делу.
		expect(page.url()).toContain(new URL(baseURL!).host);
	});
});
