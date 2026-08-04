import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';

export interface LabTestDuplicateSide {
	id: number;
	slug: string | null;
	nameEn: string | null;
	nameSr: string | null;
	nameRu: string | null;
	clinicCount: number;
	categoryIds: string | null;
	hasReferenceInfo: boolean;
	synonymCount: number;
	priceFrom: number | null;
	priceTo: number | null;
}

export interface LabTestDuplicateItem {
	id: number;
	tier: 'A' | 'B' | 'C';
	score: number;
	signals: string[];
	detectedAt: string;
	a: LabTestDuplicateSide;
	b: LabTestDuplicateSide;
}

export interface LabTestDuplicateStats {
	pendingA: number;
	pendingB: number;
	pendingC: number;
	dismissed: number;
}

const VALID_TIERS = ['A', 'B', 'C'];
const PAGE_SIZE = 25;

/**
 * Очередь ревью дубликатов анализов.
 * Кандидатов заполняет scripts/labtests/find-duplicate-labtests.mjs —
 * здесь только чтение и обогащение данными, по которым видно,
 * какой из двух анализов оставлять.
 *
 * GET /api/labtests/duplicates/queue?tier=A&page=1
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);

	const query = getQuery(event);
	const tier = VALID_TIERS.includes(String(query.tier))
		? String(query.tier)
		: null;
	const page = Math.max(1, parseInt(String(query.page)) || 1);
	const offset = (page - 1) * PAGE_SIZE;

	const [statsRow] = await executeQuery<any>(`
		SELECT
			SUM(IF(status = 'pending' AND tier = 'A', 1, 0)) AS pendingA,
			SUM(IF(status = 'pending' AND tier = 'B', 1, 0)) AS pendingB,
			SUM(IF(status = 'pending' AND tier = 'C', 1, 0)) AS pendingC,
			SUM(IF(status = 'dismissed', 1, 0)) AS dismissed
		FROM lab_test_duplicate_candidates
	`);

	const stats: LabTestDuplicateStats = {
		pendingA: Number(statsRow?.pendingA || 0),
		pendingB: Number(statsRow?.pendingB || 0),
		pendingC: Number(statsRow?.pendingC || 0),
		dismissed: Number(statsRow?.dismissed || 0),
	};

	const tierFilter = tier ? 'AND c.tier = ?' : '';
	const params = tier ? [tier] : [];

	// Обе стороны пары обогащаем одинаковым набором полей: по ним видно,
	// какая запись «богаче» и должна пережить слияние.
	const sideColumns = (alias: string, prefix: string) => `
		${alias}.id AS ${prefix}Id,
		${alias}.slug AS ${prefix}Slug,
		${alias}.name_en AS ${prefix}NameEn,
		${alias}.name_sr AS ${prefix}NameSr,
		${alias}.name_ru AS ${prefix}NameRu,
		(SELECT COUNT(*) FROM clinic_lab_tests clt WHERE clt.lab_test_id = ${alias}.id) AS ${prefix}ClinicCount,
		(SELECT GROUP_CONCAT(ltcr.category_id ORDER BY ltcr.category_id)
		   FROM lab_test_categories_relations ltcr
		  WHERE ltcr.lab_test_id = ${alias}.id) AS ${prefix}CategoryIds,
		(SELECT COUNT(*) FROM lab_test_reference_info ri WHERE ri.lab_test_id = ${alias}.id) AS ${prefix}RefCount,
		(SELECT COUNT(*) FROM lab_test_synonyms lts WHERE lts.lab_test_id = ${alias}.id) AS ${prefix}SynonymCount,
		(SELECT MIN(clt.price) FROM clinic_lab_tests clt WHERE clt.lab_test_id = ${alias}.id) AS ${prefix}PriceFrom,
		(SELECT MAX(clt.price) FROM clinic_lab_tests clt WHERE clt.lab_test_id = ${alias}.id) AS ${prefix}PriceTo
	`;

	const rows = await executeQuery<any>(
		`SELECT
			c.id, c.tier, c.score, c.signals, c.detected_at AS detectedAt,
			${sideColumns('a', 'a')},
			${sideColumns('b', 'b')}
		FROM lab_test_duplicate_candidates c
		JOIN lab_tests a ON a.id = c.lab_test_id_a
		JOIN lab_tests b ON b.id = c.lab_test_id_b
		WHERE c.status = 'pending' ${tierFilter}
		ORDER BY c.tier ASC, c.score DESC, c.id ASC
		LIMIT ${PAGE_SIZE} OFFSET ${offset}`,
		params,
	);

	const [countRow] = await executeQuery<any>(
		`SELECT COUNT(*) AS total
		 FROM lab_test_duplicate_candidates c
		 WHERE c.status = 'pending' ${tierFilter}`,
		params,
	);

	const toSide = (r: any, p: string): LabTestDuplicateSide => ({
		id: Number(r[`${p}Id`]),
		slug: r[`${p}Slug`],
		nameEn: r[`${p}NameEn`],
		nameSr: r[`${p}NameSr`],
		nameRu: r[`${p}NameRu`],
		clinicCount: Number(r[`${p}ClinicCount`] || 0),
		categoryIds: r[`${p}CategoryIds`],
		hasReferenceInfo: Number(r[`${p}RefCount`] || 0) > 0,
		synonymCount: Number(r[`${p}SynonymCount`] || 0),
		priceFrom: r[`${p}PriceFrom`] == null ? null : Number(r[`${p}PriceFrom`]),
		priceTo: r[`${p}PriceTo`] == null ? null : Number(r[`${p}PriceTo`]),
	});

	return {
		stats,
		items: rows.map(
			(r: any): LabTestDuplicateItem => ({
				id: Number(r.id),
				tier: r.tier,
				score: Number(r.score),
				signals: String(r.signals || '')
					.split(',')
					.filter(Boolean),
				detectedAt: r.detectedAt,
				a: toSide(r, 'a'),
				b: toSide(r, 'b'),
			}),
		),
		pagination: {
			page,
			pageSize: PAGE_SIZE,
			total: Number(countRow?.total || 0),
		},
	};
});
