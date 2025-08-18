import { getConnection } from '~/server/common/db-mysql';
import type { DoctorWithClinics, DoctorClinicFull } from '~/interfaces/doctor';

export default defineEventHandler(
	async (event): Promise<DoctorWithClinics | null> => {
		try {
			const doctorId = parseInt(getRouterParam(event, 'id') as string);

			if (!doctorId || isNaN(doctorId)) {
				throw createError({
					statusCode: 400,
					statusMessage: 'Invalid doctor ID',
				});
			}

			const doctor = await getDoctorWithClinicsById(doctorId);

			if (!doctor) {
				throw createError({
					statusCode: 404,
					statusMessage: 'Doctor not found',
				});
			}

			return doctor;
		} catch (error) {
			console.error('API Error - doctor by ID:', error);
			if (error.statusCode) {
				throw error; // Re-throw HTTP errors
			}
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch doctor',
			});
		}
	},
);

// Получить врача по ID с полными данными клиник
async function getDoctorWithClinicsById(
	id: number,
): Promise<DoctorWithClinics | null> {
	const connection = await getConnection();

	try {
		// Запрос для получения врача с специализациями и языками
		const doctorQuery = `
			SELECT DISTINCT
				d.*,
				GROUP_CONCAT(DISTINCT s.id ORDER BY s.id) as specialty_ids,
				GROUP_CONCAT(DISTINCT l.code ORDER BY l.code) as language_codes
			FROM doctors d
			LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
			LEFT JOIN specialties s ON ds.specialty_id = s.id
			LEFT JOIN doctor_languages dl ON d.id = dl.doctor_id
			LEFT JOIN languages l ON dl.language_id = l.id
			WHERE d.id = ?
			GROUP BY d.id, d.name
		`;

		const [doctorRows] = await connection.execute(doctorQuery, [id]);
		const doctorRowsArray = doctorRows as any[];

		if (doctorRowsArray.length === 0) {
			await connection.end();
			return null;
		}

		const doctorRow = doctorRowsArray[0];

		// Запрос для получения клиник врача с полными данными
		const clinicQuery = `
			SELECT 
				dc.doctor_id,
				dc.clinic_id,
				cl.name as clinic_name,
				cl.city_id,
				c.name as city_name,
				cl.address,
				cl.latitude,
				cl.longitude,
				cl.phone,
				cl.email,
				cl.website,
				cl.facebook,
				cl.instagram,
				cl.telegram,
				cl.whatsapp,
				cl.viber
			FROM doctor_clinics dc
			JOIN clinics cl ON dc.clinic_id = cl.id
			JOIN cities c ON cl.city_id = c.id
			WHERE dc.doctor_id = ?
			ORDER BY cl.name ASC
		`;

		const [clinicRows] = await connection.execute(clinicQuery, [id]);

		// Преобразуем клиники
		const clinics: DoctorClinicFull[] = (clinicRows as any[]).map((clinic) => ({
			clinicId: clinic.clinic_id,
			clinicName: clinic.clinic_name,
			cityId: clinic.city_id,
			cityName: clinic.city_name,
			address: clinic.address,
			latitude: clinic.latitude ? parseFloat(clinic.latitude) : undefined,
			longitude: clinic.longitude ? parseFloat(clinic.longitude) : undefined,
			phone: clinic.phone,
			email: clinic.email,
			website: clinic.website,
			facebook: clinic.facebook,
			instagram: clinic.instagram,
			telegram: clinic.telegram,
			whatsapp: clinic.whatsapp,
			viber: clinic.viber,
		}));

		// Создаем объект врача
		const doctor: DoctorWithClinics = {
			id: doctorRow.id,
			name: doctorRow.name,
			photoUrl: doctorRow.photo_url,
			phone: doctorRow.phone,
			email: doctorRow.email,
			facebook: doctorRow.facebook,
			instagram: doctorRow.instagram,
			telegram: doctorRow.telegram,
			whatsapp: doctorRow.whatsapp,
			viber: doctorRow.viber,
			description: doctorRow.description,
			specialtyIds: doctorRow.specialty_ids
				? doctorRow.specialty_ids.split(',').map(Number)
				: [],
			languages: doctorRow.language_codes
				? doctorRow.language_codes.split(',')
				: [],
			clinics: clinics,
			created_at: doctorRow.created_at,
		};

		await connection.end();
		return doctor;
	} catch (error) {
		await connection.end();
		throw error;
	}
}
