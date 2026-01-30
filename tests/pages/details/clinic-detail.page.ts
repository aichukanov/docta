import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class ClinicDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}

	async getClinicAddress(): Promise<string> {
		const address = await this.page
			.locator('[data-testid="clinic-address"]')
			.or(this.page.locator('.clinic-address, .address'))
			.first()
			.textContent();
		return address || '';
	}
}
