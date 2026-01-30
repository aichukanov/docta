import { Page } from '@playwright/test';

export class HeaderComponent {
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
	 * Получить ссылку навигации по тексту
	 */
	private getNavLinkByHref(href: string) {
		return this.page.locator(`.app-header__nav-link[href="${href}"]`);
	}

	/**
	 * Кликнуть по ссылке в навигации
	 */
	async clickNavLink(linkHref: string) {
		await this.waitForCookieBanner();
		await this.getNavLinkByHref(linkHref).click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Проверить что ссылка навигации видима
	 */
	async isNavLinkVisible(linkHref: string): Promise<boolean> {
		try {
			return await this.getNavLinkByHref(linkHref).isVisible();
		} catch {
			return false;
		}
	}

	/**
	 * Получить все ссылки навигации
	 */
	async getNavLinks(): Promise<string[]> {
		const links = await this.page.locator('.app-header__nav-link').all();
		const hrefs = await Promise.all(links.map((link) => link.getAttribute('href')));
		return hrefs.filter((href) => href !== null && href.trim() !== '') as string[];
	}

	/**
	 * Проверить что хедер видим
	 */
	async isVisible(): Promise<boolean> {
		return await this.page.locator('.app-header').isVisible();
	}

	/**
	 * Кликнуть по логотипу
	 */
	async clickLogo() {
		await this.waitForCookieBanner();
		await this.page.locator('.app-header__logo').click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Получить селектор языка
	 */
	getLanguageSwitcher() {
		return this.page.locator('.language-switcher-wrapper');
	}

	/**
	 * Открыть переключатель языка
	 */
	async openLanguageSwitcher() {
		// Кликаем по input внутри el-select
		await this.waitForCookieBanner();
		await this.getLanguageSwitcher().locator('input').click();
		// Ждем появления выпадающего списка
		await this.page.waitForTimeout(800);
	}

	/**
	 * Выбрать язык
	 */
	async selectLanguage(language: string) {
		await this.openLanguageSwitcher();
		// Element Plus рендерит dropdown в body, находим visible dropdown
		const dropdown = this.page.locator('.el-select-dropdown').last();
		await dropdown.waitFor({ state: 'visible', timeout: 3000 });

		// Ищем опцию по тексту в выпадающем списке
		await dropdown.locator('.el-option').filter({ hasText: language }).click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Получить текущий язык из переключателя
	 */
	async getCurrentLanguageLabel(): Promise<string> {
		return (
			(await this.getLanguageSwitcher()
				.locator('.el-select__selected-item')
				.textContent()) || ''
		).trim();
	}
}
