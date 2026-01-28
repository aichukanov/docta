import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
	processLocalizedDescription,
} from '~/server/common/utils';
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

		const locale = body.locale || 'en';

		const clinicsQuery = `
			SELECT
				c.id,
				c.name_sr,
				c.name_ru,
				c.name_sr_cyrl,
				c.city_id as cityId,
				c.address_sr,
				c.address_sr_cyrl,
				c.town_sr,
				c.town_sr_cyrl,
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
				c.description_sr,
				c.description_sr_cyrl,
				c.description_en,
				c.description_ru,
				c.description_de,
				c.description_tr,
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds,
				COALESCE(
					GROUP_CONCAT(DISTINCT bspi.service_id ORDER BY bspi.service_id),
					''
				) as features
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			LEFT JOIN billing_clinic_service_purchases bscp
				ON c.id = bscp.clinic_id
				AND bscp.deleted = 0
				AND bscp.purchased_at <= NOW()
				AND bscp.valid_until >= NOW()
			LEFT JOIN billing_clinic_service_purchase_items bspi
				ON bscp.id = bspi.purchase_id
			WHERE c.id = ?
			GROUP BY c.id;
		`;

		const connection = await getConnection();
		const [clinicRows] = await connection.execute(clinicsQuery, [
			body.clinicId,
		]);
		await connection.end();

		const clinic = clinicRows[0];
		if (!clinic) {
			return null;
		}

		// Обрабатываем локализованные имена
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			clinic,
			locale,
		);

		// Обрабатываем локализованные town и address
		const address = processLocalizedFieldForClinic(clinic, 'address', locale);
		const town = processLocalizedFieldForClinic(clinic, 'town', locale);

		// Обрабатываем локализованное description
		const description = processLocalizedDescription(clinic, locale);
		const features = clinic.features
			? clinic.features.split(',').map(Number)
			: [];

		return {
			id: clinic.id,
			cityId: clinic.cityId,
			postalCode: clinic.postalCode,
			latitude: clinic.latitude,
			longitude: clinic.longitude,
			phone: clinic.phone,
			email: clinic.email,
			facebook: clinic.facebook,
			instagram: clinic.instagram,
			telegram: clinic.telegram,
			whatsapp: clinic.whatsapp,
			viber: clinic.viber,
			website: clinic.website,
			description,
			languageIds: clinic.languageIds,
			features,
			name,
			localName,
			address,
			town,
		};
	} catch (error) {
		console.error('API Error - clinic data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinic data',
		});
	}
});
