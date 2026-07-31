// Типы позиций, на которые может действовать купон. Значения совпадают с
// элементами SET-колонки `clinic_coupons.applies_to` (миграция 020).
export type ClinicCouponScope = 'services' | 'labtests' | 'medications';

export const CLINIC_COUPON_SCOPES: readonly ClinicCouponScope[] = [
	'services',
	'labtests',
	'medications',
];

/**
 * Способ оплаты, при котором действует скидка (`clinic_coupons.payment_method`).
 * 'any' — любой; клиники нередко дают скидку только за наличные.
 */
export type ClinicCouponPaymentMethod = 'any' | 'cash' | 'card';

export const CLINIC_COUPON_PAYMENT_METHODS: readonly ClinicCouponPaymentMethod[] =
	['any', 'cash', 'card'];

export interface ClinicCoupon {
	id: number;
	/** Процент скидки, 1..100 */
	discountPercent: number;
	appliesTo: ClinicCouponScope[];
	paymentMethod: ClinicCouponPaymentMethod;
	/** Партнёр, чью акцию транслируем; null — купон самой docta.me */
	sourceName: string | null;
	/** Картинка купона для показа на ресепшене; null — рисуем свой купон */
	imageUrl: string | null;
	/** Кодовое слово, если клиника его требует; null — достаточно купона */
	code: string | null;
	/** ISO-дата (YYYY-MM-DD); null — бессрочно */
	validUntil: string | null;
}

/**
 * Купон в админке: публичный вид плюс поля, которые наружу не отдаются —
 * дата начала и флаг активности. Админский список показывает и неактивные,
 * и просроченные купоны, поэтому «активен ли он сейчас» считается отдельно
 * (isCouponCurrentlyActive в common/clinic-coupon.ts).
 */
export interface ClinicCouponAdmin extends ClinicCoupon {
	clinicId: number;
	/** ISO-дата (YYYY-MM-DD); null — действует сразу */
	validFrom: string | null;
	isActive: boolean;
}
