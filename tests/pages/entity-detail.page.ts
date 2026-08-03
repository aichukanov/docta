import type { Page, Locator } from '@playwright/test';
import { BasePage } from './base.page';

/**
 * Детальная страница сущности.
 *
 * Разметку задаёт `components/entity-page/index.vue` — общий для клиник,
 * врачей, услуг, анализов, лекарств и страховых. Раньше тесты искали
 * `.details-page-header` из `components/details-page.vue`; этот компонент
 * страницами больше не используется.
 */
export class EntityDetailPage extends BasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Дождаться, пока страница действительно отрисуется.
	 *
	 * `waitForURL` возвращает управление сразу после смены адреса, а при
	 * клиентской навигации в этот момент в DOM ещё старый листинг: h1, кнопка
	 * «к поиску» и canonical приезжают позже.
	 */
	async waitForLoaded(): Promise<void> {
		// Ожидание навигационного масштаба, а не действия: URL меняется сразу,
		// но Suspense держит старый экран, пока не доедут данные детальной
		// страницы. Дефолтных 15 секунд на проде иногда не хватало.
		const timeout = 30_000;
		await this.page.locator('.entity-page').waitFor({
			state: 'visible',
			timeout,
		});
		await this.page.locator('.entity-page__layout h1').first().waitFor({
			state: 'visible',
			timeout,
		});
	}

	async getPageHeading(): Promise<string> {
		return (
			(
				await this.page.locator('.entity-page__layout h1').first().textContent()
			)?.trim() || ''
		);
	}

	getRoot(): Locator {
		return this.page.locator('.entity-page');
	}

	getBackToSearchButton(): Locator {
		return this.page.locator('.entity-page__back button').first();
	}

	async waitForBackToSearchReady(): Promise<void> {
		await this.getBackToSearchButton().waitFor({ state: 'visible' });
	}

	async clickBackToSearch() {
		await this.waitForCookieBanner();
		await this.waitForBackToSearchReady();
		await this.getBackToSearchButton().click();
		await this.page.waitForLoadState('domcontentloaded');
	}

	/** Вкладки разделов (рендерятся только когда их больше одной) */
	getTabs(): Locator {
		return this.page.locator('.entity-page__nav a, .entity-page__nav button');
	}
}
