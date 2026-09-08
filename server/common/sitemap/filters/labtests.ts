import { getConnection } from '~/server/common/db-mysql';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { lastmodSql, toLastmod } from '~/server/common/sitemap/lastmod';
import { LabTestCategory } from '~/enums/labtest-category';

// Дата изменения фасета — максимум `updated_at` по анализам выборки, поэтому
// `DISTINCT` ниже заменён на `GROUP BY` с `MAX(...)`: набор строк тот же,
// добавилась агрегация. Колонки может ещё не быть (её заводит миграция 026) —
// `lastmodSql` подставит вместо выражения литерал NULL, и тег не выведется.

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
	const lastmod = await lastmodSql('lab_tests', 'MAX(lt.updated_at)');
	const connection = await getConnection();

	const query = `
		SELECT ltcr.category_id as categoryId, ${lastmod} as lastmod
		FROM lab_test_categories_relations ltcr
		INNER JOIN lab_tests lt ON lt.id = ltcr.lab_test_id
		GROUP BY ltcr.category_id
		ORDER BY ltcr.category_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	const knownIds = new Set(getEnumValues(LabTestCategory));

	return (rows as Array<{ categoryId: number; lastmod: unknown }>)
		.filter((row) => knownIds.has(row.categoryId))
		.map((row) => ({
			categoryId: row.categoryId,
			lastmod: toLastmod(row.lastmod),
		}));
}

export async function getCategoryCityCombinations() {
	const lastmod = await lastmodSql('lab_tests', 'MAX(lt.updated_at)');
	const connection = await getConnection();

	// clinicIsPublicSql обязателен: фильтр по городу в листинге считает только
	// опубликованные и нескрытые клиники (server/api/labtests/list.ts), и без
	// того же предиката здесь пара могла попасть в sitemap с нулевой выдачей.
	const query = `
		SELECT ltcr.category_id as categoryId, c.city_id as cityId,
			${lastmod} as lastmod
		FROM lab_tests lt
		INNER JOIN lab_test_categories_relations ltcr ON lt.id = ltcr.lab_test_id
		INNER JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
		INNER JOIN clinics c ON clt.clinic_id = c.id
			AND ${clinicIsPublicSql('c')}
		GROUP BY ltcr.category_id, c.city_id
		ORDER BY ltcr.category_id, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (
		rows as Array<{ categoryId: number; cityId: number; lastmod: unknown }>
	).map((row) => ({
		categoryId: row.categoryId,
		cityId: row.cityId,
		lastmod: toLastmod(row.lastmod),
	}));
}

// Пары (анализ, город) с количеством клиник ≥ threshold —
// для sitemap-варианта `/labtests/{slug}?cityIds={cityId}`.
// GROUP BY по slug (он UNIQUE), чтобы не нарваться на ONLY_FULL_GROUP_BY.
// Считаем только публичные клиники: иначе порог набирался бы в том числе
// скрытыми, и страница показала бы меньше клиник, чем обещал порог.
export async function getEntityCityCombinations(threshold: number) {
	const lastmod = await lastmodSql('lab_tests', 'MAX(lt.updated_at)');
	const connection = await getConnection();

	const query = `
		SELECT
			lt.slug,
			c.city_id as cityId,
			COUNT(DISTINCT clt.clinic_id) as clinicCount,
			${lastmod} as lastmod
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

	return (
		rows as Array<{
			slug: string;
			cityId: number;
			clinicCount: number;
			lastmod: unknown;
		}>
	).map((row) => ({
		slug: row.slug,
		cityId: row.cityId,
		clinicCount: row.clinicCount,
		lastmod: toLastmod(row.lastmod),
	}));
}
