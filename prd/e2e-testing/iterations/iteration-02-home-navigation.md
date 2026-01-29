# Итерация 2: Тесты главной страницы, хедера и футера

[← К списку итераций](README.md) | [Предыдущая](iteration-01-setup.md) | [Следующая →](iteration-03-clinics-doctors.md)

---

## Цель

Создать тесты для главной страницы и общих элементов (хедер, футер), включая переключение языка и навигацию.

## Зависимости

- Итерация 1 должна быть завершена

## Задачи

1. Создать Page Object для главной страницы
2. Создать Page Object для хедера
3. Создать Page Object для футера
4. Написать тесты главной страницы
5. Написать тесты хедера (навигация + язык)
6. Написать тесты футера

## Технические детали

### 1. Создать файл: `tests/pages/home.page.ts`

```typescript
import { Page } from '@playwright/test';
import { BasePage } from './base.page';

export class HomePage extends BasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Перейти на главную страницу
	 */
	async goto() {
		await super.goto('/');
	}

	/**
	 * Проверить что главная страница загружена
	 */
	async isLoaded(): Promise<boolean> {
		// Проверяем наличие основных элементов главной страницы
		const hasHeader = await this.isVisible('header');
		const hasFooter = await this.isVisible('footer');
		return hasHeader && hasFooter;
	}

	/**
	 * Получить заголовок главной страницы
	 */
	async getMainHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}
}
```

### 2. Создать файл: `tests/pages/components/header.page.ts`

```typescript
import { Page } from '@playwright/test';

export class HeaderComponent {
	constructor(private page: Page) {}

	/**
	 * Получить ссылку навигации по имени
	 */
	private getNavLink(name: string) {
		return this.page.locator(`header nav a:has-text("${name}")`);
	}

	/**
	 * Кликнуть по ссылке в навигации
	 */
	async clickNavLink(linkText: string) {
		await this.getNavLink(linkText).click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить что ссылка навигации видима
	 */
	async isNavLinkVisible(linkText: string): Promise<boolean> {
		return await this.getNavLink(linkText).isVisible();
	}

	/**
	 * Переключить язык
	 */
	async switchLanguage(language: 'sr' | 'en') {
		const currentLang = this.getCurrentLanguage();

		if (currentLang !== language) {
			// Находим переключатель языка
			const languageSwitcher = this.page
				.locator('[data-testid="language-switcher"]')
				.or(
					this.page.locator('header').getByRole('button', { name: /sr|en/i }),
				);

			await languageSwitcher.click();
		}
	}

	/**
	 * Получить текущий язык из URL
	 */
	getCurrentLanguage(): 'sr' | 'en' {
		const url = this.page.url();
		return url.includes('/en/') ? 'en' : 'sr';
	}

	/**
	 * Получить все ссылки навигации
	 */
	async getNavLinks(): Promise<string[]> {
		const links = await this.page.locator('header nav a').all();
		const texts = await Promise.all(links.map((link) => link.textContent()));
		return texts.filter((text) => text !== null) as string[];
	}
}
```

### 3. Создать файл: `tests/pages/components/footer.page.ts`

```typescript
import { Page } from '@playwright/test';

export class FooterComponent {
	constructor(private page: Page) {}

	/**
	 * Получить ссылку в футере по тексту
	 */
	private getFooterLink(text: string) {
		return this.page.locator(`footer a:has-text("${text}")`);
	}

	/**
	 * Кликнуть по ссылке в футере
	 */
	async clickFooterLink(linkText: string) {
		await this.getFooterLink(linkText).click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить что ссылка в футере видима
	 */
	async isFooterLinkVisible(linkText: string): Promise<boolean> {
		return await this.getFooterLink(linkText).isVisible();
	}

	/**
	 * Получить все ссылки футера
	 */
	async getFooterLinks(): Promise<string[]> {
		const links = await this.page.locator('footer a').all();
		const texts = await Promise.all(links.map((link) => link.textContent()));
		return texts.filter(
			(text) => text !== null && text.trim() !== '',
		) as string[];
	}

	/**
	 * Проверить что футер видим
	 */
	async isVisible(): Promise<boolean> {
		return await this.page.locator('footer').isVisible();
	}
}
```

### 4. Создать файл: `tests/e2e/home.spec.ts`

```typescript
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
});
```

### 5. Создать файл: `tests/e2e/navigation.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { HeaderComponent } from '../pages/components/header.page';
import { FooterComponent } from '../pages/components/footer.page';
import { URLS } from '../utils/constants';

test.describe('Navigation', () => {
	test.describe('Header Navigation', () => {
		let header: HeaderComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			header = new HeaderComponent(page);
		});

		test('should have all navigation links visible', async ({ page }) => {
			// Проверяем наличие основных ссылок
			await expect(page.locator('header nav')).toBeVisible();

			const navLinks = await header.getNavLinks();
			expect(navLinks.length).toBeGreaterThan(0);
		});

		test('should navigate to clinics page', async ({ page }) => {
			await header.clickNavLink('Клиник'); // или "Clinics" в зависимости от языка

			await page.waitForURL(/.*clinics.*/);
			expect(page.url()).toContain('clinics');
		});

		test('should navigate to doctors page', async ({ page }) => {
			await header.clickNavLink('Лекар'); // или "Doctors"

			await page.waitForURL(/.*doctors.*/);
			expect(page.url()).toContain('doctors');
		});

		test('should navigate to services page', async ({ page }) => {
			await header.clickNavLink('Услуг'); // или "Services"

			await page.waitForURL(/.*services.*/);
			expect(page.url()).toContain('services');
		});

		test('should navigate to medicines page', async ({ page }) => {
			await header.clickNavLink('Лекова'); // или "Medicines"

			await page.waitForURL(/.*medicines.*/);
			expect(page.url()).toContain('medicines');
		});

		test('should navigate to articles page', async ({ page }) => {
			await header.clickNavLink('Чланака'); // или "Articles"

			await page.waitForURL(/.*articles.*/);
			expect(page.url()).toContain('articles');
		});
	});

	test.describe('Language Switching', () => {
		let header: HeaderComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			header = new HeaderComponent(page);
		});

		test('should switch from SR to EN', async ({ page }) => {
			// Если уже на EN, сначала переключаемся на SR
			const currentLang = header.getCurrentLanguage();
			if (currentLang === 'en') {
				await header.switchLanguage('sr');
				await page.waitForLoadState('domcontentloaded');
			}

			// Переключаемся на EN
			await header.switchLanguage('en');
			await page.waitForLoadState('domcontentloaded');

			// Проверяем URL
			expect(page.url()).toContain('/en/');
		});

		test('should switch from EN to SR', async ({ page }) => {
			// Сначала убеждаемся что на EN
			await page.goto('/en/');

			// Переключаемся на SR
			await header.switchLanguage('sr');
			await page.waitForLoadState('domcontentloaded');

			// Проверяем URL (не должно содержать /en/)
			expect(page.url()).not.toContain('/en/');
		});

		test('should preserve current page when switching language', async ({
			page,
		}) => {
			// Переходим на страницу клиник
			await page.goto('/clinics');

			// Переключаем язык
			await header.switchLanguage('en');
			await page.waitForLoadState('domcontentloaded');

			// Проверяем что остались на странице клиник, но с /en/
			expect(page.url()).toContain('/en/');
			expect(page.url()).toContain('clinics');
		});
	});

	test.describe('Footer Links', () => {
		let footer: FooterComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			footer = new FooterComponent(page);
		});

		test('should have footer visible', async () => {
			const isVisible = await footer.isVisible();
			expect(isVisible).toBeTruthy();
		});

		test('should have footer links', async () => {
			const footerLinks = await footer.getFooterLinks();
			expect(footerLinks.length).toBeGreaterThan(0);
		});

		// Добавьте конкретные тесты для ссылок футера
		// в зависимости от того, какие ссылки есть в вашем футере
	});
});
```

## Критерии приемки

- [ ] AC-1: Page Objects созданы для главной страницы, хедера и футера
- [ ] AC-2: Тесты проверяют загрузку главной страницы
- [ ] AC-3: Тесты проверяют наличие заголовка и основных элементов
- [ ] AC-4: Тесты проверяют все ссылки навигации в хедере
- [ ] AC-5: Тесты проверяют переход по каждой ссылке
- [ ] AC-6: Тесты проверяют переключение языка SR ↔ EN
- [ ] AC-7: URL корректно меняется при переключении языка
- [ ] AC-8: Тесты проверяют футер и его ссылки
- [ ] AC-9: Все тесты проходят на localhost:3000

## Как проверить

1. **Запустить тесты:**

   ```bash
   npm run test:e2e
   ```

2. **Проверить конкретные тесты:**

   ```bash
   # Только тесты главной страницы
   npm run test:e2e -- home.spec.ts

   # Только тесты навигации
   npm run test:e2e -- navigation.spec.ts
   ```

3. **Запустить с UI для отладки:**

   ```bash
   npm run test:e2e:ui
   ```

4. **Запустить в headed режиме:**

   ```bash
   npm run test:e2e:headed
   ```

5. **Проверить HTML отчет:**

   ```bash
   npm run test:e2e:report
   ```

6. **Проверить что все тесты проходят:**
   - Все тесты в `home.spec.ts` должны проходить (4 теста)
   - Все тесты в `navigation.spec.ts` должны проходить (10+ тестов)
   - Нет флаки-тестов (запустить 3 раза подряд)

## Статус

**Not Started**

---

**Следующая итерация:** [3. Списки клиник и врачей →](iteration-03-clinics-doctors.md)
