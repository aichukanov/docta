import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';

dotenv.config();

const baseURL = process.env.E2E_BASE_URL || 'http://localhost:3000';
const isProduction = baseURL.includes('docta.me');
const isLocal = !isProduction;

// webServer в Playwright общий на весь прогон, но unit-проекту сервер не нужен:
// `--project=unit` не должен ждать поднятия Nuxt (а если порт занят чужим
// приложением — ещё и падать по таймауту сборки).
const selectedProjects = process.argv.flatMap((arg, i) =>
	arg === '--project'
		? [process.argv[i + 1]]
		: arg.startsWith('--project=')
			? [arg.slice('--project='.length)]
			: [],
);
const needsBrowser =
	selectedProjects.length === 0 || selectedProjects.includes('chromium');

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
	// По проду — последовательно: прогон идёт настоящим headed Chrome (см. ниже
	// про Cloudflare), и несколько таких окон разом и грузят живой сайт, и
	// быстрее нарываются на бот-защиту.
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
			use: {
				...devices['Desktop Chrome'],
				// Прод за Cloudflare, и он отдаёт 403 браузеру с признаками
				// автоматизации: не доезжают манифест приложения и часть /api/,
				// страница показывает «не найдено». Замерено на одной машине в
				// один момент: Playwright Chromium — 403, настоящий Chrome без
				// флага автоматизации — 200, но только headed (headless Chrome
				// тоже 403). Живых пользователей это не касается — тот же URL
				// из обычного Chrome и из curl отдаётся нормально.
				...(isProduction
					? {
							channel: 'chrome',
							headless: false,
							launchOptions: {
								args: ['--disable-blink-features=AutomationControlled'],
								ignoreDefaultArgs: ['--enable-automation'],
							},
						}
					: {}),
			},
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

	// Dev server только для локального окружения.
	// url берётся из baseURL, а не хардкодится: порт 3000 бывает занят чужим
	// приложением, и тогда прогон молча уходил в него — падения выглядели как
	// поломка docta. Свой порт задаётся через E2E_BASE_URL.
	...(isLocal &&
		needsBrowser && {
			webServer: {
				command: 'npm run dev',
				url: baseURL,
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
