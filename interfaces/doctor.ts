import type { ContactList } from '~/interfaces/contacts';
import type { ClinicServiceItem } from '~/interfaces/clinic';

export interface DoctorData extends ClinicServiceItem, ContactList {
	specialtyIds: string;
	languageIds: string;
	professionalTitle: string;
	photoUrl: string;
	name_sr_cyrl?: string;
	localName: string;
}

export interface DoctorList {
	doctors: DoctorData[];
	totalCount: number;
}
