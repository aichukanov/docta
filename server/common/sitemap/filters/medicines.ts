import { getConnection } from '~/server/common/db-mysql';

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
	// Одиночные ATC-фасеты в sitemap больше не публикуются — их место заняли
	// потребительские категории (sitemap.ts). Комбинации вещество×ATC остаются:
	// это уже проиндексированные и ранжирующиеся URL.
	return {
		substanceAtcCombinations: await getSubstanceAtcCombinations(),
	};
}
