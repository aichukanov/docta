# Итерация 1: Установка и базовая настройка

[← К списку итераций](README.md) | [Следующая итерация →](iteration-02-home-navigation.md)

---

## Цель

Установить Playwright, настроить конфигурацию и создать базовую структуру проекта для E2E тестирования.

## Зависимости

Нет (первая итерация)

## Задачи

1. Установить Playwright и зависимости
2. Создать файл конфигурации `playwright.config.ts`
3. Настроить два окружения (local и production)
4. Создать базовую структуру папок
5. Создать базовые утилиты и константы
6. Добавить npm скрипты для запуска тестов
7. Добавить `.gitignore` записи для артефактов тестов
8. Создать простой smoke test для проверки конфигурации

## Технические детали

### 1. Установка Playwright

```bash
# Установить Playwright
npm install -D @playwright/test @types/node

# Установить браузеры
npx playwright install
```

### 2. Создать структуру папок

```bash
mkdir tests
mkdir tests/e2e
mkdir tests/pages
mkdir tests/pages/components
mkdir tests/pages/lists
mkdir tests/pages/details
mkdir tests/utils
mkdir tests/fixtures
```

### 3. Создать файл: `playwright.config.ts`

```typescript
import { defineConfig, devices } from '@playwright/test';

const baseURL = process.env.BASE_URL || 'http://localhost:3000';

export default defineConfig({
	testDir: './tests/e2e',

	// Максимальное время выполнения одного теста
	timeout: 30 * 1000,

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
	reporter: [['html', { outputFolder: 'playwright-report' }], ['list']],

	use: {
		baseURL,

		// Скриншоты только при падении
		screenshot: 'only-on-failure',

		// Видео при первом retry
		video: 'retain-on-failure',

		// Трейсы для отладки
		trace: 'on-first-retry',
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
```

### 4. Создать файл: `tests/utils/constants.ts`

```typescript
export const URLS = {
	HOME: '/',
	CLINICS: '/clinics',
	DOCTORS: '/doctors',
	SERVICES: '/services',
	MEDICINES: '/medicines',
	ARTICLES: '/articles',
} as const;

export const LANGUAGES = {
	SERBIAN: 'sr',
	ENGLISH: 'en',
} as const;

export const TIMEOUTS = {
	SHORT: 2000,
	MEDIUM: 5000,
	LONG: 10000,
} as const;
```

### 5. Создать файл: `tests/utils/test-helpers.ts`

```typescript
import { Page } from '@playwright/test';

/**
 * Ждать завершения навигации и загрузки контента
 */
export async function waitForPageLoad(page: Page) {
	await page.waitForLoadState('networkidle');
	await page.waitForLoadState('domcontentloaded');
}

/**
 * Проверить что URL содержит ожидаемый путь
 */
export function expectUrlContains(page: Page, path: string) {
	const url = page.url();
	if (!url.includes(path)) {
		throw new Error(`Expected URL to contain "${path}", but got "${url}"`);
	}
}

/**
 * Получить текущий язык из URL
 */
export function getCurrentLanguage(page: Page): string {
	const url = page.url();
	return url.includes('/en/') ? 'en' : 'sr';
}
```

### 6. Создать файл: `tests/pages/base.page.ts`

```typescript
import { Page } from '@playwright/test';

export class BasePage {
	constructor(protected page: Page) {}

	/**
	 * Перейти на страницу
	 */
	async goto(url: string) {
		await this.page.goto(url);
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Получить заголовок страницы
	 */
	async getTitle(): Promise<string> {
		return await this.page.title();
	}

	/**
	 * Проверить что элемент видим
	 */
	async isVisible(selector: string): Promise<boolean> {
		return await this.page.locator(selector).isVisible();
	}

	/**
	 * Кликнуть по элементу
	 */
	async click(selector: string) {
		await this.page.locator(selector).click();
	}

	/**
	 * Получить текст элемента
	 */
	async getText(selector: string): Promise<string> {
		return (await this.page.locator(selector).textContent()) || '';
	}
}
```

### 7. Создать smoke test: `tests/e2e/smoke.spec.ts`

```typescript
import { test, expect } from '@playwright/test';

test.describe('Smoke tests', () => {
	test('should load home page', async ({ page }) => {
		await page.goto('/');

		// Проверяем что страница загрузилась
		await expect(page).toHaveTitle(/docta\.me/i);

		// Проверяем что есть какой-то контент
		const body = await page.locator('body').textContent();
		expect(body).toBeTruthy();
	});

	test('should have correct base URL', async ({ page }) => {
		await page.goto('/');

		const url = page.url();
		expect(url).toMatch(/localhost:3000|docta\.me/);
	});
});
```

### 8. Обновить `package.json`

Добавить скрипты:

```json
{
	"scripts": {
		"test:e2e": "playwright test",
		"test:e2e:ui": "playwright test --ui",
		"test:e2e:prod": "BASE_URL=https://docta.me playwright test",
		"test:e2e:headed": "playwright test --headed",
		"test:e2e:debug": "playwright test --debug",
		"test:e2e:report": "playwright show-report"
	}
}
```

### 9. Обновить `.gitignore`

```gitignore
# Playwright
test-results/
playwright-report/
playwright/.cache/
```

## Критерии приемки

- [ ] AC-1: Playwright установлен и браузеры загружены (команда `npx playwright --version` работает)
- [ ] AC-2: Файл конфигурации `playwright.config.ts` создан и корректен
- [ ] AC-3: Структура папок создана (tests/e2e, tests/pages, tests/utils)
- [ ] AC-4: Базовые утилиты созданы (constants.ts, test-helpers.ts, base.page.ts)
- [ ] AC-5: npm скрипты добавлены и работают
- [ ] AC-6: `.gitignore` обновлен
- [ ] AC-7: Smoke test проходит на localhost:3000
- [ ] AC-8: HTML отчет генерируется после выполнения тестов

## Как проверить

1. **Установка:**

   ```bash
   npm install
   npx playwright --version  # Должна вывести версию
   ```

2. **Запуск smoke test (локально):**

   ```bash
   npm run dev  # В отдельном терминале
   npm run test:e2e  # Должен пройти smoke test
   ```

3. **Проверка отчета:**

   ```bash
   npm run test:e2e:report  # Должен открыться HTML отчет
   ```

4. **Проверка UI режима:**

   ```bash
   npm run test:e2e:ui  # Должен открыться Playwright UI
   ```

5. **Проверка структуры:**

   - Папка `tests/` существует
   - Все подпапки созданы
   - Все файлы утилит и базовых классов на месте

6. **Проверка на продакшене (опционально):**
   ```bash
   npm run test:e2e:prod  # Smoke test должен пройти на https://docta.me
   ```

## Статус

**Not Started**

---

**Следующая итерация:** [2. Главная страница и навигация →](iteration-02-home-navigation.md)
