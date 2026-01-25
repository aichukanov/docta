import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
	processLocalizedNameForLabTest,
	getLocalizedNameField,
} from '~/server/common/utils';
import type { LabTestList } from '~/interfaces/clinic';
import {
	validateBody,
	validateName,
	validateCategoryIds,
	validateCityIds,
} from '~/common/validation';
import { LIST_PAGE_SIZE } from '~/common/constants';

export default defineEventHandler(async (event): Promise<LabTestList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/labtests/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return { items: [], totalCount: 0 };
		}
		if (body.cityIds && !validateCityIds(body, 'api/labtests/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { items: [], totalCount: 0 };
		}

		return getLabTestList(body);
	} catch (error) {
		console.error('API Error - labtests:', error);
		return { items: [], totalCount: 0 };
	}
});

export async function getLabTestList(
	body: {
		clinicIds?: number[];
		cityIds?: number[];
		categoryIds?: number[];
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

	if (body.categoryIds?.length > 0) {
		if (
			!validateCategoryIds(
				{ categoryIds: body.categoryIds },
				'api/labtests/list',
			)
		) {
			return { items: [], totalCount: 0 };
		}
		whereFilters.push(
			`EXISTS (SELECT 1 FROM lab_test_categories_relations ltcr WHERE ltcr.lab_test_id = lt.id AND ltcr.category_id IN (${buildInPlaceholders(
				body.categoryIds,
			)}))`,
		);
	}

	if (body.clinicIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_lab_tests clt_f WHERE clt_f.lab_test_id = lt.id AND clt_f.clinic_id IN (${buildInPlaceholders(
				body.clinicIds,
			)}))`,
		);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_lab_tests clt_f JOIN clinics c_f ON clt_f.clinic_id = c_f.id WHERE clt_f.lab_test_id = lt.id AND c_f.city_id IN (${buildInPlaceholders(
				body.cityIds,
			)}))`,
		);
	}
	if (body.name && validateName(body, 'api/labtests/list')) {
		const nameField = getLocalizedNameField(locale) || 'name_en';
		const namePattern = `%${body.name}%`;
		// Для sr-cyrl ищем также по синонимам на кириллице
		const synonymsFilter =
			locale === 'sr-cyrl'
				? `EXISTS (SELECT 1 FROM lab_test_synonyms lts_f WHERE lts_f.lab_test_id = lt.id AND lts_f.another_name LIKE ? AND lts_f.language IN ('sr-cyrl', 'sr'))`
				: `EXISTS (SELECT 1 FROM lab_test_synonyms lts_f WHERE lts_f.lab_test_id = lt.id AND lts_f.another_name LIKE ?)`;
		whereFilters.push(
			`(lt.name_en LIKE ? OR lt.${nameField} LIKE ? OR lt.name_sr LIKE ? OR lt.name_sr_cyrl LIKE ? OR ${synonymsFilter})`,
		);
		queryParams.push(
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

	const priceOrder = getPriceOrderBySQL('clt');
	const totalCountQuery = `
		SELECT COUNT(DISTINCT lt.id) as totalCount
		FROM lab_tests lt
		${whereFiltersString};
	`;
	const labTestsQuery = `
		SELECT
			lt.id,
			lt.name_en,
			lt.name_sr,
			lt.name_sr_cyrl,
			lt.name_ru,
			lt.name_de,
			lt.name_tr,
			(SELECT GROUP_CONCAT(DISTINCT clt.clinic_id ORDER BY ${priceOrder}) FROM clinic_lab_tests clt WHERE clt.lab_test_id = lt.id) as clinicIds,
			(SELECT GROUP_CONCAT(
				DISTINCT CONCAT(clt.clinic_id, ':', IFNULL(clt.price, ''), ':', '', ':', IFNULL(clt.price_max, ''), ':', COALESCE(clt.code, ''))
				ORDER BY ${priceOrder}
			) FROM clinic_lab_tests clt WHERE clt.lab_test_id = lt.id) as clinicPricesData,
			(SELECT GROUP_CONCAT(DISTINCT ltcr_cat.category_id ORDER BY ltcr_cat.category_id)
			 FROM lab_test_categories_relations ltcr_cat
			 WHERE ltcr_cat.lab_test_id = lt.id) as categoryIds
		FROM lab_tests lt
		${whereFiltersString}
		ORDER BY lt.name_en ASC
		${paginationClause};
	`;

	const connection = await getConnection();
	let totalCount = 0;
	if (usePagination) {
		const [countRows] = await connection.execute(totalCountQuery, queryParams);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}
	const [labTestRows] = await connection.execute(labTestsQuery, queryParams);

	// Получаем синонимы для всех анализов на выбранном языке
	const labTestIds = labTestRows.map(({ id }: { id: number }) => id);
	let synonymsMap: Record<number, string[]> = {};

	if (labTestIds.length > 0) {
		const synonymsQuery = `
			SELECT lab_test_id, another_name
			FROM lab_test_synonyms
			WHERE lab_test_id IN (${labTestIds.join(',')})
			AND language = ?
			ORDER BY another_name ASC
		`;
		const [synonymRows] = await connection.execute(synonymsQuery, [locale]);

		for (const row of synonymRows as any[]) {
			if (!synonymsMap[row.lab_test_id]) {
				synonymsMap[row.lab_test_id] = [];
			}
			synonymsMap[row.lab_test_id].push(row.another_name);
		}
	}

	await connection.end();

	const items = labTestRows.map((row: any) => {
		const { name, localName } = processLocalizedNameForLabTest(row, locale);
		return {
			id: row.id,
			name: name || '',
			localName: localName || '',
			synonyms: synonymsMap[row.id] || [],
			clinicIds: row.clinicIds,
			clinicPrices: parseClinicPricesData(row.clinicPricesData),
			categoryIds: row.categoryIds
				? row.categoryIds.split(',').map(Number)
				: undefined,
		};
	});

	return {
		items,
		totalCount: usePagination ? totalCount : items.length,
	};
}
