import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
	SITEMAP_LIMIT,
	SITEMAP_SECTIONS,
	chunkSitemapLinks,
	getSitemapSectionUrl,
	menuItemToLinks,
	parseSitemapSectionPath,
	renderSitemapIndex,
	renderUrlset,
	type SitemapLink,
} from '../../server/common/sitemap/utils';
import { locales, defaultLocale } from '../../composables/use-locale';

// Sitemap чинили дважды по одной причине: разметка была формально валидной, а
// сигнала не давала. Сначала все 13,6 тыс. страниц ехали одним файлом, потом
// выяснилось, что пять локалей из шести вообще не имеют собственного <loc> —
// их существование упоминалось только внутри xhtml:link.
//
// Проверять это вживую дорого (сборка ходит в БД двадцатью запросами), поэтому
// тест сторожит чистые функции сборки: они решают всё, кроме состава данных.

const SR = defaultLocale;

function countOccurrences(haystack: string, needle: string) {
	return haystack.split(needle).length - 1;
}

/** Блоки <url>…</url> из готового urlset. */
function extractUrlBlocks(xml: string) {
	return xml
		.split('<url>')
		.slice(1)
		.map((chunk) => chunk.slice(0, chunk.indexOf('</url>')));
}

test.describe('menuItemToLinks: по <loc> на каждую локаль', () => {
	test('одна страница = locales.length ссылок', () => {
		const links = menuItemToLinks('doctors');
		expect(links).toHaveLength(locales.length);
	});

	test('у каждой ссылки свой уникальный loc', () => {
		const links = menuItemToLinks('doctors', { specialtyIds: 4 });
		const locs = links.map((link) => link.loc);

		expect(new Set(locs).size).toBe(locales.length);
		for (const loc of locs) {
			expect(loc).toBeTruthy();
		}
	});

	test('в locs присутствует каждая локаль, дефолтная — без параметра lang', () => {
		const links = menuItemToLinks('doctors');
		const locs = links.map((link) => link.loc);

		for (const locale of locales) {
			const expected =
				locale === SR
					? 'https://docta.me/doctors'
					: `https://docta.me/doctors?lang=${locale}`;
			expect(locs).toContain(expected);
		}
	});

	// Форма URL дефолтной локали уже проиндексирована — если она съедет,
	// потеряется всё накопленное, а не только новые языковые версии.
	test('URL дефолтной локали не изменился', () => {
		expect(menuItemToLinks('')[0].loc).toBe('https://docta.me/');
		expect(
			menuItemToLinks('services', { serviceCategoryIds: 3, cityIds: 1 })[0].loc,
		).toBe('https://docta.me/services?serviceCategoryIds=3&cityIds=1');
	});

	test('набор альтернатив одинаков у всех языковых версий и полон', () => {
		const links = menuItemToLinks('labtests', { categoryIds: 2 });
		const reference = JSON.stringify(links[0].alternatives);

		for (const link of links) {
			expect(JSON.stringify(link.alternatives)).toBe(reference);
		}

		const hreflangs = links[0].alternatives.map((alt) => alt.hreflang);
		expect(hreflangs).toContain('x-default');
		// по одной альтернативе на локаль плюс x-default
		expect(hreflangs).toHaveLength(locales.length + 1);
		// self-ссылка обязательна: каждая версия ссылается и на себя
		const hrefs = links[0].alternatives.map((alt) => alt.href);
		for (const link of links) {
			expect(hrefs).toContain(link.loc);
		}
	});
});

test.describe('renderUrlset: у каждого <url> ровно один <loc>', () => {
	const links = [
		...menuItemToLinks('doctors'),
		...menuItemToLinks('doctors', { specialtyIds: 4, cityIds: 1 }),
	];
	const xml = renderUrlset(links);

	test('число <url> совпадает с числом ссылок', () => {
		expect(countOccurrences(xml, '<url>')).toBe(links.length);
		expect(countOccurrences(xml, '</url>')).toBe(links.length);
	});

	test('число <loc> совпадает с числом локалей на страницу', () => {
		expect(countOccurrences(xml, '<loc>')).toBe(2 * locales.length);
	});

	test('в каждом блоке ровно один непустой <loc>', () => {
		const blocks = extractUrlBlocks(xml);
		expect(blocks).toHaveLength(links.length);

		for (const block of blocks) {
			expect(countOccurrences(block, '<loc>')).toBe(1);
			const loc = block.slice(
				block.indexOf('<loc>') + '<loc>'.length,
				block.indexOf('</loc>'),
			);
			expect(loc).toMatch(/^https:\/\/docta\.me\//);
		}
	});

	test('амперсанды экранированы и в loc, и в alternate', () => {
		expect(xml).toContain('specialtyIds=4&amp;cityIds=1');
		expect(xml).not.toMatch(/&(?!amp;)/);
	});

	test('пустая секция — валидный пустой urlset', () => {
		const empty = renderUrlset([]);
		expect(empty).toContain('<urlset');
		expect(empty).toContain('</urlset>');
		expect(countOccurrences(empty, '<url>')).toBe(0);
	});
});

test.describe('chunkSitemapLinks: границы файлов', () => {
	// Ссылки одной страницы обязаны лежать в одном файле: иначе языковые
	// версии окажутся в разных sitemap-ах с разными датами обхода.
	const pages = SITEMAP_LIMIT + 3;
	const links: SitemapLink[] = [];
	for (let i = 0; i < pages; i++) {
		links.push(
			...menuItemToLinks(`${'https://docta.me/doctors/d' + i}`, {}, true),
		);
	}

	test('часть вмещает ровно SITEMAP_LIMIT страниц', () => {
		const chunks = chunkSitemapLinks(links);
		expect(chunks).toHaveLength(2);
		expect(chunks[0]).toHaveLength(SITEMAP_LIMIT * locales.length);
		expect(chunks[1]).toHaveLength(3 * locales.length);
	});

	test('ни одна часть не рвёт страницу между локалями', () => {
		for (const chunk of chunkSitemapLinks(links)) {
			expect(chunk.length % locales.length).toBe(0);
		}
	});

	test('часть не превышает лимиты спецификации', () => {
		const chunks = chunkSitemapLinks(links);
		expect(chunks[0].length).toBeLessThanOrEqual(50000);
		expect(renderUrlset(chunks[0]).length).toBeLessThan(50 * 1024 * 1024);
	});

	test('пустая секция всё равно даёт ровно один файл', () => {
		expect(chunkSitemapLinks([])).toEqual([[]]);
	});
});

test.describe('индекс перечисляет все секции', () => {
	const parts = SITEMAP_SECTIONS.map((section) => ({ section, part: 1 }));
	const xml = renderSitemapIndex(parts);

	test('в индексе столько же <sitemap>, сколько секций', () => {
		expect(countOccurrences(xml, '<sitemap>')).toBe(SITEMAP_SECTIONS.length);
		expect(countOccurrences(xml, '<loc>')).toBe(SITEMAP_SECTIONS.length);
	});

	for (const section of SITEMAP_SECTIONS) {
		test(`секция ${section} есть в индексе и её адрес разбирается обратно`, () => {
			const url = getSitemapSectionUrl(section, 1);
			expect(xml).toContain(`<loc>${url}</loc>`);

			// Имена секций содержат дефис (doctor-filters) — разбор пути обязан
			// отделять номер части, а не резать имя.
			const pathArray = new URL(url).pathname.split('/').slice(1);
			expect(parseSitemapSectionPath(pathArray)).toEqual({ section, part: 1 });
		});
	}

	test('мусорные адреса секций не принимаются', () => {
		expect(parseSitemapSectionPath(['sitemaps', 'doctors.xml'])).toBeNull();
		expect(parseSitemapSectionPath(['sitemaps', 'unknown-1.xml'])).toBeNull();
		expect(parseSitemapSectionPath(['sitemaps', 'doctors-0.xml'])).toBeNull();
		expect(parseSitemapSectionPath(['sitemaps', 'doctors-1.txt'])).toBeNull();
		expect(parseSitemapSectionPath(['sitemap.xml'])).toBeNull();
	});
});

test.describe('реестр секций не расходится со списком', () => {
	// Тип Record<SitemapSection, …> ловит это на typecheck, но typecheck
	// не гоняется в тестовом прогоне, а цена расхождения — секция, которую
	// индекс объявил, а сервер отдать не может.
	const HERE = dirname(fileURLToPath(import.meta.url));
	const source = readFileSync(
		resolve(HERE, '../../server/common/sitemap/sitemap.ts'),
		'utf-8',
	);
	const registry = source.slice(source.indexOf('const SECTION_BUILDERS'));

	for (const section of SITEMAP_SECTIONS) {
		test(`у секции ${section} есть сборщик`, () => {
			expect(registry).toMatch(
				new RegExp(`(^|[\\s{])'?${section}'?:\\s*build`, 'm'),
			);
		});
	}
});
