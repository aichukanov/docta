import { CLINIC_ITEMS_INLINE_THRESHOLD } from '~/common/constants';
import { getConnection } from '~/server/common/db-mysql';

export interface ClinicSubpageSlugs {
	services: string[];
	labtests: string[];
	medications: string[];
	doctors: string[];
}

// Sitemap-eligible clinic subpages: only slugs where the count exceeds the
// inline threshold (small clinics 301-redirect the subpage back to the main
// page anchor, so listing them would pollute the sitemap).
export async function getClinicSubpageSlugs(
	threshold = CLINIC_ITEMS_INLINE_THRESHOLD,
): Promise<ClinicSubpageSlugs> {
	const connection = await getConnection();

	const queries: Record<keyof ClinicSubpageSlugs, string> = {
		services: `
			SELECT c.slug
			FROM clinics c
			JOIN clinic_medical_services cms ON cms.clinic_id = c.id
			WHERE c.status = 'published'
			GROUP BY c.id, c.slug
			HAVING COUNT(DISTINCT cms.medical_service_id) > ?
		`,
		labtests: `
			SELECT c.slug
			FROM clinics c
			JOIN clinic_lab_tests clt ON clt.clinic_id = c.id
			WHERE c.status = 'published'
			GROUP BY c.id, c.slug
			HAVING COUNT(DISTINCT clt.lab_test_id) > ?
		`,
		medications: `
			SELECT c.slug
			FROM clinics c
			JOIN clinic_medications cm ON cm.clinic_id = c.id
			WHERE c.status = 'published'
			GROUP BY c.id, c.slug
			HAVING COUNT(DISTINCT cm.medication_id) > ?
		`,
		doctors: `
			SELECT c.slug
			FROM clinics c
			JOIN doctor_clinics dc ON dc.clinic_id = c.id
			JOIN doctors d ON d.id = dc.doctor_id
				AND d.hidden = FALSE AND d.is_draft = FALSE
			WHERE c.status = 'published'
			GROUP BY c.id, c.slug
			HAVING COUNT(DISTINCT dc.doctor_id) > ?
		`,
	};

	const fetchSlugs = async (sql: string) => {
		const [rows] = await connection.execute<any[]>(sql, [threshold]);
		return (rows as Array<{ slug: string }>).map((r) => r.slug);
	};

	const [services, labtests, medications, doctors] = await Promise.all([
		fetchSlugs(queries.services),
		fetchSlugs(queries.labtests),
		fetchSlugs(queries.medications),
		fetchSlugs(queries.doctors),
	]);

	await connection.end();

	return { services, labtests, medications, doctors };
}
