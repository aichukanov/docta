import { getConnection } from '~/server/common/db-mysql';
import type { DoctorList } from '~/interfaces/doctor';
import {
	validateBody,
	validateSpecialtyIds,
	validateCityIds,
	validateDoctorLanguageIds,
	validateName,
} from '~/common/validation';

export default defineEventHandler(async (event): Promise<DoctorList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/doctors/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}
		if (body.specialtyIds && !validateSpecialtyIds(body, 'api/doctors/list')) {
			setResponseStatus(event, 400, 'Invalid specialty');
			return null;
		}
		if (body.cityIds && !validateCityIds(body, 'api/doctors/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return null;
		}
		if (
			body.languageIds &&
			!validateDoctorLanguageIds(body, 'api/doctors/list')
		) {
			setResponseStatus(event, 400, 'Invalid doctor language');
			return null;
		}

		return getDoctorList(body);
	} catch (error) {
		console.error('API Error - doctors:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch doctors',
		});
	}
});

export async function getDoctorList(
	body: {
		name?: string;
		specialtyIds?: number[];
		cityIds?: number[];
		languageIds?: string[];
		clinicIds?: number[];
		onlyDoctorLanguages?: boolean;
	} = {},
) {
	const whereFilters = [];

	if (body.specialtyIds?.length > 0) {
		whereFilters.push(`s.id IN (${body.specialtyIds.join(',')})`);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(`cities.id IN (${body.cityIds.join(',')})`);
	}
	if (body.languageIds?.length > 0) {
		const languageList = body.languageIds.join(',');
		if (body.onlyDoctorLanguages) {
			whereFilters.push(`languages.id IN (${languageList})`);
		} else {
			whereFilters.push(
				`(languages.id IN (${languageList}) OR clinic_languages.language_id IN (${languageList}))`,
			);
		}
	}
	if (body.clinicIds?.length > 0) {
		whereFilters.push(`clinics.id IN (${body.clinicIds.join(',')})`);
	}
	if (body.name && validateName(body, 'api/doctors/list')) {
		whereFilters.push(
			`(d.name LIKE '%${body.name}%' OR d.name_ru LIKE '%${body.name}%')`,
		);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const doctorsQuery = `
			SELECT DISTINCT
				d.id,
				d.name,
				d.name_ru,
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
			LEFT JOIN clinics ON dc.clinic_id = clinics.id
			LEFT JOIN cities ON clinics.city_id = cities.id
			LEFT JOIN clinic_languages ON dc.clinic_id = clinic_languages.clinic_id
			${whereFiltersString}
			GROUP BY d.id, d.name ORDER BY d.name ASC;
		`;

	const connection = await getConnection();
	const [doctorRows] = await connection.execute(doctorsQuery);
	await connection.end();

	return {
		doctors: doctorRows,
		totalCount: doctorRows.length,
	};
}
