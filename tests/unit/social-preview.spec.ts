import { test, expect } from '@playwright/test';
import { existsSync, readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
	OG_IMAGE,
	OG_IMAGE_HEIGHT,
	OG_IMAGE_WIDTH,
} from '../../common/constants';
import {
	buildClinicSchema,
	buildDoctorSchema,
	buildSchemaReviews,
} from '../../common/schema-org-builders';
import type { ClinicData } from '../../interfaces/clinic';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '../..');

// Facebook и LinkedIn отбрасывают картинки меньше 200×200 и рендерят превью
// вообще без картинки. Дефолтом стоял /apple-touch-icon.png (180×180) — то
// есть все листинги и все карточки уходили в Telegram-промо без превью.
test.describe('дефолтная og:image', () => {
	test('не иконка 180×180, а отдельный роут', () => {
		expect(OG_IMAGE).not.toContain('apple-touch-icon');
		expect(OG_IMAGE).toContain('/api/og/');
	});

	test('роут, на который ссылается константа, существует', () => {
		expect(existsSync(resolve(ROOT, 'server/api/og/default.jpg.get.ts'))).toBe(
			true,
		);
	});

	test('размеры — рекомендованные 1200×630 и заведомо больше минимума соцсетей', () => {
		expect(OG_IMAGE_WIDTH).toBe(1200);
		expect(OG_IMAGE_HEIGHT).toBe(630);
		expect(OG_IMAGE_WIDTH).toBeGreaterThanOrEqual(200);
		expect(OG_IMAGE_HEIGHT).toBeGreaterThanOrEqual(200);
	});
});

// `author` и `reviewRating` у Google обязательные. Раньше оба ставились
// условно, и отзыв без имени автора или без оценки уезжал в разметку огрызком
// с undefined, делая элемент невалидным.
const own = (extra: Record<string, unknown> = {}) => ({
	id: 1,
	text: 'Отличный приём',
	rating: 5,
	author: { name: 'Ivan' },
	publishedAt: '2026-01-01',
	provider: 'docta_me',
	...extra,
});

test.describe('buildSchemaReviews', () => {
	test('валидный собственный отзыв проходит целиком', () => {
		const result = buildSchemaReviews([own()]);
		expect(result).toHaveLength(1);
		expect(result![0].author.name).toBe('Ivan');
		expect(result![0].reviewRating.ratingValue).toBe(5);
		expect(result![0].reviewBody).toBe('Отличный приём');
	});

	test('отзыв без автора выбрасывается целиком, а не отдаётся без author', () => {
		expect(buildSchemaReviews([own({ author: undefined })])).toBeUndefined();
	});

	test('отзыв без оценки выбрасывается целиком', () => {
		expect(buildSchemaReviews([own({ rating: undefined })])).toBeUndefined();
	});

	test('отзыв без текста выбрасывается', () => {
		expect(buildSchemaReviews([own({ text: '' })])).toBeUndefined();
	});

	test('сторонние отзывы в разметку не попадают', () => {
		expect(
			buildSchemaReviews([own({ provider: 'google_maps' })]),
		).toBeUndefined();
	});

	test('пусто — это undefined, а не пустой массив (пустой review невалиден)', () => {
		expect(buildSchemaReviews([])).toBeUndefined();
		expect(buildSchemaReviews(undefined)).toBeUndefined();
	});
});

test.describe('невалидные отзывы не доезжают до разметки сущностей', () => {
	const reviews = [own(), own({ id: 2, author: undefined })];

	test('в схеме врача остаётся только валидный отзыв', () => {
		const [, doctor] = buildDoctorSchema({
			siteUrl: 'https://docta.me',
			id: 1,
			slug: 'test-doctor',
			name: 'Dr Test',
			locale: 'ru',
			reviews,
			getSpecialtyName: () => undefined,
			getCityName: () => undefined,
		}) as [unknown, Record<string, any>];

		expect(doctor.review).toHaveLength(1);
		expect(doctor.review[0].author).toBeTruthy();
		expect(doctor.review[0].reviewRating).toBeTruthy();
	});

	test('в схеме клиники остаётся только валидный отзыв', () => {
		const [, clinic] = buildClinicSchema({
			siteUrl: 'https://docta.me',
			clinic: { id: 1, slug: 'test-clinic', name: 'Test' } as ClinicData,
			locale: 'ru',
			getCityName: () => undefined,
			reviews,
		}) as [unknown, Record<string, any>];

		expect(clinic.review).toHaveLength(1);
		expect(clinic.review[0].author).toBeTruthy();
		expect(clinic.review[0].reviewRating).toBeTruthy();
	});
});

// Цель редиректа подстраницы обязана нести локаль: без `lang` русская версия
// 301-редиректилась на сербскую версию родителя, а редирект на другую локаль
// Google считает дефектом hreflang-кластера.
test.describe('редиректы подстраниц не теряют язык', () => {
	const pages = [
		'pages/clinics/[clinicSlug]/services/index.vue',
		'pages/clinics/[clinicSlug]/labtests/index.vue',
		'pages/clinics/[clinicSlug]/medications/index.vue',
		'pages/clinics/[clinicSlug]/doctors/index.vue',
		'pages/clinics/[clinicSlug]/reviews/index.vue',
		'pages/doctors/[doctorSlug]/reviews/index.vue',
	];

	for (const page of pages) {
		test(`${page} собирает цель через getRegionalUrl`, () => {
			const source = readFileSync(resolve(ROOT, page), 'utf8');

			// Ни одного navigateTo со склеенным вручную путём
			expect(source).not.toMatch(/navigateTo\(\s*`\//);
			expect(source).toContain('getRegionalUrl');
		});
	}
});
