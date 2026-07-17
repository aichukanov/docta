import { executeQuery } from '~/server/common/db-mysql';
import { getClientIp } from '~/server/utils/client-ip';
import type { DetectedLocation } from '~/interfaces/geo';

interface IpApiResponse {
	city?: string;
	country_code?: string;
	latitude?: number;
	longitude?: number;
	error?: boolean;
}

interface CityRow {
	id: number;
	name: string;
	latitude: number | null;
	longitude: number | null;
}

// Кэш результатов по IP: бесплатный лимит ipapi.co — 1000 запросов/день.
// IP в БД не сохраняем (приватность) — только in-memory с TTL.
// null тоже кэшируем: неудачный детект не должен дёргать ipapi на каждый заход.
const IP_CACHE_TTL_MS = 24 * 60 * 60 * 1000;
const IP_CACHE_MAX_SIZE = 5000;
const ipCache = new Map<
	string,
	{ data: DetectedLocation | null; expires: number }
>();

// Список городов меняется редко — кэшируем на час
const CITIES_CACHE_TTL_MS = 60 * 60 * 1000;
let citiesCache: { rows: CityRow[]; expires: number } | null = null;

function isPrivateIp(ip: string): boolean {
	return (
		ip === '127.0.0.1' ||
		ip === '::1' ||
		ip.startsWith('10.') ||
		ip.startsWith('192.168.') ||
		/^172\.(1[6-9]|2\d|3[01])\./.test(ip) ||
		ip.startsWith('fc') ||
		ip.startsWith('fd') ||
		ip.startsWith('fe80')
	);
}

// ipapi возвращает английские/латинские названия; в БД — латиница с диакритикой.
// NFD-нормализация снимает č/ć/š/ž, đ не раскладывается — заменяем вручную.
function normalizeCityName(name: string): string {
	return name
		.toLowerCase()
		.normalize('NFD')
		.replace(/[̀-ͯ]/g, '')
		.replace(/đ/g, 'd')
		.trim();
}

async function getCities(): Promise<CityRow[]> {
	if (citiesCache && citiesCache.expires > Date.now()) {
		return citiesCache.rows;
	}
	const rows = await executeQuery<CityRow>(
		'SELECT id, name, latitude, longitude FROM cities',
	);
	citiesCache = { rows, expires: Date.now() + CITIES_CACHE_TTL_MS };
	return rows;
}

function cacheResult(
	ip: string,
	data: DetectedLocation | null,
): DetectedLocation | null {
	if (ipCache.size >= IP_CACHE_MAX_SIZE) {
		const oldestKey = ipCache.keys().next().value;
		if (oldestKey) ipCache.delete(oldestKey);
	}
	ipCache.set(ip, { data, expires: Date.now() + IP_CACHE_TTL_MS });
	return data;
}

// Без фолбэков: либо город уверенно сматчился с таблицей cities (Черногория),
// либо null — пользователь может быть где угодно, и подставлять Подгорицу
// или сырые IP-координаты значит втихую искажать ранжирование.
export default defineEventHandler(
	async (event): Promise<DetectedLocation | null> => {
		try {
			const clientIp = getClientIp(event);

			if (!clientIp || clientIp === 'unknown' || isPrivateIp(clientIp)) {
				return null;
			}

			const cached = ipCache.get(clientIp);
			if (cached && cached.expires > Date.now()) {
				return cached.data;
			}

			const response = await $fetch<IpApiResponse>(
				`https://ipapi.co/${clientIp}/json/`,
				{ timeout: 3000 },
			);

			if (
				response.error ||
				!response.city ||
				typeof response.latitude !== 'number' ||
				typeof response.longitude !== 'number'
			) {
				return cacheResult(clientIp, null);
			}

			const cities = await getCities();
			const normalized = normalizeCityName(response.city);
			const matched = cities.find(
				(city) => normalizeCityName(city.name) === normalized,
			);

			if (!matched) {
				return cacheResult(clientIp, null);
			}

			// Берём центр города из БД: расстояние считаем от центра города,
			// а не от неточной IP-точки (и так совпадает с ручным выбором города)
			return cacheResult(clientIp, {
				cityId: matched.id,
				latitude: Number(matched.latitude ?? response.latitude),
				longitude: Number(matched.longitude ?? response.longitude),
			});
		} catch (error) {
			console.error('[GEO] Error detecting location:', error);
			return null;
		}
	},
);
