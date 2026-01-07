import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import type { ClinicPrice } from '~/interfaces/clinic';

interface UpdateServiceBody {
	id: number;
	name_en: string;
	name_sr: string;
	name_sr_cyrl?: string;
	name_ru?: string;
	name_de?: string;
	name_tr?: string;
	sort_order?: number | null;
	specialtyIds: number[];
	clinicPrices: ClinicPrice[];
}

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		requireAdmin(event);

		const body: UpdateServiceBody = await readBody(event);

		if (!validateBody(body, 'api/services/update')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.id)) {
			setResponseStatus(event, 400, 'Invalid service id');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// 1. Обновляем основные данные услуги
			const updateQuery = `
				UPDATE medical_services SET
					name_en = ?,
					name_sr = ?,
					name_sr_cyrl = ?,
					name_ru = ?,
					name_de = ?,
					name_tr = ?,
					sort_order = ?
				WHERE id = ?
			`;
			await connection.execute(updateQuery, [
				body.name_en,
				body.name_sr,
				body.name_sr_cyrl || '',
				body.name_ru || '',
				body.name_de || '',
				body.name_tr || '',
				body.sort_order ?? null,
				body.id,
			]);

			// 2. Обновляем специальности (только дифф)
			const [existingSpecialties]: any = await connection.execute(
				'SELECT specialty_id FROM medical_services_specialties WHERE medical_service_id = ?',
				[body.id],
			);
			const existingSpecialtyIds = existingSpecialties.map(
				(row: any) => row.specialty_id,
			);
			const newSpecialtyIds = body.specialtyIds || [];

			const specialtiesToRemove = existingSpecialtyIds.filter(
				(id: number) => !newSpecialtyIds.includes(id),
			);
			const specialtiesToAdd = newSpecialtyIds.filter(
				(id: number) => !existingSpecialtyIds.includes(id),
			);

			if (specialtiesToRemove.length > 0) {
				const placeholders = specialtiesToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM medical_services_specialties 
					 WHERE medical_service_id = ? AND specialty_id IN (${placeholders})`,
					[body.id, ...specialtiesToRemove],
				);
			}

			for (const specialtyId of specialtiesToAdd) {
				await connection.execute(
					'INSERT INTO medical_services_specialties (medical_service_id, specialty_id) VALUES (?, ?)',
					[body.id, specialtyId],
				);
			}

			// 3. Обновляем цены клиник (только дифф)
			const [existingClinicPrices]: any = await connection.execute(
				'SELECT clinic_id, price, code FROM clinic_medical_services WHERE medical_service_id = ?',
				[body.id],
			);
			const existingClinicIds = existingClinicPrices.map(
				(row: any) => row.clinic_id,
			);
			const newClinicPrices = body.clinicPrices || [];
			const newClinicIds = newClinicPrices.map((cp) => cp.clinicId);

			// Удаляем клиники, которых больше нет
			const clinicsToRemove = existingClinicIds.filter(
				(id: number) => !newClinicIds.includes(id),
			);
			if (clinicsToRemove.length > 0) {
				const placeholders = clinicsToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM clinic_medical_services 
					 WHERE medical_service_id = ? AND clinic_id IN (${placeholders})`,
					[body.id, ...clinicsToRemove],
				);
			}

			// Обновляем или добавляем клиники
			for (const cp of newClinicPrices) {
				const existing = existingClinicPrices.find(
					(e: any) => e.clinic_id === cp.clinicId,
				);
				if (existing) {
					// Обновляем только если изменилось
					if (existing.price !== cp.price || existing.code !== cp.code) {
						await connection.execute(
							`UPDATE clinic_medical_services SET price = ?, code = ? 
							 WHERE medical_service_id = ? AND clinic_id = ?`,
							[cp.price || null, cp.code || null, body.id, cp.clinicId],
						);
					}
				} else {
					// Добавляем новую
					await connection.execute(
						`INSERT INTO clinic_medical_services (medical_service_id, clinic_id, price, code) 
						 VALUES (?, ?, ?, ?)`,
						[body.id, cp.clinicId, cp.price || null, cp.code || null],
					);
				}
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
		console.error('API Error - service update:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to update service',
		});
	}
});
