import { getConnection } from '~/server/common/db-mysql';
import type {
	DoctorWithClinics,
	DoctorFilters,
	DoctorsResponse,
	DoctorClinicFull,
} from '~/interfaces/doctor';
import type { CityId } from '~/common/constants';

export default defineEventHandler(async (event): Promise<DoctorsResponse> => {
	try {
		// const query = getQuery(event);

		const doctorsQuery = `
			SELECT DISTINCT
				d.id,
				d.name,
				d.photo_url as photoUrl,
				d.phone,
				d.email,
				d.facebook,
				d.instagram,
				d.telegram,
				d.whatsapp,
				d.viber,
				d.description,
				d.website,
				GROUP_CONCAT(DISTINCT s.id ORDER BY s.id) as specialtyIds,
				GROUP_CONCAT(DISTINCT l.code ORDER BY l.code) as languageCodes,   
				GROUP_CONCAT(DISTINCT dc.clinic_id ORDER BY dc.clinic_id) as clinicIds
			FROM doctors d
			LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
			LEFT JOIN specialties s ON ds.specialty_id = s.id
			LEFT JOIN doctor_languages dl ON d.id = dl.doctor_id
			LEFT JOIN languages l ON dl.language_id = l.id
			LEFT JOIN doctor_clinics dc ON d.id = dc.doctor_id
			GROUP BY d.id, d.name ORDER BY d.name ASC;
		`;

		const connection = await getConnection();
		const [doctorRows] = await connection.execute(doctorsQuery);
		await connection.end();

		return doctorRows;
	} catch (error) {
		console.error('API Error - doctors:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch doctors',
		});
	}
});
