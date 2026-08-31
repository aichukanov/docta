import { getConnection } from '~/server/common/db-mysql';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { MedicalServiceCategory } from '~/enums/medical-service-category';

function getEnumValues(enumType: Record<string, string | number>): number[] {
	return Object.values(enumType).filter(
		(value): value is number => !Number.isNaN(Number(value)),
	);
}

// === Одиночные фильтры ===

/**
 * Категории, за которыми стоит хотя бы одна услуга.
 *
 * Раньше отдавался весь enum. Листинг с пустой выборкой отдаёт
 * `noindex, follow` (components/list-page.vue) — sitemap звал бота на страницу,
 * которая сама просит её не индексировать. Сегодня непусты все 36 категорий,
 * то есть это защита на будущее: новое значение enum'а иначе попадёт в sitemap
 * раньше, чем первая услуга в нём.
 *
 * Клиники здесь ни при чём: базовый листинг `/services?serviceCategoryIds=N`
 * не требует наличия клиники. Пересечение с enum'ом — потому что id вне
 * enum'а не проходит `validateServiceCategoryIds` и страница отдала бы полный
 * каталог с `noindex`.
 */
export async function getCategoryIdsWithServices() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT mscr.medical_service_category_id as categoryId
		FROM medical_service_categories_relations mscr
		INNER JOIN medical_services ms ON ms.id = mscr.medical_service_id
		ORDER BY mscr.medical_service_category_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	const knownIds = new Set(getEnumValues(MedicalServiceCategory));

	return (rows as Array<{ categoryId: number }>)
		.map((row) => row.categoryId)
		.filter((categoryId) => knownIds.has(categoryId));
}

// === Комбинации фильтров из БД ===

export async function getCategoryCityCombinations() {
	const connection = await getConnection();

	// clinicIsPublicSql обязателен: фильтр по городу в листинге считает только
	// опубликованные и нескрытые клиники (server/api/services/list.ts), и без
	// того же предиката здесь пара могла попасть в sitemap с нулевой выдачей.
	const query = `
		SELECT DISTINCT mscr.medical_service_category_id as categoryId, c.city_id as cityId
		FROM medical_services ms
		INNER JOIN medical_service_categories_relations mscr ON ms.id = mscr.medical_service_id
		INNER JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
		INNER JOIN clinics c ON cms.clinic_id = c.id
			AND ${clinicIsPublicSql('c')}
		ORDER BY mscr.medical_service_category_id, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ categoryId: number; cityId: number }>;
}

// Пары (услуга, город) с количеством клиник ≥ threshold —
// для sitemap-варианта `/services/{slug}?cityIds={cityId}`.
// GROUP BY по slug (он UNIQUE), чтобы не нарваться на ONLY_FULL_GROUP_BY.
// Считаем только публичные клиники: иначе порог набирался бы в том числе
// скрытыми, и страница показала бы меньше клиник, чем обещал порог.
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
			AND ${clinicIsPublicSql('c')}
		GROUP BY ms.slug, c.city_id
		HAVING clinicCount >= ?
		ORDER BY ms.slug, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query, [threshold]);
	await connection.end();

	return rows as Array<{ slug: string; cityId: number; clinicCount: number }>;
}
