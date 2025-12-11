import type { ContactList } from '~/interfaces/contacts';
import type { ClinicServiceItem } from '~/interfaces/clinic';

export interface DoctorData extends ClinicServiceItem, ContactList {
	specialtyIds: string;
	languageIds: string;
	professionalTitle: string;
	photoUrl: string;
}

export interface DoctorList {
	doctors: DoctorData[];
	totalCount: number;
}
