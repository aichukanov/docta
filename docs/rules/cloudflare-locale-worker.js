/**
 * Cloudflare Worker: выбор локали по cookie на краю сети.
 *
 * Зачем — docs/rules/EDGE_LOCALE_CACHE.md.
 *
 * Коротко: сервер приложения определяет локаль ТОЛЬКО по адресу, поэтому один
 * URL отдаёт всем одно и то же и его можно кэшировать. Предпочтение посетителя
 * при этом не потеряно — его возвращает этот воркер, редиректом на адрес с
 * `?lang=`. Редирект обслуживается на краю, до кэша и без обращения к origin.
 *
 * Развернуть: Workers & Pages → Create Worker → вставить → Deploy →
 * Route `docta.me/*`.
 */

const DEFAULT_LOCALE = 'sr';

// Держать в согласии с `locales` в composables/use-locale.ts.
const LOCALES = new Set(['sr', 'sr-cyrl', 'en', 'ru', 'de', 'tr']);

// Пути, которые нельзя трогать редиректом.
//
// `/api/` и `/auth/` — данные и колбэки авторизации: у Telegram параметры
// приезжают в hash-фрагменте и лишний хоп их теряет. `.txt` в корне — robots
// и ключи IndexNow: их верификаторы ждут 200 с ровным содержимым, а не 302.
// Остальное — статика и служебное.
const SKIP_PREFIXES = [
	'/api/',
	'/auth/',
	'/admin',
	'/_nuxt/',
	'/uploads/',
	'/img/',
	'/photos/',
	'/sitemaps/',
	'/.well-known/',
	'/cdn-cgi/',
];

const SKIP_EXACT = new Set(['/sitemap.xml', '/favicon.ico', '/site.webmanifest']);

function getCookieLocale(request) {
	const header = request.headers.get('Cookie');
	if (!header) {
		return null;
	}

	for (const part of header.split(';')) {
		const [rawName, ...rawValue] = part.split('=');
		if (rawName.trim() !== 'locale') {
			continue;
		}

		const value = decodeURIComponent(rawValue.join('=').trim()).toLowerCase();
		return LOCALES.has(value) ? value : null;
	}

	return null;
}

function shouldSkip(pathname) {
	if (SKIP_EXACT.has(pathname)) {
		return true;
	}
	// Любой .txt в корне: robots.txt, ads.txt, ключи IndexNow.
	if (pathname.lastIndexOf('/') === 0 && pathname.endsWith('.txt')) {
		return true;
	}
	return SKIP_PREFIXES.some((prefix) => pathname.startsWith(prefix));
}

export default {
	async fetch(request) {
		const url = new URL(request.url);

		// Редирект уместен только для обычной навигации. HEAD пропускаем вместе
		// с GET, чтобы проверялки заголовков видели то же, что и браузер.
		if (request.method !== 'GET' && request.method !== 'HEAD') {
			return fetch(request);
		}

		// Явный язык в адресе — осознанный выбор отправителя ссылки, перебивать
		// его сохранённым предпочтением нельзя: присланная в чат русская версия
		// обязана открыться по-русски у кого угодно.
		if (url.searchParams.has('lang') || shouldSkip(url.pathname)) {
			return fetch(request);
		}

		const locale = getCookieLocale(request);

		// Нет cookie или в ней дефолтная локаль — голый адрес и есть нужный.
		// Сюда же попадают краулеры: они приходят без cookie и видят ровно то,
		// что объявлено в canonical и sitemap.
		if (!locale || locale === DEFAULT_LOCALE) {
			return fetch(request);
		}

		url.searchParams.set('lang', locale);

		// 302, а не 301: цель зависит от посетителя, и постоянный редирект
		// осел бы в кэше браузера и общих кэшах, лишив человека возможности
		// вернуться на другую версию.
		return Response.redirect(url.toString(), 302);
	},
};
