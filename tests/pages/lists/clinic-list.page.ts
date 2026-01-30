import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class ClinicListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Перейти на страницу списка клиник
	 */
	async goto() {
		await super.goto(URLS.CLINICS);
	}

	/**
	 * Получить все карточки клиник
	 */
	getListItems(): Locator {
		return this.page.locator('.results-list-item .clinic-summary');
	}

	/**
	 * Получить название первой клиники
	 */
	async getFirstClinicName(): Promise<string> {
		const firstItem = this.getListItems().first();
		const nameElement = firstItem.locator(
			'.clinic-name-link, .clinic-name, h2, h3',
		);
		return (await nameElement.first().textContent()) || '';
	}
}
