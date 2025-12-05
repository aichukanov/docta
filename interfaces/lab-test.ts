export interface LabTestClinicPrice {
	clinicId: number;
	price: number;
	code: string;
}

export interface LabTestData {
	id: number;
	name: string;
	clinicIds: string;
	clinicPrices?: LabTestClinicPrice[];
}

export interface LabTestList {
	labTests: LabTestData[];
	totalCount: number;
}

export interface LabTestWithPrice extends LabTestData {
	price: number;
	code: string;
	clinicId: number;
}
