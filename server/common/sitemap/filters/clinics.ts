import { getConnection } from '~/server/common/db-mysql';

export async function getClinicList() {
	const connection = await getConnection();

	const query = `
		SELECT c.id, c.slug, c.city_id as cityId
		FROM clinics c
		WHERE c.status = 'published'
		ORDER BY c.id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ id: number; slug: string; cityId: number }>;
}

// Города, в которых реально есть опубликованные клиники — страницы
// `/clinics?cityIds=N` (раньше перебирался весь enum городов, включая пустые)
async function getCityIdsWithClinics() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT c.city_id as cityId
		FROM clinics c
		WHERE c.status = 'published' AND c.city_id IS NOT NULL
		ORDER BY c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (rows as Array<{ cityId: number }>).map((row) => row.cityId);
}

// Типы клиник с хотя бы одной опубликованной клиникой — `/clinics?clinicTypeIds=N`
// («Стоматологические клиники в Черногории»)
async function getClinicTypeIds() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT cct.clinic_type_id as clinicTypeId
		FROM clinic_clinic_types cct
		INNER JOIN clinics c ON cct.clinic_id = c.id
		WHERE c.status = 'published'
		ORDER BY cct.clinic_type_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (rows as Array<{ clinicTypeId: number }>).map(
		(row) => row.clinicTypeId,
	);
}

// Пары (тип клиники, город) с количеством клиник ≥ threshold —
// `/clinics?clinicTypeIds=N&cityIds=M` («Стоматологические клиники в Будве»).
// Ниже порога — thin page, не раздуваем индекс.
async function getTypeCityCombinations(threshold: number) {
	const connection = await getConnection();

	const query = `
		SELECT
			cct.clinic_type_id as clinicTypeId,
			c.city_id as cityId,
			COUNT(DISTINCT c.id) as clinicCount
		FROM clinic_clinic_types cct
		INNER JOIN clinics c ON cct.clinic_id = c.id
		WHERE c.status = 'published' AND c.city_id IS NOT NULL
		GROUP BY cct.clinic_type_id, c.city_id
		HAVING clinicCount >= ?
		ORDER BY cct.clinic_type_id, c.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query, [threshold]);
	await connection.end();

	return rows as Array<{
		clinicTypeId: number;
		cityId: number;
		clinicCount: number;
	}>;
}

export async function getSitemapFilters(typeCityMinClinics: number) {
	return {
		cityIds: await getCityIdsWithClinics(),
		clinicTypeIds: await getClinicTypeIds(),
		typeCityCombinations: await getTypeCityCombinations(typeCityMinClinics),
	};
}
