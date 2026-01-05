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

		// Валидация параметров
		if (!validateBody(body, 'api/doctors/merge')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.primaryDoctorId)) {
			setResponseStatus(event, 400, 'Invalid primary doctor id');
			return false;
		}

		if (!validateNonNegativeInteger(body.secondaryDoctorId)) {
			setResponseStatus(event, 400, 'Invalid secondary doctor id');
			return false;
		}

		if (body.primaryDoctorId === body.secondaryDoctorId) {
			setResponseStatus(event, 400, 'Cannot merge doctor with itself');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Проверяем существование обоих врачей
			const checkDoctorsQuery = 'SELECT id FROM doctors WHERE id IN (?, ?)';
			const [doctorRows]: any = await connection.execute(checkDoctorsQuery, [
				body.primaryDoctorId,
				body.secondaryDoctorId,
			]);

			if (doctorRows.length !== 2) {
				throw createError({
					statusCode: 400,
					statusMessage: 'One or both doctors not found',
				});
			}

			// 1. Объединяем специализации (без дублирования)
			const mergeSpecialtiesQuery = `
				INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id)
				SELECT ?, ds.specialty_id 
				FROM doctor_specialties ds 
				WHERE ds.doctor_id = ?
			`;
			await connection.execute(mergeSpecialtiesQuery, [
				body.primaryDoctorId,
				body.secondaryDoctorId,
			]);

			// 2. Объединяем языки (без дублирования)
			const mergeLanguagesQuery = `
				INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
				SELECT ?, dl.language_id 
				FROM doctor_languages dl 
				WHERE dl.doctor_id = ?
			`;
			await connection.execute(mergeLanguagesQuery, [
				body.primaryDoctorId,
				body.secondaryDoctorId,
			]);

			// 3. Объединяем клиники (без дублирования)
			const mergeClinicsQuery = `
				INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id)
				SELECT ?, dc.clinic_id 
				FROM doctor_clinics dc 
				WHERE dc.doctor_id = ?
			`;
			await connection.execute(mergeClinicsQuery, [
				body.primaryDoctorId,
				body.secondaryDoctorId,
			]);

			// 4. Заполняем пустые поля первого врача данными из второго
			const updateDoctorQuery = `
				UPDATE doctors d1 
				JOIN doctors d2 ON d2.id = ?
				SET 
					d1.name_sr = COALESCE(NULLIF(d1.name_sr, ''), d2.name_sr),
					d1.professional_title = COALESCE(NULLIF(d1.professional_title, ''), d2.professional_title),
					d1.email = COALESCE(NULLIF(d1.email, ''), d2.email),
					d1.phone = COALESCE(NULLIF(d1.phone, ''), d2.phone),
					d1.website = COALESCE(NULLIF(d1.website, ''), d2.website),
					d1.photo_url = COALESCE(NULLIF(d1.photo_url, ''), d2.photo_url),
					d1.facebook = COALESCE(NULLIF(d1.facebook, ''), d2.facebook),
					d1.instagram = COALESCE(NULLIF(d1.instagram, ''), d2.instagram),
					d1.telegram = COALESCE(NULLIF(d1.telegram, ''), d2.telegram),
					d1.whatsapp = COALESCE(NULLIF(d1.whatsapp, ''), d2.whatsapp),
					d1.viber = COALESCE(NULLIF(d1.viber, ''), d2.viber)
				WHERE d1.id = ?
			`;
			await connection.execute(updateDoctorQuery, [
				body.secondaryDoctorId,
				body.primaryDoctorId,
			]);

			// 5. Удаляем связи второго врача
			const deleteSecondarySpecialtiesQuery =
				'DELETE FROM doctor_specialties WHERE doctor_id = ?';
			await connection.execute(deleteSecondarySpecialtiesQuery, [
				body.secondaryDoctorId,
			]);

			const deleteSecondaryLanguagesQuery =
				'DELETE FROM doctor_languages WHERE doctor_id = ?';
			await connection.execute(deleteSecondaryLanguagesQuery, [
				body.secondaryDoctorId,
			]);

			const deleteSecondaryClinicsQuery =
				'DELETE FROM doctor_clinics WHERE doctor_id = ?';
			await connection.execute(deleteSecondaryClinicsQuery, [
				body.secondaryDoctorId,
			]);

			// 6. Обновляем существующие редиректы и добавляем новый
			// Если A → B, а теперь B → C, то обновляем A → C
			const updateOldRedirectsQuery = `
				UPDATE doctor_redirects SET new_id = ? WHERE new_id = ?
			`;
			await connection.execute(updateOldRedirectsQuery, [
				body.primaryDoctorId,
				body.secondaryDoctorId,
			]);

			const saveRedirectQuery = `
				INSERT IGNORE INTO doctor_redirects (old_id, new_id)
				VALUES (?, ?)
			`;
			await connection.execute(saveRedirectQuery, [
				body.secondaryDoctorId,
				body.primaryDoctorId,
			]);

			// 7. Удаляем второго врача
			const deleteSecondaryDoctorQuery = 'DELETE FROM doctors WHERE id = ?';
			const [result]: any = await connection.execute(
				deleteSecondaryDoctorQuery,
				[body.secondaryDoctorId],
			);

			await connection.commit();
			await connection.end();

			// Проверяем, был ли второй врач успешно удален
			return result.affectedRows > 0;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - doctor merge:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to merge doctors',
		});
	}
});
