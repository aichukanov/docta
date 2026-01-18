import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

interface BillingPurchase {
	id: number;
	clinicId: number;
	price: number;
	purchasedAt: string;
	validUntil: string;
	serviceIds: number[];
	deleted: boolean;
}

export default defineEventHandler(
	async (event): Promise<{ purchases: BillingPurchase[] }> => {
		try {
			requireAdmin(event);

			const body = await readBody(event);
			if (!validateBody(body, 'api/billing/clinic-purchases/list')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return { purchases: [] };
			}

			if (!validateNonNegativeInteger(body.clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return { purchases: [] };
			}

			const connection = await getConnection();
			const [rows]: any = await connection.execute(
				`SELECT
					p.id,
					p.clinic_id as clinicId,
					p.price,
					p.purchased_at as purchasedAt,
					p.valid_until as validUntil,
					p.deleted,
					COALESCE(GROUP_CONCAT(DISTINCT i.service_id ORDER BY i.service_id), '') as serviceIds
				FROM billing_clinic_service_purchases p
				LEFT JOIN billing_clinic_service_purchase_items i
					ON p.id = i.purchase_id
				WHERE p.clinic_id = ?
				GROUP BY p.id
				ORDER BY p.purchased_at DESC`,
				[body.clinicId],
			);
			await connection.end();

			const purchases = (rows as any[]).map((row) => ({
				id: row.id,
				clinicId: row.clinicId,
				price: row.price,
				purchasedAt: row.purchasedAt,
				validUntil: row.validUntil,
				deleted: Boolean(row.deleted),
				serviceIds: row.serviceIds
					? String(row.serviceIds).split(',').map(Number)
					: [],
			}));

			return { purchases };
		} catch (error) {
			console.error('API Error - billing purchases list:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch billing purchases',
			});
		}
	},
);
