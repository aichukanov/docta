import { getConnection } from '~/server/common/db-mysql';
import { CityId } from '~/enums/cities';

function getEnumValues(enumType: any) {
	return Object.values(enumType).filter(
		(value) => !Number.isNaN(Number(value)),
	);
}

// === Одиночные фильтры ===

export function getCityIds() {
	return getEnumValues(CityId);
}

// === Данные из БД ===

export async function getClinicList() {
	const connection = await getConnection();

	const query = `
		SELECT c.id, c.city_id as cityId
		FROM clinics c
		ORDER BY c.id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ id: number; cityId: number }>;
}

// === Фильтры для Sitemap (только ценные, без thin pages) ===

export async function getSitemapFilters() {
	return {
		// Одиночные — "клиники в Подгорице" — реальный запрос
		cityIds: getCityIds(),
	};
}
