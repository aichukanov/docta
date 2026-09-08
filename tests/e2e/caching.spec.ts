import { test, expect } from '@playwright/test';
import { URLS } from '../utils/constants';
import { fetchText, visit } from '../utils/http';

// Контракт кэширования HTML и определения локали.
//
// Всё это — инфраструктура, которая либо работает молча, либо ломается молча.
// Юнит-тесты сторожат конфиг и чистые функции; здесь проверяется, что до
// реального HTTP-ответа доезжает именно то, что задумано.
//
// Самый дорогой сценарий тут — НЕ «кэш не включился» (это заметят по счетам за
// CPU), а «закэшировалось то, что нельзя»: на странице клиники и врача в
// серверную разметку попадает баннер владельца (`isOwner`), и общий кэш отдал
// бы его всем подряд.
//
// Навигация через `visit`, а не `request.get()`: прод за Cloudflare отдаёт
// не-браузерным клиентам 403 (см. tests/utils/http.ts).

/** Первая ссылка на карточку раздела с листинга. */
async function firstDetailHref(page: any, listing: string, prefix: string) {
	await page.goto(listing, { waitUntil: 'domcontentloaded' });
	const href = await page
		.locator(`a[href^="${prefix}/"]`)
		.first()
		.getAttribute('href');

	if (!href) {
		throw new Error(`не нашёл карточку в ${listing}`);
	}
	// Ссылки несут ?lang= — для проверки заголовков он не нужен и только
	// плодит варианты кэша.
	return href.split('?')[0];
}

test.describe('Кэш HTML', () => {
	// Каталог и статические страницы отдаются всем одинаково, поэтому их можно
	// держать на общих кэшах. Без `s-maxage` Cloudflare нечего кэшировать —
	// заголовок и есть весь механизм.
	const cacheable = [
		URLS.HOME,
		'/about',
		'/articles',
		URLS.SERVICES,
		URLS.LABTESTS,
		URLS.MEDICINES,
		URLS.DOCTORS,
		URLS.CLINICS,
	];

	for (const url of cacheable) {
		test(`${url}: отдаётся с s-maxage`, async ({ page }) => {
			const res = await visit(page, url);

			expect(res.status).toBe(200);
			expect(res.headers['cache-control']).toBeTruthy();
			expect(res.headers['cache-control']).toContain('s-maxage=');
			// Браузер обязан перепроверять: правка контента должна быть видна
			// сразу, а не через час.
			expect(res.headers['cache-control']).toContain('max-age=0');
		});
	}

	test('локализованная версия кэшируется отдельно, но кэшируется', async ({
		page,
	}) => {
		const res = await visit(page, `${URLS.SERVICES}?lang=ru`);

		expect(res.status).toBe(200);
		expect(res.headers['cache-control']).toContain('s-maxage=');
	});

	// Ключевая проверка раздела: эти страницы показывают владельцу клиники
	// баннер управления прямо в серверной разметке. Попади они в общий кэш —
	// баннер увидел бы любой посетитель, а владелец получил бы чужую версию.
	test('страница клиники НЕ кэшируется: в разметке баннер владельца', async ({
		page,
	}) => {
		const href = await firstDetailHref(page, URLS.CLINICS, '/clinics');
		const res = await visit(page, href);

		expect(res.status).toBe(200);
		expect(res.headers['cache-control']).toBeFalsy();
	});

	test('страница врача НЕ кэшируется: в разметке баннер владельца', async ({
		page,
	}) => {
		const href = await firstDetailHref(page, URLS.DOCTORS, '/doctors');
		const res = await visit(page, href);

		expect(res.status).toBe(200);
		expect(res.headers['cache-control']).toBeFalsy();
	});

	test('кабинет не кэшируется и закрыт заголовком от индексации', async ({
		page,
	}) => {
		const res = await visit(page, '/profile');

		expect(res.headers['cache-control']).toBeFalsy();
		// Страница ssr:false: мета появится только после JS, поэтому noindex
		// обязан быть заголовком — краулер до меты может не дождаться.
		expect(res.headers['x-robots-tag']).toContain('noindex');
	});
});

test.describe('Кэш статики', () => {
	// Правила для этих файлов раньше были написаны в синтаксисе, который radix3
	// не поддерживает (`/**/*.png`), и не срабатывали ни разу: иконки с каждой
	// страницы ревалидировались на каждом визите.
	const immutable = [
		'/favicon.svg',
		'/favicon-96x96.png',
		'/apple-touch-icon.png',
		'/web-app-manifest-192x192.png',
		'/site.webmanifest',
	];

	for (const url of immutable) {
		test(`${url}: immutable на год`, async ({ page }) => {
			const res = await visit(page, url);

			expect(res.status).toBe(200);
			expect(res.headers['cache-control']).toContain('immutable');
		});
	}

	test('robots.txt длинным кэшем не закрыт — его правят руками', async ({
		page,
	}) => {
		const res = await visit(page, '/robots.txt');

		expect(res.headers['cache-control'] || '').not.toContain('immutable');
	});
});

test.describe('Локаль определяется только адресом', () => {
	// Это предусловие всего кэша: пока ответ зависел от cookie, один адрес
	// отдавал разным людям разное, и общий кэш отдал бы не тот язык.
	test('cookie не меняет язык серверной разметки', async ({
		page,
		context,
	}) => {
		await context.addCookies([
			{
				name: 'locale',
				value: 'de',
				url: page.url().startsWith('http')
					? new URL(page.url()).origin
					: 'http://localhost:3000',
			},
		]);

		// waitUntil: 'commit' — смотрим именно то, что прислал сервер, до того
		// как клиентский плагин восстановит сохранённый язык.
		const response = await page.goto(`${URLS.SERVICES}?lang=ru`, {
			waitUntil: 'commit',
		});
		const html = await response!.text();

		expect(html).toMatch(/<html[^>]+lang="ru"/);
	});

	test('явный ?lang= сильнее сохранённого языка', async ({ page }) => {
		const res = await visit(page, `${URLS.SERVICES}?lang=ru`);

		// Ссылка с языком — осознанный выбор отправителя: присланная в чат
		// русская версия обязана открыться по-русски у кого угодно.
		expect(res.url).toContain('lang=ru');
		expect(res.hops).toBe(0);
	});
});

test.describe('Канонизация адресов', () => {
	test('слеш на конце уводит на адрес без него', async ({ page }) => {
		const res = await visit(page, `${URLS.SERVICES}/`);

		expect(res.status).toBe(200);
		expect(res.hops).toBe(1);
		expect(new URL(res.url).pathname).toBe(URLS.SERVICES);
	});

	test('слеш на конце не теряет параметры', async ({ page }) => {
		const res = await visit(page, `${URLS.DOCTORS}/?lang=ru`);

		expect(new URL(res.url).pathname).toBe(URLS.DOCTORS);
		expect(res.url).toContain('lang=ru');
	});

	test('трекинговые метки не попадают в canonical', async ({ page }) => {
		await page.goto(`${URLS.DOCTORS}?fbclid=abc123&utm_source=tg`, {
			waitUntil: 'domcontentloaded',
		});

		const canonical = await page
			.locator('link[rel="canonical"]')
			.getAttribute('href');

		expect(canonical).not.toContain('fbclid');
		expect(canonical).not.toContain('utm_source');
	});

	test('сортировка в canonical остаётся: она меняет состав страницы', async ({
		page,
	}) => {
		await page.goto(`${URLS.SERVICES}?sort=price-asc`, {
			waitUntil: 'domcontentloaded',
		});

		const canonical = await page
			.locator('link[rel="canonical"]')
			.getAttribute('href');

		expect(canonical).toContain('sort=price-asc');
	});
});

test.describe('Админка', () => {
	// Раньше сюда прилетал 401 с телом JSON, и браузер предлагал скачать файл
	// вместо того, чтобы что-то показать. Гард остался на месте — изменился
	// только способ отказа: страницу человек получает, а не загрузку.
	test('аноним уходит на логин, а не получает JSON', async ({ page }) => {
		const res = await visit(page, '/admin');

		expect(res.status).toBe(200);
		expect(res.hops).toBeGreaterThanOrEqual(1);
		expect(new URL(res.url).pathname).toBe('/login');
	});

	test('адрес возврата передан логину', async ({ page }) => {
		await visit(page, '/admin');

		// Клиентские гарды кладут адрес в sessionStorage, но серверный редирект
		// туда писать не может — отсюда параметр.
		expect(page.url()).toContain('redirect=');
		expect(decodeURIComponent(page.url())).toContain('/admin');
	});

	test('от индексации закрыта заголовком', async ({ page }) => {
		// Заголовок стоит на `/admin/**` в routeRules и виден до редиректа —
		// на ssr:false странице мета появилась бы только после выполнения JS.
		const res = await fetchText(page, '/admin');

		expect(res.headers['x-robots-tag']).toContain('noindex');
	});
});
