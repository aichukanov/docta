import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import type { ClinicPrice } from '~/interfaces/clinic';

interface ServiceAdminDetails {
	id: number;
	name_en: string;
	name_sr: string;
	name_sr_cyrl: string;
	name_ru: string;
	name_de: string;
	name_tr: string;
	sort_order: number | null;
	specialtyIds: number[];
	clinicPrices: ClinicPrice[];
}

export default defineEventHandler(
	async (event): Promise<ServiceAdminDetails | null> => {
		try {
			requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/services/admin-details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.serviceId)) {
				setResponseStatus(event, 400, 'Invalid service id');
				return null;
			}

			const connection = await getConnection();

			// Получаем основные данные услуги
			const [serviceRows]: any = await connection.execute(
				`SELECT id, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order 
				 FROM medical_services WHERE id = ?`,
				[body.serviceId],
			);

			if (!serviceRows.length) {
				await connection.end();
				return null;
			}

			const service = serviceRows[0];

			// Получаем специальности
			const [specialtyRows]: any = await connection.execute(
				`SELECT specialty_id FROM medical_services_specialties WHERE medical_service_id = ?`,
				[body.serviceId],
			);

			// Получаем цены клиник
			const [clinicPriceRows]: any = await connection.execute(
				`SELECT clinic_id, price, price_min, price_max, code FROM clinic_medical_services 
				 WHERE medical_service_id = ? ORDER BY clinic_id`,
				[body.serviceId],
			);

			await connection.end();

			const clinicPrices: ClinicPrice[] = clinicPriceRows.map((r: any) => ({
				clinicId: r.clinic_id,
				price: r.price,
				priceMin: r.price_min,
				priceMax: r.price_max,
				code: r.code,
			}));

			return {
				id: service.id,
				name_en: service.name_en || '',
				name_sr: service.name_sr || '',
				name_sr_cyrl: service.name_sr_cyrl || '',
				name_ru: service.name_ru || '',
				name_de: service.name_de || '',
				name_tr: service.name_tr || '',
				sort_order: service.sort_order,
				specialtyIds: specialtyRows.map((r: any) => r.specialty_id),
				clinicPrices,
			};
		} catch (error) {
			console.error('API Error - service admin details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch service details',
			});
		}
	},
);
