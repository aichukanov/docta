import {
	SITEMAP_SECTIONS,
	chunkSitemapLinks,
	menuItemToLinks,
	renderSitemapIndex,
	renderUrlset,
	type SitemapLink,
	type SitemapSection,
} from './utils';
import { doctorIsPublicSql } from '~/server/common/doctor-visibility';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import {
	SITE_URL,
	REVIEWS_THRESHOLD,
	SITEMAP_DETAIL_CITY_MIN_CLINICS,
	SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS,
} from '~/common/constants';
import { getDoctorList } from '~/server/api/doctors/list';
import { getLabTestList } from '~/server/api/labtests/list';
import { getMedicalServiceList } from '~/server/api/services/list';
import { getSitemapFilters as getDoctorSitemapFilters } from './filters/doctors';
import {
	getCategoryCityCombinations as getLabTestCategoryCityCombinations,
	getCategoryIdsWithLabTests,
	getEntityCityCombinations as getLabTestCityCombinations,
} from './filters/labtests';
import {
	getCategoryCityCombinations as getServiceCategoryCityCombinations,
	getCategoryIdsWithServices,
	getEntityCityCombinations as getServiceCityCombinations,
} from './filters/services';
import {
	getSitemapFilters as getClinicSitemapFilters,
	getClinicList,
} from './filters/clinics';
import { getClinicSubpageSlugs } from './filters/clinic-subpages';
import { getMedicineList } from '~/server/api/medicines/list';
import { DispensingMode } from '~/enums/dispensing-mode';
import { getSitemapFilters as getMedicineSitemapFilters } from './filters/medicines';
import { getInsuranceCompanyList } from './filters/insurance-companies';
import { getMedicationSlugs } from './filters/medications';
import { ARTICLE_SLUGS } from '~/common/articles';
import { getConnection } from '~/server/common/db-mysql';

async function getSlugsWithReviews(
	entity: 'doctor' | 'clinic',
): Promise<string[]> {
	const connection = await getConnection();

	const query =
		entity === 'doctor'
			? `SELECT d.slug
				FROM doctors d
				JOIN reviews r ON r.doctor_id = d.id AND r.rating IS NOT NULL AND r.status != 'rejected'
				WHERE ${doctorIsPublicSql('d')}
				GROUP BY d.id
				HAVING COUNT(*) > ?`
			: `SELECT c.slug
				FROM clinics c
				JOIN reviews r ON r.clinic_id = c.id AND r.rating IS NOT NULL AND r.status != 'rejected'
				WHERE ${clinicIsPublicSql('c')}
				GROUP BY c.id
				HAVING COUNT(*) > ?`;

	const [rows] = await connection.execute(query, [REVIEWS_THRESHOLD]);
	await connection.end();

	return (rows as any[]).map((r) => r.slug);
}

// === Секции ===
//
// Каждая секция — самостоятельный набор ссылок со своими запросами к БД.
// Раньше это была одна функция на весь сайт: она собирала всё, что есть, и
// отдавала одним файлом. После того как каждая страница стала давать по одному
// `<url>` на локаль (шесть вместо одного), монолит упирался и в лимит 50 тыс.
// URL, и в 50 МБ, поэтому файл разрезан на секции, а `/sitemap.xml` стал
// индексом. Границы секций — по типу сущности, см. SITEMAP_SECTIONS в utils.ts.

async function buildCoreSection(): Promise<SitemapLink[]> {
	const insuranceCompanies = await getInsuranceCompanyList();

	return [
		// Главная и «О проекте»
		...menuItemToLinks(''),
		...menuItemToLinks('about'),
		// /privacy и /terms индексируемы и слинкованы в подвале с каждой
		// страницы, но в sitemap их не было — единственные страницы сайта,
		// про которые он не сообщал вовсе.
		...menuItemToLinks('privacy'),
		...menuItemToLinks('terms'),
		// Корневые листинги разделов
		...menuItemToLinks('doctors'),
		...menuItemToLinks('labtests'),
		...menuItemToLinks('services'),
		...menuItemToLinks('medicines'),
		...menuItemToLinks('medications'),
		...menuItemToLinks('clinics'),
		// Articles. Список слагов — в common/articles.ts, под присмотром
		// unit-теста. Раньше он был захардкожен здесь двумя слагами из
		// семнадцати, и 15 статей просто не попадали в sitemap
		// (см. prd/silent-200-index-hygiene, итерация 2).
		...menuItemToLinks('articles'),
		...ARTICLE_SLUGS.flatMap((article) =>
			menuItemToLinks(`${SITE_URL}/articles/${article}`, {}, true),
		),
		// Insurance companies. routeName содержит дефис — menuItemToLinks в
		// не-URL режиме заменяет '-' на '/', ломая путь, поэтому isUrl=true.
		...menuItemToLinks(`${SITE_URL}/insurance-companies`, {}, true),
		...insuranceCompanies.flatMap((company) =>
			menuItemToLinks(
				`${SITE_URL}/insurance-companies/${company.slug}`,
				{},
				true,
			),
		),
	];
}

async function buildDoctorsSection(): Promise<SitemapLink[]> {
	const { doctors } = await getDoctorList();
	const doctorsWithReviews = await getSlugsWithReviews('doctor');

	return [
		...doctors.flatMap((doctor) =>
			menuItemToLinks(`${SITE_URL}/doctors/${doctor.slug}`, {}, true),
		),
		...doctorsWithReviews.flatMap((slug) =>
			menuItemToLinks(`${SITE_URL}/doctors/${slug}/reviews`, {}, true),
		),
	];
}

async function buildDoctorFiltersSection(): Promise<SitemapLink[]> {
	const doctorFilters = await getDoctorSitemapFilters();

	return [
		...doctorFilters.specialtyIds.flatMap((specialty) =>
			menuItemToLinks('doctors', { specialtyIds: specialty }),
		),
		...doctorFilters.specialtyCityCombinations.flatMap((combo) =>
			menuItemToLinks('doctors', {
				specialtyIds: combo.specialtyId,
				cityIds: combo.cityId,
			}),
		),
		...doctorFilters.specialtyLanguageCombinations.flatMap((combo) =>
			menuItemToLinks('doctors', {
				specialtyIds: combo.specialtyId,
				languageIds: combo.languageId,
			}),
		),
	];
}

async function buildClinicsSection(): Promise<SitemapLink[]> {
	const clinics = await getClinicList();
	const clinicsWithReviews = await getSlugsWithReviews('clinic');

	// Подстраницы клиник (services/labtests/medications/doctors) — только для
	// клиник, у которых элементов больше инлайнового порога: у остальных
	// подстраница 301-редиректится на якорь главной страницы клиники.
	const clinicSubpages = await getClinicSubpageSlugs();
	const buildSubpageLinks = (
		slugs: string[],
		type: 'services' | 'labtests' | 'medications' | 'doctors',
	): SitemapLink[] =>
		slugs.flatMap((slug) =>
			menuItemToLinks(`${SITE_URL}/clinics/${slug}/${type}`, {}, true),
		);

	return [
		...clinics.flatMap((clinic) =>
			menuItemToLinks(`${SITE_URL}/clinics/${clinic.slug}`, {}, true),
		),
		...clinicsWithReviews.flatMap((slug) =>
			menuItemToLinks(`${SITE_URL}/clinics/${slug}/reviews`, {}, true),
		),
		...buildSubpageLinks(clinicSubpages.services, 'services'),
		...buildSubpageLinks(clinicSubpages.labtests, 'labtests'),
		...buildSubpageLinks(clinicSubpages.medications, 'medications'),
		...buildSubpageLinks(clinicSubpages.doctors, 'doctors'),
	];
}

async function buildClinicFiltersSection(): Promise<SitemapLink[]> {
	const clinicFilters = await getClinicSitemapFilters(
		SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS,
	);

	return [
		...clinicFilters.cityIds.flatMap((city) =>
			menuItemToLinks('clinics', { cityIds: city }),
		),
		// Тип клиники: «Стоматологические клиники [в Будве]» — реальный
		// поисковый спрос; рейтинг/«открыто сейчас»/специализация в sitemap
		// сознательно НЕ включены (см. prd/clinic-catalog/PROGRESS.md)
		...clinicFilters.clinicTypeIds.flatMap((typeId) =>
			menuItemToLinks('clinics', { clinicTypeIds: typeId }),
		),
		...clinicFilters.typeCityCombinations.flatMap((combo) =>
			menuItemToLinks('clinics', {
				clinicTypeIds: combo.clinicTypeId,
				cityIds: combo.cityId,
			}),
		),
	];
}

async function buildServicesSection(): Promise<SitemapLink[]> {
	const { items: medicalServices } = await getMedicalServiceList();
	const cityCombinations = await getServiceCityCombinations(
		SITEMAP_DETAIL_CITY_MIN_CLINICS,
	);

	return [
		...medicalServices.flatMap((service) =>
			menuItemToLinks(`${SITE_URL}/services/${service.slug}`, {}, true),
		),
		// Город-варианты деталей услуги: `/services/{slug}?cityIds={cityId}`,
		// только для пар, где у услуги есть ≥ SITEMAP_DETAIL_CITY_MIN_CLINICS
		// публичных клиник в городе.
		...cityCombinations.flatMap((combo) =>
			menuItemToLinks(
				`${SITE_URL}/services/${combo.slug}`,
				{ cityIds: combo.cityId },
				true,
			),
		),
	];
}

async function buildServiceFiltersSection(): Promise<SitemapLink[]> {
	const categoryIds = await getCategoryIdsWithServices();
	const categoryCityCombinations = await getServiceCategoryCityCombinations();

	return [
		...categoryIds.flatMap((categoryId) =>
			menuItemToLinks('services', { serviceCategoryIds: categoryId }),
		),
		...categoryCityCombinations.flatMap((combo) =>
			menuItemToLinks('services', {
				serviceCategoryIds: combo.categoryId,
				cityIds: combo.cityId,
			}),
		),
	];
}

async function buildLabTestsSection(): Promise<SitemapLink[]> {
	const { items: labTests } = await getLabTestList();
	const cityCombinations = await getLabTestCityCombinations(
		SITEMAP_DETAIL_CITY_MIN_CLINICS,
	);

	return [
		...labTests.flatMap((labTest) =>
			menuItemToLinks(`${SITE_URL}/labtests/${labTest.slug}`, {}, true),
		),
		// Город-варианты деталей анализа: `/labtests/{slug}?cityIds={cityId}`,
		// только для пар, где у анализа есть ≥ SITEMAP_DETAIL_CITY_MIN_CLINICS
		// публичных клиник в городе.
		...cityCombinations.flatMap((combo) =>
			menuItemToLinks(
				`${SITE_URL}/labtests/${combo.slug}`,
				{ cityIds: combo.cityId },
				true,
			),
		),
	];
}

async function buildLabTestFiltersSection(): Promise<SitemapLink[]> {
	const categoryIds = await getCategoryIdsWithLabTests();
	const categoryCityCombinations = await getLabTestCategoryCityCombinations();

	return [
		...categoryIds.flatMap((categoryId) =>
			menuItemToLinks('labtests', { categoryIds: categoryId }),
		),
		...categoryCityCombinations.flatMap((combo) =>
			menuItemToLinks('labtests', {
				categoryIds: combo.categoryId,
				cityIds: combo.cityId,
			}),
		),
	];
}

async function buildMedicinesSection(): Promise<SitemapLink[]> {
	const { items: medicines } = await getMedicineList({ activeOnly: true });

	return medicines.flatMap((medicine) =>
		menuItemToLinks(`${SITE_URL}/medicines/${medicine.slug}`, {}, true),
	);
}

async function buildMedicineFiltersSection(): Promise<SitemapLink[]> {
	const medicineFilters = await getMedicineSitemapFilters();

	return [
		// Публикуем ТОЛЬКО потребительские категории: `?atcGroupIds=` даёт почти
		// те же наборы лекарств другими словами, и два конкурирующих набора
		// фасетных URL в индексе не нужны. Сам фильтр и старые URL остаются
		// рабочими — их просто не рекламируем
		// (см. prd/medicines-consumer-content/PLAN.md, трек B).
		...medicineFilters.categoryIds.flatMap((categoryId) =>
			menuItemToLinks('medicines', { medicineCategoryIds: categoryId }),
		),
		// «Что из этой категории можно купить без рецепта» — сильный отдельный
		// интент, но только там, где безрецептурные лекарства реально есть.
		...medicineFilters.otcCategoryIds.flatMap((categoryId) =>
			menuItemToLinks('medicines', {
				medicineCategoryIds: categoryId,
				dispensingModeIds: DispensingMode.OTC,
			}),
		),
		...medicineFilters.substanceAtcCombinations.flatMap((combo) =>
			menuItemToLinks('medicines', {
				substanceIds: combo.substanceId,
				atcGroupIds: combo.atcGroupId,
			}),
		),
	];
}

async function buildMedicationsSection(): Promise<SitemapLink[]> {
	// Цены лекарств в клиниках, не регистр ЦИнМЕД
	const medicationSlugs = await getMedicationSlugs();

	return medicationSlugs.flatMap((slug) =>
		menuItemToLinks(`${SITE_URL}/medications/${slug}`, {}, true),
	);
}

/**
 * Реестр секций. Тип `Record<SitemapSection, …>` намеренно строгий: добавить
 * имя в SITEMAP_SECTIONS и забыть сборщик (или наоборот) не даст typecheck.
 */
const SECTION_BUILDERS: Record<SitemapSection, () => Promise<SitemapLink[]>> = {
	'core': buildCoreSection,
	'doctors': buildDoctorsSection,
	'doctor-filters': buildDoctorFiltersSection,
	'clinics': buildClinicsSection,
	'clinic-filters': buildClinicFiltersSection,
	'services': buildServicesSection,
	'service-filters': buildServiceFiltersSection,
	'labtests': buildLabTestsSection,
	'labtest-filters': buildLabTestFiltersSection,
	'medicines': buildMedicinesSection,
	'medicine-filters': buildMedicineFiltersSection,
	'medications': buildMedicationsSection,
};

async function generateSitemapSection(section: SitemapSection, part: number) {
	const chunks = chunkSitemapLinks(await SECTION_BUILDERS[section]());

	// Часть вне диапазона — не ошибка, а гонка: индекс мог быть собран до того,
	// как из секции ушли данные. Пустой urlset честнее 404: бот просто не
	// найдёт в файле ничего нового и вернётся к нему в следующий раз.
	return renderUrlset(chunks[part - 1] ?? []);
}

async function generateSitemapIndex() {
	const parts: Array<{ section: SitemapSection; part: number }> = [];

	for (const section of SITEMAP_SECTIONS) {
		const chunks = chunkSitemapLinks(await SECTION_BUILDERS[section]());
		for (let i = 0; i < chunks.length; i++) {
			parts.push({ section, part: i + 1 });
		}
	}

	return renderSitemapIndex(parts);
}

/**
 * Файл одной секции с часовым кэшем.
 *
 * Сборка секции стоит от одного до пяти запросов к MySQL (в том числе полные
 * листинги без пагинации, только ради колонки slug) и склейку десятков тысяч
 * строк XML. На проде это измерялось в 1,9 с на монолитный файл, и платил за
 * него каждый заход бота.
 *
 * `swr` включён: по истечении часа первый запрос получает прошлую копию сразу,
 * а пересборка идёт фоном — бот никогда не ждёт. Ключ включает номер части,
 * поэтому части кэшируются независимо и в память одновременно не попадает
 * весь sitemap целиком.
 */
export const getSitemapSection = defineCachedFunction(generateSitemapSection, {
	name: 'sitemap-section',
	getKey: (section: SitemapSection, part: number) => `${section}-${part}`,
	maxAge: 60 * 60,
	swr: true,
});

/**
 * Индекс `/sitemap.xml`. Адрес обязан остаться рабочим: на него ссылается
 * `Sitemap:` в robots.txt и он же зарегистрирован в консолях поисковиков.
 *
 * Кэшируется отдельно от секций, хотя и считает их все: узнать число частей
 * можно только собрав ссылки. Зато результат — несколько сотен байт, и
 * запрашивают его на порядок чаще, чем сами секции.
 *
 * Ключ намеренно НЕ 'sitemap.xml': под этим ключом в `.data/cache` лежит
 * прошлый монолитный файл, а `swr` отдал бы его сразу и без вопросов — первый
 * час после выката поисковики получали бы старый urlset вместо индекса.
 */
export const getSitemapIndex = defineCachedFunction(generateSitemapIndex, {
	name: 'sitemap',
	getKey: () => 'sitemap-index.xml',
	maxAge: 60 * 60,
	swr: true,
});
