#!/usr/bin/env node
/**
 * Собирает миграции названий услуг из батчей data/service-names/ (README там же):
 *
 *   036-service-names-mechanical.sql — шаг 1: батчи fix-*.json + синхронизация
 *                                      name_sr_cyrl с name_sr по всему каталогу;
 *   037-service-names-review.sql     — шаг 2: батчи review-*.json (названия + синонимы).
 *
 * Применяются строго по порядку: 037 считается поверх 036.
 *
 * Что сборщик делает сам, а батчи не пишут:
 *   - name_sr_cyrl — из name_sr (scripts/common/sr-cyrl-names.mjs) с сохранением
 *     ручной кириллицы, где она честно транслитерирует латиницу;
 *   - sr-cyrl-синонимы — транслитерацией sr-синонимов;
 *   - старое name_en при переименовании → синоним en: на него ссылались
 *     импорты и по нему находили услугу;
 *   - старое name_sr с экавицей при правке на иекавицу → синоним sr: так пишут
 *     и ищут люди из Сербии («lekar», «lečenje»), а поиск ять не складывает.
 *
 * Конфликты — поле, которое шаг 1 и шаг 2 поправили по-разному, — пишутся
 * в _conflicts.md. Первыми батчи вычитки шли по старым названиям, и их правка
 * может откатить лучшую правку шага 1. Решение — в _overrides.json
 * ({ "slug": { "ru": "..." } }), он применяется последним.
 *
 * Строки обновляются по slug, а не по id: локальная БД и прод расходятся
 * по автоинкременту (импорты, применённые только локально).
 *
 * Usage: node scripts/services/build-service-names-sql.mjs
 */

import mysql from 'mysql2/promise';
import { existsSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';
import { createNameTransliterator } from '../common/sr-cyrl-names.mjs';
import { EKAVICA, tokens, searchFold } from '../common/service-name-rules.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');
const DIR = resolve(ROOT, 'data/service-names');
const MIGRATIONS = resolve(ROOT, 'server/sql/migrations');

const LOCALES = ['en', 'sr', 'ru', 'de', 'tr'];
const COLUMNS = ['en', 'sr', 'sr_cyrl', 'ru', 'de', 'tr'];

const readBatches = (prefix) =>
	readdirSync(DIR)
		.filter((f) => new RegExp(`^${prefix}-\\d+\\.json$`).test(f))
		.sort()
		.map((f) => ({ file: f, items: JSON.parse(readFileSync(resolve(DIR, f), 'utf-8')) }));

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [services] = await db.query(
	'SELECT id, slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr FROM medical_services',
);
const [existingSynonyms] = await db.query('SELECT medical_service_id AS id, another_name, language FROM medical_service_synonyms');
await db.end();

const { mergeCyrillic, transliterate } = createNameTransliterator(services);

const bySlug = new Map(services.map((s) => [s.slug, s]));
const dbNames = new Map(services.map((s) => [s.slug, Object.fromEntries(COLUMNS.map((c) => [c, s[`name_${c}`]]))]));
const existingSyn = new Map();
for (const r of existingSynonyms) {
	const slug = services.find((s) => s.id === r.id)?.slug;
	if (!slug) continue;
	if (!existingSyn.has(slug)) existingSyn.set(slug, new Set());
	existingSyn.get(slug).add(searchFold(r.another_name));
}

const fixBatches = readBatches('fix');
const reviewBatches = readBatches('review');
const overrides = existsSync(resolve(DIR, '_overrides.json'))
	? JSON.parse(readFileSync(resolve(DIR, '_overrides.json'), 'utf-8'))
	: {};

// ── Состояние после каждой стадии: DB → A (fix) → B (review + overrides).
const clone = (m) => new Map([...m].map(([k, v]) => [k, { ...v }]));
const stateA = clone(dbNames);
const stateB = clone(dbNames);

const fixChanges = new Map(); // slug → {loc: value}
for (const { items } of fixBatches) {
	for (const item of items) {
		if (item.names && Object.keys(item.names).length) fixChanges.set(item.slug, { ...(fixChanges.get(item.slug) || {}), ...item.names });
	}
}
const reviewChanges = new Map();
const reviewSynonyms = new Map(); // slug → {loc: [..]}
for (const { items } of reviewBatches) {
	for (const item of items) {
		if (item.names && Object.keys(item.names).length) reviewChanges.set(item.slug, { ...(reviewChanges.get(item.slug) || {}), ...item.names });
		if (item.synonyms) reviewSynonyms.set(item.slug, item.synonyms);
	}
}

// Невидимые символы (мягкий перенос U+00AD, нулевой ширины) — механика по всему
// каталогу: «Гернио-пластика» с мягким переносом не находится запросом «герниопластика».
const INVISIBLE = /[\u00AD\u200B-\u200F\u2060\uFEFF]/g;
for (const state of [stateA, stateB]) {
	for (const names of state.values()) {
		for (const c of COLUMNS) if (names[c]) names[c] = names[c].replace(INVISIBLE, '');
	}
}

for (const [slug, names] of fixChanges) Object.assign(stateA.get(slug), names);
for (const [slug, names] of fixChanges) Object.assign(stateB.get(slug), names);

// Конфликт: шаг 1 и шаг 2 правили одно поле, и итог разный.
const conflicts = [];
for (const [slug, names] of reviewChanges) {
	const fixed = fixChanges.get(slug) || {};
	for (const [loc, value] of Object.entries(names)) {
		if (fixed[loc] !== undefined && fixed[loc] !== value && !overrides[slug]?.[loc]) {
			conflicts.push({ slug, loc, db: dbNames.get(slug)[loc], fix: fixed[loc], review: value });
		}
	}
	Object.assign(stateB.get(slug), names);
}
for (const [slug, names] of Object.entries(overrides)) {
	if (!stateB.has(slug)) throw new Error(`_overrides.json: слага ${slug} нет в БД`);
	Object.assign(stateB.get(slug), names);
}

// ── Кириллица: пересчитывается по каждой стадии от предыдущей.
for (const [slug, a] of stateA) {
	const d = dbNames.get(slug);
	a.sr_cyrl = mergeCyrillic(d.sr_cyrl, a.sr, d.sr);
}
for (const [slug, b] of stateB) {
	const a = stateA.get(slug);
	b.sr_cyrl = a.sr === b.sr ? a.sr_cyrl : mergeCyrillic(a.sr_cyrl, b.sr, a.sr);
}

// ── Все итоговые имена каталога — синоним не должен совпадать ни с одним чужим.
const nameOwners = new Map();
for (const [slug, names] of stateB) {
	for (const v of Object.values(names)) {
		if (!v) continue;
		const k = searchFold(v);
		if (!nameOwners.has(k)) nameOwners.set(k, new Set());
		nameOwners.get(k).add(slug);
	}
}

const isEkavian = (s) => tokens(s).some((t) => EKAVICA.has(t));

/** Синонимы одной стадии: то, что пришло из батчей, плюс автоматические. */
function synonymsFor(slug, before, after, explicit) {
	const out = [];
	const seen = new Set([...(existingSyn.get(slug) || [])]);
	const own = Object.values(after).filter(Boolean).map(searchFold);
	const add = (value, language, auto) => {
		const k = searchFold(value);
		if (!value || seen.has(k)) return;
		if (own.some((n) => n.includes(k))) return; // и так находится по названию
		const others = [...(nameOwners.get(k) || [])].filter((s) => s !== slug);
		if (others.length) return; // чужое название — перетянет запросы
		seen.add(k);
		out.push({ value, language, auto });
	};
	if (before.en !== after.en) add(before.en, 'en', 'старое name_en');
	if (before.sr !== after.sr && isEkavian(before.sr)) {
		add(before.sr, 'sr', 'экавский вариант');
		add(transliterate(before.sr), 'sr-cyrl', 'экавский вариант');
	}
	for (const [loc, list] of Object.entries(explicit || {})) {
		for (const v of list || []) {
			add(v, loc, null);
			if (loc === 'sr') add(transliterate(v), 'sr-cyrl', null);
		}
	}
	return out;
}

const sq = (s) => `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`;

function updates(before, after, slugs) {
	const lines = [];
	const diff = [];
	for (const slug of slugs) {
		const b = before.get(slug);
		const a = after.get(slug);
		const changed = COLUMNS.filter((c) => a[c] !== b[c]);
		if (!changed.length) continue;
		lines.push(`UPDATE medical_services SET\n${changed.map((c) => `\tname_${c} = ${sq(a[c])}`).join(',\n')}\n WHERE slug = ${sq(slug)};`);
		diff.push({ slug, changes: changed.map((c) => ({ col: c, from: b[c], to: a[c] })) });
	}
	return { sql: lines.join('\n\n'), diff };
}

function inserts(synonymsBySlug) {
	const blocks = [];
	for (const [slug, list] of synonymsBySlug) {
		if (!list.length) continue;
		const selects = list.map(
			(s, i) => `${i ? 'UNION ALL ' : '          '}SELECT id, ${sq(s.value)}, ${sq(s.language)} FROM medical_services WHERE slug = ${sq(slug)}`,
		);
		blocks.push(`INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)\n${selects.join('\n')};`);
	}
	return blocks.join('\n\n');
}

const HEADER = `SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

START TRANSACTION;`;

// ── 036
const allSlugs = [...dbNames.keys()].sort();
const u036 = updates(dbNames, stateA, allSlugs);
const syn036 = new Map();
for (const slug of fixChanges.keys()) syn036.set(slug, synonymsFor(slug, dbNames.get(slug), stateA.get(slug), null));
const fixedRows = u036.diff.filter((d) => fixChanges.has(d.slug)).length;
const cyrOnlyRows = u036.diff.length - fixedRows;
const syn036Count = [...syn036.values()].reduce((n, l) => n + l.length, 0);

// ── 037
const u037 = updates(stateA, stateB, allSlugs);
const syn037 = new Map();
for (const slug of new Set([...reviewChanges.keys(), ...reviewSynonyms.keys(), ...Object.keys(overrides)])) {
	syn037.set(slug, synonymsFor(slug, stateA.get(slug), stateB.get(slug), reviewSynonyms.get(slug)));
}
const syn037Count = [...syn037.values()].reduce((n, l) => n + l.length, 0);
const reviewedCount = reviewBatches.reduce((n, b) => n + b.items.length, 0);

const cmd = (file) => `-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/${file}`;

const sql036 = `-- 036: названия услуг — механические дефекты (шаг 1 из docs/audit/service-names-2026-09.md).
--
${cmd('036-service-names-mechanical.sql')}
--
-- Собрано скриптом scripts/services/build-service-names-sql.mjs из
-- data/service-names/fix-*.json — руками не править, пересобирать.
--
-- Что чинится:
--   - русские названия, обрубленные на прилагательном без опорного слова
--     («Перелом пяточной» → «… пяточной кости»); в основном партия прайса FZOCG;
--   - экавица в name_sr (сайт на иекавице) и потерянная диакритика;
--   - name_sr_cyrl, разошедшийся с name_sr: латинская буква внутри кириллического
--     слова («Циркониjум» — такое слово не находится поиском), экавица в
--     кириллице при иекавской латинице, обрубленная кириллица, опечатки.
--     Ручная кириллица, которая честно транслитерирует латиницу («Ботокс»,
--     «Ашерман», «vena cava inferior»), сохраняется.
--
-- Строк: ${u036.diff.length} (правки батчей — ${fixedRows}, только синхронизация кириллицы — ${cyrOnlyRows}).
-- Синонимов: ${syn036Count} — старые name_en и экавские варианты исправленных name_sr,
-- чтобы прежние формулировки продолжали находиться.
--
-- Обновление по slug, а не по id: у локальной БД и прода разный автоинкремент.
-- Идемпотентно: присваиваются готовые значения, синонимы — INSERT IGNORE.
-- Применять ДО 037.

${HEADER}

${u036.sql}

${inserts(syn036)}

COMMIT;
`;

const sql037 = `-- 037: названия услуг — вычитка и синонимы (шаг 2 из docs/audit/service-names-2026-09.md).
--
${cmd('037-service-names-review.sql')}
--
-- Собрано скриптом scripts/services/build-service-names-sql.mjs из
-- data/service-names/review-*.json — руками не править, пересобирать.
-- Применять ПОСЛЕ 036: значения посчитаны поверх неё.
--
-- Вычитаны услуги, которые есть в трёх клиниках и больше (${reviewedCount} шт.), во всех
-- локалях: обрубки, кальки и латинизмы там, где есть обычное слово, порядок
-- слов из прайса, неверные термины, разнобой внутри серий.
-- Строк: ${u037.diff.length}. Синонимов: ${syn037Count}. До этой миграции синонимы были у 83 услуг
-- из 4991, и почти все попали туда побочно, при слиянии дублей.
--
-- Поиск читает синонимы уже сейчас (server/api/services/list.ts) — кода не нужно.
-- sr-cyrl-синонимы получены транслитерацией sr. Синоним, совпадающий с
-- названием другой услуги или являющийся подстрокой своего, отброшен.
--
-- Обновление по slug, а не по id. Идемпотентно.

${HEADER}

${u037.sql}

${inserts(syn037)}

COMMIT;
`;

writeFileSync(resolve(MIGRATIONS, '036-service-names-mechanical.sql'), sql036);
writeFileSync(resolve(MIGRATIONS, '037-service-names-review.sql'), sql037);

// ── Отчёты для глаз
const md = (title, diff, syn) => {
	const lines = [`# ${title}`, ''];
	for (const { slug, changes } of diff) {
		lines.push(`### ${slug}`);
		for (const { col, from, to } of changes) lines.push(`- **${col}**: ${from} → ${to}`);
		const s = syn.get(slug);
		if (s?.length) lines.push(`- синонимы: ${s.map((x) => `${x.value} _(${x.language}${x.auto ? `, ${x.auto}` : ''})_`).join('; ')}`);
		lines.push('');
	}
	const onlySyn = [...syn].filter(([slug, l]) => l.length && !diff.some((d) => d.slug === slug));
	if (onlySyn.length) {
		lines.push('## Только синонимы', '');
		for (const [slug, l] of onlySyn) lines.push(`- **${slug}**: ${l.map((x) => `${x.value} _(${x.language})_`).join('; ')}`);
	}
	return lines.join('\n') + '\n';
};
writeFileSync(resolve(DIR, '_diff-036.md'), md('036 — механика', u036.diff, syn036));
writeFileSync(resolve(DIR, '_diff-037.md'), md('037 — вычитка и синонимы', u037.diff, syn037));
writeFileSync(
	resolve(DIR, '_conflicts.md'),
	`# Конфликты шага 1 и шага 2\n\nПоле поправлено обоими шагами по-разному. По умолчанию побеждает шаг 2; решение — в _overrides.json.\n\n` +
		(conflicts.length
			? conflicts.map((c) => `### ${c.slug} · ${c.loc}\n- БД: ${c.db}\n- fix: ${c.fix}\n- review: ${c.review}\n`).join('\n')
			: 'Нет.\n'),
);

console.log(`036: строк ${u036.diff.length} (батчи ${fixedRows}, кириллица ${cyrOnlyRows}), синонимов ${syn036Count}`);
console.log(`037: строк ${u037.diff.length}, синонимов ${syn037Count} (вычитано ${reviewedCount} из ${reviewBatches.length} батчей)`);
console.log(`конфликтов fix/review: ${conflicts.length} → data/service-names/_conflicts.md`);
