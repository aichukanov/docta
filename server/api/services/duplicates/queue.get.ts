import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';

export interface DuplicateCandidateSide {
	id: number;
	slug: string | null;
	nameEn: string | null;
	nameSr: string | null;
	nameRu: string | null;
	clinicCount: number;
	categoryIds: string | null;
	hasReferenceInfo: boolean;
	tariffCount: number;
	priceFrom: number | null;
	priceTo: number | null;
}

export interface DuplicateCandidateItem {
	id: number;
	tier: 'A' | 'B' | 'C';
	score: number;
	signals: string[];
	detectedAt: string;
	a: DuplicateCandidateSide;
	b: DuplicateCandidateSide;
}

export interface DuplicateQueueStats {
	pendingA: number;
	pendingB: number;
	pendingC: number;
	dismissed: number;
}

const VALID_TIERS = ['A', 'B', 'C'];
const PAGE_SIZE = 25;

/**
 * Очередь ревью дубликатов услуг.
 * Кандидатов заполняет scripts/services/find-duplicate-services.mjs —
 * здесь только чтение и обогащение данными, по которым видно,
 * какую из двух услуг оставлять.
 *
 * GET /api/services/duplicates/queue?tier=A&page=1
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
		FROM medical_service_duplicate_candidates
	`);

	const stats: DuplicateQueueStats = {
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
		(SELECT COUNT(*) FROM clinic_medical_services cms WHERE cms.medical_service_id = ${alias}.id) AS ${prefix}ClinicCount,
		(SELECT GROUP_CONCAT(mscr.medical_service_category_id ORDER BY mscr.medical_service_category_id)
		   FROM medical_service_categories_relations mscr
		  WHERE mscr.medical_service_id = ${alias}.id) AS ${prefix}CategoryIds,
		(SELECT COUNT(*) FROM medical_service_reference_info ri WHERE ri.medical_service_id = ${alias}.id) AS ${prefix}RefCount,
		(SELECT COUNT(*) FROM medical_service_tariffs t WHERE t.medical_service_id = ${alias}.id) AS ${prefix}TariffCount,
		(SELECT MIN(cms.price) FROM clinic_medical_services cms WHERE cms.medical_service_id = ${alias}.id) AS ${prefix}PriceFrom,
		(SELECT MAX(cms.price) FROM clinic_medical_services cms WHERE cms.medical_service_id = ${alias}.id) AS ${prefix}PriceTo
	`;

	const rows = await executeQuery<any>(
		`SELECT
			c.id, c.tier, c.score, c.signals, c.detected_at AS detectedAt,
			${sideColumns('a', 'a')},
			${sideColumns('b', 'b')}
		FROM medical_service_duplicate_candidates c
		JOIN medical_services a ON a.id = c.service_id_a
		JOIN medical_services b ON b.id = c.service_id_b
		WHERE c.status = 'pending' ${tierFilter}
		ORDER BY c.tier ASC, c.score DESC, c.id ASC
		LIMIT ${PAGE_SIZE} OFFSET ${offset}`,
		params,
	);

	const [countRow] = await executeQuery<any>(
		`SELECT COUNT(*) AS total
		 FROM medical_service_duplicate_candidates c
		 WHERE c.status = 'pending' ${tierFilter}`,
		params,
	);

	const toSide = (r: any, p: string): DuplicateCandidateSide => ({
		id: Number(r[`${p}Id`]),
		slug: r[`${p}Slug`],
		nameEn: r[`${p}NameEn`],
		nameSr: r[`${p}NameSr`],
		nameRu: r[`${p}NameRu`],
		clinicCount: Number(r[`${p}ClinicCount`] || 0),
		categoryIds: r[`${p}CategoryIds`],
		hasReferenceInfo: Number(r[`${p}RefCount`] || 0) > 0,
		tariffCount: Number(r[`${p}TariffCount`] || 0),
		priceFrom: r[`${p}PriceFrom`] == null ? null : Number(r[`${p}PriceFrom`]),
		priceTo: r[`${p}PriceTo`] == null ? null : Number(r[`${p}PriceTo`]),
	});

	return {
		stats,
		items: rows.map(
			(r: any): DuplicateCandidateItem => ({
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
