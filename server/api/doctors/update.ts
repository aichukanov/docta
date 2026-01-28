import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
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
		requireAdmin(event);

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
				    professional_title = ?, email = ?, phone = ?, website = ?, 
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

			const [existingSpecialties]: any = await connection.execute(
				'SELECT specialty_id FROM doctor_specialties WHERE doctor_id = ?',
				[body.id],
			);
			const existingSpecialtyIds = existingSpecialties.map(
				(row: any) => row.specialty_id,
			);
			const newSpecialtyIds = body.specialtyIds;

			const specialtiesToRemove = existingSpecialtyIds.filter(
				(id: number) => !newSpecialtyIds.includes(id),
			);
			const specialtiesToAdd = newSpecialtyIds.filter(
				(id: number) => !existingSpecialtyIds.includes(id),
			);

			if (specialtiesToRemove.length > 0) {
				const placeholders = specialtiesToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM doctor_specialties WHERE doctor_id = ? AND specialty_id IN (${placeholders})`,
					[body.id, ...specialtiesToRemove],
				);
			}

			for (const specialtyId of specialtiesToAdd) {
				await connection.execute(
					'INSERT INTO doctor_specialties (doctor_id, specialty_id) VALUES (?, ?)',
					[body.id, specialtyId],
				);
			}

			// Handle languages
			const [existingLanguages]: any = await connection.execute(
				'SELECT language_id FROM doctor_languages WHERE doctor_id = ?',
				[body.id],
			);
			const existingLanguageIds = existingLanguages.map(
				(row: any) => row.language_id,
			);
			const newLanguageIds = body.languageIds;

			const languagesToRemove = existingLanguageIds.filter(
				(id: number) => !newLanguageIds.includes(id),
			);
			const languagesToAdd = newLanguageIds.filter(
				(id: number) => !existingLanguageIds.includes(id),
			);

			if (languagesToRemove.length > 0) {
				const placeholders = languagesToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM doctor_languages WHERE doctor_id = ? AND language_id IN (${placeholders})`,
					[body.id, ...languagesToRemove],
				);
			}

			for (const languageId of languagesToAdd) {
				await connection.execute(
					'INSERT INTO doctor_languages (doctor_id, language_id) VALUES (?, ?)',
					[body.id, languageId],
				);
			}

			// Handle clinics
			const [existingClinics]: any = await connection.execute(
				'SELECT clinic_id FROM doctor_clinics WHERE doctor_id = ?',
				[body.id],
			);
			const existingClinicIds = existingClinics.map(
				(row: any) => row.clinic_id,
			);
			const newClinicIds = body.clinicIds;

			const clinicsToRemove = existingClinicIds.filter(
				(id: number) => !newClinicIds.includes(id),
			);
			const clinicsToAdd = newClinicIds.filter(
				(id: number) => !existingClinicIds.includes(id),
			);

			if (clinicsToRemove.length > 0) {
				const placeholders = clinicsToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM doctor_clinics WHERE doctor_id = ? AND clinic_id IN (${placeholders})`,
					[body.id, ...clinicsToRemove],
				);
			}

			for (const clinicId of clinicsToAdd) {
				await connection.execute(
					'INSERT INTO doctor_clinics (doctor_id, clinic_id) VALUES (?, ?)',
					[body.id, clinicId],
				);
			}

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
