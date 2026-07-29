import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { ARTICLE_SLUGS } from '../../common/articles';

// ARTICLE_SLUGS кормит sitemap. Раньше этот список был захардкожен в
// sitemap.ts двумя слагами при 17 статьях, и расхождение ничем не проявлялось:
// в индексе Яндекса оказались ровно те две статьи, что попали в sitemap.
// Тест делает расхождение громким — с любой стороны.
// См. prd/silent-200-index-hygiene, итерация 2.

const HERE = dirname(fileURLToPath(import.meta.url));
const ARTICLES_DIR = resolve(HERE, '../../pages/articles');

function slugsFromPages(): string[] {
	return readdirSync(ARTICLES_DIR)
		.filter((f) => f.endsWith('.vue') && f !== 'index.vue')
		.map((f) => f.replace(/\.vue$/, ''))
		.sort();
}

test.describe('ARTICLE_SLUGS', () => {
	test('совпадает с файлами pages/articles/*.vue', () => {
		expect([...ARTICLE_SLUGS].sort()).toEqual(slugsFromPages());
	});

	test('не содержит дублей', () => {
		expect(new Set(ARTICLE_SLUGS).size).toBe(ARTICLE_SLUGS.length);
	});

	test('каждая статья есть в списке на /articles', () => {
		// Слаги городских статей на листинге собираются в цикле по массиву
		// городов (`/articles/healthcare-in-${city}`), поэтому ищем и явные
		// пути, и элементы такого массива.
		const listing = readFileSync(resolve(ARTICLES_DIR, 'index.vue'), 'utf-8');

		const missing = ARTICLE_SLUGS.filter((slug) => {
			if (listing.includes(`/articles/${slug}`)) return false;
			const city = slug.replace(/^healthcare-in-/, '');
			return !(city !== slug && listing.includes(`'${city}'`));
		});

		expect(missing).toEqual([]);
	});
});
