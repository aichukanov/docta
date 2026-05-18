import { getConnection } from '~/server/common/db-mysql';
import { LabTestCategory } from '~/enums/labtest-category';

function getEnumValues(enumType: any) {
	return Object.values(enumType).filter(
		(value) => !Number.isNaN(Number(value)),
	);
}

function getCategoryIds() {
	return getEnumValues(LabTestCategory);
}

async function getCategoryCityCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT ltcr.category_id as categoryId, c.city_id as cityId
		FROM lab_tests lt
		INNER JOIN lab_test_categories_relations ltcr ON lt.id = ltcr.lab_test_id
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		INNER JOIN clinics c ON clt.clinic_id = c.id
		ORDER BY ltcr.category_id, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ categoryId: number; cityId: number }>;
}

// Пары (анализ, город) с количеством клиник ≥ threshold —
// для sitemap-варианта `/labtests/{slug}?cityIds={cityId}`.
// GROUP BY по slug (он UNIQUE), чтобы не нарваться на ONLY_FULL_GROUP_BY.
async function getEntityCityCombinations(threshold: number) {
	const connection = await getConnection();

	const query = `
		SELECT
			lt.slug,
			c.city_id as cityId,
			COUNT(DISTINCT clt.clinic_id) as clinicCount
		FROM lab_tests lt
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		INNER JOIN clinics c ON clt.clinic_id = c.id
		GROUP BY lt.slug, c.city_id
		HAVING clinicCount >= ?
		ORDER BY lt.slug, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query, [threshold]);
	await connection.end();

	return rows as Array<{ slug: string; cityId: number; clinicCount: number }>;
}

export async function getSitemapFilters(detailCityMinClinics: number) {
	return {
		categoryIds: getCategoryIds(),
		categoryCityCombinations: await getCategoryCityCombinations(),
		entityCityCombinations: await getEntityCityCombinations(
			detailCityMinClinics,
		),
	};
}
