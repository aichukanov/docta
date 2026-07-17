import type Stripe from 'stripe';
import type { Connection } from 'mysql2/promise';
import { getConnection } from '~/server/common/db-mysql';
import { getStripe } from '~/server/utils/stripe';
import {
	sendPurchaseConfirmationEmail,
	type PurchasedServiceLine,
} from '~/server/utils/billing-email';
import { createModuleLogger, logError } from '~/server/utils/logger';

const billingLogger = createModuleLogger('billing-webhook');

/**
 * Stripe webhook (checkout.session.completed / expired).
 *
 * Идемпотентность: заказ блокируется FOR UPDATE; если он уже completed,
 * повторная доставка события ничего не делает. Активация и смена статусов
 * происходят в одной транзакции — при ошибке отдаём 500, Stripe ретраит.
 */
export default defineEventHandler(async (event) => {
	const stripe = getStripe();
	const webhookSecret = useRuntimeConfig().stripeWebhookSecret;

	if (!stripe || !webhookSecret) {
		throw createError({
			statusCode: 503,
			statusMessage: 'Payment is not configured',
		});
	}

	const signature = getHeader(event, 'stripe-signature');
	const rawBody = await readRawBody(event);

	if (!signature || !rawBody) {
		throw createError({ statusCode: 400, statusMessage: 'Invalid request' });
	}

	let stripeEvent: Stripe.Event;
	try {
		stripeEvent = stripe.webhooks.constructEvent(
			rawBody,
			signature,
			webhookSecret,
		);
	} catch (err) {
		logError(billingLogger, 'Webhook signature verification failed', err);
		throw createError({ statusCode: 400, statusMessage: 'Invalid signature' });
	}

	if (
		stripeEvent.type !== 'checkout.session.completed' &&
		stripeEvent.type !== 'checkout.session.expired'
	) {
		return { received: true };
	}

	const session = stripeEvent.data.object as Stripe.Checkout.Session;
	const orderId = session.metadata?.orderId;

	if (!orderId) {
		billingLogger.warn('Checkout session without orderId metadata', {
			sessionId: session.id,
		});
		return { received: true };
	}

	if (stripeEvent.type === 'checkout.session.expired') {
		await markOrderFailed(orderId, session.id, 'Checkout session expired');
		return { received: true };
	}

	// checkout.session.completed
	if (session.payment_status !== 'paid') {
		billingLogger.warn('Session completed but not paid, skipping activation', {
			orderId,
			paymentStatus: session.payment_status,
		});
		return { received: true };
	}

	const activation = await activateOrder(orderId, session);

	// Email после коммита: сбой почты не должен приводить к ретраю webhook'а
	if (activation) {
		try {
			await sendPurchaseConfirmationEmail(activation);
		} catch (err) {
			logError(billingLogger, 'Failed to send purchase confirmation email', err, {
				orderId,
			});
		}
	}

	return { received: true };
});

async function markOrderFailed(
	orderId: string,
	sessionId: string,
	reason: string,
): Promise<void> {
	const connection = await getConnection();
	try {
		await connection.execute(
			`UPDATE billing_payment_transactions
			 SET status = 'failed', error_message = ?
			 WHERE session_id = ? AND status = 'pending'`,
			[reason, sessionId],
		);
		// Истёкшая сессия не отменяет уже завершённый заказ. Заказ с другой
		// живой (pending) сессией тоже не трогаем: пользователь пересоздал
		// оплату, и старая сессия истекает штатно
		await connection.execute(
			`UPDATE billing_orders o SET o.status = 'failed'
			 WHERE o.id = ? AND o.status NOT IN ('completed', 'cancelled')
			 AND NOT EXISTS (
				SELECT 1 FROM billing_payment_transactions t
				WHERE t.order_id = o.id AND t.status = 'pending'
			 )`,
			[orderId],
		);
	} finally {
		await connection.end();
	}
}

interface ActivationEmailData {
	to: string;
	locale: string | null;
	clinicName: string;
	lines: PurchasedServiceLine[];
	totalCents: number;
}

/**
 * Активирует услуги по оплаченному заказу. Возвращает данные для email
 * или null, если заказ уже был активирован (повторный webhook).
 */
async function activateOrder(
	orderId: string,
	session: Stripe.Checkout.Session,
): Promise<ActivationEmailData | null> {
	const connection = await getConnection();
	try {
		await connection.beginTransaction();

		const [orderRows]: any = await connection.execute(
			`SELECT id, clinic_id, status, total_amount_cents
			 FROM billing_orders WHERE id = ? FOR UPDATE`,
			[orderId],
		);

		if (!orderRows.length) {
			billingLogger.warn('Webhook for unknown order', { orderId });
			await connection.rollback();
			return null;
		}

		const order = orderRows[0];
		if (order.status === 'completed') {
			// Повторная доставка того же события (транзакция уже success) — no-op.
			// Оплата ДРУГОЙ сессии уже завершённого заказа — двойное списание:
			// не активируем повторно, помечаем транзакцию для ручного возврата
			const [marked]: any = await connection.execute(
				`UPDATE billing_payment_transactions
				 SET status = 'failed',
					 error_message = 'Duplicate payment for completed order — manual refund required'
				 WHERE session_id = ? AND status = 'pending'`,
				[session.id],
			);
			await connection.commit();
			if (marked.affectedRows > 0) {
				billingLogger.error('Duplicate payment for completed order', {
					orderId,
					sessionId: session.id,
					paymentIntent: session.payment_intent || null,
				});
			}
			return null;
		}
		if (order.status === 'cancelled') {
			// Сессия пережила отмену заказа (не успела погаснуть) и была
			// оплачена: активировать нечего, деньги требуют ручного возврата
			await connection.execute(
				`UPDATE billing_payment_transactions
				 SET status = 'failed',
					 error_message = 'Paid after order cancellation — manual refund required'
				 WHERE session_id = ? AND status = 'pending'`,
				[session.id],
			);
			await connection.commit();
			billingLogger.error('Payment received for cancelled order', {
				orderId,
				sessionId: session.id,
				paymentIntent: session.payment_intent || null,
			});
			return null;
		}

		const [itemRows]: any = await connection.execute(
			`SELECT service_id, months, price_cents
			 FROM billing_order_items WHERE order_id = ?`,
			[orderId],
		);

		const items = itemRows as Array<{
			service_id: number;
			months: number;
			price_cents: number;
		}>;

		// Услуги с разными периодами получают разные valid_until —
		// группируем по периоду, по purchase-записи на каждую группу
		// (та же таблица, что у админки: активируются сразу).
		const byMonths = new Map<number, typeof items>();
		for (const item of items) {
			if (!byMonths.has(item.months)) byMonths.set(item.months, []);
			byMonths.get(item.months)!.push(item);
		}

		const emailLines: PurchasedServiceLine[] = [];

		for (const [months, groupItems] of byMonths) {
			const groupCents = groupItems.reduce(
				(sum, item) => sum + item.price_cents,
				0,
			);
			const validUntil = new Date();
			validUntil.setMonth(validUntil.getMonth() + months);

			// Legacy-таблица хранит цену в евро (DECIMAL)
			const [purchaseResult]: any = await connection.execute(
				`INSERT INTO billing_clinic_service_purchases
					(clinic_id, price, purchased_at, valid_until, deleted)
				 VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? MONTH), 0)`,
				[order.clinic_id, groupCents / 100, months],
			);

			for (const item of groupItems) {
				await connection.execute(
					`INSERT INTO billing_clinic_service_purchase_items (purchase_id, service_id)
					 VALUES (?, ?)`,
					[purchaseResult.insertId, item.service_id],
				);
				emailLines.push({
					serviceId: item.service_id,
					months: item.months,
					priceCents: item.price_cents,
					validUntil,
				});
			}
		}

		await connection.execute(
			`UPDATE billing_orders SET status = 'completed' WHERE id = ?`,
			[orderId],
		);

		await connection.execute(
			`UPDATE billing_payment_transactions
			 SET status = 'success', metadata = ?
			 WHERE session_id = ?`,
			[
				JSON.stringify({
					paymentIntent: session.payment_intent || null,
					eventId: session.id,
				}),
				session.id,
			],
		);

		const emailData = await loadEmailData(
			connection,
			order.clinic_id,
			emailLines,
			order.total_amount_cents,
		);

		await connection.commit();

		billingLogger.info('Order activated', {
			orderId,
			clinicId: order.clinic_id,
			totalCents: order.total_amount_cents,
		});

		return emailData;
	} catch (err) {
		await connection.rollback();
		logError(billingLogger, 'Order activation failed', err, { orderId });
		// 500 → Stripe повторит доставку (retry-механизм вместо ручной активации)
		throw createError({
			statusCode: 500,
			statusMessage: 'Activation failed',
		});
	} finally {
		await connection.end();
	}
}

async function loadEmailData(
	connection: Connection,
	clinicId: number,
	lines: PurchasedServiceLine[],
	totalCents: number,
): Promise<ActivationEmailData | null> {
	const [rows]: any = await connection.execute(
		`SELECT u.email, u.preferred_locale, c.name_sr
		 FROM clinics c
		 JOIN auth_users u ON u.id = c.created_by
		 WHERE c.id = ?`,
		[clinicId],
	);

	const owner = (rows as any[])[0];
	if (!owner?.email) return null;

	return {
		to: owner.email,
		locale: owner.preferred_locale || null,
		clinicName: owner.name_sr || `#${clinicId}`,
		lines,
		totalCents,
	};
}
