import { getConnection } from '~/server/common/db-mysql';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { lastmodSql, toLastmod } from '~/server/common/sitemap/lastmod';

// Даты изменения ниже — `updated_at` клиники, а для фасетов максимум по
// клиникам выборки: страница «стоматологии в Будве» устаревает ровно тогда,
// когда меняется хоть одна клиника из неё. Поэтому `DISTINCT` заменён на
// `GROUP BY` с `MAX(...)`: набор строк тот же, добавилась агрегация.

export async function getClinicList() {
	const lastmod = await lastmodSql('clinics', 'c.updated_at');
	const connection = await getConnection();

	const query = `
		SELECT c.id, c.slug, c.city_id as cityId, ${lastmod} as lastmod
		FROM clinics c
		WHERE ${clinicIsPublicSql('c')}
		ORDER BY c.id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (
		rows as Array<{
			id: number;
			slug: string;
			cityId: number;
			lastmod: unknown;
		}>
	).map((row) => ({
		id: row.id,
		slug: row.slug,
		cityId: row.cityId,
		lastmod: toLastmod(row.lastmod),
	}));
}

// Города, в которых реально есть опубликованные клиники — страницы
// `/clinics?cityIds=N` (раньше перебирался весь enum городов, включая пустые)
async function getCityIdsWithClinics() {
	const lastmod = await lastmodSql('clinics', 'MAX(c.updated_at)');
	const connection = await getConnection();

	const query = `
		SELECT c.city_id as cityId, ${lastmod} as lastmod
		FROM clinics c
		WHERE ${clinicIsPublicSql('c')} AND c.city_id IS NOT NULL
		GROUP BY c.city_id
		ORDER BY c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (rows as Array<{ cityId: number; lastmod: unknown }>).map((row) => ({
		cityId: row.cityId,
		lastmod: toLastmod(row.lastmod),
	}));
}

// Типы клиник с хотя бы одной опубликованной клиникой — `/clinics?clinicTypeIds=N`
// («Стоматологические клиники в Черногории»)
async function getClinicTypeIds() {
	const lastmod = await lastmodSql('clinics', 'MAX(c.updated_at)');
	const connection = await getConnection();

	const query = `
		SELECT cct.clinic_type_id as clinicTypeId, ${lastmod} as lastmod
		FROM clinic_clinic_types cct
		INNER JOIN clinics c ON cct.clinic_id = c.id
		WHERE ${clinicIsPublicSql('c')}
		GROUP BY cct.clinic_type_id
		ORDER BY cct.clinic_type_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (rows as Array<{ clinicTypeId: number; lastmod: unknown }>).map(
		(row) => ({
			clinicTypeId: row.clinicTypeId,
			lastmod: toLastmod(row.lastmod),
		}),
	);
}

// Пары (тип клиники, город) с количеством клиник ≥ threshold —
// `/clinics?clinicTypeIds=N&cityIds=M` («Стоматологические клиники в Будве»).
// Ниже порога — thin page, не раздуваем индекс.
export async function getTypeCityCombinations(threshold: number) {
	const lastmod = await lastmodSql('clinics', 'MAX(c.updated_at)');
	const connection = await getConnection();

	const query = `
		SELECT
			cct.clinic_type_id as clinicTypeId,
			c.city_id as cityId,
			COUNT(DISTINCT c.id) as clinicCount,
			${lastmod} as lastmod
		FROM clinic_clinic_types cct
		INNER JOIN clinics c ON cct.clinic_id = c.id
		WHERE ${clinicIsPublicSql('c')} AND c.city_id IS NOT NULL
		GROUP BY cct.clinic_type_id, c.city_id
		HAVING clinicCount >= ?
		ORDER BY cct.clinic_type_id, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query, [threshold]);
	await connection.end();

	return (
		rows as Array<{
			clinicTypeId: number;
			cityId: number;
			clinicCount: number;
			lastmod: unknown;
		}>
	).map((row) => ({
		clinicTypeId: row.clinicTypeId,
		cityId: row.cityId,
		clinicCount: row.clinicCount,
		lastmod: toLastmod(row.lastmod),
	}));
}

export async function getSitemapFilters(typeCityMinClinics: number) {
	return {
		cityIds: await getCityIdsWithClinics(),
		clinicTypeIds: await getClinicTypeIds(),
		typeCityCombinations: await getTypeCityCombinations(typeCityMinClinics),
	};
}
