import { Page } from '@playwright/test';
import { DetailBasePage } from './detail-base.page';

export class ArticleDetailPage extends DetailBasePage {
	constructor(page: Page) {
		super(page);
	}

	async getPageHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}

	async hasArticleContent(): Promise<boolean> {
		const content = this.page.locator(
			'.article-detail-page .description, .article-detail-page .languages-list, .article-detail-page .specialties-list',
		);
		try {
			await content.first().waitFor({ state: 'visible' });
			return true;
		} catch {
			return false;
		}
	}
}
