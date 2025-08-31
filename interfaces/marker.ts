export interface MarkerData {
	id: string;
	doctors: DoctorWithClinics[];
	clinics: DoctorClinicFull[];
	location: { lat: number; lng: number };
	isForced?: boolean;
}
