import { test, expect } from '@playwright/test';
import { ListingPage } from '../pages/listing.page';
import { EntityDetailPage } from '../pages/entity-detail.page';
import {
	LISTING_SECTIONS,
	detailUrlPattern,
	listUrlPattern,
} from '../utils/sections';
import { LIST_PAGE_SIZE } from '../../common/constants';

// Общий контракт всех семи листингов и их детальных страниц.
// Разделы различаются только разметкой карточки (см. tests/utils/sections.ts),
// поэтому раньше это были четыре почти одинаковых файла — и три раздела
// (labtests, medicines, insurance-companies) не были покрыты вовсе.

for (const section of LISTING_SECTIONS) {
	test.describe(`Листинг ${section.url}`, () => {
		let listing: ListingPage;

		test.beforeEach(async ({ page }) => {
			listing = new ListingPage(page, section);
			await listing.goto();
			await listing.waitForResultsReady();
		});

		test('открывается', async ({ page }) => {
			await expect(page).toHaveURL(listUrlPattern(section.key));
		});

		test('показывает карточки', async () => {
			expect(await listing.getListItemsCount()).toBeGreaterThan(0);
		});

		test('у первой карточки есть название', async () => {
			const name = await listing.getFirstItemName();
			expect(name.length).toBeGreaterThan(0);
		});

		test('заголовок содержит количество результатов', async () => {
			const total = await listing.getTotalCountFromTitle();
			expect(total).not.toBeNull();
			expect(total!).toBeGreaterThan(0);
		});

		test('переходит на детальную страницу по клику', async ({ page }) => {
			await listing.clickFirstItem();
			await page.waitForURL(detailUrlPattern(section.key));
			// Числовой ID отдаёт 301 на слаг, в адресной строке его быть не должно
			expect(page.url()).toMatch(detailUrlPattern(section.key));
		});

		test('пагинация ведёт на страницу 2 и обратно', async () => {
			const total = await listing.getTotalCountFromTitle();
			if (!total || total <= LIST_PAGE_SIZE) {
				test.skip();
				return;
			}

			expect(await listing.hasPagination()).toBeTruthy();
			expect(await listing.hasEnabledNextPage()).toBeTruthy();

			if (!(await listing.hasPageNumber(2))) {
				test.skip();
				return;
			}

			const initialPage = await listing.getActivePageNumber();
			await listing.goToPage(2);
			await listing.waitForActivePageNumber(2);
			expect(await listing.getActivePageNumber()).toBe(2);
			expect(await listing.getListItemsCount()).toBeGreaterThan(0);

			await listing.goToPage(initialPage);
			await listing.waitForActivePageNumber(initialPage);
			expect(await listing.getActivePageNumber()).toBe(initialPage);
		});
	});

	test.describe(`Детальная страница ${section.url}/…`, () => {
		let detail: EntityDetailPage;

		test.beforeEach(async ({ page }) => {
			const listing = new ListingPage(page, section);
			await listing.goto();
			await listing.waitForResultsReady();
			await listing.clickFirstItem();
			await page.waitForURL(detailUrlPattern(section.key));
			detail = new EntityDetailPage(page);
			await detail.waitForLoaded();
		});

		test('показывает h1', async () => {
			expect((await detail.getPageHeading()).length).toBeGreaterThan(0);
		});

		test('есть основной контент', async () => {
			await expect(detail.getRoot()).toBeVisible();
			await expect(detail.getRoot()).toHaveAttribute('role', 'main');
		});

		test('есть кнопка «к поиску»', async () => {
			await expect(detail.getBackToSearchButton()).toBeVisible();
		});

		test('кнопка «к поиску» возвращает на листинг', async ({ page }) => {
			await detail.clickBackToSearch();
			await page.waitForURL(listUrlPattern(section.key));
			expect(page.url()).not.toMatch(detailUrlPattern(section.key));
		});

		test('отдаёт 200 и canonical на себя', async ({ page }) => {
			const url = page.url();
			const canonical = await page
				.locator('link[rel="canonical"]')
				.getAttribute('href');
			expect(canonical).toBeTruthy();
			expect(canonical).toContain(new URL(url).pathname);
		});
	});
}
