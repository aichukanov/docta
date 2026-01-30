import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class DoctorDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}

	async getDoctorSpecialty(): Promise<string> {
		const specialty = await this.page
			.locator('[data-testid="doctor-specialty"]')
			.or(this.page.locator('.specialty, .doctor-specialty'))
			.first()
			.textContent();
		return specialty || '';
	}
}
