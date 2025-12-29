import type { ContactList } from '~/interfaces/contacts';

export interface ClinicService {
	clinicId: number;
	price: number;
	code: string;
}

export interface Coordinates {
	latitude: number;
	longitude: number;
}

export interface ClinicData extends ContactList, Coordinates {
	id: number;
	name: string;
	cityId: CityId;
	address: string;
	town?: string;
	postalCode?: string;
	languageIds: string;
	description_sr: string;
	description_en: string;
	description_ru: string;
	description_de: string;
	description_tr: string;
}

export interface ClinicList {
	clinics: ClinicData[];
	totalCount: number;
}

export interface ClinicServiceItem {
	id: number;
	clinicIds: string;
	name: string;
	name_ru: string;
}

export interface ClinicPrice {
	clinicId: number;
	price: number;
	code?: string;
}

export interface ClinicServiceWithPrices extends ClinicServiceItem {
	clinicPrices: ClinicPrice[];
}

export interface LabTestItem extends ClinicServiceWithPrices {
	originalName?: string;
	synonyms?: string[];
	categoryIds?: number[];
}

export interface ClinicServiceList {
	items: ClinicServiceWithPrices[];
	totalCount: number;
}

export interface LabTestList {
	items: LabTestItem[];
	totalCount: number;
}
