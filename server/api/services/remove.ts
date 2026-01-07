import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/services/remove')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.serviceId)) {
			setResponseStatus(event, 400, 'Invalid service id');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Удаляем связи
			await connection.execute(
				'DELETE FROM clinic_medical_services WHERE medical_service_id = ?',
				[body.serviceId],
			);
			await connection.execute(
				'DELETE FROM medical_services_specialties WHERE medical_service_id = ?',
				[body.serviceId],
			);

			// Удаляем услугу
			const [result]: any = await connection.execute(
				'DELETE FROM medical_services WHERE id = ?',
				[body.serviceId],
			);

			await connection.commit();
			await connection.end();

			return result.affectedRows > 0;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - service remove:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to remove service',
		});
	}
});
