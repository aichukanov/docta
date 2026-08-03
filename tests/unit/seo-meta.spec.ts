import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
	buildSeoDescription,
	buildSeoPriceSegment,
	fitSeoTitle,
	SEO_DESCRIPTION_MAX_LENGTH,
	SEO_TITLE_MAX_LENGTH,
} from '../../common/seo-meta';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '../..');

// Bing SEO Best Practices: title короче 70 символов. Замер прода 2026-08-03 —
// половина карточек услуг длиннее, максимум 132 символа.

test.describe('fitSeoTitle', () => {
	test('берёт самый полный вариант, если он влезает', () => {
		expect(
			fitSeoTitle(['Nipple reduction | Estetska hirurgija | Podgorica', 'x']),
		).toBe('Nipple reduction | Estetska hirurgija | Podgorica');
	});

	test('отбрасывает варианты, пока не влезет', () => {
		const long = 'Ureteropijelografija retrogradna bilateralna kod muškaraca';
		expect(
			fitSeoTitle([
				`${long} | Urologija | Crna Gora`,
				`${long} | Crna Gora`,
				long,
			]),
		).toBe(`${long} | Crna Gora`);
	});

	test('отдаёт последний вариант, даже если он длиннее лимита', () => {
		// Название услуги на 96 символов: обрезать медицинский термин по
		// символам хуже, чем отдать его целиком.
		const name =
			'Rekonstrukcija krvnih sudova vrata by-pass postupkom (karotidno/vertebralna) autovenskim graftom';
		expect(fitSeoTitle([`${name} | Opšta hirurgija | Crna Gora`, name])).toBe(
			name,
		);
	});

	test('пропускает пустые, false и пробельные варианты', () => {
		expect(fitSeoTitle([undefined, false, '   ', null, 'Dr Zejnilović'])).toBe(
			'Dr Zejnilović',
		);
	});

	test('пустой список даёт пустую строку', () => {
		expect(fitSeoTitle([])).toBe('');
		expect(fitSeoTitle([undefined, ''])).toBe('');
	});

	test('лимит переопределяется параметром', () => {
		expect(fitSeoTitle(['abcdef', 'abc'], 5)).toBe('abc');
	});
});

test.describe('buildSeoDescription', () => {
	test('склеивает сегменты в предложения', () => {
		expect(
			buildSeoDescription([
				'Smanjenje bradavice — medicinska usluga u Podgorici',
				'Cijena od 200 € do 400 €',
				'Uporedite cijene i kontakte klinika na Docta.me',
			]),
		).toBe(
			'Smanjenje bradavice — medicinska usluga u Podgorici. Cijena od 200 € do 400 €. Uporedite cijene i kontakte klinika na Docta.me.',
		);
	});

	test('пропускает сегмент, который не влезает, и берёт следующий', () => {
		// Ровно тот случай, ради которого сборка идёт по приоритету: длинный
		// прайсовый сегмент выпадает, короткий призыв остаётся.
		const result = buildSeoDescription(
			['Начало', 'очень длинный средний сегмент про цены', 'Хвост'],
			30,
		);
		expect(result).toBe('Начало. Хвост.');
	});

	test('первый сегмент отдаётся даже длиннее лимита', () => {
		expect(buildSeoDescription(['Длинное название услуги'], 10)).toBe(
			'Длинное название услуги.',
		);
	});

	test('не влезающий description не собирается вообще из пустых', () => {
		expect(buildSeoDescription([null, false, '', undefined])).toBe('');
	});

	test('точка в конце сегмента не удваивается', () => {
		expect(buildSeoDescription(['Первый.', 'Второй.'])).toBe('Первый. Второй.');
	});

	test('укладывается в лимит на реальном наборе фактов', () => {
		const result = buildSeoDescription([
			'Ezofagogastroduodenoskopija sa dilatacijom — medicinska usluga u Cetinju, Nikšiću',
			'Cijena od 13 € do 70 €, u prosjeku 40 €',
			'Uporedite cijene i kontakte klinika na Docta.me',
		]);
		expect(result.length).toBeLessThanOrEqual(SEO_DESCRIPTION_MAX_LENGTH);
	});
});

test.describe('buildSeoPriceSegment', () => {
	const t = (key: string, named: Record<string, unknown>) =>
		`${key}(${Object.entries(named)
			.map(([k, v]) => `${k}=${v}`)
			.join(',')})`;
	const formatPrice = (value: number) => `${value} €`;

	test('вилка со средней', () => {
		expect(
			buildSeoPriceSegment(
				{ priceMin: 13, priceMax: 70, priceAvg: 40 },
				t,
				formatPrice,
			),
		).toBe('SeoDescPriceRangeAvg(min=13 €,max=70 €,avg=40 €)');
	});

	test('вилка без средней — средних меньше порога', () => {
		expect(
			buildSeoPriceSegment(
				{ priceMin: 13, priceMax: 70, priceAvg: null },
				t,
				formatPrice,
			),
		).toBe('SeoDescPriceRange(min=13 €,max=70 €)');
	});

	test('нет потолка — только «от», диапазон рисовать нельзя', () => {
		expect(
			buildSeoPriceSegment(
				{ priceMin: 13, priceMax: null, priceAvg: 20 },
				t,
				formatPrice,
			),
		).toBe('SeoDescPriceFromValue(min=13 €)');
	});

	test('потолок равен низу — одна цена, а не вилка', () => {
		expect(
			buildSeoPriceSegment(
				{ priceMin: 30, priceMax: 30, priceAvg: 30 },
				t,
				formatPrice,
			),
		).toBe('SeoDescPriceFromValue(min=30 €)');
	});

	test('нет фактов или нет цен — сегмента нет', () => {
		expect(buildSeoPriceSegment(null, t, formatPrice)).toBeNull();
		expect(
			buildSeoPriceSegment(
				{ priceMin: null, priceMax: null, priceAvg: null },
				t,
				formatPrice,
			),
		).toBeNull();
	});
});

test.describe('карточки сущностей используют общую обвязку', () => {
	// Цена забытой страницы — молча вернувшийся длинный title или сниппет из
	// одной строки, что в проде видно только через выгрузку Bing. Тест сторожит
	// исходники, по образцу duplicate-surface-noindex.
	const PAGES = [
		'pages/services/[serviceSlug]/index.vue',
		'pages/labtests/[labTestSlug]/index.vue',
		'pages/doctors/[doctorSlug]/index.vue',
		'pages/clinics/[clinicSlug]/index.vue',
		'pages/medications/[medicationSlug]/index.vue',
		'pages/medicines/[medicineSlug]/index.vue',
	];

	for (const page of PAGES) {
		test(`${page} собирает description через buildSeoDescription`, () => {
			expect(readFileSync(resolve(ROOT, page), 'utf-8')).toContain(
				'buildSeoDescription',
			);
		});
	}

	// У карточки лекарства из регистра заголовок это название + дозировка,
	// уложить его в лимит нечем — обрезать нельзя, отбрасывать нечего.
	for (const page of PAGES.filter((page) => !page.includes('[medicineSlug]'))) {
		test(`${page} укладывает title через fitSeoTitle`, () => {
			expect(readFileSync(resolve(ROOT, page), 'utf-8')).toContain(
				'fitSeoTitle',
			);
		});
	}
});

test('лимиты не съехали', () => {
	expect(SEO_TITLE_MAX_LENGTH).toBe(70);
	expect(SEO_DESCRIPTION_MAX_LENGTH).toBe(165);
});
