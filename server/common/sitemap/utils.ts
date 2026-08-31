import { SITE_URL } from '~/common/constants';
import { getRegionalUrl, type UrlQuery } from '~/common/url-utils';
import { getHreflangTag, locales } from '~/composables/use-locale';

/**
 * Максимум СТРАНИЦ (не тегов `<url>`) в одном файле секции.
 *
 * Считаем именно страницы, потому что одна страница разворачивается в
 * `locales.length` блоков `<url>` — по одному на языковую версию. При шести
 * локалях тысяча страниц даёт 6000 `<url>` и ~6 МБ: с большим запасом под оба
 * лимита спецификации (50 000 URL и 50 МБ несжатого файла), так что добавление
 * седьмой локали не потребует пересчёта константы.
 */
export const SITEMAP_LIMIT = 1000;

/**
 * Секции sitemap-индекса.
 *
 * Разбиение по ТИПУ СУЩНОСТИ, а внутри типа — отдельно карточки и отдельно
 * фасетные URL (`*-filters`). Причина не в лимитах (по ним хватило бы и деления
 * подряд), а в диагностике: Search Console показывает покрытие на файл, и
 * «проиндексировано 40% фасетов услуг» — это ответ, а «проиндексировано 40%
 * части №7» — нет. Карточки и фасеты живут по разным правилам (у фасета есть
 * порог непустоты, у карточки нет), поэтому и смотреть на них надо порознь.
 *
 * Порядок фиксирован: он определяет порядок записей в индексе, а стабильный
 * индекс легче сравнивать между выкладками.
 */
export const SITEMAP_SECTIONS = [
	'core',
	'doctors',
	'doctor-filters',
	'clinics',
	'clinic-filters',
	'services',
	'service-filters',
	'labtests',
	'labtest-filters',
	'medicines',
	'medicine-filters',
	'medications',
] as const;

export type SitemapSection = (typeof SITEMAP_SECTIONS)[number];

/** Каталог, в котором живут файлы секций: `/sitemaps/<section>-<part>.xml`. */
const SITEMAP_SECTION_DIR = 'sitemaps';

export interface SitemapLink {
	loc: string;
	/**
	 * Опционально и сейчас НИКЕМ не заполняется — тег `<lastmod>` не выводится.
	 *
	 * Раньше здесь стоял `new Date()` на каждую ссылку, то есть все 13 638 URL
	 * заявляли, что изменились в момент запроса sitemap (13 638 тегов, 65
	 * уникальных значений — дрейф миллисекунд при сборке файла). Это хуже, чем
	 * отсутствие `lastmod`: поисковик доверяет ему только если он стабильно
	 * правдив, а сайт, у которого всё всегда «изменилось сейчас», выключает себе
	 * этот сигнал целиком. А для Google это единственный рычаг переобхода —
	 * IndexNow он не поддерживает.
	 *
	 * Заполнять только настоящим временем изменения сущности (`updated_at`, а
	 * для фасетных URL — максимум по участникам). До тех пор поле пустое, и это
	 * осознанно: по спецификации `lastmod` необязателен.
	 */
	lastmod?: Date;
	changefreq: string;
	alternatives: Array<{ hreflang: string; href: string }>;
	id?: string;
}

/**
 * Одна страница сайта → по одному `SitemapLink` на КАЖДУЮ локаль.
 *
 * Раньше функция возвращала ровно один элемент: `<loc>` собирался для `sr`, а
 * остальные пять локалей и `x-default` упоминались только внутри `xhtml:link`.
 * Google это трактует буквально — в sitemap перечислена одна страница, у
 * которой есть переводы; прямого сигнала «обойди `?lang=ru`» нет ни одного.
 * Документация требует отдельный блок `<url>` на каждую языковую версию, и у
 * каждого — ОДИН И ТОТ ЖЕ полный набор альтернатив (включая ссылку на самого
 * себя). Отсюда общий `linksWithParams` на все элементы результата.
 *
 * Порядок совпадает с `locales`, то есть первым идёт `sr` — URL дефолтной
 * локали собирается без параметра `lang` и потому побайтово совпадает с тем,
 * что было в sitemap раньше. Уже проиндексированные адреса не съезжают.
 */
export function menuItemToLinks(
	routeName: string,
	query: UrlQuery = {},
	isUrl = false,
): SitemapLink[] {
	const url = isUrl
		? routeName
		: SITE_URL + '/' + routeName.replaceAll('-', '/');

	const linksWithParams: Array<{ hreflang: string; href: string }> = [];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];

		linksWithParams.push({
			hreflang: getHreflangTag(lang),
			href: getRegionalUrl(url, query, lang),
		});
	}

	linksWithParams.push({
		hreflang: 'x-default',
		href: getRegionalUrl(url, query, 'en'),
	});

	return locales.map((lang) => ({
		loc: getRegionalUrl(url, query, lang),
		// lastmod сознательно не заполняем — см. SitemapLink выше
		changefreq: 'weekly',
		alternatives: linksWithParams,
	}));
}

/** Нарезка секции на файлы по `SITEMAP_LIMIT` страниц. */
export function chunkSitemapLinks(
	links: SitemapLink[],
	pagesPerChunk = SITEMAP_LIMIT,
): SitemapLink[][] {
	// Ссылки приходят сгруппированными по странице (menuItemToLinks отдаёт
	// подряд все локали одной страницы), поэтому режем по границе группы:
	// иначе языковые версии одной страницы разъехались бы по разным файлам.
	const linksPerChunk = pagesPerChunk * locales.length;
	const chunks: SitemapLink[][] = [];

	for (let i = 0; i < links.length; i += linksPerChunk) {
		chunks.push(links.slice(i, i + linksPerChunk));
	}

	// Секция без ссылок всё равно должна иметь ровно один файл: адрес секции
	// обязан быть предсказуемым и не появляться/исчезать вслед за данными —
	// иначе Search Console копит «удалённые» sitemap-ы.
	return chunks.length > 0 ? chunks : [[]];
}

/** Публичный адрес файла секции. */
export function getSitemapSectionUrl(
	section: SitemapSection,
	part: number,
): string {
	return `${SITE_URL}/${SITEMAP_SECTION_DIR}/${section}-${part}.xml`;
}

/**
 * Разбор пути `/sitemaps/<section>-<part>.xml`.
 *
 * Имена секций сами содержат дефис (`doctor-filters`), поэтому номер части
 * отделяем жадным разбором: всё до последнего дефиса — имя, после — число.
 * Возвращает null на любом непонятном пути, чтобы middleware отдал такой
 * адрес обычному 404, а не пустому sitemap с кодом 200.
 */
export function parseSitemapSectionPath(
	pathArray: string[],
): { section: SitemapSection; part: number } | null {
	if (pathArray.length !== 2 || pathArray[0] !== SITEMAP_SECTION_DIR) {
		return null;
	}

	const match = /^(.+)-(\d+)\.xml$/.exec(pathArray[1]);
	if (!match) {
		return null;
	}

	const section = match[1] as SitemapSection;
	if (!(SITEMAP_SECTIONS as readonly string[]).includes(section)) {
		return null;
	}

	const part = Number(match[2]);
	if (!Number.isInteger(part) || part < 1) {
		return null;
	}

	return { section, part };
}

function escapeXmlUrl(url: string) {
	return url.replaceAll('&', '&amp;');
}

const XML_DECLARATION = `<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="/__sitemap__/style.xsl"?>`;

/** `<urlset>` одного файла секции. */
export function renderUrlset(routes: SitemapLink[]): string {
	const header = `${XML_DECLARATION}
<urlset
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
	xmlns:xhtml="http://www.w3.org/1999/xhtml">`;
	const footer = `</urlset>`;

	function getAltLink({ hreflang, href }: { hreflang: string; href: string }) {
		return `
		<xhtml:link rel="alternate" hreflang="${hreflang}" href="${escapeXmlUrl(
			href,
		)}" />`;
	}

	function getUrlData(route: SitemapLink) {
		// lastmod выводим только если он реально известен: заведомо ложный
		// (время генерации файла) хуже отсутствующего — см. SitemapLink.
		const lastmod = route.lastmod
			? `\n\t\t<lastmod>${route.lastmod.toISOString()}</lastmod>`
			: '';

		return `	<url>
		<loc>${escapeXmlUrl(route.loc)}</loc>${lastmod}
		<changefreq>${route.changefreq}</changefreq>
		${route.alternatives.map((alt) => getAltLink(alt)).join('')}
	</url>`;
	}

	return `${header}
${routes.map(getUrlData).join('\n')}
${footer}`;
}

/** `<sitemapindex>` — содержимое `/sitemap.xml`. */
export function renderSitemapIndex(
	parts: Array<{ section: SitemapSection; part: number }>,
): string {
	const header = `${XML_DECLARATION}
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">`;
	const footer = `</sitemapindex>`;

	const entries = parts.map(
		({ section, part }) => `	<sitemap>
		<loc>${escapeXmlUrl(getSitemapSectionUrl(section, part))}</loc>
	</sitemap>`,
	);

	return `${header}
${entries.join('\n')}
${footer}`;
}

export function sendSitemap(event: any, content: string) {
	event.node.res.setHeader('Content-Type', 'application/xml');
	// Без этого заголовка Cloudflare отдаёт XML как DYNAMIC, то есть каждый
	// заход бота доходил до origin. Час согласован с TTL кэша сборки.
	event.node.res.setHeader('Cache-Control', 'public, max-age=3600');
	event.node.res.end(content);
}
