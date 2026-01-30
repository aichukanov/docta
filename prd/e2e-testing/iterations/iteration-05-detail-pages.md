# Итерация 5: Тесты детальных страниц и кнопки "К поиску"

[← К списку итераций](README.md) | [Предыдущая](iteration-04-services-medicines-articles.md) | [Следующая →](iteration-06-production-finalization.md)

---

## Цель

Создать тесты для детальных страниц всех сущностей и проверить работу кнопки "К поиску" / "Back to search".

## Зависимости

- Итерация 4 должна быть завершена

## Задачи

1. Создать базовый Page Object для детальных страниц
2. Создать Page Objects для детальных страниц всех сущностей
3. Добавить тесты детальных страниц в существующие spec файлы
4. Проверить кнопку "К поиску" на каждой детальной странице

## Технические детали

### 1. Создать файл: `tests/pages/details/detail-base.page.ts`

```typescript
import { Page } from '@playwright/test';
import { BasePage } from '../base.page';

export abstract class DetailBasePage extends BasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Получить заголовок детальной страницы
	 */
	abstract getPageHeading(): Promise<string>;

	/**
	 * Проверить что детальная страница загружена
	 */
	async isLoaded(): Promise<boolean> {
		const heading = await this.getPageHeading();
		return heading.length > 0;
	}

	/**
	 * Найти кнопку "К поиску" / "Back to search"
	 */
	private getBackToSearchButton() {
		return this.page
			.locator('[data-testid="back-to-search"]')
			.or(
				this.page.getByRole('link', {
					name: /к поиску|back to search|назад|back/i,
				}),
			)
			.or(
				this.page.locator('a[href*="?"]').filter({ hasText: /к поиску|back/i }),
			);
	}

	/**
	 * Проверить наличие кнопки "К поиску"
	 */
	async hasBackToSearchButton(): Promise<boolean> {
		try {
			return await this.getBackToSearchButton().isVisible();
		} catch {
			return false;
		}
	}

	/**
	 * Кликнуть по кнопке "К поиску"
	 */
	async clickBackToSearch() {
		await this.getBackToSearchButton().click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить что есть основной контент
	 */
	async hasMainContent(): Promise<boolean> {
		const main = this.page.locator('main, [role="main"], .main-content');
		return await main.isVisible();
	}
}
```

### 2. Создать файлы детальных страниц

**`tests/pages/details/clinic-detail.page.ts`:**

```typescript
import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class ClinicDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}

	async getClinicAddress(): Promise<string> {
		const address = await this.page
			.locator('[data-testid="clinic-address"]')
			.or(this.page.locator('.clinic-address, .address'))
			.first()
			.textContent();
		return address || '';
	}
}
```

**`tests/pages/details/doctor-detail.page.ts`:**

```typescript
import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class DoctorDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}

	async getDoctorSpecialty(): Promise<string> {
		const specialty = await this.page
			.locator('[data-testid="doctor-specialty"]')
			.or(this.page.locator('.specialty, .doctor-specialty'))
			.first()
			.textContent();
		return specialty || '';
	}
}
```

**`tests/pages/details/service-detail.page.ts`:**

```typescript
import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class ServiceDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}
}
```

**`tests/pages/details/medicine-detail.page.ts`:**

```typescript
import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class MedicineDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}
}
```

**`tests/pages/details/article-detail.page.ts`:**

```typescript
import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class ArticleDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}

	async hasArticleContent(): Promise<boolean> {
		const content = this.page
			.locator('[data-testid="article-content"]')
			.or(this.page.locator('.article-content, article .content'));
		return await content.isVisible();
	}
}
```

### 3. Добавить тесты детальных страниц

Обновить существующие spec файлы, добавив тесты детальных страниц.

**Добавить в `tests/e2e/clinics.spec.ts`:**

```typescript
import { ClinicDetailPage } from '../pages/details/clinic-detail.page';

test.describe('Clinic Detail Page', () => {
	let clinicDetailPage: ClinicDetailPage;
	let clinicsPage: ClinicListPage;

	test.beforeEach(async ({ page }) => {
		clinicsPage = new ClinicListPage(page);
		await clinicsPage.goto();

		// Переходим на детальную страницу первой клиники
		await clinicsPage.clickFirstItem();

		clinicDetailPage = new ClinicDetailPage(page);
	});

	test('should load clinic detail page', async ({ page }) => {
		await expect(page).toHaveURL(/.*clinics\/\d+.*/);
	});

	test('should display clinic name', async () => {
		const heading = await clinicDetailPage.getPageHeading();
		expect(heading).toBeTruthy();
		expect(heading.length).toBeGreaterThan(0);
	});

	test('should have main content', async () => {
		const hasContent = await clinicDetailPage.hasMainContent();
		expect(hasContent).toBeTruthy();
	});

	test('should have back to search button', async () => {
		const hasButton = await clinicDetailPage.hasBackToSearchButton();
		expect(hasButton).toBeTruthy();
	});

	test('should navigate back to list when clicking back to search', async ({
		page,
	}) => {
		await clinicDetailPage.clickBackToSearch();

		// Должны вернуться на страницу списка
		await page.waitForURL(/.*clinics.*/, { timeout: 5000 });

		const url = page.url();
		expect(url).toMatch(/clinics/);
		expect(url).not.toMatch(/clinics\/\d+/);
	});
});
```

**Добавить аналогичные тесты в:**

- `tests/e2e/doctors.spec.ts` - для `DoctorDetailPage`
- `tests/e2e/services.spec.ts` - для `ServiceDetailPage`
- `tests/e2e/medicines.spec.ts` - для `MedicineDetailPage`
- `tests/e2e/articles.spec.ts` - для `ArticleDetailPage`

Тесты будут очень похожими, меняется только тип страницы и URL паттерны.

### 4. Пример для врачей (добавить в `doctors.spec.ts`):

```typescript
test.describe('Doctor Detail Page', () => {
	let doctorDetailPage: DoctorDetailPage;
	let doctorsPage: DoctorListPage;

	test.beforeEach(async ({ page }) => {
		doctorsPage = new DoctorListPage(page);
		await doctorsPage.goto();
		await doctorsPage.clickFirstItem();

		doctorDetailPage = new DoctorDetailPage(page);
	});

	test('should load doctor detail page', async ({ page }) => {
		await expect(page).toHaveURL(/.*doctors\/\d+.*/);
	});

	test('should display doctor name', async () => {
		const heading = await doctorDetailPage.getPageHeading();
		expect(heading).toBeTruthy();
		expect(heading.length).toBeGreaterThan(0);
	});

	test('should have main content', async () => {
		const hasContent = await doctorDetailPage.hasMainContent();
		expect(hasContent).toBeTruthy();
	});

	test('should have back to search button', async () => {
		const hasButton = await doctorDetailPage.hasBackToSearchButton();
		expect(hasButton).toBeTruthy();
	});

	test('should navigate back to list when clicking back to search', async ({
		page,
	}) => {
		await doctorDetailPage.clickBackToSearch();

		await page.waitForURL(/.*doctors.*/, { timeout: 5000 });

		const url = page.url();
		expect(url).toMatch(/doctors/);
		expect(url).not.toMatch(/doctors\/\d+/);
	});
});
```

## Критерии приемки

- [ ] AC-1: Базовый класс `DetailBasePage` создан
- [ ] AC-2: Page Objects созданы для всех детальных страниц (5 штук)
- [ ] AC-3: Тесты проверяют загрузку детальных страниц
- [ ] AC-4: Тесты проверяют наличие заголовка на детальных страницах
- [ ] AC-5: Тесты проверяют наличие основного контента
- [ ] AC-6: Тесты проверяют наличие кнопки "К поиску" на всех детальных страницах
- [ ] AC-7: Тесты проверяют работу кнопки (возврат на список)
- [ ] AC-8: После клика по кнопке "К поиску" возвращаемся именно на список (не на главную)
- [ ] AC-9: Все тесты проходят на localhost:3000

## Как проверить

1. **Запустить все тесты:**

   ```bash
   npm run test:e2e
   ```

2. **Запустить тесты детальных страниц:**

   ```bash
   npm run test:e2e -- --grep "Detail Page"
   ```

3. **Запустить тесты кнопки "К поиску":**

   ```bash
   npm run test:e2e -- --grep "back to search"
   ```

4. **Проверить покрытие:**

   - Каждая детальная страница имеет минимум 5 тестов
   - **Общее количество тестов:** 50+ (включая все предыдущие итерации)

5. **Проверить стабильность:**

   ```bash
   # Запустить 3 раза подряд
   for i in {1..3}; do npm run test:e2e -- --grep "Detail Page"; done
   ```

6. **Проверить в headed режиме:**
   ```bash
   npm run test:e2e:headed -- clinics.spec.ts
   ```
   Визуально убедиться что:
   - Детальная страница загружается
   - Кнопка "К поиску" видна
   - Клик по кнопке возвращает на список

## Статус

**Completed**

---

**Следующая итерация:** [6. Продакшн и финализация →](iteration-06-production-finalization.md)
