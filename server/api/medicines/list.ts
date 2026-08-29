import { validateBody, validateName } from '~/common/validation';
import { isAtcClassCode } from '~/enums/atc-class';
import { getMedicineCategoryAtcPrefixes } from '~/enums/medicine-category';
import { LIST_PAGE_SIZE } from '~/common/constants';
import {
	normalizeMedicineSort,
	MEDICINE_SORT_NAME_ASC,
	type MedicineSort,
} from '~/common/medicine-sort';
import {
	type Conn,
	localizedField,
	localizedNameSql,
	localizedReferenceSql,
	mapPack,
	nameFieldFor,
	referenceLocaleSuffix,
	withConnection,
} from '~/server/common/medicines/helpers';
import type {
	MedicineList as MedicineListResponse,
	MedicineSubstance,
} from '~/interfaces/medicine';

export default defineEventHandler(
	async (event): Promise<MedicineListResponse> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/medicines/list')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return { items: [], totalCount: 0 };
			}

			return getMedicineList(body);
		} catch (error) {
			console.error('API Error - medicines:', error);
			return { items: [], totalCount: 0 };
		}
	},
);

export async function getMedicineList(
	body: {
		name?: string;
		dispensingModeIds?: number[];
		medicineCategoryIds?: number[];
		atcClassCodes?: string[];
		atcGroupIds?: number[];
		substanceIds?: number[];
		pharmaFormIds?: number[];
		manufacturerIds?: number[];
		activeOnly?: boolean;
		locale?: string;
		page?: number;
		sort?: MedicineSort;
	} = {},
): Promise<MedicineListResponse> {
	const whereFilters: string[] = [];
	const queryParams: Array<number | string> = [];
	const locale = body.locale || 'en';
	const usePagination = body.page != null;
	const pageRaw = Number(body.page);
	const pageSize = LIST_PAGE_SIZE;
	const page = Math.max(Number.isFinite(pageRaw) ? pageRaw : 1, 1);
	const offset = Math.max(Math.trunc((page - 1) * pageSize), 0);

	const buildInPlaceholders = (values: Array<number | string>) => {
		const arr = Array.isArray(values) ? values : [values];
		queryParams.push(...arr);
		return arr.map(() => '?').join(',');
	};

	// Active only (default: true)
	if (body.activeOnly !== false) {
		whereFilters.push('m.is_active = 1');
	}

	// Dispensing mode filter
	if (body.dispensingModeIds?.length) {
		whereFilters.push(
			`m.dispensing_mode_id IN (${buildInPlaceholders(body.dispensingModeIds)})`,
		);
	}

	// Потребительская категория («обезболивающие», «аллергия») — набор префиксов
	// ATC, см. enums/medicine-category.ts. Префиксный LIKE идёт по индексу
	// atc_code; сам префикс в запрос не подставляется как параметр только потому,
	// что он приходит не от пользователя, а из карты по валидированному id.
	if (body.medicineCategoryIds?.length) {
		const prefixes = getMedicineCategoryAtcPrefixes(body.medicineCategoryIds);
		if (prefixes.length) {
			whereFilters.push(
				`(${prefixes.map(() => 'm.atc_code LIKE ?').join(' OR ')})`,
			);
			queryParams.push(...prefixes.map((prefix) => `${prefix}%`));
		} else {
			whereFilters.push('1 = 0');
		}
	}

	// Фармакологический класс (ATC level-2): «все антигистаминные» = R06.
	// Значения сверяются с ATC_CLASS_CODES, поэтому в LIKE идёт заведомо
	// безопасный трёхсимвольный код, а не пользовательская строка.
	if (body.atcClassCodes?.length) {
		const codes = body.atcClassCodes.filter(isAtcClassCode);
		if (codes.length) {
			whereFilters.push(
				`(${codes.map(() => 'm.atc_code LIKE ?').join(' OR ')})`,
			);
			queryParams.push(...codes.map((code) => `${code.toUpperCase()}%`));
		} else {
			whereFilters.push('1 = 0');
		}
	}

	// ATC group filter
	if (body.atcGroupIds?.length) {
		whereFilters.push(
			`m.atc_group_id IN (${buildInPlaceholders(body.atcGroupIds)})`,
		);
	}

	// Substance filter
	if (body.substanceIds?.length) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM med_medicine_substances mms WHERE mms.medicine_id = m.id AND mms.substance_id IN (${buildInPlaceholders(body.substanceIds)}))`,
		);
	}

	// Pharmaceutical form filter
	if (body.pharmaFormIds?.length) {
		whereFilters.push(
			`m.pharmaceutical_form_id IN (${buildInPlaceholders(body.pharmaFormIds)})`,
		);
	}

	// Manufacturer filter
	if (body.manufacturerIds?.length) {
		whereFilters.push(
			`m.manufacturer_id IN (${buildInPlaceholders(body.manufacturerIds)})`,
		);
	}

	// Name search — search in medicine name + substance names across all languages
	if (body.name) {
		if (validateName(body, 'api/medicines/list')) {
			const nameField = nameFieldFor(locale);
			const p = `%${body.name}%`;
			whereFilters.push(`(
				m.name LIKE ? OR
				EXISTS (
					SELECT 1 FROM med_medicine_substances mms
					JOIN med_substances s ON s.id = mms.substance_id
					WHERE mms.medicine_id = m.id AND (
						s.name LIKE ? OR s.name_en LIKE ? OR s.${nameField} LIKE ?
						OR s.name_ru LIKE ? OR s.name_sr LIKE ? OR s.name_sr_cyrl LIKE ?
					)
				)
			)`);
			queryParams.push(p, p, p, p, p, p, p);
		} else {
			// Invalid search term → no matches. Never drop the filter silently:
			// returning the full catalogue reads to the user as "search is broken".
			whereFilters.push('1 = 0');
		}
	}

	const where =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	const pagination = usePagination ? `LIMIT ${pageSize} OFFSET ${offset}` : '';

	// Rank medicines whose total substance count is closest to the number of
	// selected substances first: a single-substance medicine (e.g. pure
	// paracetamol) outranks combination drugs. The target is an integer
	// (array length or 1), safe to inline.
	const orderClauses: string[] = ['m.is_active DESC'];
	// Target: number of substances selected in the filter. When there is no
	// substance filter but a name search (e.g. typing "paracetamol"), target a
	// single substance so the pure drug outranks combinations.
	const substanceCountTarget = body.substanceIds?.length
		? body.substanceIds.length
		: body.name
			? 1
			: null;
	if (substanceCountTarget != null) {
		orderClauses.push(
			`ABS((SELECT COUNT(*) FROM med_medicine_substances mms2 WHERE mms2.medicine_id = m.id) - ${substanceCountTarget}) ASC`,
		);
	}
	const sort = normalizeMedicineSort(body.sort);
	if (sort === MEDICINE_SORT_NAME_ASC) {
		// Явный выбор пользователя. Названия, начинающиеся не с буквы, уходят в
		// конец: в реестре это три фасовки 5-FLUOROURACIL, которые при чистом
		// алфавите открывали каталог.
		orderClauses.push(`(m.name REGEXP '^[^[:alpha:]]') ASC`);
	} else {
		// Дефолт — популярность: цена/рейтинг/близость к реестру неприменимы
		// (лекарства не привязаны к клиникам), а алфавит выводил вперёд
		// онкологию и стационарные препараты. Формула и пересчёт —
		// server/sql/migrations/recalc-med-rank-score.sql.
		orderClauses.push('m.rank_score DESC');
	}
	// Имя и id — стабильный tie-break: без них MySQL волен вернуть строки с
	// одинаковым скором в разном порядке на разных страницах пагинации.
	orderClauses.push('m.name ASC', 'm.id ASC');
	const orderBy = orderClauses.join(', ');

	const nameField = nameFieldFor(locale);

	const countQuery = `
		SELECT COUNT(*) as totalCount FROM med_medicines m ${where};
	`;

	const listQuery = `
		SELECT
			m.id,
			m.slug,
			m.name,
			m.strength,
			m.is_active,
			m.atc_code,
			m.pack_total,
			m.pack_unit,
			m.pack_container_count,
			m.pack_per_container,
			m.pack_volume,
			m.pack_volume_unit,
			m.pack_parse_status,
			(SELECT GROUP_CONCAT(${localizedNameSql('s', nameField)} SEPARATOR ', ')
			 FROM med_medicine_substances mms
			 JOIN med_substances s ON s.id = mms.substance_id
			 WHERE mms.medicine_id = m.id
			) as substances,
			pf.${nameField} as pharmaForm,
			pf.name_en as pharmaFormEn,
			pf.name as pharmaFormSrc,
			pf.id as pharmaFormId,
			mfg.name as manufacturer,
			c.${nameField} as country,
			c.name_en as countryEn,
			m.dispensing_mode_id
		FROM med_medicines m
		LEFT JOIN med_pharma_forms pf ON pf.id = m.pharmaceutical_form_id
		LEFT JOIN med_manufacturers mfg ON mfg.id = m.manufacturer_id
		LEFT JOIN countries c ON c.id = mfg.country_id
		${where}
		ORDER BY ${orderBy}
		${pagination};
	`;

	return withConnection(async (connection) => {
		let totalCount = 0;
		if (usePagination) {
			const [countRows] = await connection.execute(countQuery, queryParams);
			totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
		}

		const [rows] = await connection.execute(listQuery, queryParams);

		const items = (rows as any[]).map((row) => ({
			id: row.id,
			slug: row.slug,
			name: row.name,
			strength: row.strength,
			pharmaForm: localizedField(row, 'pharmaForm'),
			pharmaFormSrc: row.pharmaFormSrc || null,
			pharmaFormId: row.pharmaFormId ?? null,
			manufacturer: row.manufacturer || null,
			country: localizedField(row, 'country'),
			substances: row.substances || null,
			dispensingModeId: row.dispensing_mode_id || null,
			isActive: !!row.is_active,
			atcCode: row.atc_code,
			...mapPack(row),
		}));

		// Фасет одного вещества играет роль страницы вещества (страниц
		// /medicines/substance/[slug] у нас нет, а такие URL уже ранжируются).
		// Поэтому только здесь — полная справка о веществе под списком.
		const substanceReference =
			body.substanceIds?.length === 1
				? await fetchSubstanceReference(
						connection,
						Number(body.substanceIds[0]),
						nameField,
						locale,
					)
				: null;

		return {
			items,
			totalCount: usePagination ? totalCount : items.length,
			...(substanceReference ? { substanceReference } : {}),
		};
	});
}

/** Справка о веществе для фасета `?substanceIds=X` (одна выбранная позиция). */
async function fetchSubstanceReference(
	connection: Conn,
	substanceId: number,
	nameField: string,
	locale?: string,
): Promise<MedicineSubstance | null> {
	if (!Number.isInteger(substanceId)) return null;

	const suffix = referenceLocaleSuffix(locale);
	const [rows] = await connection.execute(
		`
		SELECT s.id, ${localizedNameSql('s', nameField)} as name,
			${localizedReferenceSql('sri', 'what', suffix)} as refWhat,
			${localizedReferenceSql('sri', 'used_for', suffix)} as refUsedFor,
			${localizedReferenceSql('sri', 'caution', suffix)} as refCaution
		FROM med_substances s
		JOIN med_substance_reference_info sri ON sri.substance_id = s.id
		WHERE s.id = ?
	`,
		[substanceId],
	);

	const row = (rows as any[])[0];
	if (!row?.refWhat) return null;

	return {
		id: row.id,
		name: row.name,
		reference: {
			what: row.refWhat || '',
			usedFor: row.refUsedFor || '',
			caution: row.refCaution || '',
		},
	};
}
