import { executeQuery } from '~/server/common/db-mysql';
import { PRIVATE_CACHE_CONTROL } from '~/server/common/private-cache';
import type { DetectedLocation } from '~/interfaces/geo';

interface CityRow {
	id: number;
	name: string;
	latitude: number | null;
	longitude: number | null;
}

// Список городов меняется редко — кэшируем на час
const CITIES_CACHE_TTL_MS = 60 * 60 * 1000;
let citiesCache: { rows: CityRow[]; expires: number } | null = null;

// Заголовки не приходят, если Managed Transform «Add visitor location
// headers» выключён в панели Cloudflare или запрос пришёл мимо Cloudflare.
// Первый случай — это молчаливая смерть геодетекта на всём сайте, поэтому он
// должен быть виден в логе. Одна строка на процесс: причина не рассасывается
// сама, повторять её каждый запрос смысла нет (эндпоинт зовёт каждый клиент).
let missingHeadersWarned = false;

function warnMissingHeadersOnce(): void {
	if (missingHeadersWarned) return;
	missingHeadersWarned = true;
	console.warn(
		'[GEO] Нет заголовка cf-ipcity. Проверить в Cloudflare: Rules → ' +
			'Managed Transforms → Add visitor location headers.',
	);
}

// Cloudflare отдаёт названия городов латиницей без диакритики; в БД —
// латиница с диакритикой. NFD-нормализация снимает č/ć/š/ž, đ не
// раскладывается — заменяем вручную. Нормализуются обе стороны сравнения,
// поэтому написание с диакритикой в заголовке тоже сматчится.
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

function parseCoordinate(raw: string | undefined): number | null {
	if (!raw) return null;
	const value = Number(raw);
	return Number.isFinite(value) ? value : null;
}

/**
 * Локация посетителя из заголовков Cloudflare.
 *
 * Раньше здесь был запрос к ipapi.co, и вся обвязка вокруг него существовала
 * только ради его бесплатного лимита в 1000 запросов в сутки: кэш результатов
 * по IP, отдельный короткий TTL на отказы, throttled-логгер и отсев ботов по
 * User-Agent. Лимит всё равно выжигался — 4810 ошибок 429 за неделю, 88% всего
 * error-лога прода (docs/audit/server-logs-2026-07-30.md).
 *
 * Cloudflare, за которым и так стоят домены, кладёт `cf-ipcity`,
 * `cf-iplatitude` и `cf-iplongitude` в каждый запрос — ровно те три поля,
 * которые читались из ответа ipapi. Внешнего вызова больше нет, значит нет ни
 * лимита, ни таймаута в пути пользовательского запроса, ни смысла в кэше и
 * отсеве ботов: заголовок бесплатен и приходит уже разобранным.
 *
 * Включается в панели: Rules → Managed Transforms → Add visitor location
 * headers. Без этого заголовков нет и эндпоинт всегда отвечает `null`.
 *
 * Без фолбэков: либо город уверенно сматчился с таблицей cities (Черногория),
 * либо null — посетитель может быть где угодно, и подставлять Подгорицу или
 * сырые координаты IP значит втихую искажать ранжирование.
 */
export default defineEventHandler(
	async (event): Promise<DetectedLocation | null> => {
		// Ответ зависит от IP посетителя, а не от адреса. На общих кэшах
		// (Cloudflare) такому ответу делать нечего: одна запись раздала бы
		// всем город первого попавшего. Сейчас `/api/` под Cache Rule не
		// подпадает, но правило может измениться, а этот заголовок — нет.
		setResponseHeader(event, 'cache-control', PRIVATE_CACHE_CONTROL);

		const city = getRequestHeader(event, 'cf-ipcity');

		if (!city) {
			// Заголовка нет и у локальной разработки, и у запроса мимо
			// Cloudflare — предупреждаем только там, где Cloudflare заведомо
			// был: свой заголовок с IP он проставляет всегда.
			if (getRequestHeader(event, 'cf-connecting-ip')) {
				warnMissingHeadersOnce();
			}
			return null;
		}

		const cities = await getCities();
		const normalized = normalizeCityName(city);
		const matched = cities.find(
			(row) => normalizeCityName(row.name) === normalized,
		);

		if (!matched) {
			return null;
		}

		// Берём центр города из БД: расстояние считаем от центра города, а не
		// от неточной точки IP (и так совпадает с ручным выбором города).
		// Координаты из заголовков — только фолбэк для городов без координат.
		const latitude =
			matched.latitude ??
			parseCoordinate(getRequestHeader(event, 'cf-iplatitude'));
		const longitude =
			matched.longitude ??
			parseCoordinate(getRequestHeader(event, 'cf-iplongitude'));

		if (latitude === null || longitude === null) {
			return null;
		}

		return {
			cityId: matched.id,
			latitude: Number(latitude),
			longitude: Number(longitude),
		};
	},
);
