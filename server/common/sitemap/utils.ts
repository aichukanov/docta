export interface SitemapLink {
	loc: string;
	lastmod: Date;
	changefreq: string;
	alternatives: Array<{ hreflang: string; href: string }>;
	id?: string;
}

export function sendSitemap(event: any, content: string) {
	event.node.res.setHeader('Content-Type', 'application/xml');
	event.node.res.end(content);
}
