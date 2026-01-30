import { test, expect } from '@playwright/test';
import { ClinicListPage } from '../pages/lists/clinic-list.page';
import { ClinicDetailPage } from '../pages/details/clinic-detail.page';
import { LIST_PAGE_SIZE } from '../../common/constants';

test.describe('Clinics List Page', () => {
	let clinicsPage: ClinicListPage;

	test.beforeEach(async ({ page }) => {
		clinicsPage = new ClinicListPage(page);
		await clinicsPage.goto();
		await clinicsPage.waitForResultsReady();
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
			const hasPagination = await clinicsPage.hasPagination();
			expect(hasPagination).toBeTruthy();

			const totalCount = await clinicsPage.getTotalCountFromTitle();
			const listCount = await clinicsPage.getListItemsCount();
			if (totalCount && totalCount > listCount) {
				const hasNextPage = await clinicsPage.hasEnabledNextPage();
				expect(hasNextPage).toBeTruthy();
			}
		});

		test('should navigate to page 2 and back', async ({ page }) => {
			const totalCount = await clinicsPage.getTotalCountFromTitle();
			if (!totalCount || totalCount <= LIST_PAGE_SIZE) {
				test.skip();
				return;
			}

			const hasSecondPage = await clinicsPage.hasPageNumber(2);
			if (!hasSecondPage) {
				test.skip();
				return;
			}

			// Переходим на страницу 2
			const initialPage = await clinicsPage.getActivePageNumber();
			await clinicsPage.goToPage(2);
			await clinicsPage.waitForActivePageNumber(2);

			const currentPage = await clinicsPage.getActivePageNumber();
			expect(currentPage).toBe(2);

			// Проверяем что список обновился
			const hasItems = await clinicsPage.hasListItems();
			expect(hasItems).toBeTruthy();

			// Возвращаемся на страницу 1
			await clinicsPage.goToPage(initialPage);
			await clinicsPage.waitForActivePageNumber(initialPage);
			const backToPage = await clinicsPage.getActivePageNumber();
			expect(backToPage).toBe(initialPage);
		});
	});
});

test.describe('Clinic Detail Page', () => {
	let clinicDetailPage: ClinicDetailPage;
	let clinicsPage: ClinicListPage;

	test.beforeEach(async ({ page }) => {
		clinicsPage = new ClinicListPage(page);
		await clinicsPage.goto();
		await clinicsPage.waitForResultsReady();

		await clinicsPage.clickFirstItem();
		await page.waitForURL(/.*clinics\/\d+.*/);
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
		await clinicDetailPage.waitForBackToSearchReady();
		await expect(
			clinicDetailPage.getBackToSearchButtonLocator(),
		).toBeVisible();
	});

	test('should navigate back to list when clicking back to search', async ({
		page,
	}) => {
		await clinicDetailPage.clickBackToSearch();

		await page.waitForURL(/.*clinics(\/)?(\?.*)?$/, { timeout: 5000 });
		const url = page.url();
		expect(url).toMatch(/clinics/);
		expect(url).not.toMatch(/clinics\/\d+/);
	});
});
