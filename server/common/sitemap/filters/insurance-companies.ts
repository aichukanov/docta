import { getConnection } from '~/server/common/db-mysql';

export interface InsuranceCompanySitemapItem {
	id: number;
	slug: string;
}

export async function getInsuranceCompanyList(): Promise<
	InsuranceCompanySitemapItem[]
> {
	const connection = await getConnection();
	const [rows] = await connection.execute<any[]>(
		`SELECT id, slug FROM insurance_companies ORDER BY id`,
	);
	await connection.end();
	return rows as InsuranceCompanySitemapItem[];
}
