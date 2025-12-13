import { getConnection } from '~/server/common/db-mysql';
import { parseClinicPricesData } from '~/server/common/utils';
import type { LabTestList } from '~/interfaces/clinic';
import {
	validateBody,
	validateName,
	validateCategoryIds,
	validateCityIds,
} from '~/common/validation';

const LOCALE_TO_NAME_FIELD: Record<string, string> = {
	en: 'name',
	ru: 'name_ru',
	sr: 'name_sr',
	me: 'name_sr',
	de: 'name_de',
	tr: 'name_tr',
};

function getNameField(locale?: string): string {
	return LOCALE_TO_NAME_FIELD[locale || 'en'] || 'name';
}

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
	} = {},
) {
	const whereFilters = [];
	const joins = [];
	const nameField = getNameField(body.locale);
	const locale = body.locale || 'en';

	if (body.categoryIds?.length > 0) {
		if (
			!validateCategoryIds(
				{ categoryIds: body.categoryIds },
				'api/labtests/list',
			)
		) {
			return { items: [], totalCount: 0 };
		}
		joins.push(
			'INNER JOIN lab_test_categories_relations ltcr ON lt.id = ltcr.lab_test_id',
		);
		whereFilters.push(`ltcr.category_id IN (${body.categoryIds.join(',')})`);
	}

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`clt.clinic_id IN (${body.clinicIds.join(',')})`);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(`cities.id IN (${body.cityIds.join(',')})`);
	}
	if (body.name && validateName(body, 'api/labtests/list')) {
		joins.push(
			'LEFT JOIN lab_test_synonyms lts_search ON lt.id = lts_search.lab_test_id',
		);
		whereFilters.push(
			`(lt.name LIKE '%${body.name}%' OR lt.${nameField} LIKE '%${body.name}%' OR lt.name_sr LIKE '%${body.name}%' OR lts_search.another_name LIKE '%${body.name}%')`,
		);
	}

	const joinsString = joins.join(' ');
	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const labTestsQuery = `
		SELECT DISTINCT
			lt.id,
			COALESCE(NULLIF(lt.${nameField}, ''), NULLIF(lt.name_sr, ''), lt.name) as name,
			COALESCE(NULLIF(lt.name_sr, ''), lt.name) as originalName,
			GROUP_CONCAT(DISTINCT clt.clinic_id ORDER BY clt.clinic_id) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(clt.clinic_id, ':', COALESCE(clt.price, 0), ':', COALESCE(clt.code, ''))
				ORDER BY clt.clinic_id
			) as clinicPricesData,
			(SELECT GROUP_CONCAT(DISTINCT ltcr_cat.category_id ORDER BY ltcr_cat.category_id)
			 FROM lab_test_categories_relations ltcr_cat
			 WHERE ltcr_cat.lab_test_id = lt.id) as categoryIds
		FROM lab_tests lt
		${joinsString}
		LEFT JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		LEFT JOIN clinics ON clt.clinic_id = clinics.id
		LEFT JOIN cities ON clinics.city_id = cities.id
		${whereFiltersString}
		GROUP BY lt.id, lt.${nameField}, lt.name_sr, lt.name
		ORDER BY name ASC;
	`;

	const connection = await getConnection();
	const [labTestRows] = await connection.execute(labTestsQuery);

	// Получаем синонимы для всех анализов на выбранном языке
	const labTestIds = labTestRows.map((row: any) => row.id);
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

	const items = labTestRows.map((row: any) => ({
		id: row.id,
		name: row.name,
		originalName: row.originalName !== row.name ? row.originalName : undefined,
		synonyms: synonymsMap[row.id] || [],
		clinicIds: row.clinicIds,
		clinicPrices: parseClinicPricesData(row.clinicPricesData),
		categoryIds: row.categoryIds
			? row.categoryIds.split(',').map(Number)
			: undefined,
	}));

	return {
		items,
		totalCount: items.length,
	};
}
