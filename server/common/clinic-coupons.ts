import {
	parseCouponPaymentMethod,
	parseCouponScopes,
} from '~/common/clinic-coupon';
import type { ClinicCoupon } from '~/interfaces/clinic-coupon';
import { executeQuery } from '~/server/common/db-mysql';

type CouponRow = {
	id: number;
	clinicId: number;
	discountPercent: number;
	appliesTo: string | null;
	sourceName: string | null;
	imageUrl: string | null;
	code: string | null;
	paymentMethod: string | null;
	validUntil: Date | string | null;
};

// Активность купона — три условия, и все проверяет БД: снятый вручную флаг,
// ещё не начавшийся и уже закончившийся срок. Бессрочный купон (valid_until
// IS NULL) остаётся активным до `is_active = 0`.
const ACTIVE_CONDITION = `
	cc.is_active = 1
	AND (cc.valid_from IS NULL OR cc.valid_from <= CURDATE())
	AND (cc.valid_until IS NULL OR cc.valid_until >= CURDATE())
`;

const SELECT_FIELDS = `
	cc.id,
	cc.clinic_id AS clinicId,
	cc.discount_percent AS discountPercent,
	cc.applies_to AS appliesTo,
	cc.source_name AS sourceName,
	cc.image_url AS imageUrl,
	cc.code,
	cc.payment_method AS paymentMethod,
	cc.valid_until AS validUntil
`;

// Купонов у клиники может быть несколько (разные типы позиций или партнёры),
// но карточка и баннер показывают один — с самой большой скидкой.
const ORDER = 'ORDER BY cc.discount_percent DESC, cc.id';

const ALL_COUPONS_SQL = `
	SELECT ${SELECT_FIELDS}
	FROM clinic_coupons cc
	WHERE ${ACTIVE_CONDITION}
	${ORDER}
`;

const CLINIC_COUPONS_SQL = `
	SELECT ${SELECT_FIELDS}
	FROM clinic_coupons cc
	WHERE cc.clinic_id = ? AND ${ACTIVE_CONDITION}
	${ORDER}
`;

/** DATE из mysql2 приходит то объектом Date, то строкой — нормализуем в YYYY-MM-DD. */
export function toCouponIsoDate(value: Date | string | null): string | null {
	if (!value) return null;
	if (value instanceof Date) return value.toISOString().slice(0, 10);
	return String(value).slice(0, 10);
}

function mapRow(row: CouponRow): ClinicCoupon {
	return {
		id: row.id,
		discountPercent: Number(row.discountPercent),
		appliesTo: parseCouponScopes(row.appliesTo),
		sourceName: row.sourceName || null,
		imageUrl: row.imageUrl || null,
		code: row.code || null,
		paymentMethod: parseCouponPaymentMethod(row.paymentMethod),
		validUntil: toCouponIsoDate(row.validUntil),
	};
}

/**
 * Активные купоны по id клиники — по одному (лучшему) на клинику.
 *
 * Без аргумента забирает купоны всех клиник: их единицы, а листинг клиник и так
 * отдаёт весь справочник. Отдельный запрос с `IN (...)` не делаем намеренно —
 * переменное число плейсхолдеров плодит уникальные prepared statements
 * (см. maxPreparedStatements в server/common/db-mysql.ts).
 */
export async function fetchClinicCoupons(
	clinicId?: number,
): Promise<Map<number, ClinicCoupon>> {
	let rows: CouponRow[];
	try {
		rows =
			clinicId == null
				? await executeQuery<CouponRow>(ALL_COUPONS_SQL)
				: await executeQuery<CouponRow>(CLINIC_COUPONS_SQL, [clinicId]);
	} catch (error) {
		// Купон — необязательная надстройка, а `clinics/list` питает почти все
		// страницы сайта. Отсутствующая таблица (код задеплоен раньше миграции
		// 020) или сбой запроса не должны ронять каталог — отдаём «купонов нет».
		console.error('Failed to fetch clinic coupons:', error);
		return new Map();
	}

	const byClinic = new Map<number, ClinicCoupon>();
	for (const row of rows) {
		const coupon = mapRow(row);
		// Купон без применимых типов позиций бессмысленен: показать его негде
		if (coupon.appliesTo.length === 0) continue;
		if (!byClinic.has(row.clinicId)) {
			byClinic.set(row.clinicId, coupon);
		}
	}
	return byClinic;
}
