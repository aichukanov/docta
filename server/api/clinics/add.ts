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
			INSERT INTO clinics (name_sr, city_id, address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code, latitude, longitude, phone, email, website, facebook, instagram, telegram, whatsapp, viber, description_sr, description_en, description_ru, description_de, description_tr)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
		`;

		const addClinicQueryParams = [
			body.name_sr || body.name || '',
			body.cityId,
			body.address_sr || body.address || '',
			body.address_sr_cyrl || '',
			body.town_sr || body.town || '',
			body.town_sr_cyrl || '',
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
			body.description_sr || '',
			body.description_en || '',
			body.description_ru || '',
			body.description_de || '',
			body.description_tr || '',
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
