import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';

export interface ClinicServiceItem {
	id: number;
	name: string;
	localName: string;
	price: number | null;
	priceMin: number | null;
	priceMax: number | null;
}

export interface ClinicServicesMap {
	[clinicId: number]: ClinicServiceItem[];
}

interface DoctorPriceInfo {
	price: number | null;
	priceMin: number | null;
	priceMax: number | null;
}

/**
 * Загружает индивидуальные цены врачей из clinic_medical_service_doctors
 * @param doctorIds - массив ID врачей
 * @param clinicIds - массив ID клиник
 * @returns Map<"doctorId_clinicId_serviceId", {price, priceMin, priceMax}>
 */
async function getDoctorServicePrices(
	connection: any,
	doctorIds: number[],
	clinicIds: number[],
): Promise<Map<string, DoctorPriceInfo>> {
	const result = new Map<string, DoctorPriceInfo>();

	if (doctorIds.length === 0 || clinicIds.length === 0) {
		return result;
	}

	const doctorIdsStr = doctorIds.join(',');
	const clinicIdsStr = clinicIds.join(',');
	const query = `
		SELECT doctor_id, clinic_id, medical_service_id, price, price_max
		FROM clinic_medical_service_doctors
		WHERE doctor_id IN (${doctorIdsStr}) AND clinic_id IN (${clinicIdsStr})
	`;

	const [rows] = await connection.execute(query);

	for (const row of rows as any[]) {
		const key = `${row.doctor_id}_${row.clinic_id}_${row.medical_service_id}`;
		result.set(key, {
			price: row.price ? Number(row.price) : null,
			priceMin: null, // В таблице clinic_medical_service_doctors нет поля price_min
			priceMax: row.price_max ? Number(row.price_max) : null,
		});
	}

	return result;
}

/**
 * Загружает услуги клиник по специальностям
 * @param connection - соединение с БД
 * @param clinicIds - массив ID клиник
 * @param specialtyIds - массив ID специальностей
 * @param locale - локаль для названий
 * @param doctorId - опциональный ID врача для получения индивидуальных цен
 * @returns Карта услуг по clinicId
 */
export async function getServicesByClinicAndSpecialty(
	connection: any,
	clinicIds: number[],
	specialtyIds: number[],
	locale: string,
	doctorId?: number,
): Promise<ClinicServicesMap> {
	if (clinicIds.length === 0 || specialtyIds.length === 0) {
		return {};
	}

	// Загружаем индивидуальные цены врача, если передан doctorId
	const doctorPrices = doctorId
		? await getDoctorServicePrices(connection, [doctorId], clinicIds)
		: new Map<string, DoctorPriceInfo>();

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
			cms.price_min,
			cms.price_max,
			GROUP_CONCAT(DISTINCT mss.specialty_id ORDER BY mss.specialty_id) as specialtyIds
		FROM clinic_medical_services cms
		INNER JOIN medical_services ms ON cms.medical_service_id = ms.id
		INNER JOIN medical_services_specialties mss ON ms.id = mss.medical_service_id
		WHERE cms.clinic_id IN (${clinicIdsStr})
			AND mss.specialty_id IN (${specialtyIdsStr})
		GROUP BY cms.clinic_id, ms.id, ms.name_en, ms.name_sr, ms.name_sr_cyrl, 
			ms.name_ru, ms.name_de, ms.name_tr, ms.sort_order, cms.price, cms.price_min, cms.price_max
		ORDER BY cms.clinic_id, ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC;
	`;

	const [serviceRows] = await connection.execute(servicesQuery);

	const result: ClinicServicesMap = {};

	for (const row of serviceRows as any[]) {
		const clinicId = row.clinicId;
		const serviceId = row.id;
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

		// Проверяем, есть ли индивидуальная цена врача
		const doctorPriceKey = `${doctorId}_${clinicId}_${serviceId}`;
		const doctorPrice = doctorPrices.get(doctorPriceKey);

		// Если есть запись для врача - используем только её значения (без fallback на цены клиники)
		const price =
			doctorPrice !== undefined
				? doctorPrice.price
				: row.price
				? Number(row.price)
				: null;
		const priceMin =
			doctorPrice !== undefined
				? doctorPrice.priceMin
				: row.price_min
				? Number(row.price_min)
				: null;
		const priceMax =
			doctorPrice !== undefined
				? doctorPrice.priceMax
				: row.price_max
				? Number(row.price_max)
				: null;

		result[clinicId].push({
			id: serviceId,
			name: name || '',
			localName: localName || '',
			price,
			priceMin,
			priceMax,
		});
	}

	return result;
}

/**
 * Загружает услуги для списка врачей (оптимизированно, одним запросом)
 * @param connection - соединение с БД
 * @param doctors - массив врачей с id, clinicIds и specialtyIds
 * @param locale - локаль для названий
 * @returns Map<doctorKey, ClinicServicesMap>
 */
export async function getServicesForDoctors(
	connection: any,
	doctors: Array<{ id: number; clinicIds: string; specialtyIds: string }>,
	locale: string,
): Promise<Map<string, ClinicServicesMap>> {
	// Собираем уникальные ID
	const allDoctorIds = new Set<number>();
	const allClinicIds = new Set<number>();
	const allSpecialtyIds = new Set<number>();

	doctors.forEach((doctor) => {
		allDoctorIds.add(doctor.id);
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

	// Загружаем индивидуальные цены для всех врачей
	const doctorPrices = await getDoctorServicePrices(
		connection,
		Array.from(allDoctorIds),
		Array.from(allClinicIds),
	);

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
			cms.price_min,
			cms.price_max,
			GROUP_CONCAT(DISTINCT mss.specialty_id ORDER BY mss.specialty_id) as specialtyIds
		FROM clinic_medical_services cms
		INNER JOIN medical_services ms ON cms.medical_service_id = ms.id
		INNER JOIN medical_services_specialties mss ON ms.id = mss.medical_service_id
		WHERE cms.clinic_id IN (${clinicIdsStr})
			AND mss.specialty_id IN (${specialtyIdsStr})
		GROUP BY cms.clinic_id, ms.id, ms.name_en, ms.name_sr, ms.name_sr_cyrl, 
			ms.name_ru, ms.name_de, ms.name_tr, ms.sort_order, cms.price, cms.price_min, cms.price_max
		ORDER BY cms.clinic_id, ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC;
	`;

	const [serviceRows] = await connection.execute(servicesQuery);

	// Группируем услуги по clinicId с сохранением specialtyIds и базовых цен
	const servicesByClinic: Map<
		number,
		Array<{
			id: number;
			name: string;
			localName: string;
			price: number | null;
			priceMin: number | null;
			priceMax: number | null;
			specialtyIds: number[];
		}>
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
			priceMin: row.price_min ? Number(row.price_min) : null,
			priceMax: row.price_max ? Number(row.price_max) : null,
			specialtyIds,
		});
	}

	// Создаём карту услуг для каждого врача
	const result = new Map<string, ClinicServicesMap>();

	for (const doctor of doctors) {
		const doctorKey = String(doctor.id);
		const doctorSpecialtyIds = doctor.specialtyIds
			? doctor.specialtyIds.split(',').map(Number)
			: [];
		const doctorClinicIds = doctor.clinicIds
			? doctor.clinicIds.split(',').map(Number)
			: [];

		const clinicServices: ClinicServicesMap = {};

		for (const clinicId of doctorClinicIds) {
			const allServices = servicesByClinic.get(clinicId) || [];
			// Фильтруем услуги по специальностям врача и применяем индивидуальные цены
			const filteredServices = allServices
				.filter((service) =>
					service.specialtyIds.some((id) => doctorSpecialtyIds.includes(id)),
				)
				.map(({ specialtyIds, ...rest }) => {
					// Проверяем, есть ли индивидуальная цена врача
					const doctorPriceKey = `${doctor.id}_${clinicId}_${rest.id}`;
					const doctorPrice = doctorPrices.get(doctorPriceKey);

					// Если есть запись для врача - используем её значения
					if (doctorPrice !== undefined) {
						return {
							...rest,
							price: doctorPrice.price,
							priceMin: doctorPrice.priceMin,
							priceMax: doctorPrice.priceMax,
						};
					}

					return rest;
				});

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
