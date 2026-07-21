import type {
	ClinicItemsSummary,
	ClinicItemTopEntry,
	ClinicItemTypeSummary,
} from '~/interfaces/clinic';
import { executeQuery } from '~/server/common/db-mysql';
import { getLocalizedNameField } from '~/server/common/utils';

type CountRow = { count: number };
type CategoryRow = { categoryId: number | null; count: number };

const TOP_LIMIT = 10;

const TOTAL_SQL = {
	services: `
		SELECT COUNT(DISTINCT medical_service_id) AS count
		FROM clinic_medical_services
		WHERE clinic_id = ?
	`,
	labtests: `
		SELECT COUNT(DISTINCT lab_test_id) AS count
		FROM clinic_lab_tests
		WHERE clinic_id = ?
	`,
	medications: `
		SELECT COUNT(DISTINCT medication_id) AS count
		FROM clinic_medications
		WHERE clinic_id = ?
	`,
	doctors: `
		SELECT COUNT(DISTINCT doctor_id) AS count
		FROM doctor_clinics
		WHERE clinic_id = ?
	`,
} as const;

// Per-category breakdown. NB: a service/labtest can belong to multiple
// categories, so summing rows ≠ totalCount. Total is fetched separately.
const CATEGORY_SQL = {
	services: `
		SELECT
			mscr.medical_service_category_id AS categoryId,
			COUNT(DISTINCT cms.medical_service_id) AS count
		FROM clinic_medical_services cms
		LEFT JOIN medical_service_categories_relations mscr
			ON mscr.medical_service_id = cms.medical_service_id
		WHERE cms.clinic_id = ?
		GROUP BY mscr.medical_service_category_id
	`,
	labtests: `
		SELECT
			ltcr.category_id AS categoryId,
			COUNT(DISTINCT clt.lab_test_id) AS count
		FROM clinic_lab_tests clt
		LEFT JOIN lab_test_categories_relations ltcr
			ON ltcr.lab_test_id = clt.lab_test_id
		WHERE clt.clinic_id = ?
		GROUP BY ltcr.category_id
	`,
	doctors: `
		SELECT
			ds.specialty_id AS categoryId,
			COUNT(DISTINCT dc.doctor_id) AS count
		FROM doctor_clinics dc
		LEFT JOIN doctor_specialties ds ON ds.doctor_id = dc.doctor_id
		WHERE dc.clinic_id = ?
		GROUP BY ds.specialty_id
	`,
} as const;

type TopRow = {
	id: number;
	slug: string;
	name: string;
	localName: string | null;
	price: number | null;
	priceMin: number | null;
	priceMax: number | null;
	isOutdated?: number | boolean | null;
	photoUrl?: string | null;
	professionalTitle?: string | null;
	specialtyIds?: string | null;
};

function buildPricedTopSql(options: {
	table: string;
	itemFk: string;
	relationTable: string;
	withPriceMin: boolean;
	// clinic_medications не хранит флаг устаревшей цены (только услуги и анализы)
	withOutdatedFlag: boolean;
	localizedNameField: string;
	orderBy: string;
}) {
	const {
		table,
		itemFk,
		relationTable,
		withPriceMin,
		withOutdatedFlag,
		localizedNameField,
		orderBy,
	} = options;
	return `
		SELECT
			i.id,
			i.slug,
			COALESCE(NULLIF(i.${localizedNameField}, ''), i.name_en) AS name,
			NULLIF(i.name_sr, '') AS localName,
			r.price AS price,
			${withPriceMin ? 'r.price_min' : 'NULL'} AS priceMin,
			r.price_max AS priceMax,
			${withOutdatedFlag ? 'r.is_price_outdated' : 'NULL'} AS isOutdated
		FROM ${relationTable} r
		JOIN ${table} i ON i.id = r.${itemFk}
		WHERE r.clinic_id = ?
		ORDER BY ${orderBy}
		LIMIT ${TOP_LIMIT}
	`;
}

// doctors only has en/ru/sr/sr_cyrl — unlike medical_services/lab_tests/
// medications, there is no name_de / name_tr. Fall back to name_en for
// locales the table doesn't carry.
const DOCTOR_NAME_FIELDS = new Set([
	'name_en',
	'name_ru',
	'name_sr',
	'name_sr_cyrl',
]);

function buildDoctorsTopSql(localizedNameField: string) {
	const field = DOCTOR_NAME_FIELDS.has(localizedNameField)
		? localizedNameField
		: 'name_sr';
	return `
		SELECT
			d.id,
			d.slug,
			COALESCE(NULLIF(d.${field}, ''), d.name_sr, d.name_en) AS name,
			NULLIF(d.name_sr, '') AS localName,
			d.photo_url AS photoUrl,
			d.professional_title AS professionalTitle,
			(SELECT GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id)
				FROM doctor_specialties ds WHERE ds.doctor_id = d.id) AS specialtyIds,
			NULL AS price,
			NULL AS priceMin,
			NULL AS priceMax,
			NULL AS isOutdated
		FROM doctor_clinics dc
		JOIN doctors d ON d.id = dc.doctor_id
		WHERE dc.clinic_id = ?
			AND d.hidden = FALSE
			AND d.is_draft = FALSE
		ORDER BY d.rank_score DESC, d.name_sr ASC
		LIMIT ${TOP_LIMIT}
	`;
}

function mapTopRow(row: TopRow): ClinicItemTopEntry {
	return {
		id: row.id,
		slug: row.slug,
		name: row.name || '',
		localName: row.localName || '',
		price: row.price != null ? Number(row.price) : null,
		priceMin: row.priceMin != null ? Number(row.priceMin) : null,
		priceMax: row.priceMax != null ? Number(row.priceMax) : null,
		isOutdated: row.isOutdated != null ? Boolean(row.isOutdated) : undefined,
		photoUrl: row.photoUrl || undefined,
		professionalTitle: row.professionalTitle || undefined,
		specialtyIds: row.specialtyIds || undefined,
	};
}

async function fetchOne(
	type: keyof typeof TOTAL_SQL,
	clinicId: number,
	localizedNameField: string,
): Promise<ClinicItemTypeSummary> {
	const totalPromise = executeQuery<CountRow>(TOTAL_SQL[type], [clinicId]);
	const categoryPromise =
		type === 'medications'
			? Promise.resolve<CategoryRow[]>([])
			: executeQuery<CategoryRow>(CATEGORY_SQL[type], [clinicId]);

	let topPromise: Promise<TopRow[]>;
	if (type === 'doctors') {
		topPromise = executeQuery<TopRow>(buildDoctorsTopSql(localizedNameField), [
			clinicId,
		]);
	} else if (type === 'services') {
		topPromise = executeQuery<TopRow>(
			buildPricedTopSql({
				table: 'medical_services',
				itemFk: 'medical_service_id',
				relationTable: 'clinic_medical_services',
				withPriceMin: true,
				withOutdatedFlag: true,
				localizedNameField,
				orderBy: 'i.rank_score DESC, i.name_en ASC',
			}),
			[clinicId],
		);
	} else if (type === 'labtests') {
		topPromise = executeQuery<TopRow>(
			buildPricedTopSql({
				table: 'lab_tests',
				itemFk: 'lab_test_id',
				relationTable: 'clinic_lab_tests',
				withPriceMin: false,
				withOutdatedFlag: true,
				localizedNameField,
				orderBy: 'i.rank_score DESC, i.name_en ASC',
			}),
			[clinicId],
		);
	} else {
		// medications: no rank_score column, fall back to alphabetical.
		topPromise = executeQuery<TopRow>(
			buildPricedTopSql({
				table: 'medications',
				itemFk: 'medication_id',
				relationTable: 'clinic_medications',
				withPriceMin: false,
				withOutdatedFlag: false,
				localizedNameField,
				orderBy: 'i.name_en ASC',
			}),
			[clinicId],
		);
	}

	const [totalRows, categoryRows, topRows] = await Promise.all([
		totalPromise,
		categoryPromise,
		topPromise,
	]);
	const totalCount = Number(totalRows[0]?.count) || 0;
	const categories = categoryRows
		.map((r) => ({
			categoryId: r.categoryId,
			count: Number(r.count) || 0,
		}))
		.filter((c) => c.count > 0)
		.sort((a, b) => b.count - a.count);
	const topItems = topRows.map(mapTopRow);
	return { totalCount, categories, topItems };
}

export async function fetchClinicItemsSummary(
	clinicId: number,
	locale: string = 'en',
): Promise<ClinicItemsSummary> {
	const localizedNameField = getLocalizedNameField(locale) || 'name_en';
	const [services, labtests, medications, doctors] = await Promise.all([
		fetchOne('services', clinicId, localizedNameField),
		fetchOne('labtests', clinicId, localizedNameField),
		fetchOne('medications', clinicId, localizedNameField),
		fetchOne('doctors', clinicId, localizedNameField),
	]);
	return { services, labtests, medications, doctors };
}
