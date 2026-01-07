import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody } from '~/common/validation';
import type { ClinicPrice } from '~/interfaces/clinic';

interface AddServiceBody {
	name: string;
	name_sr: string;
	name_sr_cyrl?: string;
	name_ru?: string;
	name_de?: string;
	name_tr?: string;
	sort_order?: number | null;
	specialtyIds?: number[];
	clinicPrices?: ClinicPrice[];
}

export default defineEventHandler(async (event): Promise<number | null> => {
	try {
		requireAdmin(event);

		const body: AddServiceBody = await readBody(event);

		if (!validateBody(body, 'api/services/add')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.name || !body.name_sr) {
			setResponseStatus(event, 400, 'Name and name_sr are required');
			return null;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// 1. Создаём услугу
			const insertQuery = `
				INSERT INTO medical_services (name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
				VALUES (?, ?, ?, ?, ?, ?, ?)
			`;
			const [result]: any = await connection.execute(insertQuery, [
				body.name,
				body.name_sr,
				body.name_sr_cyrl || '',
				body.name_ru || '',
				body.name_de || '',
				body.name_tr || '',
				body.sort_order ?? null,
			]);

			const serviceId = result.insertId;

			// 2. Добавляем специальности
			if (body.specialtyIds?.length > 0) {
				const specialtyValues = body.specialtyIds
					.map((specId) => `(${serviceId}, ${specId})`)
					.join(',');
				await connection.execute(
					`INSERT INTO medical_services_specialties (medical_service_id, specialty_id) 
					 VALUES ${specialtyValues}`,
				);
			}

			// 3. Добавляем связи с клиниками (с ценой и кодом)
			if (body.clinicPrices?.length > 0) {
				for (const cp of body.clinicPrices) {
					await connection.execute(
						`INSERT INTO clinic_medical_services (medical_service_id, clinic_id, price, price_max, code) 
						 VALUES (?, ?, ?, ?, ?)`,
						[
							serviceId,
							cp.clinicId,
							cp.price || null,
							cp.priceMax || null,
							cp.code || null,
						],
					);
				}
			}

			await connection.commit();
			await connection.end();

			return serviceId;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - service add:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to add service',
		});
	}
});
