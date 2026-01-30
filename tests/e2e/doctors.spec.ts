import { test, expect } from '@playwright/test';
import { DoctorListPage } from '../pages/lists/doctor-list.page';
import { DoctorDetailPage } from '../pages/details/doctor-detail.page';
import { LIST_PAGE_SIZE } from '../../common/constants';

test.describe('Doctors List Page', () => {
	let doctorsPage: DoctorListPage;

	test.beforeEach(async ({ page }) => {
		doctorsPage = new DoctorListPage(page);
		await doctorsPage.goto();
		await doctorsPage.waitForResultsReady();
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
			const hasPagination = await doctorsPage.hasPagination();
			expect(hasPagination).toBeTruthy();

			const totalCount = await doctorsPage.getTotalCountFromTitle();
			const listCount = await doctorsPage.getListItemsCount();
			if (totalCount && totalCount > listCount) {
				const hasNextPage = await doctorsPage.hasEnabledNextPage();
				expect(hasNextPage).toBeTruthy();
			}
		});

		test('should navigate to page 2 and back', async ({ page }) => {
			const totalCount = await doctorsPage.getTotalCountFromTitle();
			if (!totalCount || totalCount <= LIST_PAGE_SIZE) {
				test.skip();
				return;
			}

			const hasSecondPage = await doctorsPage.hasPageNumber(2);
			if (!hasSecondPage) {
				test.skip();
				return;
			}

			const initialPage = await doctorsPage.getActivePageNumber();
			await doctorsPage.goToPage(2);
			await doctorsPage.waitForActivePageNumber(2);

			const currentPage = await doctorsPage.getActivePageNumber();
			expect(currentPage).toBe(2);

			const hasItems = await doctorsPage.hasListItems();
			expect(hasItems).toBeTruthy();

			await doctorsPage.goToPage(initialPage);
			await doctorsPage.waitForActivePageNumber(initialPage);
			const backToPage = await doctorsPage.getActivePageNumber();
			expect(backToPage).toBe(initialPage);
		});
	});
});

test.describe('Doctor Detail Page', () => {
	let doctorDetailPage: DoctorDetailPage;
	let doctorsPage: DoctorListPage;

	test.beforeEach(async ({ page }) => {
		doctorsPage = new DoctorListPage(page);
		await doctorsPage.goto();
		await doctorsPage.waitForResultsReady();

		await doctorsPage.clickFirstItem();
		await page.waitForURL(/.*doctors\/\d+.*/);
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
		await doctorDetailPage.waitForBackToSearchReady();
		await expect(
			doctorDetailPage.getBackToSearchButtonLocator(),
		).toBeVisible();
	});

	test('should navigate back to list when clicking back to search', async ({
		page,
	}) => {
		await doctorDetailPage.clickBackToSearch();

		await page.waitForURL(/.*doctors(\/)?(\?.*)?$/, { timeout: 5000 });
		const url = page.url();
		expect(url).toMatch(/doctors/);
		expect(url).not.toMatch(/doctors\/\d+/);
	});
});
