import type { CityId } from '~/enums/cities';
import type { ContactList } from '~/interfaces/contacts';

export interface DoctorData extends ContactList {
	id: number;
	name: string;
	specialtyIds: string;
	languageIds: string;
	clinicIds: string;
	professionalTitle: string;
	photoUrl: string;
}

export interface DoctorList {
	doctors: DoctorData[];
	totalCount: number;
}
