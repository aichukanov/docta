import { randomUUID } from 'node:crypto';
import { getConnection } from '~/server/common/db-mysql';
import { requireUser, getOwnedClinic } from '~/server/common/clinic-cabinet';
import { validateNonNegativeInteger } from '~/common/validation';
import { BILLING_PERIODS } from '~/interfaces/billing';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

interface CreateOrderBody {
	clinicId: number;
	items: Array<{ serviceId: number; months: number }>;
}

export default defineEventHandler(async (event) => {
	const user = await requireUser(event);

	const body: CreateOrderBody = await readBody(event);
	if (
		!body ||
		!validateNonNegativeInteger(body.clinicId) ||
		!Array.isArray(body.items) ||
		body.items.length === 0 ||
		!body.items.every(
			(item) =>
				validateNonNegativeInteger(item?.serviceId) &&
				BILLING_PERIODS.includes(item?.months as any),
		)
	) {
		createErrorResponse(400, ERROR_CODES.ORDER_INVALID_DATA);
	}

	// Одна услуга в заказе не более одного раза
	const serviceIds = body.items.map((item) => item.serviceId);
	if (new Set(serviceIds).size !== serviceIds.length) {
		createErrorResponse(400, ERROR_CODES.ORDER_INVALID_DATA);
	}

	const connection = await getConnection();
	try {
		await getOwnedClinic(connection, body.clinicId, user);

		// Цены берём только из БД — клиентским не доверяем
		const placeholders = body.items.map(() => '(?, ?)').join(', ');
		const [priceRows]: any = await connection.execute(
			`SELECT service_id, months, price_cents
			 FROM billing_service_prices
			 WHERE active = TRUE AND (service_id, months) IN (${placeholders})`,
			body.items.flatMap((item) => [item.serviceId, item.months]),
		);

		const priceMap = new Map<string, number>();
		for (const row of priceRows as any[]) {
			priceMap.set(`${row.service_id}:${row.months}`, row.price_cents);
		}

		const items = body.items.map((item) => {
			const priceCents = priceMap.get(`${item.serviceId}:${item.months}`);
			if (priceCents == null) {
				createErrorResponse(400, ERROR_CODES.ORDER_INVALID_DATA, {
					serviceId: item.serviceId,
					months: item.months,
				});
			}
			return { ...item, priceCents: priceCents! };
		});

		const totalAmountCents = items.reduce(
			(sum, item) => sum + item.priceCents,
			0,
		);
		const orderId = randomUUID();

		await connection.beginTransaction();

		await connection.execute(
			`INSERT INTO billing_orders
				(id, clinic_id, created_by, status, total_amount_cents, currency)
			 VALUES (?, ?, ?, 'pending_payment', ?, 'EUR')`,
			[orderId, body.clinicId, user.id, totalAmountCents],
		);

		for (const item of items) {
			await connection.execute(
				`INSERT INTO billing_order_items (order_id, service_id, months, price_cents)
				 VALUES (?, ?, ?, ?)`,
				[orderId, item.serviceId, item.months, item.priceCents],
			);
		}

		await connection.commit();

		return createSuccessResponse(SUCCESS_CODES.ORDER_CREATED, {
			orderId,
			totalAmountCents,
			currency: 'EUR',
		});
	} catch (err: any) {
		await connection.rollback();
		if (err.statusCode) throw err;
		console.error('API Error - billing order create:', err);
		createErrorResponse(500, ERROR_CODES.ORDER_CREATE_FAILED);
	} finally {
		await connection.end();
	}
});
