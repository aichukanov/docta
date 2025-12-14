import { SitemapLink } from './utils';
import { locales } from '~/composables/use-locale';
import { getRegionalUrl } from '~/common/url-utils';
import { getDoctorList } from '~/server/api/doctors/list';
import { getLabTestList } from '~/server/api/labtests/list';
import { getSitemapFilters as getDoctorSitemapFilters } from './filters/doctors';
import { getSitemapFilters as getLabTestSitemapFilters } from './filters/labtests';
import {
	getSitemapFilters as getClinicSitemapFilters,
	getClinicList,
} from './filters/clinics';

export function menuItemToLinks(
	routeName: string,
	query: Record<string, string | string[]> = {},
) {
	const url = 'https://omeda.me/' + routeName.replaceAll('-', '/');

	const linksWithParams: Array<{ hreflang: string; href: string }> = [];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];
		if (lang === 'me' || lang === 'ba') {
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
	// === Главная страница ===
	const homeLink: SitemapLink = menuItemToLinks('');
	const aboutLink: SitemapLink = menuItemToLinks('about');

	// === Doctors ===
	const { doctors } = await getDoctorList();
	const doctorFilters = await getDoctorSitemapFilters();

	const doctorsPageLink: SitemapLink = menuItemToLinks('doctors');

	const doctorLinks: SitemapLink[] = doctors.map((doctor) =>
		menuItemToLinks(`doctors-${doctor.id}`),
	);

	const specialtyLinks: SitemapLink[] = doctorFilters.specialtyIds.map(
		(specialty) => menuItemToLinks('doctors', { specialtyIds: specialty }),
	);

	const specialtyCityLinks: SitemapLink[] =
		doctorFilters.specialtyCityCombinations.map((combo) =>
			menuItemToLinks('doctors', {
				specialtyIds: combo.specialtyId,
				cityIds: combo.cityId,
			}),
		);

	const specialtyLanguageLinks: SitemapLink[] =
		doctorFilters.specialtyLanguageCombinations.map((combo) =>
			menuItemToLinks('doctors', {
				specialtyIds: combo.specialtyId,
				languageIds: combo.languageId,
			}),
		);

	// === Lab Tests ===
	const { items: labTests } = await getLabTestList();
	const labTestFilters = await getLabTestSitemapFilters();

	const labTestsPageLink: SitemapLink = menuItemToLinks('labtests');

	const labTestLinks: SitemapLink[] = labTests.map((labTest) =>
		menuItemToLinks(`labtests-${labTest.id}`),
	);

	const labTestCategoryLinks: SitemapLink[] = labTestFilters.categoryIds.map(
		(categoryId) => menuItemToLinks('labtests', { categoryIds: categoryId }),
	);

	const labTestCategoryCityLinks: SitemapLink[] =
		labTestFilters.categoryCityCombinations.map((combo) =>
			menuItemToLinks('labtests', {
				categoryIds: combo.categoryId,
				cityIds: combo.cityId,
			}),
		);

	// === Clinics ===
	const clinics = await getClinicList();
	const clinicFilters = await getClinicSitemapFilters();

	const clinicsPageLink: SitemapLink = menuItemToLinks('clinics');

	const clinicLinks: SitemapLink[] = clinics.map((clinic) =>
		menuItemToLinks(`clinics-${clinic.id}`),
	);

	const clinicCityLinks: SitemapLink[] = clinicFilters.cityIds.map((city) =>
		menuItemToLinks('clinics', { cityIds: city }),
	);

	return await generateSitemap([
		// Главная страница
		homeLink,
		aboutLink,
		// Doctors: страницы + специальность + специальность+город + специальность+язык
		doctorsPageLink,
		...doctorLinks,
		...specialtyLinks,
		...specialtyCityLinks,
		...specialtyLanguageLinks,
		// Lab Tests: страницы + категории + категория+город
		labTestsPageLink,
		...labTestLinks,
		...labTestCategoryLinks,
		...labTestCategoryCityLinks,
		// Clinics: страницы + город
		clinicsPageLink,
		...clinicLinks,
		...clinicCityLinks,
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
