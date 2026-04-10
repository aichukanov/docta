export enum DispensingMode {
	PRESCRIPTION = 1,
	OTC = 2,
	HOSPITAL_ONLY = 3,
	HOSPITAL_OR_PRESCRIPTION = 4,
	HEALTHCARE_FACILITY = 5,
	SINGLE_USE_PRESCRIPTION = 6,
	RENEWABLE_PRESCRIPTION = 7,
	RESTRICTED_PRESCRIPTION = 8,
	SPECIAL_PRESCRIPTION = 9,
}

export type BadgeType = 'otc' | 'rx' | 'hospital' | 'restricted';

const BADGE_TYPE_MAP: Record<number, BadgeType> = {
	[DispensingMode.OTC]: 'otc',
	[DispensingMode.PRESCRIPTION]: 'rx',
	[DispensingMode.SINGLE_USE_PRESCRIPTION]: 'rx',
	[DispensingMode.RENEWABLE_PRESCRIPTION]: 'rx',
	[DispensingMode.HOSPITAL_ONLY]: 'hospital',
	[DispensingMode.HOSPITAL_OR_PRESCRIPTION]: 'hospital',
	[DispensingMode.HEALTHCARE_FACILITY]: 'hospital',
	[DispensingMode.RESTRICTED_PRESCRIPTION]: 'restricted',
	[DispensingMode.SPECIAL_PRESCRIPTION]: 'restricted',
};

export function getBadgeType(dispensingModeId: number | null | undefined): BadgeType {
	if (!dispensingModeId) return 'rx';
	return BADGE_TYPE_MAP[dispensingModeId] || 'rx';
}
