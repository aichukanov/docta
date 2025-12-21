import type {
	SchemaOrg,
	PostalAddressSchema,
	ListItemSchema,
	ItemListSchema,
	WebPageSchema,
	MedicalOrganizationRef,
	MedicalSpecialtySchema,
	BreadcrumbListSchema,
} from '~/types/schema-org';
import type { ClinicData } from '~/interfaces/clinic';
import {
	normalizeWebsiteUrl,
	splitContacts,
	normalizeFacebookUrl,
	normalizeInstagramUrl,
	normalizeTelegramUrl,
} from '~/common/contacts';
import { Language, LanguageId } from '~/enums/language';
import { getDoctorSpecialtySchemaOrgUrlById } from '~/common/schema-org-medical-specialty';

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
 * Build WebPage schema wrapper for entity pages
 */
export function buildWebPageSchema(options: {
	url: string;
	locale: string;
	name: string;
	mainEntityId: string;
}): WebPageSchema {
	return {
		'@type': 'WebPage',
		'@id': `${options.url}#webpage`,
		'url': options.url,
		'name': options.name,
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
 * Build medical organization reference from clinic data
 */
export function buildMedicalOrganizationRef(
	clinic: ClinicData,
	getCityName: (id: number) => string | undefined,
): MedicalOrganizationRef {
	const sameAs = buildSameAs({
		facebook: clinic.facebook,
		instagram: clinic.instagram,
		telegram: clinic.telegram,
	});

	return {
		'@type': 'MedicalOrganization',
		'name': clinic.name,
		'url': normalizeWebsiteUrl(clinic.website) || undefined,
		'telephone': splitContacts(clinic.phone)[0] || undefined,
		'email': splitContacts(clinic.email)[0] || undefined,
		'sameAs': sameAs.length > 0 ? sameAs : undefined,
		'address': buildClinicPostalAddress(clinic, getCityName),
	};
}

/**
 * Build physician/person schema for doctor page
 */
export function buildDoctorSchema(options: {
	siteUrl: string;
	id: number;
	name: string;
	photoUrl?: string;
	specialtyIds?: number[];
	languageIds?: number[];
	clinics?: ClinicData[];
	title?: string;
	locale: string;
	getSpecialtyName: (id: number) => string | undefined;
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const doctorUrl = `${options.siteUrl}/doctors/${options.id}`;
	const honorificPrefix = options.title?.trim() || undefined;
	const schemaType = honorificPrefix ? 'Physician' : 'Person';

	// Build job titles for Person type
	const jobTitles =
		schemaType === 'Person'
			? options.specialtyIds
					?.map((id) => options.getSpecialtyName(id))
					.filter(isNonEmptyString)
			: undefined;

	// Build medical specialties for Physician type
	const specialties = options.specialtyIds
		?.map((id) => buildMedicalSpecialtySchema(id, options.getSpecialtyName))
		.filter(Boolean) as MedicalSpecialtySchema[] | undefined;

	// Build language codes
	const languages = options.languageIds
		?.map((id) => getLanguageCode(id))
		.filter(isNonEmptyString);

	const doctorSchema = {
		...buildEntitySchemaBase({
			url: doctorUrl,
			type: schemaType,
			fragment: schemaType === 'Physician' ? 'physician' : 'person',
		}),
		name: options.name,
		image: options.photoUrl || undefined,
		honorificPrefix,
		medicalSpecialty: schemaType === 'Physician' ? specialties : undefined,
		jobTitle:
			schemaType === 'Person'
				? jobTitles && jobTitles.length > 0
					? jobTitles
					: undefined
				: undefined,
		knowsLanguage: languages,
		worksFor: options.clinics?.map((clinic) =>
			buildMedicalOrganizationRef(clinic, options.getCityName),
		),
	};

	const webPageSchema = buildWebPageSchema({
		url: doctorUrl,
		locale: options.locale,
		name: options.name,
		mainEntityId: doctorSchema['@id'] as string,
	});

	return [webPageSchema, doctorSchema];
}

/**
 * Build clinic (medical organization) schema
 */
export function buildClinicSchema(options: {
	siteUrl: string;
	clinic: ClinicData;
	locale: string;
	getCityName: (id: number) => string | undefined;
}): SchemaOrg[] {
	const { siteUrl, clinic, locale, getCityName } = options;
	const clinicUrl = `${siteUrl}/clinics/${clinic.id}`;

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

	const clinicSchema = {
		...buildEntitySchemaBase({
			url: clinicUrl,
			type: 'MedicalOrganization' as const,
			fragment: 'medicalorganization',
		}),
		name: clinic.name,
		address: buildClinicPostalAddress(clinic, getCityName),
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
	};

	const webPageSchema = buildWebPageSchema({
		url: clinicUrl,
		locale,
		name: clinic.name,
		mainEntityId: clinicSchema['@id'] as string,
	});

	return [webPageSchema, clinicSchema];
}
