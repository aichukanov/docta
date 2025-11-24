import { getConnection } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		const adminCookie = getCookie(event, 'adm');
		if (adminCookie !== 'xpycm') {
			throw createError({
				statusCode: 404,
				statusMessage: 'Not found',
			});
		}

		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/remove')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.clinicId)) {
			setResponseStatus(event, 400, 'Invalid clinic id');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Удаляем все связи клиники
			// 1. Удаляем связи с языками
			const deleteLanguagesQuery =
				'DELETE FROM clinic_languages WHERE clinic_id = ?';
			await connection.execute(deleteLanguagesQuery, [body.clinicId]);

			// 2. Удаляем связи с врачами
			const deleteDoctorsQuery =
				'DELETE FROM doctor_clinics WHERE clinic_id = ?';
			await connection.execute(deleteDoctorsQuery, [body.clinicId]);

			// 3. Удаляем саму клинику
			const deleteClinicQuery = 'DELETE FROM clinics WHERE id = ?';
			const [result]: any = await connection.execute(deleteClinicQuery, [
				body.clinicId,
			]);

			await connection.commit();
			await connection.end();

			return result.affectedRows > 0;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - clinic remove:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to remove clinic',
		});
	}
});

