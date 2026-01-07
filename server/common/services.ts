import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';

export interface ClinicServiceItem {
	id: number;
	name: string;
	localName: string;
	price: number | null;
}

export interface ClinicServicesMap {
	[clinicId: number]: ClinicServiceItem[];
}

/**
 * Загружает услуги клиник по специальностям
 * @param connection - соединение с БД
 * @param clinicIds - массив ID клиник
 * @param specialtyIds - массив ID специальностей
 * @param locale - локаль для названий
 * @returns Карта услуг по clinicId
 */
export async function getServicesByClinicAndSpecialty(
	connection: any,
	clinicIds: number[],
	specialtyIds: number[],
	locale: string,
): Promise<ClinicServicesMap> {
	if (clinicIds.length === 0 || specialtyIds.length === 0) {
		return {};
	}

	const clinicIdsStr = clinicIds.join(',');
	const specialtyIdsStr = specialtyIds.join(',');

	const servicesQuery = `
		SELECT
			cms.clinic_id as clinicId,
			ms.id,
			ms.name_en,
			ms.name_sr,
			ms.name_sr_cyrl,
			ms.name_ru,
			ms.name_de,
			ms.name_tr,
			ms.sort_order,
			cms.price,
			GROUP_CONCAT(DISTINCT mss.specialty_id ORDER BY mss.specialty_id) as specialtyIds
		FROM clinic_medical_services cms
		INNER JOIN medical_services ms ON cms.medical_service_id = ms.id
		INNER JOIN medical_services_specialties mss ON ms.id = mss.medical_service_id
		WHERE cms.clinic_id IN (${clinicIdsStr})
			AND mss.specialty_id IN (${specialtyIdsStr})
		GROUP BY cms.clinic_id, ms.id, ms.name_en, ms.name_sr, ms.name_sr_cyrl, 
			ms.name_ru, ms.name_de, ms.name_tr, ms.sort_order, cms.price
		ORDER BY cms.clinic_id, ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC;
	`;

	const [serviceRows] = await connection.execute(servicesQuery);

	const result: ClinicServicesMap = {};

	for (const row of serviceRows as any[]) {
		const clinicId = row.clinicId;
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			row,
			locale,
		);
		const serviceSpecialtyIds = row.specialtyIds
			? row.specialtyIds.split(',').map(Number)
			: [];

		// Фильтруем по специальностям
		if (!serviceSpecialtyIds.some((id: number) => specialtyIds.includes(id))) {
			continue;
		}

		if (!result[clinicId]) {
			result[clinicId] = [];
		}

		result[clinicId].push({
			id: row.id,
			name: name || '',
			localName: localName || '',
			price: row.price ? Number(row.price) : null,
		});
	}

	return result;
}

/**
 * Загружает услуги для списка врачей (оптимизированно, одним запросом)
 * @param connection - соединение с БД
 * @param doctors - массив врачей с clinicIds и specialtyIds
 * @param locale - локаль для названий
 * @returns Map<doctorKey, ClinicServicesMap>
 */
export async function getServicesForDoctors(
	connection: any,
	doctors: Array<{ clinicIds: string; specialtyIds: string }>,
	locale: string,
): Promise<Map<string, ClinicServicesMap>> {
	// Собираем уникальные ID
	const allClinicIds = new Set<number>();
	const allSpecialtyIds = new Set<number>();

	doctors.forEach((doctor) => {
		doctor.clinicIds?.split(',').forEach((id) => allClinicIds.add(Number(id)));
		doctor.specialtyIds
			?.split(',')
			.forEach((id) => allSpecialtyIds.add(Number(id)));
	});

	if (allClinicIds.size === 0 || allSpecialtyIds.size === 0) {
		return new Map();
	}

	const clinicIdsStr = Array.from(allClinicIds).join(',');
	const specialtyIdsStr = Array.from(allSpecialtyIds).join(',');

	const servicesQuery = `
		SELECT
			cms.clinic_id as clinicId,
			ms.id,
			ms.name_en,
			ms.name_sr,
			ms.name_sr_cyrl,
			ms.name_ru,
			ms.name_de,
			ms.name_tr,
			ms.sort_order,
			cms.price,
			GROUP_CONCAT(DISTINCT mss.specialty_id ORDER BY mss.specialty_id) as specialtyIds
		FROM clinic_medical_services cms
		INNER JOIN medical_services ms ON cms.medical_service_id = ms.id
		INNER JOIN medical_services_specialties mss ON ms.id = mss.medical_service_id
		WHERE cms.clinic_id IN (${clinicIdsStr})
			AND mss.specialty_id IN (${specialtyIdsStr})
		GROUP BY cms.clinic_id, ms.id, ms.name_en, ms.name_sr, ms.name_sr_cyrl, 
			ms.name_ru, ms.name_de, ms.name_tr, ms.sort_order, cms.price
		ORDER BY cms.clinic_id, ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC;
	`;

	const [serviceRows] = await connection.execute(servicesQuery);

	// Группируем услуги по clinicId с сохранением specialtyIds
	const servicesByClinic: Map<
		number,
		Array<ClinicServiceItem & { specialtyIds: number[] }>
	> = new Map();

	for (const row of serviceRows as any[]) {
		const clinicId = row.clinicId;
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			row,
			locale,
		);
		const specialtyIds = row.specialtyIds
			? row.specialtyIds.split(',').map(Number)
			: [];

		if (!servicesByClinic.has(clinicId)) {
			servicesByClinic.set(clinicId, []);
		}

		servicesByClinic.get(clinicId)!.push({
			id: row.id,
			name: name || '',
			localName: localName || '',
			price: row.price ? Number(row.price) : null,
			specialtyIds,
		});
	}

	// Создаём карту услуг для каждого врача
	const result = new Map<string, ClinicServicesMap>();

	for (const doctor of doctors) {
		const doctorKey = `${doctor.clinicIds}|${doctor.specialtyIds}`;
		const doctorSpecialtyIds = doctor.specialtyIds
			? doctor.specialtyIds.split(',').map(Number)
			: [];
		const doctorClinicIds = doctor.clinicIds
			? doctor.clinicIds.split(',').map(Number)
			: [];

		const clinicServices: ClinicServicesMap = {};

		for (const clinicId of doctorClinicIds) {
			const allServices = servicesByClinic.get(clinicId) || [];
			// Фильтруем услуги по специальностям врача
			const filteredServices = allServices
				.filter((service) =>
					service.specialtyIds.some((id) => doctorSpecialtyIds.includes(id)),
				)
				.map(({ specialtyIds, ...rest }) => rest);

			if (filteredServices.length > 0) {
				clinicServices[clinicId] = filteredServices;
			}
		}

		if (Object.keys(clinicServices).length > 0) {
			result.set(doctorKey, clinicServices);
		}
	}

	return result;
}
