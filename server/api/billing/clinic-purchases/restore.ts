import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/billing/clinic-purchases/restore')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.purchaseId)) {
			setResponseStatus(event, 400, 'Invalid purchase id');
			return false;
		}

		const connection = await getConnection();
		const [result]: any = await connection.execute(
			`UPDATE billing_clinic_service_purchases
			 SET deleted = 0
			 WHERE id = ?`,
			[body.purchaseId],
		);
		await connection.end();

		return result.affectedRows > 0;
	} catch (error) {
		console.error('API Error - billing purchases restore:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to restore billing purchase',
		});
	}
});
