/**
 * Скриншоты страниц прода для промо-постов.
 *
 *   node docs/promo/telegram-polako-2026-07/make-screenshots.mjs
 *
 * Playwright уже в devDependencies проекта. Cloudflare пропускает настоящий
 * Chromium (в отличие от curl/fetch), поэтому снимаем прямо с прода.
 */
import { chromium } from '@playwright/test';
import fs from 'node:fs';

const OUT = 'e:/tmp/docta-shots';
fs.mkdirSync(OUT, { recursive: true });

// Для кадров по секции шапку убираем: при скролле она плавающая и лезет
// в середину кадра. Cookie-баннер мешает всегда.
const HIDE_CHROME = `
	.app-header { display: none !important; }
	.cookie-banner { display: none !important; }
`;

/**
 * [имя файла, url, селектор секции (null — кадр «верх страницы», шапка
 * остаётся), максимальная высота кадра в CSS-px, режим]
 */
const shots = [
	['1-service-top', 'https://docta.me/services/complete-dental-cleaning?lang=ru', null, null],
	['2-service-clinics', 'https://docta.me/services/complete-dental-cleaning?lang=ru', '#clinics', 1080],
	['3-medicine-foreign', 'https://docta.me/medicines/brufen-400mg?lang=ru', '#foreign', 1150],
	['4-labtest-clinics', 'https://docta.me/labtests/complete-blood-count?lang=ru', '#clinics', 1080],
	['5-russian-doctors', 'https://docta.me/doctors?languageIds=2&lang=ru', null, null],
	['6-clinic-reviews', 'https://docta.me/clinics/medical-vranes-bar?lang=ru', '#reviews', 880],
	['7-search-ru', 'https://docta.me/?lang=ru', null, null, 'search'],
];

// Мобильную ширину (414px) для Телеграма брать не стоит: секции в одну колонку
// дают полосу вроде 1194×7200, мессенджер ужимает её до нечитаемого.
const viewports = [{ tag: 'desktop', width: 1360, height: 1000, dsf: 2 }];

const browser = await chromium.launch({ headless: true });

for (const vp of viewports) {
	const ctx = await browser.newContext({
		viewport: { width: vp.width, height: vp.height },
		deviceScaleFactor: vp.dsf,
		locale: 'ru-RU',
	});
	const page = await ctx.newPage();

	for (const [name, url, selector, maxH, mode] of shots) {
		try {
			await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
			await page.waitForSelector('h1', { timeout: 30000 });
			await page.waitForTimeout(2500);

			// Демо поиска: печатаем запрос по-русски и ждём подсказки
			if (mode === 'search') {
				const input = page.locator('input[placeholder*="Поиск"]').first();
				await input.click();
				await input.type('анализ крови', { delay: 90 });
				await page.waitForTimeout(3000);
				await page.addStyleTag({
					content: '.cookie-banner{display:none !important}',
				});
				await page.screenshot({ path: `${OUT}/${name}-${vp.tag}.png` });
				console.log(`OK ${vp.tag} ${name}`);
				continue;
			}

			await page.addStyleTag({
				content: selector
					? HIDE_CHROME
					: '.cookie-banner{display:none !important}',
			});
			await page.waitForTimeout(600);

			if (!selector) {
				await page.screenshot({ path: `${OUT}/${name}-${vp.tag}.png` });
			} else {
				const el = page.locator(selector).first();
				if (!(await el.count())) {
					console.log(`SKIP ${vp.tag} ${name} :: нет ${selector}`);
					continue;
				}
				await el.scrollIntoViewIfNeeded();
				await page.waitForTimeout(1200);
				const box = await el.boundingBox();
				const scrollY = await page.evaluate(() => window.scrollY);
				await page.screenshot({
					path: `${OUT}/${name}-${vp.tag}.png`,
					clip: {
						x: box.x,
						y: box.y + scrollY,
						width: box.width,
						height: maxH ? Math.min(box.height, maxH) : box.height,
					},
					fullPage: true,
				});
			}
			console.log(`OK ${vp.tag} ${name}`);
		} catch (e) {
			console.log(`FAIL ${vp.tag} ${name} :: ${e.message.split('\n')[0]}`);
		}
	}
	await ctx.close();
}

await browser.close();
console.log('done ->', OUT);
