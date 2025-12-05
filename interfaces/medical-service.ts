export interface MedicalServiceData {
	id: number;
	name: string;
	clinicIds: string;
}

export interface MedicalServiceList {
	medicalServices: MedicalServiceData[];
	totalCount: number;
}

export interface MedicalServiceWithPrice extends MedicalServiceData {
	price: number;
	code: string;
	clinicId: number;
}
