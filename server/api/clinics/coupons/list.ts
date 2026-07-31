import {
	parseCouponPaymentMethod,
	parseCouponScopes,
} from '~/common/clinic-coupon';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import type { ClinicCouponAdmin } from '~/interfaces/clinic-coupon';
import { requireAdmin } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import { toCouponIsoDate } from '~/server/common/clinic-coupons';

/**
 * Все купоны клиники для админки — включая снятые (`is_active = 0`) и
 * просроченные: публичная выборка их прячет, а редактировать и возвращать в
 * строй надо именно их. Публичный купон отдаёт fetchClinicCoupons.
 */
export default defineEventHandler(
	async (event): Promise<{ coupons: ClinicCouponAdmin[] } | null> => {
		try {
			await requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/coupons/list')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return null;
			}

			const connection = await getConnection();
			const [rows] = await connection.execute(
				`SELECT
					id,
					clinic_id AS clinicId,
					discount_percent AS discountPercent,
					applies_to AS appliesTo,
					source_name AS sourceName,
					image_url AS imageUrl,
					code,
					payment_method AS paymentMethod,
					valid_from AS validFrom,
					valid_until AS validUntil,
					is_active AS isActive
				FROM clinic_coupons
				WHERE clinic_id = ?
				ORDER BY is_active DESC, discount_percent DESC, id`,
				[Number(body.clinicId)],
			);
			await connection.end();

			const coupons = (rows as any[]).map((row) => ({
				id: row.id,
				clinicId: row.clinicId,
				discountPercent: Number(row.discountPercent),
				appliesTo: parseCouponScopes(row.appliesTo),
				sourceName: row.sourceName || null,
				imageUrl: row.imageUrl || null,
				code: row.code || null,
				paymentMethod: parseCouponPaymentMethod(row.paymentMethod),
				validFrom: toCouponIsoDate(row.validFrom),
				validUntil: toCouponIsoDate(row.validUntil),
				isActive: Boolean(row.isActive),
			}));

			return { coupons };
		} catch (error) {
			console.error('API Error - clinic coupons list:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch clinic coupons',
			});
		}
	},
);
