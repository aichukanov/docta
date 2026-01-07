import { getConnection } from '~/server/common/db-mysql';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import {
	validateBody,
	validateClinicIds,
	validateSpecialtyIds,
} from '~/common/validation';

export interface ClinicServiceBySpecialty {
	id: number;
	name: string;
	localName: string;
	price: number | null;
	code: string | null;
}

export interface ClinicServicesMap {
	[clinicId: number]: ClinicServiceBySpecialty[];
}

export default defineEventHandler(async (event): Promise<ClinicServicesMap> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/services-by-specialties')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return {};
		}

		if (
			!body.clinicIds ||
			!validateClinicIds(body, 'api/clinics/services-by-specialties', true)
		) {
			setResponseStatus(event, 400, 'Invalid clinic ids');
			return {};
		}

		if (
			!body.specialtyIds ||
			!validateSpecialtyIds(body, 'api/clinics/services-by-specialties')
		) {
			setResponseStatus(event, 400, 'Invalid specialty ids');
			return {};
		}

		return getClinicServicesBySpecialties(body);
	} catch (error) {
		console.error('API Error - clinic services by specialties:', error);
		return {};
	}
});

export async function getClinicServicesBySpecialties(body: {
	clinicIds: number[];
	specialtyIds: number[];
	locale?: string;
}): Promise<ClinicServicesMap> {
	const locale = body.locale || 'en';
	const clinicIds = body.clinicIds.join(',');
	const specialtyIds = body.specialtyIds.join(',');

	const query = `
		SELECT DISTINCT
			cms.clinic_id as clinicId,
			ms.id,
			ms.name_en,
			ms.name_sr,
			ms.name_sr_cyrl,
			ms.name_ru,
			ms.name_de,
			ms.name_tr,
			cms.price,
			cms.code
		FROM clinic_medical_services cms
		INNER JOIN medical_services ms ON cms.medical_service_id = ms.id
		INNER JOIN medical_services_specialties mss ON ms.id = mss.medical_service_id
		WHERE cms.clinic_id IN (${clinicIds})
			AND mss.specialty_id IN (${specialtyIds})
		ORDER BY cms.clinic_id, ms.name_en ASC;
	`;

	const connection = await getConnection();
	const [rows] = await connection.execute(query);
	await connection.end();

	const result: ClinicServicesMap = {};

	for (const row of rows as any[]) {
		const clinicId = row.clinicId;

		if (!result[clinicId]) {
			result[clinicId] = [];
		}

		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			row,
			locale,
		);

		result[clinicId].push({
			id: row.id,
			name: name || '',
			localName: localName || '',
			price: row.price ? Number(row.price) : null,
			code: row.code || null,
		});
	}

	return result;
}
