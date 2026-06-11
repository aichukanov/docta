import { getConnection } from '~/server/common/db-mysql';
import { CityId } from '~/enums/cities';

function getEnumValues(enumType: Record<string, string | number>): number[] {
	return Object.values(enumType).filter(
		(value): value is number => !Number.isNaN(Number(value)),
	);
}

function getCityIds() {
	return getEnumValues(CityId);
}

export async function getClinicList() {
	const connection = await getConnection();

	const query = `
		SELECT c.id, c.slug, c.city_id as cityId
		FROM clinics c
		ORDER BY c.id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ id: number; slug: string; cityId: number }>;
}

export async function getSitemapFilters() {
	return {
		cityIds: getCityIds(),
	};
}
