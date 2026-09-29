import { test, expect } from '@playwright/test';
import { URLS } from '../utils/constants';

/*
 * Ничто не вылезает за узкий экран.
 *
 * Аудит 2026-09-29 нашёл три класса причин, и все три отказывали ТИХО — сайт
 * выглядел рабочим, а на телефоне контент уезжал за край:
 *
 * 1. `grid-template-columns: repeat(auto-fill, minmax(380px, 1fr))` — минимум
 *    трека не сжимается, и в контейнере 278px колонка оставалась 380px;
 * 2. `min-width: auto` у flex/grid-элемента — он не сжимается ниже min-content,
 *    из-за чего многоточие у длинных названий не срабатывало никогда, а блок
 *    рос;
 * 3. строка без пробелов (адрес мессенджера) при `overflow-wrap: normal` —
 *    рвать негде, min-content равен всей строке.
 *
 * Проверяется 320px — ширина, на которой WCAG 1.4.10 требует обходиться без
 * горизонтальной прокрутки (это же и 400% зум на десктопе).
 *
 * Виновником считается самый ВЕРХНИЙ переполняющий элемент: его потомки торчат
 * просто потому, что торчит он, и без этого фильтра отчёт — сотни строк.
 */

const NARROW = { width: 320, height: 900 };

const PAGES: Array<[string, string]> = [
	['главная', URLS.HOME],
	['листинг врачей', URLS.DOCTORS],
	['листинг клиник', URLS.CLINICS],
	['листинг услуг', URLS.SERVICES],
	['листинг лекарств', URLS.MEDICINES],
	['страховые', '/insurance-companies'],
	['статья', '/articles/healthcare-in-podgorica'],
];

test.use({ viewport: NARROW, isMobile: true, hasTouch: true });

test.describe(`Нет горизонтального переполнения на ${NARROW.width}px`, () => {
	for (const [name, url] of PAGES) {
		test(name, async ({ page }) => {
			await page.goto(url, { waitUntil: 'domcontentloaded' });
			await page.waitForLoadState('networkidle').catch(() => {});

			const report = await page.evaluate(() => {
				const vw = document.documentElement.clientWidth;
				const over = (el: Element) => {
					const r = el.getBoundingClientRect();
					return r.width > 0 && (r.right > vw + 0.5 || r.left < -0.5);
				};
				const culprits: string[] = [];
				for (const el of document.querySelectorAll('body *')) {
					if (!over(el)) continue;
					// Плитки Leaflet лежат в трансформированной панели нулевого
					// размера — это устройство карты, а не дефект вёрстки
					if (el.closest('.leaflet-container')) continue;
					if (el.parentElement && over(el.parentElement)) continue;
					const r = el.getBoundingClientRect();
					culprits.push(
						`${el.tagName.toLowerCase()}.${(el.className || '').toString().trim().split(/\s+/)[0]} ` +
							`(${Math.round(r.width)}px, правый край ${Math.round(r.right)})`,
					);
				}
				return {
					vw,
					scrollWidth: document.documentElement.scrollWidth,
					culprits: [...new Set(culprits)],
				};
			});

			expect(report.culprits, 'блоки выходят за экран').toEqual([]);
			expect(
				report.scrollWidth,
				'документ шире экрана — появится горизонтальная прокрутка',
			).toBeLessThanOrEqual(report.vw);
		});
	}
});
