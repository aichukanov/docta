import { SitemapLink } from './utils';
import { SITEMAP_LIMIT } from './utils';
import { locales } from '~/composables/use-locale';
import { getRegionalUrl } from '~/common/url-utils';
import { getDoctorList } from '~/server/api/doctors/list';
import { DoctorSpecialty } from '~/enums/specialty';
import { CityId } from '~/enums/cities';
import { LanguageId } from '~/enums/language';
import { getConnection } from '~/server/common/db-mysql';

export function menuItemToLinks(
	routeName: string,
	query: Record<string, string | string[]> = {},
) {
	const url = 'https://docta.me/' + routeName.replaceAll('-', '/');

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

function getEnumValues(enumType: any) {
	return Object.values(enumType).filter(
		(value) => !Number.isNaN(Number(value)),
	);
}

async function getActiveFilterCombinations() {
	const connection = await getConnection();

	// Комбинация: специальность + город
	const specialtyCityQuery = `
		SELECT DISTINCT ds.specialty_id as specialtyId, clinics.city_id as cityId
		FROM doctors d
		INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		INNER JOIN clinics ON dc.clinic_id = clinics.id
		ORDER BY ds.specialty_id, clinics.city_id;
	`;
	const [specialtyCityRows] = await connection.execute<any[]>(
		specialtyCityQuery,
	);

	// Комбинация: специальность + язык
	const specialtyLanguageQuery = `
		SELECT DISTINCT specialty_id as specialtyId, lang_id as languageId
		FROM (
			SELECT ds.specialty_id, dl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1
			UNION
			SELECT ds.specialty_id, cl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			WHERE cl.language_id != 1
		) as combined
		ORDER BY specialty_id, lang_id;
	`;
	const [specialtyLanguageRows] = await connection.execute<any[]>(
		specialtyLanguageQuery,
	);

	// Комбинация: язык + город
	const languageCityQuery = `
		SELECT DISTINCT lang_id as languageId, city_id as cityId
		FROM (
			SELECT dl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE dl.language_id != 1
			UNION
			SELECT cl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE cl.language_id != 1
		) as combined
		ORDER BY lang_id, city_id;
	`;
	const [languageCityRows] = await connection.execute<any[]>(languageCityQuery);

	// Комбинация: специальность + язык + город
	const specialtyLanguageCityQuery = `
		SELECT DISTINCT specialty_id as specialtyId, lang_id as languageId, city_id as cityId
		FROM (
			SELECT ds.specialty_id, dl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE dl.language_id != 1
			UNION
			SELECT ds.specialty_id, cl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE cl.language_id != 1
		) as combined
		ORDER BY specialty_id, lang_id, city_id;
	`;
	const [specialtyLanguageCityRows] = await connection.execute<any[]>(
		specialtyLanguageCityQuery,
	);

	// Комбинация: только клиника
	const clinicQuery = `
		SELECT DISTINCT dc.clinic_id as clinicId
		FROM doctors d
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		ORDER BY dc.clinic_id;
	`;
	const [clinicRows] = await connection.execute<any[]>(clinicQuery);

	// Комбинация: клиника + специальность
	const clinicSpecialtyQuery = `
		SELECT DISTINCT dc.clinic_id as clinicId, ds.specialty_id as specialtyId
		FROM doctors d
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
		ORDER BY dc.clinic_id, ds.specialty_id;
	`;
	const [clinicSpecialtyRows] = await connection.execute<any[]>(
		clinicSpecialtyQuery,
	);

	// Комбинация: клиника + язык
	const clinicLanguageQuery = `
		SELECT DISTINCT clinic_id as clinicId, lang_id as languageId
		FROM (
			SELECT dc.clinic_id, dl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1
			UNION
			SELECT dc.clinic_id, cl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			WHERE cl.language_id != 1
		) as combined
		ORDER BY clinic_id, lang_id;
	`;
	const [clinicLanguageRows] = await connection.execute<any[]>(
		clinicLanguageQuery,
	);

	// Комбинация: клиника + специальность + язык
	const clinicSpecialtyLanguageQuery = `
		SELECT DISTINCT clinic_id as clinicId, specialty_id as specialtyId, lang_id as languageId
		FROM (
			SELECT dc.clinic_id, ds.specialty_id, dl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1
			UNION
			SELECT dc.clinic_id, ds.specialty_id, cl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			WHERE cl.language_id != 1
		) as combined
		ORDER BY clinic_id, specialty_id, lang_id;
	`;
	const [clinicSpecialtyLanguageRows] = await connection.execute<any[]>(
		clinicSpecialtyLanguageQuery,
	);

	await connection.end();

	return {
		specialtyCityCombinations: specialtyCityRows,
		specialtyLanguageCombinations: specialtyLanguageRows,
		languageCityCombinations: languageCityRows,
		specialtyLanguageCityCombinations: specialtyLanguageCityRows,
		clinicCombinations: clinicRows,
		clinicSpecialtyCombinations: clinicSpecialtyRows,
		clinicLanguageCombinations: clinicLanguageRows,
		clinicSpecialtyLanguageCombinations: clinicSpecialtyLanguageRows,
	};
}

export async function generateSitemapPage(sitemapIndex: number) {
	const { doctors } = await getDoctorList();

	const doctorLinks: SitemapLink[] = doctors.map((doctor) =>
		menuItemToLinks(`doctors-${doctor.id}`),
	);

	// Для одиночных фильтров можно оставить все значения - каждое гарантированно что-то вернёт
	const specialtyIds = getEnumValues(DoctorSpecialty);
	const cityIds = getEnumValues(CityId);
	const languageIds = getEnumValues(LanguageId).filter((id) => id !== 1); // Исключаем сербский язык (id = 1)

	const specialtyLinks: SitemapLink[] = specialtyIds.map((specialty) =>
		menuItemToLinks(`doctors`, { specialtyIds: specialty }),
	);

	const cityLinks: SitemapLink[] = cityIds.map((city) =>
		menuItemToLinks(`doctors`, { cityIds: city }),
	);

	const languageLinks: SitemapLink[] = languageIds.map((language) =>
		menuItemToLinks(`doctors`, { languageIds: language }),
	);

	// Получаем только реальные комбинации из БД
	const combinations = await getActiveFilterCombinations();

	const specialtyCityLinks: SitemapLink[] =
		combinations.specialtyCityCombinations.map((combo: any) =>
			menuItemToLinks(`doctors`, {
				specialtyIds: combo.specialtyId,
				cityIds: combo.cityId,
			}),
		);

	const specialtyLanguageLinks: SitemapLink[] =
		combinations.specialtyLanguageCombinations.map((combo: any) =>
			menuItemToLinks(`doctors`, {
				specialtyIds: combo.specialtyId,
				languageIds: combo.languageId,
			}),
		);

	const languageCityLinks: SitemapLink[] =
		combinations.languageCityCombinations.map((combo: any) =>
			menuItemToLinks(`doctors`, {
				languageIds: combo.languageId,
				cityIds: combo.cityId,
			}),
		);

	const specialtyLanguageCityLinks: SitemapLink[] =
		combinations.specialtyLanguageCityCombinations.map((combo: any) =>
			menuItemToLinks(`doctors`, {
				specialtyIds: combo.specialtyId,
				languageIds: combo.languageId,
				cityIds: combo.cityId,
			}),
		);

	const clinicLinks: SitemapLink[] =
		combinations.clinicCombinations.length > 0
			? combinations.clinicCombinations.map((combo: any) =>
					menuItemToLinks(`doctors`, {
						clinicIds: combo.clinicId,
					}),
			  )
			: [];

	const clinicSpecialtyLinks: SitemapLink[] =
		combinations.clinicSpecialtyCombinations.length > 0
			? combinations.clinicSpecialtyCombinations.map((combo: any) =>
					menuItemToLinks(`doctors`, {
						clinicIds: combo.clinicId,
						specialtyIds: combo.specialtyId,
					}),
			  )
			: [];

	const clinicLanguageLinks: SitemapLink[] =
		combinations.clinicLanguageCombinations.length > 0
			? combinations.clinicLanguageCombinations.map((combo: any) =>
					menuItemToLinks(`doctors`, {
						clinicIds: combo.clinicId,
						languageIds: combo.languageId,
					}),
			  )
			: [];

	const clinicSpecialtyLanguageLinks: SitemapLink[] =
		combinations.clinicSpecialtyLanguageCombinations.length > 0
			? combinations.clinicSpecialtyLanguageCombinations.map((combo: any) =>
					menuItemToLinks(`doctors`, {
						clinicIds: combo.clinicId,
						specialtyIds: combo.specialtyId,
						languageIds: combo.languageId,
					}),
			  )
			: [];

	return await generateSitemap([
		...doctorLinks,
		...specialtyLinks,
		...cityLinks,
		...languageLinks,
		...specialtyCityLinks,
		...specialtyLanguageLinks,
		...languageCityLinks,
		...specialtyLanguageCityLinks,
		...clinicLinks,
		...clinicSpecialtyLinks,
		...clinicLanguageLinks,
		...clinicSpecialtyLanguageLinks,
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
