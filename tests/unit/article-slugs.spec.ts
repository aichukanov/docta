import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { ARTICLE_SEARCH, ARTICLE_SLUGS } from '../../common/articles';
import { locales } from '../../composables/use-locale';
import articlesI18n from '../../i18n/articles';
import articleUnavailableI18n from '../../i18n/article-medications-unavailable';
import articleAllergyI18n from '../../i18n/article-allergy-medicines';
import articleCityHealthcareI18n from '../../i18n/article-city-healthcare';
import articleWeekendI18n from '../../i18n/article-weekend-medical-help';

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

// ARTICLE_SEARCH кормит группу «Статьи» в глобальном поиске. Разойтись он
// может так же молча, как когда-то ARTICLE_SLUGS с sitemap: добавил статью —
// она просто не находится, и узнать об этом можно только случайно.
test.describe('ARTICLE_SEARCH', () => {
	test('покрывает все статьи из ARTICLE_SLUGS', () => {
		const searched = ARTICLE_SEARCH.map((entry) => entry.slug).sort();
		expect(searched).toEqual([...ARTICLE_SLUGS].sort());
	});

	test('не содержит дублей слагов и ключей заголовков', () => {
		const slugs = ARTICLE_SEARCH.map((entry) => entry.slug);
		const titleKeys = ARTICLE_SEARCH.map((entry) => entry.titleKey);
		expect(new Set(slugs).size).toBe(slugs.length);
		expect(new Set(titleKeys).size).toBe(titleKeys.length);
	});

	// Поиск печатает заголовок статьи, а заголовки разбросаны по словарям:
	// общие в i18n/articles.ts, у отдельных статей — свои файлы. Тот же набор
	// подмешивает components/global-search.vue; если он разойдётся с этим
	// списком, t() вернёт сам ключ, и в выдаче будет «AlgTitle».
	const TITLE_DICTS = [
		articlesI18n,
		articleUnavailableI18n,
		articleAllergyI18n,
		articleCityHealthcareI18n,
		articleWeekendI18n,
	];

	test('у каждой статьи есть заголовок во всех локалях', () => {
		const missing: string[] = [];
		for (const locale of locales) {
			for (const { titleKey } of ARTICLE_SEARCH) {
				const found = TITLE_DICTS.some((dict) => {
					const messages = dict.messages as Record<
						string,
						Record<string, string>
					>;
					return Boolean(messages[locale]?.[titleKey]);
				});
				if (!found) missing.push(`${locale}/${titleKey}`);
			}
		}
		expect(missing).toEqual([]);
	});

	test('ключевые слова непустые и без повторов внутри статьи', () => {
		const problems: string[] = [];
		for (const { slug, keywords } of ARTICLE_SEARCH) {
			if (!keywords.length) problems.push(`${slug}: пустой список`);
			const normalized = keywords.map((word) => word.trim().toLowerCase());
			if (new Set(normalized).size !== normalized.length) {
				problems.push(`${slug}: повторы`);
			}
			if (normalized.some((word) => word.length < 3)) {
				// Короткое слово матчится подстрокой почти на всё и выносит
				// статью в выдачу по любому запросу. Исключение — «124»,
				// номер скорой: его ищут именно так.
				const short = normalized.filter(
					(word) => word.length < 3 && word !== '124',
				);
				if (short.length) problems.push(`${slug}: слишком коротко ${short}`);
			}
		}
		expect(problems).toEqual([]);
	});
});
