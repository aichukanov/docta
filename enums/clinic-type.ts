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
	PHYSIOTHERAPY_CLINIC = 24,
	PODOLOGY_CABINET = 25,
}

/** Все типы каталога. Редакторы обязаны показывать именно этот список. */
export const ALL_CLINIC_TYPES: ClinicType[] = Object.values(ClinicType).filter(
	(value): value is ClinicType => typeof value === 'number',
);

/**
 * Типы, по которым открыт фасет в публичном фильтре каталога.
 *
 * Правило: тип попадает сюда, только если есть хотя бы одна ПУБЛИЧНАЯ клиника
 * этого типа, иначе фильтр отдаёт пустой список. То же правило уже реализовано
 * данными в `server/common/sitemap/filters/clinics.ts` через `clinicIsPublicSql`
 * — этот список приходится держать в согласии с ним руками, и он расходится:
 * на 2026-08-04 сверка с базой показала `DERMATOLOGY_CLINIC` (0 клиник) и
 * `UROLOGICAL_CLINIC` (единственная клиника скрыта, `hidden = 1`) в списке при
 * отсутствии `PODOLOGY_CABINET`. Заводя новый тип, сверяйтесь с базой.
 *
 * ⚠️ Список предназначен ТОЛЬКО для публичного фильтра. Редакторам (админка,
 * кабинет клиники) передавать его нельзя: если назначенный клинике тип
 * отсутствует среди опций `el-select`, тот рендерит сырое число. Именно так
 * после добавления `PODOLOGY_CABINET` админка показывала «25» вместо подписи.
 */
export const FILTERABLE_CLINIC_TYPES: ClinicType[] = [
	ClinicType.HOSPITAL,
	ClinicType.POLYCLINIC,
	ClinicType.DENTAL_CLINIC,
	ClinicType.GYNECOLOGICAL_CLINIC,
	ClinicType.OPHTHALMOLOGY_CLINIC,
	ClinicType.CARDIOLOGY_CLINIC,
	ClinicType.ENT_CLINIC,
	ClinicType.ORTHOPEDIC_CLINIC,
	ClinicType.DIAGNOSTIC_LAB,
	ClinicType.PEDIATRIC_CLINIC,
	ClinicType.SURGICAL_CENTER,
	ClinicType.AESTHETIC_CLINIC,
	ClinicType.PHYSIOTHERAPY_CLINIC,
	ClinicType.PODOLOGY_CABINET,
];

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
	[ClinicType.PHYSIOTHERAPY_CLINIC]: 'MedicalClinic',
	[ClinicType.PODOLOGY_CABINET]: 'MedicalClinic',
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
	[ClinicType.PHYSIOTHERAPY_CLINIC]: 'Physiotherapy',
	[ClinicType.PODOLOGY_CABINET]: 'Podiatric',
};
