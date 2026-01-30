import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class MedicationDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}
}
