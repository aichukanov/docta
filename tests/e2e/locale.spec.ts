import { test, expect } from '@playwright/test';
import { HeaderComponent } from '../pages/components/header.page';

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

			// Проверяем cookie
			const cookies = await page.context().cookies();
			const localeCookie = cookies.find((c) => c.name === 'locale');
			expect(localeCookie?.value).toBe('ru');
		});

		test('should load page with English locale from query parameter', async ({
			page,
		}) => {
			await page.goto('/?lang=en');
			await page.waitForLoadState('domcontentloaded');

			expect(page.url()).toContain('lang=en');

			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('en');

			const cookies = await page.context().cookies();
			const localeCookie = cookies.find((c) => c.name === 'locale');
			expect(localeCookie?.value).toBe('en');
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
			await page.context().addCookies([
				{
					name: 'locale',
					value: 'de',
					domain: 'localhost',
					path: '/',
				},
			]);

			await page.goto('/');
			await page.waitForLoadState('domcontentloaded');

			// Должен использовать локаль из cookie
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('de');
		});

		test('should prefer query parameter over cookie', async ({ page }) => {
			// Устанавливаем cookie с одной локалью
			await page.context().addCookies([
				{
					name: 'locale',
					value: 'de',
					domain: 'localhost',
					path: '/',
				},
			]);

			// Открываем с другой локалью в query
			await page.goto('/?lang=ru');
			await page.waitForLoadState('domcontentloaded');

			// Должен использовать локаль из query
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('ru');

			// Cookie должен обновиться
			const cookies = await page.context().cookies();
			const localeCookie = cookies.find((c) => c.name === 'locale');
			expect(localeCookie?.value).toBe('ru');
		});
	});

	test.describe('Anonymous Users - Language Switcher', () => {
		let header: HeaderComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			header = new HeaderComponent(page);
		});

		test('should switch language using language switcher', async ({
			page,
		}) => {
			// Открываем и выбираем русский
			await header.selectLanguage('Русский');
			await page.waitForLoadState('domcontentloaded');

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
			await page.waitForLoadState('domcontentloaded');

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
			await page.waitForLoadState('domcontentloaded');

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
			expect(html).toContain('html lang="ru"');
		});

		test('should not have hydration mismatch for locale', async ({
			page,
		}) => {
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
				(error) =>
					error.includes('Hydration') || error.includes('mismatch'),
			);
			expect(hydrationErrors).toHaveLength(0);
		});

		test('should have same locale on server and client', async ({
			page,
		}) => {
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

	test.describe('Authenticated Users', () => {
		// NOTE: Эти тесты требуют наличия тестового пользователя с сессией
		// Для полноценного запуска нужно добавить фикстуры для авторизации

		test.skip('should load user preferred locale from database', async ({
			page,
		}) => {
			// TODO: Добавить авторизацию тестового пользователя
			// const authCookie = await loginTestUser(page, 'test@example.com', 'password');

			// Пользователь имеет русскую локаль в профиле
			// Открываем страницу без query параметра
			await page.goto('/');
			await page.waitForLoadState('domcontentloaded');

			// Должна загрузиться русская локаль из БД
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('ru');
		});

		test.skip('should ignore query parameter for authenticated users', async ({
			page,
		}) => {
			// TODO: Добавить авторизацию тестового пользователя

			// Пользователь имеет русскую локаль в профиле
			// Открываем страницу с английским query параметром
			await page.goto('/?lang=en');
			await page.waitForLoadState('domcontentloaded');

			// Должна загрузиться русская локаль из БД (игнорируя query)
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('ru');

			// URL НЕ должен содержать lang параметр
			// (для залогиненных пользователей редирект не происходит)
			expect(page.url()).toContain('lang=en');
		});

		test.skip('should save locale to database when changed', async ({
			page,
		}) => {
			// TODO: Добавить авторизацию тестового пользователя

			const header = new HeaderComponent(page);
			await page.goto('/');

			// Меняем язык через switcher
			await header.selectLanguage('English');
			await page.waitForLoadState('domcontentloaded');

			// Перезагружаем страницу
			await page.reload();
			await page.waitForLoadState('domcontentloaded');

			// Должен загрузиться английский из БД
			const htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('en');
		});

		test.skip('should use query parameter after logout', async ({
			page,
		}) => {
			// TODO: Добавить авторизацию и разлогинивание

			// Залогиненный пользователь имеет русскую локаль
			await page.goto('/');
			let htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('ru');

			// Разлогиниваемся
			// await logoutTestUser(page);

			// Открываем с английским query параметром
			await page.goto('/?lang=en');
			await page.waitForLoadState('domcontentloaded');

			// Теперь должен работать query параметр
			htmlLang = await page.getAttribute('html', 'lang');
			expect(htmlLang).toBe('en');
		});
	});

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

		test('should remove deprecated locales (ME, BA) from cookie', async ({
			page,
		}) => {
			// Устанавливаем deprecated локаль в cookie
			await page.context().addCookies([
				{
					name: 'locale',
					value: 'me', // Montenegro - deprecated
					domain: 'localhost',
					path: '/',
				},
			]);

			await page.goto('/');
			await page.waitForLoadState('domcontentloaded');

			// Cookie должен быть удален или заменен на дефолтный
			const cookies = await page.context().cookies();
			const localeCookie = cookies.find((c) => c.name === 'locale');
			expect(localeCookie?.value).not.toBe('me');
			expect(localeCookie?.value).not.toBe('ba');
		});

		test('should handle locale change during navigation', async ({
			page,
		}) => {
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

		test('should load locale from profile quickly for authenticated users', async ({
			page,
		}) => {
			// TODO: Добавить авторизацию
			// Измеряем время загрузки локали из БД

			const startTime = Date.now();
			await page.goto('/');
			await page.waitForLoadState('domcontentloaded');
			const endTime = Date.now();

			const loadTime = endTime - startTime;

			// Загрузка не должна занимать больше 2 секунд
			expect(loadTime).toBeLessThan(2000);
		});
	});
});
