import { test, expect } from '@playwright/test';
import {
	buildMedicalTestSchema,
	buildDrugSchema,
	buildMedicalProcedureSchema,
} from '../../common/schema-org-builders';
import type { ClinicData, ClinicPrice } from '../../interfaces/clinic';

// Пункт 11 в docs/audit/seo-2026-07.md.
//
// Google требует у `Product` хотя бы одно из offers/review/aggregateRating.
// Карточка без цен отдавала пустой `Product` — 758 недопустимых элементов в
// GSC, и такие страницы выпадали из расширенного сниппета «Описания товара»
// (1384 показа за 3 месяца). Гард держит инвариант в обе стороны: нет offers —
// нет `Product`; есть offers — `Product` обязан остаться, иначе мы молча
// потеряем работающий сниппет на страницах с ценами.

const SITE = 'https://docta.me';
const getCityName = () => 'Podgorica';

const clinics: ClinicData[] = [
	{ id: 1, slug: 'test-clinic', name: 'Test Clinic' } as ClinicData,
];
const withPrice: ClinicPrice[] = [{ clinicId: 1, price: 30 }];
const noPrice: ClinicPrice[] = [{ clinicId: 1, price: null }];

const common = {
	siteUrl: SITE,
	id: 1,
	slug: 'test-slug',
	name: 'Test',
	locale: 'sr',
	pageTitle: 'Test',
	getCityName,
};

const builders = [
	{ name: 'MedicalTest', build: buildMedicalTestSchema },
	{ name: 'Drug', build: buildDrugSchema },
	{ name: 'MedicalProcedure', build: buildMedicalProcedureSchema },
] as const;

function entitySchema(result: any[]): any {
	// [webPageSchema, entitySchema]
	return result[result.length - 1];
}

for (const { name, build } of builders) {
	test.describe(`${name} + Product`, () => {
		test('с ценами: Product на месте и у него есть offers', () => {
			const schema = entitySchema(
				build({ ...common, clinics, clinicPrices: withPrice } as any),
			);
			expect(schema['@type']).toEqual([name, 'Product']);
			expect(schema.offers).toBeTruthy();
			expect(schema.offers['@type']).toBe('AggregateOffer');
		});

		test('без цен: Product не объявляется', () => {
			const schema = entitySchema(
				build({ ...common, clinics, clinicPrices: noPrice } as any),
			);
			expect(schema['@type']).toBe(name);
			expect(schema.offers).toBeUndefined();
		});

		test('вообще без клиник: Product не объявляется', () => {
			const schema = entitySchema(build({ ...common } as any));
			expect(schema['@type']).toBe(name);
			expect(schema.offers).toBeUndefined();
		});

		test('нулевая цена ценой не считается', () => {
			const schema = entitySchema(
				build({
					...common,
					clinics,
					clinicPrices: [{ clinicId: 1, price: 0 }],
				} as any),
			);
			expect(schema['@type']).toBe(name);
		});

		test('остальная разметка не зависит от наличия Product', () => {
			const withOffers = entitySchema(
				build({ ...common, clinics, clinicPrices: withPrice } as any),
			);
			const without = entitySchema(build({ ...common } as any));
			expect(without['@id']).toBe(withOffers['@id']);
			expect(without.url).toBe(withOffers.url);
			expect(without.name).toBe(withOffers.name);
		});
	});
}
