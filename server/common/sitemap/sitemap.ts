import { SitemapLink } from './utils';
import { SITEMAP_LIMIT } from './utils';
import { locales } from '~/composables/use-locale';
import { getRegionalUrl } from '~/common/url-utils';
import { getDoctorList } from '~/server/api/doctors/list';
import { getLabTestList } from '~/server/api/lab-tests/list';
import { getMedicationList } from '~/server/api/medications/list';
import { getMedicalServiceList } from '~/server/api/services/list';
import { DoctorSpecialty } from '~/enums/specialty';
import { CityId } from '~/enums/cities';
import { LanguageId } from '~/enums/language';
import { LabTestCategory } from '~/enums/lab-test-category';
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

// Получаем комбинации фильтров для lab-tests
async function getLabTestFilterCombinations() {
	const connection = await getConnection();

	// Комбинация: категория + клиника
	const categoryClinicsQuery = `
		SELECT DISTINCT ltcr.category_id as categoryId, clt.clinic_id as clinicId
		FROM lab_tests lt
		INNER JOIN lab_test_categories_relations ltcr ON lt.id = ltcr.lab_test_id
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		ORDER BY ltcr.category_id, clt.clinic_id;
	`;
	const [categoryClinicRows] = await connection.execute<any[]>(
		categoryClinicsQuery,
	);

	// Комбинация: только клиника (для lab-tests)
	const clinicQuery = `
		SELECT DISTINCT clt.clinic_id as clinicId
		FROM clinic_lab_tests clt
		ORDER BY clt.clinic_id;
	`;
	const [clinicRows] = await connection.execute<any[]>(clinicQuery);

	// Комбинация: только город (для lab-tests)
	const cityQuery = `
		SELECT DISTINCT c.city_id as cityId
		FROM clinic_lab_tests clt
		INNER JOIN clinics c ON clt.clinic_id = c.id
		ORDER BY c.city_id;
	`;
	const [cityRows] = await connection.execute<any[]>(cityQuery);

	// Комбинация: категория + город
	const categoryCityQuery = `
		SELECT DISTINCT ltcr.category_id as categoryId, c.city_id as cityId
		FROM lab_tests lt
		INNER JOIN lab_test_categories_relations ltcr ON lt.id = ltcr.lab_test_id
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		INNER JOIN clinics c ON clt.clinic_id = c.id
		ORDER BY ltcr.category_id, c.city_id;
	`;
	const [categoryCityRows] = await connection.execute<any[]>(categoryCityQuery);

	await connection.end();

	return {
		categoryClinicCombinations: categoryClinicRows,
		clinicCombinations: clinicRows,
		cityCombinations: cityRows,
		categoryCityCombinations: categoryCityRows,
	};
}

// Получаем комбинации фильтров для medications
async function getMedicationFilterCombinations() {
	const connection = await getConnection();

	const clinicQuery = `
		SELECT DISTINCT cm.clinic_id as clinicId
		FROM clinic_medications cm
		ORDER BY cm.clinic_id;
	`;
	const [clinicRows] = await connection.execute<any[]>(clinicQuery);

	// Комбинация: только город
	const cityQuery = `
		SELECT DISTINCT c.city_id as cityId
		FROM clinic_medications cm
		INNER JOIN clinics c ON cm.clinic_id = c.id
		ORDER BY c.city_id;
	`;
	const [cityRows] = await connection.execute<any[]>(cityQuery);

	await connection.end();

	return {
		clinicCombinations: clinicRows,
		cityCombinations: cityRows,
	};
}

// Получаем комбинации фильтров для services
async function getMedicalServiceFilterCombinations() {
	const connection = await getConnection();

	const clinicQuery = `
		SELECT DISTINCT cms.clinic_id as clinicId
		FROM clinic_medical_services cms
		ORDER BY cms.clinic_id;
	`;
	const [clinicRows] = await connection.execute<any[]>(clinicQuery);

	// Комбинация: только город
	const cityQuery = `
		SELECT DISTINCT c.city_id as cityId
		FROM clinic_medical_services cms
		INNER JOIN clinics c ON cms.clinic_id = c.id
		ORDER BY c.city_id;
	`;
	const [cityRows] = await connection.execute<any[]>(cityQuery);

	await connection.end();

	return {
		clinicCombinations: clinicRows,
		cityCombinations: cityRows,
	};
}

// Получаем список клиник для sitemap
async function getClinicList() {
	const connection = await getConnection();

	const clinicsQuery = `
		SELECT c.id, c.city_id as cityId
		FROM clinics c
		ORDER BY c.id;
	`;
	const [clinicRows] = await connection.execute<any[]>(clinicsQuery);

	await connection.end();

	return clinicRows;
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
	// === Главная страница ===
	const homeLink: SitemapLink = menuItemToLinks('');

	// === Doctors ===
	const { doctors } = await getDoctorList();

	const doctorLinks: SitemapLink[] = doctors.map((doctor) =>
		menuItemToLinks(`doctors-${doctor.id}`),
	);

	// Для одиночных фильтров можно оставить все значения - каждое гарантированно что-то вернёт
	const specialtyIds = getEnumValues(DoctorSpecialty);
	const cityIds = getEnumValues(CityId);
	const languageIds = getEnumValues(LanguageId).filter((id) => id !== 1); // Исключаем сербский язык (id = 1)

	const doctorsPageLink: SitemapLink = menuItemToLinks('doctors');

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

	const doctorClinicLinks: SitemapLink[] =
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

	// === Lab Tests ===
	const { items: labTests } = await getLabTestList();

	const labTestsPageLink: SitemapLink = menuItemToLinks('lab-tests');

	const labTestLinks: SitemapLink[] = labTests.map((labTest) =>
		menuItemToLinks(`lab-tests-${labTest.id}`),
	);

	const labTestCategoryIds = getEnumValues(LabTestCategory);
	const labTestCategoryLinks: SitemapLink[] = labTestCategoryIds.map(
		(categoryId) => menuItemToLinks('lab-tests', { categoryIds: categoryId }),
	);

	const labTestCombinations = await getLabTestFilterCombinations();

	const labTestClinicLinks: SitemapLink[] =
		labTestCombinations.clinicCombinations.map((combo: any) =>
			menuItemToLinks('lab-tests', { clinicIds: combo.clinicId }),
		);

	const labTestCityLinks: SitemapLink[] =
		labTestCombinations.cityCombinations.map((combo: any) =>
			menuItemToLinks('lab-tests', { cityIds: combo.cityId }),
		);

	const labTestCategoryClinicLinks: SitemapLink[] =
		labTestCombinations.categoryClinicCombinations.map((combo: any) =>
			menuItemToLinks('lab-tests', {
				categoryIds: combo.categoryId,
				clinicIds: combo.clinicId,
			}),
		);

	const labTestCategoryCityLinks: SitemapLink[] =
		labTestCombinations.categoryCityCombinations.map((combo: any) =>
			menuItemToLinks('lab-tests', {
				categoryIds: combo.categoryId,
				cityIds: combo.cityId,
			}),
		);

	// === Medications ===
	const { items: medications } = await getMedicationList();

	const medicationsPageLink: SitemapLink = menuItemToLinks('medications');

	const medicationLinks: SitemapLink[] = medications.map((medication) =>
		menuItemToLinks(`medications-${medication.id}`),
	);

	const medicationCombinations = await getMedicationFilterCombinations();

	const medicationClinicLinks: SitemapLink[] =
		medicationCombinations.clinicCombinations.map((combo: any) =>
			menuItemToLinks('medications', { clinicIds: combo.clinicId }),
		);

	const medicationCityLinks: SitemapLink[] =
		medicationCombinations.cityCombinations.map((combo: any) =>
			menuItemToLinks('medications', { cityIds: combo.cityId }),
		);

	// === Medical Services ===
	const { items: medicalServices } = await getMedicalServiceList();

	const medicalServicesPageLink: SitemapLink = menuItemToLinks('services');

	const medicalServiceLinks: SitemapLink[] = medicalServices.map((service) =>
		menuItemToLinks(`services-${service.id}`),
	);

	const medicalServiceCombinations =
		await getMedicalServiceFilterCombinations();

	const medicalServiceClinicLinks: SitemapLink[] =
		medicalServiceCombinations.clinicCombinations.map((combo: any) =>
			menuItemToLinks('services', { clinicIds: combo.clinicId }),
		);

	const medicalServiceCityLinks: SitemapLink[] =
		medicalServiceCombinations.cityCombinations.map((combo: any) =>
			menuItemToLinks('services', { cityIds: combo.cityId }),
		);

	// === Clinics ===
	const clinics = await getClinicList();

	const clinicsPageLink: SitemapLink = menuItemToLinks('clinics');

	const clinicLinks: SitemapLink[] = clinics.map((clinic) =>
		menuItemToLinks(`clinics-${clinic.id}`),
	);

	const clinicCityLinks: SitemapLink[] = cityIds.map((city) =>
		menuItemToLinks('clinics', { cityIds: city }),
	);

	return await generateSitemap([
		// Главная страница
		homeLink,
		// Doctors
		doctorsPageLink,
		...doctorLinks,
		...specialtyLinks,
		...cityLinks,
		...languageLinks,
		...specialtyCityLinks,
		...specialtyLanguageLinks,
		...languageCityLinks,
		...specialtyLanguageCityLinks,
		...doctorClinicLinks,
		...clinicSpecialtyLinks,
		...clinicLanguageLinks,
		...clinicSpecialtyLanguageLinks,
		// Lab Tests
		labTestsPageLink,
		...labTestLinks,
		...labTestCategoryLinks,
		...labTestClinicLinks,
		...labTestCityLinks,
		...labTestCategoryClinicLinks,
		...labTestCategoryCityLinks,
		// Medications
		medicationsPageLink,
		...medicationLinks,
		...medicationClinicLinks,
		...medicationCityLinks,
		// Medical Services
		medicalServicesPageLink,
		...medicalServiceLinks,
		...medicalServiceClinicLinks,
		...medicalServiceCityLinks,
		// Clinics
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
