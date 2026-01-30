import { Page, Locator } from '@playwright/test';
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
	protected getBackToSearchButton(): Locator {
		return this.page
			.locator('.details-page-header')
			.locator('.el-button, button')
			.first();
	}

	getBackToSearchButtonLocator(): Locator {
		return this.getBackToSearchButton();
	}

	async waitForBackToSearchReady(): Promise<void> {
		await this.page.locator('.details-page-header').waitFor({ state: 'visible' });
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
		await this.waitForCookieBanner();
		await this.getBackToSearchButton().click({ force: true });
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить что есть основной контент
	 */
	async hasMainContent(): Promise<boolean> {
		const main = this.page.locator('[role="main"], main, .details-page');
		return await main.isVisible();
	}
}
