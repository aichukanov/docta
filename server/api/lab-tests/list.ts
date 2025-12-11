import { getConnection } from '~/server/common/db-mysql';
import type { ClinicServiceList } from '~/interfaces/clinic';
import { validateBody, validateName } from '~/common/validation';

export default defineEventHandler(async (event): Promise<ClinicServiceList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/lab-tests/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		return getLabTestList(body);
	} catch (error) {
		console.error('API Error - lab-tests:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch lab tests',
		});
	}
});

export async function getLabTestList(
	body: {
		clinicIds?: number[];
		name?: string;
	} = {},
) {
	const whereFilters = [];

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`clt.clinic_id IN (${body.clinicIds.join(',')})`);
	}
	if (body.name && validateName(body, 'api/lab-tests/list')) {
		whereFilters.push(`lt.name LIKE '%${body.name}%'`);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const labTestsQuery = `
		SELECT DISTINCT
			lt.id,
			lt.name,
			GROUP_CONCAT(DISTINCT clt.clinic_id ORDER BY clt.clinic_id) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(clt.clinic_id, ':', COALESCE(clt.price, 0), ':', COALESCE(clt.code, ''))
				ORDER BY clt.clinic_id
			) as clinicPricesData
		FROM lab_tests lt
		LEFT JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		${whereFiltersString}
		GROUP BY lt.id, lt.name 
		ORDER BY lt.name ASC;
	`;

	const connection = await getConnection();
	const [labTestRows] = await connection.execute(labTestsQuery);
	await connection.end();

	// Преобразуем данные о ценах в массив объектов
	const labTests = labTestRows.map((row) => {
		const clinicPrices = [];
		if (row.clinicPricesData) {
			const pricesData = row.clinicPricesData.split(',');
			for (const priceData of pricesData) {
				const [clinicId, price, code] = priceData.split(':');
				clinicPrices.push({
					clinicId: Number(clinicId),
					price: Number(price) || null,
					code: code || null,
				});
			}
		}

		return {
			id: row.id,
			name: row.name,
			clinicIds: row.clinicIds,
			clinicPrices,
		};
	});

	return {
		labTests,
		totalCount: labTests.length,
	};
}
