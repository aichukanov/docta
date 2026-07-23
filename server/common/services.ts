import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import type {
	ClinicSummaryService,
	ClinicServicesByClinicId,
	ClinicDoctorsByClinicId,
} from '~/interfaces/clinic';
import type { DoctorCardData } from '~/interfaces/doctor';

export type ClinicServiceItem = ClinicSummaryService;
export type ClinicServicesMap = ClinicServicesByClinicId;

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

	const doctorPlaceholders = doctorIds.map(() => '?').join(',');
	const clinicPlaceholders = clinicIds.map(() => '?').join(',');
	const query = `
		SELECT doctor_id, clinic_id, medical_service_id, price, price_max
		FROM clinic_medical_service_doctors
		WHERE doctor_id IN (${doctorPlaceholders}) AND clinic_id IN (${clinicPlaceholders})
	`;

	const [rows] = await connection.execute(query, [...doctorIds, ...clinicIds]);

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

	const clinicPlaceholders = clinicIds.map(() => '?').join(',');
	const specialtyPlaceholders = specialtyIds.map(() => '?').join(',');

	const servicesQuery = `
		SELECT
			cms.clinic_id as clinicId,
			ms.id,
			ms.slug,
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
			cms.is_price_outdated,
			GROUP_CONCAT(DISTINCT mss.specialty_id ORDER BY mss.specialty_id) as specialtyIds
		FROM clinic_medical_services cms
		INNER JOIN medical_services ms ON cms.medical_service_id = ms.id
		INNER JOIN medical_services_specialties mss ON ms.id = mss.medical_service_id
		WHERE cms.clinic_id IN (${clinicPlaceholders})
			AND mss.specialty_id IN (${specialtyPlaceholders})
		GROUP BY cms.clinic_id, ms.id, ms.slug, ms.name_en, ms.name_sr, ms.name_sr_cyrl,
			ms.name_ru, ms.name_de, ms.name_tr, ms.sort_order, cms.price, cms.price_min, cms.price_max, cms.is_price_outdated
		ORDER BY cms.clinic_id, ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC;
	`;

	const [serviceRows] = await connection.execute(servicesQuery, [
		...clinicIds,
		...specialtyIds,
	]);

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

		// Флаг устаревшей цены относится к цене клиники; для индивидуальной
		// цены врача (другой источник) не применяется.
		const isOutdated =
			doctorPrice === undefined ? Boolean(row.is_price_outdated) : false;

		result[clinicId].push({
			id: serviceId,
			slug: row.slug || '',
			name: name || '',
			localName: localName || '',
			price,
			priceMin,
			priceMax,
			isOutdated,
		});
	}

	return result;
}

// Кэп врачей на клинику в блоке «Врачи» на странице услуги (см. PRD).
const SERVICE_CLINIC_DOCTORS_CAP = 2;

/**
 * Собирает врачей для блока «Врачи» в карточке клиники на странице услуги.
 *
 * Два источника (см. prd/service-page-doctor-links):
 *  1. Точный — clinic_medical_service_doctors (клиника подтвердила пару
 *     врач×услуга). Если для пары клиника+услуга есть строки — берём только их.
 *  2. Фолбэк по специальности — врачи нужной специальности, работающие именно
 *     в этой клинике (не сайтвайд). Кэп 2, сортировка по rank_score DESC.
 *
 * @returns Record<clinicId, DoctorCardData[]> — только клиники, где нашлись врачи
 */
export async function getDoctorsForServiceByClinic(
	connection: any,
	medicalServiceId: number,
	clinicIds: number[],
	locale: string,
): Promise<ClinicDoctorsByClinicId> {
	if (clinicIds.length === 0) {
		return {};
	}

	const clinicPlaceholders = clinicIds.map(() => '?').join(',');

	// 1. Точный источник: подтверждённые клиникой пары врач×услуга.
	const [exactRows] = await connection.execute(
		`SELECT cmsd.clinic_id AS clinicId, cmsd.doctor_id AS doctorId
		 FROM clinic_medical_service_doctors cmsd
		 JOIN doctors d ON d.id = cmsd.doctor_id AND d.hidden = 0 AND d.is_draft = 0
		 WHERE cmsd.medical_service_id = ? AND cmsd.clinic_id IN (${clinicPlaceholders})
		 ORDER BY cmsd.clinic_id, cmsd.id`,
		[medicalServiceId, ...clinicIds],
	);

	// clinicId -> [doctorId] (в порядке появления, кэп применим ниже)
	const doctorsByClinic = new Map<number, number[]>();
	const clinicsWithExact = new Set<number>();
	for (const row of exactRows as any[]) {
		clinicsWithExact.add(row.clinicId);
		const list = doctorsByClinic.get(row.clinicId) ?? [];
		if (list.length < SERVICE_CLINIC_DOCTORS_CAP) {
			list.push(row.doctorId);
		}
		doctorsByClinic.set(row.clinicId, list);
	}

	// 2. Фолбэк по специальности — только для клиник без точных строк.
	const fallbackClinicIds = clinicIds.filter(
		(id) => !clinicsWithExact.has(id),
	);
	if (fallbackClinicIds.length > 0) {
		const fbPlaceholders = fallbackClinicIds.map(() => '?').join(',');
		const [fallbackRows] = await connection.execute(
			`SELECT dc.clinic_id AS clinicId, d.id AS doctorId, d.rank_score AS rankScore
			 FROM clinic_medical_services cms
			 JOIN doctor_clinics dc ON dc.clinic_id = cms.clinic_id
			 JOIN doctor_specialties ds ON ds.doctor_id = dc.doctor_id
			 JOIN medical_services_specialties mss
			   ON mss.specialty_id = ds.specialty_id
			   AND mss.medical_service_id = cms.medical_service_id
			 JOIN doctors d ON d.id = dc.doctor_id AND d.hidden = 0 AND d.is_draft = 0
			 WHERE cms.medical_service_id = ?
			   AND cms.clinic_id IN (${fbPlaceholders})
			 GROUP BY dc.clinic_id, d.id, d.rank_score
			 ORDER BY dc.clinic_id, d.rank_score DESC, d.id`,
			[medicalServiceId, ...fallbackClinicIds],
		);

		for (const row of fallbackRows as any[]) {
			const list = doctorsByClinic.get(row.clinicId) ?? [];
			if (list.length < SERVICE_CLINIC_DOCTORS_CAP) {
				list.push(row.doctorId);
				doctorsByClinic.set(row.clinicId, list);
			}
		}
	}

	// Собираем уникальные doctorId и грузим карточные поля одним запросом.
	const allDoctorIds = Array.from(
		new Set(Array.from(doctorsByClinic.values()).flat()),
	);
	if (allDoctorIds.length === 0) {
		return {};
	}

	const doctorPlaceholders = allDoctorIds.map(() => '?').join(',');
	const [doctorRows] = await connection.execute(
		`SELECT
			d.id,
			d.slug,
			d.name_sr,
			d.name_sr_cyrl,
			d.name_ru,
			d.name_en,
			d.professional_title AS professionalTitle,
			d.photo_url AS photoUrl,
			(SELECT GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) FROM doctor_specialties ds WHERE ds.doctor_id = d.id) AS specialtyIds,
			(SELECT GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) FROM doctor_languages dl WHERE dl.doctor_id = d.id) AS languageIds,
			(SELECT ROUND(AVG(r.rating), 1) FROM reviews r WHERE r.doctor_id = d.id AND r.rating IS NOT NULL AND r.status != 'rejected') AS averageRating,
			(SELECT COUNT(*) FROM reviews r WHERE r.doctor_id = d.id AND r.rating IS NOT NULL AND r.status != 'rejected') AS totalReviews
		 FROM doctors d
		 WHERE d.id IN (${doctorPlaceholders})`,
		allDoctorIds,
	);

	const doctorById = new Map<number, DoctorCardData>();
	for (const row of doctorRows as any[]) {
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			row,
			locale,
		);
		doctorById.set(row.id, {
			id: row.id,
			slug: row.slug,
			name,
			localName,
			professionalTitle: row.professionalTitle || '',
			photoUrl: row.photoUrl || '',
			specialtyIds: row.specialtyIds || '',
			languageIds: row.languageIds || '',
			rating: row.averageRating
				? {
						averageRating: parseFloat(row.averageRating),
						totalReviews: row.totalReviews,
					}
				: undefined,
		});
	}

	const result: ClinicDoctorsByClinicId = {};
	for (const [clinicId, doctorIds] of doctorsByClinic) {
		const doctors = doctorIds
			.map((id) => doctorById.get(id))
			.filter((d): d is DoctorCardData => d != null);
		if (doctors.length > 0) {
			result[clinicId] = doctors;
		}
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

	const clinicIdsArr = Array.from(allClinicIds);
	const specialtyIdsArr = Array.from(allSpecialtyIds);
	const clinicPlaceholders = clinicIdsArr.map(() => '?').join(',');
	const specialtyPlaceholders = specialtyIdsArr.map(() => '?').join(',');

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
			ms.slug,
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
		WHERE cms.clinic_id IN (${clinicPlaceholders})
			AND mss.specialty_id IN (${specialtyPlaceholders})
		GROUP BY cms.clinic_id, ms.id, ms.slug, ms.name_en, ms.name_sr, ms.name_sr_cyrl,
			ms.name_ru, ms.name_de, ms.name_tr, ms.sort_order, cms.price, cms.price_min, cms.price_max
		ORDER BY cms.clinic_id, ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC;
	`;

	const [serviceRows] = await connection.execute(servicesQuery, [
		...clinicIdsArr,
		...specialtyIdsArr,
	]);

	// Группируем услуги по clinicId с сохранением specialtyIds и базовых цен
	const servicesByClinic: Map<
		number,
		Array<{
			id: number;
			slug: string;
			name: string;
			localName: string;
			price: number | null;
			priceMin: number | null;
			priceMax: number | null;
			isOutdated: boolean;
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
			slug: row.slug || '',
			name: name || '',
			localName: localName || '',
			price: row.price ? Number(row.price) : null,
			priceMin: row.price_min ? Number(row.price_min) : null,
			priceMax: row.price_max ? Number(row.price_max) : null,
			isOutdated: Boolean(row.is_price_outdated),
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

					// Если есть запись для врача - используем её значения (флаг
					// устаревшей цены клиники к ней не относится)
					if (doctorPrice !== undefined) {
						return {
							...rest,
							price: doctorPrice.price,
							priceMin: doctorPrice.priceMin,
							priceMax: doctorPrice.priceMax,
							isOutdated: false,
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
