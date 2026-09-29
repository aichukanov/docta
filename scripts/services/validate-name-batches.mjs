#!/usr/bin/env node
/**
 * Проверка батчей вычитки названий услуг перед сборкой SQL.
 *
 * Батч — data/service-names/{fix,review}-NN.json, ростер к нему —
 * _batch-{fix,review}-NN.json. Формат и правила — data/service-names/README.md.
 *
 * ERROR — батч в SQL не пойдёт, WARN — посмотреть глазами. Проверяется:
 *   - покрытие: каждая услуга ростера ровно один раз, чужих слагов нет;
 *   - названия: экавица и кириллица в sr, латиница в ru, смешение алфавитов
 *     внутри слова, обрыв на прилагательном, поменявшиеся цифры, name_en —
 *     не из замороженных (на него завязаны неприменённые импорты) и не чужой;
 *   - синонимы: не своё название, не подстрока своего названия (и так находится),
 *     не название другой услуги (перетянет её запросы), не общее слово,
 *     одна строка — один язык (поиск по синонимам от языка не зависит).
 *
 * Без --file проверяются все батчи разом — только так ловятся столкновения
 * между батчами (агент A переименовал услугу в то, что агент B взял синонимом).
 *
 * Usage: node scripts/services/validate-name-batches.mjs [--file data/service-names/review-07.json]
 */

import mysql from 'mysql2/promise';
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { basename, resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';
import {
	EKAVICA, RU_ADJ_TAIL, RU_ADJ_TAIL_OK, RU_LATIN_OK,
	tokens, lastWord, mixedScriptWords, searchFold,
} from '../common/service-name-rules.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');
const DIR = resolve(ROOT, 'data/service-names');

const NAME_LOCALES = ['en', 'sr', 'ru', 'de', 'tr'];
const DB_NAME_COLUMNS = ['name_en', 'name_sr', 'name_sr_cyrl', 'name_ru', 'name_de', 'name_tr'];
const MAX_NAME = 255;
const MAX_SYNONYM = 100;
const MAX_SYNONYMS_PER_LOCALE = 4;

/**
 * Одно слово, которое совпадёт с сотней услуг и замусорит выдачу.
 * Сверяется после searchFold, поэтому диакритики и регистра здесь нет.
 */
const GENERIC = new Set([
	'операция', 'осмотр', 'консультация', 'узи', 'рентген', 'кт', 'мрт', 'мскт', 'анализ', 'процедура',
	'лечение', 'терапия', 'массаж', 'биопсия', 'пункция', 'удаление', 'перевязка', 'инъекция', 'укол',
	'прием', 'врач', 'диагностика', 'обследование', 'исследование', 'снимок', 'анестезия', 'наркоз',
	'хирургия', 'стоматология', 'пломба', 'коронка', 'чистка', 'протез', 'имплант', 'имплантат',
	'operacija', 'pregled', 'konsultacija', 'ultrazvuk', 'uz', 'rtg', 'rendgen', 'ct', 'mr', 'msct',
	'analiza', 'procedura', 'lijecenje', 'terapija', 'masaza', 'biopsija', 'punkcija', 'uklanjanje',
	'previjanje', 'injekcija', 'ljekar', 'lekar', 'dijagnostika', 'snimak', 'anestezija', 'hirurgija',
	'plomba', 'krunica', 'proteza', 'implant',
	'surgery', 'operation', 'examination', 'consultation', 'ultrasound', 'x-ray', 'xray', 'mri', 'test',
	'procedure', 'treatment', 'therapy', 'massage', 'biopsy', 'puncture', 'removal', 'dressing',
	'injection', 'doctor', 'diagnostics', 'scan', 'anesthesia', 'filling', 'crown', 'denture',
	'untersuchung', 'beratung', 'ultraschall', 'rontgen', 'mrt', 'behandlung', 'therapie', 'biopsie',
	'punktion', 'entfernung', 'verband', 'injektion', 'arzt', 'diagnostik', 'narkose', 'fullung', 'krone',
	'ameliyat', 'muayene', 'konsultasyon', 'ultrason', 'bt', 'tedavi', 'terapi', 'masaj', 'biyopsi',
	'ponksiyon', 'cikarma', 'pansuman', 'enjeksiyon', 'doktor', 'teshis', 'anestezi', 'dolgu', 'kuron',
]);

const argFile = process.argv.indexOf('--file');
const onlyFile = argFile > -1 ? resolve(ROOT, process.argv[argFile + 1]) : null;

const files = onlyFile
	? [onlyFile]
	: readdirSync(DIR).filter((f) => /^(fix|review)-\d+\.json$/.test(f)).sort().map((f) => resolve(DIR, f));
if (!files.length) {
	console.log('батчей нет');
	process.exit(0);
}

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [services] = await db.query(`SELECT id, slug, ${DB_NAME_COLUMNS.join(', ')} FROM medical_services`);
const [existingSynonyms] = await db.query('SELECT medical_service_id AS id, another_name FROM medical_service_synonyms');
await db.end();

const bySlug = new Map(services.map((s) => [s.slug, s]));
const frozen = new Set(JSON.parse(readFileSync(resolve(DIR, '_frozen-name-en.json'), 'utf-8')));
const existingSynById = new Map();
for (const r of existingSynonyms) {
	if (!existingSynById.has(r.id)) existingSynById.set(r.id, new Set());
	existingSynById.get(r.id).add(searchFold(r.another_name));
}

// Итоговые имена после всех батчей: переименования из батчей накрывают БД.
// Батчи шага 1 учитываются всегда, даже при --file: батч вычитки строится
// поверх них, и без них экавский синоним к уже исправленному названию
// выглядит как «собственное название услуги».
const stepOne = onlyFile
	? readdirSync(DIR).filter((f) => /^fix-\d+\.json$/.test(f)).map((f) => resolve(DIR, f)).filter((p) => p !== onlyFile)
	: [];
for (const path of stepOne) {
	for (const item of JSON.parse(readFileSync(path, 'utf-8'))) {
		const s = services.find((x) => x.slug === item.slug);
		if (s && item.names) for (const [loc, v] of Object.entries(item.names)) s[`__final_${loc}`] = v;
	}
}
const loaded = files.map((path) => {
	try {
		return { path, items: JSON.parse(readFileSync(path, 'utf-8')) };
	} catch (e) {
		return { path, parseError: e.message };
	}
});
const finalNames = new Map(services.map((s) => [s.id, {
	en: s.__final_en ?? s.name_en, sr: s.__final_sr ?? s.name_sr, sr_cyrl: s.name_sr_cyrl,
	ru: s.__final_ru ?? s.name_ru, de: s.__final_de ?? s.name_de, tr: s.__final_tr ?? s.name_tr,
}]));
for (const { items } of loaded) {
	for (const item of Array.isArray(items) ? items : []) {
		const s = bySlug.get(item?.slug);
		if (s && item.names && typeof item.names === 'object') Object.assign(finalNames.get(s.id), item.names);
	}
}
// Свёрнутое имя → id услуг, у которых оно есть в любой локали.
const nameOwners = new Map();
for (const [id, names] of finalNames) {
	for (const v of Object.values(names)) {
		if (!v) continue;
		const k = searchFold(v);
		if (!nameOwners.has(k)) nameOwners.set(k, new Set());
		nameOwners.get(k).add(id);
	}
}
const enOwners = new Map();
for (const [id, names] of finalNames) {
	const k = (names.en || '').toLowerCase();
	if (!enOwners.has(k)) enOwners.set(k, []);
	enOwners.get(k).push(id);
}

const numbers = (s) => ((s || '').match(/\d+(?:[.,]\d+)?/g) || []).sort().join(' ');
const hasCyrillic = (s) => /\p{Script=Cyrillic}/u.test(s);
const hasLatin = (s) => /\p{Script=Latin}/u.test(s);

let errors = 0;
let warns = 0;
const stats = { items: 0, renamed: Object.fromEntries(NAME_LOCALES.map((l) => [l, 0])), synonyms: 0 };

for (const { path, items, parseError } of loaded) {
	const out = [];
	const err = (msg) => { out.push(`  ERROR ${msg}`); errors++; };
	const warn = (msg) => { out.push(`  WARN  ${msg}`); warns++; };
	const kind = basename(path).startsWith('fix-') ? 'fix' : 'review';

	if (parseError) {
		err(`JSON не читается: ${parseError}`);
	} else if (!Array.isArray(items)) {
		err('корень файла — не массив');
	} else {
		const rosterPath = resolve(DIR, `_batch-${basename(path)}`);
		const roster = existsSync(rosterPath) ? JSON.parse(readFileSync(rosterPath, 'utf-8')) : null;
		if (!roster) err(`нет ростера ${basename(rosterPath)}`);
		const rosterSlugs = new Set((roster || []).map((r) => r.slug));
		const seen = new Map();

		for (const item of items) {
			const where = item?.slug || '(без slug)';
			const s = bySlug.get(item?.slug);
			if (!s) { err(`${where}: слага нет в БД`); continue; }
			if (roster && !rosterSlugs.has(item.slug)) err(`${where}: не из этого ростера`);
			seen.set(item.slug, (seen.get(item.slug) || 0) + 1);
			stats.items++;

			for (const key of Object.keys(item)) {
				if (!['slug', 'id', 'names', 'synonyms', 'note'].includes(key)) err(`${where}: лишнее поле «${key}»`);
			}
			if (item.id !== undefined && item.id !== s.id) err(`${where}: id ${item.id} не совпадает с БД (${s.id})`);
			if (item.note !== undefined && typeof item.note !== 'string') err(`${where}: note — не строка`);

			// ── Названия
			const names = item.names ?? {};
			if (typeof names !== 'object' || Array.isArray(names)) { err(`${where}: names — не объект`); continue; }
			for (const [loc, value] of Object.entries(names)) {
				const tag = `${where}.names.${loc}`;
				if (loc === 'sr_cyrl' || loc === 'sr-cyrl') { err(`${tag}: кириллицу не пишем — её собирает сборщик из sr`); continue; }
				if (!NAME_LOCALES.includes(loc)) { err(`${tag}: неизвестная локаль`); continue; }
				if (typeof value !== 'string' || !value.trim()) { err(`${tag}: пустое значение`); continue; }
				const before = s[`name_${loc}`];
				if (value === before) { warn(`${tag}: совпадает с текущим — убрать из names`); continue; }
				stats.renamed[loc]++;

				if (value !== value.trim() || /\s{2,}/.test(value)) err(`${tag}: лишние пробелы`);
				if (/[|\n\r\t]/.test(value)) err(`${tag}: недопустимый символ (| или перевод строки)`);
				if (/[\u00AD\u200B-\u200F\u2060\uFEFF]/.test(value)) err(`${tag}: невидимый символ (мягкий перенос и т.п.) — ломает поиск`);
				if (value.length > MAX_NAME) err(`${tag}: длиннее ${MAX_NAME}`);
				if (value.length > 140) warn(`${tag}: ${value.length} символов — длинно для заголовка`);
				if (/\.$/.test(value) && !/\b(br|min|ml|mm|cm)\.$/i.test(value)) warn(`${tag}: точка в конце`);
				const mixed = mixedScriptWords(value);
				if (mixed.length) err(`${tag}: смешение алфавитов в слове «${mixed.join(', ')}»`);
				if (numbers(value) !== numbers(before)) warn(`${tag}: поменялись цифры «${numbers(before)}» → «${numbers(value)}»`);

				if (loc === 'en') {
					if (frozen.has(before)) err(`${tag}: name_en «${before}» заморожен — на него ссылается неприменённый импорт`);
					const owners = (enOwners.get(value.toLowerCase()) || []).filter((id) => id !== s.id);
					if (owners.length) err(`${tag}: name_en уже занят услугой id ${owners.join(', ')} (UNIQUE)`);
					if (hasCyrillic(value)) err(`${tag}: кириллица в en`);
				}
				if (loc === 'sr') {
					if (hasCyrillic(value)) err(`${tag}: кириллица в sr — только латиница`);
					const ek = [...new Set(tokens(value).filter((t) => EKAVICA.has(t)))];
					if (ek.length) err(`${tag}: экавица «${ek.join(', ')}»`);
				}
				if (loc === 'ru') {
					if (!hasCyrillic(value)) err(`${tag}: нет кириллицы`);
					const latin = value.replace(RU_LATIN_OK, '').match(/[A-Za-z]{4,}/g);
					if (latin) warn(`${tag}: латиница «${latin.join(', ')}» — бренд? иначе перевести`);
					const tail = lastWord(value);
					if (tail.length > 4 && RU_ADJ_TAIL.test(tail) && !RU_ADJ_TAIL_OK.has(tail)) warn(`${tag}: оканчивается прилагательным «${tail}» — не обрыв?`);
				}
				if ((loc === 'de' || loc === 'tr') && value === (names.en ?? s.name_en)) warn(`${tag}: равно name_en — точно не переводится?`);
			}

			// ── Синонимы
			const syn = item.synonyms;
			if (kind === 'fix') {
				if (syn && Object.values(syn).some((l) => Array.isArray(l) && l.length)) err(`${where}: в батче шага 1 синонимов нет — только правка названий`);
				continue;
			}
			if (syn === undefined) { err(`${where}: нет поля synonyms (пустые списки — тоже ответ)`); continue; }
			if (typeof syn !== 'object' || Array.isArray(syn)) { err(`${where}: synonyms — не объект`); continue; }

			const own = Object.values(finalNames.get(s.id)).filter(Boolean).map(searchFold);
			const ownExisting = existingSynById.get(s.id) || new Set();
			const inItem = new Map();
			for (const [loc, list] of Object.entries(syn)) {
				const tag = `${where}.synonyms.${loc}`;
				if (loc === 'sr_cyrl' || loc === 'sr-cyrl') { err(`${tag}: кириллицу не пишем — её собирает сборщик из sr`); continue; }
				if (!NAME_LOCALES.includes(loc)) { err(`${tag}: неизвестная локаль`); continue; }
				if (!Array.isArray(list)) { err(`${tag}: не массив`); continue; }
				if (list.length > MAX_SYNONYMS_PER_LOCALE) warn(`${tag}: ${list.length} синонимов — больше ${MAX_SYNONYMS_PER_LOCALE}, всё ли нужно?`);
				for (const value of list) {
					if (typeof value !== 'string' || !value.trim()) { err(`${tag}: пустая строка`); continue; }
					const t = `${tag} «${value}»`;
					stats.synonyms++;
					if (value !== value.trim() || /\s{2,}/.test(value)) err(`${t}: лишние пробелы`);
					if (/[|\n\r\t"«»]/.test(value)) err(`${t}: недопустимый символ`);
					if (/[\u00AD\u200B-\u200F\u2060\uFEFF]/.test(value)) err(`${t}: невидимый символ — ломает поиск`);
					if (value.length > MAX_SYNONYM) err(`${t}: длиннее ${MAX_SYNONYM}`);
					if (/\.$/.test(value)) warn(`${t}: точка в конце`);
					const mixed = mixedScriptWords(value);
					if (mixed.length) err(`${t}: смешение алфавитов в слове «${mixed.join(', ')}»`);
					if (loc === 'sr' && hasCyrillic(value)) err(`${t}: кириллица в sr — только латиница`);
					if (loc === 'ru' && !hasCyrillic(value)) warn(`${t}: латиница в ru — если это аббревиатура, положи её в тот язык, где она родная`);
					if (['en', 'de', 'tr'].includes(loc) && hasCyrillic(value)) err(`${t}: кириллица в ${loc}`);

					const k = searchFold(value);
					if (inItem.has(k)) err(`${t}: уже есть в «${inItem.get(k)}» — поиск от языка не зависит, одной строки достаточно`);
					inItem.set(k, loc);
					if (GENERIC.has(k)) err(`${t}: слишком общее слово — совпадёт с сотней услуг`);
					if (own.includes(k)) { err(`${t}: это собственное название услуги`); continue; }
					if (own.some((n) => n.includes(k))) warn(`${t}: подстрока собственного названия — и так находится`);
					const others = [...(nameOwners.get(k) || [])].filter((id) => id !== s.id);
					if (others.length) err(`${t}: это название другой услуги (id ${others.slice(0, 3).join(', ')}) — перетянет её запросы`);
					if (ownExisting.has(k)) warn(`${t}: такой синоним уже есть в БД`);
					if (!hasLatin(value) && !hasCyrillic(value)) err(`${t}: нет букв`);
				}
			}
		}

		if (roster) {
			for (const slug of rosterSlugs) {
				if (!seen.has(slug)) err(`${slug}: пропущена — каждая услуга ростера должна быть в ответе`);
			}
		}
		for (const [slug, n] of seen) if (n > 1) err(`${slug}: встречается ${n} раза`);
	}

	console.log(`${basename(path)}: ${out.length ? '' : 'ok'}`);
	for (const line of out) console.log(line);
}

console.log(`\nуслуг: ${stats.items}; переименований: ${NAME_LOCALES.map((l) => `${l} ${stats.renamed[l]}`).join(', ')}; синонимов: ${stats.synonyms}`);
console.log(`ERROR: ${errors}, WARN: ${warns}`);
process.exit(errors ? 1 : 0);
