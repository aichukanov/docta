import { test, expect } from '@playwright/test';
import { ServiceListPage } from '../pages/lists/service-list.page';
import { ServiceDetailPage } from '../pages/details/service-detail.page';
import { LIST_PAGE_SIZE } from '../../common/constants';

test.describe('Services List Page', () => {
	let servicesPage: ServiceListPage;

	test.beforeEach(async ({ page }) => {
		servicesPage = new ServiceListPage(page);
		await servicesPage.goto();
		await servicesPage.waitForResultsReady();
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
		test('should navigate to page 2 and back', async ({ page }) => {
			const totalCount = await servicesPage.getTotalCountFromTitle();
			if (!totalCount || totalCount <= LIST_PAGE_SIZE) {
				test.skip();
				return;
			}

			const hasSecondPage = await servicesPage.hasPageNumber(2);
			if (!hasSecondPage) {
				test.skip();
				return;
			}

			const initialPage = await servicesPage.getActivePageNumber();
			await servicesPage.goToPage(2);
			await servicesPage.waitForActivePageNumber(2);

			const currentPage = await servicesPage.getActivePageNumber();
			expect(currentPage).toBe(2);

			const hasItems = await servicesPage.hasListItems();
			expect(hasItems).toBeTruthy();

			await servicesPage.goToPage(initialPage);
			await servicesPage.waitForActivePageNumber(initialPage);
			const backToPage = await servicesPage.getActivePageNumber();
			expect(backToPage).toBe(initialPage);
		});
	});
});

test.describe('Service Detail Page', () => {
	let serviceDetailPage: ServiceDetailPage;
	let servicesPage: ServiceListPage;

	test.beforeEach(async ({ page }) => {
		servicesPage = new ServiceListPage(page);
		await servicesPage.goto();
		await servicesPage.waitForResultsReady();

		await servicesPage.clickFirstItem();
		await page.waitForURL(/.*services\/\d+.*/);
		serviceDetailPage = new ServiceDetailPage(page);
	});

	test('should load service detail page', async ({ page }) => {
		await expect(page).toHaveURL(/.*services\/\d+.*/);
	});

	test('should display service name', async () => {
		const heading = await serviceDetailPage.getPageHeading();
		expect(heading).toBeTruthy();
		expect(heading.length).toBeGreaterThan(0);
	});

	test('should have main content', async () => {
		const hasContent = await serviceDetailPage.hasMainContent();
		expect(hasContent).toBeTruthy();
	});

	test('should have back to search button', async () => {
		await serviceDetailPage.waitForBackToSearchReady();
		await expect(
			serviceDetailPage.getBackToSearchButtonLocator(),
		).toBeVisible();
	});

	test('should navigate back to list when clicking back to search', async ({
		page,
	}) => {
		await serviceDetailPage.clickBackToSearch();

		await page.waitForURL(/.*services(\/)?(\?.*)?$/, { timeout: 5000 });
		const url = page.url();
		expect(url).toMatch(/services/);
		expect(url).not.toMatch(/services\/\d+/);
	});
});
