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

// Пары (услуга, город) с количеством клиник ≥ threshold —
// для sitemap-варианта `/services/{slug}?cityIds={cityId}`.
// GROUP BY по slug (он UNIQUE), чтобы не нарваться на ONLY_FULL_GROUP_BY.
export async function getEntityCityCombinations(threshold: number) {
	const connection = await getConnection();

	const query = `
		SELECT
			ms.slug,
			c.city_id as cityId,
			COUNT(DISTINCT cms.clinic_id) as clinicCount
		FROM medical_services ms
		INNER JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
		INNER JOIN clinics c ON cms.clinic_id = c.id
		GROUP BY ms.slug, c.city_id
		HAVING clinicCount >= ?
		ORDER BY ms.slug, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query, [threshold]);
	await connection.end();

	return rows as Array<{ slug: string; cityId: number; clinicCount: number }>;
}

// === Фильтры для Sitemap (только ценные, без thin pages) ===

export async function getSitemapFilters(detailCityMinClinics: number) {
	return {
		// Одиночные
		categoryIds: getCategoryIds(),
		// Комбинации
		categoryCityCombinations: await getCategoryCityCombinations(),
		entityCityCombinations: await getEntityCityCombinations(
			detailCityMinClinics,
		),
	};
}
