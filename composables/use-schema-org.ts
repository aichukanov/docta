import type { ClinicData } from '~/interfaces/clinic';
import {
	normalizeWebsiteUrl,
	splitContacts,
	normalizeFacebookUrl,
	normalizeInstagramUrl,
	normalizeTelegramUrl,
} from '~/common/contacts';
import { Language, LanguageId } from '~/enums/language';
import cityI18n from '~/i18n/city';
import { getDoctorSpecialtySchemaOrgUrlById } from '~/common/schema-org-medical-specialty';
import specialtyI18n from '~/i18n/specialty';

const cityMessagesEn = cityI18n.messages.en;

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
	'inLanguage'?: string;
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
		'addressCountry': 'ME';
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
	'@type': 'Physician' | 'Person';
	'name': string;
	'url'?: string;
	'image'?: string;
	'honorificPrefix'?: string;
	'medicalSpecialty'?: MedicalSpecialtySchema | MedicalSpecialtySchema[];
	'jobTitle'?: string | string[];
	'worksFor'?: {
		'@type': 'MedicalOrganization';
		'name': string;
		'address'?: {
			'@type': 'PostalAddress';
			'streetAddress': string;
			'addressLocality'?: string;
			'addressCountry': 'ME';
		};
		'telephone'?: string;
		'email'?: string;
		'url'?: string;
		'sameAs'?: string[];
	}[];
	'knowsLanguage'?: string[];
}

interface MedicalSpecialtySchema extends SchemaOrgBase {
	'@type': 'MedicalSpecialty';
	'@id': string;
	'name'?: string;
}

interface MedicalOrganizationSchema extends SchemaOrgBase {
	'@type': 'MedicalOrganization';
	'name': string;
	'image'?: string;
	'address'?: {
		'@type': 'PostalAddress';
		'addressCountry': 'ME';
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
	const { locale } = useI18n({ useScope: 'global' });
	const { t: tSpecialty } = useI18n(specialtyI18n);

	const isNonEmptyString = (value: unknown): value is string =>
		typeof value === 'string' && value.length > 0;

	const getBaseUrl = () => {
		return 'https://omeda.me';
	};

	const getCurrentPageUrl = (baseUrl: string) => {
		const route = useRoute();
		// В schema можно безопасно использовать полный URL текущей страницы (включая query),
		// чтобы разметка соответствовала реально показанному списку/фильтрам.
		return `${baseUrl}${route.fullPath}`;
	};

	const buildEntitySchemaBase = <TType extends string>(options: {
		url: string;
		type: TType;
		fragment: string;
	}) => {
		return {
			'@type': options.type,
			'@id': `${options.url}#${options.fragment}`,
			'mainEntityOfPage': options.url,
			'url': options.url,
		};
	};

	const buildTopListItemElements = <TItem extends { id: number; name: string }>(
		items: TItem[] | undefined,
		options: {
			baseUrl: string;
			buildPath: (item: TItem) => string;
			limit?: number;
		},
	) => {
		const limit = options.limit ?? 10;
		return items?.slice(0, limit).map((item, index) => ({
			'@type': 'ListItem' as const,
			'position': index + 1,
			'name': item.name,
			'url': `${options.baseUrl}${options.buildPath(item)}`,
		}));
	};

	const buildCollectionPageSchemas = (options: {
		pageUrl: string;
		title: string;
		description: string;
		itemList: Omit<ItemListSchema, '@context' | '@type'> & {
			'@type'?: 'ItemList';
		};
		pageType?: 'CollectionPage' | 'SearchResultsPage';
	}) => {
		const pageId = `${options.pageUrl}#webpage`;
		const itemListId = `${options.pageUrl}#itemlist`;
		const pageSchema: SchemaOrgBase = {
			'@type': options.pageType || 'CollectionPage',
			'@id': pageId,
			'url': options.pageUrl,
			'name': options.title,
			'description': options.description,
			'inLanguage': locale.value,
			'mainEntity': { '@id': itemListId },
		};

		const itemListSchema: ItemListSchema = {
			'@type': 'ItemList',
			'@id': itemListId,
			'name': options.title,
			'description': options.description,
			...options.itemList,
		} as ItemListSchema;

		return [pageSchema, itemListSchema] as SchemaOrg[];
	};

	const setEntityListSchema = <
		TItem extends { id: number; name: string },
	>(options: {
		title: string;
		description: string;
		totalCount: number;
		items?: TItem[];
		buildPath: (item: TItem) => string;
		isFiltered?: boolean;
	}) => {
		const baseUrl = getBaseUrl();
		const pageUrl = getCurrentPageUrl(baseUrl);

		setSchemaOrg(
			buildCollectionPageSchemas({
				pageUrl,
				title: options.title,
				description: options.description,
				pageType: options.isFiltered ? 'SearchResultsPage' : 'CollectionPage',
				itemList: {
					numberOfItems: options.totalCount,
					itemListElement: buildTopListItemElements(options.items, {
						baseUrl,
						buildPath: options.buildPath,
					}),
				},
			}),
		);
	};

	const setSchemaOrg = (schemas: SchemaOrg | SchemaOrg[]) => {
		const schemaArray = Array.isArray(schemas) ? schemas : [schemas];

		// Всегда держим ровно один json-ld <script>.
		// Если схем несколько — используем @graph.
		const normalizeNode = (schema: SchemaOrg) => {
			const { ['@context']: _context, ...rest } = schema as Record<
				string,
				unknown
			>;
			return rest;
		};

		const jsonLd =
			schemaArray.length === 1
				? {
						'@context': 'https://schema.org',
						...normalizeNode(schemaArray[0]),
				  }
				: {
						'@context': 'https://schema.org',
						'@graph': schemaArray.map(normalizeNode),
				  };

		useHead({
			script: [
				{
					type: 'application/ld+json',
					key: 'schema-org-jsonld',
					tagDuplicateStrategy: 'replace',
					innerHTML: JSON.stringify(jsonLd),
				},
			],
		});
	};

	// Главная страница - WebSite + Organization
	const setWebsiteSchema = (options?: { description?: string }) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg([
			{
				'@type': 'WebSite',
				'@id': `${baseUrl}#website`,
				'name': SITE_NAME,
				'inLanguage': locale.value,
				'url': baseUrl,
				'potentialAction': {
					'@type': 'SearchAction',
					'target': `${baseUrl}/doctors?name={search_term_string}`,
					'query-input': 'required name=search_term_string',
				},
			} as WebSiteSchema,
			{
				'@type': 'MedicalBusiness',
				'@id': `${baseUrl}#organization`,
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
		isFiltered?: boolean;
	}) => {
		setEntityListSchema({
			title: options.title,
			description: options.description,
			totalCount: options.totalCount,
			items: options.doctors,
			buildPath: (doctor) => `/doctors/${doctor.id}`,
			isFiltered: options.isFiltered,
		});
	};

	// Страница врача
	const setDoctorSchema = (options: {
		id: number;
		name: string;
		photoUrl?: string;
		specialtyIds?: number[]; // ID специальностей — конвертируются в schema.org MedicalSpecialty URL
		languageIds?: number[]; // ID языков — конвертируются в ISO коды (en, ru, sr)
		clinics?: ClinicData[];
		title?: string;
	}) => {
		const baseUrl = getBaseUrl();
		const honorificPrefix = options.title?.trim() || undefined;
		const schemaType = honorificPrefix
			? ('Physician' as const)
			: ('Person' as const);

		const jobTitles =
			schemaType === 'Person'
				? options.specialtyIds
						?.map((id) => tSpecialty(`doctor_${id}`))
						.filter(isNonEmptyString)
				: undefined;

		const specialties = options.specialtyIds
			?.map((id) => {
				const url = getDoctorSpecialtySchemaOrgUrlById(id);
				if (!url) {
					return null;
				}

				return {
					'@type': 'MedicalSpecialty' as const,
					'@id': url,
					'name': tSpecialty(`specialty_${id}`),
				} satisfies MedicalSpecialtySchema;
			})
			.filter(Boolean);
		const languages = options.languageIds
			?.map((id) => getLanguageCode(id))
			.filter(isNonEmptyString);

		const doctorUrl = `${baseUrl}/doctors/${options.id}`;
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
			worksFor: options.clinics?.map((clinic) => {
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
		} as PhysicianSchema;

		const webPageSchema: SchemaOrgBase = {
			'@type': 'WebPage',
			'@id': `${doctorUrl}#webpage`,
			'url': doctorUrl,
			'name': options.name,
			'inLanguage': locale.value,
			'mainEntity': { '@id': doctorSchema['@id'] as string },
		};

		setSchemaOrg([webPageSchema, doctorSchema]);
	};

	// Страница списка клиник
	const setClinicsListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		clinics?: ClinicData[];
		isFiltered?: boolean;
	}) => {
		setEntityListSchema({
			title: options.title,
			description: options.description,
			totalCount: options.totalCount,
			items: options.clinics,
			buildPath: (clinic) => `/clinics/${clinic.id}`,
			isFiltered: options.isFiltered,
		});
	};

	// Страница клиники
	const setClinicSchema = (clinic: ClinicData) => {
		const baseUrl = getBaseUrl();
		const clinicUrl = `${baseUrl}/clinics/${clinic.id}`;
		const schema: MedicalOrganizationSchema = {
			...buildEntitySchemaBase({
				url: clinicUrl,
				type: 'MedicalOrganization',
				fragment: 'medicalorganization',
			}),
			name: clinic.name,
			address: clinic.address
				? {
						'@type': 'PostalAddress',
						'addressCountry': 'ME',
						'addressLocality': getCityNameEn(clinic.cityId),
						'streetAddress': clinic.address,
				  }
				: undefined,
		};

		schema.telephone = splitContacts(clinic.phone)[0] || undefined;
		schema.email = splitContacts(clinic.email)[0] || undefined;

		// Собираем социальные сети
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

		if (sameAs.length > 0) {
			schema.sameAs = sameAs;
		}

		if (clinic.latitude && clinic.longitude) {
			schema.geo = {
				'@type': 'GeoCoordinates',
				'latitude': clinic.latitude,
				'longitude': clinic.longitude,
			};
		}

		const availableLanguage = clinic.languageIds
			?.split(',')
			.map((id) => Number(id))
			.map((id) => getLanguageCode(id))
			.filter(Boolean);
		if (availableLanguage && availableLanguage.length > 0) {
			schema.availableLanguage = availableLanguage;
		}

		const webPageSchema: SchemaOrgBase = {
			'@type': 'WebPage',
			'@id': `${clinicUrl}#webpage`,
			'url': clinicUrl,
			'name': clinic.name,
			'inLanguage': locale.value,
			'mainEntity': { '@id': schema['@id'] as string },
		};

		setSchemaOrg([webPageSchema, schema]);
	};

	// Страница списка анализов
	const setLabTestsListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		labTests?: { id: number; name: string }[];
		isFiltered?: boolean;
	}) => {
		setEntityListSchema({
			title: options.title,
			description: options.description,
			totalCount: options.totalCount,
			items: options.labTests,
			buildPath: (test) => `/labtests/${test.id}`,
			isFiltered: options.isFiltered,
		});
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
		const testUrl = `${baseUrl}/labtests/${options.id}`;
		const alternateName = [options.originalName, ...(options.synonyms || [])]
			.filter(Boolean)
			.join(', ');

		const testSchema = {
			...buildEntitySchemaBase({
				url: testUrl,
				type: 'MedicalTest',
				fragment: 'medicaltest',
			}),
			name: options.name,
			alternateName: alternateName || undefined,
			availableService: options.clinics?.map((clinic) => ({
				'@type': 'MedicalOrganization' as const,
				'name': clinic.name,
			})),
		} as MedicalTestSchema;

		const webPageSchema: SchemaOrgBase = {
			'@type': 'WebPage',
			'@id': `${testUrl}#webpage`,
			'url': testUrl,
			'name': options.name,
			'inLanguage': locale.value,
			'mainEntity': { '@id': testSchema['@id'] as string },
		};

		setSchemaOrg([webPageSchema, testSchema]);
	};

	// Страница списка лекарств
	const setMedicationsListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		medications?: { id: number; name: string }[];
		isFiltered?: boolean;
	}) => {
		setEntityListSchema({
			title: options.title,
			description: options.description,
			totalCount: options.totalCount,
			items: options.medications,
			buildPath: (medication) => `/medications/${medication.id}`,
			isFiltered: options.isFiltered,
		});
	};

	// Страница лекарства
	const setMedicationSchema = (options: {
		id: number;
		name: string;
		clinics?: { name: string }[];
	}) => {
		const baseUrl = getBaseUrl();
		const medicationUrl = `${baseUrl}/medications/${options.id}`;

		const medicationSchema = {
			...buildEntitySchemaBase({
				url: medicationUrl,
				type: 'Drug',
				fragment: 'drug',
			}),
			name: options.name,
			availableService: options.clinics?.map((clinic) => ({
				'@type': 'MedicalOrganization' as const,
				'name': clinic.name,
			})),
		} as DrugSchema;

		const webPageSchema: SchemaOrgBase = {
			'@type': 'WebPage',
			'@id': `${medicationUrl}#webpage`,
			'url': medicationUrl,
			'name': options.name,
			'inLanguage': locale.value,
			'mainEntity': { '@id': medicationSchema['@id'] as string },
		};

		setSchemaOrg([webPageSchema, medicationSchema]);
	};

	// Страница списка услуг
	const setMedicalServicesListSchema = (options: {
		title: string;
		description: string;
		totalCount: number;
		services?: { id: number; name: string }[];
		isFiltered?: boolean;
	}) => {
		setEntityListSchema({
			title: options.title,
			description: options.description,
			totalCount: options.totalCount,
			items: options.services,
			buildPath: (service) => `/services/${service.id}`,
			isFiltered: options.isFiltered,
		});
	};

	// Страница услуги
	const setMedicalServiceSchema = (options: {
		id: number;
		name: string;
		clinics?: { name: string }[];
	}) => {
		const baseUrl = getBaseUrl();
		const serviceUrl = `${baseUrl}/services/${options.id}`;

		const serviceSchema = {
			...buildEntitySchemaBase({
				url: serviceUrl,
				type: 'MedicalProcedure',
				fragment: 'medicalprocedure',
			}),
			name: options.name,
			availableService: options.clinics?.map((clinic) => ({
				'@type': 'MedicalOrganization' as const,
				'name': clinic.name,
			})),
		} as MedicalProcedureSchema;

		const webPageSchema: SchemaOrgBase = {
			'@type': 'WebPage',
			'@id': `${serviceUrl}#webpage`,
			'url': serviceUrl,
			'name': options.name,
			'inLanguage': locale.value,
			'mainEntity': { '@id': serviceSchema['@id'] as string },
		};

		setSchemaOrg([webPageSchema, serviceSchema]);
	};

	// Хлебные крошки
	const setBreadcrumbs = (items: { name: string; url?: string }[]) => {
		const baseUrl = getBaseUrl();

		setSchemaOrg({
			'@type': 'BreadcrumbList',
			'@id': `${getCurrentPageUrl(baseUrl)}#breadcrumbs`,
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
		const aboutUrl = options.url || `${baseUrl}/about`;

		setSchemaOrg({
			'@type': 'AboutPage',
			'@id': `${aboutUrl}#aboutpage`,
			'name': options.title,
			'description': options.description,
			'inLanguage': locale.value,
			'url': aboutUrl,
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
