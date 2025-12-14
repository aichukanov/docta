import { getConnection } from '~/server/common/db-mysql';
import { LabTestCategory } from '~/enums/labtest-category';

function getEnumValues(enumType: any) {
	return Object.values(enumType).filter(
		(value) => !Number.isNaN(Number(value)),
	);
}

// === Одиночные фильтры ===

export function getCategoryIds() {
	return getEnumValues(LabTestCategory);
}

// === Комбинации фильтров из БД ===

export async function getCityCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT c.city_id as cityId
		FROM clinic_lab_tests clt
		INNER JOIN clinics c ON clt.clinic_id = c.id
		ORDER BY c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ cityId: number }>;
}

export async function getClinicCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT clt.clinic_id as clinicId
		FROM clinic_lab_tests clt
		ORDER BY clt.clinic_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ clinicId: number }>;
}

export async function getCategoryCityCombinations() {
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

export async function getCategoryClinicCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT ltcr.category_id as categoryId, clt.clinic_id as clinicId
		FROM lab_tests lt
		INNER JOIN lab_test_categories_relations ltcr ON lt.id = ltcr.lab_test_id
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		ORDER BY ltcr.category_id, clt.clinic_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ categoryId: number; clinicId: number }>;
}

// === Фильтры для Sitemap (только ценные, без thin pages) ===

export async function getSitemapFilters() {
	return {
		// Одиночные
		categoryIds: getCategoryIds(),
		// Комбинации
		categoryCityCombinations: await getCategoryCityCombinations(),
	};
}
