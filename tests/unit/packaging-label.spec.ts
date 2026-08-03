import { test, expect } from '@playwright/test';
import { buildPackagingLabel } from '../../common/packaging-label';
import packagingI18n from '../../i18n/packaging';
import type { PackagingFields } from '../../common/packaging-label';

// Подпись упаковки склоняется сама, через Intl.PluralRules, а формы единиц
// лежат в i18n одной строкой «one; few; many». Разделитель именно «;»: pipe
// vue-i18n перехватывает как собственный синтаксис плюрализации, и до
// selectForm строка не доходит целиком. Тест сторожит обе половины —
// и разделитель в словарях, и выбор формы по числу.

type Locale = 'ru' | 'sr' | 'sr-cyrl' | 'en' | 'de' | 'tr';

const messages = packagingI18n.messages as unknown as Record<
	string,
	Record<string, string>
>;

function tFor(locale: Locale) {
	return (key: string) => messages[locale]?.[key] ?? key;
}

const ok = (fields: Partial<PackagingFields>): PackagingFields => ({
	pack_parse_status: 'ok',
	...fields,
});

test.describe('формы единиц в словарях', () => {
	const LOCALES: Locale[] = ['ru', 'sr', 'sr-cyrl', 'en', 'de', 'tr'];
	// Сколько форм ожидается: см. PLURAL_FAMILIES в common/packaging-label.ts
	const EXPECTED_FORMS: Record<Locale, number> = {
		'ru': 3,
		'sr': 3,
		'sr-cyrl': 3,
		'en': 2,
		'de': 2,
		'tr': 1,
	};

	for (const locale of LOCALES) {
		test(`${locale}: разделитель «;», а не «|»`, () => {
			const offenders = Object.entries(messages[locale] || {})
				.filter(([key]) => key.startsWith('pack_unit_'))
				.filter(([, value]) => value.includes('|'));

			expect(
				offenders.map(([key]) => key),
				'pipe перехватывает vue-i18n — формы хранятся через «;»',
			).toEqual([]);
		});

		test(`${locale}: у счётных единиц ${EXPECTED_FORMS[locale]} форм(ы)`, () => {
			const forms = (messages[locale]?.pack_unit_tablet || '').split(';');
			expect(forms).toHaveLength(EXPECTED_FORMS[locale]);
		});
	}
});

test.describe('выбор формы по числу', () => {
	test('русский: one / few / many', () => {
		const t = tFor('ru');
		expect(
			buildPackagingLabel(ok({ pack_total: 1, pack_unit: 'tablet' }), t, 'ru'),
		).toBe('1 таблетка');
		expect(
			buildPackagingLabel(ok({ pack_total: 3, pack_unit: 'tablet' }), t, 'ru'),
		).toBe('3 таблетки');
		expect(
			buildPackagingLabel(ok({ pack_total: 20, pack_unit: 'tablet' }), t, 'ru'),
		).toBe('20 таблеток');
	});

	test('сербская латиница и кириллица дают одну форму разными буквами', () => {
		const latin = buildPackagingLabel(
			ok({ pack_total: 3, pack_unit: 'tablet' }),
			tFor('sr'),
			'sr',
		);
		const cyrillic = buildPackagingLabel(
			ok({ pack_total: 3, pack_unit: 'tablet' }),
			tFor('sr-cyrl'),
			'sr-cyrl',
		);
		expect(latin).toBe('3 tablete');
		expect(cyrillic).toBe('3 таблете');
	});

	test('турецкий: одна форма на любое число', () => {
		const t = tFor('tr');
		expect(
			buildPackagingLabel(ok({ pack_total: 1, pack_unit: 'tablet' }), t, 'tr'),
		).toBe('1 tablet');
		expect(
			buildPackagingLabel(ok({ pack_total: 20, pack_unit: 'tablet' }), t, 'tr'),
		).toBe('20 tablet');
	});
});

test.describe('контейнеры и объём', () => {
	test('контейнер с объёмом: единица в именительном', () => {
		const t = tFor('ru');
		expect(
			buildPackagingLabel(
				ok({
					pack_total: 1,
					pack_unit: 'vial',
					pack_volume: 100,
					pack_volume_unit: 'ml',
				}),
				t,
				'ru',
			),
		).toBe('флакон 100 мл');

		// После «×» единица тоже в именительном ед.ч., не «3 флакона 0,5 мл»
		expect(
			buildPackagingLabel(
				ok({
					pack_total: 3,
					pack_unit: 'vial',
					pack_volume: 0.5,
					pack_volume_unit: 'ml',
				}),
				t,
				'ru',
			),
		).toBe('3 × флакон 0,5 мл');
	});

	test('контейнер без объёма склоняется', () => {
		expect(
			buildPackagingLabel(
				ok({ pack_total: 3, pack_unit: 'vial' }),
				tFor('ru'),
				'ru',
			),
		).toBe('3 флакона');
	});

	test('только объём, без единицы', () => {
		expect(
			buildPackagingLabel(
				ok({ pack_total: 1, pack_volume: 100, pack_volume_unit: 'ml' }),
				tFor('ru'),
				'ru',
			),
		).toBe('100 мл');
	});
});

test.describe('разбивка и неразобранные записи', () => {
	test('withBreakdown добавляет «(2 × 10)»', () => {
		const fields = ok({
			pack_total: 20,
			pack_unit: 'tablet',
			pack_container_count: 2,
			pack_per_container: 10,
		});
		expect(buildPackagingLabel(fields, tFor('ru'), 'ru')).toBe('20 таблеток');
		expect(buildPackagingLabel(fields, tFor('ru'), 'ru', true)).toBe(
			'20 таблеток (2 × 10)',
		);
	});

	test('manual/пустые записи не дают подписи — сырой текст не показываем', () => {
		expect(
			buildPackagingLabel(
				{ pack_parse_status: 'manual', pack_total: 20, pack_unit: 'tablet' },
				tFor('ru'),
				'ru',
			),
		).toBe('');
		expect(
			buildPackagingLabel(
				{ pack_parse_status: 'ok', pack_total: null },
				tFor('ru'),
				'ru',
			),
		).toBe('');
		expect(
			buildPackagingLabel(
				ok({ pack_total: 5, pack_unit: null }),
				tFor('ru'),
				'ru',
			),
		).toBe('');
	});
});
