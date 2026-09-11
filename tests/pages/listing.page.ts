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
			.locator('.kit-pagination')
			.isVisible()
			.catch(() => false);
	}

	/*
	 * Номер страницы ищется по тексту, а не по aria-label: подписи приходят
	 * из словаря приложения и на сербском выглядят как «Stranica 2».
	 * На листингах номер — ссылка (`<a href>`), в попапе карты — кнопка;
	 * общий у них класс, поэтому селектор по нему.
	 */
	private pageButton(pageNumber: number): Locator {
		return this.page
			.locator('.kit-pagination .kit-pagination__item')
			.filter({ hasText: new RegExp(`^${pageNumber}$`) });
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
		const active = this.pageButton(pageNumber).and(
			this.page.locator('[aria-current="page"]'),
		);
		await active.waitFor({ state: 'visible' });
	}

	async getActivePageNumber(): Promise<number> {
		const active = this.page
			.locator('.kit-pagination .kit-pagination__item[aria-current="page"]')
			.first();
		const text = (await active.textContent()) || '';
		const parsed = Number.parseInt(text.match(/(\d+)/)?.[1] ?? '', 10);
		return Number.isNaN(parsed) ? 1 : parsed;
	}

	async hasEnabledNextPage(): Promise<boolean> {
		return await this.page
			.locator('.kit-pagination__item--next:not(:disabled)')
			.isVisible()
			.catch(() => false);
	}

	/**
	 * Ссылка на N-ю страницу прямо из разметки — без клика и без JS.
	 *
	 * Нужна проверке краулимости: номера обязаны быть `<a href>` уже
	 * в серверном HTML (FR-10 в prd/element-plus-removal).
	 */
	async getPageHref(pageNumber: number): Promise<string | null> {
		return await this.pageButton(pageNumber).getAttribute('href');
	}

	/**
	 * Общее число результатов из шапки листинга.
	 *
	 * Счётчик переехал из «Заголовок (123)» в отдельную пилюлю рядом с `h1`
	 * (`components/list-page.vue`) — заголовок остался заголовком. Старую
	 * форму продолжаем разбирать: `pageTitleBase` необязателен, и страница без
	 * него по-прежнему рисует счётчик внутри заголовка.
	 */
	async getTotalCountFromHeader(): Promise<number | null> {
		const pill = this.page.locator('.page-title-row .kit-tag').first();

		if (await pill.count()) {
			const digits = ((await pill.textContent()) || '').replace(/\D/g, '');
			if (digits) {
				return Number.parseInt(digits, 10);
			}
		}

		const title = (await this.page.locator('.page-title').textContent()) || '';
		const match = title.match(/\((\d+)\)/);
		return match ? Number.parseInt(match[1], 10) : null;
	}
}
