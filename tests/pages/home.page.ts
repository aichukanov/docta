import { Page } from '@playwright/test';
import { BasePage } from './base.page';

export class HomePage extends BasePage {
	constructor(page: Page) {
		super(page);
	}

	/**
	 * Перейти на главную страницу
	 */
	async goto() {
		await super.goto('/');
	}

	/**
	 * Проверить что главная страница загружена
	 */
	async isLoaded(): Promise<boolean> {
		// Проверяем наличие основных элементов главной страницы
		const hasHeader = await this.isVisible('header');
		const hasFooter = await this.isVisible('footer');
		const hasHero = await this.isVisible('.hero');
		return hasHeader && hasFooter && hasHero;
	}

	/**
	 * Получить заголовок главной страницы
	 */
	async getMainHeading(): Promise<string> {
		return (await this.page.locator('h1').first().textContent()) || '';
	}

	/**
	 * Проверить наличие bento-карточек
	 */
	async hasBentoCards(): Promise<boolean> {
		const cards = await this.page.locator('.bento__card').count();
		return cards > 0;
	}

	/**
	 * Кликнуть по карточке по названию
	 */
	async clickBentoCard(href: string) {
		await this.page.locator(`.bento__card[href="${href}"]`).click();
	}
}
