import { getConnection } from '~/server/common/db-mysql';
import { requireUser, getOwnedClinic } from '~/server/common/clinic-cabinet';
import { validateNonNegativeInteger } from '~/common/validation';
import type { BillingMyPurchase } from '~/interfaces/billing';
import { ERROR_CODES, createErrorResponse } from '~/server/utils/api-codes';

// История покупок клиники для её владельца — аналог админского
// clinic-purchases/list, но с проверкой владельца вместо requireAdmin.
export default defineEventHandler(
	async (event): Promise<{ purchases: BillingMyPurchase[] }> => {
		const user = await requireUser(event);

		const query = getQuery(event);
		const clinicId = Number(query.clinicId);
		if (!validateNonNegativeInteger(clinicId)) {
			createErrorResponse(400, ERROR_CODES.ORDER_INVALID_DATA);
		}

		const connection = await getConnection();
		try {
			await getOwnedClinic(connection, clinicId, user);

			const [rows]: any = await connection.execute(
				`SELECT
					p.id,
					p.price,
					p.purchased_at as purchasedAt,
					p.valid_until as validUntil,
					p.deleted,
					COALESCE(GROUP_CONCAT(DISTINCT i.service_id ORDER BY i.service_id), '') as serviceIds,
					(p.valid_until > NOW() AND p.deleted = FALSE) as isActive,
					(p.valid_until <= NOW()) as isExpired
				FROM billing_clinic_service_purchases p
				LEFT JOIN billing_clinic_service_purchase_items i
					ON p.id = i.purchase_id
				WHERE p.clinic_id = ?
				GROUP BY p.id
				ORDER BY p.purchased_at DESC`,
				[clinicId],
			);

			const purchases: BillingMyPurchase[] = (rows as any[]).map((row) => ({
				id: row.id,
				price: Number(row.price),
				purchasedAt: row.purchasedAt,
				validUntil: row.validUntil,
				deleted: Boolean(row.deleted),
				serviceIds: row.serviceIds
					? String(row.serviceIds).split(',').map(Number)
					: [],
				isActive: Boolean(row.isActive),
				isExpired: Boolean(row.isExpired),
			}));

			return { purchases };
		} catch (err: any) {
			if (err.statusCode) throw err;
			console.error('API Error - billing purchases my:', err);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch purchases',
			});
		} finally {
			await connection.end();
		}
	},
);
