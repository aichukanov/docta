import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';

dotenv.config();

// const baseURL = 'https://docta.me';
const baseURL = process.env.E2E_BASE_URL || 'http://localhost:3000';
const isProduction = baseURL.includes('docta.me');

export default defineConfig({
	testDir: './tests',

	// Максимальное время выполнения одного теста.
	// Локально столько же, сколько на проде: `nuxt dev` компилирует роут при
	// первом заходе, и под параллельными воркерами первый `page.goto` в
	// раздел легко перебирал 30 секунд — тесты падали не по существу.
	timeout: 60 * 1000,

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

	// Количество воркеров.
	// Локально узкое место — dev-сервер: на дефолтной половине ядер он не
	// успевал отвечать и тесты флакали.
	// По проду — последовательно: во-первых, это вежливее к живому сайту;
	// во-вторых, пока фикс зависания перехода (Vue 3.5.40) не выкатан,
	// параллельные браузеры отъедают CPU и воспроизводят баг, из-за чего
	// половина детальных страниц падает не по своей вине. После деплоя
	// это ограничение можно снять.
	workers: process.env.CI || isProduction ? 1 : 4,

	// Прогрев маршрутов dev-сервера, см. tests/global-setup.ts
	globalSetup: './tests/global-setup.ts',

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

		navigationTimeout: isProduction ? 30000 : 45000,
		actionTimeout: isProduction ? 15000 : 15000,
	},

	projects: [
		{
			name: 'chromium',
			testDir: './tests/e2e',
			use: { ...devices['Desktop Chrome'] },
		},

		// Unit-тесты (без браузера)
		{
			name: 'unit',
			testDir: './tests/unit',
			retries: 0,
			use: {},
		},

		// Утилитарные скрипты (парсеры и т.д.)
		{
			name: 'scripts',
			testDir: './tests/scripts',
			timeout: 5 * 60 * 1000,
			retries: 0,
			use: {},
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
			// Полный прогон e2e доводил SSR-воркер `nuxt dev` до
			// «JS heap out of memory», и дальше весь раздел отдавал 500 —
			// падения выглядели как флаки. Касается только сервера,
			// который поднимает сам Playwright.
			env: { NODE_OPTIONS: '--max-old-space-size=4096' },
		},
	}),
});
