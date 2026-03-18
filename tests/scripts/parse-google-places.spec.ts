import { test } from '@playwright/test';
import { CityId } from '../../enums/cities';
import { toLatin } from '../../common/serbian-transliteration';
import * as fs from 'fs';
import * as path from 'path';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.resolve(__dirname, '../../.env') });

// ─── Типы медучреждений ────────────────────────────────────────────
enum PlaceType {
	DENTIST = 'dentist',
	DENTAL_CLINIC = 'dental_clinic',
	HOSPITAL = 'hospital',
	DOCTOR = 'doctor',
	MEDICAL_CLINIC = 'medical_clinic',
	// PHARMACY — собираются отдельно (их много, забивают лимит)
	PHYSIOTHERAPIST = 'physiotherapist',
}

// ─── Города с точками поиска (основная + доп. населённые пункты) ───
interface SearchPoint { lat: number; lng: number; radius: number; label?: string }
interface CityConfig { name: string; points: SearchPoint[] }

const CITIES: Record<number, CityConfig> = {
	// ─── Подгорица: сетка 2km кругов, покрывает ~12x8 км городской территории ───
	[CityId.PODGORICA]: { name: 'Podgorica', points: [
		{ lat: 42.455, lng: 19.230, radius: 2000, label: 'PG severozapad' },
		{ lat: 42.455, lng: 19.260, radius: 2000, label: 'PG sever-centar' },
		{ lat: 42.455, lng: 19.290, radius: 2000, label: 'PG severoistok' },
		{ lat: 42.440, lng: 19.230, radius: 2000, label: 'PG zapad' },
		{ lat: 42.440, lng: 19.260, radius: 2000, label: 'PG centar' },
		{ lat: 42.440, lng: 19.290, radius: 2000, label: 'PG istok' },
		{ lat: 42.425, lng: 19.230, radius: 2000, label: 'PG jugozapad' },
		{ lat: 42.425, lng: 19.260, radius: 2000, label: 'PG jug-centar' },
		{ lat: 42.425, lng: 19.290, radius: 2000, label: 'PG jugoistok' },
		{ lat: 42.410, lng: 19.260, radius: 2500, label: 'PG krajnji jug' },
		{ lat: 42.470, lng: 19.260, radius: 2500, label: 'PG krajnji sever' },
		{ lat: 42.490, lng: 19.180, radius: 3000, label: 'Tuzi' },
		{ lat: 42.370, lng: 19.310, radius: 3000, label: 'Golubovci' },
	] },
	// ─── Никшич: 3 круга по 2.5km ───
	[CityId.NIKSIC]: { name: 'Nikšić', points: [
		{ lat: 42.773, lng: 18.944, radius: 2500, label: 'Nikšić centar' },
		{ lat: 42.773, lng: 18.910, radius: 2500, label: 'Nikšić zapad' },
		{ lat: 42.773, lng: 18.980, radius: 2500, label: 'Nikšić istok' },
	] },
	// ─── Будва: побережье + Бечичи/Рафаиловичи + Петровац ───
	[CityId.BUDVA]: { name: 'Budva', points: [
		{ lat: 42.291, lng: 18.838, radius: 2000, label: 'Budva centar' },
		{ lat: 42.281, lng: 18.855, radius: 2000, label: 'Budva-Bečići' },
		{ lat: 42.268, lng: 18.870, radius: 2500, label: 'Rafailovići-Pržno' },
		{ lat: 42.250, lng: 18.873, radius: 3000, label: 'Petrovac' },
	] },
	// ─── Тиват: город + аэропорт ───
	[CityId.TIVAT]: { name: 'Tivat', points: [
		{ lat: 42.437, lng: 18.700, radius: 2500, label: 'Tivat centar' },
		{ lat: 42.420, lng: 18.720, radius: 2500, label: 'Tivat jug' },
	] },
	// ─── Улцинь: город + Велика плажа ───
	[CityId.ULCINJ]: { name: 'Ulcinj', points: [
		{ lat: 41.930, lng: 19.210, radius: 2500, label: 'Ulcinj centar' },
		{ lat: 41.910, lng: 19.230, radius: 2500, label: 'Ulcinj jug' },
	] },
	// ─── Котор: Старый город + Доброта + Рисан ───
	[CityId.KOTOR]: { name: 'Kotor', points: [
		{ lat: 42.425, lng: 18.770, radius: 2500, label: 'Kotor centar' },
		{ lat: 42.450, lng: 18.760, radius: 2500, label: 'Dobrota' },
		{ lat: 42.510, lng: 18.695, radius: 3000, label: 'Risan' },
	] },
	// ─── Бар: город + Сутоморе + Стари Бар ───
	[CityId.BAR]: { name: 'Bar', points: [
		{ lat: 42.093, lng: 19.100, radius: 2500, label: 'Bar centar' },
		{ lat: 42.080, lng: 19.110, radius: 2500, label: 'Bar jug' },
		{ lat: 42.141, lng: 18.975, radius: 3000, label: 'Sutomore' },
		{ lat: 42.095, lng: 19.130, radius: 2000, label: 'Stari Bar' },
	] },
	// ─── Херцег-Нови: город + Игало + Мелине/Каменари ───
	[CityId.HERCEG_NOVI]: { name: 'Herceg Novi', points: [
		{ lat: 42.453, lng: 18.538, radius: 2500, label: 'Herceg Novi centar' },
		{ lat: 42.460, lng: 18.510, radius: 2500, label: 'Igalo' },
		{ lat: 42.470, lng: 18.580, radius: 2500, label: 'Meljine-Zelenika' },
	] },
	// ─── Беране ───
	[CityId.BERANE]: { name: 'Berane', points: [
		{ lat: 42.843, lng: 19.870, radius: 3000, label: 'Berane centar' },
	] },
	// ─── Цетинье ───
	[CityId.CETINJE]: { name: 'Cetinje', points: [
		{ lat: 42.389, lng: 18.924, radius: 3000, label: 'Cetinje centar' },
	] },
	// ─── Даниловград ───
	[CityId.DANILOVGRAD]: { name: 'Danilovgrad', points: [
		{ lat: 42.559, lng: 19.097, radius: 3000, label: 'Danilovgrad centar' },
	] },
	// ─── Бело Поле ───
	[CityId.BELO_POLJE]: { name: 'Bijelo Polje', points: [
		{ lat: 43.035, lng: 19.747, radius: 3000, label: 'Bijelo Polje centar' },
	] },
};

// ─── Helpers ───────────────────────────────────────────────────────
function getApiKey(): string {
	return process.env.GOOGLE_MAPS_API_KEY || '';
}

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

async function searchPlaces(
	type: PlaceType,
	lat: number,
	lng: number,
	radius: number,
	pageToken?: string,
): Promise<any> {
	const body: any = {
		includedTypes: [type],
		locationRestriction: {
			circle: {
				center: { latitude: lat, longitude: lng },
				radius,
			},
		},
		maxResultCount: 20,
		languageCode: 'sr',
	};

	if (pageToken) {
		body.pageToken = pageToken;
	}

	const res = await fetch('https://places.googleapis.com/v1/places:searchNearby', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
			'X-Goog-Api-Key': getApiKey(),
			'X-Goog-FieldMask': FIELDS,
		},
		body: JSON.stringify(body),
	});

	if (!res.ok) {
		const text = await res.text();
		throw new Error(`Places API error ${res.status}: ${text}`);
	}

	return res.json();
}

function sleep(ms: number) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

const OUT_DIR = path.resolve(__dirname, '../../data/google-places');

/**
 * Собирает сырые данные для одного города.
 * Возвращает массив сырых place-объектов как их отдал Google.
 */
async function fetchPointRaw(placeType: PlaceType, point: SearchPoint): Promise<any[]> {
	const allPlaces: any[] = [];
	let pageToken: string | undefined;

	do {
		const data = await searchPlaces(placeType, point.lat, point.lng, point.radius, pageToken);
		allPlaces.push(...(data.places || []));
		pageToken = data.nextPageToken;
		if (pageToken) await sleep(500);
	} while (pageToken);

	return allPlaces;
}

async function fetchCityRaw(placeType: PlaceType, cityId: CityId): Promise<any[]> {
	const cityInfo = CITIES[cityId];
	if (!cityInfo) return [];

	const allPlaces: any[] = [];
	for (const point of cityInfo.points) {
		const label = point.label || cityInfo.name;
		console.log(`    ${label} (r=${point.radius}m)`);
		const places = await fetchPointRaw(placeType, point);
		allPlaces.push(...places);
		await sleep(200);
	}

	return allPlaces;
}

/**
 * Собирает по всем городам, дедуплицирует по place id.
 * Сохраняет в data/google-places/{type}.json
 */
async function fetchAllRaw(placeType: PlaceType): Promise<any[]> {
	const seenIds = new Set<string>();
	const allPlaces: any[] = [];

	for (const [cityIdStr, cityInfo] of Object.entries(CITIES)) {
		const cityId = Number(cityIdStr) as CityId;
		console.log(`--- ${cityInfo.name} ---`);

		const places = await fetchCityRaw(placeType, cityId);
		let newCount = 0;

		for (const p of places) {
			if (seenIds.has(p.id)) continue;
			seenIds.add(p.id);
			// Добавляем метаданные о городе к сырым данным
			p._cityId = cityId;
			p._cityName = cityInfo.name;
			allPlaces.push(p);
			newCount++;
		}

		console.log(`  ${newCount} новых (всего: ${allPlaces.length})`);
		await sleep(300);
	}

	return allPlaces;
}

function saveRaw(places: any[], placeType: PlaceType, suffix?: string): string {
	if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });
	const name = suffix ? `${placeType}-${suffix}` : placeType;
	const outFile = path.join(OUT_DIR, `${name}.json`);
	fs.writeFileSync(outFile, JSON.stringify(places, null, 2), 'utf-8');
	return outFile;
}

function printSummary(places: any[]) {
	console.log(`\nВсего: ${places.length}\n`);
	for (const p of places) {
		const name = p.displayName?.text || '???';
		const addr = p.formattedAddress || '';
		const phone = p.internationalPhoneNumber || '';
		const reviews = p.reviews?.length || 0;
		console.log(`  ${name} | ${addr} | ${phone} | reviews: ${reviews}`);
	}
}

// ─── Тесты-скрипты ────────────────────────────────────────────────

test.describe('Google Places — fetch raw data', () => {
	test.beforeAll(() => {
		if (!getApiKey()) {
			throw new Error('GOOGLE_MAPS_API_KEY не задан в .env');
		}
	});

	test('ALL Montenegro -> data/google-places/all-montenegro.json', async () => {
		// Недостающие муниципалитеты, не входящие в CITIES
		const EXTRA_POINTS: SearchPoint[] = [
			{ lat: 43.357, lng: 19.357, radius: 3000, label: 'Pljevlja' },
			{ lat: 42.840, lng: 20.165, radius: 3000, label: 'Rožaje' },
			{ lat: 42.826, lng: 19.514, radius: 3000, label: 'Kolašin' },
			{ lat: 43.155, lng: 19.118, radius: 3000, label: 'Žabljak' },
			{ lat: 42.962, lng: 19.582, radius: 3000, label: 'Mojkovac' },
			{ lat: 42.597, lng: 19.945, radius: 3000, label: 'Plav' },
			{ lat: 42.735, lng: 19.790, radius: 2500, label: 'Andrijevica' },
			{ lat: 42.960, lng: 19.090, radius: 2500, label: 'Šavnik' },
			{ lat: 42.596, lng: 19.965, radius: 2500, label: 'Gusinje' },
			{ lat: 42.894, lng: 20.028, radius: 2500, label: 'Petnjica' },
		];

		// Широкие точки — сетка 30km кругов для покрытия всей территории МЕ
		const WIDE_POINTS: SearchPoint[] = [
			// Юг (побережье)
			{ lat: 42.10, lng: 19.10, radius: 30000, label: 'Юг-центр' },
			{ lat: 42.30, lng: 18.85, radius: 30000, label: 'Юг-побережье' },
			// Центр
			{ lat: 42.45, lng: 18.70, radius: 30000, label: 'Центр-запад (Бока)' },
			{ lat: 42.45, lng: 19.25, radius: 30000, label: 'Центр (Подгорица)' },
			{ lat: 42.55, lng: 19.55, radius: 30000, label: 'Центр-восток' },
			// Север-запад
			{ lat: 42.80, lng: 18.95, radius: 30000, label: 'Северо-запад (Никшич)' },
			{ lat: 43.10, lng: 19.10, radius: 30000, label: 'Северо-запад (Жабляк)' },
			// Север-центр
			{ lat: 42.85, lng: 19.50, radius: 30000, label: 'Север-центр (Колашин)' },
			{ lat: 43.05, lng: 19.75, radius: 30000, label: 'Север (Бело Поле)' },
			// Северо-восток
			{ lat: 43.35, lng: 19.35, radius: 30000, label: 'Северо-запад (Плевля)' },
			{ lat: 42.85, lng: 19.95, radius: 30000, label: 'Северо-восток (Рожае)' },
			{ lat: 42.65, lng: 19.95, radius: 30000, label: 'Восток (Плав)' },
		];

		const allTypes = Object.values(PlaceType);
		const seenIds = new Set<string>();
		const allPlaces: any[] = [];

		// 1) Сначала по каждому городу (ловит локальные результаты)
		for (const type of allTypes) {
			console.log(`\n=== ${type} ===`);
			for (const [, cityConfig] of Object.entries(CITIES)) {
				for (const point of cityConfig.points) {
					const label = point.label || cityConfig.name;
					console.log(`  ${label} (r=${point.radius}m)`);
					const places = await fetchPointRaw(type, point);
					let newCount = 0;
					for (const p of places) {
						if (seenIds.has(p.id)) continue;
						seenIds.add(p.id);
						p._searchType = type;
						allPlaces.push(p);
						newCount++;
					}
					if (newCount > 0) console.log(`    +${newCount}`);
					await sleep(200);
				}
			}

			// 2) Недостающие муниципалитеты
			for (const point of EXTRA_POINTS) {
				console.log(`  ${point.label} (r=${point.radius}m)`);
				const places = await fetchPointRaw(type, point);
				let newCount = 0;
				for (const p of places) {
					if (seenIds.has(p.id)) continue;
					seenIds.add(p.id);
					p._searchType = type;
					allPlaces.push(p);
					newCount++;
				}
				if (newCount > 0) console.log(`    +${newCount}`);
				await sleep(200);
			}

			// 3) Широкий поиск добирает пропущенное между городами
			for (const point of WIDE_POINTS) {
				console.log(`  ${point.label}`);
				const places = await fetchPointRaw(type, point);
				let newCount = 0;
				for (const p of places) {
					if (seenIds.has(p.id)) continue;
					seenIds.add(p.id);
					p._searchType = type;
					allPlaces.push(p);
					newCount++;
				}
				if (newCount > 0) console.log(`    +${newCount}`);
				await sleep(200);
			}

			console.log(`  Итого ${type}: ${allPlaces.length}`);
		}

		const file = saveRaw(allPlaces, 'all' as any, 'montenegro');
		printSummary(allPlaces);
		console.log(`\nСохранено: ${file}`);
	});

	for (const [cityId, slug] of [
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
	] as [CityId, string][]) {
		const cityInfo = CITIES[cityId];

		test(`ALL medical — ${cityInfo.name} -> data/google-places/all-${slug}.json`, async () => {
			const allTypes = Object.values(PlaceType);
			const seenIds = new Set<string>();
			const allPlaces: any[] = [];

			for (const type of allTypes) {
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

			const file = saveRaw(allPlaces, 'all' as any, slug);
			printSummary(allPlaces);
			console.log(`\nСохранено: ${file}`);
		});
	}

	test('split all-montenegro.json -> city folders', async () => {
		const srcFile = path.join(OUT_DIR, 'all-montenegro.json');
		if (!fs.existsSync(srcFile)) {
			throw new Error('Сначала запусти "ALL Montenegro" для сбора данных');
		}

		const allPlaces: any[] = JSON.parse(fs.readFileSync(srcFile, 'utf-8'));

		// Slug-карта городов + координаты центров для определения ближайшего
		const CITY_SLUGS: { cityId?: CityId; slug: string; lat: number; lng: number }[] = [
			{ cityId: CityId.PODGORICA, slug: 'podgorica', lat: 42.442574, lng: 19.268646 },
			{ cityId: CityId.NIKSIC, slug: 'niksic', lat: 42.771059, lng: 18.947681 },
			{ cityId: CityId.BUDVA, slug: 'budva', lat: 42.2864, lng: 18.84 },
			{ cityId: CityId.TIVAT, slug: 'tivat', lat: 42.434981, lng: 18.706640 },
			{ cityId: CityId.ULCINJ, slug: 'ulcinj', lat: 41.9297, lng: 19.2142 },
			{ cityId: CityId.KOTOR, slug: 'kotor', lat: 42.432044, lng: 18.769454 },
			{ cityId: CityId.BAR, slug: 'bar', lat: 42.098060, lng: 19.094827 },
			{ cityId: CityId.HERCEG_NOVI, slug: 'herceg-novi', lat: 42.457418, lng: 18.532136 },
			{ cityId: CityId.BERANE, slug: 'berane', lat: 42.8428, lng: 19.8733 },
			{ cityId: CityId.CETINJE, slug: 'cetinje', lat: 42.389, lng: 18.924 },
			{ cityId: CityId.DANILOVGRAD, slug: 'danilovgrad', lat: 42.5595, lng: 19.0969 },
			{ cityId: CityId.BELO_POLJE, slug: 'bijelo-polje', lat: 43.0353, lng: 19.7472 },
			// Доп. муниципалитеты (нет в CityId)
			{ slug: 'pljevlja', lat: 43.357, lng: 19.357 },
			{ slug: 'rozaje', lat: 42.840, lng: 20.165 },
			{ slug: 'kolasin', lat: 42.826, lng: 19.514 },
			{ slug: 'zabljak', lat: 43.155, lng: 19.118 },
			{ slug: 'mojkovac', lat: 42.962, lng: 19.582 },
			{ slug: 'plav', lat: 42.597, lng: 19.945 },
			{ slug: 'andrijevica', lat: 42.735, lng: 19.790 },
			{ slug: 'savnik', lat: 42.960, lng: 19.090 },
			{ slug: 'gusinje', lat: 42.596, lng: 19.965 },
			{ slug: 'petnjica', lat: 42.894, lng: 20.028 },
		];

		function haversine(lat1: number, lng1: number, lat2: number, lng2: number): number {
			const R = 6371;
			const toRad = (d: number) => d * Math.PI / 180;
			const dLat = toRad(lat2 - lat1);
			const dLng = toRad(lng2 - lng1);
			const a = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) ** 2;
			return 2 * R * Math.asin(Math.sqrt(a));
		}

		function findNearestCity(lat: number, lng: number) {
			let best = CITY_SLUGS[0];
			let bestDist = Infinity;
			for (const c of CITY_SLUGS) {
				const d = haversine(lat, lng, c.lat, c.lng);
				if (d < bestDist) { bestDist = d; best = c; }
			}
			return best;
		}

		function toSlug(name: string): string {
			return toLatin(name)
				.toLowerCase()
				.normalize('NFD').replace(/[\u0300-\u036f]/g, '') // убирает диакритики (š→s, ć→c, ë→e...)
				.replace(/đ/g, 'dj')
				.replace(/[^a-z0-9]+/g, '-')
				.replace(/^-|-$/g, '')
				.slice(0, 60);
		}

		const MNE_KEYWORDS = ['Црна Гора', 'Montenegro', 'Crna Gora'];
		function isMontenegro(place: any): boolean {
			const addr = place.formattedAddress || '';
			return MNE_KEYWORDS.some(kw => addr.includes(kw));
		}

		const stats: Record<string, number> = {};
		let skipped = 0;

		for (const p of allPlaces) {
			if (!isMontenegro(p)) { skipped++; continue; }

			const lat = p.location?.latitude;
			const lng = p.location?.longitude;
			if (!lat || !lng) continue;

			const city = findNearestCity(lat, lng);
			const name = p.displayName?.text || 'unknown';
			const slug = toSlug(name);

			const cityDir = path.join(OUT_DIR, city.slug);
			if (!fs.existsSync(cityDir)) fs.mkdirSync(cityDir, { recursive: true });

			const outFile = path.join(cityDir, `${slug}.json`);
			fs.writeFileSync(outFile, JSON.stringify(p, null, 2), 'utf-8');

			stats[city.slug] = (stats[city.slug] || 0) + 1;
		}

		console.log('\nРаспределение по городам:');
		for (const [slug, count] of Object.entries(stats).sort((a, b) => b[1] - a[1])) {
			console.log(`  ${slug}: ${count}`);
		}
		console.log(`\nВсего: ${allPlaces.length - skipped} (пропущено ${skipped} не-МЕ)`);
	});
});
