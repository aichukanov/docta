import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { readdirSync, statSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { getCanonicalUrl, getCanonicalPath } from '../../common/url-utils';

// prd/silent-200-index-hygiene, итерация 3.
//
// Главный риск этой правки — не дубли, а регресс: фасетные URL дают 29% показов
// в Google, и если canonical начнёт указывать на другую форму URL (или, хуже, на
// базовый листинг), потеряется треть видимости. Поэтому тесты фиксируют не
// «какой-то стабильный порядок», а РОВНО ТУ форму, которую сайт и sitemap
// отдавали до правки.

const SR = 'sr'; // дефолтная локаль: параметр lang опускается

test.describe('getCanonicalUrl — порядок параметров', () => {
	test('перестановка даёт один и тот же canonical', () => {
		const a = getCanonicalUrl(
			'/doctors',
			{ specialtyIds: '4', cityIds: '1' },
			'ru',
		);
		const b = getCanonicalUrl(
			'/doctors',
			{ cityIds: '1', specialtyIds: '4' },
			'ru',
		);
		expect(a).toBe(b);
	});

	test('lang всегда последний', () => {
		expect(getCanonicalUrl('/doctors', { specialtyIds: '4' }, 'ru')).toBe(
			'https://docta.me/doctors?specialtyIds=4&lang=ru',
		);
	});

	// Формы ниже взяты из живого прод-sitemap (все 12 встречающихся комбинаций).
	// Ни одна не должна измениться, иначе canonical разъедется с sitemap.
	const sitemapForms: Array<[string, Record<string, string>, string]> = [
		[
			'/medicines',
			{ substanceIds: '635', atcGroupIds: '12' },
			'/medicines?substanceIds=635&atcGroupIds=12',
		],
		[
			'/doctors',
			{ specialtyIds: '5', cityIds: '3' },
			'/doctors?specialtyIds=5&cityIds=3',
		],
		[
			'/services',
			{ serviceCategoryIds: '7', cityIds: '3' },
			'/services?serviceCategoryIds=7&cityIds=3',
		],
		[
			'/labtests',
			{ categoryIds: '1', cityIds: '2' },
			'/labtests?categoryIds=1&cityIds=2',
		],
		[
			'/doctors',
			{ specialtyIds: '5', languageIds: '2' },
			'/doctors?specialtyIds=5&languageIds=2',
		],
		[
			'/clinics',
			{ clinicTypeIds: '4', cityIds: '3' },
			'/clinics?clinicTypeIds=4&cityIds=3',
		],
		['/doctors', { specialtyIds: '5' }, '/doctors?specialtyIds=5'],
		['/clinics', { cityIds: '3' }, '/clinics?cityIds=3'],
		['/medicines', { atcGroupIds: '12' }, '/medicines?atcGroupIds=12'],
	];

	for (const [path, query, expected] of sitemapForms) {
		test(`форма из sitemap не меняется: ${expected}`, () => {
			expect(getCanonicalUrl(path, query, SR)).toBe(
				`https://docta.me${expected}`,
			);
		});
	}
});

test.describe('getCanonicalUrl — UI-параметры', () => {
	test('tab вырезается', () => {
		expect(
			getCanonicalUrl('/labtests/cholesterol', { tab: 'clinics' }, 'ru'),
		).toBe('https://docta.me/labtests/cholesterol?lang=ru');
	});

	test('tab вырезается, содержательные параметры остаются', () => {
		expect(
			getCanonicalUrl(
				'/labtests/cholesterol',
				{ tab: 'clinics', cityIds: '3' },
				SR,
			),
		).toBe('https://docta.me/labtests/cholesterol?cityIds=3');
	});

	test('sort НЕ вырезается — меняет состав страницы пагинации', () => {
		expect(
			getCanonicalUrl('/clinics/x/reviews', { sort: 'newest' }, SR),
		).toContain('sort=newest');
	});
});

test.describe('getCanonicalUrl — регрессы, которые нельзя допустить', () => {
	test('фасет НЕ сворачивается на базовый листинг', () => {
		const url = getCanonicalUrl('/doctors', { specialtyIds: '5' }, SR);
		expect(url).not.toBe('https://docta.me/doctors');
		expect(url).toContain('specialtyIds=5');
	});

	test('page сохраняется (пагинация self-canonical)', () => {
		expect(getCanonicalUrl('/doctors', { page: '2' }, 'ru')).toBe(
			'https://docta.me/doctors?page=2&lang=ru',
		);
	});

	test('страница без параметров остаётся чистой', () => {
		expect(getCanonicalUrl('/doctors', {}, SR)).toBe(
			'https://docta.me/doctors',
		);
	});

	test('массив значений сохраняется целиком', () => {
		expect(getCanonicalUrl('/doctors', { cityIds: ['1', '3'] }, SR)).toBe(
			'https://docta.me/doctors?cityIds=1&cityIds=3',
		);
	});
});

// Поверхность дублей, которую нельзя перечислить денайлистом: мусорные
// query-параметры приходят снаружи (шеры в Facebook, промо-посты в Telegram,
// реклама), и каждый такой URL раньше становился самоканоничным дублём со
// своим кластером из семи hreflang.
test.describe('getCanonicalUrl — мусорные параметры (allowlist)', () => {
	const junk = [
		'utm_source',
		'utm_medium',
		'utm_campaign',
		'utm_term',
		'utm_content',
		'fbclid',
		'gclid',
		'yclid',
		'msclkid',
	];

	for (const key of junk) {
		test(`${key} вырезается`, () => {
			expect(getCanonicalUrl('/doctors', { [key]: 'xyz123' }, SR)).toBe(
				'https://docta.me/doctors',
			);
		});
	}

	test('мусор вырезается, фасет остаётся', () => {
		expect(
			getCanonicalUrl(
				'/doctors',
				{ fbclid: 'IwAR0', specialtyIds: '5', utm_source: 'telegram' },
				SR,
			),
		).toBe('https://docta.me/doctors?specialtyIds=5');
	});

	test('неизвестный ключ не попадает в canonical', () => {
		expect(getCanonicalUrl('/clinics', { hello: 'world' }, 'ru')).toBe(
			'https://docta.me/clinics?lang=ru',
		);
	});
});

test.describe('getCanonicalUrl — осмысленные ключи остаются', () => {
	// sort исключать нельзя: на страницах отзывов он меняет состав конкретной
	// страницы пагинации, и `?sort=X&page=2` — не то же самое, что `?page=2`.
	// Порядок тот же, что был до перехода на allowlist: `page` стоит в
	// CANONICAL_QUERY_ORDER, `sort` — нет, поэтому он уезжает в хвост.
	test('sort остаётся вместе с page', () => {
		expect(
			getCanonicalUrl(
				'/doctors/ivanov/reviews',
				{ sort: 'rating-desc', page: '2' },
				SR,
			),
		).toBe('https://docta.me/doctors/ivanov/reviews?page=2&sort=rating-desc');
	});

	test('sort переживает соседство с мусором', () => {
		const url = getCanonicalUrl(
			'/clinics/x/reviews',
			{ sort: 'newest', fbclid: 'abc' },
			SR,
		);
		expect(url).toContain('sort=newest');
		expect(url).not.toContain('fbclid');
	});

	// Страницы внутреннего поиска и нестабильных фильтров закрыты через
	// noindex — canonical у них обязан оставаться self, иначе к noindex
	// добавится второй, противоречащий сигнал.
	const kept: Array<[string, Record<string, string>]> = [
		['name', { name: 'petrov' }],
		['search', { search: 'krv' }],
		['category', { category: '3' }],
		['openNow', { openNow: 'true' }],
		['minRating', { minRating: '4' }],
		['clinicIds', { clinicIds: '88' }],
		['atcClassCodes', { atcClassCodes: 'R06' }],
		['pharmaFormIds', { pharmaFormIds: '2' }],
		['manufacturerIds', { manufacturerIds: '7' }],
	];

	for (const [key, query] of kept) {
		test(`${key} остаётся в canonical`, () => {
			expect(getCanonicalUrl('/doctors', query, SR)).toContain(
				`${key}=${Object.values(query)[0]}`,
			);
		});
	}

	// Оба ключа не имели места в CANONICAL_QUERY_ORDER, из-за чего сортировались
	// по появлению: перестановка давала два разных canonical на одну выборку.
	test('перестановка фасетов лекарств даёт один canonical', () => {
		const a = getCanonicalUrl(
			'/medicines',
			{ medicineCategoryIds: '1', dispensingModeIds: '2' },
			SR,
		);
		const b = getCanonicalUrl(
			'/medicines',
			{ dispensingModeIds: '2', medicineCategoryIds: '1' },
			SR,
		);
		expect(a).toBe(b);
		expect(a).toBe(
			'https://docta.me/medicines?medicineCategoryIds=1&dispensingModeIds=2',
		);
	});
});

test.describe('canonical собирается в одном месте', () => {
	const HERE = dirname(fileURLToPath(import.meta.url));
	const ROOT = resolve(HERE, '../..');
	const DIRS = ['app.vue', 'components', 'pages', 'composables', 'common'];

	const sources = (): string[] => {
		const files: string[] = [];
		const walk = (path: string) => {
			if (statSync(path).isFile()) {
				if (/\.(vue|ts)$/.test(path)) files.push(path);
				return;
			}
			for (const entry of readdirSync(path)) walk(join(path, entry));
		};
		for (const dir of DIRS) walk(resolve(ROOT, dir));
		return files;
	};

	/*
	 * Своя склейка canonical — не стилистика, а два реальных дефекта разом.
	 * `components/reviews-page.vue` собирал его вручную и до 2026-09-08
	 * (а) давал `?lang=ru&page=2` там, где весь остальной сайт даёт
	 * `?page=2&lang=ru` — при том что hreflang этой же странице ставит
	 * `app.vue` канонической функцией, то есть self-canonical и языковые
	 * версии указывали на разные адреса; и (б) выбрасывал `?sort=`, из-за
	 * чего `?sort=rating_low&page=2` канонизировалась в `?page=2` — страницу
	 * с другими отзывами.
	 *
	 * Дубликат выигрывал молча: ключ `canonical` тот же, а setup дочернего
	 * компонента идёт после `app.vue`.
	 */
	test('rel=canonical регистрирует только app.vue', () => {
		const registering = sources().filter((file) =>
			/rel:\s*'canonical'|rel="canonical"/.test(readFileSync(file, 'utf-8')),
		);

		// Сравнение со списком, а не с пустотой: сломайся обход или регулярка —
		// проверка «лишних нет» прошла бы зелёной, ничего не проверив.
		expect(registering.map((file) => file.slice(ROOT.length + 1))).toEqual([
			'app.vue',
		]);
	});

	test('getCanonicalPath — тот же адрес без домена', () => {
		const query = { specialtyIds: '4', page: '2' };
		expect(`https://docta.me${getCanonicalPath('/doctors', query, 'ru')}`).toBe(
			getCanonicalUrl('/doctors', query, 'ru'),
		);
	});
});
