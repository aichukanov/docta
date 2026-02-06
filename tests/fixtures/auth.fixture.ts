import { test as base, Page } from '@playwright/test';

/**
 * Фикстуры для тестирования с авторизацией
 * 
 * TODO: Реализовать методы после создания страницы логина
 */

interface AuthFixtures {
	/**
	 * Page с уже авторизованным пользователем
	 * Использовать когда нужен залогиненный контекст
	 */
	authenticatedPage: Page;

	/**
	 * Залогинить тестового пользователя
	 */
	loginTestUser: (email: string, password: string) => Promise<void>;

	/**
	 * Разлогинить пользователя
	 */
	logoutTestUser: () => Promise<void>;

	/**
	 * Создать тестового пользователя с определенной локалью
	 */
	createTestUserWithLocale: (
		email: string,
		password: string,
		locale: string,
	) => Promise<{ userId: number; sessionId: string }>;
}

export const test = base.extend<AuthFixtures>({
	authenticatedPage: async ({ page }, use) => {
		// TODO: Реализовать
		// 1. Создать тестового пользователя в БД
		// 2. Создать сессию для него
		// 3. Установить cookie session_id
		// 4. Передать page с установленной сессией

		// Пример:
		// const testUser = await createTestUser({
		//   email: 'test@example.com',
		//   password: 'password123',
		//   preferred_locale: 'ru'
		// });
		//
		// const session = await createSession(testUser.id);
		//
		// await page.context().addCookies([
		//   {
		//     name: 'session_id',
		//     value: session.id,
		//     domain: 'localhost',
		//     path: '/',
		//     httpOnly: true,
		//     sameSite: 'Lax',
		//   },
		// ]);

		await use(page);

		// Cleanup: удалить тестового пользователя и сессию
	},

	loginTestUser: async ({ page }, use) => {
		await use(async (email: string, password: string) => {
			// TODO: Реализовать после создания страницы логина
			// await page.goto('/login');
			// await page.fill('[name="email"]', email);
			// await page.fill('[name="password"]', password);
			// await page.click('button[type="submit"]');
			// await page.waitForLoadState('domcontentloaded');
			//
			// // Проверить что авторизация прошла успешно
			// const cookies = await page.context().cookies();
			// const sessionCookie = cookies.find((c) => c.name === 'session_id');
			// if (!sessionCookie) {
			//   throw new Error('Login failed: no session cookie');
			// }

			throw new Error('loginTestUser not implemented yet');
		});
	},

	logoutTestUser: async ({ page }, use) => {
		await use(async () => {
			// TODO: Реализовать
			// 1. Удалить cookie session_id
			// 2. Опционально: вызвать API для удаления сессии из БД

			await page.context().clearCookies();
		});
	},

	createTestUserWithLocale: async ({ page }, use) => {
		await use(
			async (
				email: string,
				password: string,
				locale: string,
			): Promise<{ userId: number; sessionId: string }> => {
				// TODO: Реализовать
				// 1. Вызвать API для создания пользователя
				// 2. Установить preferred_locale в БД
				// 3. Создать сессию
				// 4. Вернуть userId и sessionId

				// Пример:
				// const response = await fetch('http://localhost:3000/api/test/create-user', {
				//   method: 'POST',
				//   headers: { 'Content-Type': 'application/json' },
				//   body: JSON.stringify({ email, password, preferred_locale: locale }),
				// });
				//
				// const data = await response.json();
				// return { userId: data.userId, sessionId: data.sessionId };

				throw new Error('createTestUserWithLocale not implemented yet');
			},
		);
	},
});

export { expect } from '@playwright/test';
