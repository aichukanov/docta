import type { ContactList } from '~/interfaces/contacts';

export interface ClinicService {
	clinicId: number;
	price: number;
	code: string;
}

export interface ClinicData extends ContactList {
	id: number;
	name: string;
	cityId: CityId;
	address: string;
	latitude: number;
	longitude: number;
	languageIds: string;
}

export interface ClinicList {
	clinics: ClinicData[];
	totalCount: number;
}
