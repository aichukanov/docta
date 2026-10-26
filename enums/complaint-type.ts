// Словарь стандартных жалоб раздела «Репутация» (prd/clinic-reputation/).
// Один словарь на клиники и на врачей: правила раздела у них общие, а что из
// списка применимо к конкретной карточке — решает редакция. Значения хранятся
// в БД (clinic_complaints.complaint_type и doctor_complaints.complaint_type),
// формулировки — только в i18n/reputation.ts: список маленький и статичный,
// переводы живут на фронте. Новые типы дописываются в конец, значения не
// переиспользуются.
export enum ComplaintType {
	/** Навязывание услуг, о которых пациент не просил */
	IMPOSED_SERVICES = 1,
	/** Итоговая стоимость существенно выше озвученной до начала лечения */
	PRICE_DISCREPANCY = 2,
	/** Договор и письменный план лечения не выдаются */
	NO_WRITTEN_TERMS = 3,
	/** Фискальный чек выдаётся не на всю сумму оплаты */
	NO_RECEIPT = 4,
	/** Отказ вернуть предоплату за неоказанные услуги */
	REFUND_REFUSED = 5,
	/** Жалобы пациентов на качество лечения */
	QUALITY_COMPLAINTS = 6,
}

export const COMPLAINT_TYPES: ComplaintType[] = [
	ComplaintType.IMPOSED_SERVICES,
	ComplaintType.PRICE_DISCREPANCY,
	ComplaintType.NO_WRITTEN_TERMS,
	ComplaintType.NO_RECEIPT,
	ComplaintType.REFUND_REFUSED,
	ComplaintType.QUALITY_COMPLAINTS,
];

export function isComplaintType(value: number): value is ComplaintType {
	return COMPLAINT_TYPES.includes(value);
}

/**
 * Сущность, к которой относится жалоба. Таблицы разные
 * (clinic_complaints / doctor_complaints), правила и словарь — одни.
 */
export type ReputationEntity = 'clinic' | 'doctor';
