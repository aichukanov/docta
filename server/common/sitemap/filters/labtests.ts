import { getConnection } from '~/server/common/db-mysql';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { LabTestCategory } from '~/enums/labtest-category';

function getEnumValues(enumType: Record<string, string | number>): number[] {
	return Object.values(enumType).filter(
		(value): value is number => !Number.isNaN(Number(value)),
	);
}

/**
 * Категории, за которыми стоит хотя бы один анализ.
 *
 * Раньше отдавался весь enum. Листинг с пустой выборкой отдаёт
 * `noindex, follow` (components/list-page.vue) — то есть sitemap звал бота на
 * страницу, которая сама просит её не индексировать. Сегодня на этих данных
 * непусты все 24 категории, то есть это защита на будущее: новое значение
 * enum'а иначе попадает в sitemap раньше, чем первый анализ в него.
 *
 * Клиники здесь не при чём: базовый листинг `/labtests?categoryIds=N` не
 * требует наличия клиники, он показывает справочник анализов целиком.
 * Пересечение с enum'ом — потому что id вне enum'а не проходит
 * `validateCategoryIds` и страница отдала бы полный каталог с `noindex`.
 */
export async function getCategoryIdsWithLabTests() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT ltcr.category_id as categoryId
		FROM lab_test_categories_relations ltcr
		INNER JOIN lab_tests lt ON lt.id = ltcr.lab_test_id
		ORDER BY ltcr.category_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	const knownIds = new Set(getEnumValues(LabTestCategory));

	return (rows as Array<{ categoryId: number }>)
		.map((row) => row.categoryId)
		.filter((categoryId) => knownIds.has(categoryId));
}

export async function getCategoryCityCombinations() {
	const connection = await getConnection();

	// clinicIsPublicSql обязателен: фильтр по городу в листинге считает только
	// опубликованные и нескрытые клиники (server/api/labtests/list.ts), и без
	// того же предиката здесь пара могла попасть в sitemap с нулевой выдачей.
	const query = `
		SELECT DISTINCT ltcr.category_id as categoryId, c.city_id as cityId
		FROM lab_tests lt
		INNER JOIN lab_test_categories_relations ltcr ON lt.id = ltcr.lab_test_id
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		INNER JOIN clinics c ON clt.clinic_id = c.id
			AND ${clinicIsPublicSql('c')}
		ORDER BY ltcr.category_id, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ categoryId: number; cityId: number }>;
}

// Пары (анализ, город) с количеством клиник ≥ threshold —
// для sitemap-варианта `/labtests/{slug}?cityIds={cityId}`.
// GROUP BY по slug (он UNIQUE), чтобы не нарваться на ONLY_FULL_GROUP_BY.
// Считаем только публичные клиники: иначе порог набирался бы в том числе
// скрытыми, и страница показала бы меньше клиник, чем обещал порог.
export async function getEntityCityCombinations(threshold: number) {
	const connection = await getConnection();

	const query = `
		SELECT
			lt.slug,
			c.city_id as cityId,
			COUNT(DISTINCT clt.clinic_id) as clinicCount
		FROM lab_tests lt
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		INNER JOIN clinics c ON clt.clinic_id = c.id
			AND ${clinicIsPublicSql('c')}
		GROUP BY lt.slug, c.city_id
		HAVING clinicCount >= ?
		ORDER BY lt.slug, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query, [threshold]);
	await connection.end();

	return rows as Array<{ slug: string; cityId: number; clinicCount: number }>;
}
