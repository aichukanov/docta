import { getConnection } from '~/server/common/db-mysql';
import {
	validateBody,
	validateCityId,
	validateDoctorLanguageIds,
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

		if (!validateBody(body, 'api/clinics/add')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}
		if (!validateCityId(body, 'api/clinics/add')) {
			setResponseStatus(event, 400, 'Invalid city');
			return null;
		}
		if (!validateDoctorLanguageIds(body, 'api/clinics/add')) {
			setResponseStatus(event, 400, 'Invalid clinic language');
			return null;
		}

		const addClinicQuery = `
			INSERT INTO clinics (name, city_id, address, town, postal_code, latitude, longitude, phone, email, website, facebook, instagram, telegram, whatsapp, viber)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
		`;

		const addClinicQueryParams = [
			body.name,
			body.cityId,
			body.address,
			body.town || '',
			body.postalCode || '',
			body.latitude,
			body.longitude,
			body.phone,
			body.email,
			body.website,
			body.facebook,
			body.instagram,
			body.telegram,
			body.whatsapp,
			body.viber,
		];

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			const [insertResult]: any = await connection.execute(
				addClinicQuery,
				addClinicQueryParams,
			);

			const clinicId: number = insertResult.insertId;

			for (let i = 0; i < body.languageIds.length; i++) {
				const languageId = body.languageIds[i];
				const languageQuery = `
					INSERT INTO clinic_languages (clinic_id, language_id) VALUES (?, ?);
				`;
				const languageQueryParams = [clinicId, languageId];
				await connection.execute(languageQuery, languageQueryParams);
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
		console.error('API Error - clinic add:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to add clinic',
		});
	}
});
