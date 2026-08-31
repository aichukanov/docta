import { SITE_NAME } from '~/common/constants';
import {
	normalizeFacebookUrl,
	normalizeInstagramUrl,
	normalizeTelegramUrl,
	normalizeWebsiteUrl,
	splitContacts,
} from '~/common/contacts';
import { getDoctorSpecialtySchemaOrgUrlById } from '~/common/schema-org-medical-specialty';
import { getRegionalUrl } from '~/common/url-utils';
import {
	CLINIC_TYPE_MEDICAL_SPECIALTY,
	CLINIC_TYPE_SCHEMA_ORG,
	ClinicType,
} from '~/enums/clinic-type';
import { Language, LanguageId } from '~/enums/language';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';
import type {
	InsuranceBranchData,
	InsuranceCompanyData,
} from '~/interfaces/insurance-company';
import type {
	DayOfWeek,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';
import type {
	BreadcrumbListSchema,
	InsuranceAgencySchema,
	ItemListSchema,
	ListItemSchema,
	MedicalOrganizationRef,
	MedicalOrganizationType,
	MedicalSpecialtySchema,
	PersonListItemRef,
	PersonSchemaType,
	PostalAddressSchema,
	SchemaOrg,
	WebPageSchema,
} from '~/types/schema-org';

// Маппинг ID языков на ISO 639-1 коды
const LANGUAGE_CODES: Record<number, string> = {
	[LanguageId.SR]: Language.SR,
	[LanguageId.EN]: Language.EN,
	[LanguageId.RU]: Language.RU,
	[LanguageId.DE]: Language.DE,
	[LanguageId.TR]: Language.TR,
	[LanguageId.IT]: Language.IT,
	[LanguageId.FR]: Language.FR,
};

export const getLanguageCode = (id: number): string | undefined =>
	LANGUAGE_CODES[id];

const isNonEmptyString = (value: unknown): value is string =>
	typeof value === 'string' && value.length > 0;

/**
 * В JSON-LD попадают только собственные отзывы docta.me: разметка
 * сторонних (google_maps, facebook и т.п.) нарушает гайдлайны Google
 * для review snippets («ratings must be sourced directly from users»)
 * и рискует ручной санкцией за spammy structured markup. В UI сторонние
 * отзывы остаются — фильтр касается только разметки.
 */
export const SCHEMA_REVIEWS_PROVIDER = 'docta_me';

export function filterSchemaReviews<T extends { provider: string }>(
	reviews: T[] | undefined,
): T[] {
	return (reviews || []).filter(
		(review) => review.provider === SCHEMA_REVIEWS_PROVIDER,
	);
}

/**
 * Цены с пометкой «устаревшая» (`isOutdated`) в разметку НЕ попадают ни в каком
 * виде.
 *
 * На странице такая цена рисуется как «45 € +X% ⓘ» с оговоркой в тултипе, а в
 * JSON-LD уходило точное число — то есть разметка обещала цену, которой на
 * странице нет. Для Google это spammy structured markup с риском ручной
 * санкции; ровно по той же причине устаревшие цены уже вычищены из
 * meta description на странице врача.
 *
 * Оговорка: цена при этом не исчезает из UI — фильтр касается только разметки,
 * как и в случае со сторонними отзывами (см. SCHEMA_REVIEWS_PROVIDER).
 */
function isSchemaOfferPrice(
	price: number | null | undefined,
	isOutdated?: boolean,
): price is number {
	return price != null && price > 0 && !isOutdated;
}

/**
 * Build social media sameAs links from contacts
 */
export function buildSameAs(contacts: {
	facebook?: string | null;
	instagram?: string | null;
	telegram?: string | null;
}): string[] {
	const sameAs: string[] = [];

	for (const value of splitContacts(contacts.facebook)) {
		sameAs.push(normalizeFacebookUrl(value));
	}
	for (const value of splitContacts(contacts.instagram)) {
		sameAs.push(normalizeInstagramUrl(value));
	}
	for (const value of splitContacts(contacts.telegram)) {
		sameAs.push(normalizeTelegramUrl(value));
	}

	return sameAs;
}

/**
 * Build postal address schema from clinic data
 */
export function buildClinicPostalAddress(
	clinic: ClinicData,
	getCityName: (id: number) => string | undefined,
): PostalAddressSchema | undefined {
	if (!clinic.address) {
		return undefined;
	}

	const cityName = clinic.cityId ? getCityName(clinic.cityId) : undefined;
	const town = typeof clinic.town === 'string' ? clinic.town.trim() : '';
	const postalCode =
		typeof clinic.postalCode === 'string' ? clinic.postalCode.trim() : '';

	return {
		'@type': 'PostalAddress',
		'addressCountry': 'ME',
		'streetAddress': clinic.address,
		'addressLocality': town || cityName || undefined,
		'addressRegion': town ? cityName || undefined : undefined,
		'postalCode': postalCode || undefined,
	};
}

/**
 * Build postal address schema from an insurance company branch — same field
 * mapping as buildClinicPostalAddress, mirrored because InsuranceBranchData
 * isn't a ClinicData (it has no clinicTypeIds/languageIds/etc).
 */
export function buildInsuranceBranchAddress(
	branch: InsuranceBranchData,
	getCityName: (id: number) => string | undefined,
): PostalAddressSchema | undefined {
	if (!branch.address) {
		return undefined;
	}

	const cityName = branch.cityId ? getCityName(branch.cityId) : undefined;
	const town = typeof branch.town === 'string' ? branch.town.trim() : '';
	const postalCode =
		typeof branch.postalCode === 'string' ? branch.postalCode.trim() : '';

	return {
		'@type': 'PostalAddress',
		'addressCountry': 'ME',
		'streetAddress': branch.address,
		'addressLocality': town || cityName || undefined,
		'addressRegion': town ? cityName || undefined : undefined,
		'postalCode': postalCode || undefined,
	};
}

/**
 * Get the primary Schema.org @type for a clinic based on its type IDs.
 * Uses the first type ID for the primary @type.
 */
export function getClinicSchemaOrgType(
	clinicTypeIds?: string,
): MedicalOrganizationType {
	if (!clinicTypeIds) return 'MedicalOrganization';
	const firstTypeId = Number(clinicTypeIds.split(',')[0]);
	if (!firstTypeId) return 'MedicalOrganization';
	return (
		(CLINIC_TYPE_SCHEMA_ORG[
			firstTypeId as ClinicType
		] as MedicalOrganizationType) || 'MedicalOrganization'
	);
}

/**
 * Build medicalSpecialty array from clinic type IDs.
 */
function buildClinicMedicalSpecialties(
	clinicTypeIds?: string,
): MedicalSpecialtySchema[] | undefined {
	if (!clinicTypeIds) return undefined;
	const typeIds = clinicTypeIds.split(',').map(Number).filter(Boolean);
	const specialties = typeIds
		.map((id) => {
			const specialty = CLINIC_TYPE_MEDICAL_SPECIALTY[id as ClinicType];
			if (!specialty) return null;
			return {
				'@type': 'MedicalSpecialty' as const,
				'@id': `https://schema.org/${specialty}`,
				'name': specialty,
			};
		})
		.filter(Boolean) as MedicalSpecialtySchema[];
	return specialties.length > 0 ? specialties : undefined;
}

/**
 * Build entity schema base with common fields
 *
 * `mainEntityOfPage` / `url` обязаны совпадать с rel=canonical страницы, а он
 * зависит от локали (`?lang=ru` и т.п.). Без этого на пяти локалях из шести
 * разметка утверждала одну страницу, а canonical — другую. `pageUrl` приходит
 * из `getCanonicalUrl` — единственной точки сборки canonical.
 *
 * `@id` при этом СОЗНАТЕЛЬНО остаётся безлокальным: это идентификатор узла в
 * графе, на который ссылаются с других страниц (`memberOf`, `seller`,
 * `employee`, `offeredBy`). Локализуй его — и ссылки перестанут сходиться
 * ровно так же, как они не сходились из-за захардкоженного `#medicalorganization`.
 */
export function buildEntitySchemaBase<
	TType extends string | string[],
>(options: {
	url: string;
	type: TType;
	fragment: string;
	/** Канонический URL страницы с локалью; по умолчанию — URL сущности */
	pageUrl?: string;
}) {
	const canonicalUrl = options.pageUrl || options.url;
	return {
		'@type': options.type,
		'@id': `${options.url}#${options.fragment}`,
		'mainEntityOfPage': canonicalUrl,
		'url': canonicalUrl,
	};
}

/**
 * `@id` узла клиники. Фрагмент обязан совпадать с тем, что клиника ставит себе
 * на собственной странице (`buildEntitySchemaBase` + `getClinicSchemaOrgType`):
 * у реальной клиники это `#dentist`, `#hospital`, `#pharmacy`…, а не
 * `#medicalorganization` — общий тип возвращается только когда типов нет вовсе.
 * Пока фрагмент был захардкожен, `worksFor` / `seller` / `offeredBy` висели на
 * несуществующих узлах.
 */
export function buildClinicNodeId(
	clinic: Pick<ClinicData, 'slug' | 'clinicTypeIds'>,
	siteUrl: string,
): string {
	const fragment = getClinicSchemaOrgType(clinic.clinicTypeIds).toLowerCase();
	return `${siteUrl}/clinics/${clinic.slug}#${fragment}`;
}

/**
 * URL сущности в нужной локали. Сборка URL — только через `url-utils`
 * (`getRegionalUrl`, тот же, на котором стоит `getCanonicalUrl`): свой конкат
 * `?lang=` уже приводил к расхождению порядка параметров с canonical.
 */
function localizeEntityUrl(url: string, locale?: string): string {
	return locale ? getRegionalUrl(url, {}, locale) : url;
}

/**
 * Breadcrumb item for building breadcrumbs schema
 */
export interface BreadcrumbItem {
	name: string;
	url?: string;
}

/**
 * Build BreadcrumbList schema for structured data
 */
export function buildBreadcrumbsSchema(
	pageUrl: string,
	items: BreadcrumbItem[],
): BreadcrumbListSchema {
	return {
		'@type': 'BreadcrumbList',
		'@id': `${pageUrl}#breadcrumbs`,
		'itemListElement': items.map((item, index) => ({
			'@type': 'ListItem' as const,
			'position': index + 1,
			'name': item.name,
			'item': item.url,
		})),
	};
}

/**
 * Build list item elements for top items
 */
export function buildTopListItemElements<
	TItem extends { id: number; name: string },
>(
	items: TItem[] | undefined,
	options: {
		baseUrl: string;
		buildPath: (item: TItem) => string;
		limit?: number;
		/** Локаль страницы: ссылка обязана вести на canonical той же локали */
		locale?: string;
	},
): ListItemSchema[] | undefined {
	if (!items) {
		return undefined;
	}

	const limit = options.limit ?? 10;
	return items.slice(0, limit).map((item, index) => ({
		'@type': 'ListItem' as const,
		'position': index + 1,
		'name': item.name,
		'url': localizeEntityUrl(
			`${options.baseUrl}${options.buildPath(item)}`,
			options.locale,
		),
	}));
}

/**
 * Doctor data for building person schema reference
 */
export interface DoctorSchemaData {
	id: number;
	slug: string;
	name: string;
	photoUrl?: string;
	professionalTitle?: string;
	specialtyIds?: number[];
}

/**
 * Тип узла врача — всегда `Physician`.
 *
 * Раньше врач без звания (и «mr ph») размечался как `ProfessionalService` —
 * потомок `LocalBusiness`, то есть разметка утверждала, что живой человек это
 * бизнес-услуга, и при этом вешала на него свойства с доменом `Person`
 * (`honorificPrefix`, `jobTitle`, `worksFor`).
 *
 * Из двух валидных вариантов (`Physician` или `Person`) выбран `Physician`:
 * в schema.org это `MedicalOrganization` / `MedicalBusiness`, что нормально
 * для врача как места приёма, и главное — только на нём допустимы
 * `aggregateRating` и `review` (их домен — Organization/Place/Product, но не
 * Person). Отзывы о враче у нас есть и работают в сниппете, а `Person` их бы
 * обнулил. Плата за выбор — свойства домена Person здесь не используются,
 * см. `buildDoctorSchema`.
 *
 * Отдельного типа `Pharmacist` в schema.org нет (потому и был закомментирован),
 * поэтому аптекари идут тем же узлом.
 *
 * Параметр сохранён: он больше не влияет на результат, но точка выбора типа
 * и фрагмента `@id` должна оставаться одна на весь проект.
 */
export function getSchemaType(professionalTitle?: string): {
	schemaType: PersonSchemaType;
	fragment: string;
} {
	return {
		schemaType: 'Physician',
		fragment: 'physician',
	};
}

/**
 * Build Person/Physician schema reference for a doctor
 * Used in both list pages and detail pages
 */
export function buildPersonSchemaRef(
	doctor: DoctorSchemaData,
	options: {
		siteUrl: string;
		getSpecialtyName: (id: number) => string | undefined;
		/** Локаль страницы: ссылка обязана вести на canonical той же локали */
		locale?: string;
	},
): PersonListItemRef & { medicalSpecialty?: MedicalSpecialtySchema[] } {
	const url = `${options.siteUrl}/doctors/${doctor.slug}`;
	const { schemaType, fragment } = getSchemaType(
		doctor.professionalTitle?.trim(),
	);

	// Специальности вместо `jobTitle`: узел врача — `Physician`, а домен
	// `jobTitle` — только Person (см. getSchemaType)
	const specialties = (doctor.specialtyIds
		?.map((id) => buildMedicalSpecialtySchema(id, options.getSpecialtyName))
		.filter(Boolean) || []) as MedicalSpecialtySchema[];

	return {
		'@type': schemaType,
		// `@id` безлокальный — на него ссылаются с других страниц
		'@id': `${url}#${fragment}`,
		'name': doctor.name,
		'url': localizeEntityUrl(url, options.locale),
		'image': doctor.photoUrl || undefined,
		'medicalSpecialty': specialties.length > 0 ? specialties : undefined,
	};
}

/**
 * Build list item elements for doctors with Person/Physician type
 */
export function buildDoctorListItemElements(
	doctors:
		| Array<{
				id: number;
				slug: string;
				name: string;
				photoUrl?: string;
				professionalTitle?: string;
				specialtyIds?: string;
		  }>
		| undefined,
	options: {
		siteUrl: string;
		limit?: number;
		getSpecialtyName: (id: number) => string | undefined;
		locale?: string;
	},
): ListItemSchema[] | undefined {
	if (!doctors) {
		return undefined;
	}

	const limit = options.limit ?? 10;
	return doctors.slice(0, limit).map((doctor, index) => {
		// Convert string specialtyIds to number array
		const specialtyIds = doctor.specialtyIds
			?.split(',')
			.map((id) => Number(id));

		const personRef = buildPersonSchemaRef(
			{ ...doctor, specialtyIds },
			{
				siteUrl: options.siteUrl,
				getSpecialtyName: options.getSpecialtyName,
				locale: options.locale,
			},
		);

		return {
			'@type': 'ListItem' as const,
			'position': index + 1,
			'item': personRef,
		};
	});
}

/**
 * Build collection page schemas (for list pages)
 */
export function buildCollectionPageSchemas(options: {
	pageUrl: string;
	locale: string;
	title: string;
	description: string;
	numberOfItems: number;
	itemListElement?: ListItemSchema[];
	pageType?: 'CollectionPage' | 'SearchResultsPage';
}): SchemaOrg[] {
	const pageId = `${options.pageUrl}#webpage`;
	const itemListId = `${options.pageUrl}#itemlist`;

	const pageSchema: WebPageSchema = {
		'@type': options.pageType || 'CollectionPage',
		'@id': pageId,
		'url': options.pageUrl,
		'name': options.title,
		'description': options.description,
		'inLanguage': options.locale,
		'mainEntity': { '@id': itemListId },
	};

	const itemListSchema: ItemListSchema = {
		'@type': 'ItemList',
		'@id': itemListId,
		'name': options.title,
		'description': options.description,
		'numberOfItems': options.numberOfItems,
		'itemListElement': options.itemListElement,
	};

	return [pageSchema, itemListSchema];
}

/**
 * Build entity list schema for list pages
 */
export function buildEntityListSchema<
	TItem extends { id: number; name: string },
>(options: {
	siteUrl: string;
	pageUrl: string;
	locale: string;
	title: string;
	description: string;
	totalCount: number;
	items?: TItem[];
	buildPath: (item: TItem) => string;
	isFiltered?: boolean;
}): SchemaOrg[] {
	return buildCollectionPageSchemas({
		pageUrl: options.pageUrl,
		locale: options.locale,
		title: options.title,
		description: options.description,
		pageType: options.isFiltered ? 'SearchResultsPage' : 'CollectionPage',
		numberOfItems: options.totalCount,
		itemListElement: buildTopListItemElements(options.items, {
			baseUrl: options.siteUrl,
			buildPath: options.buildPath,
			locale: options.locale,
		}),
	});
}

/**
 * Build doctor list schema with Person/Physician types
 */
export function buildDoctorListSchema(options: {
	siteUrl: string;
	pageUrl: string;
	locale: string;
	title: string;
	description: string;
	totalCount: number;
	doctors?: Array<{
		id: number;
		slug: string;
		name: string;
		photoUrl?: string;
		professionalTitle?: string;
		specialtyIds?: string;
	}>;
	isFiltered?: boolean;
	getSpecialtyName: (id: number) => string | undefined;
}): SchemaOrg[] {
	return buildCollectionPageSchemas({
		pageUrl: options.pageUrl,
		locale: options.locale,
		title: options.title,
		description: options.description,
		pageType: options.isFiltered ? 'SearchResultsPage' : 'CollectionPage',
		numberOfItems: options.totalCount,
		itemListElement: buildDoctorListItemElements(options.doctors, {
			siteUrl: options.siteUrl,
			getSpecialtyName: options.getSpecialtyName,
			locale: options.locale,
		}),
	});
}

/**
 * Build WebPage schema wrapper for entity pages
 */
export function buildWebPageSchema(options: {
	url: string;
	locale: string;
	name: string;
	description?: string;
	mainEntityId: string;
}): WebPageSchema {
	return {
		'@type': 'WebPage',
		'@id': `${options.url}#webpage`,
		'url': options.url,
		'name': options.name,
		'description': options.description,
		'inLanguage': options.locale,
		'mainEntity': { '@id': options.mainEntityId },
	};
}

/**
 * Build medical specialty schema
 */
export function buildMedicalSpecialtySchema(
	id: number,
	getSpecialtyName: (id: number) => string | undefined,
): MedicalSpecialtySchema | null {
	const url = getDoctorSpecialtySchemaOrgUrlById(id);
	if (!url) {
		return null;
	}

	return {
		'@type': 'MedicalSpecialty',
		'@id': url,
		'name': getSpecialtyName(id),
	};
}

/**
 * Build minimal medical organization reference from clinic data.
 * Full clinic details live on the clinic's own page — here we only
 * provide enough context for search engines to identify the entity.
 */
export function buildMedicalOrganizationRef(
	clinic: ClinicData,
	siteUrl: string,
): MedicalOrganizationRef {
	const website = normalizeWebsiteUrl(clinic.website);
	return {
		'@type': getClinicSchemaOrgType(clinic.clinicTypeIds),
		'name': clinic.name,
		'url': `${siteUrl}/clinics/${clinic.slug}`,
		'sameAs': website ? [website] : undefined,
	};
}

/**
 * Doctor service item for schema
 */
export interface DoctorServiceItem {
	id: number;
	slug: string;
	name: string;
	price: number | null;
	priceMax?: number | null;
	/** Цена помечена как устаревшая — см. ClinicPrice.isOutdated */
	isOutdated?: boolean;
}

/**
 * Doctor clinic services map
 */
export interface DoctorClinicServicesMap {
	[clinicId: number]: DoctorServiceItem[];
}

/**
 * Build hasOfferCatalog and knowsAbout for doctor services
 * Uses @id references to clinics (defined in worksFor) to avoid duplication
 */
function buildDoctorServicesSchema(options: {
	siteUrl: string;
	clinicServices?: DoctorClinicServicesMap;
	getClinic?: (id: number) => ClinicData | undefined;
}): { hasOfferCatalog?: object; knowsAbout?: object[] } {
	if (!options.clinicServices) {
		return {};
	}

	const offersWithPrice: object[] = [];
	const servicesWithoutPrice: Map<
		number,
		{ id: number; slug: string; name: string }
	> = new Map();

	// Iterate through all clinics and their services
	for (const [clinicIdStr, services] of Object.entries(
		options.clinicServices,
	)) {
		const clinicId = Number(clinicIdStr);
		const clinic = options.getClinic?.(clinicId);
		const clinicRef = clinic
			? buildClinicNodeId(clinic, options.siteUrl)
			: `${options.siteUrl}/clinics/${clinicId}#medicalorganization`;

		for (const service of services) {
			const serviceUrl = `${options.siteUrl}/services/${service.slug}`;

			if (isSchemaOfferPrice(service.price, service.isOutdated)) {
				// Service with price → add to hasOfferCatalog
				const hasPriceRange =
					service.priceMax && service.priceMax !== service.price;

				offersWithPrice.push({
					'@type': 'Offer',
					'itemOffered': {
						'@type': 'MedicalProcedure',
						'@id': `${serviceUrl}#medicalprocedure`,
						'name': service.name,
						'url': serviceUrl,
					},
					'price': hasPriceRange ? undefined : service.price.toFixed(2),
					'priceSpecification': hasPriceRange
						? {
								'@type': 'PriceSpecification',
								'minPrice': service.price.toFixed(2),
								'maxPrice': service.priceMax!.toFixed(2),
								'priceCurrency': 'EUR',
							}
						: undefined,
					'priceCurrency': 'EUR',
					'availability': 'https://schema.org/InStock',
					// Just reference to clinic @id (full data is in memberOf)
					'offeredBy': { '@id': clinicRef },
				});
			} else {
				// Service without price → add to knowsAbout (deduplicated)
				if (!servicesWithoutPrice.has(service.id)) {
					servicesWithoutPrice.set(service.id, {
						id: service.id,
						slug: service.slug,
						name: service.name,
					});
				}
			}
		}
	}

	const result: { hasOfferCatalog?: object; knowsAbout?: object[] } = {};

	// Build hasOfferCatalog if there are offers with prices
	if (offersWithPrice.length > 0) {
		result.hasOfferCatalog = {
			'@type': 'OfferCatalog',
			'name': 'Medical Services',
			'itemListElement': offersWithPrice,
		};
	}

	// Build knowsAbout for services without prices
	if (servicesWithoutPrice.size > 0) {
		result.knowsAbout = Array.from(servicesWithoutPrice.values()).map(
			(service) => ({
				'@type': 'MedicalProcedure',
				'@id': `${options.siteUrl}/services/${service.slug}#medicalprocedure`,
				'name': service.name,
				'url': `${options.siteUrl}/services/${service.slug}`,
			}),
		);
	}

	return result;
}

/**
 * Build physician/person schema for doctor page
 */
export function buildDoctorSchema(options: {
	siteUrl: string;
	id: number;
	slug: string;
	name: string;
	photoUrl?: string;
	specialtyIds?: number[];
	languageIds?: number[];
	clinics?: ClinicData[];
	clinicServices?: DoctorClinicServicesMap;
	title?: string;
	locale: string;
	pageTitle?: string;
	pageDescription?: string;
	/** Канонический URL страницы (с ?lang= и т.п.); по умолчанию — URL сущности */
	pageUrl?: string;
	facebook?: string | null;
	instagram?: string | null;
	/**
	 * Рейтинг ТОЛЬКО по собственным отзывам docta.me. Агрегат по сторонним
	 * провайдерам сюда передавать нельзя (см. SCHEMA_REVIEWS_PROVIDER).
	 */
	rating?: { averageRating: number | null; totalReviews: number } | null;
	reviews?: Array<{
		id: number;
		text: string;
		rating?: number;
		author?: { name: string; photoUrl?: string };
		publishedAt?: string;
		provider: string;
	}>;
	getSpecialtyName: (id: number) => string | undefined;
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const doctorUrl = `${options.siteUrl}/doctors/${options.slug}`;
	const { schemaType, fragment } = getSchemaType(options.title?.trim());

	// Build medical specialties for Physician type
	const specialties =
		(options.specialtyIds
			?.map((id) => buildMedicalSpecialtySchema(id, options.getSpecialtyName))
			.filter(Boolean) as MedicalSpecialtySchema[]) || [];

	// Build language codes
	const languages = options.languageIds
		?.map((id) => getLanguageCode(id))
		.filter(isNonEmptyString);

	// Build social media links
	const sameAs = buildSameAs({
		facebook: options.facebook,
		instagram: options.instagram,
	});

	// Build services schema (hasOfferCatalog and knowsAbout)
	const servicesSchema = buildDoctorServicesSchema({
		siteUrl: options.siteUrl,
		clinicServices: options.clinicServices,
		getClinic: (id) => options.clinics?.find((c) => c.id === id),
	});

	// Build aggregate rating
	let aggregateRating: object | undefined;
	if (
		options.rating &&
		options.rating.averageRating &&
		options.rating.totalReviews > 0
	) {
		aggregateRating = {
			'@type': 'AggregateRating' as const,
			'ratingValue': options.rating.averageRating.toFixed(1),
			'reviewCount': options.rating.totalReviews,
		};
	}

	// Build reviews (only own docta.me reviews, skip ones without text)
	const reviews = filterSchemaReviews(options.reviews)
		.filter((review) => review.text)
		.map((review) => ({
			'@type': 'Review' as const,
			'author': review.author
				? {
						'@type': 'Person' as const,
						'name': review.author.name,
					}
				: undefined,
			'reviewRating': review.rating
				? {
						'@type': 'Rating' as const,
						'ratingValue': review.rating,
					}
				: undefined,
			'reviewBody': review.text,
			'datePublished': review.publishedAt || undefined,
		}));

	// Набор свойств собран под домен `Physician` (см. getSchemaType):
	// `honorificPrefix` и `jobTitle` выброшены — их домен только Person, а
	// звание и специальности и без них есть в `name`/`description` страницы и
	// в `medicalSpecialty`. `worksFor` (тоже Person) заменён на `memberOf`,
	// он допустим у Organization и означает ровно то же — врач приписан к
	// клинике. `knowsLanguage` оставлен: его домен Person И Organization.
	const doctorSchema = {
		...buildEntitySchemaBase({
			url: doctorUrl,
			type: schemaType,
			fragment,
			pageUrl: options.pageUrl,
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		address: options.clinics
			?.map((clinic) => buildClinicPostalAddress(clinic, options.getCityName))
			.filter(Boolean),
		image: options.photoUrl || undefined,
		medicalSpecialty: specialties.length > 0 ? specialties : undefined,
		knowsLanguage: languages,
		sameAs: sameAs.length > 0 ? sameAs : undefined,
		memberOf: options.clinics?.map((clinic) => ({
			...buildMedicalOrganizationRef(clinic, options.siteUrl),
			'@id': buildClinicNodeId(clinic, options.siteUrl),
		})),
		hasOfferCatalog: servicesSchema.hasOfferCatalog,
		knowsAbout: servicesSchema.knowsAbout,
		aggregateRating,
		review: reviews && reviews.length > 0 ? reviews : undefined,
	};

	const webPageSchema = buildWebPageSchema({
		url: options.pageUrl || doctorUrl,
		locale: options.locale,
		name: options.pageTitle || options.name,
		description: options.pageDescription,
		mainEntityId: doctorSchema['@id'] as string,
	});

	return [webPageSchema, doctorSchema];
}

/**
 * Service item for clinic offer catalog
 */
export interface ClinicServiceOffer {
	id: number;
	slug: string;
	name: string;
	clinicPrices?: ClinicPrice[];
}

/**
 * Doctor item for clinic employee schema
 */
export interface ClinicDoctorItem {
	id: number;
	slug: string;
	professionalTitle?: string;
}

/**
 * Build employee references for clinic schema
 */
function buildEmployeeRefs(
	doctors: ClinicDoctorItem[],
	siteUrl: string,
): Array<{ '@id': string }> {
	return doctors.map((doctor) => {
		const { fragment } = getSchemaType(doctor.professionalTitle?.trim());
		return { '@id': `${siteUrl}/doctors/${doctor.slug}#${fragment}` };
	});
}

interface OfferCatalogTypeConfig {
	itemType: 'MedicalProcedure' | 'MedicalTest' | 'Drug';
	fragment: string;
	urlPrefix: string;
	catalogName: string;
}

/**
 * Build hasOfferCatalog schema for a clinic item type
 * (medical services / lab tests / medications).
 */
function buildOfferCatalogSchema(options: {
	siteUrl: string;
	clinicId: number;
	items: ClinicServiceOffer[];
	config: OfferCatalogTypeConfig;
}): object | undefined {
	if (!options.items || options.items.length === 0) {
		return undefined;
	}

	// Устаревшая цена для разметки всё равно что её отсутствие — см.
	// isSchemaOfferPrice: такой элемент уходит в каталог без Offer
	const usablePrice = (item: ClinicServiceOffer) => {
		const priceInfo = item.clinicPrices?.find(
			(p) => p.clinicId === options.clinicId,
		);
		return priceInfo && !priceInfo.isOutdated ? priceInfo : undefined;
	};

	// Limit to 10 items, prioritizing ones with prices
	const sorted = [...options.items].sort((a, b) => {
		const aPrice = usablePrice(a);
		const bPrice = usablePrice(b);
		const aHasPrice = aPrice?.price != null || aPrice?.priceMin != null;
		const bHasPrice = bPrice?.price != null || bPrice?.priceMin != null;
		if (aHasPrice !== bHasPrice) return aHasPrice ? -1 : 1;
		return 0;
	});
	const limited = sorted.slice(0, 10);

	const { itemType, fragment, urlPrefix } = options.config;
	const itemListElement = limited.map((service) => {
		const priceInfo = usablePrice(service);
		const serviceUrl = `${options.siteUrl}/${urlPrefix}/${service.slug}`;

		const hasPrice = priceInfo?.price != null || priceInfo?.priceMin != null;

		if (!hasPrice) {
			return {
				'@type': itemType,
				'@id': `${serviceUrl}#${fragment}`,
				'name': service.name,
				'url': serviceUrl,
			};
		}

		const hasPriceRange =
			priceInfo!.price != null && priceInfo!.priceMax != null;
		const hasMinPriceOnly =
			priceInfo!.priceMin != null && priceInfo!.priceMax == null;

		let priceSpecification: object | undefined;
		if (hasPriceRange) {
			priceSpecification = {
				'@type': 'PriceSpecification' as const,
				'minPrice': priceInfo!.price!.toFixed(2),
				'maxPrice': priceInfo!.priceMax!.toFixed(2),
				'priceCurrency': 'EUR',
			};
		} else if (hasMinPriceOnly) {
			priceSpecification = {
				'@type': 'PriceSpecification' as const,
				'minPrice': priceInfo!.priceMin!.toFixed(2),
				'priceCurrency': 'EUR',
			};
		}

		return {
			'@type': 'Offer' as const,
			'itemOffered': {
				'@type': itemType,
				'@id': `${serviceUrl}#${fragment}`,
				'name': service.name,
				'url': serviceUrl,
			},
			'price':
				!hasPriceRange && !hasMinPriceOnly && priceInfo!.price
					? priceInfo!.price.toFixed(2)
					: undefined,
			'priceSpecification': priceSpecification,
			'priceCurrency': 'EUR',
			'availability': 'https://schema.org/InStock',
			'url': serviceUrl,
		};
	});

	if (itemListElement.length === 0) {
		return undefined;
	}

	return {
		'@type': 'OfferCatalog' as const,
		'name': options.config.catalogName,
		'itemListElement': itemListElement,
	};
}

const SERVICES_CATALOG_CONFIG: OfferCatalogTypeConfig = {
	itemType: 'MedicalProcedure',
	fragment: 'medicalprocedure',
	urlPrefix: 'services',
	catalogName: 'Medical Services',
};
const LABTESTS_CATALOG_CONFIG: OfferCatalogTypeConfig = {
	itemType: 'MedicalTest',
	fragment: 'medicaltest',
	urlPrefix: 'labtests',
	catalogName: 'Lab Tests',
};
const MEDICATIONS_CATALOG_CONFIG: OfferCatalogTypeConfig = {
	itemType: 'Drug',
	fragment: 'drug',
	urlPrefix: 'medications',
	catalogName: 'Medications',
};

const SCHEMA_DAY_MAP: Record<DayOfWeek, string> = {
	monday: 'Monday',
	tuesday: 'Tuesday',
	wednesday: 'Wednesday',
	thursday: 'Thursday',
	friday: 'Friday',
	saturday: 'Saturday',
	sunday: 'Sunday',
};

function buildOpeningHoursSpecification(workingHours: WorkingHours) {
	const specs: any[] = [];

	for (const day of DAYS_OF_WEEK) {
		const ds = workingHours[day];
		if (ds.type === '24/7') {
			specs.push({
				'@type': 'OpeningHoursSpecification',
				'dayOfWeek': SCHEMA_DAY_MAP[day],
				'opens': '00:00',
				'closes': '23:59',
			});
		} else if (ds.type === 'regular' && ds.intervals?.length) {
			for (const interval of ds.intervals) {
				specs.push({
					'@type': 'OpeningHoursSpecification',
					'dayOfWeek': SCHEMA_DAY_MAP[day],
					'opens': interval.start,
					'closes': interval.end,
				});
			}
		}
	}

	return specs.length > 0 ? specs : undefined;
}

/**
 * Build clinic (medical organization) schema
 */
export function buildClinicSchema(options: {
	siteUrl: string;
	clinic: ClinicData;
	locale: string;
	pageTitle?: string;
	pageDescription?: string;
	/** Канонический URL страницы (с ?lang= и т.п.); по умолчанию — URL сущности */
	pageUrl?: string;
	getCityName: (id: number) => string | undefined;
	services?: ClinicServiceOffer[];
	labTests?: ClinicServiceOffer[];
	medications?: ClinicServiceOffer[];
	doctors?: ClinicDoctorItem[];
	workingHours?: WorkingHours | null;
	/**
	 * Рейтинг ТОЛЬКО по собственным отзывам docta.me. Агрегат по сторонним
	 * провайдерам сюда передавать нельзя (см. SCHEMA_REVIEWS_PROVIDER).
	 */
	rating?: { averageRating: number | null; totalReviews: number } | null;
	reviews?: Array<{
		id: number;
		text: string;
		rating?: number;
		author?: { name: string; photoUrl?: string };
		publishedAt?: string;
		provider: string;
	}>;
}): SchemaOrg[] {
	const { siteUrl, clinic, locale, getCityName } = options;
	const clinicUrl = `${siteUrl}/clinics/${clinic.slug}`;

	const socialLinks = buildSameAs({
		facebook: clinic.facebook,
		instagram: clinic.instagram,
		telegram: clinic.telegram,
	});

	const sameAs: string[] = [];
	const website = normalizeWebsiteUrl(clinic.website);
	if (website) {
		sameAs.push(website);
	}
	sameAs.push(...socialLinks);

	const availableLanguage = clinic.languageIds
		?.split(',')
		.map((id) => Number(id))
		.map((id) => getLanguageCode(id))
		.filter(Boolean) as string[] | undefined;

	const schemaOrgType = getClinicSchemaOrgType(clinic.clinicTypeIds);
	const medicalSpecialties = buildClinicMedicalSpecialties(
		clinic.clinicTypeIds,
	);

	const clinicSchema = {
		...buildEntitySchemaBase({
			url: clinicUrl,
			type: schemaOrgType,
			fragment: schemaOrgType.toLowerCase(),
			pageUrl: options.pageUrl,
		}),
		name: clinic.name,
		image: clinic.logoUrl ? `${siteUrl}${clinic.logoUrl}` : undefined,
		logo: clinic.logoUrl ? `${siteUrl}${clinic.logoUrl}` : undefined,
		description: options.pageDescription || undefined,
		address: buildClinicPostalAddress(clinic, getCityName),
		medicalSpecialty: medicalSpecialties,
		telephone: splitContacts(clinic.phone)[0] || undefined,
		email: splitContacts(clinic.email)[0] || undefined,
		sameAs: sameAs.length > 0 ? sameAs : undefined,
		geo:
			clinic.latitude && clinic.longitude
				? {
						'@type': 'GeoCoordinates' as const,
						'latitude': clinic.latitude,
						'longitude': clinic.longitude,
					}
				: undefined,
		availableLanguage:
			availableLanguage && availableLanguage.length > 0
				? availableLanguage
				: undefined,
		openingHoursSpecification: options.workingHours
			? buildOpeningHoursSpecification(options.workingHours)
			: undefined,
		hasOfferCatalog: (() => {
			const catalogs = [
				buildOfferCatalogSchema({
					siteUrl,
					clinicId: clinic.id,
					items: options.services || [],
					config: SERVICES_CATALOG_CONFIG,
				}),
				buildOfferCatalogSchema({
					siteUrl,
					clinicId: clinic.id,
					items: options.labTests || [],
					config: LABTESTS_CATALOG_CONFIG,
				}),
				buildOfferCatalogSchema({
					siteUrl,
					clinicId: clinic.id,
					items: options.medications || [],
					config: MEDICATIONS_CATALOG_CONFIG,
				}),
			].filter(Boolean);
			if (catalogs.length === 0) return undefined;
			return catalogs.length === 1 ? catalogs[0] : catalogs;
		})(),
		employee:
			options.doctors && options.doctors.length > 0
				? buildEmployeeRefs(options.doctors, siteUrl)
				: undefined,
		aggregateRating:
			options.rating &&
			options.rating.averageRating &&
			options.rating.totalReviews > 0
				? {
						'@type': 'AggregateRating' as const,
						'ratingValue': options.rating.averageRating.toFixed(1),
						'reviewCount': options.rating.totalReviews,
					}
				: undefined,
		review: (() => {
			// Only own docta.me reviews, skip ones without text
			const reviews = filterSchemaReviews(options.reviews)
				.filter((review) => review.text)
				.map((review) => ({
					'@type': 'Review' as const,
					'author': review.author
						? {
								'@type': 'Person' as const,
								'name': review.author.name,
							}
						: undefined,
					'reviewRating': review.rating
						? {
								'@type': 'Rating' as const,
								'ratingValue': review.rating,
							}
						: undefined,
					'reviewBody': review.text,
					'datePublished': review.publishedAt || undefined,
				}));
			return reviews.length > 0 ? reviews : undefined;
		})(),
	};

	const webPageSchema = buildWebPageSchema({
		url: options.pageUrl || clinicUrl,
		locale,
		name: options.pageTitle || clinic.name,
		description: options.pageDescription,
		mainEntityId: clinicSchema['@id'] as string,
	});

	return [webPageSchema, clinicSchema];
}

/**
 * Build InsuranceAgency schema for an insurance company page. Unlike a
 * clinic (one address), an insurer has several offices across Montenegro —
 * schema.org models this via `location`, an array of InsuranceAgency nodes
 * each with their own address/geo/telephone (see types/schema-org.ts).
 */
export function buildInsuranceCompanySchema(options: {
	siteUrl: string;
	company: InsuranceCompanyData;
	locale: string;
	pageTitle?: string;
	pageDescription?: string;
	pageUrl?: string;
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const { siteUrl, company, locale, getCityName } = options;
	const companyUrl = `${siteUrl}/insurance-companies/${company.slug}`;

	const socialLinks = buildSameAs({
		facebook: company.facebook,
		instagram: company.instagram,
		telegram: company.telegram,
	});

	const sameAs: string[] = [];
	const website = normalizeWebsiteUrl(company.website);
	if (website) {
		sameAs.push(website);
	}
	sameAs.push(...socialLinks);

	const companySchema: InsuranceAgencySchema = {
		...buildEntitySchemaBase({
			url: companyUrl,
			type: 'InsuranceAgency',
			fragment: 'insuranceagency',
			pageUrl: options.pageUrl,
		}),
		name: company.name,
		image: company.logoUrl ? `${siteUrl}${company.logoUrl}` : undefined,
		logo: company.logoUrl ? `${siteUrl}${company.logoUrl}` : undefined,
		description: options.pageDescription || undefined,
		telephone: splitContacts(company.phone)[0] || undefined,
		email: splitContacts(company.email)[0] || undefined,
		sameAs: sameAs.length > 0 ? sameAs : undefined,
		location: company.branches.map((branch) => ({
			'@type': 'InsuranceAgency' as const,
			'address': buildInsuranceBranchAddress(branch, getCityName),
			'geo':
				branch.latitude && branch.longitude
					? {
							'@type': 'GeoCoordinates' as const,
							'latitude': branch.latitude,
							'longitude': branch.longitude,
						}
					: undefined,
			'telephone': branch.phone || splitContacts(company.phone)[0] || undefined,
		})),
	};

	const webPageSchema = buildWebPageSchema({
		url: options.pageUrl || companyUrl,
		locale,
		name: options.pageTitle || company.name,
		description: options.pageDescription,
		mainEntityId: companySchema['@id'] as string,
	});

	return [webPageSchema, companySchema];
}

/**
 * Добавляет `Product` вторым типом только когда есть чем его наполнить.
 *
 * Google требует у `Product` хотя бы одно из `offers` / `review` /
 * `aggregateRating`. Медицинские типы (`MedicalTest`, `Drug`,
 * `MedicalProcedure`) своих обязательных полей не имеют, поэтому карточка без
 * цен раньше отдавала пустой `Product` — в GSC это 758 недопустимых элементов
 * («Описания товара», росло с 271 в январе 2026), и такие страницы выпадали из
 * расширенного сниппета, который у сайта реально работает (1384 показа за
 * 3 месяца). См. пункт 11 в docs/audit/seo-2026-07.md.
 *
 * `aggregateRating` сюда не подставить: отзывы у нас про клинику, а не про
 * услугу — это была бы неправда в разметке.
 */
function withProductType(baseType: string, offers: unknown): string | string[] {
	return offers ? [baseType, 'Product'] : baseType;
}

/**
 * Build offers schema for products/services
 */
export function buildOffersSchema(options: {
	siteUrl: string;
	clinics?: ClinicData[];
	clinicPrices?: ClinicPrice[];
	getCityName: (id: number) => string | undefined;
}) {
	const validPrices =
		options.clinicPrices?.filter((p) =>
			isSchemaOfferPrice(p.price, p.isOutdated),
		) || [];

	if (validPrices.length === 0) {
		return undefined;
	}

	// Собираем все цены (включая priceMax) для расчёта диапазона
	const allPrices: number[] = [];
	for (const p of validPrices) {
		allPrices.push(p.price as number);
		if (p.priceMax && p.priceMax > 0) {
			allPrices.push(p.priceMax);
		}
	}
	const lowPrice = Math.min(...allPrices);
	const highPrice = Math.max(...allPrices);

	return {
		'@type': 'AggregateOffer' as const,
		'lowPrice': lowPrice.toFixed(2),
		'highPrice': highPrice.toFixed(2),
		'priceCurrency': 'EUR',
		'offerCount': validPrices.length.toString(),
		'offers': validPrices
			.map((priceItem) => {
				const clinic = options.clinics?.find(
					(c) => c.id === priceItem.clinicId,
				);
				if (!clinic) return null;

				const clinicUrl = `${options.siteUrl}/clinics/${clinic.slug}`;
				const price = priceItem.price as number;
				const priceMax = priceItem.priceMax;

				// Если есть priceMax и он отличается от price — используем priceSpecification
				const hasPriceRange = priceMax && priceMax !== price;

				return {
					'@type': 'Offer' as const,
					'price': hasPriceRange ? undefined : price.toFixed(2),
					'priceCurrency': hasPriceRange ? undefined : 'EUR',
					'priceSpecification': hasPriceRange
						? {
								'@type': 'PriceSpecification' as const,
								'minPrice': price.toFixed(2),
								'maxPrice': priceMax.toFixed(2),
								'priceCurrency': 'EUR',
							}
						: undefined,
					'availability': 'https://schema.org/InStock',
					'url': clinicUrl,
					'seller': {
						...buildMedicalOrganizationRef(clinic, options.siteUrl),
						'@id': buildClinicNodeId(clinic, options.siteUrl),
						'url': clinicUrl,
					},
				};
			})
			.filter(Boolean),
	};
}

/**
 * Build MedicalTest schema for lab test pages
 */
export function buildMedicalTestSchema(options: {
	siteUrl: string;
	id: number;
	slug: string;
	name: string;
	localName?: string;
	synonyms?: string[];
	locale: string;
	pageTitle: string;
	pageDescription?: string;
	/** Канонический URL страницы (с ?lang= и т.п.); по умолчанию — URL сущности */
	pageUrl?: string;
	clinics?: ClinicData[];
	clinicPrices?: ClinicPrice[];
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const testUrl = `${options.siteUrl}/labtests/${options.slug}`;

	// Build alternateName from localName and synonyms
	const alternateNames: string[] = [];
	if (options.localName && options.localName !== options.name) {
		alternateNames.push(options.localName);
	}
	if (options.synonyms?.length) {
		alternateNames.push(...options.synonyms);
	}

	const offers = buildOffersSchema({
		siteUrl: options.siteUrl,
		clinics: options.clinics,
		clinicPrices: options.clinicPrices,
		getCityName: options.getCityName,
	});

	const testSchema = {
		...buildEntitySchemaBase({
			url: testUrl,
			type: withProductType('MedicalTest', offers),
			fragment: 'medicaltest',
			pageUrl: options.pageUrl,
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		alternateName:
			alternateNames.length > 0 ? alternateNames.join(', ') : undefined,
		offers,
	};

	const webPageSchema = buildWebPageSchema({
		url: options.pageUrl || testUrl,
		locale: options.locale,
		name: options.pageTitle,
		description: options.pageDescription,
		mainEntityId: testSchema['@id'] as string,
	});

	return [webPageSchema, testSchema];
}

/**
 * Build Drug schema for medication pages
 */
export function buildDrugSchema(options: {
	siteUrl: string;
	id: number;
	slug: string;
	name: string;
	locale: string;
	pageTitle: string;
	pageDescription?: string;
	/** Канонический URL страницы (с ?lang= и т.п.); по умолчанию — URL сущности */
	pageUrl?: string;
	clinics?: ClinicData[];
	clinicPrices?: ClinicPrice[];
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const drugUrl = `${options.siteUrl}/medications/${options.slug}`;

	const offers = buildOffersSchema({
		siteUrl: options.siteUrl,
		clinics: options.clinics,
		clinicPrices: options.clinicPrices,
		getCityName: options.getCityName,
	});

	const drugSchema = {
		...buildEntitySchemaBase({
			url: drugUrl,
			type: withProductType('Drug', offers),
			fragment: 'drug',
			pageUrl: options.pageUrl,
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		offers,
	};

	const webPageSchema = buildWebPageSchema({
		url: options.pageUrl || drugUrl,
		locale: options.locale,
		name: options.pageTitle,
		description: options.pageDescription,
		mainEntityId: drugSchema['@id'] as string,
	});

	return [webPageSchema, drugSchema];
}

/**
 * Build Drug schema for /medicines/ detail pages (CInMED register)
 */
export function buildMedicineSchema(options: {
	siteUrl: string;
	slug: string;
	name: string;
	locale: string;
	pageTitle: string;
	pageDescription?: string;
	/** Канонический URL страницы (с ?lang= и т.п.); по умолчанию — URL сущности */
	pageUrl?: string;
	substances?: string[];
	/** Зарубежные торговые названия того же вещества → schema.org alternateName */
	alternateName?: string[];
	pharmaForm?: string | null;
	strength?: string | null;
	manufacturer?: string | null;
	country?: string | null;
	dispensingModeId?: number | null;
	atcCode?: string | null;
	isActive?: boolean;
	// `sameAs` на карточку cinmed.me сознательно НЕ отдаём: id в их URL
	// (`?id=567`) не стабилен — сверка 2026-08-28 показала, что все 8 проверенных
	// id из нашего скрейпа (апрель 2026) на живом сайте открывают другие
	// препараты. Неверный `sameAs` заявляет поисковику тождество сущностей,
	// поэтому лучше никакого. Ссылка в UI ведёт на корень cinmed.me.
}): SchemaOrg[] {
	const medicineUrl = `${options.siteUrl}/medicines/${options.slug}`;

	const medicineSchema: Record<string, unknown> = {
		...buildEntitySchemaBase({
			url: medicineUrl,
			type: 'Drug',
			fragment: 'drug',
			pageUrl: options.pageUrl,
		}),
		name: options.name,
		description: options.pageDescription || undefined,
	};

	if (options.substances?.length) {
		medicineSchema.activeIngredient = options.substances.join(', ');
	}
	if (options.alternateName?.length) {
		medicineSchema.alternateName = options.alternateName;
	}
	if (options.pharmaForm) {
		medicineSchema.dosageForm = options.pharmaForm;
	}
	if (options.strength) {
		medicineSchema.doseSchedule = {
			'@type': 'DoseSchedule',
			'doseValue': options.strength,
		};
	}
	if (options.manufacturer) {
		medicineSchema.manufacturer = {
			'@type': 'Organization',
			'name': options.manufacturer,
			...(options.country
				? {
						address: {
							'@type': 'PostalAddress',
							'addressCountry': options.country,
						},
					}
				: {}),
		};
	}
	if (options.dispensingModeId) {
		medicineSchema.prescriptionStatus =
			options.dispensingModeId === 2 ? 'OTC' : 'PrescriptionOnly';
	}
	if (options.atcCode) {
		medicineSchema.code = {
			'@type': 'MedicalCode',
			'codingSystem': 'ATC',
			'codeValue': options.atcCode,
		};
	}
	if (options.isActive != null) {
		medicineSchema.legalStatus = options.isActive
			? 'ActivelyMarketed'
			: 'WithdrawnFromMarket';
	}
	const webPageSchema = buildWebPageSchema({
		url: options.pageUrl || medicineUrl,
		locale: options.locale,
		name: options.pageTitle,
		description: options.pageDescription,
		mainEntityId: medicineSchema['@id'] as string,
	});

	return [webPageSchema, medicineSchema as SchemaOrg];
}

/**
 * Build MedicalProcedure schema for medical service pages
 */
export function buildMedicalProcedureSchema(options: {
	siteUrl: string;
	id: number;
	slug: string;
	name: string;
	locale: string;
	pageTitle: string;
	pageDescription?: string;
	/** Канонический URL страницы (с ?lang= и т.п.); по умолчанию — URL сущности */
	pageUrl?: string;
	clinics?: ClinicData[];
	clinicPrices?: ClinicPrice[];
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const procedureUrl = `${options.siteUrl}/services/${options.slug}`;

	const offers = buildOffersSchema({
		siteUrl: options.siteUrl,
		clinics: options.clinics,
		clinicPrices: options.clinicPrices,
		getCityName: options.getCityName,
	});

	const procedureSchema = {
		...buildEntitySchemaBase({
			url: procedureUrl,
			type: withProductType('MedicalProcedure', offers),
			fragment: 'medicalprocedure',
			pageUrl: options.pageUrl,
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		offers,
	};

	const webPageSchema = buildWebPageSchema({
		url: options.pageUrl || procedureUrl,
		locale: options.locale,
		name: options.pageTitle,
		description: options.pageDescription,
		mainEntityId: procedureSchema['@id'] as string,
	});

	return [webPageSchema, procedureSchema];
}

/**
 * Build MedicalWebPage schema with ItemList (similar to doctor list schema)
 * Used for medical article pages like "Russian-speaking doctors in Montenegro"
 */
export function buildMedicalWebPageSchema(options: {
	siteUrl: string;
	pageUrl: string;
	locale: string;
	title: string;
	description?: string;
	image?: string;
	datePublished?: string;
	dateModified?: string;
	lastReviewed?: string;
	// Списочная часть опциональна: прозаические статьи отдают
	// только MedicalWebPage без mainEntity/ItemList
	totalCount?: number;
	doctors?: Array<{
		id: number;
		slug: string;
		name: string;
		photoUrl?: string;
		professionalTitle?: string;
		specialtyIds?: string;
	}>;
	getSpecialtyName?: (id: number) => string | undefined;
}): SchemaOrg[] {
	const pageId = `${options.pageUrl}#webpage`;
	const itemListId = `${options.pageUrl}#itemlist`;
	const { totalCount, doctors } = options;
	const hasItemList = totalCount != null && doctors != null;

	const pageSchema: WebPageSchema = {
		'@type': 'MedicalWebPage',
		'@id': pageId,
		'url': options.pageUrl,
		'name': options.title,
		'description': options.description,
		'inLanguage': options.locale,
		...(hasItemList ? { mainEntity: { '@id': itemListId } } : {}),
		'author': {
			'@type': 'Organization',
			'name': SITE_NAME,
			'url': options.siteUrl,
		},
		'datePublished': options.datePublished,
		'dateModified': options.dateModified,
		'lastReviewed': options.lastReviewed,
		'image': options.image,
	};

	if (totalCount == null || doctors == null) {
		return [pageSchema];
	}

	const itemListSchema: ItemListSchema = {
		'@type': 'ItemList',
		'@id': itemListId,
		'name': options.title,
		'description': options.description,
		'numberOfItems': totalCount,
		'itemListElement': buildDoctorListItemElements(doctors, {
			siteUrl: options.siteUrl,
			getSpecialtyName: options.getSpecialtyName ?? (() => undefined),
			locale: options.locale,
		}),
	};

	return [pageSchema, itemListSchema];
}
