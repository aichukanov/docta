import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import type { DoctorData } from '~/interfaces/doctor';
import {
	validateBody,
	validateSpecialtyIds,
	validateDoctorLanguageIds,
	validateClinicIds,
} from '~/common/validation';

interface DoctorServicePrice {
	clinicId: number;
	serviceId: number;
	price: number | null;
	priceMax: number | null;
}

export default defineEventHandler(async (event): Promise<DoctorData> => {
	try {
		requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/doctors/add')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}
		if (!validateSpecialtyIds(body, 'api/doctors/add')) {
			setResponseStatus(event, 400, 'Invalid specialty');
			return null;
		}
		if (!validateDoctorLanguageIds(body, 'api/doctors/add')) {
			setResponseStatus(event, 400, 'Invalid doctor language');
			return null;
		}
		if (!validateClinicIds(body, 'api/doctors/add', true)) {
			setResponseStatus(event, 400, 'Invalid clinic');
			return null;
		}

		const addDoctorQuery = `
			INSERT INTO doctors (name_sr, name_sr_cyrl, name_ru, name_en, professional_title, email, phone, website, photo_url, facebook, instagram, telegram, whatsapp, viber)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
		`;

		const addDoctorQueryParams = [
			body.name,
			body.name_sr_cyrl || '',
			body.name_ru || '',
			body.name_en || '',
			body.professionalTitle,
			body.email,
			body.phone,
			body.website,
			body.photoUrl,
			body.facebook,
			body.instagram,
			body.telegram,
			body.whatsapp,
			body.viber,
		];

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			const [insertResult]: any = await connection.execute(
				addDoctorQuery,
				addDoctorQueryParams,
			);

			const doctorId: number = insertResult.insertId;

			for (let i = 0; i < body.specialtyIds.length; i++) {
				const specialtyId = body.specialtyIds[i];
				const specialtyQuery = `
					INSERT INTO doctor_specialties (doctor_id, specialty_id) VALUES (?, ?);
				`;
				const specialtyQueryParams = [doctorId, specialtyId];
				await connection.execute(specialtyQuery, specialtyQueryParams);
			}

			for (let i = 0; i < body.languageIds.length; i++) {
				const languageId = body.languageIds[i];
				const languageQuery = `
					INSERT INTO doctor_languages (doctor_id, language_id) VALUES (?, ?);
				`;
				const languageQueryParams = [doctorId, languageId];
				await connection.execute(languageQuery, languageQueryParams);
			}

			for (let i = 0; i < body.clinicIds.length; i++) {
				const clinicId = body.clinicIds[i];
				const clinicQuery = `
					INSERT INTO doctor_clinics (doctor_id, clinic_id) VALUES (?, ?);
				`;
				const clinicQueryParams = [doctorId, clinicId];
				await connection.execute(clinicQuery, clinicQueryParams);
			}

			// Handle service prices (clinic_medical_service_doctors)
			if (body.servicePrices && body.servicePrices.length > 0) {
				for (const sp of body.servicePrices as DoctorServicePrice[]) {
					await connection.execute(
						`INSERT INTO clinic_medical_service_doctors 
						 (doctor_id, clinic_id, medical_service_id, price, price_max, created_at) 
						 VALUES (?, ?, ?, ?, ?, NOW())`,
						[
							doctorId,
							sp.clinicId,
							sp.serviceId,
							sp.price || null,
							sp.priceMax || null,
						],
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
		console.error('API Error - doctor add:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to add doctor',
		});
	}
});
