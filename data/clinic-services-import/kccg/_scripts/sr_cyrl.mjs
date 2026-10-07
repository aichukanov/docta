// name_sr -> name_sr_cyrl for new KCCG catalog entries (and sr synonyms),
// via scripts/common/sr-cyrl-names.mjs trained on the whole catalog.
// Usage (from repo root): node data/clinic-services-import/kccg/_scripts/sr_cyrl.mjs <in.json> <out.json>
import mysql from 'mysql2/promise';
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { loadEnv, dbConfigFromEnv } from '../../../../scripts/common/dedup-text.mjs';
import { createNameTransliterator } from '../../../../scripts/common/sr-cyrl-names.mjs';

const ROOT = resolve(process.cwd());
loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [svc] = await db.query('SELECT name_sr, name_sr_cyrl FROM medical_services');
const [lab] = await db.query('SELECT name_sr, name_sr_cyrl FROM lab_tests');
await db.end();
const { transliterate } = createNameTransliterator([...svc, ...lab]);

// Catalog keeps abbreviations Latin inside Cyrillic names (dsDNA, ANCA, CD4+, DNK, TSH):
// a token with two capitals, or a capital next to a digit, goes back to its Latin form.
const ABBR = /^(?=.*[A-Z].*[A-Z]|.*[A-Z]\d|.*\d[A-Z])[A-Za-z0-9+-]+$/;
const LAT2CYR = { lj: 'љ', nj: 'њ', dž: 'џ', a: 'а', b: 'б', c: 'ц', č: 'ч', ć: 'ћ', d: 'д', đ: 'ђ', e: 'е', f: 'ф', g: 'г', h: 'х', i: 'и', j: 'ј', k: 'к', l: 'л', m: 'м', n: 'н', o: 'о', p: 'п', r: 'р', s: 'с', š: 'ш', t: 'т', u: 'у', v: 'в', z: 'з', ž: 'ж' };
function toCyr(w) {
	let o = '';
	for (let i = 0; i < w.length; i++) {
		const two = w.slice(i, i + 2).toLowerCase();
		const up = w[i] !== w[i].toLowerCase();
		let c = LAT2CYR[two] ? LAT2CYR[two] : null;
		if (c) i++;
		else c = LAT2CYR[w[i].toLowerCase()] ?? w[i];
		o += up ? c.toUpperCase() : c;
	}
	return o;
}
const PHRASES = [['In ситу', 'In situ'], ['in ситу', 'in situ'], ['SYBR Греен', 'SYBR Green'], ['Barrovo', 'Барово'], ['posttraumatsk', 'посттрауматск']];
function cyrl(sr) {
	let out = transliterate(sr);
	// KK (komplikacije i komorbiditeti) is a Serbian abbreviation: Cyrillic «КК», as in the Mojkovac DRG records
	const parts = new Set((sr.match(/[A-Za-z0-9+-]+/g) || []).filter((t) => ABBR.test(t) && t !== 'KK'));
	for (const t of [...parts].sort((a, b) => b.length - a.length)) {
		const c = transliterate(t);
		if (c !== t) out = out.split(c).join(t);
	}
	for (const [from, to] of PHRASES) out = out.split(from).join(to);
	// Serbian has no «sh» digraph (that is š): «ishod», «ishemijski», «posttraumatske» are s+h at a prefix
	// boundary, but the shared transliterator treats «sh» as a foreign-word marker and leaves them Latin.
	out = out.replace(/(?<![\p{L}])[a-zčćšžđ]*sh[a-zčćšžđ]*(?![\p{L}])/giu, (w) => toCyr(w));
	// case suffix after a Latin abbreviation: «HIV-om» → «HIV-ом»
	out = out.replace(/([A-Z]{2,})-([a-zčćšžđ]+)/g, (_, a, s) => `${a}-${toCyr(s)}`);
	return out;
}

const [, , inp, out] = process.argv;
const entries = JSON.parse(readFileSync(inp, 'utf-8'));
for (const e of entries) {
	e.name_sr_cyrl = cyrl(e.name_sr);
	for (const s of e.synonyms || []) if (s.lang === 'sr') s.cyrl = cyrl(s.name);
}
writeFileSync(out, JSON.stringify(entries, null, 1));
console.log('transliterated', entries.length);
