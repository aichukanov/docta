/*
 * Аудит горизонтального переполнения на узких экранах.
 *
 * Ищет не «страница скроллится вбок» (это ловит только часть случаев — предок
 * с overflow:hidden прячет симптом, а контент всё равно обрезан), а элементы,
 * которые вылезают за свой контейнер. Виновником считается самый ВЕРХНИЙ
 * такой элемент: его потомки торчат просто потому, что торчит он.
 */
import { chromium } from '@playwright/test';

const BASE = process.env.AUDIT_BASE || 'http://localhost:3100';
const WIDTHS = (process.env.AUDIT_WIDTHS || '320,360').split(',').map(Number);

const browser = await chromium.launch();
const probe = await browser.newContext({
	viewport: { width: 1280, height: 900 },
});
const probePage = await probe.newPage();

/** Первый слаг из листинга — чтобы не хардкодить и не протухнуть. */
async function firstSlug(listUrl, prefix) {
	await probePage.goto(`${BASE}${listUrl}`, { waitUntil: 'domcontentloaded' });
	const href = await probePage
		.locator(`a[href^="${prefix}"]`)
		.first()
		.getAttribute('href');
	return href ? href.split('?')[0] : null;
}

const doctor = await firstSlug('/doctors', '/doctors/');
const clinic = await firstSlug('/clinics', '/clinics/');
const service = await firstSlug('/services', '/services/');
const labtest = await firstSlug('/labtests', '/labtests/');
const medicine = await firstSlug('/medicines', '/medicines/');
const insurance = await firstSlug(
	'/insurance-companies',
	'/insurance-companies/',
);
await probe.close();

const URLS = [
	'/',
	'/about',
	'/privacy',
	'/terms',
	'/login',
	'/forgot-password',
	'/articles',
	'/articles/healthcare-in-podgorica',
	'/articles/health-insurance-for-residence-permit',
	'/articles/medications-not-available-in-montenegro',
	'/articles/allergy-medicines-in-montenegro',
	'/articles/birth-in-montenegro',
	'/doctors',
	'/doctors?page=64',
	'/clinics',
	'/clinics?view=map',
	'/services',
	'/labtests',
	'/medicines',
	'/insurance-companies',
	doctor,
	doctor && `${doctor}/reviews`,
	clinic,
	clinic && `${clinic}/services`,
	clinic && `${clinic}/labtests`,
	clinic && `${clinic}/doctors`,
	clinic && `${clinic}/reviews`,
	service,
	labtest,
	medicine,
	insurance,
	'/no-such-page-404',
].filter(Boolean);

const summary = new Map();

for (const width of WIDTHS) {
	console.log(`\n========== viewport ${width}px ==========`);
	const context = await browser.newContext({
		viewport: { width, height: 900 },
		hasTouch: true,
		isMobile: true,
	});
	const page = await context.newPage();

	for (const url of URLS) {
		try {
			await page.goto(`${BASE}${url}`, {
				waitUntil: 'networkidle',
				timeout: 30000,
			});
		} catch {
			console.log(`   ⏱ ${url} — таймаут, пропущено`);
			continue;
		}
		const res = await page.evaluate(() => {
			const vw = document.documentElement.clientWidth;
			const over = (el) => {
				const r = el.getBoundingClientRect();
				return r.width > 0 && (r.right > vw + 0.5 || r.left < -0.5);
			};
			const culprits = [];
			for (const el of document.querySelectorAll('body *')) {
				if (!over(el)) continue;
				// Плитки Leaflet лежат внутри трансформированной панели нулевого
				// размера — это устройство карты, а не переполнение вёрстки
				if (el.closest('.leaflet-container')) continue;
				if (el.parentElement && over(el.parentElement)) continue;
				const r = el.getBoundingClientRect();
				culprits.push({
					sel:
						el.tagName.toLowerCase() +
						(el.className
							? '.' +
								el.className
									.toString()
									.trim()
									.split(/\s+/)
									.slice(0, 2)
									.join('.')
							: ''),
					w: Math.round(r.width),
					parentW: el.parentElement
						? Math.round(el.parentElement.getBoundingClientRect().width)
						: null,
					text: (el.textContent || '').trim().slice(0, 30),
				});
			}
			return {
				vw,
				scrollW: document.documentElement.scrollWidth,
				culprits,
			};
		});

		const scrolls = res.scrollW > res.vw;
		const uniq = new Map();
		for (const c of res.culprits) {
			if (!uniq.has(c.sel)) uniq.set(c.sel, c);
			const key = c.sel;
			summary.set(key, (summary.get(key) || 0) + 1);
		}
		if (!scrolls && uniq.size === 0) continue;
		console.log(
			`${scrolls ? '❌ скролл' : '⚠️  обрезано'} ${url} — scrollWidth ${res.scrollW}/${res.vw}`,
		);
		for (const c of uniq.values()) {
			console.log(`      ${c.sel}: ${c.w}px в ${c.parentW}px «${c.text}»`);
		}
	}
	await context.close();
}

console.log('\n========== сводка по виновникам ==========');
for (const [sel, n] of [...summary.entries()].sort((a, b) => b[1] - a[1])) {
	console.log(`${String(n).padStart(4)} × ${sel}`);
}

await browser.close();
