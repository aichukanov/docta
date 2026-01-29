# Итерация 3: Тесты списков клиник и врачей

[← К списку итераций](README.md) | [Предыдущая](iteration-02-home-navigation.md) | [Следующая →](iteration-04-services-medicines-articles.md)

---

## Цель

Создать тесты для страниц списков клиник и врачей, включая пагинацию и переход на детальные страницы.

## Зависимости

- Итерация 2 должна быть завершена

## Задачи

1. Создать базовый Page Object для списков с пагинацией
2. Создать Page Object для списка клиник
3. Создать Page Object для списка врачей
4. Написать тесты для списка клиник
5. Написать тесты для списка врачей

## Технические детали

### 1. Создать файл: `tests/pages/lists/list-base.page.ts`

```typescript
import { Page, Locator } from '@playwright/test';
import { BasePage } from '../base.page';

export abstract class ListBasePage extends BasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Получить все элементы списка
	 */
	abstract getListItems(): Locator;

	/**
	 * Проверить что список загружен и содержит элементы
	 */
	async hasListItems(): Promise<boolean> {
		const count = await this.getListItems().count();
		return count > 0;
	}

	/**
	 * Получить количество элементов в списке
	 */
	async getListItemsCount(): Promise<number> {
		return await this.getListItems().count();
	}

	/**
	 * Кликнуть по первому элементу списка
	 */
	async clickFirstItem() {
		await this.getListItems().first().click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Кликнуть по элементу списка по индексу
	 */
	async clickItemByIndex(index: number) {
		await this.getListItems().nth(index).click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить наличие пагинации
	 */
	async hasPagination(): Promise<boolean> {
		const pagination = this.page
			.locator('[data-testid="pagination"]')
			.or(this.page.locator('.pagination'))
			.or(this.page.locator('nav[aria-label*="pagination"]'));

		return await pagination.isVisible();
	}

	/**
	 * Перейти на следующую страницу пагинации
	 */
	async goToNextPage() {
		const nextButton = this.page
			.locator('[data-testid="pagination-next"]')
			.or(this.page.getByRole('button', { name: /next|след|>|›/i }))
			.or(this.page.locator('.pagination a[rel="next"]'));

		await nextButton.click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Перейти на предыдущую страницу пагинации
	 */
	async goToPreviousPage() {
		const prevButton = this.page
			.locator('[data-testid="pagination-prev"]')
			.or(this.page.getByRole('button', { name: /prev|пред|<|‹/i }))
			.or(this.page.locator('.pagination a[rel="prev"]'));

		await prevButton.click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Перейти на конкретную страницу пагинации
	 */
	async goToPage(pageNumber: number) {
		const pageButton = this.page
			.getByRole('button', { name: pageNumber.toString() })
			.or(this.page.locator(`.pagination a:has-text("${pageNumber}")`));

		await pageButton.click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Получить текущий номер страницы из URL
	 */
	getCurrentPageFromUrl(): number {
		const url = this.page.url();
		const match = url.match(/[?&]page=(\d+)/);
		return match ? parseInt(match[1]) : 1;
	}
}
```

### 2. Создать файл: `tests/pages/lists/clinic-list.page.ts`

```typescript
import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class ClinicListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Перейти на страницу списка клиник
	 */
	async goto() {
		await super.goto(URLS.CLINICS);
	}

	/**
	 * Получить все карточки клиник
	 */
	getListItems(): Locator {
		return this.page
			.locator('[data-testid="clinic-card"]')
			.or(this.page.locator('.clinic-card'))
			.or(
				this.page
					.locator('article')
					.filter({ has: this.page.locator('a[href*="/clinics/"]') }),
			);
	}

	/**
	 * Получить название первой клиники
	 */
	async getFirstClinicName(): Promise<string> {
		const firstItem = this.getListItems().first();
		return (
			(await firstItem.locator('h2, h3, .clinic-name').first().textContent()) ||
			''
		);
	}
}
```

### 3. Создать файл: `tests/pages/lists/doctor-list.page.ts`

```typescript
import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class DoctorListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Перейти на страницу списка врачей
	 */
	async goto() {
		await super.goto(URLS.DOCTORS);
	}

	/**
	 * Получить все карточки врачей
	 */
	getListItems(): Locator {
		return this.page
			.locator('[data-testid="doctor-card"]')
			.or(this.page.locator('.doctor-card'))
			.or(
				this.page
					.locator('article')
					.filter({ has: this.page.locator('a[href*="/doctors/"]') }),
			);
	}

	/**
	 * Получить имя первого врача
	 */
	async getFirstDoctorName(): Promise<string> {
		const firstItem = this.getListItems().first();
		return (
			(await firstItem.locator('h2, h3, .doctor-name').first().textContent()) ||
			''
		);
	}
}
```

### 4. Создать файл: `tests/e2e/clinics.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { ClinicListPage } from '../pages/lists/clinic-list.page';

test.describe('Clinics List Page', () => {
	let clinicsPage: ClinicListPage;

	test.beforeEach(async ({ page }) => {
		clinicsPage = new ClinicListPage(page);
		await clinicsPage.goto();
	});

	test('should load clinics list page', async ({ page }) => {
		await expect(page).toHaveURL(/.*clinics.*/);
	});

	test('should display clinic cards', async () => {
		const hasItems = await clinicsPage.hasListItems();
		expect(hasItems).toBeTruthy();
	});

	test('should have at least one clinic', async () => {
		const count = await clinicsPage.getListItemsCount();
		expect(count).toBeGreaterThan(0);
	});

	test('should display clinic name', async () => {
		const name = await clinicsPage.getFirstClinicName();
		expect(name).toBeTruthy();
		expect(name.length).toBeGreaterThan(0);
	});

	test('should navigate to clinic detail page when clicked', async ({
		page,
	}) => {
		await clinicsPage.clickFirstItem();

		// Проверяем что перешли на детальную страницу
		await page.waitForURL(/.*clinics\/\d+.*/);
		expect(page.url()).toMatch(/clinics\/\d+/);
	});

	test.describe('Pagination', () => {
		test('should have pagination if more than one page', async () => {
			const itemsCount = await clinicsPage.getListItemsCount();

			// Если элементов много, должна быть пагинация
			if (itemsCount >= 10) {
				const hasPagination = await clinicsPage.hasPagination();
				expect(hasPagination).toBeTruthy();
			}
		});

		test('should navigate to page 2 and back', async ({ page }) => {
			// Проверяем есть ли пагинация
			const hasPagination = await clinicsPage.hasPagination();

			if (hasPagination) {
				// Переходим на страницу 2
				await clinicsPage.goToNextPage();

				// Проверяем URL
				const currentPage = clinicsPage.getCurrentPageFromUrl();
				expect(currentPage).toBe(2);

				// Проверяем что список обновился
				const hasItems = await clinicsPage.hasListItems();
				expect(hasItems).toBeTruthy();

				// Возвращаемся на страницу 1
				await clinicsPage.goToPreviousPage();
				const backToPage = clinicsPage.getCurrentPageFromUrl();
				expect(backToPage).toBe(1);
			} else {
				test.skip();
			}
		});

		test('should change URL when navigating pages', async ({ page }) => {
			const hasPagination = await clinicsPage.hasPagination();

			if (hasPagination) {
				const initialUrl = page.url();

				await clinicsPage.goToNextPage();

				const newUrl = page.url();
				expect(newUrl).not.toBe(initialUrl);
				expect(newUrl).toContain('page=2');
			} else {
				test.skip();
			}
		});
	});
});
```

### 5. Создать файл: `tests/e2e/doctors.spec.ts`

```typescript
import { test, expect } from '@playwright/test';
import { DoctorListPage } from '../pages/lists/doctor-list.page';

test.describe('Doctors List Page', () => {
	let doctorsPage: DoctorListPage;

	test.beforeEach(async ({ page }) => {
		doctorsPage = new DoctorListPage(page);
		await doctorsPage.goto();
	});

	test('should load doctors list page', async ({ page }) => {
		await expect(page).toHaveURL(/.*doctors.*/);
	});

	test('should display doctor cards', async () => {
		const hasItems = await doctorsPage.hasListItems();
		expect(hasItems).toBeTruthy();
	});

	test('should have at least one doctor', async () => {
		const count = await doctorsPage.getListItemsCount();
		expect(count).toBeGreaterThan(0);
	});

	test('should display doctor name', async () => {
		const name = await doctorsPage.getFirstDoctorName();
		expect(name).toBeTruthy();
		expect(name.length).toBeGreaterThan(0);
	});

	test('should navigate to doctor detail page when clicked', async ({
		page,
	}) => {
		await doctorsPage.clickFirstItem();

		// Проверяем что перешли на детальную страницу
		await page.waitForURL(/.*doctors\/\d+.*/);
		expect(page.url()).toMatch(/doctors\/\d+/);
	});

	test.describe('Pagination', () => {
		test('should have pagination if more than one page', async () => {
			const itemsCount = await doctorsPage.getListItemsCount();

			if (itemsCount >= 10) {
				const hasPagination = await doctorsPage.hasPagination();
				expect(hasPagination).toBeTruthy();
			}
		});

		test('should navigate to page 2 and back', async ({ page }) => {
			const hasPagination = await doctorsPage.hasPagination();

			if (hasPagination) {
				await doctorsPage.goToNextPage();

				const currentPage = doctorsPage.getCurrentPageFromUrl();
				expect(currentPage).toBe(2);

				const hasItems = await doctorsPage.hasListItems();
				expect(hasItems).toBeTruthy();

				await doctorsPage.goToPreviousPage();
				const backToPage = doctorsPage.getCurrentPageFromUrl();
				expect(backToPage).toBe(1);
			} else {
				test.skip();
			}
		});

		test('should change URL when navigating pages', async ({ page }) => {
			const hasPagination = await doctorsPage.hasPagination();

			if (hasPagination) {
				const initialUrl = page.url();

				await doctorsPage.goToNextPage();

				const newUrl = page.url();
				expect(newUrl).not.toBe(initialUrl);
				expect(newUrl).toContain('page=2');
			} else {
				test.skip();
			}
		});
	});
});
```

## Критерии приемки

- [ ] AC-1: Базовый класс `ListBasePage` создан с общей логикой
- [ ] AC-2: Page Objects созданы для списков клиник и врачей
- [ ] AC-3: Тесты проверяют загрузку страниц списков
- [ ] AC-4: Тесты проверяют наличие элементов в списках
- [ ] AC-5: Тесты проверяют отображение названий (клиник/врачей)
- [ ] AC-6: Тесты проверяют переход на детальную страницу из списка
- [ ] AC-7: Тесты проверяют пагинацию (переход между страницами)
- [ ] AC-8: Тесты проверяют изменение URL при пагинации
- [ ] AC-9: Все тесты проходят на localhost:3000

## Как проверить

1. **Запустить все тесты:**

   ```bash
   npm run test:e2e
   ```

2. **Запустить только тесты клиник:**

   ```bash
   npm run test:e2e -- clinics.spec.ts
   ```

3. **Запустить только тесты врачей:**

   ```bash
   npm run test:e2e -- doctors.spec.ts
   ```

4. **Запустить в headed режиме:**

   ```bash
   npm run test:e2e:headed -- clinics.spec.ts
   ```

5. **Проверить покрытие:**

   - Тесты клиник: минимум 8 тестов проходит
   - Тесты врачей: минимум 8 тестов проходит
   - Пагинация работает (если есть достаточно данных)

6. **Проверить стабильность:**
   ```bash
   # Запустить 3 раза подряд
   npm run test:e2e -- clinics.spec.ts
   npm run test:e2e -- clinics.spec.ts
   npm run test:e2e -- clinics.spec.ts
   ```
   Все прогоны должны проходить успешно (нет флаков)

## Статус

**Not Started**

---

**Следующая итерация:** [4. Списки услуг, лекарств и статей →](iteration-04-services-medicines-articles.md)
