import { executeQuery } from '~/server/common/db-mysql';
import { getClientIp } from '~/server/utils/client-ip';
import { isBotUserAgent } from '~/server/utils/bot-user-agent';
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

// Отказ ipapi (429, таймаут, сеть) кэшируем отдельным коротким TTL.
//
// Раньше `catch` возвращал `null` НЕ кэшируя, и это делало исчерпание лимита
// самоподдерживающимся: после первого 429 каждый следующий заход того же
// посетителя снова шёл в ipapi, снова получал 429 — за неделю 4810 ошибок по
// 1556 IP, 88% всего error-лога прода (docs/audit/server-logs-2026-07-30.md).
// Тот же класс, что `catch → null` в slug-redirects: тихая деградация.
//
// TTL короткий именно потому, что причина временная: «город не сматчился» —
// это факт про IP и живёт сутки, а «ipapi сейчас недоступен» — про сервис, и
// после сброса суточной квоты детект должен заработать сам.
const IP_ERROR_CACHE_TTL_MS = 10 * 60 * 1000;

// Логи этого эндпоинта сами стали проблемой: 4810 одинаковых строк за неделю
// топили всё остальное. Пишем не чаще раза в 5 минут, с числом подавленных —
// сигнал «ipapi лежит» сохраняется, шум исчезает.
const ERROR_LOG_INTERVAL_MS = 5 * 60 * 1000;
let lastErrorLoggedAt = 0;
let suppressedErrorCount = 0;

function logErrorThrottled(error: unknown): void {
	const now = Date.now();
	if (now - lastErrorLoggedAt < ERROR_LOG_INTERVAL_MS) {
		suppressedErrorCount++;
		return;
	}
	const suffix =
		suppressedErrorCount > 0
			? ` (подавлено похожих за интервал: ${suppressedErrorCount})`
			: '';
	console.error(`[GEO] Error detecting location${suffix}:`, error);
	lastErrorLoggedAt = now;
	suppressedErrorCount = 0;
}

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
	ttlMs: number = IP_CACHE_TTL_MS,
): DetectedLocation | null {
	if (ipCache.size >= IP_CACHE_MAX_SIZE) {
		const oldestKey = ipCache.keys().next().value;
		if (oldestKey) ipCache.delete(oldestKey);
	}
	ipCache.set(ip, { data, expires: Date.now() + ttlMs });
	return data;
}

// Без фолбэков: либо город уверенно сматчился с таблицей cities (Черногория),
// либо null — пользователь может быть где угодно, и подставлять Подгорицу
// или сырые IP-координаты значит втихую искажать ранжирование.
export default defineEventHandler(
	async (event): Promise<DetectedLocation | null> => {
		const clientIp = getClientIp(event);

		if (!clientIp || clientIp === 'unknown' || isPrivateIp(clientIp)) {
			return null;
		}

		// Геолокация нужна живому посетителю (ранжирование клиник по
		// расстоянию), а эндпоинт вызывается с клиента — значит его дёргают
		// краулеры, исполняющие JS. В логах прода квоту жгли Googlebot
		// (66.249.77.100) и Baiduspider (116.179.37.x). Ботам отвечаем `null`,
		// не тратя ни запроса к ipapi, ни места в кэше.
		if (isBotUserAgent(getRequestHeader(event, 'user-agent'))) {
			return null;
		}

		try {
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
			logErrorThrottled(error);
			// Кэшируем отказ, иначе следующий заход того же посетителя снова
			// пойдёт в ipapi — именно это делало 429 самоподдерживающимся.
			return cacheResult(clientIp, null, IP_ERROR_CACHE_TTL_MS);
		}
	},
);
