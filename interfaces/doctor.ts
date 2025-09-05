import type { CityId } from '~/enums/cities';
import type { ContactList } from '~/interfaces/contacts';

export interface DoctorData extends ContactList {
	id: number;
	name: string;
	specialtyIds: string;
	languageCodes: string;
	clinicIds: string;
	professionalTitle: string;
	photoUrl: string;
}

export interface ClinicData extends ContactList {
	id: number;
	name: string;
	cityId: CityId;
	address: string;
	latitude: number;
	longitude: number;
}

export interface DoctorList {
	doctors: DoctorData[];
	totalCount: number;
}

export interface ClinicList {
	clinics: ClinicData[];
	totalCount: number;
}
