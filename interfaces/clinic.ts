import type { ContactList } from '~/interfaces/contacts';
import type { CityId } from '~/enums/cities';
import type { BillingService } from '~/enums/billing-service';
import type { Rating, Review } from '~/interfaces/review';
import type { WorkingHours } from '~/interfaces/clinic-working-hours';

export interface Coordinates {
	latitude: number;
	longitude: number;
}

// Жизненный цикл пользовательской клиники (clinics.status).
// 'pending_verification' и 'rejected' зарезервированы под будущую модерацию
// (PRD clinic-verification); пользовательский флоу — draft <-> published.
export type ClinicStatus =
	| 'draft'
	| 'pending_verification'
	| 'published'
	| 'rejected';

export type ClinicItemType =
	| 'services'
	| 'labtests'
	| 'medications'
	| 'doctors';

export interface ClinicItemCategory {
	categoryId: number | null;
	count: number;
}

export interface ClinicItemTopEntry {
	id: number;
	slug: string;
	name: string;
	localName: string;
	price: number | null;
	priceMin: number | null;
	priceMax: number | null;
	photoUrl?: string;
	professionalTitle?: string;
	specialtyIds?: string;
}

export interface ClinicItemTypeSummary {
	totalCount: number;
	categories: ClinicItemCategory[];
	topItems: ClinicItemTopEntry[];
}

export type ClinicItemsSummary = Record<ClinicItemType, ClinicItemTypeSummary>;

export interface ClinicData extends ContactList, Coordinates {
	id: number;
	slug: string;
	clinicTypeIds: string;
	name: string;
	localName: string;
	cityId: CityId;
	address: string;
	town: string;
	postalCode?: string;
	languageIds: string;
	description: string;
	logoUrl?: string;
	features: BillingService[];
	rating?: Rating;
	reviews?: Review[];
	workingHours?: Omit<WorkingHours, 'clinicId'>;
	itemsSummary?: ClinicItemsSummary;
	// Заполняются только на details-эндпоинте: непубличная клиника видна
	// владельцу/админу, страница показывает owner-баннер.
	status?: ClinicStatus;
	isOwner?: boolean;
	// Расстояние до пользователя в км — только когда список отсортирован
	// по расстоянию (см. sortByDistance в server/api/clinics/list.ts)
	distance?: number;
	// Общий рейтинг 0..1 (server/utils/entity-ranking.ts) — нужен клиенту
	// для композитной пересортировки (composables/use-clinic-ranking.ts)
	rankScore?: number;
}

export interface ClinicList {
	clinics: ClinicData[];
	totalCount: number;
}

export interface ClinicServiceItem {
	id: number;
	slug: string;
	// Полный список id клиник (по нему карта ставит маркеры). Карточка
	// показывает только первые LIST_CARD_MAX_CLINICS (см. common/constants.ts),
	// clinicPrices на listing-эндпоинтах тоже обрезаны до этого числа.
	clinicIds: string;
	// Общее число клиник, в которых доступна услуга/анализ/лекарство.
	// Заполняется backend-ом на listing-эндпоинтах и используется для подписи "Показать все клиники (N)".
	clinicCount?: number;
	name: string;
	localName: string;
}

// Услуга клиники в карточке ClinicSummary (профильные услуги врача в клинике)
export interface ClinicSummaryService {
	id: number;
	slug: string;
	name: string;
	localName: string;
	price: number | null;
	priceMin: number | null;
	priceMax: number | null;
}

// Услуги, сгруппированные по id клиники. Не путать с компонентом ClinicServicesMap (карта).
export type ClinicServicesByClinicId = Record<number, ClinicSummaryService[]>;

export interface ClinicPrice {
	clinicId: number;
	price: number | null;
	priceMin?: number | null;
	priceMax?: number | null;
	code?: string | null;
}

export interface ClinicServiceWithPrices extends ClinicServiceItem {
	clinicPrices: ClinicPrice[];
	categoryIds?: number[];
	tariffs?: import('./medical-service-tariff').MedicalServiceTariff[];
	referenceInfo?: import('./reference-info').ReferenceInfo | null;
}

export interface LabTestItem extends ClinicServiceWithPrices {
	localName: string;
	synonyms?: string[];
	categoryIds?: number[];
}

export interface ClinicServiceList {
	items: ClinicServiceWithPrices[];
	totalCount: number;
}

export interface LabTestListItem {
	id: number;
	name: string;
}

export interface LabTestNames {
	name_en: string;
	name_sr: string;
	name_sr_cyrl: string;
	name_ru: string;
	name_de: string;
	name_tr: string;
}

export interface LabTestList {
	items: LabTestItem[];
	totalCount: number;
}
