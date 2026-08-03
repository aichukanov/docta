import type { Locator, Page } from '@playwright/test';

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

	private getNavLinkByHref(href: string): Locator {
		return this.page.locator(`.app-header__nav-link[href="${href}"]`).first();
	}

	async clickNavLink(linkHref: string) {
		await this.waitForCookieBanner();
		await this.getNavLinkByHref(linkHref).click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	async isNavLinkVisible(linkHref: string): Promise<boolean> {
		return await this.getNavLinkByHref(linkHref)
			.isVisible()
			.catch(() => false);
	}

	async getNavLinks(): Promise<string[]> {
		const links = await this.page.locator('.app-header__nav-link').all();
		const hrefs = await Promise.all(
			links.map((link) => link.getAttribute('href')),
		);
		return hrefs.filter((href): href is string => !!href && href.trim() !== '');
	}

	async isVisible(): Promise<boolean> {
		return await this.page.locator('.app-header').isVisible();
	}

	async clickLogo() {
		await this.waitForCookieBanner();
		await this.page.locator('.app-header__logo').click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/**
	 * Переключатель языка.
	 *
	 * Это не el-select: `components/language-switcher.vue` — свой
	 * button + ul, dropdown рендерится внутри компонента, а не в body.
	 * В шапке их два (десктопный и мобильный), поэтому берём видимый.
	 */
	getLanguageSwitcher(): Locator {
		return this.page.locator('.language-switcher:visible').first();
	}

	async openLanguageSwitcher() {
		await this.waitForCookieBanner();
		const trigger = this.getLanguageSwitcher().locator(
			'.language-switcher__trigger',
		);
		if ((await trigger.getAttribute('aria-expanded')) === 'true') return;
		await trigger.click();
		await this.getLanguageSwitcher()
			.locator('.language-switcher__dropdown')
			.waitFor({ state: 'visible' });
	}

	/** @param language — подпись из `localeNames`, например «Русский», «English» */
	async selectLanguage(language: string) {
		await this.openLanguageSwitcher();
		await this.getLanguageSwitcher()
			.locator('.language-switcher__option')
			.filter({ hasText: language })
			.first()
			.click();
	}

	/** Короткий код текущего языка на кнопке переключателя */
	async getCurrentLanguageLabel(): Promise<string> {
		return (
			(await this.getLanguageSwitcher()
				.locator('.language-switcher__label')
				.textContent()) || ''
		).trim();
	}
}
