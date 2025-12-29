import { getConnection } from '~/server/common/db-mysql';
import {
	validateBody,
	validateCityId,
	validateDoctorLanguageIds,
	validateNonNegativeInteger,
} from '~/common/validation';

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

		if (!validateBody(body, 'api/clinics/update')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.id)) {
			setResponseStatus(event, 400, 'Invalid clinic id');
			return null;
		}

		if (!validateCityId(body, 'api/clinics/update')) {
			setResponseStatus(event, 400, 'Invalid city');
			return null;
		}
		if (!validateDoctorLanguageIds(body, 'api/clinics/update')) {
			setResponseStatus(event, 400, 'Invalid clinic language');
			return null;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			const updateClinicQuery = `
				UPDATE clinics 
				SET name = ?, city_id = ?, address = ?, town = ?, postal_code = ?, latitude = ?, longitude = ?,
				    phone = ?, email = ?, website = ?, facebook = ?, instagram = ?, 
				    telegram = ?, whatsapp = ?, viber = ?,
				    description_sr = ?, description_en = ?, description_ru = ?, description_de = ?, description_tr = ?
				WHERE id = ?;
			`;

			await connection.execute(updateClinicQuery, [
				body.name,
				body.cityId,
				body.address || '',
				body.town || '',
				body.postalCode || '',
				body.latitude || 0,
				body.longitude || 0,
				body.phone || '',
				body.email || '',
				body.website || '',
				body.facebook || '',
				body.instagram || '',
				body.telegram || '',
				body.whatsapp || '',
				body.viber || '',
				body.description_sr || '',
				body.description_en || '',
				body.description_ru || '',
				body.description_de || '',
				body.description_tr || '',
				body.id,
			]);

			// Handle languages
			const [existingLanguages]: any = await connection.execute(
				'SELECT language_id FROM clinic_languages WHERE clinic_id = ?',
				[body.id],
			);
			const existingLanguageIds = existingLanguages.map(
				(row: any) => row.language_id,
			);
			const newLanguageIds = body.languageIds;

			const languagesToRemove = existingLanguageIds.filter(
				(id: number) => !newLanguageIds.includes(id),
			);
			const languagesToAdd = newLanguageIds.filter(
				(id: number) => !existingLanguageIds.includes(id),
			);

			if (languagesToRemove.length > 0) {
				const placeholders = languagesToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM clinic_languages WHERE clinic_id = ? AND language_id IN (${placeholders})`,
					[body.id, ...languagesToRemove],
				);
			}

			for (const languageId of languagesToAdd) {
				await connection.execute(
					'INSERT INTO clinic_languages (clinic_id, language_id) VALUES (?, ?)',
					[body.id, languageId],
				);
			}

			await connection.commit();
			await connection.end();

			return true;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - clinic update:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to update clinic',
		});
	}
});
