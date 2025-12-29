import { DoctorSpecialty } from '~/enums/specialty';

const SCHEMA_ORG_BASE_URL = 'https://schema.org';

type SchemaOrgMedicalSpecialtyMember =
	| 'Anesthesia'
	| 'Cardiovascular'
	| 'CommunityHealth'
	| 'Dentistry'
	| 'Dermatology'
	| 'DietNutrition'
	| 'Emergency'
	| 'Endocrine'
	| 'Gastroenterologic'
	| 'Genetic'
	| 'Gynecologic'
	| 'Hematologic'
	| 'Infectious'
	| 'LaboratoryScience'
	| 'Midwifery'
	| 'Musculoskeletal'
	| 'Neurologic'
	| 'Nursing'
	| 'Obstetric'
	| 'Oncologic'
	| 'Optometric'
	| 'Otolaryngologic'
	| 'Pathology'
	| 'Pediatric'
	| 'PharmacySpecialty'
	| 'Physiotherapy'
	| 'PlasticSurgery'
	| 'Podiatric'
	| 'PrimaryCare'
	| 'Psychiatric'
	| 'PublicHealth'
	| 'Pulmonary'
	| 'Radiography'
	| 'Renal'
	| 'RespiratoryTherapy'
	| 'Rheumatologic'
	| 'SpeechPathology'
	| 'Surgical'
	| 'Toxicologic'
	| 'Urologic';

const SPECIALTY_TO_SCHEMA_ORG_MEMBER: Partial<
	Record<DoctorSpecialty, SchemaOrgMedicalSpecialtyMember>
> = {
	[DoctorSpecialty.CARDIOLOGY]: 'Cardiovascular',
	[DoctorSpecialty.INTERNAL_MEDICINE]: 'PrimaryCare',
	[DoctorSpecialty.GENERAL_SURGERY]: 'Surgical',
	[DoctorSpecialty.PEDIATRICS]: 'Pediatric',
	[DoctorSpecialty.GYNECOLOGY_OBSTETRICS]: 'Gynecologic',
	[DoctorSpecialty.OPHTHALMOLOGY]: 'Optometric',
	[DoctorSpecialty.DERMATOVENEROLOGY]: 'Dermatology',
	[DoctorSpecialty.NEUROLOGY]: 'Neurologic',
	[DoctorSpecialty.UROLOGY]: 'Urologic',
	[DoctorSpecialty.RADIOLOGY]: 'Radiography',
	[DoctorSpecialty.OTORHINOLARYNGOLOGY]: 'Otolaryngologic',
	[DoctorSpecialty.ENDOCRINOLOGY]: 'Endocrine',
	[DoctorSpecialty.GASTROENTEROLOGY]: 'Gastroenterologic',
	[DoctorSpecialty.PULMONOLOGY]: 'Pulmonary',
	[DoctorSpecialty.HEMATOLOGY]: 'Hematologic',
	[DoctorSpecialty.RHEUMATOLOGY]: 'Rheumatologic',
	[DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY]: 'Musculoskeletal',
	[DoctorSpecialty.PLASTIC_SURGERY]: 'PlasticSurgery',
	[DoctorSpecialty.ANESTHESIOLOGY]: 'Anesthesia',
	[DoctorSpecialty.FAMILY_MEDICINE]: 'PrimaryCare',
	[DoctorSpecialty.PSYCHIATRY]: 'Psychiatric',
	[DoctorSpecialty.PSYCHOLOGY]: 'Psychiatric',

	[DoctorSpecialty.PEDIATRIC_CARDIOLOGY]: 'Cardiovascular',
	[DoctorSpecialty.PEDIATRIC_SURGERY]: 'Surgical',
	[DoctorSpecialty.PEDIATRIC_NEUROLOGY]: 'Neurologic',
	[DoctorSpecialty.PEDIATRIC_PULMONOLOGY]: 'Pulmonary',
	[DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY]: 'Gastroenterologic',
	[DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY]: 'Endocrine',
	[DoctorSpecialty.PEDIATRIC_HEMATOLOGY]: 'Hematologic',
	[DoctorSpecialty.PEDIATRIC_ENT]: 'Otolaryngologic',
	[DoctorSpecialty.PEDIATRIC_ORTHOPEDICS]: 'Musculoskeletal',
	[DoctorSpecialty.PEDIATRIC_UROLOGY]: 'Urologic',

	[DoctorSpecialty.VASCULAR_SURGERY]: 'Cardiovascular',
	[DoctorSpecialty.ENDOCRINE_SURGERY]: 'Surgical',
	[DoctorSpecialty.PROCTOLOGY]: 'Gastroenterologic',
	[DoctorSpecialty.GYNECOLOGIC_ONCOLOGY]: 'Oncologic',
	[DoctorSpecialty.REPRODUCTIVE_MEDICINE]: 'Gynecologic',
	[DoctorSpecialty.CLINICAL_BIOCHEMISTRY]: 'LaboratoryScience',
	[DoctorSpecialty.MICROBIOLOGY]: 'LaboratoryScience',
	[DoctorSpecialty.MOLECULAR_BIOLOGY]: 'LaboratoryScience',
	[DoctorSpecialty.PHYSICAL_MEDICINE]: 'Physiotherapy',
	[DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE]: 'Physiotherapy',
	[DoctorSpecialty.AESTHETIC_MEDICINE]: 'PlasticSurgery',
	[DoctorSpecialty.GENERAL_MEDICINE]: 'PrimaryCare',
	[DoctorSpecialty.NEPHROLOGY]: 'Renal',
	[DoctorSpecialty.NEUROSURGERY]: 'Surgical',
	[DoctorSpecialty.ONCOLOGY]: 'Oncologic',
	[DoctorSpecialty.EMERGENCY_MEDICINE]: 'Emergency',
	[DoctorSpecialty.THORACIC_SURGERY]: 'Surgical',
	[DoctorSpecialty.OCCUPATIONAL_MEDICINE]: 'PublicHealth',
	[DoctorSpecialty.PSYCHOTHERAPY]: 'Psychiatric',
	[DoctorSpecialty.INFECTIOUS_DISEASES]: 'Infectious',
	[DoctorSpecialty.NEONATOLOGY]: 'Pediatric',
	[DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY]: 'Optometric',
	[DoctorSpecialty.SPEECH_THERAPY]: 'SpeechPathology',
	[DoctorSpecialty.PERINATOLOGY]: 'Obstetric',
	[DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY]: 'PlasticSurgery',
	[DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION]: 'Physiotherapy',
	[DoctorSpecialty.ORAL_SURGERY]: 'Dentistry',
	[DoctorSpecialty.MAMMOLOGY]: 'Oncologic',
	[DoctorSpecialty.ONCOLOGIC_SURGERY]: 'Oncologic',
	[DoctorSpecialty.DENTISTRY]: 'Dentistry',
	[DoctorSpecialty.OPHTHALMIC_SURGERY]: 'Surgical',
	[DoctorSpecialty.OSTEOPATHY]: 'Musculoskeletal',
	[DoctorSpecialty.PATHOLOGICAL_ANATOMY]: 'Pathology',
	[DoctorSpecialty.PODIATRY]: 'Podiatric',
	[DoctorSpecialty.TRICHOLOGY]: 'Dermatology',
	[DoctorSpecialty.PEDIATRIC_DENTISTRY]: 'Dentistry',
	[DoctorSpecialty.NUCLEAR_MEDICINE]: 'Radiography',
	[DoctorSpecialty.GENETICS]: 'Genetic',
	[DoctorSpecialty.GASTROINTESTINAL_SURGERY]: 'Surgical',
	[DoctorSpecialty.MAXILLOFACIAL_SURGERY]: 'Surgical',
	[DoctorSpecialty.CARDIAC_SURGERY]: 'Cardiovascular',
	[DoctorSpecialty.ORTHODONTIST]: 'Dentistry',
};

export function getDoctorSpecialtySchemaOrgUrlById(
	specialtyId: number,
): string | null {
	const member =
		SPECIALTY_TO_SCHEMA_ORG_MEMBER[specialtyId as DoctorSpecialty] || null;
	return member ? `${SCHEMA_ORG_BASE_URL}/${member}` : null;
}
