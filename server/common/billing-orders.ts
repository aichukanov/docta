import type { Connection } from 'mysql2/promise';
import type { User } from '~/server/utils/session';
import type {
	BillingOrderDetails,
	BillingOrderStatus,
} from '~/interfaces/billing';
import { getOwnedClinic } from '~/server/common/clinic-cabinet';
import { ERROR_CODES, createErrorResponse } from '~/server/utils/api-codes';

/**
 * Загружает заказ с позициями и проверяет, что пользователь — владелец
 * клиники заказа (или админ). Бросает 404/403 с кодом.
 */
export async function getOwnedOrder(
	connection: Connection,
	orderId: string,
	user: User,
): Promise<BillingOrderDetails> {
	if (!orderId || typeof orderId !== 'string' || orderId.length > 36) {
		createErrorResponse(400, ERROR_CODES.ORDER_INVALID_DATA);
	}

	const [rows]: any = await connection.execute(
		`SELECT id, clinic_id, status, total_amount_cents, currency, created_at
		 FROM billing_orders WHERE id = ?`,
		[orderId],
	);

	if (!rows.length) {
		createErrorResponse(404, ERROR_CODES.ORDER_NOT_FOUND);
	}

	const order = rows[0];
	// Владелец клиники заказа или админ; бросает 403/404
	await getOwnedClinic(connection, order.clinic_id, user);

	const [itemRows]: any = await connection.execute(
		`SELECT service_id, months, price_cents
		 FROM billing_order_items WHERE order_id = ? ORDER BY service_id`,
		[orderId],
	);

	return {
		id: order.id,
		clinicId: order.clinic_id,
		status: order.status as BillingOrderStatus,
		totalAmountCents: order.total_amount_cents,
		currency: order.currency,
		items: (itemRows as any[]).map((row) => ({
			serviceId: row.service_id,
			months: row.months,
			priceCents: row.price_cents,
		})),
		createdAt:
			order.created_at instanceof Date
				? order.created_at.toISOString()
				: String(order.created_at),
	};
}
