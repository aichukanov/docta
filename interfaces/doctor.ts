import type { ContactList } from '~/interfaces/contacts';
import type { ClinicServiceItem } from '~/interfaces/clinic';

export interface DoctorData extends ClinicServiceItem, ContactList {
	specialtyIds: string;
	languageIds: string;
	professionalTitle: string;
	photoUrl: string;
	name_sr?: string;
	name_sr_cyrl?: string;
	name_ru?: string;
	name_en?: string;
	localName: string;
	description?: string;
	isOwner?: boolean;
}

export interface DoctorList {
	doctors: DoctorData[];
	totalCount: number;
}

export type DoctorProfileStatus = 'draft' | 'public' | 'hidden';
