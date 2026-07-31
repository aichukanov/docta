export const SITEMAP_LIMIT = 1000;

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

export function sendSitemap(event: any, content: string) {
	event.node.res.setHeader('Content-Type', 'application/xml');
	event.node.res.end(content);
}
