import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
	processLocalizedNameForClinicOrDoctor,
	getLocalizedNameField,
} from '~/server/common/utils';
import type { ClinicServiceList } from '~/interfaces/clinic';
import {
	validateBody,
	validateName,
	validateCityIds,
} from '~/common/validation';
import { LIST_PAGE_SIZE } from '~/common/constants';

export default defineEventHandler(async (event): Promise<ClinicServiceList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/medications/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return { items: [], totalCount: 0 };
		}
		if (body.cityIds && !validateCityIds(body, 'api/medications/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { items: [], totalCount: 0 };
		}

		return getMedicationList(body);
	} catch (error) {
		console.error('API Error - medications:', error);
		return { items: [], totalCount: 0 };
	}
});

export async function getMedicationList(
	body: {
		clinicIds?: number[];
		cityIds?: number[];
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

	if (body.clinicIds?.length > 0) {
		whereFilters.push(
			`cm.clinic_id IN (${buildInPlaceholders(body.clinicIds)})`,
		);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(
			`cities.id IN (${buildInPlaceholders(body.cityIds)})`,
		);
	}
	if (body.name && validateName(body, 'api/medications/list')) {
		const nameField = getLocalizedNameField(locale) || 'name_en';
		const namePattern = `%${body.name}%`;
		whereFilters.push(
			`(m.name_en LIKE ? OR m.${nameField} LIKE ? OR m.name_sr LIKE ? OR m.name_sr_cyrl LIKE ? OR m.name_ru LIKE ? OR m.name_de LIKE ? OR m.name_tr LIKE ?)`,
		);
		queryParams.push(
			namePattern,
			namePattern,
			namePattern,
			namePattern,
			namePattern,
			namePattern,
			namePattern,
		);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	const paginationClause = usePagination
		? `LIMIT ${pageSize} OFFSET ${offset}`
		: '';

	const priceOrder = getPriceOrderBySQL('cm');
	const totalCountQuery = `
		SELECT COUNT(DISTINCT m.id) as totalCount
		FROM medications m
		LEFT JOIN clinic_medications cm ON m.id = cm.medication_id
		LEFT JOIN clinics ON cm.clinic_id = clinics.id
		LEFT JOIN cities ON clinics.city_id = cities.id
		${whereFiltersString};
	`;
	const medicationsQuery = `
		SELECT DISTINCT
			m.id,
			m.name_en,
			m.name_sr,
			m.name_sr_cyrl,
			m.name_ru,
			m.name_de,
			m.name_tr,
			GROUP_CONCAT(DISTINCT cm.clinic_id ORDER BY ${priceOrder}) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(cm.clinic_id, ':', IFNULL(cm.price, ''), ':', '', ':', IFNULL(cm.price_max, ''), ':', COALESCE(cm.code, ''))
				ORDER BY ${priceOrder}
			) as clinicPricesData
		FROM medications m
		LEFT JOIN clinic_medications cm ON m.id = cm.medication_id
		LEFT JOIN clinics ON cm.clinic_id = clinics.id
		LEFT JOIN cities ON clinics.city_id = cities.id
		${whereFiltersString}
		GROUP BY m.id, m.name_en, m.name_sr, m.name_sr_cyrl, m.name_ru, m.name_de, m.name_tr 
		ORDER BY m.name_en ASC
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
	const [medicationRows] = await connection.execute(
		medicationsQuery,
		queryParams,
	);
	await connection.end();

	const items = medicationRows.map((row: any) => {
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			row,
			locale,
		);
		// Удаляем избыточные поля локализации
		const {
			name_en,
			name_sr,
			name_sr_cyrl,
			name_ru,
			name_de,
			name_tr,
			...rest
		} = row;
		return {
			...rest,
			id: row.id,
			name: name || '',
			localName: localName || '',
			clinicIds: row.clinicIds,
			clinicPrices: parseClinicPricesData(row.clinicPricesData),
		};
	});

	return {
		items,
		totalCount: usePagination ? totalCount : items.length,
	};
}
