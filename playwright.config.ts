import { defineConfig, devices } from '@playwright/test';

// const baseURL = 'https://docta.me';
const baseURL = process.env.E2E_BASE_URL || 'http://localhost:3000';
const isProduction = baseURL.includes('docta.me');

export default defineConfig({
	testDir: './tests/e2e',

	// Максимальное время выполнения одного теста
	timeout: isProduction ? 60 * 1000 : 30 * 1000,

	// Ожидание элементов
	expect: {
		timeout: 5000,
	},

	// Полный параллелизм
	fullyParallel: true,

	// Fail быстро если в CI
	forbidOnly: !!process.env.CI,

	// Retry при падении
	retries: process.env.CI ? 2 : 1,

	// Количество воркеров
	workers: process.env.CI ? 1 : undefined,

	// Отчеты
	reporter: [
		['html', { outputFolder: 'playwright-report', open: 'never' }],
		['list'],
		['json', { outputFile: 'test-results/results.json' }],
	],

	use: {
		baseURL,

		// Скриншоты только при падении
		screenshot: 'only-on-failure',

		// Видео при первом retry
		video: 'retain-on-failure',

		// Трейсы для отладки
		trace: 'on-first-retry',

		// Таймауты для продакшена
		navigationTimeout: isProduction ? 30000 : 30000,
		actionTimeout: isProduction ? 15000 : 10000,
	},

	projects: [
		{
			name: 'chromium',
			use: { ...devices['Desktop Chrome'] },
		},

		// Опционально: другие браузеры
		// {
		//   name: 'firefox',
		//   use: { ...devices['Desktop Firefox'] },
		// },
		// {
		//   name: 'webkit',
		//   use: { ...devices['Desktop Safari'] },
		// },
	],

	// Dev server только для локального окружения
	...(baseURL.includes('localhost') && {
		webServer: {
			command: 'npm run dev',
			url: 'http://localhost:3000',
			reuseExistingServer: !process.env.CI,
			timeout: 120 * 1000,
		},
	}),
});
