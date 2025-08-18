import { SitemapLink } from './utils';
import { SITEMAP_LIMIT } from '../limits';
import { locales } from '~/composables/use-locale';
import { getRegionalUrl } from '~/common/url-utils';

export function menuItemToLinks(
	routeName: string,
	d?: number,
	brandId?: number,
	id?: string,
) {
	const url = 'https://docta.me/' + routeName.replaceAll('-', '/');

	// const defaultLink = {
	// 	hreflang: 'x-default',
	// 	href: `${url}${brandId ? `?brand=${brandId}` : ''}`,
	// };

	const query: Record<string, string | string[]> = {};
	if (brandId) {
		query.brandId = brandId.toString();
	}

	const linksWithParams: Array<{ hreflang: string; href: string }> = [];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];
		if (lang === 'me') {
			continue;
		}

		linksWithParams.push({
			hreflang: `${lang}-ME`,
			href: getRegionalUrl(url, query, lang),
		});
	}

	const loc = getRegionalUrl(url, query, 'sr');

	return {
		loc,
		lastmod: d ? new Date(d) : new Date(),
		changefreq: 'daily',
		alternatives: linksWithParams,
		id,
	};
}

async function getArticlesList(skip: number, limit: number) {
	return [];
	// const articles = await runSelect(`
	// 	SELECT article_list.id AS id, category_id, MAX(article_prices.updated_date) as lastmod
	// 	FROM article_list
	// 		INNER JOIN article_prices ON article_list.id = article_prices.article_id
	// 		INNER JOIN shops ON article_prices.shop_id = shops.id
	// 	WHERE
	// 		article_list.category_id IN (${getAvailableCategories()})
	// 	GROUP BY article_list.id
	// 	LIMIT ${limit}
	// 	OFFSET ${skip};
	// `);

	// return articles.map((article) => {
	// 	const menuPath =
	// 		categoryLinksMap[article.category_id as ArticleCategory] ||
	// 		'other-other-other';

	// 	return menuItemToLinks(
	// 		`${menuPath}-${article.id}`,
	// 		article.lastmod,
	// 		undefined,
	// 		article.id,
	// 	);
	// });
}

export async function generateSitemapPage(sitemapIndex: number) {
	let menuLinks: SitemapLink[] = await getArticlesList(
		SITEMAP_LIMIT * (sitemapIndex - 1),
		SITEMAP_LIMIT,
	);

	return await generateSitemap(menuLinks);
}

async function generateSitemap(routes: SitemapLink[]) {
	const header = `<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="/__sitemap__/style.xsl"?>
<urlset
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
	xmlns:xhtml="http://www.w3.org/1999/xhtml">`;
	const footer = `</urlset>`;

	async function getImageLinks(_id: string | undefined) {
		return '';
		// if (!id) {
		// 	return '';
		// }

		// const imgs = await getArticleImages(id, 'orig');
		// return imgs
		// 	.map(
		// 		(img: string) => `
		// <image:image>
		// 	<image:loc>${img}</image:loc>
		// </image:image>`,
		// 	)
		// 	.join('');
	}

	function getAltLink({ hreflang, href }: { hreflang: string; href: string }) {
		return `
		<xhtml:link rel="alternate" hreflang="${hreflang}" href="${href.replaceAll(
			'&',
			'&amp;',
		)}" />`;
	}

	async function getUrlData(route: SitemapLink) {
		const imgLinks = await getImageLinks(route.id);

		return `	<url>
		<loc>${route.loc.replaceAll('&', '&amp;')}</loc>
		${imgLinks}
		<lastmod>${route.lastmod.toISOString()}</lastmod>
		<changefreq>${route.changefreq}</changefreq>
		${route.alternatives.map((alt) => getAltLink(alt)).join('')}
	</url>`;
	}

	const urls = [];
	for (let i = 0; i < routes.length; i++) {
		urls.push(await getUrlData(routes[i]));
	}

	return `${header}
${urls.join('\n')}
${footer}`;
}
