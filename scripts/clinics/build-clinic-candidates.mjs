/**
 * Список клиник-кандидатов на добавление и их очередь.
 *
 * Сводит:
 *   - места из data/google-places/<город>/*.json (медицинские типы, только Черногория);
 *   - гугл-таблицу юзера data/clinic-candidates/sheet-*.json (у строк ручное поле resolved);
 *   - проверку сайтов data/clinic-candidates/site-checks.json (прайс, врачи, услуги);
 *   - ручные правки data/clinic-candidates/overrides.json (что уже в БД под другим
 *     доменом, что не клиника);
 *   - разборы конкурентов data/competitors/<сайт>/clinic-candidates.json — отметка
 *     «есть у конкурента» (по домену сайта или названию места Google);
 *   - локальную БД (.env): клиника считается добавленной, если совпал домен сайта,
 *     google_place_id, запись в google-places/progress.json или ручная привязка.
 *
 * Кандидат — один сайт (все места Google с этим доменом) или одно место без сайта.
 * Очередь:
 *   1 — прайс на сайте И хотя бы один врач;
 *   2 — на сайте есть что-то из: список услуг, прайс, врачи;
 *   3 — сайта с содержимым нет, но в Google ≥ 10 отзывов;
 *   4 — остальное (мало отзывов, сайта нет) — не в работе.
 *
 * Результат — candidates.json и candidates.md рядом с входами.
 *
 * Usage:
 *   node scripts/clinics/build-clinic-candidates.mjs
 */

import { existsSync, readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import mysql from 'mysql2/promise';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '../..');
const DIR = resolve(ROOT, 'data/clinic-candidates');
const PLACES_DIR = resolve(ROOT, 'data/google-places');
const DOMAINS_STATE = resolve(ROOT, 'data/clinic-domains/state.json');
const TIER3_MIN_REVIEWS = 10;
const today = new Date().toISOString().slice(0, 10);

const envPath = resolve(ROOT, '.env');
if (existsSync(envPath)) {
	for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
		const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/);
		if (m) process.env[m[1]] = m[2].trim();
	}
}

const readJson = (file, fallback) => (existsSync(file) ? JSON.parse(readFileSync(file, 'utf-8')) : fallback);

// Места этих типов — не клиники (аптеки, салоны, ветеринария и случайные попадания поиска).
const SKIP_TYPES = new Set([
	'pharmacy', 'veterinary_care', 'hair_care', 'nail_salon', 'cosmetics_store', 'hotel', 'resort_hotel',
	'coworking_space', 'car_repair', 'painter', 'garden_center', 'beauty_salon',
]);
// Домены, которые не принадлежат клинике: соцсети, агрегаторы, конструкторы.
const FOREIGN_DOMAINS = new Set([
	'facebook.com', 'instagram.com', 'google.com', 'linkedin.com', 'youtube.com', 'tiktok.com', 't.me',
	'wa.me', 'linktr.ee', 'business.site', 'wixsite.com', 'weebly.com', 'wordpress.com', 'tilda.ws',
	'registarfirmi.me', 'travelmontenegro.me', 'stomatologija.me', 'tapqo.co', 'firme-cg.com', 'mojgrad.rs',
	'booksy.com', 'fresha.com', 'cdm.me', 'barinfo.me', 'ordinacije.me', 'odmaraj.me',
]);
const SECOND_LEVEL = new Set(['co.me', 'org.me', 'net.me', 'co.rs', 'org.rs']);
const MONTENEGRO = /Crna Gora|Montenegro|Црна Гора/i;

function hostOf(url) {
	try {
		return new URL(/^https?:\/\//i.test(url) ? url : `http://${url}`).hostname.replace(/^www\./, '').toLowerCase();
	} catch {
		return '';
	}
}
function ownDomain(url) {
	const host = hostOf(url || '');
	if (!host) return null;
	const parts = host.split('.');
	const domain = SECOND_LEVEL.has(parts.slice(-2).join('.')) ? parts.slice(-3).join('.') : parts.slice(-2).join('.');
	return FOREIGN_DOMAINS.has(domain) ? null : domain;
}

// ─── входы ───────────────────────────────────────────────────────────────────

const sheetFiles = readdirSync(DIR).filter((f) => /^sheet-.*\.json$/.test(f)).sort();
const sheet = sheetFiles.flatMap((f) => readJson(resolve(DIR, f), []).map((row) => ({ ...row, sheetFile: f })));
const siteChecks = readJson(resolve(DIR, 'site-checks.json'), []);
const overrides = readJson(resolve(DIR, 'overrides.json'), { inDb: {}, exclude: {} });
const domainState = readJson(DOMAINS_STATE, { domains: {} }).domains;
const progress = readJson(resolve(PLACES_DIR, 'progress.json'), {});
const COMPETITORS_DIR = resolve(ROOT, 'data/competitors');
const competitorRows = existsSync(COMPETITORS_DIR)
	? readdirSync(COMPETITORS_DIR).flatMap((site) =>
			readJson(resolve(COMPETITORS_DIR, site, 'clinic-candidates.json'), []).map((row) => ({ ...row, competitor: site })),
		)
	: [];

const db = await mysql.createConnection({
	host: process.env.DB_HOST || 'localhost',
	user: process.env.DB_USER || 'root',
	password: process.env.DB_PASSWORD || process.env.DB_PASS || '',
	database: process.env.DB_NAME,
	port: Number(process.env.DB_PORT || 3306),
});
const [clinicRows] = await db.query(`
	SELECT c.id, c.slug, c.name_sr name, c.website, c.google_place_id,
		(SELECT COUNT(*) FROM clinic_medical_services s WHERE s.clinic_id = c.id) services,
		(SELECT COUNT(*) FROM clinic_medical_services s WHERE s.clinic_id = c.id AND s.price IS NOT NULL) servicesPriced,
		(SELECT COUNT(*) FROM clinic_lab_tests l WHERE l.clinic_id = c.id) labTests,
		(SELECT COUNT(*) FROM doctor_clinics d WHERE d.clinic_id = c.id) doctors,
		(SELECT COUNT(*) FROM reviews r WHERE r.clinic_id = c.id AND r.status <> 'rejected') reviews
	FROM clinics c`);
await db.end();
const clinicById = new Map(clinicRows.map((c) => [c.id, c]));
const clinicByDomain = new Map();
for (const c of clinicRows) {
	const d = ownDomain(c.website);
	if (d) clinicByDomain.set(d, [...(clinicByDomain.get(d) || []), c.id]);
}
const clinicByPlace = new Map(clinicRows.filter((c) => c.google_place_id).map((c) => [c.google_place_id, c.id]));

// ─── места Google → кандидаты ────────────────────────────────────────────────

const places = new Map();
for (const city of readdirSync(PLACES_DIR)) {
	const cityDir = resolve(PLACES_DIR, city);
	if (!statSync(cityDir).isDirectory()) continue;
	for (const file of readdirSync(cityDir)) {
		const p = JSON.parse(readFileSync(resolve(cityDir, file), 'utf-8'));
		const prev = places.get(p.id);
		if (prev) {
			prev.files.push(`${city}/${file}`);
			prev.addedPerProgress ||= !!progress[city]?.[file];
			continue;
		}
		places.set(p.id, {
			id: p.id,
			name: p.displayName?.text || null,
			type: p.primaryType || p.types?.[0] || null,
			city,
			address: p.formattedAddress || null,
			phone: p.internationalPhoneNumber || null,
			website: p.websiteUri || null,
			rating: p.rating ?? null,
			userRatingCount: p.userRatingCount || 0,
			reviewsLocal: p.reviews?.length || 0,
			collectedAt: p.collectedAt?.slice(0, 10) || null,
			files: [`${city}/${file}`],
			addedPerProgress: !!progress[city]?.[file],
		});
	}
}

const candidates = new Map();
function candidateFor(key, init) {
	if (!candidates.has(key)) candidates.set(key, { key, domain: null, site: null, places: [], sheet: [], ...init });
	return candidates.get(key);
}
const placeKey = new Map();
function attachPlace(c, place) {
	const prevKey = placeKey.get(place.id);
	if (prevKey === c.key) return;
	if (prevKey) {
		const prev = candidates.get(prevKey);
		prev.places = prev.places.filter((p) => p.id !== place.id);
		if (!prev.places.length && !prev.sheet.length && !prev.domain) candidates.delete(prevKey);
	}
	c.places.push(place);
	placeKey.set(place.id, c.key);
}

const outOfCountry = [];
for (const place of places.values()) {
	if (SKIP_TYPES.has(place.type)) continue;
	if (!MONTENEGRO.test(place.address || '')) {
		outOfCountry.push(place);
		continue;
	}
	const domain = ownDomain(place.website);
	const c = domain
		? candidateFor(domain, { domain, site: place.website })
		: candidateFor(`place:${place.id}`, {});
	attachPlace(c, place);
}

// Строки таблицы: resolved = { db } | { domain, placeIds } | { placeIds } | { skip }.
const sheetInDb = [];
for (const row of sheet) {
	const r = row.resolved || {};
	const entry = { tab: row.tab, n: row.n ?? null, name: row.name, url: row.url || null, note: row.note || null, comment: r.comment || null };
	if (r.skip) continue;
	if (r.db) {
		sheetInDb.push({ ...entry, clinicId: r.db, task: r.task || null });
		continue;
	}
	let c = null;
	if (r.domain) c = candidateFor(r.domain, { domain: r.domain, site: row.url || `https://${r.domain}/` });
	for (const id of r.placeIds || []) {
		const place = places.get(id);
		if (!place) continue;
		c ||= candidates.get(placeKey.get(id)) || candidateFor(`place:${id}`, {});
		attachPlace(c, place);
	}
	c ||= candidateFor(`sheet:${row.name}`, {});
	c.sheet.push(entry);
}

// ─── уже в БД? ───────────────────────────────────────────────────────────────

function clinicsOf(c) {
	const ids = new Set();
	for (const id of overrides.inDb[c.key] || []) ids.add(id);
	for (const id of clinicByDomain.get(c.domain) || []) ids.add(id);
	for (const p of c.places) {
		if (clinicByPlace.has(p.id)) ids.add(clinicByPlace.get(p.id));
		for (const id of overrides.inDb[p.id] || []) ids.add(id);
	}
	return [...ids].filter((id) => clinicById.has(id));
}

// ─── очередь ─────────────────────────────────────────────────────────────────

const checkByKey = new Map();
for (const s of siteChecks) {
	if (s.domain) checkByKey.set(s.domain, s);
	if (s.placeId) checkByKey.set(`place:${s.placeId}`, s);
}

// Кандидата могли проверить дважды: по старому домену из Google и по найденному новому
// сайту места. Берётся проверка, где сайт читается.
function pickCheck(checks) {
	return checks.find((s) => ['ok', 'js_unreadable'].includes(s.siteState)) || checks[0] || null;
}

function tierOf(c) {
	const s = c.siteCheck;
	const reviews = c.reviews.google;
	const usable = s && s.isMedical !== false && ['ok', 'js_unreadable'].includes(s.siteState || 'ok');
	const prices = usable && ['full'].includes(s.pricelist?.status);
	const somePrices = usable && ['full', 'partial'].includes(s.pricelist?.status);
	const doctors = usable ? s.doctors?.count || (['list', 'single'].includes(s.doctors?.status) ? 1 : 0) : 0;
	const services = usable && ['list', 'partial'].includes(s.services?.status);
	if (prices && doctors) return { tier: 1, reason: `прайс${s.pricelist.approxItems ? ` ~${s.pricelist.approxItems}` : ''} + врачей ${doctors}` };
	if (somePrices || doctors || services) {
		const parts = [prices ? 'прайс' : somePrices ? 'отдельные цены' : null, doctors ? `врачей ${doctors}` : null, services ? 'список услуг' : null];
		return { tier: 2, reason: parts.filter(Boolean).join(', ') };
	}
	if (reviews >= TIER3_MIN_REVIEWS) return { tier: 3, reason: `${reviews} отзывов в Google` };
	return { tier: 4, reason: s ? 'на сайте ничего пригодного, мало отзывов' : 'сайта нет, мало отзывов' };
}

const result = [];
const excluded = [];
for (const c of candidates.values()) {
	const main = [...c.places].sort((a, b) => b.userRatingCount - a.userRatingCount)[0];
	const item = {
		key: c.key,
		name: main?.name || c.sheet[0]?.name || c.domain,
		city: main?.city || null,
		type: main?.type || null,
		domain: c.domain,
		site: c.site,
		domainStatus: c.domain ? domainState[c.domain]?.status || null : null,
		reviews: {
			google: Math.max(0, ...c.places.map((p) => p.userRatingCount)),
			googleTotal: c.places.reduce((s, p) => s + p.userRatingCount, 0),
			local: c.places.reduce((s, p) => s + p.reviewsLocal, 0),
		},
		places: c.places,
		sheet: c.sheet,
		siteCheck: pickCheck([c.key, ...c.places.map((p) => `place:${p.id}`)].map((k) => checkByKey.get(k)).filter(Boolean)),
	};
	item.competitors = competitorRows
		.filter((r) => (c.domain && ownDomain(r.website) === c.domain) || c.places.some((p) => p.name && p.name === r.google?.name))
		.map((r) => ({ site: r.competitor, url: r.url, verdict: r.verdict }));
	const exclude = overrides.exclude[c.key] || c.places.map((p) => overrides.exclude[p.id]).find(Boolean);
	const inDb = clinicsOf(c);
	if (exclude) {
		excluded.push({ ...item, excludeReason: exclude });
		continue;
	}
	if (item.siteCheck?.isMedical === false) {
		excluded.push({ ...item, excludeReason: `не клиника: ${item.siteCheck.kind || ''} ${item.siteCheck.notes || ''}`.trim() });
		continue;
	}
	if (inDb.length || c.places.some((p) => p.addedPerProgress)) {
		item.inDb = inDb;
		item.status = 'in_db';
	} else {
		Object.assign(item, tierOf(item));
		item.status = 'candidate';
	}
	result.push(item);
}

// В очередях 3–4 сайта нет или он пустой — там решают только отзывы.
const rank = (c) => {
	const s = c.tier <= 2 ? c.siteCheck : null;
	return [
		c.tier,
		-(s?.pricelist?.status === 'full'),
		-(s?.doctors?.count || 0),
		-(s?.services?.status === 'list'),
		-c.reviews.google,
	];
};
const cmp = (a, b) => {
	const ra = rank(a);
	const rb = rank(b);
	for (let i = 0; i < ra.length; i++) if (ra[i] !== rb[i]) return ra[i] - rb[i];
	return a.name.localeCompare(b.name);
};
const queue = result.filter((c) => c.status === 'candidate').sort(cmp);
const inDbList = result.filter((c) => c.status === 'in_db');
writeFileSync(
	resolve(DIR, 'candidates.json'),
	`${JSON.stringify([...queue, ...inDbList, ...excluded.map((e) => ({ ...e, status: 'excluded' }))], null, '\t')}\n`,
);

// ─── отчёт ───────────────────────────────────────────────────────────────────

const esc = (s) => String(s ?? '').replace(/\|/g, '/').replace(/\n/g, ' ');
const siteCell = (c) => {
	if (!c.domain) return c.siteCheck?.newSite ? `→ ${c.siteCheck.newSite}` : '—';
	const st = c.domainStatus && c.domainStatus !== 'ok' && c.domainStatus !== 'expiring' ? ` (${c.domainStatus})` : '';
	const moved = c.siteCheck?.newSite ? ` → ${c.siteCheck.newSite}` : '';
	return `${c.domain}${st}${moved}`;
};
const sources = (c) => {
	const s = c.siteCheck;
	if (!s) return '';
	return [...(s.pricelist?.urls || []).slice(0, 1).map((u) => `[прайс](${u})`), ...(s.doctors?.urls || []).slice(0, 1).map((u) => `[врачи](${u})`)].join(' ');
};
const reviewsCell = (c) => `${c.reviews.google}${c.reviews.local > 5 ? ` (скачано ${c.reviews.local})` : ''}`;
const fromSheet = (c) => [c.sheet.length ? 'таблица' : '', ...c.competitors.map((x) => x.site)].filter(Boolean).join(', ');
const tierTable = (list) =>
	list.length
		? [
				'| # | Клиника | Город | Сайт | Что есть | Отзывы Google | Где ещё есть | Источники |',
				'|---|---|---|---|---|---|---|---|',
				...list.map((c, i) => `| ${i + 1} | ${esc(c.name)} | ${c.city || ''} | ${esc(siteCell(c))} | ${esc(c.reason)} | ${reviewsCell(c)} | ${fromSheet(c)} | ${sources(c)} |`),
			].join('\n')
		: 'Нет.';
const byTier = (t) => queue.filter((c) => c.tier === t);
const notes = (c) => esc([c.sheet.map((s) => s.note || s.comment).filter(Boolean).join('; '), c.siteCheck?.notes].filter(Boolean).join(' — ')).slice(0, 220);

const md = `# Кандидаты на добавление

Генерируется \`node scripts/clinics/build-clinic-candidates.mjs\`. Последняя сборка: **${today}**.
Как устроено и как обновлять — [README.md](README.md), порядок работы — [PLAN.md](PLAN.md).

В очереди: ${queue.length} (1-я — ${byTier(1).length}, 2-я — ${byTier(2).length}, 3-я — ${byTier(3).length}, 4-я — ${byTier(4).length}). Уже в БД: ${inDbList.length}. Исключено: ${excluded.length}. Вне Черногории (не учитываются): ${outOfCountry.length}.

«Отзывы Google» — число отзывов на дату выгрузки места (\`collectedAt\`, март–сентябрь 2026); «скачано» — сколько отзывов уже лежит в файле места.

## 1. Прайс и врачи

${tierTable(byTier(1))}

## 2. Хотя бы список услуг, цены или врачи

${tierTable(byTier(2))}

## 3. Только отзывы (≥ ${TIER3_MIN_REVIEWS} в Google)

${tierTable(byTier(3))}

## 4. Не в работе

Сайта с содержимым нет и меньше ${TIER3_MIN_REVIEWS} отзывов. ${byTier(4).length} мест, список — в \`candidates.json\` (\`tier: 4\`).

## Из таблицы: уже на сайте

${[
	'| Вкладка | Строка таблицы | Клиника в БД | Услуг (с ценой) / анализов / врачей / отзывов | Что сделать |',
	'|---|---|---|---|---|',
	...sheetInDb.map((r) => {
		const c = clinicById.get(r.clinicId);
		const counts = c ? `${c.services} (${c.servicesPriced}) / ${c.labTests} / ${c.doctors} / ${c.reviews}` : 'нет в БД';
		return `| ${r.tab} | ${esc(r.name)} | ${c ? `#${c.id} ${c.slug}` : `#${r.clinicId}?`} | ${counts} | ${esc(r.task || '')} |`;
	}),
].join('\n')}

## Заметки по кандидатам из таблицы

${queue
	.filter((c) => c.sheet.length)
	.map((c) => `- **${esc(c.name)}** (очередь ${c.tier}) — ${notes(c) || 'заметок нет'}`)
	.join('\n')}

## Исключено

${excluded.map((c) => `- ${esc(c.name)} (${c.city || ''}${c.domain ? `, ${c.domain}` : ''}) — ${esc(c.excludeReason).slice(0, 160)}`).join('\n') || 'Нет.'}
`;
writeFileSync(resolve(DIR, 'candidates.md'), md);
console.log(
	`Очередь: ${queue.length} (1: ${byTier(1).length}, 2: ${byTier(2).length}, 3: ${byTier(3).length}, 4: ${byTier(4).length}); в БД: ${inDbList.length}; исключено: ${excluded.length}`,
);
