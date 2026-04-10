import { getConnection } from '~/server/common/db-mysql';

export async function getAtcGroupIds(): Promise<string[]> {
	const connection = await getConnection();
	const [rows] = await connection.execute<any[]>(
		`SELECT DISTINCT ag.id
		 FROM med_atc_groups ag
		 INNER JOIN med_medicines m ON m.atc_group_id = ag.id AND m.is_active = 1
		 ORDER BY ag.id`,
	);
	await connection.end();
	return rows.map((r) => String(r.id));
}

export async function getSubstanceAtcCombinations(): Promise<
	Array<{ substanceId: string; atcGroupId: string }>
> {
	const connection = await getConnection();
	const [rows] = await connection.execute<any[]>(
		`SELECT DISTINCT mms.substance_id as substanceId, m.atc_group_id as atcGroupId
		 FROM med_medicine_substances mms
		 INNER JOIN med_medicines m ON m.id = mms.medicine_id AND m.is_active = 1
		 WHERE m.atc_group_id IS NOT NULL
		 ORDER BY mms.substance_id, m.atc_group_id`,
	);
	await connection.end();
	return rows.map((r) => ({
		substanceId: String(r.substanceId),
		atcGroupId: String(r.atcGroupId),
	}));
}

export async function getSitemapFilters() {
	return {
		atcGroupIds: await getAtcGroupIds(),
		substanceAtcCombinations: await getSubstanceAtcCombinations(),
	};
}
