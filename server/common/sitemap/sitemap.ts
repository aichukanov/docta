import { SitemapLink } from './utils';
import { SITEMAP_LIMIT } from './utils';
import { locales } from '~/composables/use-locale';
import { getRegionalUrl } from '~/common/url-utils';
import { getDoctorList } from '~/server/api/doctors/list';
import { DoctorSpecialty } from '~/enums/specialty';

export function menuItemToLinks(
	routeName: string,
	query: Record<string, string | string[]> = {},
) {
	const url = 'https://docta.me/' + routeName.replaceAll('-', '/');

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
		lastmod: new Date(),
		changefreq: 'daily',
		alternatives: linksWithParams,
	};
}

export async function generateSitemapPage(sitemapIndex: number) {
	const { doctors } = await getDoctorList();

	const doctorLinks: SitemapLink[] = doctors.map((doctor) =>
		menuItemToLinks(`doctors-${doctor.id}`),
	);

	const specialtyLinks: SitemapLink[] = Object.values(DoctorSpecialty)
		.map((specialty) => {
			if (Number.isNaN(Number(specialty))) {
				return null;
			}

			return menuItemToLinks(`doctors`, { specialtyIds: specialty });
		})
		.filter(Boolean);

	return await generateSitemap([...doctorLinks, ...specialtyLinks]);
}

async function generateSitemap(routes: SitemapLink[]) {
	const header = `<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="/__sitemap__/style.xsl"?>
<urlset
	xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
	xmlns:xhtml="http://www.w3.org/1999/xhtml">`;
	const footer = `</urlset>`;

	function getAltLink({ hreflang, href }: { hreflang: string; href: string }) {
		return `
		<xhtml:link rel="alternate" hreflang="${hreflang}" href="${href.replaceAll(
			'&',
			'&amp;',
		)}" />`;
	}

	async function getUrlData(route: SitemapLink) {
		return `	<url>
		<loc>${route.loc.replaceAll('&', '&amp;')}</loc>
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
