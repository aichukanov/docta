import { SitemapLink } from './utils';
import { SITEMAP_LIMIT } from './utils';
import { locales } from '~/composables/use-locale';
import { getRegionalUrl } from '~/common/url-utils';
import { getDoctorList } from '~/server/api/doctors/list';
import { DoctorSpecialty } from '~/enums/specialty';
import { CityId } from '~/enums/cities';
import { LanguageId } from '~/enums/language';

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

function getEnumValues(enumType: any) {
	return Object.values(enumType).filter(
		(value) => !Number.isNaN(Number(value)),
	);
}

export async function generateSitemapPage(sitemapIndex: number) {
	const { doctors } = await getDoctorList();

	const doctorLinks: SitemapLink[] = doctors.map((doctor) =>
		menuItemToLinks(`doctors-${doctor.id}`),
	);

	const specialtyIds = getEnumValues(DoctorSpecialty);
	const cityIds = getEnumValues(CityId);
	const languageIds = getEnumValues(LanguageId);

	const specialtyLinks: SitemapLink[] = specialtyIds.map((specialty) =>
		menuItemToLinks(`doctors`, { specialtyIds: specialty }),
	);

	const cityLinks: SitemapLink[] = cityIds.map((city) =>
		menuItemToLinks(`doctors`, { cityIds: city }),
	);

	const languageLinks: SitemapLink[] = languageIds.map((language) =>
		menuItemToLinks(`doctors`, { languageIds: language }),
	);

	const specialtyCityLinks: SitemapLink[] = specialtyIds.flatMap((specialty) =>
		cityIds.map((city) =>
			menuItemToLinks(`doctors`, { specialtyIds: specialty, cityIds: city }),
		),
	);

	const specialtyLanguageLinks: SitemapLink[] = specialtyIds.flatMap(
		(specialty) =>
			languageIds.map((language) =>
				menuItemToLinks(`doctors`, {
					specialtyIds: specialty,
					languageIds: language,
				}),
			),
	);

	const specialtyLanguageCityLinks: SitemapLink[] = specialtyIds.flatMap(
		(specialty) =>
			languageIds.flatMap((language) =>
				cityIds.map((city) =>
					menuItemToLinks(`doctors`, {
						specialtyIds: specialty,
						languageIds: language,
						cityIds: city,
					}),
				),
			),
	);

	const languageCityLinks: SitemapLink[] = languageIds.flatMap((language) =>
		cityIds.map((city) =>
			menuItemToLinks(`doctors`, { languageIds: language, cityIds: city }),
		),
	);

	return await generateSitemap([
		...doctorLinks,
		...specialtyLinks,
		...cityLinks,
		...languageLinks,
		...specialtyCityLinks,
		...specialtyLanguageLinks,
		...specialtyLanguageCityLinks,
		...languageCityLinks,
	]);
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
