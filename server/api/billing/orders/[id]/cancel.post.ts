import { getConnection } from '~/server/common/db-mysql';
import { requireUser } from '~/server/common/clinic-cabinet';
import { getOwnedOrder } from '~/server/common/billing-orders';
import { getStripe } from '~/server/utils/stripe';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

// Отмена неоплаченного заказа (с checkout-страницы).
export default defineEventHandler(async (event) => {
	const user = await requireUser(event);
	const orderId = getRouterParam(event, 'id') || '';

	const connection = await getConnection();
	try {
		const order = await getOwnedOrder(connection, orderId, user);

		if (order.status === 'completed') {
			createErrorResponse(400, ERROR_CODES.ORDER_ALREADY_COMPLETED);
		}

		await connection.execute(
			`UPDATE billing_orders SET status = 'cancelled' WHERE id = ?`,
			[order.id],
		);

		// Отменённый заказ не должен оставаться платёжеспособным: гасим его
		// открытые Checkout-сессии, иначе оплата из «зависшей» вкладки Stripe
		// спишет деньги уже после отмены
		const [pendingSessions]: any = await connection.execute(
			`SELECT session_id FROM billing_payment_transactions
			 WHERE order_id = ? AND status = 'pending'`,
			[order.id],
		);
		const stripe = getStripe();
		for (const row of pendingSessions as Array<{ session_id: string }>) {
			try {
				await stripe?.checkout.sessions.expire(row.session_id);
			} catch {
				// сессия уже оплачена/истекла — итоговый статус разрулит webhook
			}
		}
		await connection.execute(
			`UPDATE billing_payment_transactions
			 SET status = 'failed', error_message = 'Order cancelled'
			 WHERE order_id = ? AND status = 'pending'`,
			[order.id],
		);

		return createSuccessResponse(SUCCESS_CODES.ORDER_CANCELLED);
	} catch (err: any) {
		if (err.statusCode) throw err;
		console.error('API Error - billing order cancel:', err);
		createErrorResponse(500, ERROR_CODES.ORDER_CREATE_FAILED);
	} finally {
		await connection.end();
	}
});
