import { test, expect } from '@playwright/test';
import { HeaderComponent } from '../pages/components/header.page';
import { FooterComponent } from '../pages/components/footer.page';

test.describe('Navigation', () => {
	test.describe('Header Component', () => {
		let header: HeaderComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			header = new HeaderComponent(page);
		});

		test('should have header visible', async () => {
			const isVisible = await header.isVisible();
			expect(isVisible).toBeTruthy();
		});

		test('should have navigation links', async () => {
			const navLinks = await header.getNavLinks();
			expect(navLinks.length).toBeGreaterThan(0);
			// Должно быть минимум 5 основных ссылок
			expect(navLinks.length).toBeGreaterThanOrEqual(5);
		});

		test('should navigate to doctors page', async ({ page }) => {
			await header.clickNavLink('/doctors');
			await page.waitForURL(/.*doctors.*/);
			expect(page.url()).toContain('doctors');
		});

		test('should navigate to clinics page', async ({ page }) => {
			await header.clickNavLink('/clinics');
			await page.waitForURL(/.*clinics.*/);
			expect(page.url()).toContain('clinics');
		});

		test('should navigate to services page', async ({ page }) => {
			await header.clickNavLink('/services');
			await page.waitForURL(/.*services.*/);
			expect(page.url()).toContain('services');
		});

		test('should navigate to medications page', async ({ page }) => {
			await header.clickNavLink('/medications');
			await page.waitForURL(/.*medications.*/);
			expect(page.url()).toContain('medications');
		});

		test('should navigate to labtests page', async ({ page }) => {
			await header.clickNavLink('/labtests');
			await page.waitForURL(/.*labtests.*/);
			expect(page.url()).toContain('labtests');
		});

		test('should return to home when clicking logo', async ({ page }) => {
			// Сначала переходим на другую страницу
			await page.goto('/doctors');
			await page.waitForLoadState('domcontentloaded');

			// Кликаем по логотипу
			await header.clickLogo();
			await page.waitForURL(/.*\/(\?.*)?$/);

			// Проверяем что вернулись на главную
			const url = page.url();
			expect(url).toMatch(/\/(\?.*)?$/);
		});
	});

	test.describe('Language Switching', () => {
		let header: HeaderComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			header = new HeaderComponent(page);
		});

		test('should have language switcher visible', async () => {
			const switcher = header.getLanguageSwitcher();
			await expect(switcher).toBeVisible();
		});

		// NOTE: Детальные тесты переключения языка перенесены в Итерацию 6
		// так как требуют специальной работы с Element Plus dropdown/popper
	});

	test.describe('Footer Component', () => {
		let footer: FooterComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			footer = new FooterComponent(page);
		});

		test('should have footer visible', async () => {
			const isVisible = await footer.isVisible();
			expect(isVisible).toBeTruthy();
		});

		test('should have footer navigation links', async () => {
			const footerLinks = await footer.getFooterNavLinks();
			expect(footerLinks.length).toBeGreaterThan(0);
			// Должно быть минимум 5 ссылок
			expect(footerLinks.length).toBeGreaterThanOrEqual(5);
		});

		test('should have contact links', async () => {
			const contactLinks = await footer.getContactLinks();
			expect(contactLinks.length).toBeGreaterThan(0);
			expect(contactLinks.some((link) => link.startsWith('mailto:'))).toBeTruthy();
			expect(contactLinks.some((link) => link.includes('t.me'))).toBeTruthy();
		});

		test('should have copyright text', async () => {
			const copyrightText = await footer.getCopyrightText();
			expect(copyrightText).toBeTruthy();
			// Проверяем что есть год
			expect(copyrightText).toMatch(/202[0-9]/);
		});

		test('should navigate when clicking footer link', async ({ page }) => {
			const footerLinks = await footer.getFooterNavLinks();
			const testLink =
				footerLinks.find((link) => link.includes('/doctors')) ||
				footerLinks.find((link) => link.includes('/clinics')) ||
				footerLinks[0];

			const initialUrl = page.url();
			await footer.clickFooterLink(testLink);
			await page.waitForLoadState('domcontentloaded');

			const newUrl = page.url();
			expect(newUrl).not.toEqual(initialUrl);
		});
	});
});
