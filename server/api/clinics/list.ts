import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
	processLocalizedDescription,
} from '~/server/common/utils';
import type { ClinicList } from '~/interfaces/clinic';
import {
	validateCityIds,
	validateDoctorLanguageIds,
	validateName,
} from '~/common/validation';
import { LIST_PAGE_SIZE } from '~/common/constants';

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
		name?: string;
		locale?: string;
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

	if (body.name && validateName(body, 'api/clinics/list')) {
		const namePattern = `%${body.name}%`;
		whereFilters.push(
			`(c.name_sr LIKE ? OR c.name_sr_cyrl LIKE ? OR c.name_ru LIKE ?)`,
		);
		queryParams.push(namePattern, namePattern, namePattern);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	const paginationClause = usePagination
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
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds,
				COALESCE(
					GROUP_CONCAT(DISTINCT bspi.service_id ORDER BY bspi.service_id),
					''
				) as features
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			LEFT JOIN billing_clinic_service_purchases bscp
				ON c.id = bscp.clinic_id
				AND bscp.deleted = 0
				AND bscp.purchased_at <= NOW()
				AND bscp.valid_until >= NOW()
			LEFT JOIN billing_clinic_service_purchase_items bspi
				ON bscp.id = bspi.purchase_id
			${whereFiltersString}
			GROUP BY c.id
			ORDER BY c.name_sr ASC
			${paginationClause};
		`;

	const connection = await getConnection();
	let totalCount = 0;
	if (usePagination) {
		const [countRows] = await connection.execute(totalCountQuery, queryParams);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}
	const [clinics] = await connection.execute(clinicsQuery, queryParams);
	await connection.end();

	// Обрабатываем локализованные имена, town, address и description
	const processedClinics = (clinics as any[]).map((clinic: any) => {
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
		};
	});

	if (!usePagination) {
		totalCount = processedClinics.length;
	}

	return {
		clinics: processedClinics,
		totalCount,
	};
}
