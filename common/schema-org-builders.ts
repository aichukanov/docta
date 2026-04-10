import { SITE_NAME } from '~/common/constants';
import {
	normalizeFacebookUrl,
	normalizeInstagramUrl,
	normalizeTelegramUrl,
	normalizeWebsiteUrl,
	splitContacts,
} from '~/common/contacts';
import { getDoctorSpecialtySchemaOrgUrlById } from '~/common/schema-org-medical-specialty';
import {
	CLINIC_TYPE_MEDICAL_SPECIALTY,
	CLINIC_TYPE_SCHEMA_ORG,
	ClinicType,
} from '~/enums/clinic-type';
import { Language, LanguageId } from '~/enums/language';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';
import type {
	DayOfWeek,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';
import type {
	BreadcrumbListSchema,
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
 */
export function buildEntitySchemaBase<TType extends string>(options: {
	url: string;
	type: TType;
	fragment: string;
}) {
	return {
		'@type': options.type,
		'@id': `${options.url}#${options.fragment}`,
		'mainEntityOfPage': options.url,
		'url': options.url,
	};
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
		'url': `${options.baseUrl}${options.buildPath(item)}`,
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

export function getSchemaType(professionalTitle: string): {
	schemaType: PersonSchemaType;
	fragment: string;
} {
	if (!professionalTitle) {
		return {
			schemaType: 'ProfessionalService',
			fragment: 'professionalservice',
		};
	} else if (professionalTitle === 'mr ph') {
		return {
			// это только для аптекарей
			// schemaType: 'Pharmacist',
			// fragment: 'pharmacist',
			schemaType: 'ProfessionalService',
			fragment: 'professionalservice',
		};
	} else {
		return {
			schemaType: 'Physician',
			fragment: 'physician',
		};
	}
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
	},
): PersonListItemRef {
	const url = `${options.siteUrl}/doctors/${doctor.slug}`;
	const { schemaType, fragment } = getSchemaType(
		doctor.professionalTitle?.trim(),
	);

	// Build job titles from specialties
	const jobTitles = doctor.specialtyIds
		?.map((id) => options.getSpecialtyName(id))
		.filter(isNonEmptyString);

	return {
		'@type': schemaType,
		'@id': `${url}#${fragment}`,
		'name': doctor.name,
		'url': url,
		'image': doctor.photoUrl || undefined,
		'jobTitle': jobTitles && jobTitles.length > 0 ? jobTitles : undefined,
	};
}

/**
 * Build list item elements for doctors with Person/Physician type
 */
export function buildDoctorListItemElements(
	doctors:
		| Array<{
				id: number;
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
			{ siteUrl: options.siteUrl, getSpecialtyName: options.getSpecialtyName },
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
	getClinicSlug?: (id: number) => string | undefined;
}): { hasOfferCatalog?: object; knowsAbout?: object[] } {
	if (!options.clinicServices) {
		return {};
	}

	const offersWithPrice: object[] = [];
	const servicesWithoutPrice: Map<number, { id: number; name: string }> =
		new Map();

	// Iterate through all clinics and their services
	for (const [clinicIdStr, services] of Object.entries(
		options.clinicServices,
	)) {
		const clinicId = Number(clinicIdStr);
		const clinicSlug = options.getClinicSlug?.(clinicId) || String(clinicId);
		const clinicRef = `${options.siteUrl}/clinics/${clinicSlug}#medicalorganization`;

		for (const service of services) {
			const serviceUrl = `${options.siteUrl}/services/${service.slug}`;

			if (service.price && service.price > 0) {
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
					// Just reference to clinic @id (full data is in worksFor)
					'offeredBy': { '@id': clinicRef },
				});
			} else {
				// Service without price → add to knowsAbout (deduplicated)
				if (!servicesWithoutPrice.has(service.id)) {
					servicesWithoutPrice.set(service.id, {
						id: service.id,
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
	facebook?: string | null;
	instagram?: string | null;
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
	const honorificPrefix = options.title?.trim() || undefined;
	const { schemaType, fragment } = getSchemaType(honorificPrefix);

	// Build job titles for Person type
	const jobTitles =
		schemaType === 'ProfessionalService' || schemaType === 'Pharmacist'
			? options.specialtyIds
					?.map((id) => options.getSpecialtyName(id))
					.filter(isNonEmptyString)
			: [];

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
		getClinicSlug: (id) => options.clinics?.find((c) => c.id === id)?.slug,
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

	// Build reviews (skip reviews without text — they still count in AggregateRating)
	const reviews = options.reviews
		?.filter((review) => review.text)
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
			'provider': {
				'@type': 'Organization' as const,
				'name': review.provider,
			},
		}))
		.filter(Boolean);

	const doctorSchema = {
		...buildEntitySchemaBase({
			url: doctorUrl,
			type: schemaType,
			fragment,
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		address: options.clinics
			?.map((clinic) => buildClinicPostalAddress(clinic, options.getCityName))
			.filter(Boolean),
		image: options.photoUrl || undefined,
		honorificPrefix,
		medicalSpecialty: schemaType === 'Physician' ? specialties : undefined,
		jobTitle: jobTitles.length > 0 ? jobTitles : undefined,
		knowsLanguage: languages,
		sameAs: sameAs.length > 0 ? sameAs : undefined,
		worksFor: options.clinics?.map((clinic) => ({
			...buildMedicalOrganizationRef(clinic, options.siteUrl),
			'@id': `${options.siteUrl}/clinics/${clinic.slug}#medicalorganization`,
		})),
		hasOfferCatalog: servicesSchema.hasOfferCatalog,
		knowsAbout: servicesSchema.knowsAbout,
		aggregateRating,
		review: reviews && reviews.length > 0 ? reviews : undefined,
	};

	const webPageSchema = buildWebPageSchema({
		url: doctorUrl,
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

/**
 * Build hasOfferCatalog schema for clinic services
 */
function buildOfferCatalogSchema(options: {
	siteUrl: string;
	clinicId: number;
	services: ClinicServiceOffer[];
}): object | undefined {
	if (!options.services || options.services.length === 0) {
		return undefined;
	}

	const items = options.services.map((service) => {
		const priceInfo = service.clinicPrices?.find(
			(p) => p.clinicId === options.clinicId,
		);
		const serviceUrl = `${options.siteUrl}/services/${service.slug}`;

		const hasPrice = priceInfo?.price != null || priceInfo?.priceMin != null;

		// Услуга без цены → просто MedicalProcedure
		if (!hasPrice) {
			return {
				'@type': 'MedicalProcedure' as const,
				'@id': `${serviceUrl}#medicalprocedure`,
				'name': service.name,
				'url': serviceUrl,
			};
		}

		// price + priceMax → диапазон "100-120 евро"
		const hasPriceRange =
			priceInfo!.price != null && priceInfo!.priceMax != null;
		// priceMin (без priceMax) → "от 1200 евро"
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

		// Услуга с ценой → Offer
		return {
			'@type': 'Offer' as const,
			'itemOffered': {
				'@type': 'MedicalProcedure' as const,
				'@id': `${serviceUrl}#medicalprocedure`,
				'name': service.name,
				'url': serviceUrl,
			},
			'price':
				!hasPriceRange && !hasMinPriceOnly && priceInfo!.price
					? priceInfo!.price.toFixed(2)
					: undefined,
			'priceSpecification': priceSpecification,
			'priceCurrency': 'EUR',
			'url': serviceUrl,
		};
	});

	if (items.length === 0) {
		return undefined;
	}

	return {
		'@type': 'OfferCatalog' as const,
		'name': 'Medical Services',
		'itemListElement': items,
	};
}

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
	getCityName: (id: number) => string | undefined;
	services?: ClinicServiceOffer[];
	doctors?: ClinicDoctorItem[];
	workingHours?: WorkingHours | null;
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
		}),
		name: clinic.name,
		image: clinic.logoUrl || undefined,
		logo: clinic.logoUrl || undefined,
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
		hasOfferCatalog: buildOfferCatalogSchema({
			siteUrl,
			clinicId: clinic.id,
			services: options.services || [],
		}),
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
			const reviews = options.reviews
				?.filter((review) => review.text)
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
					'provider': {
						'@type': 'Organization' as const,
						'name': review.provider,
					},
				}))
				.filter(Boolean);
			return reviews && reviews.length > 0 ? reviews : undefined;
		})(),
	};

	const webPageSchema = buildWebPageSchema({
		url: clinicUrl,
		locale,
		name: options.pageTitle || clinic.name,
		description: options.pageDescription,
		mainEntityId: clinicSchema['@id'] as string,
	});

	return [webPageSchema, clinicSchema];
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
		options.clinicPrices?.filter((p) => p.price && p.price > 0) || [];

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
					'url': clinicUrl,
					'seller': {
						...buildMedicalOrganizationRef(clinic, options.siteUrl),
						'@id': `${clinicUrl}#medicalorganization`,
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

	const testSchema = {
		...buildEntitySchemaBase({
			url: testUrl,
			type: ['MedicalTest', 'Product'],
			fragment: 'medicaltest',
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		alternateName:
			alternateNames.length > 0 ? alternateNames.join(', ') : undefined,
		// Use availableAt to specify where the test is available
		availableAt: options.clinics?.map((clinic) =>
			buildMedicalOrganizationRef(clinic, options.siteUrl),
		),
		offers: buildOffersSchema({
			siteUrl: options.siteUrl,
			clinics: options.clinics,
			clinicPrices: options.clinicPrices,
			getCityName: options.getCityName,
		}),
	};

	const webPageSchema = buildWebPageSchema({
		url: testUrl,
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
	clinics?: ClinicData[];
	clinicPrices?: ClinicPrice[];
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const drugUrl = `${options.siteUrl}/medications/${options.slug}`;

	const drugSchema = {
		...buildEntitySchemaBase({
			url: drugUrl,
			type: ['Drug', 'Product'],
			fragment: 'drug',
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		// Use availableAt to specify pharmacies/clinics where drug is available
		availableAt: options.clinics?.map((clinic) =>
			buildMedicalOrganizationRef(clinic, options.siteUrl),
		),
		offers: buildOffersSchema({
			siteUrl: options.siteUrl,
			clinics: options.clinics,
			clinicPrices: options.clinicPrices,
			getCityName: options.getCityName,
		}),
	};

	const webPageSchema = buildWebPageSchema({
		url: drugUrl,
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
	substances?: string[];
	pharmaForm?: string | null;
	strength?: string | null;
	manufacturer?: string | null;
	country?: string | null;
	dispensingModeId?: number | null;
	atcCode?: string | null;
	isActive?: boolean;
	detailUrl?: string | null;
}): SchemaOrg[] {
	const medicineUrl = `${options.siteUrl}/medicines/${options.slug}`;

	const medicineSchema: Record<string, unknown> = {
		...buildEntitySchemaBase({
			url: medicineUrl,
			type: 'Drug',
			fragment: 'drug',
		}),
		name: options.name,
		description: options.pageDescription || undefined,
	};

	if (options.substances?.length) {
		medicineSchema.activeIngredient = options.substances.join(', ');
	}
	if (options.pharmaForm) {
		medicineSchema.dosageForm = options.pharmaForm;
	}
	if (options.strength) {
		medicineSchema.doseSchedule = {
			'@type': 'DoseSchedule',
			doseValue: options.strength,
		};
	}
	if (options.manufacturer) {
		medicineSchema.manufacturer = {
			'@type': 'Organization',
			name: options.manufacturer,
			...(options.country ? { address: { '@type': 'PostalAddress', addressCountry: options.country } } : {}),
		};
	}
	if (options.dispensingModeId) {
		medicineSchema.prescriptionStatus = options.dispensingModeId === 2
			? 'OTC' : 'PrescriptionOnly';
	}
	if (options.atcCode) {
		medicineSchema.code = {
			'@type': 'MedicalCode',
			codingSystem: 'ATC',
			codeValue: options.atcCode,
		};
	}
	if (options.isActive != null) {
		medicineSchema.legalStatus = options.isActive ? 'ActivelyMarketed' : 'WithdrawnFromMarket';
	}
	if (options.detailUrl) {
		medicineSchema.sameAs = options.detailUrl;
	}

	const webPageSchema = buildWebPageSchema({
		url: medicineUrl,
		locale: options.locale,
		name: options.pageTitle,
		description: options.pageDescription,
		mainEntityId: medicineSchema['@id'] as string,
	});

	return [webPageSchema, medicineSchema];
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
	clinics?: ClinicData[];
	clinicPrices?: ClinicPrice[];
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const procedureUrl = `${options.siteUrl}/services/${options.slug}`;

	const procedureSchema = {
		...buildEntitySchemaBase({
			url: procedureUrl,
			type: ['MedicalProcedure', 'Product'],
			fragment: 'medicalprocedure',
		}),
		name: options.name,
		description: options.pageDescription || undefined,
		// Use availableAt to specify clinics where procedure is performed
		availableAt: options.clinics?.map((clinic) =>
			buildMedicalOrganizationRef(clinic, options.siteUrl),
		),
		offers: buildOffersSchema({
			siteUrl: options.siteUrl,
			clinics: options.clinics,
			clinicPrices: options.clinicPrices,
			getCityName: options.getCityName,
		}),
	};

	const webPageSchema = buildWebPageSchema({
		url: procedureUrl,
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
	totalCount: number;
	doctors?: Array<{
		id: number;
		name: string;
		photoUrl?: string;
		professionalTitle?: string;
		specialtyIds?: string;
	}>;
	getSpecialtyName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const pageId = `${options.pageUrl}#webpage`;
	const itemListId = `${options.pageUrl}#itemlist`;

	const pageSchema: WebPageSchema = {
		'@type': 'MedicalWebPage',
		'@id': pageId,
		'url': options.pageUrl,
		'name': options.title,
		'description': options.description,
		'inLanguage': options.locale,
		'mainEntity': { '@id': itemListId },
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

	const itemListSchema: ItemListSchema = {
		'@type': 'ItemList',
		'@id': itemListId,
		'name': options.title,
		'description': options.description,
		'numberOfItems': options.totalCount,
		'itemListElement': buildDoctorListItemElements(options.doctors, {
			siteUrl: options.siteUrl,
			getSpecialtyName: options.getSpecialtyName,
		}),
	};

	return [pageSchema, itemListSchema];
}
