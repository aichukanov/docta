export interface MedicationData {
	id: number;
	name: string;
	clinicIds: string;
}

export interface MedicationList {
	medications: MedicationData[];
	totalCount: number;
}

export interface MedicationWithPrice extends MedicationData {
	price: number;
	code: string;
	clinicId: number;
}
