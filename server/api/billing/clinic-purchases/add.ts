import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import {
	validateBody,
	validateNonNegativeInteger,
	validateNonNegativeNumber,
} from '~/common/validation';

function isValidDate(value: string) {
	return typeof value === 'string' && !Number.isNaN(Date.parse(value));
}

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/billing/clinic-purchases/add')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.clinicId)) {
			setResponseStatus(event, 400, 'Invalid clinic id');
			return false;
		}

		if (!validateNonNegativeNumber(body.price)) {
			setResponseStatus(event, 400, 'Invalid price');
			return false;
		}

		if (!Array.isArray(body.serviceIds) || body.serviceIds.length === 0) {
			setResponseStatus(event, 400, 'Invalid service ids');
			return false;
		}

		if (!body.serviceIds.every((id: string) => validateNonNegativeInteger(id))) {
			setResponseStatus(event, 400, 'Invalid service id value');
			return false;
		}

		if (!isValidDate(body.purchasedAt) || !isValidDate(body.validUntil)) {
			setResponseStatus(event, 400, 'Invalid dates');
			return false;
		}

		const purchasedAt = new Date(body.purchasedAt);
		const validUntil = new Date(body.validUntil);
		if (validUntil < purchasedAt) {
			setResponseStatus(event, 400, 'Invalid dates range');
			return false;
		}

		const serviceIds = Array.from(new Set(body.serviceIds.map(Number)));
		const connection = await getConnection();

		try {
			await connection.beginTransaction();
			const [purchaseResult]: any = await connection.execute(
				`INSERT INTO billing_clinic_service_purchases 
				 (clinic_id, price, purchased_at, valid_until, deleted)
				 VALUES (?, ?, ?, ?, 0)`,
				[body.clinicId, body.price, body.purchasedAt, body.validUntil],
			);

			const purchaseId = purchaseResult.insertId;
			for (const serviceId of serviceIds) {
				await connection.execute(
					`INSERT INTO billing_clinic_service_purchase_items (purchase_id, service_id)
					 VALUES (?, ?)`,
					[purchaseId, serviceId],
				);
			}

			await connection.commit();
			await connection.end();
			return true;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - billing purchases add:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to add billing purchase',
		});
	}
});
