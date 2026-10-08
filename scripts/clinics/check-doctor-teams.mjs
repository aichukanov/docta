/**
 * Журнал составов врачей клиник.
 *
 * Обходит источники составов из data/clinic-teams/map.json (`teamSources[].url`)
 * и по каждой клинике сравнивает с нашей БД и с прошлым прогоном:
 *   - наши врачи клиники (doctor_clinics), которых нет ни в одном источнике, — кандидаты
 *     на отвязку; считается только там, где сайт даёт полный список (`dbOnlyIsEvidence`);
 *   - новые имена на сайте вида «Dr Ime Prezime», которых нет в БД, — кандидаты на импорт;
 *   - новые ссылки на PDF на страницах-оглавлениях (ДЗ Подгорица публикует графики
 *     помесячно — новый файл = новый состав).
 * Имена сравниваются без диакритики, в любом порядке слов, по латинице и кириллице.
 * PDF читаются через PyMuPDF (py -3.12); без него у PDF остаётся только отпечаток байтов.
 *
 * Состояние — data/clinic-teams/journal.json, отчёт — journal.md. map.json не трогается.
 * БД — локальная (.env); перед прогоном она должна совпадать с продом.
 *
 * Usage:
 *   node scripts/clinics/check-doctor-teams.mjs [--only=<slug,slug>]
 */

import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import mysql from 'mysql2/promise';
import {
	fetchUrl,
	isJsonResponse,
	isPdfResponse,
	isTextResponse,
	pdfText,
	sha,
	stableJson,
	today as todayFn,
	visibleText,
} from './lib/source-fetch.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '../..');
const DIR = resolve(ROOT, 'data/clinic-teams');
const MAP_FILE = resolve(DIR, 'map.json');
const STATE_FILE = resolve(DIR, 'journal.json');
const REPORT_FILE = resolve(DIR, 'journal.md');
const CONCURRENCY = 5;
const today = todayFn();

// Статусы карты, у которых есть что сверять. partial_team — только новые имена, без отвязки.
const TEAM_STATUSES = new Set(['team_page', 'doctors_on_service_pages', 'doctor_pages', 'partial_team']);
const SKIP_URL = [
	/web\.archive\.org/,
	/[<>]/, // шаблоны в карте вида /poliklinika/<odjeljenje> — не адрес
	/=\d+\.\.\d+/, // диапазон страниц page=1..4 — пометка, а не адрес
];

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

// ─── имена ───────────────────────────────────────────────────────────────────

const CYR = { а: 'a', б: 'b', в: 'v', г: 'g', д: 'd', ђ: 'dj', е: 'e', ж: 'z', з: 'z', и: 'i', ј: 'j', к: 'k', л: 'l', љ: 'lj', м: 'm', н: 'n', њ: 'nj', о: 'o', п: 'p', р: 'r', с: 's', т: 't', ћ: 'c', у: 'u', ф: 'f', х: 'h', ц: 'c', ч: 'c', џ: 'dz', ш: 's', й: 'j', ы: 'y', э: 'e', ю: 'ju', я: 'ja', ь: '', ъ: '', ё: 'e', щ: 's' };

/** Нижний регистр, без диакритики, кириллица → латиница, только буквы и пробелы. */
function norm(s) {
	return (s || '')
		.toLowerCase()
		.replace(/[а-яёђјљњћџ]/g, (ch) => CYR[ch] ?? ch)
		.replace(/đ/g, 'dj')
		.normalize('NFD')
		.replace(/[̀-ͯ]/g, '')
		.replace(/[^a-z]+/g, ' ')
		.trim();
}

const STOP = new Set(['dr', 'prof', 'doc', 'prim', 'med', 'sci', 'spec', 'stom', 'mr', 'mag', 'ph']);
const nameTokens = (s) => norm(s).split(' ').filter((t) => t.length > 1 && !STOP.has(t));

/**
 * Врач найден в тексте, если его имя и хотя бы одна фамилия стоят рядом (до двух слов
 * между ними — второе имя, двойная фамилия) в любом порядке. Варианты имени — sr, sr-cyrl, en, ru.
 */
function foundIn(textNorm, doctor) {
	for (const variant of doctor.names) {
		const t = nameTokens(variant);
		if (t.length < 2) continue;
		const first = t[0];
		for (const surname of t.slice(1)) {
			const re = new RegExp(`\\b${first}\\b(?: \\w+){0,2} ${surname}\\b|\\b${surname}\\b(?: \\w+){0,2} ${first}\\b`);
			if (re.test(textNorm)) return true;
		}
	}
	return false;
}

// «Dr Ime Prezime», «Prof. dr Ime Prezime-Prezime», «Prim. dr med. Ime Prezime»
const CANDIDATE_RE =
	/\b(?:prof\.?\s*|doc\.?\s*|prim\.?\s*|mr\.?\s*(?:sci\.?\s*)?)?dr\.?\s*(?:med\.?\s*|sci\.?\s*|stom\.?\s*)*((?:[A-ZŠĐČĆŽ][a-zšđčćž]+)(?:[ -][A-ZŠĐČĆŽ][a-zšđčćž]+){1,2})/g;

function candidates(text) {
	const out = new Set();
	for (const m of text.matchAll(CANDIDATE_RE)) out.add(m[1].trim());
	return [...out];
}

// ─── main ────────────────────────────────────────────────────────────────────

const map = JSON.parse(readFileSync(MAP_FILE, 'utf-8'));
const state = existsSync(STATE_FILE) ? JSON.parse(readFileSync(STATE_FILE, 'utf-8')) : { sources: {}, clinics: {} };
const firstRun = !Object.keys(state.sources).length;

const db = await mysql.createConnection({
	host: process.env.DB_HOST || 'localhost',
	user: process.env.DB_USER || 'root',
	password: process.env.DB_PASSWORD || '',
	database: process.env.DB_NAME,
	port: Number(process.env.DB_PORT || 3306),
});
const [doctorRows] = await db.query(
	`SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, d.name_en, d.name_ru FROM doctors d WHERE d.is_draft = 0`,
);
const [linkRows] = await db.query(
	`SELECT c.slug clinic, d.slug doctor FROM doctor_clinics dc
	 JOIN clinics c ON c.id = dc.clinic_id JOIN doctors d ON d.id = dc.doctor_id`,
);
await db.end();

const doctors = new Map(
	doctorRows.map((d) => [d.slug, { slug: d.slug, name: d.name_sr, names: [d.name_sr, d.name_sr_cyrl, d.name_en, d.name_ru].filter(Boolean) }]),
);
const doctorsByClinic = new Map();
for (const l of linkRows) {
	if (!doctorsByClinic.has(l.clinic)) doctorsByClinic.set(l.clinic, []);
	doctorsByClinic.get(l.clinic).push(l.doctor);
}
// индекс «пара токенов имени» → есть в БД, для отсева кандидатов
const knownPairs = new Set();
for (const d of doctors.values())
	for (const v of d.names) {
		const t = nameTokens(v);
		for (let i = 0; i < t.length; i++) for (let j = 0; j < t.length; j++) if (i !== j) knownPairs.add(`${t[i]} ${t[j]}`);
	}
const isKnown = (name) => {
	const t = nameTokens(name);
	for (let i = 0; i < t.length; i++) for (let j = i + 1; j < t.length; j++) if (knownPairs.has(`${t[i]} ${t[j]}`)) return true;
	return false;
};

const entries = map.filter(
	(e) => TEAM_STATUSES.has(e.status) && e.teamSources?.length && (!only || e.clinics.some((c) => only.includes(c.slug))),
);

// уникальные URL (у сетей один источник на несколько записей)
const urls = [...new Set(entries.flatMap((e) => e.teamSources.map((s) => s.url)).filter((u) => u && !SKIP_URL.some((re) => re.test(u))))];
const texts = new Map(); // видимый текст — для новых имён
const rawTexts = new Map(); // + сырой HTML (встроенные JSON Next/Nuxt/Webflow, бандлы) — для поиска наших врачей
let next = 0;
async function worker() {
	while (next < urls.length) {
		const url = urls[next++];
		const prev = state.sources[url];
		const res = await fetchUrl(url);
		const rec = { ...(prev || { firstSeen: today }), url, lastChecked: today };
		let text = '';
		if (res.error || !res.status || res.status >= 400) {
			rec.lastError = res.error || `HTTP ${res.status}`;
			rec.lastResult = 'error';
		} else {
			rec.lastError = null;
			if (isTextResponse(res, url)) {
				const raw = res.body.toString('utf-8');
				if (isJsonResponse(res, url)) {
					try {
						text = stableJson(JSON.parse(raw)).replace(/[{}[\]",:]+/g, ' ');
					} catch {
						text = raw;
					}
				} else {
					text = visibleText(raw);
					rawTexts.set(url, raw);
					// ссылки на PDF — для оглавлений графиков
					const pdfs = [...raw.matchAll(/href\s*=\s*["']([^"']+\.pdf)["']/gi)].map((m) => {
						try {
							return new URL(m[1], res.finalUrl || url).toString();
						} catch {
							return null;
						}
					});
					const pdfSet = [...new Set(pdfs.filter(Boolean))].sort();
					rec.newPdfLinks = prev?.pdfLinks ? pdfSet.filter((p) => !prev.pdfLinks.includes(p)) : [];
					rec.pdfLinks = pdfSet;
				}
				rec.hash = sha(text);
			} else if (isPdfResponse(res, url)) {
				rec.hash = sha(res.body);
				text = (await pdfText(res.body)) || '';
				rec.pdfTextOk = Boolean(text);
			} else {
				rec.hash = sha(res.body);
			}
			rec.lastResult = !prev ? 'new' : prev.hash !== rec.hash ? 'changed' : 'unchanged';
			if (rec.lastResult === 'changed') rec.lastChanged = today;
		}
		state.sources[url] = rec;
		texts.set(url, text);
		process.stdout.write(`${rec.lastResult.padEnd(10)} ${url}\n`);
	}
}
await Promise.all(Array.from({ length: CONCURRENCY }, worker));

// ─── сверка по клиникам ──────────────────────────────────────────────────────

const report = [];
for (const e of entries) {
	const key = e.clinics.map((c) => c.slug).join('+');
	const prev = state.clinics[key];
	const srcUrls = e.teamSources.map((s) => s.url).filter((u) => texts.has(u));
	const fullText = srcUrls.map((u) => texts.get(u)).join('\n');
	const textNorm = norm(srcUrls.map((u) => `${texts.get(u)}\n${rawTexts.get(u) || ''}`).join('\n'));
	const linked = [...new Set(e.clinics.flatMap((c) => doctorsByClinic.get(c.slug) || []))];
	const errors = srcUrls.filter((u) => state.sources[u].lastResult === 'error');
	const allFailed = errors.length === srcUrls.length;

	// отсутствие врача — сигнал только при полном списке и если источники прочитались
	const evidence = e.dbOnlyIsEvidence && e.status !== 'partial_team' && !allFailed;
	const missing = evidence ? linked.filter((s) => doctors.has(s) && !foundIn(textNorm, doctors.get(s))).sort() : [];
	const cands = candidates(fullText).filter((n) => !isKnown(n)).sort();

	const rec = {
		lastChecked: today,
		linked: linked.length,
		missing,
		candidates: cands,
		newlyMissing: prev ? missing.filter((s) => !prev.missing.includes(s)) : [],
		newCandidates: prev ? cands.filter((n) => !prev.candidates.includes(n)) : [],
		changedSources: srcUrls.filter((u) => state.sources[u].lastResult === 'changed'),
		newPdfLinks: srcUrls.flatMap((u) => state.sources[u].newPdfLinks || []),
		errors,
		lastChanged: prev?.lastChanged || null,
	};
	// правка текста страницы сама по себе не событие (у части сайтов на странице счётчики и даты)
	if (rec.newlyMissing.length || rec.newCandidates.length || rec.newPdfLinks.length) rec.lastChanged = today;
	state.clinics[key] = rec;
	report.push({ key, e, rec });
}

state.lastRun = today;
writeFileSync(STATE_FILE, JSON.stringify(state, null, '\t') + '\n');

// ─── отчёт ───────────────────────────────────────────────────────────────────

const name = (slug) => `${doctors.get(slug)?.name || slug} (\`${slug}\`)`;
const L = [];
L.push('# Журнал составов врачей', '');
L.push(
	`Генерируется \`node scripts/clinics/check-doctor-teams.mjs\`; состояние — \`journal.json\`. Последний прогон: **${today}**${firstRun ? ' (первый — базовая линия: «новое» ниже не считается, смотреть разделы «сейчас»)' : ''}.`,
	'',
);
const changed = report.filter(
	(r) => r.rec.newlyMissing.length || r.rec.newCandidates.length || r.rec.newPdfLinks.length,
);
L.push('## Изменилось с прошлого прогона', '');
if (firstRun || !changed.length) L.push(firstRun ? 'Первый прогон — сравнивать не с чем.' : 'Нет.', '');
if (!firstRun)
	for (const { key, rec } of changed) {
		L.push(`### ${key}`);
		if (rec.newlyMissing.length) L.push(`- пропали с сайта: ${rec.newlyMissing.map(name).join(', ')}`);
		if (rec.newCandidates.length) L.push(`- новые имена на сайте: ${rec.newCandidates.join(', ')}`);
		if (rec.newPdfLinks.length) L.push(`- новые PDF: ${rec.newPdfLinks.join(', ')}`);
		L.push('');
	}
const missingNow = report.filter((r) => r.rec.missing.length);
L.push('## Сейчас нет на сайте (полный список, кандидаты на отвязку)', '');
L.push('Имя ищется в любом порядке слов, без диакритики; транслитерации (рус. → лат.) могут дать ложное «нет».', '');
if (!missingNow.length) L.push('Нет.', '');
for (const { key, rec } of missingNow) L.push(`- **${key}** (${rec.missing.length} из ${rec.linked}): ${rec.missing.map(name).join(', ')}`);
L.push('');
const candNow = report.filter((r) => r.rec.candidates.length);
L.push('## Сейчас на сайте, нет в БД (кандидаты на импорт)', '');
L.push('Отбор по шаблону «Dr Ime Prezime»; бывают шаблонные заглушки и не-врачи — сверять глазами.', '');
if (!candNow.length) L.push('Нет.', '');
for (const { key, rec } of candNow) L.push(`- **${key}**: ${rec.candidates.join(', ')}`);
L.push('');
const errs = report.filter((r) => r.rec.errors.length);
L.push('## Ошибки доступа', '');
if (!errs.length) L.push('Нет.', '');
for (const { key, rec } of errs) L.push(`- ${key}: ${rec.errors.map((u) => `${u} — ${state.sources[u].lastError}`).join('; ')}`);
L.push('');
L.push('## По клиникам', '');
L.push('| Клиника | Источников | Проверен | Изменился | Врачей у нас | Нет на сайте | Новых имён |', '|---|---|---|---|---|---|---|');
for (const { key, e, rec } of report)
	L.push(
		`| ${key} | ${e.teamSources.length} | ${rec.lastChecked} | ${rec.lastChanged || '—'} | ${rec.linked} | ${e.dbOnlyIsEvidence && e.status !== 'partial_team' ? rec.missing.length : '—'} | ${rec.candidates.length} |`,
	);
L.push('');
writeFileSync(REPORT_FILE, L.join('\n'));

const pdfFail = Object.values(state.sources).filter((s) => s.pdfTextOk === false).length;
console.log(
	`\n${urls.length} URL, ${report.length} клиник: нет на сайте ${missingNow.reduce((n, r) => n + r.rec.missing.length, 0)}, новых имён ${candNow.reduce((n, r) => n + r.rec.candidates.length, 0)}, ошибок ${errs.length}${pdfFail ? `, PDF без текста ${pdfFail}` : ''}`,
);
console.log(`→ ${REPORT_FILE}`);
