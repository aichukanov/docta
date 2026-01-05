import { getConnection } from '~/server/common/db-mysql';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import type { DoctorData } from '~/interfaces/doctor';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<DoctorData> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/doctors/details')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.doctorId)) {
			setResponseStatus(event, 400, 'Invalid doctor id');
			return null;
		}

		const locale = body.locale || 'en';

		const doctorsQuery = `
			SELECT DISTINCT
				d.id,
				d.name_sr,
				d.name_sr_cyrl,
				d.name_ru,
				d.name_en,
				d.professional_title as professionalTitle,
				d.photo_url as photoUrl,
				d.phone,
				d.email,
				d.facebook,
				d.instagram,
				d.telegram,
				d.whatsapp,
				d.viber,
				d.website,
				GROUP_CONCAT(DISTINCT s.id ORDER BY s.id) as specialtyIds,
				GROUP_CONCAT(DISTINCT languages.id ORDER BY languages.id) as languageIds,
				GROUP_CONCAT(DISTINCT dc.clinic_id ORDER BY dc.clinic_id) as clinicIds
			FROM doctors d
			LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
			LEFT JOIN specialties s ON ds.specialty_id = s.id
			LEFT JOIN doctor_languages dl ON d.id = dl.doctor_id
			LEFT JOIN languages ON dl.language_id = languages.id
			LEFT JOIN doctor_clinics dc ON d.id = dc.doctor_id
			WHERE d.id = "${body.doctorId}";
		`;

		const connection = await getConnection();
		const [doctorRows] = await connection.execute(doctorsQuery);
		await connection.end();

		const doctor = doctorRows[0];
		if (!doctor) {
			return null;
		}

		// Обрабатываем локализованные имена
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			doctor,
			locale,
		);
		// Удаляем избыточные поля локализации
		const { name_sr, name_sr_cyrl, name_ru, name_en, ...rest } = doctor;

		return {
			...rest,
			name,
			localName,
		};
	} catch (error) {
		console.error('API Error - doctor data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch doctor data',
		});
	}
});
