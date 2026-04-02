import { SitemapLink } from './utils';
import { locales } from '~/composables/use-locale';
import { getRegionalUrl } from '~/common/url-utils';
import { SITE_URL, REVIEWS_THRESHOLD } from '~/common/constants';
import { getDoctorList } from '~/server/api/doctors/list';
import { getLabTestList } from '~/server/api/labtests/list';
import { getMedicalServiceList } from '~/server/api/services/list';
import { getSitemapFilters as getDoctorSitemapFilters } from './filters/doctors';
import { getSitemapFilters as getLabTestSitemapFilters } from './filters/labtests';
import { getSitemapFilters as getMedicalServiceSitemapFilters } from './filters/services';
import {
	getSitemapFilters as getClinicSitemapFilters,
	getClinicList,
} from './filters/clinics';
import { getConnection } from '~/server/common/db-mysql';

export function menuItemToLinks(
	routeName: string,
	query: Record<string, string | string[]> = {},
	isUrl = false,
) {
	const url = isUrl
		? routeName
		: SITE_URL + '/' + routeName.replaceAll('-', '/');

	const linksWithParams: Array<{ hreflang: string; href: string }> = [];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];
		if (lang === 'ba') {
			continue;
		}

		linksWithParams.push({
			hreflang: lang,
			href: getRegionalUrl(url, query, lang),
		});
	}

	linksWithParams.push({
		hreflang: 'x-default',
		href: getRegionalUrl(url, query, 'en'),
	});

	const loc = getRegionalUrl(url, query, 'sr');

	return {
		loc,
		lastmod: new Date(),
		changefreq: 'weekly',
		alternatives: linksWithParams,
	};
}

async function getEntitiesWithReviews(): Promise<{
	doctorSlugs: string[];
	clinicSlugs: string[];
}> {
	const connection = await getConnection();

	const [doctorRows] = await connection.execute(
		`SELECT d.slug
		FROM doctors d
		JOIN reviews r ON r.doctor_id = d.id AND r.rating IS NOT NULL
		WHERE d.hidden = 0 AND d.is_draft = 0
		GROUP BY d.id
		HAVING COUNT(*) > ?`,
		[REVIEWS_THRESHOLD],
	);

	const [clinicRows] = await connection.execute(
		`SELECT c.slug
		FROM clinics c
		JOIN reviews r ON r.clinic_id = c.id AND r.rating IS NOT NULL
		GROUP BY c.id
		HAVING COUNT(*) > ?`,
		[REVIEWS_THRESHOLD],
	);

	await connection.end();

	return {
		doctorSlugs: (doctorRows as any[]).map((r) => r.slug),
		clinicSlugs: (clinicRows as any[]).map((r) => r.slug),
	};
}

export async function generateSitemapPage(sitemapIndex: number) {
	// === Главная страница ===
	const homeLink: SitemapLink = menuItemToLinks('');
	const aboutLink: SitemapLink = menuItemToLinks('about');

	// === Articles ===
	const articlesPageLink: SitemapLink = menuItemToLinks('articles');
	const articleList = [
		'russian-speaking-doctors-in-montenegro',
		'clinics-with-language-support',
	];
	const articleLinks: SitemapLink[] = articleList.map((article) =>
		menuItemToLinks(SITE_URL + '/articles/' + article, {}, true),
	);

	// === Doctors ===
	const { doctors } = await getDoctorList();
	const doctorFilters = await getDoctorSitemapFilters();

	const doctorsPageLink: SitemapLink = menuItemToLinks('doctors');

	const doctorLinks: SitemapLink[] = doctors.map((doctor) =>
		menuItemToLinks(`${SITE_URL}/doctors/${doctor.slug}`, {}, true),
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
		menuItemToLinks(`${SITE_URL}/labtests/${labTest.slug}`, {}, true),
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

	// === Medical Services ===
	const { items: medicalServices } = await getMedicalServiceList();
	const medicalServiceFilters = await getMedicalServiceSitemapFilters();

	const medicalServicesPageLink: SitemapLink = menuItemToLinks('services');

	const medicalServiceLinks: SitemapLink[] = medicalServices.map((service) =>
		menuItemToLinks(`${SITE_URL}/services/${service.slug}`, {}, true),
	);

	const medicalServiceCategoryLinks: SitemapLink[] =
		medicalServiceFilters.categoryIds.map((categoryId) =>
			menuItemToLinks('services', { serviceCategoryIds: categoryId }),
		);

	const medicalServiceCategoryCityLinks: SitemapLink[] =
		medicalServiceFilters.categoryCityCombinations.map((combo) =>
			menuItemToLinks('services', {
				serviceCategoryIds: combo.categoryId,
				cityIds: combo.cityId,
			}),
		);

	// === Reviews pages ===
	const { doctorSlugs: doctorsWithReviews, clinicSlugs: clinicsWithReviews } =
		await getEntitiesWithReviews();

	const doctorReviewLinks: SitemapLink[] = doctorsWithReviews.map((slug) =>
		menuItemToLinks(`${SITE_URL}/doctors/${slug}/reviews`, {}, true),
	);

	const clinicReviewLinks: SitemapLink[] = clinicsWithReviews.map((slug) =>
		menuItemToLinks(`${SITE_URL}/clinics/${slug}/reviews`, {}, true),
	);

	// === Clinics ===
	const clinics = await getClinicList();
	const clinicFilters = await getClinicSitemapFilters();

	const clinicsPageLink: SitemapLink = menuItemToLinks('clinics');

	const clinicLinks: SitemapLink[] = clinics.map((clinic) =>
		menuItemToLinks(`${SITE_URL}/clinics/${clinic.slug}`, {}, true),
	);

	const clinicCityLinks: SitemapLink[] = clinicFilters.cityIds.map((city) =>
		menuItemToLinks('clinics', { cityIds: city }),
	);

	return await generateSitemap([
		// Главная страница
		homeLink,
		aboutLink,
		// Articles
		articlesPageLink,
		...articleLinks,
		// Doctors: страницы + специальность + специальность+город + специальность+язык
		doctorsPageLink,
		...doctorLinks,
		...doctorReviewLinks,
		...specialtyLinks,
		...specialtyCityLinks,
		...specialtyLanguageLinks,
		// Lab Tests: страницы + категории + категория+город
		labTestsPageLink,
		...labTestLinks,
		...labTestCategoryLinks,
		...labTestCategoryCityLinks,
		// Medical Services: страницы + категории + категория+город
		medicalServicesPageLink,
		...medicalServiceLinks,
		...medicalServiceCategoryLinks,
		...medicalServiceCategoryCityLinks,
		// Clinics: страницы + город
		clinicsPageLink,
		...clinicLinks,
		...clinicReviewLinks,
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
