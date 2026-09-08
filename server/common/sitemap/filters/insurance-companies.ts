import { getConnection } from '~/server/common/db-mysql';
import { lastmodSql, toLastmod } from '~/server/common/sitemap/lastmod';

export interface InsuranceCompanySitemapItem {
	id: number;
	slug: string;
	lastmod?: Date;
}

export async function getInsuranceCompanyList(): Promise<
	InsuranceCompanySitemapItem[]
> {
	const lastmod = await lastmodSql('insurance_companies', 'updated_at');
	const connection = await getConnection();
	const [rows] = await connection.execute<any[]>(
		`SELECT id, slug, ${lastmod} as lastmod FROM insurance_companies ORDER BY id`,
	);
	await connection.end();
	return (rows as Array<{ id: number; slug: string; lastmod: unknown }>).map(
		(row) => ({
			id: row.id,
			slug: row.slug,
			lastmod: toLastmod(row.lastmod),
		}),
	);
}
