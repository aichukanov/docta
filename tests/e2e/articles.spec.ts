import { test, expect } from '@playwright/test';
import { ArticleListPage } from '../pages/lists/article-list.page';
import { ArticleDetailPage } from '../pages/details/article-detail.page';

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

	test('should display article description', async () => {
		const description = await articlesPage.getFirstArticleDescription();
		expect(description).toBeTruthy();
		expect(description.length).toBeGreaterThan(0);
	});

	test('should navigate to article page when clicked', async ({ page }) => {
		await articlesPage.clickFirstItem();

		await page.waitForURL(/.*articles\/.+/);
		expect(page.url()).toMatch(/articles\/.+/);
	});
});

test.describe('Article Detail Page', () => {
	let articleDetailPage: ArticleDetailPage;
	let articlesPage: ArticleListPage;
	let articleSlug: string | null;

	test.beforeEach(async ({ page }) => {
		articlesPage = new ArticleListPage(page);
		await articlesPage.goto();

		await articlesPage.clickFirstItem();
		articleDetailPage = new ArticleDetailPage(page);
		articleSlug = page.url().split('/articles/')[1] || null;
	});

	test('should load article detail page', async ({ page }) => {
		await expect(page).toHaveURL(/.*articles\/.+/);
	});

	test('should display article title', async () => {
		const heading = await articleDetailPage.getPageHeading();
		expect(heading).toBeTruthy();
		expect(heading.length).toBeGreaterThan(0);
	});

	test('should have article content', async () => {
		const hasContent = await articleDetailPage.hasArticleContent();
		expect(hasContent).toBeTruthy();
	});

	test('should navigate back to articles via breadcrumbs', async ({ page }) => {
		const breadcrumbsLink = page
			.locator('nav.app-breadcrumbs a.app-breadcrumbs__link[href="/articles"]')
			.first();

		await breadcrumbsLink.waitFor({ state: 'visible' });
		await breadcrumbsLink.click();

		await page.waitForURL(/.*articles(\/)?(\?.*)?$/);
		expect(page.url()).toMatch(/\/articles(\/)?(\?.*)?$/);
		if (articleSlug) {
			expect(page.url()).not.toContain(`/articles/${articleSlug}`);
		}
	});
});
