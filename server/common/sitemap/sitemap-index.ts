import { SITEMAP_LIMIT } from '../limits';
import { runSelect } from '../db';
import { getAvailableCategories } from './utils';

async function getArticleCount() {
	const articles = await runSelect(`
		SELECT article_list.id, category_id
		FROM article_list
			INNER JOIN article_prices ON article_list.id = article_prices.article_id
			INNER JOIN shops ON article_prices.shop_id = shops.id
		WHERE 
			article_list.category_id IN (${getAvailableCategories()})
		GROUP BY article_list.id;
	`);

	return articles.length;
}

export async function generateSitemapIndex() {
	const articleCount = await getArticleCount();
	const sitemapCount = Math.ceil(articleCount / SITEMAP_LIMIT);

	const sitemapContent = [];
	for (let i = 0; i <= sitemapCount; i++) {
		sitemapContent.push(
			`	<sitemap>
		<loc>https://docta.me/sitemap${i}.xml</loc>
		<lastmod>${new Date().toISOString()}</lastmod>
	</sitemap>`,
		);
	}

	return `<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="/__sitemap__/style.xsl"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${sitemapContent.join('\n')}
</sitemapindex>`;
}
