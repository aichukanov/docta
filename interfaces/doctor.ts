import type { ContactList } from '~/interfaces/contacts';
import type { ClinicServiceItem } from '~/interfaces/clinic';
import type { Review, Rating } from '~/interfaces/review';

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
	rating?: Rating;
	reviews?: Review[];
}

export interface DoctorList {
	doctors: DoctorData[];
	totalCount: number;
}

export type DoctorProfileStatus = 'draft' | 'public' | 'hidden';
