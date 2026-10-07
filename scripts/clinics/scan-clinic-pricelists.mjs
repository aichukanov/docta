/**
 * Обходит сайты клиник из БД и ищет на них прайс-листы: страницы с ценами,
 * PDF/XLS-файлы, цены прямо на страницах услуг. Первый, автоматический проход
 * карты прайсов — неоднозначные сайты (SPA, Wix, ошибки) дальше смотрятся руками.
 *
 * Что делает по каждому сайту:
 *   1. Главная + sitemap.xml / wp-sitemap.xml / sitemap_index.xml.
 *   2. Кандидаты: ссылки и URL из sitemap со словами «cjenovnik / cijene /
 *      price / ценовник …», файлы .pdf/.xls(x)/.doc(x), затем страницы услуг.
 *   3. На каждой HTML-странице считает вхождения цен в евро. Для файлов —
 *      только заголовки (размер, Last-Modified) и sha256.
 *
 * Usage:
 *   node scripts/clinics/scan-clinic-pricelists.mjs [--only=<slug,slug>]
 *
 * Результат: data/clinic-pricelists/scan-<YYYY-MM-DD>.json
 */

import { createHash } from 'node:crypto';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import mysql from 'mysql2/promise';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '../..');
const OUT_DIR = resolve(ROOT, 'data/clinic-pricelists');

const envPath = resolve(ROOT, '.env');
if (existsSync(envPath)) {
	for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
		const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/);
		if (m) process.env[m[1]] = m[2].trim();
	}
}

const only = process.argv
	.find((a) => a.startsWith('--only='))
	?.slice(7)
	.split(',');

const UA =
	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0 Safari/537.36';
const TIMEOUT_MS = 20000;
const MAX_PRICE_CANDIDATES = 10;
const MAX_SERVICE_CANDIDATES = 4;
const CONCURRENCY = 6;

const PRICE_WORDS =
	/(cjenovni|cjenik|cenovni|\bcijen|\bcjen|\bcene\b|\bcena\b|price|pricing|preis|tarif|ценовн|цјеновн|\bцен[аеуы]|\bцијен|прайс|стоимост)/i;
const SERVICE_WORDS = /(usluge|usluga|services|service|услуг|услуге|ordinacij|odjelj|odjeljen|tretman|treatments)/i;
const FILE_EXT = /\.(pdf|xlsx?|docx?)(\?|#|$)/i;
const PRICE_RE =
	/(?:€\s?\d{1,5}(?:[.,]\d{1,2})?)|(?:\b\d{1,5}(?:[.,]\d{1,2})?\s?(?:€|eur\b|eura\b|evra\b|e\b(?=\s|<|$)))/gi;

const today = new Date().toISOString().slice(0, 10);

async function fetchUrl(url, { method = 'GET', binary = false } = {}) {
	const ctrl = new AbortController();
	const t = setTimeout(() => ctrl.abort(), TIMEOUT_MS);
	try {
		const res = await fetch(url, {
			method,
			redirect: 'follow',
			signal: ctrl.signal,
			headers: { 'User-Agent': UA, Accept: '*/*', 'Accept-Language': 'sr,en;q=0.8' },
		});
		const out = {
			status: res.status,
			finalUrl: res.url,
			contentType: res.headers.get('content-type') || '',
			lastModified: res.headers.get('last-modified'),
			contentLength: res.headers.get('content-length'),
		};
		if (method === 'GET') {
			const buf = Buffer.from(await res.arrayBuffer());
			out.size = buf.length;
			out.sha256 = createHash('sha256').update(buf).digest('hex');
			if (!binary && !/pdf|octet|excel|spreadsheet|msword|officedocument/i.test(out.contentType)) {
				out.text = buf.toString('utf-8');
			}
		}
		return out;
	} catch (e) {
		return { error: e.name === 'AbortError' ? 'timeout' : String(e.cause?.code || e.message) };
	} finally {
		clearTimeout(t);
	}
}

function normalizeSite(raw) {
	let u = raw.trim();
	if (!/^https?:\/\//i.test(u)) u = 'https://' + u;
	return u;
}

function stripHtml(html) {
	return html
		.replace(/<!--[\s\S]*?-->/g, ' ')
		.replace(/<script[\s\S]*?<\/script>/gi, ' ')
		.replace(/<style[\s\S]*?<\/style>/gi, ' ')
		.replace(/<[^>]+>/g, ' ')
		.replace(/&nbsp;|&#160;/g, ' ')
		.replace(/&euro;|&#8364;/g, '€')
		.replace(/\s+/g, ' ');
}

function countPrices(html) {
	const text = stripHtml(html);
	const hits = text.match(PRICE_RE) || [];
	return { priceHits: hits.length, textLength: text.length, sample: hits.slice(0, 5) };
}

function extractLinks(html, base) {
	const links = [];
	const re = /<a\b[^>]*href\s*=\s*["']([^"'#]+)["'][^>]*>([\s\S]*?)<\/a>/gi;
	let m;
	while ((m = re.exec(html))) {
		try {
			const url = new URL(m[1].trim(), base).toString();
			if (!/^https?:/.test(url)) continue;
			links.push({ url, text: stripHtml(m[2]).trim().slice(0, 120) });
		} catch {}
	}
	return links;
}

function jsRenderedHint(html, textLength) {
	const markers = [];
	if (/wix\.com|wixstatic/i.test(html)) markers.push('wix');
	if (/__NEXT_DATA__|_next\/static/i.test(html)) markers.push('next');
	if (/__NUXT__|_nuxt\//i.test(html)) markers.push('nuxt');
	if (/<div id=["'](root|app)["']>\s*<\/div>/i.test(html)) markers.push('spa-root');
	if (/squarespace/i.test(html)) markers.push('squarespace');
	if (/elementor/i.test(html)) markers.push('elementor');
	if (/wp-content/i.test(html)) markers.push('wordpress');
	if (textLength < 800) markers.push('little-text');
	return markers;
}

async function sitemapUrls(origin) {
	const urls = new Set();
	const queue = [`${origin}/sitemap.xml`, `${origin}/wp-sitemap.xml`, `${origin}/sitemap_index.xml`];
	const seen = new Set();
	while (queue.length && seen.size < 15) {
		const sm = queue.shift();
		if (seen.has(sm)) continue;
		seen.add(sm);
		const r = await fetchUrl(sm);
		if (!r.text || r.status !== 200 || !/<(urlset|sitemapindex)/i.test(r.text)) continue;
		for (const [, loc] of r.text.matchAll(/<loc>\s*([^<\s]+)\s*<\/loc>/gi)) {
			const u = loc.replace(/&amp;/g, '&');
			if (/\.xml(\?|$)/i.test(u)) queue.push(u);
			else urls.add(u);
		}
	}
	return [...urls];
}

const sameSite = (a, b) => {
	try {
		return new URL(a).hostname.replace(/^www\./, '') === new URL(b).hostname.replace(/^www\./, '');
	} catch {
		return false;
	}
};

async function scanSite(siteUrl) {
	const result = { siteUrl, checkedAt: today };
	const home = await fetchUrl(siteUrl);
	if (home.error || !home.text) {
		result.error = home.error || `no html (status ${home.status}, ${home.contentType})`;
		result.verdict = classify(result);
		return result;
	}
	result.status = home.status;
	result.finalUrl = home.finalUrl;
	const homeCount = countPrices(home.text);
	result.home = { priceHits: homeCount.priceHits, textLength: homeCount.textLength };
	result.hints = jsRenderedHint(home.text, homeCount.textLength);

	const origin = new URL(home.finalUrl).origin;
	const links = extractLinks(home.text, home.finalUrl);
	const smUrls = await sitemapUrls(origin);
	result.sitemapUrls = smUrls.length;

	const cand = new Map();
	const add = (url, text, why) => {
		const key = url.replace(/\/$/, '');
		if (key === home.finalUrl.replace(/\/$/, '')) return;
		if (!cand.has(key)) cand.set(key, { url, text, why });
	};
	for (const l of links) {
		const hay = decodeURIComponent(l.url) + ' ' + l.text;
		if (FILE_EXT.test(l.url)) add(l.url, l.text, PRICE_WORDS.test(hay) ? 'file+price-word' : 'file');
		else if (sameSite(l.url, origin) && PRICE_WORDS.test(hay)) add(l.url, l.text, 'link-price-word');
	}
	for (const u of smUrls) {
		let dec = u;
		try {
			dec = decodeURIComponent(u);
		} catch {}
		if (FILE_EXT.test(u)) add(u, '', PRICE_WORDS.test(dec) ? 'file+price-word' : 'file');
		else if (PRICE_WORDS.test(dec)) add(u, '', 'sitemap-price-word');
	}
	const priceCands = [...cand.values()].filter((c) => c.why !== 'file');
	const otherFiles = [...cand.values()].filter((c) => c.why === 'file');

	const serviceCands = [];
	const seenSvc = new Set();
	for (const l of [...links, ...smUrls.map((u) => ({ url: u, text: '' }))]) {
		if (serviceCands.length >= MAX_SERVICE_CANDIDATES) break;
		if (FILE_EXT.test(l.url) || !sameSite(l.url, origin)) continue;
		const key = l.url.replace(/\/$/, '');
		if (cand.has(key) || seenSvc.has(key)) continue;
		let hay = l.url + ' ' + l.text;
		try {
			hay = decodeURIComponent(l.url) + ' ' + l.text;
		} catch {}
		if (SERVICE_WORDS.test(hay)) {
			seenSvc.add(key);
			serviceCands.push({ url: l.url, text: l.text, why: 'service-page' });
		}
	}

	result.candidates = [];
	for (const c of [...priceCands.slice(0, MAX_PRICE_CANDIDATES), ...serviceCands]) {
		const isFile = FILE_EXT.test(c.url);
		const r = await fetchUrl(c.url, { binary: isFile });
		const entry = { ...c, status: r.status, error: r.error };
		if (r.text) {
			const pc = countPrices(r.text);
			entry.priceHits = pc.priceHits;
			entry.sample = pc.sample;
		} else if (!r.error) {
			entry.contentType = r.contentType;
			entry.size = r.size;
			entry.lastModified = r.lastModified;
		}
		entry.sha256 = r.sha256;
		result.candidates.push(entry);
	}
	result.otherFiles = otherFiles.slice(0, 20).map((f) => ({ url: f.url, text: f.text }));
	result.skippedPriceCandidates = Math.max(0, priceCands.length - MAX_PRICE_CANDIDATES);

	result.verdict = classify(result);
	return result;
}

function classify(r) {
	if (r.error) return 'unreachable';
	const cands = r.candidates || [];
	const pricePage = cands.find((c) => c.why !== 'service-page' && (c.priceHits || 0) >= 10);
	const priceFile = cands.find((c) => c.why === 'file+price-word' && c.status === 200);
	const svcPrices = cands.filter((c) => c.why === 'service-page' && (c.priceHits || 0) >= 3);
	if (pricePage) return 'pricelist-page';
	if (priceFile) return 'pricelist-file';
	if ((r.home?.priceHits || 0) >= 10) return 'prices-on-home';
	if (svcPrices.length) return 'prices-on-service-pages';
	const some = cands.some((c) => (c.priceHits || 0) > 0) || (r.home?.priceHits || 0) > 0;
	if (some) return 'some-prices';
	if (r.hints?.includes('little-text') || r.hints?.includes('wix') || r.hints?.includes('spa-root'))
		return 'js-rendered-unknown';
	return 'no-prices-found';
}

const conn = await mysql.createConnection({
	host: process.env.DB_HOST || 'localhost',
	user: process.env.DB_USER || 'root',
	password: process.env.DB_PASSWORD || '',
	database: process.env.DB_NAME,
	port: Number(process.env.DB_PORT || 3306),
});
const [clinics] = await conn.query(
	`SELECT id, slug, name_sr, website FROM clinics WHERE website IS NOT NULL AND website <> '' ORDER BY id`,
);
await conn.end();

const sites = new Map();
for (const c of clinics) {
	if (only && !only.includes(c.slug)) continue;
	for (const raw of c.website.split(/[;,\s]+/).filter(Boolean)) {
		const url = normalizeSite(raw);
		if (!sites.has(url)) sites.set(url, []);
		sites.get(url).push({ id: c.id, slug: c.slug, name: c.name_sr });
	}
}

const entries = [...sites.entries()];
const results = [];
let next = 0;
async function worker() {
	while (next < entries.length) {
		const [url, cl] = entries[next++];
		const r = await scanSite(url);
		r.clinics = cl;
		results.push(r);
		console.log(`${r.verdict.padEnd(24)} ${url}`);
	}
}
await Promise.all(Array.from({ length: CONCURRENCY }, worker));
results.sort((a, b) => a.clinics[0].id - b.clinics[0].id);

mkdirSync(OUT_DIR, { recursive: true });
const outFile = resolve(OUT_DIR, `scan-${today}.json`);
writeFileSync(outFile, JSON.stringify(results, null, '\t'));
const tally = {};
for (const r of results) tally[r.verdict] = (tally[r.verdict] || 0) + 1;
console.log(tally);
console.log(`→ ${outFile}`);
