/**
 * Отметки после применения импорта клиник (юзер написал «применил», сверка прошла).
 *
 * По конфигу JSON (массив клиник) обновляет:
 *   - data/clinic-imports/<slug>.json → status.appliedLocal/appliedProd, clinicId (прод),
 *     clinicIdLocal, doctorIds;
 *   - data/clinic-pricelists/map.json и data/clinic-teams/map.json — новая запись на клинику
 *     (если ещё нет), чтобы её подхватили ежемесячные журналы;
 *   - data/google-places/progress.json — 1 у файла места (place = null — пропуск).
 * Формат конфига — см. data/clinic-candidates/README.md («Отметки после применения»).
 * После — node scripts/clinics/build-clinic-candidates.mjs.
 *
 * Usage:
 *   node scripts/clinics/mark-imported-clinics.mjs <config.json> [YYYY-MM-DD]
 */
import fs from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '../..') + '/';
const read = (p) => JSON.parse(fs.readFileSync(ROOT + p, 'utf8'));
const write = (p, v) => fs.writeFileSync(ROOT + p, JSON.stringify(v, null, '\t') + '\n');
const D = process.argv[3] || new Date().toISOString().slice(0, 10);

const W = JSON.parse(fs.readFileSync(resolve(process.argv[2]), 'utf8'));

// 1. Записи импорта
for (const w of W) {
	const p = `data/clinic-imports/${w.slug}.json`;
	const r = read(p);
	r.status = {
		...r.status,
		appliedLocal: D,
		appliedProd: D,
		clinicId: w.prod,
		clinicIdLocal: w.local,
		doctorIds: w.doctors,
		note: `${r.status.note || ''} Применено юзером ${D} локально и на проде; сверено координатором SELECT'ами (локаль) и API (прод): число услуг/врачей/типы/языки совпали, кодировка чистая на 6 языках. clinicId и doctorIds — прод, clinicIdLocal — локаль (id расходятся).`.trim(),
	};
	write(p, r);
}

// 2. Карта прайсов
const pm = read('data/clinic-pricelists/map.json');
for (const w of W) {
	if (pm.some((e) => e.clinics.some((c) => c.slug === w.slug))) continue;
	pm.push({
		site: w.site,
		clinics: [{ id: w.prod, slug: w.slug, name: w.name, city: w.city, db: w.db }],
		status: w.pricelistStatus,
		pricelists: w.pricelists,
		coverageVsDb: `импорт с этого прайса ${D}: ${w.db.services} услуг, ${w.db.servicesPriced} с ценой`,
		notes: w.priceNotes,
		checked: 'импорт кандидатов (data/clinic-candidates/WAVE1_IMPORT_PROMPT.md): curl по сырому HTML / wp-json',
		flags: [`imported: insert-clinic-${w.slug}-services.sql, в проде ${D}`],
		recheckHint: w.recheckHint,
		lastChecked: D,
	});
}
write('data/clinic-pricelists/map.json', pm);

// 3. Карта составов
const tm = read('data/clinic-teams/map.json');
for (const w of W) {
	if (tm.some((e) => e.clinics.some((c) => c.slug === w.slug))) continue;
	tm.push({
		site: w.site,
		clinics: [{ id: w.prod, slug: w.slug, name: w.name, dbDoctors: Object.keys(w.doctors).length }],
		status: w.teamStatus,
		coverage: w.teamStatus === 'no_team_list' ? 'none' : 'full',
		teamSources: w.teamUrls.map(([url, scope]) => ({ url, kind: 'html', scope, date_hint: null })),
		siteDoctors: [],
		matched: w.siteDoctors,
		possibleMatches: [],
		dbOnly: w.dbOnly.map((slug) => ({ slug })),
		dbOnlyIsEvidence: w.teamStatus !== 'no_team_list' && w.dbOnly.length === 0,
		siteOnly: [],
		checked: w.teamStatus === 'no_team_list' ? `импорт ${D}: на сайте нет списка врачей` : `импорт ${D}: состав взят с сайта целиком`,
		notes: w.teamNotes,
		synced: D,
		lastChecked: D,
	});
}
write('data/clinic-teams/map.json', tm);

// 4. progress.json мест Google: 1 = данные клиники внесены на сайт
const pg = read('data/google-places/progress.json');
for (const w of W) {
	if (!w.place) continue;
	const [city, file] = w.place.split('/');
	pg[city] = pg[city] || {};
	if (!pg[city][file]) pg[city][file] = 1;
}
fs.writeFileSync(ROOT + 'data/google-places/progress.json', JSON.stringify(pg, null, 2) + '\n');
console.log('ok', pm.length, tm.length);
