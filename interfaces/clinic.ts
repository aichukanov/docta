import type { ContactList } from '~/interfaces/contacts';

export interface ClinicService {
	clinicId: number;
	price: number | null;
	priceMin: number | null;
	priceMax: number | null;
	code: string;
}

export interface Coordinates {
	latitude: number;
	longitude: number;
}

export interface ClinicData extends ContactList, Coordinates {
	id: number;
	name: string;
	localName: string;
	cityId: CityId;
	address: string;
	town: string;
	postalCode?: string;
	languageIds: string;
	description: string;
}

export interface ClinicList {
	clinics: ClinicData[];
	totalCount: number;
}

export interface ClinicServiceItem {
	id: number;
	clinicIds: string;
	name: string;
	localName: string;
}

export interface ClinicPrice {
	clinicId: number;
	price: number | null;
	priceMin?: number | null;
	priceMax?: number | null;
	code?: string;
}

export interface ClinicServiceWithPrices extends ClinicServiceItem {
	clinicPrices: ClinicPrice[];
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
