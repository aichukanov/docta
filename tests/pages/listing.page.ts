import type { Page, Locator } from '@playwright/test';
import { BasePage } from './base.page';
import type { ListingSection } from '../utils/sections';

/**
 * Страница-листинг. Один класс на все разделы: разметку задаёт
 * `components/list-page.vue`, различия карточек приезжают в `section`.
 */
export class ListingPage extends BasePage {
	constructor(
		page: Page,
		readonly section: ListingSection,
	) {
		super(page);
	}

	override async goto(url: string = this.section.url) {
		await super.goto(url);
	}

	getListItems(): Locator {
		return this.page.locator('.results-list-item');
	}

	async hasListItems(): Promise<boolean> {
		return (await this.getListItems().count()) > 0;
	}

	/**
	 * Дождаться готовности списка.
	 *
	 * `.loading-overlay` висит поверх уже отрисованного списка при смене
	 * страницы/фильтра, поэтому ждать надо именно его исчезновения, а не
	 * появления карточек.
	 */
	async waitForResultsReady(): Promise<void> {
		await this.page.locator('.list-content').waitFor({ state: 'visible' });
		await this.page.locator('.loading-overlay').waitFor({ state: 'hidden' });
	}

	async getListItemsCount(): Promise<number> {
		return await this.getListItems().count();
	}

	async getFirstItemName(): Promise<string> {
		const name = this.getListItems()
			.first()
			.locator(this.section.nameSelector)
			.first();
		return (await name.textContent())?.trim() || '';
	}

	/** Ссылка на детальную страницу внутри карточки */
	getFirstDetailLink(): Locator {
		return this.getListItems()
			.first()
			.locator(`a[href^="/${this.section.key}/"]`)
			.first();
	}

	async clickFirstItem() {
		await this.waitForCookieBanner();
		const link = this.getFirstDetailLink();
		await link.waitFor({ state: 'visible' });
		await link.click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	async hasPagination(): Promise<boolean> {
		return await this.page
			.locator('.el-pagination')
			.isVisible()
			.catch(() => false);
	}

	private pageButton(pageNumber: number): Locator {
		return this.page.locator(
			`.el-pagination .el-pager li.number[aria-label="page ${pageNumber}"]`,
		);
	}

	async goToPage(pageNumber: number) {
		await this.waitForCookieBanner();
		await this.waitForResultsReady();
		await this.pageButton(pageNumber).waitFor({ state: 'visible' });
		await this.pageButton(pageNumber).click();
		await this.waitForResultsReady();
	}

	async hasPageNumber(pageNumber: number): Promise<boolean> {
		await this.waitForCookieBanner();
		return await this.pageButton(pageNumber)
			.isVisible()
			.catch(() => false);
	}

	async waitForActivePageNumber(pageNumber: number): Promise<void> {
		await this.waitForCookieBanner();
		const selector = `.el-pagination .el-pager li.number[aria-label="page ${pageNumber}"]`;
		await this.page.locator(selector).waitFor({ state: 'visible' });
		await this.page.waitForFunction((targetSelector) => {
			const el = document.querySelector(targetSelector);
			return el?.getAttribute('aria-current') === 'true';
		}, selector);
	}

	async getActivePageNumber(): Promise<number> {
		const active = this.page
			.locator('.el-pagination .el-pager li[aria-current="true"]')
			.first();
		const label = await active.getAttribute('aria-label');
		const text = label || (await active.textContent()) || '';
		const parsed = Number.parseInt(text.match(/(\d+)/)?.[1] ?? '', 10);
		return Number.isNaN(parsed) ? 1 : parsed;
	}

	async hasEnabledNextPage(): Promise<boolean> {
		return await this.page
			.locator('.el-pagination .btn-next:not(.is-disabled)')
			.isVisible()
			.catch(() => false);
	}

	/** Общее число результатов из «Заголовок (123)» */
	async getTotalCountFromTitle(): Promise<number | null> {
		const title = (await this.page.locator('.page-title').textContent()) || '';
		const match = title.match(/\((\d+)\)/);
		return match ? Number.parseInt(match[1], 10) : null;
	}
}
