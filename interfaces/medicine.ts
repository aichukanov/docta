// Лекарство в списке /medicines (ответ /api/medicines/list)
export interface MedicineListItem {
	id: number;
	slug: string;
	name: string;
	strength: string | null;
	pharmaForm: string | null;
	pharmaFormSrc: string | null;
	manufacturer: string | null;
	country: string | null;
	// Действующие вещества одной строкой через запятую (GROUP_CONCAT)
	substances: string | null;
	dispensingModeId: number | null;
	isActive: boolean;
	atcCode: string | null;
	pack_total: number | null;
	pack_unit: string | null;
	pack_container_count: number | null;
	pack_per_container: number | null;
	pack_volume: number | null;
	pack_volume_unit: string | null;
	pack_parse_status: string | null;
}

export interface MedicineList {
	items: MedicineListItem[];
	totalCount: number;
}

export interface MedicineSubstance {
	id: number;
	name: string;
}

// exact — состав совпадает полностью; superset — содержит весь состав плюс
// дополнительные вещества; partial — только часть состава.
export type MedicineAnalogMatchType = 'exact' | 'superset' | 'partial';

export interface MedicineAnalog {
	id: number;
	slug: string;
	name: string;
	strength: string | null;
	pharmaForm: string | null;
	pharmaFormSrc: string | null;
	dispensingModeId: number | null;
	manufacturer: string | null;
	substances: string | null;
	matchType: MedicineAnalogMatchType;
	pack_total: number | null;
	pack_unit: string | null;
	pack_container_count: number | null;
	pack_per_container: number | null;
	pack_volume: number | null;
	pack_volume_unit: string | null;
	pack_parse_status: string | null;
}

// Ответ /api/medicines/details. Даты приходят строками после сериализации.
export interface MedicineDetails {
	id: number;
	cinmedId: number | null;
	slug: string;
	name: string;
	strength: string | null;
	packaging: string | null;
	detailPackaging: string | null;
	authorizationNumber: string | null;
	authorizationDate: string | null;
	atcCode: string | null;
	isActive: boolean;
	detailUrl: string | null;
	updatedAt: string | null;
	pharmaForm: string | null;
	pharmaFormSrc: string | null;
	pack_total: number | null;
	pack_unit: string | null;
	pack_container_count: number | null;
	pack_per_container: number | null;
	pack_volume: number | null;
	pack_volume_unit: string | null;
	pack_parse_status: string | null;
	manufacturerId: number | null;
	manufacturer: string | null;
	manufacturerAddress: string | null;
	country: string | null;
	authorizationHolder: string | null;
	dispensingModeId: number | null;
	atcGroup: string | null;
	atcGroupCode: string | null;
	substances: MedicineSubstance[];
	analogs: MedicineAnalog[];
}
