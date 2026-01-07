import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

interface ClinicAdminData {
	id: number;
	name_sr: string;
	name_ru: string;
	name_sr_cyrl: string;
	cityId: number;
	address_sr: string;
	address_sr_cyrl: string;
	town_sr: string;
	town_sr_cyrl: string;
	postalCode: string;
	latitude: number;
	longitude: number;
	phone: string;
	email: string;
	facebook: string;
	instagram: string;
	telegram: string;
	whatsapp: string;
	viber: string;
	website: string;
	description_sr: string;
	description_sr_cyrl: string;
	description_en: string;
	description_ru: string;
	description_de: string;
	description_tr: string;
	languageIds: number[];
}

export default defineEventHandler(
	async (event): Promise<ClinicAdminData | null> => {
		try {
			requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/admin-details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return null;
			}

			const connection = await getConnection();

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
				WHERE c.id = ?
				GROUP BY c.id;
			`;

			const [clinicRows] = await connection.execute(clinicsQuery, [
				body.clinicId,
			]);

			await connection.end();

			const clinic = clinicRows[0];
			if (!clinic) {
				return null;
			}

			return {
				id: clinic.id,
				name_sr: clinic.name_sr || '',
				name_ru: clinic.name_ru || '',
				name_sr_cyrl: clinic.name_sr_cyrl || '',
				cityId: clinic.cityId,
				address_sr: clinic.address_sr || '',
				address_sr_cyrl: clinic.address_sr_cyrl || '',
				town_sr: clinic.town_sr || '',
				town_sr_cyrl: clinic.town_sr_cyrl || '',
				postalCode: clinic.postalCode || '',
				latitude: clinic.latitude || 0,
				longitude: clinic.longitude || 0,
				phone: clinic.phone || '',
				email: clinic.email || '',
				facebook: clinic.facebook || '',
				instagram: clinic.instagram || '',
				telegram: clinic.telegram || '',
				whatsapp: clinic.whatsapp || '',
				viber: clinic.viber || '',
				website: clinic.website || '',
				description_sr: clinic.description_sr || '',
				description_sr_cyrl: clinic.description_sr_cyrl || '',
				description_en: clinic.description_en || '',
				description_ru: clinic.description_ru || '',
				description_de: clinic.description_de || '',
				description_tr: clinic.description_tr || '',
				languageIds: clinic.languageIds
					? clinic.languageIds.split(',').map(Number)
					: [1],
			};
		} catch (error) {
			console.error('API Error - clinic admin details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch clinic admin details',
			});
		}
	},
);
