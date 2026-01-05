import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
	processLocalizedDescriptionForClinic,
} from '~/server/common/utils';
import type { ClinicList } from '~/interfaces/clinic';

export default defineEventHandler(async (event): Promise<ClinicList> => {
	try {
		const body = await readBody(event);
		const locale = body?.locale || 'en';

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
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			GROUP BY c.id
			ORDER BY c.name_sr ASC;
		`;

		const connection = await getConnection();
		const [clinics] = await connection.execute(clinicsQuery);
		await connection.end();

		// Обрабатываем локализованные имена, town, address и description
		const processedClinics = clinics.map((clinic: any) => {
			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				clinic,
				locale,
			);
			const address = processLocalizedFieldForClinic(clinic, 'address', locale);
			const town = processLocalizedFieldForClinic(clinic, 'town', locale);
			const description = processLocalizedDescriptionForClinic(clinic, locale);

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
				name,
				localName,
				address,
				town,
			};
		});

		return {
			clinics: processedClinics,
			totalCount: processedClinics.length,
		};
	} catch (error) {
		console.error('API Error - clinics:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinics',
		});
	}
});
