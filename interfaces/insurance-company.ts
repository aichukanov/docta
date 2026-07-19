import type { ContactList } from './contacts';
import type { Coordinates } from './clinic';
import type { CityId } from '~/enums/cities';

export interface InsuranceBranchData extends Coordinates {
	id: number;
	cityId: CityId;
	address: string;
	town: string;
	postalCode?: string;
	// Переопределяют контакты компании, если для филиала есть отдельные
	phone?: string;
	email?: string;
	workingHours?: string;
}

export interface InsuranceCompanyData extends ContactList {
	id: number;
	slug: string;
	name: string;
	localName: string;
	logoUrl?: string;
	branches: InsuranceBranchData[];
}

export interface InsuranceCompanyListItem {
	id: number;
	slug: string;
	name: string;
	localName: string;
	logoUrl?: string;
	website: string;
	phone: string;
	branchCount: number;
	// Все филиалы (или только попавшие под фильтр городов) — нужны каталогу
	// для карты со всеми офисами компаний сразу
	branches: InsuranceBranchData[];
}

// Один филиал + данные материнской компании — плоская структура для карты
// каталога (несколько компаний, у каждой несколько офисов)
export interface InsuranceCompanyBranchWithCompany extends InsuranceBranchData {
	companyId: number;
	companySlug: string;
	companyName: string;
	companyPhone: string;
}
