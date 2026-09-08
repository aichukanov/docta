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
import articleTitleI18n from '../../i18n/article-title';
import articleDescriptionI18n from '../../i18n/article-description';

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
	// общие в i18n/articles.ts, у отдельных статей — свои файлы. Выжимку из
	// них подмешивает components/global-search.vue (i18n/article-title.ts);
	// если она разойдётся с этим списком, t() вернёт сам ключ, и в выдаче
	// будет «AlgTitle».
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

// i18n/article-title.ts — выжимка заголовков для глобального поиска. Она
// существует только ради веса: раньше поиск ради восемнадцати строк тянул в
// первый экран главной пять словарей статей целиком (347 КБ raw / 102 КБ gzip
// текстов на шести локалях). Цена выжимки — второй экземпляр строк, а второго
// названия у статьи быть не должно (см. i18n/article-search.ts), поэтому
// расхождение обязано падать тестом, а не всплывать в выдаче.
test.describe('i18n/article-title', () => {
	const titles = articleTitleI18n.messages as Record<
		string,
		Record<string, string>
	>;

	const TITLE_DICTS = [
		articlesI18n,
		articleUnavailableI18n,
		articleAllergyI18n,
		articleCityHealthcareI18n,
		articleWeekendI18n,
	];

	function canonicalTitle(locale: string, key: string): string | undefined {
		for (const dict of TITLE_DICTS) {
			const messages = dict.messages as Record<string, Record<string, string>>;
			const value = messages[locale]?.[key];
			if (value) return value;
		}
		return undefined;
	}

	test('содержит ровно те же локали, что и приложение', () => {
		expect(Object.keys(titles).sort()).toEqual([...locales].sort());
	});

	test('дословно совпадает с заголовками из словарей статей', () => {
		const problems: string[] = [];
		for (const locale of locales) {
			for (const { titleKey } of ARTICLE_SEARCH) {
				const expected = canonicalTitle(locale, titleKey);
				const actual = titles[locale]?.[titleKey];
				if (actual !== expected) {
					problems.push(
						`${locale}/${titleKey}: «${actual}» вместо «${expected}»`,
					);
				}
			}
		}
		expect(problems).toEqual([]);
	});

	// Лишний ключ означает, что в выжимку затёк кусок словаря статьи: она
	// уедет на главную, и вся экономия схлопнется.
	test('не содержит ничего, кроме заголовков из ARTICLE_SEARCH', () => {
		const allowed = new Set(ARTICLE_SEARCH.map((entry) => entry.titleKey));
		const extra: string[] = [];
		for (const locale of Object.keys(titles)) {
			for (const key of Object.keys(titles[locale])) {
				if (!allowed.has(key)) extra.push(`${locale}/${key}`);
			}
		}
		expect(extra).toEqual([]);
	});
});

// i18n/article-description.ts — парная выжимка описаний для листинга
// /articles. Причина та же, что у заголовков: страница печатает у каждой
// карточки заголовок и описание, а импортировала ради этого пять словарей
// целиком — 371 КБ исходников против 31 КБ выжимки. И риск тот же: второго
// описания у статьи быть не должно, поэтому расхождение обязано падать здесь,
// а не всплывать в мете и в выдаче.
test.describe('i18n/article-description', () => {
	const descriptions = articleDescriptionI18n.messages as Record<
		string,
		Record<string, string>
	>;

	// Порядок как в генераторе: при совпадении ключа выигрывает последний.
	const SOURCE_DICTS = [
		articlesI18n,
		articleCityHealthcareI18n,
		articleWeekendI18n,
		articleUnavailableI18n,
		articleAllergyI18n,
	];

	function canonical(locale: string, key: string): string | undefined {
		let found: string | undefined;
		for (const dict of SOURCE_DICTS) {
			const messages = dict.messages as Record<string, Record<string, string>>;
			const value = messages[locale]?.[key];
			if (value) found = value;
		}
		return found;
	}

	test('содержит ровно те же локали, что и приложение', () => {
		expect(Object.keys(descriptions).sort()).toEqual([...locales].sort());
	});

	test('дословно совпадает с описаниями из словарей статей', () => {
		const problems: string[] = [];
		for (const locale of locales) {
			for (const key of Object.keys(descriptions[locale] ?? {})) {
				const expected = canonical(locale, key);
				// Ключи, которых нет в этих пяти словарях, живут в словарях
				// отдельных статей (стоматология, роды, ментальное здоровье) —
				// их сверяет проверка ниже, здесь пропускаем.
				if (expected === undefined) continue;
				if (descriptions[locale][key] !== expected) {
					problems.push(
						`${locale}/${key}: «${descriptions[locale][key]}» вместо «${expected}»`,
					);
				}
			}
		}
		expect(problems).toEqual([]);
	});

	test('содержит только описания и две строки самого листинга', () => {
		const extra: string[] = [];
		for (const locale of Object.keys(descriptions)) {
			for (const key of Object.keys(descriptions[locale])) {
				const isDescription = key.endsWith('Description');
				const isCityDescription = key.startsWith('CityHcDescription_');
				const isPageOwn = key === 'Articles';
				if (!isDescription && !isCityDescription && !isPageOwn) {
					extra.push(`${locale}/${key}`);
				}
			}
		}
		expect(extra).toEqual([]);
	});

	test('непустые значения во всех локалях', () => {
		const empty: string[] = [];
		for (const locale of locales) {
			for (const [key, value] of Object.entries(descriptions[locale] ?? {})) {
				if (!value?.trim()) empty.push(`${locale}/${key}`);
			}
		}
		expect(empty).toEqual([]);
	});
});
