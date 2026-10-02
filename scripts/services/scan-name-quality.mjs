#!/usr/bin/env node
/**
 * Аудит качества названий услуг или анализов (--catalog svc|lab) во всех шести
 * локалях + покрытие синонимами.
 *
 * Разбор находок и план работ — docs/audit/service-names-2026-09.md.
 * Скрипт ничего не правит: он собирает рабочий список, по которому вычитка
 * идёт батчами (конвенция — docs/import/CLINIC_SERVICES_IMPORT.md).
 *
 * Классы дефектов:
 *   ekavica_sr       — экавица в name_sr (сайт ведётся на иекавице);
 *   diacritics_sr    — потерянная диакритика, подтверждённая корпусом названий;
 *   truncated_ru     — name_ru обрывается относительным прилагательным без
 *                      опорного существительного («Перелом пяточной»);
 *   short_vs_en      — локаль вдвое короче name_en: смысл потерян либо сжат;
 *   copy_of_en       — name_de / name_tr / name_ru дословно равны name_en;
 *   empty_<loc>      — локаль пустая или NULL (у анализов такое есть);
 *   mixed_script     — кириллица и латиница внутри одного слова (такое слово
 *                      выглядит нормально, но не находится поиском);
 *   no_synonyms      — у записи нет ни одной строки в таблице синонимов.
 *
 * Usage: node scripts/services/scan-name-quality.mjs [--catalog svc|lab] [--min-clinics 0] [--json <path>]
 */

import mysql from 'mysql2/promise';
import { writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';
import {
	EKAVICA, DIACRITIC_HOMOGRAPHS, RU_ADJ_TAIL, RU_ADJ_TAIL_OK, RU_LATIN_OK,
	tokens, foldSerbian as fold, hasDiacritics, lastWord, mixedScriptWords,
} from '../common/service-name-rules.mjs';
import { catalogFromArgv } from '../common/name-review-catalog.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');

const argMin = process.argv.indexOf('--min-clinics');
const MIN_CLINICS = argMin > -1 ? Number(process.argv[argMin + 1]) : 0;
const argJson = process.argv.indexOf('--json');
const C = catalogFromArgv(ROOT);
const JSON_OUT = resolve(ROOT, argJson > -1 ? process.argv[argJson + 1] : `${C.dir}/_flags.json`);


// ─────────────────────────────────────────────────────────────────────────────

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [rows] = await db.query(`
	SELECT s.id, s.slug, s.name_en, s.name_sr, s.name_sr_cyrl, s.name_ru, s.name_de, s.name_tr,
	       COUNT(DISTINCT cs.clinic_id) AS clinics,
	       GROUP_CONCAT(DISTINCT cat.name ORDER BY cat.name SEPARATOR ', ') AS categories,
	       (SELECT COUNT(*) FROM ${C.synonymTable} m WHERE m.${C.fk} = s.id) AS synonyms
	  FROM ${C.table} s
	  LEFT JOIN ${C.clinicTable} cs ON cs.${C.fk} = s.id
	  LEFT JOIN ${C.categoryRelTable} rel ON rel.${C.fk} = s.id
	  LEFT JOIN ${C.categoryTable} cat ON cat.id = rel.${C.categoryRelColumn}
	 GROUP BY s.id
	 ORDER BY clinics DESC, s.name_en`);
await db.end();

/**
 * Как слово пишется в корпусе name_sr: если вариант с диакритикой встречается
 * не реже голого, голый — опечатка. Проверка корпусная, а не по словарю: свой
 * словарь сербского в репозитории держать незачем.
 */
const spellings = new Map();
for (const r of rows) {
	for (const t of tokens(r.name_sr)) {
		const f = fold(t);
		if (!spellings.has(f)) spellings.set(f, new Map());
		spellings.get(f).set(t, (spellings.get(f).get(t) || 0) + 1);
	}
}
const canonical = new Map();
for (const [f, variants] of spellings) {
	if (DIACRITIC_HOMOGRAPHS.has(f)) continue;
	const withDiacritics = [...variants].filter(([w]) => hasDiacritics(w)).sort((a, b) => b[1] - a[1]);
	const plain = variants.get(f) || 0;
	if (withDiacritics.length && withDiacritics[0][1] >= plain) canonical.set(f, withDiacritics[0][0]);
}

const flags = {};
const noSynonyms = [];
const flag = (kind, r, detail) => {
	(flags[kind] ||= []).push({
		id: r.id, slug: r.slug, clinics: r.clinics, categories: r.categories,
		name_en: r.name_en, name_sr: r.name_sr, name_ru: r.name_ru,
		name_de: r.name_de, name_tr: r.name_tr, detail,
	});
};

for (const r of rows) {
	if (r.clinics < MIN_CLINICS) continue;
	for (const col of ['name_en', 'name_sr', 'name_sr_cyrl', 'name_ru', 'name_de', 'name_tr']) {
		if (!r[col] || !String(r[col]).trim()) { flag(`empty_${col.slice(5)}`, r, col); r[col] = ''; }
	}
	const mixed = ['name_sr', 'name_sr_cyrl', 'name_ru', 'name_de', 'name_tr'].flatMap((col) => mixedScriptWords(r[col]).map((w) => `${col.slice(5)}: ${w}`));
	if (mixed.length) flag('mixed_script', r, mixed.join(', '));
	const { name_en: en = '', name_sr: sr = '', name_ru: ru = '', name_de: de = '', name_tr: tr = '' } = r;

	const ekavica = [...new Set(tokens(sr).filter((t) => EKAVICA.has(t)))];
	if (ekavica.length) flag('ekavica_sr', r, ekavica.join(', '));

	const lost = tokens(sr)
		.filter((t) => !hasDiacritics(t) && canonical.has(t) && canonical.get(t) !== t)
		.map((t) => `${t} → ${canonical.get(t)}`);
	if (lost.length) flag('diacritics_sr', r, [...new Set(lost)].join(', '));

	const tail = lastWord(ru);
	if (tail.length > 4 && RU_ADJ_TAIL.test(tail) && !RU_ADJ_TAIL_OK.has(tail)) flag('truncated_ru', r, tail);

	for (const [loc, value] of [['ru', ru], ['de', de], ['tr', tr], ['sr', sr]]) {
		if (!value || !en) continue;
		if (value === en && loc !== 'sr') flag('copy_of_en', r, loc);
		if (en.length >= 40 && value.length < en.length * 0.55) flag('short_vs_en', r, `${loc}: ${value.length}/${en.length}`);
	}

	if (/[A-Za-z]{4,}/.test(ru.replace(RU_LATIN_OK, ''))) flag('ru_latin', r, ru);
	if (!r.synonyms) noSynonyms.push(r.id);
}

// Услуг без синонимов почти весь каталог, и дефект у них один и тот же —
// разворачивать их в полные карточки значит раздуть отчёт с 70 КБ до 2,5 МБ
// ради нуля информации. Рабочий ростер под вычитку собирается отдельно.
writeFileSync(JSON_OUT, JSON.stringify({ ...flags, no_synonyms: noSynonyms }, null, '\t') + '\n');

const buckets = { '10+': 0, '5-9': 0, '3-4': 0, '2': 0, '1': 0, '0': 0 };
for (const r of rows) {
	const c = r.clinics;
	buckets[c >= 10 ? '10+' : c >= 5 ? '5-9' : c >= 3 ? '3-4' : c === 2 ? '2' : c === 1 ? '1' : '0'] += 1;
}

console.log(`${C.noun}: ${rows.length}, покрытие клиниками: ` + Object.entries(buckets).map(([k, v]) => `${k}=${v}`).join(' '));
console.log('');
for (const [kind, list] of [...Object.entries(flags), ['no_synonyms', noSynonyms]].sort((a, b) => b[1].length - a[1].length)) {
	console.log(`${String(list.length).padStart(5)}  ${kind}`);
}
console.log(`\nотчёт: ${JSON_OUT}`);
