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
import { ARTICLE_SLUGS } from '~/common/articles';
import { getConnection } from '~/server/common/db-mysql';
import { getSlugLastmodMap, lastmodSql, toLastmod } from './lastmod';

/**
 * Страницы отзывов и дата их изменения.
 *
 * `lastmod` берётся по САМИМ отзывам, а не по врачу или клинике: содержимое
 * страницы — отзывы, и новый отзыв меняет её, не трогая строку сущности.
 */
async function getSlugsWithReviews(
	entity: 'doctor' | 'clinic',
): Promise<Array<{ slug: string; lastmod?: Date }>> {
	const lastmod = await lastmodSql('reviews', 'MAX(r.updated_at)');
	const connection = await getConnection();

	const query =
		entity === 'doctor'
			? `SELECT d.slug, ${lastmod} as lastmod
				FROM doctors d
				JOIN reviews r ON r.doctor_id = d.id AND r.rating IS NOT NULL AND r.status != 'rejected'
				WHERE ${doctorIsPublicSql('d')}
				GROUP BY d.id
				HAVING COUNT(*) > ?`
			: `SELECT c.slug, ${lastmod} as lastmod
				FROM clinics c
				JOIN reviews r ON r.clinic_id = c.id AND r.rating IS NOT NULL AND r.status != 'rejected'
				WHERE ${clinicIsPublicSql('c')}
				GROUP BY c.id
				HAVING COUNT(*) > ?`;

	const [rows] = await connection.execute(query, [REVIEWS_THRESHOLD]);
	await connection.end();

	return (rows as any[]).map((r) => ({
		slug: r.slug,
		lastmod: toLastmod(r.lastmod),
	}));
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
				company.lastmod,
			),
		),
	];
}

async function buildDoctorsSection(): Promise<SitemapLink[]> {
	const { doctors } = await getDoctorList();
	const doctorsWithReviews = await getSlugsWithReviews('doctor');
	// Списочный эндпоинт врачей даты не отдаёт (и не должен — она нужна только
	// здесь), поэтому забираем её отдельным запросом и сводим по слагу.
	const lastmod = await getSlugLastmodMap('doctors');

	return [
		...doctors.flatMap((doctor) =>
			menuItemToLinks(
				`${SITE_URL}/doctors/${doctor.slug}`,
				{},
				true,
				lastmod.get(doctor.slug),
			),
		),
		...doctorsWithReviews.flatMap((doctor) =>
			menuItemToLinks(
				`${SITE_URL}/doctors/${doctor.slug}/reviews`,
				{},
				true,
				doctor.lastmod,
			),
		),
	];
}

async function buildDoctorFiltersSection(): Promise<SitemapLink[]> {
	const doctorFilters = await getDoctorSitemapFilters();

	return [
		...doctorFilters.specialtyIds.flatMap((facet) =>
			menuItemToLinks(
				'doctors',
				{ specialtyIds: facet.specialtyId },
				false,
				facet.lastmod,
			),
		),
		...doctorFilters.specialtyCityCombinations.flatMap((combo) =>
			menuItemToLinks(
				'doctors',
				{ specialtyIds: combo.specialtyId, cityIds: combo.cityId },
				false,
				combo.lastmod,
			),
		),
		...doctorFilters.specialtyLanguageCombinations.flatMap((combo) =>
			menuItemToLinks(
				'doctors',
				{ specialtyIds: combo.specialtyId, languageIds: combo.languageId },
				false,
				combo.lastmod,
			),
		),
	];
}

async function buildClinicsSection(): Promise<SitemapLink[]> {
	const clinics = await getClinicList();
	const clinicsWithReviews = await getSlugsWithReviews('clinic');

	// Подстраницы клиник (services/labtests/doctors) — только для
	// клиник, у которых элементов больше инлайнового порога: у остальных
	// подстраница 301-редиректится на якорь главной страницы клиники.
	const clinicSubpages = await getClinicSubpageSlugs();
	// Подстраница — срез карточки клиники, отдельной даты у неё нет: берём дату
	// самой клиники из уже загруженного списка, без второго запроса.
	const clinicLastmod = new Map(
		clinics.map((clinic) => [clinic.slug, clinic.lastmod]),
	);
	const buildSubpageLinks = (
		slugs: string[],
		type: 'services' | 'labtests' | 'doctors',
	): SitemapLink[] =>
		slugs.flatMap((slug) =>
			menuItemToLinks(
				`${SITE_URL}/clinics/${slug}/${type}`,
				{},
				true,
				clinicLastmod.get(slug),
			),
		);

	return [
		...clinics.flatMap((clinic) =>
			menuItemToLinks(
				`${SITE_URL}/clinics/${clinic.slug}`,
				{},
				true,
				clinic.lastmod,
			),
		),
		...clinicsWithReviews.flatMap((clinic) =>
			menuItemToLinks(
				`${SITE_URL}/clinics/${clinic.slug}/reviews`,
				{},
				true,
				clinic.lastmod,
			),
		),
		...buildSubpageLinks(clinicSubpages.services, 'services'),
		...buildSubpageLinks(clinicSubpages.labtests, 'labtests'),
		...buildSubpageLinks(clinicSubpages.doctors, 'doctors'),
	];
}

async function buildClinicFiltersSection(): Promise<SitemapLink[]> {
	const clinicFilters = await getClinicSitemapFilters(
		SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS,
	);

	return [
		...clinicFilters.cityIds.flatMap((facet) =>
			menuItemToLinks(
				'clinics',
				{ cityIds: facet.cityId },
				false,
				facet.lastmod,
			),
		),
		// Тип клиники: «Стоматологические клиники [в Будве]» — реальный
		// поисковый спрос; рейтинг/«открыто сейчас»/специализация в sitemap
		// сознательно НЕ включены (см. prd/clinic-catalog/PROGRESS.md)
		...clinicFilters.clinicTypeIds.flatMap((facet) =>
			menuItemToLinks(
				'clinics',
				{ clinicTypeIds: facet.clinicTypeId },
				false,
				facet.lastmod,
			),
		),
		...clinicFilters.typeCityCombinations.flatMap((combo) =>
			menuItemToLinks(
				'clinics',
				{ clinicTypeIds: combo.clinicTypeId, cityIds: combo.cityId },
				false,
				combo.lastmod,
			),
		),
	];
}

async function buildServicesSection(): Promise<SitemapLink[]> {
	const { items: medicalServices } = await getMedicalServiceList();
	const cityCombinations = await getServiceCityCombinations(
		SITEMAP_DETAIL_CITY_MIN_CLINICS,
	);
	// Справочный блок услуги живёт в отдельной таблице и правится отдельно от
	// самой услуги, поэтому дата — максимум из двух.
	const lastmod = await getSlugLastmodMap('medical_services', {
		name: 'medical_service_reference_info',
		foreignKey: 'medical_service_id',
	});

	return [
		...medicalServices.flatMap((service) =>
			menuItemToLinks(
				`${SITE_URL}/services/${service.slug}`,
				{},
				true,
				lastmod.get(service.slug),
			),
		),
		// Город-варианты деталей услуги: `/services/{slug}?cityIds={cityId}`,
		// только для пар, где у услуги есть ≥ SITEMAP_DETAIL_CITY_MIN_CLINICS
		// публичных клиник в городе.
		...cityCombinations.flatMap((combo) =>
			menuItemToLinks(
				`${SITE_URL}/services/${combo.slug}`,
				{ cityIds: combo.cityId },
				true,
				combo.lastmod,
			),
		),
	];
}

async function buildServiceFiltersSection(): Promise<SitemapLink[]> {
	const categoryIds = await getCategoryIdsWithServices();
	const categoryCityCombinations = await getServiceCategoryCityCombinations();

	return [
		...categoryIds.flatMap((facet) =>
			menuItemToLinks(
				'services',
				{ serviceCategoryIds: facet.categoryId },
				false,
				facet.lastmod,
			),
		),
		...categoryCityCombinations.flatMap((combo) =>
			menuItemToLinks(
				'services',
				{ serviceCategoryIds: combo.categoryId, cityIds: combo.cityId },
				false,
				combo.lastmod,
			),
		),
	];
}

async function buildLabTestsSection(): Promise<SitemapLink[]> {
	const { items: labTests } = await getLabTestList();
	const cityCombinations = await getLabTestCityCombinations(
		SITEMAP_DETAIL_CITY_MIN_CLINICS,
	);
	// Как и у услуг: справочный блок анализа правится отдельно от строки анализа.
	const lastmod = await getSlugLastmodMap('lab_tests', {
		name: 'lab_test_reference_info',
		foreignKey: 'lab_test_id',
	});

	return [
		...labTests.flatMap((labTest) =>
			menuItemToLinks(
				`${SITE_URL}/labtests/${labTest.slug}`,
				{},
				true,
				lastmod.get(labTest.slug),
			),
		),
		// Город-варианты деталей анализа: `/labtests/{slug}?cityIds={cityId}`,
		// только для пар, где у анализа есть ≥ SITEMAP_DETAIL_CITY_MIN_CLINICS
		// публичных клиник в городе.
		...cityCombinations.flatMap((combo) =>
			menuItemToLinks(
				`${SITE_URL}/labtests/${combo.slug}`,
				{ cityIds: combo.cityId },
				true,
				combo.lastmod,
			),
		),
	];
}

async function buildLabTestFiltersSection(): Promise<SitemapLink[]> {
	const categoryIds = await getCategoryIdsWithLabTests();
	const categoryCityCombinations = await getLabTestCategoryCityCombinations();

	return [
		...categoryIds.flatMap((facet) =>
			menuItemToLinks(
				'labtests',
				{ categoryIds: facet.categoryId },
				false,
				facet.lastmod,
			),
		),
		...categoryCityCombinations.flatMap((combo) =>
			menuItemToLinks(
				'labtests',
				{ categoryIds: combo.categoryId, cityIds: combo.cityId },
				false,
				combo.lastmod,
			),
		),
	];
}

async function buildMedicinesSection(): Promise<SitemapLink[]> {
	const { items: medicines } = await getMedicineList({ activeOnly: true });
	const lastmod = await getSlugLastmodMap('med_medicines');

	return medicines.flatMap((medicine) =>
		menuItemToLinks(
			`${SITE_URL}/medicines/${medicine.slug}`,
			{},
			true,
			lastmod.get(medicine.slug),
		),
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
		...medicineFilters.categoryIds.flatMap((facet) =>
			menuItemToLinks(
				'medicines',
				{ medicineCategoryIds: facet.categoryId },
				false,
				facet.lastmod,
			),
		),
		// «Что из этой категории можно купить без рецепта» — сильный отдельный
		// интент, но только там, где безрецептурные лекарства реально есть.
		...medicineFilters.otcCategoryIds.flatMap((facet) =>
			menuItemToLinks(
				'medicines',
				{
					medicineCategoryIds: facet.categoryId,
					dispensingModeIds: DispensingMode.OTC,
				},
				false,
				facet.lastmod,
			),
		),
		...medicineFilters.substanceAtcCombinations.flatMap((combo) =>
			menuItemToLinks(
				'medicines',
				{ substanceIds: combo.substanceId, atcGroupIds: combo.atcGroupId },
				false,
				combo.lastmod,
			),
		),
	];
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
/**
 * Состав секций в ключе кэша.
 *
 * Иначе снятие раздела оставляет в индексе ссылку на секцию, которой больше
 * нет: `parseSitemapSectionPath` её не узнаёт и отдаёт 404, а индекс из кэша
 * продолжает её рекламировать — до часа после выката, и Search Console это
 * записывает как ошибку. Ровно так и случилось при удалении `/medications`.
 *
 * Длина списка сюда не годится: переименование секции её не меняет. Берём
 * сами имена — ключ длинный, но кэш-запись одна.
 */
const SECTIONS_CACHE_KEY = SITEMAP_SECTIONS.join('.');

export const getSitemapIndex = defineCachedFunction(generateSitemapIndex, {
	name: 'sitemap',
	// Ключ намеренно НЕ 'sitemap.xml': под этим именем в `.data/cache` лежал
	// прежний монолит, и `swr` отдавал бы его вместо индекса.
	getKey: () => `sitemap-index.${SECTIONS_CACHE_KEY}.xml`,
	maxAge: 60 * 60,
	swr: true,
});
