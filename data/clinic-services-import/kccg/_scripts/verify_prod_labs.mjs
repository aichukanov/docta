// Fetch /api/labtests/details for lab rows whose listing clinicPrices is truncated; compare clinic 65 row.
import { readFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
const fin = JSON.parse(readFileSync('final.json', 'utf8')).rows.filter((f) => f.kind === 'lt');
const list = Object.fromEntries(JSON.parse(readFileSync('prod-labtests.json', 'utf8')).items.map((i) => [i.slug, i.clinicPrices]));
let checked = 0; const bad = [];
for (const f of fin) {
	let rows = list[f.slug] || [];
	if (!rows.some((p) => p.clinicId === 65)) {
		const out = execFileSync('curl', ['-s', '-X', 'POST', 'https://docta.me/api/labtests/details', '-H', 'Content-Type: application/json', '-d', JSON.stringify({ slug: f.slug })], { encoding: 'utf8' });
		rows = JSON.parse(out).clinicPrices; checked++;
	}
	const p = rows.find((r) => r.clinicId === 65);
	const ok = p && Math.abs((p.price ?? 0) - f.price) < 0.005 && Math.abs((p.priceMax ?? 0) - (f.price_max ?? 0)) < 0.005 && p.code === f.codes.join('/') && !p.isOutdated;
	if (!ok) bad.push([f.slug, p, f.price, f.codes.join('/')]);
}
console.log('details fetched', checked, 'lab rows', fin.length, 'mismatches', bad.length, JSON.stringify(bad.slice(0, 5)));
