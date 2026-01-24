import { getConnection } from '~/server/common/db-mysql';
import { MedicalServiceCategory } from '~/enums/medical-service-category';

function getEnumValues(enumType: any) {
	return Object.values(enumType).filter(
		(value) => !Number.isNaN(Number(value)),
	);
}

// === Одиночные фильтры ===

export function getCategoryIds() {
	return getEnumValues(MedicalServiceCategory);
}

// === Комбинации фильтров из БД ===

export async function getCategoryCityCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT mscr.medical_service_category_id as categoryId, c.city_id as cityId
		FROM medical_services ms
		INNER JOIN medical_service_categories_relations mscr ON ms.id = mscr.medical_service_id
		INNER JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
		INNER JOIN clinics c ON cms.clinic_id = c.id
		ORDER BY mscr.medical_service_category_id, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ categoryId: number; cityId: number }>;
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
