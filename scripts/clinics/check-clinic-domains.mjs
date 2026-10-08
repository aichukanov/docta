/**
 * Журнал доменов клиник: какие освободились или вот-вот освободятся.
 *
 * Собирает домены из трёх мест:
 *   - сайты клиник в нашей БД (clinics.website, локальная БД из .env);
 *   - websiteUri мест из data/google-places/<город>/*.json;
 *   - сайты кандидатов из data/clinic-candidates/candidates.json (site и newSite);
 *   - ручной список data/clinic-domains/decisions.json (поле watch).
 * Для свободных и умирающих доменов дополнительно смотрит Wayback Machine: был ли на
 * домене сайт и сколько он прожил. Найденные вручную ссылки на домен — decisions.json → research.
 * По каждому регистрируемому домену смотрит регистрацию (WHOIS для .me/.rs/.ru,
 * RDAP для остальных), DNS и ответ сайта. Домены агрегаторов и соцсетей пропускаются.
 *
 * Отчёт — data/clinic-domains/report.md, состояние — state.json (там же дата,
 * с которой домен свободен). Решения по доменам (куплен / не нужен) — decisions.json,
 * такие домены в отчёте уходят в отдельный раздел.
 *
 * Usage:
 *   node scripts/clinics/check-clinic-domains.mjs [--only=<domain,domain>]
 */

import dns from 'node:dns/promises';
import { existsSync, readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import net from 'node:net';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import mysql from 'mysql2/promise';
import { UA, today as todayFn } from './lib/source-fetch.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '../..');
const DIR = resolve(ROOT, 'data/clinic-domains');
const STATE_FILE = resolve(DIR, 'state.json');
const REPORT_FILE = resolve(DIR, 'report.md');
const DECISIONS_FILE = resolve(DIR, 'decisions.json');
const PLACES_DIR = resolve(ROOT, 'data/google-places');
const CANDIDATES_FILE = resolve(ROOT, 'data/clinic-candidates/candidates.json');
const CONCURRENCY = 6;
const EXPIRING_DAYS = 45;
const today = todayFn();
const monthAgo = new Date(Date.now() - 30 * 864e5).toISOString().slice(0, 10);

const only = process.argv
	.find((a) => a.startsWith('--only='))
	?.slice(7)
	.split(',');

const envPath = resolve(ROOT, '.env');
if (existsSync(envPath)) {
	for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
		const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/);
		if (m) process.env[m[1]] = m[2].trim();
	}
}

// Агрегаторы, соцсети и хостинги сайтов-конструкторов: домен не принадлежит клинике.
const FOREIGN_DOMAINS = new Set([
	'facebook.com', 'instagram.com', 'google.com', 'linkedin.com', 'youtube.com', 'tiktok.com', 't.me',
	'wa.me', 'linktr.ee', 'business.site', 'wixsite.com', 'weebly.com', 'wordpress.com', 'tilda.ws',
	'registarfirmi.me', 'travelmontenegro.me', 'stomatologija.me', 'tapqo.co', 'firme-cg.com', 'mojgrad.rs',
	'booksy.com', 'fresha.com', 'cdm.me', 'barinfo.me', 'ordinacije.me', 'odmaraj.me',
]);
const SECOND_LEVEL = new Set(['co.me', 'org.me', 'net.me', 'its.me', 'edu.me', 'gov.me', 'co.rs', 'org.rs', 'in.rs', 'co.uk', 'com.tr']);
const WHOIS_SERVERS = { me: 'whois.nic.me', rs: 'whois.rnids.rs', ru: 'whois.tcinet.ru' };
const WHOIS_NOT_FOUND = /Domain not found|No entries found|not registered|NOT FOUND|No match for/i;
const NON_CLINIC_TYPES = new Set([
	'pharmacy', 'veterinary_care', 'hair_care', 'nail_salon', 'cosmetics_store', 'beauty_salon', 'hotel',
	'resort_hotel', 'car_repair', 'coworking_space', 'garden_center', 'painter',
]);
const PARKED = /\/lander\b|parking|sedoparking|dan\.com|afternic|hugedomains|Account Suspended|Domain has been assigned|domain is for sale|buy this domain/i;
// Домен перекуплен под спам: так обычно выглядит освободившийся домен, который
// забрали раньше нас. Клинике нужен новый сайт, ссылку в карточке — снять.
const HIJACKED = /\b(slot|gacor|togel|judi|casino|kasino|poker|pamanslot)\b/i;

function hostOf(url) {
	try {
		return new URL(/^https?:\/\//i.test(url) ? url : `http://${url}`).hostname.replace(/^www\./, '').toLowerCase();
	} catch {
		return '';
	}
}

function registrable(host) {
	const parts = host.split('.');
	return SECOND_LEVEL.has(parts.slice(-2).join('.')) ? parts.slice(-3).join('.') : parts.slice(-2).join('.');
}

// ─── источники ───────────────────────────────────────────────────────────────

const domains = new Map();
function addDomain(url, source) {
	const host = hostOf(url || '');
	if (!host || !host.includes('.')) return;
	const domain = registrable(host);
	if (FOREIGN_DOMAINS.has(domain) || FOREIGN_DOMAINS.has(host)) return;
	if (!domains.has(domain)) domains.set(domain, { domain, hosts: new Set(), sources: [] });
	const entry = domains.get(domain);
	entry.hosts.add(host);
	if (!entry.sources.some((s) => s.label === source.label)) entry.sources.push(source);
}

const db = await mysql.createConnection({
	host: process.env.DB_HOST || 'localhost',
	user: process.env.DB_USER || 'root',
	password: process.env.DB_PASSWORD || process.env.DB_PASS || '',
	database: process.env.DB_NAME,
	port: Number(process.env.DB_PORT || 3306),
});
const [clinicRows] = await db.query(`SELECT id, slug, website FROM clinics WHERE website IS NOT NULL AND website <> ''`);
await db.end();
for (const c of clinicRows) addDomain(c.website, { kind: 'db', label: `БД #${c.id} ${c.slug}` });

for (const city of readdirSync(PLACES_DIR)) {
	const cityDir = resolve(PLACES_DIR, city);
	if (!statSync(cityDir).isDirectory()) continue;
	for (const file of readdirSync(cityDir)) {
		const place = JSON.parse(readFileSync(resolve(cityDir, file), 'utf-8'));
		if (!place.websiteUri) continue;
		const type = place.primaryType || place.types?.[0] || '';
		addDomain(place.websiteUri, {
			kind: 'google',
			type,
			label: `${place.displayName?.text} (${city}, ${place.userRatingCount || 0} отз., ${type})`,
		});
	}
}

if (existsSync(CANDIDATES_FILE)) {
	for (const c of JSON.parse(readFileSync(CANDIDATES_FILE, 'utf-8'))) {
		for (const url of [c.site, c.siteCheck?.newSite].filter(Boolean)) {
			addDomain(url, { kind: 'candidate', label: `кандидат ${c.name}` });
		}
	}
}

const decisions = existsSync(DECISIONS_FILE) ? JSON.parse(readFileSync(DECISIONS_FILE, 'utf-8')) : { watch: [], decided: {} };
for (const w of decisions.watch || []) addDomain(w.domain, { kind: 'manual', label: w.note || 'ручной список' });

// ─── проверки ────────────────────────────────────────────────────────────────

function whois(domain, server) {
	return new Promise((done) => {
		let text = '';
		const socket = net.connect(43, server, () => socket.write(`${domain}\r\n`));
		socket.setTimeout(20000, () => {
			socket.destroy();
			done({ error: 'timeout' });
		});
		socket.on('data', (d) => (text += d));
		socket.on('end', () => done({ text }));
		socket.on('error', (e) => done({ error: e.code || e.message || 'socket error' }));
	});
}

// whois.nic.me рвёт соединения при параллельных запросах: запросы к одному серверу
// идут строго по очереди с паузой, при ошибке — повтор с паузой подольше.
const whoisQueues = {};
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
function whoisThrottled(domain, server) {
	const run = (whoisQueues[server] || Promise.resolve()).then(async () => {
		for (const pause of [0, 5000, 15000]) {
			if (pause) await sleep(pause);
			const r = await whois(domain, server);
			if (!r.error && r.text) {
				await sleep(800);
				return r;
			}
		}
		return { error: 'нет ответа после 3 попыток' };
	});
	whoisQueues[server] = run.catch(() => {});
	return run;
}

// WHOIS отдаёт даты в разных форматах: 2027-02-15T…, 07.02.2027 (.rs), 2027.02.15.
function isoDate(s) {
	if (!s) return null;
	const dmy = s.match(/^(\d{2})\.(\d{2})\.(\d{4})/);
	if (dmy) return `${dmy[3]}-${dmy[2]}-${dmy[1]}`;
	return s.slice(0, 10).replace(/\./g, '-');
}

let rdapBootstrap = null;
async function rdapBase(tld) {
	if (!rdapBootstrap) {
		const res = await fetch('https://data.iana.org/rdap/dns.json', { signal: AbortSignal.timeout(20000) });
		rdapBootstrap = (await res.json()).services;
	}
	return rdapBootstrap.find(([tlds]) => tlds.includes(tld))?.[1]?.[0] || null;
}

async function registration(domain) {
	const tld = domain.split('.').pop();
	if (WHOIS_SERVERS[tld]) {
		const { text, error } = await whoisThrottled(domain, WHOIS_SERVERS[tld]);
		if (error) return { reg: 'error', error };
		if (WHOIS_NOT_FOUND.test(text)) return { reg: 'free' };
		return {
			reg: 'registered',
			expiry: isoDate(text.match(/(?:Registry Expiry Date|Expiration date|paid-till):\s*(\S+)/i)?.[1]),
			status: [...text.matchAll(/(?:Domain Status|Domain status|state):\s*(\S+)/gi)].map((m) => m[1]),
		};
	}
	const base = await rdapBase(tld).catch(() => null);
	if (!base) return { reg: 'error', error: `нет RDAP/WHOIS для .${tld}` };
	try {
		const res = await fetch(`${base}domain/${domain}`, { signal: AbortSignal.timeout(20000) });
		if (res.status === 404) return { reg: 'free' };
		const j = await res.json();
		const events = Object.fromEntries((j.events || []).map((e) => [e.eventAction, e.eventDate]));
		return { reg: 'registered', expiry: events.expiration?.slice(0, 10) || null, status: j.status || [] };
	} catch (e) {
		return { reg: 'error', error: e.message };
	}
}

async function site(host) {
	for (const scheme of ['https', 'http']) {
		try {
			const res = await fetch(`${scheme}://${host}`, {
				redirect: 'follow',
				signal: AbortSignal.timeout(20000),
				headers: { 'user-agent': UA },
			});
			const html = await res.text();
			return {
				http: res.status,
				finalUrl: res.url,
				title: html.match(/<title[^>]*>([^<]{0,120})/i)?.[1]?.trim() || null,
				bytes: html.length,
				parked: PARKED.test(`${res.url} ${html.slice(0, 3000)}`),
				hijacked: HIJACKED.test(html.match(/<title[^>]*>([^<]*)/i)?.[1] || ''),
			};
		} catch (e) {
			if (scheme === 'http') return { http: 'error', error: e.cause?.code || e.message };
		}
	}
}

async function check(entry) {
	let dnsOk = true;
	try {
		await dns.resolve4(entry.domain);
	} catch {
		dnsOk = false;
	}
	const reg = await registration(entry.domain);
	const s = reg.reg === 'free' ? null : await site([...entry.hosts][0]);
	return { ...reg, dns: dnsOk, site: s };
}

function classify(r) {
	if (r.reg === 'free') return 'free';
	if (r.reg === 'error') return 'unknown';
	const st = (r.status || []).join(' ');
	if (/pendingDelete|redemption/i.test(st)) return 'pending_delete';
	if (r.expiry && r.expiry < today) return 'expired';
	if (r.site?.hijacked) return 'hijacked';
	const dead = !r.site || r.site.http === 'error' || r.site.http >= 500 || r.site.http === 404 || r.site.parked || r.site.bytes < 300;
	const daysLeft = r.expiry ? (Date.parse(r.expiry) - Date.parse(today)) / 864e5 : Infinity;
	if (daysLeft <= EXPIRING_DAYS && dead) return 'expiring_dead';
	if (dead) return r.site?.parked ? 'parked' : 'dead';
	if (daysLeft <= EXPIRING_DAYS) return 'expiring';
	return 'ok';
}

// ─── прогон ──────────────────────────────────────────────────────────────────

const state = existsSync(STATE_FILE) ? JSON.parse(readFileSync(STATE_FILE, 'utf-8')) : { domains: {} };
const queue = [...domains.values()].filter((d) => !only || only.includes(d.domain));
console.log(`Доменов: ${queue.length}`);
let done = 0;
async function worker() {
	while (queue.length) {
		const entry = queue.shift();
		const r = await check(entry);
		const status = classify(r);
		const prev = state.domains[entry.domain];
		state.domains[entry.domain] = {
			hosts: [...entry.hosts],
			sources: entry.sources,
			status,
			statusSince: prev?.status === status ? prev.statusSince : today,
			expiry: r.expiry || null,
			registryStatus: r.status || [],
			dns: r.dns,
			site: r.site,
			error: r.error || null,
			lastChecked: today,
		};
		if (++done % 25 === 0) console.log(`  ${done}`);
	}
}
await Promise.all(Array.from({ length: CONCURRENCY }, worker));
state.lastRun = today;
writeFileSync(STATE_FILE, `${JSON.stringify(state, null, '\t')}\n`);

// ─── история сайта в Wayback ─────────────────────────────────────────────────

// Свободный домен ценен, только если на нём жил сайт клиники: тогда на него остались
// ссылки (каталоги, статьи, карточка в Google). Архив отвечает, был ли сайт и когда.
// Запросы строго по одному: archive.org отвечает 429 на параллельные.
const WAYBACK_STATUSES = new Set(['free', 'pending_delete', 'expired', 'expiring_dead', 'dead', 'parked', 'hijacked']);
async function wayback(domain) {
	const url = `https://web.archive.org/cdx/search/cdx?url=${domain}&matchType=domain&output=json&fl=timestamp,original&filter=statuscode:200&limit=5000`;
	for (const pause of [0, 10000, 30000]) {
		if (pause) await sleep(pause);
		try {
			const res = await fetch(url, { signal: AbortSignal.timeout(60000), headers: { 'user-agent': UA } });
			if (res.status === 429) continue;
			const rows = (await res.json()).slice(1);
			const months = new Set(rows.map(([ts]) => ts.slice(0, 6)));
			const pages = new Set(rows.map(([, u]) => u.replace(/^https?:\/\/(www\.)?/, '').replace(/[?#].*$/, '').replace(/\/$/, '')));
			const ts = rows.map(([t]) => t).sort();
			return {
				captures: rows.length,
				months: months.size,
				pages: pages.size,
				first: ts[0] ? `${ts[0].slice(0, 4)}-${ts[0].slice(4, 6)}` : null,
				last: ts.at(-1) ? `${ts.at(-1).slice(0, 4)}-${ts.at(-1).slice(4, 6)}` : null,
				checked: today,
			};
		} catch {
			// повтор
		}
	}
	return { error: 'archive.org не ответил', checked: today };
}

const waybackQueue = Object.entries(state.domains).filter(
	([domain, d]) =>
		WAYBACK_STATUSES.has(d.status) && (!only || only.includes(domain)) && (!d.wayback || d.wayback.error || d.wayback.checked < monthAgo),
);
if (waybackQueue.length) console.log(`Wayback: ${waybackQueue.length}`);
for (const [domain, d] of waybackQueue) {
	d.wayback = await wayback(domain);
	await sleep(1500);
}
writeFileSync(STATE_FILE, `${JSON.stringify(state, null, '\t')}\n`);

// ─── отчёт ───────────────────────────────────────────────────────────────────

const decided = decisions.decided || {};
const research = decisions.research || {};
const rows = Object.entries(state.domains).map(([domain, d]) => ({ domain, ...d }));
const open = rows.filter((r) => !decided[r.domain]);
// Не клиника — если домен знают только места Google немедицинских типов (аптеки, салоны, ветеринария).
const isClinic = (r) => r.sources.some((s) => s.kind !== 'google' || !NON_CLINIC_TYPES.has(s.type));
const hadSite = (r) => (r.wayback?.months || 0) > 0;
const fmtSources = (r) => r.sources.map((s) => s.label).join('; ');
const siteNote = (r) =>
	!r.site ? '' : r.site.http === 'error' ? `сайт: ${r.site.error}` : `сайт: ${r.site.http}${r.site.parked ? ', парковка' : ''}${r.site.title ? `, «${r.site.title.slice(0, 40)}»` : ''}`;
const archiveNote = (r) =>
	!r.wayback
		? '—'
		: r.wayback.error
			? r.wayback.error
			: r.wayback.months
				? `${r.wayback.first} … ${r.wayback.last}, ${r.wayback.months} мес., ${r.wayback.pages} стр.`
				: 'снимков нет';
const linksNote = (r) => {
	const x = research[r.domain];
	if (!x) return 'не искали';
	const found = x.links?.length ? `${x.links.length}: ${x.links.slice(0, 3).join(', ')}${x.links.length > 3 ? '…' : ''}` : 'не найдено';
	return `${found}${x.note ? ` — ${x.note}` : ''} (${x.checked})`;
};
const line = (r) =>
	`| ${r.domain} | ${r.expiry || '—'} | ${archiveNote(r)} | ${linksNote(r)} | ${[siteNote(r), (r.registryStatus || []).filter((s) => /pending|redemption|hold|autoRenew/i.test(s)).join(', ')].filter(Boolean).join('; ')} | ${fmtSources(r)} |`;
const table = (list) =>
	list.length
		? ['| Домен | Истекает | Сайт в архиве | Ссылки на домен | Состояние | Чей |', '|---|---|---|---|---|---|', ...list.map(line)].join('\n')
		: 'Нет.';
const byStatus = (...st) =>
	open
		.filter((r) => st.includes(r.status))
		.sort((a, b) => (b.wayback?.months || 0) - (a.wayback?.months || 0) || (a.expiry || '').localeCompare(b.expiry || ''));
const ownClinic = (r) => r.sources.some((s) => s.kind === 'db');
const free = byStatus('free');

const report = `# Домены клиник

Генерируется \`node scripts/clinics/check-clinic-domains.mjs\`; состояние — \`state.json\`, решения и найденные ссылки — \`decisions.json\`. Последний прогон: **${today}**.

Проверено доменов: ${rows.length}. Свободны: ${free.length}, из них бывших сайтов клиник — ${free.filter((r) => isClinic(r) && hadSite(r)).length}. Скоро освободятся: ${byStatus('pending_delete', 'expired', 'expiring_dead').length}, сайт мёртв или припаркован: ${byStatus('dead', 'parked').length}, перекуплены под спам: ${byStatus('hijacked').length}.

«Сайт в архиве» — снимки Wayback Machine: первый … последний месяц, сколько месяцев и страниц сохранено. Нет снимков — сайта на домене, скорее всего, не было (адрес вписан в карточку Google, но не запущен), и ссылок на него нет. «Ссылки на домен» — где домен упоминается снаружи; собирается вручную в \`decisions.json → research\`.

## Свободны: бывшие сайты клиник

Главный список на выкуп.

${table(free.filter((r) => isClinic(r) && hadSite(r)))}

## Свободны: сайта в архиве нет

Домен указан у клиники, но в архиве его нет — покупать незачем, пока не найдутся ссылки.

${table(free.filter((r) => isClinic(r) && !hadSite(r)))}

## Скоро освободятся

Удаление в реестре, срок уже истёк или истекает в ближайшие ${EXPIRING_DAYS} дней при мёртвом сайте.

${table(byStatus('pending_delete', 'expired', 'expiring_dead').filter(isClinic))}

## Заняты, но сайт мёртв или припаркован

Следить: такие домены обычно не продлевают.

${table(byStatus('dead', 'parked').filter(isClinic))}

## Перекуплены под спам

Клиника потеряла домен, его занял чужой (казино, слоты). Если домен стоит в карточке клиники — ссылку снять и искать новый сайт.

${table(byStatus('hijacked'))}

## Наши клиники: сайт истекает в ближайшие ${EXPIRING_DAYS} дней

Сайт работает, но если клиника не продлит домен — ссылка в карточке станет битой.

${table(byStatus('expiring').filter(ownClinic))}

## Не клиники

Аптеки, салоны, ветеринария — свободные и умирающие домены, для сведения.

${table(open.filter((r) => !isClinic(r) && ['free', 'pending_delete', 'expired', 'expiring_dead'].includes(r.status)))}

## Не удалось проверить

${table(byStatus('unknown'))}

## Решения

${
	Object.keys(decided).length
		? ['| Домен | Решение | Заметка |', '|---|---|---|', ...Object.entries(decided).map(([d, v]) => `| ${d} | ${v.decision} | ${v.note || ''} |`)].join('\n')
		: 'Нет.'
}
`;
writeFileSync(REPORT_FILE, report);
console.log(`Отчёт: ${REPORT_FILE}`);
