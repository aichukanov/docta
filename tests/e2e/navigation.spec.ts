import { test, expect } from '@playwright/test';
import { HeaderComponent } from '../pages/components/header.page';
import { FooterComponent } from '../pages/components/footer.page';
import { LISTING_SECTIONS } from '../utils/sections';
import { URLS } from '../utils/constants';

// Разделы, которые обязаны быть в главном меню. Список берётся из общего
// конфига: раньше тест ходил по `/medications`, хотя пункт «Lekovi» уже вёл
// на `/medicines`, и промах ловился только таймаутом.
const HEADER_SECTIONS = LISTING_SECTIONS.filter((s) => s.inHeaderNav);

test.describe('Navigation', () => {
	test.describe('Header Component', () => {
		let header: HeaderComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			header = new HeaderComponent(page);
		});

		test('should have header visible', async () => {
			expect(await header.isVisible()).toBeTruthy();
		});

		test('меню содержит все разделы и статьи', async () => {
			const navLinks = await header.getNavLinks();
			for (const section of HEADER_SECTIONS) {
				expect(navLinks, `нет ссылки на ${section.url}`).toContain(section.url);
			}
			expect(navLinks).toContain(URLS.ARTICLES);
		});

		for (const section of HEADER_SECTIONS) {
			test(`переход в раздел ${section.url}`, async ({ page }) => {
				await header.clickNavLink(section.url);
				await page.waitForURL(new RegExp(`${section.url}(?:[/?#]|$)`));
				expect(new URL(page.url()).pathname).toBe(section.url);
			});
		}

		test('переход в статьи', async ({ page }) => {
			await header.clickNavLink(URLS.ARTICLES);
			await page.waitForURL(/\/articles(?:[/?#]|$)/);
			expect(new URL(page.url()).pathname).toBe(URLS.ARTICLES);
		});

		test('should return to home when clicking logo', async ({ page }) => {
			await page.goto('/doctors');
			await page.waitForLoadState('domcontentloaded');

			await header.clickLogo();
			await page.waitForURL(/.*\/(\?.*)?$/);

			expect(new URL(page.url()).pathname).toBe('/');
		});
	});

	test.describe('Footer Component', () => {
		let footer: FooterComponent;

		test.beforeEach(async ({ page }) => {
			await page.goto('/');
			footer = new FooterComponent(page);
		});

		test('should have footer visible', async () => {
			expect(await footer.isVisible()).toBeTruthy();
		});

		test('should have footer navigation links', async () => {
			const footerLinks = await footer.getFooterNavLinks();
			expect(footerLinks.length).toBeGreaterThanOrEqual(5);
		});

		test('should have contact links', async () => {
			const contactLinks = await footer.getContactLinks();
			expect(contactLinks.length).toBeGreaterThan(0);
			expect(
				contactLinks.some((link) => link.startsWith('mailto:')),
			).toBeTruthy();
			expect(contactLinks.some((link) => link.includes('t.me'))).toBeTruthy();
		});

		test('should have copyright text', async () => {
			const copyrightText = await footer.getCopyrightText();
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

			expect(page.url()).not.toEqual(initialUrl);
		});
	});
});
