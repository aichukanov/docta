import { test, expect } from '@playwright/test';
import type { Page } from '@playwright/test';
import { HeaderComponent } from '../pages/components/header.page';

// Cookie ставится по адресу страницы, а не по захардкоженному домену: иначе
// на прогоне против прода кука с domain=localhost до docta.me не доезжает и
// тест «приоритет cookie над query» проверял бы пустоту.
async function setLocaleCookie(page: Page, value: string) {
	const baseURL = process.env.E2E_BASE_URL || 'http://localhost:3000';
	await page.context().addCookies([{ name: 'locale', value, url: baseURL }]);
}

test.describe('Locale System', () => {
	test.describe('Anonymous Users - Query Parameters', () => {
		test('should load page with Russian locale from query parameter', async ({
			page,
		}) => {
			await page.goto('/?lang=ru');
			await page.waitForLoadState('domcontentloaded');

			// Проверяем что URL содержит lang=ru
			expect(page.url()).toContain('lang=ru');

			// Проверяем что атрибут lang установлен правильно
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('ru');
		});

		test('should load page with English locale from query parameter', async ({
			page,
		}) => {
			await page.goto('/?lang=en');
			await page.waitForLoadState('domcontentloaded');

			expect(page.url()).toContain('lang=en');

			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('en');
		});

		test('should redirect from default locale in query parameter', async ({
			page,
		}) => {
			await page.goto('/?lang=sr');

			// Должен сделать редирект на URL без lang=sr
			await page.waitForURL(/^(?!.*lang=sr).*$/);

			const finalUrl = page.url();
			expect(finalUrl).not.toContain('lang=sr');
		});

		test('should use cookie locale when no query parameter', async ({
			page,
		}) => {
			// Устанавливаем cookie вручную
			await setLocaleCookie(page, 'de');

			await page.goto('/');
			await page.waitForLoadState('domcontentloaded');

			// Должен использовать локаль из cookie
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('de');
		});

		test('should prefer cookie over query parameter', async ({ page }) => {
			// Устанавливаем cookie с одной локалью
			await setLocaleCookie(page, 'de');

			// Открываем с другой локалью в query
			await page.goto('/?lang=ru');
			await page.waitForLoadState('domcontentloaded');

			// Кука имеет приоритет над query-параметром
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('de');

			// Cookie остаётся прежним
			const cookies = await page.context().cookies();
			const localeCookie = cookies.find((c) => c.name === 'locale');
			expect(localeCookie?.value).toBe('de');
		});
	});

	test.describe('Anonymous Users - Language Switcher', () => {
		let header: HeaderComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			header = new HeaderComponent(page);
		});

		test('переключатель языка виден в шапке', async () => {
			await expect(header.getLanguageSwitcher()).toBeVisible();
		});

		test('should switch language using language switcher', async ({ page }) => {
			// Открываем и выбираем русский
			await header.selectLanguage('Русский');
			// router.replace — клиентская навигация, ждём именно смены URL
			await page.waitForURL(/lang=ru/);

			// Проверяем что язык изменился
			expect(page.url()).toContain('lang=ru');
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('ru');

			// Проверяем что cookie обновился
			const cookies = await page.context().cookies();
			const localeCookie = cookies.find((c) => c.name === 'locale');
			expect(localeCookie?.value).toBe('ru');
		});

		test('should persist language after page reload', async ({ page }) => {
			// Меняем язык
			await header.selectLanguage('English');
			await page.waitForURL(/lang=en/);

			// Перезагружаем страницу
			await page.reload();
			await page.waitForLoadState('domcontentloaded');

			// Проверяем что язык сохранился
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('en');
		});

		test('should persist language across navigation', async ({ page }) => {
			// Меняем язык на русский
			await header.selectLanguage('Русский');
			await page.waitForURL(/lang=ru/);

			// Переходим на другую страницу
			await page.goto('/doctors');
			await page.waitForLoadState('domcontentloaded');

			// Проверяем что язык сохранился
			expect(page.url()).toContain('lang=ru');
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('ru');
		});
	});

	test.describe('SSR and Hydration', () => {
		test('should render correct locale on server-side', async ({ page }) => {
			// Делаем запрос с русской локалью
			const response = await page.goto('/?lang=ru');
			const html = await response?.text();

			// Проверяем что в HTML уже есть правильный lang
			expect(html).toContain('lang="ru"');
		});

		test('should not have hydration mismatch for locale', async ({ page }) => {
			// Отслеживаем ошибки в консоли
			const consoleErrors: string[] = [];
			page.on('console', (msg) => {
				if (msg.type() === 'error') {
					consoleErrors.push(msg.text());
				}
			});

			await page.goto('/?lang=ru');
			await page.waitForLoadState('domcontentloaded');

			// Не должно быть ошибок гидратации
			const hydrationErrors = consoleErrors.filter(
				(error) => error.includes('Hydration') || error.includes('mismatch'),
			);
			expect(hydrationErrors).toHaveLength(0);
		});

		test('should have same locale on server and client', async ({ page }) => {
			const response = await page.goto('/?lang=de');
			const serverHtml = await response?.text();

			// Проверяем серверный HTML
			expect(serverHtml).toContain('lang="de"');

			// Ждем гидратации
			await page.waitForLoadState('domcontentloaded');

			// Проверяем клиентский атрибут
			const clientLang = await page.getAttribute('html', 'lang');
			expect(clientLang).toBe('de');
		});
	});

	// Локаль залогиненного пользователя (приоритет БД над query, запись при
	// смене языка) сюда не входит: здесь были четыре test.skip-заглушки без
	// фикстуры авторизации, они не проверяли ничего. Появится тестовый
	// пользователь — вернуть.

	test.describe('Edge Cases', () => {
		test('should handle invalid locale gracefully', async ({ page }) => {
			await page.goto('/?lang=invalid');
			await page.waitForLoadState('domcontentloaded');

			// Должна загрузиться дефолтная локаль (sr)
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(['sr', 'sr-cyrl']).toContain(htmlLang);
		});

		test('should handle multiple lang parameters', async ({ page }) => {
			await page.goto('/?lang=ru&lang=en');

			// Должен сделать редирект
			await page.waitForLoadState('domcontentloaded');

			// URL должен быть очищен или содержать только одну локаль
			const url = page.url();
			const langParams = url.split('lang=').length - 1;
			expect(langParams).toBeLessThanOrEqual(1);
		});

		test('should handle locale change during navigation', async ({ page }) => {
			await page.goto('/?lang=ru');
			await page.waitForLoadState('domcontentloaded');

			// Начинаем навигацию
			const navigationPromise = page.goto('/doctors');

			// Пытаемся изменить локаль во время навигации
			const header = new HeaderComponent(page);
			// Не ждем завершения selectLanguage
			header.selectLanguage('English').catch(() => {
				/* игнорируем ошибку */
			});

			await navigationPromise;
			await page.waitForLoadState('domcontentloaded');

			// Страница должна загрузиться корректно
			expect(page.url()).toContain('/doctors');
		});
	});

	test.describe('Performance', () => {
		test('should not cause layout shift when loading locale', async ({
			page,
		}) => {
			await page.goto('/?lang=ru');

			// Измеряем CLS (Cumulative Layout Shift)
			const cls = await page.evaluate(() => {
				return new Promise((resolve) => {
					let clsValue = 0;
					const observer = new PerformanceObserver((list) => {
						for (const entry of list.getEntries()) {
							if ((entry as any).hadRecentInput) continue;
							clsValue += (entry as any).value;
						}
					});
					observer.observe({ type: 'layout-shift', buffered: true });

					setTimeout(() => {
						observer.disconnect();
						resolve(clsValue);
					}, 3000);
				});
			});

			// CLS должен быть минимальным (< 0.1 считается хорошим)
			expect(cls).toBeLessThan(0.1);
		});

		test('главная отдаётся быстрее 3 секунд', async ({ page }) => {
			const startTime = Date.now();
			await page.goto('/');
			await page.waitForLoadState('domcontentloaded');
			const endTime = Date.now();

			const loadTime = endTime - startTime;

			// Загрузка не должна занимать больше 3 секунд
			expect(loadTime).toBeLessThan(3000);
		});
	});
});
