import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class MedicationListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	async goto() {
		await super.goto(URLS.MEDICINES);
	}

	getListItems(): Locator {
		return this.page.locator('.results-list-item');
	}

	async getFirstMedicationName(): Promise<string> {
		const firstItem = this.getListItems().first();
		const nameElement = firstItem.locator(
			'.list-card-link, .list-card-header, h2, h3',
		);
		return (await nameElement.first().textContent()) || '';
	}
}
