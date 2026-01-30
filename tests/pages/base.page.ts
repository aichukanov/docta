import { Page } from '@playwright/test';

export class BasePage {
	constructor(protected page: Page) {}

	/**
	 * Перейти на страницу
	 */
	async goto(url: string) {
		try {
			await this.page.goto(url, {
				waitUntil: 'domcontentloaded',
				timeout: 30000,
			});
		} catch (error) {
			const message = error instanceof Error ? error.message : String(error);
			if (!message.includes('net::ERR_ABORTED')) {
				throw error;
			}
		}
		await this.page.waitForLoadState('domcontentloaded');
		await this.waitForCookieBanner();
	}

	/**
	 * Дождаться появления cookie-баннера, если он есть
	 */
	async waitForCookieBanner(): Promise<void> {
		const banner = this.page.locator('.cookie-banner');
		try {
			await banner.waitFor({ state: 'visible', timeout: 3000 });
		} catch {
			// Если баннер не появился, продолжаем
		}
	}

	/**
	 * Получить заголовок страницы
	 */
	async getTitle(): Promise<string> {
		return await this.page.title();
	}

	/**
	 * Проверить что элемент видим
	 */
	async isVisible(selector: string): Promise<boolean> {
		return await this.page.locator(selector).isVisible();
	}

	/**
	 * Кликнуть по элементу
	 */
	async click(selector: string) {
		await this.waitForCookieBanner();
		await this.page.locator(selector).click();
	}

	/**
	 * Получить текст элемента
	 */
	async getText(selector: string): Promise<string> {
		return (await this.page.locator(selector).textContent()) || '';
	}
}
