import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class ServiceListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	async goto() {
		await super.goto(URLS.SERVICES);
	}

	getListItems(): Locator {
		return this.page.locator('.results-list-item');
	}

	async getFirstServiceName(): Promise<string> {
		const firstItem = this.getListItems().first();
		const nameElement = firstItem.locator(
			'.service-name-link, .service-name, .list-card-header, h2, h3',
		);
		return (await nameElement.first().textContent()) || '';
	}
}
