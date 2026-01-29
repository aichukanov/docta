# Итерация 4: Тесты списков услуг, лекарств и статей

[← К списку итераций](README.md) | [Предыдущая](iteration-03-clinics-doctors.md) | [Следующая →](iteration-05-detail-pages.md)

---

## Цель

Создать тесты для страниц списков услуг, лекарств и статей по аналогии со списками клиник и врачей.

## Зависимости

- Итерация 3 должна быть завершена

## Задачи

1. Создать Page Object для списка услуг
2. Создать Page Object для списка лекарств
3. Создать Page Object для списка статей
4. Написать тесты для каждого списка
5. Переиспользовать логику из `ListBasePage`

## Технические детали

### 1. Создать файл: `tests/pages/lists/service-list.page.ts`

```typescript
import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class ServiceListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	async goto() {
		await super.goto(URLS.SERVICES);
	}

	getListItems(): Locator {
		return this.page
			.locator('[data-testid="service-card"]')
			.or(this.page.locator('.service-card'))
			.or(
				this.page
					.locator('article')
					.filter({ has: this.page.locator('a[href*="/services/"]') }),
			);
	}

	async getFirstServiceName(): Promise<string> {
		const firstItem = this.getListItems().first();
		return (
			(await firstItem
				.locator('h2, h3, .service-name')
				.first()
				.textContent()) || ''
		);
	}
}
```

### 2. Создать файл: `tests/pages/lists/medicine-list.page.ts`

```typescript
import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class MedicineListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	async goto() {
		await super.goto(URLS.MEDICINES);
	}

	getListItems(): Locator {
		return this.page
			.locator('[data-testid="medicine-card"]')
			.or(this.page.locator('.medicine-card'))
			.or(
				this.page
					.locator('article')
					.filter({ has: this.page.locator('a[href*="/medicines/"]') }),
			);
	}

	async getFirstMedicineName(): Promise<string> {
		const firstItem = this.getListItems().first();
		return (
			(await firstItem
				.locator('h2, h3, .medicine-name')
				.first()
				.textContent()) || ''
		);
	}
}
```

### 3. Создать файл: `tests/pages/lists/article-list.page.ts`

```typescript
import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class ArticleListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	async goto() {
		await super.goto(URLS.ARTICLES);
	}

	getListItems(): Locator {
		return this.page
			.locator('[data-testid="article-card"]')
			.or(this.page.locator('.article-card'))
			.or(
				this.page
					.locator('article')
					.filter({ has: this.page.locator('a[href*="/articles/"]') }),
			);
	}

	async getFirstArticleTitle(): Promise<string> {
		const firstItem = this.getListItems().first();
		return (
			(await firstItem
				.locator('h2, h3, .article-title')
				.first()
				.textContent()) || ''
		);
	}
}
```

### 4. Создать файл: `tests/e2e/services.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { ServiceListPage } from '../pages/lists/service-list.page';

test.describe('Services List Page', () => {
	let servicesPage: ServiceListPage;

	test.beforeEach(async ({ page }) => {
		servicesPage = new ServiceListPage(page);
		await servicesPage.goto();
	});

	test('should load services list page', async ({ page }) => {
		await expect(page).toHaveURL(/.*services.*/);
	});

	test('should display service cards', async () => {
		const hasItems = await servicesPage.hasListItems();
		expect(hasItems).toBeTruthy();
	});

	test('should have at least one service', async () => {
		const count = await servicesPage.getListItemsCount();
		expect(count).toBeGreaterThan(0);
	});

	test('should display service name', async () => {
		const name = await servicesPage.getFirstServiceName();
		expect(name).toBeTruthy();
		expect(name.length).toBeGreaterThan(0);
	});

	test('should navigate to service detail page when clicked', async ({
		page,
	}) => {
		await servicesPage.clickFirstItem();

		await page.waitForURL(/.*services\/\d+.*/);
		expect(page.url()).toMatch(/services\/\d+/);
	});

	test.describe('Pagination', () => {
		test('should navigate to page 2 if pagination exists', async ({ page }) => {
			const hasPagination = await servicesPage.hasPagination();

			if (hasPagination) {
				await servicesPage.goToNextPage();

				const currentPage = servicesPage.getCurrentPageFromUrl();
				expect(currentPage).toBe(2);

				const hasItems = await servicesPage.hasListItems();
				expect(hasItems).toBeTruthy();
			} else {
				test.skip();
			}
		});
	});
});
```

### 5. Создать файл: `tests/e2e/medicines.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { MedicineListPage } from '../pages/lists/medicine-list.page';

test.describe('Medicines List Page', () => {
	let medicinesPage: MedicineListPage;

	test.beforeEach(async ({ page }) => {
		medicinesPage = new MedicineListPage(page);
		await medicinesPage.goto();
	});

	test('should load medicines list page', async ({ page }) => {
		await expect(page).toHaveURL(/.*medicines.*/);
	});

	test('should display medicine cards', async () => {
		const hasItems = await medicinesPage.hasListItems();
		expect(hasItems).toBeTruthy();
	});

	test('should have at least one medicine', async () => {
		const count = await medicinesPage.getListItemsCount();
		expect(count).toBeGreaterThan(0);
	});

	test('should display medicine name', async () => {
		const name = await medicinesPage.getFirstMedicineName();
		expect(name).toBeTruthy();
		expect(name.length).toBeGreaterThan(0);
	});

	test('should navigate to medicine detail page when clicked', async ({
		page,
	}) => {
		await medicinesPage.clickFirstItem();

		await page.waitForURL(/.*medicines\/\d+.*/);
		expect(page.url()).toMatch(/medicines\/\d+/);
	});

	test.describe('Pagination', () => {
		test('should navigate to page 2 if pagination exists', async ({ page }) => {
			const hasPagination = await medicinesPage.hasPagination();

			if (hasPagination) {
				await medicinesPage.goToNextPage();

				const currentPage = medicinesPage.getCurrentPageFromUrl();
				expect(currentPage).toBe(2);

				const hasItems = await medicinesPage.hasListItems();
				expect(hasItems).toBeTruthy();
			} else {
				test.skip();
			}
		});
	});
});
```

### 6. Создать файл: `tests/e2e/articles.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { ArticleListPage } from '../pages/lists/article-list.page';

test.describe('Articles List Page', () => {
	let articlesPage: ArticleListPage;

	test.beforeEach(async ({ page }) => {
		articlesPage = new ArticleListPage(page);
		await articlesPage.goto();
	});

	test('should load articles list page', async ({ page }) => {
		await expect(page).toHaveURL(/.*articles.*/);
	});

	test('should display article cards', async () => {
		const hasItems = await articlesPage.hasListItems();
		expect(hasItems).toBeTruthy();
	});

	test('should have at least one article', async () => {
		const count = await articlesPage.getListItemsCount();
		expect(count).toBeGreaterThan(0);
	});

	test('should display article title', async () => {
		const title = await articlesPage.getFirstArticleTitle();
		expect(title).toBeTruthy();
		expect(title.length).toBeGreaterThan(0);
	});

	test('should navigate to article detail page when clicked', async ({
		page,
	}) => {
		await articlesPage.clickFirstItem();

		await page.waitForURL(/.*articles\/\d+.*/);
		expect(page.url()).toMatch(/articles\/\d+/);
	});

	test.describe('Pagination', () => {
		test('should navigate to page 2 if pagination exists', async ({ page }) => {
			const hasPagination = await articlesPage.hasPagination();

			if (hasPagination) {
				await articlesPage.goToNextPage();

				const currentPage = articlesPage.getCurrentPageFromUrl();
				expect(currentPage).toBe(2);

				const hasItems = await articlesPage.hasListItems();
				expect(hasItems).toBeTruthy();
			} else {
				test.skip();
			}
		});
	});
});
```

## Критерии приемки

- [ ] AC-1: Page Objects созданы для всех трех типов списков
- [ ] AC-2: Page Objects наследуют от `ListBasePage` и переиспользуют логику
- [ ] AC-3: Тесты проверяют загрузку всех страниц списков
- [ ] AC-4: Тесты проверяют наличие элементов в каждом списке
- [ ] AC-5: Тесты проверяют отображение названий/заголовков
- [ ] AC-6: Тесты проверяют переход на детальные страницы
- [ ] AC-7: Тесты проверяют пагинацию для каждого списка (если есть)
- [ ] AC-8: Все тесты проходят на localhost:3000

## Как проверить

1. **Запустить все новые тесты:**

   ```bash
   npm run test:e2e -- services.spec.ts medicines.spec.ts articles.spec.ts
   ```

2. **Запустить каждый тест отдельно:**

   ```bash
   npm run test:e2e -- services.spec.ts
   npm run test:e2e -- medicines.spec.ts
   npm run test:e2e -- articles.spec.ts
   ```

3. **Запустить все тесты (включая предыдущие итерации):**

   ```bash
   npm run test:e2e
   ```

4. **Проверить покрытие:**

   - Тесты услуг: минимум 6 тестов
   - Тесты лекарств: минимум 6 тестов
   - Тесты статей: минимум 6 тестов
   - **Общее количество тестов:** 30+ (включая предыдущие итерации)

5. **Проверить отчет:**

   ```bash
   npm run test:e2e:report
   ```

6. **Проверить стабильность:**
   Запустить все новые тесты 3 раза подряд - не должно быть флаков

## Статус

**Not Started**

---

**Следующая итерация:** [5. Детальные страницы →](iteration-05-detail-pages.md)
