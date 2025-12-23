/**
 * Schema.org types for structured data
 */

export type PersonSchemaType = 'Physician' | 'Pharmacist' | 'Person';

export interface SchemaOrgBase {
	'@context'?: string;
	'@type': string | string[];
	'@id'?: string;
	'inLanguage'?: string;
	[key: string]: unknown;
}

export interface PostalAddressSchema {
	'@type': 'PostalAddress';
	'addressCountry': 'ME';
	'addressLocality'?: string;
	'addressRegion'?: string;
	'postalCode'?: string;
	'streetAddress'?: string;
}

export interface OrganizationSchema extends SchemaOrgBase {
	'@type': 'Organization' | 'MedicalBusiness';
	'name': string;
	'url'?: string;
	'logo'?: string;
	'description'?: string;
	'address'?: PostalAddressSchema;
}

export interface WebSiteSchema extends SchemaOrgBase {
	'@type': 'WebSite';
	'name': string;
	'url': string;
	'potentialAction'?: {
		'@type': 'SearchAction';
		'target': string;
		'query-input': string;
	};
}

export interface MedicalSpecialtySchema extends SchemaOrgBase {
	'@type': 'MedicalSpecialty';
	'@id': string;
	'name'?: string;
}

export interface MedicalOrganizationRef {
	'@type': 'MedicalOrganization';
	'name': string;
	'address'?: PostalAddressSchema;
	'telephone'?: string;
	'email'?: string;
	'url'?: string;
	'sameAs'?: string[];
	'knowsLanguage'?: string[];
}

export interface PhysicianSchema extends SchemaOrgBase {
	'@type': 'Physician' | 'Person';
	'name': string;
	'url'?: string;
	'image'?: string;
	'honorificPrefix'?: string;
	'medicalSpecialty'?: MedicalSpecialtySchema | MedicalSpecialtySchema[];
	'jobTitle'?: string | string[];
	'worksFor'?: MedicalOrganizationRef[];
	'knowsLanguage'?: string[];
}

export interface GeoCoordinatesSchema {
	'@type': 'GeoCoordinates';
	'latitude': number;
	'longitude': number;
}

export interface MedicalOrganizationSchema extends SchemaOrgBase {
	'@type': 'MedicalOrganization';
	'name': string;
	'image'?: string;
	'address'?: PostalAddressSchema;
	'telephone'?: string;
	'email'?: string;
	'url'?: string;
	'sameAs'?: string[];
	'geo'?: GeoCoordinatesSchema;
	'openingHoursSpecification'?: {
		'@type': 'OpeningHoursSpecification';
		'dayOfWeek': string[];
		'opens'?: string;
		'closes'?: string;
	};
	'availableLanguage'?: string[];
}

export interface MedicalTestSchema extends SchemaOrgBase {
	'@type': 'MedicalTest';
	'name': string;
	'url'?: string;
	'alternateName'?: string;
	'description'?: string;
	'usedToDiagnose'?: string;
	'availableService'?: {
		'@type': 'MedicalOrganization';
		'name': string;
	}[];
}

export interface DrugSchema extends SchemaOrgBase {
	'@type': 'Drug';
	'name': string;
	'url'?: string;
	'description'?: string;
	'availableService'?: {
		'@type': 'MedicalOrganization';
		'name': string;
	}[];
}

export interface MedicalProcedureSchema extends SchemaOrgBase {
	'@type': 'MedicalProcedure';
	'name': string;
	'url'?: string;
	'description'?: string;
	'howPerformed'?: string;
	'availableService'?: {
		'@type': 'MedicalOrganization';
		'name': string;
	}[];
}

/**
 * Compact person reference for list items
 */
export interface PersonListItemRef {
	'@type': SchemaType;
	'@id': string;
	'name': string;
	'url': string;
	'image'?: string;
	'jobTitle'?: string | string[];
}

export interface ListItemSchema {
	'@type': 'ListItem';
	'position': number;
	'name'?: string;
	'url'?: string;
	'item'?: string | PersonListItemRef;
}

export interface ItemListSchema extends SchemaOrgBase {
	'@type': 'ItemList';
	'name': string;
	'description'?: string;
	'numberOfItems': number;
	'itemListElement'?: ListItemSchema[];
}

export interface BreadcrumbListSchema extends SchemaOrgBase {
	'@type': 'BreadcrumbList';
	'itemListElement': ListItemSchema[];
}

export interface WebPageSchema extends SchemaOrgBase {
	'@type': 'WebPage' | 'CollectionPage' | 'SearchResultsPage' | 'AboutPage';
	'name': string;
	'description'?: string;
	'url'?: string;
	'mainEntity'?: { '@id': string };
	'isPartOf'?: {
		'@type': 'WebSite';
		'name': string;
		'url': string;
	};
	'about'?: {
		'@type': 'Organization' | 'MedicalBusiness';
		'name': string;
		'url'?: string;
	};
}

export type SchemaOrg =
	| OrganizationSchema
	| WebSiteSchema
	| PhysicianSchema
	| MedicalOrganizationSchema
	| MedicalTestSchema
	| DrugSchema
	| MedicalProcedureSchema
	| ItemListSchema
	| BreadcrumbListSchema
	| WebPageSchema
	| SchemaOrgBase;
