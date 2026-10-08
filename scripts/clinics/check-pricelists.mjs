/**
 * Журнал актуальности прайсов клиник.
 *
 * Обходит URL прайсов из data/clinic-pricelists/map.json (`pricelists[].url`),
 * снимает отпечаток каждого и сравнивает с прошлым прогоном:
 *   - HTML / JSON — отпечаток цен (мультимножество ценовых токенов) и отпечаток
 *     текста; изменились цены — «прайс изменился», только текст — «правка текста»;
 *   - PDF / картинки / doc — sha256 байтов, размер, Last-Modified.
 * Изменившийся источник сохраняется снимком в sources/<slug>/<дата>.<ext>, чтобы
 * по нему готовить обновление цен.
 *
 * Состояние — data/clinic-pricelists/journal.json, отчёт — journal.md (по каждой
 * клинике: последняя проверка, последнее изменение источника, наш импорт).
 * map.json скрипт не трогает: это ручная карта, журнал — машинный.
 *
 * Usage:
 *   node scripts/clinics/check-pricelists.mjs [--only=<slug,slug>]
 *
 * Первый прогон — базовая линия: всё «новое», изменений нет.
 */

import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { fetchUrl, sha, stableJson, visibleText } from './lib/source-fetch.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '../..');
const DIR = resolve(ROOT, 'data/clinic-pricelists');
const MAP_FILE = resolve(DIR, 'map.json');
const STATE_FILE = resolve(DIR, 'journal.json');
const REPORT_FILE = resolve(DIR, 'journal.md');
const IMPORTS_DIR = resolve(ROOT, 'data/clinic-imports');

const CONCURRENCY = 5;
const MAX_SNAPSHOT_BYTES = 5 * 1024 * 1024;
const today = new Date().toISOString().slice(0, 10);

// Особенности отдельных сайтов (recheckHint в map.json)
const SKIP_URL = [
	/web\.archive\.org/, // архив — не живой источник
	/invitro\.co\.me\/cms\/pdf\/create\//, // PDF генерируется на лету, сверяется HTML
];

const only = process.argv
	.find((a) => a.startsWith('--only='))
	?.slice(7)
	.split(',');

// Ценовые токены: «40 €», «€50», «40,00», «15.00», «40,oo», «3400 / eur», «1.400,00 €»
const PRICE_RE =
	/€\s?\d[\d.,]*|\d[\d.,]*\s?(?:€|eur\b|eura\b|evra\b)|\b\d{1,5}[.,](?:\d{2}|oo)\b|\b\d{1,5}\s*\/\s*eur\b/gi;

function priceTokens(text) {
	return (text.match(PRICE_RE) || [])
		.map((t) => t.toLowerCase().replace(/\s+/g, '').replace(/oo$/, '00'))
		.sort();
}

function fingerprint(res, url) {
	const ct = res.contentType || '';
	const isJson = /json/i.test(ct) || /\/wp-json\/|\/api\//.test(url);
	const isText = isJson || /html|text|xml/i.test(ct);
	if (!isText) {
		return { kind: 'binary', bytesHash: sha(res.body), size: res.body.length };
	}
	const raw = res.body.toString('utf-8');
	let text;
	let tokens;
	if (isJson) {
		try {
			const parsed = JSON.parse(raw);
			text = stableJson(parsed);
			// в JSON цена — число в полях price*, их и берём
			tokens = (text.match(/"(?:price|cijena|cena)[a-z_]*":\s*-?\d+(?:\.\d+)?/gi) || []).sort();
		} catch {
			text = raw;
			tokens = priceTokens(raw);
		}
	} else {
		text = visibleText(raw);
		tokens = priceTokens(text);
	}
	const extra = {};
	const lu = raw.match(/\\?"lastUpdated\\?":\s*\\?"(\d{4}-\d{2}-\d{2})/); // Milmedika, RSC-данные
	if (lu) extra.lastUpdated = lu[1];
	return {
		kind: isJson ? 'json' : 'html',
		priceHash: sha(tokens.join('|')),
		textHash: sha(text),
		priceTokenCount: tokens.length,
		tokens,
		text,
		...extra,
	};
}

function tokenDiff(oldTokens = [], newTokens = []) {
	const count = (arr) => arr.reduce((m, t) => m.set(t, (m.get(t) || 0) + 1), new Map());
	const a = count(oldTokens);
	const b = count(newTokens);
	const added = [];
	const removed = [];
	for (const [t, n] of b) for (let i = 0; i < n - (a.get(t) || 0); i++) added.push(t);
	for (const [t, n] of a) for (let i = 0; i < n - (b.get(t) || 0); i++) removed.push(t);
	return { added, removed };
}

// Дата нашего импорта: запись data/clinic-imports/<slug>.json, иначе отметки «в проде YYYY-MM-DD» во flags карты
function importDate(slug, entry) {
	const fromFlags = (entry?.flags || []).join(' ').match(/в проде (20\d\d-\d\d-\d\d)/g)?.map((s) => s.slice(-10)).sort().pop() || null;
	const f = resolve(IMPORTS_DIR, `${slug}.json`);
	if (!existsSync(f)) return fromFlags;
	try {
		const s = JSON.parse(readFileSync(f, 'utf-8')).status || {};
		const all = JSON.stringify(s).match(/20\d\d-\d\d-\d\d/g) || [];
		return [all.sort().pop(), fromFlags].filter(Boolean).sort().pop() || null;
	} catch {
		return fromFlags;
	}
}

function extFor(fp, url, ct) {
	if (fp.kind === 'html') return 'txt';
	if (fp.kind === 'json') return 'json';
	const m = url.match(/\.(pdf|jpe?g|png|webp|docx?|xlsx?)(?:[?#]|$)/i);
	if (m) return m[1].toLowerCase();
	if (/pdf/i.test(ct)) return 'pdf';
	return 'bin';
}

// ─── main ────────────────────────────────────────────────────────────────────

const map = JSON.parse(readFileSync(MAP_FILE, 'utf-8'));
const state = existsSync(STATE_FILE) ? JSON.parse(readFileSync(STATE_FILE, 'utf-8')) : { urls: {} };
const firstRun = !Object.keys(state.urls).length;

const targets = [];
// Статусы карты, у которых в pricelists[] собственный прайс клиники. У no_prices там
// бывают чужие документы (тарифник FZOCG 2015 на jzuobkotor.me) и виджеты записи (ipodo).
const PRICE_STATUSES = new Set(['pricelist_page', 'pricelist_file', 'prices_on_service_pages', 'partial_prices']);

for (const entry of map) {
	if (!entry.pricelists?.length || !PRICE_STATUSES.has(entry.status)) continue;
	const slugs = entry.clinics.map((c) => c.slug);
	if (only && !slugs.some((s) => only.includes(s))) continue;
	for (const pl of entry.pricelists) {
		if (!pl.url || SKIP_URL.some((re) => re.test(pl.url))) continue;
		targets.push({ url: pl.url, slugs, mainSlug: slugs[0], kindHint: pl.kind });
	}
}

const results = [];
let next = 0;
async function worker() {
	while (next < targets.length) {
		const t = targets[next++];
		const prev = state.urls[t.url];
		const res = await fetchUrl(t.url);
		const rec = { ...(prev || { firstSeen: today }), url: t.url, clinics: t.slugs, lastChecked: today };
		let change = null;
		if (res.error || !res.status || res.status >= 400) {
			rec.lastError = res.error || `HTTP ${res.status}`;
			rec.status = res.status || null;
			change = 'error';
		} else {
			const fp = fingerprint(res, t.url);
			rec.status = res.status;
			rec.lastError = null;
			rec.kind = fp.kind;
			rec.lastModified = res.lastModified;
			if (fp.lastUpdated) rec.lastUpdated = fp.lastUpdated;
			const snapshotNeeded = !prev || !prev.snapshot;
			if (fp.kind === 'binary') {
				if (prev && prev.bytesHash && prev.bytesHash !== fp.bytesHash) change = 'file-changed';
				rec.bytesHash = fp.bytesHash;
				rec.size = fp.size;
			} else {
				if (prev && prev.priceHash && prev.priceHash !== fp.priceHash) change = 'prices-changed';
				else if (prev && prev.textHash && prev.textHash !== fp.textHash) change = 'text-changed';
				if (change === 'prices-changed') rec.lastDiff = tokenDiff(prev.tokens, fp.tokens);
				rec.priceHash = fp.priceHash;
				rec.textHash = fp.textHash;
				rec.priceTokenCount = fp.priceTokenCount;
				rec.tokens = fp.tokens;
			}
			if (!prev) change = 'new';
			if (change === 'prices-changed' || change === 'file-changed') rec.lastChanged = today;
			if (change && change !== 'text-changed' && change !== 'error' ? true : snapshotNeeded) {
				const body = fp.kind === 'binary' ? res.body : Buffer.from(fp.text, 'utf-8');
				if (body.length <= MAX_SNAPSHOT_BYTES) {
					const dir = resolve(DIR, 'sources', t.mainSlug);
					mkdirSync(dir, { recursive: true });
					const name = `${today}-${sha(t.url).slice(0, 8)}.${extFor(fp, t.url, res.contentType)}`;
					writeFileSync(resolve(dir, name), body);
					rec.snapshot = `sources/${t.mainSlug}/${name}`;
				} else {
					rec.snapshot = rec.snapshot || null;
					rec.snapshotSkipped = `больше ${MAX_SNAPSHOT_BYTES / 1048576} МБ`;
				}
			}
		}
		rec.lastResult = change || 'unchanged';
		state.urls[t.url] = rec;
		results.push({ ...t, change: rec.lastResult, rec });
		process.stdout.write(`${(change || 'unchanged').padEnd(15)} ${t.mainSlug}  ${t.url}\n`);
	}
}
await Promise.all(Array.from({ length: CONCURRENCY }, worker));

state.lastRun = today;
writeFileSync(STATE_FILE, JSON.stringify(state, null, '\t') + '\n');

// ─── отчёт ───────────────────────────────────────────────────────────────────

const byResult = (r) => results.filter((x) => x.change === r);
const lines = [];
lines.push('# Журнал актуальности прайсов', '');
lines.push(
	`Генерируется \`node scripts/clinics/check-pricelists.mjs\`; состояние — \`journal.json\`. Последний прогон: **${today}**${firstRun ? ' (первый — базовая линия, изменений быть не может)' : ''}.`,
	'',
);
lines.push(
	`Проверено URL: ${results.length}. Цены изменились: ${byResult('prices-changed').length}, файл изменился: ${byResult('file-changed').length}, правка текста без цен: ${byResult('text-changed').length}, ошибки: ${byResult('error').length}, новые: ${byResult('new').length}.`,
	'',
);
const changed = [...byResult('prices-changed'), ...byResult('file-changed')];
lines.push('## Изменились — нужна сверка цен', '');
if (!changed.length) lines.push('Нет.', '');
for (const x of changed) {
	const d = x.rec.lastDiff;
	const diff = d ? ` +${d.added.length}/−${d.removed.length} ценовых токенов (напр. ${[...d.added.slice(0, 4).map((t) => '+' + t), ...d.removed.slice(0, 4).map((t) => '−' + t)].join(' ')})` : '';
	lines.push(`- **${x.slugs.join(', ')}** — ${x.url}${diff}; снимок \`${x.rec.snapshot || '—'}\``);
}
lines.push('');
const errors = byResult('error');
lines.push('## Ошибки доступа', '');
if (!errors.length) lines.push('Нет.', '');
for (const x of errors) lines.push(`- ${x.slugs.join(', ')} — ${x.url}: ${x.rec.lastError}`);
lines.push('');
const texty = byResult('text-changed');
if (texty.length) {
	lines.push('## Правка текста без изменения цен (для сведения)', '');
	for (const x of texty) lines.push(`- ${x.slugs.join(', ')} — ${x.url}`);
	lines.push('');
}

// сводка по клиникам: все записи карты, у которых есть прайс
lines.push('## По клиникам', '');
lines.push('| Клиника | Источник | Проверен | Изменился | Наш импорт | Статус |', '|---|---|---|---|---|---|');
const allUrls = Object.values(state.urls);
for (const entry of map) {
	if (!entry.pricelists?.length || !PRICE_STATUSES.has(entry.status)) continue;
	const slug = entry.clinics[0].slug;
	const recs = allUrls.filter((r) => r.clinics?.includes(slug));
	if (!recs.length) continue;
	const checked = recs.map((r) => r.lastChecked).sort().pop();
	const changedAt = recs.map((r) => r.lastChanged).filter(Boolean).sort().pop() || '—';
	const statusCell = recs.some((r) => r.lastResult === 'error')
		? 'ошибка'
		: recs.some((r) => ['prices-changed', 'file-changed'].includes(r.lastResult))
			? '**изменился**'
			: 'ок';
	const src = recs[0].url.replace(/^https?:\/\/(www\.)?/, '').slice(0, 60) + (recs.length > 1 ? ` (+${recs.length - 1})` : '');
	const lu = recs.find((r) => r.lastUpdated)?.lastUpdated;
	lines.push(
		`| ${entry.clinics.map((c) => c.slug).join(', ')} | ${src}${lu ? ` (lastUpdated ${lu})` : ''} | ${checked} | ${changedAt} | ${importDate(slug, entry) || '—'} | ${statusCell} |`,
	);
}
lines.push('');
writeFileSync(REPORT_FILE, lines.join('\n'));

console.log(
	`\n${results.length} URL: prices-changed ${byResult('prices-changed').length}, file-changed ${byResult('file-changed').length}, text-changed ${texty.length}, error ${errors.length}, new ${byResult('new').length}`,
);
console.log(`→ ${REPORT_FILE}`);
