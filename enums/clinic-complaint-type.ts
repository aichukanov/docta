// Словарь стандартных жалоб раздела «Репутация» (prd/clinic-reputation/).
// Значения хранятся в БД (clinic_complaints.complaint_type), формулировки —
// только в i18n/clinic-reputation.ts: список маленький и статичный, переводы
// живут на фронте. Новые типы дописываются в конец, значения не переиспользуются.
export enum ClinicComplaintType {
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

export const CLINIC_COMPLAINT_TYPES: ClinicComplaintType[] = [
	ClinicComplaintType.IMPOSED_SERVICES,
	ClinicComplaintType.PRICE_DISCREPANCY,
	ClinicComplaintType.NO_WRITTEN_TERMS,
	ClinicComplaintType.NO_RECEIPT,
	ClinicComplaintType.REFUND_REFUSED,
	ClinicComplaintType.QUALITY_COMPLAINTS,
];

export function isClinicComplaintType(
	value: number,
): value is ClinicComplaintType {
	return CLINIC_COMPLAINT_TYPES.includes(value);
}
