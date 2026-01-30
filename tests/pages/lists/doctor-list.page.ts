import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class DoctorListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Перейти на страницу списка врачей
	 */
	async goto() {
		await super.goto(URLS.DOCTORS);
	}

	/**
	 * Получить все карточки врачей
	 */
	getListItems(): Locator {
		return this.page.locator('.results-list-item .doctor-wrapper');
	}

	/**
	 * Получить имя первого врача
	 */
	async getFirstDoctorName(): Promise<string> {
		const firstItem = this.getListItems().first();
		const nameElement = firstItem.locator('.doctor-name');
		return (await nameElement.first().textContent()) || '';
	}
}
