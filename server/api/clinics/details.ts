import { getConnection } from '~/server/common/db-mysql';
import type { ClinicData } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<ClinicData> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/details')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.clinicId)) {
			setResponseStatus(event, 400, 'Invalid clinic id');
			return null;
		}

		const clinicsQuery = `
			SELECT
				c.id,
				c.name,
				c.city_id as cityId,
				c.address,
				c.town,
				c.postal_code as postalCode,
				c.latitude,
				c.longitude,
				c.phone,
				c.email,
				c.facebook,
				c.instagram,
				c.telegram,
				c.whatsapp,
				c.viber,
				c.website,
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			WHERE c.id = ?
			GROUP BY c.id;
		`;

		const connection = await getConnection();
		const [clinicRows] = await connection.execute(clinicsQuery, [
			body.clinicId,
		]);
		await connection.end();

		return clinicRows[0];
	} catch (error) {
		console.error('API Error - clinic data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinic data',
		});
	}
});
