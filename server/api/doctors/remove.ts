import { getConnection } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		// Проверка админского доступа
		const adminCookie = getCookie(event, 'adm');
		if (adminCookie !== 'xpycm') {
			throw createError({
				statusCode: 404,
				statusMessage: 'Not found',
			});
		}

		const body = await readBody(event);

		// Валидация параметров (аналогично api/doctors/details)
		if (!validateBody(body, 'api/doctors/remove')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.doctorId)) {
			setResponseStatus(event, 400, 'Invalid doctor id');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Удаляем все связи врача
			// 1. Удаляем связи со специализациями
			const deleteSpecialtiesQuery =
				'DELETE FROM doctor_specialties WHERE doctor_id = ?';
			await connection.execute(deleteSpecialtiesQuery, [body.doctorId]);

			// 2. Удаляем связи с языками
			const deleteLanguagesQuery =
				'DELETE FROM doctor_languages WHERE doctor_id = ?';
			await connection.execute(deleteLanguagesQuery, [body.doctorId]);

			// 3. Удаляем связи с клиниками
			const deleteClinicsQuery =
				'DELETE FROM doctor_clinics WHERE doctor_id = ?';
			await connection.execute(deleteClinicsQuery, [body.doctorId]);

			// 4. Удаляем самого врача
			const deleteDoctorQuery = 'DELETE FROM doctors WHERE id = ?';
			const [result]: any = await connection.execute(deleteDoctorQuery, [
				body.doctorId,
			]);

			await connection.commit();
			await connection.end();

			// Проверяем, был ли врач действительно удален
			return result.affectedRows > 0;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - doctor remove:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to remove doctor',
		});
	}
});
