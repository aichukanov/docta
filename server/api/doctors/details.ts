import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedDescription,
} from '~/server/common/utils';
import {
	getServicesByClinicAndSpecialty,
	type ClinicServicesMap,
} from '~/server/common/services';
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
		const includeServices = body.includeServices || false;

		const doctorsQuery = `
			SELECT DISTINCT
				d.id,
				d.name_sr,
				d.name_sr_cyrl,
				d.name_ru,
				d.name_en,
				d.description_sr,
				d.description_sr_cyrl,
				d.description_ru,
				d.description_en,
				d.description_de,
				d.description_tr,
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

		const doctor = (doctorRows as any[])[0];
		if (!doctor) {
			await connection.end();
			return null;
		}

		// Загружаем услуги, если требуется
		let clinicServices: ClinicServicesMap | undefined;
		if (includeServices && doctor.clinicIds && doctor.specialtyIds) {
			const clinicIds = doctor.clinicIds.split(',').map(Number);
			const specialtyIds = doctor.specialtyIds.split(',').map(Number);
			clinicServices = await getServicesByClinicAndSpecialty(
				connection,
				clinicIds,
				specialtyIds,
				locale,
				doctor.id, // Передаём ID врача для получения индивидуальных цен
			);
		}

		await connection.end();

		// Обрабатываем локализованные имена
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			doctor,
			locale,
		);

		// Обрабатываем локализованное описание
		const description = processLocalizedDescription(doctor, locale);

		// Сортируем clinicIds по количеству услуг (больше услуг — выше)
		let sortedClinicIds = doctor.clinicIds;
		if (clinicServices && doctor.clinicIds) {
			const clinicIdsList = doctor.clinicIds.split(',').map(Number);
			clinicIdsList.sort((a: number, b: number) => {
				const aCount = clinicServices[a]?.length || 0;
				const bCount = clinicServices[b]?.length || 0;
				return bCount - aCount;
			});
			sortedClinicIds = clinicIdsList.join(',');
		}

		// Удаляем избыточные поля локализации
		const {
			name_sr,
			name_sr_cyrl,
			name_ru,
			name_en,
			description_sr,
			description_sr_cyrl,
			description_ru,
			description_en,
			description_de,
			description_tr,
			...rest
		} = doctor;

		return {
			...rest,
			name,
			localName,
			description,
			clinicIds: sortedClinicIds,
			clinicServices,
		};
	} catch (error) {
		console.error('API Error - doctor data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch doctor data',
		});
	}
});
