import { getConnection } from '~/server/common/db-mysql';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import {
	getServicesForDoctors,
	type ClinicServicesMap,
} from '~/server/common/services';
import type { DoctorList } from '~/interfaces/doctor';
import { LIST_PAGE_SIZE } from '~/common/constants';
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
			return { doctors: [], totalCount: 0 };
		}
		if (body.specialtyIds && !validateSpecialtyIds(body, 'api/doctors/list')) {
			setResponseStatus(event, 400, 'Invalid specialty');
			return { doctors: [], totalCount: 0 };
		}
		if (body.cityIds && !validateCityIds(body, 'api/doctors/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { doctors: [], totalCount: 0 };
		}
		if (
			body.languageIds &&
			!validateDoctorLanguageIds(body, 'api/doctors/list')
		) {
			setResponseStatus(event, 400, 'Invalid doctor language');
			return { doctors: [], totalCount: 0 };
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
		locale?: string;
		includeAllLocales?: boolean;
		includeServices?: boolean;
		page?: number;
	} = {},
) {
	const whereFilters: string[] = [];
	const queryParams: Array<number | string> = [];
	const locale = body.locale || 'en';
	const usePagination = body.page != null;
	const pageRaw = Number(body.page);
	const pageSize = LIST_PAGE_SIZE;
	const page = Math.max(Number.isFinite(pageRaw) ? pageRaw : 1, 1);
	const offset = Math.max(Math.trunc((page - 1) * pageSize), 0);

	const buildInPlaceholders = (values: Array<number | string>) => {
		queryParams.push(...values);
		return values.map(() => '?').join(',');
	};

	if (body.specialtyIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM doctor_specialties ds WHERE ds.doctor_id = d.id AND ds.specialty_id IN (${buildInPlaceholders(body.specialtyIds)}))`,
		);
	}

	if (body.cityIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM doctor_clinics dc JOIN clinics c ON dc.clinic_id = c.id WHERE dc.doctor_id = d.id AND c.city_id IN (${buildInPlaceholders(body.cityIds)}))`,
		);
	}

	if (body.languageIds?.length > 0) {
		if (body.onlyDoctorLanguages) {
			whereFilters.push(
				`EXISTS (SELECT 1 FROM doctor_languages dl WHERE dl.doctor_id = d.id AND dl.language_id IN (${buildInPlaceholders(body.languageIds)}))`,
			);
		} else {
			whereFilters.push(
				`(EXISTS (SELECT 1 FROM doctor_languages dl WHERE dl.doctor_id = d.id AND dl.language_id IN (${buildInPlaceholders(body.languageIds)})) OR EXISTS (SELECT 1 FROM doctor_clinics dc JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id WHERE dc.doctor_id = d.id AND cl.language_id IN (${buildInPlaceholders(body.languageIds)})))`,
			);
		}
	}

	if (body.clinicIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM doctor_clinics dc WHERE dc.doctor_id = d.id AND dc.clinic_id IN (${buildInPlaceholders(body.clinicIds)}))`,
		);
	}

	if (body.name && validateName(body, 'api/doctors/list')) {
		const namePattern = `%${body.name}%`;
		whereFilters.push(
			`(d.name_sr LIKE ? OR d.name_sr_cyrl LIKE ? OR d.name_ru LIKE ? OR d.name_en LIKE ?)`,
		);
		queryParams.push(namePattern, namePattern, namePattern, namePattern);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const paginationClause = usePagination
		? `LIMIT ${pageSize} OFFSET ${offset}`
		: '';
	const totalCountQuery = `
			SELECT COUNT(DISTINCT d.id) as totalCount
			FROM doctors d
			${whereFiltersString};
		`;
	const doctorsQuery = `
			SELECT
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
				(SELECT GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) FROM doctor_specialties ds WHERE ds.doctor_id = d.id) as specialtyIds,
				(SELECT GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) FROM doctor_languages dl WHERE dl.doctor_id = d.id) as languageIds,
				(SELECT GROUP_CONCAT(DISTINCT dc.clinic_id ORDER BY dc.clinic_id) FROM doctor_clinics dc WHERE dc.doctor_id = d.id) as clinicIds
			FROM doctors d
			${whereFiltersString}
			ORDER BY d.name_sr ASC
			${paginationClause};
		`;

	const connection = await getConnection();
	let totalCount = 0;
	if (usePagination) {
		const [countRows] = await connection.execute(
			totalCountQuery,
			queryParams,
		);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}
	const [doctorRows] = await connection.execute(doctorsQuery, queryParams);

	// Загружаем услуги для всех врачей, если нужно
	let servicesMap: Map<string, ClinicServicesMap> | null = null;

	if (body.includeServices && doctorRows.length > 0) {
		servicesMap = await getServicesForDoctors(
			connection,
			doctorRows as any[],
			locale,
		);
	}

	await connection.end();

	// Обрабатываем локализованные имена
	const processedDoctors = (doctorRows as any[]).map((doctor: any) => {
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			doctor,
			locale,
		);

		// Получаем услуги для этого врача
		const clinicServices = servicesMap?.get(String(doctor.id)) || undefined;

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

		// Для админки сохраняем все поля локализации
		if (body.includeAllLocales) {
			return {
				...doctor,
				name,
				localName,
				clinicIds: sortedClinicIds,
				clinicServices,
			};
		}
		// Удаляем избыточные поля локализации
		const { name_sr, name_sr_cyrl, name_ru, name_en, ...rest } = doctor;
		return {
			...rest,
			name,
			localName,
			clinicIds: sortedClinicIds,
			clinicServices,
		};
	});

	if (!usePagination) {
		totalCount = processedDoctors.length;
	}

	return {
		doctors: processedDoctors,
		totalCount,
	};
}
