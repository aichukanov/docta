import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { syncDoctorRelation } from '~/server/common/doctor-relations';
import type { DoctorData } from '~/interfaces/doctor';
import {
	validateBody,
	validateSpecialtyIds,
	validateDoctorLanguageIds,
	validateClinicIds,
	validateNonNegativeInteger,
} from '~/common/validation';

interface DoctorServicePrice {
	clinicId: number;
	serviceId: number;
	price: number | null;
	priceMax: number | null;
}

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/doctors/update')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.id)) {
			setResponseStatus(event, 400, 'Invalid doctor id');
			return null;
		}

		if (!validateSpecialtyIds(body, 'api/doctors/update')) {
			setResponseStatus(event, 400, 'Invalid specialty');
			return null;
		}
		if (!validateDoctorLanguageIds(body, 'api/doctors/update')) {
			setResponseStatus(event, 400, 'Invalid doctor language');
			return null;
		}
		if (!validateClinicIds(body, 'api/doctors/update', true)) {
			setResponseStatus(event, 400, 'Invalid clinic');
			return null;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			const updateDoctorQuery = `
				UPDATE doctors 
				SET name_sr = ?, name_sr_cyrl = ?, name_ru = ?, name_en = ?, 
				    description_sr = ?, description_sr_cyrl = ?, description_ru = ?, description_en = ?, description_de = ?, description_tr = ?,
				    professional_title = ?, hidden = ?, email = ?, phone = ?, website = ?, 
				    photo_url = ?, facebook = ?, instagram = ?, telegram = ?, whatsapp = ?, viber = ?
				WHERE id = ?;
			`;

			await connection.execute(updateDoctorQuery, [
				body.name,
				body.name_sr_cyrl || '',
				body.name_ru || '',
				body.name_en || '',
				body.description_sr || '',
				body.description_sr_cyrl || '',
				body.description_ru || '',
				body.description_en || '',
				body.description_de || '',
				body.description_tr || '',
				body.professionalTitle || '',
				body.hidden ? 1 : 0,
				body.email || '',
				body.phone || '',
				body.website || '',
				body.photoUrl || '',
				body.facebook || '',
				body.instagram || '',
				body.telegram || '',
				body.whatsapp || '',
				body.viber || '',
				body.id,
			]);

			await syncDoctorRelation({
				connection,
				doctorId: body.id,
				table: 'doctor_specialties',
				column: 'specialty_id',
				newIds: body.specialtyIds,
			});

			await syncDoctorRelation({
				connection,
				doctorId: body.id,
				table: 'doctor_languages',
				column: 'language_id',
				newIds: body.languageIds,
			});

			await syncDoctorRelation({
				connection,
				doctorId: body.id,
				table: 'doctor_clinics',
				column: 'clinic_id',
				newIds: body.clinicIds,
			});

			// Handle service prices (clinic_medical_service_doctors)
			if (body.servicePrices) {
				const [existingServicePrices]: any = await connection.execute(
					'SELECT clinic_id, medical_service_id, price, price_max FROM clinic_medical_service_doctors WHERE doctor_id = ?',
					[body.id],
				);

				const existingKeys = existingServicePrices.map(
					(row: any) => `${row.clinic_id}_${row.medical_service_id}`,
				);
				const newServicePrices: DoctorServicePrice[] = body.servicePrices || [];
				const newKeys = newServicePrices.map(
					(sp) => `${sp.clinicId}_${sp.serviceId}`,
				);

				// Удаляем записи, которых больше нет
				const keysToRemove = existingKeys.filter(
					(key: string) => !newKeys.includes(key),
				);
				for (const key of keysToRemove) {
					const [clinicId, serviceId] = key.split('_').map(Number);
					await connection.execute(
						'DELETE FROM clinic_medical_service_doctors WHERE doctor_id = ? AND clinic_id = ? AND medical_service_id = ?',
						[body.id, clinicId, serviceId],
					);
				}

				// Обновляем или добавляем записи
				for (const sp of newServicePrices) {
					const existing = existingServicePrices.find(
						(e: any) =>
							e.clinic_id === sp.clinicId &&
							e.medical_service_id === sp.serviceId,
					);
					if (existing) {
						// Обновляем только если изменилось
						if (
							existing.price !== sp.price ||
							existing.price_max !== sp.priceMax
						) {
							await connection.execute(
								`UPDATE clinic_medical_service_doctors 
								 SET price = ?, price_max = ? 
								 WHERE doctor_id = ? AND clinic_id = ? AND medical_service_id = ?`,
								[
									sp.price || null,
									sp.priceMax || null,
									body.id,
									sp.clinicId,
									sp.serviceId,
								],
							);
						}
					} else {
						// Добавляем новую
						await connection.execute(
							`INSERT INTO clinic_medical_service_doctors 
							 (doctor_id, clinic_id, medical_service_id, price, price_max, created_at) 
							 VALUES (?, ?, ?, ?, ?, NOW())`,
							[
								body.id,
								sp.clinicId,
								sp.serviceId,
								sp.price || null,
								sp.priceMax || null,
							],
						);
					}
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
		console.error('API Error - doctor update:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to update doctor',
		});
	}
});
