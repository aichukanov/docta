import type { ClinicData } from '~/interfaces/clinic';
import {
	normalizeWebsiteUrl,
	splitContacts,
	normalizeFacebookUrl,
	normalizeInstagramUrl,
	normalizeTelegramUrl,
} from '~/common/contacts';
import { Language, LanguageId } from '~/enums/language';
import specialtyI18n from '~/i18n/specialty';
import cityI18n from '~/i18n/city';

// Английские названия из i18n (канонические для schema.org)
const specialtyMessagesEn = specialtyI18n.messages.en;
const cityMessagesEn = cityI18n.messages.en;

const getSpecialtyNameEn = (id: number): string | undefined =>
	specialtyMessagesEn[`specialty_${id}`];

const getCityNameEn = (id: number): string | undefined =>
	cityMessagesEn[`city_${id}`];

// Маппинг ID языков на ISO 639-1 коды (используем существующие enum'ы)
const LANGUAGE_CODES: Record<number, string> = {
	[LanguageId.SR]: Language.SR,
	[LanguageId.EN]: Language.EN,
	[LanguageId.RU]: Language.RU,
	[LanguageId.DE]: Language.DE,
	[LanguageId.TR]: Language.TR,
	[LanguageId.IT]: Language.IT,
	[LanguageId.FR]: Language.FR,
};

const getLanguageCode = (id: number): string | undefined => LANGUAGE_CODES[id];

interface SchemaOrgBase {
	'@context': string;
	'@type': string | string[];
	[key: string]: unknown;
}

interface OrganizationSchema extends SchemaOrgBase {
	'@type': 'Organization' | 'MedicalBusiness';
	'name': string;
	'url'?: string;
	'logo'?: string;
	'description'?: string;
	'address'?: {
		'@type': 'PostalAddress';
		'addressCountry': string;
		'addressLocality'?: string;
		'streetAddress'?: string;
	};
}

interface WebSiteSchema extends SchemaOrgBase {
	'@type': 'WebSite';
	'name': string;
	'url': string;
	'potentialAction'?: {
		'@type': 'SearchAction';
		'target': string;
		'query-input': string;
	};
}

interface PhysicianSchema extends SchemaOrgBase {
	'@type': 'Physician';
	'name': string;
	'url'?: string;
	'image'?: string;
	'honorificPrefix'?: string;
	'medicalSpecialty'?: string | string[];
	'worksFor'?: {
		'@type': 'MedicalOrganization';
		'name': string;
		'address'?: {
			'@type': 'PostalAddress';
			'streetAddress': string;
			'addressLocality'?: string;
			'addressCountry': string;
		};
		'telephone'?: string;
		'email'?: string;
		'url'?: string;
		'sameAs'?: string[];
	}[];
	'knowsLanguage'?: string[];
}

interface MedicalOrganizationSchema extends SchemaOrgBase {
	'@type': 'MedicalOrganization';
	'name': string;
	'image'?: string;
	'address'?: {
		'@type': 'PostalAddress';
		'addressCountry': string;
		'addressLocality'?: string;
		'streetAddress'?: string;
	};
	'telephone'?: string;
	'email'?: string;
	'url'?: string;
	'sameAs'?: string[];
	'geo'?: {
		'@type': 'GeoCoordinates';
		'latitude': number;
		'longitude': number;
	};
	'openingHoursSpecification'?: {
		'@type': 'OpeningHoursSpecification';
		'dayOfWeek': string[];
		'opens'?: string;
		'closes'?: string;
	};
	'availableLanguage'?: string[];
}

interface MedicalTestSchema extends SchemaOrgBase {
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

interface DrugSchema extends SchemaOrgBase {
	'@type': 'Drug';
	'name': string;
	'url'?: string;
	'description'?: string;
	'availableService'?: {
		'@type': 'MedicalOrganization';
		'name': string;
	}[];
}

interface MedicalProcedureSchema extends SchemaOrgBase {
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

interface ItemListSchema extends SchemaOrgBase {
	'@type': 'ItemList';
	'name': string;
	'description'?: string;
	'numberOfItems': number;
	'itemListElement'?: {
		'@type': 'ListItem';
		'position': number;
		'name': string;
		'url'?: string;
	}[];
}

interface BreadcrumbListSchema extends SchemaOrgBase {
	'@type': 'BreadcrumbList';
	'itemListElement': {
		'@type': 'ListItem';
		'position': number;
		'name': string;
		'item'?: string;
	}[];
}

interface AboutPageSchema extends SchemaOrgBase {
	'@type': 'AboutPage';
	'name': string;
	'description'?: string;
	'url'?: string;
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

type SchemaOrg =
	| OrganizationSchema
	| WebSiteSchema
	| PhysicianSchema
	| MedicalOrganizationSchema
	| MedicalTestSchema
	| DrugSchema
	| MedicalProcedureSchema
	| ItemListSchema
	| BreadcrumbListSchema
	| AboutPageSchema
	| SchemaOrgBase;

const SITE_NAME = 'omeda.me';
const SITE_DESCRIPTION =
	'Healthcare services directory in Montenegro - find doctors, clinics, lab tests, medications, and medical services';

function buildSameAs(
	contacts: Pick<ContactList, 'facebook' | 'instagram' | 'telegram'>,
): string[] {
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

export const useSchemaOrg = () => {
	const getBaseUrl = () => {
		return 'https://omeda.me';
	};

	const setSchemaOrg = (schemas: SchemaOrg | SchemaOrg[]) => {
		const schemaArray = Array.isArray(schemas) ? schemas : [schemas];

		useHead({
			script: schemaArray.map((schema, index) => ({
				type: 'application/ld+json',
				key: `schema-org-${index}`,
				tagDuplicateStrategy: 'replace',
				innerHTML: JSON.stringify({
					'@context': 'https://schema.org',
					...schema,
				}),
			})),
		});
	};

	// Главная страница - WebSite + Organization
	const setWebsiteSchema = (options?: { description?: string }) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg([
			{
				'@type': 'WebSite',
				'name': SITE_NAME,
				'url': baseUrl,
				'potentialAction': {
					'@type': 'SearchAction',
					'target': `${baseUrl}/doctors?name={search_term_string}`,
					'query-input': 'required name=search_term_string',
				},
			} as WebSiteSchema,
			{
				'@type': 'MedicalBusiness',
				'name': SITE_NAME,
				'url': baseUrl,
				'description': options?.description || SITE_DESCRIPTION,
				'address': {
					'@type': 'PostalAddress',
					'addressCountry': 'ME',
				},
			} as OrganizationSchema,
		]);
	};

	// Страница списка врачей
	const setDoctorsListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		doctors?: { id: number; name: string }[];
	}) => {
		const baseUrl = getBaseUrl();

		const schemas: SchemaOrg[] = [
			{
				'@type': 'ItemList',
				'name': options.title,
				'description': options.description,
				'numberOfItems': options.totalCount,
				'itemListElement': options.doctors
					?.slice(0, 10)
					.map((doctor, index) => ({
						'@type': 'ListItem',
						'position': index + 1,
						'name': doctor.name,
						'url': `${baseUrl}/doctors/${doctor.id}`,
					})),
			} as ItemListSchema,
			{
				'@type': 'MedicalWebPage',
				'name': options.title,
				'description': options.description,
				'about': {
					'@type': 'MedicalSpecialty',
					'name': 'Healthcare Services',
				},
			} as SchemaOrgBase,
		];

		setSchemaOrg(schemas);
	};

	// Страница врача
	const setDoctorSchema = (options: {
		id: number;
		name: string;
		photoUrl?: string;
		specialtyIds?: number[]; // ID специальностей — конвертируются в английские названия
		languageIds?: number[]; // ID языков — конвертируются в ISO коды (en, ru, sr)
		clinics?: ClinicData[];
		title?: string;
	}) => {
		const baseUrl = getBaseUrl();
		const specialties = options.specialtyIds
			?.map((id) => getSpecialtyNameEn(id))
			.filter(Boolean);
		const languages = options.languageIds
			?.map((id) => getLanguageCode(id))
			.filter(Boolean);

		const doctorUrl = `${baseUrl}/doctors/${options.id}`;
		setSchemaOrg({
			'@type': 'Physician',
			'@id': `${doctorUrl}#physician`,
			'mainEntityOfPage': doctorUrl,
			'url': doctorUrl,
			'name': options.name,
			'image': options.photoUrl || undefined,
			'honorificPrefix': options.title || undefined,
			'medicalSpecialty': specialties,
			'knowsLanguage': languages,
			'worksFor': options.clinics?.map((clinic) => {
				const sameAs = buildSameAs({
					facebook: clinic.facebook,
					instagram: clinic.instagram,
					telegram: clinic.telegram,
				});

				return {
					'@type': 'MedicalOrganization' as const,
					'name': clinic.name,
					'url': normalizeWebsiteUrl(clinic.website) || undefined,
					'telephone': splitContacts(clinic.phone)[0] || undefined,
					'email': splitContacts(clinic.email)[0] || undefined,
					'sameAs': sameAs.length > 0 ? sameAs : undefined,
					'address': clinic.address
						? {
								'@type': 'PostalAddress' as const,
								'streetAddress': clinic.address,
								'addressLocality': clinic.cityId
									? getCityNameEn(clinic.cityId)
									: undefined,
								'addressCountry': 'ME',
						  }
						: undefined,
				};
			}),
		} as PhysicianSchema);
	};

	// Страница списка клиник
	const setClinicsListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		clinics?: ClinicData[];
	}) => {
		const baseUrl = getBaseUrl();

		const schemas: SchemaOrg[] = [
			{
				'@type': 'ItemList',
				'name': options.title,
				'description': options.description,
				'numberOfItems': options.totalCount,
				'itemListElement': options.clinics
					?.slice(0, 10)
					.map((clinic, index) => ({
						'@type': 'ListItem',
						'position': index + 1,
						'name': clinic.name,
						'url': `${baseUrl}/clinics/${clinic.id}`,
					})),
			} as ItemListSchema,
		];

		setSchemaOrg(schemas);
	};

	// Страница клиники
	const setClinicSchema = (clinic: ClinicData) => {
		const baseUrl = getBaseUrl();
		const schema: MedicalOrganizationSchema = {
			'@context': 'https://schema.org',
			'@type': 'MedicalOrganization',
			'name': clinic.name,
			'url':
				normalizeWebsiteUrl(clinic.website) ||
				`${baseUrl}/clinics/${clinic.id}`,
			'address': {
				'@type': 'PostalAddress',
				'addressCountry': 'ME',
				'addressLocality': getCityNameEn(clinic.cityId),
				'streetAddress': clinic.address,
			},
		};

		schema.telephone = splitContacts(clinic.phone)[0] || undefined;
		schema.email = splitContacts(clinic.email)[0] || undefined;

		// Собираем социальные сети
		const socialLinks = buildSameAs({
			facebook: clinic.facebook,
			instagram: clinic.instagram,
			telegram: clinic.telegram,
		});

		if (socialLinks.length > 0) {
			schema.sameAs = socialLinks;
		}

		if (clinic.latitude && clinic.longitude) {
			schema.geo = {
				'@type': 'GeoCoordinates',
				'latitude': clinic.latitude,
				'longitude': clinic.longitude,
			};
		}

		setSchemaOrg(schema);
	};

	// Страница списка анализов
	const setLabTestsListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		labTests?: { id: number; name: string }[];
	}) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg({
			'@type': 'ItemList',
			'name': options.title,
			'description': options.description,
			'numberOfItems': options.totalCount,
			'itemListElement': options.labTests?.slice(0, 10).map((test, index) => ({
				'@type': 'ListItem',
				'position': index + 1,
				'name': test.name,
				'url': `${baseUrl}/labtests/${test.id}`,
			})),
		} as ItemListSchema);
	};

	// Страница анализа
	const setLabTestSchema = (options: {
		id: number;
		name: string;
		originalName?: string;
		synonyms?: string[];
		clinics?: { name: string }[];
	}) => {
		const baseUrl = getBaseUrl();
		setSchemaOrg({
			'@type': 'MedicalTest',
			'name': options.name,
			'url': `${baseUrl}/labtests/${options.id}`,
			'alternateName': options.originalName,
			'availableService': options.clinics?.map((clinic) => ({
				'@type': 'MedicalOrganization' as const,
				'name': clinic.name,
			})),
		} as MedicalTestSchema);
	};

	// Страница списка лекарств
	const setMedicationsListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		medications?: { id: number; name: string }[];
	}) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg({
			'@type': 'ItemList',
			'name': options.title,
			'description': options.description,
			'numberOfItems': options.totalCount,
			'itemListElement': options.medications
				?.slice(0, 10)
				.map((medication, index) => ({
					'@type': 'ListItem',
					'position': index + 1,
					'name': medication.name,
					'url': `${baseUrl}/medications/${medication.id}`,
				})),
		} as ItemListSchema);
	};

	// Страница лекарства
	const setMedicationSchema = (options: {
		id: number;
		name: string;
		clinics?: { name: string }[];
	}) => {
		const baseUrl = getBaseUrl();
		setSchemaOrg({
			'@type': 'Drug',
			'name': options.name,
			'url': `${baseUrl}/medications/${options.id}`,
			'availableService': options.clinics?.map((clinic) => ({
				'@type': 'MedicalOrganization' as const,
				'name': clinic.name,
			})),
		} as DrugSchema);
	};

	// Страница списка услуг
	const setMedicalServicesListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		services?: { id: number; name: string }[];
	}) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg({
			'@type': 'ItemList',
			'name': options.title,
			'description': options.description,
			'numberOfItems': options.totalCount,
			'itemListElement': options.services
				?.slice(0, 10)
				.map((service, index) => ({
					'@type': 'ListItem',
					'position': index + 1,
					'name': service.name,
					'url': `${baseUrl}/services/${service.id}`,
				})),
		} as ItemListSchema);
	};

	// Страница услуги
	const setMedicalServiceSchema = (options: {
		id: number;
		name: string;
		clinics?: { name: string }[];
	}) => {
		const baseUrl = getBaseUrl();
		setSchemaOrg({
			'@type': 'MedicalProcedure',
			'name': options.name,
			'url': `${baseUrl}/services/${options.id}`,
			'availableService': options.clinics?.map((clinic) => ({
				'@type': 'MedicalOrganization' as const,
				'name': clinic.name,
			})),
		} as MedicalProcedureSchema);
	};

	// Хлебные крошки
	const setBreadcrumbs = (items: { name: string; url?: string }[]) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg({
			'@type': 'BreadcrumbList',
			'itemListElement': items.map((item, index) => ({
				'@type': 'ListItem',
				'position': index + 1,
				'name': item.name,
				'item': item.url ? `${baseUrl}${item.url}` : undefined,
			})),
		} as BreadcrumbListSchema);
	};

	// Страница "О проекте" (E-E-A-T)
	const setAboutPageSchema = (options: {
		title: string;
		description?: string;
		url?: string;
	}) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg({
			'@type': 'AboutPage',
			'name': options.title,
			'description': options.description,
			'url': options.url || `${baseUrl}/about`,
			'isPartOf': {
				'@type': 'WebSite',
				'name': SITE_NAME,
				'url': baseUrl,
			},
			'about': {
				'@type': 'MedicalBusiness',
				'name': SITE_NAME,
				'url': baseUrl,
			},
		} as AboutPageSchema);
	};

	return {
		setSchemaOrg,
		setWebsiteSchema,
		setDoctorsListSchema,
		setDoctorSchema,
		setClinicsListSchema,
		setClinicSchema,
		setLabTestsListSchema,
		setLabTestSchema,
		setMedicationsListSchema,
		setMedicationSchema,
		setMedicalServicesListSchema,
		setMedicalServiceSchema,
		setBreadcrumbs,
		setAboutPageSchema,
	};
};
