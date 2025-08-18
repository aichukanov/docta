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
		const query = getQuery(event);

		// Извлекаем фильтры из query параметров
		const filters: DoctorFilters = {
			specialtyIds: query.specialtyIds
				? Array.isArray(query.specialtyIds)
					? query.specialtyIds.map((id) => parseInt(id as string))
					: [parseInt(query.specialtyIds as string)]
				: undefined,
			languages: query.languages
				? Array.isArray(query.languages)
					? (query.languages as string[])
					: [query.languages as string]
				: undefined,
			cityIds: query.cityIds
				? Array.isArray(query.cityIds)
					? query.cityIds.map((id) => parseInt(id as string) as CityId)
					: [parseInt(query.cityIds as string) as CityId]
				: undefined,
		};

		return await filterDoctorsWithClinics(filters);
	} catch (error) {
		console.error('API Error - doctors:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch doctors',
		});
	}
});

// Функция фильтрации врачей с полными данными клиник (для карты)
async function filterDoctorsWithClinics(
	filters: DoctorFilters,
): Promise<DoctorsResponse> {
	const connection = await getConnection();

	try {
		let whereConditions: string[] = [];
		const params: any[] = [];

		// Базовый запрос для врачей с клиниками (всегда нужны данные клиник)
		let query = `
			SELECT DISTINCT
				d.*,
				GROUP_CONCAT(DISTINCT s.id ORDER BY s.id) as specialty_ids,
				GROUP_CONCAT(DISTINCT l.code ORDER BY l.code) as language_codes
			FROM doctors d
			LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
			LEFT JOIN specialties s ON ds.specialty_id = s.id
			LEFT JOIN doctor_languages dl ON d.id = dl.doctor_id
			LEFT JOIN languages l ON dl.language_id = l.id
		`;

		// Фильтр по ID специализаций
		if (filters.specialtyIds && filters.specialtyIds.length > 0) {
			const placeholders = filters.specialtyIds.map(() => '?').join(',');
			whereConditions.push(`ds.specialty_id IN (${placeholders})`);
			params.push(...filters.specialtyIds);
		}

		// Фильтр по языкам
		if (filters.languages && filters.languages.length > 0) {
			const placeholders = filters.languages.map(() => '?').join(',');
			whereConditions.push(`l.code IN (${placeholders})`);
			params.push(...filters.languages);
		}

		// Фильтр по городам (через клиники)
		if (filters.cityIds && filters.cityIds.length > 0) {
			const placeholders = filters.cityIds.map(() => '?').join(',');
			whereConditions.push(`d.id IN (
				SELECT DISTINCT doctor_id 
				FROM doctor_clinics dc2 
				JOIN clinics cl2 ON dc2.clinic_id = cl2.id 
				WHERE cl2.city_id IN (${placeholders})
			)`);
			params.push(...filters.cityIds);
		}

		// Добавляем WHERE условия
		if (whereConditions.length > 0) {
			query += ` WHERE ${whereConditions.join(' AND ')}`;
		}

		// Группировка и сортировка
		query += ` GROUP BY d.id, d.name ORDER BY d.name ASC`;

		const [doctorRows] = await connection.execute(query, params);

		// Получаем общее количество записей
		const totalCount = (doctorRows as any[]).length;

		// Запрос для получения клиник с полными данными для отфильтрованных врачей
		let clinicQuery = `
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
		`;

		// Если есть отфильтрованные врачи, получаем только их клиники
		const doctorIds = (doctorRows as any[]).map((row) => row.id);
		if (doctorIds.length > 0) {
			const placeholders = doctorIds.map(() => '?').join(',');
			clinicQuery += ` WHERE dc.doctor_id IN (${placeholders})`;
			clinicQuery += ` ORDER BY dc.doctor_id, cl.name ASC`;

			const [clinicRows] = await connection.execute(clinicQuery, doctorIds);

			// Группируем клиники по врачам
			const clinicsByDoctor = new Map<number, DoctorClinicFull[]>();
			(clinicRows as any[]).forEach((clinic) => {
				if (!clinicsByDoctor.has(clinic.doctor_id)) {
					clinicsByDoctor.set(clinic.doctor_id, []);
				}
				clinicsByDoctor.get(clinic.doctor_id)!.push({
					clinicId: clinic.clinic_id,
					clinicName: clinic.clinic_name,
					cityId: clinic.city_id,
					cityName: clinic.city_name,
					address: clinic.address,
					latitude: clinic.latitude ? parseFloat(clinic.latitude) : undefined,
					longitude: clinic.longitude
						? parseFloat(clinic.longitude)
						: undefined,
					phone: clinic.phone,
					email: clinic.email,
					website: clinic.website,
					facebook: clinic.facebook,
					instagram: clinic.instagram,
					telegram: clinic.telegram,
					whatsapp: clinic.whatsapp,
					viber: clinic.viber,
				});
			});

			// Преобразуем результат
			const doctors: DoctorWithClinics[] = (doctorRows as any[]).map((row) => ({
				id: row.id,
				name: row.name,
				photoUrl: row.photo_url,
				phone: row.phone,
				email: row.email,
				facebook: row.facebook,
				instagram: row.instagram,
				telegram: row.telegram,
				whatsapp: row.whatsapp,
				viber: row.viber,
				description: row.description,
				specialtyIds: row.specialty_ids
					? row.specialty_ids.split(',').map(Number)
					: [],
				languages: row.language_codes ? row.language_codes.split(',') : [],
				clinics: clinicsByDoctor.get(row.id) || [],
				created_at: row.created_at,
			}));

			await connection.end();
			return { doctors, totalCount };
		} else {
			await connection.end();
			return { doctors: [], totalCount: 0 };
		}
	} catch (error) {
		console.error('Filter doctors with clinics error:', error);
		await connection.end();
		throw error;
	}
}
