import { Page, Locator } from '@playwright/test';
import { ListBasePage } from './list-base.page';
import { URLS } from '../../utils/constants';

export class ArticleListPage extends ListBasePage {
	constructor(page: Page) {
		super(page);
	}

	async goto() {
		await super.goto(URLS.ARTICLES);
	}

	getListItems(): Locator {
		return this.page.locator('.article-card');
	}

	async getFirstArticleTitle(): Promise<string> {
		const firstItem = this.getListItems().first();
		return (await firstItem.locator('h2, h3').first().textContent()) || '';
	}

	async getFirstArticleDescription(): Promise<string> {
		const firstItem = this.getListItems().first();
		return (await firstItem.locator('p').first().textContent()) || '';
	}

	async clickFirstItem() {
		await this.getListItems().first().click();
		await this.page.waitForLoadState('domcontentloaded');
	}
}
