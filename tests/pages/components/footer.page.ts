import { Page } from '@playwright/test';

export class FooterComponent {
	constructor(private page: Page) {}

	private async waitForCookieBanner(): Promise<void> {
		const banner = this.page.locator('.cookie-banner');
		try {
			await banner.waitFor({ state: 'visible', timeout: 3000 });
		} catch {
			// Баннер может не появиться
		}
	}

	/**
	 * Получить ссылку в футере по тексту
	 */
	private getFooterLinkByHref(href: string) {
		return this.page.locator(`footer a[href="${href}"]`);
	}

	/**
	 * Кликнуть по ссылке в футере
	 */
	async clickFooterLink(linkHref: string) {
		await this.waitForCookieBanner();
		await this.getFooterLinkByHref(linkHref).click();
		await this.page.waitForURL(new RegExp(linkHref.replace('/', '\\/')));
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить что ссылка в футере видима
	 */
	async isFooterLinkVisible(linkHref: string): Promise<boolean> {
		try {
			return await this.getFooterLinkByHref(linkHref).isVisible();
		} catch {
			return false;
		}
	}

	/**
	 * Получить все ссылки навигации футера
	 */
	async getFooterNavLinks(): Promise<string[]> {
		const links = await this.page.locator('.footer-nav .footer-link').all();
		const hrefs = await Promise.all(links.map((link) => link.getAttribute('href')));
		return hrefs.filter((href) => href !== null && href.trim() !== '') as string[];
	}

	/**
	 * Получить все контактные ссылки
	 */
	async getContactLinks(): Promise<string[]> {
		const links = await this.page.locator('.footer-contacts .footer-contact').all();
		const hrefs = await Promise.all(links.map((link) => link.getAttribute('href')));
		return hrefs.filter((href) => href !== null && href.trim() !== '') as string[];
	}

	/**
	 * Проверить что футер видим
	 */
	async isVisible(): Promise<boolean> {
		return await this.page.locator('footer').isVisible();
	}

	/**
	 * Получить текст копирайта
	 */
	async getCopyrightText(): Promise<string> {
		return (
			(await this.page
				.locator('.footer-bottom__muted')
				.first()
				.textContent()) || ''
		).trim();
	}
}
