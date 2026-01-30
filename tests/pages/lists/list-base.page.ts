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
	 * Дождаться готовности списка
	 */
	async waitForResultsReady(): Promise<void> {
		await this.page.locator('.list-content').waitFor({ state: 'visible' });
		await this.page.locator('.loading-overlay').waitFor({ state: 'hidden' });
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
		// Кликаем на ссылку внутри карточки
		const firstItem = this.getListItems().first();
		const link = firstItem.locator('a').first();
		await this.waitForCookieBanner();
		await link.waitFor({ state: 'visible' });
		await link.click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Кликнуть по элементу списка по индексу
	 */
	async clickItemByIndex(index: number) {
		const item = this.getListItems().nth(index);
		await this.waitForCookieBanner();
		await item.waitFor({ state: 'visible' });
		await item.click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить наличие пагинации
	 */
	async hasPagination(): Promise<boolean> {
		const pagination = this.page.locator('.el-pagination');

		try {
			return await pagination.isVisible();
		} catch {
			return false;
		}
	}

	/**
	 * Перейти на следующую страницу пагинации
	 */
	async goToNextPage() {
		const nextButton = this.page.locator(
			'.el-pagination .btn-next:not(.is-disabled)',
		);

		// Проверяем что кнопка существует и не disabled
		await this.waitForCookieBanner();
		await nextButton.waitFor({ state: 'visible' });
		await nextButton.click();
		await this.waitForResultsReady();
	}

	/**
	 * Перейти на предыдущую страницу пагинации
	 */
	async goToPreviousPage() {
		const prevButton = this.page.locator(
			'.el-pagination .btn-prev:not(.is-disabled)',
		);

		await this.waitForCookieBanner();
		await prevButton.waitFor({ state: 'visible' });
		await prevButton.click();
		await this.waitForResultsReady();
	}

	/**
	 * Перейти на конкретную страницу пагинации
	 */
	async goToPage(pageNumber: number) {
		const pageButton = this.page.locator(
			`.el-pagination .el-pager li.number[aria-label="page ${pageNumber}"]`,
		);

		await this.waitForCookieBanner();
		await this.waitForResultsReady();
		await pageButton.waitFor({ state: 'visible' });
		await pageButton.click();
		await this.waitForResultsReady();
	}

	/**
	 * Проверить что страница пагинации доступна
	 */
	async hasPageNumber(pageNumber: number): Promise<boolean> {
		const pageButton = this.page.locator(
			`.el-pagination .el-pager li.number[aria-label="page ${pageNumber}"]`,
		);
		await this.waitForCookieBanner();
		return await pageButton.isVisible().catch(() => false);
	}

	/**
	 * Дождаться активной страницы пагинации
	 */
	async waitForActivePageNumber(pageNumber: number): Promise<void> {
		await this.waitForCookieBanner();
		const selector = `.el-pagination .el-pager li.number[aria-label="page ${pageNumber}"]`;
		await this.page.locator(selector).waitFor({ state: 'visible' });
		await this.page.waitForFunction((targetSelector) => {
			const el = document.querySelector(targetSelector);
			return el?.getAttribute('aria-current') === 'true';
		}, selector);
	}

	/**
	 * Получить текущий номер страницы по активной кнопке
	 */
	async getActivePageNumber(): Promise<number> {
		const active = this.page.locator(
			'.el-pagination .el-pager li[aria-current="true"]',
		);
		const label = await active.first().getAttribute('aria-label');
		const text = label || (await active.first().textContent()) || '';
		const match = text.match(/(\d+)/);
		const parsed = match ? Number.parseInt(match[1], 10) : Number.NaN;
		return Number.isNaN(parsed) ? 1 : parsed;
	}

	/**
	 * Проверить что есть активная кнопка следующей страницы
	 */
	async hasEnabledNextPage(): Promise<boolean> {
		const nextButton = this.page.locator(
			'.el-pagination .btn-next:not(.is-disabled)',
		);
		return await nextButton.isVisible().catch(() => false);
	}

	/**
	 * Получить общее количество результатов из заголовка
	 */
	async getTotalCountFromTitle(): Promise<number | null> {
		const title = (await this.page.locator('.page-title').textContent()) || '';
		const match = title.match(/\((\d+)\)/);
		return match ? Number.parseInt(match[1], 10) : null;
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
