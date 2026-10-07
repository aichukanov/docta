// Rows matched by name (not by code): search prod with the first two significant words of the KCCG wording
// (search is AND of words); report when hits exist but the chosen record is not among them.
import { readFileSync, writeFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
const fin = JSON.parse(readFileSync('final.json', 'utf8')).rows;
const rows = Object.fromEntries(JSON.parse(readFileSync('matched.json', 'utf8')).items.map((r) => [r.code, r]));
const STOP = new Set(['pregled', 'prvi', 'ponovni', 'kontrolni', 'specijalistički', 'određivanje', 'antitijela', 'ispitivanje', 'sa', 'bez', 'kod', 'ili', 'na', 'u', 'i', 'za', 'od', 'do', 'vrlo', 'teških', 'teškim', 'istog', 'dana']);
const out = []; let n = 0;
for (const f of fin) {
	if (f.via.includes('new')) continue;
	for (const code of f.codes) {
		const r = rows[code];
		if (r.target) continue; // matched by code
		const words = r.name_kccg.replace(/[(),.\-–:;/]/g, ' ').split(/\s+/).filter((w) => w.length >= 3 && !STOP.has(w.toLowerCase()));
		if (!words.length) continue;
		const name = words.slice(0, 2).join(' ');
		const ep = f.kind === 'ms' ? 'services' : 'labtests';
		const res = JSON.parse(execFileSync('curl', ['-s', '-X', 'POST', `https://docta.me/api/${ep}/list`, '-H', 'Content-Type: application/json', '--data-binary', JSON.stringify({ name, pageSize: 50 })], { encoding: 'utf8', maxBuffer: 64 << 20 }));
		n++;
		const hits = (res.items || []).map((i) => i.slug);
		if (hits.length && hits.length <= 15 && !hits.includes(f.slug)) out.push({ code, kccg: r.name_kccg, query: name, chosen: f.slug, hits });
	}
}
writeFileSync('search-check.json', JSON.stringify(out, null, 1));
console.log('searched', n, 'chosen not among hits', out.length);
