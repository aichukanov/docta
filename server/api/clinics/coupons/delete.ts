import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import { requireAdmin } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';

/**
 * Полное удаление купона — для ошибочно созданных записей. Снятие акции с
 * витрины делается флагом `is_active` через save (историю купона надо
 * сохранять: по нему уже могли прийти пациенты).
 */
export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/coupons/delete')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.couponId)) {
			setResponseStatus(event, 400, 'Invalid coupon id');
			return false;
		}

		const connection = await getConnection();
		await connection.execute('DELETE FROM clinic_coupons WHERE id = ?', [
			Number(body.couponId),
		]);
		await connection.end();

		return true;
	} catch (error) {
		console.error('API Error - clinic coupon delete:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to delete clinic coupon',
		});
	}
});
