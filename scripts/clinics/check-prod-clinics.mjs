/**
 * Сверка импортированных клиник на проде через публичный API (пароля от прод-БД не нужно).
 *
 * По каждому slug клиники:
 *   - POST /api/clinics/items-summary — id на проде, число услуг, анализов, врачей;
 *   - POST /api/clinics/details — координаты;
 *   - на 6 языках сайта (sr, sr-cyrl, en, ru, de, tr) — клиника, её врачи и, если переданы,
 *     новые записи каталога (--services=slug,slug): поиск битой кодировки (двойной UTF-8
 *     вида «Å¡», «Ð°», «â€», символ замены, «??») и проверка, что у услуг в sr-cyrl/ru
 *     название на кириллице.
 * Числа сравнивать с локальной БД (SELECT по тем же slug) — должны совпасть.
 * Запросы идут curl'ом: Node fetch на прод режет Cloudflare.
 *
 * Usage:
 *   node scripts/clinics/check-prod-clinics.mjs <clinic-slug> [<clinic-slug> …] [--services=slug,slug]
 */

import { execFileSync } from 'node:child_process';

const LOCALES = ['sr', 'sr-cyrl', 'en', 'ru', 'de', 'tr'];
const BAD = /Ã[\u0080-¿]|Å[\u0080-¿¡¾½]|Ä[\u0080-¿‡Œ‘Ÿ]|Ð[\u0080-¿°-¿]|Ñ[\u0080-¿]|â€|�|\?\?/;

const args = process.argv.slice(2);
const services = (args.find((a) => a.startsWith('--services='))?.slice(11) || '').split(',').filter(Boolean);
const clinics = args.filter((a) => !a.startsWith('--'));
if (!clinics.length && !services.length) {
	console.log('Usage: node scripts/clinics/check-prod-clinics.mjs <clinic-slug> … [--services=slug,slug]');
	process.exit(1);
}

function post(path, body) {
	const out = execFileSync(
		'curl',
		['-s', '-w', '\n%{http_code}', '-A', 'Mozilla/5.0', '-H', 'content-type: application/json', '-X', 'POST', `https://docta.me${path}`, '-d', JSON.stringify(body)],
		{ maxBuffer: 50e6 },
	).toString('utf8');
	const i = out.lastIndexOf('\n');
	return { status: Number(out.slice(i + 1)), text: out.slice(0, i) };
}

const problems = [];
const checkText = (where, text) => {
	const m = text.match(BAD);
	if (m) problems.push(`${where}: «${text.slice(Math.max(0, m.index - 40), m.index + 30)}»`);
};

console.log('slug | prod id | услуг | анализов | врачей | координаты');
const ids = {};
for (const slug of clinics) {
	const s = post('/api/clinics/items-summary', { slug, locale: 'sr' });
	if (s.status !== 200) {
		console.log(`${slug} | НЕТ НА ПРОДЕ (${s.status})`);
		continue;
	}
	const sum = JSON.parse(s.text);
	const d = JSON.parse(post('/api/clinics/details', { slug, locale: 'sr' }).text);
	ids[slug] = sum.id;
	const it = sum.itemsSummary || {};
	console.log(`${slug} | ${sum.id} | ${it.services?.totalCount ?? 0} | ${it.labtests?.totalCount ?? 0} | ${it.doctors?.totalCount ?? 0} | ${d.latitude ?? '—'}, ${d.longitude ?? '—'}`);
}

let calls = 0;
const noCyr = [];
for (const locale of LOCALES) {
	for (const [slug, id] of Object.entries(ids)) {
		calls += 2;
		checkText(`clinic ${slug} ${locale}`, post('/api/clinics/details', { slug, locale }).text);
		checkText(`doctors ${slug} ${locale}`, post('/api/doctors/list', { clinicIds: [id], locale, limit: 100 }).text);
	}
	for (const slug of services) {
		calls++;
		const r = post('/api/services/details', { slug, locale });
		if (r.status !== 200) {
			problems.push(`service ${slug} ${locale}: HTTP ${r.status}`);
			continue;
		}
		checkText(`service ${slug} ${locale}`, r.text);
		if (locale === 'sr-cyrl' || locale === 'ru') {
			const name = r.text.match(/"name":"([^"]*)"/)?.[1] || '';
			if (!/[а-яё]/i.test(name)) noCyr.push(`${slug} ${locale}: ${name}`);
		}
	}
}
console.log(`\nКодировка: запросов ${calls}, проблем ${problems.length}, услуг без кириллицы ${noCyr.length}`);
for (const p of [...problems, ...noCyr]) console.log(`  ${p}`);
