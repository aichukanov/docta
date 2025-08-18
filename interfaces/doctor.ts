import type { CityId } from '~/common/constants';

export interface Language {
	id: number;
	code: string;
	name: string;
	name_sr: string;
	name_en: string;
	name_ru: string;
}

export interface City {
	id: CityId;
	name: string;
	name_sr: string;
	name_en: string;
	name_ru: string;
	latitude?: number;
	longitude?: number;
}

export interface Specialty {
	id: number;
	name: string;
	name_sr: string;
	name_en: string;
	name_ru: string;
}

export interface DoctorClinic {
	clinicId: number;
	doctorId: number;
}

export interface DoctorClinicFull {
	clinicId: number;
	clinicName: string;
	cityId: CityId;
	cityName: string;
	address: string;
	latitude?: number;
	longitude?: number;
	phone: string;
	email: string;
	website: string;
	facebook: string;
	instagram: string;
	telegram: string;
	whatsapp: string;
	viber: string;
}

export interface Clinic {
	id: number;
	name: string;
	cityId: CityId;
	cityName: string;
	address: string;
	latitude?: number;
	longitude?: number;
	phone: string;
	email: string;
	website?: string;
	facebook?: string;
	instagram?: string;
	telegram?: string;
	whatsapp?: string;
	viber?: string;
	created_at: Date;
}

export interface DoctorBase {
	id: number;
	name: string;
	photoUrl?: string;
	phone: string;
	email: string;
	facebook?: string;
	instagram?: string;
	telegram?: string;
	whatsapp?: string;
	viber?: string;
	description?: string;
	specialtyIds: number[];
	languages: string[];
	created_at: Date;
}

export interface DoctorFull extends DoctorBase {
	clinics: DoctorClinic[];
}

export interface DoctorWithClinics extends DoctorBase {
	clinics: DoctorClinicFull[];
}

// Типы для фильтрации
export interface DoctorFilters {
	specialtyIds?: number[];
	specialtyNames?: string[];
	languages?: string[];
	cityIds?: CityId[];
}

export interface DoctorsResponse {
	doctors: DoctorWithClinics[];
	totalCount: number;
}
