/**
 * Сборщик сырых данных Google Places по медучреждениям Черногории.
 *
 * ЭТО НЕ ТЕСТ И НЕ ПРОВЕРКА. Скрипт ходит в платный Places API
 * (searchNearby, тариф с полем reviews) и перезаписывает data/google-places/**
 * машинным ответом — вместе со всеми ручными правками каталога, молча,
 * сотнями файлов разом. Правила и цена ошибки: docs/rules/GOOGLE_PLACES_DATA.md.
 *
 * Поэтому без явного `--yes` скрипт только показывает план и выходит.
 * Запускать с `--yes` — исключительно с разрешения владельца данных.
 *
 * Usage:
 *   node scripts/collectors/google-places.mjs <команда> [--yes]
 *
 * Команды:
 *   montenegro     вся страна -> data/google-places/all-montenegro.json
 *   city <slug>    один город -> data/google-places/all-<slug>.json
 *   cities         все города подряд (12 запусков city)
 *   split          разложить all-montenegro.json по папкам городов.
 *                  API не трогает, но перезаписывает карточки мест.
 *
 * Требует GOOGLE_MAPS_API_KEY в .env (кроме команды split).
 */
import * as fs from 'node:fs';
import * as path from 'node:path';
import { fileURLToPath } from 'node:url';
import dotenv from 'dotenv';
import { createJiti } from 'jiti';

const ROOT = path.resolve(
	path.dirname(fileURLToPath(import.meta.url)),
	'..',
	'..',
);

dotenv.config({ path: path.resolve(ROOT, '.env'), quiet: true });

const jiti = createJiti(import.meta.url);
const { CityId } = await jiti.import(path.resolve(ROOT, 'enums/cities.ts'));
const { toLatin } = await jiti.import(
	path.resolve(ROOT, 'common/serbian-transliteration.ts'),
);

const OUT_DIR = path.resolve(ROOT, 'data/google-places');

// ─── Типы медучреждений ────────────────────────────────────────────
// PHARMACY — собираются отдельно (их много, забивают лимит)
const PLACE_TYPES = [
	'dentist',
	'dental_clinic',
	'hospital',
	'doctor',
	'medical_clinic',
	'physiotherapist',
];

// ─── Города с точками поиска (основная + доп. населённые пункты) ───
const CITIES = {
	// ─── Подгорица: сетка 2km кругов, покрывает ~12x8 км городской территории ───
	[CityId.PODGORICA]: {
		name: 'Podgorica',
		points: [
			{ lat: 42.455, lng: 19.23, radius: 2000, label: 'PG severozapad' },
			{ lat: 42.455, lng: 19.26, radius: 2000, label: 'PG sever-centar' },
			{ lat: 42.455, lng: 19.29, radius: 2000, label: 'PG severoistok' },
			{ lat: 42.44, lng: 19.23, radius: 2000, label: 'PG zapad' },
			{ lat: 42.44, lng: 19.26, radius: 2000, label: 'PG centar' },
			{ lat: 42.44, lng: 19.29, radius: 2000, label: 'PG istok' },
			{ lat: 42.425, lng: 19.23, radius: 2000, label: 'PG jugozapad' },
			{ lat: 42.425, lng: 19.26, radius: 2000, label: 'PG jug-centar' },
			{ lat: 42.425, lng: 19.29, radius: 2000, label: 'PG jugoistok' },
			{ lat: 42.41, lng: 19.26, radius: 2500, label: 'PG krajnji jug' },
			{ lat: 42.47, lng: 19.26, radius: 2500, label: 'PG krajnji sever' },
			{ lat: 42.49, lng: 19.18, radius: 3000, label: 'Tuzi' },
			{ lat: 42.37, lng: 19.31, radius: 3000, label: 'Golubovci' },
		],
	},
	// ─── Никшич: 3 круга по 2.5km ───
	[CityId.NIKSIC]: {
		name: 'Nikšić',
		points: [
			{ lat: 42.773, lng: 18.944, radius: 2500, label: 'Nikšić centar' },
			{ lat: 42.773, lng: 18.91, radius: 2500, label: 'Nikšić zapad' },
			{ lat: 42.773, lng: 18.98, radius: 2500, label: 'Nikšić istok' },
		],
	},
	// ─── Будва: побережье + Бечичи/Рафаиловичи + Петровац ───
	[CityId.BUDVA]: {
		name: 'Budva',
		points: [
			{ lat: 42.291, lng: 18.838, radius: 2000, label: 'Budva centar' },
			{ lat: 42.281, lng: 18.855, radius: 2000, label: 'Budva-Bečići' },
			{ lat: 42.268, lng: 18.87, radius: 2500, label: 'Rafailovići-Pržno' },
			{ lat: 42.25, lng: 18.873, radius: 3000, label: 'Petrovac' },
		],
	},
	[CityId.TIVAT]: {
		name: 'Tivat',
		points: [
			{ lat: 42.437, lng: 18.7, radius: 2500, label: 'Tivat centar' },
			{ lat: 42.42, lng: 18.72, radius: 2500, label: 'Tivat jug' },
		],
	},
	// ─── Улцинь: город + Велика плажа ───
	[CityId.ULCINJ]: {
		name: 'Ulcinj',
		points: [
			{ lat: 41.93, lng: 19.21, radius: 2500, label: 'Ulcinj centar' },
			{ lat: 41.91, lng: 19.23, radius: 2500, label: 'Ulcinj jug' },
		],
	},
	// ─── Котор: Старый город + Доброта + Рисан ───
	[CityId.KOTOR]: {
		name: 'Kotor',
		points: [
			{ lat: 42.425, lng: 18.77, radius: 2500, label: 'Kotor centar' },
			{ lat: 42.45, lng: 18.76, radius: 2500, label: 'Dobrota' },
			{ lat: 42.51, lng: 18.695, radius: 3000, label: 'Risan' },
		],
	},
	// ─── Бар: город + Сутоморе + Стари Бар ───
	[CityId.BAR]: {
		name: 'Bar',
		points: [
			{ lat: 42.093, lng: 19.1, radius: 2500, label: 'Bar centar' },
			{ lat: 42.08, lng: 19.11, radius: 2500, label: 'Bar jug' },
			{ lat: 42.141, lng: 18.975, radius: 3000, label: 'Sutomore' },
			{ lat: 42.095, lng: 19.13, radius: 2000, label: 'Stari Bar' },
		],
	},
	// ─── Херцег-Нови: город + Игало + Мелине/Каменари ───
	[CityId.HERCEG_NOVI]: {
		name: 'Herceg Novi',
		points: [
			{ lat: 42.453, lng: 18.538, radius: 2500, label: 'Herceg Novi centar' },
			{ lat: 42.46, lng: 18.51, radius: 2500, label: 'Igalo' },
			{ lat: 42.47, lng: 18.58, radius: 2500, label: 'Meljine-Zelenika' },
		],
	},
	// ─── Беране ───
	[CityId.BERANE]: {
		name: 'Berane',
		points: [{ lat: 42.843, lng: 19.87, radius: 3000, label: 'Berane centar' }],
	},
	// ─── Цетинье ───
	[CityId.CETINJE]: {
		name: 'Cetinje',
		points: [
			{ lat: 42.389, lng: 18.924, radius: 3000, label: 'Cetinje centar' },
		],
	},
	// ─── Даниловград ───
	[CityId.DANILOVGRAD]: {
		name: 'Danilovgrad',
		points: [
			{ lat: 42.559, lng: 19.097, radius: 3000, label: 'Danilovgrad centar' },
		],
	},
	// ─── Бело Поле ───
	[CityId.BELO_POLJE]: {
		name: 'Bijelo Polje',
		points: [
			{ lat: 43.035, lng: 19.747, radius: 3000, label: 'Bijelo Polje centar' },
		],
	},
};

// Недостающие муниципалитеты, не входящие в CITIES
const EXTRA_POINTS = [
	{ lat: 43.357, lng: 19.357, radius: 3000, label: 'Pljevlja' },
	{ lat: 42.84, lng: 20.165, radius: 3000, label: 'Rožaje' },
	{ lat: 42.826, lng: 19.514, radius: 3000, label: 'Kolašin' },
	{ lat: 43.155, lng: 19.118, radius: 3000, label: 'Žabljak' },
	{ lat: 42.962, lng: 19.582, radius: 3000, label: 'Mojkovac' },
	{ lat: 42.597, lng: 19.945, radius: 3000, label: 'Plav' },
	{ lat: 42.735, lng: 19.79, radius: 2500, label: 'Andrijevica' },
	{ lat: 42.96, lng: 19.09, radius: 2500, label: 'Šavnik' },
	{ lat: 42.596, lng: 19.965, radius: 2500, label: 'Gusinje' },
	{ lat: 42.894, lng: 20.028, radius: 2500, label: 'Petnjica' },
];

// Широкие точки — сетка 30km кругов для покрытия всей территории МЕ
const WIDE_POINTS = [
	// Юг (побережье)
	{ lat: 42.1, lng: 19.1, radius: 30000, label: 'Юг-центр' },
	{ lat: 42.3, lng: 18.85, radius: 30000, label: 'Юг-побережье' },
	// Центр
	{ lat: 42.45, lng: 18.7, radius: 30000, label: 'Центр-запад (Бока)' },
	{ lat: 42.45, lng: 19.25, radius: 30000, label: 'Центр (Подгорица)' },
	{ lat: 42.55, lng: 19.55, radius: 30000, label: 'Центр-восток' },
	// Север-запад
	{ lat: 42.8, lng: 18.95, radius: 30000, label: 'Северо-запад (Никшич)' },
	{ lat: 43.1, lng: 19.1, radius: 30000, label: 'Северо-запад (Жабляк)' },
	// Север-центр
	{ lat: 42.85, lng: 19.5, radius: 30000, label: 'Север-центр (Колашин)' },
	{ lat: 43.05, lng: 19.75, radius: 30000, label: 'Север (Бело Поле)' },
	// Северо-восток
	{ lat: 43.35, lng: 19.35, radius: 30000, label: 'Северо-запад (Плевля)' },
	{ lat: 42.85, lng: 19.95, radius: 30000, label: 'Северо-восток (Рожае)' },
	{ lat: 42.65, lng: 19.95, radius: 30000, label: 'Восток (Плав)' },
];

// Города, по которым собирается отдельный all-<slug>.json
const CITY_TARGETS = [
	[CityId.BAR, 'bar'],
	[CityId.PODGORICA, 'podgorica'],
	[CityId.NIKSIC, 'niksic'],
	[CityId.BUDVA, 'budva'],
	[CityId.TIVAT, 'tivat'],
	[CityId.ULCINJ, 'ulcinj'],
	[CityId.KOTOR, 'kotor'],
	[CityId.HERCEG_NOVI, 'herceg-novi'],
	[CityId.BERANE, 'berane'],
	[CityId.CETINJE, 'cetinje'],
	[CityId.DANILOVGRAD, 'danilovgrad'],
	[CityId.BELO_POLJE, 'bijelo-polje'],
];

// ─── Places API ───────────────────────────────────────────────────

const FIELDS = [
	'places.id',
	'places.displayName',
	'places.formattedAddress',
	'places.location',
	'places.types',
	'places.rating',
	'places.userRatingCount',
	'places.internationalPhoneNumber',
	'places.websiteUri',
	'places.googleMapsUri',
	'places.reviews',
].join(',');

function getApiKey() {
	return process.env.GOOGLE_MAPS_API_KEY || '';
}

async function searchPlaces(type, lat, lng, radius, pageToken) {
	const body = {
		includedTypes: [type],
		locationRestriction: {
			circle: { center: { latitude: lat, longitude: lng }, radius },
		},
		maxResultCount: 20,
		languageCode: 'sr',
	};

	if (pageToken) {
		body.pageToken = pageToken;
	}

	const res = await fetch(
		'https://places.googleapis.com/v1/places:searchNearby',
		{
			method: 'POST',
			headers: {
				'Content-Type': 'application/json',
				'X-Goog-Api-Key': getApiKey(),
				'X-Goog-FieldMask': FIELDS,
			},
			body: JSON.stringify(body),
		},
	);

	if (!res.ok) {
		const text = await res.text();
		throw new Error(`Places API error ${res.status}: ${text}`);
	}

	return res.json();
}

function sleep(ms) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

/** Все места в одной точке, с пагинацией. */
async function fetchPointRaw(placeType, point) {
	const allPlaces = [];
	let pageToken;

	do {
		const data = await searchPlaces(
			placeType,
			point.lat,
			point.lng,
			point.radius,
			pageToken,
		);
		allPlaces.push(...(data.places || []));
		pageToken = data.nextPageToken;
		if (pageToken) await sleep(500);
	} while (pageToken);

	return allPlaces;
}

/** Все места одного города: по всем его точкам. */
async function fetchCityRaw(placeType, cityId) {
	const cityInfo = CITIES[cityId];
	if (!cityInfo) return [];

	const allPlaces = [];
	for (const point of cityInfo.points) {
		const label = point.label || cityInfo.name;
		console.log(`    ${label} (r=${point.radius}m)`);
		const places = await fetchPointRaw(placeType, point);
		allPlaces.push(...places);
		await sleep(200);
	}

	return allPlaces;
}

function saveRaw(places, suffix) {
	if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });
	const outFile = path.join(OUT_DIR, `all-${suffix}.json`);
	fs.writeFileSync(outFile, JSON.stringify(places, null, 2), 'utf-8');
	return outFile;
}

function printSummary(places) {
	console.log(`\nВсего: ${places.length}\n`);
	for (const p of places) {
		const name = p.displayName?.text || '???';
		const addr = p.formattedAddress || '';
		const phone = p.internationalPhoneNumber || '';
		const reviews = p.reviews?.length || 0;
		console.log(`  ${name} | ${addr} | ${phone} | reviews: ${reviews}`);
	}
}

// ─── Команды ──────────────────────────────────────────────────────

/** Вся страна: города -> недостающие муниципалитеты -> широкая сетка. */
async function collectMontenegro() {
	const seenIds = new Set();
	const allPlaces = [];

	const take = (places, type) => {
		let newCount = 0;
		for (const p of places) {
			if (seenIds.has(p.id)) continue;
			seenIds.add(p.id);
			p._searchType = type;
			allPlaces.push(p);
			newCount++;
		}
		if (newCount > 0) console.log(`    +${newCount}`);
	};

	for (const type of PLACE_TYPES) {
		console.log(`\n=== ${type} ===`);

		// 1) Сначала по каждому городу (ловит локальные результаты)
		for (const cityConfig of Object.values(CITIES)) {
			for (const point of cityConfig.points) {
				console.log(`  ${point.label || cityConfig.name} (r=${point.radius}m)`);
				take(await fetchPointRaw(type, point), type);
				await sleep(200);
			}
		}

		// 2) Недостающие муниципалитеты
		for (const point of EXTRA_POINTS) {
			console.log(`  ${point.label} (r=${point.radius}m)`);
			take(await fetchPointRaw(type, point), type);
			await sleep(200);
		}

		// 3) Широкий поиск добирает пропущенное между городами
		for (const point of WIDE_POINTS) {
			console.log(`  ${point.label}`);
			take(await fetchPointRaw(type, point), type);
			await sleep(200);
		}

		console.log(`  Итого ${type}: ${allPlaces.length}`);
	}

	const file = saveRaw(allPlaces, 'montenegro');
	printSummary(allPlaces);
	console.log(`\nСохранено: ${file}`);
}

/** Один город: все типы по его точкам. */
async function collectCity(cityId, slug) {
	const cityInfo = CITIES[cityId];
	const seenIds = new Set();
	const allPlaces = [];

	for (const type of PLACE_TYPES) {
		console.log(`\n=== ${type} ===`);
		const places = await fetchCityRaw(type, cityId);
		let newCount = 0;
		for (const p of places) {
			if (seenIds.has(p.id)) continue;
			seenIds.add(p.id);
			p._cityId = cityId;
			p._cityName = cityInfo.name;
			p._searchType = type;
			allPlaces.push(p);
			newCount++;
		}
		console.log(`  ${newCount} новых (всего: ${allPlaces.length})`);
		await sleep(300);
	}

	const file = saveRaw(allPlaces, slug);
	printSummary(allPlaces);
	console.log(`\nСохранено: ${file}`);
}

// Slug-карта городов + координаты центров для определения ближайшего
const CITY_SLUGS = [
	{
		cityId: CityId.PODGORICA,
		slug: 'podgorica',
		lat: 42.442574,
		lng: 19.268646,
	},
	{ cityId: CityId.NIKSIC, slug: 'niksic', lat: 42.771059, lng: 18.947681 },
	{ cityId: CityId.BUDVA, slug: 'budva', lat: 42.2864, lng: 18.84 },
	{ cityId: CityId.TIVAT, slug: 'tivat', lat: 42.434981, lng: 18.70664 },
	{ cityId: CityId.ULCINJ, slug: 'ulcinj', lat: 41.9297, lng: 19.2142 },
	{ cityId: CityId.KOTOR, slug: 'kotor', lat: 42.432044, lng: 18.769454 },
	{ cityId: CityId.BAR, slug: 'bar', lat: 42.09806, lng: 19.094827 },
	{
		cityId: CityId.HERCEG_NOVI,
		slug: 'herceg-novi',
		lat: 42.457418,
		lng: 18.532136,
	},
	{ cityId: CityId.BERANE, slug: 'berane', lat: 42.8428, lng: 19.8733 },
	{ cityId: CityId.CETINJE, slug: 'cetinje', lat: 42.389, lng: 18.924 },
	{
		cityId: CityId.DANILOVGRAD,
		slug: 'danilovgrad',
		lat: 42.5595,
		lng: 19.0969,
	},
	{
		cityId: CityId.BELO_POLJE,
		slug: 'bijelo-polje',
		lat: 43.0353,
		lng: 19.7472,
	},
	// Доп. муниципалитеты (нет в CityId)
	{ slug: 'pljevlja', lat: 43.357, lng: 19.357 },
	{ slug: 'rozaje', lat: 42.84, lng: 20.165 },
	{ slug: 'kolasin', lat: 42.826, lng: 19.514 },
	{ slug: 'zabljak', lat: 43.155, lng: 19.118 },
	{ slug: 'mojkovac', lat: 42.962, lng: 19.582 },
	{ slug: 'plav', lat: 42.597, lng: 19.945 },
	{ slug: 'andrijevica', lat: 42.735, lng: 19.79 },
	{ slug: 'savnik', lat: 42.96, lng: 19.09 },
	{ slug: 'gusinje', lat: 42.596, lng: 19.965 },
	{ slug: 'petnjica', lat: 42.894, lng: 20.028 },
];

function haversine(lat1, lng1, lat2, lng2) {
	const R = 6371;
	const toRad = (d) => (d * Math.PI) / 180;
	const dLat = toRad(lat2 - lat1);
	const dLng = toRad(lng2 - lng1);
	const a =
		Math.sin(dLat / 2) ** 2 +
		Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) ** 2;
	return 2 * R * Math.asin(Math.sqrt(a));
}

function findNearestCity(lat, lng) {
	let best = CITY_SLUGS[0];
	let bestDist = Infinity;
	for (const c of CITY_SLUGS) {
		const d = haversine(lat, lng, c.lat, c.lng);
		if (d < bestDist) {
			bestDist = d;
			best = c;
		}
	}
	return best;
}

function toSlug(name) {
	return toLatin(name)
		.toLowerCase()
		.normalize('NFD')
		.replace(/[̀-ͯ]/g, '') // убирает диакритики (š→s, ć→c, ë→e...)
		.replace(/đ/g, 'dj')
		.replace(/[^a-z0-9]+/g, '-')
		.replace(/^-|-$/g, '')
		.slice(0, 60);
}

const MNE_KEYWORDS = ['Црна Гора', 'Montenegro', 'Crna Gora'];
function isMontenegro(place) {
	const addr = place.formattedAddress || '';
	return MNE_KEYWORDS.some((kw) => addr.includes(kw));
}

/**
 * Раскладывает all-montenegro.json по папкам городов. API не трогает.
 *
 * Карточки в каталоге богаче, чем то, что отдаёт searchNearby: в них полный
 * список отзывов (сотни) и поле collectedAt — их собирал другой, детальный
 * проход. searchNearby отдаёт максимум 5 отзывов. Поэтому слепая раскладка
 * может только испортить каталог: 167 отзывов превращаются в 5, файл худеет
 * с 253 КБ до 14 КБ — так 2026-10-26 и пострадала 141 карточка.
 *
 * Отсюда правило: карточку, которая уже полнее приходящей, не трогаем.
 * Перезаписать насильно — `--force`.
 */
function split(force) {
	const srcFile = path.join(OUT_DIR, 'all-montenegro.json');
	if (!fs.existsSync(srcFile)) {
		throw new Error('Сначала собери данные командой montenegro');
	}

	const allPlaces = JSON.parse(fs.readFileSync(srcFile, 'utf-8'));
	const stats = {};
	let skipped = 0;
	let kept = 0;

	for (const p of allPlaces) {
		if (!isMontenegro(p)) {
			skipped++;
			continue;
		}

		const lat = p.location?.latitude;
		const lng = p.location?.longitude;
		if (!lat || !lng) continue;

		const city = findNearestCity(lat, lng);
		const slug = toSlug(p.displayName?.text || 'unknown');

		const cityDir = path.join(OUT_DIR, city.slug);
		if (!fs.existsSync(cityDir)) fs.mkdirSync(cityDir, { recursive: true });

		const outFile = path.join(cityDir, `${slug}.json`);
		const existing = fs.existsSync(outFile)
			? JSON.parse(fs.readFileSync(outFile, 'utf-8'))
			: null;

		if (existing && !force) {
			const had = existing.reviews?.length || 0;
			const incoming = p.reviews?.length || 0;
			if (had > incoming) {
				kept++;
				continue;
			}
		}

		// collectedAt ставит детальный проход, в searchNearby его нет — не теряем
		if (existing?.collectedAt && !p.collectedAt)
			p.collectedAt = existing.collectedAt;

		fs.writeFileSync(outFile, JSON.stringify(p, null, 2), 'utf-8');
		stats[city.slug] = (stats[city.slug] || 0) + 1;
	}

	console.log('\nРаспределение по городам:');
	for (const [slug, count] of Object.entries(stats).sort(
		(a, b) => b[1] - a[1],
	)) {
		console.log(`  ${slug}: ${count}`);
	}
	const written = Object.values(stats).reduce((a, b) => a + b, 0);
	console.log(
		`\nЗаписано: ${written} | сохранено как было: ${kept} | пропущено не-МЕ: ${skipped}`,
	);
	if (kept) {
		console.log(
			'Карточки с более полными отзывами не тронуты. Перезаписать: --force',
		);
	}
}

// ─── CLI ──────────────────────────────────────────────────────────

const USAGE = `
Сборщик Google Places. Перезаписывает data/google-places/**.

  node scripts/collectors/google-places.mjs montenegro --yes
  node scripts/collectors/google-places.mjs city <slug> --yes
  node scripts/collectors/google-places.mjs cities --yes
  node scripts/collectors/google-places.mjs split --yes [--force]

Города: ${CITY_TARGETS.map(([, slug]) => slug).join(', ')}

split по умолчанию не трогает карточки, которые полнее приходящих;
--force перезаписывает их (потеря полного списка отзывов).
`.trim();

const CITY_POINTS = Object.values(CITIES).reduce(
	(n, c) => n + c.points.length,
	0,
);

/** Сколько запросов в Places API уйдёт — без учёта пагинации. */
function estimateRequests(command, slug) {
	const t = PLACE_TYPES.length;
	if (command === 'montenegro')
		return (CITY_POINTS + EXTRA_POINTS.length + WIDE_POINTS.length) * t;
	if (command === 'cities') return CITY_POINTS * t;
	if (command === 'city') {
		const target = CITY_TARGETS.find(([, s]) => s === slug);
		return target ? CITIES[target[0]].points.length * t : 0;
	}
	return 0;
}

/** Что команда перезапишет — чтобы это было видно до запуска, а не после. */
function describeTargets(command, slug) {
	if (command === 'montenegro') return 'data/google-places/all-montenegro.json';
	if (command === 'cities')
		return CITY_TARGETS.map(([, s]) => `all-${s}.json`).join(', ');
	if (command === 'city') return `data/google-places/all-${slug}.json`;
	return force
		? 'data/google-places/<город>/*.json — ВСЕ карточки, включая более полные (--force)'
		: 'data/google-places/<город>/*.json — только карточки не полнее приходящих';
}

const args = process.argv.slice(2);
const confirmed = args.includes('--yes');
const force = args.includes('--force');
const [command, ...rest] = args.filter((a) => !a.startsWith('--'));
const slug = rest[0];

if (!command || !['montenegro', 'city', 'cities', 'split'].includes(command)) {
	console.log(USAGE);
	process.exit(command ? 1 : 0);
}

if (command === 'city' && !CITY_TARGETS.some(([, s]) => s === slug)) {
	console.error(`Неизвестный город: ${slug || '(не задан)'}\n`);
	console.log(USAGE);
	process.exit(1);
}

// Предохранитель: без явного --yes ничего не запрашивается и не пишется.
if (!confirmed) {
	console.log(
		`
Команда:      ${command}${slug ? ` ${slug}` : ''}
Перезапишет:  ${describeTargets(command, slug)}
Запросов API: ${estimateRequests(command, slug) || 'нет (локальная раскладка)'}

${
		command === 'split' && !force
			? 'Карточки полнее приходящих останутся как есть.'
			: 'Ручные правки каталога будут затёрты машинным ответом Google.'
	}
См. docs/rules/GOOGLE_PLACES_DATA.md.

Запуск только с разрешения владельца данных — добавь --yes.
`.trim(),
	);
	process.exit(0);
}

if (command !== 'split' && !getApiKey()) {
	console.error('GOOGLE_MAPS_API_KEY не задан в .env');
	process.exit(1);
}

if (command === 'montenegro') {
	await collectMontenegro();
} else if (command === 'city') {
	const [cityId] = CITY_TARGETS.find(([, s]) => s === slug);
	await collectCity(cityId, slug);
} else if (command === 'cities') {
	for (const [cityId, citySlug] of CITY_TARGETS) {
		console.log(`\n########## ${citySlug} ##########`);
		await collectCity(cityId, citySlug);
	}
} else {
	split(force);
}
