import { test, expect } from '@playwright/test';
import { buildRetiredFilterRedirect } from '../../server/common/redirect/retired-filter-ids';
import { RETIRED_SPECIALTY_IDS, DoctorSpecialty } from '../../enums/specialty';

// Пункт 12 в docs/audit/seo-2026-07.md.
//
// Риск здесь несимметричный. Не сработавший редирект стоит одной страницы,
// которая продолжит отдавать полный каталог. Ошибочно сработавший уводит живой
// фасет (29% показов Google) на чужой URL — поэтому тесты в первую очередь
// фиксируют, что на нормальных URL функция МОЛЧИТ.

test.describe('снятые ID фильтров — редирект не срабатывает', () => {
	test('действующая специальность', () => {
		expect(
			buildRetiredFilterRedirect('/doctors', { specialtyIds: '5' }),
		).toBeNull();
	});

	test('преемник снятого ID', () => {
		expect(
			buildRetiredFilterRedirect('/doctors', { specialtyIds: '94' }),
		).toBeNull();
	});

	test('никогда не существовавшее значение — это работа noindex (7d), не 301', () => {
		expect(
			buildRetiredFilterRedirect('/doctors', { specialtyIds: '99999' }),
		).toBeNull();
		expect(
			buildRetiredFilterRedirect('/doctors', { specialtyIds: 'abc' }),
		).toBeNull();
	});

	test('чистый листинг и другие параметры', () => {
		expect(buildRetiredFilterRedirect('/doctors', {})).toBeNull();
		expect(
			buildRetiredFilterRedirect('/doctors', { cityIds: '73' }),
		).toBeNull();
		expect(
			buildRetiredFilterRedirect('/services', { serviceCategoryIds: '73' }),
		).toBeNull();
	});

	test('73 в непроверяемом параметре не трогаем', () => {
		expect(buildRetiredFilterRedirect('/doctors', { page: '73' })).toBeNull();
	});
});

test.describe('снятые ID фильтров — редирект срабатывает', () => {
	test('одиночное значение', () => {
		const result = buildRetiredFilterRedirect('/doctors', {
			specialtyIds: '73',
		});
		expect(result?.status).toBe(301);
		expect(result?.url).toBe('/doctors?specialtyIds=94');
	});

	test('остальные параметры сохраняются и уезжают в канонический порядок', () => {
		const result = buildRetiredFilterRedirect('/doctors', {
			cityIds: '1',
			specialtyIds: '73',
		});
		expect(result?.url).toBe('/doctors?specialtyIds=94&cityIds=1');
	});

	test('нативная локаль сохраняется, дефолтная опускается', () => {
		expect(
			buildRetiredFilterRedirect('/doctors', {
				specialtyIds: '73',
				languageIds: '2',
				cityIds: '1',
				lang: 'en',
			})?.url,
		).toBe('/doctors?specialtyIds=94&cityIds=1&languageIds=2&lang=en');

		expect(
			buildRetiredFilterRedirect('/doctors', {
				specialtyIds: '73',
				lang: 'sr',
			})?.url,
		).toBe('/doctors?specialtyIds=94');
	});

	test('множественное значение: заменяется только снятый ID', () => {
		expect(
			buildRetiredFilterRedirect('/doctors', {
				specialtyIds: ['73', '5'],
			})?.url,
		).toBe('/doctors?specialtyIds=94&specialtyIds=5');
	});

	test('дубль после подстановки схлопывается', () => {
		expect(
			buildRetiredFilterRedirect('/doctors', {
				specialtyIds: ['73', '94'],
			})?.url,
		).toBe('/doctors?specialtyIds=94');
	});

	test('редирект одним хопом: цель сама редиректу не подлежит', () => {
		const first = buildRetiredFilterRedirect('/doctors', {
			specialtyIds: '73',
			cityIds: '1',
		});
		const [path, search] = (first?.url ?? '').split('?');
		const nextQuery = Object.fromEntries(new URLSearchParams(search));
		expect(buildRetiredFilterRedirect(path, nextQuery)).toBeNull();
	});
});

test.describe('карта снятых ID', () => {
	test('73 → PHYSIOTHERAPY и это единственная запись', () => {
		expect(RETIRED_SPECIALTY_IDS[73]).toBe(DoctorSpecialty.PHYSIOTHERAPY);
		expect(Object.keys(RETIRED_SPECIALTY_IDS)).toHaveLength(1);
	});

	test('снятый ID не вернулся в enum под другим именем', () => {
		const liveValues = Object.values(DoctorSpecialty).filter(
			(v) => typeof v === 'number',
		);
		for (const retired of Object.keys(RETIRED_SPECIALTY_IDS)) {
			expect(liveValues).not.toContain(Number(retired));
		}
	});

	test('преемник существует в enum', () => {
		const liveValues = Object.values(DoctorSpecialty).filter(
			(v) => typeof v === 'number',
		);
		for (const successor of Object.values(RETIRED_SPECIALTY_IDS)) {
			expect(liveValues).toContain(successor);
		}
	});
});
