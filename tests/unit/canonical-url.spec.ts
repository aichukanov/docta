import { test, expect } from '@playwright/test';
import { getCanonicalUrl } from '../../common/url-utils';

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
