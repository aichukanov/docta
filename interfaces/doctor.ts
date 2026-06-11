import type { ContactList } from '~/interfaces/contacts';
import type {
	ClinicServiceItem,
	ClinicServicesByClinicId,
} from '~/interfaces/clinic';
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
	// Профильные услуги врача по клиникам (details/list с includeServices)
	clinicServices?: ClinicServicesByClinicId;
}

export interface DoctorList {
	doctors: DoctorData[];
	totalCount: number;
}

// Облегчённые данные для карточки врача (DoctorInfo/DoctorSpecialties):
// полный DoctorData либо topItems из ClinicItemsSummary.
export type DoctorCardData = Partial<DoctorData> & {
	id: number;
	name: string;
};

export type DoctorProfileStatus = 'draft' | 'public' | 'hidden';
