import { getConnection } from '~/server/common/db-mysql';
import { requireUser } from '~/server/common/clinic-cabinet';
import { getOwnedOrder } from '~/server/common/billing-orders';
import type { BillingOrderDetails } from '~/interfaces/billing';

// Детали заказа для владельца клиники: checkout-страница и поллинг
// статуса активации на success-странице.
export default defineEventHandler(
	async (event): Promise<BillingOrderDetails> => {
		const user = await requireUser(event);
		const orderId = getRouterParam(event, 'id') || '';

		const connection = await getConnection();
		try {
			return await getOwnedOrder(connection, orderId, user);
		} catch (err: any) {
			if (err.statusCode) throw err;
			console.error('API Error - billing order details:', err);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch order',
			});
		} finally {
			await connection.end();
		}
	},
);
