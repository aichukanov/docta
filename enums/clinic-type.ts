export enum ClinicType {
	POLYCLINIC = 1,
	DENTAL_CLINIC = 2,
	HOSPITAL = 3,
	DIAGNOSTIC_LAB = 4,
	PHARMACY = 5,
	OPTICAL_CLINIC = 6,
	GYNECOLOGICAL_CLINIC = 7,
	UROLOGICAL_CLINIC = 8,
	OPHTHALMOLOGY_CLINIC = 9,
	DERMATOLOGY_CLINIC = 10,
	CARDIOLOGY_CLINIC = 11,
	PEDIATRIC_CLINIC = 12,
	REHABILITATION_CENTER = 13,
	AESTHETIC_CLINIC = 14,
	PSYCHIATRIC_CLINIC = 15,
	ONCOLOGY_CLINIC = 16,
	SURGICAL_CENTER = 17,
	ENT_CLINIC = 18,
	NEUROLOGY_CLINIC = 19,
	ENDOCRINOLOGY_CLINIC = 20,
	GASTROENTEROLOGY_CLINIC = 21,
	ORTHOPEDIC_CLINIC = 22,
	PULMONOLOGY_CLINIC = 23,
}

/**
 * Maps ClinicType → Schema.org @type
 */
export const CLINIC_TYPE_SCHEMA_ORG: Record<ClinicType, string> = {
	[ClinicType.POLYCLINIC]: 'MedicalClinic',
	[ClinicType.DENTAL_CLINIC]: 'Dentist',
	[ClinicType.HOSPITAL]: 'Hospital',
	[ClinicType.DIAGNOSTIC_LAB]: 'DiagnosticLab',
	[ClinicType.PHARMACY]: 'Pharmacy',
	[ClinicType.OPTICAL_CLINIC]: 'Optician',
	[ClinicType.GYNECOLOGICAL_CLINIC]: 'MedicalClinic',
	[ClinicType.UROLOGICAL_CLINIC]: 'MedicalClinic',
	[ClinicType.OPHTHALMOLOGY_CLINIC]: 'MedicalClinic',
	[ClinicType.DERMATOLOGY_CLINIC]: 'MedicalClinic',
	[ClinicType.CARDIOLOGY_CLINIC]: 'MedicalClinic',
	[ClinicType.PEDIATRIC_CLINIC]: 'MedicalClinic',
	[ClinicType.REHABILITATION_CENTER]: 'MedicalClinic',
	[ClinicType.AESTHETIC_CLINIC]: 'MedicalClinic',
	[ClinicType.PSYCHIATRIC_CLINIC]: 'MedicalClinic',
	[ClinicType.ONCOLOGY_CLINIC]: 'MedicalClinic',
	[ClinicType.SURGICAL_CENTER]: 'MedicalClinic',
	[ClinicType.ENT_CLINIC]: 'MedicalClinic',
	[ClinicType.NEUROLOGY_CLINIC]: 'MedicalClinic',
	[ClinicType.ENDOCRINOLOGY_CLINIC]: 'MedicalClinic',
	[ClinicType.GASTROENTEROLOGY_CLINIC]: 'MedicalClinic',
	[ClinicType.ORTHOPEDIC_CLINIC]: 'MedicalClinic',
	[ClinicType.PULMONOLOGY_CLINIC]: 'MedicalClinic',
};

/**
 * Maps ClinicType → Schema.org MedicalSpecialty URL suffix
 * Only for types that have a specific medical specialty
 */
export const CLINIC_TYPE_MEDICAL_SPECIALTY: Partial<
	Record<ClinicType, string>
> = {
	[ClinicType.DENTAL_CLINIC]: 'Dentistry',
	[ClinicType.OPTICAL_CLINIC]: 'Optometric',
	[ClinicType.GYNECOLOGICAL_CLINIC]: 'Gynecologic',
	[ClinicType.UROLOGICAL_CLINIC]: 'Urologic',
	[ClinicType.OPHTHALMOLOGY_CLINIC]: 'Optometric',
	[ClinicType.DERMATOLOGY_CLINIC]: 'Dermatology',
	[ClinicType.CARDIOLOGY_CLINIC]: 'Cardiovascular',
	[ClinicType.PEDIATRIC_CLINIC]: 'Pediatric',
	[ClinicType.REHABILITATION_CENTER]: 'Physiotherapy',
	[ClinicType.AESTHETIC_CLINIC]: 'PlasticSurgery',
	[ClinicType.PSYCHIATRIC_CLINIC]: 'Psychiatric',
	[ClinicType.ONCOLOGY_CLINIC]: 'Oncologic',
	[ClinicType.SURGICAL_CENTER]: 'Surgical',
	[ClinicType.ENT_CLINIC]: 'Otolaryngologic',
	[ClinicType.NEUROLOGY_CLINIC]: 'Neurologic',
	[ClinicType.ENDOCRINOLOGY_CLINIC]: 'Endocrine',
	[ClinicType.GASTROENTEROLOGY_CLINIC]: 'Gastroenterologic',
	[ClinicType.ORTHOPEDIC_CLINIC]: 'Musculoskeletal',
	[ClinicType.PULMONOLOGY_CLINIC]: 'Pulmonary',
};
