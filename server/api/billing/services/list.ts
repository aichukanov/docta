import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';

interface BillingService {
	id: number;
	name: string;
}

export default defineEventHandler(
	async (event): Promise<{ services: BillingService[] }> => {
		try {
			await requireAdmin(event);

			const connection = await getConnection();
			const [rows] = await connection.execute(
				'SELECT id, name FROM billing_paid_services ORDER BY id',
			);
			await connection.end();

			return {
				services: rows as BillingService[],
			};
		} catch (error) {
			console.error('API Error - billing services list:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch billing services',
			});
		}
	},
);
