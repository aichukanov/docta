import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/services/merge')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.primaryServiceId)) {
			setResponseStatus(event, 400, 'Invalid primary service id');
			return false;
		}

		if (!validateNonNegativeInteger(body.secondaryServiceId)) {
			setResponseStatus(event, 400, 'Invalid secondary service id');
			return false;
		}

		if (body.primaryServiceId === body.secondaryServiceId) {
			setResponseStatus(event, 400, 'Cannot merge service with itself');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Проверяем существование обеих услуг
			const [serviceRows]: any = await connection.execute(
				'SELECT id, name_sr FROM medical_services WHERE id IN (?, ?)',
				[body.primaryServiceId, body.secondaryServiceId],
			);

			if (serviceRows.length !== 2) {
				throw createError({
					statusCode: 400,
					statusMessage: 'One or both services not found',
				});
			}

			// 1. Переносим связи с клиниками (только те, которых ещё нет)
			await connection.execute(
				`INSERT INTO clinic_medical_services (medical_service_id, clinic_id, price, code)
				 SELECT ?, clinic_id, price, code
				 FROM clinic_medical_services src
				 WHERE src.medical_service_id = ?
				 AND NOT EXISTS (
				   SELECT 1 FROM clinic_medical_services dest
				   WHERE dest.medical_service_id = ? AND dest.clinic_id = src.clinic_id
				 )`,
				[body.primaryServiceId, body.secondaryServiceId, body.primaryServiceId],
			);

			// 2. Переносим специальности (только те, которых ещё нет)
			await connection.execute(
				`INSERT INTO medical_services_specialties (medical_service_id, specialty_id)
				 SELECT ?, specialty_id
				 FROM medical_services_specialties src
				 WHERE src.medical_service_id = ?
				 AND NOT EXISTS (
				   SELECT 1 FROM medical_services_specialties dest
				   WHERE dest.medical_service_id = ? AND dest.specialty_id = src.specialty_id
				 )`,
				[body.primaryServiceId, body.secondaryServiceId, body.primaryServiceId],
			);

			// 3. Удаляем связи удаляемой услуги
			await connection.execute(
				'DELETE FROM clinic_medical_services WHERE medical_service_id = ?',
				[body.secondaryServiceId],
			);
			await connection.execute(
				'DELETE FROM medical_services_specialties WHERE medical_service_id = ?',
				[body.secondaryServiceId],
			);

			// 4. Удаляем услугу
			const [result]: any = await connection.execute(
				'DELETE FROM medical_services WHERE id = ?',
				[body.secondaryServiceId],
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
		console.error('API Error - service merge:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to merge services',
		});
	}
});
