/**
 * Fetches regularOpeningHours from Google Places (New) API for clinics listed
 * in data/clinics-without-hours.json. Только Place Details на place_id из JSON,
 * никакого поиска — placeId должен быть в файле (или null если не найден).
 *
 * Usage:
 *   node scripts/fetch-clinic-working-hours.mjs
 *
 * Env (.env): GOOGLE_MAPS_API_KEY
 */

import {
	existsSync,
	mkdirSync,
	readFileSync,
	writeFileSync,
} from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');

const INPUT_FILE = resolve(ROOT, 'data/clinics-without-hours.json');
const OUT_DIR = resolve(ROOT, 'data/google-places-hours');

// .env
const envPath = resolve(ROOT, '.env');
if (existsSync(envPath)) {
	for (const line of readFileSync(envPath, 'utf-8').split('\n')) {
		const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*)/);
		if (m) process.env[m[1]] = m[2].trim();
	}
}

const API_KEY = process.env.GOOGLE_MAPS_API_KEY;
if (!API_KEY) {
	console.error('GOOGLE_MAPS_API_KEY не задан в .env');
	process.exit(1);
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function fetchHours(placeId) {
	const url = `https://places.googleapis.com/v1/places/${encodeURIComponent(placeId)}`;
	const res = await fetch(url, {
		headers: {
			'X-Goog-Api-Key': API_KEY,
			'X-Goog-FieldMask': 'regularOpeningHours',
		},
	});
	if (!res.ok) {
		throw new Error(`HTTP ${res.status}: ${await res.text()}`);
	}
	return res.json();
}

const clinics = JSON.parse(readFileSync(INPUT_FILE, 'utf-8'));
const withPlaceId = clinics.filter((c) => c.placeId);
const withoutPlaceId = clinics.filter((c) => !c.placeId);

console.log(`Всего клиник: ${clinics.length}`);
console.log(`С placeId:    ${withPlaceId.length}`);
console.log(`Без placeId:  ${withoutPlaceId.length} (будут пропущены)\n`);

if (!existsSync(OUT_DIR)) mkdirSync(OUT_DIR, { recursive: true });

let withHours = 0;
let withoutHours = 0;
let errors = 0;
let apiCalls = 0;

for (const clinic of withPlaceId) {
	const outFile = join(OUT_DIR, `${clinic.id}.json`);
	if (existsSync(outFile)) {
		console.log(`[skip] ${clinic.id} ${clinic.name} — уже есть`);
		continue;
	}

	try {
		apiCalls++;
		const data = await fetchHours(clinic.placeId);
		const hasHours = data.regularOpeningHours?.periods?.length > 0;

		writeFileSync(
			outFile,
			JSON.stringify(
				{
					clinicId: clinic.id,
					slug: clinic.slug,
					name: clinic.name,
					cityId: clinic.cityId,
					placeId: clinic.placeId,
					regularOpeningHours: data.regularOpeningHours || null,
				},
				null,
				2,
			),
			'utf-8',
		);

		if (hasHours) {
			withHours++;
			console.log(`[ok]   ${clinic.id} ${clinic.name}`);
		} else {
			withoutHours++;
			console.log(`[null] ${clinic.id} ${clinic.name} — у Google нет часов`);
		}
	} catch (e) {
		errors++;
		console.error(`[err]  ${clinic.id} ${clinic.name}: ${e.message}`);
	}

	await sleep(150);
}

console.log(`\nИтого:`);
console.log(`  API вызовов:      ${apiCalls}`);
console.log(`  с часами:         ${withHours}`);
console.log(`  Google без часов: ${withoutHours}`);
console.log(`  ошибок:           ${errors}`);
console.log(`  пропущено:        ${withoutPlaceId.length}`);

console.log(`\nСледующий шаг: node scripts/build-working-hours-sql.mjs`);
