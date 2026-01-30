import { test, expect } from '@playwright/test';
import { MedicationListPage } from '../pages/lists/medication-list.page';
import { MedicationDetailPage } from '../pages/details/medication-detail.page';
import { LIST_PAGE_SIZE } from '../../common/constants';

test.describe('Medications List Page', () => {
	let medicationsPage: MedicationListPage;

	test.beforeEach(async ({ page }) => {
		medicationsPage = new MedicationListPage(page);
		await medicationsPage.goto();
		await medicationsPage.waitForResultsReady();
	});

	test('should load medications list page', async ({ page }) => {
		await expect(page).toHaveURL(/.*medications.*/);
	});

	test('should display medication cards', async () => {
		const hasItems = await medicationsPage.hasListItems();
		expect(hasItems).toBeTruthy();
	});

	test('should have at least one medication', async () => {
		const count = await medicationsPage.getListItemsCount();
		expect(count).toBeGreaterThan(0);
	});

	test('should display medication name', async () => {
		const name = await medicationsPage.getFirstMedicationName();
		expect(name).toBeTruthy();
		expect(name.length).toBeGreaterThan(0);
	});

	test('should navigate to medication detail page when clicked', async ({
		page,
	}) => {
		await medicationsPage.clickFirstItem();

		await page.waitForURL(/.*medications\/\d+.*/);
		expect(page.url()).toMatch(/medications\/\d+/);
	});

	test.describe('Pagination', () => {
		test('should navigate to page 2 and back', async ({ page }) => {
			const totalCount = await medicationsPage.getTotalCountFromTitle();
			if (!totalCount || totalCount <= LIST_PAGE_SIZE) {
				test.skip();
				return;
			}

			const hasSecondPage = await medicationsPage.hasPageNumber(2);
			if (!hasSecondPage) {
				test.skip();
				return;
			}

			const initialPage = await medicationsPage.getActivePageNumber();
			await medicationsPage.goToPage(2);
			await medicationsPage.waitForActivePageNumber(2);

			const currentPage = await medicationsPage.getActivePageNumber();
			expect(currentPage).toBe(2);

			const hasItems = await medicationsPage.hasListItems();
			expect(hasItems).toBeTruthy();

			await medicationsPage.goToPage(initialPage);
			await medicationsPage.waitForActivePageNumber(initialPage);
			const backToPage = await medicationsPage.getActivePageNumber();
			expect(backToPage).toBe(initialPage);
		});
	});
});

test.describe('Medication Detail Page', () => {
	let medicationDetailPage: MedicationDetailPage;
	let medicationsPage: MedicationListPage;

	test.beforeEach(async ({ page }) => {
		medicationsPage = new MedicationListPage(page);
		await medicationsPage.goto();
		await medicationsPage.waitForResultsReady();

		await medicationsPage.clickFirstItem();
		await page.waitForURL(/.*medications\/\d+.*/);
		medicationDetailPage = new MedicationDetailPage(page);
	});

	test('should load medication detail page', async ({ page }) => {
		await expect(page).toHaveURL(/.*medications\/\d+.*/);
	});

	test('should display medication name', async () => {
		const heading = await medicationDetailPage.getPageHeading();
		expect(heading).toBeTruthy();
		expect(heading.length).toBeGreaterThan(0);
	});

	test('should have main content', async () => {
		const hasContent = await medicationDetailPage.hasMainContent();
		expect(hasContent).toBeTruthy();
	});

	test('should have back to search button', async () => {
		await medicationDetailPage.waitForBackToSearchReady();
		await expect(
			medicationDetailPage.getBackToSearchButtonLocator(),
		).toBeVisible();
	});

	test('should navigate back to list when clicking back to search', async ({
		page,
	}) => {
		await medicationDetailPage.clickBackToSearch();

		await page.waitForURL(/.*medications(\/)?(\?.*)?$/, { timeout: 5000 });
		const url = page.url();
		expect(url).toMatch(/medications/);
		expect(url).not.toMatch(/medications\/\d+/);
	});
});
