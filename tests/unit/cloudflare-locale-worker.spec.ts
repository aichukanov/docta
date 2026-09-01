import { test, expect } from '@playwright/test';
import { dirname, resolve } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

// Воркер живёт вне приложения (его разворачивают в панели Cloudflare), но
// логика в нём — часть контракта локалей: сервер определяет язык только по
// адресу, а предпочтение посетителя возвращает этот редирект на краю сети.
// См. docs/rules/EDGE_LOCALE_CACHE.md.
//
// Ошибиться тут дёшево и незаметно: лишний редирект на /api/ ломает выдачу,
// на .txt в корне — верификацию IndexNow, а пропущенный `?lang=` заставляет
// присланную в чат ссылку открываться на чужом языке.

const HERE = dirname(fileURLToPath(import.meta.url));
const WORKER_PATH = resolve(HERE, '../../docs/rules/cloudflare-locale-worker.js');

const worker = (await import(pathToFileURL(WORKER_PATH).href)).default;

/** Прогоняет запрос через воркер, подменяя выход в сеть. */
async function run(
	url: string,
	{ cookie, method = 'GET' }: { cookie?: string; method?: string } = {},
) {
	const originalFetch = globalThis.fetch;
	let passedThrough = false;

	globalThis.fetch = (async () => {
		passedThrough = true;
		return new Response('origin', { status: 200 });
	}) as typeof fetch;

	try {
		const request = new Request(url, {
			method,
			headers: cookie ? { Cookie: cookie } : {},
		});
		const response = await worker.fetch(request);

		return {
			passedThrough,
			status: response.status,
			location: response.headers.get('location'),
		};
	} finally {
		globalThis.fetch = originalFetch;
	}
}

test.describe('редирект по cookie', () => {
	test('голый адрес с непустой локалью уходит на ?lang=', async () => {
		const r = await run('https://docta.me/services', { cookie: 'locale=ru' });

		expect(r.status).toBe(302);
		expect(r.location).toBe('https://docta.me/services?lang=ru');
		expect(r.passedThrough).toBe(false);
	});

	test('редирект временный: цель зависит от посетителя', async () => {
		const r = await run('https://docta.me/', { cookie: 'locale=de' });

		// 301 осел бы в кэше браузера и запер человека на одном языке.
		expect(r.status).toBe(302);
	});

	test('сохраняет остальные параметры адреса', async () => {
		const r = await run('https://docta.me/doctors?specialtyIds=4&page=2', {
			cookie: 'locale=de',
		});

		expect(r.location).toContain('specialtyIds=4');
		expect(r.location).toContain('page=2');
		expect(r.location).toContain('lang=de');
	});

	test('несколько cookie в заголовке — берётся именно locale', async () => {
		const r = await run('https://docta.me/', {
			cookie: 'session_id=abc; locale=tr; i18n_redirected=sr',
		});

		expect(r.location).toBe('https://docta.me/?lang=tr');
	});
});

test.describe('когда трогать нельзя', () => {
	test('явный ?lang= сильнее cookie', async () => {
		const r = await run('https://docta.me/?lang=ru', { cookie: 'locale=de' });

		expect(r.passedThrough).toBe(true);
		expect(r.status).toBe(200);
	});

	test('дефолтная локаль в cookie не создаёт редиректа', async () => {
		const r = await run('https://docta.me/', { cookie: 'locale=sr' });

		expect(r.passedThrough).toBe(true);
	});

	test('краулер без cookie видит голый адрес', async () => {
		const r = await run('https://docta.me/services');

		expect(r.passedThrough).toBe(true);
	});

	test('мусор в cookie игнорируется', async () => {
		for (const value of ['locale=xx', 'locale=', 'locale=%20', 'locale=me']) {
			const r = await run('https://docta.me/', { cookie: value });
			expect(r.passedThrough, value).toBe(true);
		}
	});

	test('служебные пути проходят насквозь', async () => {
		const paths = [
			'/api/clinics/list',
			'/auth/telegram/return',
			'/admin',
			'/_nuxt/entry.js',
			'/uploads/doctors/a.webp',
			'/img/articles/x.webp',
			'/sitemap.xml',
			'/sitemaps/core-1.xml',
			'/robots.txt',
			'/ads.txt',
			'/89f50cfd072780601a781474285a3534.txt',
			'/.well-known/x',
			'/favicon.ico',
		];

		for (const path of paths) {
			const r = await run(`https://docta.me${path}`, { cookie: 'locale=ru' });
			expect(r.passedThrough, path).toBe(true);
		}
	});

	test('POST не редиректится — тело запроса потерялось бы', async () => {
		const r = await run('https://docta.me/', {
			cookie: 'locale=ru',
			method: 'POST',
		});

		expect(r.passedThrough).toBe(true);
	});

	test('HEAD ведёт себя как GET: проверялки заголовков видят то же', async () => {
		const r = await run('https://docta.me/', {
			cookie: 'locale=ru',
			method: 'HEAD',
		});

		expect(r.status).toBe(302);
	});
});

test('список локалей совпадает с приложением', async () => {
	const { readFileSync } = await import('node:fs');
	const source = readFileSync(WORKER_PATH, 'utf-8');
	const inWorker = source
		.match(/const LOCALES = new Set\(\[([^\]]+)\]\)/)![1]
		.match(/'([^']+)'/g)!
		.map((s) => s.replaceAll("'", ''))
		.sort();

	const appSource = readFileSync(
		resolve(HERE, '../../composables/use-locale.ts'),
		'utf-8',
	);
	const inApp = appSource
		.match(/export const locales = \[([\s\S]*?)\] as const/)![1]
		.match(/Language\.(\w+)/g)!.length;

	// Сверяем количество: имена в приложении — константы enum, а в воркере
	// строковые значения; расхождение по числу ловит забытую локаль.
	expect(inWorker.length).toBe(inApp);
});
