import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
	processLocalizedDescription,
} from '~/server/common/utils';
import type { ClinicList } from '~/interfaces/clinic';
import type {
	DaySchedule,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import {
	DAYS_OF_WEEK,
	DEFAULT_DAY_SCHEDULE,
} from '~/interfaces/clinic-working-hours';
import { calculateStatus } from '~/common/clinic-working-hours';
import {
	validateCityIds,
	validateClinicTypeIds,
	validateDoctorLanguageIds,
	validateName,
} from '~/common/validation';
import { LIST_PAGE_SIZE } from '~/common/constants';

function parseDaySchedule(value: unknown): DaySchedule {
	if (!value) return DEFAULT_DAY_SCHEDULE;
	if (typeof value === 'string') {
		try {
			return JSON.parse(value) as DaySchedule;
		} catch {
			return DEFAULT_DAY_SCHEDULE;
		}
	}
	return value as DaySchedule;
}

function buildWorkingHours(
	row: any,
): Omit<WorkingHours, 'clinicId'> | undefined {
	if (!row) return undefined;
	const hasAnyDay = DAYS_OF_WEEK.some((day) => row[day] != null);
	if (!hasAnyDay) return undefined;
	return {
		monday: parseDaySchedule(row.monday),
		tuesday: parseDaySchedule(row.tuesday),
		wednesday: parseDaySchedule(row.wednesday),
		thursday: parseDaySchedule(row.thursday),
		friday: parseDaySchedule(row.friday),
		saturday: parseDaySchedule(row.saturday),
		sunday: parseDaySchedule(row.sunday),
	};
}

export default defineEventHandler(async (event): Promise<ClinicList> => {
	try {
		const body = (await readBody(event)) || {};

		if (body.cityIds && !validateCityIds(body, 'api/clinics/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { clinics: [], totalCount: 0 };
		}
		if (
			body.languageIds &&
			!validateDoctorLanguageIds(
				{ languageIds: body.languageIds },
				'api/clinics/list',
			)
		) {
			setResponseStatus(event, 400, 'Invalid clinic language');
			return { clinics: [], totalCount: 0 };
		}
		if (body.name && !validateName(body, 'api/clinics/list')) {
			setResponseStatus(event, 400, 'Invalid name');
			return { clinics: [], totalCount: 0 };
		}
		if (
			body.clinicTypeIds &&
			!validateClinicTypeIds(body, 'api/clinics/list')
		) {
			setResponseStatus(event, 400, 'Invalid clinic type');
			return { clinics: [], totalCount: 0 };
		}

		return getClinicList(body);
	} catch (error) {
		console.error('API Error - clinics:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinics',
		});
	}
});

export async function getClinicList(
	body: {
		cityIds?: number[];
		languageIds?: number[];
		clinicTypeIds?: number[];
		name?: string;
		locale?: string;
		page?: number;
		openNow?: boolean;
	} = {},
) {
	const whereFilters: string[] = [];
	const queryParams: Array<number | string> = [];
	const locale = body.locale || 'en';
	const usePagination = body.page != null;
	const openNow = body.openNow === true;
	const pageRaw = Number(body.page);
	const pageSize = LIST_PAGE_SIZE;
	const page = Math.max(Number.isFinite(pageRaw) ? pageRaw : 1, 1);
	const offset = Math.max(Math.trunc((page - 1) * pageSize), 0);
	// `openNow` filter requires evaluating each clinic's schedule in JS
	// (timezone-aware calculation), which can't be expressed in SQL — paginate
	// in-memory afterwards.
	const useDbPagination = usePagination && !openNow;

	const buildInPlaceholders = (values: Array<number | string>) => {
		const arr = Array.isArray(values) ? values : [values];
		queryParams.push(...arr);
		return arr.map(() => '?').join(',');
	};

	if (body.cityIds?.length > 0) {
		whereFilters.push(`c.city_id IN (${buildInPlaceholders(body.cityIds)})`);
	}

	if (body.languageIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_languages cl_f WHERE cl_f.clinic_id = c.id AND cl_f.language_id IN (${buildInPlaceholders(
				body.languageIds,
			)}))`,
		);
	}

	if (body.clinicTypeIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_clinic_types cct_f WHERE cct_f.clinic_id = c.id AND cct_f.clinic_type_id IN (${buildInPlaceholders(
				body.clinicTypeIds,
			)}))`,
		);
	}

	if (body.name && validateName(body, 'api/clinics/list')) {
		const namePattern = `%${body.name}%`;
		whereFilters.push(
			`(c.name_sr LIKE ? OR c.name_sr_cyrl LIKE ? OR c.name_ru LIKE ?)`,
		);
		queryParams.push(namePattern, namePattern, namePattern);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	const paginationClause = useDbPagination
		? `LIMIT ${pageSize} OFFSET ${offset}`
		: '';

	const totalCountQuery = `
			SELECT COUNT(DISTINCT c.id) as totalCount
			FROM clinics c
			${whereFiltersString};
		`;
	const clinicsQuery = `
			SELECT
				c.id,
				c.slug,
				c.name_sr,
				c.name_ru,
				c.name_sr_cyrl,
				c.city_id as cityId,
				c.address_sr,
				c.address_sr_cyrl,
				c.town_sr,
				c.town_sr_cyrl,
				c.postal_code as postalCode,
				c.latitude,
				c.longitude,
				c.phone,
				c.email,
				c.facebook,
				c.instagram,
				c.telegram,
				c.whatsapp,
				c.viber,
				c.website,
				c.description_sr,
				c.description_sr_cyrl,
				c.description_en,
				c.description_ru,
				c.description_de,
				c.description_tr,
				c.logo_url as logoUrl,
				ANY_VALUE(cwh.monday) as monday,
				ANY_VALUE(cwh.tuesday) as tuesday,
				ANY_VALUE(cwh.wednesday) as wednesday,
				ANY_VALUE(cwh.thursday) as thursday,
				ANY_VALUE(cwh.friday) as friday,
				ANY_VALUE(cwh.saturday) as saturday,
				ANY_VALUE(cwh.sunday) as sunday,
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds,
				COALESCE(GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id), '') as clinicTypeIds,
				COALESCE(
					GROUP_CONCAT(DISTINCT bspi.service_id ORDER BY bspi.service_id),
					''
				) as features,
				(SELECT ROUND(AVG(r.rating), 1) FROM reviews r WHERE r.clinic_id = c.id AND r.rating IS NOT NULL) as averageRating,
				(SELECT COUNT(*) FROM reviews r WHERE r.clinic_id = c.id AND r.rating IS NOT NULL) as totalReviews
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			LEFT JOIN clinic_clinic_types cct ON c.id = cct.clinic_id
			LEFT JOIN clinic_working_hours cwh ON c.id = cwh.clinic_id
			LEFT JOIN billing_clinic_service_purchases bscp
				ON c.id = bscp.clinic_id
				AND bscp.deleted = 0
				AND bscp.purchased_at <= NOW()
				AND bscp.valid_until >= NOW()
			LEFT JOIN billing_clinic_service_purchase_items bspi
				ON bscp.id = bspi.purchase_id
			${whereFiltersString}
			GROUP BY c.id
			ORDER BY c.rank_score DESC, c.name_sr ASC
			${paginationClause};
		`;

	const connection = await getConnection();
	let totalCount = 0;
	if (useDbPagination) {
		const [countRows] = await connection.execute(totalCountQuery, queryParams);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}
	const [clinics] = await connection.execute(clinicsQuery, queryParams);
	await connection.end();

	// Обрабатываем локализованные имена, town, address и description
	let processedClinics = (clinics as any[]).map((clinic: any) => {
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			clinic,
			locale,
		);
		const address = processLocalizedFieldForClinic(clinic, 'address', locale);
		const town = processLocalizedFieldForClinic(clinic, 'town', locale);
		const description = processLocalizedDescription(clinic, locale);
		const features = clinic.features
			? clinic.features.split(',').map(Number)
			: [];

		return {
			id: clinic.id,
			slug: clinic.slug,
			clinicTypeIds: clinic.clinicTypeIds || '',
			cityId: clinic.cityId,
			postalCode: clinic.postalCode,
			latitude: clinic.latitude,
			longitude: clinic.longitude,
			phone: clinic.phone,
			email: clinic.email,
			facebook: clinic.facebook,
			instagram: clinic.instagram,
			telegram: clinic.telegram,
			whatsapp: clinic.whatsapp,
			viber: clinic.viber,
			website: clinic.website,
			description,
			languageIds: clinic.languageIds,
			features,
			name,
			localName,
			address,
			town,
			logoUrl: clinic.logoUrl || '',
			rating: clinic.averageRating
				? {
						averageRating: parseFloat(clinic.averageRating),
						totalReviews: clinic.totalReviews,
					}
				: undefined,
			workingHours: buildWorkingHours(clinic),
		};
	});

	if (openNow) {
		processedClinics = processedClinics.filter((c) =>
			c.workingHours
				? calculateStatus({ clinicId: c.id, ...c.workingHours }).isOpen
				: false,
		);
		totalCount = processedClinics.length;
		if (usePagination) {
			processedClinics = processedClinics.slice(offset, offset + pageSize);
		}
	} else if (!usePagination) {
		totalCount = processedClinics.length;
	}

	return {
		clinics: processedClinics,
		totalCount,
	};
}
