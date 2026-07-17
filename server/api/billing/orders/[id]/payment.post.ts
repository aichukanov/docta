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

// Человекочитаемые названия для Stripe Checkout (форма Stripe не использует наш i18n)
const SERVICE_NAMES: Record<number, string> = {
	1: 'Dofollow links',
	2: 'Highlight in listings',
	3: 'Verified clinic badge',
};

export default defineEventHandler(async (event) => {
	const user = await requireUser(event);
	const orderId = getRouterParam(event, 'id') || '';

	const stripe = getStripe();
	if (!stripe) {
		createErrorResponse(503, ERROR_CODES.PAYMENT_NOT_CONFIGURED);
	}

	const connection = await getConnection();
	try {
		const order = await getOwnedOrder(connection, orderId, user);

		if (order.status === 'completed') {
			createErrorResponse(400, ERROR_CODES.ORDER_ALREADY_COMPLETED);
		}
		if (order.status === 'cancelled') {
			createErrorResponse(400, ERROR_CODES.ORDER_INVALID_DATA);
		}

		// Гасим прежние живые Checkout-сессии заказа: платёжеспособной должна
		// оставаться максимум одна, иначе две открытые вкладки оплаты
		// спишут деньги дважды (webhook активирует только первую)
		const [pendingSessions]: any = await connection.execute(
			`SELECT session_id FROM billing_payment_transactions
			 WHERE order_id = ? AND status = 'pending'`,
			[order.id],
		);
		for (const row of pendingSessions as Array<{ session_id: string }>) {
			try {
				await stripe!.checkout.sessions.expire(row.session_id);
			} catch {
				// сессия уже оплачена/истекла — итоговый статус разрулит webhook
			}
		}
		await connection.execute(
			`UPDATE billing_payment_transactions
			 SET status = 'failed', error_message = 'Superseded by a new payment attempt'
			 WHERE order_id = ? AND status = 'pending'`,
			[order.id],
		);

		const baseUrl = useRuntimeConfig().baseUrl || 'http://localhost:3000';
		const billingBase = `${baseUrl}/profile/clinics/${order.clinicId}/billing`;

		const session = await stripe!.checkout.sessions.create({
			mode: 'payment',
			payment_method_types: ['card'],
			line_items: order.items.map((item) => ({
				price_data: {
					currency: 'eur',
					product_data: {
						name: SERVICE_NAMES[item.serviceId] || `Service #${item.serviceId}`,
						description: `${item.months} mo`,
					},
					unit_amount: item.priceCents,
				},
				quantity: 1,
			})),
			success_url: `${billingBase}/success?order_id=${order.id}&session_id={CHECKOUT_SESSION_ID}`,
			cancel_url: `${billingBase}/error?order_id=${order.id}`,
			metadata: {
				orderId: order.id,
				clinicId: String(order.clinicId),
			},
		});

		// Лог транзакции (pending) + заказ переходит в processing.
		// transaction_id = Checkout Session id (уникален); payment_intent
		// придёт в webhook и сохранится в metadata.
		await connection.execute(
			`INSERT INTO billing_payment_transactions
				(order_id, transaction_id, payment_provider, amount_cents, currency,
				 status, payment_url, session_id)
			 VALUES (?, ?, 'stripe', ?, ?, 'pending', ?, ?)`,
			[
				order.id,
				session.id,
				order.totalAmountCents,
				order.currency,
				session.url || '',
				session.id,
			],
		);

		await connection.execute(
			`UPDATE billing_orders SET status = 'processing' WHERE id = ?`,
			[order.id],
		);

		return createSuccessResponse(SUCCESS_CODES.PAYMENT_SESSION_CREATED, {
			paymentUrl: session.url,
			sessionId: session.id,
		});
	} catch (err: any) {
		if (err.statusCode) throw err;
		console.error('API Error - billing payment init:', err);
		createErrorResponse(500, ERROR_CODES.PAYMENT_INIT_FAILED);
	} finally {
		await connection.end();
	}
});
