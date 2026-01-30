import { Page } from '@playwright/test';

/**
 * Ждать завершения навигации и загрузки контента
 */
export async function waitForPageLoad(page: Page) {
	await page.waitForLoadState('networkidle');
	await page.waitForLoadState('domcontentloaded');
}

/**
 * Проверить что URL содержит ожидаемый путь
 */
export function expectUrlContains(page: Page, path: string) {
	const url = page.url();
	if (!url.includes(path)) {
		throw new Error(`Expected URL to contain "${path}", but got "${url}"`);
	}
}

/**
 * Получить текущий язык из URL
 */
export function getCurrentLanguage(page: Page): string {
	const url = page.url();
	return url.includes('/en/') ? 'en' : 'sr';
}
